-- =============================================================================
-- Boden (bd) Postgres — bd_ma_stylecolorchannelattributes: table + triggers +
-- lifecycle trigger functions.  NOT IN ANY REPO except this snapshot.
--
-- Source : pgAdmin "CREATE script" + pg_get_functiondef(), pasted by
--          Vikram CM during SUP-3857 on 2026-09-29.
-- Envs   : QA  and  Staging/Upgrade "Bonus" (the live Staging DB).
--          Mechanically diffed: table DDL, all 10 triggers and the 5
--          functions below are byte-identical between QA and Bonus.
-- NOT    : 172.16.80.198 / db bd — a stale Staging copy (last write
--          2025-06-19) with the OLD locked md/exit triggers; see
--          tickets/SUP-3857/trigger-snapshots.sql.
-- Prod   : not yet captured.
--
-- Other functions referenced by triggers here (queue_removal_update,
-- trigger_set_timestamp, sizerangecode_isvalid,
-- sizerangecode_validsizes_members, update_ticket_prices) were NOT captured.
-- Refresh + drift check: tickets/SUP-3857/diagnostic-queries.sql §5.
-- Map / what each trigger does: customers/BOD/db/README.md
-- =============================================================================

-- Table: public.bd_ma_stylecolorchannelattributes

-- DROP TABLE IF EXISTS public.bd_ma_stylecolorchannelattributes;

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
    ticketprice_locked integer,
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
    WHEN (new.exitdate <= new.erlstmkdnwk AND pg_trigger_depth() = 0)
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
    WHEN ((new.erlstmkdnwk <= new.dbt_wk OR new.exitdate <= new.erlstmkdnwk) AND pg_trigger_depth() = 0)
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
    WHEN (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate)
    EXECUTE FUNCTION public.update_week_indxes();

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
    AFTER UPDATE OF ccticketpricechannel_base_gbp1, ccticketpricechannel_base_gbp2, ccticketpricechannel_base_usd, ccticketpricechannel_base_eur1, ccticketpricechannel_base_eur2, ccticketpricechannel_base_aud, ccticketpricechannel_override_gbp1, ccticketpricechannel_override_gbp2, ccticketpricechannel_override_usd, ccticketpricechannel_override_eur1, ccticketpricechannel_override_eur2, ccticketpricechannel_override_aud
    ON public.bd_ma_stylecolorchannelattributes
    FOR EACH ROW
    WHEN (pg_trigger_depth() = 0)
    EXECUTE FUNCTION public.update_ticket_prices();


-- =============================================================================
-- Lifecycle trigger functions (QA == Bonus, 2026-09-29)
-- =============================================================================

-- Function: public.md_trigger_on_update_validity_check()

CREATE OR REPLACE FUNCTION public.md_trigger_on_update_validity_check()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE bd_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$function$;

-- Function: public.exit_trigger_on_update_validity_check()

CREATE OR REPLACE FUNCTION public.exit_trigger_on_update_validity_check()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE bd_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$function$;

-- Function: public.dbt_after_md_trigger_on_update_validity_check()

CREATE OR REPLACE FUNCTION public.dbt_after_md_trigger_on_update_validity_check()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
          UPDATE bd_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$function$;

-- Function: public.update_week_indxes()

