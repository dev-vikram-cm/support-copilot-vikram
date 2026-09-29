-- =============================================================================
-- SUP-3857 — trigger snapshots, diff, and the Prod fix/rollback script
--
--  §A  Diff: OLD (locked) vs CURRENT (QA == Bonus)       — what changed
--  §B  Prod: check → save → fix → verify → rollback       — run only if Prod
--                                                           still has the lock
--  §C  Full OLD DDL as seen on 172.16.80.198 / db bd      — reference only
--
-- CURRENT QA/Bonus DDL (table + 10 triggers + 5 functions) lives in
--   customers/BOD/db/bd_ma_stylecolorchannelattributes.sql
-- =============================================================================


-- -----------------------------------------------------------------------------
-- §A  Diff  (stale server 172.16.80.198/bd  →  QA == Bonus), mechanically diffed
-- -----------------------------------------------------------------------------
-- SUP-3857 (the bug):
--   md_trigger_on_update    WHEN  - (new.erlstmkdnwk <= new.dbt_wk OR old.erlstmkdnwk < old.plan_current OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0
--                                 + (new.erlstmkdnwk <= new.dbt_wk OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0
--   exit_trigger_on_update  WHEN  - (new.exitdate <= new.erlstmkdnwk OR old.exitdate < old.plan_current) AND pg_trigger_depth() = 0
--                                 + new.exitdate <= new.erlstmkdnwk AND pg_trigger_depth() = 0
--
--   Mechanism: when the WHEN is true, *_validity_check() runs
--     UPDATE bd_ma_stylecolorchannelattributes SET erlstmkdnwk = OLD.erlstmkdnwk WHERE product = NEW.product;
--   inside the save transaction → an in-MD item's relaunch MD edit is silently undone.
--
-- NOT SUP-3857 (separate ticket-price-lock work — do not promote under this ticket):
--   column  ticketprice_locked integer            — present in QA/Bonus only
--   trigger trigger_for_time_indx                 — QA/Bonus add WHEN (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate)
--   trigger trigger_update_price                  — QA/Bonus: all 12 ticket-price cols + WHEN (pg_trigger_depth() = 0); old: 4 GBP cols, no WHEN
--   trigger trigger_queue_ticketprice_update      — OLD server only (queue_ticketprice_update()); absent in QA/Bonus
--   update_week_indxes() in QA/Bonus writes ticketprice_locked → copying it to a DB
--   without that column breaks every lifecycle save.
--
-- Function bodies on the stale server were NOT captured; only QA vs Bonus
-- functions were diffed (identical).


-- -----------------------------------------------------------------------------
-- §B  Prod — run step 1 first; continue ONLY if it shows the old.<col> < old.plan_current clauses.
--      Get reporter/owner approval + go through the normal DB change process.
-- -----------------------------------------------------------------------------

-- 1. Check (read-only). Also confirm you are on the app's live DB:
SELECT inet_server_addr(), current_database();
SELECT id, value FROM bd_serviceparams WHERE id IN ('plan_current', 'plan_end');   -- must match the UI's current week
SELECT max(updated_at) FROM bd_ma_stylecolorchannelattributes;                    -- must be recent
SELECT tgname, pg_get_triggerdef(oid)
FROM pg_trigger
WHERE tgrelid = 'public.bd_ma_stylecolorchannelattributes'::regclass
  AND tgname IN ('md_trigger_on_update', 'exit_trigger_on_update');

-- 2. Save the output of step 1 into tickets/SUP-3857/ (that IS the rollback).

-- 3. Fix — QA's definitions (these two triggers only):
BEGIN;
CREATE OR REPLACE TRIGGER md_trigger_on_update
    AFTER UPDATE OF erlstmkdnwk ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN ((new.erlstmkdnwk <= new.dbt_wk OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.md_trigger_on_update_validity_check();

CREATE OR REPLACE TRIGGER exit_trigger_on_update
    AFTER UPDATE OF exitdate ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN (new.exitdate <= new.erlstmkdnwk AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();
COMMIT;

-- 4. Verify: re-run step 1's trigger query; then relaunch an in-MD item
--    (diagnostic-queries.sql §2) and snapshot the row after save and after replan (§3).

-- 5. Rollback (if needed) — the OLD definitions, exactly as seen on the stale server:
-- BEGIN;
-- CREATE OR REPLACE TRIGGER md_trigger_on_update
--     AFTER UPDATE OF erlstmkdnwk ON public.bd_ma_stylecolorchannelattributes
--     FOR EACH ROW
--     WHEN ((new.erlstmkdnwk <= new.dbt_wk OR old.erlstmkdnwk < old.plan_current OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0)
--     EXECUTE FUNCTION public.md_trigger_on_update_validity_check();
-- CREATE OR REPLACE TRIGGER exit_trigger_on_update
--     AFTER UPDATE OF exitdate ON public.bd_ma_stylecolorchannelattributes
--     FOR EACH ROW
--     WHEN ((new.exitdate <= new.erlstmkdnwk OR old.exitdate < old.plan_current) AND pg_trigger_depth() = 0)
--     EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();
-- COMMIT;
--   (Prefer Prod's own step-1 output over this if they differ.)


-- -----------------------------------------------------------------------------
-- §C  OLD (locked) DDL — 172.16.80.198:5432 / db bd, pasted 2026-09-28.
--     Stale Staging copy: bd_serviceparams plan_current 2025-W20, plan_end 2026-W32,
--     max(updated_at) 2025-06-19 19:12:25, pg_is_in_recovery = f. The app does NOT use it.
--     Reference only — do not execute.
-- -----------------------------------------------------------------------------
/*
CREATE TABLE IF NOT EXISTS public.bd_ma_stylecolorchannelattributes
(
    product text COLLATE pg_catalog."default" NOT NULL,
    location text COLLATE pg_catalog."default" NOT NULL,
    initrcptwk text COLLATE pg_catalog."default",
    dbt_wk text COLLATE pg_catalog."default",
    too smallint,
    mkdnwks smallint,
    last_inv_wk text COLLATE pg_catalog."default",
    lstfpwk text COLLATE pg_catalog."default",
    last_rcpt_wk text COLLATE pg_catalog."default",
    erlstmkdnwk text COLLATE pg_catalog."default",
    exitdate text COLLATE pg_catalog."default",
    lastdcorder text COLLATE pg_catalog."default",
    ccmdstrategy text COLLATE pg_catalog."default",
    ccordpolicy text COLLATE pg_catalog."default",
    ccrangecode text COLLATE pg_catalog."default",
    ssnprf text COLLATE pg_catalog."default",
    validsizes text[] COLLATE pg_catalog."default",
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real DEFAULT 0.0,
    ccimupct real DEFAULT 0.0,
    ccexistingwac real DEFAULT 0.0,
    ccsystemcost real DEFAULT 0.0,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real DEFAULT 3,
    relaunchweek text COLLATE pg_catalog."default",
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text COLLATE pg_catalog."default",
    act_dbt_wk text COLLATE pg_catalog."default",
    cc_flrset text COLLATE pg_catalog."default",
    cc_season text COLLATE pg_catalog."default",
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text COLLATE pg_catalog."default",
    in_season_flag text COLLATE pg_catalog."default" DEFAULT 'No'::text,
    lifecycle_applied text COLLATE pg_catalog."default",
    ccticketpricechannel_base_gbp1 real DEFAULT '0.01'::real,
    ccticketpricechannel_base_gbp2 real DEFAULT '0.01'::real,
    ccticketpricechannel_base_usd real DEFAULT '0.01'::real,
    ccticketpricechannel_base_eur1 real DEFAULT '0.01'::real,
    ccticketpricechannel_base_eur2 real DEFAULT '0.01'::real,
    ccticketpricechannel_base_aud real DEFAULT '0.01'::real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text COLLATE pg_catalog."default" DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text COLLATE pg_catalog."default" DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_return_u_pct real,
    auto_rollforward boolean DEFAULT false,
    irr_mode text COLLATE pg_catalog."default" DEFAULT 'Normal'::text,
    plan_current text COLLATE pg_catalog."default",
    hasbeenpatternedafter text COLLATE pg_catalog."default",
    CONSTRAINT bd_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.bd_ma_stylecolorchannelattributes
    OWNER to psql;

-- Trigger: ca_1_trigger_on_update

-- DROP TRIGGER IF EXISTS ca_1_trigger_on_update ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER ca_1_trigger_on_update
    AFTER UPDATE OF dbt_wk, exitdate
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate AND (old.dbt_wk > old.plan_current OR old.exitdate > old.plan_current) AND new.exitdate > new.erlstmkdnwk AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.store_eligibility_trigger();

-- Trigger: dbt_trigger_on_update

-- DROP TRIGGER IF EXISTS dbt_trigger_on_update ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER dbt_trigger_on_update
    AFTER UPDATE OF dbt_wk
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN ((new.dbt_wk >= new.erlstmkdnwk OR old.dbt_wk < old.plan_current) AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.dbt_after_md_trigger_on_update_validity_check();

-- Trigger: exit_trigger_on_update

-- DROP TRIGGER IF EXISTS exit_trigger_on_update ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER exit_trigger_on_update
    AFTER UPDATE OF exitdate
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN ((new.exitdate <= new.erlstmkdnwk OR old.exitdate < old.plan_current) AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();

-- Trigger: item_removal_trigger

-- DROP TRIGGER IF EXISTS item_removal_trigger ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER item_removal_trigger
    AFTER UPDATE OF record_state
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN (new.record_state = 1 AND old.record_state = 0)
    EXECUTE FUNCTION public.queue_removal_update();

-- Trigger: md_trigger_on_update

-- DROP TRIGGER IF EXISTS md_trigger_on_update ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER md_trigger_on_update
    AFTER UPDATE OF erlstmkdnwk
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN ((new.erlstmkdnwk <= new.dbt_wk OR old.erlstmkdnwk < old.plan_current OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.md_trigger_on_update_validity_check();

-- Trigger: set_timestamp_styleclrchannel

-- DROP TRIGGER IF EXISTS set_timestamp_styleclrchannel ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER set_timestamp_styleclrchannel
    BEFORE UPDATE
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.trigger_set_timestamp();

-- Trigger: trigger_for_time_indx

-- DROP TRIGGER IF EXISTS trigger_for_time_indx ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER trigger_for_time_indx
    AFTER INSERT OR UPDATE OF dbt_wk, erlstmkdnwk, exitdate
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_week_indxes();

-- Trigger: trigger_queue_ticketprice_update

-- DROP TRIGGER IF EXISTS trigger_queue_ticketprice_update ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER trigger_queue_ticketprice_update
    AFTER UPDATE OF ccticketpricechannel_base_gbp1, ccticketpricechannel_base_gbp2, ccticketpricechannel_base_usd, ccticketpricechannel_base_eur1, ccticketpricechannel_base_eur2, ccticketpricechannel_base_aud, ccticketpricechannel_override_gbp1, ccticketpricechannel_override_gbp2, ccticketpricechannel_override_usd, ccticketpricechannel_override_eur1, ccticketpricechannel_override_eur2, ccticketpricechannel_override_aud
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.queue_ticketprice_update();

-- Trigger: trigger_sizerangecode_isvalid

-- DROP TRIGGER IF EXISTS trigger_sizerangecode_isvalid ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER trigger_sizerangecode_isvalid
    AFTER UPDATE OF validsizes
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.sizerangecode_isvalid();

-- Trigger: trigger_sizerangecode_validsizes_members

-- DROP TRIGGER IF EXISTS trigger_sizerangecode_validsizes_members ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER trigger_sizerangecode_validsizes_members
    AFTER UPDATE OF ccrangecode
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.sizerangecode_validsizes_members();

-- Trigger: trigger_update_price

-- DROP TRIGGER IF EXISTS trigger_update_price ON public.bd_ma_stylecolorchannelattributes;

CREATE OR REPLACE TRIGGER trigger_update_price
    AFTER UPDATE OF ccticketpricechannel_base_gbp1, ccticketpricechannel_base_gbp2, ccticketpricechannel_override_gbp1, ccticketpricechannel_override_gbp2
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_ticket_prices();
*/
