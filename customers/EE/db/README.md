# EE (Evereve) Postgres: schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `eve`, server 14.22, dumped 2026-10-01 15:05 IST (pg_dump 18.6, plain,
schema-only). **Prod and Staging are not captured.** The JIRA tag is `EE`, but tables use `eve_` (see `../profile.md`).
Full trigger list and counts: [SCHEMA_MAP.md](SCHEMA_MAP.md). Cross-client comparison:
`knowledge/db-trigger-matrix.md`. ClickHouse: `../clickhouse_schema.sql` (not analyzed here).

Contents: 337 tables, 54 triggers on 20 tables (**2 disabled**), 62 functions + 4 procedures,
16 views, 4 materialized views. Schemas: `public` 258, `mfp` 46, `target_setting` 20, `safe_to_delete` 6,
`migrate` 5, `debug` 2. Line numbers are `postgres_schema.sql` lines.

Hierarchy convention, from `update_class_after_subclass` (L5986) and `update_pim_style_id` (L6379):

| `eve_h_prodstd` row | ancestor0 | ancestor1 | ancestor2 | ancestor3 |
|---|---|---|---|---|
| style | subclass | class | department | |
| stylecolor | style | subclass | class | department |
| stylecolorsize | stylecolor | style | subclass | class |

`ccrangecode` = `<sty_size_run_name> - <class id>`. Class ids start with `CL-`, and L5602 parses on ` - CL-`.

## The hidden business-logic layer: triggers

None of this is in git, and the live QA DDL has drifted from the ETL repo's
`Deployments/postgres/postgres_ap_ddls.sql`. **Observed** = read from the DDL. **Inferred** = derived
from trigger semantics, not yet confirmed with data (EE has no `db/connections.json` yet).
**Porting rule:** EE's lifecycle validity triggers, `ca_1_trigger_on_update`, `trigger_cartparams_ranging` and
`trg_to_update_source_of_ranging_edit` behave the same as **KW's** (same matrix letter), not AEO's.
Diff against KW before porting an AEO fix.

### eve_ma_stylecolorchannelattributes: 11 triggers (the hot spot)

PK `(product, location)` (L17453). "Passed" means older than the row's own `plan_current`
**column**, not `eve_serviceparams`. "Not cloned" means `cloned_at IS NULL`.

| Trigger | Fires on | WHEN | Function (Lnnn) → effect |
|---|---|---|---|
| `md_trigger_on_update` | AFTER UPDATE OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut), OR exit ≤ MD, OR (not cloned AND MD passed); depth=0 | `md_trigger_on_update_validity_check()` (L5143) → **`SET erlstmkdnwk = OLD`** on every channel row |
| `exit_trigger_on_update` | AFTER UPDATE OF `exitdate` | exit ≤ MD, OR (not cloned AND exit passed). The depth=0 guard covers **only the relaunch branch** | `exit_trigger_on_update_validity_check()` (L4838) → **`SET exitdate = OLD`** |
| `dbt_trigger_on_update` | AFTER UPDATE OF `dbt_wk` | debut ≥ MD, OR (not cloned AND debut passed); depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L2424) → **`SET dbt_wk = OLD`**. AEO has no passed-week lock |
| `ca_1_trigger_on_update` | AFTER UPDATE OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit AND (cloned OR debut/exit not passed); depth=0 | `store_eligibility_trigger()` (L5710) → deletes the item's `plan` rows in `eve_a_assortment` and rebuilds them over the floorsets whose `slsstart..slsend` overlaps [`dbt_wk`, exit], copying ranging from the nearest old floorset. Then sets `isfunded = 1` on the floorset that contains `dbt_wk`, for **all locations** |
| `ca_1_trigger_on_update2` | AFTER UPDATE OF `dbt_wk, exitdate` | debut < MD < exit AND debut/exit not passed; depth=0 | `store_eligibility_trigger2()` (L5785) → **the same rebuild again**, through the permanent tables `tmp_new`/`tmp_old` (L15973, L15988) using `TRUNCATE` |
| `trigger_for_time_indx` | AFTER INSERT OR UPDATE OF the 4 lifecycle weeks | none | `update_week_indxes()`, see below |
| `trigger_for_time_indx_update` | AFTER UPDATE OF the same 4 weeks | same as `ca_1` minus depth | `update_week_indxes()` again |
| `trigger_lifecycle_plan_update` | AFTER UPDATE OF `erlstmkdnwk` | none, no depth guard | `lifecycle_plan_update()` (L5108) → **NULLs `dc_uservrp`/`dc_useradj`** in `eve_p_dc_adj` and `_size` for `time >= new MD`. Same as AEO |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | none (fires even when the value is unchanged) | `sizerangecode_validsizes_members()` (L5566) → sets every size to `isvalid = 0`, deletes and re-inserts the in-range `eve_ma_sizeattributes` rows (`eve_l_dependencylookup` ⨝ `s5_eve_sizerange_master`), adds `eve_d_product`/`eve_h_prodstd` rows for new sizes (named `<stylecolor>-<size>`), NULLs `dc_useradj` on invalid sizes, and **overwrites `cc_validsizes_store/_ecom` on all channels with the full range** |
| `clear_pim_style_id` | AFTER UPDATE OF `record_state` | none (the body checks 0→1) | `clear_pim_style_id()` (L2337) → when the style's last other active stylecolor is removed, blanks `eve_ma_styleattributes.pim_style_id`, which fires `update_pim_style_id` |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | always | `trigger_set_timestamp()` (L5969) → `updated_at` |

