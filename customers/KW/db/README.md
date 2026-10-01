# KW (KnitWell Group) Postgres — schema knowledge (4 brand databases)

Snapshot: **QA**, 4 databases (`ann`, `atfs`, `loft`, `los`), server 14.22, dumped 2026-10-01 (pg_dump
18.6, plain, schema-only). **Prod/Staging not captured.** Each brand has its own DB and table prefix;
platform tables (`plan_queue`, `cart_*`, `sync_*`…) are unprefixed. `<brand> Lnnn` = a line in that
brand's `postgres_schema.sql`. Grep the dumps for full bodies; this file is the map.

| Brand | Prefix | Tables (public + target_setting) | Views / MVs | Functions + procs | Triggers (enabled) | Location code¹ | Generated map |
|---|---|---|---|---|---|---|---|
| ann | `ann_` | 279 (259 + 20) | 11 / 2 | 62 + 4 | 62 (61) | `GP-A` | [ann/SCHEMA_MAP.md](ann/SCHEMA_MAP.md) |
| atfs | `atfs_` | 259 (239 + 20) | 11 / 2 | 63 + 4 | 62 (61) | `GP-F` | [atfs/SCHEMA_MAP.md](atfs/SCHEMA_MAP.md) (ends with diff vs ann) |
| loft | `loft_` | 418 (398 + 20) | 11 / 2 | 65 + 4 | 62 (59) | `GP-L` | [loft/SCHEMA_MAP.md](loft/SCHEMA_MAP.md) (ends with diff vs ann) |
| los | `los_` | 256 (238 + 18) | 10 / 2 | 64 + 4 | 62 (61) | `GP-O` | [los/SCHEMA_MAP.md](los/SCHEMA_MAP.md) (ends with diff vs ann) |

¹ Hard-coded as the plan-queue location in each brand's `<t>_plan_these_cloned_style_stylecolors_proc`
(ann L6514); *inferred* to be the brand's single channel location. *Inferred, unconfirmed:* atfs = Ann
Taylor Factory, los = LOFT Outlet. "Enabled" excludes `ALTER TABLE … DISABLE TRIGGER` lines. Each brand's
SCHEMA_MAP lists its disabled triggers, and `knowledge/db-trigger-matrix.md` marks them `off`.

Hierarchy convention (from function bodies, same as AEO): for a stylecolor row in `<t>_h_prodstd`,
`ancestor0` = style, `ancestor1` = subclass, `ancestor2` = class, `ancestor3` = department
(`fetch_store_count`, ann L9549; `update_subclass_name`, ann L12002). A style row is shifted one
level (`ancestor0` = subclass, `ancestor1` = class, `ancestor2` = department; `update_subclass`, ann L11945).

**KW-only concept — size-concept families.** A "missy" master CC/style owns related CCs/styles of other
size types (petite, plus…): `missy_related_stylecolor` on channel rows, `cc_missy_related_stylecolor`
on stylecolor attributes, `sty_missy_related_style` on styles. Many triggers copy master edits to the
family. `add_to_assortment` creates related CCs with `record_state = 1`, not in assortment (ann L2722).

## The hidden business-logic layer: triggers (ann is the reference brand)

None of this is in git. **Observed** = read from the DDL. **Inferred** = derived from trigger semantics,
not yet confirmed with data. "Same as AEO" = body matches `customers/AEO/db/postgres_schema.sql` (diffed).

### ann_ma_stylecolorchannelattributes — 15 triggers (the hot spot)

PK `(product, location)`. Two KW-only row columns drive the lifecycle rules: `plan_current` (copied
from `ann_serviceparams` by `add_to_assortment` step s51, ann L2735) and `cloned_at` (set by the clone
procedures, e.g. ann L4549). "Passed" below means earlier than the row's `plan_current`.

