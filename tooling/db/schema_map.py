#!/usr/bin/env python3
"""Turn a plain-text, schema-only pg_dump into a markdown "schema map".

The dumps (customers/<CLIENT>/db/postgres_schema.sql) are the source of
truth; this produces the generated half of each db/README.md (counts,
trigger map, unattached trigger functions, views/MVs, table families) and
cross-tenant comparisons, so every client's README has the same shape.

  schema_map.py map  <dump.sql> [--label AEO]        # one client's map
  schema_map.py diff <a.sql> <b.sql>                 # what differs A vs B
  schema_map.py matrix <LABEL=dump.sql> ...          # triggers x clients
  schema_map.py regen                                # rewrite every SCHEMA_MAP.md + the matrix

Tenant table prefixes (aeo_, bd_, trd_...) are normalized to <t>_ before
comparing, so the same platform trigger lines up across clients; function
bodies are compared after whitespace/comment normalization (A/B/C groups =
identical logic within a group).
"""
import argparse
import hashlib
import re
import sys
from collections import Counter, defaultdict

HEADER = re.compile(r"^-- Name: (.+?); Type: (.+?); Schema: (.+?);")
TRIGGER = re.compile(
    r"^CREATE (?:CONSTRAINT )?TRIGGER (\S+) (BEFORE|AFTER|INSTEAD OF) (.+?) ON (\S+)"
    r"(?: FROM \S+)?(?: NOT DEFERRABLE| DEFERRABLE)?(?: INITIALLY \w+)?"
    r"(?: REFERENCING(?: (?:OLD|NEW) TABLE AS \S+)+)?"
    r"(?: FOR EACH (ROW|STATEMENT))?(?: WHEN \((.*)\))? EXECUTE (?:FUNCTION|PROCEDURE) ([^(]+)\("
)
TRIGGER_STATE = re.compile(r"^ALTER TABLE (?:ONLY )?(\S+) (DISABLE|ENABLE ALWAYS|ENABLE REPLICA) TRIGGER (\S+);")
ROUTINE = re.compile(r"^CREATE (?:OR REPLACE )?(FUNCTION|PROCEDURE) ([^(]+)\((.*?)\)(.*)$")
RELATION = re.compile(r"\b(?:FROM|JOIN)\s+\(*\s*([a-z_][a-z0-9_]*\.[a-z_][a-z0-9_]*)")


def load(path):
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read().split("\n")


def tenant_prefix(lines):
    """Most common leading token of public tables (aeo, bd, trd, eve...)."""
    c = Counter()
    for ln in lines:
        m = HEADER.match(ln)
        if m and m.group(2) == "TABLE" and m.group(3) == "public":
            c[m.group(1).split("_", 1)[0]] += 1
    return c.most_common(1)[0][0] if c else ""


def norm_name(name, prefix):
    name = name.replace("public.", "")
    return re.sub(rf"\b{re.escape(prefix)}_", "<t>_", name) if prefix else name


