# GAP Postgres — schema knowledge (from postgres_schema.sql)

> **Client context is missing.** `customers/GAP/` is new: there is no `profile.md` or
> `repos.json` yet, so the ETL/config repos and business context are unknown. This file
> covers the Postgres DDL only.

Snapshot: **QA**, db `gap`, server 14.22, dumped 2026-10-01 15:06 IST (pg_dump 18.6, plain,
schema-only; header L1). **Prod/Staging not captured.** Contents: 211 tables, 53 triggers
(5 disabled), 57 functions + 5 procedures, 9 views, 2 MVs. Counts and the trigger list are in
[SCHEMA_MAP.md](SCHEMA_MAP.md). Cross-client
view: [db-trigger-matrix.md](../../../knowledge/db-trigger-matrix.md).
Schemas: `public` (186 tables, prefix `gap_`). `target_setting` (19) is the MFP-style
target-setting layer, shaped like AEO's `mfp*` schemas (`actuals_wide`, `sys_gen_wide`,
`plan_data_wide`, `plans`, `dimensions`/`hierarchies`/`tyly`; `comments` are deleted with their
plan, L18930). `target_setting_bkup` (6) holds manual copies of `dimensions`/`hierarchies`/`tyly`
that nothing reads (its FKs point only inside itself, L18956-18984). Line numbers are
`postgres_schema.sql` lines.

Hierarchy convention (from function bodies): for a stylecolor row in `gap_h_prodstd`,
`ancestor0` = style (L8936, L9283), `ancestor2` = class (L9269 matches the style row's
`ancestor1` at L8931), `ancestor3` = department (L6787, L9483); `ancestor1` = subclass is
inferred. Size rows shift up one level: `ancestor0` = stylecolor (L6822, L7939-7941).
Channel rows carry four price/cost variants: base (*Inferred:* US store), `_ecom_us`,
`_store_cad` and `_ecom_cad`.

## The hidden business-logic layer: triggers

None of this is in any git repo. **Observed** = read from the DDL. **Inferred** = derived from
trigger semantics, not yet confirmed with data.

### gap_ma_stylecolorchannelattributes — 16 triggers (the hot spot)

PK `(product, location)` (L17235). **GAP rebuilt the lifecycle logic.** AEO's AFTER
`md/exit/dbt_*_validity_check` and `trigger_for_time_indx*` triggers are gone. BEFORE triggers
named `scch_NN_*` edit `NEW` in place instead. Postgres fires same-timing triggers in name
order, so the numbers set the sequence: guard pricing, validate, derive, floorset fields.

