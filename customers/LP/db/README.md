# LP Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `lp`, server 14.22, dumped 2026-10-01 (pg_dump 18.6,
plain, schema-only). Prod not captured. Generated object-level map:
`SCHEMA_MAP.md`.

Contents: 71 tables (`public` 40, `mfp` 16, `mfp_backup` 15), 6 views,
2 materialized views, 3 functions, **2 triggers**. Table prefix `lp_`.

## Shape: an MFP tenant with a thin assortment layer

LP (Lilly Pulitzer) is live on MFP, and the Hindsighting/AP build is in
progress (`customers/LP/hindsighting-build-log.md`). The database
reflects that:
- **`mfp`**: the platform MFP tables (`actuals_wide`,
  `actuals_stage_wide`, `sys_gen_wide`, `plan_data_wide`, `plans`,
  `dimensions`, `hierarchies`, `tyly`, …). **`mfp_backup`** is a full
  copy of the same 15 tables.
- **`public`**: only 16 `lp_*` tables (`lp_d_*`, `lp_h_*`, `lp_ma_*`,
  `lp_serviceparams`) plus the platform tables (`cart_*`, `plan_queue`,
  `pivot_execution`, `scope`, `undo_*`, `user_*`, liquibase).
- Views `lp_store_hier_attr` (L2061) and `lp_stylecolor_hier_attr`
  (L2112) flatten store and stylecolor hierarchy attributes.

## No business logic in the database

Observed: the only triggers are the platform LISTEN/NOTIFY pair on
`pivot_execution` and `plan_queue` (`notify_*_change()`, L196/L209). The
only other function is `plan_eligible()` (L222). There are no
lifecycle, validity, ranging or publish triggers, so the trigger
checklists in AEO/TRD/BOD's READMEs don't apply. "Value changed" issues
on LP come from the ETL, config or backend.

As the Hindsighting/AP build adds `lp_*` model tables, re-dump and
regenerate so this file and `SCHEMA_MAP.md` keep up.

## Materialized views

`mfp.actuals_wide_denorm` (L483) and `mfp.sys_gen_wide_denorm` (L835)
follow the platform MFP pattern (the wide table joined to the time,
product and location denorm views) and only change on batch REFRESH.
"MFP numbers stale" usually means the refresh didn't run.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, then run
`python3 tooling/db/schema_map.py regen`.