def parse(path):
    lines = load(path)
    d = {
        "path": path,
        "lines": lines,
        "prefix": tenant_prefix(lines),
        "meta": {},
        "objects": [],      # (type, schema, name)
        "triggers": [],     # dicts
        "routines": {},     # qualified name(args) -> dict
        "views": [],        # (kind, qualname, line, base relations)
    }
    for ln in lines[:40]:
        for key, pat in (("env", r"^-- ENV: (.*)"), ("server", r"^-- Dumped from database version (.*)"),
                         ("pg_dump", r"^-- Dumped by pg_dump version (.*)"), ("started", r"^-- Started on (.*)")):
            m = re.match(pat, ln)
            if m and key not in d["meta"]:
                d["meta"][key] = m.group(1).strip()

    states = {}   # (table, trigger) -> (state, line); absent = enabled (origin)
    for k, ln in enumerate(lines):
        st = TRIGGER_STATE.match(ln)
        if st:
            states[(st.group(1), st.group(3))] = (st.group(2), k + 1)

    i, n = 0, len(lines)
    while i < n:
        ln = lines[i]
        m = HEADER.match(ln)
        if m:
            d["objects"].append((m.group(2), m.group(3), m.group(1)))
        t = TRIGGER.match(ln)
        if t:
            d["triggers"].append({
                "name": t.group(1), "timing": t.group(2), "events": t.group(3),
                "table": t.group(4), "level": t.group(5) or "STATEMENT",
                "when": t.group(6) or "", "line": i + 1,
                # unqualified (search_path) calls resolve to public in these dumps
                "func": t.group(7) if "." in t.group(7) else f"public.{t.group(7)}",
                "state": states.get((t.group(4), t.group(1)), ("ENABLED", None)),
            })
        r = ROUTINE.match(ln)
        if r:
            start = i
            j = i + 1
            # block ends at the ALTER ... OWNER line or the next object header
            while j < n and not HEADER.match(lines[j]) and not re.match(r"^ALTER (FUNCTION|PROCEDURE) ", lines[j]):
                j += 1
            body = "\n".join(lines[start:j])
            # hash only up to the closing dollar-quote, so trailing SET lines
            # (present in --no-owner dumps) don't make identical bodies differ
            tag = re.search(r"\$([A-Za-z_]*)\$", body)
            if tag:
                close = body.find(tag.group(0), tag.end())
                if close != -1:
                    body = body[: close + len(tag.group(0))]
            name = r.group(2)
            key = f"{name}({r.group(3)})"
            d["routines"][key] = {
                "kind": r.group(1), "name": name, "args": r.group(3), "line": start + 1,
                "length": j - start, "is_trigger": "RETURNS trigger" in r.group(4),
                "hash": body_hash(body, d["prefix"]),
            }
            i = j
            continue
        v = re.match(r"^CREATE (MATERIALIZED VIEW|VIEW) (\S+) AS", ln)
        if v:
            j, rels = i, set()
            while j < n and not lines[j].rstrip().endswith(";"):
                rels.update(RELATION.findall(lines[j]))
                j += 1
            rels.update(RELATION.findall(lines[j]) if j < n else [])
            d["views"].append((v.group(1), v.group(2), i + 1, sorted(rels)))
            i = j + 1
            continue
        i += 1
    created = sum(1 for ln in lines if re.match(r"^CREATE (?:CONSTRAINT )?TRIGGER ", ln))
    if created != len(d["triggers"]):
        print(f"warning: {path}: {created} CREATE TRIGGER lines but parsed {len(d['triggers'])}; "
              "extend the TRIGGER regex", file=sys.stderr)
    return d


def body_hash(body, prefix):
    body = re.sub(r"--[^\n]*", "", body)
    body = re.sub(r"/\*.*?\*/", "", body, flags=re.S)
    if prefix:
        body = re.sub(rf"\b{re.escape(prefix)}_", "<t>_", body)
    body = re.sub(r"\s+", " ", body).strip().lower()
    return hashlib.sha1(body.encode()).hexdigest()[:10]


def short_events(ev):
    return re.sub(r"\s+", " ", ev).replace("INSERT OR UPDATE", "INS/UPD")


def short_when(w, limit=110):
    w = re.sub(r"\s+", " ", w)
    w = w.replace("(pg_trigger_depth() = 0)", "depth=0").replace("::text", "")
    w = w.replace("::double precision", "")
    return (w[: limit - 1] + "…") if len(w) > limit else w


def routine_line(d, func):
    for r in d["routines"].values():
        if r["name"] == func:
            return r["line"]
    return None