| Trigger | Fires on | WHEN | Function (Lnnn) → effect |
|---|---|---|---|
| `scch_05_guard_pricing` (L18441) | BEFORE UPDATE OF the 8 ticket-price/plan-cost columns | depth=0 | `guard_scch_pricing_edits()` (L6700) → if that column's `*_flrset*_enabled = 1`, **puts OLD back**, RAISE WARNING only. GAP-only |
| `scch_10_validate_lifecycle` (L18449) | BEFORE UPDATE OF `dbt_wk, erlstmkdnwk, exitdate` | depth=0, one of them changed | `validate_lifecycle_weeks()` (L9536) → **`NEW.x := OLD.x` on this row only** if debut ≥ MD, exit ≤ MD, or MD ≤ (relaunch ?? debut). All checks use the submitted row (L9545-9574) |
| `scch_20_derive_week_indexes_insert` / `_update` (L18457, L18465) | BEFORE INSERT / UPDATE OF `dbt_wk, relaunchweek, erlstmkdnwk, exitdate` | none, no depth guard | `update_week_indxes()` (L9413) → derived fields written into `NEW` (below) |
| `scch_30_set_floorset_fields_insert` / `_update` (L18473, L18481) | BEFORE INSERT / UPDATE | depth=0 (+ `initrcptwk` changed) | `set_floorset_fields_on_initrcptwk_change()` (L7746, = AEO) → `irw_superset*`, `irw_floorset*` from the dept floorset whose `rcptstart..rcptend` holds IRW |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | always | `trigger_set_timestamp()` (L8770) → `updated_at` |
| `trg_cc_validsizes_on_change` | BEFORE UPDATE OF `ccrangecode, use_valid_sizes_from, cc_size_eligibility_profile` | depth < 2 | `update_cc_validsizes_on_ccrangecode()` (L8811, = AEO) → `cc_validsizes_store/ecom` |
| `ca_1_trigger_on_update` (L18387) | AFTER UPDATE OF `dbt_wk, relaunchweek, exitdate` | depth=0, (relaunch ?? debut) < MD < exit, a value really changed | `store_eligibility_trigger()` (L7979) → resizes the item's `plan` rows in `gap_a_assortment` (below) |
| `trigger_auto_rollforward` (L18717) | AFTER UPDATE OF `auto_rollforward` | NEW is TRUE | `update_on_auto_rollforward()` (L9233) → **all** channel rows of the product: exit = `gap_serviceparams.extended_range`, MD = week before. GAP-only |
| `trigger_cost` | AFTER UPDATE OF `cc_plan_cost` | depth=0 | `trigger_final_cost()` (L8578) → `cc_final_cost`, `cc_imupct` on all channel rows; divides by ticket price unguarded (L8586-8587) |
| `trigger_lifecycle_plan_update` (L18765) | AFTER UPDATE OF `erlstmkdnwk` | none | `lifecycle_plan_update()` (L6801, = AEO) → **NULLs `dc_uservrp`/`dc_useradj`** in `gap_p_dc_adj` and `_size` for `time >= MD` |
| `trigger_remove_from_assortment` | AFTER UPDATE OF `record_state` | `= 1` | `remove_from_assortment()` (L7662) → explicit no-op |
| `trigger_sizerangecode_isvalid` | AFTER UPDATE OF `validsizes` | none | `sizerangecode_isvalid()` (L7823) → `gap_ma_sizeattributes.isvalid` from this row's `validsizes` |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | none | `sizerangecode_validsizes_members()` (L7851) → marks all sizes invalid, revalidates/creates members via `gap_size_range_mapping` (into `gap_ma_sizeattributes`, `gap_d_product`, `gap_h_prodstd`), NULLs invalid sizes' `dc_useradj`. **Never deletes members** (AEO does) |
| `trg_upd_scch_pricing` (L18675) | AFTER UPDATE, **statement-level**, transition tables | in body: top level only | `propagate_pricing_to_assortment()` (L7061) → style-to-floorset price sync (below). **Not in SCHEMA_MAP.** GAP-only |

#### A lifecycle save, step by step

1. `scch_10` silently reverts each invalid column on **the edited row only**, with no error
   (L9576-9586). AEO reverts every channel row of the stylecolor.
2. `scch_20` (L9413) does AEO's maths but assigns `NEW`, so it runs once per event (AEO: twice),
   and only when raw `dbt_wk < MD < exit` (L9461-9477). **IRW** = effective debut (relaunch,
   blank → NULL, else debut) − `irw_debut_offset` of the dept floorset whose `ap_start..ap_end`
   holds `dbt_wk` (L9479-9485). **Last DC order** = MD − 4 (L9487); in roll mode MD − 1, plus
   `planned_sell_down_week` (L9512-9516). Roll mode is `auto_rollforward IS DISTINCT FROM FALSE`
   (L9501), so **NULL counts as roll**, as in AEO (default FALSE, L12864). It also sets `too`,
   `mkdnwks` (L9508-9509) and `act_dbt_wk` (L9434-9440).
3. `scch_30` sees the new IRW, because a BEFORE trigger's WHEN reads `NEW` as earlier triggers
   left it. *Inferred:* AEO's stale-IRW-floorset quirk is fixed for direct edits.
4. AFTER, `ca_1` → `store_eligibility_trigger` (L7979). The window is the dept floorsets
   overlapping [relaunch ?? LEAST(IRW, debut), exit] (L8020-8045): it starts at IRW, not debut
   as in AEO. It extends by cloning the earliest/latest `plan` row (L8037-8300) and leaves
   in-window rows alone (AEO deletes and reinserts all). It **deletes `plan` rows outside the
   window** (L8302-8320); *Inferred:* re-lengthening clones a survivor, so their ranging and
   prices are lost. It re-derives channel price/cost from the survivors (L8322-8405), and it
   sets `isfunded = 1` on all the product's assortment rows (every location and plan type) in
   a floorset holding a channel `dbt_wk` (L8407-8421), and never resets it to 0.
