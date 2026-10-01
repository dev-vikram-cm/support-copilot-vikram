# TRD Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA** (the `internal-qa` env; config bucket `internal-qa-config`,
see `customers/TRD/profile.md`), db `trd`, server 14.22, dumped 2026-10-01
(pg_dump 18.6, plain, schema-only). Same env as the previous dump of
2026-07-09 (server 14.17); what changed is under
[Drift since 2026-07-09](#drift-since-2026-07-09). **Prod/Staging not
captured.**

Contents (from [SCHEMA_MAP.md](SCHEMA_MAP.md)): 428 tables, 54 triggers on
23 tables (5 of them DISABLED, see
[Disabled triggers](#disabled-triggers-defined-but-never-fire-in-qa)), 62
functions + 8 procedures, 20 views, 6 materialized views, 40
indexes, 11 sequences, 12 types. Schemas: `public` 341 tables, `mfp` 32,
`mfp_td` 32, `target_setting` 23. About 117 of the `public` tables are
backups or scratch copies by name (`deleteme_*`, `*_bkp*`, date-suffixed,
`sup####_*`); ignore them unless a ticket names one.

SCHEMA_MAP.md is the generated object list (every trigger, view and large
routine with its line). This file is the hand-written account of what the
logic does. `Lnnn` = line in `postgres_schema.sql`.

Hierarchy convention (from function bodies): for a stylecolor row in
`trd_h_prodstd`, `ancestor0` = style, `ancestor1` = subclass, `ancestor2` =
class, `ancestor3` = department (L6130, L6256, L10552, L10776). For a style
row, `ancestor0` = subclass (L10370) and `ancestor1` = class (`'CL-%'`,
L26539).

## The hidden business-logic layer: triggers

None of this is in any git repo. When a value "changes by itself", reverts,
or a save "doesn't stick", look here first. **Observed** = read from the DDL.
**Inferred** = derived from trigger semantics, not yet confirmed with data.

### Disabled triggers (defined but never fire in QA)

*Observed:* the dump disables five triggers right after creating them.
SCHEMA_MAP.md and the trigger matrix list them without saying so.

| Table | Trigger (DISABLE line) | Would do if enabled |
|---|---|---|
| `trd_p_stylecolor_worklist` | `on_publish_remove_from_worklist_trigger` (L26155), `on_publish_remove_from_worklist_trigger_insert` (L26165) | `on_publish_remove_from_worklist()` (L5925): delete the item from the user's `user_worklist` when `in_worklist` becomes 1 |
| `trd_p_stylecolor_worklist` | `on_unpublish_remove_from_worklist_trigger` (L26175) | `on_unpublish_remove_from_worklist()` (L5944): put it back when `in_worklist` goes 1 → 0 |
| `trd_p_stylecolor_store_worklist` | `trg_sync_alloc_and_override_trigger` (L26353), `trg_update_alloc_qty` (L26387) | `trg_sync_alloc_and_override()` (L9687) / `trg_sum_override_array()` (L9663): set the allocation qty to the sum of the size-override array, and clear the override arrays when a qty is typed with no prior overrides |

The same five were disabled in the July dump, and AEO's QA dump disables the
same five. So in QA nothing in the database keeps `user_worklist` in step
with publish/unpublish, or keeps `sclr_loc_wrk_alloc_sclr_qty` equal to the
size-override sum. *Inferred:* if that happens at all, the app or a batch
does it. Other envs may differ: check `pg_trigger.tgenabled` (`'D'` =
disabled) in the target env before assuming a trigger fires.

### Shared with AEO

Per `knowledge/db-trigger-matrix.md`, 39 of TRD's 54 triggers are identical
to AEO's (same events, WHEN and function body; the matrix does not look at
enabled/disabled). That includes the core
lifecycle set on `trd_ma_stylecolorchannelattributes`: the three validity
reverts (`md_` / `exit_` / `dbt_trigger_on_update`),
`trigger_lifecycle_plan_update`, the three `trigger_for_time_indx*`
triggers, `trg_set_floorset_fields_on_initrcptwk_change` and
`trigger_sizerangecode_isvalid`. The quirks written up in
[`customers/AEO/db/README.md`](../../AEO/db/README.md) for those triggers
therefore apply to TRD too. Re-checked in TRD's own DDL: the validity
reverts have no location filter (L5117, L5212, L5880), and
`lifecycle_plan_update` has no WHEN clause and no depth guard (L26491,
L5848–L5862). See Quirks below.

11 triggers exist in both but differ, so read the TRD rows below, not AEO's.
Five are on channel attributes: `ca_1_trigger_on_update`,
`trigger_sizerangecode_validsizes_members`, `trigger_cost`,
`trg_cc_validsizes_on_change`, `trigger_remove_from_assortment`. The other
six: `trg_upd_assortment_ranging`, both `set_timestamp_p_dc_publish_adj*`,
`trigger_upd_name_description`, `trig_upd_on_color_change`,
`trigger_cartparams_ranging`. Four TRD triggers have no AEO counterpart:
`trig_upd_on_ticketprice`, `trg_upd_specstyleid`, `trg_upd_specstylecolor`,
`trg_update_cc_floorset`.

### trd_ma_stylecolorchannelattributes — 15 triggers (the hot spot)

PK `(product, location)` (L25426). Trigger DDL at L26105–L26515.

| Trigger | Fires on | WHEN | Function → effect |
|---|---|---|---|
| `md_trigger_on_update` | AFTER UPDATE OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut) OR exit ≤ MD; depth=0 | `md_trigger_on_update_validity_check()` (L5876) → **`SET erlstmkdnwk = OLD.erlstmkdnwk`** on every channel row of the product |
| `exit_trigger_on_update` | AFTER UPDATE OF `exitdate` | exit ≤ MD; depth=0 | `exit_trigger_on_update_validity_check()` (L5208) → **`SET exitdate = OLD.exitdate`**, all channels |
| `dbt_trigger_on_update` | AFTER UPDATE OF `dbt_wk` | `dbt_wk` ≥ MD; depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L5113) → **`SET dbt_wk = OLD.dbt_wk`**, all channels |
| `ca_1_trigger_on_update` | AFTER UPDATE OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit; depth=0 | `store_eligibility_trigger()` (L6541) → deletes this product/location's `plan_type='plan'` rows in `trd_a_assortment` and rebuilds them for every department floorset whose `ap_start..ap_end` overlaps [relaunch ?? debut, exit], copying ranging from the nearest existing floorset. Then sets `isfunded = 1` on the floorset containing `dbt_wk`; that UPDATE (L6602) has no location filter |
| `trigger_for_time_indx` | AFTER INSERT OR UPDATE OF `dbt_wk, relaunchweek, erlstmkdnwk, exitdate` | (none) | `update_week_indxes()` (L10746), see below |
| `trigger_for_time_indx_insert` | AFTER INSERT | (none) | `update_week_indxes()` again |
| `trigger_for_time_indx_update` | AFTER UPDATE OF the same 4 weeks | valid ordering; no depth guard | `update_week_indxes()` again |
| `trigger_lifecycle_plan_update` | AFTER UPDATE OF `erlstmkdnwk` | (none, no depth guard) | `lifecycle_plan_update()` (L5841) → **NULLs `dc_uservrp`/`dc_useradj`** in `trd_p_dc_adj` (product) and `trd_p_dc_adj_size` (its sizes) for `time >= new MD` |
| `trg_set_floorset_fields_on_initrcptwk_change` | BEFORE INSERT OR UPDATE OF `initrcptwk` | depth=0 | `set_floorset_fields_on_initrcptwk_change()` (L6238) → fills `irw_superset[_display]`, `irw_floorset[_id/_display]` from the department floorset whose `rcptstart..rcptend` contains IRW |
| `trg_cc_validsizes_on_change` | BEFORE UPDATE OF `ccrangecode, use_valid_sizes_from, cc_size_eligibility_profile` | depth < 2 | `update_cc_validsizes_on_ccrangecode()` (L9951) → 'Model – All Valid Sizes' clears the profile; a profile change rebuilds `cc_validsizes_store/ecom` from `trd_l_sizeeligibility_with_ccrangecode`; 'Defaults – All Valid Sizes' rebuilds from `is_default = 1` rows. The "ccrangecode changed" branch is commented out (L9998), so a `ccrangecode` change alone rebuilds valid sizes **only** when `use_valid_sizes_from` = 'Defaults – All Valid Sizes' |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | (none) | `sizerangecode_validsizes_members()` (L6436) → **regenerates size members** from `trd_l_dependencylookup` + `trd_size_range_mapping`: sets all children `isvalid = 0`, deletes and reinserts `trd_ma_sizeattributes` rows, adds `trd_d_product` + `trd_h_prodstd` rows for new sizes, NULLs `trd_p_dc_adj_size.dc_useradj` for now-invalid sizes |
| `trigger_sizerangecode_isvalid` | AFTER UPDATE OF `validsizes` | (none) | `sizerangecode_isvalid()` (L6384) → resets `trd_ma_sizeattributes.isvalid` for the stylecolor from **this row's** `validsizes` |
| `trigger_cost` | AFTER UPDATE OF `cc_plan_cost, cc_systemcost` | (none) | `trigger_final_cost()` (L9721) → `cc_final_cost` = `cc_systemcost` if > 0, else `trd_ma_stylecolorattributes.cc_unit_cost` if > 0, else `cc_plan_cost`; then `cc_imupct` = (ticket − final) / ticket. Both writes are product-wide and use this row's ticket price. A zero-ticket guard was added after July (see Drift) |
| `trigger_remove_from_assortment` | AFTER UPDATE OF `record_state` | `new.record_state = 1` | `remove_from_assortment()` (L6109) → skipped if `cloned_at` is set. Otherwise clears the spec-stylecolor link (`cc_vpn_color`) and returns it to the `trd_l_dependencylookup` pool; if no active channel rows remain under the style, also clears `trd_ma_styleattributes.sty_vpn`. AEO's version is a no-op; TRD's does real work |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | (always) | `trigger_set_timestamp()` (L9912) → `updated_at` (batch loads disable it, see Quirks) |

