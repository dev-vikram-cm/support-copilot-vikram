# BOD Postgres: schema knowledge (hidden lifecycle logic)

Snapshot: **QA**, db `bd`, server 14.22, full schema-only dump taken 2026-10-01
(`postgres_schema.sql`, pg_dump 18.6). The SUP-3857 **QA and Staging/Bonus** capture of
one table (2026-09-29) is kept in `bd_ma_stylecolorchannelattributes.sql`. **Prod has not
been captured.** Counts, triggers with WHEN, views: [`SCHEMA_MAP.md`](SCHEMA_MAP.md).
Cross-client: `knowledge/db-trigger-matrix.md`. `Lnnn` = a line in `postgres_schema.sql`.

Contents: 349 tables (`public` 316, `mfp` 28, `backups` 4, `debug` 1), 27 triggers
on 11 tables, 55 functions, 16 views, 2 MVs. Hierarchy (from function bodies): for
a stylecolor in `bd_h_prodstd`, `ancestor0` = style (L3727), `ancestor2` = category
(L2713), `ancestor3` = department (L2621, L3118); `ancestor5` keys price bands (L3758).

None of this is in any git repo, and environments drift silently (SUP-3857: QA was
hand-edited, a stale Staging copy kept the old version). When a value "changes by
itself", reverts, or differs between environments, diff this layer first
(`tickets/SUP-3857/diagnostic-queries.sql` §5). **Observed** = read from the DDL.
**Inferred** = derived from trigger semantics, not confirmed with data. Two Postgres
rules apply throughout: `AFTER UPDATE OF col` fires whenever `col` is in the SET
list, even if unchanged; AFTER triggers on one event fire in alphabetical order.

## Drift check: 2026-09-29 capture vs 2026-10-01 dump

