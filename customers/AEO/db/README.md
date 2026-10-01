# AEO Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `aeo`, server 14.22, dumped 2026-10-01 (pg_dump 18.6,
plain, schema-only). **Prod/Staging not captured.** Sibling tenants AER,
TSN, UNS are in `aer/`, `tsn/`, `uns/` next to this file (see "Sibling
tenants" below). Generated object-level map: `SCHEMA_MAP.md`.

Contents: 232 tables, 50 triggers, 55 functions + 5 procedures, 18 views,
8 materialized views across schemas `public` (161 tables), `mfp` (20),
`mfp_channel_plan` / `mfp_long_range` / `mfp_total_aeo` (17 each). Grep
the dump for full bodies; this file is the map. Line numbers below are
`postgres_schema.sql` lines.

Hierarchy convention (from function bodies): for a stylecolor row in
`aeo_h_prodstd`, `ancestor0` = style, `ancestor1` = subclass, `ancestor2` =
class, `ancestor3` = department.

## The hidden business-logic layer: triggers

None of this is in any git repo. When a value "changes by itself", reverts,
or a save "doesn't stick", look here first. **Observed** = read from the DDL.
**Inferred** = derived from trigger semantics, not yet confirmed with data.

**5 triggers are DISABLED in QA** (they exist but never fire): the 3
worklist publish/unpublish triggers and the 2 store-worklist
allocation-qty triggers (see "Other notable triggers"). All 15
channel-attribute triggers below are enabled. `SCHEMA_MAP.md` lists
disabled triggers at the top of its trigger section. Before blaming a
trigger, check it's enabled in the environment you're looking at.

### aeo_ma_stylecolorchannelattributes — 15 triggers (the hot spot)

PK `(product, location)`.

| Trigger | Fires on | WHEN | Function → effect |
|---|---|---|---|
| `md_trigger_on_update` | AFTER UPDATE OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut) OR exit ≤ MD; depth=0 | `md_trigger_on_update_validity_check()` (L6821) → **`SET erlstmkdnwk = OLD.erlstmkdnwk`** (undo) |
| `exit_trigger_on_update` | AFTER UPDATE OF `exitdate` | exit ≤ MD; depth=0 | `exit_trigger_on_update_validity_check()` (L6160) → **`SET exitdate = OLD.exitdate`** |
| `dbt_trigger_on_update` | AFTER UPDATE OF `dbt_wk` | debut ≥ MD; depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L6065) → **`SET dbt_wk = OLD.dbt_wk`**. No "passed debut is locked" rule (BOD has one) |
| `ca_1_trigger_on_update` | AFTER UPDATE OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit; depth=0 | `store_eligibility_trigger()` (L7408) → rebuilds the item's `aeo_a_assortment` plan rows across floorsets overlapping [relaunch ?? debut, exit] in `aeo_ma_dptflrsetattributes` (copies ranging from the nearest existing floorset), then sets `isfunded = 1` on the floorset containing `dbt_wk` |
| `trigger_for_time_indx` | AFTER INSERT OR UPDATE OF `dbt_wk, relaunchweek, erlstmkdnwk, exitdate` | (none) | `update_week_indxes()`, see below |
| `trigger_for_time_indx_insert` | AFTER INSERT | (none) | `update_week_indxes()` again |
| `trigger_for_time_indx_update` | AFTER UPDATE OF the same 4 weeks | valid ordering | `update_week_indxes()` again |
| `trigger_lifecycle_plan_update` | AFTER UPDATE OF `erlstmkdnwk` | (none, no depth guard) | `lifecycle_plan_update()` (L6786) → **NULLs `dc_uservrp`/`dc_useradj`** in `aeo_p_dc_adj` (product) and `aeo_p_dc_adj_size` (its sizes) for `time >= new MD` |
| `trg_set_floorset_fields_on_initrcptwk_change` | BEFORE INSERT OR UPDATE OF `initrcptwk` | depth=0 | `set_floorset_fields_on_initrcptwk_change()` (L7172) → fills `irw_superset[_display]`, `irw_floorset[_id/_display]` from the department floorset whose `rcptstart..rcptend` contains IRW |
| `trg_cc_validsizes_on_change` | BEFORE UPDATE OF `ccrangecode, use_valid_sizes_from, cc_size_eligibility_profile` | depth < 2 | `update_cc_validsizes_on_ccrangecode()` (L7857) → sets `cc_validsizes_store/ecom` from `aeo_l_sizeeligibility_with_ccrangecode` (profile, or `is_default=1` for 'Defaults – All Valid Sizes'; 'Model – All Valid Sizes' clears the profile) |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | (none) | `sizerangecode_validsizes_members()` (L7300) → **regenerates size members**: rewrites `aeo_ma_sizeattributes`, inserts/deletes `aeo_d_product` + `aeo_h_prodstd` size rows, NULLs `aeo_p_dc_adj_size.dc_useradj` for now-invalid sizes |
| `trigger_sizerangecode_isvalid` | AFTER UPDATE OF `validsizes` | (none) | `sizerangecode_isvalid()` (L7248) → resets `aeo_ma_sizeattributes.isvalid` for the stylecolor from **this row's** `validsizes` |
| `trigger_cost` | AFTER UPDATE OF `cc_plan_cost` | (none) | `trigger_final_cost()` (L7635) → `cc_final_cost = cc_plan_cost`, recomputes `cc_imupct` |
| `trigger_remove_from_assortment` | AFTER UPDATE OF `record_state` | `new.record_state = 1` | `remove_from_assortment()` (L7043) → **effectively a no-op** (observed: `v_specstyleid` is never assigned, so its only UPDATE never runs) |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | (always) | `trigger_set_timestamp()` → `updated_at`. Reliable freshness signal |