| Trigger | Fires on | WHEN | Function (ann Lnnn) → effect |
|---|---|---|---|
| `md_trigger_on_update` | AFTER UPDATE OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut) OR exit ≤ MD OR (not cloned AND MD passed²); depth=0 | `md_trigger_on_update_validity_check()` (L9905) → **`SET erlstmkdnwk = OLD`**, all channels. Body same as AEO; WHEN adds the passed-week lock |
| `exit_trigger_on_update` | AFTER UPDATE OF `exitdate` | exit ≤ MD OR (not cloned AND exit passed²); **depth guard only on the relaunch branch** (L21337) | `exit_trigger_on_update_validity_check()` (L9530) → **`SET exitdate = OLD`**, all channels |
| `dbt_trigger_on_update` | AFTER UPDATE OF `dbt_wk` | dbt ≥ MD OR (not cloned AND OLD dbt passed); depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L9474) → **`SET dbt_wk = OLD`**. Unlike AEO, a passed debut is locked (BOD has a similar rule) |
| `ca_1_trigger_on_update` | AFTER UPDATE OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit AND (cloned OR OLD dbt or OLD exit after `plan_current`); depth=0 | `store_eligibility_trigger()` (L10401) → rebuilds this channel's `ann_a_assortment` `plan` rows over floorsets whose **sales window** `slsstart..slsend` overlaps [raw `dbt_wk`, exit] (AEO: `ap_start..ap_end`, relaunch-aware), copying grade/climate/SSG from the nearest floorset; `isfunded = 1` on the floorset holding `dbt_wk` |
| `trigger_for_time_indx` | AFTER INSERT OR UPDATE OF the 4 weeks | (none) | `update_week_indxes()` (L12108), see below |
| `trigger_for_time_indx_update` | AFTER UPDATE OF the 4 weeks | same as `ca_1`, no depth guard | `update_week_indxes()` again (no `_insert` twin in KW) |
| `trigger_lifecycle_plan_update` | AFTER UPDATE OF `erlstmkdnwk` | (none, no depth guard) | `lifecycle_plan_update()` (L9870), same as AEO → **NULLs `dc_uservrp`/`dc_useradj`** in `ann_p_dc_adj` and `_size` for `time >=` new MD |
| `trig_cc_channel_copy_master_attributes` | AFTER UPDATE OF 11 lifecycle weeks (debut, relaunch, MD, exit, IRW, last inv/FP/rcpt, act IRW/debut, planned sell-down) | row has a `missy_related_stylecolor`; depth=0 | `cc_channel_copy_master_attributes()` (L9116) → copies the 11 weeks to every related CC (all locations), queues the in-assortment ones to `plan_queue`, rebuilds their `ann_a_assortment` rows for this location, sets `isfunded` |
| `trig_cc_channel_copy_master_attributes_without_lifecycle` | AFTER UPDATE OF `ccmdstrategy`, order mult/min, discount pcts, `auto_rollforward`, `ccticketpricechannel`, `slsrnk_*`, `cc_plan_cost` | same | `…_without_lifecycle()` (L9257) → first 7 copied to all related CCs; `slsrnk_*`/`cc_plan_cost` only to related CCs with `record_state = 1`; queues `plan_queue` |
| `trg_update_cctktprc_override` | AFTER UPDATE OF `ccticketpricechannel_override_txt` | depth=0 | `update_ccticketpricechannel_ovr()` (L11136) → numeric override = text without `$` (`''` → NULL); text rewritten as `'$' ‖ text` |
| `update_price_band` | AFTER INSERT OR UPDATE OF ticket price / override | (none) | `update_price_bands()` (L11450) → `cc_price_band` and style `sty_price_bands` (max over the style) from `ann_l_dependencylookup` target `sty_price_bands` |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | (none) | `sizerangecode_validsizes_members()` (L10245) → **regenerates size members** from the **style's** `sty_size_range` (via `ann_stylecolor_hier_attr`), not from the new `ccrangecode` (AEO parses `ccrangecode`); new sizes named `<stylecolor id>-<size>`; NULLs size `dc_useradj` for invalid sizes |
| `trigger_sizerangecode_isvalid` | AFTER UPDATE OF `validsizes` | (none) | `sizerangecode_isvalid()` (L10193), same as AEO → resets `ann_ma_sizeattributes.isvalid` from this row |
| `update_size_concepts` | AFTER UPDATE OF `record_state` | depth=0 | `update_cc_size_concept_in_assortment()` (L10935) → size-concept add/remove cascade, see Quirks |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | (always) | `trigger_set_timestamp()` (L10755) → `updated_at` |