5. AFTER, `lifecycle_plan_update` wipes DC user adjustments from MD onward.

#### Pricing sync, style ↔ floorset (GAP-only, "V4.6" in comments)

`gap_a_assortment` holds per-floorset copies (`cc_*_flrset*`; a NULL channel variant inherits the
base column). Channel-row flags `*_flrset*_enabled` mean "varies by floorset" (L7552-7560).
- **Style-level edit:** `scch_05` reverts it if the column varies. Otherwise
  `propagate_pricing_to_assortment` (L7061) writes it to **every** assortment row of the
  product, joined on `product` only, with no location/plan_type/floorset filter (L7180-7198).
  Values ≤ 0.01 become NULL (sentinel rule, L7169-7196); then the flags are refreshed
  (L7200-7290). Per L7174, 1,294 of 4,376 channel rows had `cc_plan_cost = 0` at authoring.
- **Floorset edit:** `trg_upd_assortment_pricing` (L18659) → `propagate_pricing_to_floorsets`
  (L7304) pushes changed columns **forward to all later floorsets** of the same
  product/location/plan_type (L7340-7505) and fills NULL channel variants on earlier ones
  (L7477-7503). The rollup sets the style value = **MAX over all the product's assortment
  rows**, flags = "values differ", and recomputes `cc_final_cost`/`cc_imupct` (L7507-7648).
- Both return at once at trigger depth > 1 (L7068, L7312): pricing written by another trigger
  or function is not synced.

### Quirks worth knowing

- **Two pricing triggers are statement-level with transition tables.** *Observed:*
  `trg_upd_assortment_pricing` (L18659) and `trg_upd_scch_pricing` (L18675) use
  `REFERENCING OLD TABLE … NEW TABLE` and fire once per UPDATE statement, not once per row. GAP is
  the only client with this pattern.
- **Five triggers are DISABLED in QA and never fire.** *Observed:* the three worklist
  publish/unpublish triggers (L18413, L18423, L18433) and both store-worklist alloc-qty
  triggers (L18651, L18685). SCHEMA_MAP doesn't flag them. AEO and TRD QA disable the same five.
- **Blank relaunch slips past validation.** *Observed:* the validator tests `relaunchweek IS
  NULL` (L9561, L9568); `scch_20` and `ca_1` treat '' as NULL (L9432, L18387). *Inferred:* with
  `''`, an MD ≤ debut is accepted, but derived fields and ranging don't update (AEO: same gap).
- **Any save with `erlstmkdnwk` in the SET list wipes DC user adjustments.** *Observed:* no
  WHEN (L18765); column triggers fire on the SET list even if `scch_10` reverted the value.
  *Inferred:* a rejected MD edit still wipes from the old MD onward.
- **Turning on auto-rollforward cascades.** *Inferred* from L9242-9245 and the depth guards:
  the UPDATE runs at depth 1, so `scch_10` and `ca_1` are skipped (floorsets not extended to
  the new exit); `scch_20` re-derives in roll mode; `lifecycle_plan_update` wipes DC
  adjustments. Saving TRUE again re-applies it. No `extended_range` → exit and MD become NULL.
- **A zero ticket price breaks cost saves.** *Observed:* `trigger_final_cost` (L8586-8587) and
  the rollup (L7642) divide by price with no NULLIF; the authors note it (L8352-8355).
  *Inferred:* the save fails with `division by zero`. The default price is 0.01 (L12852).
- **Item price saves can error.** *Observed:* `update_eff_aur` (L9029, = AEO) never assigns
  `v_ticketprice` (its SELECT is commented out, L9074-9077). *Inferred:* with channel price
  ≤ 0 or NULL the dynamic SQL becomes NULL (L9119, L9132) and `EXECUTE` fails.
- **Reading the matrix:** many GAP cells differ from AEO only because GAP functions add `SET
  search_path TO 'public','pg_temp'` (*Observed* by diff: e.g. `trigger_set_timestamp`,
  `trigger_set_publish_timestamp`, `lifecycle_plan_update`, `update_name_description`).

