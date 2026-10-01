-- ENV: QA | DB: bd | dumped: 2026-10-01 15:05 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict CfJJ9f46fBQrzdZ76JPBLGrfIrfOLRTqwUFVaRx1WOTfXxw0rhAlwTzGAgYka3i

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:05:01 IST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 811 (class 2615 OID 136956723)
-- Name: backups; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA backups;


ALTER SCHEMA backups OWNER TO psql;

--
-- TOC entry 812 (class 2615 OID 136956724)
-- Name: debug; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA debug;


ALTER SCHEMA debug OWNER TO psql;

--
-- TOC entry 813 (class 2615 OID 136956725)
-- Name: mfp; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp;


ALTER SCHEMA mfp OWNER TO psql;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 2 (class 3079 OID 36069)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 7369 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 2079 (class 1247 OID 136956727)
-- Name: approval; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp.approval OWNER TO psql;

--
-- TOC entry 2082 (class 1247 OID 136956732)
-- Name: permission; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp.permission OWNER TO psql;

--
-- TOC entry 2085 (class 1247 OID 136956740)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 2088 (class 1247 OID 136956748)
-- Name: appmodule; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.appmodule AS ENUM (
    'bottom_up',
    'top_down',
    'middle_out',
    'brand_report',
    'global_down'
);


ALTER TYPE public.appmodule OWNER TO psql;

--
-- TOC entry 2091 (class 1247 OID 136956760)
-- Name: approval; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE public.approval OWNER TO psql;

--
-- TOC entry 2094 (class 1247 OID 136956766)
-- Name: paged_pivot_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.paged_pivot_status AS ENUM (
    'pending',
    'error',
    'ready',
    'cancelled'
);


ALTER TYPE public.paged_pivot_status OWNER TO psql;

--
-- TOC entry 2097 (class 1247 OID 136956776)
-- Name: permission; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE public.permission OWNER TO psql;

--
-- TOC entry 2100 (class 1247 OID 136956784)
-- Name: queue_state; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.queue_state AS ENUM (
    'PENDING',
    'QUEUED',
    'PROCESSING',
    'COMPLETED',
    'FAILED'
);


ALTER TYPE public.queue_state OWNER TO psql;

--
-- TOC entry 2103 (class 1247 OID 136956796)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 1406 (class 1255 OID 136956801)
-- Name: _final_median(numeric[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public._final_median(numeric[]) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$_$;


ALTER FUNCTION public._final_median(numeric[]) OWNER TO psql;

--
-- TOC entry 1407 (class 1255 OID 136956802)
-- Name: add_to_assortment(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

s1 text;
s2 text;
s3 text;
s4_1 text;
s4_2 text;
s4_3 text;
s4_4 text;
s5 text;
s6 text;
s7 text;
s8 text;
s9 text;
s10 text;
s11 text;
s12 text;
s13 text;
s14 text;
s15 text;
s16 text;
s17 text;
s18 text;
s19 text;
s20 text;
s21 text;
s22 text;
s23 text;
s24 text;
s25 text;
s26 text;
s27 text;
s28 text;
s28_1 text;
s28_X text;
s29 text;
s29_1 text;
s30 text;
s31 text;
s32 text;
s33 text;
s34 text;
s35 text;
s36 text;
s37 text;
s38 text;
s39 text;
s39_1 text;
s39_2 text;
s40 text;
s41 text;
s42 text;
s43 text;
s43_1 text;
s44 text;
s45 text;
s46 text;
s47 text;
s48 text;
s49 text;
s50 text;
s51 text;
s52 text;
s52_1 text;
s53 text;
s54 text;
s55 text;
s56 text;
s57 text;
s58 text;
s59 text;
added_prods refcursor;

v_uuid_temp text;
v_uuid text;
table_input_t1 text;
table_cart_master_temp text;
table_cart_style text;
table_cart_stylecolorsize text;
table_cart_stylecolor text;
table_default_cart_params text;
table_temp_sclr_chnl_attr text;
table_ma_imgattr text;
table_temp_assort text;
table_final_list text;
table_spec_img text;

invalidsizes int;

BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_input_t1 := 'input_t1'||v_uuid;
table_cart_master_temp := 'cart_master_temp'||v_uuid;
table_cart_style := 'cart_style'||v_uuid;
table_cart_stylecolorsize := 'cart_stylecolorsize'||v_uuid;
table_cart_stylecolor := 'cart_stylecolor'||v_uuid;
table_default_cart_params := 'default_cart_params'||v_uuid;
table_temp_sclr_chnl_attr := 'temp_sclr_chnl_attr'||v_uuid;
table_spec_img := 'temp_space_img'||v_uuid;
table_ma_imgattr := 'table_ma_imgattr'||v_uuid;
table_temp_assort := 'table_temp_assort'||v_uuid;
table_final_list := 'table_final_list'||v_uuid;

s1 := 'create temporary table '||table_input_t1||' as select '''||$1||''' as jsid,'''||$2||''' as scope_product,'''||$3||''' as scope_location ,'''||$4||''' as scope_start,'''||$5||''' as scope_floorset
    ';
EXECUTE s1;


if scope_location <> 'CG17' then
  s53 := 'insert into cart_master_archive select * from cart_master  where jsessionid in (select jsid from  '||table_input_t1||')';
  s54 := 'insert into cart_params_archive select * from cart_params  where jsessionid in (select jsid from  '||table_input_t1||')';
  s55 := 'insert into cart_ranging_archive select * from cart_ranging  where jsessionid in (select jsid from  '||table_input_t1||')';
  
  s56 := 'delete from cart_master where jsessionid in (select jsid from  '||table_input_t1||')';
  s57 := 'delete from cart_params where jsessionid in (select jsid from  '||table_input_t1||')';
  s58 := 'delete from cart_ranging where jsessionid in (select jsid from  '||table_input_t1||')';
  
  EXECUTE s53;
  EXECUTE s54;
  EXECUTE s55;
  EXECUTE s56;
  EXECUTE s57;
  EXECUTE s58;

end if;

-- delete from debug_stats_ts where stat_id='s1';

s2 := '
    create temporary table '||table_cart_master_temp||' as
    select
    distinct
    jsessionid
    ,  style_sequence
    ,  style_id as incoming_style_id
    ,  style_name
    ,  style_description
    ,  style_type
    ,  cccolor
    ,  stylecolor_id as incoming_stylecolor_id
    ,  stylecolor_type
    ,  stylecolor_name
    ,  stylecolor_description
    ,  null::text final_style_id
    ,  null::text final_stylecolor_id
    ,  null::text cccolorfamily
    ,  initiator
    ,  img
    ,  job_priority
    ,  null::text class_id
    ,  null::text subclass_id
    ,  null::text class_name
    ,  null::text subclass_name
    from cart_master
    where
    jsessionid in (select jsid from '||table_input_t1||')
    and isProcessed=0
    '
    ;


EXECUTE s2;

s3 := '
    create temporary table '||table_cart_style||' as
    select jsessionid
    , style_sequence
    , case when style_type = ''similar'' then uuid_generate_v4()::text else incoming_style_id end AS final_style_id
    , incoming_style_id
    , style_type
    , style_name  as displayed_style_name
    , style_description  as displayed_style_description
    from
    (
    select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||')
    ) x
    ';

EXECUTE s3;

s4_1 := '
    Update '||table_cart_master_temp||' a
    set final_style_id = b.final_style_id
    from '||table_cart_style||' b
    where
    a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    ';

EXECUTE s4_1;

s4_2 := '
    Update '||table_cart_master_temp||' a
    set class_id = b.ancestor1,
        subclass_id = b.ancestor0
    from public.bd_h_prodstd b
    where
    b.id = a.incoming_style_id
    ';

execute s4_2;

s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from public.bd_d_product b
    where
    b.id = a.class_id
    ';

execute s4_3;

s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from public.bd_d_product b
    where
    b.id = a.subclass_id
    ';

execute s4_4;

s5 := '
    create temporary table '||table_cart_stylecolor||' as
    select jsessionid
    , style_sequence
    , case when stylecolor_type = ''similar'' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = ''similar'' then style_name||''-''||color_id else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = ''similar'' then style_description ||'' ''||cccolor else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor,
    case when strpos(cccolor, '' '') > 0 then (SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1)) else cccolor end
    as color_id
    , style_name, style_description, stylecolor_name, stylecolor_description
    from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||')
    ) x
    '
    ;

EXECUTE s5;

s6 := '
    Update '||table_cart_master_temp||' a set
    final_stylecolor_id = b.final_stylecolor_id
    , stylecolor_name = displayed_stylecolor_name
    , stylecolor_description = displayed_stylecolor_description
    from '||table_cart_stylecolor||' b
    where
    a.incoming_stylecolor_id=b.incoming_stylecolor_id
    and a.cccolor=b.cccolor
    and a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.stylecolor_type=b.stylecolor_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    '
    ;

EXECUTE s6;

s7 := '
    CREATE temporary TABLE '||table_cart_stylecolorsize||' AS
    SELECT
           case when stylecolor_type=''similar'' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id
         , sizeattribute    AS size_name
         , sizeattribute    AS size_description
         , incoming_stylecolor_id
         , incoming_style_id
         , final_style_id
         , final_stylecolor_id
         , stylecolor_type
         , jsessionid
    FROM   (SELECT
           a.incoming_stylecolor_id
                 , a.incoming_style_id
                 , b.product stylecolorsize_id
                 , b.sizeattribute
                 , b.parent_id
                 , a.jsessionid
                 , a.style_type
                 , a.stylecolor_type
                 , a.final_style_id
                 , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                 , bd_ma_sizeattributes b
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x
          '
          ;

EXECUTE s7;

RAISE NOTICE 'Start Member Create:%', 'START:'|| now();


-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from bd_l_dependencylookup b where b.target_id = ''cccolorfamily'' and b.lookup_id=''cccolor'' and lookup_value=a.cccolor
';

EXECUTE s21;

-- IMAGE ATTRIBUTES START

s29 := 'drop table if exists '||table_ma_imgattr||'';

s29_1 := '
create temporary table '||table_spec_img||' as
select
 distinct si.product, si.img, sa.ancestor0 as style_id
from bd_specimages si
 inner join
bd_h_prodstd sa
 on sa.id = si.product
where sa.ancestor0 in (select final_style_id from '||table_cart_master_temp||' where jsessionid in (select jsid from '||table_input_t1||'));
';

s30 := '
create temporary table '||table_ma_imgattr||' as
select
    c.jsessionid
  , c.final_stylecolor_id as product
  , b.img as orig_image
  , c.img as cart_image
  , d.img as spec_image
FROM
  (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, img from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')) c
 LEFT JOIN
  (select distinct product, img from bd_ma_imgattributes) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, style_id from '||table_spec_img||') d
on
d.style_id = c.final_style_id;

'
;

EXECUTE s29;
EXECUTE s29_1;
EXECUTE s30;

-- IMAGE ATTRIBUTES END

RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();

PERFORM get_default_params(''||$1||'',''||$2||'',''||$3||'',''||$4||'',''||$5||'');

-- STYLECOLOR CHANNEL ATTRIBUTES

s35 := '
create temporary  table '||table_default_cart_params||' as
select
    a.jsessionid
  , a.scope_product
  , a.scope_location
  , initrcptwk  as default_initrcptwk
  , dbt_wk as default_dbt_wk
  , too as default_too
  , mkdnwks as default_mkdnwks
  , last_inv_wk as default_last_inv_wk
  , lstfpwk as default_lstfpwk
  , last_rcpt_wk as default_last_rcpt_wk
  , erlstmkdnwk as default_erlstmkdnwk
  , exitdate as default_exitdate
  , ccmdstrategy as default_ccmdstrategy
  , presmin as default_presmin
  , presmin_weeks as default_presmin_weeks
  , ccrcptint as default_ccrcptint
  , ccordermultiple as default_ccordermultiple
  , ccordpolicy as default_ccordpolicy
from (select distinct * from cart_params) a, '||table_input_t1||' b
where a.jsessionid = b.jsid
and a.scope_product = b.scope_product
and a.scope_location = b.scope_location
and a.scope_start = b.scope_start
'
;

EXECUTE s35;
s36 := '
create  temporary table '||table_temp_sclr_chnl_attr||' as
select
    a.jsessionid
  , final_stylecolor_id as product
  , a.scope_location as location
  , default_initrcptwk as initrcptwk
  , default_dbt_wk as dbt_wk
  , default_dbt_wk as act_dbt_wk
  , default_too as too
  , default_mkdnwks as mkdnwks
  , default_last_inv_wk as last_inv_wk
  , default_lstfpwk as lstfpwk
  , default_last_rcpt_wk as last_rcpt_wk
  , default_erlstmkdnwk as erlstmkdnwk
  , default_exitdate as exitdate
  , default_ccmdstrategy ccmdstrategy
  , default_ccordpolicy ccordpolicy
  , sty_size_range || '' - '' || class_id as ccrangecode
  , ''class_default'' as ssnprf
  , default_presmin as presmin
  , default_presmin_weeks as presmin_weeks
  , default_ccrcptint::int as ccrcptint
  , default_ccordermultiple::int as ccordermultiple
  , 3 as slsrnk
  , COALESCE(d.cc_boden_landed_cost,1) as ccexistingwac

FROM
'||table_default_cart_params||' a,
(select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id from '||table_cart_master_temp||') b,
bd_ma_styleattributes c, bd_ma_stylecolorattributes d
where a.jsessionid=b.jsessionid and b.final_style_id = c.product and b.final_stylecolor_id = d.product
';

EXECUTE s36;

s37 := '
delete from bd_ma_stylecolorchannelattributes 
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

EXECUTE s37;

s38 := '
INSERT  into bd_ma_stylecolorchannelattributes (
  product
, location
, initrcptwk
, dbt_wk
, act_dbt_wk
, too
, mkdnwks
, last_inv_wk
, lstfpwk
, last_rcpt_wk
, erlstmkdnwk
, exitdate
, ccmdstrategy
, ccordpolicy
, ccrangecode
, ssnprf
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple
, slsrnk
, ccexistingwac
)
select
  product
, location
, initrcptwk
, dbt_wk
, act_dbt_wk
, too
, mkdnwks
, last_inv_wk
, lstfpwk
, last_rcpt_wk
, erlstmkdnwk
, exitdate
, ccmdstrategy
, ccordpolicy
, ccrangecode
, ssnprf
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple
, slsrnk
, ccexistingwac
FROM
 '||table_temp_sclr_chnl_attr||'
 ';

EXECUTE s38;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

-- ASSORTMENT MODEL

s51 := '
update bd_ma_stylecolorchannelattributes a
set
  ccdiscountpct = default_discount
, ccmdstrategy = default_md
from (select id, ancestor3, default_discount, default_md from bd_h_prodstd a, default_disc_md b where a.ancestor3=b.department) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product=b.id
';

EXECUTE s51;


s52 := '
update bd_ma_stylecolorchannelattributes a
set
  validsizes = b.valid_sizes::text[]
from (select b.final_stylecolor_id, ''{'' || STRING_AGG(target_value, '','') || ''}'' as valid_sizes from bd_l_dependencylookup a, '|| table_cart_master_temp || ' b where a.lookup_id=''sty_size_range'' and target_id = ''validsizes'' and lookup_value = b.final_style_id and jsessionid in (select jsid from  '||table_input_t1||') group by b.final_stylecolor_id) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product=b.final_stylecolor_id
';


EXECUTE s52;

EXECUTE '(SELECT COUNT(*) FROM bd_ma_stylecolorchannelattributes WHERE cardinality(validsizes) = 0 and (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||')))' into invalidsizes;

IF COALESCE(invalidsizes,0) > 0
THEN
    RAISE EXCEPTION 'One or more styles in the cart have no validsizes (% product(s))', invalidsizes USING HINT = 'dependencylookup';
END IF;


s53 := '
update bd_ma_stylecolorchannelattributes a
set
  ccticketpricechannel_base_gbp1 = 0.01,
  ccticketpricechannel_base_gbp2 = 0.01,
  plan_current = b.plan_current
from (select value as plan_current from bd_serviceparams where id = ''plan_current'') b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

EXECUTE s53;

-- Updates the launch week to facilitate the proper filters in Support Ticket SUP-1062
s59 := '
    Update bd_ma_stylecolorattributes a
    SET launch_week=b.dbt_wk,
    launch_month = t.ancestor0 /* Ancestor0 is the respective month of that week */
      from  '||table_temp_sclr_chnl_attr||' b
    inner join bd_h_timestd t on 
    b.dbt_wk = t.id 
    Where a.product=b.product
    and a.actual_launch_week IS NULL
    and jsessionid in (select jsid from  '||table_input_t1||')
';
-- ASSORTMENT MODEL

EXECUTE s59;


s39 := '
    create temporary table '||table_temp_assort||' AS
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(strchannel as text[]) as strchannel
        , cast(strterritory as text[]) as strterritory
        , cast(straccount as text[]) as straccount
        , grade as grade
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , get_store_count(e.slsstart,strterritory::text[],straccount::text[],strchannel::text[],grade::text[],d.category_id) as store_count
    FROM
    (select distinct * from cart_ranging) a, 
    '||table_input_t1||' b, 
    (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c,
    (select id, ancestor2 as category_id, ancestor3 as department_id from bd_h_prodstd) d,
    (select product, time, slsstart from bd_ma_dptflrsetattributes) e
    where a.jsessionid=c.jsessionid
  and a.jsessionid = b.jsid
  and a.scope_product = b.scope_product
  and a.scope_location = b.scope_location
  and a.scope_start = b.scope_start
  and c.final_stylecolor_id = d.id
  and e.product = d.department_id
  and e.time = a.scope_floorset
    '
    ;

EXECUTE s39;


s40 := '
delete from bd_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';

EXECUTE s40;


s41 := '

    insert into bd_a_assortment (
          product
        , location
        , "time"
        , strchannel
        , strterritory
        , straccount
        , grade
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , a_cc_planned_phase)
    SELECT
          product
        , location
        , "time"
        , strchannel
        , strterritory
        , straccount
        , grade
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , substr(time,6)
    FROM
       '||table_temp_assort||'
';

EXECUTE s41;

s39_1 := '
    update bd_a_assortment a
    set a_cc_phase_story   = t_cc_phase_story  
       ,a_cc_newness       = t_cc_newness      
       ,a_cc_season        = t_cc_season       
       ,a_cc_exposure      = t_cc_exposure     
    from bd_ma_stylecolorphaseattributes b
    where a.product = b.product and a.time = b.time
      and (a.product, a.location) in (select product,location from '||table_temp_assort||')
    '
    ;

EXECUTE s39_1;

s39_2 := '
    update bd_a_assortment a
    set a_cc_season        = b.season          
    from (select attributekey as phase, attributevalue as season from bd_v_memberbasedvalidvalues where attributeid = ''phase_season_mapping'') b
    where a.time = b.phase
      and (a.product, a.location) in (select product,location from '||table_temp_assort||')
    '
    ;

EXECUTE s39_2;

RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

s42 := '
create temporary table '||table_final_list||' AS
select distinct a.product, a.location
from
(select distinct product,location  from bd_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from bd_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
where
a.product=b.product
and a.location=b.location
';

EXECUTE s42;

s43 := '
insert into plan_queue (product, location, initiator, initiated_at)
select final_stylecolor_id, '''||$3||''', initiator :: uuid, now() from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')
';

EXECUTE s43;

s43_1 := 'select final_stylecolor_id product from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
    and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')';

s44 := 'update cart_master set isProcessed=1 where jsessionid in (select jsid from  '||table_input_t1||')';

s45 := 'insert into cart_master_archive select * from cart_master  where jsessionid in (select jsid from  '||table_input_t1||')';
s46 := 'insert into cart_params_archive select * from cart_params  where jsessionid in (select jsid from  '||table_input_t1||')';
s47 := 'insert into cart_ranging_archive select * from cart_ranging  where jsessionid in (select jsid from  '||table_input_t1||')';

s48 := 'delete from cart_master where jsessionid in (select jsid from  '||table_input_t1||')';
s49 := 'delete from cart_params where jsessionid in (select jsid from  '||table_input_t1||')';
s50 := 'delete from cart_ranging where jsessionid in (select jsid from  '||table_input_t1||')';

EXECUTE s44;
EXECUTE s45;
EXECUTE s46;
EXECUTE s47;
EXECUTE s48;
EXECUTE s49;
EXECUTE s50;

insert into debug_stats_ts values ('s1',s1,now());
insert into debug_stats_ts values ('s2',s2,now());
insert into debug_stats_ts values ('s3',s3,now());
insert into debug_stats_ts values ('s4_1',s4_1,now());
insert into debug_stats_ts values ('s4_2',s4_2,now());
insert into debug_stats_ts values ('s4_3',s4_3,now());
insert into debug_stats_ts values ('s4_4',s4_4,now());
insert into debug_stats_ts values ('s5',s5,now());
insert into debug_stats_ts values ('s6',s6,now());
insert into debug_stats_ts values ('s7',s7,now());
insert into debug_stats_ts values ('s21',s21,now());
insert into debug_stats_ts values ('s29',s29,now());
insert into debug_stats_ts values ('s30',s30,now());
insert into debug_stats_ts values ('s35',s35,now());
insert into debug_stats_ts values ('s36',s36,now());
insert into debug_stats_ts values ('s37',s37,now());
insert into debug_stats_ts values ('s38',s38,now());
insert into debug_stats_ts values ('s39',s39,now());
insert into debug_stats_ts values ('s39_1',s39_1,now());
insert into debug_stats_ts values ('s41',s41,now());
insert into debug_stats_ts values ('s42',s42,now());
insert into debug_stats_ts values ('s43',s43,now());
insert into debug_stats_ts values ('s44',s44,now());
insert into debug_stats_ts values ('s51',s51,now());
insert into debug_stats_ts values ('s52',s52,now());
insert into debug_stats_ts values ('s53',s53,now());

OPEN added_prods FOR EXECUTE s43_1;

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();

 RETURN added_prods;

END;
$_$;


ALTER FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 1411 (class 1255 OID 136956804)
-- Name: calc_store_count_ranging(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.calc_store_count_ranging() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
  ssg_array text[] := string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.ssg)), ',');
BEGIN
  IF (ssg_array IS NULL OR array_length(ssg_array, 1) IS NULL OR array_length(ssg_array, 1) = 0) then
   raise notice 'Received edit with no ssg.';
    new.store_count := public.get_store_count(
      (select slsstart from public.bd_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strterritory)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.straccount)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strchannel)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','),
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM bd_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 1420 (class 1255 OID 136956805)
-- Name: can_remove_from_assortment(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
 declare
  scWeekCount INT;
  sizeWeekCount INT;
  scWeekCount_pub INT;
  scWeekCount_eoh INT;
 BEGIN
  scWeekCount_pub = (select COUNT(*) from bd_p_dc_adj 
   where product = stylecolorId 
   and location = (select dc from bd_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from bd_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from bd_p_dc_adj_size
   where product in (select id from bd_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from bd_l_dclookup where channel = channelId)
   and (dc_onorder > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 1421 (class 1255 OID 136956806)
-- Name: check_isprepublishable(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.check_isprepublishable(stylecolorid text) RETURNS text
    LANGUAGE plpgsql
    AS $$
 declare
 v_isprepublishable text;
 BEGIN
  select
  CASE
          WHEN (
                 COALESCE(length(btrim("substring"(c.sty_age_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_gender_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_price_band_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(a.cc_price_banding_latest, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_texture, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(f.a_cc_newness, 1, 1))), 0)
               ) = 6 
               AND upper(cc_active_flag) = 'YES'
               AND upper(cc_ready_for_ranging) = 'TRUE'
               AND COALESCE(ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1, 0.01) > 0.01
               AND COALESCE(ccticketpricechannel_override_gbp2, ccticketpricechannel_base_gbp2, 0.01) > 0.01
               AND cardinality(d.validsizes) > 0
          THEN '1'::text
          ELSE '0'::text
      END AS ispublishable
      into v_isprepublishable
  FROM bd_ma_stylecolorattributes a
  JOIN bd_h_prodstd b ON a.product = b.id
  JOIN ( SELECT bd_d_product.id,
         bd_d_product.name,
         bd_d_product.description
        FROM bd_d_product
       WHERE bd_d_product.levelid = 'style'::text) l2 ON b.ancestor0 = l2.id
  JOIN bd_ma_styleattributes c ON l2.id = c.product
  LEFT OUTER JOIN (select distinct product, cc_plan_cost, validsizes,
                                   ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1,
                                   ccticketpricechannel_override_gbp2, ccticketpricechannel_base_gbp2,
                                   ccticketpricechannel_override_usd, ccticketpricechannel_base_usd,
                                   ccticketpricechannel_override_eur1, ccticketpricechannel_base_eur1,
                                   ccticketpricechannel_override_eur2, ccticketpricechannel_base_eur2,
                                   ccticketpricechannel_override_aud, ccticketpricechannel_base_aud
                   from bd_ma_stylecolorchannelattributes
                  ) d ON a.product = d.product
  LEFT OUTER JOIN (select product, 
                          max(a_cc_newness) a_cc_newness
                   from bd_a_assortment
                   where product in (select product from bd_ma_stylecolorattributes)
                     and a_cc_newness in (select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 't_cc_newness')
                   group by product
                  ) f ON a.product = f.product
  where a.product = stylecolorid
  ;

  return v_isprepublishable;
 END;
$$;


ALTER FUNCTION public.check_isprepublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 1422 (class 1255 OID 136956807)
-- Name: check_ispublishable(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.check_ispublishable(stylecolorid text) RETURNS text
    LANGUAGE plpgsql
    AS $$
 declare
 v_ispublishable text;
 BEGIN
  select
  CASE
          WHEN (
                 COALESCE(length(btrim("substring"(c.sty_age_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_packages, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_fit_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_end_use, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_heel_height, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_footwear_type, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_gender_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_dress_skirt_length, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_neck_detail, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_price_band_style, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_classification_latest, 1, 1))), 0) + 
                 COALESCE(length(btrim("substring"(c.sty_rise, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(c.sty_skirt_shape, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(c.sty_sleeve_length, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(c.sty_sleeve_shape, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_applied_detail, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_price_banding_latest, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_archetype, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_sub_theme, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_theme_latest, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_texture, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_pattern_new, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_pattern, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_print_name, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_classification_latest, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_collection, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(a.cc_weight, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(c.sty_size_range, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(f.a_cc_newness, 1, 1))), 0) +
                 COALESCE(length(btrim("substring"(f.a_cc_exposure, 1, 1))), 0)
               ) = 30 
               AND upper(cc_active_flag) = 'YES'
               AND upper(cc_ready_for_ranging) = 'TRUE'
               AND COALESCE(cc_boden_landed_cost, 0.01) > 0.01
               AND COALESCE(ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1, 0.01) > 0.01
               AND COALESCE(ccticketpricechannel_override_gbp2, ccticketpricechannel_base_gbp2, 0.01) > 0.01
               AND cardinality(d.validsizes) > 0
          THEN '1'::text
          ELSE '0'::text
      END AS ispublishable
      into v_ispublishable
  FROM bd_ma_stylecolorattributes a
  JOIN bd_h_prodstd b ON a.product = b.id
  JOIN ( SELECT bd_d_product.id,
         bd_d_product.name,
         bd_d_product.description
        FROM bd_d_product
       WHERE bd_d_product.levelid = 'style'::text) l2 ON b.ancestor0 = l2.id
  JOIN bd_ma_styleattributes c ON l2.id = c.product
  LEFT OUTER JOIN (select distinct product, cc_plan_cost, validsizes,
                                   ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1,
                                   ccticketpricechannel_override_gbp2, ccticketpricechannel_base_gbp2,
                                   ccticketpricechannel_override_usd, ccticketpricechannel_base_usd,
                                   ccticketpricechannel_override_eur1, ccticketpricechannel_base_eur1,
                                   ccticketpricechannel_override_eur2, ccticketpricechannel_base_eur2,
                                   ccticketpricechannel_override_aud, ccticketpricechannel_base_aud
                   from bd_ma_stylecolorchannelattributes
                  ) d ON a.product = d.product
  LEFT OUTER JOIN (select product, 
                          max(a_cc_newness) a_cc_newness, 
                          max(a_cc_exposure) a_cc_exposure
                   from bd_a_assortment
                   where product in (select product from bd_ma_stylecolorattributes)
                     and a_cc_newness in (select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 't_cc_newness')
                     and a_cc_exposure in (select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 't_cc_exposure')
                   group by product
                  ) f ON a.product = f.product
  where a.product = stylecolorid
  ;


  return v_ispublishable;
 END;
$$;


ALTER FUNCTION public.check_ispublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 1423 (class 1255 OID 136956808)
-- Name: commit_upload_lifecycleparams(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.commit_upload_lifecycleparams(v__uid text, v__txid text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;
v__txid text;
stylecolor_ret refcursor;
input_uid text;
input_txid text;

v__timestamp timestamp without time zone;

BEGIN 


select $1 into input_uid;
select $2 into input_txid;

insert into archives_lifecycleparams
select a.*
from staging_lifecycleparams a
where __txid=input_txid
;

create temporary table temp_shadow_lifecycleparams on commit drop
AS
select * from shadow_lifecycleparams where __txid=input_txid and __uid = input_uid;

select max(__timestamp) into v__timestamp from staging_lifecycleparams where __txid=input_txid and __uid = input_uid;

-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_lifecycleparams:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_stylecolorchannelattributes
select a.*, 'existing', input_txid, input_uid, v__timestamp 
from bd_ma_stylecolorchannelattributes a, shadow_lifecycleparams b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Update data into App Tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start bd_ma_stylecolorchannelattributes:%', 'START:'|| now();
update bd_ma_stylecolorchannelattributes a
set 
  dbt_wk           = planned_launch_week,
  erlstmkdnwk      = md_week,
  exitdate         = exit_week,
  slsrnk           = pssr::real
from shadow_lifecycleparams b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_lifecycleparams:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_stylecolorchannelattributes
select a.*, 'new', input_txid, input_uid, v__timestamp 
from bd_ma_stylecolorchannelattributes a, shadow_lifecycleparams b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Upload Statistics
-- =================================
-- ---------------------------------
RAISE NOTICE 'Start upload_statistics:%', 'UPDATE:'|| now();
update upload_statistics 
set final_status = 'Upload Committed'
where (__txid, __timestamp) in (select __txid, max(__timestamp) from staging_lifecycleparams where __txid=input_txid group by __txid)
;

delete from shadow_lifecycleparams where __txid in (select __txid from upload_statistics where final_status = 'Upload Committed')
;

RAISE NOTICE 'COMMIT SUCCESSFUL ';

OPEN stylecolor_ret FOR
SELECT product
FROM temp_shadow_lifecycleparams
where __txid=input_txid
;

-- select commit_upload ('test','5c09ce01-7093-4600-8ce8-fce9f6e64d7e');
RETURN stylecolor_ret;
END;
$_$;


ALTER FUNCTION public.commit_upload_lifecycleparams(v__uid text, v__txid text) OWNER TO psql;

--
-- TOC entry 1424 (class 1255 OID 136956809)
-- Name: commit_upload_optionattributes(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.commit_upload_optionattributes(v__uid text, v__txid text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

 v_template_id  text;
 v__txid text;
 stylecolor_ret refcursor;
 input_uid text;
 input_txid text;

 v__timestamp timestamp without time zone;

 BEGIN

 select $1 into input_uid;
 select $2 into input_txid;

 insert into archives_optionattributes
 select a.*
 from staging_optionattributes a
 where __txid=input_txid
 ;

 create temporary table temp_shadow_optionattributes on commit drop
 AS
 select * from shadow_optionattributes where __txid=input_txid and __uid = input_uid;

 select max(__timestamp) into v__timestamp from staging_optionattributes where __txid=input_txid and __uid = input_uid;

 -- ---------------------------------
 -- =================================
 -- Create Arc tables
 -- =================================
 -- ---------------------------------
 -- SUP-4083
 INSERT INTO arc_bulkupload_ma_stylecolorattributes
 SELECT
    a.product,
    a.cc_sub_range,
    a.cc_applied_detail,
    a.cc_colour_group,
    a.cc_sub_theme,
    a.cc_pattern,
    a.cc_print_name,
    a.cc_collection,
    a.cc_fabric_yarn_type,
    a.cccw_age_gender,
    a.cc_price_banding_latest,
    a.cc_texture,
    a.cc_season_latest,
    a.cc_classification_latest,
    a.cc_theme_latest,
    a.launch_month,
    a.actual_launch_month,
    a.launch_week,
    a.actual_launch_week,
    a.cccolor,
    a.cccolorfamily,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state,
    a.cc_weight,
    a.cc_archetype,
    a.cc_pattern_new,
    a.cc_ready_for_ranging,
    a.cc_active_flag,
    a.cc_color_code,
    a.cc_color_group,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    a.isstyleremovable,
    a.ispublishable,
    a.cc_supplier_1,
    a.cc_supplier_1_fob,
    a.cc_supplier_1_moq,
    a.cc_supplier_2,
    a.cc_supplier_2_fob,
    a.cc_supplier_2_moq,
    a.cc_supplier_3,
    a.cc_supplier_3_fob,
    a.cc_supplier_3_moq,
    a.cc_boden_landed_cost,
    a.merch_comments,
    a.plan_comments,
    a.subcategory_name,
    a.category_name,
    a.department_name,
    a.segment_name,
    a.division_name,
    a.company_name,
    'existing',
    input_txid,
    input_uid,
    v__timestamp,
    a.us_price_band,
    a.uk_price_band
 FROM bd_ma_stylecolorattributes a
 JOIN shadow_optionattributes b ON a.product = b.product
 WHERE b.__txid = input_txid;

 -- ---------------------------------
 -- =================================
 -- Update data into App Tables
 -- =================================
 -- ---------------------------------
 update bd_ma_stylecolorattributes a
 set
   cc_price_banding_latest     = price_banding_option,
   cc_archetype                = archetype,
   cc_theme_latest             = design_theme,
   cc_sub_theme                = design_sub_theme,
   cc_applied_detail           = detail,
   cc_texture                  = fabric_type,
   cc_pattern_new              = pattern,
   cc_pattern                  = pattern_type,
   cc_classification_latest    = product_pyramid_option,
   cc_collection               = theme,
   cc_weight                   = weight_option
 from shadow_optionattributes b
 where a.product = b.product
 and __txid=input_txid;

 -- ---------------------------------
 -- =================================
 -- Create Arc tables
 -- =================================
 -- ---------------------------------
 -- SUP-4083
 INSERT INTO arc_bulkupload_ma_stylecolorattributes
 SELECT
    a.product,
    a.cc_sub_range,
    a.cc_applied_detail,
    a.cc_colour_group,
    a.cc_sub_theme,
    a.cc_pattern,
    a.cc_print_name,
    a.cc_collection,
    a.cc_fabric_yarn_type,
    a.cccw_age_gender,
    a.cc_price_banding_latest,
    a.cc_texture,
    a.cc_season_latest,
    a.cc_classification_latest,
    a.cc_theme_latest,
    a.launch_month,
    a.actual_launch_month,
    a.launch_week,
    a.actual_launch_week,
    a.cccolor,
    a.cccolorfamily,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state,
    a.cc_weight,
    a.cc_archetype,
    a.cc_pattern_new,
    a.cc_ready_for_ranging,
    a.cc_active_flag,
    a.cc_color_code,
    a.cc_color_group,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    a.isstyleremovable,
    a.ispublishable,
    a.cc_supplier_1,
    a.cc_supplier_1_fob,
    a.cc_supplier_1_moq,
    a.cc_supplier_2,
    a.cc_supplier_2_fob,
    a.cc_supplier_2_moq,
    a.cc_supplier_3,
    a.cc_supplier_3_fob,
    a.cc_supplier_3_moq,
    a.cc_boden_landed_cost,
    a.merch_comments,
    a.plan_comments,
    a.subcategory_name,
    a.category_name,
    a.department_name,
    a.segment_name,
    a.division_name,
    a.company_name,
    'new',
    input_txid,
    input_uid,
    v__timestamp,
    a.us_price_band,
    a.uk_price_band
 FROM bd_ma_stylecolorattributes a, shadow_optionattributes b
 WHERE a.product = b.product
 AND __txid = input_txid;

 -- ---------------------------------
 -- =================================
 -- Upload Statistics
 -- =================================
 -- ---------------------------------
 RAISE NOTICE 'Start upload_statistics:%', 'UPDATE:'|| now();
 update upload_statistics
 set final_status = 'Upload Committed'
 where (__txid, __timestamp) in (select __txid, max(__timestamp) from staging_optionattributes where __txid=input_txid group by __txid)
 ;

 delete from shadow_optionattributes where __txid in (select __txid from upload_statistics where final_status = 'Upload Committed')
 ;

 RAISE NOTICE 'COMMIT SUCCESSFUL ';

 OPEN stylecolor_ret FOR
 SELECT product
 FROM temp_shadow_optionattributes
 where __txid=input_txid
 ;

 RETURN stylecolor_ret;
 END;
$_$;


ALTER FUNCTION public.commit_upload_optionattributes(v__uid text, v__txid text) OWNER TO psql;

--
-- TOC entry 1425 (class 1255 OID 136956810)
-- Name: commit_upload_price(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.commit_upload_price(v__uid text, v__txid text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;
v__txid text;
stylecolor_ret refcursor;
input_uid text;
input_txid text;

v__timestamp timestamp without time zone;

BEGIN 


select $1 into input_uid;
select $2 into input_txid;

insert into archives_price
select a.*
from staging_price a
where __txid=input_txid
;

create temporary table temp_shadow_price on commit drop
AS
select * from shadow_price where __txid=input_txid and __uid = input_uid;

select max(__timestamp) into v__timestamp from staging_price where __txid=input_txid and __uid = input_uid;

-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_price:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_stylecolorchannelattributes
select a.*, 'existing', input_txid, input_uid, v__timestamp 
from bd_ma_stylecolorchannelattributes a, shadow_price b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Update data into App Tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start bd_ma_stylecolorchannelattributes:%', 'START:'|| now();
update bd_ma_stylecolorchannelattributes a
set 
 ccticketpricechannel_override_gbp1  = fsp_gbp_ticket_1_override::real,
 ccticketpricechannel_override_gbp2  = fsp_gbp_ticket_2_override::real,
 ccticketpricechannel_override_eur1  = eur_ticket_1_override::real,
 ccticketpricechannel_override_eur2  = eur_ticket_2_override::real,
 ccticketpricechannel_override_usd   = usd_ticket_override::real,
 ccticketpricechannel_override_aud   = aud_ticket_override::real
from shadow_price b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_price:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_stylecolorchannelattributes
select a.*, 'new', input_txid, input_uid, v__timestamp 
from bd_ma_stylecolorchannelattributes a, shadow_price b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Upload Statistics
-- =================================
-- ---------------------------------
RAISE NOTICE 'Start upload_statistics:%', 'UPDATE:'|| now();
update upload_statistics 
set final_status = 'Upload Committed'
where (__txid, __timestamp) in (select __txid, max(__timestamp) from staging_price where __txid=input_txid group by __txid)
;

delete from shadow_price where __txid in (select __txid from upload_statistics where final_status = 'Upload Committed')
;

RAISE NOTICE 'COMMIT SUCCESSFUL ';

OPEN stylecolor_ret FOR
SELECT product
FROM temp_shadow_price
where __txid=input_txid
;

-- select commit_upload ('test','5c09ce01-7093-4600-8ce8-fce9f6e64d7e');
RETURN stylecolor_ret;
END;
$_$;


ALTER FUNCTION public.commit_upload_price(v__uid text, v__txid text) OWNER TO psql;

--
-- TOC entry 1426 (class 1255 OID 136956811)
-- Name: commit_upload_styleattributes(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.commit_upload_styleattributes(v__uid text, v__txid text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;
v__txid text;
stylecolor_ret refcursor;
input_uid text;
input_txid text;

v__timestamp timestamp without time zone;

BEGIN 


select $1 into input_uid;
select $2 into input_txid;

insert into archives_styleattributes
select a.*
from staging_styleattributes a
where __txid=input_txid
;

create temporary table temp_shadow_styleattributes on commit drop
AS
select * from shadow_styleattributes where __txid=input_txid and __uid = input_uid;

select max(__timestamp) into v__timestamp from staging_styleattributes where __txid=input_txid and __uid = input_uid;

-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_styleattributes:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_styleattributes
select a.*, 'existing', input_txid, input_uid, v__timestamp 
from bd_ma_styleattributes a, shadow_styleattributes b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Update data into App Tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start bd_ma_styleattributes:%', 'START:'|| now();
update bd_ma_styleattributes a
set 
sty_age_style                = age_style               ,
sty_packages                 = building_blocks         ,
sty_fit_style                = clothing_fit            ,
sty_end_use                  = end_use                 ,
sty_heel_height              = footwear_heel_height    ,
sty_footwear_type            = footwear_type           ,
sty_gender_style             = gender                  ,
sty_dress_skirt_length       = length_style            ,
sty_neck_detail              = neck_shape              ,
sty_price_band_style         = price_banding_style     ,
sty_classification_latest    = product_pyramid_style   ,
sty_rise                     = rise                    ,
sty_skirt_shape              = skirt_or_leg_shape      ,
sty_sleeve_length            = sleeve_length           ,
sty_sleeve_shape             = sleeve_shape            
from shadow_styleattributes b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Create Arc tables
-- =================================
-- ---------------------------------
--RAISE NOTICE 'Start arc_bulkupload_ma_styleattributes:%', 'START:'|| now();
INSERT INTO arc_bulkupload_ma_styleattributes
select a.*, 'new', input_txid, input_uid, v__timestamp 
from bd_ma_styleattributes a, shadow_styleattributes b
where a.product = b.product
and __txid=input_txid;


-- ---------------------------------
-- =================================
-- Upload Statistics
-- =================================
-- ---------------------------------
RAISE NOTICE 'Start upload_statistics:%', 'UPDATE:'|| now();
update upload_statistics 
set final_status = 'Upload Committed'
where (__txid, __timestamp) in (select __txid, max(__timestamp) from staging_styleattributes where __txid=input_txid group by __txid)
;

delete from shadow_styleattributes where __txid in (select __txid from upload_statistics where final_status = 'Upload Committed')
;

RAISE NOTICE 'COMMIT SUCCESSFUL ';

OPEN stylecolor_ret FOR
SELECT c.product
FROM temp_shadow_styleattributes a, bd_h_prodstd b, bd_ma_stylecolorchannelattributes c
where __txid=input_txid
and a.product = b.ancestor0 and b.id = c.product and c.record_state = 0
;

-- select commit_upload ('test','5c09ce01-7093-4600-8ce8-fce9f6e64d7e');
RETURN stylecolor_ret;
END;
$_$;


ALTER FUNCTION public.commit_upload_styleattributes(v__uid text, v__txid text) OWNER TO psql;

--
-- TOC entry 1427 (class 1255 OID 136956812)
-- Name: copy_inserted_plan_queue(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.copy_inserted_plan_queue() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  INSERT into plan_queue_mark
  SELECT (NEW).*;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.copy_inserted_plan_queue() OWNER TO psql;

--
-- TOC entry 1428 (class 1255 OID 136956813)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          UPDATE bd_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1429 (class 1255 OID 136956814)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from bd_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 1430 (class 1255 OID 136956815)
-- Name: eval(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.eval(expression text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  result integer;
begin
  execute expression into result;
  return result;
end;
$$;


ALTER FUNCTION public.eval(expression text) OWNER TO psql;

--
-- TOC entry 1431 (class 1255 OID 136956816)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE bd_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1432 (class 1255 OID 136956817)
-- Name: fetch_lifecycleparams(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_lifecycleparams(__product text, __location text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ret refcursor;
BEGIN

OPEN ret FOR
SELECT
product,
style_name,
style_description,
option_name,
case when is_published >= 1 then 'Yes' else 'No' end is_published,
actual_launch_week,
planned_launch_week,
md_week,
exit_week,
pssr
FROM
(
  SELECT 
  c.product                   as product,
  d.name                      as style_name,
  d.description               as style_description,
  e.name                      as option_name,
  e.description               as option_description,
  sum(publish)                as is_published,
  act_dbt_wk                  as actual_launch_week,
  dbt_wk                      as planned_launch_week,
  erlstmkdnwk                 as md_week,
  exitdate                    as exit_week,
  slsrnk                      as pssr
  from bd_ma_stylecolorchannelattributes a
  join bd_h_prodstd b on a.product = b.id
  join bd_ma_stylecolorattributes c on b.id = c.product
  join bd_d_product d on b.ancestor0 = d.id
  join bd_d_product e on c.product = e.id
  left outer join (
  select product, 1 as publish from sync_stylecolorpublishes where is_published = 1
  union
  select product, 1 as publish from bd_p_dc_adj where dc_publish = 1
  ) f on a.product = f.product
  where a.record_state = 0 and array_length(validsizes, 1) is not null and exitdate > plan_current
  and b.ancestor3 = __product
  group by 
  c.product
  ,d.name
  ,d.description
  ,e.name
  ,e.description
  ,act_dbt_wk
  ,dbt_wk
  ,erlstmkdnwk
  ,exitdate
  ,slsrnk
) x
;

return ret;
END;
$$;


ALTER FUNCTION public.fetch_lifecycleparams(__product text, __location text) OWNER TO psql;

--
-- TOC entry 1433 (class 1255 OID 136956818)
-- Name: fetch_optionattributes(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_optionattributes(__product text, __location text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ret refcursor;
BEGIN

OPEN ret FOR
SELECT
product,
style_name,
style_description,
option_name,
case when is_published >= 1 then 'Yes' else 'No' end is_published,
price_banding_option,
archetype,
design_theme,
design_sub_theme,
detail,
fabric_type,
pattern,
pattern_type,
print_name,
product_pyramid_option,
theme,
weight_option
FROM
(
  SELECT 
  c.product                   as product,
  d.name                      as style_name,
  d.description               as style_description,
  e.name                      as option_name,
  e.description               as option_description,
  sum(publish)                as is_published,
  cc_price_banding_latest     as price_banding_option,
  cc_archetype                as archetype,
  cc_theme_latest             as design_theme,
  cc_sub_theme                as design_sub_theme,
  cc_applied_detail           as detail,
  cc_texture                  as fabric_type,
  cc_pattern_new              as pattern,
  cc_pattern                  as pattern_type,
  cc_print_name               as print_name,
  cc_classification_latest    as product_pyramid_option,
  cc_collection               as theme,
  cc_weight                   as weight_option
  from bd_ma_stylecolorchannelattributes a
  join bd_h_prodstd b on a.product = b.id
  join bd_ma_stylecolorattributes c on b.id = c.product
  join bd_d_product d on b.ancestor0 = d.id
  join bd_d_product e on c.product = e.id
  left outer join (
  select product, 1 as publish from sync_stylecolorpublishes where is_published = 1
  union
  select product, 1 as publish from bd_p_dc_adj where dc_publish = 1
  ) f on a.product = f.product
  where a.record_state = 0 and array_length(validsizes, 1) is not null and exitdate > plan_current
  and b.ancestor3 = __product
  group by 
  c.product
  ,d.name
  ,d.description
  ,e.name
  ,e.description
  ,cc_price_banding_latest
  ,cc_archetype
  ,cc_theme_latest
  ,cc_sub_theme
  ,cc_applied_detail
  ,cc_texture
  ,cc_pattern_new
  ,cc_pattern
  ,cc_print_name
  ,cc_classification_latest
  ,cc_collection
  ,cc_weight
) x
;

return ret;
END;
$$;


ALTER FUNCTION public.fetch_optionattributes(__product text, __location text) OWNER TO psql;

--
-- TOC entry 1434 (class 1255 OID 136956819)
-- Name: fetch_price(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_price(__product text, __location text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ret refcursor;
BEGIN

OPEN ret FOR
SELECT
product,
style_name,
style_description,
option_name,
case when is_published >= 1 then 'Yes' else 'No' end is_published,
md_week,
fsp_gbp_ticket_1_override,
fsp_gbp_ticket_2_override,
eur_ticket_1_override,
eur_ticket_2_override,
usd_ticket_override,
aud_ticket_override,
fsp_gbp_ticket_1,
fsp_gbp_ticket_2,
eur_ticket_1,
eur_ticket_2,
usd_ticket,
aud_ticket
FROM
(
  SELECT 
  c.product                            as product,
  d.name                               as style_name,
  d.description                        as style_description,
  e.name                               as option_name,
  e.description                        as option_description,
  sum(publish)                         as is_published,
  erlstmkdnwk                          as md_week,
  ccticketpricechannel_override_gbp1   as fsp_gbp_ticket_1_override,
  ccticketpricechannel_override_gbp2   as fsp_gbp_ticket_2_override,
  ccticketpricechannel_override_eur1   as eur_ticket_1_override,
  ccticketpricechannel_override_eur2   as eur_ticket_2_override,
  ccticketpricechannel_override_usd    as usd_ticket_override,
  ccticketpricechannel_override_aud    as aud_ticket_override,
  ccticketpricechannel_base_gbp1       as fsp_gbp_ticket_1,
  ccticketpricechannel_base_gbp2       as fsp_gbp_ticket_2,
  ccticketpricechannel_base_eur1       as eur_ticket_1,
  ccticketpricechannel_base_eur2       as eur_ticket_2,
  ccticketpricechannel_base_usd        as usd_ticket,
  ccticketpricechannel_base_aud        as aud_ticket
  from bd_ma_stylecolorchannelattributes a
  join bd_h_prodstd b on a.product = b.id
  join bd_ma_stylecolorattributes c on b.id = c.product
  join bd_d_product d on b.ancestor0 = d.id
  join bd_d_product e on c.product = e.id
  left outer join (
  select product, 1 as publish from sync_stylecolorpublishes where is_published = 1
  union
  select product, 1 as publish from bd_p_dc_adj where dc_publish = 1
  ) f on a.product = f.product
  where a.record_state = 0 and array_length(validsizes, 1) is not null and exitdate > plan_current
  and b.ancestor3 = __product
  group by 
  c.product
  ,d.name
  ,d.description
  ,e.name
  ,e.description
  ,erlstmkdnwk
  ,ccticketpricechannel_override_gbp1
  ,ccticketpricechannel_override_gbp2
  ,ccticketpricechannel_override_eur1
  ,ccticketpricechannel_override_eur2
  ,ccticketpricechannel_override_usd
  ,ccticketpricechannel_override_aud
  ,ccticketpricechannel_base_gbp1
  ,ccticketpricechannel_base_gbp2
  ,ccticketpricechannel_base_eur1
  ,ccticketpricechannel_base_eur2
  ,ccticketpricechannel_base_usd
  ,ccticketpricechannel_base_aud
) x
;

return ret;
END;
$$;


ALTER FUNCTION public.fetch_price(__product text, __location text) OWNER TO psql;

--
-- TOC entry 1435 (class 1255 OID 136956820)
-- Name: fetch_store_count(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 BEGIN

    RETURN 1;

 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text) OWNER TO psql;

--
-- TOC entry 1436 (class 1255 OID 136956821)
-- Name: fetch_styleattributes(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_styleattributes(__product text, __location text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ret refcursor;
BEGIN

OPEN ret FOR
SELECT
product,
style_name,
style_description,
case when is_published >= 1 then 'Yes' else 'No' end is_published,
age_style,
building_blocks,
clothing_fit,
end_use,
footwear_heel_height,
footwear_type,
gender,
length_style,
neck_shape,
shape_name_package,
product_pyramid_style,
rise,
skirt_or_leg_shape,
sleeve_length,
sleeve_shape
FROM
(
with publishes as
(
 select ancestor0 as style, sum(publish) publish
 from bd_h_prodstd a
 left outer join 
  (select product, 1 as publish from sync_stylecolorpublishes where is_published = 1
   union
   select product, 1 as publish from bd_p_dc_adj where dc_publish = 1
  ) b on a.id = b.product
  group by ancestor0
)
  SELECT 
  c.product                   as product,
  d.name                      as style_name,
  d.description               as style_description,
  sum(publish)                as is_published,
  sty_age_style               as age_style,
  sty_packages                as building_blocks,
  sty_fit_style               as clothing_fit,
  sty_end_use                 as end_use,
  sty_heel_height             as footwear_heel_height,
  sty_footwear_type           as footwear_type,
  sty_gender_style            as gender,
  sty_dress_skirt_length      as length_style,
  sty_neck_detail             as neck_shape,
  sty_price_band_style        as shape_name_package,
  sty_classification_latest   as product_pyramid_style,
  sty_rise                    as rise,
  sty_skirt_shape             as skirt_or_leg_shape,
  sty_sleeve_length           as sleeve_length,
  sty_sleeve_shape            as sleeve_shape
  from bd_ma_stylecolorchannelattributes a
  join bd_h_prodstd b on a.product = b.id
  join bd_ma_styleattributes c on b.ancestor0 = c.product
  join bd_d_product d on c.product = d.id
  left outer join publishes e on c.product = e.style
  where a.record_state = 0 and array_length(validsizes, 1) is not null and exitdate > plan_current
  and b.ancestor3 = __product
  group by 
  c.product                  
  ,d.name                     
  ,d.description              
  ,sty_age_style              
  ,sty_packages               
  ,sty_fit_style              
  ,sty_end_use                
  ,sty_heel_height            
  ,sty_footwear_type          
  ,sty_gender_style           
  ,sty_dress_skirt_length     
  ,sty_neck_detail            
  ,sty_price_band_style       
  ,sty_classification_latest  
  ,sty_rise                   
  ,sty_skirt_shape            
  ,sty_sleeve_length          
  ,sty_sleeve_shape           
) x
;

return ret;
END;
$$;


ALTER FUNCTION public.fetch_styleattributes(__product text, __location text) OWNER TO psql;

--
-- TOC entry 1437 (class 1255 OID 136956822)
-- Name: generate_create_table_statement(character varying); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.generate_create_table_statement(p_table_name character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_table_ddl   text;
    column_record record;
BEGIN
    FOR column_record IN 
        SELECT 
            b.nspname as schema_name,
            b.relname as table_name,
            a.attname as column_name,
            pg_catalog.format_type(a.atttypid, a.atttypmod) as column_type,
            CASE WHEN 
                (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                 FROM pg_catalog.pg_attrdef d
                 WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef) IS NOT NULL THEN
                'DEFAULT '|| (SELECT substring(pg_catalog.pg_get_expr(d.adbin, d.adrelid) for 128)
                              FROM pg_catalog.pg_attrdef d
                              WHERE d.adrelid = a.attrelid AND d.adnum = a.attnum AND a.atthasdef)
            ELSE
                ''
            END as column_default_value,
            CASE WHEN a.attnotnull = true THEN 
                'NOT NULL'
            ELSE
                'NULL'
            END as column_not_null,
            a.attnum as attnum,
            e.max_attnum as max_attnum
        FROM 
            pg_catalog.pg_attribute a
            INNER JOIN 
             (SELECT c.oid,
                n.nspname,
                c.relname
              FROM pg_catalog.pg_class c
                   LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
              WHERE c.relname ~ ('^('||p_table_name||')$')
                AND pg_catalog.pg_table_is_visible(c.oid)
              ORDER BY 2, 3) b
            ON a.attrelid = b.oid
            INNER JOIN 
             (SELECT 
                  a.attrelid,
                  max(a.attnum) as max_attnum
              FROM pg_catalog.pg_attribute a
              WHERE a.attnum > 0 
                AND NOT a.attisdropped
              GROUP BY a.attrelid) e
            ON a.attrelid=e.attrelid
        WHERE a.attnum > 0 
          AND NOT a.attisdropped
        ORDER BY a.attnum
    LOOP
        IF column_record.attnum = 1 THEN
            v_table_ddl:='CREATE TABLE '||column_record.schema_name||'.'||column_record.table_name||' (';
        ELSE
            v_table_ddl:=v_table_ddl||',';
        END IF;

        IF column_record.attnum <= column_record.max_attnum THEN
            v_table_ddl:=v_table_ddl||chr(10)||
                     '    '||column_record.column_name||' '||column_record.column_type||' '||column_record.column_default_value||' '||column_record.column_not_null;
        END IF;
    END LOOP;

    v_table_ddl:=v_table_ddl||');';
    RETURN v_table_ddl;
END;
$_$;


ALTER FUNCTION public.generate_create_table_statement(p_table_name character varying) OWNER TO psql;

--
-- TOC entry 1438 (class 1255 OID 136956823)
-- Name: get_default_parameters(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_default_parameters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
s1 text;
BEGIN
update cart_params a 
set
initrcptwk = default_initrcptwk,
 dbt_wk = default_dbt_wk,
 too = default_too,
 mkdnwks = default_mkdnwks,
 last_inv_wk = default_last_inv_wk,
 lstfpwk = default_lstfpwk,
 last_rcpt_wk = default_last_rcpt_wk,
 erlstmkdnwk = default_erlstmkdnwk,
 exitdate = default_exitdate,
 ccmdstrategy = default_ccmdstrategy,
 presmin = default_presmin,
 presmin_weeks = default_presmin_weeks,
 ccrcptint = default_ccrcptint,
 ccordermultiple = default_ccordermultiple,
 ccordpolicy = default_ccordpolicy
from bd_ma_dptflrsetattributes b
where b.product = NEW.scope_product
--and a.location = NEW.scope_location
and b.time = NEW.scope_floorset;
/*
update cart_params a set initrcptwk = greatest(initrcptwk, b.value) from (select value from bd_serviceparams where id='plan_current') b
where a.product=NEW.scope_product;
update cart_params a set dbt_wk = greatest(dbt_wk, b.value) from (select value from bd_serviceparams where id='plan_current') b
where a.product=NEW.scope_product;
*/
delete from cart_ranging b  
where 
b.scope_product = NEW.scope_product
and b.scope_location = NEW.scope_location
and b.scope_floorset = NEW.scope_floorset;
insert into cart_ranging 
(jsessionid,scope_product,scope_location,scope_start,scope_floorset
 ,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded)
select 
NEW.jsessionid,product,NEW.scope_location,NEW.scope_start,time, 
default_strterritory,default_straccount,default_strchannel,cast(default_grade as text[]) as default_grade,default_ssg,default_flnrange,isfunded
FROM (
select product, time, default_strterritory,default_straccount,default_strchannel,default_grade,default_ssg,default_flnrange
 ,1 as isfunded
FROM bd_ma_dptflrsetattributes
where product = NEW.scope_product
--and a.location = NEW.scope_location
and time = NEW.scope_floorset
)X;
--RAISE NOTICE 'INPUT:%', 'START:'|| s1;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.get_default_parameters() OWNER TO psql;

--
-- TOC entry 1439 (class 1255 OID 136956824)
-- Name: get_default_params(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_default_params(input_jsessionid text, scope_department text, scope_location text, scope_start text, scope_floorset text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
v_exists integer;
insert_s2 text;
delete_s3 text;
insert_s4 text;
BEGIN
  EXECUTE '(select count(*) from cart_params where 
          jsessionid = '''||$1||'''  
          and scope_product =  '''||$2||'''  
          and scope_location = '''||$3||'''  
    and scope_start = '''||$4||''' 
          )' into v_exists;
  insert_s2 := '
        INSERT INTO cart_params
        (
            jsessionid, scope_product, scope_location, scope_start, scope_floorset
          , initrcptwk
          , dbt_wk
          , too
          , mkdnwks
          , last_inv_wk
          , lstfpwk
          , last_rcpt_wk
          , erlstmkdnwk
          , exitdate
          , ccmdstrategy
          , presmin
          , presmin_weeks
          , ccrcptint
          , ccordermultiple
          , ccordpolicy
        )
        SELECT
            '''||$1||''','''||$2||''','''||$3||''','''||$4||''','''||$5||'''
          , default_initrcptwk
          , default_dbt_wk
          , default_too
          , default_mkdnwks
          , default_last_inv_wk
          , default_lstfpwk
          , default_last_rcpt_wk
          , default_erlstmkdnwk
          , default_exitdate
          , default_ccmdstrategy
          , default_presmin
          , default_presmin_weeks
          , default_ccrcptint
          , default_ccordermultiple
          , default_ccordpolicy
        FROM 
          bd_ma_dptflrsetattributes
                  WHERE 
          product = '''||$2||'''
          and time = '''||$5||'''
        ';
  delete_s3 := ' 
     delete from cart_ranging where jsessionid = '''||$1||''' and scope_product='''||$2||''' 
     and scope_start = '''||$4||''' and scope_floorset = '''||$5||'''  
             ';
  insert_s4 := '
  insert into cart_ranging 
(jsessionid,scope_product,scope_location,scope_start,scope_floorset
   ,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, indx, store_count)
select 
  '''||$1||''',product,'''||$3||''','''||$4||''',time, 
    default_strterritory
  , default_straccount
  , default_strchannel
  , cast(default_grade as text[]) as default_grade
  , default_ssg
  , default_flnrange
  , isfunded
  , indx
        , store_count
  FROM (
  select product, time, default_strterritory,default_straccount,default_strchannel,default_grade,default_ssg,default_flnrange
   ,1 as isfunded, a.indx, a.default_store_count as store_count
  FROM bd_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from bd_serviceparams where id=''plan_current'') c,
   (select value as plan_end from bd_serviceparams where id=''plan_end'') d
  where 
  b.jsessionid = '''||$1||'''
  and b.scope_product = '''||$2||'''
  and b.scope_location = '''||$3||'''
  and a.product = b.scope_product
     and a.slsstart <= least(d.plan_end,b.exitdate) and a.slsend >= greatest(b.dbt_wk,c.plan_current)
  )X
        ';
  IF  v_exists = 0
  THEN
  EXECUTE insert_s2;
  EXECUTE delete_s3;  
  EXECUTE insert_s4;
  END IF;
 RETURN;
END;
$_$;


ALTER FUNCTION public.get_default_params(input_jsessionid text, scope_department text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 1440 (class 1255 OID 136956825)
-- Name: get_store_count(text, text[], text[], text[], text[], text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, strterritory text[], straccount text[], strchannel text[], grade text[], productval text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 BEGIN
RETURN(
  SELECT
  count(*)
FROM
  (
    (
      (
        (
          SELECT
            distinct(smc.unnest) as store
          FROM
            (
              SELECT
                unnest(stores)
              FROM
                public.bd_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strterritory'
                AND value=ANY( strterritory )
            ) AS smc
        ) as smc
        INNER JOIN (
          SELECT
            distinct(sc.unnest) as store
          FROM
            (
              SELECT
                unnest(stores)
              FROM
                public.bd_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strchannel'
                AND value = ANY( strchannel )
            ) as sc
        ) as sc USING (store)
      )
      INNER JOIN (
        SELECT
          distinct(sw.unnest) as store
        FROM
          (
            SELECT
              unnest(stores)
            FROM
              public.bd_l_storelookup
            WHERE
              time = week
              AND product = productVal
              AND id = 'straccount'
              AND value = ANY( straccount )
          ) as sw
      ) as sw USING (store)
    )
    INNER JOIN (
      SELECT
        distinct(gr.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            public.bd_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'grade'
            AND value = ANY( grade )
        ) as gr
    ) as gr USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.get_store_count(week text, strterritory text[], straccount text[], strchannel text[], grade text[], productval text) OWNER TO psql;

--
-- TOC entry 1441 (class 1255 OID 136956826)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from bd_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 1442 (class 1255 OID 136956827)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE bd_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1443 (class 1255 OID 136956828)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 1444 (class 1255 OID 136956829)
-- Name: notify_plan_queue_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_plan_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
                EXECUTE 'NOTIFY plan_queue_change';
                RETURN NEW;
            END;
            $$;


ALTER FUNCTION public.notify_plan_queue_change() OWNER TO psql;

--
-- TOC entry 1445 (class 1255 OID 136956830)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM bd_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 1446 (class 1255 OID 136956831)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
sls_start     text;
dept_var      text;
cat_var       text;
BEGIN

  select ancestor2 into cat_var
  from bd_h_prodstd where id = NEW.product;

  select ancestor3 into dept_var
  from bd_h_prodstd where id = NEW.product;

  select a.slsstart into sls_start 
  from bd_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;

  if NEW.SSG is null or cardinality(NEW.SSG) = 0 then 
  
      NEW.store_count := get_store_count(
                                           sls_start
                                          ,NEW.strterritory
                                          ,NEW.straccount
                                          ,NEW.strchannel
                                          ,NEW.grade
                                          ,cat_var
                                        );
  else 
      select cardinality(stores) into NEW.store_count
      from bd_l_ssglookup 
      where ssg_id = array_to_string(NEW.SSG, ',')
        and product = dept_var;
  end if;

  update bd_a_assortment a
  set grade = NEW.grade
     ,strterritory = NEW.strterritory
     ,straccount = NEW.straccount
     ,strchannel = NEW.strchannel
     ,ssg = NEW.ssg
     ,store_count = NEW.store_count

  where product = NEW.product
    and location = NEW.location
    and time in (select distinct id 
                 from bd_d_time a, bd_a_assortment b 
                 where a.id = b.time 
                   and levelid = 'floorset' 
                   and product = NEW.product
                   and location = NEW.location
                   and indx >= (select indx 
                                from bd_d_time a, bd_a_assortment b 
                                where a.id = b.time 
                                  and product = NEW.product
                                  and location = NEW.location
                                  and a.id = NEW.time
                               )
                 )
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 1447 (class 1255 OID 136956832)
-- Name: propagate_phaseattrs_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_phaseattrs_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  update bd_a_assortment a
  set a_cc_phase_story = NEW.a_cc_phase_story
     ,a_cc_newness = NEW.a_cc_newness
     ,a_cc_exposure = NEW.a_cc_exposure
  where product = NEW.product
    and location = NEW.location
    and time in (select distinct id 
                 from bd_d_time a, bd_a_assortment b 
                 where a.id = b.time 
                   and levelid = 'floorset' 
                   and product = NEW.product
                   and location = NEW.location
                   and indx > (select indx 
                                from bd_d_time a, bd_a_assortment b 
                                where a.id = b.time 
                                  and product = NEW.product
                                  and location = NEW.location
                                  and a.id = NEW.time
                               )
                )
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_phaseattrs_to_floorsets() OWNER TO psql;

--
-- TOC entry 1448 (class 1255 OID 136956833)
-- Name: queue_removal_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.queue_removal_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '15.5', 'NA', NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
    DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);


RETURN NEW;
END;
$$;


ALTER FUNCTION public.queue_removal_update() OWNER TO psql;

--
-- TOC entry 1449 (class 1255 OID 136956834)
-- Name: queue_ticketprice_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.queue_ticketprice_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    if exists (SELECT FROM sync_stylecolorpublishes where product= NEW.product and (first_published_date IS NOT NULL)) and (COALESCE(NEW.ccticketpricechannel_override_aud, 0) != COALESCE(OLD.ccticketpricechannel_override_aud, 0) OR COALESCE(NEW.ccticketpricechannel_override_eur1, 0) != COALESCE(OLD.ccticketpricechannel_override_eur1, 0) OR COALESCE(NEW.ccticketpricechannel_override_eur2, 0) != COALESCE(OLD.ccticketpricechannel_override_eur2, 0) OR COALESCE(NEW.ccticketpricechannel_override_gbp1, 0) != COALESCE(OLD.ccticketpricechannel_override_gbp1, 0) OR COALESCE(NEW.ccticketpricechannel_override_gbp2, 0) != COALESCE(OLD.ccticketpricechannel_override_gbp2, 0) OR COALESCE(NEW.ccticketpricechannel_override_usd, 0) != COALESCE(OLD.ccticketpricechannel_override_usd, 0) OR COALESCE(NEW.ccticketpricechannel_base_aud, 0) != COALESCE(OLD.ccticketpricechannel_base_aud, 0) OR COALESCE(NEW.ccticketpricechannel_base_eur1, 0) != COALESCE(OLD.ccticketpricechannel_base_eur1, 0) OR COALESCE(NEW.ccticketpricechannel_base_eur2, 0) != COALESCE(OLD.ccticketpricechannel_base_eur2, 0) OR COALESCE(NEW.ccticketpricechannel_base_gbp1, 0) != COALESCE(OLD.ccticketpricechannel_base_gbp1, 0) OR COALESCE(NEW.ccticketpricechannel_base_gbp2, 0) != COALESCE(OLD.ccticketpricechannel_base_gbp2, 0) OR COALESCE(NEW.ccticketpricechannel_base_usd, 0) != COALESCE(OLD.ccticketpricechannel_base_usd, 0)

    ) then
        
        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.1', 'NA', NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

    end if;


RETURN NEW;
END;
$$;


ALTER FUNCTION public.queue_ticketprice_update() OWNER TO psql;

--
-- TOC entry 1450 (class 1255 OID 136956835)
-- Name: sizerangecode_isvalid(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sizerangecode_isvalid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    s1 text;
    s2 text;
    s3 text;

    table_temp_isvalid_master text;
    v_uuid_temp text;
    v_uuid text;
 v_product text;
 v_location text;
BEGIN
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
table_temp_isvalid_master:= 'temp_isvalid_master'||v_uuid;
v_product=NEW.product;
v_location=NEW.location;

s1 := 'create temporary table '||table_temp_isvalid_master||' as 
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from bd_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';

EXECUTE s1;

s2 := '
  update bd_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';

EXECUTE s2;

s3 := '
  update bd_ma_sizeattributes a
  set isvalid=b.isvalid
  from '||table_temp_isvalid_master||' b
  where a.parent_id=b.product
  and a.sizeattribute=b.validsizes
  ';

EXECUTE s3;

if exists (SELECT FROM sync_stylecolorpublishes where product= NEW.product and (first_published_date IS NOT NULL)) and cardinality(OLD.validsizes) < cardinality(NEW.validsizes) then
    
    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '15.1', 'NA', NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
        DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

end if;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.sizerangecode_isvalid() OWNER TO psql;

--
-- TOC entry 1451 (class 1255 OID 136956836)
-- Name: sizerangecode_validsizes_members(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sizerangecode_validsizes_members() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    s0 text;
    s1 text;
    s2 text;
    s3 text;
  s4 text;
    s5 text;
    s6 text;
  s6x text;
    s7 text;
  s8 text;
  
    table_temp_rangecode_master text;
    v_uuid_temp text;
    v_uuid text;
  v_product text;
  v_location text;
  v_ccrangecode text;
BEGIN
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
table_temp_rangecode_master:= 'table_temp_rangecode_master'||v_uuid;
v_product=NEW.product;
v_location=NEW.location;
v_ccrangecode=NEW.ccrangecode;
s0 := 'drop table if exists '||table_temp_rangecode_master||' 
  ';
s1 := 'create temporary table '||table_temp_rangecode_master||' as 
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location
  , lookup_value as ccrangecode,target_value as master_size_attr, uuid_generate_v4()::text as memberid, 0::int as member_exists from bd_l_dependencylookup 
  where 
  lookup_id=''ccrangecode''
  and lookup_value= '''||v_ccrangecode||'''
    ';
s2 := '
  update '||table_temp_rangecode_master||' a set memberid = b.product, member_exists=1 from bd_ma_sizeattributes b 
  where a.product=b.parent_id and a.master_size_attr=b.sizeattribute
  ';
s3 := '
  update bd_ma_sizeattributes set isvalid=0 where parent_id='''||v_product||'''
  ';
s4 := '
  delete from bd_ma_sizeattributes where product in (select memberid from '||table_temp_rangecode_master||')
  ';
s5 := ' 
  insert into bd_ma_sizeattributes (product, sizeattribute, parent_id, isvalid)
  select memberid, master_size_attr, product, 1 as isvalid from '||table_temp_rangecode_master||' 
  ';
s6 := '
  delete from bd_d_product where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0)
  ';
s6x := '
  insert into bd_d_product (id, name, description, levelid) select memberid, product||''-''||master_size_attr, product||''-''||master_size_attr, ''stylecolorsize'' 
  from  '||table_temp_rangecode_master||' 
  where member_exists=0
  ';
s7 := '
  delete from bd_h_prodstd where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0);
  insert into bd_h_prodstd 
  (id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,ancestor8,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state) 
  select 
  memberid,id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
  from bd_h_prodstd a, (select memberid,product from  '||table_temp_rangecode_master||'  where member_exists=0) b
  where a.id=b.product
  ';
s8 := '
  update bd_ma_stylecolorchannelattributes a
  set validsizes=b.validsizes
  from (select product, location, array_agg(master_size_attr) as validsizes from  '||table_temp_rangecode_master||'  group by product, location) b
  where a.product=b.product and a.location=b.location
  ';
EXECUTE s0;
EXECUTE s1;
EXECUTE s2;
EXECUTE s3;
EXECUTE s4;
EXECUTE s5;
EXECUTE s6;
EXECUTE s6x;
EXECUTE s7;
EXECUTE s8;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_validsizes_members() OWNER TO psql;

--
-- TOC entry 1452 (class 1255 OID 136956837)
-- Name: store_eligibility_triger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_triger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
    select a.product,a.location,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count 
    from bd_a_assortment a, bd_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from bd_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from bd_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx ;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx order by c.indx ;
        insert into bd_a_assortment 
        (product,location,time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strchannel,strterritory,straccount,grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx ;
    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update bd_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.ap_start, d.ap_end  from bd_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.ap_start,b.ap_end from bd_a_assortment a 
          join (select c.time,ap_start,ap_end from bd_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.ap_start 
    and c.dbt_wk <= d.ap_end) filtered 
    where bd_a_assortment.time=filtered.time and bd_a_assortment.product=filtered.product;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_triger() OWNER TO psql;

--
-- TOC entry 1453 (class 1255 OID 136956838)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 1454 (class 1255 OID 136956839)
-- Name: test_assortment(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.test_assortment(scope_product text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
v_uuid_temp text;
v_uuid text;
table_input_t1 text;

s1 text;
BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_input_t1 := 'input_t1'||v_uuid;

s1 := 'create temporary table '||table_input_t1||' as select '''||$1||''' as scope_product';

RAISE NOTICE 's1%', ': '|| s1;

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();

 RETURN;
END;
$_$;


ALTER FUNCTION public.test_assortment(scope_product text) OWNER TO psql;

--
-- TOC entry 1455 (class 1255 OID 136956840)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from bd_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 1456 (class 1255 OID 136956841)
-- Name: trigger_set_prepublish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_prepublish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF NEW.is_prepublished = 1 
 THEN
   NEW.prepublished_at = NOW()::timestamp(0);
   NEW.last_prepublished = NEW.dc_finalqty;

  INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
  VALUES (NEW.product, '14.1', NEW.time, NEW.location)
  ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
    DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

   IF NOT EXISTS (SELECT FROM sync_stylecolorpublishes WHERE product = NEW.product and first_published_date IS NOT NULL)
   THEN

    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '15.2', NEW.time, NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
     DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '15.3', NEW.time, NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
     DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '15.5', NEW.time, NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
     DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

   END IF;

 END IF;

 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_prepublish_timestamp() OWNER TO psql;

--
-- TOC entry 1457 (class 1255 OID 136956842)
-- Name: trigger_set_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF NEW.dc_publish = 1 
 THEN
   NEW.created_at = NOW()::timestamp(0);
   NEW.published_at = NOW()::timestamp(0);

   IF EXISTS (SELECT FROM bd_ma_stylecolorchannelattributes WHERE product = NEW.product) 
   THEN
    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
    VALUES (NEW.product, '14.3', NEW.time, NEW.location)
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
      DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);
  END IF;

  IF TG_OP = 'Update'
  THEN
    
    IF NEW.dc_publish = 1 and COALESCE(OLD.dc_publish,0) = 0 and NOT EXISTS (SELECT FROM sync_stylecolorpublishes WHERE product = NEW.product and first_published_date IS NOT NULL)
    THEN

      INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
      VALUES (NEW.product, '15.1', NEW.time, NEW.location)
      ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
       DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

      INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
      VALUES (NEW.product, '15.2', NEW.time, NEW.location)
      ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
       DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

      INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
      VALUES (NEW.product, '15.3', NEW.time, NEW.location)
      ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
       DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

      INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
      VALUES (NEW.product, '15.4', NEW.time, NEW.location)
      ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
       DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

      INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
      VALUES (NEW.product, '15.5', NEW.time, NEW.location)
      ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);


    END IF;

  ELSE

    IF NEW.dc_publish = 1 and NOT EXISTS (SELECT FROM sync_stylecolorpublishes WHERE product = NEW.product and first_published_date IS NOT NULL)
      THEN

        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.1', NEW.time, NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.2', NEW.time, NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.3', NEW.time, NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.4', NEW.time, NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

        INSERT INTO sync_outbound_dataqueue (product, interface, time, location)
        VALUES (NEW.product, '15.5', NEW.time, NEW.location)
        ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue 
         DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);

      END IF;

    END IF;

  END IF;
  
  IF NEW.dc_publish = 0 and OLD.dc_publish = 1
  THEN

    UPDATE sync_stylecolorpublishes
    SET is_published = 0
    WHERE product = NEW.product
    --and time = NEW.time
    --and location = NEW.location
    ;

  END IF;



 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 1458 (class 1255 OID 136956843)
-- Name: trigger_set_size_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_size_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare curSizeId integer;
BEGIN
IF (NEW.size_id is null or new.size_id = '99999')
then
    select size_id into curSizeId from size_ids si where si.size_naem = new.sizeattribute;
    new.size_id = curSizeId;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_size_id() OWNER TO psql;

--
-- TOC entry 1459 (class 1255 OID 136956844)
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW()::timestamp(0);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO psql;

--
-- TOC entry 1460 (class 1255 OID 136956845)
-- Name: undo_upload_lifecycleparams(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.undo_upload_lifecycleparams(v_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN

delete from shadow_lifecycleparams a where a.__uid=v_uid;
delete from staging_lifecycleparams a where a.__uid=v_uid;
-- delete from upload_statistics a where a.__uid=input_uid;

RAISE NOTICE 'UNDO SUCCESSFUL';

RETURN;
END;
$$;


ALTER FUNCTION public.undo_upload_lifecycleparams(v_uid text) OWNER TO psql;

--
-- TOC entry 1461 (class 1255 OID 136956846)
-- Name: undo_upload_optionattributes(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.undo_upload_optionattributes(v_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN

delete from shadow_optionattributes a where a.__uid=v_uid;
delete from staging_optionattributes a where a.__uid=v_uid;
-- delete from upload_statistics a where a.__uid=input_uid;

RAISE NOTICE 'UNDO SUCCESSFUL';

RETURN;
END;
$$;


ALTER FUNCTION public.undo_upload_optionattributes(v_uid text) OWNER TO psql;

--
-- TOC entry 1462 (class 1255 OID 136956847)
-- Name: undo_upload_price(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.undo_upload_price(v_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN

delete from shadow_price a where a.__uid=v_uid;
delete from staging_price a where a.__uid=v_uid;
-- delete from upload_statistics a where a.__uid=input_uid;

RAISE NOTICE 'UNDO SUCCESSFUL';

RETURN;
END;
$$;


ALTER FUNCTION public.undo_upload_price(v_uid text) OWNER TO psql;

--
-- TOC entry 1463 (class 1255 OID 136956848)
-- Name: undo_upload_styleattributes(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.undo_upload_styleattributes(v_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN

delete from shadow_styleattributes a where a.__uid=v_uid;
delete from staging_styleattributes a where a.__uid=v_uid;
-- delete from upload_statistics a where a.__uid=input_uid;

RAISE NOTICE 'UNDO SUCCESSFUL';

RETURN;
END;
$$;


ALTER FUNCTION public.undo_upload_styleattributes(v_uid text) OWNER TO psql;

--
-- TOC entry 1464 (class 1255 OID 136956849)
-- Name: update_eff_aur(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_eff_aur() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
s0 text;
s1 text;
s2 text;
s3 text;
s4 text;
v_addoff real;
v_event text;
v_eo real;
v_ccpriceevent text;
v_expression text;
v_ccdiscount real;
v_cccurp real;
v_mdstrategy text;
v_val real;
fep real;
final_eff_aur real;
v_val2 real;
v_uuid_temp text;
v_uuid text;
table_input_t1 text;
addofnull real;
ccdiscountnull real;
v_ticketprice real;
v_mdstart_indx int2;
v_newtime_indx int2;
v_mdpct float4;
v_erlstmkdnwk text;
BEGIN
RAISE NOTICE 'product:%', NEW.product ;
RAISE NOTICE 'time:%', NEW.time ;
select cast(addoff as real), cast(event as text), cast(eo as real) into v_addoff, v_event, v_eo
 from bd_p_itemprice 
 where product=NEW.product and location=NEW.location and time=NEW.time;
select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
 from bd_l_priceeventlookup 
 where product=NEW.department and location=NEW.location and ccpriceevent=NEW.event;
select ccdiscountpct::real, coalesce(ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1)::real into v_ccdiscount, v_cccurp
 from bd_ma_stylecolorchannelattributes 
 where product=NEW.product and location=NEW.location;
--select ccticketprice::real into v_ticketprice 
-- from bd_ma_styleattributes 
 --where product in (select ancestor0 from bd_h_prodstd where id=NEW.product);
/*
RAISE NOTICE 'INPUT:%', 'add off:'|| v_addoff;
RAISE NOTICE 'INPUT:%', 'event:'|| v_event;
RAISE NOTICE 'INPUT:%', 'eo:'|| v_eo;
RAISE NOTICE 'INPUT:%', 'priceevent:'|| v_ccpriceevent;
RAISE NOTICE 'INPUT:%', 'expression:'|| v_expression;
*/
/*CREATE SEQ TBL*/
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
table_input_t1 := 'input_t1'||v_uuid;
s1 := 'drop table if exists '||table_input_t1||'';
EXECUTE s1;
--RAISE NOTICE 'INPUT:%', 's1:'|| s1; 
s2 := 'create temporary table '||table_input_t1||' as select * from pricing_table where 1=2';
EXECUTE s2;
--RAISE NOTICE 'INPUT:%', 's2:'|| s2; 
/* END SEQ TBL CREATE */
IF v_cccurp > 0 
then 
v_cccurp := v_cccurp;
else 
v_cccurp := v_ticketprice;
end if;
/*
RAISE NOTICE 'INPUT:%', 'v_mdpct:'|| v_mdpct; 
IF NEW.time >= v_erlstmkdnwk 
then 
v_cccurp := v_cccurp * v_mdpct;
else 
v_cccurp := v_cccurp;
end if;
RAISE NOTICE 'INPUT:%', 'Before v_expression:'|| v_expression;

RAISE NOTICE 'INPUT:%', 'Before v_cccurp:'|| v_cccurp;
*/
--raise notice 'ccurp: %', v_cccurp;
IF v_expression is not null
THEN
--RAISE NOTICE 's3:%','Before S3';
s3 :=  'insert into '||table_input_t1||' (t_expression,v_cccurp) values('''||v_expression||''', '||v_cccurp||')';
RAISE NOTICE 's3:%', s3; 
EXECUTE s3;
execute 'select '||v_expression||' from '||table_input_t1||'' into v_val;
RAISE NOTICE 'INPUT:%', 'VVAL:'|| v_val;
fep := coalesce(v_eo,v_val,v_cccurp);
ELSE 
fep := coalesce(v_eo,v_cccurp);
END IF;
--RAISE NOTICE 'table_input_DEBUT_t1%', table_input_t1;
--addofnull := coalesce(v_addoff,0);
--ccdiscountnull := coalesce(v_ccdiscount,0);
--RAISE NOTICE 'addofnull:%, ccdiscountnull:%', addofnull, ccdiscountnull;
s4 := 'select '||fep||'';
--RAISE NOTICE 'INPUT:%', 'VAL:'|| s4;
EXECUTE s4  into final_eff_aur;
update bd_p_itemprice a set eff_aur=final_eff_aur where product=NEW.product and location=NEW.location and time=NEW.time;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 1465 (class 1255 OID 136956850)
-- Name: update_ticket_prices(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ticket_prices() RETURNS trigger
    LANGUAGE plpgsql
    AS $$             
BEGIN                                                                                                                                                              
IF ((SELECT indx FROM bd_d_time WHERE id = NEW.erlstmkdnwk)                                                                                                                  
   - (SELECT indx FROM bd_d_time WHERE id = NEW.plan_current)) < 5 THEN
    UPDATE bd_ma_stylecolorchannelattributes a                                                                                                  
    SET                                                                                                                                         
      ccticketpricechannel_base_gbp1     = OLD.ccticketpricechannel_base_gbp1    ,
      ccticketpricechannel_base_gbp2     = OLD.ccticketpricechannel_base_gbp2    ,
      ccticketpricechannel_base_usd      = OLD.ccticketpricechannel_base_usd     ,
      ccticketpricechannel_base_eur1     = OLD.ccticketpricechannel_base_eur1    ,
      ccticketpricechannel_base_eur2     = OLD.ccticketpricechannel_base_eur2    ,
      ccticketpricechannel_base_aud      = OLD.ccticketpricechannel_base_aud     ,
      ccticketpricechannel_override_gbp1 = OLD.ccticketpricechannel_override_gbp1,
      ccticketpricechannel_override_gbp2 = OLD.ccticketpricechannel_override_gbp2,
      ccticketpricechannel_override_usd  = OLD.ccticketpricechannel_override_usd ,
      ccticketpricechannel_override_eur1 = OLD.ccticketpricechannel_override_eur1,
      ccticketpricechannel_override_eur2 = OLD.ccticketpricechannel_override_eur2,
      ccticketpricechannel_override_aud  = OLD.ccticketpricechannel_override_aud 
    WHERE a.product = NEW.product;  
    RETURN NEW;
END IF;

UPDATE bd_ma_stylecolorchannelattributes a                                                                                                  
SET                                                                                                                                         
  ccticketpricechannel_base_eur1 = b.ticket_de_eur,                                                                                         
  ccticketpricechannel_base_usd  = b.ticket_us_usd,                                                                                          
  ccticketpricechannel_base_aud  = b.ticket_aus_aud                                                                                          
FROM ticketpricemapping_l_dependencylookup b                                                                                                
WHERE a.product = NEW.product                                                                                                               
  AND a.location = NEW.location                                                                                                             
  AND b.price_group = 'P1'                                                                                                                  
  AND b.product = (SELECT ancestor3 FROM bd_h_prodstd WHERE id = NEW.product)                                                               
  AND b.ticket_uk_gbp = NEW.ccticketpricechannel_base_gbp1;                                                                                 

UPDATE bd_ma_stylecolorchannelattributes a                                                                                                  
SET                                                                                                                                         
  ccticketpricechannel_base_eur2 = b.ticket_de_eur                                                                                          
FROM ticketpricemapping_l_dependencylookup b                                                                                                
WHERE a.product = NEW.product                                                                                                               
  AND a.location = NEW.location                                                                                                             
  AND b.price_group = 'P2'                                                                                                                  
  AND b.product = (SELECT ancestor3 FROM bd_h_prodstd WHERE id = NEW.product)                                                               
  AND b.ticket_uk_gbp = NEW.ccticketpricechannel_base_gbp2;                                                                                 

UPDATE bd_ma_styleattributes b                                                                                                              
SET sty_ticketpricechannel_base_gbp1 = a.ccticketpricechannel                                                                               
FROM (SELECT ancestor0, MAX(ccticketpricechannel) AS ccticketpricechannel                                                                   
      FROM (SELECT ancestor0, product, COALESCE(ccticketpricechannel_override_gbp1, ccticketpricechannel_base_gbp1) AS ccticketpricechannel 
            FROM bd_ma_stylecolorchannelattributes a, bd_h_prodstd b                                                                        
            WHERE a.product = b.id AND b.ancestor0 = (SELECT ancestor0 FROM bd_h_prodstd WHERE id = NEW.product)                            
           ) x                                                                                                                              
      GROUP BY ancestor0                                                                                                                    
     ) a                                                                                                                                    
WHERE b.product = a.ancestor0;                                                                                                               

UPDATE bd_ma_styleattributes b                                                                                                              
SET sty_ticketpricechannel_base_gbp2 = a.ccticketpricechannel                                                                               
FROM (SELECT ancestor0, MAX(ccticketpricechannel) AS ccticketpricechannel                                                                   
      FROM (SELECT ancestor0, product, COALESCE(ccticketpricechannel_override_gbp2, ccticketpricechannel_base_gbp2) AS ccticketpricechannel 
            FROM bd_ma_stylecolorchannelattributes a, bd_h_prodstd b                                                                        
            WHERE a.product = b.id AND b.ancestor0 = (SELECT ancestor0 FROM bd_h_prodstd WHERE id = NEW.product)                            
           ) x                                                                                                                              
      GROUP BY ancestor0                                                                                                                    
     ) a                                                                                                                                    
WHERE b.product = a.ancestor0;

-- -------------------------------------------------------
-- Update us_price_band and uk_price_band via lookup table
-- Read from table (not NEW) so that base_usd reflects the
-- value already written by the mapping lookup above
-- -------------------------------------------------------
UPDATE bd_ma_stylecolorattributes a
SET
  us_price_band = us_band.price_band,
  uk_price_band = uk_band.price_band
FROM bd_ma_stylecolorchannelattributes src
LEFT JOIN LATERAL (
  SELECT price_band
  FROM bd_l_pricebandlookup
  WHERE currency_identifier = 'US'
    AND product = (SELECT ancestor5 FROM bd_h_prodstd WHERE id = src.product)
    AND COALESCE(src.ccticketpricechannel_override_usd, src.ccticketpricechannel_base_usd)
          BETWEEN ticket_price_min AND ticket_price_max
  LIMIT 1
) us_band ON true
LEFT JOIN LATERAL (
  SELECT price_band
  FROM bd_l_pricebandlookup
  WHERE currency_identifier = 'UK'
    AND product = (SELECT ancestor5 FROM bd_h_prodstd WHERE id = src.product)
    AND COALESCE(src.ccticketpricechannel_override_gbp1, src.ccticketpricechannel_base_gbp1)
          BETWEEN ticket_price_min AND ticket_price_max
  LIMIT 1
) uk_band ON true
WHERE a.product = NEW.product
  AND src.product = NEW.product;

IF EXISTS (                                                                                                                                                                  
    SELECT                                                                                                                                                         
    FROM sync_stylecolorpublishes                                                                                                                                       
    WHERE product = NEW.product                                                                                                                                              
      AND first_published_date IS NOT NULL                                                                                                                                   
)                                                                                                                                                                  
AND (                                                                                                                                                                  
   COALESCE(NEW.ccticketpricechannel_override_aud, 0)  <> COALESCE(OLD.ccticketpricechannel_override_aud, 0)                                                                 
   OR COALESCE(NEW.ccticketpricechannel_override_eur1, 0) <> COALESCE(OLD.ccticketpricechannel_override_eur1, 0)                                                             
   OR COALESCE(NEW.ccticketpricechannel_override_eur2, 0) <> COALESCE(OLD.ccticketpricechannel_override_eur2, 0)                                                             
   OR COALESCE(NEW.ccticketpricechannel_override_gbp1, 0) <> COALESCE(OLD.ccticketpricechannel_override_gbp1, 0)                                                             
   OR COALESCE(NEW.ccticketpricechannel_override_gbp2, 0) <> COALESCE(OLD.ccticketpricechannel_override_gbp2, 0)                                                             
   OR COALESCE(NEW.ccticketpricechannel_override_usd, 0)  <> COALESCE(OLD.ccticketpricechannel_override_usd, 0)                                                              
   OR COALESCE(NEW.ccticketpricechannel_base_aud, 0)      <> COALESCE(OLD.ccticketpricechannel_base_aud, 0)                                                                  
   OR COALESCE(NEW.ccticketpricechannel_base_eur1, 0)     <> COALESCE(OLD.ccticketpricechannel_base_eur1, 0)                                                                 
   OR COALESCE(NEW.ccticketpricechannel_base_eur2, 0)     <> COALESCE(OLD.ccticketpricechannel_base_eur2, 0)                                                                 
   OR COALESCE(NEW.ccticketpricechannel_base_gbp1, 0)     <> COALESCE(OLD.ccticketpricechannel_base_gbp1, 0)                                                                 
   OR COALESCE(NEW.ccticketpricechannel_base_gbp2, 0)     <> COALESCE(OLD.ccticketpricechannel_base_gbp2, 0)                                                                 
   OR COALESCE(NEW.ccticketpricechannel_base_usd, 0)      <> COALESCE(OLD.ccticketpricechannel_base_usd, 0)                                                                  
)                                                                                                                                                                  
THEN                                                                                                                                                               
    INSERT INTO sync_outbound_dataqueue (product, interface, time, location)                                                                                                 
         VALUES (NEW.product, '15.1', 'NA', NEW.location)                                                                                                                    
    ON CONFLICT ON CONSTRAINT UK_sync_outbound_dataqueue                                                                                                                     
      DO UPDATE SET updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP);                                                                                                 
END IF;                                                                                                                                                                
RETURN NEW;                                                                                                                                                               
END; 
$$;


ALTER FUNCTION public.update_ticket_prices() OWNER TO psql;

--
-- TOC entry 1466 (class 1255 OID 136956851)
-- Name: update_trigger_cartparams_ranging(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_trigger_cartparams_ranging() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
drop table if exists temp_new;
drop table if exists temp_old;
drop table if exists cart_params_temp;
create temporary table cart_params_temp AS
select jsessionid, scope_product as product, scope_location as location, initrcptwk, dbt_wk, exitdate 
from cart_params where 
jsessionid = NEW.jsessionid 
and scope_product= NEW.scope_product 
and scope_location = NEW.scope_location
and scope_start = NEW.scope_start
and scope_floorset = NEW.scope_floorset;
create temporary table temp_new as 
select b.product,b.location,a.indx,a.time from bd_ma_dptflrsetattributes a, cart_params_temp b, 
(select value as plan_current from bd_serviceparams where id='plan_current') c,
(select value as plan_end from bd_serviceparams where id='plan_end') d
where 
a.product=b.product
and b.product = NEW.scope_product
and b.location = NEW.scope_location
and slsstart <= least(plan_end,exitdate) and slsend >= greatest(dbt_wk,plan_current)
order by indx;
create temporary table temp_old as 
select * 
from cart_ranging a WHERE 
jsessionid = NEW.jsessionid 
and scope_product = NEW.scope_product 
and scope_location = NEW.scope_location
--and scope_start = NEW.scope_start
;
delete from cart_ranging where 
jsessionid = NEW.jsessionid 
and scope_product = NEW.scope_product 
and scope_location = NEW.scope_location
--and scope_start = NEW.scope_start
;
insert into cart_ranging
(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, indx)
select a.jsessionid,scope_product,scope_location,scope_start,c.time,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, c.indx from 
temp_old a, temp_new c
where a.scope_product=c.product and a.scope_location=c.location
and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||min(indx) from temp_old group by scope_product, scope_location)
and c.indx < a.indx ;
insert into cart_ranging
(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, indx)
select a.jsessionid,scope_product,scope_location,scope_start,c.time,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, c.indx from 
temp_old a, temp_new c
where a.scope_product=c.product and a.scope_location=c.location
and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||max(indx) from temp_old group by scope_product, scope_location)
and c.indx > a.indx ;
insert into cart_ranging
(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, indx)
select a.jsessionid,scope_product,scope_location,scope_start,c.time,strterritory,straccount,strchannel,grade,ssg,flnrange,isfunded, c.indx from 
temp_old a, temp_new c
where a.scope_product=c.product and a.scope_location=c.location
and c.indx = a.indx ;
drop table temp_new;
drop table temp_old;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_trigger_cartparams_ranging() OWNER TO psql;

--
-- TOC entry 1467 (class 1255 OID 136956852)
-- Name: update_week_indxes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_week_indxes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

--
-- TOC entry 1468 (class 1255 OID 136956853)
-- Name: validate_transform_uploads_lifecycleparams(text, text, text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_transform_uploads_lifecycleparams(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;

BEGIN 

--delete from staging_lifecycleparams a where __txid = v__txid and __uid = v__uid and style_id is null and color_id is null;

update staging_lifecycleparams a
set row_indx = b.rowindx
from (select x.*, row_number() over () as rowindx from staging_lifecycleparams x where __txid = v__txid and product is not null) b
where a.__txid = v__txid and a.product = b.product
and a.product is not null;

update staging_lifecycleparams a
set row_indx = 0
where a.__txid = v__txid
and (a.product is null);

DROP TABLE IF EXISTS temp_staging_lifecycleparams_unique_val
;

CREATE TEMPORARY TABLE temp_staging_lifecycleparams_unique_val on commit drop
as 
select 
product,
style_name,
style_description,
option_name,
is_published,
actual_launch_week,
planned_launch_week,
md_week,
exit_week,
pssr,
__status,
__txid,
__uid,
__timestamp,
__error_msg,
row_indx,
row_number() over (partition by product order by product) rn 
from staging_lifecycleparams a
where a.__txid=v__txid
and product is not null
;

CREATE INDEX temp_staging_lifecycleparams_indx ON temp_staging_lifecycleparams_unique_val (product);



-- --------------------------------------
-- PART 1
-- Product Validation
-- --------------------------------------

DROP TABLE IF EXISTS temp_prod_val_reject;
CREATE TEMPORARY TABLE temp_prod_val_reject 
(row_indx int, rn int, __txid text, product text, err_msg text) on commit drop;


--
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and product not in (select name from bd_d_product where levelid='stylecolor')
or product not in (select product from bd_ma_stylecolorattributes)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product not in assortment' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and product not in (select product from bd_ma_stylecolorchannelattributes where record_state = 0)
-- and rn=1
;

/*
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Cannot Edit a Published Option' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and product in (select id from bd_h_prodstd 
                where id in (select product from sync_stylecolorpublishes where is_published = 1
                             union
                             select product from bd_p_dc_adj where dc_publish = 1
                            )
               )
-- and rn=1
;
*/

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, product, 'product cannot be blank' err_msg 
from staging_lifecycleparams 
where __txid=v__txid
and product is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'planned_launch_week cannot be blank' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and planned_launch_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'md_week cannot be blank' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and md_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'exit_week cannot be blank' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and exit_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'pssr cannot be blank' err_msg 
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and pssr is null
-- and rn=1
;


INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, a.product, 'Cannot edit Planned Launch Week in the past' err_msg 
from temp_staging_lifecycleparams_unique_val a, 
(select value as plan_current from bd_serviceparams where id = 'plan_current') b,
(select value as plan_end from bd_serviceparams where id = 'plan_end') c,
(select product, dbt_wk, erlstmkdnwk, exitdate from bd_ma_stylecolorchannelattributes) d
where __txid=v__txid and a.product = d.product
and planned_launch_week is not null and UPPER(planned_launch_week) in (select id from bd_d_time where levelid='week')
and md_week is not null and UPPER(md_week) in (select id from bd_d_time where levelid='week')
and exit_week is not null and UPPER(exit_week) in (select id from bd_d_time where levelid='week')
and ( (planned_launch_week <> dbt_wk and dbt_wk < plan_current) or (planned_launch_week < plan_current and dbt_wk >= plan_current) )
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, a.product, 'Cannot edit MD Week in the past' err_msg 
from temp_staging_lifecycleparams_unique_val a, 
(select value as plan_current from bd_serviceparams where id = 'plan_current') b,
(select value as plan_end from bd_serviceparams where id = 'plan_end') c,
(select product, dbt_wk, erlstmkdnwk, exitdate from bd_ma_stylecolorchannelattributes) d
where __txid=v__txid and a.product = d.product
and planned_launch_week is not null and UPPER(planned_launch_week) in (select id from bd_d_time where levelid='week')
and md_week is not null and UPPER(md_week) in (select id from bd_d_time where levelid='week')
and exit_week is not null and UPPER(exit_week) in (select id from bd_d_time where levelid='week')
and ( (md_week <> erlstmkdnwk and erlstmkdnwk < plan_current) or (md_week < plan_current and erlstmkdnwk >= plan_current) )
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, a.product, 'Cannot edit Exit Week in the past' err_msg 
from temp_staging_lifecycleparams_unique_val a, 
(select value as plan_current from bd_serviceparams where id = 'plan_current') b,
(select value as plan_end from bd_serviceparams where id = 'plan_end') c,
(select product, dbt_wk, erlstmkdnwk, exitdate from bd_ma_stylecolorchannelattributes) d
where __txid=v__txid and a.product = d.product
and planned_launch_week is not null and UPPER(planned_launch_week) in (select id from bd_d_time where levelid='week')
and md_week is not null and UPPER(md_week) in (select id from bd_d_time where levelid='week')
and exit_week is not null and UPPER(exit_week) in (select id from bd_d_time where levelid='week')
and ( (exit_week <> exitdate and exitdate < plan_current) or (exit_week < plan_current and exitdate >= plan_current) )
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Lifecycle not in plan horizon' err_msg 
from temp_staging_lifecycleparams_unique_val a, 
(select value as plan_current from bd_serviceparams where id = 'plan_current') b,
(select value as plan_end from bd_serviceparams where id = 'plan_end') c
where __txid=v__txid
and planned_launch_week is not null and UPPER(planned_launch_week) in (select id from bd_d_time where levelid='week')
and md_week is not null and UPPER(md_week) in (select id from bd_d_time where levelid='week')
and exit_week is not null and UPPER(exit_week) in (select id from bd_d_time where levelid='week')
and
(
  planned_launch_week > plan_end or
  md_week > plan_end or
  exit_week > plan_end
)
-- and rn=1
;


-- --------------------------------------
-- PART 2
-- LIFECYCLE VALIDATION
-- --------------------------------------
DROP TABLE IF EXISTS temp_time_val;
CREATE TEMPORARY TABLE temp_time_val 
(
row_indx int, rn int, __txid text, product text,
planned_launch_week text,
md_week text,
exit_week text,
md_before_dbt int,
exit_before_dbt int,
lifecycle_issue int
) on commit drop;

DROP TABLE IF EXISTS temp_time_val_reject;
CREATE TEMPORARY TABLE temp_time_val_reject
(
row_indx int, rn int, __txid text, product text,
planned_launch_week text,
md_week text,
exit_week text,
md_before_dbt int,
exit_before_dbt int,
lifecycle_issue int
) on commit drop;

INSERT INTO temp_time_val
select 
row_indx
, rn
, __txid
, product 
, UPPER(planned_launch_week) as planned_launch_week
, UPPER(md_week) as md_week
, UPPER(exit_week) as exit_week
, CASE WHEN (UPPER(md_week) <= UPPER(planned_launch_week)) THEN 1 else 0 END as md_before_dbt
, CASE WHEN (UPPER(exit_week) <= UPPER(md_week)) THEN 1 else 0 END as exit_before_dbt
, CASE WHEN (UPPER(md_week) <= UPPER(planned_launch_week)) OR (UPPER(exit_week) <= UPPER(md_week)) THEN 1 else 0 END as lifecycle_issue
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and UPPER(planned_launch_week) in (select id from bd_d_time where levelid='week')
and UPPER(md_week) in (select id from bd_d_time where levelid='week')
and UPPER(exit_week) in (select id from bd_d_time where levelid='week')
;


INSERT INTO temp_time_val_reject
select 
row_indx
, rn
, __txid
, product
, planned_launch_week
, md_week
, exit_week
, CASE WHEN (UPPER(md_week) <= UPPER(planned_launch_week)) THEN 1 else 0 END as md_before_dbt
, CASE WHEN (UPPER(exit_week) <= UPPER(md_week)) THEN 1 else 0 END as exit_before_dbt
, CASE WHEN (UPPER(md_week) <= UPPER(planned_launch_week)) OR (UPPER(exit_week) <= UPPER(md_week)) THEN 1 else 0 END as lifecycle_issue
from temp_staging_lifecycleparams_unique_val 
where __txid=v__txid
and 
(
   planned_launch_week is null or UPPER(planned_launch_week) not in (select id from bd_d_time where levelid='week')
OR md_week is null or UPPER(md_week) not in (select id from bd_d_time where levelid='week')
OR exit_week is null or UPPER(exit_week) not in (select id from bd_d_time where levelid='week')
)
;


create temporary table temp_consolidated_time_val_reject on commit drop
AS 
select row_indx, rn, product, err_msg
from 
(
select row_indx, rn, product, planned_launch_week, 'Invalid Planned Launch Week' as err_msg from temp_time_val_reject where planned_launch_week is not null and UPPER(planned_launch_week) not in (select id from bd_d_time where levelid='week')
UNION ALL 
select row_indx, rn, product, md_week, 'Invalid MD Week' as err_msg from temp_time_val_reject where md_week is not null and UPPER(md_week) not in (select id from bd_d_time where levelid='week')
UNION ALL 
select row_indx, rn, product, exit_week, 'Invalid Exit Week' as err_msg from temp_time_val_reject where exit_week is not null and UPPER(exit_week) not in (select id from bd_d_time where levelid='week')
UNION ALL 
select row_indx, rn, product, exit_week, 'MD Before Planned Launch' as err_msg from temp_time_val where md_before_dbt=1
UNION ALL 
select row_indx, rn, product, exit_week, 'Exit Before MD' as err_msg from temp_time_val where exit_before_dbt=1
)x;

-- --------------------------------------
-- PART 3
-- PARAM DATA VALIDATION
-- --------------------------------------




DROP TABLE IF EXISTS temp_all_datatype_val_reject;
CREATE TEMPORARY TABLE temp_all_datatype_val_reject  on commit drop
AS 
SELECT row_indx, rn, product, err_msg
FROM 
(
select row_indx, rn, product, pssr, 'Invalid pssr' as err_msg from temp_staging_lifecycleparams_unique_val where (pssr is not null and pssr not in (select attributekey from bd_v_memberbasedvalidvalues where attributeid = 'slsrnk' union all select '1.0' union all select '2.0' union all select '3.0' union all select '4.0' union all select '5.0'))
) x

;

-- --------------------------------------
-- Combine Everything
-- --------------------------------------

create temporary table temp_product_val_reject on commit drop
AS 
select row_indx, rn, product, err_msg
from 
temp_prod_val_reject
;

create temporary table temp_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_consolidated_time_val_reject
        UNION ALL 
        select row_indx, rn, product, err_msg from temp_prod_val_reject
        UNION ALL
        select row_indx, rn, product, err_msg from temp_all_datatype_val_reject
    ) x 
) y group by row_indx, rn, product
;

DROP TABLE IF EXISTS temp_final_good_kids;
CREATE TEMPORARY TABLE temp_final_good_kids 
(
product                         text,
style_name                      text,
style_description               text,
option_name                     text,
is_published                    text,
actual_launch_week              text,
planned_launch_week             text,
md_week                         text,
exit_week                       text,
pssr                            text
, __status text
, __txid text
, __uid text
, __timestamp timestamp without time zone
, rn integer
, row_indx integer
) on commit drop;

insert into temp_final_good_kids
select 
product,
style_name,
style_description,
option_name,
is_published,
actual_launch_week,
planned_launch_week,
md_week,
exit_week,
pssr
, __status::text
, __txid::text
, __uid::text
, __timestamp
, ROW_NUMBER() OVER (PARTITION BY product) as rn
, row_indx
FROM 
    temp_staging_lifecycleparams_unique_val 
where 
    (row_indx) not in (select row_indx from temp_final_all_reject)
;

create temporary table temp_final_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) as error_msg from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_prod_val_reject
        UNION ALL 
        select row_indx, rn, product, err_msg from temp_consolidated_time_val_reject
        UNION ALL 
        select row_indx, rn, product, err_msg from temp_all_datatype_val_reject
        UNION ALL
        select row_indx, rn, product, 'Duplicate Record' as err_msg from temp_final_good_kids where rn > 1
    ) x 
) y group by row_indx, rn, product
;


insert into shadow_lifecycleparams
(
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    actual_launch_week,
    planned_launch_week,
    md_week,
    exit_week,
    pssr,
    __status,
    __txid,
    __uid,
    __timestamp,
    row_indx
)
SELECT 
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    actual_launch_week,
    planned_launch_week,
    md_week,
    exit_week,
    pssr,
    'pending_final_move',
    __txid,
    __uid,
    __timestamp,
    row_indx
from temp_final_good_kids
where rn=1
;


update staging_lifecycleparams a
set __status = 'Validated' from shadow_lifecycleparams b where a.row_indx=b.row_indx and a.product=b.product;

update staging_lifecycleparams a
set __status = 'Rejected', __error_msg =  b.error_msg from temp_final_final_all_reject b where a.row_indx=b.row_indx;


create temporary table temp_upload_statistics on commit drop
AS
select 
-- template_id,
__txid,
__uid,
max(__timestamp) as __timestamp,
count(*) as records_uploaded,
sum(CASE when __status='Validated' THEN 1 ELSE 0 END) as validated_count,
sum(CASE when __status='Rejected' THEN 1 ELSE 0 END) as rejected_count
from staging_lifecycleparams 
where __uid = v__uid and __txid = v__txid
group by 
__txid,
__uid
;

delete from upload_statistics where __txid = v__txid;

insert into upload_statistics 
(
-- template_id,
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
final_status
)
SELECT 
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
'Pending Final Move'
from 
temp_upload_statistics;


RAISE NOTICE 'VALIDATION SUCCESSFUL';

-- select validate_transform_uploads ('test',v__txid);

OPEN stats FOR
SELECT 
records_uploaded,
validated_count,
rejected_count
FROM temp_upload_statistics;

OPEN messages FOR
select row_indx as rowid, (product || __status || __error_msg) as message, *
from staging_lifecycleparams where __status='Rejected' and __txid=v__txid;


RETURN;
END;
$$;


ALTER FUNCTION public.validate_transform_uploads_lifecycleparams(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) OWNER TO psql;

--
-- TOC entry 1469 (class 1255 OID 136956855)
-- Name: validate_transform_uploads_optionattributes(text, text, text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_transform_uploads_optionattributes(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;

BEGIN 

--delete from staging_optionattributes a where __txid = v__txid and __uid = v__uid and style_id is null and color_id is null;

update staging_optionattributes a
set row_indx = b.rowindx
from (select x.*, row_number() over () as rowindx from staging_optionattributes x where __txid = v__txid and product is not null) b
where a.__txid = v__txid and a.product = b.product
and a.product is not null;

update staging_optionattributes a
set row_indx = 0
where a.__txid = v__txid
and (a.product is null);

DROP TABLE IF EXISTS temp_staging_optionattributes_unique_val
;

CREATE TEMPORARY TABLE temp_staging_optionattributes_unique_val on commit drop
as 
select 
product,
style_name,
style_description,
option_name,
is_published,
price_banding_option,
archetype,
design_theme,
design_sub_theme,
detail,
fabric_type,
pattern,
pattern_type,
print_name,
product_pyramid_option,
theme,
weight_option,
__status,
__txid,
__uid,
__timestamp,
__error_msg,
row_indx,
row_number() over (partition by product order by product) rn 
from staging_optionattributes a
where a.__txid=v__txid
and product is not null
;

CREATE INDEX temp_staging_optionattributes_indx ON temp_staging_optionattributes_unique_val (product);



-- --------------------------------------
-- PART 1
-- Product Validation
-- --------------------------------------

DROP TABLE IF EXISTS temp_prod_val_reject;
CREATE TEMPORARY TABLE temp_prod_val_reject 
(row_indx int, rn int, __txid text, product text, err_msg text) on commit drop;


--
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and product not in (select name from bd_d_product where levelid='stylecolor')
or product not in (select product from bd_ma_stylecolorattributes)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product not in assortment' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and product not in (select product from bd_ma_stylecolorchannelattributes where record_state = 0)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Published Option - need to update in PIM' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and product in (select id from bd_h_prodstd 
                where id in (select product from sync_stylecolorpublishes where is_published = 1
                             union
                             select product from bd_p_dc_adj where dc_publish = 1
                            )
               )
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, product, 'product cannot be blank' err_msg 
from staging_optionattributes 
where __txid=v__txid
and product is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid price_banding_option' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((price_banding_option) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_price_banding_latest'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and price_banding_option is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'price_banding_option cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (price_banding_option is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid archetype' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((archetype) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_archetype'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and archetype is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'archetype cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (archetype is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid design_theme' err_msg 
from temp_staging_optionattributes_unique_val a
where __txid=v__txid
and ((design_theme) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_theme_latest'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and design_theme is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'design_theme cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val a
where __txid=v__txid
and (design_theme is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid design_sub_theme' err_msg 
from temp_staging_optionattributes_unique_val a
where __txid=v__txid 
--and design_theme not in ('Unknown', 'Not Applicable')
--and design_sub_theme not in ('Unknown', 'Not Applicable')
and (not exists (select 1 from bd_l_dependencylookup b where lookup_id = 'theme' and target_id = 'sub_theme' and a.design_theme = b.lookup_value)
and design_sub_theme is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'design_sub_theme cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val a
where __txid=v__txid 
--and design_theme not in ('Unknown', 'Not Applicable')
--and design_sub_theme not in ('Unknown', 'Not Applicable')
and design_sub_theme is null
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid detail' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((detail) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_applied_detail'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and detail is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'detail cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (detail is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid fabric_type' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((fabric_type) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_texture'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and fabric_type is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'fabric_type cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (fabric_type is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid pattern' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((pattern) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_pattern_new'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and pattern is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'pattern cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (pattern is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid pattern_type' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((pattern_type) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_pattern'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and pattern_type is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'pattern_type cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (pattern_type is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product_pyramid_option' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((product_pyramid_option) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_classification_latest'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and product_pyramid_option is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product_pyramid_option cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (product_pyramid_option is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid theme' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((theme) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_collection'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and theme is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'theme cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (theme is null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid weight_option' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and ((weight_option) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'cc_weight'
/*
Removing below code as Boden business did not want Unknown/NotApplicable to be Valid values allowed
union all
select 'Unknown'
union all
select 'Not Applicable'
*/
)
and weight_option is not null)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'weight_option cannot be blank' err_msg 
from temp_staging_optionattributes_unique_val 
where __txid=v__txid
and (weight_option is null)
;


-- --------------------------------------
-- Combine Everything
-- --------------------------------------

create temporary table temp_product_val_reject on commit drop
AS 
select row_indx, rn, product, err_msg
from 
temp_prod_val_reject
;

create temporary table temp_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) from 
(
    select row_indx, rn, product, err_msg from temp_prod_val_reject
) y group by row_indx, rn, product
;

DROP TABLE IF EXISTS temp_final_good_kids;
CREATE TEMPORARY TABLE temp_final_good_kids 
(
product                         text,
style_name                      text,
style_description               text,
option_name                     text,
is_published                    text,
price_banding_option            text,
archetype                        text,
design_theme                    text,
design_sub_theme                text,
detail                          text,
fabric_type                     text,
pattern                         text,
pattern_type                    text,
print_name                      text,
product_pyramid_option          text,
theme                           text,
weight_option                   text
, __status text
, __txid text
, __uid text
, __timestamp timestamp without time zone
, rn integer
, row_indx integer
) on commit drop;

insert into temp_final_good_kids
select 
product,
style_name,
style_description,
option_name,
is_published,
price_banding_option,
archetype,
design_theme,
design_sub_theme,
detail,
fabric_type,
pattern,
pattern_type,
print_name,
product_pyramid_option,
theme,
weight_option
, __status::text
, __txid::text
, __uid::text
, __timestamp
, ROW_NUMBER() OVER (PARTITION BY product) as rn
, row_indx
FROM 
    temp_staging_optionattributes_unique_val 
where 
    (row_indx) not in (select row_indx from temp_final_all_reject)
;

create temporary table temp_final_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) as error_msg from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_prod_val_reject
        UNION ALL 
        select row_indx, rn, product, 'Duplicate Record' as err_msg from temp_final_good_kids where rn > 1
    ) x 
) y group by row_indx, rn, product
;


insert into shadow_optionattributes
(
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    price_banding_option,
    archetype,
    design_theme,
    design_sub_theme,
    detail,
    fabric_type,
    pattern,
    pattern_type,
    print_name,
    product_pyramid_option,
    theme,
    weight_option,
    __status,
    __txid,
    __uid,
    __timestamp,
    row_indx
)
SELECT 
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    price_banding_option,
    archetype,
    design_theme,
    design_sub_theme,
    detail,
    fabric_type,
    pattern,
    pattern_type,
    print_name,
    product_pyramid_option,
    theme,
    weight_option,
    'pending_final_move',
    __txid,
    __uid,
    __timestamp,
    row_indx
from temp_final_good_kids
where rn=1
;


update staging_optionattributes a
set __status = 'Validated' from shadow_optionattributes b where a.row_indx=b.row_indx and a.product=b.product;

update staging_optionattributes a
set __status = 'Rejected', __error_msg =  b.error_msg from temp_final_final_all_reject b where a.row_indx=b.row_indx;


create temporary table temp_upload_statistics on commit drop
AS
select 
-- template_id,
__txid,
__uid,
max(__timestamp) as __timestamp,
count(*) as records_uploaded,
sum(CASE when __status='Validated' THEN 1 ELSE 0 END) as validated_count,
sum(CASE when __status='Rejected' THEN 1 ELSE 0 END) as rejected_count
from staging_optionattributes 
where __uid = v__uid and __txid = v__txid
group by 
__txid,
__uid
;

delete from upload_statistics where __txid = v__txid;

insert into upload_statistics 
(
-- template_id,
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
final_status
)
SELECT 
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
'Pending Final Move'
from 
temp_upload_statistics;


RAISE NOTICE 'VALIDATION SUCCESSFUL';

-- select validate_transform_uploads ('test',v__txid);

OPEN stats FOR
SELECT 
records_uploaded,
validated_count,
rejected_count
FROM temp_upload_statistics;

OPEN messages FOR
select row_indx as rowid, (product || __status || __error_msg) as message, *
from staging_optionattributes where __status='Rejected' and __txid=v__txid;


RETURN;
END;
$$;


ALTER FUNCTION public.validate_transform_uploads_optionattributes(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) OWNER TO psql;

--
-- TOC entry 1470 (class 1255 OID 136956857)
-- Name: validate_transform_uploads_price(text, text, text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_transform_uploads_price(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) RETURNS record
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;

BEGIN 

--delete from staging_price a where __txid = v__txid and __uid = v__uid and style_id is null and color_id is null;

update staging_price a
set row_indx = b.rowindx
from (select x.*, row_number() over () as rowindx from staging_price x where __txid = v__txid and product is not null) b
where a.__txid = v__txid and a.product = b.product
and a.product is not null;

update staging_price a
set row_indx = 0
where a.__txid = v__txid
and (a.product is null);

DROP TABLE IF EXISTS temp_staging_price_unique_val
;

CREATE TEMPORARY TABLE temp_staging_price_unique_val on commit drop
as 
select 
product,
style_name,
style_description,
option_name,
is_published,
md_week,
case when fsp_gbp_ticket_1_override = 'null' then null else fsp_gbp_ticket_1_override end as fsp_gbp_ticket_1_override,
case when fsp_gbp_ticket_2_override = 'null' then null else fsp_gbp_ticket_2_override end as fsp_gbp_ticket_2_override,
case when eur_ticket_1_override = 'null' then null else eur_ticket_1_override end as eur_ticket_1_override,
case when eur_ticket_2_override = 'null' then null else eur_ticket_2_override end as eur_ticket_2_override,
case when usd_ticket_override = 'null' then null else usd_ticket_override end as usd_ticket_override,
case when aud_ticket_override = 'null' then null else aud_ticket_override end as aud_ticket_override,
fsp_gbp_ticket_1,
fsp_gbp_ticket_2,
eur_ticket_1,
eur_ticket_2,
usd_ticket,
aud_ticket,
__status,
__txid,
__uid,
__timestamp,
__error_msg,
row_indx,
row_number() over (partition by product order by product) rn 
from staging_price a
where a.__txid=v__txid
and product is not null
;

CREATE INDEX temp_staging_price_indx ON temp_staging_price_unique_val (product);



-- --------------------------------------
-- PART 1
-- Product Validation
-- --------------------------------------

DROP TABLE IF EXISTS temp_prod_val_reject;
CREATE TEMPORARY TABLE temp_prod_val_reject 
(row_indx int, rn int, __txid text, product text, err_msg text) on commit drop;


--
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and product not in (select name from bd_d_product where levelid='stylecolor')
or product not in (select product from bd_ma_stylecolorattributes)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product not in assortment' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and product not in (select product from bd_ma_stylecolorchannelattributes where record_state = 0)
-- and rn=1
;

/*
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Cannot Edit a Published Option' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and product in (select id from bd_h_prodstd 
                where id in (select product from sync_stylecolorpublishes where is_published = 1
                             union
                             select product from bd_p_dc_adj where dc_publish = 1
                            )
               )
-- and rn=1
;
*/

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, product, 'product cannot be blank' err_msg 
from staging_price 
where __txid=v__txid
and product is null
-- and rn=1
;


INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, a.product, 'Cannot edit Ticket price when Current Week < 5 weeks from MD Week' err_msg 
from temp_staging_price_unique_val a, 
bd_ma_stylecolorchannelattributes b,
bd_d_time c,
bd_d_time d
where __txid=v__txid and a.product = b.product
and b.erlstmkdnwk = c.id and b.plan_current = d.id
and c.indx - d.indx < 5
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'fsp_gbp_ticket_1_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (fsp_gbp_ticket_1_override is not null and (regexp_replace(fsp_gbp_ticket_1_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (fsp_gbp_ticket_1_override::real = 0 or fsp_gbp_ticket_1_override::real > 1000)) 
OR 
    (fsp_gbp_ticket_1_override is null)
)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'fsp_gbp_ticket_2_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (fsp_gbp_ticket_2_override is not null and (regexp_replace(fsp_gbp_ticket_2_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (fsp_gbp_ticket_2_override::real = 0 or fsp_gbp_ticket_2_override::real > 1000)) 
OR 
    (fsp_gbp_ticket_2_override is null)
)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'eur_ticket_1_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (eur_ticket_1_override is not null and (regexp_replace(eur_ticket_1_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (eur_ticket_1_override::real = 0 or eur_ticket_1_override::real > 1000)) 
OR 
    (eur_ticket_1_override is null)
)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'eur_ticket_2_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (eur_ticket_2_override is not null and (regexp_replace(eur_ticket_2_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (eur_ticket_2_override::real = 0 or eur_ticket_2_override::real > 1000)) 
OR 
    (eur_ticket_2_override is null)
)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'usd_ticket_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (usd_ticket_override is not null and (regexp_replace(usd_ticket_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (usd_ticket_override::real = 0 or usd_ticket_override::real > 1000)) 
OR 
    (usd_ticket_override is null)
)
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'aud_ticket_override cannot be blank or 0 or >1000' err_msg 
from temp_staging_price_unique_val 
where __txid=v__txid
and 
(
    (aud_ticket_override is not null and (regexp_replace(aud_ticket_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$')
and (aud_ticket_override::real = 0 or aud_ticket_override::real > 1000)) 
OR 
    (aud_ticket_override is null)
)
-- and rn=1
;


-- --------------------------------------
-- PART 3
-- PARAM DATA VALIDATION
-- --------------------------------------

DROP TABLE IF EXISTS temp_all_datatype_val_reject;
CREATE TEMPORARY TABLE temp_all_datatype_val_reject  on commit drop
AS 
SELECT row_indx, rn, product, err_msg
FROM 
(
select row_indx, rn, product, fsp_gbp_ticket_1_override, 'Invalid: fsp_gbp_ticket_1_override' as err_msg from temp_staging_price_unique_val where ( fsp_gbp_ticket_1_override is not null and not (regexp_replace(fsp_gbp_ticket_1_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, product, fsp_gbp_ticket_2_override, 'Invalid: fsp_gbp_ticket_2_override' as err_msg from temp_staging_price_unique_val where ( fsp_gbp_ticket_2_override is not null and not (regexp_replace(fsp_gbp_ticket_2_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, product, eur_ticket_1_override, 'Invalid: eur_ticket_1_override' as err_msg from temp_staging_price_unique_val where ( eur_ticket_1_override is not null and not (regexp_replace(eur_ticket_1_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, product, eur_ticket_2_override, 'Invalid: eur_ticket_2_override' as err_msg from temp_staging_price_unique_val where ( eur_ticket_2_override is not null and not (regexp_replace(eur_ticket_2_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, product, usd_ticket_override, 'Invalid: usd_ticket_override' as err_msg from temp_staging_price_unique_val where ( usd_ticket_override is not null and not (regexp_replace(usd_ticket_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, product, aud_ticket_override, 'Invalid: aud_ticket_override' as err_msg from temp_staging_price_unique_val where ( aud_ticket_override is not null and not (regexp_replace(aud_ticket_override,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
) x

;

-- --------------------------------------
-- Combine Everything
-- --------------------------------------

create temporary table temp_product_val_reject on commit drop
AS 
select row_indx, rn, product, err_msg
from 
temp_prod_val_reject
;

create temporary table temp_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_all_datatype_val_reject
        UNION ALL 
        select row_indx, rn, product, err_msg from temp_prod_val_reject
    ) x 
) y group by row_indx, rn, product
;

DROP TABLE IF EXISTS temp_final_good_kids;
CREATE TEMPORARY TABLE temp_final_good_kids 
(
product                         text,
style_name                      text,
style_description               text,
option_name                     text,
is_published                    text,
md_week                         text,
fsp_gbp_ticket_1_override       text,
fsp_gbp_ticket_2_override       text,
eur_ticket_1_override           text,
eur_ticket_2_override           text,
usd_ticket_override             text,
aud_ticket_override             text,
fsp_gbp_ticket_1                text,
fsp_gbp_ticket_2                text,
eur_ticket_1                    text,
eur_ticket_2                    text,
usd_ticket                      text,
aud_ticket                      text
, __status text
, __txid text
, __uid text
, __timestamp timestamp without time zone
, rn integer
, row_indx integer
) on commit drop;

insert into temp_final_good_kids
select 
product,
style_name,
style_description,
option_name,
is_published,
md_week,
fsp_gbp_ticket_1_override,
fsp_gbp_ticket_2_override,
eur_ticket_1_override,
eur_ticket_2_override,
usd_ticket_override,
aud_ticket_override,
fsp_gbp_ticket_1,
fsp_gbp_ticket_2,
eur_ticket_1,
eur_ticket_2,
usd_ticket,
aud_ticket
, __status::text
, __txid::text
, __uid::text
, __timestamp
, ROW_NUMBER() OVER (PARTITION BY product) as rn
, row_indx
FROM 
    temp_staging_price_unique_val 
where 
    (row_indx) not in (select row_indx from temp_final_all_reject)
;

create temporary table temp_final_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) as error_msg from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_prod_val_reject
        UNION ALL 
        select row_indx, rn, product, err_msg from temp_all_datatype_val_reject
        UNION ALL
        select row_indx, rn, product, 'Duplicate Record' as err_msg from temp_final_good_kids where rn > 1
    ) x 
) y group by row_indx, rn, product
;


insert into shadow_price
(
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    md_week,
    fsp_gbp_ticket_1_override,
    fsp_gbp_ticket_2_override,
    eur_ticket_1_override,
    eur_ticket_2_override,
    usd_ticket_override,
    aud_ticket_override,
    fsp_gbp_ticket_1,
    fsp_gbp_ticket_2,
    eur_ticket_1,
    eur_ticket_2,
    usd_ticket,
    aud_ticket,
    __status,
    __txid,
    __uid,
    __timestamp,
    row_indx
)
SELECT 
    product,
    style_name,
    style_description,
    option_name,
    is_published,
    md_week,
    fsp_gbp_ticket_1_override,
    fsp_gbp_ticket_2_override,
    eur_ticket_1_override,
    eur_ticket_2_override,
    usd_ticket_override,
    aud_ticket_override,
    fsp_gbp_ticket_1,
    fsp_gbp_ticket_2,
    eur_ticket_1,
    eur_ticket_2,
    usd_ticket,
    aud_ticket,
    'pending_final_move',
    __txid,
    __uid,
    __timestamp,
    row_indx
from temp_final_good_kids
where rn=1
;


update staging_price a
set __status = 'Validated' from shadow_price b where a.row_indx=b.row_indx and a.product=b.product;

update staging_price a
set __status = 'Rejected', __error_msg =  b.error_msg from temp_final_final_all_reject b where a.row_indx=b.row_indx;


create temporary table temp_upload_statistics on commit drop
AS
select 
-- template_id,
__txid,
__uid,
max(__timestamp) as __timestamp,
count(*) as records_uploaded,
sum(CASE when __status='Validated' THEN 1 ELSE 0 END) as validated_count,
sum(CASE when __status='Rejected' THEN 1 ELSE 0 END) as rejected_count
from staging_price 
where __uid = v__uid and __txid = v__txid
group by 
__txid,
__uid
;

delete from upload_statistics where __txid = v__txid;

insert into upload_statistics 
(
-- template_id,
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
final_status
)
SELECT 
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
'Pending Final Move'
from 
temp_upload_statistics;


RAISE NOTICE 'VALIDATION SUCCESSFUL';

-- select validate_transform_uploads ('test',v__txid);

OPEN stats FOR
SELECT 
records_uploaded,
validated_count,
rejected_count
FROM temp_upload_statistics;

OPEN messages FOR
select row_indx as rowid, (product || __status || __error_msg) as message, *
from staging_price where __status='Rejected' and __txid=v__txid;


RETURN;
END;
$_$;


ALTER FUNCTION public.validate_transform_uploads_price(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) OWNER TO psql;

--
-- TOC entry 1471 (class 1255 OID 136956859)
-- Name: validate_transform_uploads_styleattributes(text, text, text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_transform_uploads_styleattributes(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;

BEGIN 

--delete from staging_styleattributes a where __txid = v__txid and __uid = v__uid and style_id is null and color_id is null;

update staging_styleattributes a
set row_indx = b.rowindx
from (select x.*, row_number() over () as rowindx from staging_styleattributes x where __txid = v__txid and product is not null) b
where a.__txid = v__txid and a.product = b.product
and a.product is not null;

update staging_styleattributes a
set row_indx = 0
where a.__txid = v__txid
and (a.product is null);

DROP TABLE IF EXISTS temp_staging_styleattributes_unique_val
;

CREATE TEMPORARY TABLE temp_staging_styleattributes_unique_val on commit drop
as 
select 
product,
style_name,
style_description,
is_published,
age_style,
building_blocks,
clothing_fit,
end_use,
footwear_heel_height,
footwear_type,
gender,
length_style,
neck_shape,
shape_name_package,
product_pyramid_style,
rise,
skirt_or_leg_shape,
sleeve_length,
sleeve_shape,
__status,
__txid,
__uid,
__timestamp,
__error_msg,
row_indx,
row_number() over (partition by product order by product) rn 
from staging_styleattributes a
where a.__txid=v__txid
and product is not null
;

CREATE INDEX temp_staging_styleattributes_indx ON temp_staging_styleattributes_unique_val (product);



-- --------------------------------------
-- PART 1
-- Product Validation
-- --------------------------------------

DROP TABLE IF EXISTS temp_prod_val_reject;
CREATE TEMPORARY TABLE temp_prod_val_reject 
(row_indx int, rn int, __txid text, product text, err_msg text) on commit drop;


--
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and product not in (select name from bd_d_product where levelid='style')
or product not in (select product from bd_ma_styleattributes)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product not in assortment' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and product not in (select distinct ancestor0 from bd_h_prodstd where id in (select product from bd_ma_stylecolorchannelattributes where record_state = 0))
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Published Style - need to update in PIM' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and product in (select ancestor0 from bd_h_prodstd 
                where id in (select product from sync_stylecolorpublishes where is_published = 1
                             union
                             select product from bd_p_dc_adj where dc_publish = 1
                            )
               )
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, product, 'product cannot be blank' err_msg 
from staging_styleattributes 
where __txid=v__txid
and product is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid age_style' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((age_style) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_age_style')
and age_style is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'age_style cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and age_style is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid building_blocks' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((building_blocks) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_packages')
and building_blocks is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'building_blocks cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and building_blocks is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid clothing_fit' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((clothing_fit) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_fit_style')
and clothing_fit is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'clothing_fit cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and clothing_fit is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid end_use' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((end_use) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_end_use')
and end_use is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'end_use cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (end_use is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid footwear_heel_height' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((footwear_heel_height) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_heel_height')
and footwear_heel_height is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'footwear_heel_height cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (footwear_heel_height is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid footwear_type' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((footwear_type) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_footwear_type')
and footwear_type is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'footwear_type cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (footwear_type is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid gender' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((gender) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_gender_style')
and gender is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'gender cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (gender is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid length_style' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((length_style) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_dress_skirt_length')
and length_style is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'length_style cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (length_style is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid neck_shape' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((neck_shape) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_neck_detail')
and neck_shape is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'neck_shape cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (neck_shape is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid shape_name_package' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((shape_name_package) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_price_band_style')
and shape_name_package is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'shape_name_package cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (shape_name_package is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid product_pyramid_style' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((product_pyramid_style) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_classification_latest')
and product_pyramid_style is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'product_pyramid_style cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (product_pyramid_style is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid rise' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((rise) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_rise')
and rise is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'rise cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (rise is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid skirt_or_leg_shape' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((skirt_or_leg_shape) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_skirt_shape')
and skirt_or_leg_shape is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'skirt_or_leg_shape cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (skirt_or_leg_shape is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid sleeve_length' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((sleeve_length) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_sleeve_length')
and sleeve_length is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'sleeve_length cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (sleeve_length is null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'Invalid sleeve_shape' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and ((sleeve_shape) not in 
(select distinct attributekey from bd_v_memberbasedvalidvalues where attributeid = 'sty_sleeve_shape')
and sleeve_shape is not null)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, product, 'sleeve_shape cannot be blank' err_msg 
from temp_staging_styleattributes_unique_val 
where __txid=v__txid
and (sleeve_shape is null)
-- and rn=1
;

-- --------------------------------------
-- Combine Everything
-- --------------------------------------

create temporary table temp_product_val_reject on commit drop
AS 
select row_indx, rn, product, err_msg
from 
temp_prod_val_reject
;

create temporary table temp_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) from 
(
    select row_indx, rn, product, err_msg from temp_prod_val_reject
) y group by row_indx, rn, product
;

DROP TABLE IF EXISTS temp_final_good_kids;
CREATE TEMPORARY TABLE temp_final_good_kids 
(
product                         text,
style_name                           text,
style_description               text,
is_published                    text,
age_style                       text,
building_blocks                 text,
clothing_fit                    text,
end_use                         text,
footwear_heel_height            text,
footwear_type                   text,
gender                          text,
length_style                    text,
neck_shape                      text,
shape_name_package             text,
product_pyramid_style           text,
rise                            text,
skirt_or_leg_shape              text,
sleeve_length                   text,
sleeve_shape                    text
, __status text
, __txid text
, __uid text
, __timestamp timestamp without time zone
, rn integer
, row_indx integer
) on commit drop;

insert into temp_final_good_kids
select 
product,
style_name,
style_description,
is_published,
age_style,
building_blocks,
clothing_fit,
end_use,
footwear_heel_height,
footwear_type,
gender,
length_style,
neck_shape,
shape_name_package,
product_pyramid_style,
rise,
skirt_or_leg_shape,
sleeve_length,
sleeve_shape
, __status::text
, __txid::text
, __uid::text
, __timestamp
, ROW_NUMBER() OVER (PARTITION BY product) as rn
, row_indx
FROM 
    temp_staging_styleattributes_unique_val 
where 
    (row_indx) not in (select row_indx from temp_final_all_reject)
;

create temporary table temp_final_final_all_reject on commit drop
AS 
select row_indx, rn, product, ARRAY_AGG(err_msg) as error_msg from 
(
    select distinct row_indx, rn, product, err_msg from 
    (
        select row_indx, rn, product, err_msg from temp_prod_val_reject
        UNION ALL 
        select row_indx, rn, product, 'Duplicate Record' as err_msg from temp_final_good_kids where rn > 1
    ) x 
) y group by row_indx, rn, product
;


insert into shadow_styleattributes
(
    product,
    style_name,
    style_description,
    is_published,
    age_style,
    building_blocks,
    clothing_fit,
    end_use,
    footwear_heel_height,
    footwear_type,
    gender,
    length_style,
    neck_shape,
    price_banding_style,
    product_pyramid_style,
    rise,
    skirt_or_leg_shape,
    sleeve_length,
    sleeve_shape,
    __status,
    __txid,
    __uid,
    __timestamp,
    row_indx
)
SELECT 
    product,
    style_name,
    style_description,
    is_published,
    age_style,
    building_blocks,
    clothing_fit,
    end_use,
    footwear_heel_height,
    footwear_type,
    gender,
    length_style,
    neck_shape,
    shape_name_package,
    product_pyramid_style,
    rise,
    skirt_or_leg_shape,
    sleeve_length,
    sleeve_shape,
    'pending_final_move',
    __txid,
    __uid,
    __timestamp,
    row_indx
from temp_final_good_kids
where rn=1
;


update staging_styleattributes a
set __status = 'Validated' from shadow_styleattributes b where a.row_indx=b.row_indx and a.product=b.product;

update staging_styleattributes a
set __status = 'Rejected', __error_msg =  b.error_msg from temp_final_final_all_reject b where a.row_indx=b.row_indx;


create temporary table temp_upload_statistics on commit drop
AS
select 
-- template_id,
__txid,
__uid,
max(__timestamp) as __timestamp,
count(*) as records_uploaded,
sum(CASE when __status='Validated' THEN 1 ELSE 0 END) as validated_count,
sum(CASE when __status='Rejected' THEN 1 ELSE 0 END) as rejected_count
from staging_styleattributes 
where __uid = v__uid and __txid = v__txid
group by 
__txid,
__uid
;

delete from upload_statistics where __txid = v__txid;

insert into upload_statistics 
(
-- template_id,
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
final_status
)
SELECT 
__txid,
__uid,
__timestamp,
records_uploaded,
validated_count,
rejected_count,
'Pending Final Move'
from 
temp_upload_statistics;


RAISE NOTICE 'VALIDATION SUCCESSFUL';

-- select validate_transform_uploads ('test',v__txid);

OPEN stats FOR
SELECT 
records_uploaded,
validated_count,
rejected_count
FROM temp_upload_statistics;

OPEN messages FOR
select row_indx as rowid, (product || __status || __error_msg) as message, *
from staging_styleattributes where __status='Rejected' and __txid=v__txid;


RETURN;
END;
$$;


ALTER FUNCTION public.validate_transform_uploads_styleattributes(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) OWNER TO psql;

--
-- TOC entry 3202 (class 1255 OID 136956861)
-- Name: median(numeric); Type: AGGREGATE; Schema: public; Owner: psql
--

CREATE AGGREGATE public.median(numeric) (
    SFUNC = array_append,
    STYPE = numeric[],
    INITCOND = '{}',
    FINALFUNC = _final_median
);


ALTER AGGREGATE public.median(numeric) OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 1027 (class 1259 OID 136956862)
-- Name: bd_d_time_20200625; Type: TABLE; Schema: backups; Owner: psql
--

CREATE TABLE backups.bd_d_time_20200625 (
    id text,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE backups.bd_d_time_20200625 OWNER TO psql;

--
-- TOC entry 1028 (class 1259 OID 136956867)
-- Name: bd_h_timeflrset_20200625; Type: TABLE; Schema: backups; Owner: psql
--

CREATE TABLE backups.bd_h_timeflrset_20200625 (
    id text,
    ancestor0 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE backups.bd_h_timeflrset_20200625 OWNER TO psql;

--
-- TOC entry 1029 (class 1259 OID 136956872)
-- Name: bd_h_timestd_20200625; Type: TABLE; Schema: backups; Owner: psql
--

CREATE TABLE backups.bd_h_timestd_20200625 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE backups.bd_h_timestd_20200625 OWNER TO psql;

--
-- TOC entry 1030 (class 1259 OID 136956877)
-- Name: bd_ma_weekattributes_20200625; Type: TABLE; Schema: backups; Owner: psql
--

CREATE TABLE backups.bd_ma_weekattributes_20200625 (
    "time" text,
    start_date text,
    end_date text,
    eventdate date
);


ALTER TABLE backups.bd_ma_weekattributes_20200625 OWNER TO psql;

--
-- TOC entry 1031 (class 1259 OID 136956882)
-- Name: bi_assortmentbyfloorset_staging; Type: TABLE; Schema: debug; Owner: psql
--

CREATE TABLE debug.bi_assortmentbyfloorset_staging (
    run_id integer,
    row_id integer,
    stylecolor_id text,
    stylecolor_name text,
    stylecolor_description text,
    floorset text,
    channel text,
    color_name text,
    pricing_tier text,
    editable_plan_cost real,
    wac real,
    status text,
    editable_preseason_sales_rating real,
    initial_rec_week text,
    editable_debut_week text,
    relaunch_week text,
    editable_markdown_week text,
    editable_exit_week text,
    last_dc_order_week text,
    editable_markdown_strategy text,
    editable_debut_floorset text,
    store_count_average integer,
    editable_store_vol_tier_dept text[],
    editable_climate text[],
    editable_capacity_mens text[],
    editable_capacity_womens text[],
    editable_ssg integer,
    editable_is_funded text,
    ticket_price real,
    unconstrained_sales_u integer,
    sales_u_override integer,
    final_sales_u integer,
    final_aps_u real,
    final_sales_r real,
    final_sales_c real,
    system_rec_u integer,
    rec_u_override integer,
    on_order_u integer,
    on_order_u_override integer,
    final_rec_u integer,
    dc_receipt_c real,
    boh_u integer,
    eoh_u integer,
    total_stock_to_sales real,
    margin_r real,
    margin_percent real
);


ALTER TABLE debug.bi_assortmentbyfloorset_staging OWNER TO psql;

--
-- TOC entry 1032 (class 1259 OID 136956887)
-- Name: actuals_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide (
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adj_in_c double precision DEFAULT 0.0 NOT NULL,
    adj_in_u double precision DEFAULT 0.0 NOT NULL,
    adj_in_v double precision DEFAULT 0.0 NOT NULL,
    adj_out_c double precision DEFAULT 0.0 NOT NULL,
    adj_out_u double precision DEFAULT 0.0 NOT NULL,
    adj_out_v double precision DEFAULT 0.0 NOT NULL,
    backorder_c_local double precision DEFAULT 0.0 NOT NULL,
    backorder_u double precision DEFAULT 0.0 NOT NULL,
    backorder_v_local double precision DEFAULT 0.0 NOT NULL,
    backorders_released_c double precision DEFAULT 0.0 NOT NULL,
    backorders_released_u double precision DEFAULT 0.0 NOT NULL,
    backorders_released_v double precision DEFAULT 0.0 NOT NULL,
    boh_c double precision DEFAULT 0.0 NOT NULL,
    boh_u double precision DEFAULT 0.0 NOT NULL,
    boh_v_csp double precision DEFAULT 0.0 NOT NULL,
    cancellations_c_local double precision DEFAULT 0.0 NOT NULL,
    cancellations_u double precision DEFAULT 0.0 NOT NULL,
    cancellations_v_asp_local double precision DEFAULT 0.0 NOT NULL,
    closing_on_hold_c double precision DEFAULT 0.0 NOT NULL,
    closing_on_hold_u double precision DEFAULT 0.0 NOT NULL,
    closing_on_hold_v double precision DEFAULT 0.0 NOT NULL,
    customer_despatch_c double precision DEFAULT 0.0 NOT NULL,
    customer_despatch_u double precision DEFAULT 0.0 NOT NULL,
    customer_despatch_v double precision DEFAULT 0.0 NOT NULL,
    discount_v_local double precision DEFAULT 0.0 NOT NULL,
    eoh_c double precision DEFAULT 0.0 NOT NULL,
    eoh_u double precision DEFAULT 0.0 NOT NULL,
    eoh_v_csp double precision DEFAULT 0.0 NOT NULL,
    grossdemand_c_local double precision DEFAULT 0.0 NOT NULL,
    grossdemand_u double precision DEFAULT 0.0 NOT NULL,
    grossdemand_v_local double precision DEFAULT 0.0 NOT NULL,
    intake_c double precision DEFAULT 0.0 NOT NULL,
    intake_u double precision DEFAULT 0.0 NOT NULL,
    intake_v double precision DEFAULT 0.0 NOT NULL,
    on_order_c double precision DEFAULT 0.0 NOT NULL,
    on_order_u double precision DEFAULT 0.0 NOT NULL,
    on_order_v double precision DEFAULT 0.0 NOT NULL,
    opening_on_hold_c double precision DEFAULT 0.0 NOT NULL,
    opening_on_hold_u double precision DEFAULT 0.0 NOT NULL,
    opening_on_hold_v double precision DEFAULT 0.0 NOT NULL,
    pending_back_orders_c_local double precision DEFAULT 0.0 NOT NULL,
    pending_back_orders_u double precision DEFAULT 0.0 NOT NULL,
    pending_back_orders_v_local double precision DEFAULT 0.0 NOT NULL,
    perm_md_move_c double precision DEFAULT 0.0 NOT NULL,
    perm_md_move_u double precision DEFAULT 0.0 NOT NULL,
    perm_md_move_v double precision DEFAULT 0.0 NOT NULL,
    perm_md_u double precision DEFAULT 0.0 NOT NULL,
    perm_md_v double precision DEFAULT 0.0 NOT NULL,
    pos_v_local double precision DEFAULT 0.0 NOT NULL,
    return_perm_md double precision DEFAULT 0.0 NOT NULL,
    soft_commitment_c double precision DEFAULT 0.0 NOT NULL,
    soft_commitment_u double precision DEFAULT 0.0 NOT NULL,
    soft_commitment_v double precision DEFAULT 0.0 NOT NULL,
    stock_valuation_factor_v double precision DEFAULT 0.0 NOT NULL,
    transfers_c_from_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_c_from_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_c_from_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_c_from_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    transfers_c_to_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_c_to_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_c_to_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_c_to_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    transfers_u_from_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_u_from_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_u_from_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_u_from_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    transfers_u_to_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_u_to_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_u_to_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_u_to_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    transfers_v_from_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_v_from_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_v_from_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_v_from_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    transfers_v_to_outlets double precision DEFAULT 0.0 NOT NULL,
    transfers_v_to_vdc_concessions_jl double precision DEFAULT 0.0 NOT NULL,
    transfers_v_to_vdc_dm double precision DEFAULT 0.0 NOT NULL,
    transfers_v_to_vdc_retail double precision DEFAULT 0.0 NOT NULL,
    balance_u_local double precision DEFAULT 0.0 NOT NULL,
    balance_v_local double precision DEFAULT 0.0 NOT NULL,
    balance_c_local double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_c double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_u double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_v double precision DEFAULT 0.0 NOT NULL,
    return_u double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_u double precision DEFAULT 0.0 NOT NULL,
    return_c_local double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_v double precision DEFAULT 0.0 NOT NULL,
    return_v_local double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_c double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_c_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_u_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_v_local double precision DEFAULT 0.0 NOT NULL,
    boh_aut_local double precision DEFAULT 0.0,
    md_inv_v double precision DEFAULT 0.0,
    further_md_v double precision DEFAULT 0.0,
    grossdemand_v_fsp_local double precision DEFAULT 0.0,
    preview_v_local double precision DEFAULT 0.0,
    preview_u double precision DEFAULT 0.0,
    preview_c_local double precision DEFAULT 0.0,
    eoh_v_fsp double precision DEFAULT 0.0,
    boh_v_fsp double precision DEFAULT 0.0,
    factor_grossdemand_asp double precision DEFAULT 0.0,
    factor_returns_cancellations_asp double precision DEFAULT 0.0,
    grossdemand_contribution_territory double precision DEFAULT 0.0,
    gross_uk_ctp_rev double precision DEFAULT 0.0,
    cls_stk_csp_rev double precision DEFAULT 0.0,
    gross_auc_rev double precision DEFAULT 0.0,
    eoh_u_shadow double precision DEFAULT 0.0,
    eoh_v_csp_target double precision DEFAULT 0.0,
    returns_contribution_territory double precision DEFAULT 0.0,
    grossdemand_u_act double precision DEFAULT 0.0,
    grossdemand_c_local_act double precision DEFAULT 0.0,
    return_c_local_act double precision DEFAULT 0.0,
    return_u_act double precision DEFAULT 0.0,
    cancellations_c_local_act double precision DEFAULT 0.0,
    cancellations_u_act double precision DEFAULT 0.0,
    adj_in_u_act double precision DEFAULT 0.0,
    adj_out_u_act double precision DEFAULT 0.0,
    transfers_u_from_vdc_concessions_jl_act double precision DEFAULT 0.0,
    transfers_u_to_vdc_concessions_jl_act double precision DEFAULT 0.0,
    customer_despatch_v_act double precision DEFAULT 0.0,
    customer_despatch_u_act double precision DEFAULT 0.0,
    customer_despatch_c_act double precision DEFAULT 0.0
);


ALTER TABLE mfp.actuals_wide OWNER TO psql;

--
-- TOC entry 1033 (class 1259 OID 136957016)
-- Name: actuals_wide_bk_20251031; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_bk_20251031 (
    prodlife text,
    product text,
    location text,
    "time" text,
    adj_in_c double precision,
    adj_in_u double precision,
    adj_in_v double precision,
    adj_out_c double precision,
    adj_out_u double precision,
    adj_out_v double precision,
    backorder_c_local double precision,
    backorder_u double precision,
    backorder_v_local double precision,
    backorders_released_c double precision,
    backorders_released_u double precision,
    backorders_released_v double precision,
    boh_c double precision,
    boh_u double precision,
    boh_v_csp double precision,
    cancellations_c_local double precision,
    cancellations_u double precision,
    cancellations_v_asp_local double precision,
    closing_on_hold_c double precision,
    closing_on_hold_u double precision,
    closing_on_hold_v double precision,
    customer_despatch_c double precision,
    customer_despatch_u double precision,
    customer_despatch_v double precision,
    discount_v_local double precision,
    eoh_c double precision,
    eoh_u double precision,
    eoh_v_csp double precision,
    grossdemand_c_local double precision,
    grossdemand_u double precision,
    grossdemand_v_local double precision,
    intake_c double precision,
    intake_u double precision,
    intake_v double precision,
    on_order_c double precision,
    on_order_u double precision,
    on_order_v double precision,
    opening_on_hold_c double precision,
    opening_on_hold_u double precision,
    opening_on_hold_v double precision,
    pending_back_orders_c_local double precision,
    pending_back_orders_u double precision,
    pending_back_orders_v_local double precision,
    perm_md_move_c double precision,
    perm_md_move_u double precision,
    perm_md_move_v double precision,
    perm_md_u double precision,
    perm_md_v double precision,
    pos_v_local double precision,
    return_perm_md double precision,
    soft_commitment_c double precision,
    soft_commitment_u double precision,
    soft_commitment_v double precision,
    stock_valuation_factor_v double precision,
    transfers_c_from_outlets double precision,
    transfers_c_from_vdc_concessions_jl double precision,
    transfers_c_from_vdc_dm double precision,
    transfers_c_from_vdc_retail double precision,
    transfers_c_to_outlets double precision,
    transfers_c_to_vdc_concessions_jl double precision,
    transfers_c_to_vdc_dm double precision,
    transfers_c_to_vdc_retail double precision,
    transfers_u_from_outlets double precision,
    transfers_u_from_vdc_concessions_jl double precision,
    transfers_u_from_vdc_dm double precision,
    transfers_u_from_vdc_retail double precision,
    transfers_u_to_outlets double precision,
    transfers_u_to_vdc_concessions_jl double precision,
    transfers_u_to_vdc_dm double precision,
    transfers_u_to_vdc_retail double precision,
    transfers_v_from_outlets double precision,
    transfers_v_from_vdc_concessions_jl double precision,
    transfers_v_from_vdc_dm double precision,
    transfers_v_from_vdc_retail double precision,
    transfers_v_to_outlets double precision,
    transfers_v_to_vdc_concessions_jl double precision,
    transfers_v_to_vdc_dm double precision,
    transfers_v_to_vdc_retail double precision,
    balance_u_local double precision,
    balance_v_local double precision,
    balance_c_local double precision,
    on_order_net_bo_c double precision,
    on_order_net_bo_u double precision,
    on_order_net_bo_v double precision,
    return_u double precision,
    returns_to_inventory_u double precision,
    return_c_local double precision,
    returns_to_inventory_v double precision,
    return_v_local double precision,
    returns_to_inventory_c double precision,
    fraud_adj_c_local double precision,
    fraud_adj_u_local double precision,
    fraud_adj_v_local double precision,
    boh_aut_local double precision,
    md_inv_v double precision,
    further_md_v double precision,
    grossdemand_v_fsp_local double precision,
    preview_v_local double precision,
    preview_u double precision,
    preview_c_local double precision,
    eoh_v_fsp double precision,
    boh_v_fsp double precision,
    factor_grossdemand_asp double precision,
    factor_returns_cancellations_asp double precision,
    grossdemand_contribution_territory double precision,
    gross_uk_ctp_rev double precision,
    cls_stk_csp_rev double precision,
    gross_auc_rev double precision,
    eoh_u_shadow double precision,
    eoh_v_csp_target double precision,
    returns_contribution_territory double precision,
    grossdemand_u_act double precision,
    grossdemand_c_local_act double precision,
    return_c_local_act double precision,
    return_u_act double precision,
    cancellations_c_local_act double precision,
    cancellations_u_act double precision,
    adj_in_u_act double precision,
    adj_out_u_act double precision,
    transfers_u_from_vdc_concessions_jl_act double precision,
    transfers_u_to_vdc_concessions_jl_act double precision,
    customer_despatch_v_act double precision,
    customer_despatch_u_act double precision,
    customer_despatch_c_act double precision
);


ALTER TABLE mfp.actuals_wide_bk_20251031 OWNER TO psql;

--
-- TOC entry 1034 (class 1259 OID 136957021)
-- Name: dimensions; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE mfp.dimensions OWNER TO psql;

--
-- TOC entry 1035 (class 1259 OID 136957026)
-- Name: hierarchies; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE mfp.hierarchies OWNER TO psql;

--
-- TOC entry 1036 (class 1259 OID 136957031)
-- Name: location_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.location_denorm AS
 SELECT brand.id AS brand,
    channel.id AS channel,
    selling_channel.id AS selling_channel,
    territory.id AS territory,
    market.id AS market
   FROM ((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'market'::text))) market
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = market.id)) territory ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = territory.id)) selling_channel ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = selling_channel.id)) channel ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = channel.id)) brand ON (true));


ALTER VIEW mfp.location_denorm OWNER TO psql;

--
-- TOC entry 1037 (class 1259 OID 136957036)
-- Name: prodlife_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.prodlife_denorm AS
 SELECT prodliferootlevel.id AS prodliferootlevel,
    merchcat.id AS merchcat
   FROM (( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'prodlife'::text) AND (dimensions.levelid = 'merchcat'::text))) merchcat
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = merchcat.id)) prodliferootlevel ON (true));


ALTER VIEW mfp.prodlife_denorm OWNER TO psql;

--
-- TOC entry 1038 (class 1259 OID 136957040)
-- Name: product_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.product_denorm AS
 SELECT company.id AS company,
    division.id AS division,
    segment.id AS segment,
    department.id AS department,
    class.id AS class
   FROM ((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'class'::text))) class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = class.id)) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = department.id)) segment ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = segment.id)) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = division.id)) company ON (true));


ALTER VIEW mfp.product_denorm OWNER TO psql;

--
-- TOC entry 1039 (class 1259 OID 136957045)
-- Name: time_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.time_denorm AS
 SELECT fiscalyear.id AS fiscalyear,
    halfyear.id AS halfyear,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM ((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = week.id)) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = month.id)) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = quarter.id)) halfyear ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (hierarchies.id = halfyear.id)) fiscalyear ON (true));


ALTER VIEW mfp.time_denorm OWNER TO psql;

--
-- TOC entry 1040 (class 1259 OID 136957050)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.actuals_wide_denorm AS
 SELECT "time".week AS time_week,
    "time".halfyear AS time_halfyear,
    product.class AS product_class,
    product.department AS product_department,
    product.division AS product_division,
    product.company AS product_company,
    location.market AS location_market,
    location.channel AS location_channel,
    location.brand AS location_brand,
    prodlife.merchcat AS prodlife_merchcat,
    prodlife.prodliferootlevel AS prodlife_prodliferootlevel,
    wide."time",
    wide.product,
    wide.location,
    wide.prodlife,
    wide.backorder_c_local,
    wide.backorder_u,
    wide.backorder_v_local,
    wide.cancellations_c_local,
    wide.cancellations_v_asp_local,
    wide.cancellations_u,
    wide.discount_v_local,
    wide.grossdemand_c_local,
    wide.grossdemand_u,
    wide.grossdemand_v_local,
    wide.pending_back_orders_c_local,
    wide.pending_back_orders_u,
    wide.pending_back_orders_v_local,
    wide.return_u,
    wide.return_v_local,
    wide.return_c_local,
    wide.pos_v_local,
    wide.closing_on_hold_c,
    wide.closing_on_hold_u,
    wide.closing_on_hold_v,
    wide.eoh_c,
    wide.eoh_u,
    wide.eoh_v_csp,
    wide.boh_c,
    wide.boh_u,
    wide.boh_v_csp,
    wide.fraud_adj_c_local,
    wide.fraud_adj_u_local,
    wide.fraud_adj_v_local,
    wide.intake_c,
    wide.intake_u,
    wide.intake_v,
    wide.adj_in_v,
    wide.adj_in_u,
    wide.adj_in_c,
    wide.adj_out_v,
    wide.adj_out_u,
    wide.adj_out_c,
    wide.opening_on_hold_v,
    wide.opening_on_hold_u,
    wide.opening_on_hold_c,
    wide.returns_to_inventory_v,
    wide.returns_to_inventory_u,
    wide.returns_to_inventory_c,
    wide.transfers_v_to_outlets,
    wide.transfers_u_to_outlets,
    wide.transfers_c_to_outlets,
    wide.transfers_v_to_vdc_retail,
    wide.transfers_u_to_vdc_retail,
    wide.transfers_c_to_vdc_retail,
    wide.transfers_v_to_vdc_concessions_jl,
    wide.transfers_u_to_vdc_concessions_jl,
    wide.transfers_c_to_vdc_concessions_jl,
    wide.transfers_v_to_vdc_dm,
    wide.transfers_u_to_vdc_dm,
    wide.transfers_c_to_vdc_dm,
    wide.transfers_v_from_outlets,
    wide.transfers_u_from_outlets,
    wide.transfers_c_from_outlets,
    wide.transfers_v_from_vdc_retail,
    wide.transfers_u_from_vdc_retail,
    wide.transfers_c_from_vdc_retail,
    wide.transfers_v_from_vdc_concessions_jl,
    wide.transfers_u_from_vdc_concessions_jl,
    wide.transfers_c_from_vdc_concessions_jl,
    wide.transfers_v_from_vdc_dm,
    wide.transfers_u_from_vdc_dm,
    wide.transfers_c_from_vdc_dm,
    wide.stock_valuation_factor_v,
    wide.backorders_released_v,
    wide.backorders_released_u,
    wide.backorders_released_c,
    wide.perm_md_v,
    wide.perm_md_u,
    wide.perm_md_move_v,
    wide.perm_md_move_u,
    wide.return_perm_md,
    wide.perm_md_move_c,
    wide.soft_commitment_v,
    wide.soft_commitment_u,
    wide.soft_commitment_c,
    wide.boh_aut_local,
    wide.customer_despatch_v,
    wide.customer_despatch_u,
    wide.customer_despatch_c,
    wide.on_order_v,
    wide.on_order_u,
    wide.on_order_c,
    wide.on_order_net_bo_v,
    wide.on_order_net_bo_u,
    wide.on_order_net_bo_c,
    wide.balance_c_local,
    wide.balance_u_local,
    wide.balance_v_local,
    wide.md_inv_v,
    wide.further_md_v,
    wide.grossdemand_v_fsp_local,
    wide.preview_v_local,
    wide.preview_u,
    wide.preview_c_local,
    wide.eoh_v_fsp,
    wide.boh_v_fsp,
    wide.factor_grossdemand_asp,
    wide.factor_returns_cancellations_asp,
    wide.grossdemand_contribution_territory,
    wide.gross_uk_ctp_rev,
    wide.cls_stk_csp_rev,
    wide.gross_auc_rev,
    wide.eoh_u_shadow,
    wide.eoh_v_csp_target,
    wide.returns_contribution_territory,
    wide.grossdemand_u_act,
    wide.grossdemand_c_local_act,
    wide.return_c_local_act,
    wide.return_u_act,
    wide.cancellations_c_local_act,
    wide.cancellations_u_act,
    wide.adj_in_u_act,
    wide.adj_out_u_act,
    wide.transfers_u_from_vdc_concessions_jl_act,
    wide.transfers_u_to_vdc_concessions_jl_act,
    wide.customer_despatch_v_act,
    wide.customer_despatch_u_act,
    wide.customer_despatch_c_act
   FROM ((((mfp.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.halfyear
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.company
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.market,
            location_denorm.channel,
            location_denorm.brand
           FROM mfp.location_denorm) location ON ((location.market = wide.location)))
     JOIN ( SELECT prodlife_denorm.merchcat,
            prodlife_denorm.prodliferootlevel
           FROM mfp.prodlife_denorm) prodlife ON ((prodlife.merchcat = wide.prodlife)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 1041 (class 1259 OID 136957057)
-- Name: actuals_wide_stage; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_stage (
    id character varying(218) NOT NULL,
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adj_in_c double precision NOT NULL,
    adj_in_u double precision NOT NULL,
    adj_in_v double precision NOT NULL,
    adj_out_c double precision NOT NULL,
    adj_out_u double precision NOT NULL,
    adj_out_v double precision NOT NULL,
    backorder_c_local double precision NOT NULL,
    backorder_u double precision NOT NULL,
    backorder_v_local double precision NOT NULL,
    backorders_released_c double precision NOT NULL,
    backorders_released_u double precision NOT NULL,
    backorders_released_v double precision NOT NULL,
    boh_c double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_v_csp double precision NOT NULL,
    cancellations_c_local double precision NOT NULL,
    cancellations_u double precision NOT NULL,
    cancellations_v_asp_local double precision NOT NULL,
    closing_on_hold_c double precision NOT NULL,
    closing_on_hold_u double precision NOT NULL,
    closing_on_hold_v double precision NOT NULL,
    customer_despatch_c double precision NOT NULL,
    customer_despatch_u double precision NOT NULL,
    customer_despatch_v double precision NOT NULL,
    discount_v_local double precision NOT NULL,
    eoh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_v_csp double precision NOT NULL,
    grossdemand_c_local double precision NOT NULL,
    grossdemand_u double precision NOT NULL,
    grossdemand_v_local double precision NOT NULL,
    intake_c double precision NOT NULL,
    intake_u double precision NOT NULL,
    intake_v double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_v double precision NOT NULL,
    opening_on_hold_c double precision NOT NULL,
    opening_on_hold_u double precision NOT NULL,
    opening_on_hold_v double precision NOT NULL,
    pending_back_orders_c_local double precision NOT NULL,
    pending_back_orders_u double precision NOT NULL,
    pending_back_orders_v_local double precision NOT NULL,
    perm_md_move_c double precision NOT NULL,
    perm_md_move_u double precision NOT NULL,
    perm_md_move_v double precision NOT NULL,
    perm_md_u double precision NOT NULL,
    perm_md_v double precision NOT NULL,
    pos_v_local double precision NOT NULL,
    return_c_local double precision NOT NULL,
    return_perm_md double precision NOT NULL,
    return_u double precision NOT NULL,
    return_v_local double precision NOT NULL,
    returns_to_inventory_c double precision NOT NULL,
    returns_to_inventory_u double precision NOT NULL,
    returns_to_inventory_v double precision NOT NULL,
    soft_commitment_c double precision NOT NULL,
    soft_commitment_u double precision NOT NULL,
    soft_commitment_v double precision NOT NULL,
    stock_valuation_factor_v double precision NOT NULL,
    transfers_c_from_marketoutlets double precision NOT NULL,
    transfers_c_from_outlets double precision NOT NULL,
    transfers_c_from_vdc_concessions_jl double precision NOT NULL,
    transfers_c_from_vdc_dm double precision NOT NULL,
    transfers_c_from_vdc_market double precision NOT NULL,
    transfers_c_from_vdc_retail double precision NOT NULL,
    transfers_c_to_marketoutlets double precision NOT NULL,
    transfers_c_to_outlets double precision NOT NULL,
    transfers_c_to_vdc_concessions_jl double precision NOT NULL,
    transfers_c_to_vdc_d_m double precision NOT NULL,
    transfers_c_to_vdc_market double precision NOT NULL,
    transfers_c_to_vdc_retail double precision NOT NULL,
    transfers_u_from_marketoutlets double precision NOT NULL,
    transfers_u_from_outlets double precision NOT NULL,
    transfers_u_from_vdc_concessions_jl double precision NOT NULL,
    transfers_u_from_vdc_dm double precision NOT NULL,
    transfers_u_from_vdc_market double precision NOT NULL,
    transfers_u_from_vdc_retail double precision NOT NULL,
    transfers_u_to_marketoutlets double precision NOT NULL,
    transfers_u_to_outlets double precision NOT NULL,
    transfers_u_to_vdc_concessions_jl double precision NOT NULL,
    transfers_u_to_vdc_d_m double precision NOT NULL,
    transfers_u_to_vdc_market double precision NOT NULL,
    transfers_u_to_vdc_retail double precision NOT NULL,
    transfers_v_from_marketoutlets double precision NOT NULL,
    transfers_v_from_outlets double precision NOT NULL,
    transfers_v_from_vdc_concessions_jl double precision NOT NULL,
    transfers_v_from_vdc_dm double precision NOT NULL,
    transfers_v_from_vdc_market double precision NOT NULL,
    transfers_v_from_vdc_retail double precision NOT NULL,
    transfers_v_to_marketoutlets double precision NOT NULL,
    transfers_v_to_outlets double precision NOT NULL,
    transfers_v_to_vdc_concessions_jl double precision NOT NULL,
    transfers_v_to_vdc_d_m double precision NOT NULL,
    transfers_v_to_vdc_market double precision NOT NULL,
    transfers_v_to_vdc_retail double precision NOT NULL
);


ALTER TABLE mfp.actuals_wide_stage OWNER TO psql;

--
-- TOC entry 1042 (class 1259 OID 136957062)
-- Name: comments; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp.comments OWNER TO psql;

--
-- TOC entry 1043 (class 1259 OID 136957068)
-- Name: currency_exchange_rates; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE mfp.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 1044 (class 1259 OID 136957074)
-- Name: currency_exchange_rates_20240102; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.currency_exchange_rates_20240102 (
    "time" text,
    location text,
    exchange_ratio double precision,
    currency_id text
);


ALTER TABLE mfp.currency_exchange_rates_20240102 OWNER TO psql;

--
-- TOC entry 1045 (class 1259 OID 136957079)
-- Name: currency_exchange_rates_bk20240102; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.currency_exchange_rates_bk20240102 (
    "time" text,
    location text,
    exchange_ratio double precision,
    currency_id text
);


ALTER TABLE mfp.currency_exchange_rates_bk20240102 OWNER TO psql;

--
-- TOC entry 1046 (class 1259 OID 136957084)
-- Name: currency_exchange_rates_bkp; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.currency_exchange_rates_bkp (
    "time" text,
    location text,
    exchange_ratio double precision,
    currency_id text
);


ALTER TABLE mfp.currency_exchange_rates_bkp OWNER TO psql;

--
-- TOC entry 1047 (class 1259 OID 136957089)
-- Name: dense; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dense (
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL
);


ALTER TABLE mfp.dense OWNER TO psql;

--
-- TOC entry 1048 (class 1259 OID 136957094)
-- Name: dimensions_bk_20251031; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_bk_20251031 (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE mfp.dimensions_bk_20251031 OWNER TO psql;

--
-- TOC entry 1049 (class 1259 OID 136957099)
-- Name: factors_stage; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.factors_stage (
    product character varying(50),
    location character varying(50),
    prodlife character varying(50),
    "time" character varying(50),
    factor_grossdemand_asp real
);


ALTER TABLE mfp.factors_stage OWNER TO psql;

--
-- TOC entry 1050 (class 1259 OID 136957102)
-- Name: hierarchies_bk_20251031; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_bk_20251031 (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE mfp.hierarchies_bk_20251031 OWNER TO psql;

--
-- TOC entry 1051 (class 1259 OID 136957107)
-- Name: metadata; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp.metadata OWNER TO psql;

--
-- TOC entry 1052 (class 1259 OID 136957112)
-- Name: nov2025_test; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.nov2025_test (
    product character varying(50),
    location character varying(50),
    prodlife character varying(50),
    "time" character varying(50),
    factor_grossdemand_asp real
);


ALTER TABLE mfp.nov2025_test OWNER TO psql;

--
-- TOC entry 1053 (class 1259 OID 136957115)
-- Name: paired_dimension_links; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE mfp.paired_dimension_links OWNER TO psql;

--
-- TOC entry 1054 (class 1259 OID 136957120)
-- Name: plan_archives; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_archives (
    id integer NOT NULL,
    name text DEFAULT 'unnamed'::text NOT NULL,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    archived_at timestamp with time zone DEFAULT now() NOT NULL,
    owned_by text DEFAULT 'system'::text NOT NULL,
    authored_by text NOT NULL,
    modified_by text,
    created_from integer,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    prodlife text NOT NULL
);


ALTER TABLE mfp.plan_archives OWNER TO psql;

--
-- TOC entry 1055 (class 1259 OID 136957129)
-- Name: plan_audit_log; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp.plan_audit_log OWNER TO psql;

--
-- TOC entry 1056 (class 1259 OID 136957135)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide (
    id integer NOT NULL,
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adj_in_c double precision NOT NULL,
    adj_in_u double precision NOT NULL,
    adj_in_v double precision NOT NULL,
    adj_out_c double precision NOT NULL,
    adj_out_u double precision NOT NULL,
    adj_out_v double precision NOT NULL,
    backorder_c_local double precision NOT NULL,
    backorder_u double precision NOT NULL,
    backorder_v_local double precision NOT NULL,
    backorders_released_c double precision NOT NULL,
    backorders_released_u double precision NOT NULL,
    backorders_released_v double precision NOT NULL,
    boh_c double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_v_csp double precision NOT NULL,
    cancellations_c_local double precision NOT NULL,
    cancellations_u double precision NOT NULL,
    cancellations_v_asp_local double precision NOT NULL,
    closing_on_hold_c double precision NOT NULL,
    closing_on_hold_u double precision NOT NULL,
    closing_on_hold_v double precision NOT NULL,
    customer_despatch_c double precision NOT NULL,
    customer_despatch_u double precision NOT NULL,
    customer_despatch_v double precision NOT NULL,
    discount_v_local double precision NOT NULL,
    eoh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_v_csp double precision NOT NULL,
    grossdemand_c_local double precision NOT NULL,
    grossdemand_u double precision NOT NULL,
    grossdemand_v_local double precision NOT NULL,
    intake_c double precision NOT NULL,
    intake_u double precision NOT NULL,
    intake_v double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_v double precision NOT NULL,
    opening_on_hold_c double precision NOT NULL,
    opening_on_hold_u double precision NOT NULL,
    opening_on_hold_v double precision NOT NULL,
    pending_back_orders_c_local double precision NOT NULL,
    pending_back_orders_u double precision NOT NULL,
    pending_back_orders_v_local double precision NOT NULL,
    perm_md_move_c double precision NOT NULL,
    perm_md_move_u double precision NOT NULL,
    perm_md_move_v double precision NOT NULL,
    perm_md_u double precision NOT NULL,
    perm_md_v double precision NOT NULL,
    pos_v_local double precision NOT NULL,
    return_perm_md double precision NOT NULL,
    soft_commitment_c double precision NOT NULL,
    soft_commitment_u double precision NOT NULL,
    soft_commitment_v double precision NOT NULL,
    stock_valuation_factor_v double precision NOT NULL,
    transfers_c_from_outlets double precision NOT NULL,
    transfers_c_from_vdc_concessions_jl double precision NOT NULL,
    transfers_c_from_vdc_dm double precision NOT NULL,
    transfers_c_from_vdc_retail double precision NOT NULL,
    transfers_c_to_outlets double precision NOT NULL,
    transfers_c_to_vdc_concessions_jl double precision NOT NULL,
    transfers_c_to_vdc_dm double precision NOT NULL,
    transfers_c_to_vdc_retail double precision NOT NULL,
    transfers_u_from_outlets double precision NOT NULL,
    transfers_u_from_vdc_concessions_jl double precision NOT NULL,
    transfers_u_from_vdc_dm double precision NOT NULL,
    transfers_u_from_vdc_retail double precision NOT NULL,
    transfers_u_to_outlets double precision NOT NULL,
    transfers_u_to_vdc_concessions_jl double precision NOT NULL,
    transfers_u_to_vdc_dm double precision NOT NULL,
    transfers_u_to_vdc_retail double precision NOT NULL,
    transfers_v_from_outlets double precision NOT NULL,
    transfers_v_from_vdc_concessions_jl double precision NOT NULL,
    transfers_v_from_vdc_dm double precision NOT NULL,
    transfers_v_from_vdc_retail double precision NOT NULL,
    transfers_v_to_outlets double precision NOT NULL,
    transfers_v_to_vdc_concessions_jl double precision NOT NULL,
    transfers_v_to_vdc_dm double precision NOT NULL,
    transfers_v_to_vdc_retail double precision NOT NULL,
    balance_u_local double precision DEFAULT 0.0 NOT NULL,
    balance_v_local double precision DEFAULT 0.0 NOT NULL,
    balance_c_local double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_c double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_u double precision DEFAULT 0.0 NOT NULL,
    on_order_net_bo_v double precision DEFAULT 0.0 NOT NULL,
    return_u double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_u double precision DEFAULT 0.0 NOT NULL,
    return_c_local double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_v double precision DEFAULT 0.0 NOT NULL,
    return_v_local double precision DEFAULT 0.0 NOT NULL,
    returns_to_inventory_c double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_c_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_u_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_v_local double precision DEFAULT 0.0 NOT NULL,
    boh_aut_local double precision DEFAULT 0.0,
    md_inv_v double precision DEFAULT 0.0,
    further_md_v double precision DEFAULT 0.0,
    grossdemand_v_fsp_local double precision DEFAULT 0.0,
    preview_v_local double precision DEFAULT 0.0,
    preview_u double precision DEFAULT 0.0,
    preview_c_local double precision DEFAULT 0.0,
    eoh_v_fsp double precision DEFAULT 0.0,
    boh_v_fsp double precision DEFAULT 0.0,
    factor_grossdemand_asp double precision DEFAULT 0.0,
    factor_returns_cancellations_asp double precision DEFAULT 0.0,
    grossdemand_contribution_territory double precision DEFAULT 0.0,
    gross_uk_ctp_rev double precision DEFAULT 0.0,
    cls_stk_csp_rev double precision DEFAULT 0.0,
    gross_auc_rev double precision DEFAULT 0.0,
    eoh_u_shadow double precision DEFAULT 0.0,
    eoh_v_csp_target double precision DEFAULT 0.0,
    returns_contribution_territory double precision DEFAULT 0.0,
    grossdemand_u_act double precision,
    grossdemand_c_local_act double precision,
    return_c_local_act double precision,
    return_u_act double precision,
    cancellations_c_local_act double precision,
    cancellations_u_act double precision,
    adj_in_u_act double precision,
    adj_out_u_act double precision,
    transfers_u_from_vdc_concessions_jl_act double precision,
    transfers_u_to_vdc_concessions_jl_act double precision,
    customer_despatch_v_act double precision,
    customer_despatch_u_act double precision,
    customer_despatch_c_act double precision
);


ALTER TABLE mfp.plan_data_wide OWNER TO psql;

--
-- TOC entry 1057 (class 1259 OID 136957173)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    prodlife text NOT NULL,
    backorder_c_local double precision NOT NULL,
    backorder_u double precision NOT NULL,
    backorder_v_local double precision NOT NULL,
    cancellations_c_local double precision NOT NULL,
    cancellations_v_asp_local double precision NOT NULL,
    cancellations_u double precision NOT NULL,
    discount_v_local double precision NOT NULL,
    grossdemand_c_local double precision NOT NULL,
    grossdemand_u double precision NOT NULL,
    grossdemand_v_local double precision NOT NULL,
    pending_back_orders_c_local double precision NOT NULL,
    pending_back_orders_u double precision NOT NULL,
    pending_back_orders_v_local double precision NOT NULL,
    return_u double precision NOT NULL,
    return_v_local double precision NOT NULL,
    return_c_local double precision NOT NULL,
    pos_v_local double precision NOT NULL,
    closing_on_hold_c double precision NOT NULL,
    closing_on_hold_u double precision NOT NULL,
    closing_on_hold_v double precision NOT NULL,
    eoh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_v_csp double precision NOT NULL,
    boh_c double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_v_csp double precision NOT NULL,
    fraud_adj_c_local double precision NOT NULL,
    fraud_adj_u_local double precision NOT NULL,
    fraud_adj_v_local double precision NOT NULL,
    intake_c double precision NOT NULL,
    intake_u double precision NOT NULL,
    intake_v double precision NOT NULL,
    adj_in_v double precision NOT NULL,
    adj_in_u double precision NOT NULL,
    adj_in_c double precision NOT NULL,
    adj_out_v double precision NOT NULL,
    adj_out_u double precision NOT NULL,
    adj_out_c double precision NOT NULL,
    opening_on_hold_v double precision NOT NULL,
    opening_on_hold_u double precision NOT NULL,
    opening_on_hold_c double precision NOT NULL,
    returns_to_inventory_v double precision NOT NULL,
    returns_to_inventory_u double precision NOT NULL,
    returns_to_inventory_c double precision NOT NULL,
    transfers_v_to_outlets double precision NOT NULL,
    transfers_u_to_outlets double precision NOT NULL,
    transfers_c_to_outlets double precision NOT NULL,
    transfers_v_to_vdc_retail double precision NOT NULL,
    transfers_u_to_vdc_retail double precision NOT NULL,
    transfers_c_to_vdc_retail double precision NOT NULL,
    transfers_v_to_vdc_concessions_jl double precision NOT NULL,
    transfers_u_to_vdc_concessions_jl double precision NOT NULL,
    transfers_c_to_vdc_concessions_jl double precision NOT NULL,
    transfers_v_to_vdc_dm double precision NOT NULL,
    transfers_u_to_vdc_dm double precision NOT NULL,
    transfers_c_to_vdc_dm double precision NOT NULL,
    transfers_v_from_outlets double precision NOT NULL,
    transfers_u_from_outlets double precision NOT NULL,
    transfers_c_from_outlets double precision NOT NULL,
    transfers_v_from_vdc_retail double precision NOT NULL,
    transfers_u_from_vdc_retail double precision NOT NULL,
    transfers_c_from_vdc_retail double precision NOT NULL,
    transfers_v_from_vdc_concessions_jl double precision NOT NULL,
    transfers_u_from_vdc_concessions_jl double precision NOT NULL,
    transfers_c_from_vdc_concessions_jl double precision NOT NULL,
    transfers_v_from_vdc_dm double precision NOT NULL,
    transfers_u_from_vdc_dm double precision NOT NULL,
    transfers_c_from_vdc_dm double precision NOT NULL,
    stock_valuation_factor_v double precision NOT NULL,
    backorders_released_v double precision NOT NULL,
    backorders_released_u double precision NOT NULL,
    backorders_released_c double precision NOT NULL,
    perm_md_v double precision NOT NULL,
    perm_md_u double precision NOT NULL,
    perm_md_move_v double precision NOT NULL,
    perm_md_move_u double precision NOT NULL,
    return_perm_md double precision NOT NULL,
    perm_md_move_c double precision NOT NULL,
    soft_commitment_v double precision NOT NULL,
    soft_commitment_u double precision NOT NULL,
    soft_commitment_c double precision NOT NULL,
    boh_aut_local double precision NOT NULL,
    customer_despatch_v double precision NOT NULL,
    customer_despatch_u double precision NOT NULL,
    customer_despatch_c double precision NOT NULL,
    on_order_v double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_net_bo_v double precision NOT NULL,
    on_order_net_bo_u double precision NOT NULL,
    on_order_net_bo_c double precision NOT NULL,
    balance_c_local double precision NOT NULL,
    balance_u_local double precision NOT NULL,
    balance_v_local double precision NOT NULL,
    md_inv_v double precision NOT NULL,
    further_md_v double precision NOT NULL,
    grossdemand_v_fsp_local double precision NOT NULL,
    preview_v_local double precision NOT NULL,
    preview_u double precision NOT NULL,
    preview_c_local double precision NOT NULL,
    eoh_v_fsp double precision NOT NULL,
    boh_v_fsp double precision NOT NULL,
    factor_grossdemand_asp double precision NOT NULL,
    factor_returns_cancellations_asp double precision NOT NULL,
    grossdemand_contribution_territory double precision NOT NULL,
    gross_uk_ctp_rev double precision NOT NULL,
    cls_stk_csp_rev double precision NOT NULL,
    gross_auc_rev double precision NOT NULL,
    eoh_u_shadow double precision NOT NULL,
    eoh_v_csp_target double precision NOT NULL,
    returns_contribution_territory double precision NOT NULL,
    grossdemand_u_act double precision NOT NULL,
    grossdemand_c_local_act double precision NOT NULL,
    return_c_local_act double precision NOT NULL,
    return_u_act double precision NOT NULL,
    cancellations_c_local_act double precision NOT NULL,
    cancellations_u_act double precision NOT NULL,
    adj_in_u_act double precision NOT NULL,
    adj_out_u_act double precision NOT NULL,
    transfers_u_from_vdc_concessions_jl_act double precision NOT NULL,
    transfers_u_to_vdc_concessions_jl_act double precision NOT NULL,
    customer_despatch_v_act double precision NOT NULL,
    customer_despatch_u_act double precision NOT NULL,
    customer_despatch_c_act double precision NOT NULL
);


ALTER TABLE mfp.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 1058 (class 1259 OID 136957178)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: mfp; Owner: psql
--

CREATE SEQUENCE mfp.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp.plan_id_ticker OWNER TO psql;

--
-- TOC entry 1059 (class 1259 OID 136957179)
-- Name: plan_init_status; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp.plan_init_status OWNER TO psql;

--
-- TOC entry 1060 (class 1259 OID 136957182)
-- Name: plans; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plans (
    id integer DEFAULT nextval('mfp.plan_id_ticker'::regclass) NOT NULL,
    name text DEFAULT 'unnamed'::text NOT NULL,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    owned_by text DEFAULT 'system'::text NOT NULL,
    authored_by text NOT NULL,
    modified_by text,
    created_from integer,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    prodlife text NOT NULL,
    module text NOT NULL
);


ALTER TABLE mfp.plans OWNER TO psql;

--
-- TOC entry 1061 (class 1259 OID 136957191)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.sys_gen_wide (
    sys_version text NOT NULL,
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adj_in_c double precision,
    adj_in_u double precision,
    adj_in_v double precision,
    adj_out_c double precision,
    adj_out_u double precision,
    adj_out_v double precision,
    backorder_c_local double precision,
    backorder_u double precision,
    backorder_v_local double precision,
    backorders_released_c double precision,
    backorders_released_u double precision,
    backorders_released_v double precision,
    balance_c_local double precision,
    balance_u_local double precision,
    balance_v_local double precision,
    boh_c double precision,
    boh_u double precision,
    boh_v_csp double precision,
    cancellations_c_local double precision,
    cancellations_u double precision,
    cancellations_v_asp_local double precision,
    closing_on_hold_c double precision,
    closing_on_hold_u double precision,
    closing_on_hold_v double precision,
    customer_despatch_c double precision,
    customer_despatch_u double precision,
    customer_despatch_v double precision,
    discount_v_local double precision,
    eoh_c double precision,
    eoh_u double precision,
    eoh_v_csp double precision,
    grossdemand_c_local double precision,
    grossdemand_u double precision,
    grossdemand_v_local double precision,
    intake_c double precision,
    intake_u double precision,
    intake_v double precision,
    on_order_c double precision,
    on_order_u double precision,
    on_order_v double precision,
    opening_on_hold_c double precision,
    opening_on_hold_u double precision,
    opening_on_hold_v double precision,
    pending_back_orders_c_local double precision,
    pending_back_orders_u double precision,
    pending_back_orders_v_local double precision,
    perm_md_move_c double precision,
    perm_md_move_u double precision,
    perm_md_move_v double precision,
    perm_md_u double precision,
    perm_md_v double precision,
    pos_v_local double precision,
    return_perm_md double precision,
    soft_commitment_c double precision,
    soft_commitment_u double precision,
    soft_commitment_v double precision,
    stock_valuation_factor_v double precision,
    transfers_c_from_outlets double precision,
    transfers_c_from_vdc_concessions_jl double precision,
    transfers_c_from_vdc_dm double precision,
    transfers_c_from_vdc_retail double precision,
    transfers_c_to_outlets double precision,
    transfers_c_to_vdc_concessions_jl double precision,
    transfers_c_to_vdc_dm double precision,
    transfers_c_to_vdc_retail double precision,
    transfers_u_from_outlets double precision,
    transfers_u_from_vdc_concessions_jl double precision,
    transfers_u_from_vdc_dm double precision,
    transfers_u_from_vdc_retail double precision,
    transfers_u_to_outlets double precision,
    transfers_u_to_vdc_concessions_jl double precision,
    transfers_u_to_vdc_dm double precision,
    transfers_u_to_vdc_retail double precision,
    transfers_v_from_outlets double precision,
    transfers_v_from_vdc_concessions_jl double precision,
    transfers_v_from_vdc_dm double precision,
    transfers_v_from_vdc_retail double precision,
    transfers_v_to_outlets double precision,
    transfers_v_to_vdc_concessions_jl double precision,
    transfers_v_to_vdc_dm double precision,
    transfers_v_to_vdc_retail double precision,
    on_order_net_bo_c double precision,
    on_order_net_bo_u double precision,
    on_order_net_bo_v double precision,
    return_u double precision,
    returns_to_inventory_u double precision,
    return_c_local double precision,
    returns_to_inventory_v double precision,
    return_v_local double precision,
    returns_to_inventory_c double precision,
    fraud_adj_c_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_u_local double precision DEFAULT 0.0 NOT NULL,
    fraud_adj_v_local double precision DEFAULT 0.0 NOT NULL,
    boh_aut_local double precision,
    md_inv_v double precision,
    further_md_v double precision,
    grossdemand_v_fsp_local double precision,
    preview_v_local double precision,
    preview_u double precision,
    preview_c_local double precision,
    eoh_v_fsp double precision,
    boh_v_fsp double precision,
    factor_grossdemand_asp double precision,
    factor_returns_cancellations_asp double precision,
    grossdemand_contribution_territory double precision,
    gross_uk_ctp_rev double precision,
    cls_stk_csp_rev double precision,
    gross_auc_rev double precision,
    eoh_u_shadow double precision,
    eoh_v_csp_target double precision,
    returns_contribution_territory double precision,
    grossdemand_u_act double precision,
    grossdemand_c_local_act double precision,
    return_c_local_act double precision,
    return_u_act double precision,
    cancellations_c_local_act double precision,
    cancellations_u_act double precision,
    adj_in_u_act double precision,
    adj_out_u_act double precision,
    transfers_u_from_vdc_concessions_jl_act double precision,
    transfers_u_to_vdc_concessions_jl_act double precision,
    customer_despatch_v_act double precision,
    customer_despatch_u_act double precision,
    customer_despatch_c_act double precision
);


ALTER TABLE mfp.sys_gen_wide OWNER TO psql;

--
-- TOC entry 1062 (class 1259 OID 136957199)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".halfyear AS time_halfyear,
    product.class AS product_class,
    product.department AS product_department,
    product.division AS product_division,
    product.company AS product_company,
    location.market AS location_market,
    location.channel AS location_channel,
    location.brand AS location_brand,
    prodlife.merchcat AS prodlife_merchcat,
    prodlife.prodliferootlevel AS prodlife_prodliferootlevel,
    wide."time",
    wide.product,
    wide.location,
    wide.prodlife,
    wide.backorder_c_local,
    wide.backorder_u,
    wide.backorder_v_local,
    wide.cancellations_c_local,
    wide.cancellations_v_asp_local,
    wide.cancellations_u,
    wide.discount_v_local,
    wide.grossdemand_c_local,
    wide.grossdemand_u,
    wide.grossdemand_v_local,
    wide.pending_back_orders_c_local,
    wide.pending_back_orders_u,
    wide.pending_back_orders_v_local,
    wide.return_u,
    wide.return_v_local,
    wide.return_c_local,
    wide.pos_v_local,
    wide.closing_on_hold_c,
    wide.closing_on_hold_u,
    wide.closing_on_hold_v,
    wide.eoh_c,
    wide.eoh_u,
    wide.eoh_v_csp,
    wide.boh_c,
    wide.boh_u,
    wide.boh_v_csp,
    wide.fraud_adj_c_local,
    wide.fraud_adj_u_local,
    wide.fraud_adj_v_local,
    wide.intake_c,
    wide.intake_u,
    wide.intake_v,
    wide.adj_in_v,
    wide.adj_in_u,
    wide.adj_in_c,
    wide.adj_out_v,
    wide.adj_out_u,
    wide.adj_out_c,
    wide.opening_on_hold_v,
    wide.opening_on_hold_u,
    wide.opening_on_hold_c,
    wide.returns_to_inventory_v,
    wide.returns_to_inventory_u,
    wide.returns_to_inventory_c,
    wide.transfers_v_to_outlets,
    wide.transfers_u_to_outlets,
    wide.transfers_c_to_outlets,
    wide.transfers_v_to_vdc_retail,
    wide.transfers_u_to_vdc_retail,
    wide.transfers_c_to_vdc_retail,
    wide.transfers_v_to_vdc_concessions_jl,
    wide.transfers_u_to_vdc_concessions_jl,
    wide.transfers_c_to_vdc_concessions_jl,
    wide.transfers_v_to_vdc_dm,
    wide.transfers_u_to_vdc_dm,
    wide.transfers_c_to_vdc_dm,
    wide.transfers_v_from_outlets,
    wide.transfers_u_from_outlets,
    wide.transfers_c_from_outlets,
    wide.transfers_v_from_vdc_retail,
    wide.transfers_u_from_vdc_retail,
    wide.transfers_c_from_vdc_retail,
    wide.transfers_v_from_vdc_concessions_jl,
    wide.transfers_u_from_vdc_concessions_jl,
    wide.transfers_c_from_vdc_concessions_jl,
    wide.transfers_v_from_vdc_dm,
    wide.transfers_u_from_vdc_dm,
    wide.transfers_c_from_vdc_dm,
    wide.stock_valuation_factor_v,
    wide.backorders_released_v,
    wide.backorders_released_u,
    wide.backorders_released_c,
    wide.perm_md_v,
    wide.perm_md_u,
    wide.perm_md_move_v,
    wide.perm_md_move_u,
    wide.return_perm_md,
    wide.perm_md_move_c,
    wide.soft_commitment_v,
    wide.soft_commitment_u,
    wide.soft_commitment_c,
    wide.boh_aut_local,
    wide.customer_despatch_v,
    wide.customer_despatch_u,
    wide.customer_despatch_c,
    wide.on_order_v,
    wide.on_order_u,
    wide.on_order_c,
    wide.on_order_net_bo_v,
    wide.on_order_net_bo_u,
    wide.on_order_net_bo_c,
    wide.balance_c_local,
    wide.balance_u_local,
    wide.balance_v_local,
    wide.md_inv_v,
    wide.further_md_v,
    wide.grossdemand_v_fsp_local,
    wide.preview_v_local,
    wide.preview_u,
    wide.preview_c_local,
    wide.eoh_v_fsp,
    wide.boh_v_fsp,
    wide.factor_grossdemand_asp,
    wide.factor_returns_cancellations_asp,
    wide.grossdemand_contribution_territory,
    wide.gross_uk_ctp_rev,
    wide.cls_stk_csp_rev,
    wide.gross_auc_rev,
    wide.eoh_u_shadow,
    wide.eoh_v_csp_target,
    wide.returns_contribution_territory,
    wide.grossdemand_u_act,
    wide.grossdemand_c_local_act,
    wide.return_c_local_act,
    wide.return_u_act,
    wide.cancellations_c_local_act,
    wide.cancellations_u_act,
    wide.adj_in_u_act,
    wide.adj_out_u_act,
    wide.transfers_u_from_vdc_concessions_jl_act,
    wide.transfers_u_to_vdc_concessions_jl_act,
    wide.customer_despatch_v_act,
    wide.customer_despatch_u_act,
    wide.customer_despatch_c_act
   FROM ((((mfp.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.halfyear
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.company
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.market,
            location_denorm.channel,
            location_denorm.brand
           FROM mfp.location_denorm) location ON ((location.market = wide.location)))
     JOIN ( SELECT prodlife_denorm.merchcat,
            prodlife_denorm.prodliferootlevel
           FROM mfp.prodlife_denorm) prodlife ON ((prodlife.merchcat = wide.prodlife)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 1063 (class 1259 OID 136957206)
-- Name: tyly; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp.tyly OWNER TO psql;

--
-- TOC entry 1064 (class 1259 OID 136957211)
-- Name: tyly_bk_20251031; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly_bk_20251031 (
    ty text,
    ly text
);


ALTER TABLE mfp.tyly_bk_20251031 OWNER TO psql;

--
-- TOC entry 1065 (class 1259 OID 136957216)
-- Name: user_kv_store; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp.user_kv_store OWNER TO psql;

--
-- TOC entry 1066 (class 1259 OID 136957221)
-- Name: user_kv_store_bkp; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.user_kv_store_bkp (
    uid text,
    key text,
    value text
);


ALTER TABLE mfp.user_kv_store_bkp OWNER TO psql;

--
-- TOC entry 1067 (class 1259 OID 136957226)
-- Name: agent_conversations; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.agent_conversations (
    conversation_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.agent_conversations OWNER TO psql;

--
-- TOC entry 1068 (class 1259 OID 136957234)
-- Name: agent_conversations_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.agent_conversations_log (
    conversation_id uuid NOT NULL,
    message_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    message_sender agent_sender NOT NULL,
    message_content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.agent_conversations_log OWNER TO psql;

--
-- TOC entry 1069 (class 1259 OID 136957241)
-- Name: allocation_plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.allocation_plan_queue (
    jobid uuid NOT NULL,
    initiator text NOT NULL,
    model_defn_path text NOT NULL,
    scope json NOT NULL,
    state queue_state,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    error text
);


ALTER TABLE public.allocation_plan_queue OWNER TO psql;

--
-- TOC entry 1070 (class 1259 OID 136957248)
-- Name: allocation_plan_queue_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.allocation_plan_queue_items (
    jobid uuid,
    user_id text NOT NULL,
    product text NOT NULL,
    type text NOT NULL,
    name text DEFAULT '⚠️❓❓'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.allocation_plan_queue_items OWNER TO psql;

--
-- TOC entry 1071 (class 1259 OID 136957256)
-- Name: assort_period_from_dpt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.assort_period_from_dpt (
    department text NOT NULL,
    "time" text NOT NULL,
    floorset text
);


ALTER TABLE public.assort_period_from_dpt OWNER TO psql;

--
-- TOC entry 1072 (class 1259 OID 136957261)
-- Name: bd_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text DEFAULT 'plan'::text NOT NULL,
    style text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    isfunded integer DEFAULT 1,
    store_count integer DEFAULT 0,
    propagate_ranging integer DEFAULT 1,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.bd_a_assortment OWNER TO psql;

--
-- TOC entry 1073 (class 1259 OID 136957277)
-- Name: bd_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_corpdisc (
    department text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    corpaddoff real DEFAULT 0.0,
    corpexcl real DEFAULT 0.0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_corpdisc OWNER TO psql;

--
-- TOC entry 1074 (class 1259 OID 136957291)
-- Name: bd_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_location (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_d_location OWNER TO psql;

--
-- TOC entry 1075 (class 1259 OID 136957303)
-- Name: bd_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_time (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_d_time OWNER TO psql;

--
-- TOC entry 1076 (class 1259 OID 136957315)
-- Name: bd_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_locstd OWNER TO psql;

--
-- TOC entry 1077 (class 1259 OID 136957327)
-- Name: bd_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_prodstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_prodstd OWNER TO psql;

--
-- TOC entry 1078 (class 1259 OID 136957339)
-- Name: bd_l_mdstrategy; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_mdstrategy (
    department text NOT NULL,
    mdstrategy text NOT NULL,
    seq integer NOT NULL,
    md_disc real,
    factor real,
    eventdate date DEFAULT (now())::date
);


ALTER TABLE public.bd_l_mdstrategy OWNER TO psql;

--
-- TOC entry 1079 (class 1259 OID 136957345)
-- Name: bd_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes (
    product text NOT NULL,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sty_ticketpricechannel_base_gbp1 real DEFAULT 0.01,
    sty_ticketpricechannel_base_gbp2 real DEFAULT 0.01,
    ccstylecreatedate text DEFAULT '1900-01-01'::text
);


ALTER TABLE public.bd_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1080 (class 1259 OID 136957360)
-- Name: bd_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes (
    product text NOT NULL,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    actual_launch_month text,
    launch_week text,
    actual_launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text,
    us_price_band text,
    uk_price_band text
);


ALTER TABLE public.bd_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1081 (class 1259 OID 136957365)
-- Name: bd_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorchannelattributes (
    product text NOT NULL,
    location text NOT NULL,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
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
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text DEFAULT 'No'::text,
    lifecycle_applied text,
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
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_return_u_pct real,
    auto_rollforward boolean DEFAULT false,
    irr_mode text DEFAULT 'Normal'::text,
    plan_current text,
    hasbeenpatternedafter text,
    ticketprice_locked integer
);


ALTER TABLE public.bd_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1082 (class 1259 OID 136957391)
-- Name: bd_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_weekattributes (
    "time" text NOT NULL,
    start_date text DEFAULT ''::text,
    end_date text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_ma_weekattributes OWNER TO psql;

--
-- TOC entry 1083 (class 1259 OID 136957398)
-- Name: bd_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_itemprice (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    addoff real,
    eo real,
    eff_aur real,
    department text NOT NULL,
    event text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_p_itemprice OWNER TO psql;

--
-- TOC entry 1084 (class 1259 OID 136957410)
-- Name: bd_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_serviceparams (
    id text,
    type text,
    value text,
    eventdate text,
    version_id text,
    created_at text,
    created_by text,
    updated_at text,
    updated_by text,
    record_state integer
);


ALTER TABLE public.bd_serviceparams OWNER TO psql;

--
-- TOC entry 1085 (class 1259 OID 136957415)
-- Name: md_strategy; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.md_strategy AS
 SELECT bd_l_mdstrategy.department,
    bd_l_mdstrategy.mdstrategy,
    bd_l_mdstrategy.seq,
    bd_l_mdstrategy.md_disc,
    bd_l_mdstrategy.factor,
    bd_l_mdstrategy.eventdate
   FROM bd_l_mdstrategy;


ALTER VIEW public.md_strategy OWNER TO psql;

--
-- TOC entry 1086 (class 1259 OID 136957419)
-- Name: analytics_product_fcst_input; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.analytics_product_fcst_input AS
 SELECT a.product,
    a.selling_channel,
    a.store_count,
    a.flow_flag,
    a.weekdate,
    a.price_status,
    a.ccticketprice AS original_ticketprice,
    a.ccticketprice AS selling_price,
    a.class,
    a.subclass,
    a.department,
    a.division,
    a.num_sizes AS sku_count,
    a.num_sizes,
    b.cc_sub_range,
    b.cc_applied_detail,
    b.cc_color_group,
    b.cc_sub_theme,
    b.cc_pattern,
    b.cc_collection,
    b.cc_fabric_yarn_type,
    b.cccw_age_gender,
    b.cc_price_banding_latest,
    b.cc_texture,
    b.cc_season_latest,
    b.cc_theme_latest,
    b.cc_weight,
    b.cc_archetype,
    b.cc_pattern_new,
    c.sty_fit_style,
    c.sty_rise,
    c.sty_heel_height,
    c.sty_footwear_type,
    c.sty_end_use,
    c.sty_dress_skirt_length,
    c.sty_neck_detail,
    c.sty_waist_detail,
    c.sty_skirt_shape,
    c.sty_sleeve_length,
    c.sty_sleeve_shape,
    c.sty_trouser_length,
    c.sty_trouser_shape,
    c.sty_packages,
    c.sty_shopzilla_rating,
    c.sty_price_band_style,
    c.sty_classification_latest,
    c.sty_age_style,
    c.sty_gender_style,
    c.sty_size_range AS size_range,
    b.cc_print_name
   FROM ( SELECT m.product,
            m.org_channel,
            m.dbt_wk,
            m.last_rcpt_wk,
            m.erlstmkdnwk,
            m.exitdate,
            m.ccmdstrategy,
            m.ccdiscountpct,
            m."time",
            m.indx,
            m.price_status,
            m.seq,
            m.style,
            m.subclass,
            m.class,
            m.department,
            m.division,
            m.ccticketprice,
            m.dbt_wk_indx,
            m.last_rcpt_wk_indx,
            m.erlstmkdnwk_indx,
            m.flow_flag,
            m.weekdate,
            m.floorset,
            m.num_sizes,
            m.channel,
            m.selling_channel,
            m.store_count,
            m.md_disc,
            m.curp,
            m.corpaddoff,
            m.corpexcl,
            n.eff_aur AS expressed_aur,
            n.addoff,
                CASE
                    WHEN (m.seq = 0) THEN (m.ccticketprice * ((1)::double precision - COALESCE(m.corpexcl, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_a,
                CASE
                    WHEN (m.seq = 0) THEN ((
                    CASE
                        WHEN (n.eff_aur > (0)::double precision) THEN n.eff_aur
                        ELSE m.ccticketprice
                    END * ((1)::double precision - COALESCE(n.addoff, (0)::real))) * ((1)::double precision - COALESCE(m.corpaddoff, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_b
           FROM (( SELECT a_1.product,
                    a_1.org_channel,
                    a_1.dbt_wk,
                    a_1.last_rcpt_wk,
                    a_1.erlstmkdnwk,
                    a_1.exitdate,
                    a_1.ccmdstrategy,
                    a_1.ccdiscountpct,
                    a_1."time",
                    a_1.indx,
                    a_1.price_status,
                    a_1.seq,
                    a_1.style,
                    a_1.subclass,
                    a_1.class,
                    a_1.department,
                    a_1.division,
                    a_1.ccticketprice,
                    a_1.dbt_wk_indx,
                    a_1.last_rcpt_wk_indx,
                    a_1.erlstmkdnwk_indx,
                    a_1.flow_flag,
                    a_1.weekdate,
                    a_1.floorset,
                    a_1.num_sizes,
                    a_1.channel,
                    a_1.selling_channel,
                    a_1.store_count,
                    a_1.md_disc,
                    a_1.curp,
                    COALESCE(c_1.corpaddoff, (0)::real) AS corpaddoff,
                    COALESCE(c_1.corpexcl, (0)::real) AS corpexcl
                   FROM (( SELECT a_2.product,
                            a_2.org_channel,
                            a_2.dbt_wk,
                            a_2.last_rcpt_wk,
                            a_2.erlstmkdnwk,
                            a_2.exitdate,
                            a_2.ccmdstrategy,
                            a_2.ccdiscountpct,
                            a_2."time",
                            a_2.indx,
                            a_2.price_status,
                            a_2.seq,
                            a_2.style,
                            a_2.subclass,
                            a_2.class,
                            a_2.department,
                            a_2.division,
                            a_2.ccticketprice,
                            a_2.dbt_wk_indx,
                            a_2.last_rcpt_wk_indx,
                            a_2.erlstmkdnwk_indx,
                            a_2.flow_flag,
                            a_2.weekdate,
                            a_2.floorset,
                            a_2.num_sizes,
                            a_2.channel,
                            a_2.selling_channel,
                            a_2.store_count,
                            b_1.md_disc,
                            (a_2.ccticketprice * ((1)::double precision - b_1.md_disc)) AS curp
                           FROM (( SELECT z.product,
                                    z.org_channel,
                                    z.dbt_wk,
                                    z.last_rcpt_wk,
                                    z.erlstmkdnwk,
                                    z.exitdate,
                                    z.ccmdstrategy,
                                    z.ccdiscountpct,
                                    z."time",
                                    z.indx,
                                    z.price_status,
                                    z.seq,
                                    z.style,
                                    z.subclass,
                                    z.class,
                                    z.department,
                                    z.division,
                                    z.ccticketprice,
                                    z.dbt_wk_indx,
                                    z.last_rcpt_wk_indx,
                                    z.erlstmkdnwk_indx,
                                    z.flow_flag,
                                    z.weekdate,
                                    z.floorset,
                                    z.num_sizes,
                                    z.channel,
                                    z.selling_channel,
                                    asst.store_count
                                   FROM ( SELECT x.product,
    x.org_channel,
    x.dbt_wk,
    x.last_rcpt_wk,
    x.erlstmkdnwk,
    x.exitdate,
    x.ccmdstrategy,
    x.ccdiscountpct,
    x."time",
    x.indx,
    x.price_status,
    x.seq,
    x.style,
    x.subclass,
    x.class,
    x.department,
    x.division,
    x.ccticketprice,
    x.dbt_wk_indx,
    x.last_rcpt_wk_indx,
    x.erlstmkdnwk_indx,
    x.flow_flag,
    x.weekdate,
    x.floorset,
    x.num_sizes,
    y.channel,
    y.selling_channel
   FROM ( SELECT a_3.product,
      a_3.location AS org_channel,
      COALESCE(a_3.relaunchweek, a_3.dbt_wk) AS dbt_wk,
      a_3.last_rcpt_wk,
      a_3.erlstmkdnwk,
      a_3.exitdate,
      a_3.ccmdstrategy,
      a_3.ccdiscountpct,
      b_2.id AS "time",
      b_2.indx,
    CASE
     WHEN (b_2.id < a_3.erlstmkdnwk) THEN 'FP'::text
     ELSE 'MD'::text
    END AS price_status,
      GREATEST(0, ((b_2.indx + 1) - dx.indx)) AS seq,
      c_2.ancestor0 AS style,
      c_2.ancestor1 AS subclass,
      c_2.ancestor2 AS class,
      c_2.ancestor3 AS department,
      c_2.ancestor5 AS division,
      d.sty_ticketpricechannel_base_gbp1 AS ccticketprice,
      bx.indx AS dbt_wk_indx,
      cx.indx AS last_rcpt_wk_indx,
      dx.indx AS erlstmkdnwk_indx,
    CASE
     WHEN ((b_2.indx >= bx.indx) AND (b_2.indx < (bx.indx + 4))) THEN 'NEW'::text
     ELSE
     CASE
      WHEN ((b_2.indx >= (bx.indx + 4)) AND (b_2.indx < (cx.indx + 4))) THEN 'FLOW'::text
      ELSE 'LOF'::text
     END
    END AS flow_flag,
      str_dt.start_date AS weekdate,
      dptflr.floorset,
      array_length(a_3.validsizes, 1) AS num_sizes
     FROM bd_ma_stylecolorchannelattributes a_3,
      bd_d_time b_2,
      bd_h_prodstd c_2,
      bd_ma_styleattributes d,
      bd_d_time bx,
      bd_d_time cx,
      bd_d_time dx,
      bd_ma_weekattributes str_dt,
      assort_period_from_dpt dptflr
    WHERE ((b_2.id >= COALESCE(a_3.relaunchweek, a_3.dbt_wk)) AND (b_2.id <= a_3.exitdate) AND (b_2.levelid = 'week'::text) AND (c_2.id = a_3.product) AND (d.product = c_2.ancestor0) AND (a_3.dbt_wk = bx.id) AND (a_3.last_rcpt_wk = cx.id) AND (a_3.erlstmkdnwk = dx.id) AND (str_dt."time" = b_2.id) AND (dptflr.department = c_2.ancestor3) AND (b_2.id = dptflr."time") AND (b_2.id >= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_current'::text))) AND (b_2.id <= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_end'::text))))
    ORDER BY a_3.product, b_2.id) x,
    ( SELECT DISTINCT bd_h_locstd.id AS selling_channel,
      bd_h_locstd.ancestor1 AS channel,
      bd_h_locstd.ancestor2 AS org_channel
     FROM bd_h_locstd
    WHERE (bd_h_locstd.id IN ( SELECT bd_d_location.id
       FROM bd_d_location
      WHERE (bd_d_location.levelid = 'market'::text)))) y
  WHERE (x.org_channel = y.org_channel)) z,
                                    bd_a_assortment asst
                                  WHERE ((asst.product = z.product) AND (asst.location = z.org_channel) AND (asst."time" = z.floorset) AND (asst.plan_type = 'plan'::text))) a_2
                             LEFT JOIN md_strategy b_1 ON (((a_2.seq = b_1.seq) AND (a_2.ccmdstrategy = b_1.mdstrategy) AND (a_2.department = b_1.department))))) a_1
                     LEFT JOIN bd_corpdisc c_1 ON (((a_1.subclass = c_1.product) AND (a_1."time" = c_1."time"))))) m
             LEFT JOIN bd_p_itemprice n ON (((m.product = n.product) AND (m."time" = n."time"))))) a,
    bd_ma_stylecolorattributes b,
    bd_ma_styleattributes c
  WHERE ((a.product = b.product) AND (a.style = c.product));


ALTER VIEW public.analytics_product_fcst_input OWNER TO psql;

--
-- TOC entry 1087 (class 1259 OID 136957424)
-- Name: analytics_product_fcst_input_xx; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.analytics_product_fcst_input_xx AS
 SELECT a.product,
    a.flow_flag,
    a.weekdate,
    a.price_status,
    a.ccticketprice AS original_ticketprice,
    (LEAST(a.v_a, a.v_b))::numeric(16,2) AS selling_price,
    a.class,
    a.subclass,
    a.department,
    a.division,
    a.style,
    a.num_sizes,
    b.cc_sub_range,
    b.cc_applied_detail,
    b.cc_color_group,
    b.cc_sub_theme,
    b.cc_pattern,
    b.cc_collection,
    b.cc_fabric_yarn_type,
    b.cccw_age_gender,
    b.cc_price_banding_latest,
    b.cc_texture,
    b.cc_season_latest,
    b.cc_classification_latest,
    b.cc_theme_latest,
    b.cc_weight,
    b.cc_archetype,
    b.cc_pattern_new,
    c.sty_fit_style,
    c.sty_rise,
    c.sty_heel_height,
    c.sty_footwear_type,
    c.sty_end_use,
    c.sty_dress_skirt_length,
    c.sty_neck_detail,
    c.sty_waist_detail,
    c.sty_skirt_shape,
    c.sty_sleeve_length,
    c.sty_sleeve_shape,
    c.sty_trouser_length,
    c.sty_trouser_shape,
    c.sty_packages,
    c.sty_shopzilla_rating,
    c.sty_price_band_style,
    c.sty_classification_latest,
    c.sty_age_style,
    c.sty_gender_style,
    c.sty_size_range AS size_range,
    b.cc_print_name,
    c.sty_shopzilla_rating_count,
    b.launch_month,
    b.launch_week
   FROM ( SELECT m.product,
            m.org_channel,
            m.dbt_wk,
            m.last_rcpt_wk,
            m.erlstmkdnwk,
            m.exitdate,
            m.ccmdstrategy,
            m.ccdiscountpct,
            m."time",
            m.indx,
            m.price_status,
            m.seq,
            m.style,
            m.subclass,
            m.class,
            m.department,
            m.division,
            m.ccticketprice,
            m.dbt_wk_indx,
            m.last_rcpt_wk_indx,
            m.erlstmkdnwk_indx,
            m.flow_flag,
            m.weekdate,
            m.floorset,
            m.num_sizes,
            m.md_disc,
            m.curp,
            m.corpaddoff,
            m.corpexcl,
            n.eff_aur AS expressed_aur,
            n.addoff,
                CASE
                    WHEN (m.seq = 0) THEN (m.ccticketprice * ((1)::double precision - COALESCE(m.corpexcl, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_a,
                CASE
                    WHEN (m.seq = 0) THEN ((
                    CASE
                        WHEN (n.eff_aur > (0)::double precision) THEN n.eff_aur
                        ELSE m.ccticketprice
                    END * ((1)::double precision - COALESCE(n.addoff, (0)::real))) * ((1)::double precision - COALESCE(m.corpaddoff, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_b
           FROM (( SELECT a_1.product,
                    a_1.org_channel,
                    a_1.dbt_wk,
                    a_1.last_rcpt_wk,
                    a_1.erlstmkdnwk,
                    a_1.exitdate,
                    a_1.ccmdstrategy,
                    a_1.ccdiscountpct,
                    a_1."time",
                    a_1.indx,
                    a_1.price_status,
                    a_1.seq,
                    a_1.style,
                    a_1.subclass,
                    a_1.class,
                    a_1.department,
                    a_1.division,
                    a_1.ccticketprice,
                    a_1.dbt_wk_indx,
                    a_1.last_rcpt_wk_indx,
                    a_1.erlstmkdnwk_indx,
                    a_1.flow_flag,
                    a_1.weekdate,
                    a_1.floorset,
                    a_1.num_sizes,
                    a_1.md_disc,
                    a_1.curp,
                    COALESCE(c_1.corpaddoff, (0)::real) AS corpaddoff,
                    COALESCE(c_1.corpexcl, (0)::real) AS corpexcl
                   FROM (( SELECT a_2.product,
                            a_2.org_channel,
                            a_2.dbt_wk,
                            a_2.last_rcpt_wk,
                            a_2.erlstmkdnwk,
                            a_2.exitdate,
                            a_2.ccmdstrategy,
                            a_2.ccdiscountpct,
                            a_2."time",
                            a_2.indx,
                            a_2.price_status,
                            a_2.seq,
                            a_2.style,
                            a_2.subclass,
                            a_2.class,
                            a_2.department,
                            a_2.division,
                            a_2.ccticketprice,
                            a_2.dbt_wk_indx,
                            a_2.last_rcpt_wk_indx,
                            a_2.erlstmkdnwk_indx,
                            a_2.flow_flag,
                            a_2.weekdate,
                            a_2.floorset,
                            a_2.num_sizes,
                            b_1.md_disc,
                            (a_2.ccticketprice * ((1)::double precision - b_1.md_disc)) AS curp
                           FROM (( SELECT z.product,
                                    z.org_channel,
                                    z.dbt_wk,
                                    z.last_rcpt_wk,
                                    z.erlstmkdnwk,
                                    z.exitdate,
                                    z.ccmdstrategy,
                                    z.ccdiscountpct,
                                    z."time",
                                    z.indx,
                                    z.price_status,
                                    z.seq,
                                    z.style,
                                    z.subclass,
                                    z.class,
                                    z.department,
                                    z.division,
                                    z.ccticketprice,
                                    z.dbt_wk_indx,
                                    z.last_rcpt_wk_indx,
                                    z.erlstmkdnwk_indx,
                                    z.flow_flag,
                                    z.weekdate,
                                    z.floorset,
                                    z.num_sizes
                                   FROM ( SELECT x.product,
    x.org_channel,
    x.dbt_wk,
    x.last_rcpt_wk,
    x.erlstmkdnwk,
    x.exitdate,
    x.ccmdstrategy,
    x.ccdiscountpct,
    x."time",
    x.indx,
    x.price_status,
    x.seq,
    x.style,
    x.subclass,
    x.class,
    x.department,
    x.division,
    x.ccticketprice,
    x.dbt_wk_indx,
    x.last_rcpt_wk_indx,
    x.erlstmkdnwk_indx,
    x.flow_flag,
    x.weekdate,
    x.floorset,
    x.num_sizes
   FROM ( SELECT a_3.product,
      a_3.location AS org_channel,
      COALESCE(a_3.relaunchweek, a_3.dbt_wk) AS dbt_wk,
      a_3.last_rcpt_wk,
      a_3.erlstmkdnwk,
      a_3.exitdate,
      a_3.ccmdstrategy,
      a_3.ccdiscountpct,
      b_2.id AS "time",
      b_2.indx,
    CASE
     WHEN (b_2.id < a_3.erlstmkdnwk) THEN 'FP'::text
     ELSE 'MD'::text
    END AS price_status,
      GREATEST(0, ((b_2.indx + 1) - dx.indx)) AS seq,
      c_2.ancestor0 AS style,
      c_2.ancestor1 AS subclass,
      c_2.ancestor2 AS class,
      c_2.ancestor3 AS department,
      c_2.ancestor5 AS division,
      d.sty_ticketpricechannel_base_gbp1 AS ccticketprice,
      bx.indx AS dbt_wk_indx,
      cx.indx AS last_rcpt_wk_indx,
      dx.indx AS erlstmkdnwk_indx,
    CASE
     WHEN ((b_2.indx >= bx.indx) AND (b_2.indx < (bx.indx + 4))) THEN 'NEW'::text
     ELSE
     CASE
      WHEN ((b_2.indx >= (bx.indx + 4)) AND (b_2.indx < (cx.indx + 4))) THEN 'FLOW'::text
      ELSE 'LOF'::text
     END
    END AS flow_flag,
      str_dt.start_date AS weekdate,
      dptflr.floorset,
      array_length(a_3.validsizes, 1) AS num_sizes
     FROM bd_ma_stylecolorchannelattributes a_3,
      bd_d_time b_2,
      bd_h_prodstd c_2,
      bd_ma_styleattributes d,
      bd_d_time bx,
      bd_d_time cx,
      bd_d_time dx,
      bd_ma_weekattributes str_dt,
      assort_period_from_dpt dptflr
    WHERE ((b_2.id >= COALESCE(a_3.relaunchweek, a_3.dbt_wk)) AND (b_2.id <= a_3.exitdate) AND (a_3.product = 'B1447GSP'::text) AND (b_2.levelid = 'week'::text) AND (c_2.id = a_3.product) AND (d.product = c_2.ancestor0) AND (a_3.dbt_wk = bx.id) AND (a_3.last_rcpt_wk = cx.id) AND (a_3.erlstmkdnwk = dx.id) AND (str_dt."time" = b_2.id) AND (dptflr.department = c_2.ancestor3) AND (b_2.id = dptflr."time") AND (b_2.id >= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_current'::text))) AND (b_2.id <= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_end'::text))))
    ORDER BY a_3.product, b_2.id) x,
    ( SELECT DISTINCT bd_h_locstd.ancestor2 AS org_channel
     FROM bd_h_locstd
    WHERE (bd_h_locstd.id IN ( SELECT bd_d_location.id
       FROM bd_d_location
      WHERE (bd_d_location.levelid = 'market'::text)))) y
  WHERE (x.org_channel = y.org_channel)) z) a_2
                             LEFT JOIN md_strategy b_1 ON (((a_2.seq = b_1.seq) AND (a_2.ccmdstrategy = b_1.mdstrategy) AND (a_2.department = b_1.department))))) a_1
                     LEFT JOIN bd_corpdisc c_1 ON (((a_1.subclass = c_1.product) AND (a_1."time" = c_1."time"))))) m
             LEFT JOIN bd_p_itemprice n ON (((m.product = n.product) AND (m."time" = n."time"))))) a,
    bd_ma_stylecolorattributes b,
    bd_ma_styleattributes c
  WHERE ((a.product = b.product) AND (a.style = c.product));


ALTER VIEW public.analytics_product_fcst_input_xx OWNER TO psql;

--
-- TOC entry 1088 (class 1259 OID 136957429)
-- Name: analytics_product_fcst_input_xxyz; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.analytics_product_fcst_input_xxyz AS
 SELECT a.product,
    a.selling_channel,
    a.store_count,
    a.flow_flag,
    a.weekdate,
    a.price_status,
    a.ccticketprice AS original_ticketprice,
    (LEAST(a.v_a, a.v_b))::numeric(16,2) AS selling_price,
    a.class,
    a.subclass,
    a.department,
    a.division,
    a.num_sizes AS sku_count,
    b.cc_sub_range,
    b.cc_applied_detail,
    b.cc_color_group,
    b.cc_sub_theme,
    b.cc_pattern,
    b.cc_collection,
    b.cc_fabric_yarn_type,
    b.cccw_age_gender,
    b.cc_price_banding_latest,
    b.cc_texture,
    b.cc_season_latest,
    b.cc_theme_latest,
    b.cc_weight,
    b.cc_archetype,
    b.cc_pattern_new,
    c.sty_fit_style,
    c.sty_rise,
    c.sty_heel_height,
    c.sty_footwear_type,
    c.sty_end_use,
    c.sty_dress_skirt_length,
    c.sty_neck_detail,
    c.sty_waist_detail,
    c.sty_skirt_shape,
    c.sty_sleeve_length,
    c.sty_sleeve_shape,
    c.sty_trouser_length,
    c.sty_trouser_shape,
    c.sty_packages,
    c.sty_shopzilla_rating,
    c.sty_price_band_style,
    c.sty_classification_latest,
    c.sty_age_style,
    c.sty_gender_style,
    c.sty_size_range AS size_range,
    b.cc_print_name
   FROM ( SELECT m.product,
            m.org_channel,
            m.dbt_wk,
            m.last_rcpt_wk,
            m.erlstmkdnwk,
            m.exitdate,
            m.ccmdstrategy,
            m.ccdiscountpct,
            m."time",
            m.indx,
            m.price_status,
            m.seq,
            m.style,
            m.subclass,
            m.class,
            m.department,
            m.division,
            m.ccticketprice,
            m.dbt_wk_indx,
            m.last_rcpt_wk_indx,
            m.erlstmkdnwk_indx,
            m.flow_flag,
            m.weekdate,
            m.floorset,
            m.num_sizes,
            m.channel,
            m.selling_channel,
            m.store_count,
            m.md_disc,
            m.curp,
            m.corpaddoff,
            m.corpexcl,
            n.eff_aur AS expressed_aur,
            n.addoff,
                CASE
                    WHEN (m.seq = 0) THEN (m.ccticketprice * ((1)::double precision - COALESCE(m.corpexcl, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_a,
                CASE
                    WHEN (m.seq = 0) THEN ((
                    CASE
                        WHEN (n.eff_aur > (0)::double precision) THEN n.eff_aur
                        ELSE m.ccticketprice
                    END * ((1)::double precision - COALESCE(n.addoff, (0)::real))) * ((1)::double precision - COALESCE(m.corpaddoff, (0)::real)))
                    ELSE (m.ccticketprice * ((1)::double precision - m.md_disc))
                END AS v_b
           FROM (( SELECT a_1.product,
                    a_1.org_channel,
                    a_1.dbt_wk,
                    a_1.last_rcpt_wk,
                    a_1.erlstmkdnwk,
                    a_1.exitdate,
                    a_1.ccmdstrategy,
                    a_1.ccdiscountpct,
                    a_1."time",
                    a_1.indx,
                    a_1.price_status,
                    a_1.seq,
                    a_1.style,
                    a_1.subclass,
                    a_1.class,
                    a_1.department,
                    a_1.division,
                    a_1.ccticketprice,
                    a_1.dbt_wk_indx,
                    a_1.last_rcpt_wk_indx,
                    a_1.erlstmkdnwk_indx,
                    a_1.flow_flag,
                    a_1.weekdate,
                    a_1.floorset,
                    a_1.num_sizes,
                    a_1.channel,
                    a_1.selling_channel,
                    a_1.store_count,
                    a_1.md_disc,
                    a_1.curp,
                    COALESCE(c_1.corpaddoff, (0)::real) AS corpaddoff,
                    COALESCE(c_1.corpexcl, (0)::real) AS corpexcl
                   FROM (( SELECT a_2.product,
                            a_2.org_channel,
                            a_2.dbt_wk,
                            a_2.last_rcpt_wk,
                            a_2.erlstmkdnwk,
                            a_2.exitdate,
                            a_2.ccmdstrategy,
                            a_2.ccdiscountpct,
                            a_2."time",
                            a_2.indx,
                            a_2.price_status,
                            a_2.seq,
                            a_2.style,
                            a_2.subclass,
                            a_2.class,
                            a_2.department,
                            a_2.division,
                            a_2.ccticketprice,
                            a_2.dbt_wk_indx,
                            a_2.last_rcpt_wk_indx,
                            a_2.erlstmkdnwk_indx,
                            a_2.flow_flag,
                            a_2.weekdate,
                            a_2.floorset,
                            a_2.num_sizes,
                            a_2.channel,
                            a_2.selling_channel,
                            a_2.store_count,
                            b_1.md_disc,
                            (a_2.ccticketprice * ((1)::double precision - b_1.md_disc)) AS curp
                           FROM (( SELECT z.product,
                                    z.org_channel,
                                    z.dbt_wk,
                                    z.last_rcpt_wk,
                                    z.erlstmkdnwk,
                                    z.exitdate,
                                    z.ccmdstrategy,
                                    z.ccdiscountpct,
                                    z."time",
                                    z.indx,
                                    z.price_status,
                                    z.seq,
                                    z.style,
                                    z.subclass,
                                    z.class,
                                    z.department,
                                    z.division,
                                    z.ccticketprice,
                                    z.dbt_wk_indx,
                                    z.last_rcpt_wk_indx,
                                    z.erlstmkdnwk_indx,
                                    z.flow_flag,
                                    z.weekdate,
                                    z.floorset,
                                    z.num_sizes,
                                    z.channel,
                                    z.selling_channel,
                                    asst.store_count
                                   FROM ( SELECT x.product,
    x.org_channel,
    x.dbt_wk,
    x.last_rcpt_wk,
    x.erlstmkdnwk,
    x.exitdate,
    x.ccmdstrategy,
    x.ccdiscountpct,
    x."time",
    x.indx,
    x.price_status,
    x.seq,
    x.style,
    x.subclass,
    x.class,
    x.department,
    x.division,
    x.ccticketprice,
    x.dbt_wk_indx,
    x.last_rcpt_wk_indx,
    x.erlstmkdnwk_indx,
    x.flow_flag,
    x.weekdate,
    x.floorset,
    x.num_sizes,
    y.channel,
    y.selling_channel
   FROM ( SELECT a_3.product,
      a_3.location AS org_channel,
      COALESCE(a_3.relaunchweek, a_3.dbt_wk) AS dbt_wk,
      a_3.last_rcpt_wk,
      a_3.erlstmkdnwk,
      a_3.exitdate,
      a_3.ccmdstrategy,
      a_3.ccdiscountpct,
      b_2.id AS "time",
      b_2.indx,
    CASE
     WHEN (b_2.id < a_3.erlstmkdnwk) THEN 'FP'::text
     ELSE 'MD'::text
    END AS price_status,
      GREATEST(0, ((b_2.indx + 1) - dx.indx)) AS seq,
      c_2.ancestor0 AS style,
      c_2.ancestor1 AS subclass,
      c_2.ancestor2 AS class,
      c_2.ancestor3 AS department,
      c_2.ancestor5 AS division,
      d.sty_ticketpricechannel_base_gbp1 AS ccticketprice,
      bx.indx AS dbt_wk_indx,
      cx.indx AS last_rcpt_wk_indx,
      dx.indx AS erlstmkdnwk_indx,
    CASE
     WHEN ((b_2.indx >= bx.indx) AND (b_2.indx < (bx.indx + 4))) THEN 'NEW'::text
     ELSE
     CASE
      WHEN ((b_2.indx >= (bx.indx + 4)) AND (b_2.indx < (cx.indx + 4))) THEN 'FLOW'::text
      ELSE 'LOF'::text
     END
    END AS flow_flag,
      str_dt.start_date AS weekdate,
      dptflr.floorset,
      array_length(a_3.validsizes, 1) AS num_sizes
     FROM bd_ma_stylecolorchannelattributes a_3,
      bd_d_time b_2,
      bd_h_prodstd c_2,
      bd_ma_styleattributes d,
      bd_d_time bx,
      bd_d_time cx,
      bd_d_time dx,
      bd_ma_weekattributes str_dt,
      assort_period_from_dpt dptflr
    WHERE ((b_2.id >= COALESCE(a_3.relaunchweek, a_3.dbt_wk)) AND (b_2.id <= a_3.exitdate) AND (a_3.product = 'B1447GSP'::text) AND (b_2.levelid = 'week'::text) AND (c_2.id = a_3.product) AND (d.product = c_2.ancestor0) AND (a_3.dbt_wk = bx.id) AND (a_3.last_rcpt_wk = cx.id) AND (a_3.erlstmkdnwk = dx.id) AND (str_dt."time" = b_2.id) AND (dptflr.department = c_2.ancestor3) AND (b_2.id = dptflr."time") AND (b_2.id >= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_current'::text))) AND (b_2.id <= ( SELECT bd_serviceparams.value
       FROM bd_serviceparams
      WHERE (bd_serviceparams.id = 'plan_end'::text))))
    ORDER BY a_3.product, b_2.id) x,
    ( SELECT DISTINCT bd_h_locstd.id AS selling_channel,
      bd_h_locstd.ancestor1 AS channel,
      bd_h_locstd.ancestor2 AS org_channel
     FROM bd_h_locstd
    WHERE (bd_h_locstd.id IN ( SELECT bd_d_location.id
       FROM bd_d_location
      WHERE (bd_d_location.levelid = 'market'::text)))) y
  WHERE (x.org_channel = y.org_channel)) z,
                                    bd_a_assortment asst
                                  WHERE ((asst.product = z.product) AND (asst.location = z.org_channel) AND (asst."time" = z.floorset) AND (asst.plan_type = 'plan'::text))) a_2
                             LEFT JOIN md_strategy b_1 ON (((a_2.seq = b_1.seq) AND (a_2.ccmdstrategy = b_1.mdstrategy) AND (a_2.department = b_1.department))))) a_1
                     LEFT JOIN bd_corpdisc c_1 ON (((a_1.subclass = c_1.product) AND (a_1."time" = c_1."time"))))) m
             LEFT JOIN bd_p_itemprice n ON (((m.product = n.product) AND (m."time" = n."time"))))) a,
    bd_ma_stylecolorattributes b,
    bd_ma_styleattributes c
  WHERE ((a.product = b.product) AND (a.style = c.product));


ALTER VIEW public.analytics_product_fcst_input_xxyz OWNER TO psql;

--
-- TOC entry 1089 (class 1259 OID 136957434)
-- Name: arc_bulkupload_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_a_assortment (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_a_assortment OWNER TO psql;

--
-- TOC entry 1090 (class 1259 OID 136957440)
-- Name: arc_bulkupload_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_d_product (
    id text,
    client_id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_d_product OWNER TO psql;

--
-- TOC entry 1091 (class 1259 OID 136957446)
-- Name: arc_bulkupload_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_h_prodstd (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_h_prodstd OWNER TO psql;

--
-- TOC entry 1092 (class 1259 OID 136957452)
-- Name: arc_bulkupload_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_sizeattributes (
    product text,
    parent_id text,
    size_id text,
    size_name text,
    sizeattribute text,
    isvalid integer,
    size_range_id text,
    size_range_desc text,
    price_group text,
    orig_price_uk real,
    orig_price_us real,
    orig_price_de real,
    orig_price_row real,
    current_price_uk real,
    current_price_us real,
    current_price_de real,
    current_price_row real,
    eventdate date,
    updated_at timestamp without time zone,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1093 (class 1259 OID 136957458)
-- Name: arc_bulkupload_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_styleattributes (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_ticketpricechannel_base_gbp1 real,
    sty_ticketpricechannel_base_gbp2 real,
    ccstylecreatedate text,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1094 (class 1259 OID 136957464)
-- Name: arc_bulkupload_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_stylecolorattributes (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    actual_launch_month text,
    launch_week text,
    actual_launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    us_price_band text,
    uk_price_band text
);


ALTER TABLE public.arc_bulkupload_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1095 (class 1259 OID 136957470)
-- Name: arc_bulkupload_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_stylecolorchannelattributes (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    hasbeenpatternedafter text,
    ticketprice_locked integer,
    __record_type text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1096 (class 1259 OID 136957476)
-- Name: archives_lifecycleparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_lifecycleparams (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    actual_launch_week text,
    planned_launch_week text,
    md_week text,
    exit_week text,
    pssr text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_lifecycleparams OWNER TO psql;

--
-- TOC entry 1097 (class 1259 OID 136957482)
-- Name: archives_optionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_optionattributes (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    price_banding_option text,
    archetype text,
    design_theme text,
    design_sub_theme text,
    detail text,
    fabric_type text,
    pattern text,
    pattern_type text,
    print_name text,
    product_pyramid_option text,
    theme text,
    weight_option text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_optionattributes OWNER TO psql;

--
-- TOC entry 1098 (class 1259 OID 136957488)
-- Name: archives_price; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_price (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    md_week text,
    fsp_gbp_ticket_1_override text,
    fsp_gbp_ticket_2_override text,
    eur_ticket_1_override text,
    eur_ticket_2_override text,
    usd_ticket_override text,
    aud_ticket_override text,
    fsp_gbp_ticket_1 text,
    fsp_gbp_ticket_2 text,
    eur_ticket_1 text,
    eur_ticket_2 text,
    usd_ticket text,
    aud_ticket text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_price OWNER TO psql;

--
-- TOC entry 1099 (class 1259 OID 136957494)
-- Name: archives_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_styleattributes (
    product text,
    style_name text,
    style_description text,
    is_published text,
    age_style text,
    building_blocks text,
    clothing_fit text,
    end_use text,
    footwear_heel_height text,
    footwear_type text,
    gender text,
    length_style text,
    neck_shape text,
    shape_name_package text,
    product_pyramid_style text,
    rise text,
    skirt_or_leg_shape text,
    sleeve_length text,
    sleeve_shape text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_styleattributes OWNER TO psql;

--
-- TOC entry 1100 (class 1259 OID 136957500)
-- Name: bd_a_assortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment_bk (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.bd_a_assortment_bk OWNER TO psql;

--
-- TOC entry 1101 (class 1259 OID 136957505)
-- Name: bd_a_assortment_bk20221005; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment_bk20221005 (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.bd_a_assortment_bk20221005 OWNER TO psql;

--
-- TOC entry 1102 (class 1259 OID 136957510)
-- Name: bd_a_assortment_bk20230417; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment_bk20230417 (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.bd_a_assortment_bk20230417 OWNER TO psql;

--
-- TOC entry 1103 (class 1259 OID 136957515)
-- Name: bd_a_assortment_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment_storecount (
    product text,
    "time" text,
    location text,
    grade text[],
    strchannel text[],
    strterritory text[],
    straccount text[],
    category text,
    department text,
    store_count integer
);


ALTER TABLE public.bd_a_assortment_storecount OWNER TO psql;

--
-- TOC entry 1104 (class 1259 OID 136957520)
-- Name: bd_a_assortment_test20231108; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_assortment_test20231108 (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.bd_a_assortment_test20231108 OWNER TO psql;

--
-- TOC entry 1105 (class 1259 OID 136957525)
-- Name: bd_a_sizeprofile_tbl_from_ch; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_a_sizeprofile_tbl_from_ch (
    ccrangecode text
);


ALTER TABLE public.bd_a_sizeprofile_tbl_from_ch OWNER TO psql;

--
-- TOC entry 1106 (class 1259 OID 136957530)
-- Name: bd_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_authorization (
    tenantid text DEFAULT 'TB01'::text,
    roleid text NOT NULL,
    authid text NOT NULL,
    access text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_authorization OWNER TO psql;

--
-- TOC entry 1107 (class 1259 OID 136957537)
-- Name: bd_c_conversion_file; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_conversion_file (
    option_id text NOT NULL,
    style_description text,
    channel text,
    territory text,
    account text,
    shop_grade text,
    cc_gbp1 real,
    cc_gbp2 real,
    cc_eur1 real,
    cc_eur2 real,
    cc_usd real,
    cc_aud real,
    cc_size_range text,
    cc_discount_pct real,
    cc_presmin real,
    cc_presmin_weeks real,
    cc_pssr real,
    md_strategy text,
    dbt_wk text,
    md_wk text,
    exitdate text,
    receipt_interval real
);


ALTER TABLE public.bd_c_conversion_file OWNER TO psql;

--
-- TOC entry 1108 (class 1259 OID 136957542)
-- Name: bd_c_conversion_file_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_conversion_file_lifecycle (
    option_id text,
    style_description text,
    channel text,
    territory text,
    account text,
    shop_grade text,
    cc_gbp1 real,
    cc_gbp2 real,
    cc_eur1 real,
    cc_eur2 real,
    cc_usd real,
    cc_aud real,
    cc_size_range text,
    cc_discount_pct real,
    cc_presmin real,
    cc_presmin_weeks real,
    cc_pssr real,
    md_strategy text,
    dbt_wk text,
    md_wk text,
    exitdate text,
    receipt_interval real,
    initrcptwk text,
    last_inv_wk text,
    last_rcpt_wk text,
    lastdcorder text,
    wac real,
    style text,
    category text,
    department text
);


ALTER TABLE public.bd_c_conversion_file_lifecycle OWNER TO psql;

--
-- TOC entry 1109 (class 1259 OID 136957547)
-- Name: bd_c_conversion_wac; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_conversion_wac (
    product text NOT NULL,
    wac real
);


ALTER TABLE public.bd_c_conversion_wac OWNER TO psql;

--
-- TOC entry 1110 (class 1259 OID 136957552)
-- Name: bd_c_cutover_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_cutover_existing (
    product text NOT NULL,
    style text,
    style_description text,
    subcategory text,
    category text,
    department text,
    segment text,
    division text,
    company text,
    isassortment text,
    initrcptwk text,
    dbt_wk text,
    last_inv_week text,
    erlstmkdnwk text,
    exitdate text,
    last_rcpt_wk text,
    wac real,
    channel text[],
    territory text[],
    account text[],
    grade text[]
);


ALTER TABLE public.bd_c_cutover_existing OWNER TO psql;

--
-- TOC entry 1111 (class 1259 OID 136957557)
-- Name: bd_c_cutover_existing_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_cutover_existing_prep (
    product text NOT NULL,
    style text,
    style_description text,
    subcategory text,
    category text,
    department text,
    segment text,
    division text,
    company text,
    isassortment text,
    initrcptwk text,
    dbt_wk text,
    last_inv_week text,
    erlstmkdnwk text,
    exitdate text,
    last_rcpt_wk text,
    wac real
);


ALTER TABLE public.bd_c_cutover_existing_prep OWNER TO psql;

--
-- TOC entry 1112 (class 1259 OID 136957562)
-- Name: bd_c_cutover_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_c_cutover_new (
    product text NOT NULL,
    levelid text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text,
    channel text,
    initrcptwk text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text
);


ALTER TABLE public.bd_c_cutover_new OWNER TO psql;

--
-- TOC entry 1113 (class 1259 OID 136957567)
-- Name: bd_colorgroup_color_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_colorgroup_color_mapping (
    cccolor text,
    cc_color_code text,
    "?column?" text
);


ALTER TABLE public.bd_colorgroup_color_mapping OWNER TO psql;

--
-- TOC entry 1114 (class 1259 OID 136957572)
-- Name: bd_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_corpdisc_backup (
    department text,
    product text,
    location text,
    "time" text,
    corpaddoff real,
    corpexcl real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_corpdisc_backup OWNER TO psql;

--
-- TOC entry 1115 (class 1259 OID 136957577)
-- Name: bd_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_cluster (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_d_cluster OWNER TO psql;

--
-- TOC entry 1116 (class 1259 OID 136957589)
-- Name: bd_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_prodlife (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_d_prodlife OWNER TO psql;

--
-- TOC entry 1117 (class 1259 OID 136957601)
-- Name: bd_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_product (
    id text NOT NULL,
    client_id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_d_product OWNER TO psql;

--
-- TOC entry 1118 (class 1259 OID 136957613)
-- Name: bd_d_product_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_product_intraday (
    id text,
    client_id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_d_product_intraday OWNER TO psql;

--
-- TOC entry 1119 (class 1259 OID 136957618)
-- Name: bd_d_product_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_product_intraday_delta (
    id text,
    client_id text,
    name text,
    description text,
    levelid text,
    indx text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_d_product_intraday_delta OWNER TO psql;

--
-- TOC entry 1120 (class 1259 OID 136957623)
-- Name: bd_d_product_test20230518; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_d_product_test20230518 (
    id text,
    client_id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_d_product_test20230518 OWNER TO psql;

--
-- TOC entry 1121 (class 1259 OID 136957628)
-- Name: bd_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_designimages (
    product text,
    img text
);


ALTER TABLE public.bd_designimages OWNER TO psql;

--
-- TOC entry 1122 (class 1259 OID 136957633)
-- Name: bd_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_eohdata_stylecolor (
    product text,
    channel text,
    eohu real
);


ALTER TABLE public.bd_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 1123 (class 1259 OID 136957638)
-- Name: bd_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_clusterstd OWNER TO psql;

--
-- TOC entry 1124 (class 1259 OID 136957650)
-- Name: bd_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_locdc OWNER TO psql;

--
-- TOC entry 1125 (class 1259 OID 136957662)
-- Name: bd_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_prodlifestd OWNER TO psql;

--
-- TOC entry 1126 (class 1259 OID 136957674)
-- Name: bd_h_prodstd_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_prodstd_intraday (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_h_prodstd_intraday OWNER TO psql;

--
-- TOC entry 1127 (class 1259 OID 136957679)
-- Name: bd_h_prodstd_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_prodstd_intraday_delta (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_h_prodstd_intraday_delta OWNER TO psql;

--
-- TOC entry 1128 (class 1259 OID 136957684)
-- Name: bd_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_timeflrset (
    id text NOT NULL,
    ancestor0 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_timeflrset OWNER TO psql;

--
-- TOC entry 1129 (class 1259 OID 136957696)
-- Name: bd_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_h_timestd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_h_timestd OWNER TO psql;

--
-- TOC entry 1130 (class 1259 OID 136957708)
-- Name: bd_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dclookup (
    channel text NOT NULL,
    dc text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_dclookup OWNER TO psql;

--
-- TOC entry 1131 (class 1259 OID 136957720)
-- Name: bd_l_dclookup20221109; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dclookup20221109 (
    channel text,
    dc text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_l_dclookup20221109 OWNER TO psql;

--
-- TOC entry 1132 (class 1259 OID 136957725)
-- Name: bd_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1133 (class 1259 OID 136957730)
-- Name: bd_l_dependencylookup2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup2 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text,
    myindex integer NOT NULL
);


ALTER TABLE public.bd_l_dependencylookup2 OWNER TO psql;

--
-- TOC entry 1134 (class 1259 OID 136957735)
-- Name: bd_l_dependencylookup20221007; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup20221007 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup20221007 OWNER TO psql;

--
-- TOC entry 1135 (class 1259 OID 136957740)
-- Name: bd_l_dependencylookup2_myindex_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.bd_l_dependencylookup2_myindex_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bd_l_dependencylookup2_myindex_seq OWNER TO psql;

--
-- TOC entry 7370 (class 0 OID 0)
-- Dependencies: 1135
-- Name: bd_l_dependencylookup2_myindex_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: psql
--

ALTER SEQUENCE public.bd_l_dependencylookup2_myindex_seq OWNED BY public.bd_l_dependencylookup2.myindex;


--
-- TOC entry 1136 (class 1259 OID 136957741)
-- Name: bd_l_dependencylookup_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup_bk (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup_bk OWNER TO psql;

--
-- TOC entry 1137 (class 1259 OID 136957746)
-- Name: bd_l_dependencylookup_bk20230120; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup_bk20230120 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup_bk20230120 OWNER TO psql;

--
-- TOC entry 1138 (class 1259 OID 136957751)
-- Name: bd_l_dependencylookup_bk20230502; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup_bk20230502 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup_bk20230502 OWNER TO psql;

--
-- TOC entry 1139 (class 1259 OID 136957756)
-- Name: bd_l_dependencylookup_bk20231122; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup_bk20231122 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup_bk20231122 OWNER TO psql;

--
-- TOC entry 1140 (class 1259 OID 136957761)
-- Name: bd_l_dependencylookup_bu062322; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_dependencylookup_bu062322 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.bd_l_dependencylookup_bu062322 OWNER TO psql;

--
-- TOC entry 1141 (class 1259 OID 136957766)
-- Name: bd_l_pricebandlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_pricebandlookup (
    currency_identifier text,
    product text,
    ticket_price_min real,
    ticket_price_max real,
    price_band text
);


ALTER TABLE public.bd_l_pricebandlookup OWNER TO psql;

--
-- TOC entry 1142 (class 1259 OID 136957771)
-- Name: bd_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_priceeventlookup (
    product text NOT NULL,
    location text NOT NULL,
    ccpriceevent text DEFAULT ''::text NOT NULL,
    expression text DEFAULT ''::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 1143 (class 1259 OID 136957785)
-- Name: bd_l_priceeventlookup_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_priceeventlookup_bk (
    product text,
    location text,
    ccpriceevent text,
    expression text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_l_priceeventlookup_bk OWNER TO psql;

--
-- TOC entry 1144 (class 1259 OID 136957790)
-- Name: bd_l_promodesclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_promodesclookup (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    description text DEFAULT 'NA'::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_promodesclookup OWNER TO psql;

--
-- TOC entry 1145 (class 1259 OID 136957803)
-- Name: bd_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_ssglookup (
    product text NOT NULL,
    location text NOT NULL,
    ssg_id text DEFAULT ''::text NOT NULL,
    ssg_name text DEFAULT ''::text,
    stores text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_ssglookup OWNER TO psql;

--
-- TOC entry 1146 (class 1259 OID 136957817)
-- Name: bd_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_storedclookup (
    store text NOT NULL,
    channel text NOT NULL,
    dc text NOT NULL,
    priority bigint NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_storedclookup OWNER TO psql;

--
-- TOC entry 1147 (class 1259 OID 136957829)
-- Name: bd_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_l_storelookup (
    "time" text NOT NULL,
    product text NOT NULL,
    id text DEFAULT ''::text NOT NULL,
    value text DEFAULT ''::text NOT NULL,
    stores text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_l_storelookup OWNER TO psql;

--
-- TOC entry 1148 (class 1259 OID 136957843)
-- Name: bd_ma_channelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_channelattributes (
    indx integer,
    location text,
    chnllatitude text,
    chnllongitude text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_ma_channelattributes OWNER TO psql;

--
-- TOC entry 1149 (class 1259 OID 136957849)
-- Name: bd_ma_channelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_channelattributes_bk (
    indx integer,
    location text,
    chnllatitude text,
    chnllongitude text,
    eventdate date
);


ALTER TABLE public.bd_ma_channelattributes_bk OWNER TO psql;

--
-- TOC entry 1150 (class 1259 OID 136957854)
-- Name: bd_ma_classattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_classattributes (
    indx integer,
    product text NOT NULL,
    clssubclassid text,
    clssubclassname text,
    clssubclassdesc text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_ma_classattributes OWNER TO psql;

--
-- TOC entry 1151 (class 1259 OID 136957866)
-- Name: bd_ma_classchnlattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_classchnlattributes (
    indx integer,
    product text,
    location text,
    promoelas real,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_ma_classchnlattributes OWNER TO psql;

--
-- TOC entry 1152 (class 1259 OID 136957872)
-- Name: bd_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_dptflrsetattributes (
    indx integer NOT NULL,
    product text NOT NULL,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.bd_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1153 (class 1259 OID 136957883)
-- Name: bd_ma_dptflrsetattributes_20230807; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_dptflrsetattributes_20230807 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.bd_ma_dptflrsetattributes_20230807 OWNER TO psql;

--
-- TOC entry 1154 (class 1259 OID 136957888)
-- Name: bd_ma_dptflrsetattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_dptflrsetattributes_bk (
    indx text,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.bd_ma_dptflrsetattributes_bk OWNER TO psql;

--
-- TOC entry 1155 (class 1259 OID 136957893)
-- Name: bd_ma_dptflrsetattributes_bk_20221025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_dptflrsetattributes_bk_20221025 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.bd_ma_dptflrsetattributes_bk_20221025 OWNER TO psql;

--
-- TOC entry 1156 (class 1259 OID 136957898)
-- Name: bd_ma_dptflrsetattributes_bu062222; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_dptflrsetattributes_bu062222 (
    indx text,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.bd_ma_dptflrsetattributes_bu062222 OWNER TO psql;

--
-- TOC entry 1157 (class 1259 OID 136957903)
-- Name: bd_ma_globalregionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_globalregionattributes (
    indx integer,
    location text,
    globalregionlatitude text,
    globalregionlongitude text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_ma_globalregionattributes OWNER TO psql;

--
-- TOC entry 1158 (class 1259 OID 136957909)
-- Name: bd_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_imgattributes (
    indx integer,
    product text NOT NULL,
    img text,
    eventdate date,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_ma_imgattributes OWNER TO psql;

--
-- TOC entry 1159 (class 1259 OID 136957920)
-- Name: bd_ma_imgattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_imgattributes_bk (
    indx text,
    product text,
    img text,
    eventdate date
);


ALTER TABLE public.bd_ma_imgattributes_bk OWNER TO psql;

--
-- TOC entry 1160 (class 1259 OID 136957925)
-- Name: bd_ma_imgattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_imgattributes_intraday (
    indx integer,
    product text,
    img text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_imgattributes_intraday OWNER TO psql;

--
-- TOC entry 1161 (class 1259 OID 136957930)
-- Name: bd_ma_imgattributes_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_imgattributes_test (
    indx integer,
    product text,
    img text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_imgattributes_test OWNER TO psql;

--
-- TOC entry 1162 (class 1259 OID 136957935)
-- Name: bd_ma_marketattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_marketattributes (
    indx integer,
    location text,
    marketlatitude text,
    marketlongitude text,
    eventdate date
);


ALTER TABLE public.bd_ma_marketattributes OWNER TO psql;

--
-- TOC entry 1163 (class 1259 OID 136957940)
-- Name: bd_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_sizeattributes (
    product text NOT NULL,
    parent_id text,
    size_id text DEFAULT '99999'::text,
    size_name text,
    sizeattribute text NOT NULL,
    isvalid integer DEFAULT 1,
    size_range_id text,
    size_range_desc text,
    price_group text,
    orig_price_uk real DEFAULT (0.01)::real,
    orig_price_us real DEFAULT (0.01)::real,
    orig_price_de real DEFAULT (0.01)::real,
    orig_price_row real DEFAULT (0.01)::real,
    current_price_uk real DEFAULT (0.01)::real,
    current_price_us real DEFAULT (0.01)::real,
    current_price_de real DEFAULT (0.01)::real,
    current_price_row real DEFAULT (0.01)::real,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1164 (class 1259 OID 136957957)
-- Name: bd_ma_sizeattributes_bk20231121; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_sizeattributes_bk20231121 (
    product text,
    parent_id text,
    size_id text,
    size_name text,
    sizeattribute text,
    isvalid integer,
    size_range_id text,
    size_range_desc text,
    price_group text,
    orig_price_uk real,
    orig_price_us real,
    orig_price_de real,
    orig_price_row real,
    current_price_uk real,
    current_price_us real,
    current_price_de real,
    current_price_row real,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.bd_ma_sizeattributes_bk20231121 OWNER TO psql;

--
-- TOC entry 1165 (class 1259 OID 136957962)
-- Name: bd_ma_sizeattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_sizeattributes_intraday (
    product text,
    parent_id text,
    size_id text,
    size_name text,
    sizeattribute text,
    isvalid integer,
    size_range_id text,
    size_range_desc text,
    price_group text,
    orig_price_uk real,
    orig_price_us real,
    orig_price_de real,
    orig_price_row real,
    current_price_uk real,
    current_price_us real,
    current_price_de real,
    current_price_row real,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.bd_ma_sizeattributes_intraday OWNER TO psql;

--
-- TOC entry 1166 (class 1259 OID 136957967)
-- Name: bd_ma_sizeattributes_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_sizeattributes_intraday_delta (
    product text,
    parent_id text,
    size_id text,
    size_name text,
    sizeattribute text,
    isvalid integer,
    size_range_id text,
    size_range_desc text,
    price_group text,
    orig_price_uk real,
    orig_price_us real,
    orig_price_de real,
    orig_price_row real,
    current_price_uk real,
    current_price_us real,
    current_price_de real,
    current_price_row real,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.bd_ma_sizeattributes_intraday_delta OWNER TO psql;

--
-- TOC entry 1167 (class 1259 OID 136957975)
-- Name: bd_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_storeattributes (
    location text NOT NULL,
    account text,
    region text,
    market text,
    territory text,
    selling_channel text,
    channel text,
    brand text,
    account_name text,
    region_name text,
    market_name text,
    territory_name text,
    selling_channel_name text,
    channel_name text,
    brand_name text,
    str_dc_or_store text,
    str_city text,
    str_state text,
    str_country text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    strlatitude text,
    strlongitude text,
    store_name text,
    strchannel text,
    strterritory text,
    straccount text,
    strgrade text
);


ALTER TABLE public.bd_ma_storeattributes OWNER TO psql;

--
-- TOC entry 1168 (class 1259 OID 136957987)
-- Name: bd_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_storeattributes_lat_long (
    indx integer,
    location text,
    strlatitude text,
    strlongitude text,
    eventdate date
);


ALTER TABLE public.bd_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 1169 (class 1259 OID 136957992)
-- Name: bd_ma_styleattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes_bk (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_styleattributes_bk OWNER TO psql;

--
-- TOC entry 1170 (class 1259 OID 136957997)
-- Name: bd_ma_styleattributes_bk_20220705; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes_bk_20220705 (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_styleattributes_bk_20220705 OWNER TO psql;

--
-- TOC entry 1171 (class 1259 OID 136958002)
-- Name: bd_ma_styleattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes_intraday (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_ticketpricechannel_base_gbp1 real,
    sty_ticketpricechannel_base_gbp2 real,
    ccstylecreatedate text
);


ALTER TABLE public.bd_ma_styleattributes_intraday OWNER TO psql;

--
-- TOC entry 1172 (class 1259 OID 136958007)
-- Name: bd_ma_styleattributes_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes_intraday_delta (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_ticketpricechannel_base_gbp1 real,
    sty_ticketpricechannel_base_gbp2 real,
    ccstylecreatedate text
);


ALTER TABLE public.bd_ma_styleattributes_intraday_delta OWNER TO psql;

--
-- TOC entry 1173 (class 1259 OID 136958012)
-- Name: bd_ma_styleattributes_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_styleattributes_test (
    product text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    sty_size_range text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_ticketpricechannel_base_gbp1 real,
    sty_ticketpricechannel_base_gbp2 real,
    ccstylecreatedate text
);


ALTER TABLE public.bd_ma_styleattributes_test OWNER TO psql;

--
-- TOC entry 1174 (class 1259 OID 136958017)
-- Name: bd_ma_stylecolorattributes_20240617; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_20240617 (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text
);


ALTER TABLE public.bd_ma_stylecolorattributes_20240617 OWNER TO psql;

--
-- TOC entry 1175 (class 1259 OID 136958022)
-- Name: bd_ma_stylecolorattributes_bk20221209; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_bk20221209 (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text
);


ALTER TABLE public.bd_ma_stylecolorattributes_bk20221209 OWNER TO psql;

--
-- TOC entry 1176 (class 1259 OID 136958027)
-- Name: bd_ma_stylecolorattributes_bk20230603; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_bk20230603 (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text
);


ALTER TABLE public.bd_ma_stylecolorattributes_bk20230603 OWNER TO psql;

--
-- TOC entry 1177 (class 1259 OID 136958032)
-- Name: bd_ma_stylecolorattributes_bu061322; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_bu061322 (
    product text,
    style text,
    subcategory text,
    category text,
    department text,
    segment text,
    division text,
    company text,
    stylecolor_name text,
    style_name text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    stylecolor_description text,
    style_description text,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real
);


ALTER TABLE public.bd_ma_stylecolorattributes_bu061322 OWNER TO psql;

--
-- TOC entry 1178 (class 1259 OID 136958037)
-- Name: bd_ma_stylecolorattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_intraday (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    actual_launch_month text,
    launch_week text,
    actual_launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text,
    us_price_band text,
    uk_price_band text
);


ALTER TABLE public.bd_ma_stylecolorattributes_intraday OWNER TO psql;

--
-- TOC entry 1179 (class 1259 OID 136958042)
-- Name: bd_ma_stylecolorattributes_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes_intraday_delta (
    product text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    launch_month text,
    launch_week text,
    cccolor text,
    cccolorfamily text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_color_code text,
    cc_color_group text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    cc_boden_landed_cost real,
    merch_comments text,
    plan_comments text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text
);


ALTER TABLE public.bd_ma_stylecolorattributes_intraday_delta OWNER TO psql;

--
-- TOC entry 1180 (class 1259 OID 136958047)
-- Name: bd_ma_stylecolorchannelattributes_20220824; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorchannelattributes_20220824 (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real
);


ALTER TABLE public.bd_ma_stylecolorchannelattributes_20220824 OWNER TO psql;

--
-- TOC entry 1181 (class 1259 OID 136958052)
-- Name: bd_ma_stylecolorchannelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorchannelattributes_bk (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    hasbeenpatternedafter text
);


ALTER TABLE public.bd_ma_stylecolorchannelattributes_bk OWNER TO psql;

--
-- TOC entry 1182 (class 1259 OID 136958057)
-- Name: bd_ma_stylecolorchannelattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorchannelattributes_intraday (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    hasbeenpatternedafter text,
    ticketprice_locked integer
);


ALTER TABLE public.bd_ma_stylecolorchannelattributes_intraday OWNER TO psql;

--
-- TOC entry 1183 (class 1259 OID 136958062)
-- Name: bd_ma_stylecolorchannelattributes_test20231108; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorchannelattributes_test20231108 (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    hasbeenpatternedafter text
);


ALTER TABLE public.bd_ma_stylecolorchannelattributes_test20231108 OWNER TO psql;

--
-- TOC entry 1184 (class 1259 OID 136958067)
-- Name: bd_ma_stylecolorphaseattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorphaseattributes (
    product text NOT NULL,
    style text,
    "time" text NOT NULL,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    eventdate date DEFAULT (now())::date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_stylecolorphaseattributes OWNER TO psql;

--
-- TOC entry 1185 (class 1259 OID 136958073)
-- Name: bd_ma_stylecolorphaseattributes_bk20230411; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorphaseattributes_bk20230411 (
    product text,
    style text,
    "time" text,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_stylecolorphaseattributes_bk20230411 OWNER TO psql;

--
-- TOC entry 1186 (class 1259 OID 136958078)
-- Name: bd_ma_stylecolorphaseattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorphaseattributes_intraday (
    product text,
    style text,
    "time" text,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_stylecolorphaseattributes_intraday OWNER TO psql;

--
-- TOC entry 1187 (class 1259 OID 136958083)
-- Name: bd_ma_stylecolorphaseattributes_intraday_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorphaseattributes_intraday_delta (
    product text,
    style text,
    "time" text,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_stylecolorphaseattributes_intraday_delta OWNER TO psql;

--
-- TOC entry 1188 (class 1259 OID 136958088)
-- Name: bd_ma_stylecolorphaseattributes_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorphaseattributes_test (
    product text,
    style text,
    "time" text,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_ma_stylecolorphaseattributes_test OWNER TO psql;

--
-- TOC entry 1189 (class 1259 OID 136958093)
-- Name: bd_ma_stylecolorpublishes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorpublishes (
    product text NOT NULL,
    is_published real,
    first_published_date date,
    is_prepublished real,
    first_prepublished_date date,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_ma_stylecolorpublishes OWNER TO psql;

--
-- TOC entry 1190 (class 1259 OID 136958100)
-- Name: bd_ma_stylecolorweekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorweekattributes (
    product text NOT NULL,
    style text,
    phase_id text,
    t_cc_planned_phase text,
    t_cc_phase_story text,
    t_cc_newness text,
    t_cc_cts text,
    t_cc_season text,
    t_cc_exposure text,
    t_sty_classification text,
    from_styletime text,
    "time" text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_ma_stylecolorweekattributes OWNER TO psql;

--
-- TOC entry 1191 (class 1259 OID 136958112)
-- Name: bd_ma_subclassattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_subclassattributes (
    indx integer,
    product text NOT NULL,
    conceptstyleid text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    conceptstylecolorid text
);


ALTER TABLE public.bd_ma_subclassattributes OWNER TO psql;

--
-- TOC entry 1192 (class 1259 OID 136958124)
-- Name: bd_ma_territoryattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_territoryattributes (
    indx integer,
    location text,
    territorylatitude text,
    territorylongitude text,
    eventdate date
);


ALTER TABLE public.bd_ma_territoryattributes OWNER TO psql;

--
-- TOC entry 1193 (class 1259 OID 136958129)
-- Name: bd_market_name_correction; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.bd_market_name_correction AS
 SELECT a.id,
    ((a.name || ' '::text) || b.name) AS name,
    ((a.description || ' '::text) || b.description) AS description
   FROM ( SELECT bd_d_location.id,
            bd_d_location.name,
            bd_d_location.description,
            bd_d_location.levelid,
            bd_d_location.indx,
            bd_d_location.eventdate,
            bd_d_location.version_id,
            bd_d_location.created_at,
            bd_d_location.created_by,
            bd_d_location.updated_at,
            bd_d_location.updated_by,
            bd_d_location.record_state
           FROM bd_d_location
          WHERE (bd_d_location.levelid = 'market'::text)) a,
    ( SELECT bd_d_location.id,
            bd_d_location.name,
            bd_d_location.description,
            bd_d_location.levelid,
            bd_d_location.indx,
            bd_d_location.eventdate,
            bd_d_location.version_id,
            bd_d_location.created_at,
            bd_d_location.created_by,
            bd_d_location.updated_at,
            bd_d_location.updated_by,
            bd_d_location.record_state
           FROM bd_d_location
          WHERE ((bd_d_location.id IN ( SELECT x.ancestor1
                   FROM ( SELECT bd_h_locstd.id,
                            bd_h_locstd.ancestor0,
                            bd_h_locstd.ancestor1,
                            bd_h_locstd.ancestor2,
                            bd_h_locstd.ancestor3,
                            bd_h_locstd.ancestor4,
                            bd_h_locstd.ancestor5,
                            bd_h_locstd.ancestor6,
                            bd_h_locstd.eventdate,
                            bd_h_locstd.version_id,
                            bd_h_locstd.created_at,
                            bd_h_locstd.created_by,
                            bd_h_locstd.updated_at,
                            bd_h_locstd.updated_by,
                            bd_h_locstd.record_state
                           FROM bd_h_locstd
                          WHERE (bd_h_locstd.id IN ( SELECT bd_d_location_1.id
                                   FROM bd_d_location bd_d_location_1
                                  WHERE (bd_d_location_1.levelid = 'market'::text)))) x)) AND (bd_d_location.name !~~* '%dummy%'::text))) b,
    ( SELECT bd_h_locstd.id,
            bd_h_locstd.ancestor0,
            bd_h_locstd.ancestor1,
            bd_h_locstd.ancestor2,
            bd_h_locstd.ancestor3,
            bd_h_locstd.ancestor4,
            bd_h_locstd.ancestor5,
            bd_h_locstd.ancestor6,
            bd_h_locstd.eventdate,
            bd_h_locstd.version_id,
            bd_h_locstd.created_at,
            bd_h_locstd.created_by,
            bd_h_locstd.updated_at,
            bd_h_locstd.updated_by,
            bd_h_locstd.record_state
           FROM bd_h_locstd
          WHERE (bd_h_locstd.id IN ( SELECT bd_d_location.id
                   FROM bd_d_location
                  WHERE (bd_d_location.levelid = 'market'::text)))) c
  WHERE ((a.id = c.id) AND (b.id = c.ancestor1));


ALTER VIEW public.bd_market_name_correction OWNER TO psql;

--
-- TOC entry 1194 (class 1259 OID 136958134)
-- Name: bd_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_channeloverride (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    weekadjaps real DEFAULT 0.0,
    weekadjslsu real DEFAULT 0.0,
    comments text DEFAULT ''::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    testpo text,
    floorsetpo text
);


ALTER TABLE public.bd_p_channeloverride OWNER TO psql;

--
-- TOC entry 1195 (class 1259 OID 136958149)
-- Name: bd_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_isedited real,
    dc_syscost real,
    dc_lndcst real,
    dc_sysvrp real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    dc_sc_useradj real,
    dc_sc_finrev real,
    po_indicator text,
    po_shipmode text,
    air_trigger text,
    cut text,
    published_at timestamp(0) without time zone,
    is_prepublished real,
    prepublished_at timestamp(0) without time zone,
    last_prepublished real
);


ALTER TABLE public.bd_p_dc_adj OWNER TO psql;

--
-- TOC entry 1196 (class 1259 OID 136958161)
-- Name: bd_p_dc_adj_pre_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_pre_existing (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_isedited real,
    dc_syscost real,
    dc_lndcst real,
    dc_sysvrp real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dc_sc_useradj real,
    dc_sc_finrev real,
    po_indicator text,
    po_shipmode text,
    air_trigger text,
    cut text,
    published_at timestamp(0) without time zone,
    is_prepublished real,
    prepublished_at timestamp(0) without time zone,
    last_prepublished real
);


ALTER TABLE public.bd_p_dc_adj_pre_existing OWNER TO psql;

--
-- TOC entry 1197 (class 1259 OID 136958166)
-- Name: bd_p_dc_adj_resync; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_resync (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_isedited real,
    dc_syscost real,
    dc_lndcst real,
    dc_sysvrp real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dc_sc_useradj real,
    dc_sc_finrev real,
    po_indicator text,
    po_shipmode text,
    air_trigger text,
    cut text,
    published_at timestamp(0) without time zone,
    is_prepublished real,
    prepublished_at timestamp(0) without time zone,
    last_prepublished real
);


ALTER TABLE public.bd_p_dc_adj_resync OWNER TO psql;

--
-- TOC entry 1198 (class 1259 OID 136958171)
-- Name: bd_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_size (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_scadj real,
    dc_ttluseradj real,
    dc_scfinrev real,
    dc_ttlfinrev real,
    dc_isedited real,
    eventdate date DEFAULT (now())::date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text,
    record_state smallint,
    dc_onorder_v real,
    dc_onorder_c real
);


ALTER TABLE public.bd_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 1199 (class 1259 OID 136958178)
-- Name: bd_p_dc_adj_size_pre_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_size_pre_existing (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_scadj real,
    dc_ttluseradj real,
    dc_scfinrev real,
    dc_ttlfinrev real,
    dc_isedited real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dc_onorder_v real,
    dc_onorder_c real
);


ALTER TABLE public.bd_p_dc_adj_size_pre_existing OWNER TO psql;

--
-- TOC entry 1200 (class 1259 OID 136958183)
-- Name: bd_p_dc_adj_size_temp_master_dc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_size_temp_master_dc (
    product text,
    location text,
    "time" text,
    dc_onorder real,
    dc_adjcost real
);


ALTER TABLE public.bd_p_dc_adj_size_temp_master_dc OWNER TO psql;

--
-- TOC entry 1201 (class 1259 OID 136958188)
-- Name: bd_p_dc_adj_temp_master_dc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_p_dc_adj_temp_master_dc (
    product text,
    location text,
    "time" text,
    dc_onorder real,
    dc_syscost real,
    dc_lndcst real
);


ALTER TABLE public.bd_p_dc_adj_temp_master_dc OWNER TO psql;

--
-- TOC entry 1202 (class 1259 OID 136958193)
-- Name: bd_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_pg_batch_validation (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value numeric(16,4),
    previous1_value numeric(16,4),
    previous2_value numeric(16,4),
    previous3_value numeric(16,4),
    previous4_value numeric(16,4),
    curr_prev_percentage_diff numeric(16,4),
    diff_percentage_threshold numeric(16,4),
    check_percentage_diff text,
    check_zero_value text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_pg_batch_validation OWNER TO psql;

--
-- TOC entry 1203 (class 1259 OID 136958199)
-- Name: bd_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_pg_batch_validation_archive (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value numeric(16,4),
    previous1_value numeric(16,4),
    previous2_value numeric(16,4),
    previous3_value numeric(16,4),
    previous4_value numeric(16,4),
    curr_prev_percentage_diff numeric(16,4),
    diff_percentage_threshold numeric(16,4),
    check_percentage_diff text,
    check_zero_value text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 1204 (class 1259 OID 136958205)
-- Name: bd_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_pg_batch_validation_failure (
    failure_message text,
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value numeric(16,4),
    previous1_value numeric(16,4),
    previous2_value numeric(16,4),
    previous3_value numeric(16,4),
    previous4_value numeric(16,4),
    curr_prev_percentage_diff numeric(16,4),
    diff_percentage_threshold numeric(16,4),
    check_percentage_diff text,
    check_zero_value text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 1205 (class 1259 OID 136958211)
-- Name: bd_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_pg_batch_validation_previous (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value numeric(16,4),
    previous1_value numeric(16,4),
    previous2_value numeric(16,4),
    previous3_value numeric(16,4),
    previous4_value numeric(16,4),
    curr_prev_percentage_diff numeric(16,4),
    diff_percentage_threshold numeric(16,4),
    check_percentage_diff text,
    check_zero_value text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.bd_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 1206 (class 1259 OID 136958217)
-- Name: bd_phase_season_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_phase_season_mapping (
    phase character varying(500),
    season character varying(500)
);


ALTER TABLE public.bd_phase_season_mapping OWNER TO psql;

--
-- TOC entry 1207 (class 1259 OID 136958222)
-- Name: bd_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_roledimension (
    tenantid text DEFAULT 'TB01'::text NOT NULL,
    roleid text NOT NULL,
    dimensionid text NOT NULL,
    levelids text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_roledimension OWNER TO psql;

--
-- TOC entry 1208 (class 1259 OID 136958229)
-- Name: bd_s5actualsinventory_inbound_closingstock; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_s5actualsinventory_inbound_closingstock (
    member_id character varying(16)
);


ALTER TABLE public.bd_s5actualsinventory_inbound_closingstock OWNER TO psql;

--
-- TOC entry 1209 (class 1259 OID 136958232)
-- Name: bd_s5bdreplanproducts_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_s5bdreplanproducts_delta (
    member_id text
);


ALTER TABLE public.bd_s5bdreplanproducts_delta OWNER TO psql;

--
-- TOC entry 1210 (class 1259 OID 136958237)
-- Name: bd_s5prodattrsize_inbound_prodvert20220505; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_s5prodattrsize_inbound_prodvert20220505 (
    member_id character varying(16),
    client_member_id character varying(16),
    size_code character varying(8),
    size_desc character varying(8),
    size_range_id character varying(128),
    size_range_desc character varying(128),
    orig_price_uk real,
    orig_price_us real,
    orig_price_de real,
    orig_price_row real,
    current_price_uk real,
    current_price_us real,
    current_price_de real,
    current_price_row real,
    "TIME_STAMP" character varying(32),
    isactive integer
);


ALTER TABLE public.bd_s5prodattrsize_inbound_prodvert20220505 OWNER TO psql;

--
-- TOC entry 1211 (class 1259 OID 136958240)
-- Name: bd_s5replannablestyleclr_inbound; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_s5replannablestyleclr_inbound (
    member_id text
);


ALTER TABLE public.bd_s5replannablestyleclr_inbound OWNER TO psql;

--
-- TOC entry 1212 (class 1259 OID 136958245)
-- Name: bd_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_servicedefn (
    service text NOT NULL,
    authlevels text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.bd_servicedefn OWNER TO psql;

--
-- TOC entry 1213 (class 1259 OID 136958251)
-- Name: bd_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.bd_sizinglookup OWNER TO psql;

--
-- TOC entry 1214 (class 1259 OID 136958256)
-- Name: bd_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.bd_specimages OWNER TO psql;

--
-- TOC entry 1215 (class 1259 OID 136958261)
-- Name: bd_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.bd_stylecolor_hier_attr AS
 SELECT a.product,
    a.product AS stylecolor,
    l1.description AS stylecolor_description,
    l2.id AS style,
    l2.description AS style_description,
    b.ancestor1 AS subcategory,
    b.ancestor2 AS category,
    b.ancestor3 AS department,
    b.ancestor4 AS segment,
    b.ancestor5 AS division,
    b.ancestor6 AS company,
    l1.name AS stylecolor_name,
    l2.name AS style_name,
    l3.name AS subcategory_name,
    l4.name AS category_name,
    l5.name AS department_name,
    l6.name AS segment_name,
    l7.name AS division_name,
    l8.name AS company_name,
    a.cc_sub_range,
    a.cc_applied_detail,
    a.cc_colour_group,
    a.cc_color_group,
    a.cc_sub_theme,
    a.cc_pattern,
    a.cc_print_name,
    a.cc_collection,
    a.cc_fabric_yarn_type,
    a.cccw_age_gender,
    a.cc_price_banding_latest,
    a.cc_texture,
    a.cc_season_latest,
    a.cc_classification_latest,
    a.cc_theme_latest,
    a.cc_weight,
    a.cc_archetype,
    a.cc_pattern_new,
    a.cc_ready_for_ranging,
    a.cc_active_flag,
    a.cc_boden_landed_cost,
    a.cc_supplier_1,
    a.cc_supplier_1_fob,
    a.cc_supplier_1_moq,
    a.cc_supplier_2,
    a.cc_supplier_2_fob,
    a.cc_supplier_2_moq,
    a.cc_supplier_3,
    a.cc_supplier_3_fob,
    a.cc_supplier_3_moq,
    c.sty_fit_style,
    c.sty_rise,
    c.sty_heel_height,
    c.sty_footwear_type,
    c.sty_end_use,
    c.sty_dress_skirt_length,
    c.sty_neck_detail,
    c.sty_waist_detail,
    c.sty_skirt_shape,
    c.sty_sleeve_length,
    c.sty_sleeve_shape,
    c.sty_trouser_length,
    c.sty_trouser_shape,
    c.sty_packages,
    c.sty_shopzilla_rating,
    c.sty_shopzilla_rating_count,
    c.sty_price_band_style,
    c.sty_classification_latest,
    c.sty_sub_range_style,
    c.sty_cw_age_gender_style,
    c.sty_age_style,
    c.sty_gender_style,
    c.sty_ready_for_ranging,
    c.sty_active_flag,
    a.launch_month,
    a.launch_week,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    a.isstyleremovable,
    check_ispublishable(a.product) AS ispublishable,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state,
    a.merch_comments,
    a.plan_comments,
    c.ccstylecreatedate,
    c.sty_size_range,
    check_isprepublishable(a.product) AS isprepublishable,
    a.us_price_band,
    a.uk_price_band
   FROM ((((((((((bd_ma_stylecolorattributes a
     JOIN bd_h_prodstd b ON ((a.product = b.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'stylecolor'::text)) l1 ON ((a.product = l1.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'style'::text)) l2 ON ((b.ancestor0 = l2.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'subclass'::text)) l3 ON ((b.ancestor1 = l3.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'class'::text)) l4 ON ((b.ancestor2 = l4.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'department'::text)) l5 ON ((b.ancestor3 = l5.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'segment'::text)) l6 ON ((b.ancestor4 = l6.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'division'::text)) l7 ON ((b.ancestor5 = l7.id)))
     JOIN ( SELECT bd_d_product.id,
            bd_d_product.name,
            bd_d_product.description
           FROM bd_d_product
          WHERE (bd_d_product.levelid = 'company'::text)) l8 ON ((b.ancestor6 = l8.id)))
     JOIN bd_ma_styleattributes c ON ((l2.id = c.product)));


ALTER VIEW public.bd_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 1216 (class 1259 OID 136958266)
-- Name: bd_stylecolortime_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.bd_stylecolortime_attr AS
 SELECT bd_ma_stylecolorweekattributes.product,
    bd_ma_stylecolorweekattributes.product AS stylecolor,
    bd_ma_stylecolorweekattributes.style,
    bd_ma_stylecolorweekattributes.phase_id,
    bd_ma_stylecolorweekattributes.t_cc_planned_phase,
    bd_ma_stylecolorweekattributes.t_cc_phase_story,
    bd_ma_stylecolorweekattributes.t_cc_newness,
    bd_ma_stylecolorweekattributes.t_cc_cts,
    bd_ma_stylecolorweekattributes.t_cc_season,
    bd_ma_stylecolorweekattributes.t_cc_exposure,
    bd_ma_stylecolorweekattributes.t_sty_classification,
    bd_ma_stylecolorweekattributes.from_styletime,
    bd_ma_stylecolorweekattributes."time",
    substr(bd_ma_stylecolorweekattributes.phase_id, 6, 10) AS phase_name,
    bd_ma_stylecolorweekattributes.eventdate,
    bd_ma_stylecolorweekattributes.version_id,
    bd_ma_stylecolorweekattributes.created_at,
    bd_ma_stylecolorweekattributes.created_by,
    bd_ma_stylecolorweekattributes.updated_at,
    bd_ma_stylecolorweekattributes.updated_by,
    bd_ma_stylecolorweekattributes.record_state
   FROM bd_ma_stylecolorweekattributes;


ALTER VIEW public.bd_stylecolortime_attr OWNER TO psql;

--
-- TOC entry 1217 (class 1259 OID 136958271)
-- Name: bd_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_swatches (
    attributeid text,
    validvalue text,
    datastr text,
    strtype text,
    type text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_swatches OWNER TO psql;

--
-- TOC entry 1218 (class 1259 OID 136958283)
-- Name: bd_territory_name_correction; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.bd_territory_name_correction AS
 SELECT a.id,
    ((a.name || ' '::text) || b.name) AS name,
    ((a.description || ' '::text) || b.description) AS description
   FROM ( SELECT bd_d_location.id,
            bd_d_location.name,
            bd_d_location.description,
            bd_d_location.levelid,
            bd_d_location.indx,
            bd_d_location.eventdate,
            bd_d_location.version_id,
            bd_d_location.created_at,
            bd_d_location.created_by,
            bd_d_location.updated_at,
            bd_d_location.updated_by,
            bd_d_location.record_state
           FROM bd_d_location
          WHERE (bd_d_location.levelid = 'territory'::text)) a,
    ( SELECT bd_d_location.id,
            bd_d_location.name,
            bd_d_location.description,
            bd_d_location.levelid,
            bd_d_location.indx,
            bd_d_location.eventdate,
            bd_d_location.version_id,
            bd_d_location.created_at,
            bd_d_location.created_by,
            bd_d_location.updated_at,
            bd_d_location.updated_by,
            bd_d_location.record_state
           FROM bd_d_location
          WHERE ((bd_d_location.id IN ( SELECT x.ancestor0
                   FROM ( SELECT bd_h_locstd.id,
                            bd_h_locstd.ancestor0,
                            bd_h_locstd.ancestor1,
                            bd_h_locstd.ancestor2,
                            bd_h_locstd.ancestor3,
                            bd_h_locstd.ancestor4,
                            bd_h_locstd.ancestor5,
                            bd_h_locstd.ancestor6,
                            bd_h_locstd.eventdate,
                            bd_h_locstd.version_id,
                            bd_h_locstd.created_at,
                            bd_h_locstd.created_by,
                            bd_h_locstd.updated_at,
                            bd_h_locstd.updated_by,
                            bd_h_locstd.record_state
                           FROM bd_h_locstd
                          WHERE (bd_h_locstd.id IN ( SELECT bd_d_location_1.id
                                   FROM bd_d_location bd_d_location_1
                                  WHERE (bd_d_location_1.levelid = 'territory'::text)))) x)) AND (bd_d_location.name !~~* '%dummy%'::text))) b,
    ( SELECT bd_h_locstd.id,
            bd_h_locstd.ancestor0,
            bd_h_locstd.ancestor1,
            bd_h_locstd.ancestor2,
            bd_h_locstd.ancestor3,
            bd_h_locstd.ancestor4,
            bd_h_locstd.ancestor5,
            bd_h_locstd.ancestor6,
            bd_h_locstd.eventdate,
            bd_h_locstd.version_id,
            bd_h_locstd.created_at,
            bd_h_locstd.created_by,
            bd_h_locstd.updated_at,
            bd_h_locstd.updated_by,
            bd_h_locstd.record_state
           FROM bd_h_locstd
          WHERE (bd_h_locstd.id IN ( SELECT bd_d_location.id
                   FROM bd_d_location
                  WHERE (bd_d_location.levelid = 'territory'::text)))) c
  WHERE ((a.id = c.id) AND (b.id = c.ancestor0));


ALTER VIEW public.bd_territory_name_correction OWNER TO psql;

--
-- TOC entry 1219 (class 1259 OID 136958288)
-- Name: bd_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1220 (class 1259 OID 136958300)
-- Name: bd_v_memberbasedvalidvalues_bk20221215; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues_bk20221215 (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_v_memberbasedvalidvalues_bk20221215 OWNER TO psql;

--
-- TOC entry 1221 (class 1259 OID 136958305)
-- Name: bd_v_memberbasedvalidvalues_bu062222; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues_bu062222 (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_v_memberbasedvalidvalues_bu062222 OWNER TO psql;

--
-- TOC entry 1222 (class 1259 OID 136958310)
-- Name: bd_v_memberbasedvalidvalues_bu070722; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues_bu070722 (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_v_memberbasedvalidvalues_bu070722 OWNER TO psql;

--
-- TOC entry 1223 (class 1259 OID 136958315)
-- Name: bd_v_memberbasedvalidvalues_slsrnk_pre_08292023; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues_slsrnk_pre_08292023 (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_v_memberbasedvalidvalues_slsrnk_pre_08292023 OWNER TO psql;

--
-- TOC entry 1224 (class 1259 OID 136958320)
-- Name: bd_v_memberbasedvalidvalues_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_v_memberbasedvalidvalues_temp (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.bd_v_memberbasedvalidvalues_temp OWNER TO psql;

--
-- TOC entry 1225 (class 1259 OID 136958325)
-- Name: bd_v_stylecolorchannelattributes; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.bd_v_stylecolorchannelattributes AS
 SELECT bd_ma_stylecolorchannelattributes.product,
    bd_ma_stylecolorchannelattributes.location,
    bd_ma_stylecolorchannelattributes.initrcptwk,
    bd_ma_stylecolorchannelattributes.dbt_wk,
    bd_ma_stylecolorchannelattributes.too,
    bd_ma_stylecolorchannelattributes.mkdnwks,
    bd_ma_stylecolorchannelattributes.last_inv_wk,
    bd_ma_stylecolorchannelattributes.lstfpwk,
    bd_ma_stylecolorchannelattributes.last_rcpt_wk,
    bd_ma_stylecolorchannelattributes.erlstmkdnwk,
    bd_ma_stylecolorchannelattributes.exitdate,
    bd_ma_stylecolorchannelattributes.lastdcorder,
    bd_ma_stylecolorchannelattributes.ccmdstrategy,
    bd_ma_stylecolorchannelattributes.ccordpolicy,
    bd_ma_stylecolorchannelattributes.ccrangecode,
    bd_ma_stylecolorchannelattributes.ssnprf,
    bd_ma_stylecolorchannelattributes.validsizes,
    bd_ma_stylecolorchannelattributes.adjaps,
    bd_ma_stylecolorchannelattributes.presmin_weeks,
    bd_ma_stylecolorchannelattributes.presmin,
    bd_ma_stylecolorchannelattributes.ccrcptint,
    bd_ma_stylecolorchannelattributes.ccordermultiple,
    bd_ma_stylecolorchannelattributes.ccdiscountpct,
    bd_ma_stylecolorchannelattributes.ccimupct,
    bd_ma_stylecolorchannelattributes.ccexistingwac,
    bd_ma_stylecolorchannelattributes.ccsystemcost,
    bd_ma_stylecolorchannelattributes.irw_indx,
    bd_ma_stylecolorchannelattributes.dbtwk_indx,
    bd_ma_stylecolorchannelattributes.mdstart_indx,
    bd_ma_stylecolorchannelattributes.lastdcorder_indx,
    bd_ma_stylecolorchannelattributes.exitdate_indx,
    bd_ma_stylecolorchannelattributes.slsrnk,
    bd_ma_stylecolorchannelattributes.relaunchweek,
    bd_ma_stylecolorchannelattributes.cc_plan_cost,
    bd_ma_stylecolorchannelattributes.cc_landed_cost,
    bd_ma_stylecolorchannelattributes.act_initrcptwk,
    bd_ma_stylecolorchannelattributes.act_dbt_wk,
    bd_ma_stylecolorchannelattributes.cc_flrset,
    bd_ma_stylecolorchannelattributes.cc_season,
    bd_ma_stylecolorchannelattributes.cc_target_cost,
    bd_ma_stylecolorchannelattributes.inseason_adjaps,
    bd_ma_stylecolorchannelattributes.smoothing_strategy,
    bd_ma_stylecolorchannelattributes.in_season_flag,
    bd_ma_stylecolorchannelattributes.lifecycle_applied,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_gbp1,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_gbp2,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_usd,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_eur1,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_eur2,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_base_aud,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_gbp1,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_gbp2,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_usd,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_eur1,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_eur2,
    bd_ma_stylecolorchannelattributes.ccticketpricechannel_override_aud,
    bd_ma_stylecolorchannelattributes.cc_fob_cost,
    bd_ma_stylecolorchannelattributes.eventdate,
    bd_ma_stylecolorchannelattributes.version_id,
    bd_ma_stylecolorchannelattributes.created_at,
    bd_ma_stylecolorchannelattributes.created_by,
    bd_ma_stylecolorchannelattributes.updated_at,
    bd_ma_stylecolorchannelattributes.updated_by,
    bd_ma_stylecolorchannelattributes.record_state,
    bd_ma_stylecolorchannelattributes.cc_return_u_pct,
        CASE
            WHEN bd_ma_stylecolorchannelattributes.auto_rollforward THEN 0
            ELSE 1
        END AS auto_rollforward,
    bd_ma_stylecolorchannelattributes.irr_mode,
    bd_ma_stylecolorchannelattributes.plan_current,
    bd_ma_stylecolorchannelattributes.hasbeenpatternedafter
   FROM bd_ma_stylecolorchannelattributes;


ALTER VIEW public.bd_v_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1226 (class 1259 OID 136958330)
-- Name: bi_assortmentbyfloorset_staging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bi_assortmentbyfloorset_staging (
    run_id integer,
    row_id integer,
    stylecolor_id text,
    stylecolor_name text,
    stylecolor_description text,
    floorset text,
    channel text,
    color_name text,
    pricing_tier text,
    editable_plan_cost real,
    wac real,
    status text,
    editable_preseason_sales_rating real,
    initial_rec_week text,
    editable_debut_week text,
    relaunch_week text,
    editable_markdown_week text,
    editable_exit_week text,
    last_dc_order_week text,
    editable_markdown_strategy text,
    editable_debut_floorset text,
    store_count_average integer,
    editable_store_vol_tier_dept text[],
    editable_climate text[],
    editable_capacity_mens text[],
    editable_capacity_womens text[],
    editable_ssg integer,
    editable_is_funded text,
    ticket_price real,
    unconstrained_sales_u integer,
    sales_u_override integer,
    final_sales_u integer,
    final_aps_u real,
    final_sales_r real,
    final_sales_c real,
    system_rec_u integer,
    rec_u_override integer,
    on_order_u integer,
    on_order_u_override integer,
    final_rec_u integer,
    dc_receipt_c real,
    boh_u integer,
    eoh_u integer,
    total_stock_to_sales real,
    margin_r real,
    margin_percent real
);


ALTER TABLE public.bi_assortmentbyfloorset_staging OWNER TO psql;

--
-- TOC entry 1227 (class 1259 OID 136958335)
-- Name: bi_assortmentbyfloorset_summary; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bi_assortmentbyfloorset_summary (
    run_id integer,
    row_id integer,
    stylecolor_id text,
    stylecolor_name text,
    stylecolor_description text,
    floorset text,
    channel text,
    color_name text,
    pricing_tier text,
    editable_plan_cost real,
    wac real,
    status text,
    editable_preseason_sales_rating real,
    initial_rec_week text,
    editable_debut_week text,
    relaunch_week text,
    editable_markdown_week text,
    editable_exit_week text,
    last_dc_order_week text,
    editable_markdown_strategy text,
    editable_debut_floorset text,
    store_count_average integer,
    editable_store_vol_tier_dept text[],
    editable_climate text[],
    editable_capacity_mens text[],
    editable_capacity_womens text[],
    editable_ssg integer,
    editable_is_funded text,
    ticket_price real,
    unconstrained_sales_u integer,
    sales_u_override integer,
    final_sales_u integer,
    final_aps_u real,
    final_sales_r real,
    final_sales_c real,
    system_rec_u integer,
    rec_u_override integer,
    on_order_u integer,
    on_order_u_override integer,
    final_rec_u integer,
    dc_receipt_c real,
    boh_u integer,
    eoh_u integer,
    total_stock_to_sales real,
    margin_r real,
    margin_percent real,
    validation_status text,
    reason text[]
);


ALTER TABLE public.bi_assortmentbyfloorset_summary OWNER TO psql;

--
-- TOC entry 1228 (class 1259 OID 136958340)
-- Name: bulk_import_audit; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_audit (
    run_id integer NOT NULL,
    principle text NOT NULL,
    run_time timestamp with time zone NOT NULL,
    bulk_import_id text NOT NULL
);


ALTER TABLE public.bulk_import_audit OWNER TO psql;

--
-- TOC entry 1229 (class 1259 OID 136958345)
-- Name: bulk_import_refs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_refs (
    user_id text NOT NULL,
    import_id text NOT NULL,
    transaction_id text NOT NULL,
    storage_path text
);


ALTER TABLE public.bulk_import_refs OWNER TO psql;

--
-- TOC entry 1230 (class 1259 OID 136958350)
-- Name: bulk_import_run_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_run_params (
    run_id integer NOT NULL,
    param text NOT NULL,
    str_value text
);


ALTER TABLE public.bulk_import_run_params OWNER TO psql;

--
-- TOC entry 1231 (class 1259 OID 136958355)
-- Name: bulk_run_id_sequence; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.bulk_run_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bulk_run_id_sequence OWNER TO psql;

--
-- TOC entry 1232 (class 1259 OID 136958356)
-- Name: cart_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master (
    jsessionid text,
    style_sequence text,
    style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    isprocessed integer DEFAULT 0,
    initiator text,
    img text,
    job_priority integer DEFAULT 2
);


ALTER TABLE public.cart_master OWNER TO psql;

--
-- TOC entry 1233 (class 1259 OID 136958363)
-- Name: cart_master_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_archive (
    jsessionid text,
    style_sequence text,
    style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    isprocessed integer DEFAULT 0,
    initiator text,
    img text,
    job_priority integer DEFAULT 2
);


ALTER TABLE public.cart_master_archive OWNER TO psql;

--
-- TOC entry 1234 (class 1259 OID 136958370)
-- Name: cart_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    initrcptwk text,
    dbt_wk text,
    too integer,
    mkdnwks integer,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    ccmdstrategy text,
    presmin integer,
    presmin_weeks integer,
    ccrcptint text,
    ccordermultiple text,
    ccordpolicy text
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 1235 (class 1259 OID 136958375)
-- Name: cart_params_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    initrcptwk text,
    dbt_wk text,
    too integer,
    mkdnwks integer,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    ccmdstrategy text,
    presmin integer,
    presmin_weeks integer,
    ccrcptint text,
    ccordermultiple text,
    ccordpolicy text
);


ALTER TABLE public.cart_params_archive OWNER TO psql;

--
-- TOC entry 1236 (class 1259 OID 136958380)
-- Name: cart_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_queue (
    cart_id text NOT NULL,
    user_id text NOT NULL,
    scope_id uuid NOT NULL,
    state queue_state NOT NULL,
    error_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cart_queue OWNER TO psql;

--
-- TOC entry 1237 (class 1259 OID 136958387)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    grade text[],
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    strchannel text,
    strterritory text,
    straccount text
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 1238 (class 1259 OID 136958392)
-- Name: cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    grade text[],
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    strchannel text,
    strterritory text,
    straccount text
);


ALTER TABLE public.cart_ranging_archive OWNER TO psql;

--
-- TOC entry 1239 (class 1259 OID 136958397)
-- Name: corpdisc_from_boden; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.corpdisc_from_boden (
    product text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.corpdisc_from_boden OWNER TO psql;

--
-- TOC entry 1240 (class 1259 OID 136958402)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO psql;

--
-- TOC entry 1241 (class 1259 OID 136958407)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO psql;

--
-- TOC entry 1242 (class 1259 OID 136958410)
-- Name: dc_adj118dc858af1a4a37b8a85436d3ca5e8e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj118dc858af1a4a37b8a85436d3ca5e8e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj118dc858af1a4a37b8a85436d3ca5e8e OWNER TO psql;

--
-- TOC entry 1243 (class 1259 OID 136958415)
-- Name: dc_adj2973fe04598a4392900a64b2eae20eec; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj2973fe04598a4392900a64b2eae20eec (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj2973fe04598a4392900a64b2eae20eec OWNER TO psql;

--
-- TOC entry 1244 (class 1259 OID 136958420)
-- Name: dc_adj36bee73525a6417ba85a52653069782e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj36bee73525a6417ba85a52653069782e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj36bee73525a6417ba85a52653069782e OWNER TO psql;

--
-- TOC entry 1245 (class 1259 OID 136958425)
-- Name: dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5 OWNER TO psql;

--
-- TOC entry 1246 (class 1259 OID 136958430)
-- Name: dc_adj5b984a493a54473c8a67bf0b9c577a36; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj5b984a493a54473c8a67bf0b9c577a36 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj5b984a493a54473c8a67bf0b9c577a36 OWNER TO psql;

--
-- TOC entry 1247 (class 1259 OID 136958435)
-- Name: dc_adj7b4f9674bd6740469592d986ad488af2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj7b4f9674bd6740469592d986ad488af2 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj7b4f9674bd6740469592d986ad488af2 OWNER TO psql;

--
-- TOC entry 1248 (class 1259 OID 136958440)
-- Name: dc_adj96da36850c474873a032da718ecc2330; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj96da36850c474873a032da718ecc2330 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj96da36850c474873a032da718ecc2330 OWNER TO psql;

--
-- TOC entry 1249 (class 1259 OID 136958445)
-- Name: dc_adjcc9dc91b484b44fcad0dd8a81db3b727; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjcc9dc91b484b44fcad0dd8a81db3b727 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjcc9dc91b484b44fcad0dd8a81db3b727 OWNER TO psql;

--
-- TOC entry 1250 (class 1259 OID 136958450)
-- Name: dc_adjf6b910bcc96b4a72bd481286b530d9c7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjf6b910bcc96b4a72bd481286b530d9c7 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjf6b910bcc96b4a72bd481286b530d9c7 OWNER TO psql;

--
-- TOC entry 1251 (class 1259 OID 136958455)
-- Name: dc_adjf81d06ee327d4c988bb4667653210585; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjf81d06ee327d4c988bb4667653210585 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjf81d06ee327d4c988bb4667653210585 OWNER TO psql;

--
-- TOC entry 1252 (class 1259 OID 136958460)
-- Name: dc_adjfef7258575ee48089181daf003e6e77d; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjfef7258575ee48089181daf003e6e77d (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjfef7258575ee48089181daf003e6e77d OWNER TO psql;

--
-- TOC entry 1253 (class 1259 OID 136958465)
-- Name: dc_adjfffd125e07344cd9b3ac7e3c44de8244; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjfffd125e07344cd9b3ac7e3c44de8244 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    is_prepublished text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjfffd125e07344cd9b3ac7e3c44de8244 OWNER TO psql;

--
-- TOC entry 1254 (class 1259 OID 136958470)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 1255 (class 1259 OID 136958475)
-- Name: default_cart_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_cart_params (
    jsessionid text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    grade text[],
    ssg text[],
    flnrange text[],
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[]
);


ALTER TABLE public.default_cart_params OWNER TO psql;

--
-- TOC entry 1256 (class 1259 OID 136958480)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    department text,
    default_discount numeric(16,4),
    default_md text
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 1257 (class 1259 OID 136958485)
-- Name: deleteme_bd_l_dependencylookup_20231017; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_bd_l_dependencylookup_20231017 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text
);


ALTER TABLE public.deleteme_bd_l_dependencylookup_20231017 OWNER TO psql;

--
-- TOC entry 1258 (class 1259 OID 136958490)
-- Name: deleteme_bd_ma_dptflrsetattributes_20231013; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_bd_ma_dptflrsetattributes_20231013 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.deleteme_bd_ma_dptflrsetattributes_20231013 OWNER TO psql;

--
-- TOC entry 1259 (class 1259 OID 136958495)
-- Name: deleteme_bd_ma_stylecolorchannelattributes_20230616; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_bd_ma_stylecolorchannelattributes_20230616 (
    product text,
    location text,
    initrcptwk text,
    dbt_wk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    erlstmkdnwk text,
    exitdate text,
    lastdcorder text,
    ccmdstrategy text,
    ccordpolicy text,
    ccrangecode text,
    ssnprf text,
    validsizes text[],
    adjaps real,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccdiscountpct real,
    ccimupct real,
    ccexistingwac real,
    ccsystemcost real,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    act_initrcptwk text,
    act_dbt_wk text,
    cc_flrset text,
    cc_season text,
    cc_target_cost real,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_gbp2 real,
    ccticketpricechannel_base_usd real,
    ccticketpricechannel_base_eur1 real,
    ccticketpricechannel_base_eur2 real,
    ccticketpricechannel_base_aud real,
    ccticketpricechannel_override_gbp1 real,
    ccticketpricechannel_override_gbp2 real,
    ccticketpricechannel_override_usd real,
    ccticketpricechannel_override_eur1 real,
    ccticketpricechannel_override_eur2 real,
    ccticketpricechannel_override_aud real,
    cc_fob_cost real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    hasbeenpatternedafter text
);


ALTER TABLE public.deleteme_bd_ma_stylecolorchannelattributes_20230616 OWNER TO psql;

--
-- TOC entry 1260 (class 1259 OID 136958500)
-- Name: deleteme_bd_ma_weekattributes_20251006; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_bd_ma_weekattributes_20251006 (
    "time" text,
    start_date text,
    end_date text,
    eventdate date
);


ALTER TABLE public.deleteme_bd_ma_weekattributes_20251006 OWNER TO psql;

--
-- TOC entry 1261 (class 1259 OID 136958505)
-- Name: deleteme_failed_items_20250330; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_failed_items_20250330 (
    jobid uuid,
    product text,
    location text,
    initiator text,
    initiated_at timestamp with time zone,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone,
    priority integer
);


ALTER TABLE public.deleteme_failed_items_20250330 OWNER TO psql;

--
-- TOC entry 1262 (class 1259 OID 136958510)
-- Name: deleteme_sup1064_20231211; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_sup1064_20231211 (
    department_name text,
    product text,
    old_indx integer,
    new_indx integer,
    old_phase text,
    new_phase text,
    department text,
    location text
);


ALTER TABLE public.deleteme_sup1064_20231211 OWNER TO psql;

--
-- TOC entry 1263 (class 1259 OID 136958515)
-- Name: deleteme_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_v_memberbasedvalidvalues (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.deleteme_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1264 (class 1259 OID 136958520)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 1265 (class 1259 OID 136958525)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 1266 (class 1259 OID 136958530)
-- Name: dept_plan_items_20230605; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_20230605 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_20230605 OWNER TO psql;

--
-- TOC entry 1267 (class 1259 OID 136958535)
-- Name: dept_plan_items_20231101; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_20231101 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_20231101 OWNER TO psql;

--
-- TOC entry 1268 (class 1259 OID 136958540)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 1269 (class 1259 OID 136958545)
-- Name: dept_plan_items_adhoc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_adhoc (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_adhoc OWNER TO psql;

--
-- TOC entry 1270 (class 1259 OID 136958550)
-- Name: dept_plan_items_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_archives (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_archives OWNER TO psql;

--
-- TOC entry 1271 (class 1259 OID 136958555)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 1272 (class 1259 OID 136958560)
-- Name: dept_plan_items_failed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_failed (
    product text
);


ALTER TABLE public.dept_plan_items_failed OWNER TO psql;

--
-- TOC entry 1273 (class 1259 OID 136958565)
-- Name: dept_plan_items_new16; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_new16 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_new16 OWNER TO psql;

--
-- TOC entry 1274 (class 1259 OID 136958570)
-- Name: dept_plan_items_weekly_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_weekly_backup (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_weekly_backup OWNER TO psql;

--
-- TOC entry 1275 (class 1259 OID 136958575)
-- Name: dept_var; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_var (
    ancestor3 text
);


ALTER TABLE public.dept_var OWNER TO psql;

--
-- TOC entry 1276 (class 1259 OID 136958580)
-- Name: dev_session; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dev_session (
    session_id text NOT NULL,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    alive_at timestamp with time zone DEFAULT now() NOT NULL,
    target_user_id text
);


ALTER TABLE public.dev_session OWNER TO psql;

--
-- TOC entry 1277 (class 1259 OID 136958587)
-- Name: eve_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.eve_ma_dptflrsetattributes (
    indx integer NOT NULL,
    product text,
    "time" text,
    floorset_name text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    too integer,
    ly_rcptstart text,
    ly_rcptend text,
    ly_slsstart text,
    ly_slsend text,
    ap_start text,
    ap_end text,
    default_discount text,
    default_ccmdstrategy text,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    floorset_attribute text,
    ly_floorset_attribute text,
    lly_floorset_attribute text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.eve_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1278 (class 1259 OID 136958599)
-- Name: favorites; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.favorites (
    key text NOT NULL,
    user_id text NOT NULL,
    module text NOT NULL,
    favorite_name text NOT NULL,
    version integer NOT NULL,
    json_blob json NOT NULL,
    active boolean
);


ALTER TABLE public.favorites OWNER TO psql;

--
-- TOC entry 1279 (class 1259 OID 136958604)
-- Name: metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone
);


ALTER TABLE public.metadata OWNER TO psql;

--
-- TOC entry 1280 (class 1259 OID 136958609)
-- Name: mfp_currency_exchange_rates_bk20231106; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.mfp_currency_exchange_rates_bk20231106 (
    "time" text,
    location text,
    exchange_ratio double precision,
    currency_id text
);


ALTER TABLE public.mfp_currency_exchange_rates_bk20231106 OWNER TO psql;

--
-- TOC entry 1281 (class 1259 OID 136958614)
-- Name: paged_pivot_blacklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.paged_pivot_blacklist (
    pivot_request_id uuid NOT NULL,
    parameter text NOT NULL,
    blacklisted_values text[] NOT NULL
);


ALTER TABLE public.paged_pivot_blacklist OWNER TO psql;

--
-- TOC entry 7371 (class 0 OID 0)
-- Dependencies: 1281
-- Name: TABLE paged_pivot_blacklist; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.paged_pivot_blacklist IS 'blacklist filters for paged-pivots';


--
-- TOC entry 7372 (class 0 OID 0)
-- Dependencies: 1281
-- Name: COLUMN paged_pivot_blacklist.pivot_request_id; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_blacklist.pivot_request_id IS 'UUID of the paged pivot ID';


--
-- TOC entry 1282 (class 1259 OID 136958619)
-- Name: paged_pivot_cache; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.paged_pivot_cache (
    pivot_request_id uuid NOT NULL,
    pivot_page jsonb,
    page_index bigint NOT NULL,
    page_group uuid NOT NULL
);


ALTER TABLE public.paged_pivot_cache OWNER TO psql;

--
-- TOC entry 7373 (class 0 OID 0)
-- Dependencies: 1282
-- Name: TABLE paged_pivot_cache; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.paged_pivot_cache IS 'stores paged pivot results';


--
-- TOC entry 7374 (class 0 OID 0)
-- Dependencies: 1282
-- Name: COLUMN paged_pivot_cache.pivot_request_id; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_cache.pivot_request_id IS 'UUID in string format';


--
-- TOC entry 1283 (class 1259 OID 136958624)
-- Name: paged_pivot_meta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.paged_pivot_meta (
    pivot_request_id uuid NOT NULL,
    num_pages integer,
    session_id character varying(255),
    page_agg_by character varying(255)[],
    root_agg_by character varying(255)[],
    request_status paged_pivot_status DEFAULT 'pending'::paged_pivot_status NOT NULL,
    error_msg text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.paged_pivot_meta OWNER TO psql;

--
-- TOC entry 7375 (class 0 OID 0)
-- Dependencies: 1283
-- Name: TABLE paged_pivot_meta; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.paged_pivot_meta IS 'metadata for outstanding paged_pivot requests';


--
-- TOC entry 7376 (class 0 OID 0)
-- Dependencies: 1283
-- Name: COLUMN paged_pivot_meta.num_pages; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_meta.num_pages IS 'total number of pages across all groups';


--
-- TOC entry 7377 (class 0 OID 0)
-- Dependencies: 1283
-- Name: COLUMN paged_pivot_meta.session_id; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_meta.session_id IS 'session_id for the app the user is in.';


--
-- TOC entry 7378 (class 0 OID 0)
-- Dependencies: 1283
-- Name: COLUMN paged_pivot_meta.page_agg_by; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_meta.page_agg_by IS 'the prefix of the aggBy parameter which describes the levels of the root tree.';


--
-- TOC entry 7379 (class 0 OID 0)
-- Dependencies: 1283
-- Name: COLUMN paged_pivot_meta.root_agg_by; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.paged_pivot_meta.root_agg_by IS 'the suffix of aggBy parameter which describes the levels of the pages.';


--
-- TOC entry 1284 (class 1259 OID 136958631)
-- Name: perf_assortperiod_week_pg_06192023; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week_pg_06192023 AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT bd_ma_dptflrsetattributes.product,
            bd_ma_dptflrsetattributes."time",
            bd_ma_dptflrsetattributes.slsstart,
            bd_ma_dptflrsetattributes.slsend
           FROM bd_ma_dptflrsetattributes) a,
    bd_d_time b
  WHERE ((b.levelid = 'week'::text) AND (b.id >= a.slsstart) AND (b.id <= a.slsend));


ALTER VIEW public.perf_assortperiod_week_pg_06192023 OWNER TO psql;

--
-- TOC entry 1285 (class 1259 OID 136958636)
-- Name: pivot_clean_session; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pivot_clean_session (
    session_id text NOT NULL,
    created timestamp with time zone NOT NULL,
    live timestamp with time zone NOT NULL,
    finished timestamp with time zone
);


ALTER TABLE public.pivot_clean_session OWNER TO psql;

--
-- TOC entry 1286 (class 1259 OID 136958641)
-- Name: pivot_execution; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pivot_execution (
    pivot_session_id text NOT NULL,
    user_id text NOT NULL,
    scope_id uuid NOT NULL,
    app_name text,
    defn_id text NOT NULL,
    agg_by text,
    history_start text,
    history_end text,
    sales_start text,
    sales_end text,
    sort_by text,
    flow_status text,
    top_members text,
    nest_data boolean NOT NULL,
    ignore_ancestors boolean NOT NULL,
    ignore_agg_by_params boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pivot_execution OWNER TO psql;

--
-- TOC entry 1287 (class 1259 OID 136958647)
-- Name: pivot_tables; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pivot_tables (
    user_id text NOT NULL,
    session_id text NOT NULL,
    table_name text NOT NULL,
    approx_create_time timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pivot_tables OWNER TO psql;

--
-- TOC entry 1288 (class 1259 OID 136958653)
-- Name: plan_audit_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.plan_audit_log OWNER TO psql;

--
-- TOC entry 1289 (class 1259 OID 136958659)
-- Name: plan_ca; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_ca (
    product text
);


ALTER TABLE public.plan_ca OWNER TO psql;

--
-- TOC entry 1290 (class 1259 OID 136958664)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plan_id_ticker OWNER TO psql;

--
-- TOC entry 1291 (class 1259 OID 136958665)
-- Name: plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue (
    jobid uuid DEFAULT uuid_generate_v4() NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    initiator text NOT NULL,
    initiated_at timestamp with time zone DEFAULT now() NOT NULL,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    priority integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.plan_queue OWNER TO psql;

--
-- TOC entry 1292 (class 1259 OID 136958674)
-- Name: plan_queue_20230315; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_20230315 (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone
);


ALTER TABLE public.plan_queue_20230315 OWNER TO psql;

--
-- TOC entry 1293 (class 1259 OID 136958679)
-- Name: plan_queue_20230605_postplan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_20230605_postplan (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue_20230605_postplan OWNER TO psql;

--
-- TOC entry 1294 (class 1259 OID 136958684)
-- Name: plan_queue_bk_20221023; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_bk_20221023 (
    jobid text,
    jsessionid text,
    tenantid text,
    product text,
    location text,
    status text,
    initiator text,
    initiated_at timestamp without time zone,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    job_priority integer
);


ALTER TABLE public.plan_queue_bk_20221023 OWNER TO psql;

--
-- TOC entry 1295 (class 1259 OID 136958689)
-- Name: plan_queue_boden_failed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_boden_failed (
    jobid text,
    jsessionid text,
    tenantid text,
    product text,
    location text,
    status text,
    initiator text,
    initiated_at timestamp without time zone,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    job_priority integer
);


ALTER TABLE public.plan_queue_boden_failed OWNER TO psql;

--
-- TOC entry 1296 (class 1259 OID 136958694)
-- Name: plan_queue_delete_me; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_delete_me (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue_delete_me OWNER TO psql;

--
-- TOC entry 1297 (class 1259 OID 136958699)
-- Name: plan_queue_fails; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_fails (
    jobid uuid,
    product text,
    location text,
    initiator text,
    initiated_at timestamp with time zone,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone,
    priority integer
);


ALTER TABLE public.plan_queue_fails OWNER TO psql;

--
-- TOC entry 1298 (class 1259 OID 136958704)
-- Name: plan_queue_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_jr (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue_jr OWNER TO psql;

--
-- TOC entry 1299 (class 1259 OID 136958709)
-- Name: plan_queue_jun6_2023; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_jun6_2023 (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue_jun6_2023 OWNER TO psql;

--
-- TOC entry 1300 (class 1259 OID 136958714)
-- Name: plan_queue_mark; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_mark (
    jobid text,
    jsessionid text,
    tenantid text,
    product text,
    location text,
    status text,
    initiator text,
    initiated_at timestamp without time zone,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    job_priority integer
);


ALTER TABLE public.plan_queue_mark OWNER TO psql;

--
-- TOC entry 1301 (class 1259 OID 136958719)
-- Name: plan_queue_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_test (
    jobid uuid,
    product text,
    location text,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid,
    initiated_at timestamp with time zone,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue_test OWNER TO psql;

--
-- TOC entry 1302 (class 1259 OID 136958724)
-- Name: plan_queue_test2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_test2 (
    jobid uuid,
    product text,
    location text,
    initiator text
);


ALTER TABLE public.plan_queue_test2 OWNER TO psql;

--
-- TOC entry 1303 (class 1259 OID 136958729)
-- Name: plan_status; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.plan_status AS
 SELECT plan_queue.jobid,
    plan_queue.product,
    plan_queue.location,
    plan_queue.initiator,
        CASE
            WHEN (plan_queue.completed IS NOT NULL) THEN
            CASE
                WHEN (plan_queue.error IS NOT NULL) THEN 'FAILED'::text
                ELSE 'COMPLETED'::text
            END
            WHEN (plan_queue.processing IS NOT NULL) THEN 'PROCESSING'::text
            WHEN (plan_queue.queued IS NOT NULL) THEN 'PENDING'::text
            ELSE 'STALLED'::text
        END AS status
   FROM plan_queue;


ALTER VIEW public.plan_status OWNER TO psql;

--
-- TOC entry 1304 (class 1259 OID 136958733)
-- Name: price_mapping_jon; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.price_mapping_jon (
    product text,
    price_group text,
    ticket_uk_gbp text,
    ticket_de_eur text,
    ticket_us_usd text,
    ticket_aus_aud text
);


ALTER TABLE public.price_mapping_jon OWNER TO psql;

--
-- TOC entry 1305 (class 1259 OID 136958738)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 1306 (class 1259 OID 136958743)
-- Name: promoevents_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.promoevents_l_dependencylookup (
    product text,
    ccpriceevent text,
    expression text
);


ALTER TABLE public.promoevents_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1307 (class 1259 OID 136958748)
-- Name: publishable_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.publishable_products (
    product text
);


ALTER TABLE public.publishable_products OWNER TO psql;

--
-- TOC entry 1308 (class 1259 OID 136958753)
-- Name: role; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.role (
    tenantid text NOT NULL,
    id text NOT NULL,
    description text DEFAULT ''::text,
    name text DEFAULT ''::text,
    service text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.role OWNER TO psql;

--
-- TOC entry 1309 (class 1259 OID 136958761)
-- Name: s5_profile_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master (
    size_range_class text,
    class text,
    sub_size_range text,
    profile_id text,
    size_id text,
    size_desc text,
    interim_prof text
);


ALTER TABLE public.s5_profile_master OWNER TO psql;

--
-- TOC entry 1310 (class 1259 OID 136958766)
-- Name: s5_profile_master_upgrade; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_upgrade (
    size_range_class text,
    class text,
    sub_size_range text,
    profile_id text,
    size_id text,
    size_desc text,
    interim_prof text
);


ALTER TABLE public.s5_profile_master_upgrade OWNER TO psql;

--
-- TOC entry 1311 (class 1259 OID 136958771)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 1312 (class 1259 OID 136958776)
-- Name: scope; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.scope (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    app_name text NOT NULL,
    user_id text NOT NULL,
    params json NOT NULL,
    filter_conditions json DEFAULT '{"filterConditions": []}'::json NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.scope OWNER TO psql;

--
-- TOC entry 1313 (class 1259 OID 136958785)
-- Name: shadow_lifecycleparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.shadow_lifecycleparams (
    product text NOT NULL,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    actual_launch_week text,
    planned_launch_week text,
    md_week text,
    exit_week text,
    pssr text,
    __status text,
    __txid text NOT NULL,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.shadow_lifecycleparams OWNER TO psql;

--
-- TOC entry 1314 (class 1259 OID 136958791)
-- Name: shadow_optionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.shadow_optionattributes (
    product text NOT NULL,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    price_banding_option text,
    archetype text,
    design_theme text,
    design_sub_theme text,
    detail text,
    fabric_type text,
    pattern text,
    pattern_type text,
    print_name text,
    product_pyramid_option text,
    theme text,
    weight_option text,
    __status text,
    __txid text NOT NULL,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.shadow_optionattributes OWNER TO psql;

--
-- TOC entry 1315 (class 1259 OID 136958797)
-- Name: shadow_price; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.shadow_price (
    product text NOT NULL,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    md_week text,
    fsp_gbp_ticket_1_override text,
    fsp_gbp_ticket_2_override text,
    eur_ticket_1_override text,
    eur_ticket_2_override text,
    usd_ticket_override text,
    aud_ticket_override text,
    fsp_gbp_ticket_1 text,
    fsp_gbp_ticket_2 text,
    eur_ticket_1 text,
    eur_ticket_2 text,
    usd_ticket text,
    aud_ticket text,
    __status text,
    __txid text NOT NULL,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.shadow_price OWNER TO psql;

--
-- TOC entry 1316 (class 1259 OID 136958803)
-- Name: shadow_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.shadow_styleattributes (
    product text NOT NULL,
    style_name text,
    style_description text,
    is_published text,
    age_style text,
    building_blocks text,
    clothing_fit text,
    end_use text,
    footwear_heel_height text,
    footwear_type text,
    gender text,
    length_style text,
    neck_shape text,
    price_banding_style text,
    product_pyramid_style text,
    rise text,
    skirt_or_leg_shape text,
    sleeve_length text,
    sleeve_shape text,
    __status text,
    __txid text NOT NULL,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.shadow_styleattributes OWNER TO psql;

--
-- TOC entry 1317 (class 1259 OID 136958809)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 1318 (class 1259 OID 136958814)
-- Name: staging_lifecycleparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_lifecycleparams (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    actual_launch_week text,
    planned_launch_week text,
    md_week text,
    exit_week text,
    pssr text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.staging_lifecycleparams OWNER TO psql;

--
-- TOC entry 1319 (class 1259 OID 136958820)
-- Name: staging_lifecycleparams_prod_val; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_lifecycleparams_prod_val (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_lifecycleparams_prod_val OWNER TO psql;

--
-- TOC entry 1320 (class 1259 OID 136958825)
-- Name: staging_lifecycleparams_prod_val_reject; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_lifecycleparams_prod_val_reject (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_lifecycleparams_prod_val_reject OWNER TO psql;

--
-- TOC entry 1321 (class 1259 OID 136958830)
-- Name: staging_optionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_optionattributes (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    price_banding_option text,
    archetype text,
    design_theme text,
    design_sub_theme text,
    detail text,
    fabric_type text,
    pattern text,
    pattern_type text,
    print_name text,
    product_pyramid_option text,
    theme text,
    weight_option text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.staging_optionattributes OWNER TO psql;

--
-- TOC entry 1322 (class 1259 OID 136958836)
-- Name: staging_optionattributes_prod_val; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_optionattributes_prod_val (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_optionattributes_prod_val OWNER TO psql;

--
-- TOC entry 1323 (class 1259 OID 136958841)
-- Name: staging_optionattributes_prod_val_reject; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_optionattributes_prod_val_reject (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_optionattributes_prod_val_reject OWNER TO psql;

--
-- TOC entry 1324 (class 1259 OID 136958846)
-- Name: staging_price; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_price (
    product text,
    style_name text,
    style_description text,
    option_name text,
    is_published text,
    md_week text,
    fsp_gbp_ticket_1_override text,
    fsp_gbp_ticket_2_override text,
    eur_ticket_1_override text,
    eur_ticket_2_override text,
    usd_ticket_override text,
    aud_ticket_override text,
    fsp_gbp_ticket_1 text,
    fsp_gbp_ticket_2 text,
    eur_ticket_1 text,
    eur_ticket_2 text,
    usd_ticket text,
    aud_ticket text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.staging_price OWNER TO psql;

--
-- TOC entry 1325 (class 1259 OID 136958852)
-- Name: staging_price_prod_val; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_price_prod_val (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_price_prod_val OWNER TO psql;

--
-- TOC entry 1326 (class 1259 OID 136958857)
-- Name: staging_price_prod_val_reject; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_price_prod_val_reject (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_price_prod_val_reject OWNER TO psql;

--
-- TOC entry 1327 (class 1259 OID 136958862)
-- Name: staging_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_styleattributes (
    product text,
    style_name text,
    style_description text,
    is_published text,
    age_style text,
    building_blocks text,
    clothing_fit text,
    end_use text,
    footwear_heel_height text,
    footwear_type text,
    gender text,
    length_style text,
    neck_shape text,
    shape_name_package text,
    product_pyramid_style text,
    rise text,
    skirt_or_leg_shape text,
    sleeve_length text,
    sleeve_shape text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.staging_styleattributes OWNER TO psql;

--
-- TOC entry 1328 (class 1259 OID 136958868)
-- Name: staging_styleattributes_prod_val; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_styleattributes_prod_val (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_styleattributes_prod_val OWNER TO psql;

--
-- TOC entry 1329 (class 1259 OID 136958873)
-- Name: staging_styleattributes_prod_val_reject; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_styleattributes_prod_val_reject (
    upload_tx_id text NOT NULL,
    product text NOT NULL
);


ALTER TABLE public.staging_styleattributes_prod_val_reject OWNER TO psql;

--
-- TOC entry 1330 (class 1259 OID 136958878)
-- Name: stylecolor_size_predict_attrs; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.stylecolor_size_predict_attrs AS
 SELECT bd_stylecolor_hier_attr.product,
    bd_stylecolor_hier_attr.sty_size_range AS size_range,
    bd_stylecolor_hier_attr.department,
    bd_stylecolor_hier_attr.category AS class,
    bd_stylecolor_hier_attr.subcategory AS subclass,
    bd_stylecolor_hier_attr.department_name,
    bd_stylecolor_hier_attr.category_name AS class_name,
    bd_stylecolor_hier_attr.subcategory_name AS subclass_name,
    bd_stylecolor_hier_attr.cc_sub_range,
    bd_stylecolor_hier_attr.cc_applied_detail,
    bd_stylecolor_hier_attr.cc_color_group,
    bd_stylecolor_hier_attr.cc_sub_theme,
    bd_stylecolor_hier_attr.cc_pattern,
    bd_stylecolor_hier_attr.cc_collection,
    bd_stylecolor_hier_attr.cc_fabric_yarn_type,
    bd_stylecolor_hier_attr.cccw_age_gender,
    bd_stylecolor_hier_attr.cc_price_banding_latest,
    bd_stylecolor_hier_attr.cc_texture,
    bd_stylecolor_hier_attr.cc_season_latest,
    bd_stylecolor_hier_attr.cc_classification_latest,
    bd_stylecolor_hier_attr.cc_theme_latest,
    bd_stylecolor_hier_attr.cc_weight,
    bd_stylecolor_hier_attr.cc_archetype,
    bd_stylecolor_hier_attr.cc_pattern_new,
    bd_stylecolor_hier_attr.sty_fit_style,
    bd_stylecolor_hier_attr.sty_rise,
    bd_stylecolor_hier_attr.sty_heel_height,
    bd_stylecolor_hier_attr.sty_footwear_type,
    bd_stylecolor_hier_attr.sty_end_use,
    bd_stylecolor_hier_attr.sty_dress_skirt_length,
    bd_stylecolor_hier_attr.sty_neck_detail,
    bd_stylecolor_hier_attr.sty_waist_detail,
    bd_stylecolor_hier_attr.sty_skirt_shape,
    bd_stylecolor_hier_attr.sty_sleeve_length,
    bd_stylecolor_hier_attr.sty_sleeve_shape,
    bd_stylecolor_hier_attr.sty_trouser_length,
    bd_stylecolor_hier_attr.sty_trouser_shape,
    bd_stylecolor_hier_attr.sty_packages,
    bd_stylecolor_hier_attr.sty_shopzilla_rating,
    bd_stylecolor_hier_attr.sty_price_band_style,
    bd_stylecolor_hier_attr.sty_classification_latest,
    bd_stylecolor_hier_attr.sty_age_style,
    bd_stylecolor_hier_attr.sty_gender_style
   FROM bd_stylecolor_hier_attr;


ALTER VIEW public.stylecolor_size_predict_attrs OWNER TO psql;

--
-- TOC entry 1331 (class 1259 OID 136958883)
-- Name: sync_current_phase; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_current_phase (
    currentphase text,
    year integer,
    phase integer
);


ALTER TABLE public.sync_current_phase OWNER TO psql;

--
-- TOC entry 1332 (class 1259 OID 136958888)
-- Name: sync_dataqueue_deletes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_dataqueue_deletes (
    product text,
    location text,
    "time" text
);


ALTER TABLE public.sync_dataqueue_deletes OWNER TO psql;

--
-- TOC entry 1333 (class 1259 OID 136958893)
-- Name: sync_outbound_assortment_attr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_assortment_attr (
    stylecolor text,
    "time" text,
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_season text,
    a_cc_exposure text,
    a_cc_newness text,
    isfunded integer
);


ALTER TABLE public.sync_outbound_assortment_attr OWNER TO psql;

--
-- TOC entry 1334 (class 1259 OID 136958898)
-- Name: sync_outbound_assortment_attr_phase_full; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_assortment_attr_phase_full (
    stylecolor text,
    "time" text,
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_season text,
    a_cc_exposure text,
    a_cc_newness text,
    isfunded integer
);


ALTER TABLE public.sync_outbound_assortment_attr_phase_full OWNER TO psql;

--
-- TOC entry 1335 (class 1259 OID 136958903)
-- Name: sync_outbound_dataqueue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue (
    product text NOT NULL,
    interface text NOT NULL,
    "time" text NOT NULL,
    location text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.sync_outbound_dataqueue OWNER TO psql;

--
-- TOC entry 1336 (class 1259 OID 136958910)
-- Name: sync_outbound_dataqueue_20220105testing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue_20220105testing (
    product text,
    interface text,
    "time" text,
    location text,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_dataqueue_20220105testing OWNER TO psql;

--
-- TOC entry 1337 (class 1259 OID 136958915)
-- Name: sync_outbound_dataqueue_bk20231102; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue_bk20231102 (
    product text,
    interface text,
    "time" text,
    location text,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_dataqueue_bk20231102 OWNER TO psql;

--
-- TOC entry 1338 (class 1259 OID 136958920)
-- Name: sync_outbound_dataqueue_season; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue_season (
    product text,
    interface text,
    "time" text,
    location text,
    eventdate date,
    updated_at timestamp without time zone,
    season text
);


ALTER TABLE public.sync_outbound_dataqueue_season OWNER TO psql;

--
-- TOC entry 1339 (class 1259 OID 136958925)
-- Name: sync_outbound_dataqueue_test20231120; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue_test20231120 (
    product text,
    interface text,
    "time" text,
    location text,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_dataqueue_test20231120 OWNER TO psql;

--
-- TOC entry 1340 (class 1259 OID 136958930)
-- Name: sync_outbound_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_delta (
    sync_start timestamp without time zone,
    sync_end timestamp without time zone
);


ALTER TABLE public.sync_outbound_delta OWNER TO psql;

--
-- TOC entry 1341 (class 1259 OID 136958933)
-- Name: sync_outbound_interfaces; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_interfaces (
    interface text NOT NULL,
    frequency text NOT NULL,
    sync_start timestamp without time zone,
    sync_end timestamp without time zone,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.sync_outbound_interfaces OWNER TO psql;

--
-- TOC entry 1342 (class 1259 OID 136958940)
-- Name: sync_outbound_recomendationplm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_recomendationplm (
    member_id text,
    client_id text,
    member_stylecolor_id text,
    member_style_id text,
    week_id text,
    season text,
    location_id text,
    ticket_price_gbp text,
    ticket_price_usd text,
    buy_value text,
    buy_qnt text
);


ALTER TABLE public.sync_outbound_recomendationplm OWNER TO psql;

--
-- TOC entry 1343 (class 1259 OID 136958945)
-- Name: sync_outbound_sizeattribute; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_sizeattribute (
    product text,
    size_id text,
    size_range_id text,
    parent_id text,
    isvalid integer,
    eventdate date,
    updated_at timestamp without time zone,
    size_name text
);


ALTER TABLE public.sync_outbound_sizeattribute OWNER TO psql;

--
-- TOC entry 1344 (class 1259 OID 136958950)
-- Name: sync_outbound_styleattr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_styleattr (
    member_id text,
    client_id text,
    fit_style text,
    rise text,
    heel_height text,
    footwear_type text,
    end_use text,
    dress_skirt_length text,
    neck_detail text,
    skirt_shape text,
    sleeve_length text,
    sleeve_shape text,
    packages text,
    price_band_style text,
    product_classification_style text,
    age_style text,
    gender_style text
);


ALTER TABLE public.sync_outbound_styleattr OWNER TO psql;

--
-- TOC entry 1345 (class 1259 OID 136958955)
-- Name: sync_outbound_styleclrchannel_attr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_styleclrchannel_attr (
    stylecolor text,
    location text,
    record_state smallint,
    validsizes text,
    ccticketpricechannel_base_gbp1 real,
    ccticketpricechannel_base_usd real,
    dbt_wk text,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_styleclrchannel_attr OWNER TO psql;

--
-- TOC entry 1346 (class 1259 OID 136958960)
-- Name: sync_outbound_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolor (
    stylecolor text,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_stylecolor OWNER TO psql;

--
-- TOC entry 1347 (class 1259 OID 136958965)
-- Name: sync_outbound_stylecolor_attr_phase_full; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolor_attr_phase_full (
    stylecolor text,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_stylecolor_attr_phase_full OWNER TO psql;

--
-- TOC entry 1348 (class 1259 OID 136958970)
-- Name: sync_outbound_stylecolor_hier_attr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolor_hier_attr (
    product text,
    stylecolor text,
    stylecolor_description text,
    style text,
    style_description text,
    subcategory text,
    category text,
    department text,
    segment text,
    division text,
    company text,
    stylecolor_name text,
    style_name text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_color_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_boden_landed_cost real,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    launch_month text,
    launch_week text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    merch_comments text,
    plan_comments text,
    ccstylecreatedate text,
    sty_size_range text,
    isprepublishable text,
    us_price_band text,
    uk_price_band text
);


ALTER TABLE public.sync_outbound_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 1349 (class 1259 OID 136958975)
-- Name: sync_outbound_stylecolor_hier_attr_phase_full; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolor_hier_attr_phase_full (
    stylecolor text,
    style text
);


ALTER TABLE public.sync_outbound_stylecolor_hier_attr_phase_full OWNER TO psql;

--
-- TOC entry 1350 (class 1259 OID 136958980)
-- Name: sync_outbound_stylecolorattr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolorattr (
    member_id text,
    client_id text,
    member_style_id text,
    applied_detail text,
    sub_theme text,
    pattern text,
    collection text,
    price_banding_latest text,
    texture text,
    product_classification_stylecolor_latest text,
    theme text,
    weight text,
    archetype text,
    pattern_new text,
    debut_week text
);


ALTER TABLE public.sync_outbound_stylecolorattr OWNER TO psql;

--
-- TOC entry 1351 (class 1259 OID 136958985)
-- Name: sync_outbound_stylecolorattr_11082026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolorattr_11082026 (
    member_id text,
    client_id text,
    member_style_id text,
    applied_detail text,
    sub_theme text,
    pattern text,
    collection text,
    price_banding_latest text,
    texture text,
    product_classification_stylecolor_latest text,
    theme text,
    weight text,
    archetype text,
    pattern_new text,
    debut_week text
);


ALTER TABLE public.sync_outbound_stylecolorattr_11082026 OWNER TO psql;

--
-- TOC entry 1352 (class 1259 OID 136958990)
-- Name: sync_outbound_stylecolorattr_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolorattr_time (
    member_id text,
    client_id text,
    member_style_id text,
    phase_id text,
    planned_phase text,
    phase_story text,
    season text,
    exposure text,
    newness text,
    is_funded integer
);


ALTER TABLE public.sync_outbound_stylecolorattr_time OWNER TO psql;

--
-- TOC entry 1353 (class 1259 OID 136958995)
-- Name: sync_outbound_stylecolorlifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_stylecolorlifecycle (
    member_id text,
    client_id text,
    member_style_id text,
    debut_week text,
    md_week text,
    exit_week text,
    is_removed integer
);


ALTER TABLE public.sync_outbound_stylecolorlifecycle OWNER TO psql;

--
-- TOC entry 1354 (class 1259 OID 136959000)
-- Name: sync_outbound_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_ticketprice (
    member_id text,
    client_id text,
    member_stylecolor_id text,
    member_style_id text,
    week_id text,
    currency text,
    ticket_price numeric
);


ALTER TABLE public.sync_outbound_ticketprice OWNER TO psql;

--
-- TOC entry 1355 (class 1259 OID 136959005)
-- Name: sync_outbound_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_validsizes (
    member_id text,
    client_id text,
    member_stylecolor_id text,
    member_style_id text,
    location_id text,
    size_range text,
    size_member_id text,
    size_member_name text
);


ALTER TABLE public.sync_outbound_validsizes OWNER TO psql;

--
-- TOC entry 1356 (class 1259 OID 136959010)
-- Name: sync_stylecolorpublishes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_stylecolorpublishes (
    product text NOT NULL,
    is_published real,
    first_published_date date,
    is_prepublished real,
    first_prepublished_date date,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.sync_stylecolorpublishes OWNER TO psql;

--
-- TOC entry 1357 (class 1259 OID 136959017)
-- Name: t1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.t1 (
    product text,
    location text,
    "time" text,
    grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    style text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    strchannel text[],
    strterritory text[],
    straccount text[],
    a_cc_planned_phase text,
    a_cc_phase_story text,
    a_cc_newness text,
    a_cc_season text,
    a_cc_exposure text
);


ALTER TABLE public.t1 OWNER TO psql;

--
-- TOC entry 1358 (class 1259 OID 136959022)
-- Name: targetsetting; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.targetsetting (
    id text NOT NULL,
    version text NOT NULL,
    type text NOT NULL,
    data jsonb,
    scope_hash text NOT NULL
);


ALTER TABLE public.targetsetting OWNER TO psql;

--
-- TOC entry 1359 (class 1259 OID 136959027)
-- Name: temp1_bd_c_week13; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_c_week13 (
    week text,
    week_minus_13 text
);


ALTER TABLE public.temp1_bd_c_week13 OWNER TO psql;

--
-- TOC entry 1360 (class 1259 OID 136959032)
-- Name: temp1_bd_c_week15; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_c_week15 (
    week text,
    week_minus_15 text
);


ALTER TABLE public.temp1_bd_c_week15 OWNER TO psql;

--
-- TOC entry 1361 (class 1259 OID 136959037)
-- Name: temp1_bd_c_week4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_c_week4 (
    week text,
    week_minus_4 text
);


ALTER TABLE public.temp1_bd_c_week4 OWNER TO psql;

--
-- TOC entry 1362 (class 1259 OID 136959042)
-- Name: temp1_bd_c_week6; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_c_week6 (
    week text,
    week_minus_6 text
);


ALTER TABLE public.temp1_bd_c_week6 OWNER TO psql;

--
-- TOC entry 1363 (class 1259 OID 136959047)
-- Name: temp1_bd_c_week7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_c_week7 (
    week text,
    week_minus_7 text
);


ALTER TABLE public.temp1_bd_c_week7 OWNER TO psql;

--
-- TOC entry 1364 (class 1259 OID 136959052)
-- Name: temp1_bd_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_bd_ma_dptflrsetattributes (
    indx bigint,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.temp1_bd_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1025 (class 1259 OID 38061)
-- Name: temp_S5SizeRange_20220301142700; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."temp_S5SizeRange_20220301142700" (
    size_range character varying(32),
    size_member_id character varying(8),
    size_member_name character varying(8),
    price_group character varying(2)
);


ALTER TABLE public."temp_S5SizeRange_20220301142700" OWNER TO psql;

--
-- TOC entry 1026 (class 1259 OID 38064)
-- Name: temp_S5SizeRange_20220506; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public."temp_S5SizeRange_20220506" (
    size_range text,
    size_member_id text,
    size_member_name text,
    price_group text
);


ALTER TABLE public."temp_S5SizeRange_20220506" OWNER TO psql;

--
-- TOC entry 1365 (class 1259 OID 136959057)
-- Name: temp_bd_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_corpdisc (
    department text,
    product text,
    location text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.temp_bd_corpdisc OWNER TO psql;

--
-- TOC entry 1366 (class 1259 OID 136959062)
-- Name: temp_bd_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_d_time (
    id text,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.temp_bd_d_time OWNER TO psql;

--
-- TOC entry 1367 (class 1259 OID 136959067)
-- Name: temp_bd_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_ma_dptflrsetattributes (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.temp_bd_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1368 (class 1259 OID 136959072)
-- Name: temp_bd_ma_dptflrsetattributes_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_ma_dptflrsetattributes_jr (
    indx bigint,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.temp_bd_ma_dptflrsetattributes_jr OWNER TO psql;

--
-- TOC entry 1369 (class 1259 OID 136959077)
-- Name: temp_bd_ma_dptflrsetattributes_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_ma_dptflrsetattributes_test (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    lyslsstart text,
    lyslsend text,
    too text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too smallint,
    default_mkdnwks smallint,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_strchannel text[],
    default_strterritory text[],
    default_straccount text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.temp_bd_ma_dptflrsetattributes_test OWNER TO psql;

--
-- TOC entry 1370 (class 1259 OID 136959082)
-- Name: temp_bd_p_dc_adj_20221109; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_p_dc_adj_20221109 (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_isedited real,
    dc_syscost real,
    dc_lndcst real,
    dc_sysvrp real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dc_sc_useradj real,
    dc_sc_finrev real,
    po_indicator text,
    po_shipmode text,
    air_trigger text,
    cut text,
    published_at timestamp(0) without time zone,
    is_prepublished real,
    prepublished_at timestamp(0) without time zone,
    last_prepublished real
);


ALTER TABLE public.temp_bd_p_dc_adj_20221109 OWNER TO psql;

--
-- TOC entry 1371 (class 1259 OID 136959087)
-- Name: temp_bd_p_dc_adj_size_20221109; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_p_dc_adj_size_20221109 (
    product text,
    location text,
    "time" text,
    dc_publish real,
    is_locked real,
    dc_uservrp real,
    dc_lockedqty real,
    dc_useradj real,
    dc_onorder real,
    dc_finrev real,
    dc_validwk real,
    dc_finalqty real,
    dc_adjcost real,
    const_y_n real,
    sbkt real,
    dc_scadj real,
    dc_ttluseradj real,
    dc_scfinrev real,
    dc_ttlfinrev real,
    dc_isedited real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dc_onorder_v real,
    dc_onorder_c real
);


ALTER TABLE public.temp_bd_p_dc_adj_size_20221109 OWNER TO psql;

--
-- TOC entry 1372 (class 1259 OID 136959092)
-- Name: temp_bd_p_dc_adj_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_p_dc_adj_stylecolor (
    stylecolor_id text,
    location_id text,
    week_id text,
    on_order_v real,
    on_order_u real,
    on_order_c real,
    adj_cost real
);


ALTER TABLE public.temp_bd_p_dc_adj_stylecolor OWNER TO psql;

--
-- TOC entry 1373 (class 1259 OID 136959097)
-- Name: temp_bd_p_dc_adj_stylecolorsize; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_bd_p_dc_adj_stylecolorsize (
    member_id text,
    location_id text,
    week_id text,
    on_order_v real,
    on_order_u real,
    on_order_c real,
    adj_cost real
);


ALTER TABLE public.temp_bd_p_dc_adj_stylecolorsize OWNER TO psql;

--
-- TOC entry 1374 (class 1259 OID 136959102)
-- Name: temp_dp60price2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_dp60price2 (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    index text,
    row_number bigint
);


ALTER TABLE public.temp_dp60price2 OWNER TO psql;

--
-- TOC entry 1375 (class 1259 OID 136959107)
-- Name: temp_sup1080_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_sup1080_2 (
    product text,
    a_cc_newness text,
    a_cc_exposure text
);


ALTER TABLE public.temp_sup1080_2 OWNER TO psql;

--
-- TOC entry 1376 (class 1259 OID 136959112)
-- Name: temp_sup1312; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_sup1312 (
    product text,
    a_cc_newness text,
    a_cc_exposure text
);


ALTER TABLE public.temp_sup1312 OWNER TO psql;

--
-- TOC entry 1377 (class 1259 OID 136959117)
-- Name: temp_test_phases; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_test_phases (
    product text,
    "time" text,
    dbt_wk text,
    exitdate text,
    slsstart text,
    slsend text,
    phase text
);


ALTER TABLE public.temp_test_phases OWNER TO psql;

--
-- TOC entry 1378 (class 1259 OID 136959122)
-- Name: ticketpricemapping_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ticketpricemapping_l_dependencylookup (
    product text,
    price_group text,
    ticket_uk_gbp real,
    ticket_de_eur real,
    ticket_us_usd real,
    ticket_aus_aud real
);


ALTER TABLE public.ticketpricemapping_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1379 (class 1259 OID 136959127)
-- Name: ticketpricemapping_l_dependencylookup_bk20230502; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ticketpricemapping_l_dependencylookup_bk20230502 (
    product text,
    price_group text,
    ticket_uk_gbp real,
    ticket_de_eur real,
    ticket_us_usd real,
    ticket_aus_aud real
);


ALTER TABLE public.ticketpricemapping_l_dependencylookup_bk20230502 OWNER TO psql;

--
-- TOC entry 1380 (class 1259 OID 136959132)
-- Name: tmp_bd_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_bd_swatches (
    attributeid text,
    validvalue text,
    datastr text,
    strtype text,
    type text
);


ALTER TABLE public.tmp_bd_swatches OWNER TO psql;

--
-- TOC entry 1381 (class 1259 OID 136959137)
-- Name: tmp_bd_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_bd_v_memberbasedvalidvalues (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.tmp_bd_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1382 (class 1259 OID 136959142)
-- Name: tmp_jr_ticket_price; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_jr_ticket_price (
    ancestor0 text,
    ccticketpricechannel real
);


ALTER TABLE public.tmp_jr_ticket_price OWNER TO psql;

--
-- TOC entry 1383 (class 1259 OID 136959147)
-- Name: tmp_jr_ticket_price_gbp1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_jr_ticket_price_gbp1 (
    ancestor0 text,
    ccticketpricechannel real
);


ALTER TABLE public.tmp_jr_ticket_price_gbp1 OWNER TO psql;

--
-- TOC entry 1384 (class 1259 OID 136959154)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 1385 (class 1259 OID 136959160)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 1386 (class 1259 OID 136959165)
-- Name: undo_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_log (
    undo_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    department text NOT NULL,
    channel text NOT NULL,
    plan_measure text[] NOT NULL,
    level_tie text[] NOT NULL,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    undone boolean DEFAULT false NOT NULL
);


ALTER TABLE public.undo_log OWNER TO psql;

--
-- TOC entry 1387 (class 1259 OID 136959173)
-- Name: undo_modifications; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_modifications (
    undo_id uuid NOT NULL,
    key json NOT NULL,
    plan_defn text NOT NULL,
    measure text NOT NULL,
    old_value_numeric real,
    new_value_numeric real,
    old_value_text text,
    new_value_text text
);


ALTER TABLE public.undo_modifications OWNER TO psql;

--
-- TOC entry 1388 (class 1259 OID 136959178)
-- Name: upload_statistics; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.upload_statistics (
    upload_id text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    records_uploaded integer,
    validated_count integer,
    rejected_count integer,
    final_status text
);


ALTER TABLE public.upload_statistics OWNER TO psql;

--
-- TOC entry 1389 (class 1259 OID 136959184)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 1390 (class 1259 OID 136959189)
-- Name: user_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl (
    tenantid text NOT NULL,
    id text NOT NULL,
    description text DEFAULT 'User'::text,
    name text DEFAULT 'User'::text,
    password text DEFAULT 'blah'::text,
    roles text[],
    eventdate date DEFAULT CURRENT_DATE,
    profile_group text
);


ALTER TABLE public.user_tbl OWNER TO psql;

--
-- TOC entry 1391 (class 1259 OID 136959198)
-- Name: user_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_worklist (
    user_id text NOT NULL,
    product text NOT NULL,
    type text NOT NULL,
    updated_at timestamp without time zone,
    name text DEFAULT '⚠️❓❓'::text NOT NULL
);


ALTER TABLE public.user_worklist OWNER TO psql;

--
-- TOC entry 1392 (class 1259 OID 136959204)
-- Name: v_isprepublishable; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_isprepublishable (
    ispublishable text
);


ALTER TABLE public.v_isprepublishable OWNER TO psql;

--
-- TOC entry 1393 (class 1259 OID 136959209)
-- Name: v_ispublishable; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_ispublishable (
    ispublishable text
);


ALTER TABLE public.v_ispublishable OWNER TO psql;

--
-- TOC entry 1394 (class 1259 OID 136959214)
-- Name: xt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.xt (
    product text,
    flow_flag text,
    weekdate text,
    price_status text,
    original_ticketprice real,
    selling_price numeric(16,2),
    class text,
    subclass text,
    department text,
    division text,
    style text,
    num_sizes integer,
    cc_sub_range text,
    cc_applied_detail text,
    cc_color_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_age_style text,
    sty_gender_style text,
    size_range text,
    cc_print_name text,
    sty_shopzilla_rating_count text,
    launch_month text,
    launch_week text
);


ALTER TABLE public.xt OWNER TO psql;

--
-- TOC entry 1395 (class 1259 OID 136959219)
-- Name: yt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.yt (
    product text,
    stylecolor text,
    stylecolor_description text,
    style text,
    style_description text,
    subcategory text,
    category text,
    department text,
    segment text,
    division text,
    company text,
    stylecolor_name text,
    style_name text,
    subcategory_name text,
    category_name text,
    department_name text,
    segment_name text,
    division_name text,
    company_name text,
    cc_sub_range text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_color_group text,
    cc_sub_theme text,
    cc_pattern text,
    cc_print_name text,
    cc_collection text,
    cc_fabric_yarn_type text,
    cccw_age_gender text,
    cc_price_banding_latest text,
    cc_texture text,
    cc_season_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    cc_weight text,
    cc_archetype text,
    cc_pattern_new text,
    cc_ready_for_ranging text,
    cc_active_flag text,
    cc_boden_landed_cost real,
    cc_supplier_1 text,
    cc_supplier_1_fob text,
    cc_supplier_1_moq text,
    cc_supplier_2 text,
    cc_supplier_2_fob text,
    cc_supplier_2_moq text,
    cc_supplier_3 text,
    cc_supplier_3_fob text,
    cc_supplier_3_moq text,
    sty_fit_style text,
    sty_rise text,
    sty_heel_height text,
    sty_footwear_type text,
    sty_end_use text,
    sty_dress_skirt_length text,
    sty_neck_detail text,
    sty_waist_detail text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_trouser_length text,
    sty_trouser_shape text,
    sty_packages text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_price_band_style text,
    sty_classification_latest text,
    sty_sub_range_style text,
    sty_cw_age_gender_style text,
    sty_age_style text,
    sty_gender_style text,
    sty_ready_for_ranging text,
    sty_active_flag text,
    launch_month text,
    launch_week text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    isstyleremovable text,
    ispublishable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    merch_comments text,
    plan_comments text,
    ccstylecreatedate text,
    sty_size_range text,
    isprepublishable text
);


ALTER TABLE public.yt OWNER TO psql;

--
-- TOC entry 6741 (class 2604 OID 136959224)
-- Name: bd_l_dependencylookup2 myindex; Type: DEFAULT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_dependencylookup2 ALTER COLUMN myindex SET DEFAULT nextval('bd_l_dependencylookup2_myindex_seq'::regclass);


--
-- TOC entry 6947 (class 2606 OID 136965500)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 6938 (class 2606 OID 136965502)
-- Name: dimensions dimension_levelid_indx_uniqe; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimension_levelid_indx_uniqe UNIQUE (dimension, levelid, indx);


--
-- TOC entry 6940 (class 2606 OID 136965504)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 6942 (class 2606 OID 136965506)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 6949 (class 2606 OID 136965508)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 6952 (class 2606 OID 136965510)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 6954 (class 2606 OID 136965512)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location, prodlife);


--
-- TOC entry 6956 (class 2606 OID 136965514)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 6961 (class 2606 OID 136965516)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 6963 (class 2606 OID 136965518)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 6967 (class 2606 OID 136965520)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 6965 (class 2606 OID 136965522)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 6969 (class 2606 OID 136965524)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 6971 (class 2606 OID 136965526)
-- Name: assort_period_from_dpt assort_period_from_dpt_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.assort_period_from_dpt
    ADD CONSTRAINT assort_period_from_dpt_pkey PRIMARY KEY (department, "time");


--
-- TOC entry 6973 (class 2606 OID 136965528)
-- Name: bd_a_assortment bd_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_a_assortment
    ADD CONSTRAINT bd_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 7007 (class 2606 OID 136965530)
-- Name: bd_d_cluster bd_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_d_cluster
    ADD CONSTRAINT bd_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 6977 (class 2606 OID 136965532)
-- Name: bd_d_location bd_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_d_location
    ADD CONSTRAINT bd_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 7009 (class 2606 OID 136965534)
-- Name: bd_d_prodlife bd_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_d_prodlife
    ADD CONSTRAINT bd_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 7011 (class 2606 OID 136965536)
-- Name: bd_d_product bd_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_d_product
    ADD CONSTRAINT bd_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 6979 (class 2606 OID 136965547)
-- Name: bd_d_time bd_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_d_time
    ADD CONSTRAINT bd_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 7014 (class 2606 OID 136965549)
-- Name: bd_h_clusterstd bd_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_clusterstd
    ADD CONSTRAINT bd_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 6981 (class 2606 OID 136965551)
-- Name: bd_h_locstd bd_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_locstd
    ADD CONSTRAINT bd_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7018 (class 2606 OID 136965553)
-- Name: bd_h_prodlifestd bd_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_prodlifestd
    ADD CONSTRAINT bd_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 6990 (class 2606 OID 136965555)
-- Name: bd_h_prodstd bd_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_prodstd
    ADD CONSTRAINT bd_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7020 (class 2606 OID 136965563)
-- Name: bd_h_timeflrset bd_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_timeflrset
    ADD CONSTRAINT bd_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 7022 (class 2606 OID 136965565)
-- Name: bd_h_timestd bd_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_timestd
    ADD CONSTRAINT bd_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 6975 (class 2606 OID 136965567)
-- Name: bd_corpdisc bd_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_corpdisc
    ADD CONSTRAINT bd_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time");


--
-- TOC entry 7024 (class 2606 OID 136965569)
-- Name: bd_l_dclookup bd_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_dclookup
    ADD CONSTRAINT bd_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 6992 (class 2606 OID 136965571)
-- Name: bd_l_mdstrategy bd_l_mdstrategy_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_mdstrategy
    ADD CONSTRAINT bd_l_mdstrategy_pkey PRIMARY KEY (department, mdstrategy, seq);


--
-- TOC entry 7026 (class 2606 OID 136965573)
-- Name: bd_l_priceeventlookup bd_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_priceeventlookup
    ADD CONSTRAINT bd_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 7028 (class 2606 OID 136965575)
-- Name: bd_l_promodesclookup bd_l_promodesclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_promodesclookup
    ADD CONSTRAINT bd_l_promodesclookup_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7066 (class 2606 OID 136965577)
-- Name: bd_sizinglookup bd_l_sizinglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_sizinglookup
    ADD CONSTRAINT bd_l_sizinglookup_pkey UNIQUE (sizerange, size, strselling_channel);


--
-- TOC entry 7030 (class 2606 OID 136965579)
-- Name: bd_l_ssglookup bd_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_ssglookup
    ADD CONSTRAINT bd_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 7032 (class 2606 OID 136965581)
-- Name: bd_l_storedclookup bd_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_storedclookup
    ADD CONSTRAINT bd_l_storedclookup_pkey PRIMARY KEY (store, dc, priority);


--
-- TOC entry 7034 (class 2606 OID 136965583)
-- Name: bd_l_storelookup bd_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_l_storelookup
    ADD CONSTRAINT bd_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 7037 (class 2606 OID 136965606)
-- Name: bd_ma_classattributes bd_ma_classattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_classattributes
    ADD CONSTRAINT bd_ma_classattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7039 (class 2606 OID 136965608)
-- Name: bd_ma_dptflrsetattributes bd_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_dptflrsetattributes
    ADD CONSTRAINT bd_ma_dptflrsetattributes_pkey PRIMARY KEY (indx, product);


--
-- TOC entry 7041 (class 2606 OID 136965610)
-- Name: bd_ma_imgattributes bd_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_imgattributes
    ADD CONSTRAINT bd_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7043 (class 2606 OID 136965612)
-- Name: bd_ma_sizeattributes bd_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_sizeattributes
    ADD CONSTRAINT bd_ma_sizeattributes_pkey PRIMARY KEY (product, sizeattribute);


--
-- TOC entry 7046 (class 2606 OID 136965617)
-- Name: bd_ma_storeattributes bd_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_storeattributes
    ADD CONSTRAINT bd_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 6994 (class 2606 OID 136965619)
-- Name: bd_ma_styleattributes bd_ma_styleattributes_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_styleattributes
    ADD CONSTRAINT bd_ma_styleattributes_pk PRIMARY KEY (product);


--
-- TOC entry 6996 (class 2606 OID 136965621)
-- Name: bd_ma_stylecolorattributes bd_ma_stylecolorattributes_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorattributes
    ADD CONSTRAINT bd_ma_stylecolorattributes_pk PRIMARY KEY (product);


--
-- TOC entry 6998 (class 2606 OID 136965623)
-- Name: bd_ma_stylecolorchannelattributes bd_ma_stylecolorchannelattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorchannelattributes
    ADD CONSTRAINT bd_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7048 (class 2606 OID 136965625)
-- Name: bd_ma_stylecolorphaseattributes bd_ma_stylecolorphaseattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorphaseattributes
    ADD CONSTRAINT bd_ma_stylecolorphaseattributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 7050 (class 2606 OID 136965633)
-- Name: bd_ma_stylecolorpublishes bd_ma_stylecolorpublishes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorpublishes
    ADD CONSTRAINT bd_ma_stylecolorpublishes_pkey PRIMARY KEY (product);


--
-- TOC entry 7052 (class 2606 OID 136965635)
-- Name: bd_ma_stylecolorweekattributes bd_ma_stylecolorweekattributes_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorweekattributes
    ADD CONSTRAINT bd_ma_stylecolorweekattributes_pk PRIMARY KEY (product, "time");


--
-- TOC entry 7054 (class 2606 OID 136965934)
-- Name: bd_ma_subclassattributes bd_ma_subclassattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_subclassattributes
    ADD CONSTRAINT bd_ma_subclassattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7056 (class 2606 OID 136965936)
-- Name: bd_p_channeloverride bd_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_p_channeloverride
    ADD CONSTRAINT bd_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 7058 (class 2606 OID 136965938)
-- Name: bd_p_dc_adj bd_p_dc_adj_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_p_dc_adj
    ADD CONSTRAINT bd_p_dc_adj_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7060 (class 2606 OID 136965943)
-- Name: bd_p_dc_adj_size bd_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_p_dc_adj_size
    ADD CONSTRAINT bd_p_dc_adj_size_pk UNIQUE (product, location, "time");


--
-- TOC entry 7003 (class 2606 OID 136965948)
-- Name: bd_p_itemprice bd_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_p_itemprice
    ADD CONSTRAINT bd_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7068 (class 2606 OID 136965950)
-- Name: bd_specimages bd_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_specimages
    ADD CONSTRAINT bd_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 7070 (class 2606 OID 136965958)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 7072 (class 2606 OID 136965960)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 7074 (class 2606 OID 136965962)
-- Name: dc_adj118dc858af1a4a37b8a85436d3ca5e8e dc_adj118dc858af1a4a37b8a85436d3ca5e8e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj118dc858af1a4a37b8a85436d3ca5e8e
    ADD CONSTRAINT dc_adj118dc858af1a4a37b8a85436d3ca5e8e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7076 (class 2606 OID 136965964)
-- Name: dc_adj2973fe04598a4392900a64b2eae20eec dc_adj2973fe04598a4392900a64b2eae20eec_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj2973fe04598a4392900a64b2eae20eec
    ADD CONSTRAINT dc_adj2973fe04598a4392900a64b2eae20eec_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7078 (class 2606 OID 136965966)
-- Name: dc_adj36bee73525a6417ba85a52653069782e dc_adj36bee73525a6417ba85a52653069782e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj36bee73525a6417ba85a52653069782e
    ADD CONSTRAINT dc_adj36bee73525a6417ba85a52653069782e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7080 (class 2606 OID 136965968)
-- Name: dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5 dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5
    ADD CONSTRAINT dc_adj4fbae77ce62d4a5c9cb566ee684aa0a5_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7082 (class 2606 OID 136965970)
-- Name: dc_adj5b984a493a54473c8a67bf0b9c577a36 dc_adj5b984a493a54473c8a67bf0b9c577a36_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj5b984a493a54473c8a67bf0b9c577a36
    ADD CONSTRAINT dc_adj5b984a493a54473c8a67bf0b9c577a36_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7084 (class 2606 OID 136965972)
-- Name: dc_adj7b4f9674bd6740469592d986ad488af2 dc_adj7b4f9674bd6740469592d986ad488af2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj7b4f9674bd6740469592d986ad488af2
    ADD CONSTRAINT dc_adj7b4f9674bd6740469592d986ad488af2_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7086 (class 2606 OID 136965974)
-- Name: dc_adj96da36850c474873a032da718ecc2330 dc_adj96da36850c474873a032da718ecc2330_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj96da36850c474873a032da718ecc2330
    ADD CONSTRAINT dc_adj96da36850c474873a032da718ecc2330_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7088 (class 2606 OID 136965976)
-- Name: dc_adjcc9dc91b484b44fcad0dd8a81db3b727 dc_adjcc9dc91b484b44fcad0dd8a81db3b727_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjcc9dc91b484b44fcad0dd8a81db3b727
    ADD CONSTRAINT dc_adjcc9dc91b484b44fcad0dd8a81db3b727_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7090 (class 2606 OID 136965978)
-- Name: dc_adjf6b910bcc96b4a72bd481286b530d9c7 dc_adjf6b910bcc96b4a72bd481286b530d9c7_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjf6b910bcc96b4a72bd481286b530d9c7
    ADD CONSTRAINT dc_adjf6b910bcc96b4a72bd481286b530d9c7_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7092 (class 2606 OID 136965980)
-- Name: dc_adjf81d06ee327d4c988bb4667653210585 dc_adjf81d06ee327d4c988bb4667653210585_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjf81d06ee327d4c988bb4667653210585
    ADD CONSTRAINT dc_adjf81d06ee327d4c988bb4667653210585_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7094 (class 2606 OID 136965982)
-- Name: dc_adjfef7258575ee48089181daf003e6e77d dc_adjfef7258575ee48089181daf003e6e77d_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjfef7258575ee48089181daf003e6e77d
    ADD CONSTRAINT dc_adjfef7258575ee48089181daf003e6e77d_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7096 (class 2606 OID 136965984)
-- Name: dc_adjfffd125e07344cd9b3ac7e3c44de8244 dc_adjfffd125e07344cd9b3ac7e3c44de8244_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjfffd125e07344cd9b3ac7e3c44de8244
    ADD CONSTRAINT dc_adjfffd125e07344cd9b3ac7e3c44de8244_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7098 (class 2606 OID 136965986)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 7100 (class 2606 OID 136965988)
-- Name: eve_ma_dptflrsetattributes eve_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.eve_ma_dptflrsetattributes
    ADD CONSTRAINT eve_ma_dptflrsetattributes_pkey PRIMARY KEY (indx);


--
-- TOC entry 7016 (class 2606 OID 136965990)
-- Name: bd_h_locdc exp01_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_h_locdc
    ADD CONSTRAINT exp01_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7102 (class 2606 OID 136965992)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 7107 (class 2606 OID 136965994)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 7109 (class 2606 OID 136965996)
-- Name: paged_pivot_blacklist paged_pivot_blacklist_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.paged_pivot_blacklist
    ADD CONSTRAINT paged_pivot_blacklist_pk PRIMARY KEY (pivot_request_id, parameter);


--
-- TOC entry 7113 (class 2606 OID 136965998)
-- Name: paged_pivot_meta paged_pivot_meta_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.paged_pivot_meta
    ADD CONSTRAINT paged_pivot_meta_pk PRIMARY KEY (pivot_request_id);


--
-- TOC entry 7115 (class 2606 OID 136966000)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 7117 (class 2606 OID 136966002)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7119 (class 2606 OID 136966004)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 7121 (class 2606 OID 136966006)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 7123 (class 2606 OID 136966008)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 7125 (class 2606 OID 136966010)
-- Name: shadow_lifecycleparams shadow_lifecycleparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.shadow_lifecycleparams
    ADD CONSTRAINT shadow_lifecycleparams_pkey PRIMARY KEY (product, __txid);


--
-- TOC entry 7127 (class 2606 OID 136966012)
-- Name: shadow_optionattributes shadow_optionattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.shadow_optionattributes
    ADD CONSTRAINT shadow_optionattributes_pkey PRIMARY KEY (product, __txid);


--
-- TOC entry 7129 (class 2606 OID 136966014)
-- Name: shadow_price shadow_price_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.shadow_price
    ADD CONSTRAINT shadow_price_pkey PRIMARY KEY (product, __txid);


--
-- TOC entry 7131 (class 2606 OID 136966016)
-- Name: shadow_styleattributes shadow_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.shadow_styleattributes
    ADD CONSTRAINT shadow_styleattributes_pkey PRIMARY KEY (product, __txid);


--
-- TOC entry 7133 (class 2606 OID 136966018)
-- Name: staging_lifecycleparams_prod_val staging_lifecycleparams_prod_val_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_lifecycleparams_prod_val
    ADD CONSTRAINT staging_lifecycleparams_prod_val_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7135 (class 2606 OID 136966020)
-- Name: staging_lifecycleparams_prod_val_reject staging_lifecycleparams_prod_val_reject_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_lifecycleparams_prod_val_reject
    ADD CONSTRAINT staging_lifecycleparams_prod_val_reject_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7137 (class 2606 OID 136966022)
-- Name: staging_optionattributes_prod_val staging_optionattributes_prod_val_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_optionattributes_prod_val
    ADD CONSTRAINT staging_optionattributes_prod_val_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7139 (class 2606 OID 136966024)
-- Name: staging_optionattributes_prod_val_reject staging_optionattributes_prod_val_reject_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_optionattributes_prod_val_reject
    ADD CONSTRAINT staging_optionattributes_prod_val_reject_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7141 (class 2606 OID 136966026)
-- Name: staging_price_prod_val staging_price_prod_val_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_price_prod_val
    ADD CONSTRAINT staging_price_prod_val_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7143 (class 2606 OID 136966028)
-- Name: staging_price_prod_val_reject staging_price_prod_val_reject_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_price_prod_val_reject
    ADD CONSTRAINT staging_price_prod_val_reject_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7145 (class 2606 OID 136966030)
-- Name: staging_styleattributes_prod_val staging_styleattributes_prod_val_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_styleattributes_prod_val
    ADD CONSTRAINT staging_styleattributes_prod_val_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7147 (class 2606 OID 136966032)
-- Name: staging_styleattributes_prod_val_reject staging_styleattributes_prod_val_reject_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_styleattributes_prod_val_reject
    ADD CONSTRAINT staging_styleattributes_prod_val_reject_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7151 (class 2606 OID 136966034)
-- Name: sync_stylecolorpublishes sync_stylecolorpublishes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.sync_stylecolorpublishes
    ADD CONSTRAINT sync_stylecolorpublishes_pkey PRIMARY KEY (product);


--
-- TOC entry 7153 (class 2606 OID 136966036)
-- Name: targetsetting targetsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.targetsetting
    ADD CONSTRAINT targetsetting_pkey PRIMARY KEY (id, version, type, scope_hash);


--
-- TOC entry 7005 (class 2606 OID 136966038)
-- Name: bd_authorization tb01_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_authorization
    ADD CONSTRAINT tb01_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 7000 (class 2606 OID 136966040)
-- Name: bd_ma_weekattributes tb01_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_weekattributes
    ADD CONSTRAINT tb01_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 7062 (class 2606 OID 136966042)
-- Name: bd_roledimension tb01_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_roledimension
    ADD CONSTRAINT tb01_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 7064 (class 2606 OID 136966044)
-- Name: bd_servicedefn tb01_servicedefn_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_servicedefn
    ADD CONSTRAINT tb01_servicedefn_pkey PRIMARY KEY (service);


--
-- TOC entry 7104 (class 2606 OID 136966046)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 7149 (class 2606 OID 136966048)
-- Name: sync_outbound_dataqueue uk_sync_outbound_dataqueue; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.sync_outbound_dataqueue
    ADD CONSTRAINT uk_sync_outbound_dataqueue UNIQUE (product, interface, "time", location);


--
-- TOC entry 7156 (class 2606 OID 136966050)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 7158 (class 2606 OID 136966052)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 7160 (class 2606 OID 136966054)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 7162 (class 2606 OID 136966056)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 6943 (class 1259 OID 136966057)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp.actuals_wide_denorm USING btree (time_halfyear, product_department, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 6944 (class 1259 OID 136966058)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp.actuals_wide_denorm USING btree (time_halfyear, product_division, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 6945 (class 1259 OID 136966059)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp.actuals_wide_denorm USING btree (time_halfyear, product_company, location_brand, prodlife_prodliferootlevel);


--
-- TOC entry 6936 (class 1259 OID 136966060)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp.actuals_wide USING btree ("time", product, location, prodlife);


--
-- TOC entry 6950 (class 1259 OID 136966121)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp.plan_data_wide USING hash (id);


--
-- TOC entry 6957 (class 1259 OID 136966972)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp.sys_gen_wide_denorm USING btree (time_halfyear, product_department, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 6958 (class 1259 OID 136966973)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp.sys_gen_wide_denorm USING btree (time_halfyear, product_division, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 6959 (class 1259 OID 136966974)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp.sys_gen_wide_denorm USING btree (time_halfyear, product_company, location_brand, prodlife_prodliferootlevel);


--
-- TOC entry 7012 (class 1259 OID 136966975)
-- Name: bd_eohdata_stylecolor_product_channel_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX bd_eohdata_stylecolor_product_channel_idx ON public.bd_eohdata_stylecolor USING btree (product, channel);


--
-- TOC entry 6982 (class 1259 OID 136966976)
-- Name: bd_h_prodstd_ancestor0_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor0_idx ON public.bd_h_prodstd USING btree (ancestor0);


--
-- TOC entry 6983 (class 1259 OID 136966980)
-- Name: bd_h_prodstd_ancestor1_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor1_idx ON public.bd_h_prodstd USING btree (ancestor1);


--
-- TOC entry 6984 (class 1259 OID 136966984)
-- Name: bd_h_prodstd_ancestor2_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor2_idx ON public.bd_h_prodstd USING btree (ancestor2);


--
-- TOC entry 6985 (class 1259 OID 136966991)
-- Name: bd_h_prodstd_ancestor3_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor3_idx ON public.bd_h_prodstd USING btree (ancestor3);


--
-- TOC entry 6986 (class 1259 OID 136966995)
-- Name: bd_h_prodstd_ancestor4_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor4_idx ON public.bd_h_prodstd USING btree (ancestor4);


--
-- TOC entry 6987 (class 1259 OID 136966996)
-- Name: bd_h_prodstd_ancestor5_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor5_idx ON public.bd_h_prodstd USING btree (ancestor5);


--
-- TOC entry 6988 (class 1259 OID 136967000)
-- Name: bd_h_prodstd_ancestor6_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX bd_h_prodstd_ancestor6_idx ON public.bd_h_prodstd USING btree (ancestor6);


--
-- TOC entry 7110 (class 1259 OID 136967001)
-- Name: paged_pivot_cache__page_group; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX paged_pivot_cache__page_group ON public.paged_pivot_cache USING hash (page_group);


--
-- TOC entry 7111 (class 1259 OID 136967002)
-- Name: paged_pivot_cache__pivot_request_id; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX paged_pivot_cache__pivot_request_id ON public.paged_pivot_cache USING hash (pivot_request_id);


--
-- TOC entry 7044 (class 1259 OID 136967003)
-- Name: sizeattr_parent_key; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX sizeattr_parent_key ON public.bd_ma_sizeattributes USING btree (parent_id);


--
-- TOC entry 7035 (class 1259 OID 136967004)
-- Name: tb01_ma_channelattributes_location; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tb01_ma_channelattributes_location ON public.bd_ma_channelattributes USING hash (location);


--
-- TOC entry 7001 (class 1259 OID 136967005)
-- Name: tb01_ma_weekattributes_time; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tb01_ma_weekattributes_time ON public.bd_ma_weekattributes USING hash ("time");


--
-- TOC entry 7105 (class 1259 OID 136967006)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 7154 (class 1259 OID 136967007)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 7183 (class 2620 OID 136967008)
-- Name: bd_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, exitdate ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.dbt_wk < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current)) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION store_eligibility_trigger();


--
-- TOC entry 7184 (class 2620 OID 136967012)
-- Name: bd_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.dbt_wk >= new.erlstmkdnwk) OR (old.dbt_wk < old.plan_current)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 7185 (class 2620 OID 136967013)
-- Name: bd_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.exitdate <= new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION exit_trigger_on_update_validity_check();


--
-- TOC entry 7186 (class 2620 OID 136967014)
-- Name: bd_ma_stylecolorchannelattributes item_removal_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER item_removal_trigger AFTER UPDATE OF record_state ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.record_state = 1) AND (old.record_state = 0))) EXECUTE FUNCTION queue_removal_update();


--
-- TOC entry 7187 (class 2620 OID 136967015)
-- Name: bd_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.erlstmkdnwk <= new.dbt_wk) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION md_trigger_on_update_validity_check();


--
-- TOC entry 7204 (class 2620 OID 136967016)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION notify_pivot_execution_change();


--
-- TOC entry 7205 (class 2620 OID 136967017)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION notify_plan_queue_change();


--
-- TOC entry 7202 (class 2620 OID 136967018)
-- Name: bd_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.bd_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION trigger_set_indx_valid_values();


--
-- TOC entry 7182 (class 2620 OID 136967019)
-- Name: bd_ma_stylecolorattributes set_timestamp; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.bd_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7179 (class 2620 OID 136967020)
-- Name: bd_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.bd_a_assortment FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7195 (class 2620 OID 136967021)
-- Name: bd_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.bd_p_channeloverride FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7196 (class 2620 OID 136967022)
-- Name: bd_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.bd_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7201 (class 2620 OID 136967023)
-- Name: bd_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.bd_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7197 (class 2620 OID 136967024)
-- Name: bd_p_dc_adj set_timestamp_p_dc_prepublish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_prepublish_adj BEFORE UPDATE OF is_prepublished ON public.bd_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_prepublish_timestamp();


--
-- TOC entry 7198 (class 2620 OID 136967025)
-- Name: bd_p_dc_adj set_timestamp_p_dc_prepublish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_prepublish_adj_ins BEFORE INSERT ON public.bd_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_prepublish_timestamp();


--
-- TOC entry 7199 (class 2620 OID 136967026)
-- Name: bd_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.bd_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_publish_timestamp();


--
-- TOC entry 7200 (class 2620 OID 136967027)
-- Name: bd_p_dc_adj set_timestamp_p_dc_publish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj_ins BEFORE INSERT ON public.bd_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_publish_timestamp();


--
-- TOC entry 7188 (class 2620 OID 136967028)
-- Name: bd_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7180 (class 2620 OID 136967029)
-- Name: bd_a_assortment trg_upd_assortment_phaseattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_phaseattr AFTER UPDATE OF a_cc_phase_story, a_cc_newness, a_cc_exposure ON public.bd_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION propagate_phaseattrs_to_floorsets();


--
-- TOC entry 7181 (class 2620 OID 136967030)
-- Name: bd_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF strterritory, strchannel, straccount, grade, ssg ON public.bd_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION propagate_assortment_to_floorsets();


--
-- TOC entry 7203 (class 2620 OID 136967031)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION update_trigger_cartparams_ranging();


--
-- TOC entry 7193 (class 2620 OID 136967032)
-- Name: bd_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.bd_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION update_eff_aur();


--
-- TOC entry 7189 (class 2620 OID 136967033)
-- Name: bd_ma_stylecolorchannelattributes trigger_for_time_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx AFTER INSERT OR UPDATE OF dbt_wk, erlstmkdnwk, exitdate ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.dbt_wk < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate))) EXECUTE FUNCTION update_week_indxes();


--
-- TOC entry 7194 (class 2620 OID 136967034)
-- Name: bd_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.bd_p_itemprice FOR EACH ROW EXECUTE FUNCTION itemprice_fetchdepartment();


--
-- TOC entry 7190 (class 2620 OID 136967035)
-- Name: bd_ma_stylecolorchannelattributes trigger_sizerangecode_isvalid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_isvalid AFTER UPDATE OF validsizes ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION sizerangecode_isvalid();


--
-- TOC entry 7191 (class 2620 OID 136967036)
-- Name: bd_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION sizerangecode_validsizes_members();


--
-- TOC entry 7192 (class 2620 OID 136967037)
-- Name: bd_ma_stylecolorchannelattributes trigger_update_price; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_price AFTER UPDATE OF ccticketpricechannel_base_gbp1, ccticketpricechannel_base_gbp2, ccticketpricechannel_base_aud, ccticketpricechannel_base_eur1, ccticketpricechannel_base_eur2, ccticketpricechannel_base_usd, ccticketpricechannel_override_gbp1, ccticketpricechannel_override_gbp2, ccticketpricechannel_override_aud, ccticketpricechannel_override_eur1, ccticketpricechannel_override_eur2, ccticketpricechannel_override_usd ON public.bd_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_ticket_prices();


--
-- TOC entry 7163 (class 2606 OID 136967038)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp.dimensions(id) ON DELETE CASCADE;


--
-- TOC entry 7164 (class 2606 OID 136967043)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp.dimensions(id) ON DELETE CASCADE;


--
-- TOC entry 7167 (class 2606 OID 136967048)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp.dimensions(id);


--
-- TOC entry 7165 (class 2606 OID 136967053)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp.plans(id) ON DELETE CASCADE;


--
-- TOC entry 7166 (class 2606 OID 136967058)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp.plans(id);


--
-- TOC entry 7168 (class 2606 OID 136967063)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp.dimensions(id);


--
-- TOC entry 7171 (class 2606 OID 136967068)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7172 (class 2606 OID 136967073)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7174 (class 2606 OID 136967078)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7169 (class 2606 OID 136967083)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES agent_conversations(conversation_id);


--
-- TOC entry 7170 (class 2606 OID 136967088)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES allocation_plan_queue(jobid);


--
-- TOC entry 7177 (class 2606 OID 136967093)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7178 (class 2606 OID 136967098)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7173 (class 2606 OID 136967103)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 7176 (class 2606 OID 136967108)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 7175 (class 2606 OID 136967113)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES user_metadata(uid);


--
-- TOC entry 7368 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:06:13 IST

--
-- PostgreSQL database dump complete
--

\unrestrict CfJJ9f46fBQrzdZ76JPBLGrfIrfOLRTqwUFVaRx1WOTfXxw0rhAlwTzGAgYka3i

