#!/usr/bin/env python3
"""
Execute a composed validation query and COMPARE it to the UI value.

Closes the loop: compose (independent SQL) -> run on ClickHouse -> summarize
(choice count + metric totals) -> diff against what the screen shows. A match
confirms the number; a mismatch localizes a criteria/filter/aggregation bug.

Time-window resolution: the composed SQL leaves `:HISTORY_WEEKS` as a
placeholder (the history window is session context, not in the listData URL).
Supply it with --weeks (comma list) or --week-range LO HI (lexical, inclusive)
— or --list-weeks to pull the available weeks from the DB first.

Expected UI values come from --expected (JSON, e.g.
'{"choice_count": 125, "dmd_u": 84213}') — read them off the screen or a
captured listData response.

Runs against the customer's ClickHouse — use LOCALLY with read-only access.

Usage:
  python3 compare.py --sql-file q.sql --dsn http://u:p@host:8123 \
     --weeks 202540,202541,202542 --expected '{"choice_count":125}'
  python3 compare.py --sql-file q.sql --dsn ... --list-weeks --table trd_p_history_agg
"""
import argparse, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "db"))
import ch_validate as chv
from readonly_guard import check_sql, SqlNotAllowed   # enforce read-only on CH too


def weeks_clause(weeks):
    return ", ".join(f"'{w.strip()}'" for w in weeks if w.strip())


def resolve_weeks(a, dsn):
    if a.weeks:
        return [w.strip() for w in a.weeks.split(",") if w.strip()]
    if a.week_range:
        lo, hi = a.week_range
        table = a.table or "trd_p_history_agg"
        # lexical range on the String week id (fixed-width YYYYWW => chronological)
        q = (f"SELECT DISTINCT time FROM {table} WHERE time >= '{lo}' AND time <= '{hi}' "
             f"ORDER BY time FORMAT TabSeparated")
        out = chv.ch_post(dsn, q)
        return [l for l in out.splitlines() if l.strip()]
    return None


def parse_tsv(text):
    lines = [l for l in text.splitlines() if l != ""]
    if not lines:
        return [], []
    header = lines[0].split("\t")
    rows = [dict(zip(header, l.split("\t"))) for l in lines[1:]]
    return header, rows


def is_num(x):
    try:
        float(x); return True
    except Exception:
        return False


def summarize(header, rows):
    """choice_count = # rows; per numeric metric column => sum over rows.
    (dimension columns like stylecolor/product are excluded from sums.)"""
    summary = {"choice_count": len(rows)}
    if not rows:
        return summary
    numeric_cols = [c for c in header
                    if c not in ("stylecolor", "product", "style", "x_style")
                    and all(is_num(r.get(c, "")) for r in rows)]
    for c in numeric_cols:
        summary[c] = round(sum(float(r[c]) for r in rows), 4)
    return summary


def compare(summary, expected, tol=1e-6):
    out = []
    ok = True
    for k, exp in expected.items():
        got = summary.get(k)
        if got is None:
            out.append((k, exp, None, "MISSING")); ok = False; continue
        exp_f, got_f = float(exp), float(got)
        denom = max(1.0, abs(exp_f))
        match = abs(exp_f - got_f) / denom <= tol
        out.append((k, exp, got, "MATCH" if match else f"MISMATCH (Δ {got_f-exp_f:+.4g})"))
        ok = ok and match
    return ok, out


def run(sql, dsn, weeks, max_rows):
    sql = chv.strip_comments(chv.substitute(sql, {"HISTORY_WEEKS": weeks_clause(weeks)}))
    # HARD read-only gate: the composed statement is validated as a single
    # SELECT-family query BEFORE it touches ClickHouse. LIMIT/FORMAT are appended
    # by us afterwards (never user-supplied), so the guard sees only the body.
    check_sql(sql)
    q = f"{sql}\nLIMIT {max_rows}\nFORMAT TabSeparatedWithNames"
    text = chv.ch_post(dsn, q)
    header, rows = parse_tsv(text)
    return header, rows


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sql-file", required=True)
    ap.add_argument("--dsn", required=True)
    ap.add_argument("--weeks", help="comma list of week ids, e.g. 202540,202541")
    ap.add_argument("--week-range", nargs=2, metavar=("LO", "HI"))
    ap.add_argument("--table", help="table for --week-range / --list-weeks")
    ap.add_argument("--list-weeks", action="store_true", help="print DB weeks and exit")
    ap.add_argument("--expected", default="{}", help="JSON of UI values to compare")
    ap.add_argument("--max-rows", type=int, default=200000)
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()

    # version + capability gate first (most of the fleet is 21.4)
    info = chv.probe_version(a.dsn)
    if not info.get("version"):
        print(f"CH UNREACHABLE: {info.get('version_error')}"); sys.exit(2)
    print(f"CH version(): {info['version']}")
    miss = [k for k, v in info["capabilities"].items() if not v]
    if miss:
        print(f"  ⚠ server lacks {miss} — composed query may fail.");

    if a.list_weeks:
        table = a.table or "trd_p_history_agg"
        print(chv.ch_post(a.dsn, f"SELECT DISTINCT time FROM {table} ORDER BY time FORMAT TabSeparated"))
        return

    weeks = resolve_weeks(a, a.dsn)
    if not weeks:
        ap.error("supply --weeks or --week-range (or --list-weeks to discover them)")
    print(f"history window: {len(weeks)} weeks ({weeks[0]}..{weeks[-1]})")

    sql = Path(a.sql_file).read_text()
    try:
        header, rows = run(sql, a.dsn, weeks, a.max_rows)
    except Exception as e:
        print(f"QUERY FAILED: {e}"); sys.exit(2)
    summary = summarize(header, rows)

    print("\nDB SUMMARY (independent oracle):")
    for k, v in summary.items():
        print(f"  {k:16} {v}")

    expected = json.loads(a.expected)
    if expected:
        ok, rowsc = compare(summary, expected)
        print("\nCOMPARE vs UI:")
        for k, exp, got, verdict in rowsc:
            print(f"  {k:16} UI={exp:<12} DB={got!s:<12} {verdict}")
        print(f"\nRESULT: {'✓ ALL MATCH' if ok else '✗ MISMATCH — investigate criteria/filter/aggregation'}")
        if a.json:
            print(json.dumps({"summary": summary, "match": ok}, indent=1))
        sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
