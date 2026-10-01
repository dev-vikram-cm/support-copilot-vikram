# BELK Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `belk`, server 14.22, dumped 2026-10-01 15:05 IST (pg_dump 18.6, plain,
schema-only). Tenant prefix **`blk_`** (not `belk_`). **Prod/Staging not captured.** Supersedes the
undated `customers/BELK/belk_schema_only.sql` (committed 2026-08-10; see "Drift"). ClickHouse:
`customers/BELK/belk_clickhouse_schema.sql` (+ `belk_ch_rowcounts.tsv`), not covered here.

Contents: 320 tables (`public` 298, `target_setting` 22), 71 triggers on 23 tables, 88 functions + 6
procedures, 12 views, 2 MVs. Counts, every WHEN clause and the large routines are in
[SCHEMA_MAP.md](SCHEMA_MAP.md); this file explains what they do. `Lnnn` = `postgres_schema.sql` line.

Hierarchy (from function bodies): for a stylecolor row in `blk_h_prodstd`, `ancestor0` = style,
`ancestor1` = subclass, `ancestor2` = class, `ancestor3` = department (L8328, L9497). A style row is
shifted up one level: `ancestor2` = department (L3896, L13925).

## The hidden business-logic layer: triggers

None of this is in any git repo. **Observed** = read from the DDL. **Inferred** = from trigger
semantics, not yet confirmed with data. Per `knowledge/db-trigger-matrix.md`, only 14 of the 71 behave
the same as AEO: the 8 `set_timestamp_*` (`trigger_set_timestamp()` L12076), the two NOTIFY triggers,
`trigger_itemprice_fetchdepartment`, `set_mvv_indx`, `trigger_lifecycle_plan_update` and
`trg_p_strategy_params_set_apply_targets`. 14 more share a name with AEO but behave differently, and 43
don't exist at AEO.

**3 triggers are DISABLED in QA and never fire** (`DISABLE TRIGGER`; also listed in SCHEMA_MAP, `off` in the matrix):
`plan_queue_remove_dups` (L31132), `set_l_dependency_indx` (L31182), `trig_update_sty_vpn` (L31480).
They were already disabled in the August dump, so 68 are active. Check `pg_trigger.tgenabled` (`D` =
disabled) in the target env first.

### blk_ma_stylecolorchannelattributes — 14 triggers (lifecycle hot spot)

PK `(product, location)`. AFTER triggers fire in alphabetical order.