#### update_week_indxes() (L10746): what a lifecycle save also changes

1. Converts debut (`relaunchweek` if set, else `dbt_wk`), relaunch, MD
   (`erlstmkdnwk`) and exit to `trd_d_time.indx` (L10766–L10770).
2. **IRW** = debut − `irw_debut_offset`. The offset comes from the
   department's (`ancestor3`) floorset in `trd_ma_dptflrsetattributes`
   whose `ap_start..ap_end` contains raw `dbt_wk` (L10772–L10780). This
   sets `initrcptwk`.
3. **Last DC order** = MD − 4, written to `lastdcorder` and `last_rcpt_wk`
   (L10781). If `auto_rollforward` is not FALSE it is MD − 1 instead, and
   `planned_sell_down_week` is set too (L10786, L10802–L10837). The test is
   `= FALSE`, so NULL takes the roll-forward branch; the column defaults to
   false (L13598).
4. `too` = MD − debut and `mkdnwks` = exit − MD (L10812–L10813).
5. Moving `dbt_wk` while `OLD.dbt_wk = OLD.act_dbt_wk` (and new debut < MD)
   also moves `act_dbt_wk` (L10790–L10798).
6. Steps 2–4 run only when `dbt_wk < MD < exit` on raw `dbt_wk` (L10800),
   while the trigger's WHEN uses relaunch-aware ordering. All writes here
   filter on product **and** location.