**Identical to the 2026-09-29 capture.** *Observed* (mechanical diff): table DDL
(69 columns incl. `ticketprice_locked`, PK `(product, location)`, L8316, L18213),
all 10 triggers (L18936–L19144) and the 5 captured functions are byte-identical.
Only cosmetic: `trigger_update_price` lists the same 12 price columns in another
order (pgAdmin sorts by column position, pg_dump doesn't). QA has not changed since
SUP-3857. Bonus matched QA on 09-29 and has not been re-checked.
**No disabled triggers in QA:** the dump has no `ALTER TABLE … DISABLE TRIGGER` (or
`ENABLE REPLICA/ALWAYS TRIGGER`) lines, so all 27 fire. The 09-29 capture holds only
CREATE statements and could not have shown a disabled state; check
`pg_trigger.tgenabled` when capturing Bonus/Prod.

## bd_ma_stylecolorchannelattributes: 10 triggers (the hot spot)

| Trigger (line) | Fires on | WHEN | Function (line) → effect |
|---|---|---|---|
| `md_trigger_on_update` (L18968) | AFTER UPDATE OF `erlstmkdnwk` | MD ≤ debut OR exit ≤ MD; depth=0 | `md_trigger_on_update_validity_check()` (L2635) → **`SET erlstmkdnwk = OLD.erlstmkdnwk`** (undo) |
| `exit_trigger_on_update` (L18952) | AFTER UPDATE OF `exitdate` | exit ≤ MD; depth=0 | `exit_trigger_on_update_validity_check()` (L1878) → **`SET exitdate = OLD.exitdate`** |
| `dbt_trigger_on_update` (L18944) | AFTER UPDATE OF `dbt_wk` | debut ≥ MD **OR `old.dbt_wk < old.plan_current`**; depth=0 | `dbt_after_md_trigger_on_update_validity_check()` (L1822) → **`SET dbt_wk = OLD.dbt_wk`**. The "passed Debut is locked" rule is still here |
| `ca_1_trigger_on_update` (L18936) | AFTER UPDATE OF `dbt_wk, exitdate` | debut < MD < exit AND (old debut or old exit after `old.plan_current`); depth=0 | `store_eligibility_trigger()` (L3109) → deletes the item's `plan` rows in `bd_a_assortment` (L3130), re-creates one per department floorset whose **sales window** (`slsstart..slsend`) overlaps [debut, exit] (L3121), copying ranging from the nearest floorset; phase/season via `bd_v_memberbasedvalidvalues` `phase_season_mapping` (L3136); funds the floorset containing debut (L3163) |
| `trigger_for_time_indx` (L19112) | AFTER INSERT OR UPDATE OF `dbt_wk, erlstmkdnwk, exitdate` | debut < MD < exit | `update_week_indxes()` (L3886), see below |
| `trigger_update_price` (L19144) | AFTER UPDATE OF the 12 `ccticketpricechannel_*` | depth=0 | `update_ticket_prices()` (L3676), see below: the ticket-price lock |
| `trigger_sizerangecode_validsizes_members` (L19136) | AFTER UPDATE OF `ccrangecode` | (none) | `sizerangecode_validsizes_members()` (L2942), see below |
| `trigger_sizerangecode_isvalid` (L19128) | AFTER UPDATE OF `validsizes` | (none) | `sizerangecode_isvalid()` (L2873) → all the stylecolor's sizes in `bd_ma_sizeattributes` to `isvalid = 0`, then 1 for sizes in **this row's** `validsizes` (L2902–L2918). Published item whose `validsizes` grew → queues **15.1** (L2920) |
| `item_removal_trigger` (L18960) | AFTER UPDATE OF `record_state` | 0 → 1 | `queue_removal_update()` (L2821) → queues outbound **15.5** for the row (L2826). No published check, nothing else |
| `set_timestamp_styleclrchannel` (L19072) | BEFORE UPDATE | (always) | `trigger_set_timestamp()` (L3428) → `updated_at`. Reliable freshness signal; every corrective UPDATE bumps it too |

All outbound writes upsert into `sync_outbound_dataqueue` on
`uk_sync_outbound_dataqueue (product, interface, time, location)` (L18708), so a
repeat only bumps `updated_at`.

**`update_week_indxes()` (L3886)**, what a lifecycle save also changes:
1. IRW = debut − 4 → `initrcptwk` (L3905). Last DC order = MD − 6 → `lastdcorder`,
   `last_rcpt_wk` (L3907). `too` = MD − debut (Wks at FP), `mkdnwks` = exit − MD
   (L3940). **Counted from Debut, not Relaunch.** *Observed:* no BOD trigger fires on
   `relaunchweek` and no function reads it, so relaunch has no DB-side logic.
2. Published or pre-published item with a debut/MD/exit change → queues **15.5** (L3909).
3. Moving a future debut while `dbt_wk = act_dbt_wk` also moves `act_dbt_wk` and sets
   `bd_ma_stylecolorattributes.launch_week/launch_month` if `actual_launch_week` is
   NULL (L3915–L3927).
4. MD changed → `ticketprice_locked = 1` if MD is past or < 5 weeks away, else NULL
   (L3950). **Writes a column older DBs lack**; never copy it to such an environment.

**`update_ticket_prices()` (L3676)**, the ticket-price lock:
1. **Lock** (L3680–L3698): if MD − `plan_current` < 5 weeks (incl. MD passed), it
   **resets all 12 price columns to OLD** and stops. *Observed:* it recomputes the
   rule and never reads `ticketprice_locked`.
2. Else derives `base_eur1/usd/aud` from `base_gbp1` (group P1) and `base_eur2` from
   `base_gbp2` (P2) via `ticketpricemapping_l_dependencylookup`, by department (L3700).
3. Rolls up `bd_ma_styleattributes.sty_ticketpricechannel_base_gbp1/gbp2` = MAX of
   override ?? base over the style (L3722); sets `us/uk_price_band` on
   `bd_ma_stylecolorattributes` from `bd_l_pricebandlookup` (L3749).
4. Published item with any price change → queues **15.1** (L3775).

**`sizerangecode_validsizes_members()` (L2942)**, changing `ccrangecode`: reads the
code's sizes from `bd_l_dependencylookup` (`lookup_id = 'ccrangecode'`, L2972); marks
all the stylecolor's sizes invalid (L2984); deletes and re-inserts matched sizes as
valid (L2987–L2991); creates `bd_d_product` (`<stylecolor>-<size>`) and `bd_h_prodstd`
rows for new sizes (L2996–L3009); rewrites **this row's** `validsizes` (L3010), which
fires `trigger_sizerangecode_isvalid`. Sizes leaving the range are never deleted.

### Quirks worth knowing

- **Reverts hit every channel.** *Observed:* the validity checks and the price-lock
  revert filter on `product` only (L1826, L1882, L2639, L3696). *Inferred:* one edit
  resets that column on all channel rows to the edited row's OLD value.
- **In-season debut saves revert.** *Observed:* `dbt_trigger_on_update` fires whenever
  `dbt_wk` is in the SET list and the old debut has passed. *Inferred:* each such save
  rewrites `dbt_wk`/`updated_at` on every channel row, even if unchanged.
- **A rejected debut edit can still rebuild floorsets.** *Inferred:* old debut passed,
  old exit not → `ca_1_…` and `dbt_…` both fire; `ca_1` runs first (alphabetical) and
  rebuilds `bd_a_assortment` for the rejected debut; the depth-1 revert doesn't re-run it.
- **Floorsets missing from `phase_season_mapping` are dropped.** *Observed:* the
  re-inserts inner-join the mapping (L3136, L3146, L3157) after the delete (L3130).
  *Inferred:* a debut/exit save removes the item from unmapped floorsets; a duplicate
  mapping row would violate the PK and fail the save.
- **`ticketprice_locked` goes stale.** *Observed:* refreshed only when MD changes
  (L3950). *Inferred:* as weeks roll, the flag (read by `boden-configs`
  `FlowSheetPlanPivot.pivotdefn:106`) can say unlocked while the trigger locks.
- **"query string argument of EXECUTE is null".** *Inferred:* SQL built by string
  concatenation, so a save with `ccrangecode` NULL in the SET list fails (L2972); a
  code missing from the lookup leaves every size invalid. `update_eff_aur` fails the
  same way with no `eo` and no GBP1 price (L3647, L3660).
- **Temp tables leak.** *Observed:* `sizerangecode_*` and `update_eff_aur` never drop
  their uniquely named temp tables. *Inferred:* pooled sessions accumulate them.

## The old lock (SUP-3857)

Older copies (stale server `172.16.80.198/bd`) had two extra WHEN conditions:
`md_trigger_on_update` `OR old.erlstmkdnwk < old.plan_current`, and `exit_trigger_on_update`
`OR old.exitdate < old.plan_current`. They lock MD and Exit once passed, ignoring
`relaunchweek`, so relaunching an in-MD item silently reverts its new MD at save. QA
(re-confirmed in the 10-01 dump) and Bonus have both removed. **Prod: unchecked.**
Before/after DDL, fix and rollback: `tickets/SUP-3857/trigger-snapshots.sql`. Evereve keeps
the lock plus a relaunch-aware branch on `cloned_at`, which Boden lacks
(`customers/EE/db/postgres_schema.sql:18161`).

## Where BOD differs from AEO (matrix letters differ)

| Trigger → function | BOD vs AEO (observed in both dumps) |
|---|---|
| `md_/exit_/dbt_trigger_on_update` | WHENs not relaunch-aware (AEO uses relaunch ?? debut); BOD's dbt also locks a passed debut. Bodies identical; neither filters on location |
| `trigger_for_time_indx` → `update_week_indxes` | BOD: ordering WHEN, no `relaunchweek`; IRW = debut − 4 (AEO: floorset `irw_debut_offset`); last DC = MD − 6 (AEO MD − 4, MD − 1 if `auto_rollforward`); adds 15.5 queue, `launch_week`, `ticketprice_locked` |
| `ca_1_trigger_on_update` → `store_eligibility_trigger` | Not relaunch-aware; needs old debut or exit in the future; sales window (AEO `ap_start/ap_end`); carries phase/season via `phase_season_mapping` |
| `trigger_sizerangecode_validsizes_members` | Looks up `ccrangecode` directly (AEO: `size_range` + `size_range_mapping`); names sizes `<cc>-<size>`; rewrites `validsizes`; does **not** clear `dc_useradj` for invalidated sizes |
| `trigger_sizerangecode_isvalid` | Same, plus 15.1 queue when a published item gains sizes |
| `set_timestamp_p_dc_publish_adj(_ins)` | AEO queues `RDY4PO`, stamps `cc_first_publish_date`. BOD queues 14.3 (+15.1–15.5 on first publish), clears `is_published` on unpublish |
| `trigger_eff_aur` → `update_eff_aur` | Prices from the row's GBP1 override ?? base, no fallback (AEO falls back to `cc_current_price`) |
| `trg_upd_assortment_ranging` | Ranges on territory/channel/account/grade/ssg; no SSG-vs-attribute exclusion or default fill; store count by category (AEO subclass) |
| `trigger_cartparams_ranging` | Same shape; sales window and BOD ranging columns |

BOD has none of AEO's `trigger_lifecycle_plan_update` (MD move wipes DC adjustments),
`trg_cc_validsizes_on_change`, `trigger_cost`, IRW floorset-fields, `ccrangecode`
cascades, colour/name triggers or casepack PO gate. BOD-only: `item_removal_trigger`,
`trigger_update_price`, prepublish triggers, `trg_upd_assortment_phaseattr`.

## Other notable triggers

| Table | Trigger (line) → function (line) | Effect |
|---|---|---|
| `bd_p_dc_adj` | `set_timestamp_p_dc_publish_adj` (L19056), `_ins` (L19064) → `trigger_set_publish_timestamp()` (L3293) | `dc_publish = 1` overwrites `created_at`/`published_at` (L3299), queues **14.3** (L3302); never published → also **15.1–15.5** (L3346). 1 → 0 sets `sync_stylecolorpublishes.is_published = 0` (L3380) |
| `bd_p_dc_adj` | `set_timestamp_p_dc_prepublish_adj` (L19040), `_ins` (L19048) → `trigger_set_prepublish_timestamp()` (L3244) | `is_prepublished = 1` → `prepublished_at`, `last_prepublished = dc_finalqty`, queues **14.1**; never published → also **15.2, 15.3, 15.5** |
| `bd_a_assortment` | `trg_upd_assortment_ranging` (L19088) → `propagate_assortment_to_floorsets()` (L2704) | Recomputes `store_count` (`get_store_count()` or `bd_l_ssglookup`) and **pushes ranging + store count to this and every later floorset** (L2740) |
| `bd_a_assortment` | `trg_upd_assortment_phaseattr` (L19080) → `propagate_phaseattrs_to_floorsets()` (L2779) | Phase story/newness/exposure copied to every **later** floorset (L2786) |
| `bd_p_itemprice` | `trigger_eff_aur` (L19104) → `update_eff_aur()` (L3561); `trigger_itemprice_fetchdepartment` (L19120) → L2615 | `eff_aur` = `eo`, else `bd_l_priceeventlookup` expression on the GBP1 ticket price, else that price. Department = `ancestor3` |
| `cart_params` | `trigger_cartparams_ranging` (L19096) → L3813 | Rebuilds `cart_ranging` over floorsets in [max(debut, plan_current), min(exit, plan_end)] |
| `pivot_execution`, `plan_queue` | `on_*_change` (L18976, L18984) → `notify_*` (L2654, L2667) | LISTEN/NOTIFY eventing for the backend |
| `bd_v_memberbasedvalidvalues` | `set_mvv_indx` (L18992) → L3222 | `indx` = max + 1 when NULL on insert |

`trigger_set_timestamp` also keeps `updated_at` on `bd_ma_stylecolorattributes`,
`bd_a_assortment`, `bd_p_channeloverride`, `bd_p_dc_adj`, `bd_p_dc_adj_size`.
*Observed:* `trigger_set_publish_timestamp` tests `TG_OP = 'Update'` (L3310), but
`TG_OP` is upper-case, so updates take the insert branch and skip the "OLD was 0"
check. *Inferred:* low impact (the upsert de-duplicates). `bd_p_dc_adj.created_at`
means "last published", not "created".

## Unattached trigger functions

Attached to nothing in QA (dead code, or attached by hand elsewhere; check first):
`store_eligibility_triger` (L3038, typo: older version, no phase attributes, funds by AP
window); `queue_ticketprice_update` (L2844, 15.1 on price change, superseded by L3775);
`delete_duplicate_invalids` (L1841, drops `plan_queue` rows of removed items; attached at
KW); `get_default_parameters` (L2351, resets `cart_params` to floorset defaults);
`calc_store_count_ranging` (L994, `cart_ranging.store_count`; attached at EXP);
`copy_inserted_plan_queue` (L1803, to `plan_queue_mark`); `trigger_set_size_id` (L3406).

## Big procedural code (not triggers)

- **Bulk uploads** (lifecycle, option attributes, price, style attributes):
  `validate_transform_uploads_*` (L3976, L4486, L5078, L5543; 450–600 lines each) →
  `commit_upload_*` (L1216–L1682, `shadow_*` → live tables, archived to
  `arc_bulkupload_*`) → `undo_upload_*` (L3445–L3532).
  - Lifecycle validation **still has the passed-week lock** SUP-3857 removed from the
    trigger: "Cannot edit MD Week in the past" (L4128), same for debut (L4114) and
    exit (L4142), on live `bd_serviceparams.plan_current`, ignoring relaunch.
  - Price validation rejects edits < 5 weeks before MD (L5192): the trigger lock's
    rule, reported instead of silently reverted.
  - The lifecycle commit updates every channel row of the product (L1266).
- `add_to_assortment()` (L236, ~750 lines) materializes a cart into the plan. Stamps
  `plan_current` from `bd_serviceparams` onto channel rows (L776), sets `validsizes`
  from `sty_size_range` (L752), raises if any are empty (L767). Same shape as
  `knowledge/backend/ann-add-to-assortment.md`.

## Views, MVs and side schemas

- **MFP:** MVs `mfp.actuals_wide_denorm` (L6732) and `sys_gen_wide_denorm` (L7711) join
  wide facts to `time/product/location/prodlife_denorm` views (`prodlife` like TRD; AEO
  lacks it). They change only on batch REFRESH. **public views:** `plan_status` (L15627,
  queue status), `bd_v_stylecolorchannelattributes` (L13827, pass-through),
  `analytics_product_fcst_input` (L8476, plus `_xx`, `_xxyz`), `md_strategy`.
- **`backups`:** 4 calendar tables from 2020-06-25 (`bd_d_time`, `bd_h_timeflrset`,
  `bd_h_timestd`, `bd_ma_weekattributes`). **`debug`:** `bi_assortmentbyfloorset_staging`.
  `public` holds about 90 ad-hoc copies (`*_bk*`, `*_YYYYMMDD`, `deleteme_*`, `temp_*`,
  seven `dc_adj<uuid>`), `mfp` a few `*_bk*`. Don't mistake them for live tables.

## Triage implications

| Symptom | Where to look |
|---|---|
| MD/Exit/Debut reverts after save or replan | Validity triggers on the **app's live DB** (replan only re-reads PG). Check debut < MD < exit on every channel row, and whether old debut has passed. Prod unchecked for the old lock |
| Bulk upload rejects a relaunch MD | Upload validation (L4128), not the trigger |
| Ticket price edit doesn't stick | Price lock: MD passed or < 5 weeks away (L3680); uploads show a message (L5192) |
| EUR/USD/AUD price changed by itself | Derived from the GBP base on any price save (L3700) |
| Item vanished from a floorset after a lifecycle edit | `store_eligibility_trigger`: sales window, `phase_season_mapping` gaps |
| Ranging/store count changed on later floorsets | `propagate_assortment_to_floorsets` |
| Sizes invalid or size members changed | A `ccrangecode`/`validsizes` save; check `bd_l_dependencylookup` `ccrangecode` rows |
| Outbound interface fired (or didn't) | `sync_outbound_dataqueue`: 15.5 lifecycle/removal; 15.1 price, sizes, first publish; 14.1 prepublish; 14.3 publish |
| Works in QA, not Staging/Prod | Hash-diff triggers/functions (§5); confirm you're on the live DB (§1) |
| Wks at FP wrong after relaunch | `update_week_indxes` counts from Debut; by design today |
| Bulk SQL behaves unlike the UI | Same triggers fire, but depth guards skip some at depth 1. Test in `BEGIN … ROLLBACK` (§4) |

## Refresh

Re-dump per `knowledge/runbooks/db-schema-snapshot.md`, run `python3 tooling/db/schema_map.py
diff <old.sql> <new.sql>` for drift, then `python3 tooling/db/schema_map.py regen` to rebuild
SCHEMA_MAP and the matrix. Capture Bonus and Prod next; BOD ClickHouse/Vertica not captured.
