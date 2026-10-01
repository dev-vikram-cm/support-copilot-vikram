# TB Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `tb`, server 14.22, dumped 2026-10-01 (pg_dump 18.6,
plain, schema-only). Prod not captured. Generated object-level map:
`SCHEMA_MAP.md`.

Contents: 134 tables (`public` 86, `mfp` 48), 5 views, 2 materialized
views, 4 functions, **2 triggers**. Table prefix: **`tb01_`**, not `tb_`.
Ids and queries must use `tb01_…`.

## There is no business logic in TB's Postgres

Unlike AEO, TRD, BOD, BELK, EE, EXP, GAP and KW, TB has **no lifecycle,
validity, ranging or publish triggers** (Observed; compare
`knowledge/db-trigger-matrix.md`, where TB's column is empty apart from
two rows). The only triggers are the platform LISTEN/NOTIFY pair on
`pivot_execution` and `plan_queue` (`notify_*_change()`, L217/L230), which
the backend uses as eventing.

What that means for triage:
- **"Value changed by itself" / "edit reverted" is not a database
  trigger on TB.** Look at the ETL (`etl-tb-batch`), config
  (`tb-configs-v2`) or the backend instead. The trigger checklists in the
  other clients' READMEs don't apply.
- A fix ported from AEO/TRD that relies on a trigger side effect (week
  indexes, IRW, last DC order, store-eligibility rebuild) **won't happen
  on TB** unless the ETL or backend does it.

## Things that look wrong (Observed)

- **`plan_eligible(products text[])` (L243) reads
  `tb01_ma_stylecolorchannelattributes`, a table that does not exist** in
  this database (the `tb01_ma_*` tables are channel, classchnl,
  dptflrset, globalregion, img, store, stylecolor and week attributes).
  pg_dump uses `check_function_bodies = false`, so the function exists
  but would error if called. *Inferred:* it was copied from the shared
  platform template.
- **Two Boden-prefixed tables live in TB's `public`:**
  `bd_ma_stylecolorattributes` and `bd_ma_stylecolorweekattributes`.
  *Inferred:* these are template or copy leftovers. Don't read them as TB
  data.
- Lots of copy clutter: `*_shadow`, `*_shadow2`, `*_jul30`, `*_bkp*`,
  `*_test` versions of the core `d_product`, `h_prodstd`,
  `ma_stylecolorattributes` and `v_memberbasedvalidvalues` tables. Make
  sure a query targets the live table, not a shadow.
- `generate_create_table_statement(p_table_name)` (L137) is a DDL helper
  that builds a CREATE TABLE from the catalog. It's a utility, not
  business logic.

## Table families

| Family | Notes |
|---|---|
| `tb01_d_*`, `tb01_h_*` | Dimensions and hierarchies (product, location, time, prodlife, cluster, DC location, time floorset) |
| `tb01_ma_*` | Master attributes. **No `stylecolorchannelattributes`** (see above) |
| `tb01_v_memberbasedvalidvalues` | Valid-values table that darwin reads directly. Fed from the Vertica constant table since SUP-4738 (`knowledge/notes/SUP-4738.md`) |
| `tb01_a_assortment` | Assortment (plus `_old`) |
| `mfp.*` (48) | MFP: `actuals_wide`, `sys_gen_wide`, `plan_data_wide`, plans, dimensions, hierarchies, many dated backups/staging copies. TB's MFP schema keeps its own `d_*`/`h_*` copies (`mfp.d_product`, `mfp.h_prodstd`, …) |
| platform | `cart_*`, `plan_queue`, `pivot_execution`, `scope`, `undo_*`, `user_*`, liquibase |

## Materialized views

`mfp.actuals_wide_denorm` (L650) and `mfp.sys_gen_wide_denorm` (L1426)
follow the platform MFP pattern: the wide table joined to the
`time_denorm`, `product_denorm` and `location_denorm` views. TB also has
`mfp.prodlife_denorm`. They only change when the batch REFRESHes them.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, then run
`python3 tooling/db/schema_map.py regen`.
