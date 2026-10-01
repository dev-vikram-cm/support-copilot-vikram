# EXP (Express) Postgres — schema knowledge (from postgres_schema.sql)

Snapshot: **QA**, db `exp`, server 14.22, dumped 2026-10-01 15:05 IST (pg_dump
18.6, schema-only; header L1). **Prod/Staging not captured.** Generated detail is in
[`SCHEMA_MAP.md`](SCHEMA_MAP.md); `Lnnn` = `postgres_schema.sql` line; cross-client
diff is in `knowledge/db-trigger-matrix.md`; repos are in `customers/EXP/repos.json`.

Contents: 555 tables, 46 triggers (**5 disabled**), 60 functions, no procedures,
14 views, **no MVs**, 19 indexes. Only schema `public` (no MFP schemas, unlike AEO/TRD).

## Table families: what's real and what's clutter

The tenant prefix is **`exp01_`** (not `exp_`). By name (*Inferred*), only about
150 of the 555 tables are live:
- **Model (~67 `exp01_*`)**: `d_`/`h_`/`ma_`/`l_`/`p_` tables, `a_assortment`,
  `serviceparams`, `v_memberbasedvalidvalues`, `an_price_storecount_info`.
  **Platform (~80)**: `cart_*`, `plan_queue`, `pivot_execution`, `scope`,
  `undo_*`, `user_*`, `dept_plan_items`, `sync_outbound_dataqueue` (L21557),
  `s5_profile_master*`, `md_strategy`, `size_ids`, `databasechangelog`.
- **Clutter (~400)**: about 190 `exp01_*` copies with date/`_bk`/`_backup`/
  `_old`/`_temp`/`_dp5`/`_2`/`_3` suffixes (23 of `a_assortment`, 20 of the
  channel table), 102 uuid-suffixed `dc_adj[_size]<hex>`/`channeloverride<hex>`
  work tables (nothing in this dump creates them), and about 40
  `dept_plan_items_*`/`plan_queue_*` backups, plus `deleteme_*` and `frank_test_*`.
- **These look like junk but are live**: `trigger_trial` (L21947), `exp01_ma_imgattributes_archives`,
  `debug_stats_ts`, `pricing_table`. The PK names `exp01_a_assortment_2_pkey`
  (L23314) and `..._channelattributes_2_pkey` (L23710) suggest the live tables
  were swapped in by rename (*Inferred*); query the unsuffixed name.

Hierarchy (L8113–L8121): stylecolor row `ancestor0` = style, `1` = subclass,
`2` = class, `3` = department, … `7` = division. On a style row, `ancestor1` is
the class (`CL-nnnn`, L24456). Sizes have `ancestor0` = stylecolor (L4574).

## The hidden business-logic layer: triggers

Not visible in the app; some of it is in `etl-exp-batch` liquibase. **Observed** =
read from the DDL. **Inferred** = from trigger semantics, not confirmed with data.

### exp01_ma_stylecolorchannelattributes — 12 triggers, 1 disabled (the hot spot)

PK `(product, location)` (L23710), table at L8019. `plan_current` is a
**column on each row** (L8075), not the serviceparams value.

