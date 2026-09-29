-- =============================================================================
-- SUP-3857 — diagnostic queries (Boden, tenant prefix `bd`)
-- Reusable for any "lifecycle week reverts / won't save" ticket on Boden.
-- All read-only except §4 (wrapped in BEGIN … ROLLBACK).
-- =============================================================================


-- -----------------------------------------------------------------------------
-- §1  Am I on the DB the app actually uses?   (Postgres)
--     The trap in SUP-3857: 172.16.80.198 / bd looked like Staging but was a
--     stale copy (plan_current 2025-W20, last write 2025-06-19). The UI's week
--     range comes from bd_serviceparams (darwin AssortmentHelper.getRange), so it
--     MUST match what the UI shows, and updated_at must be recent (every UI save
--     bumps it via set_timestamp_styleclrchannel).
-- -----------------------------------------------------------------------------
SELECT inet_server_addr(), inet_server_port(), current_database(), pg_is_in_recovery();
SELECT pg_last_xact_replay_timestamp();                      -- only meaningful if in recovery
SELECT id, value FROM bd_serviceparams WHERE id IN ('plan_current', 'plan_end');
SELECT max(updated_at) FROM bd_ma_stylecolorchannelattributes;
-- Who else is connected (the app shows up as "PostgreSQL JDBC Driver"):
SELECT datname, numbackends FROM pg_stat_database ORDER BY numbackends DESC;
SELECT datname, usename, application_name, client_addr, count(*)
FROM pg_stat_activity WHERE pid <> pg_backend_pid() GROUP BY 1, 2, 3, 4;