#### update_week_indxes() (L6875): what a lifecycle save also changes

1. **IRW = debut, with no offset**: `initrcptwk = dbt_wk`. AEO subtracts the floorset's `irw_debut_offset`.
2. **Last DC order = MD − 6**, which sets `lastdcorder` and `last_rcpt_wk`. BOD also uses MD − 6; AEO and TRD use MD − 4.
   There is no `auto_rollforward` branch.
3. `too` = MD − debut and `mkdnwks` = exit − MD. **`relaunchweek` is ignored throughout**, even though the WHEN clause checks it.
4. Writes `eve_ma_stylecolorattributes.cc_floorset` / `cc_fulfillment` from `eve_l_dependencylookup`
   (`dbt_wk` → floorset → month). If no lookup row exists, **both become NULL**.
5. `act_dbt_wk` follows `dbt_wk` when `OLD.dbt_wk = OLD.act_dbt_wk`, the new debut < MD, and the old debut is not passed.
6. Steps 1–4 run only when debut < MD < exit AND (old debut or old exit > `plan_current`). *Inferred:* on INSERT,
   OLD is NULL, so this gate is never true and inserted rows get none of these fields (AEO has an `_insert` trigger; EE doesn't).

### eve_ma_styleattributes (7) and eve_ma_stylecolorattributes (6): the PIM lock layer

| Table.trigger | Fires on / WHEN | Function (Lnnn) → effect |
|---|---|---|
| style `aa_trig_sty_update_revert`, stylecolor `aa_trig_cc_update_revert` | BEFORE UPDATE OF 21 `sty_*` / 14 `cc_*` columns (L18103 / L18095); WHEN `old.sty_is_locked` / `old.cc_is_locked = 'Y'` | `revert_to_original()` (L5473) is just `RETURN NULL` → **the whole row update is silently skipped**. AEO has this function but leaves it unattached |
| style `trg_upd_pim_style_id` | BEFORE UPDATE OF `pim_style_id` | `update_pim_style_id()` (L6379) → rejects an id already used by another style (silently keeps OLD). Otherwise: clears the children's `pim_stylecolor_id`, swaps ids in the `eve_l_dependencylookup` pool, **moves the style, stylecolors and sizes to the PIM style's subclass and class**, copies the PIM name, description and about 20 `sty_*` attributes, and sets `sty_is_locked = 'Y'` when `erp_style_id` is set and the size runs match. Blanking the id unlocks the style (SUP-2261) |
| stylecolor `trg_upd_pim_stylecolor_id` | BEFORE UPDATE OF `pim_stylecolor_id` | `update_pim_stylecolor_id()` (L6487) → the same pattern at stylecolor level (about 30 `cc_*` fields copied), with `cc_is_locked = 'Y'`. *Inferred:* blanking it does **not** unlock, because `erp_stylecolor_id` is never cleared |
| style `update_ccrangecode` | AFTER UPDATE OF `sty_size_run_name`; depth=0 | `update_stylecolorchannelattributes_ccrangecode()` (L6674) → if the value changed and `sty_is_locked IS NULL`: the children's `ccrangecode` = `<run> - <class>` and valid sizes = the run's `size_range` lookup (this cascades into size regeneration). **Otherwise it reverts `sty_size_run_name` to OLD** (L6752) |
| style `trigger_update_class_after_subclass` | AFTER UPDATE OF `sty_subclass_display` | `update_class_after_subclass()` (L5986) → rewrites the subclass and class ancestors for the style, its stylecolors and its sizes |
| style `trg_upd_vendor_name` / `trigger_update_sty_brand_name` | BEFORE UPDATE OF vendor / brand | L6598: `sty_development_path` from the `vendor_name → direct_import` lookup (NULL if none). L6568: `sty_source` from the brand lookup, else `'Branded'` |
| stylecolor `trig_upd_on_color_change` | AFTER UPDATE OF `cccolor` | `update_color_change()` (L6046) → `eve_d_product` name = `<style name>:<first word of color>`, description = `<style desc>:<color>`, plus `cccolorfamily` from the lookup. Simpler than AEO's |
| stylecolor `trig_upd_on_ticketprice` | AFTER UPDATE OF `cc_msrp` | `update_ticket_price()` (L6769) → `ccticketpricechannel = cc_msrp` on every channel row |
| stylecolor `trg_upd_cc_prepublish` | BEFORE UPDATE OF `cc_prepublish` | `set_prepublished_at()` (L5492) → stamps `cc_prepublished_at` the first time it becomes true; any non-true value is stored as NULL |

### Quirks worth knowing

- **Saves on locked PIM items vanish without an error.** *Observed:* a BEFORE row trigger that returns NULL
  skips the row, so you get 0 rows updated and no error. Every other column in that UPDATE (`updated_at` too) is lost as well.
- **Validity reverts hit every channel.** *Observed:* L2428, L4842 and L5147 filter on `product` only. This is the same as AEO.
- **Passed-week locks compare against a stale `plan_current`.** *Inferred:* the batch advances `eve_serviceparams.plan_current`
  (`etl-evereve-batch/vsql/weekly/110_internal.sql:29`). The only writer of the row column found in the ETL repo is
  `add_to_assortment` (L1198), so the locks and the `ca_1`/`update_week_indxes` gates use the week the item was added.
- **Exit edits on a passed, non-relaunched item can recurse.** *Observed:* there is no depth guard on that WHEN branch (L18153).
  The git DDL guards the whole clause (`postgres_ap_ddls.sql:4631`). *Inferred:* the revert re-fires on sibling channel rows
  that are still passed. This likely loops to `stack depth limit exceeded` and rolls the save back, instead of quietly reverting.
- **The store-eligibility rebuild runs twice and takes a table lock.** *Inferred:* the second run TRUNCATEs the shared
  `tmp_new`/`tmp_old` (ACCESS EXCLUSIVE until commit), so concurrent lifecycle saves queue behind each other. Rows with
  `plan_type` other than `plan` are not deleted but are re-copied, which risks the PK `(product, time, location, plan_type)` (L17165).
- **Many edits end in a size regeneration.** *Observed:* subclass edit → L5986 → `eve_h_prodstd.ancestor1` →
  `create_hidden_class_ccsizerange_mod()` (L2388, which writes `ccrangecode` unconditionally) → L5566. A PIM style
  assignment (L6379) and a size-run change (L6674) end in the same place. Custom valid sizes reset to the full range.
- **`ccrangecode` must contain ` - CL-`.** *Inferred:* otherwise L5602 asks for a negative-length substring, which raises an
  error and rolls back the save. A NULL code produces a NULL `EXECUTE` string, which also errors.
- **Size-run edits can bounce.** *Inferred from L6702:* a first assignment from NULL, or an edit while `sty_is_locked` is
  non-NULL but not `'Y'`, falls into the revert branch.
- **Editing a stylecolor's name or description renames the style.** *Observed:* L6330 and L6084 copy the value to the parent
  style, then rebuild every sibling as `<style>:<cccolor>`, and L6301 (no depth guard) cascades again. The name suffix uses the
  color's first word after a color change (L6062) but the full color after a style rename (L6312).
- **Two triggers are disabled in QA** (listed at the top of SCHEMA_MAP's trigger section, `off` in the matrix). These are `set_size_id` (L18227) and `enforce_cc_override_trigger`
  (L18145). `trigger_set_size_id()` (L5947) is broken anyway: `eve_ma_sizeattributes` (L11957) has no `size_id` column,
  and the function reads `size_naem`, while `size_ids` has `size_name` (L15672). *Inferred:* re-enabling it (as the git
  DDL does, `postgres_ap_ddls.sql:4656`) would make every size insert fail.
- **Publishing doesn't queue anything outbound.** *Observed:* `trigger_set_publish_timestamp()` (L5926) stamps
  `published_at` **and overwrites `created_at`** each time `dc_publish` is set to 1. EE has no `sync_outbound_dataqueue` and no
  `p_casepack` (AEO queues `RDY4PO`/`PO`).

### Other notable triggers

| Table | Trigger → function | Effect |
|---|---|---|
| `eve_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L5274) | Fires on `str_climate`/`str_grade`/`ssg` only (AEO: 11 columns). SSG and attribute ranging are mutually exclusive; blanks are filled with **all** valid values from `eve_v_memberbasedvalidvalues`. Recomputes `store_count`, then **pushes the ranging to every later floorset**. *Inferred:* with more than one SSG, `store_count` becomes NULL |
| `eve_a_assortment` | `trg_to_update_source_of_ranging_edit` → `reset_plan_type_to_plan()` (L5446) | A top-level `plan_type = 'ranging'` is flipped back to `'plan'` for this floorset and later ones (text comparison on `time`) |
| `eve_h_prodstd` | `trg_update_stylecolorattr_class_suclass_name` (L6628) | An ancestor change on a style refreshes the children's `class_name`/`subclass_name` |
| `eve_p_itemprice` | `trigger_eff_aur` → `update_eff_aur()` (L6133); `itemprice_fetchdepartment` (L5088) | `eff_aur` = `eo`, else the price-event expression, else the current price. Unlike AEO, the current price falls back to `cc_current_price` when `ccticketpricechannel` ≤ 0. Runs twice per edit |
| `cart_params` | `trigger_cartparams_ranging` (L6794) | Rebuilds `cart_ranging` over floorsets in (max(debut, `plan_current`), min(exit, `plan_end`)]. No IRW-offset cart trigger |
| `plan_queue` | `replicate_to_post_run_trigger` (L5403); `on_plan_queue_change` (L5175) | Mirrors every job into `plan_queue_post_run` (its delete-on-complete is commented out). Also LISTEN/NOTIFY, as does `pivot_execution` (L5162) |
| `user_worklist` | `trg_change_product_to_worklist_id` (L2194) | Rewrites `product` to its `worklist_map.worklist_id`, or deletes the row if the user already has it |
| same as AEO | worklist (L5214, L5233), `trg_ai_worklist_map` (L5885), `set_mvv_indx` (L5904), eligibility NULL→0 (L6280), 10 × `set_timestamp_*` (L5969) | `set_timestamp_*` here also covers `eve_d_product` and `eve_h_prodstd` |

**AEO triggers EE lacks:** `trigger_cost`, `trg_cc_validsizes_on_change`, `trigger_sizerangecode_isvalid`, IRW floorset
fields, `trigger_remove_from_assortment`, casepack/PO publish, pack-indicator, store-worklist, overflow-ok and strategy-params
triggers. **Unattached functions:** `calc_store_count_ranging`, `delete_duplicate_invalids`, `null_value_vendor_cost`,
`replicate_and_cleanup`, `sizerangecode_isvalid`, `strip_dollar_sign_msrp`.

## Big procedural code (not triggers)

- `add_to_assortment()` (L240, about 1,780 lines) materializes a cart. It has the same shape as
  `knowledge/backend/ann-add-to-assortment.md`, so read that first. Cart defaults come from `get_default_params()` (L4922):
  `eve_ma_dptflrsetattributes.default_*`, `slsrnk = 3`, `'Copy Rating'`. `s51` (L1193) stamps `plan_current`.
- **Run tracing:** each step runs through `ata_exec()` (L2044), which writes one `ata_trace` row (L8557: SQL, duration, row count)
  and a `RAISE LOG 'ATA[run] …'` line. `ata_snapshot[_q]()` (L2085/L2108) dumps temp tables and the channel rows'
  `ccrangecode`/valid sizes into `ata_debug` (L8542). The run id is a per-call uuid (L373). On failure, the trace rows roll back,
  but the server-log `FAILED` line survives.
- Clone procedures: `eve_no_style_clone_stylecolor_size_proc` (L2502) and `eve_style_clone_stylecolor_size_proc` (L3662)
  stamp `cloned_at` (L2998, L4305), which exempts the rows from the passed-week locks. `eve_plan_these_cloned_style_stylecolors_proc`
  (L3494) plans them. `_dummy` (L4815) is a stub.
- Helpers: `check_is(pre)publishable` (L2235/L2274, identical bodies), `can_remove_from_assortment` (L2160),
  `get_store_count` (L5034), `plan_eligible` (L5254).

## Views and materialized views

- `mfp` and `target_setting` each have `actuals_wide_denorm` and `sys_gen_wide_denorm` MVs (L7340, L8197, L16554, L16908). They change
  only when the batch REFRESHes them. `mfp` carries many `*_bk*`/`*_pre_cal_change`/`*_xfer`/`deleteme*` copies, and the
  `migrate`/`safe_to_delete` schemas are old copies, so don't query them by mistake.
- **Size diagnostics:** `sca_stylecolors_with_size_issues` (L15558), `sca_valid_sizes_mismatch` (L15595) and
  `sca_valid_sizes_not_in_sizeattributes` (L15627) compare the channel `cc_validsizes_*` with the `eve_ma_sizeattributes` rows.
  Others: `plan_status` (L15405), `stylecolor_size_predict_attrs` (L15775).

## Drift since the August dump

The older dump is `customers/EE/postgres_schema.sql` (undated, committed 2026-08-25, pg_dump 14.24). `python3 tooling/db/schema_map.py diff
customers/EE/postgres_schema.sql customers/EE/db/postgres_schema.sql --labels EE-aug EE-oct` reports no table, trigger or WHEN
changes. One routine body changed: `add_to_assortment` (now at L240).

1. **`ccrangecode` now depends on `style_type`** (SUP-3620, L1204). In August, `s51_1` set the price and cost fields on every cart
   stylecolor, and `s51_1a` set `ccrangecode` only where `IS DISTINCT FROM`. In October, `s51_1` (L1212, `existing`) sets
   `ccrangecode` unconditionally plus the price and costs. `s51_1s` (L1229, `similar`) sets the price and costs but **never
   `ccrangecode`**, so similar items keep the code and sizes copied from their source stylecolor. The cost formulas are the same for both:
   `cc_existingwac` and `cc_landed_cost` = `cc_actual_cost`, and `cc_systemcost` = `cc_estimated_cost`. *Inferred:* a row whose
   `style_type` is neither value now gets no price or cost.
2. **Tracing switched on.** Every `EXECUTE sN` became `ata_exec` plus snapshots. The helpers and tables already existed in August but
   weren't called. *Inferred:* `ata_trace`/`ata_debug` grow with each cart add, and no cleanup appears in the dump.

## Triage implications

- **"Lifecycle week reverts on save"** → check the ordering on **every channel row**, and check the passed-week lock
  (old week < row `plan_current`, `cloned_at IS NULL`).
- **"Exit date save errors out"** → the exit-trigger recursion. **"Attribute edit doesn't stick, no error"** → a `*_is_locked = 'Y'` row.
- **"Valid sizes reset / size DC adjustments gone"** → what wrote `ccrangecode`: a size-run, subclass or PIM edit, or the ATA `existing`
  path. Run the `sca_*` views, and read `ata_debug`.
- **"DC user adjustments disappeared"** → was MD moved, even invalidly (`lifecycle_plan_update`)?
- **"IRW / last DC order wrong"** → IRW = debut and last DC order = MD − 6, set only on a valid UPDATE, never on INSERT.
- **"cc_floorset / fulfillment blank after a debut edit"** → no `eve_l_dependencylookup` row for that week.
- **"Style renamed when I edited a colour"** → the `eve_d_product` triggers. **"Later floorsets' ranging changed"** → `propagate_assortment_to_floorsets`.
- **"Add to assortment failed"** → `ata_trace` by run id, plus the `ATA[...]` lines in the server log.
- **"Lifecycle saves hang with several planners"** → the `tmp_new`/`tmp_old` lock. **"Bulk vs UI edit differs"** → the depth guards.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, run `python3 tooling/db/schema_map.py regen` (this refreshes SCHEMA_MAP
and the matrix), then diff against this dump with `schema_map.py diff` to catch manual DDL drift.
