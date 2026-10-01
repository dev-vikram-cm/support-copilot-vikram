#!/usr/bin/env python3
"""
Headless composer — the command-line equivalent of the Data Validation Studio.

Compose a ClickHouse validation query for a pivot with a chosen SCOPE, TIME
window, FILTERS and METRIC subset — deterministically — and optionally run it
against a read-only ClickHouse and diff against the UI value. Reuses the exact
same engine as the UI (compose + members + compare), so CLI and UI never drift.

Everything is read-only: time/scope resolution and any execution pass through
the shared read-only guard.

Examples
--------
# list the metrics a pivot exposes (so you know what to pass to --metrics)
python3 compose_query.py --config-dir /path/trd-configs --pivot HistoryFit --list-metrics

# explicit weeks, all metrics (no DB needed)
python3 compose_query.py --config-dir /path/trd-configs --pivot HistoryFit \
    --time-kind weeks --time-values 2025_W26,2025_W27

# metric subset + department scope + a quarter (needs VPN to resolve/expand)
python3 compose_query.py --config-dir /path/trd-configs --pivot HistoryFit \
    --metrics eoh_u,dmd_u --department DP-48 --time-kind quarter --time-values FY28_Q4

# floorset selling window, then run on ClickHouse and compare to UI numbers
python3 compose_query.py --config-dir /path/trd-configs --pivot HistoryFit \
    --time-kind floorset --time-values 0526_Spr_4_125 --dept DP-125 \
    --execute --dsn http://ro:pass@ch-host:8123 --expected '{"dmd_u":84213}'
"""
import argparse, json, sys
from pathlib import Path
from urllib.parse import quote

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "db"))
import compose as composer
import pivot_contract
import config_sync as cfgsync              # repo vs live-QA (OCI overlay) config sources
try:
    import members as members_mod          # live time/scope resolution (needs DB+VPN)
except Exception:
    members_mod = None


def _csv(s):
    return [x.strip() for x in (s or "").split(",") if x.strip()]


def list_metrics(config_dir, pivot):
    cpath, note = composer.resolve_pivot(pivot, config_dir)
    if not cpath:
        print(f"ERROR: {note}", file=sys.stderr); sys.exit(2)
    c = pivot_contract.extract(cpath)
    maggs = c.get("metric_aggs", {})
    if not maggs:
        print("(no classified metrics on this pivot)"); return
    print(f"# {pivot} — {len(maggs)} metrics (pass any subset to --metrics):")
    for m in sorted(maggs):
        print(f"  {m:<12} {maggs[m].get('family','?')}")


def assemble(client, a):
    """Build the compose filters dict from CLI options, resolving time and
    expanding department/channel scope via the read-only DB when reachable."""
    filters = {"cluster": _csv(a.cluster), "department": _csv(a.department),
               "channel": _csv(a.channel), "prodlife": _csv(a.prodlife),
               "flowStatus": a.flow_status or "", "metrics": _csv(a.metrics),
               "weeks": _csv(a.weeks)}
    notes = []
    # --- time selection -> concrete weeks ---
    if a.time_kind:
        if members_mod:
            try:
                r = members_mod.resolve_time(client, a.time_kind, _csv(a.time_values),
                                             window=a.window, dept=a.dept)
                if r["weeks"]:
                    filters["weeks"] = r["weeks"]; filters["time_note"] = r["note"]
                    notes.append(r["note"])
                else:
                    notes.append(f"time '{a.time_kind}' resolved to 0 weeks")
            except Exception as e:
                notes.append(f"time resolve failed ({e}) — need VPN/DB")
        elif a.time_kind == "weeks":
            filters["weeks"] = _csv(a.time_values) or filters["weeks"]
        else:
            notes.append("members provider unavailable — pass --time-kind weeks --time-values …")
    # --- scope expansion (dept -> stylecolors, channel -> stores) ---
    if members_mod:
        try:
            if filters["department"]:
                r = members_mod.expand(client, "department", filters["department"])
                if r["ids"]:
                    filters["product"] = r["ids"]; notes.append(f"department→{len(r['ids'])} stylecolors")
            if filters["channel"]:
                r = members_mod.expand(client, "channel", filters["channel"])
                if r["ids"]:
                    filters["location"] = (filters.get("location") or []) + r["ids"]
                    notes.append(f"channel→{len(r['ids'])} stores")
        except Exception as e:
            notes.append(f"scope expand failed ({e}) — dept/channel left as TODO")
    return filters, notes


