#!/usr/bin/env python3
"""
Runtime members provider — pull the scope/filter values (departments, classes,
locations, clusters, weeks, floorsets, flow statuses) LIVE from the read-only DB
so the composer UI can populate real pickers like the S5 app.

Reuses the existing read-only SSH connection (customers/<CID>/db/connections.json
+ tooling/db/mcp_server.py) — no new creds, read-only SELECTs only. Results are
cached (default 12h) so the UI is fast; `--refresh` / ?refresh=1 re-queries.

Requires: the real s5_copilot_ro password filled in connections.json + VPN.

CLI:
  python3 members.py --client TRD --list-levels          # discover levelid values
  python3 members.py --client TRD --kind department      # pull one kind
  python3 members.py --client TRD --kind week --refresh
API (imported by the Studio server): get_members(client, kind, refresh=False)
"""
import argparse, json, re, sys, time
from pathlib import Path

HERE = Path(__file__).resolve().parent
HUB = HERE.parent.parent
sys.path.insert(0, str(HUB / "tooling" / "db"))
import mcp_server as db          # tool_query({client,env,engine,sql,max_rows}) -> TSV text

QUERIES = json.loads((HERE / "members_queries.json").read_text())
CACHE_DIR = HERE / ".members_cache"
CACHE_TTL = 12 * 3600


def _parse_tsv(text):
    """psql/vsql -A output: header line, rows, trailing '(N rows)'. → [{id,name}]"""
    lines = [l for l in text.splitlines() if l.strip()]
    lines = [l for l in lines if not re.match(r"^\(\d+ rows?\)$", l.strip())]
    if not lines:
        return []
    # psql/vsql -A always prints a header row first → always drop it as the header
    header = lines[0].split("\t"); lines = lines[1:]
    out = []
    for l in lines:
        parts = l.split("\t")
        row = {header[i] if i < len(header) else f"c{i}": parts[i] for i in range(len(parts))}
        # normalize to id/name
        out.append({"id": row.get("id", parts[0]),
                    "name": row.get("name", parts[1] if len(parts) > 1 else parts[0])})
    return out


def _parse_rows(text):
    """Like _parse_tsv but returns full rows keyed by the psql header (no
    id/name normalization) — used by the time resolver for arbitrary columns."""
    lines = [l for l in text.splitlines() if l.strip()]
    lines = [l for l in lines if not re.match(r"^\(\d+ rows?\)$", l.strip())]
    if not lines:
        return []
    header = lines[0].split("\t")
    return [dict(zip(header, l.split("\t"))) for l in lines[1:]]


def _q(v):
    return str(v).replace("'", "''")


def _run(client, engine, sql, env):
    text = db.tool_query({"client": client, "env": env, "engine": engine,
                          "sql": sql, "max_rows": 5000})
    if text.lower().startswith(("error", "no connection")) or "denied" in text.lower():
        raise RuntimeError(text.strip().splitlines()[0])
    return text


def list_levels(client):
    """Probe every dimension's distinct levelids → {dim: [levels]}."""
    cfg = QUERIES.get(client) or {}
    out = {}
    for dim, dconf in (cfg.get("dimensions") or {}).items():
        sql = f"SELECT DISTINCT levelid FROM {dconf['table']} ORDER BY 1"
        try:
            out[dim] = [r["id"] for r in _parse_tsv(_run(client, dconf["engine"], sql, cfg["env"]))]
        except Exception as e:
            out[dim] = [f"<error: {e}>"]
    return out


def _kind_sql(cfg, q):
    dim = cfg["dimensions"][q["dim"]]
    sql = f"SELECT id, name FROM {dim['table']}"
    if q.get("level"):
        sql += f" WHERE levelid='{q['level']}'"
    sql += " ORDER BY name"
    if q.get("limit"):
        sql += f" LIMIT {int(q['limit'])}"
    return dim["engine"], sql