### Other notable triggers

| Table | Trigger → function | Effect |
|---|---|---|
| `gap_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L6923) | Ranging pushed to later floorsets of the same product/location/**plan_type** (L7028-7047). SSG and attributes are mutually exclusive. Blanks default to **all valid values** from `gap_v_memberbasedvalidvalues` (L6961-7004), not floorset `default_*` as in AEO. **No `store_count` recompute** (AEO does one) |
| `gap_p_dc_adj` | `set_timestamp_p_dc_publish_adj[_ins]` → `trigger_set_publish_timestamp()` (L8716) | = AEO. `dc_publish = 1` → `published_at`, queues **`RDY4PO`** to `sync_outbound_dataqueue` (L16049), first-publish date on all channel rows. No OLD check, so re-saving re-queues (*Inferred*) |
| `gap_p_casepack` | `set_timestamp_cp_publish[_ins]` → `trigger_set_cp_publish_timestamp()` (L8612) | = AEO. `po_status = 1` queues **`PO`** only if `dc_publish = 1`, else **forces `po_status` to 0** |
| `gap_p_dc_adj` / `_size` | `set_pack_ind_flag` (L8692); `set_dc_ttluseradj_p_dc_adj_size` (L8649) | `reason_code = 'Initial'` → `pack_ind_flag`. Size total = store + ecom adj, NULL-safe (AEO's is NULL if either is NULL) |
| `gap_ma_styleattributes` | `update_ccrangecode` → `update_stylecolorchannelattributes_ccrangecode()` (L9259) | `sty_size_range` change → children's `ccrangecode = <range> - <class>` + valid sizes, then size-member rebuild. Guard and write both use `ancestor2` (fixes AEO's mismatch) |
| `gap_h_prodstd` | `update_ccsizerange_after_class_change_ancestor1` → `update_ccrangecode_on_class_change()` (L8903) | Style moved to a new class → children's `ccrangecode` rebuilt |
| `gap_ma_stylecolorattributes` | `trig_upd_on_color_change` → `update_color_change()` (L8958); `trg_update_cc_floorset` → `update_cc_use_sys_floorset()` (L8788) | Color fields from `gap_l_dependencylookup`; name = `<style><color_code>` (L8991; *Inferred:* NULL if no `color_code` lookup row), description `<style>:<color>`. Setting `cc_floorset` → `cc_use_sys_floorset` FALSE, clearing → TRUE |
| `gap_d_product`, `gap_p_itemprice`, `cart_params`, alloc-scaling/eligibility/strategy/worklist_map/mvv | L9197, L9029, L6781, L9302, L9332, L8435-8500, L8670, L9176 | Logic = AEO; see the [AEO README](../../AEO/db/README.md) |
| `gap_p_stylecolor_worklist`, `gap_p_stylecolor_store_worklist` | `on_(un)publish_remove_from_worklist*` (L6863, L6882); `trg_sync_alloc_and_override_trigger` (L8544), `trg_update_alloc_qty` (L8520) | **DISABLED in QA, never fire** (L18413, L18423, L18433, L18651, L18685). Don't rely on worklist cleanup or alloc-qty summing |
| `pivot_execution` / `plan_queue` | `notify_*_change()` (L6837, L6850) | LISTEN/NOTIFY eventing for the backend |
| 8 tables | `set_timestamp_*` → `trigger_set_timestamp()` (L8770) | `updated_at`; nested pricing/lifecycle writes bump it too |

Unattached trigger functions: `calc_store_count_ranging`, `delete_duplicate_invalids`,
`reset_to_prev_if_approved`, `revert_to_original` (`RETURN NULL` only, L7727), `trigger_set_size_id`.

## Big procedural code (not triggers)

- `add_to_assortment()` (L165, ~2,280 lines) has the ann/KWG shape; read
  [ann-add-to-assortment.md](../../../knowledge/backend/ann-add-to-assortment.md) first. GAP
  deletes and reinserts the cart's channel rows (L1446, L1452), so the `scch_20`/`scch_30`
  INSERT triggers fire. It seeds floorset price/cost with the > 0.01 sentinel (L1723-1730).
- `after_add_to_assortment()` (L2451) selects the quoted identifier `"jobid FROM plan_queue
  LIMIT 1"` (L2457). *Inferred:* calling it errors. AEO and TRD have the same body.
