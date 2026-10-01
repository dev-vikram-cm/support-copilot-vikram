#!/usr/bin/env python3
"""
Tests for the Time & Filters build:
  - members.resolve_time: week-range / calendar-member / floorset paths emit
    read-only SQL and return the right weeks (DB mocked).
  - compose: emits a real prodlife IN(...) filter, documents flowStatus as
    pivot-derived (does NOT fake `prodlife = '<fs>'`), and stamps the time
    window note — verified with the parser/contract stubbed so no live config
    is needed. The composed SQL still passes the read-only guard.

Run:  python3 test_time_filters.py     (exit 0 = pass)
"""
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "db"))

import members as M
import compose as C
from readonly_guard import check_sql

fails = []


def check(cond, msg):
    if not cond:
        fails.append(msg)


# ---- 1. resolve_time paths (DB mocked) --------------------------------------
def _mock_run_factory():
    seen = []
    def fake_run(client, engine, sql, env):
        seen.append(sql)
        check_sql(sql)                        # every emitted query must be read-only
        if " AS s" in sql or "slsstart" in sql:
            return "s\te\n2025_W26\t2025_W28\n(1 row)"
        return "id\n2025_W26\n2025_W27\n2025_W28\n(3 rows)"
    return fake_run, seen


def test_resolve_time():
    fake, seen = _mock_run_factory()
    M._run = fake
    r = M.resolve_time("TRD", "range", ["2025_W26", "2025_W28"])
    check(r["weeks"] == ["2025_W26", "2025_W27", "2025_W28"], f"range weeks wrong: {r}")
    check("BETWEEN" in seen[-1], "range must use indx BETWEEN")

    r = M.resolve_time("TRD", "quarter", ["FY28_Q4"])
    check(len(r["weeks"]) == 3, f"quarter weeks wrong: {r}")
    check("trd_h_timestd" in seen[-1] and "ancestor" in seen[-1], "quarter must use timestd ancestors")

    r = M.resolve_time("TRD", "floorset", ["0526_Spr_4_125"], dept="DP-125")
    check(r["weeks"] == ["2025_W26", "2025_W27", "2025_W28"], f"floorset weeks wrong: {r}")
    check(any("trd_ma_dptflrsetattributes" in s for s in seen), "floorset must read attr table")

    r = M.resolve_time("TRD", "weeks", ["2025_W26", "2025_W27"])
    check(r["weeks"] == ["2025_W26", "2025_W27"], "weeks passthrough wrong")


# ---- 2. compose filter emission (parser/contract stubbed) -------------------
def _stub_compose():
    C.listdata_parse.parse = lambda url: {
        "defnId": "HistoryFit", "grain": [{"kind": "level", "name": "stylecolor"}],
        "grain_raw": "level:stylecolor", "flowStatus": "", "topMembers": ""}
    C.resolve_pivot = lambda defn, cfg: (Path("HistoryFit.pivotdefn"), None)
    C.pivot_contract.extract = lambda p: {
        "runtime_table": "trd_p_history_agg", "runtime_note": None,
        "metric_aggs": {"dmd_u": {"ch_expr": "sum(dmd_u)", "family": "additive"},
                        "eoh_u": {"ch_expr": "argMax(eoh_u,time)", "family": "snapshot (EOH)"}},
        "hist_criteria": "sum(dmd_u) > 0", "flow_criteria": "avg(dmd_u) > 0"}


def test_compose_filters():
    _stub_compose()
    sql = C.compose("api/pivot3/listData?defnId=HistoryFit", "/fake", "hist", None,
                    filters={"weeks": ["2025_W26", "2025_W27"],
                             "time_note": "range 2025_W26..2025_W27 → 2 weeks",
                             "prodlife": ["FP", "MD"], "flowStatus": "0",
                             "cluster": ["A"]})
    check("prodlife IN ('FP', 'MD')" in sql, "prodlife IN filter missing")
    check("prodlife = '0'" not in sql, "BUG: flowStatus was faked as prodlife = '0'")
    check("flowStatus=0" in sql and "pivot-derived" in sql, "flowStatus caveat missing")
    check("time window: range 2025_W26..2025_W27" in sql, "time_note missing")
    check("time IN ('2025_W26', '2025_W27')" in sql, "resolved weeks not inlined")
    check("cluster IN ('A')" in sql, "cluster filter missing")
    # the composed statement must still be a legal read-only query
    check_sql(sql)


def test_metric_subset():
    _stub_compose()
    # subset: only eoh_u -> only that metric expr, plus grain + choice count
    sql = C.compose("api/pivot3/listData?defnId=HistoryFit", "/fake", "hist", None,
                    filters={"metrics": ["eoh_u"]})
    check("argMax(eoh_u,time) AS m_eoh_u" in sql and "m_eoh_u AS eoh_u" in sql, "chosen metric eoh_u missing")
    check("AS m_dmd_u" not in sql, "unselected metric dmd_u should be absent")
    check("count(DISTINCT product) AS stylecolor_count" in sql, "choice count must stay")
    check("product AS stylecolor" in sql, "grain column must stay")
    check("metrics     : subset (1/2)" in sql, "subset provenance missing")
    check_sql(sql)
    # unknown metric -> a CONFIRM note, no fabricated column
    sql2 = C.compose("api/pivot3/listData?defnId=HistoryFit", "/fake", "hist", None,
                     filters={"metrics": ["dmd_u", "nope_u"]})
    check("not on this pivot: nope_u" in sql2, "unknown-metric note missing")
    check("m_dmd_u AS dmd_u" in sql2 and "nope_u AS" not in sql2, "unknown metric must not be emitted")
    check_sql(sql2)
    # default (no metrics) -> all present with 'all' provenance
    sql3 = C.compose("api/pivot3/listData?defnId=HistoryFit", "/fake", "hist", None, filters={})
    check("metrics     : all 2 on this pivot" in sql3, "default-all provenance missing")
    check("m_dmd_u AS dmd_u" in sql3 and "m_eoh_u AS eoh_u" in sql3, "default-all should emit all metrics")


if __name__ == "__main__":
    test_resolve_time()
    test_compose_filters()
    test_metric_subset()
    if fails:
        print(f"FAIL ({len(fails)}):")
        for f in fails:
            print("  -", f)
        sys.exit(1)
    print("OK — resolve_time (4 paths) + compose filters (prodlife/flowStatus/time) all correct.")