### Quirks worth knowing (all from the DDL)

- **Validity reverts hit every channel.** *Observed:* the three
  `*_validity_check()` functions run `UPDATE … WHERE product = NEW.product`
  with no `location` filter (L5117, L5212, L5880). One bad edit on one
  channel resets that column on all of the stylecolor's channel rows to the
  edited row's OLD value. `trigger_final_cost` is product-wide too
  (L9732–L9745).
- **Moving MD wipes user DC adjustments.** *Observed:* no WHEN clause and
  no depth guard (L26491; body L5848–L5862). *Inferred:* an invalid MD edit
  still wipes adjustments from the invalid week onward, and the revert's own
  UPDATE then fires it again from the old MD.
- **`update_week_indxes` runs twice per event.** *Observed:* an INSERT fires
  L26459 and L26467; a valid UPDATE fires L26459 and L26475. *Inferred:*
  harmless (same writes) but doubles the write load.
- **IRW floorset fields can go stale.** *Inferred:* `initrcptwk` is written
  by `update_week_indxes`' own UPDATE (L10814, L10832) at trigger depth 1,
  but the floorset trigger requires depth = 0 (L26327). After a debut move,
  `irw_floorset*`/`irw_superset*` can still describe the old IRW.
- **Changing `ccrangecode` is destructive.** It deletes and recreates size
  members and clears size DC user adjustments (L6482–L6527).
- **Batch loads skip triggers.** *Observed* in the local etl-trd-batch clone
  (branch `graph_db_validation`, not the QA branch):
  `pgsql/daily/load_pgsql.sql` and `pgsql/weekly/load_pgsql.sql` disable
  and re-enable 11 triggers, including `set_timestamp_styleclrchannel`,
  `trigger_cost`, `md_`/`exit_`/`ca_1_trigger_on_update`,
  `trigger_for_time_indx[_insert]`, `trigger_lifecycle_plan_update` and both
  size-range triggers. *Inferred:* channel-row `updated_at`,
  `cc_final_cost` and `cc_imupct` reflect UI edits, not batch loads.
- **Linking a spec stylecolor cascades.** *Observed:*
  `update_specstylecolor_id()` (L10427) reverts the edit if another
  stylecolor already holds that `cc_vpn_color` (L10441–L10445). Otherwise
  it sets `cc_systemcost` = unit cost + freight + duty on all channels
  (L10462–L10466), which fires `trigger_cost`; overwrites about 30 `cc_*`
  attributes plus `cccolor` from `trd_ma_specstylecolorattributes`
  (L10468–L10508), which fires the color-change trigger; and replaces the
  image, archiving the old one (L10510–L10519).