CREATE OR REPLACE FUNCTION public.update_week_indxes()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
v_irw_indx int;
v_dbtwk_indx int;
v_mdstart_indx int;
v_lastdcorder_indx int;
v_exitdate_indx int;
v_initrcptwk text;
v_lastdcorder text;
v_plan_current_indx int;  
BEGIN
--v_irw_indx := (select indx from bd_d_time where id =''||NEW.initrcptwk||'');
v_dbtwk_indx := (select indx from bd_d_time where id = ''||NEW.dbt_wk||'');
v_mdstart_indx := (select indx  from bd_d_time where id = ''||NEW.erlstmkdnwk||'');
--v_lastdcorder_indx := (select indx from bd_d_time where id =''||NEW.lastdcorder||'');
v_exitdate_indx := (select indx  from bd_d_time where id = ''||NEW.exitdate||'');
v_plan_current_indx := (select indx  from bd_d_time where id = ''||NEW.plan_current||'');  
v_irw_indx := v_dbtwk_indx - 4;
v_initrcptwk := (select id from bd_d_time where indx= v_irw_indx);
v_lastdcorder_indx := v_mdstart_indx - 6;
v_lastdcorder := (select id from bd_d_time where indx= v_lastdcorder_indx);
if exists (SELECT FROM sync_stylecolorpublishes where product= NEW.product and (first_published_date IS NOT NULL or first_prepublished_date IS NOT NULL)) and (NEW.dbt_wk != OLD.dbt_wk OR NEW.erlstmkdnwk != OLD.erlstmkdnwk OR NEW.exitdate != OLD.exitdate) then
INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
VALUES (NEW.product, '15.5', 'NA', NEW.location)
ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue
DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);
end if;
if (NEW.dbt_wk != OLD.dbt_wk AND OLD.dbt_wk = OLD.act_dbt_wk and new.dbt_wk < new.erlstmkdnwk and old.dbt_wk >= old.plan_current) then
UPDATE bd_ma_stylecolorchannelattributes
SET act_dbt_wk = NEW.dbt_wk
WHERE
product = NEW.product
and location = NEW.location;
Update bd_ma_stylecolorattributes a
SET launch_week=NEW.dbt_wk,
launch_month = t.ancestor0 /* Ancestor0 is the respective month of that week */
from bd_h_timestd t
Where a.product=NEW.product
and t.id = NEW.dbt_wk
and a.actual_launch_week IS NULL;
end if;
-- START added on 0122 2023 for too and mkdnwwks update after mass updates
if
(new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate)
then
update bd_ma_stylecolorchannelattributes
set
irw_indx = v_irw_indx,
dbtwk_indx = v_dbtwk_indx,
mdstart_indx = v_mdstart_indx,
lastdcorder_indx = v_lastdcorder_indx,
exitdate_indx = v_exitdate_indx,
too = v_mdstart_indx - v_dbtwk_indx,
mkdnwks = v_exitdate_indx - v_mdstart_indx,
initrcptwk = v_initrcptwk,
last_rcpt_wk = v_lastdcorder,
lastdcorder = v_lastdcorder
WHERE
product = NEW.product
and location = NEW.location;
end if;
-- END added on 0122 2023 for too and mkdnwwks update after mass updates
if (NEW.erlstmkdnwk IS DISTINCT FROM OLD.erlstmkdnwk) then
UPDATE bd_ma_stylecolorchannelattributes
SET ticketprice_locked = CASE
WHEN
(v_mdstart_indx < v_plan_current_indx)
OR
((v_mdstart_indx - v_plan_current_indx) < 5)
THEN 1
ELSE NULL
END
WHERE
product = NEW.product
and location = NEW.location;
end if;
RETURN NEW;
END;
$function$;

-- Function: public.store_eligibility_trigger()

CREATE OR REPLACE FUNCTION public.store_eligibility_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from bd_ma_dptflrsetattributes a, bd_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from bd_h_prodstd where id=NEW.product)
    and b.product = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count, a_cc_planned_phase, a_cc_phase_story, a_cc_newness, a_cc_season, a_cc_exposure
    from bd_a_assortment a, bd_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from bd_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from bd_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count, a_cc_planned_phase, a_cc_phase_story, a_cc_newness, a_cc_season, a_cc_exposure)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count, substr(c.time,6) a_cc_planned_phase, a_cc_phase_story, a_cc_newness, d.season a_cc_season, a_cc_exposure from 
        temp_old a, 
        temp_new c,
        (select attributekey as phase, attributevalue as season from bd_v_memberbasedvalidvalues where attributeid = 'phase_season_mapping') d
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx 
        and c.time = d.phase;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count, a_cc_planned_phase, a_cc_phase_story, a_cc_newness, a_cc_season, a_cc_exposure)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count, substr(c.time,6) a_cc_planned_phase, a_cc_phase_story, a_cc_newness, d.season a_cc_season, a_cc_exposure from 
        temp_old a, 
        temp_new c,
        (select attributekey as phase, attributevalue as season from bd_v_memberbasedvalidvalues where attributeid = 'phase_season_mapping') d
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        and c.time = d.phase
        order by c.indx ;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count, a_cc_planned_phase, a_cc_phase_story, a_cc_newness, a_cc_season, a_cc_exposure)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style,isfunded, store_count, substr(c.time,6) a_cc_planned_phase, a_cc_phase_story, a_cc_newness, d.season a_cc_season, a_cc_exposure from 
        temp_old a, 
        temp_new c,
        (select attributekey as phase, attributevalue as season from bd_v_memberbasedvalidvalues where attributeid = 'phase_season_mapping') d
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx  
        and c.time = d.phase;
    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update bd_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from bd_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from bd_a_assortment a 
          join (select c.time,slsstart,slsend from bd_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where bd_a_assortment.time=filtered.time and bd_a_assortment.product=filtered.product;
 RETURN NEW;
END;
$function$;