| Trigger | Fires on | WHEN | Function (Lnnn) → effect |
|---|---|---|---|
| `md_trigger_on_update` (L24180) | AFTER UPD OF `erlstmkdnwk` | MD ≤ (relaunch ?? debut) or exit ≤ MD, **or past-lock**: no relaunch → OLD MD < `old.plan_current`; relaunch → NEW MD < `old.plan_current`; depth=0 | `md_trigger_on_update_validity_check()` (L4630) → **`SET erlstmkdnwk = OLD`** on every channel of the product. Same body as AEO; only the WHEN differs |
| `exit_trigger_on_update` (L24156) | AFTER UPD OF `exitdate` | exit ≤ MD **or** OLD exit < `old.plan_current`; depth=0 | `exit_trigger_on_update_validity_check()` (L3914) → **`SET exitdate = OLD`** (all channels) |
| `dbt_trigger_on_update` (L24140) | AFTER UPD OF `dbt_wk` | debut ≥ MD **or** OLD debut < `old.plan_current` ("passed debut is locked"; the matrix shows it identical to BOD); depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L3815) → **`SET dbt_wk = OLD`** (all channels) |
| `ca_1_trigger_on_update` (L24104) | AFTER UPD OF `dbt_wk, relaunchweek, exitdate` | (relaunch ?? debut) < MD < exit **and** (OLD debut or OLD exit > `old.plan_current`); depth=0 | `store_eligibility_triger_chetan()` (L4976) → deletes the item's `plan_type='plan'` rows in `exp01_a_assortment` and rebuilds them for floorsets whose **sales window** `slsstart..slsend` overlaps [raw `dbt_wk`, exit], copying the nearest floorset's ranging. Then sets `isfunded=1` on the floorset whose `ap_start..ap_end` holds `dbt_wk` (no location filter). AEO uses the ap window and is relaunch-aware |
| `trigger_for_time_indx_insert` (L24392) | AFTER INSERT | (none) | `update_week_indxes()` (L7631), see below |
| `trigger_for_time_indx_update` (L24400) | AFTER UPD OF the 4 weeks | same as `ca_1` but **no depth guard** | `update_week_indxes()` |
| `trigger_lifecycle_plan_update` (L24416) | AFTER UPD OF `erlstmkdnwk` | (none, no depth guard) | `lifecycle_plan_update()` (L4574) → **NULLs `dc_uservrp`/`dc_useradj`** in `exp01_p_dc_adj` and `_size` for `time >= new MD`. Identical to AEO |
| `trigger_sizerangecode_validsizes_members` (L24432) | AFTER UPD OF `ccrangecode` | (none) | `sizerangecode_validsizes_members()` (L4844) → regenerates size members from `exp01_l_dependencylookup` (`lookup_id='ccrangecode'`). It rewrites `exp01_ma_sizeattributes`, adds `exp01_d_product` rows (`<stylecolor>-<size>`) and `exp01_h_prodstd` rows, writes `validsizes` back to this row, and **NULLs `exp01_p_dc_adj_size.dc_useradj`** for invalid sizes. This is an older version than AEO's (AEO reads `size_range_mapping`) |
| `trigger_sizerangecode_isvalid` (L24424) | AFTER UPD OF `validsizes` | (none) | `sizerangecode_isvalid()` (L4782) → resets `exp01_ma_sizeattributes.isvalid` from this row's `validsizes`. Same as AEO |
| `on_cc_flrset_update` (L24188) | AFTER UPD OF `cc_flrset` | (none) | `trigger_update_ccfloorset()` (L6774) → copies the value to `exp01_ma_stylecolorattributes.ccfloorset` and logs a row to `trigger_trial` |
| `update_pricing_store_trig` (L24464) | AFTER UPD OF the 4 weeks | as `ca_1` | **DISABLED** (L24466). `update_pricing_store_info()` (L7027) would rebuild `exp01_an_price_storecount_info` |
| `set_timestamp_styleclrchannel` (L24334) | BEFORE UPDATE | (always) | `trigger_set_timestamp()` (L6745) → `updated_at` |

AEO-only here: `trigger_for_time_indx`, `trg_set_floorset_fields_on_initrcptwk_change`,
`trg_cc_validsizes_on_change`, `trigger_cost`, `trigger_remove_from_assortment`.

#### update_week_indxes() (L7631): what a lifecycle save also changes

EXP *does* have these triggers: the matrix `·` is only the generic `trigger_for_time_indx`.
EXP has `_insert` (`B`) and `_update` (`D`), so unlike AEO it doesn't run twice.
1. Converts debut (`relaunchweek ?? dbt_wk`), MD and exit to `exp01_d_time.indx`.
2. **IRW = debut − 3 weeks, hardcoded** → `initrcptwk`/`irw_indx`. There's no
   `irw_debut_offset` in the dump (AEO reads it per floorset).
3. **`last_rcpt_wk` = MD − 6** (like BOD; AEO/TRD use MD − 4). `lastdcorder[_indx]`
   is **not** written (commented out), and there's no `auto_rollforward` branch.
4. `too` = MD − debut; `mkdnwks` = exit − MD. No `act_dbt_wk` follow-along and no
   ordering check inside: INSERT always runs (NULL weeks → NULL indexes), and
   UPDATE relies on the WHEN. Writes only this `(product, location)` row.

### Quirks worth knowing