#### update_week_indxes() (L8435): what a lifecycle save also changes

1. It converts debut (`relaunchweek` if set, else `dbt_wk`), relaunch, MD
   (`erlstmkdnwk`) and exit to `aeo_d_time.indx`.
2. **IRW** = debut − `irw_debut_offset`. The offset comes from
   `aeo_ma_dptflrsetattributes`, joined on the department (`ancestor3`),
   for the floorset whose `ap_start..ap_end` contains `dbt_wk`. This sets
   `initrcptwk`.
3. **Last DC order** = MD − 4, which sets `lastdcorder` and `last_rcpt_wk`.
   TRD also uses MD − 4; BOD uses MD − 6. The function only takes the
   MD − 4 path when `auto_rollforward = FALSE`. When it is TRUE **or
   NULL**, last DC order is MD − 1 instead, and the function also sets
   `planned_sell_down_week` (Observed: `IF new.auto_rollforward = FALSE …
   ELSE`).
4. `too` = MD − debut (weeks at full price) and `mkdnwks` = exit − MD.
   Both are counted from relaunch when one is set.
5. Moving `dbt_wk` while `OLD.dbt_wk = OLD.act_dbt_wk` also moves
   `act_dbt_wk`.
6. Steps 2–4 only run when `dbt_wk < MD < exit`. This check uses raw
   `dbt_wk`, while the trigger's WHEN clause checks relaunch-aware ordering.

### Quirks worth knowing (all from the DDL)

- **Validity reverts hit every channel.** *Observed:* the three
  `*_validity_check()` functions run `UPDATE … WHERE product = NEW.product`
  with no `location` filter. One bad edit on one channel resets that column
  on all of the stylecolor's channel rows to the edited row's OLD value.
  `trigger_final_cost` also has no location filter.
- **Moving MD wipes user DC adjustments.** *Observed:* `lifecycle_plan_update`
  has no WHEN clause and no depth guard. *Inferred:* an invalid MD edit
  still wipes adjustments from the invalid week onward. The revert's own
  UPDATE (`erlstmkdnwk` = old value) then fires it again from the old MD.
- **`update_week_indxes` runs twice per event.** *Observed:* on INSERT,
  `_indx` and `_indx_insert` both fire. On a valid UPDATE, `_indx` and
  `_indx_update` both fire. *Inferred:* this is harmless (same OLD/NEW,
  same writes) but doubles the write load.
- **IRW floorset fields can go stale.** *Inferred:* `initrcptwk` is
  recomputed inside `update_week_indxes`, at trigger depth 1. The floorset
  trigger requires depth = 0, so it doesn't fire then. After a debut move,
  `irw_floorset*`/`irw_superset*` can still describe the old IRW. On INSERT
  they're set only if the inserting statement supplies `initrcptwk` itself.
- **Changing `ccrangecode` is destructive.** It deletes and recreates
  size-level products and clears size DC user adjustments (see
  `sizerangecode_validsizes_members` above).

### Other notable triggers