-- ClickHouse side (should agree with PG's plan_current):
--   SELECT hostName(), currentDatabase();
--   SELECT * FROM bd_PlanMeta;


-- -----------------------------------------------------------------------------
-- §2  Find items that are "in MD" — i.e. would trip the old lock   (Postgres)
--     in MD  :=  erlstmkdnwk < plan_current AND exitdate >= plan_current
--     (the row's OWN plan_current — exactly what the trigger compares).
--     Testing on a NOT-in-MD item always passes and proves nothing.
-- -----------------------------------------------------------------------------
SELECT h.ancestor0    AS style,             -- search THIS in Style Edit (it lists styles)
       a.product      AS stylecolor,
       a.location,
       d.name         AS department,
       a.dbt_wk, a.act_dbt_wk,
       a.erlstmkdnwk  AS md_wk,
       a.exitdate     AS exit_wk,
       a.relaunchweek, a.ccmdstrategy, a.plan_current
FROM bd_ma_stylecolorchannelattributes a
LEFT JOIN bd_h_prodstd h ON h.id = a.product          -- ancestor0 = style, ancestor3 = department
LEFT JOIN bd_d_product d ON d.id = h.ancestor3
WHERE a.record_state = 0                              -- active (1 = removed from channel)
  AND a.erlstmkdnwk <> ''                             -- '' would sort before any week
  AND a.erlstmkdnwk <  a.plan_current                 -- markdown already started
  AND a.exitdate    >= a.plan_current                 -- not exited yet
  AND COALESCE(a.relaunchweek, '') = ''               -- not relaunched yet
  AND EXISTS (SELECT 1 FROM bd_a_assortment x         -- in the assortment
              WHERE x.product = a.product AND x.location = a.location)
  -- AND d.name = 'Boys'                              -- ticket scope
  -- AND a.location = '<location id>'                 -- e.g. CG17
ORDER BY a.erlstmkdnwk DESC, a.product
LIMIT 50;
-- Exit-lock variant: replace the exit line with  AND a.exitdate < a.plan_current

-- ClickHouse: in-MD items that Style Edit will actually LIST in a scope
-- (its list = AssortmentFitStyleZeros pivot over bd_temp_flow_status_prep, written by replan):
--   SELECT h.style, a.product, a.location, a.dbt_wk, a.erlstmkdnwk AS md_wk, a.exitdate
--   FROM ( SELECT * FROM bd_ma_stylecolorchannelattributes
--          WHERE location = '<scope location id>'
--          ORDER BY product, location, updated_at DESC
--          LIMIT 1 BY product, location ) AS a            -- latest version per item (CH is append-only)
--   ANY LEFT JOIN (SELECT product, style FROM bd_v_stylecolor_hier_attr) AS h USING (product)
--   WHERE a.record_state = 0 AND a.erlstmkdnwk != ''
--     AND a.erlstmkdnwk < '<plan_current>' AND a.exitdate >= '<plan_current>'
--     AND ifNull(a.relaunchweek, '') = ''
--     AND a.product IN (SELECT stylecolor FROM bd_temp_flow_status_prep
--                       WHERE channel = '<scope location id>'
--                         AND time BETWEEN '<scope start wk>' AND '<scope end wk>')
--   ORDER BY a.erlstmkdnwk DESC LIMIT 20;


-- -----------------------------------------------------------------------------
-- §3  Row snapshot — take it BEFORE save, right AFTER save (before replan),
--     and AFTER replan. "Reverted right after save" = Postgres trigger.
-- -----------------------------------------------------------------------------
SELECT product, location, plan_current, dbt_wk, act_dbt_wk, relaunchweek,
       erlstmkdnwk, exitdate, too, mkdnwks, lastdcorder, last_rcpt_wk,
       mdstart_indx, exitdate_indx, updated_at, updated_by
FROM bd_ma_stylecolorchannelattributes
WHERE product = '<stylecolor>' AND location = '<location>';


-- -----------------------------------------------------------------------------
-- §4  Reproduce / test the trigger purely in SQL — nothing persists.
--     The trigger fires on ANY top-level UPDATE OF erlstmkdnwk, UI or SQL.
--     psql only (GUI clients: turn auto-commit OFF first). The CREATE OR REPLACE
--     part needs table-owner rights and briefly blocks other saves — get approval.
-- -----------------------------------------------------------------------------
BEGIN;
SELECT product, location, plan_current, dbt_wk, relaunchweek, erlstmkdnwk, exitdate
FROM bd_ma_stylecolorchannelattributes WHERE product = '<item>' AND location = '<location>';

-- simulate the relaunch save (relaunch >= plan_current, MD > relaunch, exit > MD)
UPDATE bd_ma_stylecolorchannelattributes
SET relaunchweek = '<relaunch wk>', erlstmkdnwk = '<new md wk>', exitdate = '<new exit wk>'
WHERE product = '<item>' AND location = '<location>';

-- with the OLD lock: erlstmkdnwk is back to the old value; relaunch/exit keep new ones
SELECT product, location, relaunchweek, erlstmkdnwk, exitdate
FROM bd_ma_stylecolorchannelattributes WHERE product = '<item>' AND location = '<location>';
ROLLBACK;   -- undoes the update AND everything the triggers did (DDL too, if any)


-- -----------------------------------------------------------------------------
-- §5  Drift check — hash every trigger + every function touching the table.
--     Run on two envs, diff line by line. Same names + same hashes = same logic.
-- -----------------------------------------------------------------------------
SELECT tgname, md5(pg_get_triggerdef(oid))
FROM pg_trigger
WHERE tgrelid = 'public.bd_ma_stylecolorchannelattributes'::regclass AND NOT tgisinternal
ORDER BY 1;

SELECT p.proname, md5(pg_get_functiondef(p.oid))
FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.prokind = 'f'
  AND pg_get_functiondef(p.oid) ILIKE '%bd_ma_stylecolorchannelattributes%'
ORDER BY 1;

-- Full bodies of the lifecycle functions:
SELECT p.proname, pg_get_functiondef(p.oid)
FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.prokind = 'f'
  AND p.proname IN ('md_trigger_on_update_validity_check', 'exit_trigger_on_update_validity_check',
                    'dbt_after_md_trigger_on_update_validity_check', 'update_week_indxes',
                    'store_eligibility_trigger');

-- Anything else that writes MD week:
SELECT p.proname FROM pg_proc p JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.prokind = 'f' AND pg_get_functiondef(p.oid) ILIKE '%erlstmkdnwk%';