- `delete_records(v_uid)` (L2639) hard-deletes a stylecolor from 10 tables, **including the
  parent style's `gap_d_product` row** (L2662), even if sibling stylecolors remain. Same as AEO.
- Clone procedures `gap_style_clone_stylecolor_size_proc` (L4678), `gap_no_style_…` (L2883),
  `gap_plan_these_cloned_style_stylecolors_proc` (L4493); `_dummy` (L6261) only RAISEs. Helpers:
  `get_default_params` (L6284), `get_store_count` (L6598), `check_is(pre)publishable` (L2538, L2579).

## Views, MVs and other tables

- `target_setting.actuals_wide_denorm` (L16456) and `sys_gen_wide_denorm` (L16818) join the wide
  tables to `time_denorm` (floorset_uda → quarter → year), `product_denorm` (class → dept →
  division) and `location_denorm` (grade → selling channel → channel); grain floorset × class ×
  grade. Like AEO's MFP MVs, they change only on a batch REFRESH.
- `public` views: `plan_status` (L15768, `plan_queue` job state FAILED / COMPLETED / PROCESSING /
  PENDING / STALLED), `gap_ma_dptflrsetattributes_view_verification` (L12368),
  `perf_assortperiod_week` (L15608), `gap_for_tgt_flrset_hier` (L11677), `gap_*_hier_attr`.
- 74 non-`gap_` tables: carts (`cart_*`, `ata_cart_*` + `_archive`), `plan_queue*`,
  `allocation_plan_queue*`, `pivot_execution`, `undo_*`, `user_*`, `bulk_import_*`,
  `sync_outbound_dataqueue`, `agent_conversations*` (L9604), liquibase. **Not live data:**
  `gap_ma_stylecolorchannelattributes_0815/_bkp/_bkp_blank_initrcptw` (L13022, L13655, L13866),
  `gap_a_assortment_bkp` (L10960), `gap_ma_dptflrsetattributes_bkp_wrong_08232026` (L12279),
  `temp_cc_plan_cost_issues` / `temp_ccticketpricechannel_issues` (L16091, L16104), `deleteme_*`.

## Triage implications

| Symptom | Look at |
|---|---|
| Debut/MD/Exit reverts on save, no error | `scch_10` (L9536): ordering on **the edited row only**; check for a blank `relaunchweek` |
| Style-level ticket price/plan cost "won't stick" | That row's `*_flrset*_enabled` and `scch_05` (L6700); edit on the floorsets instead |
| Later floorset prices changed; style price didn't drop | Forward push and MAX rollup in `propagate_pricing_to_floorsets` (L7304) |
| Cost save fails with division by zero | A 0 ticket price on the product (L8586, L7642) |
| DC user adjustments disappeared | MD in the SET list (L6801), auto-rollforward turned on (L9233), or a `ccrangecode` change (L7959-7965) |
| Floorsets/ranging vanished after a lifecycle change | Contraction delete in `store_eligibility_trigger` (L8311) |
| Exit/MD jumped to the extended range | `auto_rollforward` set TRUE; check `gap_serviceparams.extended_range` |
| Store count stale after a ranging change | GAP's ranging trigger doesn't recompute it (L6923) |
| Item price insert/update fails | `update_eff_aur` with ticket price ≤ 0 (L9097-9132) |
| Bulk/ETL update behaves differently than a UI edit | depth=0 guards on `scch_05/10/30`, `ca_1`, `trigger_cost`; pricing sync runs at top level only |
| Worklist not cleared on publish; alloc qty not summed | Those triggers are DISABLED in QA (L18413-18433, L18651, L18685) |

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, then `python3 tooling/db/schema_map.py regen`
(it rewrites SCHEMA_MAP.md and the matrix). Diff against this dump to catch
manual DDL drift. ClickHouse and Vertica schemas for GAP are not captured yet.