def get_members(client, kind, refresh=False):
    cfg = QUERIES.get(client)
    if not cfg:
        raise RuntimeError(f"no member queries for client {client}")
    # static enums (e.g. flow_status) — no DB
    if kind in (cfg.get("static") or {}):
        return cfg["static"][kind]
    q = (cfg.get("kinds") or {}).get(kind)
    if not q:
        raise RuntimeError(f"unknown kind '{kind}' for {client}")
    cache = CACHE_DIR / f"{client}_{kind}.json"
    if not refresh and cache.exists() and (time.time() - cache.stat().st_mtime) < CACHE_TTL:
        return json.loads(cache.read_text())
    engine, sql = _kind_sql(cfg, q)
    rows = _parse_tsv(_run(client, engine, sql, cfg["env"]))
    CACHE_DIR.mkdir(exist_ok=True)
    cache.write_text(json.dumps(rows))
    return rows


def expand(client, scope, ids):
    """Expand scope members (e.g. a department, a channel) to the agg-table grain
    ids (stylecolors, stores) via the PG ancestor closure tables.
    Returns {'target': 'product'|'location', 'ids': [...]}."""
    cfg = QUERIES.get(client) or {}
    e = (cfg.get("expansions") or {}).get(scope)
    ids = [i for i in ids if str(i).strip()]
    if not e or not ids:
        return {"target": None, "ids": []}
    inlist = ", ".join("'" + str(i).replace("'", "''") + "'" for i in ids)
    sql = (f"SELECT DISTINCT {e['leaf_col']} FROM {e['table']} "
           f"WHERE {e['scope_col']} IN ({inlist})")
    rows = _parse_tsv(_run(client, e["engine"], sql, cfg["env"]))
    return {"target": e["target"], "ids": [r["id"] for r in rows]}


def resolve_time(client, kind, values, window=None, dept=None):
    """Resolve a time selection to a concrete list of WEEK ids (the agg `time`
    grain), read-only against PG. `time` is treated as an opaque ordered String;
    ordering is always by `indx` so it is format-agnostic (calendar & fiscal).

    kind:
      weeks    values=[week ids]                 -> passthrough
      range    values=[start_week, end_week]     -> indx BETWEEN (inclusive)
      month|quarter|season|year  values=[member] -> trd_h_timestd ancestor match
      floorset values=[floorset ids]             -> trd_ma_dptflrsetattributes
                                                     window (sales|receipt|life)
    Returns {'weeks': [...], 'note': '...'}.
    """
    cfg = QUERIES.get(client) or {}
    env = cfg.get("env")
    tc = cfg.get("time") or {}
    dim = tc.get("dim_table", "trd_d_time")
    wk = tc.get("week_level", "week")
    values = [str(v).strip() for v in (values or []) if str(v).strip()]
    if not values:
        return {"weeks": [], "note": "no time members selected"}

    def _weeks_between(a, b):
        sql = (f"SELECT id FROM {dim} WHERE levelid='{wk}' AND indx BETWEEN "
               f"(SELECT indx FROM {dim} WHERE id='{_q(a)}' AND levelid='{wk}') AND "
               f"(SELECT indx FROM {dim} WHERE id='{_q(b)}' AND levelid='{wk}') "
               f"ORDER BY indx")
        return [r["id"] for r in _parse_tsv(_run(client, "postgres", sql, env))]

    if kind == "weeks":
        return {"weeks": values, "note": f"{len(values)} explicit weeks"}

    if kind == "range":
        if len(values) != 2:
            raise RuntimeError("range needs exactly [start_week, end_week]")
        w = _weeks_between(values[0], values[1])
        return {"weeks": w, "note": f"range {values[0]}..{values[1]} → {len(w)} weeks"}

    if kind in ("month", "quarter", "season", "year"):
        hier = tc["calendar_hier"]
        ancs = tc["calendar_ancestors"]
        inlist = ", ".join(f"'{_q(v)}'" for v in values)
        cond = " OR ".join(f"h.{a} IN ({inlist})" for a in ancs)
        sql = (f"SELECT t.id FROM {hier} h JOIN {dim} t ON t.id=h.id "
               f"WHERE t.levelid='{wk}' AND ({cond}) ORDER BY t.indx")
        w = [r["id"] for r in _parse_tsv(_run(client, "postgres", sql, env))]
        return {"weeks": w, "note": f"{kind} {values} → {len(w)} weeks"}

    if kind == "floorset":
        fa = tc["floorset_attr_table"]
        keyc, deptc = tc["floorset_key_col"], tc["floorset_dept_col"]
        wname = window or tc.get("floorset_default_window", "sales")
        s_col, e_col = tc["floorset_windows"][wname]
        allw, notes = [], []
        for fs in values:
            cond = f"{keyc}='{_q(fs)}'"
            if dept:
                cond += f" AND {deptc}='{_q(dept)}'"
            sql = f"SELECT {s_col} AS s, {e_col} AS e FROM {fa} WHERE {cond} LIMIT 1"
            rows = _parse_rows(_run(client, "postgres", sql, env))
            if rows and rows[0].get("s") and rows[0].get("e"):
                s, e = rows[0]["s"], rows[0]["e"]
                w = _weeks_between(s, e)
                allw += w
                notes.append(f"{fs}[{wname} {s}..{e}]→{len(w)}")
            else:
                notes.append(f"{fs}[no {wname} window]")
        seen = set()
        weeks = [x for x in allw if not (x in seen or seen.add(x))]
        return {"weeks": weeks, "note": "floorset " + "; ".join(notes)}

    raise RuntimeError(f"unknown time kind '{kind}'")


