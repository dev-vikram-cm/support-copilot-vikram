# BOD Postgres: schema knowledge (hidden lifecycle logic)

Snapshot: **QA and Staging/Bonus**, pasted during SUP-3857 on 2026-09-29,
and mechanically diffed as identical. Full DDL is in
`bd_ma_stylecolorchannelattributes.sql`, next to this file. **Prod has not
been captured.** There is no full `postgres_schema.sql` dump for Boden yet;
see `knowledge/runbooks/db-schema-snapshot.md`.

None of this is in any git repo. Environments drift silently: in SUP-3857,
QA was hand-edited and a stale Staging copy kept the old version. When a
value "changes by itself", or behaves differently between environments,
diff this layer first (`tickets/SUP-3857/diagnostic-queries.sql` §5).

## bd_ma_stylecolorchannelattributes: 10 triggers

PK is `(product, location)`. The `WHEN` clauses compare `OLD`/`NEW`
against the row's own `plan_current`. Guarding with `pg_trigger_depth() = 0`
stops a trigger's own corrective `UPDATE` from firing it again.

| Trigger | Fires on | WHEN (QA = Bonus) | Function → effect |
|---|---|---|---|
| `md_trigger_on_update` | AFTER UPDATE OF `erlstmkdnwk` | `(new.erlstmkdnwk <= new.dbt_wk OR new.exitdate <= new.erlstmkdnwk) AND depth=0` | `md_trigger_on_update_validity_check()` → **`SET erlstmkdnwk = OLD.erlstmkdnwk`** (undo) |
| `exit_trigger_on_update` | AFTER UPDATE OF `exitdate` | `new.exitdate <= new.erlstmkdnwk AND depth=0` | `exit_trigger_on_update_validity_check()` → **`SET exitdate = OLD.exitdate`** |
| `dbt_trigger_on_update` | AFTER UPDATE OF `dbt_wk` | `(new.dbt_wk >= new.erlstmkdnwk OR old.dbt_wk < old.plan_current) AND depth=0` | `dbt_after_md_trigger_on_update_validity_check()` → **`SET dbt_wk = OLD.dbt_wk`**. Note: the "passed Debut is locked" rule is still here |
| `ca_1_trigger_on_update` | AFTER UPDATE OF `dbt_wk, exitdate` | valid ordering, and old dbt or exit still in the future, `depth=0` | `store_eligibility_trigger()` → rebuilds the item's `bd_a_assortment` floorset rows from `bd_ma_dptflrsetattributes` (slsstart/slsend overlap), maps the season through `bd_v_memberbasedvalidvalues` `phase_season_mapping`, and funds the first floorset |
| `trigger_for_time_indx` | AFTER INSERT OR UPDATE OF `dbt_wk, erlstmkdnwk, exitdate` | `new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate` | `update_week_indxes()`, see below |
| `set_timestamp_styleclrchannel` | BEFORE UPDATE | (always) | `trigger_set_timestamp()` → `updated_at`. Reliable freshness signal |
| `item_removal_trigger` | AFTER UPDATE OF `record_state` | `new.record_state = 1 AND old.record_state = 0` | `queue_removal_update()` (body not captured) |
| `trigger_sizerangecode_isvalid` | AFTER UPDATE OF `validsizes` | (always) | `sizerangecode_isvalid()` (body not captured) |
| `trigger_sizerangecode_validsizes_members` | AFTER UPDATE OF `ccrangecode` | (always) | `sizerangecode_validsizes_members()` (body not captured) |
| `trigger_update_price` | AFTER UPDATE OF all 12 `ccticketpricechannel_*` | `depth=0` | `update_ticket_prices()` (body not captured). Part of the ticket-price-lock work |

### update_week_indxes(): what a lifecycle save also changes

1. It converts `dbt_wk`, `erlstmkdnwk`, `exitdate` and `plan_current` to
   `bd_d_time.indx`.
2. It derives the dependent weeks:
   - `irw_indx` = debut − 4, which gives `initrcptwk`
   - `lastdcorder_indx` = MD − 6, which gives `lastdcorder` and `last_rcpt_wk`
3. It recomputes the durations:
   - `too` = MD − debut (Wks at FP)
   - `mkdnwks` = exit − MD
   These are **counted from Debut, not Relaunch**.
4. **Published items** (`sync_stylecolorpublishes` first_(pre)published_date
   set) are queued to outbound **interface 15.5** (`sync_outbound_dataqueue`)
   whenever debut, MD or exit changes.
5. Moving a **future** debut when `dbt_wk = act_dbt_wk` also moves
   `act_dbt_wk`, and updates `bd_ma_stylecolorattributes.launch_week` and
   `launch_month` (when `actual_launch_week` is NULL).
6. It sets `ticketprice_locked = 1` when MD is in the past or less than 5
   weeks away. **It writes a column that older DBs don't have**, so never
   copy it to an environment without `ticketprice_locked`.

## The old lock (SUP-3857)

Older copies (seen on the stale server `172.16.80.198/bd`) had two extra
conditions:
- `md_trigger_on_update`: `OR old.erlstmkdnwk < old.plan_current`
- `exit_trigger_on_update`: `OR old.exitdate < old.plan_current`

This locks MD and Exit once they have passed, ignoring `relaunchweek`, so
relaunching an in-MD item silently reverts its new MD at save time. QA and
Bonus have both conditions removed. **Prod: unchecked.** The before/after
DDL, fix and rollback are in `tickets/SUP-3857/trigger-snapshots.sql`.

For comparison, Evereve's version of the same trigger keeps the lock but
adds a relaunch-aware branch, and uses a `cloned_at` column that Boden lacks
(`customers/EE/postgres_schema.sql:16647`).

## Triage implications

- **"Relaunch, MD or Exit week reverts after save or replan":** check this
  trigger layer on the **app's live DB** first. Replan only re-reads
  Postgres.
- **"Works in QA, not in Staging/Prod":** hash-diff the triggers and
  functions between environments (§5). Also confirm you're on the live DB
  (§1).
- **"Wks at FP looks wrong after relaunch":** `update_week_indxes` counts
  from Debut. This is by design today.
- **Bulk SQL updates** fire the same triggers as UI saves. Test them inside
  `BEGIN … ROLLBACK` (§4).