def render_map(d, label):
    out = []
    meta = d["meta"]
    out.append(f"<!-- generated by tooling/db/schema_map.py from {d['path'].split('/')[-1]} — regenerate, don't hand-edit -->")
    out.append(f"## Generated schema map ({label})\n")
    out.append(f"Source: `{d['path']}`  ")
    shown = {"env": meta["env"]} if "env" in meta else meta
    out.append(" · ".join(f"{k}: {v}" for k, v in shown.items()) + "  ")
    out.append(f"Tenant table prefix: `{d['prefix']}_`\n")

    types = Counter(t for t, _, _ in d["objects"])
    keep = ["TABLE", "VIEW", "MATERIALIZED VIEW", "FUNCTION", "PROCEDURE", "TRIGGER", "INDEX", "SEQUENCE", "TYPE"]
    out.append("| Object | Count |\n|---|---|")
    for k in keep:
        if types.get(k):
            out.append(f"| {k.lower()} | {types[k]} |")
    out.append("")

    per_schema = Counter(s for t, s, _ in d["objects"] if t == "TABLE")
    out.append("Tables per schema: " + ", ".join(f"`{s}` {c}" for s, c in sorted(per_schema.items())) + "\n")

    fam = Counter()
    for t, s, nm in d["objects"]:
        if t == "TABLE" and s == "public":
            parts = nm.split("_")
            fam[f"{parts[0]}_{parts[1]}*" if parts[0] == d["prefix"] and len(parts) > 1 else "(platform / other)"] += 1
    out.append("Public table families: " + ", ".join(f"`{k}` {v}" for k, v in fam.most_common()) + "\n")

    by_table = defaultdict(list)
    for t in d["triggers"]:
        by_table[t["table"]].append(t)
    disabled = [t for t in d["triggers"] if t["state"][0] == "DISABLE"]
    out.append(f"### Triggers ({len(d['triggers'])} on {len(by_table)} tables, {len(disabled)} disabled)\n")
    if disabled:
        out.append("**Disabled in this DB — they exist but never fire** (`ALTER TABLE … DISABLE TRIGGER`): "
                   + ", ".join(f"`{t['table'].replace('public.', '')}.{t['name']}` (L{t['state'][1]})" for t in disabled) + "\n")
    out.append("| Table | Trigger | Fires on | WHEN | Function (line) |\n|---|---|---|---|---|")
    for table in sorted(by_table, key=lambda k: (-len(by_table[k]), k)):
        for t in sorted(by_table[table], key=lambda x: x["name"]):
            ln = routine_line(d, t["func"])
            fn = t["func"].replace("public.", "") + "()" + (f" L{ln}" if ln else "")
            ev = f"{t['timing']} {short_events(t['events'])}" + (" (stmt)" if t["level"] == "STATEMENT" else "")
            if t["state"][0] != "ENABLED":
                ev = f"**{t['state'][0]}D** · {ev}" if t["state"][0] == "DISABLE" else f"**{t['state'][0]}** · {ev}"
            out.append(f"| `{table.replace('public.', '')}` | `{t['name']}` | {ev} | {short_when(t['when']) or '—'} | `{fn}` |")
    out.append("")

    attached = {t["func"] for t in d["triggers"]}
    orphans = sorted(r["name"].replace("public.", "") for r in d["routines"].values()
                     if r["is_trigger"] and r["name"] not in attached)
    if orphans:
        out.append("Unattached trigger functions (dead code, or attached by hand in other envs): "
                   + ", ".join(f"`{o}`" for o in orphans) + "\n")

    big = sorted((r for r in d["routines"].values() if r["length"] >= 150), key=lambda r: -r["length"])
    if big:
        out.append("Large routines (≥150 lines): " + ", ".join(
            f"`{r['name'].replace('public.', '')}` ({r['kind'].lower()}, L{r['line']}, ~{r['length']} lines)" for r in big) + "\n")

    if d["views"]:
        out.append("### Views and materialized views\n")
        out.append("| Kind | Name (line) | Reads from |\n|---|---|---|")
        for kind, name, line, rels in d["views"]:
            out.append(f"| {'MV' if kind.startswith('MAT') else 'view'} | `{name}` L{line} | {', '.join(f'`{r}`' for r in rels) or '—'} |")
        out.append("")
    return "\n".join(out)


def table_set(d):
    return {f"{s}.{norm_name(nm, d['prefix'])}" for t, s, nm in d["objects"] if t == "TABLE"}