| Trigger | Fires on | WHEN | Function (Lnnn) → effect |
|---|---|---|---|
| `trigger_lifecycle_blank_null` | BEFORE UPD OF `dbt_wk, erlstmkdnwk, exitdate` | any of the three is NULL/'' in NEW | `lifecycle_blank_null()` (L8342) → resets **all three** to OLD |
| `dbt_trigger_on_update` | AFTER UPD OF `dbt_wk` | debut ≥ MD, **or** (`cloned_at` null and old debut < `plan_current`); depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L7411) → `UPDATE … SET dbt_wk = OLD.dbt_wk WHERE product = NEW.product`. Works, and hits **every channel** (no location filter). Same body as AEO; the WHEN adds a BOD-style "passed debut is locked" rule for non-cloned items |
| `md_trigger_on_update` | AFTER UPD OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut), passed MD on non-cloned, or exit ≤ MD | `md_trigger_on_update_validity_check()` (L8432) → sets `NEW.erlstmkdnwk := OLD…` and returns. **No-op** (see Quirks) |
| `exit_trigger_on_update` | AFTER UPD OF `exitdate` | exit ≤ MD or passed exit on non-cloned (depth guard only on the relaunch branch) | `exit_trigger_on_update_validity_check()` (L7489) → `NEW.exitdate := OLD…`. **No-op** |
| `ca_1_trigger_on_update` | AFTER UPD OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit; cloned, or old debut/exit > `plan_current`; depth=0 | `store_eligibility_trigger()` (L9476) → **deletes every** `blk_a_assortment` row of the product/location (all `plan_type`s; AEO deletes only `plan`) (L9550). Re-inserts rows for department floorsets whose **sales window** `slsstart..slsend` (AEO uses `ap_start..ap_end`) overlaps [min(debut, `relaunch_dbt_wk`), max(exit, `relaunch_exitdate`)], copying ranging from the first/last existing floorset (exact matches keep their own). Then `isfunded=1` on the floorset holding `dbt_wk` (L9680) and `isfunded=0` on gap floorsets between exit and relaunch debut (L9710) |
| `update_assortment_model_based_on_lifecycle` | AFTER UPD OF `dbt_wk, exitdate, relaunch_exitdate, relaunch_dbt_wk` | debut < MD ≤ exit, old debut/exit > `plan_current`, exit > MD; **no depth guard** | `store_eligibility_trigger()` again |
| `trigger_for_time_indx` / `trigger_for_time_indx_update` | AFTER INS OR UPD OF the 4 weeks + `relaunch_dbt_wk/_erlstmkdnwk/_exitdate` / AFTER UPD OF the 4 weeks | none / same ordering as `ca_1`, no depth guard | `update_week_indxes()` (L14807), see below. A valid update runs it twice |
| `trigger_lifecycle_plan_update` | AFTER UPD OF `erlstmkdnwk` | none | `lifecycle_plan_update()` (L8363) → **NULLs `dc_uservrp`/`dc_useradj`** in `blk_p_dc_adj` and `blk_p_dc_adj_size` for `time >= new MD`. Same as AEO |
| `trigger_auto_rollforward_true` | AFTER UPD OF `auto_rollforward` | new = true | `auto_rollforward_true()` (L2315) → every channel row of the product with `auto_rollforward` gets exit = `blk_serviceparams.extended_range` and MD = the week before, plus `exitdate_indx`/`mdstart_indx` |
| `tr_set_relaunch_is_valid` / `tr_validate_relaunch_is_valid` | BEFORE UPD OF `relaunch_dbt_wk` / OF `relaunch_is_valid` | none | L9234: a non-null relaunch debut sets `relaunch_is_valid = TRUE`. L14954: TRUE without a relaunch debut is forced to FALSE, and TRUE→FALSE **clears 9 `relaunch_*` columns** |
| `trigger_cost` | AFTER UPD OF `cc_target_cost` | none | `trigger_update_cost()` (L12111) → `cc_plan_cost/landed_cost/systemcost/existingwac` = target cost and recomputes `cc_imupct` on **all channels** (AEO's `trigger_cost` watches `cc_plan_cost` instead) |
| `set_timestamp_styleclrchannel` | BEFORE UPD | always | `updated_at`. Same as AEO |

#### update_week_indxes() (L14807): what a lifecycle save also changes

1. Converts `dbt_wk`, MD and exit to `blk_d_time.indx`, using raw `dbt_wk` (AEO is relaunch-aware).
2. **IRW = debut − 0**, so `initrcptwk` = `dbt_wk` ("Changed in January 2025 per Belk and S5
   agreement"). No `irw_debut_offset` lookup like AEO.
3. **Last DC order = MD − 6** → `lastdcorder`, `last_rcpt_wk`, `lastdcorder_indx`. Same as BOD; AEO and
   TRD use MD − 4. No `auto_rollforward` branch (AEO: MD − 1) and no `planned_sell_down_week`.
4. `too` = MD − debut, `mkdnwks` = exit − MD. Moving `dbt_wk` while `OLD.dbt_wk = OLD.act_dbt_wk` also
   moves `act_dbt_wk`.
5. Steps 2–4 run only when debut < MD < exit **and** old debut or old exit > `plan_current` (AEO has no
   OLD check). Writes are per `(product, location)`.
6. Relaunch block: when `relaunch_dbt_wk < relaunch_erlstmkdnwk < relaunch_exitdate`, fills
   `relaunch_*_indx`, `relaunch_too/mkdnwks` and `relaunch_initrcptwk` (= relaunch debut).
   `relaunch_last_rcpt_wk_indx` comes from the user-set `relaunch_last_rcpt_wk`.

### blk_ma_stylecolorattributes — 12 triggers (PLM / lock / revert)

| Trigger | Fires on | WHEN | Function (Lnnn) → effect |
|---|---|---|---|
| `trig_cc_createdate_revert` **(new)** | BEFORE UPD OF `cc_aa_ind` | old `ccstylecolorcreatedate` not null/''; depth=0 | `revert_non_editable_columns()` (L9097) → `NEW.cc_aa_ind := OLD.cc_aa_ind`. **Silent revert, no error raised** |
| `trg_upd_cc_prepublish` | BEFORE UPD OF `cc_prepublish` | none | `set_prepublished_at()` (L9193) → TRUE stamps `cc_prepublished_at` = NOW − 4h. Anything else is coerced to `false` |
| `trg_lock_stylecolor` / `trg_unlock_stylecolor` | AFTER UPD OF `cc_prepublish` | new TRUE / new FALSE-NULL; depth=0 | `lock_stylecolor()` (L8398) → `cc_is_locked='Y'`, **`ccstylecolorcreatedate='3000-01-01'`** (temp lock, L8406), `cc_last_published_by`, and temp-locks the style. `unlock_stylecolor()` (L12200) clears a `3000-01-01` lock; the style unlocks only when no sibling is still locked |
| `trig_upd_on_color_change` | AFTER INS/UPD OF `cccolor` | none | `update_color_change()` (L12363) → `cccolorid/cc_color_desc` from `blk_v_memberbasedvalidvalues`, family/code from `blk_l_dependencylookup`. Renames `blk_d_product` to `<style>.<colorid>` / `<style desc> <color desc>` (or `.NoColor`) |
| `trig_upd_on_ticketprice` | AFTER UPD OF `cc_msrp, cc_current_retail` | none | `update_ticket_price()` (L14684) → MSRP goes to `ccticketpricechannel` (all channels) and `blk_a_assortment.a_msrp`. Placeholders (no create date) also get `cc_current_retail = msrp`. Current retail goes to `a_current_retail` on **every** floorset row |
| `trig_set_design_img` | AFTER UPD OF `cc_vpn` | none | `set_design_img()` (L9133) → PLM styles not on hold: archives `blk_ma_imgattributes`, sets `img` = specstyle design image ?? oldest archived image |
| `trig_update_cc_vpn_color` | AFTER UPD OF `cc_vpn_color_display` | none | `update_cc_vpn()` (L12251), PLM only. If another CC already has the same color + buy period, it **reverts the display**. Otherwise it moves the color out of the `blk_l_dependencylookup` pool, sets `cc_vpn_color/_desc` and `cccolor` (which cascades to the rename above). Clearing the display **deletes the CC's `blk_ma_stylecolorweekattributes`** |
| `trig_insert_stylecolorweekattributes` / `trig_update_stylecolorweekattributes` | AFTER UPD OF `cc_vpn_color` | first color (old null/'') / color changed with the same `cc_vpn` | `insert_stylecolorweekattributes()` (L8261) → loads week rows from `blk_specstyle_attr_week` (min `hq_id`), then **`cc_target_cost = plm_cost`** (L8296). `update_stylecolorweekattributes()` (L14523) → deletes and reloads the week rows |
| `trg_update_of_cc_vpn_buy_period` | AFTER UPD OF `cc_buy_period_descr` | depth=0 | `update_of_cc_vpn_buy_period()` (L12657) → rebuilds `cc_vpn_buy_period`, **clears `cc_vpn_color/_desc/_display`** |
| `set_timestamp_stylecolorattr` | BEFORE UPD | always | `updated_at`. Same as AEO |

### blk_ma_styleattributes — 8 triggers (VPN / supplier / size run)

| Trigger → function (Lnnn) | Effect |
|---|---|
| `trig_update_plm_sty_vpn` → `update_plm_sty_vpn()` (L13912) | VPN already used by another style → **reverts `sty_vpn`** and nulls the children's VPN colors. Otherwise: children's `cc_vpn` = VPN with colors cleared, week rows deleted, old VPN returned to the `blk_l_dependencylookup` pool and new one removed, supplier site taken from specstyle, and **style + stylecolor names/descriptions rewritten to the VPN** (restored from `sty_style_name/description` when the VPN is cleared) |
| `trig_update_sty_vpn` → `update_stylecolorattributes_cc_vpn()` (L14364) | **DISABLED in QA (L31480).** Its effect (children's `cc_vpn` = VPN, color nulled, week rows deleted) is covered by `update_plm_sty_vpn` above, so `sty_vpn` edits go only through the August-changed L13912 body |
| `trig_update_sty_vpn_non_plm` → L14393 | `sty_vpn_id_non_plm` edit → children's `cc_vpn` = it, `cc_vpn_color` nulled. Non-PLM styles also get `sty_vpn_final` |
| `trg_set_sty_dpt_buy_period` → `set_sty_dpt_buy_period()` (L9255) | Changing the buy period on a style with a VPN **clears `sty_vpn`** (which cascades to the VPN trigger above) and the children's buy period. Blanking it clears VPN and buy-period fields. Otherwise it pushes `cc_buy_period_descr` to children |
| `trig_update_supp_attr` → `update_styleattributes_supp()` (L14124) | New supplier site → 17 `supp_*` fields from `blk_l_dependencylookup`, then recomputes pinch-PO publish names |
| `trig_remove_supp_attr` → `remove_styleattributes_supp()` (L9033) | Blank supplier site → NULLs 18 supplier fields |
| `update_ccrangecode` → `update_stylecolorchannelattributes_ccrangecode()` (L14430) | Fires on `sty_size_range` but tests **`sty_size_run_name`**. It acts only if the run name changed in the same statement and the style is unlocked: children get `ccrangecode = <run name> - <class>` + `cc_validsizes_store/ecom`. Otherwise it **writes `sty_size_run_name` back to OLD**. No size-member regeneration (BELK's `sizerangecode_*` functions are unattached) |

### Quirks (all from the DDL)

- **MD and Exit validity reverts are dead code.** *Observed:* both functions only set `NEW.x := OLD.x`
  and return NEW (L8432, L7489), but the triggers are AFTER (L31106, L31074), and Postgres ignores an
  AFTER row trigger's return value. AEO's versions run an `UPDATE`. An unattached BEFORE-style
  `dbt_trigger_before_update_validity_check` (L7430) also exists. *Inferred:* the bodies were rewritten
  for BEFORE triggers that were never recreated. An invalid MD/exit save sticks, `update_week_indxes`
  skips it (stale `*_indx/too/mkdnwks/lastdcorder`), and `lifecycle_plan_update` still wipes DC user
  adjustments from the new MD. Check prod `pg_trigger` before telling the customer.
- **`cc_aa_ind` is frozen once a CC has a create date** (L31406). The host system sets
  `ccstylecolorcreatedate` (comment at L1028), and so does a prepublish temp lock (`3000-01-01`, L8406).
  Because direct UPDATEs run at depth 0, ETL and procedure writes are reverted too. *Inferred:* the UI
  "saves", but the value reloads unchanged.
- **One blank week reverts all three** (L8342). *Inferred:* on a row that already has a NULL
  exit/MD/debut, a save that sets only one week is dropped. Set all three at once.
- **A lifecycle change drops floorset prices.** *Observed:* the `store_eligibility_trigger` re-inserts
  (L9561/L9599/L9638) omit `a_msrp`, `a_current_retail` and `a_current_retail_override`, and reset
  `propagate_ranging` to 1. *Inferred:* they stay NULL until a price trigger or the batch rewrites them.
- **Double runs / no-op on INSERT.** A valid lifecycle edit runs `store_eligibility_trigger` and
  `update_week_indxes` twice each. *Inferred:* on INSERT, `update_week_indxes` does nothing because its
  guards read OLD (NULL), so new rows (e.g. the L3807 pre-assortment) get no `*_indx`/`lastdcorder`
  until their first edit.
- **Target cost is overwritten by PLM cost** on the first VPN color (L8296) and on any `hq_id` change
  (L14655). `trigger_update_cost` divides by `ccticketpricechannel` (L12132). *Inferred:* a 0 ticket
  price fails the save (the default is 0.01, L18780).
- **Image hold** (L11876, L11937): while `hold_img='YES'`, a non-scene7 `img` edit reverts to
  `img_held`. With no hold, the *previous* image is stored in `img_from_etl`. A scene7 (ECOM) image
  clears the hold. Un-holding sets `img = img_from_etl`.
- **Misc:** `set_prepublished_at`/`update_pinchpo_published` stamp NOW − 4h (hard-coded US-East shift),
  while `trigger_set_publish_timestamp` uses NOW and rewrites `created_at`. The publishability checks
  (L6036/L6079) test `IS NOT NULL OR <> ''`, which lets '' pass.

### Other notable triggers

| Table | Trigger → function (Lnnn) | Effect |
|---|---|---|
| `blk_a_assortment` | `trg_upd_assortment_ranging` → `propagate_assortment_to_floorsets()` (L8544) | Store-attribute ranging (grade, segmentation, AA/Hisp ind, lifestyle 1–4, climate, state, `*_or`) and SSG are mutually exclusive; empty attributes are filled from `blk_ma_dptflrsetattributes.default_*`. The result is **pushed to this and every later floorset** row. `store_count` is copied as-is (L8834); AEO recomputes it. Skipped when `plan_type='ranging'` |
| `blk_a_assortment` | `trg_to_update_source_of_ranging_edit` → `reset_plan_type_to_plan()` (L9070) | `plan_type='ranging'` edit → sets `plan_type='plan'` on this and later floorsets (the marker skips propagation). Same as EE/KW |
| `blk_a_assortment` | `trig_override_ticket_price` → `override_ticket_price()` (L8486) | `a_current_retail` = override, or (cleared) MSRP for placeholders / `cc_current_retail` for created CCs, for that `time` across locations |
| `blk_ma_imgattributes` **(new)** | `img_update` → L11876; `set_held_img` → L11937 | Image-hold logic, see Quirks |
| `blk_h_prodstd` **(new)** | `h_prod_updatescname` → `updatescname_if_style_changed()` (L14915) | Stylecolor moved to another style (`ancestor0`) → `blk_d_product` renamed `<style name>.<cccolorid>` / `<style desc> <cc_color_desc>`. No WHEN or depth guard; runs DROP/CREATE TEMP TABLE per row |
| `blk_d_product` | `trigger_upd_name_description` → L12579; `_style` → L12608 | Style rename → child names/descriptions. Editing a **stylecolor** description overwrites the **style** description, then rebuilds every sibling as `<style desc> <color desc>` |
| `blk_ma_stylecolorweekattributes` | `_post_hq` → L14613; `_null_hq` → L14566 | New `hq_id` → refresh PLM fields from `blk_specstyle_attr_week` and **set all cost columns + `cc_imupct` from `plm_cost`**. Cleared `hq_id` → PLM fields NULLed |
| `blk_p_pinchpo` (7) | `ispublished_pinchpo` → L13872; `poname_pinchpo_ecom/_store/_nad_nbd/_empty` → L12777/L13564/L13131/L13086; `trg_remove_pinched_store` → L8880; `set_timestamp_pinchpo` → L12093 | Publish → `spo/po_status_store='PUBLISHED'` and **upserts `blk_p_dc_adj.dc_publish`** (unpublish sets 0 but leaves the statuses). Publish PO names = the user name for the first group, otherwise `<name>:<bi_flg>:<nad>:<nbd>:<supplier>[:<style>]`, split by supplier site, NBD/NAD and BI style; blank NBD/NAD are defaulted from the week. Re-pinching a store removes it from the oldest line. *Inferred:* the scalar subquery errors when 2+ stores are duplicated |
| `blk_p_dc_adj` | `set_timestamp_p_dc_publish_adj` → `trigger_set_publish_timestamp()` (L12033) | `dc_publish=1` stamps `created_at/published_at`. **No outbound queue** (no `sync_outbound_dataqueue` table) and no INSERT twin |
| `blk_p_itemprice` | `trigger_eff_aur` → `update_eff_aur()` (L12432) | `eff_aur` = `eo`, else the `blk_l_priceeventlookup` expression on `ccticketpricechannel` (falls back to `cc_msrp` if ≤ 0), else that price |
| `blk_p_strategy_params` | `trg_blk_p_strategy_params_sync` → L3597 | `rec_magnitude`, `apply_targets_to_plan` or `cluster_group_selected_type` copied to every row with the same product + quarter. *Inferred:* combined with the Carryover/Future → NULL rule (L11856), a sync can push NULL back onto siblings |
| `blk_p_stylecolor_extra_params` | `trg_validate_reset_inv_for_relaunch` → L7854 | `reset_inv_for_relaunch=1` forced to 0 unless `relaunch_is_valid` |
| `plan_queue` | `plan_queue_remove_dups` → `remove_dup()` (L8853), statement-level | **DISABLED in QA (L31132).** If it were re-enabled, it would delete *every* row of any `(product, initiator)` pair that has duplicate error-free rows, including the original, ignoring location and completed state. Don't re-enable it without fixing that |
| `cart_params` | `trigger_cartparams_ranging` → L14726 | Cart `cart_ranging` rebuilt over floorsets in [max(debut, `plan_current`), min(exit, `plan_end`)]. No IRW-offset cart trigger (IRW = debut) |
| `blk_l_dependencylookup` | `set_l_dependency_indx` → L11989 | **DISABLED in QA (L31182).** The column has no default, so inserts that omit `index` (`add_to_assortment` L737/L744, `update_plm_sty_vpn` L13987) leave it NULL. `update_cc_vpn` computes its own max + 1 (L12300) |
| misc | `on_plan_queue_change`/`on_pivot_execution_change` (L8469/L8456), `trg_blk_p_quick_pre_assortment_sheet_qs_status` (L9215), `set_size_id` (L12054), `set_mvv_indx` (L12011), `set_timestamp_specstyleattributes` (skipped when `updated_by='system'`) | LISTEN/NOTIFY backend eventing (same at all clients); `qs_status` forced to `IN USE`; size id from `size_ids`; next `indx` = max + 1 |

Unattached trigger functions: `calc_store_count_ranging`, `dbt_trigger_before_update_validity_check`,
`delete_duplicate_invalids`, `revert_to_original`, `sizerangecode_isvalid`,
`sizerangecode_validsizes_members`, `unlock_style`, `update_pim_style_id`, `update_pim_stylecolor_id`.
**Not present at BELK** (unlike AEO): the casepack "PO publish won't stick" rule, the RDY4PO/PO outbound
queue, size-member regeneration, the IRW floorset-field trigger, and the worklist/alloc triggers.

## Big procedural code (not triggers)

- `add_to_assortment()` (L172, ~2,115 lines) materializes a cart into the plan. Read
  `knowledge/backend/ann-add-to-assortment.md` first, since it has the same shape. BELK specifics:
  "similar" clones get a NULL create date (L1028); `cc_is_locked='Y'` only with a create date (L1144);
  `plan_current` is stamped on all added rows (L1494/L2197); results are queued in `plan_queue` (L1674).
  `test_2` (L9780) is an older debug copy.
- ATA upload: `validate_transform_uploads_ata` (L14994), `commit_upload_ata` (L6125), `undo_upload_ata`
  (L12147). Clones: `blk_style_clone_stylecolor_size_proc` (L4472),
  `blk_no_style_clone_stylecolor_size_proc` (L2343), and `blk_plan_these_cloned_style_stylecolors_proc`
  1-arg (L3631, queues `CP-1`) and **5-arg (L3807, new)**. The 5-arg version builds placeholder styles,
  CCs (colors = the first N `cccolorid` valid values), sizes, channel rows and `blk_a_assortment`
  (`isfunded=1`) from `blk_p_preassortment_stylesheet`, then queues them. **`create_new_styles` (L7150,
  new)** creates UUID styles from a `style<<>>stylecolor` list, copying the reference style's attributes
  (including lock/create-date fields) and hierarchy row.
- Helpers: `fetch_store_count`/`get_store_count` (L7645/L8063), `get_default_params` (L7899),
  `can_remove_from_assortment` (L5998: blocked by DC publish, EOH or prepublish), `check_ispublishable`
  (L6079: needs a create date, plus `hq_id` for PLM).

## Views and materialized views

`target_setting` MVs `actuals_wide_denorm` (L29478) and `sys_gen_wide_denorm` (L29887) sit over the
`*_denorm` views. This is AEO's MFP pattern: they only change when the batch REFRESHes them.
`plan_status` (L28168) gives queue status from `plan_queue` timestamps. `blk_clustering_needs_attention`
(L18898) lists depts with missing/unapproved clusters. `blk_stylecolor_hier_attr` (+ `_cyclic`,
`_intraday`) and `blk_store_hier_attr` are flattened attribute views. 125 platform tables (carts,
`plan_queue`, `pivot_execution`, `sync_pg_ch*`, `user_metadata`, …).

## Drift since the August dump

From `python3 tooling/db/schema_map.py diff customers/BELK/belk_schema_only.sql customers/BELK/db/postgres_schema.sql --labels BELK-aug BELK-oct`:
- **4 new triggers:** `trig_cc_createdate_revert` (L31406), `img_update` (L31090), `set_held_img`
  (L31172), `h_prod_updatescname` (L31082). No existing trigger's events or WHEN changed. The 3 DISABLED
  triggers were disabled in both dumps.
- **New routines:** `revert_non_editable_columns`, `trigger_img_update`, `trigger_set_held_img`,
  `updatescname_if_style_changed`, `create_new_styles`, and the 5-arg clone proc. **Removed:**
  `ata_snapshot`, `insert_phantom_ccs_into_p_quick_pre_assortment_sheet`.
- **Bodies changed:** `set_design_img` now skips held images. `update_plm_sty_vpn` takes the VPN description as `max(vpn_desc)` within the style's department (previously the longest across all departments). `add_to_assortment` gained the conditional `cc_is_locked` and separate `plan_current` stamping. `commit_upload_ata`: the template's `store_min_multiple` now feeds `cc_store_min_multiple`, and `cc_ordermultiple` comes from defaults (SUP-3813, L6667).
- **Tables:** 20 new, including `blk_p_preassortment_status`/`_stylesheet` (L23807/L23827) and backups
  such as `blk_ma_imgattributes_sup_4523` (L20762). *Inferred:* the image-hold triggers came with
  SUP-4523. The 13 dropped tables were dated/temp copies.

## Triage implications

| Symptom | Look at |
|---|---|
| MD/exit saved in an invalid order; weeks or `lastdcorder` not recomputed | Dead MD/exit reverts. Check `pg_trigger` in that env and compare `*_indx` to the weeks |
| Debut reverts on save | `dbt_trigger_on_update`: debut ≥ MD, or a passed debut on a non-cloned CC. The revert applies to all channels |
| AA indicator edit doesn't stick | `trig_cc_createdate_revert`. Check `ccstylecolorcreatedate` (a real date, or `3000-01-01` = prepublished) |
| Lifecycle edit silently ignored | A blank week on the row (`lifecycle_blank_null`) |
| DC user adjustments disappeared | MD moved, even an invalid MD (which now sticks) |
| Floorset prices/overrides blank after a debut/exit change | `store_eligibility_trigger` re-insert |
| Target cost / IMU reverted | PLM cost from week attributes (VPN color or `hq_id` change) |
| Image keeps reverting | `hold_img` / `img_held` / `img_from_etl` in `blk_ma_imgattributes` |
| VPN, VPN color or buy period cleared | `set_sty_dpt_buy_period`, `update_of_cc_vpn_buy_period`, the VPN-uniqueness reverts |
| Item never planned | `plan_status` (L28168). The de-dup trigger is disabled in QA, so it isn't the cause there |
| Bulk/ETL behaves differently than the UI | depth=0 guards. A direct UPDATE is depth 0 too, so the `cc_aa_ind` revert also blocks ETL |

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, run `python3 tooling/db/schema_map.py regen`
(SCHEMA_MAP + trigger matrix), diff against this dump for manual DDL drift, and re-verify the `Lnnn`
references.
