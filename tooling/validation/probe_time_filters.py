#!/usr/bin/env python3
"""
Confirmation probes for the Time & Filters build (see time-and-filters-plan.md).

Runs a handful of READ-ONLY discovery queries against the read-only account so
we STOP GUESSING the hierarchy/ancestor mappings before writing the time
resolver. Everything goes through the same guarded, read-only DB layer
(mcp_server.tool_query -> check_sql), so it can only SELECT.

Run on the VPN, from tooling/validation:
    python3 probe_time_filters.py --client TRD
    python3 probe_time_filters.py --client TRD --engine postgres

Read the output to answer, per the plan's section 4:
  1. trd_h_timeflrset : which ancestorN holds the floorset id vs the week id
  2. trd_h_timestd    : week/month/quarter/season/year -> which ancestor index
  3. trd_d_time        : levels present + that weeks are ordered by `indx`
                         (so a HistoryStart..HistoryEnd range is a BETWEEN on indx)
  4. table discovery   : real table names for time / prodlife / flow_status
  5. prodlife          : distinct lifecycle codes + labels (if a PG dim exists)

flow_status (New/Carryover/Sell-down) is pivot-DERIVED into a session table
`flow_status_<PID>` and is not expected as a plain column — the composer will
document that caveat rather than fake it (confirmed design choice).
"""
import argparse, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "db"))
import mcp_server as db
import members as M   # reuse client env config

# (label, engine, sql). client prefix is 'trd'; adjust here if a table name differs.
PROBES = [
    ("1. floorset hierarchy — trd_h_timeflrset (id + ancestors; spot the week vs floorset columns)",
     "postgres", "SELECT * FROM trd_h_timeflrset LIMIT 5"),

    ("2. calendar hierarchy — trd_h_timestd (id + ancestors; map week/month/quarter/season/year)",
     "postgres", "SELECT * FROM trd_h_timestd LIMIT 5"),

    ("3a. time dimension levels — trd_d_time (levelid coverage + indx range)",
     "postgres", "SELECT levelid, count(*) AS n, min(indx) AS min_indx, max(indx) AS max_indx "
                 "FROM trd_d_time GROUP BY levelid ORDER BY n DESC"),

    ("3b. weeks are ordered by indx (proves range = BETWEEN on indx, format-agnostic)",
     "postgres", "SELECT id, indx FROM trd_d_time WHERE levelid='week' ORDER BY indx LIMIT 8"),

    ("4. table discovery — real time / prodlife / flow table names in this DB",
     "postgres", "SELECT table_name FROM information_schema.tables "
                 "WHERE table_name LIKE 'trd_%time%' OR table_name LIKE 'trd_%flrset%' "
                 "OR table_name LIKE 'trd_%life%' OR table_name LIKE 'trd_%flow%' "
                 "ORDER BY table_name"),

    # --- round 2: confirmed trd_d_prodlife exists; floorset->week lives outside
    #     trd_h_timeflrset (which only maps floorset->season/year) -------------
    ("5. prodlife dimension — trd_d_prodlife members (codes + labels for the filter)",
     "postgres", "SELECT id, name, levelid FROM trd_d_prodlife ORDER BY id"),

    ("6. calendar hierarchy — a WEEK row's ancestors (confirm month/quarter/season/year order)",
     "postgres", r"SELECT * FROM trd_h_timestd WHERE id LIKE '%\_W%' ORDER BY id LIMIT 5"),

    ("7a. floorset->week source? dept-floorset attributes (look for start/end week cols)",
     "postgres", "SELECT * FROM trd_ma_dptflrsetattributes LIMIT 3"),

    ("7b. floorset->week source? target floorset hierarchy (look for a week column)",
     "postgres", "SELECT * FROM trd_for_tgt_flrset_hier LIMIT 5"),
]


def run(client, only_engine=None):
    cfg = M.QUERIES.get(client) or {}
    env = cfg.get("env", "qa")
    print(f"# Time & Filter confirmation probes — client={client} env={env}")
    print(f"# account: {db.probe_identity(client, env, 'postgres')}\n")
    for label, engine, sql in PROBES:
        if only_engine and engine != only_engine:
            continue
        print("=" * 78)
        print(label)
        print(f"  [{engine}] {sql}")
        print("-" * 78)
        try:
            out = db.tool_query({"client": client, "env": env, "engine": engine,
                                 "sql": sql, "max_rows": 200})
        except Exception as e:
            out = f"ERROR: {e}"
        print(out.strip() or "(no rows)")
        print()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--client", default="TRD")
    ap.add_argument("--engine", choices=["postgres", "vertica", "clickhouse"])
    a = ap.parse_args()
    run(a.client, a.engine)


if __name__ == "__main__":
    main()
