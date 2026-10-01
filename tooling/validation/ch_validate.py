#!/usr/bin/env python3
"""
Validate a composed query with ClickHouse ITSELF — the authoritative dialect +
schema check. Uses the HTTP interface (stdlib only, no deps).

Two modes:
  EXPLAIN SYNTAX (default) — CH parses + reformats the query; errors if it's not
     valid CH / schema-correct. Returns NO data — safe, cheap, read-only.
  --run                    — run the query with a small LIMIT and return rows,
     to compare values against the UI.

The composed SQL has placeholders (e.g. :HISTORY_WEEKS). Supply them with
--params so the query is concrete before validation.

Runs against the customer's ClickHouse — use LOCALLY where you have read-only
access; it does not run inside Cowork (no DB reachability there).

Every call first probes `SELECT version()` + a capability self-test (argMax,
argMin, uniqExact, count-distinct) so you KNOW those constructs work on that
exact server — most of the fleet is ClickHouse 21.4. EXPLAIN SYNTAX falls back
to LIMIT 0 if a server rejects it.

Usage:
  python3 ch_validate.py --dsn http://user:pass@ch-host:8123 --probe   # version + caps only
  python3 ch_validate.py --file q.sql --dsn http://user:pass@ch-host:8123 \
      --params '{"HISTORY_WEEKS": "'\''202544'\'','\''202545'\''"}'
  python3 ch_validate.py --file q.sql --dsn ... --run --limit 20
  python3 ch_validate.py --file q.sql --dsn ... --expect-version 21.4
"""
import argparse, json, sys, urllib.request, urllib.parse
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "db"))
from readonly_guard import check_sql, SqlNotAllowed   # single read-only gate


def substitute(sql, params):
    for k, v in (params or {}).items():
        sql = sql.replace(f":{k}", str(v))
    return sql


def strip_comments(sql):
    return "\n".join(l for l in sql.splitlines()
                     if not l.strip().startswith("--")).strip().rstrip(";")


def ch_post(dsn, query, timeout=30):
    # dsn like http://user:pass@host:8123 ; CH http takes the SQL as the body.
    # EVERY statement sent to ClickHouse passes the read-only gate first — this
    # is the single choke point for the CH HTTP path (probes, EXPLAIN, runs).
    check_sql(query)
    data = query.encode("utf-8")
    req = urllib.request.Request(dsn, data=data, method="POST")
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return r.read().decode("utf-8", "replace")


# constructs the composer relies on — probed against the real server so we KNOW
# they work on that version (most of the fleet is 21.4).
CAPABILITY_PROBES = {
    "argMax":    "SELECT argMax(number, number) FROM numbers(3)",
    "argMin":    "SELECT argMin(number, number) FROM numbers(3)",
    "uniqExact": "SELECT uniqExact(number) FROM numbers(3)",
    "count_distinct": "SELECT count(DISTINCT number) FROM numbers(3)",
}


def probe_version(dsn):
    """Return (version_str, {capability: ok_bool}). Never raises — reports."""
    info = {"version": None, "capabilities": {}}
    try:
        info["version"] = ch_post(dsn, "SELECT version()").strip()
    except Exception as e:
        info["version_error"] = str(e); return info
    for name, q in CAPABILITY_PROBES.items():
        try:
            ch_post(dsn, q); info["capabilities"][name] = True
        except Exception:
            info["capabilities"][name] = False
    return info


def explain_or_fallback(dsn, sql):
    """Prefer EXPLAIN SYNTAX (valid on 21.4); if the server rejects it, fall
    back to LIMIT 0 (valid on every version)."""
    try:
        return "EXPLAIN SYNTAX", ch_post(dsn, f"EXPLAIN SYNTAX {sql}")
    except Exception:
        return "LIMIT 0 (EXPLAIN SYNTAX unsupported)", ch_post(dsn, f"{sql}\nLIMIT 0")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file")
    ap.add_argument("--stdin", action="store_true")
    ap.add_argument("--dsn", required=True, help="http://[user:pass@]host:8123")
    ap.add_argument("--params", default="{}", help="JSON of placeholder -> value")
    ap.add_argument("--run", action="store_true", help="execute (LIMIT) instead of validating")
    ap.add_argument("--limit", type=int, default=20)
    ap.add_argument("--probe", action="store_true", help="only report version() + capabilities")
    ap.add_argument("--expect-version", default="21.4",
                    help="warn if the server major.minor differs (default 21.4)")
    a = ap.parse_args()

    # --- version + capability probe (always run first; it's cheap) ----------
    info = probe_version(a.dsn)
    ver = info.get("version")
    if not ver:
        print(f"CH UNREACHABLE: {info.get('version_error')}"); sys.exit(2)
    print(f"CH version(): {ver}")
    if a.expect_version and not ver.startswith(a.expect_version):
        print(f"  ⚠ expected {a.expect_version}.x — this server is {ver}. "
              f"Confirm constructs below still pass.")
    caps = info["capabilities"]
    print("  capabilities: " + ", ".join(f"{k}={'ok' if v else 'MISSING'}"
                                          for k, v in caps.items()))
    missing = [k for k, v in caps.items() if not v]
    if missing:
        print(f"  ⚠ this server lacks: {missing} — composed queries using them will fail here.")
    if a.probe:
        sys.exit(1 if missing else 0)

    sql = sys.stdin.read() if a.stdin else Path(a.file).read_text()
    sql = strip_comments(substitute(sql, json.loads(a.params)))
    if not sql:
        ap.error("empty query after stripping comments")

    try:
        if a.run:
            out = ch_post(a.dsn, f"{sql}\nLIMIT {a.limit}\nFORMAT TabSeparatedWithNames")
            mode = f"rows (LIMIT {a.limit})"
        else:
            mode, out = explain_or_fallback(a.dsn, sql)
    except Exception as e:
        print(f"CH VALIDATION FAILED: {e}")
        print("  (invalid CH SQL for this version, unreachable host, or missing access)")
        sys.exit(2)
    print(f"\nCH OK — {mode}:")
    print(out)


if __name__ == "__main__":
    main()
