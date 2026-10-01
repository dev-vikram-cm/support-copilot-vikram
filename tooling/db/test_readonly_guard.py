#!/usr/bin/env python3
"""
Unit tests for the read-only SQL guard. Run:  python3 -m pytest -q
(or just:  python3 test_readonly_guard.py)

Proves the worst-case guarantee the tool relies on: NOTHING but a single
SELECT-family statement can ever reach a database — across write/DDL/DCL/
transaction/session/admin verbs, multi-statement chaining, and comment/string
smuggling — while every real composed/detail query still passes.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from readonly_guard import check_sql, is_readonly, SqlNotAllowed

# --- must be REFUSED ----------------------------------------------------------
BLOCKED = [
    # writes / DML
    "INSERT INTO trd_d_product VALUES (1)",
    "UPDATE trd_d_product SET name='x'",
    "DELETE FROM trd_d_product",
    "MERGE INTO t USING s ON (t.id=s.id)",
    "TRUNCATE TABLE trd_d_product",
    # DDL
    "DROP TABLE trd_d_product",
    "ALTER TABLE t ADD COLUMN c int",
    "CREATE TABLE t (id int)",
    "RENAME TABLE a TO b",
    # DCL
    "GRANT SELECT ON t TO r",
    "REVOKE SELECT ON t FROM r",
    # bulk / engine admin
    "COPY t FROM '/tmp/x'",
    "SELECT * FROM t INTO OUTFILE '/tmp/x'",
    "SELECT * INTO newtbl FROM t",
    "OPTIMIZE TABLE t FINAL",
    "ATTACH TABLE t",
    "SYSTEM RELOAD DICTIONARIES",
    "KILL QUERY WHERE 1",
    # transaction / session
    "BEGIN",
    "COMMIT",
    "SET search_path = evil",
    "USE otherdb",
    # locking / read-for-write
    "SELECT * FROM t FOR UPDATE",
    # multiple statements
    "SELECT 1; DROP TABLE t",
    "SELECT 1;SELECT 2",
    # comment / string smuggling & malformed
    "SELECT 1 /* unterminated",
    "SELECT 'unterminated",
    "DROP TABLE t -- SELECT 1",         # leading verb is DROP
    "SELECT 1\x00; DROP TABLE t",
    "",
    "   ",
    "-- just a comment",
    "WITH x AS (SELECT 1) DELETE FROM t",   # CTE then write
]

# --- must be ALLOWED (real composed / detail / probe queries) -----------------
ALLOWED = [
    "SELECT 1",
    "SELECT version()",
    "SELECT argMax(number, number) FROM numbers(3)",
    "SELECT DISTINCT levelid FROM trd_d_product ORDER BY 1",
    "SELECT id, name FROM trd_d_product WHERE levelid='department' ORDER BY name",
    "SELECT DISTINCT ancestor0 FROM trd_h_prodstd WHERE ancestor4 IN ('DP-48','DP-50')",
    # composer output essentials
    "SELECT product AS stylecolor, sum(dmd_u) AS dmd_u, argMax(eoh_u,time) AS eoh_u,"
    " count(DISTINCT product) AS c FROM trd_p_history_agg WHERE time IN ('202540')"
    " AND cluster IN ('A','B') GROUP BY product HAVING sum(shp_u) > -10 ORDER BY product",
    # cluster is a real column, must not trip the guard
    "SELECT cluster, count(*) FROM trd_p_history_agg GROUP BY cluster",
    # CASE ... END must not trip on 'end'
    "SELECT CASE WHEN dmd_u > 0 THEN 1 ELSE 0 END AS f FROM t",
    # SETTINGS / OFFSET / RESET-like identifiers must not trip 'set'
    "SELECT * FROM t LIMIT 10 OFFSET 5",
    "SELECT max_threads FROM t SETTINGS max_threads=1",
    # identity probe with forbidden words INSIDE string literals -> safe
    "SELECT has_table_privilege('trd_d_product','INSERT') AS can_insert",
    "SELECT current_user, current_setting('is_superuser')",
    # CTE then SELECT
    "WITH x AS (SELECT 1 AS a) SELECT a FROM x",
    # EXPLAIN family
    "EXPLAIN SYNTAX SELECT 1",
    "EXPLAIN ANALYZE SELECT count(*) FROM t",
    "SHOW TABLES",
    "DESCRIBE trd_d_product",
    # trailing semicolon + whitespace tolerated
    "SELECT 1 ;  ",
    # a legit string containing a semicolon and keywords (data, not code)
    "SELECT name FROM t WHERE name = 'a; drop table t'",
]


def run():
    fails = []
    for q in BLOCKED:
        if is_readonly(q):
            fails.append(f"SHOULD BLOCK but allowed: {q!r}")
    for q in ALLOWED:
        try:
            check_sql(q)
        except SqlNotAllowed as e:
            fails.append(f"SHOULD ALLOW but blocked ({e}): {q!r}")
    if fails:
        print(f"FAIL ({len(fails)}):")
        for f in fails:
            print("  -", f)
        return 1
    print(f"OK — {len(BLOCKED)} blocked, {len(ALLOWED)} allowed, all correct.")
    return 0


# pytest entry points
def test_blocked():
    assert all(not is_readonly(q) for q in BLOCKED)


def test_allowed():
    for q in ALLOWED:
        check_sql(q)


if __name__ == "__main__":
    sys.exit(run())