- **5 triggers are DISABLED in QA, and SCHEMA_MAP/the matrix list them as
  live.** *Observed* (`DISABLE TRIGGER`): `update_pricing_store_trig` (L24466; changeset
  `disable_update_pricing_store_trig`, `etl-exp-batch` `database_changes/postgres/changelog_current.xml:65`),
  `sync_stylecolor_subsizerange` (L24344), `set_timestamp_styleattr` (L24326) and
  `ca_2_trigger_on_insert/_delete` (L24124/L24114). Styleattributes `updated_at` **is
  still maintained** by the enabled duplicate `set_timestamp_style` (L24316, same
  function). Check `pg_trigger.tgenabled` in each env.
- **Past-week lock uses the row's own `plan_current`.** *Observed:* stamped by
  `add_to_assortment` (s51, L1048, run at L1599) and carried from Vertica by the
  batch (`bash/daily/09_vertica_daily_export_copy_to_pgsql_for_daily.sh:22`).
  *Inferred:* when it's NULL, the lock never fires, and the `ca_1`/`_indx_update`
  WHENs are NULL too, so edits get no floorset rebuild and no IRW recalculation.
- **The MD lock is asymmetric.** *Observed (L24180):* without a relaunch it blocks
  moving a passed MD; with a relaunch it blocks moving MD *into* the past.
- **A rejected edit can leave side effects behind.** *Inferred:* AFTER triggers fire
  in name order. Take a valid-order edit rejected only by the past-lock, such as
  moving a passed debut: `ca_1` first rebuilds floorsets for the *rejected* debut,
  then `dbt_trigger_on_update` reverts `dbt_wk`, then the outer `_indx_update` (no
  depth guard) overwrites `initrcptwk`/`*_indx`/`too` from the rejected NEW row.
  `ca_1` never re-runs. AEO can't hit this, because there the revert and the
  recalculation need opposite orderings. For MD, `lifecycle_plan_update` also wipes
  adjustments from the rejected MD.
- **Validity reverts hit every channel** (*Observed*: they filter on `product` only), as in AEO.
- **Channel floorset can't differ by channel.** *Observed:* L6762/L6774 sync
  stylecolor `ccfloorset` ↔ all channels' `cc_flrset`, and each fire adds a
  `trigger_trial` row (that table grows without bound). Changing `ccrangecode`
  is destructive, the same as AEO.

### Other notable triggers