def whoami(client):
    """Report which DB account actually runs our detail/scope queries and
    whether it is read-only. Probes every engine configured for this client's
    env (postgres/vertica/clickhouse). Lets the composer verify it is on the
    read-only account (s5_copilot_ro), not an admin proxy."""
    cfg = QUERIES.get(client) or {}
    env = cfg.get("env", "qa")
    conns = db.connections().get(client, {}).get(env, {}) or {}
    return {"client": client, "env": env,
            "accounts": {eng: db.probe_identity(client, env, eng)
                         for eng in conns}}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--client", default="TRD")
    ap.add_argument("--kind")
    ap.add_argument("--list-levels", action="store_true")
    ap.add_argument("--expand", help="scope kind to expand (department|channel)")
    ap.add_argument("--ids", help="comma member ids to expand")
    ap.add_argument("--whoami", action="store_true",
                    help="report which DB account runs our queries + read-only status")
    ap.add_argument("--resolve-time", dest="rtime",
                    help="time kind to resolve to weeks: weeks|range|month|quarter|season|year|floorset")
    ap.add_argument("--values", help="comma members for --resolve-time (range = start,end)")
    ap.add_argument("--window", help="floorset window: sales|receipt|life (default sales)")
    ap.add_argument("--dept", help="floorset dept (e.g. DP-48) to disambiguate")
    ap.add_argument("--refresh", action="store_true")
    a = ap.parse_args()
    try:
        if a.whoami:
            print(whoami(a.client))
            return
        if a.rtime:
            r = resolve_time(a.client, a.rtime, (a.values or "").split(","),
                             window=a.window, dept=a.dept)
            print(f"{r['note']}")
            print(f"weeks ({len(r['weeks'])}): {r['weeks'][:30]}"
                  + (" …" if len(r['weeks']) > 30 else ""))
            return
        if a.list_levels:
            for dim, levels in list_levels(a.client).items():
                print(f"{dim:9} ({QUERIES[a.client]['dimensions'][dim]['table']}): {', '.join(levels)}")
            return
        if a.expand:
            r = expand(a.client, a.expand, (a.ids or "").split(","))
            print(f"{a.expand} -> {r['target']} ({len(r['ids'])} ids): {r['ids'][:20]}")
            return
        if not a.kind:
            ap.error("give --kind or --list-levels")
        rows = get_members(a.client, a.kind, refresh=a.refresh)
        print(f"{len(rows)} {a.kind} members:")
        for r in rows[:30]:
            print(f"  {r['id']:<14} {r['name']}")
        if len(rows) > 30:
            print(f"  … +{len(rows)-30} more")
    except Exception as e:
        print(f"FAILED: {e}")
        print("  (check: real password in connections.json, on VPN, and levelid values via --list-levels)")
        sys.exit(2)


if __name__ == "__main__":
    main()