| Table | Trigger → function | Effect |
|---|---|---|
| `aeo_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L6930) | On a ranging attribute change (`str_grade/climate/region_combo/hvlc/tourist_border_combo`, `ssg`, `*_or`): makes SSG and attribute ranging mutually exclusive (switching to attributes fills blanks with `aeo_ma_dptflrsetattributes.default_*`), recomputes `store_count` (`get_store_count()`, or SSG cardinality from `aeo_l_ssglookup`), and **pushes the ranging forward to every later floorset** of that product/location |
| `aeo_ma_styleattributes` | `update_ccrangecode` → `update_stylecolorchannelattributes_ccrangecode()` (L8275) | `sty_size_range` change → child stylecolors get `ccrangecode = <range> - <class>` + valid sizes (which cascades into the size-member regeneration above). Its "already equal?" guard compares against `ancestor1` (subclass) while the value it writes uses `ancestor2` (class). *Inferred:* the guard therefore never short-circuits |
| `aeo_h_prodstd` | `update_ccsizerange_after_class_change_ancestor1` → `update_ccrangecode_on_class_change()` (L7948) | Style moved to a new class (`ancestor1 LIKE 'CL-%'`) → children's `ccrangecode` rebuilt |
| `aeo_ma_stylecolorattributes` | `trig_upd_on_color_change` → `update_color_change()` (L7991) | `cccolor` change → color code/family/name/id/group pulled from `aeo_l_dependencylookup`. `aeo_d_product` is rewritten: name = `<style name><color code>` (no separator) and description = `<style description>:<color name>`. Blank color gives name `<style name> NoColor` and description `<style description> No Color` |
| `aeo_d_product` | `trigger_upd_name_description` → `update_name_description()` (L8240) | Style rename → child stylecolor names/descriptions and `aeo_ma_stylecolorattributes.stylecolor_name/style_name` |
| `aeo_p_itemprice` | `trigger_eff_aur` → `update_eff_aur()` (L8072); `trigger_itemprice_fetchdepartment` | `eff_aur` = `eo` override, else the `aeo_l_priceeventlookup` expression applied to `ccticketpricechannel`, else ticket price |
| `aeo_p_dc_adj` | `set_timestamp_p_dc_publish_adj[_ins]` → `trigger_set_publish_timestamp()` (L7765) | `dc_publish = 1` → stamps `published_at`, queues **`RDY4PO`** to `sync_outbound_dataqueue`, sets `cc_first_publish_date` (first time only) on the channel rows |
| `aeo_p_casepack` | `set_timestamp_cp_publish[_ins]` → `trigger_set_cp_publish_timestamp()` (L7666) | `po_status = 1` queues **`PO`** to `sync_outbound_dataqueue` **only if** the matching `aeo_p_dc_adj.dc_publish = 1`. Otherwise it **forces `po_status` back to 0**. This is the "PO publish won't stick" rule |
| `aeo_p_dc_adj` / `_size` | `set_pack_ind_flag`, `set_dc_ttluseradj_p_dc_adj_size` | Pack indicator from `reason_code`; size total user adjustment |
| `aeo_p_stylecolor_store_worklist` | `trg_sync_alloc_and_override_trigger`, `trg_update_alloc_qty`: **both DISABLED in QA** (L20149, L20167) | Would set allocation qty = sum of the size-override array. Because they're disabled, qty and the override array are **not** kept in sync by the DB |
| `aeo_p_stylecolor_worklist` | `on_(un)publish_remove_from_worklist*`: **all 3 DISABLED in QA** (L19951, L19961, L19971) | Would react to `in_worklist` 0↔1 transitions. Disabled, so publishing doesn't remove items from the worklist at the DB level |
| `aeo_ma_departmentalloc_attributes`, `aeo_ma_stylecolor_alloc_attributes` | `trg_(sclr_)allow_scaling_set_overflow_ok` | Turning on allow-scaling also forces overflow-ok on |
| `aeo_p_stylecolor_store_eligibility` | `trg_update_eligibility_from_null_to_zero` | NULL eligibility → 0 |
| `aeo_p_strategy_params` | `trg_p_strategy_params_set_apply_targets` | Carryover/Future floorsets → `apply_targets_to_plan = NULL` |
| `worklist_map` | `trg_ai_worklist_map` | Seeds `aeo_ma_stylecolor_alloc_attributes` row |
| `aeo_v_memberbasedvalidvalues` | `set_mvv_indx` | Sets `indx` on insert |
| `cart_params` | `trigger_cartparams_irw_debut_offset` (L8324), `trigger_cartparams_ranging` (L8354) | Add-to-assortment cart: IRW = debut − `irw_debut_offset`. `cart_ranging` is rebuilt across floorsets in [max(debut, `plan_current`), min(exit, `plan_end`)] |
| `pivot_execution` / `plan_queue` | `on_*_change` → `notify_*_change()` | **LISTEN/NOTIFY**: the backend's eventing for pivot runs and the plan queue |
| 8 tables | `set_timestamp_*` → `trigger_set_timestamp()` | `updated_at` maintenance (`a_assortment`, `ma_style/stylecolor/sizeattributes`, channelattributes, `p_channeloverride`, `p_dc_adj[_size]`) |

Unattached trigger functions (dead code, or attached manually in other
envs, so check before trusting): `calc_store_count_ranging`,
`delete_duplicate_invalids`, `reset_to_prev_if_approved`,
`revert_to_original`, `trigger_set_size_id`, `update_cc_use_sys_floorset`.

## Big procedural code (not triggers)

- `add_to_assortment()` (L320, ~2,200 lines) materializes a cart into the
  plan. It has the same shape as the ann/KWG procedure in
  `knowledge/backend/ann-add-to-assortment.md`, so read that first.
- Clone procedures: `aeo_style_clone_stylecolor_size_proc` (L4289) and
  `aeo_no_style_clone_stylecolor_size_proc` (L2494), about 1.6k lines
  each, plus `aeo_plan_these_cloned_style_stylecolors_proc` (L4104).
- Helpers: `get_default_params`, `get/fetch_store_count`,
  `check_is(pre)publishable`, `can_remove_from_assortment`,
  `plan_eligible`.

## Materialized views (the MFP serving layer)

Each MFP schema (`mfp`, `mfp_channel_plan`, `mfp_long_range`,
`mfp_total_aeo`) has the same pattern:
- `actuals_wide_denorm` = `actuals_wide` joined to the `time_denorm`,
  `product_denorm` (on class) and `location_denorm` (on alt_country) views
- `sys_gen_wide_denorm` = the same, over `sys_gen_wide`

Like TRD, these only change when the batch REFRESHes them. "MFP numbers
stale" usually means the refresh step didn't run. `mfp` and
`mfp_total_aeo` also carry `*_bkp_0911` backup tables (dimensions,
hierarchies, tyly).

## Platform (non-`aeo_`) tables in `public`

There are 64 of them: carts (`cart_*`, `ata_cart_*`, with `_archive`
twins), `plan_queue`, `pivot_execution`, `scope`, `undo_*`, `user_*`,
`bulk_import_*`, `sync_outbound_dataqueue` (outbound interface queue),
`dept_plan_items*`, and liquibase `databasechangelog`.

## Triage implications

- **"MD/Exit/Debut week reverts on save"** → the validity triggers. Check
  the ordering (relaunch ?? debut) < MD < exit for **every channel row** of
  the stylecolor; a revert applies across all channels.
- **"DC user adjustments disappeared"** → was MD moved (even invalidly)?
  Or was `ccrangecode`/size range changed? See `lifecycle_plan_update` and
  `sizerangecode_validsizes_members`.
- **"IRW floorset shows the wrong floorset after a debut change"** → the
  depth-guard staleness above.
- **"PO publish won't stick"** → `aeo_p_dc_adj.dc_publish` must be 1
  first.
- **"Bulk update behaves differently than a UI edit"** → the
  `pg_trigger_depth()` guards, plus any ETL `enable/disable trigger`
  calls.
- **"Store count / ranging changed on later floorsets"** →
  `propagate_assortment_to_floorsets` pushes the ranging forward.
- `updated_at` is trigger-maintained on the 8 tables above, so it is
  reliable for freshness checks there.

## Sibling tenants: AER, TSN, UNS

Each has its own database (`aer`, `tsn`, `uns`), but they use the **same
`aeo_` table prefix and the same five schemas**. Dumps and generated maps
are in `aer/`, `tsn/` and `uns/`. Each `SCHEMA_MAP.md` ends with a diff
against AEO.

Observed, from the 2026-10-01 dumps:
- **Triggers and functions are identical to AEO.** No trigger, WHEN clause
  or function body differs. Everything above applies to all four tenants,
  and a trigger/function fix made in `aeo` can be replayed as-is.
- **AEO has extra tables the siblings lack.** Most are backups
  (`*_bkp*`, `*_20260512`), but they also include **`bulk_import_audit`
  and `bulk_import_run_params`**. A fix touching bulk import won't find
  those tables in AER/TSN/UNS. AEO also has the unattached
  `update_cc_use_sys_floorset()`.
- **AER, TSN and UNS are identical to each other** apart from one column
  default holding a 2026-09-14 creation timestamp. *Inferred:* all three
  were created from the same template that day. Aerie-named columns
  (`str_aerie_*`) exist in all four tenants, AEO included. The schema is
  shared, not tailored to each brand.

Replicating an AEO fix: run
`python3 tooling/db/schema_map.py diff customers/AEO/db/postgres_schema.sql customers/AEO/db/<tenant>/postgres_schema.sql`
on a fresh dump first. These tenants can drift.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md` (plain format,
schema-only). Diff against this dump to catch manual DDL drift, then
regenerate the maps and the cross-client matrix with
`python3 tooling/db/schema_map.py regen`. ClickHouse and Vertica schemas
for AEO are not captured yet.