def main():
    ap = argparse.ArgumentParser(description="Headless SQL composer (CLI Studio).")
    ap.add_argument("--client", default="TRD")
    ap.add_argument("--config-dir", required=True, help="path to trd-configs (the repo base)")
    ap.add_argument("--source", default="repo",
                    help="config source: repo (use --config-dir as-is) | qa|staging|prod (OCI-overlaid effective dir)")
    ap.add_argument("--sync", action="store_true",
                    help="with --source <env>: sync it (git + oci overlay) before composing")
    src = ap.add_mutually_exclusive_group()
    src.add_argument("--pivot", help="pivot/model defnId (composes a listData URL)")
    src.add_argument("--url", help="a raw pivot3 listData URL")
    src.add_argument("--app-url", dest="app_url",
                     help="an S5 app screen URL (#/… route) — resolved to its pivot via the confdefn")
    ap.add_argument("--grain", default="stylecolor")
    ap.add_argument("--criteria", choices=["hist", "flow"], default="hist")
    ap.add_argument("--catalog", default=None, help="catalog.db (default <cfg>/lineage/catalog.db)")
    ap.add_argument("--top-members", default="")
    # metric picker
    ap.add_argument("--metrics", help="comma subset of metrics (default: all on the pivot)")
    ap.add_argument("--list-metrics", action="store_true", help="print the pivot's metrics and exit")
    # time
    ap.add_argument("--time-kind", choices=["weeks", "range", "month", "quarter", "season", "year", "floorset"])
    ap.add_argument("--time-values", help="members for --time-kind (range = start,end)")
    ap.add_argument("--window", choices=["sales", "receipt", "life"], help="floorset window")
    ap.add_argument("--dept", help="floorset dept (e.g. DP-48) to disambiguate")
    ap.add_argument("--weeks", help="explicit weeks (alternative to --time-kind weeks)")
    # filters / scope
    ap.add_argument("--department", help="comma departments (product scope)")
    ap.add_argument("--channel", help="comma channels (location scope)")
    ap.add_argument("--cluster", help="comma clusters/grades")
    ap.add_argument("--prodlife", help="comma prodlife codes (FP,MD,OOL)")
    ap.add_argument("--flow-status", dest="flow_status", help="flowStatus (documented caveat)")
    # execute
    ap.add_argument("--execute", action="store_true", help="run on ClickHouse and compare")
    ap.add_argument("--dsn", help="read-only ClickHouse DSN for --execute")
    ap.add_argument("--expected", default="{}", help="JSON of UI values to compare")
    ap.add_argument("--max-rows", type=int, default=200000)
    a = ap.parse_args()

    # resolve the config source → the config dir everything reads from
    config_dir = a.config_dir
    if a.source and a.source != "repo":
        if a.sync:
            res = cfgsync.sync_env(a.client, a.source)
            if not res.get("ok"):
                ap.error(f"sync '{a.source}' failed: {res.get('hint') or res.get('results')}")
            print(f"-- synced {a.source}: {res.get('effective')}", file=sys.stderr)
        d = cfgsync.effective_dir(a.client, a.source)
        if not d:
            ap.error(f"source '{a.source}' not synced — run: "
                     f"python3 config_sync.py --client {a.client} --sync-env {a.source}  (or add --sync)")
        config_dir = str(d)
        print(f"-- config source: {a.source} → {config_dir}", file=sys.stderr)

    if a.list_metrics:
        if not a.pivot:
            ap.error("--list-metrics needs --pivot")
        list_metrics(config_dir, a.pivot)
        return

    pivot_id = a.pivot
    if a.app_url:
        import route_resolver as rr
        cat0 = a.catalog or (Path(config_dir) / "lineage" / "catalog.db")
        res = rr.resolve_url(config_dir, a.app_url, str(cat0) if Path(cat0).exists() else None)
        pivot_id = res.get("pivot") or res.get("model")
        for w in res.get("warnings", []):
            print(f"-- url: {w}", file=sys.stderr)
        if not pivot_id:
            ap.error(f"could not resolve --app-url to a pivot ({'; '.join(res.get('warnings') or [])})")
        print(f"-- url → {res.get('tab')} / {(res.get('catalog_match') or {}).get('screen','?')} "
              f"/ pivot {pivot_id}", file=sys.stderr)

    if a.url:
        url = a.url
    elif pivot_id:
        url = (f"api/pivot3/listData?aggBy=level:{quote(a.grain)}&appName=Assortment"
               f"&defnId={quote(pivot_id)}&flowStatus={quote(a.flow_status or '')}")
        if a.top_members:
            url += f"&topMembers={quote(a.top_members)}"
    else:
        ap.error("give --pivot, --url or --app-url")

    filters, notes = assemble(a.client, a)
    for n in notes:
        print(f"-- resolve: {n}", file=sys.stderr)

    catalog = a.catalog or (Path(config_dir) / "lineage" / "catalog.db")
    catalog = str(catalog) if Path(catalog).exists() else None
    sql = composer.compose(url, config_dir, a.criteria, catalog, filters=filters)
    print(sql)

    if a.execute:
        if not a.dsn:
            ap.error("--execute needs --dsn (a read-only ClickHouse DSN)")
        weeks = filters.get("weeks") or []
        if not weeks:
            ap.error("--execute needs a resolved time selection (--time-kind/--weeks)")
        import compare as cmpmod
        info = cmpmod.chv.probe_version(a.dsn)
        if not info.get("version"):
            print(f"CH UNREACHABLE: {info.get('version_error')}", file=sys.stderr); sys.exit(2)
        header, rows = cmpmod.run(sql, a.dsn, weeks, a.max_rows)
        summary = cmpmod.summarize(header, rows)
        print(f"\n-- CH {info['version']} · {len(weeks)} weeks · DB summary:", file=sys.stderr)
        print(json.dumps(summary, indent=1))
        exp = json.loads(a.expected or "{}")
        if exp:
            ok, det = cmpmod.compare(summary, exp)
            for k, uiv, dbv, verdict in det:
                print(f"-- {k}: UI={uiv} DB={dbv} {verdict}", file=sys.stderr)
            print(f"-- RESULT: {'✓ ALL MATCH' if ok else '✗ MISMATCH'}", file=sys.stderr)
            sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