- **Linking a spec style blanks `sty_vpn_desc`.** *Observed:*
  `update_specstyle_id()` selects 17 columns into 18 targets, the last one
  being `NEW.sty_vpn_desc` (L10402–L10407). *Inferred:* PL/pgSQL fills the
  missing value with NULL. The function that would set it,
  `set_sty_vpn_desc_on_update()` (L6314), is not attached to any trigger.
- **Removing an item probably returns its spec color to the pool twice.**
  *Inferred:* `remove_from_assortment()` NULLs `cc_vpn_color`
  (L6133–L6135), which fires `update_specstylecolor_id()` and inserts the
  old pair into `trd_l_dependencylookup` (L10450–L10454). It then inserts
  the same pair itself (L6139–L6140).

### Other notable triggers

| Table | Trigger → function | Effect |
|---|---|---|
| `trd_ma_stylecolorattributes` | `trig_upd_on_ticketprice` → `update_ticket_price()` (L10587) | BEFORE UPDATE OF `cc_orig_unit_retail`. When retail changes: sets `cc_orig_unit_retail_char` (new since July), copies retail to every channel's `ccticketpricechannel`, looks up CAD price and price band (`trd_l_ticketprice`, by department) and good/better/best (`trd_l_pricebandlookup`, by subclass), recomputes `cc_imupct` on all channels, and touches `trd_p_itemprice` so `trigger_eff_aur` recomputes `eff_aur` (SUP-2549) |
| `trd_ma_stylecolorattributes` | `trig_upd_on_color_change` → `update_color_change()` (L10085) | `cccolor` change → color id/family/web description from `trd_l_dependencylookup`, `cc_item_diff_1 = cccolor`; `trd_d_product` name/description = `<style> <color>`. A blank color gives name `<style> NoColor`, description `<style> No Color`, and NULLs the color fields |
| `trd_ma_stylecolorattributes` | `trg_upd_specstylecolor` → `update_specstylecolor_id()` (L10427) | Spec-stylecolor link; see Quirks |
| `trd_ma_stylecolorattributes` | `trg_update_cc_floorset` → `update_cc_use_sys_floorset()` (L9929) | Setting `cc_floorset` → `cc_use_sys_floorset = FALSE`; clearing it → TRUE |
| `trd_ma_styleattributes` | `trg_upd_specstyleid` → `update_specstyle_id()` (L10360) | `sty_vpn` change: a duplicate is silently reverted (L10377). Otherwise NULLs `cc_vpn_color` on all child stylecolors (each fires the spec-stylecolor trigger) and pulls PLM attributes from `trd_ma_specstyleattributes` |
| `trd_ma_styleattributes` | `update_ccrangecode` → `update_stylecolorchannelattributes_ccrangecode()` (L10538) | `sty_size_range` change → child channel rows get `ccrangecode = <range> - <class (ancestor2)>` and `cc_validsizes_store/ecom` from `trd_l_dependencylookup`, which cascades into the size-member regeneration. The "already equal?" guard compares against `ancestor1` (L10566). *Inferred:* it never short-circuits |
| `trd_h_prodstd` | `update_ccsizerange_after_class_change_ancestor1` → `update_ccrangecode_on_class_change()` (L10042) | Style moved to a new class (`ancestor1 LIKE 'CL-%'`) → children's `ccrangecode` rebuilt |
| `trd_d_product` | `trigger_upd_name_description` → `update_name_description()` (L10325) | Style rename → child stylecolor name/description = `<style> <cc_web_color_discription>`, plus `trd_ma_stylecolorattributes.stylecolor_name/style_name`. The compare is not NULL-safe (L10333) |
| `trd_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L5985) | Ranging attribute change: SSG and attribute ranging are mutually exclusive (switching to attributes fills blanks from `trd_ma_dptflrsetattributes.default_*`); `store_count` from `get_store_count()` or SSG cardinality (`trd_l_ssglookup`); then **pushes the ranging to this and every later floorset** of the product/location (L6076–L6093) |
| `trd_p_dc_adj` | `set_timestamp_p_dc_publish_adj[_ins]` → `trigger_set_publish_timestamp()` (L9858) | `dc_publish = 1` → stamps `created_at`/`published_at`/`published_by`, queues **`RDY4PO`** to `sync_outbound_dataqueue`, and (new since July) sets `cc_first_publish_date` once on all channel rows |
| `trd_p_casepack` | `set_timestamp_cp_publish[_ins]` → `trigger_set_cp_publish_timestamp()` (L9759) | `po_status = 1` queues **`PO`** only if the matching `trd_p_dc_adj.dc_publish = 1`; otherwise it **forces `po_status` back to 0**. This is the "PO publish won't stick" rule |
| `trd_p_dc_adj` / `_size` | `set_pack_ind_flag` (L9835), `set_dc_ttluseradj_p_dc_adj_size` (L9796) | `reason_code = 'Initial'` → `pack_ind_flag = 'TRUE'`; `dc_ttluseradj = dc_useradj + dc_useradj_ecom` (NULL if either is NULL) |
| `trd_p_itemprice` | `trigger_eff_aur` → `update_eff_aur()` (L10157); `trigger_itemprice_fetchdepartment` (L5821) | `eff_aur` = `eo` override, else the `trd_l_priceeventlookup` expression applied to the channel ticket price, else that price. Department filled from `ancestor3` on insert |
| `trd_p_stylecolor_store_worklist` | `trg_sync_alloc_and_override_trigger`, `trg_update_alloc_qty` | **DISABLED in QA** (L26353, L26387); no effect. See Disabled triggers |
| `trd_p_stylecolor_worklist` | `on_(un)publish_remove_from_worklist*` | **DISABLED in QA** (L26155, L26165, L26175); no effect. See Disabled triggers |
| `trd_ma_departmentalloc_attributes`, `trd_ma_stylecolor_alloc_attributes` | `trg_(sclr_)allow_scaling_set_overflow_ok` (L9578, L9620) | Turning on allow-scaling also forces overflow-ok on |
| `trd_p_stylecolor_store_eligibility` | `trg_update_eligibility_from_null_to_zero` (L10304) | NULL eligibility → 0 |
| `trd_p_strategy_params` | `trg_p_strategy_params_set_apply_targets` (L9643) | Carryover/Future floorsets → `apply_targets_to_plan = NULL` |
| `worklist_map` | `trg_ai_worklist_map` (L9601) | Seeds a `trd_ma_stylecolor_alloc_attributes` row |
| `trd_v_memberbasedvalidvalues` | `set_mvv_indx` (L9813) | NULL `indx` → max + 1 on insert |
| `cart_params` | `trigger_cartparams_irw_debut_offset` (L10635), `trigger_cartparams_ranging` (L10665) | Add-to-assortment cart: IRW = debut − `irw_debut_offset`; `cart_ranging` rebuilt across floorsets in [max(debut, `plan_current`), min(exit, `plan_end`)] |
| `pivot_execution` / `plan_queue` | `on_*_change` → `notify_*_change()` (L5895, L5908) | **LISTEN/NOTIFY**: the backend's eventing for pivot runs and the plan queue |
| 8 tables | `set_timestamp_*` → `trigger_set_timestamp()` (L9912) | `updated_at` on `a_assortment`, `ma_style/stylecolor/sizeattributes`, channelattributes, `p_channeloverride`, `p_dc_adj[_size]` |

Unattached trigger functions (dead code, or attached by hand in other envs)
are listed in SCHEMA_MAP.md.

## Big procedural code (not triggers)

- `add_to_assortment()` (L296, ~2,180 lines) and the procedure
  `ata_add_to_assortment` (L2501, ~2,200 lines) materialize a cart into the
  plan. Same shape as the ann/KWG procedure in
  `knowledge/backend/ann-add-to-assortment.md`, so read that first.
  `after_add_to_assortment` (L2481) is a stub that only opens a cursor.
- Clone procedures: `trd_style_clone_stylecolor_size_proc` (L8183) and
  `trd_no_style_clone_stylecolor_size_proc` (L6625), ~1,365 lines each,
  plus `trd_plan_these_cloned_style_stylecolors_proc` (L7998).

## Materialized views (the MFP serving layer)

`mfp.actuals_wide_denorm` (L11225) and `mfp.sys_gen_wide_denorm` (L11903),
with twins in `mfp_td` (L12411, L13105) and `target_setting` (L24231,
L24630). Each joins `actuals_wide` / `sys_gen_wide` to that schema's
`*_denorm` dimension views (sources in SCHEMA_MAP.md). They only change when
refreshed. The ETL's `ch/weekly/mfp/05_refresh_dimension_hierarchy.sql`
refreshes the `mfp` and `mfp_td` pairs; no refresh of the `target_setting`
pair is in that script (local clone).

## Drift since 2026-07-09

Same QA env, three months apart. Found with `python3 tooling/db/schema_map.py
diff <jul.sql> <oct.sql> --labels TRD-jul TRD-oct`, plus a column, view and
index diff the tool doesn't do. The July dump is in git:
`git show d852d41:customers/TRD/db/postgres_schema.sql`. Line numbers are
October lines; removed objects have none.

**Unchanged:** all 54 triggers (names, events, WHEN; the same 5 were
DISABLED in July), constraints, and every view but one. The server moved
from 14.17 to 14.22 (L1, L8). The newer pg_dump (18.6) also writes owners
and TOC comments, which is diff noise.

**Behaviour changes in trigger functions** (*Observed* unless marked):

- `trigger_final_cost()` (L9721): new L9728–L9730 treat a 0 ticket price as
  0.01. The trigger runs AFTER UPDATE (L26443), so the stored price stays 0
  and only the IMU% math changes. *Inferred:* before, a cost edit on a row
  with ticket price 0 failed with "division by zero"; now it saves and
  writes `cc_imupct` = (0.01 − final cost) / 0.01, a large negative number
  (cost 10 → −999), to all channels. AEO's copy has neither this guard nor
  TRD's cost fallback.
- `trigger_set_publish_timestamp()` (L9858): new L9872–L9875. A DC publish
  now also stamps `cc_first_publish_date` and `cc_first_publish_snapshot_op`
  (only where NULL) on every channel row of the product. This matches AEO's
  function, plus TRD's existing `published_by`. *Inferred:* stylecolors
  first published before this change get the date of their next publish,
  not their real first one; channel `updated_at` now moves on every publish.
- `update_ticket_price()` (L10587): new L10594–L10596 set
  `cc_orig_unit_retail_char` = `'$'` + retail to 2 decimals whenever
  `cc_orig_unit_retail` changes (SUP-4311). The `$$` → `$_$` quoting change
  is cosmetic.

**SUP-4311 rollout (new column `cc_orig_unit_retail_char`):**

- Column added to `trd_ma_stylecolorattributes` (L13534) and appended to the
  view `trd_stylecolor_hier_attr` (L23670).
- `add_to_assortment()` (L296), `trd_no_style_clone_stylecolor_size_proc`
  (L6625), `trd_style_clone_stylecolor_size_proc` (L8183): the only body
  change is that their `trd_ma_stylecolorattributes` inserts now fill the
  new column (L1128/L1199, L7064/L7173, L8620/L8729).
- **Gap:** `ata_add_to_assortment` (L2501) still inserts into
  `trd_ma_stylecolorattributes` without it (L3286).
  `knowledge/notes/SUP-4311.md` step 7 calls this insert
  `after_add_to_assortment`, but its July line (3213) is inside
  `ata_add_to_assortment`. *Inferred:* stylecolors created through that
  path have a NULL `cc_orig_unit_retail_char` until their retail is edited.

**Removed: the style split/merge feature** (*Observed*):

- Procedures `trd_style_split_proc`, `trd_style_merge_reparent_proc`,
  `trd_prefill_split_attrs_proc`, `trd_prefill_stylecolor_names_proc`. In
  July, split created new styles and re-parented the selected stylecolors
  and sizes under them; merge re-parented stylecolors under a target style
  (retiring color collisions and emptied styles) and applied typed renames;
  the prefills seeded the rename scratch columns.
- Tables `trd_style_split_stage`, `trd_style_split_archives_tbl`,
  `trd_style_merge_reparent`, `trd_style_merge_archives_tbl`,
  `trd_split_attrs_prefill`, `trd_stylecolor_name_prefill`; their three
  `session_id` indexes; and the columns `split_new_style_name`,
  `new_stylecolor_name`, `merge_target_style` on
  `trd_ma_stylecolorattributes`.
- No reference found in the local `trd-configs` clone (git base only; the
  QA OCI overlay was not checked). *Inferred:* any QA screen action that
  still calls these procedures now fails with "procedure does not exist",
  and the archive of past QA splits/merges is gone.

**Other removals:**

- `instance_id` column dropped from `plan_queue` (L17198), `cart_queue`
  (L14521) and `allocation_plan_queue` (L13272). *Inferred:* a backend queue
  change was undone in QA; check which darwin build QA runs if queue
  processing misbehaves.
- `user_metadata_get_api`: staging table from Liquibase change SUP-4151.
  *Observed* in the local etl-trd-batch clone: `bash/get_fusionauth_users.sh`
  TRUNCATEs it first and exits on failure. *Inferred:* the FusionAuth user
  sync fails in QA until the table is recreated.
- `mfp.plan_data_export`: a work table. The ETL's
  `pgsql/mfpapsync/mfp_plan_data_outbound_daily.sql` drops and recreates
  `plan_data_export` each run, and `public.plan_data_export` still exists
  (L17071). Low impact.
- `deleteme_trd_ma_sizeattributes_20260319` (cleanup).

**Added: backups and fix artifacts (no logic):**

- `*_bkp29052026` copies of `trd_d_product` (L19220), `trd_h_prodstd`
  (L19691), `trd_ma_sizeattributes` (L20880), `trd_p_dc_adj_size` (L22427).
- `sup4164_in_sca` (L18003), `sup4164_in_sca_fix` (L18017),
  `sup4164_ma_sizeattributes` (L18034),
  `sup4164_ma_stylecolorchannelattributes` (L18059): SUP-4164 fix tables.
- `trd_ma_stylecolorchannelattributes_11050122_black_bad_ccrangeco`
  (L21740): backup from a one-item `ccrangecode` fix.
- `mfp` / `mfp_td` `actuals_wide_bkp_20260712` (L10981, L12161) and
  `actuals_wide_deduped` (L11039, L12222). *Inferred:* an MFP actuals
  de-duplication fix around 2026-07-12.
- `s5_analytics_inseason_sls_rnk_transposed` (L17812) reshaped:
  `act_aps_store/ecom` replaced by `raw_aps_*` and `clean_aps_*`. The old
  shape is kept as `prev_s5_analytics_inseason_sls_rnk_transposed` (L17441).

**What it means (*Inferred*):** two readings fit. (a) Split/merge and
`instance_id` were rolled back on purpose. (b) QA `trd` was rebuilt or
restored from another environment's copy taken after 29 May 2026, and the
later changes (SUP-4311, first-publish stamp, zero-ticket guard) were
applied on top. Points for (b): the `*_bkp29052026` tables are dated before
the July dump yet appear only now, July-era scratch
(`deleteme_..._20260319`) vanished, and the server version changed (weak on
its own). Neither is confirmed. Ask the DBA/infra team before relying on
it, and check `databasechangelog` for the SUP-4151 row via the db MCP.

## Triage implications

- **"MD/Exit/Debut week reverts on save"** → the validity triggers. Check
  the ordering (relaunch ?? debut) < MD < exit for **every channel row** of
  the stylecolor; a revert applies across all channels.
- **"DC user adjustments disappeared"** → was MD moved (even invalidly)? Or
  was `ccrangecode`/size range changed? See `lifecycle_plan_update` and
  `sizerangecode_validsizes_members`.
- **"Final cost / IMU% looks wrong"** → `trigger_cost` precedence is system
  cost > unit cost > plan cost; linking a spec stylecolor sets system cost.
  A huge negative IMU% means ticket price 0 (the post-July guard). Batch
  loads don't fire it.
- **"Ticket price group-by / Cap Recap blank"** → `cc_orig_unit_retail_char`
  is not filled on the `ata_add_to_assortment` path (Drift, SUP-4311 gap).
- **"First publish date missing or too late"** → only stamped since the
  post-July change, and only once.
- **"Style split/merge fails in QA"** → the procedures and tables are gone
  from QA (Drift).
- **"PO publish won't stick"** → `trd_p_dc_adj.dc_publish` must be 1 first.
- **"Allocation qty doesn't match the size overrides" / "worklist not
  updated on publish"** → the triggers for both are DISABLED in QA (see
  Disabled triggers); look in the app or batch instead.
- **"Store count / ranging changed on later floorsets"** →
  `propagate_assortment_to_floorsets` pushes the ranging forward.
- **"Bulk update behaves differently than a UI edit"** → the
  `pg_trigger_depth()` guards, plus the ETL's disable/enable trigger calls.
- **"MFP numbers stale"** → the MV refresh step in the weekly mfp flow.
- `updated_at` is trigger-maintained on the 8 tables above, so it is a good
  freshness signal for UI edits, but not for batch loads on channel rows.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, regenerate
SCHEMA_MAP.md, then diff against the previous dump with `schema_map.py
diff` (tables, triggers, routines) plus a column/view check to catch manual
DDL drift. All three engine schemas are captured (PG + Vertica + ClickHouse
sections below).

---

# TRD Vertica — schema knowledge (from vertica_schema.sql)

Snapshot: QA, DB `trd`, dumped 2026-08 (EXPORT_OBJECTS). 284 tables,
275 projections, 1 function. Vertica is the ETL staging + transform layer
(inbound files land here, get transformed, then export to PG/CH).

## Table families (the naming convention = the pipeline stage)

| Prefix | Count | Role |
|---|---|---|
| `TRD_IN_*` | 87 | **Inbound staging** — raw loaded from S5* files (per table_mappings*.json). First landing zone. |
| `TRD_REF_*` / `trd_ref_*` | 12 | Reference/mapping tables (e.g. `TRD_REF_S5_CLIENT_ID_MAPPING` — the id-translation table; `TRD_REF_PRD_MEMBERMASTER`). Built early in 010_products.sql. |
| `trd_d_*` | 11 | Dimensions (trd_d_product, trd_d_location, trd_d_time, trd_d_prodlife). |
| `trd_h_*` | 13 | Hierarchies (trd_h_prodstd, trd_h_locstd). |
| `trd_ma_*` | 19 | Master attributes (styleattributes, stylecolorattributes, sizeattributes). |
| `trd_p_*` | 14 | Plan/fact tables (history, onorder, dc_adj). |
| `trd_l_*` | 8 | Lookup tables. |
| `trd_int_*` | 11 | Intermediate transform tables. |
| `*_existing` | 23 | **The round-trip preservation tables** — current PG state exported back to Vertica, MERGEd with fresh build to preserve user edits + rows dropped from the feed (see weekly-product-master-lineage.md). First suspect for "record disappeared after batch". |
| `temp_*` | 3 | Session/temp transform scratch. |

## Notes for triage

- Vertica is where inbound data first lands (`TRD_IN_*`) and gets shaped —
  so "data wrong/missing everywhere" that traces to a bad transform lives
  in the vsql/ scripts operating on these tables.
- Almost no stored logic in Vertica (1 function) — unlike Postgres (54
  triggers). Vertica is pure batch transform; the business-logic-in-DB
  concern is a Postgres thing.
- Projections (275) are Vertica's storage/query-optimization layer; rarely
  relevant to data-correctness tickets, but a missing/wrong projection can
  cause query performance issues.
- Grep this dump for a table's exact columns/DDL when a transform question
  needs the real shape.

---

# TRD ClickHouse — schema knowledge (from clickhouse_schema.sql)

Snapshot: QA, DB `trd`, dumped 2026-08. **1,267 tables/views.** Engines:
MergeTree 1077, ReplicatedMergeTree 79, **Distributed 73**, **PostgreSQL 21**,
Memory 9, ReplacingMergeTree 8. 79 VIEWs. **0 materialized views.**

## Correction: there are NO materialized views feeding the `*_agg` tables

Earlier docs (config CLAUDE.md "known gaps") assumed CH `*_agg` tables were
fed by materialized views whose DDL lived in `database_changes/`. **The dump
disproves this** — there are 0 MVs in `trd`. What look like `*_agg` are
plain **VIEWs**. Example (the SUP-4202 metric root):

- `trd.trd_p_history_agg` is a **VIEW**: `... AS SELECT ... FROM
  trd.trd_p_history_loc_arr_tbl ARRAY JOIN arr_location, arr_prodlife,
  arr_cluster, arr_dmd_r, …` — it **unnests the array-packed
  `trd_p_history_loc_arr_tbl`** (which the ETL loads) into row-per-
  location/prodlife/cluster. So every pivot that reads `trd_p_history_agg`
  actually reads `trd_p_history_loc_arr_tbl`.

**Lineage implication:** pivot roots like `trd_p_history_agg` that showed
"no upstream" in the graph are VIEWs → their real source is the base `_tbl`
the ETL loads. The 79 view definitions in this dump are the missing bridge
between pivot-read names and ETL-loaded names. (Next enrichment: parse these
views → `view → base_tbl` edges and fold into the unified graph — closes
the pivot-root gaps.)

## The three physical layers (naming = layer)

| Layer | Engine | Naming | Who uses it |
|---|---|---|---|
| **Local** | MergeTree/ReplicatedMergeTree | `trd_x_tbl` (183) | ETL loads here (`bash/*/11_ch_*`) |
| **Distributed wrapper** | Distributed (73) | `trd_x` | what pivots read (config side) |
| **View** | VIEW (79) | `trd_x` / `s5_analytics_tenant_*` | reshape/unnest over base tables (e.g. array-unnest, PG denorm) |
| **PG proxy** | PostgreSQL (21) | `*_in_ch`, `target_setting_*` | LIVE window into Postgres (not ETL-loaded) — `trd_d_product_in_ch`, `trd_h_prodstd_in_ch` |

The `_tbl`↔wrapper split is why lineage normalizes `_tbl` away (same logical
table). The **PostgreSQL-engine tables are a direct CH→PG link** (bypass the
file export) — relevant when a CH value tracks PG live, not the batch.

## Triage notes

- "Metric wrong in a pivot, data right in the base table" → check the VIEW
  in between (it may reshape/alias columns — see the `x_*`→base aliasing in
  `trd_p_history_agg`).
- A CH table ending `_in_ch` or under `target_setting_*` = PostgreSQL engine
  = reads PG live; its "freshness" is PG's, not the batch's.
- Grep this dump for a table's `CREATE` to see engine + columns + (for
  views) the exact SELECT/source.