def render_diff(a, b, la, lb):
    out = [f"## {la} vs {lb}\n"]
    ta, tb = table_set(a), table_set(b)
    for title, items in ((f"Tables only in {la}", ta - tb), (f"Tables only in {lb}", tb - ta)):
        out.append(f"**{title}** ({len(items)}): " + (", ".join(f"`{x}`" for x in sorted(items)) or "none") + "\n")

    def trig_keys(d):
        return {(norm_name(t["table"], d["prefix"]), t["name"]): t for t in d["triggers"]}
    ka, kb = trig_keys(a), trig_keys(b)
    for title, items in ((f"Triggers only in {la}", ka.keys() - kb.keys()), (f"Triggers only in {lb}", kb.keys() - ka.keys())):
        out.append(f"**{title}** ({len(items)}): " + (", ".join(f"`{t}.{n}`" for t, n in sorted(items)) or "none") + "\n")
    changed = [k for k in ka.keys() & kb.keys()
               if (short_events(ka[k]["events"]), ka[k]["when"].replace(a["prefix"] + "_", "<t>_")) !=
                  (short_events(kb[k]["events"]), kb[k]["when"].replace(b["prefix"] + "_", "<t>_"))]
    state_diff = sorted(k for k in ka.keys() & kb.keys() if ka[k]["state"][0] != kb[k]["state"][0])
    out.append(f"**Triggers enabled in one, disabled in the other** ({len(state_diff)}): "
               + (", ".join(f"`{t}.{n}` ({la} {ka[(t, n)]['state'][0].lower()}, {lb} {kb[(t, n)]['state'][0].lower()})"
                            for t, n in state_diff) or "none") + "\n")
    out.append(f"**Triggers with different events/WHEN** ({len(changed)}): "
               + (", ".join(f"`{t}.{n}`" for t, n in sorted(changed)) or "none") + "\n")

    ra = {norm_name(k, a["prefix"]): r for k, r in a["routines"].items()}
    rb = {norm_name(k, b["prefix"]): r for k, r in b["routines"].items()}
    for title, items in ((f"Routines only in {la}", ra.keys() - rb.keys()), (f"Routines only in {lb}", rb.keys() - ra.keys())):
        out.append(f"**{title}** ({len(items)}): " + (", ".join(f"`{x.split('(')[0]}`" for x in sorted(items)) or "none") + "\n")
    diff_body = sorted(k for k in ra.keys() & rb.keys() if ra[k]["hash"] != rb[k]["hash"])
    out.append(f"**Routines whose body differs** ({len(diff_body)}): "
               + (", ".join(f"`{k.split('(')[0]}` ({la} L{ra[k]['line']} / {lb} L{rb[k]['line']})" for k in diff_body) or "none") + "\n")
    return "\n".join(out)


def render_matrix(dumps):
    labels = [l for l, _ in dumps]
    rows = defaultdict(dict)   # (table, trigger) -> label -> (func, hash)
    for label, d in dumps:
        hashes = {r["name"]: r["hash"] for r in d["routines"].values()}
        for t in d["triggers"]:
            key = (norm_name(t["table"], d["prefix"]), t["name"])
            # behaviour = events + WHEN guard + function body, all prefix-normalized
            guard = norm_name(re.sub(r"\s+", " ", f"{t['timing']} {t['events']} {t['level']} {t['when']}"), d["prefix"])
            sig = hashlib.sha1(f"{guard}|{hashes.get(t['func'], '?')}".encode()).hexdigest()[:10]
            rows[key][label] = (t["func"].replace("public.", ""), sig, t["state"][0] == "DISABLE")
    out = ["| Table | Trigger | Function | " + " | ".join(labels) + " |",
           "|---|---|---|" + "---|" * len(labels)]
    for key in sorted(rows, key=lambda k: (-len(rows[k]), k)):
        cells = rows[key]
        letters, groups = {}, []
        for l in labels:
            if l in cells:
                h = cells[l][1]
                if h not in letters:
                    letters[h] = chr(ord("A") + len(letters))
                groups.append(letters[h] + (" off" if cells[l][2] else ""))
            else:
                groups.append("·")
        func = next(iter(cells.values()))[0]
        out.append(f"| `{key[0]}` | `{key[1]}` | `{func}` | " + " | ".join(groups) + " |")
    return "\n".join(out)


