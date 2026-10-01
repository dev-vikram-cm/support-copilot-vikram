# Runbook: database schema snapshots

**Why:** completes the fourth knowledge source (ETL, config, app repos +
DB). Schema dumps let the agent answer trigger/function/engine questions
with citations, power MV-based lineage edges, and act as drift detection
for manual DDL changes in lower envs (diff consecutive snapshots).

## Commands (run per env; commit to customers/<CLIENT>/db/)

### Postgres — includes triggers, functions, views, MVs, constraints
```bash
pg_dump -s --no-owner --no-privileges -d <dbname> \
  > customers/<CLIENT>/db/postgres_schema.sql
```
- Use **plain format** (the default, or `-Fp`), schema-only (`-s`). A
  custom-format archive (`-Fc`, "PGDMP" header) can't be grepped and
  needs a `pg_restore` at least as new as the `pg_dump` that wrote it
  (`brew install libpq` gives one; convert it with
  `pg_restore -f out.sql --no-owner --no-privileges <archive>`).
- Pgadmin/GUI dumps with owners and TOC comments are fine; the tooling
  handles both.
- Where things go: a client's own DB → `customers/<CLIENT>/db/`. Sibling
  tenants/brands with their own DB go in a subfolder: AEO's `aer`, `tsn`
  and `uns` in `customers/AEO/db/<tenant>/`; KW's brands `ann`, `atfs`,
  `loft` and `los` in `customers/KW/db/<brand>/`. DB names don't always
  match folder names: `eve` → EE, `bd` → BOD.
- Prepend the header line (see Rules):
  `-- ENV: QA | DB: <db> | dumped: <YYYY-MM-DD HH:MM TZ> | server <ver> (pg_dump <ver>, plain, schema-only)`.
- Confirm there's no data: `grep -c "^COPY .* FROM stdin;" <file>` must
  be 0.

### After any PG dump: regenerate the maps
```bash
python3 tooling/db/schema_map.py diff <old.sql> <new.sql>   # drift vs previous snapshot
python3 tooling/db/schema_map.py regen                      # every db/**/SCHEMA_MAP.md + knowledge/db-trigger-matrix.md
```
`SCHEMA_MAP.md` (generated) holds counts, every trigger with its WHEN
clause and function line, unattached trigger functions and views/MVs.
The hand-written `db/README.md` holds the meaning: quirks and triage
implications. Update the README when the drift diff shows a trigger or
function change.

### ClickHouse — includes MATERIALIZED VIEWS (their SELECTs = lineage!)
```bash
clickhouse-client --query "SELECT create_table_query FROM system.tables
  WHERE database = '<db>' AND create_table_query != ''
  FORMAT TSVRaw" > customers/<CLIENT>/db/clickhouse_schema.sql
```

### Vertica — DDL including projections
```sql
SELECT EXPORT_OBJECTS('', '<schema>', false);
-- save output to customers/<CLIENT>/db/vertica_schema.sql
```

### Optional: row-count snapshot (freshness/sanity context)
```bash
psql -d <dbname> -Atc "select relname||E'\t'||n_live_tup
  from pg_stat_user_tables order by 1" > customers/<CLIENT>/db/pg_rowcounts.tsv
clickhouse-client --query "select name, total_rows from system.tables
  where database='<db>' FORMAT TSV" > customers/<CLIENT>/db/ch_rowcounts.tsv
```

## Rules

- Tag each file with env + date in a header comment (which env was dumped!).
- Lower-env dumps are the truth for lower-env debugging (git may lie —
  same principle as the OCI config runbook).
- Weekly cadence is enough; also re-dump before any deep DB debugging.
- Diff vs previous snapshot on every refresh — unexpected DDL changes go
  straight into a ticket/note.

## What schema dumps do NOT cover

Data values, query performance/statistics, runtime settings. For those:
ad-hoc query results pasted into chat, or the (phase 3) read-only QA
database MCP.