| Table | Trigger → function | Effect |
|---|---|---|
| `exp01_ma_styleattributes` | `update_ccsizerange` (L24448, depth=0) → `create_hidden_ccsizerange_mod()` (L3495) | `express_size_range` edit. It is **reverted to OLD** unless the value changed **and** `OLD.ccstylecreatedate IS NULL` (the SUP-522 rule). An OLD of NULL also reverts, because `<>` returns NULL. If allowed, it sets `ccsizerange = <range>-<class>` and maps each child's `ccrangecode` to the same `sub_size_range` via `s5_profile_master` (falling back to `_max_default`), which triggers size regeneration (the `ccsizerange` → children cascade is **disabled**). If no child maps, the edit reverts |
| `exp01_h_prodstd` | `update_ccsizerange_after_class_change_ancestor1` → `create_hidden_class_ccsizerange_mod()` (L3648) | Style moved to a new `CL-%` class → rebuilds `ccsizerange`/`express_size_range` and the children's `ccrangecode`. There is no revert branch |
| `exp01_ma_styleattributes` | `update_tktp_across` → `update_stylecolor_ticketprice()` (L7512) | Style `ccticketprice` **overwrites `ccticketpricechannel`** on every channel of every child. It also touches `exp01_p_itemprice.updated_at`, which re-runs `trigger_eff_aur` |
| `exp01_ma_styleattributes` | `set_ccspecstylestyleclr` → `trigger_set_ccspecstylestyleclr()` (L6546) | Spec style → children's `ccspecstylestyleclr`, plus `size_range_lookup`/`fabric_lookup` from the lookup. If `exp01_specimages` has an image, it archives the child image rows, then **overwrites `img` even when held** |
| `exp01_ma_stylecolorattributes` | `set_is_publishable` → `trigger_set_is_publishable()` (L6663) | `ispublishable='1'` when spec style-color and `ccplmcolor` are both non-NULL. The `''` check comes second, so blanks count as publishable |
| `exp01_ma_stylecolorattributes` | `trig_upd_on_color_change` → `update_color_change()` (L6786) | `cccolor` → `d_product` name `<style>-<first word>` and description `<style desc>-<cccolor>`. Also sets `cccolorfamily`/`cccin` from the lookup. There's no "No Color" branch (AEO has one): **clearing `cccolor` NULLs the name** (SUP-4165 filtered NULL names out of the MemberMaster export) |
| `exp01_ma_stylecolorattributes` | `efo_lookup` → `efo_lookup()` (L3853) | `retail_stylecolor_efo` (matched by **name**) → deletes and re-inserts the item's image row with the EFO item's image (resets the hold and ETL image columns). Copies the EFO ticket price and GP-01 WAC/IMU into `efo_rtl_*` |
| `exp01_ma_imgattributes` | `img_update` → `trigger_img_update()` (L6485); `set_held_img` → `trigger_set_held_img()` (L6590), both depth=0 | A non-`images.express.com` image keeps a held image. An `images.express.com` (ECOM) image clears the hold and wins. **Releasing a hold sets `img = img_from_etl`**, so the planner's image is dropped |
| `exp01_a_assortment` | `trg_upd_assortment_ranging` (depth=0) → `propagate_assortment_to_floorsets()` (L4694) | A ranging change (`strmens/strwomenscapacity, strcorpvoltier, strclimate, grade, ssg`) recomputes `store_count` (`get_store_count` on the floorset's `slsstart`, or SSG cardinality) and **pushes it to every later floorset** (`time >= NEW.time`, a text compare). No SSG/attribute exclusion or defaults (AEO has both) |
| `exp01_a_assortment` | `trigger_assortment_blank_checks` → `assortment_blank_checks()` (L3282) | EXP-only. On `plan` rows with `ssg='{""}'`, blank `grade`/`strclimate`/`strmenscapacity`/`strwomenscapacity` → `{A}`/`{COLD}`/`{AVERAGE}`/`{AVERAGE}` |
| `exp01_p_dc_adj` | `set_timestamp_p_dc_publish_adj` → `trigger_set_publish_timestamp()` (L6690) | `dc_publish=1` → stamps `published_at` **and `created_at`**, queues **`OP_SNAPSHOT`** (AEO queues `RDY4PO`) with `time` = some channel's `dbt_wk` (LIMIT 1), and sets the first-publish fields. UPDATE only (no `_ins` twin). Re-saving 1 re-queues. EXP has no casepack/PO triggers |
| `exp01_p_itemprice` | `trigger_eff_aur` (depth ≤ 1) → `update_eff_aur()` (L6825); `trigger_itemprice_fetchdepartment` (L4554) | `eff_aur` = `eo`, else the `exp01_l_priceeventlookup` expression, else the channel ticket price. A channel price ≤ 0 falls back to style `ccticketprice` (AEO has no fallback). *Inferred:* if no price resolves, `EXECUTE` gets NULL and the write errors |
| `cart_params` / `cart_ranging` | `triger_cartparams_ranging` (sic) → `update_triger_cartparams_ranging()` (L7546); `calc_store_count` → `calc_store_count_ranging()` (L3372) | `cart_ranging` is rebuilt for floorsets whose ap window overlaps [max(debut, `plan_current`), min(exit, `plan_end`)]. Store count is computed on every write. No IRW-offset cart trigger |
| `exp01_d_product` | `trigger_upd_name_description` → `update_name_description()` (L6998) | Style rename → children's names become `<style>-<cccolorid>` and descriptions `<desc> <cccolor>` (a space, where the color trigger uses `-`) |
| `exp01_l_dependencylookup`, `exp01_ma_styleattributes` | `ca_2_*` → `hasbeenpatterned_*` (L4521/L4487); `sync_stylecolor_subsizerange` → `sync_ccsizerange_dependent_lookup()` (L5056) | **DISABLED in QA** (L24114/L24124/L24344), so they have no effect. If enabled, they would maintain the `hasbeenpatterned*` flags and push `ccsizerange` to the children's `ccrangecode`/`validsizes` |
| `pivot_execution` / `plan_queue` | `notify_*_change()` (L4649/L4662) | LISTEN/NOTIFY eventing, same as AEO |
| 8 tables | `set_timestamp*` → `trigger_set_timestamp()` (L6745) | `updated_at` maintenance: a_assortment, style/stylecolor/size/channel attrs, p_channeloverride, p_dc_adj[_size]. On styleattributes, `set_timestamp_styleattr` is **DISABLED** (L24326), but `set_timestamp_style` (L24316, enabled) still stamps it |

Small ones: `set_size_id` (L6723, from `size_ids.size_naem`, a real column),
`set_mvv_indx` (L6641, max+1), and `last_name_changes` on `employees` (L4609, a
PostgreSQL tutorial sample). Unattached `*_chetan`/`copy_inserted_*` are leftovers.

## Big procedural code (not triggers)

- `add_to_assortment()` (L100, ~1,580 lines) materializes a cart into the plan.
  It has the same shape as ann's, so read `knowledge/backend/ann-add-to-assortment.md`
  first, and follow the EXECUTE block at L1599+. It deletes and re-inserts
  channel rows (s38, L988), which fires `_indx_insert` (IRW = debut − 3, last
  receipt = MD − 6), stamps `plan_current` (s51) and logs to `debug_stats_ts`
  (L1175). The QA body matches git `sql_changes/20260305_add_to_assortment_from_qa.sql`
  on `etl_assortment_planning` (whitespace-normalized diff, 2026-10-01).
- Dev copies, **don't edit by mistake**: `add_to_assortment_2` (L1690), `_temp` (L2301),
  `test1`/`test2` (L5083/L5703), `testing_cart_chetan`/`testing_triger_chetan` (L5800/L6390).
- `update_pricing_store_info()` (L7027; its trigger is DISABLED) builds the
  weekly price and store-count series per selling channel (GP-01 → CH-01, or
  CH-02 when `grade` has `ECOM`; GP-03 → CH-03) with NEW/FLOW/LOF flags.

## Views (no MVs)

- `exp01_stylecolor_hier_attr` (L8089): hierarchy + attributes
  (`_hs`/`_mod`/`_testing` variants at L19463/L19599/L19741).
- `analytics_product_fcst_input` (L8236) reads `exp01_an_price_storecount_info` (L7806).
  *Inferred:* with the pricing trigger disabled, only `add_to_assortment` refreshes it
  (no `etl-exp-batch` script writes it), so it goes stale after lifecycle edits.
- `exp01_ma_dptflrsetattributes_view` (L15080) and its three `*_time_view`s read
  **`exp01_ma_dptflrsetattributes_old`**, not the live table. Nothing in ETL/config
  references them (*Inferred:* left over from a rename).

## Triage implications

- **"Lifecycle week reverts on save"** → validity triggers + past-lock. Compare
  the week with `plan_current` **on that row**, for every channel.
- **"Edit rejected but IRW/floorsets changed anyway"** → the name-order quirk.
  Check `initrcptwk` = debut − 3 and the `exp01_a_assortment` floorsets.
- **"IRW/last receipt not recalculated"** → `plan_current` NULL, item fully past, or
  bad ordering. IRW is always debut − 3 and last receipt MD − 6 (no floorset offset).
- **"DC user adjustments disappeared"** → MD moved (even a rejected move), or
  `ccrangecode`/size range changed.
- **"Cleared ranging came back as A/COLD/AVERAGE"** → `assortment_blank_checks`.
  **"Later floorsets changed"** → `propagate_assortment_to_floorsets`.
- **"Size range edit won't stick"** → `ccstylecreatedate` set, no `s5_profile_master` mapping, or old value NULL.
- **"Image reverted / held image lost"** → img/held-img, spec-style, `efo_lookup`.
- **"Stylecolor name blank"** → `cccolor` cleared. **"Channel price override lost"** →
  style `ccticketprice` edited. **"Forecast input stale"** → pricing trigger disabled.
- **"Works at AEO, not EXP"** → matrix letters, then `tgenabled`, then diff bodies.

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, run `python3 tooling/db/schema_map.py regen`,
and diff against this dump to catch manual DDL drift. Disabled triggers are listed in SCHEMA_MAP
and marked `off` in the matrix. EXP ClickHouse/Vertica not captured.