² No relaunch: OLD value passed (a passed week can't be edited). With relaunch: NEW value passed
(can't move it into the past). See `CREATE TRIGGER` at ann L21321–L21345.

#### update_week_indxes() (ann L12108): what a lifecycle save also changes

1. Converts raw `dbt_wk` (relaunch is **not** used, unlike AEO), relaunch, MD and exit to `ann_d_time.indx`.
2. **IRW** = debut − **2** (fixed; AEO reads `irw_debut_offset` from the floorset table) → `initrcptwk`.
3. **Last DC order** = MD − **6** → `lastdcorder` and `last_rcpt_wk`. Same as BOD (MD − 6); AEO and
   TRD use MD − 4. No `auto_rollforward` branch (AEO uses MD − 1), although the column exists.
4. `too` = MD − debut, `mkdnwks` = exit − MD, both from `dbt_wk` even when a relaunch is set.
5. `plannedselldnwk` follows MD when it equalled the old MD (KW only).
6. `act_dbt_wk` follows `dbt_wk` when they were equal, the old debut hadn't passed and new debut < MD.
7. Steps 2–5 run only when dbt < MD < exit AND (OLD dbt or OLD exit after `plan_current`). Writes
   are per `(product, location)`.

| Brand | IRW | Last DC order | Source |
|---|---|---|---|
| ann, loft | debut − 2 | MD − 6 | ann L12108, loft L12355 (identical bodies) |
| atfs, los | debut − **3** | MD − 6 | atfs L12103, los L12120 (only the IRW line differs from ann) |

### Quirks worth knowing

- **Validity reverts hit every channel** (*Observed*: `WHERE product = NEW.product`, ann L9474/L9530/L9905; same as AEO).
- **Passed-week locks use the row's `plan_current`** (*Observed*, WHEN clauses). *Inferred:* the
  boundary is only as fresh as whatever last wrote that column (add_to_assortment, ann L2735, or the
  batch). Cloned CCs (`cloned_at` set) are exempt.
- **Exit revert can fire below depth 0** (*Observed*: the `pg_trigger_depth() = 0` term sits inside the
  relaunch branch only, ann L21337). *Inferred:* for non-relaunch rows it fires on related CCs during
  the missy copy, and editing a passed exit to another passed week can make the revert re-trigger
  itself until "stack depth limit exceeded", failing the whole save.
- **A rejected lifecycle edit on a missy master still reaches its children** (*Inferred*): AFTER
  triggers run in name order with the event's NEW values, so the md/exit/dbt revert runs first and
  `trig_cc_channel_copy_master_attributes` then copies the rejected values to related CCs at depth 1,
  where the depth-guarded validity triggers don't run. Check the children after any revert.
- **`ca_1` can rebuild assortment rows for a debut that is then reverted** (*Inferred*): it fires before
  `dbt_trigger_on_update` and its WHEN passes when the exit is still in the future.
- **Moving MD wipes DC user adjustments**, even when reverted (same as AEO). **`update_week_indxes`
  runs twice per valid UPDATE**, once per INSERT (*Observed*).
- **`trigger_update_cc_floorset` is a no-op** (*Observed*: it is an AFTER trigger that assigns
  `NEW.cc_floorset`, ann L10882 / L21707; AFTER-trigger return values are discarded).
- **Style edits silently dropped when the spec style is shared** (*Observed*:
  `skip_update_styleattributes()`, ann L10376, BEFORE UPDATE returns NULL if another style has the same
  non-empty `sty_specstyleid`). *Inferred:* any column edit on that style, UI or ETL, vanishes without error.
- **Price band not set on the first ticket price** (*Observed*: `update_price_bands` compares with
  `!=`, so INSERT and NULL→value skip both branches).
- **Grade/climate edits copy across channels** (*Observed*: `upd_array_order()`, ann L10837, sorts the
  arrays and writes them to every location and plan_type of that product + floorset).
- **`plan_type = 'ranging'` never sticks** (*Observed*: `reset_plan_type_to_plan()`, ann L10166, resets
  this and later floorsets to `plan`).
- **Size-concept array is derived, not edited** (*Observed*: `remove_size_concepts_from_assortment()`,
  ann L10111, recomputes `cc_size_concepts_in_assortment` from related CCs with `record_state = 0`
  unless the array is emptied, which removes all children). `validate_size_concept_addition()`
  (ann L12189) returns OLD, silently discarding the whole row update, for a concept not in
  `ann_l_size_concept_lookups`. Removing a MISSY/CURVY_MISSY master whose children fail
  `can_remove_from_assortment` (published DC weeks, EOH or size on-order) is undone (ann L10935).
- **Two CC naming formats** (*Observed*): colour change writes `<style>:<cc_color_name>`
  (`update_color_change`, ann L11160); style rename writes `<style>:<cccolor>` (`update_name_description`,
  ann L11360). `update_specstylecolor_id` (ann L11754) sets `cc_color_name`, which chains into both
  `update_color_change` and `cc_copy_master_attributes`.
- **`update_eff_aur`** (ann L11244): `v_ticketprice` is never assigned (*Observed*, same as AEO).
  *Inferred:* with no channel ticket price and no `eo` it EXECUTEs a NULL string and the price write
  errors. KW-only: it copies all of the master's `ann_p_itemprice` rows to related CCs (`ON CONFLICT` update).
- **`set_pack_ind_flag` is DISABLED in all 4 brands** (*Observed*: ann L21395, atfs L20870, loft
  L26727, los L20720). Its body (ann L10628) would blank reason codes on non-IRW weeks; it is inert in QA.
- **`updated_at` is reliable in PG** (*Observed* in `etl-ann-batch/stylecolorchannelattributes_sync.sh`,
  prod branch): the every-minute job only reads rows whose product is in `sync_stylecolorchannel`,
  appends them to CH `ann_ma_stylecolorchannelattributes_tbl`, then runs `delete from sync_stylecolorchannel`.
  Repeated identical-`updated_at` rows are CH-side appends. *Inferred:* products queued between the
  export and the delete are dropped from the queue and miss CH until queued again.

### Other notable triggers (ann)

| Table | Trigger → function (ann Lnnn) | Effect |
|---|---|---|
| `ann_ma_stylecolorattributes` | `cc_copy_master_attributes` (L9397) | Master CC → related CCs: 20 descriptive attributes always; climate/primary selling/online excl./delivery/storeset/season only to related CCs with `record_state = 1`; queues `plan_queue` |
| | `cc_add_size_concept_to_assortment` → `add_size_concepts_to_assortment()` (L155) | Array grew → matching children `record_state = 0`, master's `ann_a_assortment` rows copied to children that have none, children queued |
| | `trg_upd_specstylecolorid` → `update_specstylecolor_id()` (L11754) | Duplicate spec colour → reverted; else sets `cc_specstylecolorid`, returns the old one to the `ann_l_dependencylookup` pool, pushes to related CCs |
| | `trig_upd_on_color_change` (L11160), `trg_upd_season` (L10903), `trigger_update_cc_use_sys_floorset` (L11114) | Colour family/code/type/print from lookup on colour name; storeset → season + storeset period; `cc_floorset` set/cleared flips `cc_use_sys_floorset` |
| `ann_ma_styleattributes` | `trg_upd_specstyleid` → `update_specstyle_id()` (L11572, ~175 lines) | Spec style set: blanks child spec colours, returns old id to the class pool, pulls BBR attributes, sets related styles' ids, overwrites images from `ann_specimages` (archived first), renames `ann_d_product`. Cleared: restores names/images, queues **`DEL2`** if published |
| | `sty_copy_master_attributes` (L10476); `update_ccrangecode` → `update_stylecolorchannelattributes_ccrangecode()` (L11836) | 24 style attributes master → related styles. `sty_size_range` change → related styles get the mapped range (`ann_l_size_concept_lookups`), CCs get `ccrangecode = <range> - <class>` + valid sizes from `ann_l_size_range_validsize_defaults` (no defaults row → nothing changes), cascading into size regeneration |
| `ann_h_prodstd` | `trg_upd_subclass` (L11945), `trg_upd_subclass_name` (L12002) | Master style changes subclass → related styles, their CCs and sizes re-parented to the related subclass (class ancestor untouched); CC `subclass_name` refresh |
| `ann_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L9974) | SSG vs grade/climate made exclusive; blank grade/climate without SSG → all valid values; `store_count` via `get_store_count` or SSG cardinality (warning + 0 if no lookup); **pushed to this and every later floorset** (AEO also handles region/HVLC/tourist) |
| | `triggger_insert_scflrsetattr` (sic) → `insert_stylecolorfloorsetattributes()` (L9823) | Seeds an `ann_ma_stylecolorfloorsetattributes` row |
| `ann_ma_stylecolorfloorsetattributes` | `trigger_update_publish_attributes` → `update_publish_attributes()` (L11520) | `is_attr/fc/ir_published` false→true stamps user/time (+ spec ids), queues **`ATTR` / `FC` / `IR`** to `sync_outbound_dataqueue` |
| `ann_p_dc_adj` | `set_timestamp_p_dc_publish_adj[_ins]` → `trigger_set_publish_timestamp()` (L10678) | `dc_publish = 1` → stamps, forces `dc_publish_ecom = 1`, queues **`RDY4PO`**; first publish also sets `cc_first_publish_date` and queues **`OP_SNAPSHOT`** (AEO sets the date but has no `OP_SNAPSHOT` and no ecom mirroring) |
| | `update_p_dc_adj_size_publish` (L11411), `set_dc_adjcost_ecom` (L10582) | Publish flags copied to sizes on UPDATE only (not INSERT); `dc_adjcost_ecom = dc_adjcost` |
| `ann_p_casepack` | `set_timestamp_cp_publish[_ins]` → `trigger_set_cp_publish_timestamp()` (L10545) | Same as AEO: `PO` queued only if `dc_publish = 1`, otherwise `po_status` forced to 0 |
| `ann_p_dc_adj_size` | `update_ecom_onorder_ovr` (L11212) | Rolls size `dc_finrev_ecom` up to `ann_p_dc_adj.dc_sc_finrev_ecom` |
| `ann_p_subclass_channel_floorset_pssr_infomap` | `trg_sync_is_approved` → `fn_sync_is_approved()` (L9614) | Copies `is_analytics_approved` to every `pssr_key` row of that product/time/location; `updated_by` = DB role |
| `plan_queue` | `remove_product_from_queue` (L10082), `delete_duplicate_invalids` (L9493), `on_plan_queue_change` | BEFORE INSERT **silently drops** the row unless the product's (first-found) channel row has `record_state = 0`; removed rows' queue entries deleted; NOTIFY |
| `cart_params` | `trigger_cartparams_ranging` → `update_trigger_cartparams_ranging()` (L12027) | `cart_ranging` rebuilt over sales-window floorsets in [max(debut, `plan_current`), min(exit, `plan_end`)]. No IRW-offset cart trigger (AEO has one) |
| others | `trigger_eff_aur` / `itemprice_fetchdepartment` (L9850), `set_mvv_indx`, `trg_p_strategy_params_set_apply_targets`, `on_pivot_execution_change`, `set_timestamp_*` on 9 tables | Same pattern as AEO |

Unattached trigger functions: `calc_store_count_ranging`, `trigger_set_size_id` (loft attaches it as
`set_size_id`, DISABLED in QA), `unlink_cc_size_concept_in_assortment` (would queue `DEL1`; live path is `update_cc_size_concept_in_assortment`).

## Big procedural code (not triggers)

- `add_to_assortment()` (ann L287, ~3,500 lines) materialises a cart into the plan. Read
  [knowledge/backend/ann-add-to-assortment.md](../../../knowledge/backend/ann-add-to-assortment.md). Its body
  differs in every brand; see Brand differences.
- Clone procedures (set `cloned_at`): `ann_no_style_clone_stylecolor_size_proc` (ann L3819),
  `ann_style_clone_stylecolor_size_proc` (ann L6547), `ann_plan_these_cloned_style_stylecolors_proc`
  (ann L6309). Helpers: `get_default_params` (ann L9646), `get_store_count` (ann L9769),
  `can_remove_from_assortment` (ann L9082), `plan_eligible`.

## Materialized views and platform tables

`target_setting` (20 tables; los 18, no `plan_archives`/`plan_data_wide_archives`) is the MFP-style
serving layer: MVs `actuals_wide_denorm` (ann L19955) and `sys_gen_wide_denorm` (ann L20309) over the
`*_denorm` views; they change only when the batch REFRESHes them. Triggers read the view
`ann_stylecolor_hier_attr` (ann L17206). Unprefixed `public` tables (ann 107, atfs 99, los 103, loft 248
mostly clutter): carts, `plan_queue`, `pivot_execution`, `sync_outbound_dataqueue` (outbound queue),
`sync_stylecolorchannel` (PG→CH queue), `bbr_status_check`, `user_metadata`.

## Brand differences (vs ann)

Behavioural (read from the differing bodies):

| Area | atfs | loft | los |
|---|---|---|---|
| IRW in `update_week_indxes` | debut − 3 | debut − 2 (same as ann) | debut − 3 |
| Trigger set | same as ann | no `trigger_sizerangecode_isvalid` (editing `validsizes` doesn't reset size `isvalid`), no `validate_size_concept_addition`; extra `set_size_id` and `trg_update_cc_current_price` on `loft_ma_sizeattributes`, **both DISABLED in QA, never fire** (loft L26737, L26947; bodies loft L10788 size-id lookup, L10932 max size price → `cc_current_price`) | same as ann |
| Size-concept plan queueing (SUP-3892) | no | yes: `update_eff_aur` (loft L11323), `sty_copy_master_attributes`, `update_subclass`, `update_stylecolorchannelattributes_ccrangecode`, `update_specstyle_id`, `update_specstylecolor_id` also queue related CCs | no |
| `update_stylecolorchannelattributes_ccrangecode` | same | also copies `arr_all_sizes_for_mins`, `sizemin_store/ecom` from the defaults (loft L12055) | same |
| `propagate_assortment_to_floorsets` | same | SUP-1715 variant: different SSG→grade/climate switch test, no missing-SSG warning (loft L9992) | same |
| `update_color_change` | same | same | `<>` without COALESCE (NULL→name skips rename/lookup) and still overwrites `cc_print_pattern_type` (SUP-3758 not applied; los L11148) |
| `add_to_assortment` | lacks SUP-3879 step 9C (`s4_0_3`) | lacks 9C and SSG-aware default ranging; debug capture **on**: writes `deleteme_*_jr` tables each run and creates `cart_master_temp<uuid>` as an UNLOGGED table that is never dropped (117 leaked in QA) | lacks 9C; non-SSG default `store_count` uses the cart's grade/climate, not the defaults |
| `get_default_params` | same | no `use_act_aps_or_act_rank = 'Copy Rating'` default | no `use_act_aps_or_act_rank` default |

Table-only differences (full lists in each brand's SCHEMA_MAP diff): mostly clutter (`deleteme_*`,
`bkp_*`, `*_backup*`, `temp*`, dated `failed_items_*`, the ann-only `ann_ata_missing_items_20250724*`
set, loft's 117 `cart_master_temp*`). Real-looking: ann-only `<t>_ma_masterstyleattributes`,
`subclass_default_attributes`, `user_metadata_get_api`; loft lacks `<t>_sizinglookup`,
`<t>_l_storedclookup`, `floorset_week_mapping`; loft/los add `<t>_a_assortment_storecount`; los lacks
the `<t>_stylecolor_sizeconcepts` view. Brand-only routines with no trigger: atfs/los `update_ticket_price`,
los `revert_to_original`, loft `set_prepublished_at`, `update_pim_style_id`, `update_pim_stylecolor_id`.

## Triage implications

- **First question: which brand?** Table prefix, DB name or location code (`GP-A/F/L/O`). Then open
  that brand's SCHEMA_MAP diff before porting any fix: a fix ported from ann can be wrong for atfs/los
  (IRW −3) or for loft (different triggers, SUP-3892 queueing, add_to_assortment debug code).
- **"MD/Exit/Debut reverts on save"** → the validity WHENs: ordering on **every channel row**, the
  passed-week lock against the row's `plan_current`, and whether `cloned_at` is set.
- **"Petite/plus CC has different weeks or attributes than its master"** → the `*_copy_master_*`
  triggers, depth guards, and the rejected-edit propagation above.
- **"IRW / last DC order is off"** → debut − 2 (ann, loft) vs − 3 (atfs, los); MD − 6 everywhere.
- **"DC user adjustments disappeared"** → MD moved (even if reverted), or `ccrangecode`/`sty_size_range` changed.
- **"Style attribute edit doesn't stick"** → another style shares the `sty_specstyleid`.
- **"Size concept won't add/remove"** → `validate_size_concept_addition`, the derived array, `can_remove_from_assortment`.
- **"Price band blank"** → first ticket price set from NULL. **"Grade/climate changed elsewhere"** →
  `upd_array_order` (other channels) and `propagate_assortment_to_floorsets` (later floorsets).
- **"Outbound file missing a CC"** → `sync_outbound_dataqueue` writers: `RDY4PO`, `OP_SNAPSHOT`, `PO`,
  `ATTR`/`FC`/`IR`, `DEL1`, `DEL2`. **"CH channel attributes stale"** → `sync_stylecolorchannel` + the minute job.
- **"Item never planned"** → `remove_product_from_queue` drops queue inserts for removed CCs.
  **"Behaviour doesn't match this file"** → check `DISABLE TRIGGER` lines and prod drift (QA only).

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, run `python3 tooling/db/schema_map.py regen`, diff
against these dumps for manual DDL drift, and grep `DISABLE TRIGGER`. KW ClickHouse/Vertica not captured yet.