# Sibling tenants: customers/<C>/db/<sub>/postgres_schema.sql is diffed against
# the client's own db/postgres_schema.sql, or against REFERENCE[<C>] when the
# client has no top-level dump (KW = 4 brands, ann is the best-documented one).
REFERENCE = {"KW": "ann"}
MATRIX_OUT = "knowledge/db-trigger-matrix.md"


def discover(root="customers"):
    import glob
    import os
    found = []
    paths = glob.glob(f"{root}/*/db/postgres_schema.sql") + glob.glob(f"{root}/*/db/*/postgres_schema.sql")
    # client's own dump first, then its sibling tenants/brands
    for path in sorted(paths, key=lambda p: (p.split(os.sep)[1], p.count(os.sep), p)):
        parts = path.split(os.sep)
        client = parts[1]
        sub = parts[3] if len(parts) == 5 else None
        found.append((f"{client}/{sub}" if sub else client, client, sub, path))
    return found


def regen():
    import os
    dumps = discover()
    parsed = {label: parse(path) for label, _, _, path in dumps}
    for label, client, sub, path in dumps:
        text = render_map(parsed[label], label)
        if sub:
            ref = client if client in parsed else (f"{client}/{REFERENCE[client]}" if client in REFERENCE else None)
            if ref and ref != label and ref in parsed:
                text += "\n\n" + render_diff(parsed[ref], parsed[label], ref, label).replace("## ", "## Diff: ", 1)
        out = os.path.join(os.path.dirname(path), "SCHEMA_MAP.md")
        with open(out, "w") as fh:
            fh.write(text + "\n")
        print(f"wrote {out}")
    with open(MATRIX_OUT, "w") as fh:
        fh.write("<!-- generated by `python3 tooling/db/schema_map.py regen` — regenerate, don't hand-edit -->\n")
        fh.write("# Postgres trigger matrix — every client (QA dumps)\n\n")
        fh.write("Which PG triggers exist at which client, and whether their logic is the same.\n"
                 "Rows = (table, trigger) with the tenant prefix normalized to `<t>_`. Cells: same letter in a\n"
                 "row = **identical behaviour**: same events, same WHEN guard and same function body\n"
                 "(whitespace/comments/tenant prefix ignored). A different letter means the trigger or its\n"
                 "function differs, so diff both before porting a fix. `·` = trigger absent.\n"
                 "**`off`** = the trigger exists but is DISABLED in that DB (`ALTER TABLE … DISABLE TRIGGER`), so it\n"
                 "never fires there. Check this before blaming a trigger.\n"
                 "Sources: `customers/*/db/**/postgres_schema.sql`; per-client detail in each `db/SCHEMA_MAP.md`.\n\n")
        def when(m):
            hit = re.search(r"dumped: ([0-9-]+)", m.get("env", ""))
            return hit.group(1) if hit else m.get("started", "?")[:10]
        fh.write("Snapshots (all QA unless noted in the dump header): "
                 + ", ".join(f"{l} {when(parsed[l]['meta'])}" for l, _, _, _ in dumps) + "\n\n")
        fh.write(render_matrix([(l, parsed[l]) for l, _, _, _ in dumps]) + "\n")
    print(f"wrote {MATRIX_OUT}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    m = sub.add_parser("map"); m.add_argument("dump"); m.add_argument("--label", default="")
    df = sub.add_parser("diff"); df.add_argument("a"); df.add_argument("b")
    df.add_argument("--labels", nargs=2, default=None)
    mx = sub.add_parser("matrix"); mx.add_argument("pairs", nargs="+", help="LABEL=path")
    sub.add_parser("regen", help="rewrite every customers/*/db/**/SCHEMA_MAP.md and the trigger matrix")
    args = ap.parse_args()

    if args.cmd == "map":
        print(render_map(parse(args.dump), args.label or args.dump))
    elif args.cmd == "diff":
        la, lb = args.labels or (args.a, args.b)
        print(render_diff(parse(args.a), parse(args.b), la, lb))
    elif args.cmd == "regen":
        regen()
    else:
        dumps = []
        for p in args.pairs:
            label, path = p.split("=", 1)
            dumps.append((label, parse(path)))
        print(render_matrix(dumps))


if __name__ == "__main__":
    sys.exit(main())
