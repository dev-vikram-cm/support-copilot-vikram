-- ENV: QA | DB: tsn | dumped: 2026-10-01 15:08 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict hgf3LhGEFUb6KmNHrP833t3hiIWIp9iGbrrNqn4uge4NwLSBQMAMlV21MhhR8te

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:08:11 IST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 108253391)
-- Name: mfp; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp;


ALTER SCHEMA mfp OWNER TO psql;

--
-- TOC entry 8 (class 2615 OID 108253756)
-- Name: mfp_channel_plan; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp_channel_plan;


ALTER SCHEMA mfp_channel_plan OWNER TO psql;

--
-- TOC entry 9 (class 2615 OID 108254123)
-- Name: mfp_long_range; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp_long_range;


ALTER SCHEMA mfp_long_range OWNER TO psql;

--
-- TOC entry 10 (class 2615 OID 108254485)
-- Name: mfp_total_aeo; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp_total_aeo;


ALTER SCHEMA mfp_total_aeo OWNER TO psql;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 2 (class 3079 OID 97069988)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 6308 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1460 (class 1247 OID 108253494)
-- Name: approval; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp.approval OWNER TO psql;

--
-- TOC entry 1448 (class 1247 OID 108253410)
-- Name: permission; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp.permission OWNER TO psql;

--
-- TOC entry 1457 (class 1247 OID 108253478)
-- Name: scopetype; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE mfp.scopetype OWNER TO psql;

--
-- TOC entry 1538 (class 1247 OID 108253858)
-- Name: approval; Type: TYPE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TYPE mfp_channel_plan.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp_channel_plan.approval OWNER TO psql;

--
-- TOC entry 1523 (class 1247 OID 108253775)
-- Name: permission; Type: TYPE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TYPE mfp_channel_plan.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp_channel_plan.permission OWNER TO psql;

--
-- TOC entry 1535 (class 1247 OID 108253842)
-- Name: scopetype; Type: TYPE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TYPE mfp_channel_plan.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE mfp_channel_plan.scopetype OWNER TO psql;

--
-- TOC entry 1631 (class 1247 OID 108254226)
-- Name: approval; Type: TYPE; Schema: mfp_long_range; Owner: psql
--

CREATE TYPE mfp_long_range.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp_long_range.approval OWNER TO psql;

--
-- TOC entry 1610 (class 1247 OID 108254142)
-- Name: permission; Type: TYPE; Schema: mfp_long_range; Owner: psql
--

CREATE TYPE mfp_long_range.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp_long_range.permission OWNER TO psql;

--
-- TOC entry 1628 (class 1247 OID 108254210)
-- Name: scopetype; Type: TYPE; Schema: mfp_long_range; Owner: psql
--

CREATE TYPE mfp_long_range.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE mfp_long_range.scopetype OWNER TO psql;

--
-- TOC entry 1708 (class 1247 OID 108254588)
-- Name: approval; Type: TYPE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TYPE mfp_total_aeo.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp_total_aeo.approval OWNER TO psql;

--
-- TOC entry 1696 (class 1247 OID 108254504)
-- Name: permission; Type: TYPE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TYPE mfp_total_aeo.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp_total_aeo.permission OWNER TO psql;

--
-- TOC entry 1705 (class 1247 OID 108254572)
-- Name: scopetype; Type: TYPE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TYPE mfp_total_aeo.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE mfp_total_aeo.scopetype OWNER TO psql;

--
-- TOC entry 1156 (class 1247 OID 97070000)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 1159 (class 1247 OID 97070008)
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
-- TOC entry 1391 (class 1247 OID 134667864)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 488 (class 1255 OID 134295473)
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
s7_1 text;
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
s21_1 text;
s21_2 text;
s21_3 text;
s21_4 text;
s22 text;
s23 text;
s24 text;
s25 text;
s26 text;
s26_X text;
s27 text;
s28 text;
s28_1 text;
s28_X text;
s28_X1 text;
s28_X2 text;
s28_Y text;
s29 text;
s29_1 text;
s30 text;
s31 text;
s32 text;
s33 text;
s34 text;
s35 text;
s36 text;
s36_1 text;
s37 text;
s38 text;
s39 text;
s39_test text;
s40 text;
s41 text;
s41_1 text;
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
s51_1 text;
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

s100 text;
s101 text;
s102 text;
s103 text;
s104 text;
s104_a text;
s105 text;
s106 text;
s107 text;
s108 text;
s109 text;
s110 text;
s111 text;
s112 text;
s113 text;
s114 text;
s115 text;
s110_1 text;
s110_2 text;
s110_3 text;
s110_4 text;
s110_5 text;

s113_1 text;
s113_2 text;

tst_df_temp text;
tst_md_seq text;
tst_df text;
tst_df_with_style text;
tst_md_tktp_md text;

table_xt text;
table_yt text;
table_zt text;

table_xt_flag text;
table_zt_flow_flag text;
table_zt_pre text;
s_pre_110_1 text;
s113_post text;

s001_x text;
s002_x text;
s003_x text;
s004_x text;
s005_x text;
s006_x text;
s007_x text;
s008_x text;
s009_x text;
s010_x text;
v_already_ata integer;

BEGIN


--RETURN NULL;
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


tst_df_temp := 'tst_df_temp'||v_uuid;
tst_md_seq := 'tst_md_seq'||v_uuid;
tst_df := 'tst_df'||v_uuid;
tst_df_with_style := 'tst_df_with_style'||v_uuid;
tst_md_tktp_md := 'tst_md_tktp_md'||v_uuid;

table_xt := 'table_xt'||v_uuid;
table_yt := 'table_yt'||v_uuid;
table_zt := 'table_zt'||v_uuid;

table_xt_flag := 'table_xt_flag'||v_uuid;
table_zt_flow_flag := 'table_zt_flow_flag'||v_uuid;
table_zt_pre  := 'table_zt_pre'||v_uuid;


s1 := 'create temporary table '||table_input_t1||' as select '''||$1||''' as jsid,'''||$2||''' as scope_product,'''||$3||''' as scope_location ,'''||$4||''' as scope_start,'''||$5||''' as scope_floorset
    ';

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
    ,  initiator
    ,  null::text as cccolorfamily
    ,  null::text as cccolorid
    ,  cccolor    as cc_color_desc
    ,  null::text as color_name
    ,  null::text as cc_color_group
    ,  null::text as cc_color_code
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



s4_2 := '
    Update '||table_cart_master_temp||' a
    set class_id = b.ancestor1,
        subclass_id = b.ancestor0
    from aeo_h_prodstd b
    where
    b.id = a.incoming_style_id
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from aeo_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from aeo_d_product b
    where
    b.id = a.subclass_id
    ';



s5 := '
    create temporary table '||table_cart_stylecolor||' as
    select jsessionid
    , style_sequence
    , case when stylecolor_type = ''similar'' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = ''similar'' then style_name||color_code else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = ''similar'' then style_description ||'':''||color_description else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, a.cccolor
    , style_name, style_description, stylecolor_name, stylecolor_description, b.color_description, c.color_code
    from '||table_cart_master_temp||' a, 
    (select lookup_value as cccolor, target_value color_description from aeo_l_dependencylookup where target_id = ''color_description'' and lookup_id = ''cccolor'') b,
    (select lookup_value as cccolor, target_value color_code from aeo_l_dependencylookup where target_id = ''color_code'' and lookup_id = ''cccolor'') c
    where jsessionid in (select jsid from '||table_input_t1||') and a.cccolor = b.cccolor and a.cccolor = c.cccolor
    ) x
    '
    ;


s6 := '
    Update '||table_cart_master_temp||' a set
    final_stylecolor_id = b.final_stylecolor_id
    , stylecolor_name = displayed_stylecolor_name
    , stylecolor_description = displayed_stylecolor_description
    from '||table_cart_stylecolor||' b
    where
    a.incoming_stylecolor_id=b.incoming_stylecolor_id
    and a.cccolor = b.cccolor
    and a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.stylecolor_type=b.stylecolor_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    '
    ;



s7 := '
    CREATE temporary TABLE '||table_cart_stylecolorsize||' AS
    SELECT
           case when stylecolor_type=''similar'' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id
         , sizeattribute
         , incoming_stylecolor_id
         , incoming_style_id
         , final_style_id
         , final_stylecolor_id
         , stylecolor_name
         , stylecolor_description
         , stylecolor_type
         , jsessionid
         , size_code
         , size_name
         , isvalid
    FROM   (SELECT
           a.incoming_stylecolor_id
           , a.incoming_style_id
           , uuid_generate_v4()::text stylecolorsize_id
           , a.stylecolor_name
           , a.stylecolor_description
           , e.size_code
           , e.size_desc as size_name
           , target_value as sizeattribute
           , 1 as isvalid
           , a.jsessionid
           , a.style_type
           , a.stylecolor_type
           , a.final_style_id
           , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                 , aeo_ma_styleattributes c
                 , aeo_l_dependencylookup d
                 , aeo_size_range_mapping e
                 , '||table_cart_stylecolor||' f
          WHERE  c.product = a.incoming_style_id
            and d.lookup_value = e.sty_size_range and d.target_value = e.sizeattribute
            and lookup_id = ''size_range'' and lookup_value = c.sty_size_range
            and a.stylecolor_type=''similar''
            and a.jsessionid=f.jsessionid and a.final_stylecolor_id = f.final_stylecolor_id
          )x
          '
          ;

s7_1 := '
    insert into '||table_cart_stylecolorsize||'
    SELECT
           case when stylecolor_type=''similar'' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id
         , sizeattribute
         , incoming_stylecolor_id
         , incoming_style_id
         , final_style_id
         , final_stylecolor_id
         , stylecolor_name
         , stylecolor_description
         , stylecolor_type
         , jsessionid
         , size_code
         , size_name
         , isvalid
    FROM   (SELECT
           a.incoming_stylecolor_id
           , a.incoming_style_id
           , b.product stylecolorsize_id
           , a.stylecolor_name
           , a.stylecolor_description
           , b.parent_id
           , b.size_code
           , b.size_name
           , b.sizeattribute
           , b.isvalid
           , a.jsessionid
           , a.style_type
           , a.stylecolor_type
           , a.final_style_id
           , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                 , aeo_ma_sizeattributes b
                 , '||table_cart_stylecolor||' f
          WHERE  a.incoming_stylecolor_id = b.parent_id
          and a.stylecolor_type=''existing''
          and a.jsessionid=f.jsessionid and a.final_stylecolor_id = f.final_stylecolor_id
          )x
          '
          ;

EXECUTE s1;
-- insert into trigger_test_delete_me values ('s1:', clock_timestamp());
EXECUTE s2;
-- insert into trigger_test_delete_me values ('s2:', clock_timestamp());
EXECUTE s3;
-- insert into trigger_test_delete_me values ('s3:', clock_timestamp());
EXECUTE s4_1;
-- insert into trigger_test_delete_me values ('s4_1:', clock_timestamp());
EXECUTE s5;
-- insert into trigger_test_delete_me values ('s5:', clock_timestamp());
EXECUTE s6;
-- insert into trigger_test_delete_me values ('s6:', clock_timestamp());
EXECUTE s7;
-- insert into trigger_test_delete_me values ('s7:', clock_timestamp());
EXECUTE s7_1;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());

-- Check if the product is already in assortment. If yes then return

execute '
select count(*)
from (
select distinct a.product, a.location
from
(select distinct product,location  from aeo_ma_stylecolorchannelattributes where record_state = 0 and (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from aeo_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
where
a.product=b.product
and a.location=b.location
)x
' into v_already_ata;

if v_already_ata > 0 then
  s002_x := '
  insert into plan_queue (product, location, initiator, initiated_at)
  select final_stylecolor_id, '''||$3||''', initiator :: uuid, now() from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
  ';
  EXECUTE s002_x;
  s003_x := 'select final_stylecolor_id product from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')';
  
  s004_x := 'update cart_master set isProcessed=1 where jsessionid in (select jsid from  '||table_input_t1||')';
  EXECUTE s004_x;
  s005_x := 'insert into cart_master_archive select * from cart_master  where jsessionid in (select jsid from  '||table_input_t1||')';
  s006_x := 'insert into cart_params_archive select * from cart_params  where jsessionid in (select jsid from  '||table_input_t1||')';
  s007_x := 'insert into cart_ranging_archive select * from cart_ranging  where jsessionid in (select jsid from  '||table_input_t1||')';
  EXECUTE s005_x;
  EXECUTE s006_x;
  EXECUTE s007_x;
  s008_x := 'delete from cart_master where jsessionid in (select jsid from  '||table_input_t1||')';
  s009_x := 'delete from cart_params where jsessionid in (select jsid from  '||table_input_t1||')';
  s010_x := 'delete from cart_ranging where jsessionid in (select jsid from  '||table_input_t1||')';
  EXECUTE s008_x;
  EXECUTE s009_x;
  EXECUTE s010_x;
  OPEN added_prods FOR EXECUTE s003_x;
  
  RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();
  
   RETURN added_prods;
end if;

s8 := 'delete from aeo_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';


s9 := '
    INSERT INTO aeo_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT final_style_id AS id
       , COALESCE(displayed_style_name, ''S5-'' || nextval(''style_sequence'') || ''-'' || displayed_style_name) AS NAME
       , COALESCE(displayed_style_description, ''S5-'' || nextval(''style_sequence'') ||''-'' || displayed_style_description) AS description
       , ''style'' AS levelid
    FROM   '||table_cart_style||'
    WHERE style_type=''similar''
    ';



s10 := '
delete from aeo_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s11 := '
    INSERT INTO aeo_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT final_stylecolor_id              AS id
           , displayed_stylecolor_name        AS NAME
           , displayed_stylecolor_description AS description
           , ''stylecolor''             AS levelid
    FROM '||table_cart_stylecolor||'
    WHERE stylecolor_type=''similar''
    '
    ;




s12 := '
delete from aeo_d_product where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s13 := '
    INSERT INTO aeo_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT final_stylecolorsize_id            AS id
           , stylecolor_name || '':'' || size_name        AS NAME
           , stylecolor_description || '':'' || size_name AS description
           , ''stylecolorsize'' AS levelid
    FROM   '||table_cart_stylecolorsize||'
    WHERE stylecolor_type=''similar''
    '
    ;



-- CREATING HIERARCHY

s14 := '
delete from aeo_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s15 := '
INSERT INTO aeo_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
SELECT DISTINCT
                  final_style_id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
                , ancestor6
FROM   '||table_cart_master_temp||' a,
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from aeo_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
'
;



s16 := '
delete from aeo_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO aeo_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
SELECT DISTINCT
                  final_stylecolor_id
                , final_style_id
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
                , ancestor6
FROM   '||table_cart_master_temp||'   a,
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from aeo_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
'
;



s18 := '
delete from aeo_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO aeo_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
SELECT DISTINCT
                  final_stylecolorsize_id
                , final_stylecolor_id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
FROM    '||table_cart_stylecolorsize||'  a,
aeo_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s20 := '
delete from aeo_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from aeo_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''cccolorfamily'' and lookup_value=a.cccolor
';

s21_1 := '
update '||table_cart_master_temp||' a set cccolorid = b.target_value from aeo_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_id'' and lookup_value=a.cccolor
';

s21_2 := '
update '||table_cart_master_temp||' a set color_name = b.target_value from aeo_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_description'' and lookup_value=a.cccolor
';

s21_3 := '
update '||table_cart_master_temp||' a set cc_color_group = b.target_value from aeo_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_group'' and lookup_value=a.cccolor
';

s21_4 := '
update '||table_cart_master_temp||' a set cc_color_code = b.target_value from aeo_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_code'' and lookup_value=a.cccolor
';


s22 := '
delete from aeo_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s23 := '
delete from aeo_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';





s24 := '
insert into aeo_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


s25 := '
insert into aeo_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


-- STYLE ATTRIBUTES

S26 := '
INSERT INTO aeo_ma_styleattributes
            (product      
            , sty_e_top_bottom          
            , sty_b_end_use             
            , sty_c_division_specific_1 
            , sty_d_division_specific_2 
            , sty_e_q1                  
            , sty_f_hang_fold_packs     
            , sty_g_length              
            , sty_k_partnerships        
            , sty_l_q2                  
            , sty_m_q3                  
            , sty_n_q4                  
            , sty_spec_style            
            , sty_size_model_code       
            , sty_size_model_name       
            , ccstylecreatedate         
            , sty_size_range            
            , sty_vendor_id             
            , sty_vendor_name           
            , sty_spec_style_store_cad  
            , sty_spec_style_ecom_us    
            , sty_spec_style_ecom_cad   
            , sty_patterned_after       
            , sty_is_locked             
            , sty_s5_adopted            
            , sty_num_clones_s5         
            , sty_num_times_cloned_s5   
            )
SELECT final_style_id as product
            , sty_e_top_bottom          
            , sty_b_end_use             
            , null as sty_c_division_specific_1 
            , null as sty_d_division_specific_2 
            , sty_e_q1                  
            , sty_f_hang_fold_packs     
            , sty_g_length              
            , sty_k_partnerships        
            , null as sty_l_q2                  
            , null as sty_m_q3                  
            , null as sty_n_q4                  
            , null as sty_spec_style            
            , sty_size_model_code       
            , sty_size_model_name       
            , null as ccstylecreatedate         
            , sty_size_range            
            , sty_vendor_id             
            , sty_vendor_name           
            , null as sty_spec_style_store_cad  
            , null as sty_spec_style_ecom_us    
            , null as sty_spec_style_ecom_cad   
            , a.incoming_style_id as sty_patterned_after       
            , null as sty_is_locked             
            , ''Y'' as sty_s5_adopted            
            , null as sty_num_clones_s5         
            , null as sty_num_times_cloned_s5   
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name from '||table_cart_master_temp||') a, aeo_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
';


s26_X := '
Update aeo_ma_styleattributes b
set sty_is_locked = ''Y'', sty_s5_adopted = ''Y''
from (select distinct final_style_id, style_type, stylecolor_type, incoming_style_id  from '||table_cart_master_temp||') a
where a.incoming_style_id=b.product
and a.style_type=''existing'' and a.stylecolor_type=''existing''
';


-- STYLECOLOR ATTRIBUTES

s27 := '
delete from aeo_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



s28 := '
INSERT INTO aeo_ma_stylecolorattributes
        (product
         , cccolorid                                   
         , cccolor                                     
         , color_name                                  
         , cc_color_desc                               
         , cccolorfamily                               
         , cc_color_group                              
         , cc_color_code                               
         , ccstylecolorcreatedate                      
         , cc_size_range_code                          
         , cc_spec_stylecolor                          
         , cc_attribute_1                              
         , cc_attribute_2                              
         , cc_attribute_3                              
         , cc_attribute_4                              
         , cc_attribute_5                              
         , cc_attribute_6                              
         , cc_attribute_7                              
         , cc_assortment_architecture                  
         , cc_price_bucket                             
         , cc_a_module                                 
         , cc_c_responsive                             
         , cc_f_print_pattern                          
         , cc_g_color_family                           
         , cc_h_denim_wash                             
         , cc_i_fabric                                 
         , cc_j_logo                                   
         , cc_k_license_collab                         
         , cc_l_doorbuster                             
         , cc_m_exclusive                              
         , cc_n_dpc                                    
         , cc_h_placeholder_type_booking_track_testing 
         , cc_j_print_pattern_wash_color_family        
         , cc_spec_stylecolor_store_cad                
         , cc_spec_stylecolor_ecom_us                  
         , cc_spec_stylecolor_ecom_cad                 
         , stylecolor_open_1                           
         , stylecolor_open_2                           
         , stylecolor_open_3                           
         , stylecolor_open_4                           
         , stylecolor_open_5                           
         , stylecolor_open_6                           
         , stylecolor_open_7                           
         , stylecolor_open_8                           
         , stylecolor_open_9                           
         , stylecolor_open_10                          
         , stylecolor_name                             
         , style_name                                  
         , subclass_name                               
         , class_name                                  
         , department_name                             
         , division_name                               
         , brand_name                                  
         , isassortment                                
         , merch_comments                              
         , plan_comments                               
         , allocator_comments                          
         , cc_is_locked                                
         , cc_s5_adopted                               
         , cc_prepublish                               
         , cc_prepublished_at                          
         , cc_floorset                                 
         , cc_use_sys_floorset                         
         , cc_num_clones_s5                            
         , cc_num_times_cloned_s5                      
        )
SELECT final_stylecolor_id as product
         , a.cccolorid                                   
         , a.cccolor                                     
         , a.color_name                                  
         , a.cc_color_desc                               
         , a.cccolorfamily                               
         , a.cc_color_group                              
         , a.cc_color_code                               
         , null as ccstylecolorcreatedate                      
         , cc_size_range_code                          
         , null as cc_spec_stylecolor                          
         , cc_attribute_1                              
         , cc_attribute_2                              
         , cc_attribute_3                              
         , cc_attribute_4                              
         , cc_attribute_5                              
         , cc_attribute_6                              
         , cc_attribute_7                              
         , cc_assortment_architecture                  
         , cc_price_bucket                             
         , cc_a_module                                 
         , cc_c_responsive                             
         , cc_f_print_pattern                          
         , cc_g_color_family                           
         , cc_h_denim_wash                             
         , cc_i_fabric                                 
         , cc_j_logo                                   
         , cc_k_license_collab                         
         , cc_l_doorbuster                             
         , cc_m_exclusive                              
         , cc_n_dpc                                    
         , cc_h_placeholder_type_booking_track_testing 
         , cc_j_print_pattern_wash_color_family        
         , null as cc_spec_stylecolor_store_cad                
         , null as cc_spec_stylecolor_ecom_us                  
         , null as cc_spec_stylecolor_ecom_cad                 
         , null as stylecolor_open_1                           
         , null as stylecolor_open_2                           
         , null as stylecolor_open_3                           
         , null as stylecolor_open_4                           
         , null as stylecolor_open_5                           
         , null as stylecolor_open_6                           
         , null as stylecolor_open_7                           
         , null as stylecolor_open_8                           
         , null as stylecolor_open_9                           
         , null as stylecolor_open_10                          
         , a.stylecolor_name                             
         , a.style_name                                  
         , subclass_name                               
         , class_name                                  
         , department_name                             
         , division_name                               
         , brand_name                                  
         , ''true'' as isassortment                                
         , null as merch_comments                              
         , null as plan_comments                               
         , null as allocator_comments                          
         , null as cc_is_locked                                
         , ''Y'' as cc_s5_adopted                               
         , null as cc_prepublish                               
         , null as cc_prepublished_at                          
         , null as cc_floorset                                 
         , null as cc_use_sys_floorset                         
         , null as cc_num_clones_s5                            
         , null as cc_num_times_cloned_s5                      
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily,cccolorid,color_name,cc_color_desc,cc_color_group,cc_color_code, stylecolor_name, style_name  from '||table_cart_master_temp||') a, aeo_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
';


s28_X := '
Update aeo_ma_stylecolorattributes b
set isassortment = ''true'', cc_is_locked = ''Y'', cc_s5_adopted = ''Y''
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily  from '||table_cart_master_temp||') a
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
';

/*
s28_X1 := '
Update aeo_ma_stylecolorattributes b
set cc_price_band = a.price_band
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, usd_ticket_price, price_band  from '||table_cart_master_temp||' x, aeo_h_prodstd z, aeo_l_ticketprice y where x.final_stylecolor_id = z.id and z.ancestor3 = y.product) a
where a.final_stylecolor_id=b.product
and b.cc_orig_unit_retail = a.usd_ticket_price
and a.stylecolor_type=''similar''
';

s28_X2 := '
Update aeo_ma_stylecolorattributes b
set cc_good_better_best = a.price_band
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, subclass_id, ticket_price_min, ticket_price_max, price_band  from '||table_cart_master_temp||' x, aeo_l_pricebandlookup y where x.subclass_id = y.product) a
where a.final_stylecolor_id=b.product
and b.cc_orig_unit_retail > ticket_price_min and b.cc_orig_unit_retail <= ticket_price_max
and a.stylecolor_type=''similar''
';
*/

-- IMAGE ATTRIBUTES START

s29 := 'drop table if exists '||table_ma_imgattr||'';

s29_1 := '
create temporary table '||table_spec_img||' as
select
 distinct si.product, si.img, sa.product as stylecolor_id
from aeo_specimages si
 inner join
aeo_ma_stylecolorattributes sa
 on sa.product = si.product
where sa.product in (select final_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from '||table_input_t1||'));
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
  (select distinct product, img from aeo_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, stylecolor_id from '||table_spec_img||') d
on
d.stylecolor_id = c.final_stylecolor_id;

'
;


s31 := '
delete from aeo_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;

s32 := '
insert into aeo_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES

s33 := '
delete from aeo_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';



s34 := '
insert into aeo_ma_sizeattributes
    (product,
    parent_id,
    sizeattribute,
    size_code,
    size_name,
    isvalid
    )
SELECT
    distinct final_stylecolorsize_id,
    final_stylecolor_id,
    sizeattribute,
    size_code,
    size_name,
    isvalid
FROM
    '||table_cart_stylecolorsize||'
WHERE stylecolor_type = ''similar''
';

PERFORM get_default_params(''||$1||'',''||$2||'',''||$3||'',''||$4||'',''||$5||'');

-- STYLECOLOR CHANNEL ATTRIBUTES

s35 := '
create temporary  table '||table_default_cart_params||' as
select
    a.jsessionid
  , a.scope_product
  , a.scope_location
  , a.initrcptwk  as default_initrcptwk
  , a.dbt_wk as default_dbt_wk
  , a.too as default_too
  , a.mkdnwks as default_mkdnwks
  , a.last_inv_wk as default_last_inv_wk
  , a.lstfpwk as default_lstfpwk
  , a.last_rcpt_wk as default_last_rcpt_wk
  , a.erlstmkdnwk as default_erlstmkdnwk
  , a.exitdate as default_exitdate
  , a.ccmdstrategy as default_ccmdstrategy
  , a.presmin as default_presmin
  , a.presmin_weeks as default_presmin_weeks
  , a.retpct_str as default_retpct_str
  , a.retpct_ecomm as default_retpct_ecom
  , a.retpct_cross as default_retpct_cross
  , a.ccrcptint as default_ccrcptint
  , a.ccordermultiple as default_ccordermultiple
  , a.ccordpolicy as default_ccordpolicy
  , a.slsrnk_store
  , a.slsrnk_ecom
  , a.planned_sell_down_week
  , c.default_ccdiscountpct
  , c.default_lead_time
  , a.cc_cluster_group

-- CA MOD 08.14.2025
  , a.use_act_aps_or_act_rank as use_act_aps_or_act_rank
  , a.use_valid_sizes_from as use_valid_sizes_from
  , a.apply_size_mins_to as apply_size_mins_to
  , a.cc_addoff_store as cc_addoff_store
  , a.cc_addoff_ecom as cc_addoff_ecom

  , a.cc_service_level as cc_service_level
  , a.cc_service_level_ecom as cc_service_level_ecom

from (select distinct * from cart_params) a, aeo_ma_dptflrsetattributes c, '||table_input_t1||' b
where a.jsessionid = b.jsid
and a.scope_product = b.scope_product
and a.scope_location = b.scope_location
and a.scope_start = b.scope_start
and a.scope_product = c.product
and a.scope_floorset = c.time
'
;


s36 := '
create  temporary table '||table_temp_sclr_chnl_attr||' as
select
    a.jsessionid
  , final_stylecolor_id as product
  , a.scope_location as location
  , default_initrcptwk as initrcptwk
  , default_dbt_wk as dbt_wk
  , default_too as too
  , default_mkdnwks as mkdnwks
  , default_last_inv_wk as last_inv_wk
  , default_lstfpwk as lstfpwk
  , default_last_rcpt_wk as last_rcpt_wk
  , default_erlstmkdnwk as erlstmkdnwk
  , default_exitdate as exitdate

  , coalesce(default_ccmdstrategy, ccmdstrategy) ccmdstrategy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , cc_validsizes_store
  , cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
    , coalesce(default_ccordermultiple::int, cc_ordermultiple::int) cc_ordermultiple
  , null::real as cc_systemcost

  -- =================================
  -- CA MOD 08.12.2025 START

              -- , a.slsrnk_store
              -- , a.slsrnk_ecom

   , CASE
      WHEN a.use_act_aps_or_act_rank = ''Use Cart Rating'' THEN a.slsrnk_store
      ELSE COALESCE(b.act_slsrnk_store, b.slsrnk_store)
    END AS slsrnk_store

  , COALESCE(b.act_aps_mult_adj_store, 1) as act_aps_mult_adj_store

  , CASE
      WHEN a.use_act_aps_or_act_rank = ''Use Cart Rating'' THEN a.slsrnk_ecom
      ELSE COALESCE(b.act_slsrnk_ecom, b.slsrnk_ecom)
    END AS slsrnk_ecom
  , COALESCE(b.act_aps_mult_adj_ecom, 1) as act_aps_mult_adj_ecom

  , a.use_act_aps_or_act_rank as use_act_aps_or_act_rank

  , a.use_valid_sizes_from
  , a.apply_size_mins_to
  , a.cc_addoff_store
  , a.cc_addoff_ecom

   -- CA MOD 08.12.2025 END
  -- =================================


  , default_retpct_str as cc_return_u_pct_store
  , default_retpct_ecom as cc_return_u_pct_ecom
  , default_retpct_cross as cc_return_u_pct_cross

  -- MODIFIED BY CA on 03.29.2025
  -- , coalesce(b.cc_systemcost, e.cc_unit_cost, b.cc_plan_cost ) as cc_plan_cost
  -- , coalesce(b.cc_systemcost, e.cc_unit_cost, b.cc_plan_cost ) as cc_final_cost

  , coalesce(b.cc_plan_cost, .01::real) as cc_plan_cost

  , coalesce(b.cc_plan_cost, .01::real) as cc_final_cost

  , a.planned_sell_down_week
  , b.ccticketpricechannel
  , a.default_ccdiscountpct

  , coalesce(round(((b.ccticketpricechannel-coalesce(b.cc_plan_cost, .01::real))/b.ccticketpricechannel)::numeric, 2),0.0) as cc_imupct 
  , a.default_lead_time as cc_lead_time
  , a.cc_cluster_group

  , a.cc_service_level
  , a.cc_service_level_ecom

  , b.cc_orig_unit_retail
  , b.cc_orig_unit_retail_store_cad
  , b.cc_orig_unit_retail_ecom_us
  , b.cc_orig_unit_retail_ecom_cad


FROM
'||table_default_cart_params||' a, aeo_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||' where style_type = ''similar'') c,
 aeo_ma_stylecolorattributes d, aeo_ma_stylecolorattributes e
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location and c.final_stylecolor_id = d.product
and e.product=c.incoming_stylecolor_id
';


s36_1 := '
insert into '||table_temp_sclr_chnl_attr||'
select
    a.jsessionid
  , final_stylecolor_id as product
  , a.scope_location as location
  , default_initrcptwk as initrcptwk
  , default_dbt_wk as dbt_wk
  , default_too as too
  , default_mkdnwks as mkdnwks
  , default_last_inv_wk as last_inv_wk
  , default_lstfpwk as lstfpwk
  , default_last_rcpt_wk as last_rcpt_wk
  , default_erlstmkdnwk as erlstmkdnwk
  , default_exitdate as exitdate

  , coalesce(default_ccmdstrategy, ccmdstrategy) ccmdstrategy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , cc_validsizes_store
  , cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(default_ccordermultiple::int, cc_ordermultiple::int) cc_ordermultiple
  , cc_systemcost

  -- =================================
  -- CA MOD 08.12.2025 START

              -- , a.slsrnk_store
              -- , a.slsrnk_ecom

  , COALESCE(e.act_slsrnk_store, e.slsrnk_store) as slsrnk_store
  , COALESCE(e.act_aps_mult_adj_store, 1) as act_aps_mult_adj_store

  , COALESCE(e.act_slsrnk_ecom, e.slsrnk_ecom) as slsrnk_ecom
  , COALESCE(e.act_aps_mult_adj_ecom, 1) as act_aps_mult_adj_ecom

  , a.use_act_aps_or_act_rank as use_act_aps_or_act_rank

  , a.use_valid_sizes_from
  , a.apply_size_mins_to
  , a.cc_addoff_store
  , a.cc_addoff_ecom

   -- CA MOD 08.12.2025 END
  -- =================================

  , default_retpct_str as cc_return_u_pct_store
  , default_retpct_ecom as cc_return_u_pct_ecom
  , default_retpct_cross as cc_return_u_pct_cross
  , cc_plan_cost

    , cc_plan_cost as cc_final_cost
  -- , case when cc_systemcost is not null then cc_systemcost when d.cc_unit_cost is not null then d.cc_unit_cost else cc_plan_cost end as cc_final_cost
  
  , a.planned_sell_down_week
  , e.ccticketpricechannel
  , a.default_ccdiscountpct
  , coalesce(round(((e.ccticketpricechannel-coalesce(e.cc_plan_cost, .01::real))/e.ccticketpricechannel)::numeric, 2),0.0) as cc_imupct 

  , a.default_lead_time as cc_lead_time
  , a.cc_cluster_group

  , a.cc_service_level
  , a.cc_service_level_ecom

  , e.cc_orig_unit_retail
  , e.cc_orig_unit_retail_store_cad
  , e.cc_orig_unit_retail_ecom_us
  , e.cc_orig_unit_retail_ecom_cad
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id, style_type from '||table_cart_master_temp||' where style_type = ''existing'') b,
aeo_ma_styleattributes c, 
aeo_ma_stylecolorattributes d,
aeo_ma_stylecolorchannelattributes e
--(select array_agg(target_value) as validsizes, lookup_value as sty_size_run_name from aeo_l_dependencylookup where lookup_id = ''size_range'' group by lookup_value) e
where a.jsessionid=b.jsessionid 
and b.final_style_id = c.product 
and b.final_stylecolor_id = d.product 
and b.incoming_stylecolor_id = e.product
and a.scope_location = e.location
--and c.sty_size_range = e.sty_size_run_name 
'
;



s37 := '
delete from aeo_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into aeo_ma_stylecolorchannelattributes (
  product
, location
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
, ccrangecode
, ssnprf
, validsizes
, cc_validsizes_store
, cc_validsizes_ecom
, cc_presmin
, cc_presmin_weeks
, cc_rcptint
, cc_ordermultiple
, cc_imupct
, cc_systemcost
-- , slsrnk_store
-- , slsrnk_ecom
, ccticketpricechannel
, cc_return_u_pct_store
, cc_return_u_pct_ecom
, cc_return_u_pct_cross
, cc_plan_cost
, cc_final_cost
, planned_sell_down_week
, cc_discount_pct
, cc_lead_time
, irw_debut_offset
, cc_cluster_group

  -- =================================
  -- CA MOD 08.12.2025 START

              -- , a.slsrnk_store
              -- , a.slsrnk_ecom

  , slsrnk_store
  , act_aps_mult_adj_store
  , slsrnk_ecom
  , act_aps_mult_adj_ecom

  , use_act_aps_or_act_rank

  , use_valid_sizes_from
  , apply_size_mins_to
  , cc_addoff_store
  , cc_addoff_ecom

   -- CA MOD 08.12.2025 END
  -- =================================
  , cc_service_level
  , cc_service_level_ecom

  , cc_orig_unit_retail
  , cc_orig_unit_retail_store_cad
  , cc_orig_unit_retail_ecom_us
  , cc_orig_unit_retail_ecom_cad

)
select
  product
, location
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
, ccrangecode
, ssnprf
, ''{}''::text[]
, cc_validsizes_store
, cc_validsizes_ecom
, cc_presmin
, cc_presmin_weeks
, cc_rcptint
, cc_ordermultiple
, cc_imupct
, cc_systemcost
-- , slsrnk_store
-- , slsrnk_ecom
, ccticketpricechannel
, cc_return_u_pct_store
, cc_return_u_pct_ecom
, cc_return_u_pct_cross
, cc_plan_cost
, cc_final_cost
, planned_sell_down_week
, default_ccdiscountpct
, cc_lead_time
, b.irw_debut_offset
, a.cc_cluster_group

  -- =================================
  -- CA MOD 08.12.2025 START

              -- , a.slsrnk_store
              -- , a.slsrnk_ecom

  , slsrnk_store
  , act_aps_mult_adj_store
  , slsrnk_ecom
  , act_aps_mult_adj_ecom
  
  , use_act_aps_or_act_rank

  , use_valid_sizes_from
  , apply_size_mins_to
  , cc_addoff_store
  , cc_addoff_ecom

   -- CA MOD 08.12.2025 END
  -- =================================
  , cc_service_level
  , cc_service_level_ecom

  , cc_orig_unit_retail
  , cc_orig_unit_retail_store_cad
  , cc_orig_unit_retail_ecom_us
  , cc_orig_unit_retail_ecom_cad
FROM
 '||table_temp_sclr_chnl_attr||' a, 
(select b.id, ap_start, ap_end, irw_debut_offset
      from aeo_ma_dptflrsetattributes a, aeo_h_prodstd b
      where b.ancestor3 = a.product and b.id in (select product from '||table_temp_sclr_chnl_attr||')
     ) b
where a.product = b.id
and a.dbt_wk between ap_start and ap_end;
 ';




-- ASSORTMENT MODEL

s51 := '
update aeo_ma_stylecolorchannelattributes a
set plan_current = v_plan_current,
    ccrangecode = d.ccrangecode,
    use_valid_sizes_from = d.use_valid_sizes_from
from (select value as v_plan_current from aeo_serviceparams where id=''plan_current'') b,
     aeo_ma_stylecolorattributes c, (select product, ccrangecode, use_valid_sizes_from from '||table_temp_sclr_chnl_attr||') d
where (a.product, a.location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product = c.product
and a.product = d.product
';

/*
-- When adding a color to an exsting style, we will take the max of various attributes and cost for the parent style and apply them to the newly added stylecolor
s51_1 := '
update aeo_ma_stylecolorchannelattributes a
set
  ccrangecode = rangecode
 ,cc_validsizes_store = cc_validsizes_store_existing
 ,cc_validsizes_ecom = cc_validsizes_ecom_existing
 ,ccticketpricechannel = cast(coalesce(cc_msrp::real, .01) as real)
 ,cc_ordpolicy = cc_ordpolicy_existing
 ,cc_ordermultiple = cc_ordermultiple_existing
 ,cc_existingwac = cast(coalesce(cc_existingwac_existing::real,0.0) as real)
 ,cc_systemcost = cast(coalesce(cc_systemcost_existing::real,0.0) as real)
 ,cc_plan_cost = cast(coalesce(cc_plan_cost_existing::real,0.0) as real)
 ,cc_landed_cost = cast(coalesce(cc_landed_cost_existing::real,0.0) as real)
 ,cc_target_cost = cast(coalesce(cc_target_cost_existing::real,0.0) as real)
 --,cc_imupct = coalesce(round((((cc_msrp::real-coalesce(cc_actual_cost,cc_estimated_cost)::real)/cc_msrp::real)::numeric), 2)::real,0.0)::real
from 
(
  select x.sty_size_range || '' - '' || y.ancestor2 as rangecode, a.cc_validsizes_store_existing, a.cc_validsizes_ecom_existing, style_type, cc_msrp, cc_unit_retail, a.cc_ordpolicy_existing, a.cc_ordermultiple_existing, a.cc_existingwac_existing, 
        a.cc_systemcost_existing, a.cc_plan_cost_existing,a.cc_landed_cost_existing, a.cc_target_cost_existing
  from 
    aeo_ma_styleattributes x, 
    aeo_h_prodstd y, 
    aeo_ma_stylecolorattributes d,
    (
      select distinct final_stylecolor_id, final_style_id, style_type 
      from  '||table_cart_master_temp||' 
      where jsessionid in (select jsid from  '||table_input_t1||') and style_type = ''existing''
    ) z,
    (
      select a.ancestor0, max(b.cc_validsizes_store) as cc_validsizes_store_existing, max(b.cc_validsizes_ecom) as cc_validsizes_ecom_existing, max(b.cc_ordpolicy) as cc_ordpolicy_existing, 
             max(b.cc_ordermultiple) as cc_ordermultiple_existing, max(b.cc_existingwac) as cc_existingwac_existing, max(b.cc_systemcost) as cc_systemcost_existing, max(b.cc_plan_cost) as cc_plan_cost_existing, 
             max(b.cc_landed_cost) as cc_landed_cost_existing, max(b.cc_target_cost) as cc_target_cost_existing
      from aeo_h_prodstd a
      join aeo_ma_stylecolorchannelattributes b
      on a.id = b.product
      where a.ancestor0 in (select distinct final_style_id from  '||table_cart_master_temp||')
      group by a.ancestor0 
    ) a
    where x.product = z.final_style_id 
    and y.id = z.final_stylecolor_id 
    and d.product = z.final_stylecolor_id
    and x.product = a.ancestor0
) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';
*/


s39 := '
    create temporary table '||table_temp_assort||' AS
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(str_grade as text[]) as str_grade
        , cast(str_climate as text[]) as str_climate
        , cast(str_region_combo as text[]) as str_region_combo
        , cast(str_hvlc as text[]) as str_hvlc
        , cast(str_tourist_border_combo as text[]) as str_tourist_border_combo
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , store_count
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c,
    aeo_ma_stylecolorattributes d
    where a.jsessionid=c.jsessionid
    and a.jsessionid = b.jsid
    and a.scope_product = b.scope_product
    and a.scope_location = b.scope_location
    and a.scope_start = b.scope_start
    and c.final_stylecolor_id = d.product
    '
    ;

s39_test := 'insert into jrtest_S5391 select * from ' || table_temp_assort;

s40 := '
delete from aeo_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';

s41 := '

    insert into aeo_a_assortment (
          product
        , location
        , "time"
        , str_grade
        , str_climate
        , str_region_combo
        , str_hvlc
        , str_tourist_border_combo
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style)
    SELECT
          product
        , location
        , "time"
        , str_grade
        , str_climate
        , str_region_combo
        , str_hvlc
        , str_tourist_border_combo
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
    FROM
       '||table_temp_assort||'
';



RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

s42 := '
create temporary table '||table_final_list||' AS
select distinct a.product, a.location
from
(select distinct product,location  from aeo_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from aeo_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
where
a.product=b.product
and a.location=b.location
';



s43 := '
insert into plan_queue (product, location, initiator, initiated_at)
select final_stylecolor_id, '''||$3||''', initiator :: uuid, now() from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')
';

s43_1 := 'select final_stylecolor_id product from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
    and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')';



s44 := 'update cart_master set isProcessed=1 where jsessionid in (select jsid from  '||table_input_t1||')';

s45 := 'insert into cart_master_archive select * from cart_master  where jsessionid in (select jsid from  '||table_input_t1||')';
s46 := 'insert into cart_params_archive select * from cart_params  where jsessionid in (select jsid from  '||table_input_t1||')';
s47 := 'insert into cart_ranging_archive select * from cart_ranging  where jsessionid in (select jsid from  '||table_input_t1||')';

s48 := 'delete from cart_master where jsessionid in (select jsid from  '||table_input_t1||')';
s49 := 'delete from cart_params where jsessionid in (select jsid from  '||table_input_t1||')';
s50 := 'delete from cart_ranging where jsessionid in (select jsid from  '||table_input_t1||')';
insert into debug_stats_ts values ('s1',s1,now());


s100 := 'CREATE TEMPORARY TABLE '||tst_df_temp||' AS
          SELECT
              product,
              COALESCE(relaunchweek,dbt_wk) as dbt_wk,
              last_rcpt_wk,
              erlstmkdnwk,
              exitdate,
              ccmdstrategy,
              cc_discount_pct,
              in_season_flag,
              id AS time,
              case when id < erlstmkdnwk then ''FP'' else ''MD'' end as price_status
          FROM aeo_ma_stylecolorchannelattributes AS a
          , aeo_d_time AS b
          WHERE (id >= COALESCE(relaunchweek,dbt_wk)) AND (id <= exitdate) AND product in (select product from '||table_temp_sclr_chnl_attr||')
          ORDER BY
              product ASC,
              id ASC
          ';

s101 := 'CREATE TEMPORARY TABLE '||tst_md_seq||' AS
          SELECT
              *,
              row_number() OVER (PARTITION BY product ORDER BY time ASC) AS seq
          FROM '||tst_df_temp||'
          WHERE price_status = ''MD''
          ';

s102 := 'CREATE TEMPORARY TABLE '||tst_df||' AS
          SELECT *
          FROM
          (
              SELECT
                  product,
                  dbt_wk,
                  last_rcpt_wk,
                  erlstmkdnwk,
                  exitdate,
                  time,
                  price_status,
                  0 AS seq,
                  ccmdstrategy,
                  cc_discount_pct,
                  in_season_flag
              FROM '||tst_df_temp||' AS a
              WHERE price_status = ''FP''
              UNION ALL
              SELECT
                  product,
                  dbt_wk,
                  last_rcpt_wk,
                  erlstmkdnwk,
                  exitdate,
                  time,
                  price_status,
                  seq,
                  ccmdstrategy,
                  cc_discount_pct,
                  in_season_flag
              FROM '||tst_md_seq||' AS b
              WHERE price_status = ''MD''
          ) AS x
          ORDER BY
              product ASC,
              time ASC,
              seq ASC
    ';

s103 := 'CREATE TEMPORARY TABLE '||tst_df_with_style||' AS
          SELECT
              a.*,
              b.ancestor0 AS style,
              ancestor1 AS subclass,
              ancestor3 as department
          FROM '||tst_df||' AS a
          ,
          (
              SELECT
                  id,
                  ancestor0,
                  ancestor1,
                  ancestor3
              FROM aeo_h_prodstd
              WHERE id IN
              (
                  SELECT product
                  FROM '||tst_df||'
              )
          ) AS b
          WHERE a.product = b.id
          ';


s104 := 'CREATE TEMPORARY TABLE '||tst_md_tktp_md||' as
            select x.*
            , 0::real as ccticketprice
            , 0::real as md_disc
            , 0::real corpaddoff
            , 0::real corpexcl
            , 0::real addoff
            , null::real expressed_aur
            , 0::real curp
            , 0::real selling_price
            , 0::real v_A
            , 0::real v_B
            , null::text weekdate
            FROM
            (select a.* from '||tst_df_with_style||' a, aeo_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.ccticketpricechannel::real, curp=ccticketpricechannel::real
          from aeo_ma_stylecolorchannelattributes b
          where a.product = b.product
          ';

s105 := 'update '||tst_md_tktp_md||' a
            set md_disc=b.md_disc, curp=ccticketprice * (1 - b.md_disc)
          from md_strategy b
          where a.seq=b.seq and a.ccmdstrategy=b.mdstrategy
          and a.seq > 0
          ';

s106 := 'update '||tst_md_tktp_md||' a
            set corpaddoff=b.corpaddoff, corpexcl=b.corpexcl
          from aeo_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff
          from aeo_p_itemprice b
          where a.product=b.product and a.time=b.time
        ';

s108 := 'update '||tst_md_tktp_md||' a
            set v_A=b.v_A
          FROM
            (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A from '||tst_md_tktp_md||') b
          WHERE a.product=b.product and a.time=b.time
          ';

s109 := 'update '||tst_md_tktp_md||' a
            set v_B=b.v_B
          FROM
            (select product, time, seq, addoff, corpaddoff
              , case when seq=0 then
                  (case when expressed_aur > 0 then expressed_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
               else curp end as v_B
               from '||tst_md_tktp_md||'
            ) b
          WHERE a.product=b.product and a.time=b.time
          ';

S_PRE_110_1 := 'CREATE TEMPORARY TABLE '||table_xt_flag||' AS
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, aeo_d_time b, aeo_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from aeo_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from aeo_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from aeo_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from aeo_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from aeo_ma_weekattributes b where a.time=b.time';


s111 := 'CREATE TEMPORARY TABLE '||table_xt||' AS
        select *,
            case when ''ECOM''=ANY(str_grade) then ''ECOM'' else ''STORE'' END as selling_channel
        FROM
        (
          SELECT
              x.*,
              y.id,
              y.indx
          FROM
          (
              SELECT
                  product,
                  location,
                  time AS floorset,
                  store_count,
                  str_grade,
                  isfunded,
                  ancestor3 AS department
              FROM (select * from aeo_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM aeo_h_prodstd where id in (select product from '||tst_md_tktp_md||')
              ) AS b
              WHERE (a.product = b.id)
          ) AS x
          ,
          (
              SELECT
                  product AS department,
                  a.time AS floorset,
                  b.id,
                  b.indx
              FROM aeo_ma_dptflrsetattributes AS a
              , aeo_d_time AS b
              WHERE (b.id >= a.ap_start) AND (b.id <= a.ap_end)
          ) AS y
          WHERE (x.department = y.department) AND (x.floorset = y.floorset)
        ) z
        ';
/*
s112 := 'CREATE TEMPORARY TABLE '||table_yt||' AS
          select
          product
          , location
          , case when ch02 is null then 0 else 1 end as store_count
          , isfunded
          , id as time
          , indx
          , ch02 as selling_channel
          from '||table_xt||' where ch02 = ''CH-02''
          UNION ALL
          select
          product
          , location
          , case when ch01 is null then 0 else case when ch02 is null then store_count else store_count - 1 end end as store_count
          , isfunded
          , id as time
          , indx
          , ch01 as selling_channel
          from '||table_xt||' where ch01 = ''CH-01''
          UNION ALL
          select
          product
          , location
          , store_count
          , isfunded
          , id as time
          , indx
          , ch03 as selling_channel
          from '||table_xt||' where ch03 = ''CH-03''
        ';
*/
s113 := 'CREATE TEMPORARY TABLE '||table_zt_pre||' AS
          SELECT *
          FROM
          (
              SELECT
                  a.product,
                  a.location AS channel,
                  a.id as time,
                  a.indx,
                  a.selling_channel,
                  a.isfunded,
                  a.store_count,
                  b.in_season_flag,
                  b.dbt_wk,
                  b.last_rcpt_wk,
                  b.erlstmkdnwk,
                  b.exitdate,
                  b.weekdate,
                  b.price_status,
                  b.seq,
                  b.ccticketprice,
                  b.curp,
                  b.selling_price,
                  b.expressed_aur,
                  b.corpexcl,
                  b.addoff,
                  b.corpaddoff,
                  b.v_A,
                  b.v_B,
                  b.cc_discount_pct
              FROM '||table_xt||' AS a
              , '||tst_md_tktp_md||' AS b
              WHERE (a.product = b.product) AND (a.id = b.time)
          ) AS x
          WHERE time >= (select value from aeo_serviceparams where id=''plan_current'')
          AND time <= (select value from aeo_serviceparams where id=''plan_end'')
        ';

s113_1 := 'CREATE TEMPORARY TABLE '||table_zt_flow_flag||'
              AS
              SELECT a.product, a.selling_channel, a.time, a.indx, dbt_wk_indx, last_rcpt_wk_indx
              , CASE when (indx >= dbt_wk_indx and indx < (dbt_wk_indx + 4)) then ''NEW''
                  ELSE
                    CASE when (indx >= (dbt_wk_indx + 4) AND indx < (last_rcpt_wk_indx + 4)) then ''FLOW''
                      ELSE ''LOF''
                    END
                END as flow_flag
              from '||table_zt_pre||' a, '||table_xt_flag||' b
              WHERE a.product=b.product
              ';

s113_2 := 'CREATE TEMPORARY TABLE '||table_zt||'
           AS
           select a.*, flow_flag from '||table_zt_pre||' a, '||table_zt_flow_flag||' b
           WHERE a.product=b.product and a.selling_channel=b.selling_channel and a.time=b.time
           ';


s114 := 'delete from aeo_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into aeo_an_price_storecount_info
          select
            product
            , channel
            , time
            , selling_channel
            , isfunded
            , store_count
            , in_season_flag
            , dbt_wk
            , last_rcpt_wk
            , erlstmkdnwk
            , exitdate
            , weekdate
            , price_status
            , seq
            , ccticketprice
            , curp
            , selling_price
            , expressed_aur
            , corpexcl
            , addoff
            , corpaddoff
            , v_A
            , v_B
            , cc_discount_pct
            , flow_flag
          from
          '||table_zt||'
          ';

/*
RAISE NOTICE 'INPUT:%', 'START:'|| now();
RAISE NOTICE 's1:%', s1;
RAISE NOTICE 's2:%', s2;
RAISE NOTICE 's3:%', s3;
RAISE NOTICE 's4_1:%', s4_1;
RAISE NOTICE 's5:%', s5;
RAISE NOTICE 's6:%', s6;
RAISE NOTICE 's7:%', s7;
RAISE NOTICE 's7_1:%', s7_1;


RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

RAISE NOTICE 's8:%', s8;
RAISE NOTICE 's9: %', s9;
RAISE NOTICE 's10: %', s10;
RAISE NOTICE 's11: %', s11;
RAISE NOTICE 's12: %', s12;
RAISE NOTICE 's13: %', s13;
RAISE NOTICE 's14: %', s14;
RAISE NOTICE 's15: %', s15;
RAISE NOTICE 's16: %', s16;
RAISE NOTICE 's17: %', s17;
RAISE NOTICE 's18: %', s18;
RAISE NOTICE 's19: %', s19;


RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();
RAISE NOTICE 's20: %', s20;
RAISE NOTICE 's21: %', s21;
RAISE NOTICE 's21_1: %', s21_1;
RAISE NOTICE 's21_2: %', s21_2;
RAISE NOTICE 's21_3: %', s21_3;
RAISE NOTICE 's21_4: %', s21_4;
RAISE NOTICE 's22: %', s22;
RAISE NOTICE 's23: %', s23;
RAISE NOTICE 's24: %', s24;
RAISE NOTICE 's25: %', s25;
RAISE NOTICE 's26: %', s26;
RAISE NOTICE 's26_X: %', s26_X;
RAISE NOTICE 's27: %', s27;
RAISE NOTICE 's28: %', s28;
RAISE NOTICE 's28_X: %', s28_X;
RAISE NOTICE 's28_X1: %', s28_X1;
RAISE NOTICE 's28_X2: %', s28_X2;
RAISE NOTICE 's29: %', s29;
RAISE NOTICE 's29_1: %', s29_1;
RAISE NOTICE 's30: %', s30;
RAISE NOTICE 's31: %', s31;
RAISE NOTICE 's32: %', s32;
RAISE NOTICE 's33: %', s33;
RAISE NOTICE 's34: %', s34;
RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();
RAISE NOTICE 's35: %', s35;
RAISE NOTICE 's36: %', s36;
RAISE NOTICE 's36_1: %', s36_1;
RAISE NOTICE 's37: %', s37;
RAISE NOTICE 's38: %', s38;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();
RAISE NOTICE 's51: %', s51;
RAISE NOTICE 's51_1: %', s51_1;
RAISE NOTICE 's39: %', s39;
RAISE NOTICE 's40: %', s40;
RAISE NOTICE 's41: %', s41;

RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();
RAISE NOTICE 's42: %', s42;
RAISE NOTICE 's43: %', s43;
RAISE NOTICE 's44: %', s44;
RAISE NOTICE 's45: %', s45;
RAISE NOTICE 's46: %', s46;
RAISE NOTICE 's47: %', s47;
RAISE NOTICE 's48: %', s48;
RAISE NOTICE 's49: %', s49;
RAISE NOTICE 's50: %', s50;
*/

-- s110_6 :=  'drop table if exists tst_md_tktp_md';
-- s110_7 :=  'create table tst_md_tktp_md as select * from '||tst_md_tktp_md||'';
-- s110_8 :=  'drop table if exists table_zt';
-- s110_9 :=  'create table table_zt as select * from '||table_zt||'';
-- insert into trigger_test_delete_me values ('s0:', clock_timestamp());
EXECUTE s8;
-- insert into trigger_test_delete_me values ('s8:', clock_timestamp());
EXECUTE s9;
-- insert into trigger_test_delete_me values ('s9:', clock_timestamp());
EXECUTE s10;
-- insert into trigger_test_delete_me values ('s10:', clock_timestamp());
EXECUTE s11;
-- insert into trigger_test_delete_me values ('s11:', clock_timestamp());
EXECUTE s13;
-- insert into trigger_test_delete_me values ('s13:', clock_timestamp());
EXECUTE s14;
-- insert into trigger_test_delete_me values ('s14:', clock_timestamp());
EXECUTE s15;
-- insert into trigger_test_delete_me values ('s15:', clock_timestamp());
EXECUTE s16;
-- insert into trigger_test_delete_me values ('s16:', clock_timestamp());
EXECUTE s17;
-- insert into trigger_test_delete_me values ('s17:', clock_timestamp());
EXECUTE s19;
-- insert into trigger_test_delete_me values ('s19:', clock_timestamp());
EXECUTE s20;
-- insert into trigger_test_delete_me values ('s20:', clock_timestamp());
EXECUTE s21;
-- insert into trigger_test_delete_me values ('s21:', clock_timestamp());
EXECUTE s21_1;
-- insert into trigger_test_delete_me values ('s21_1:', clock_timestamp());
EXECUTE s21_2;
-- insert into trigger_test_delete_me values ('s21_2:', clock_timestamp());
EXECUTE s21_3;
-- insert into trigger_test_delete_me values ('s21_3:', clock_timestamp());
EXECUTE s21_4;
-- insert into trigger_test_delete_me values ('s21_4:', clock_timestamp());
EXECUTE s22;
-- insert into trigger_test_delete_me values ('s22:', clock_timestamp());
EXECUTE s23;
-- insert into trigger_test_delete_me values ('s23:', clock_timestamp());
EXECUTE s24;
-- insert into trigger_test_delete_me values ('s24:', clock_timestamp());
EXECUTE s25;
-- insert into trigger_test_delete_me values ('s25:', clock_timestamp());
EXECUTE s26;
-- insert into trigger_test_delete_me values ('s26:', clock_timestamp());
EXECUTE s26_X;
-- insert into trigger_test_delete_me values ('s26_X:', clock_timestamp());
EXECUTE s27;
-- insert into trigger_test_delete_me values ('s27:', clock_timestamp());
EXECUTE s28;
-- insert into trigger_test_delete_me values ('s28:', clock_timestamp());
EXECUTE s28_X;
-- insert into trigger_test_delete_me values ('s28_X:', clock_timestamp());
--EXECUTE s28_X1;
-- insert into trigger_test_delete_me values ('s28_X1:', clock_timestamp());
--EXECUTE s28_X2;
-- insert into trigger_test_delete_me values ('s28_X2:', clock_timestamp());
EXECUTE s29;
-- insert into trigger_test_delete_me values ('s29:', clock_timestamp());
EXECUTE s29_1;
-- insert into trigger_test_delete_me values ('s29_1:', clock_timestamp());
EXECUTE s30;
-- insert into trigger_test_delete_me values ('s30:', clock_timestamp());
EXECUTE s31;
-- insert into trigger_test_delete_me values ('s31:', clock_timestamp());
EXECUTE s32;
-- insert into trigger_test_delete_me values ('s32:', clock_timestamp());
EXECUTE s33;
-- insert into trigger_test_delete_me values ('s33:', clock_timestamp());
EXECUTE s34;
-- insert into trigger_test_delete_me values ('s34:', clock_timestamp());
EXECUTE s35;
-- insert into trigger_test_delete_me values ('s35:', clock_timestamp());
EXECUTE s36;
-- insert into trigger_test_delete_me values ('s36:', clock_timestamp());
EXECUTE s36_1;
-- insert into trigger_test_delete_me values ('s36_1:', clock_timestamp());
EXECUTE s37;
-- insert into trigger_test_delete_me values ('s37:', clock_timestamp());
EXECUTE s38;
-- insert into trigger_test_delete_me values ('s38:', clock_timestamp());
EXECUTE s51;
-- insert into trigger_test_delete_me values ('s51:', clock_timestamp());
--EXECUTE s51_1;
-- insert into trigger_test_delete_me values ('s51_1:', clock_timestamp());
EXECUTE s39;
-- insert into trigger_test_delete_me values ('s39:', clock_timestamp());
--EXECUTE s39_test;
-- insert into trigger_test_delete_me values ('s39_test:', clock_timestamp());
EXECUTE s40;
-- insert into trigger_test_delete_me values ('s40:', clock_timestamp());
EXECUTE s41;
-- insert into trigger_test_delete_me values ('s41:', clock_timestamp());
EXECUTE s42;
-- insert into trigger_test_delete_me values ('s42:', clock_timestamp());
EXECUTE s43;
-- insert into trigger_test_delete_me values ('s43:', clock_timestamp());
EXECUTE s44;
-- insert into trigger_test_delete_me values ('s44:', clock_timestamp());
EXECUTE s45;
-- insert into trigger_test_delete_me values ('s45:', clock_timestamp());
EXECUTE s46;
-- insert into trigger_test_delete_me values ('s46:', clock_timestamp());
EXECUTE s47;
-- insert into trigger_test_delete_me values ('s47:', clock_timestamp());
EXECUTE s48;
-- insert into trigger_test_delete_me values ('s48:', clock_timestamp());
EXECUTE s49;
-- insert into trigger_test_delete_me values ('s49:', clock_timestamp());
EXECUTE s50;
-- insert into trigger_test_delete_me values ('s50:', clock_timestamp());
EXECUTE s100 ;
-- insert into trigger_test_delete_me values ('s100:', clock_timestamp());
EXECUTE s101 ;
-- insert into trigger_test_delete_me values ('s101:', clock_timestamp());
EXECUTE s102 ;
-- insert into trigger_test_delete_me values ('s102:', clock_timestamp());
EXECUTE s103 ;
-- insert into trigger_test_delete_me values ('s103:', clock_timestamp());
EXECUTE s104 ;
-- insert into trigger_test_delete_me values ('s104:', clock_timestamp());
EXECUTE s104_a ;
-- insert into trigger_test_delete_me values ('s104_a:', clock_timestamp());
EXECUTE s105 ;
-- insert into trigger_test_delete_me values ('s105:', clock_timestamp());
EXECUTE s106 ;
-- insert into trigger_test_delete_me values ('s106:', clock_timestamp());
EXECUTE s107 ;
-- insert into trigger_test_delete_me values ('s107:', clock_timestamp());
EXECUTE s108 ;
-- insert into trigger_test_delete_me values ('s108:', clock_timestamp());
EXECUTE s109 ;
-- insert into trigger_test_delete_me values ('s109:', clock_timestamp());
EXECUTE s_pre_110_1;
-- insert into trigger_test_delete_me values ('s_pre_110_1:', clock_timestamp());
EXECUTE s110 ;
-- insert into trigger_test_delete_me values ('s110:', clock_timestamp());
EXECUTE s110_1;
-- insert into trigger_test_delete_me values ('s110_1:', clock_timestamp());
EXECUTE s110_2;
-- insert into trigger_test_delete_me values ('s110_2:', clock_timestamp());
EXECUTE s110_3;
-- insert into trigger_test_delete_me values ('s110_3:', clock_timestamp());
EXECUTE s110_4;
-- insert into trigger_test_delete_me values ('s110_4:', clock_timestamp());
EXECUTE s110_5;
-- insert into trigger_test_delete_me values ('s110_5:', clock_timestamp());
EXECUTE s111 ;
-- insert into trigger_test_delete_me values ('s111:', clock_timestamp());
--EXECUTE s112 ;
-- insert into trigger_test_delete_me values ('s112:', clock_timestamp());
EXECUTE s113 ;
-- insert into trigger_test_delete_me values ('s113:', clock_timestamp());
EXECUTE s113_1 ;
-- insert into trigger_test_delete_me values ('s113_1:', clock_timestamp());
EXECUTE s113_2 ;
-- insert into trigger_test_delete_me values ('s113_2:', clock_timestamp());
EXECUTE s114 ;
-- insert into trigger_test_delete_me values ('s114:', clock_timestamp());
EXECUTE s115 ;
-- insert into trigger_test_delete_me values ('s115:', clock_timestamp());
OPEN added_prods FOR EXECUTE s43_1;

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();


 RETURN added_prods;

END;
$_$;


ALTER FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 529 (class 1255 OID 134295512)
-- Name: aeo_no_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.aeo_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE aeo_style_clone_flat_map_temp AS
    SELECT * 
    FROM (
        /*
        SELECT DISTINCT
            from_style        AS from_id,
            to_new_style      AS to_id,
            'style'           AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , to_new_style_name as to_name
            , to_new_style_desc as to_desc
            , '' as cccolor
            , '' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND session_id = v_session_id

        UNION ALL
        */        
        SELECT DISTINCT
            from_stylecolor   AS from_id,
            to_new_stylecolor AS to_id,
            'stylecolor'      AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , to_new_stylecolor_name as to_name
            , to_new_stylecolor_desc as to_desc
            , RIGHT(to_new_stylecolor_name, 8) as cccolor
            , 'TBD' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND session_id = v_session_id

        UNION ALL
        SELECT DISTINCT
            from_stylecolorsize   AS from_id,
            to_new_stylecolorsize AS to_id,
            'stylecolorsize'      AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , '' as to_name 
            , '' as to_desc
            , '' as cccolor
            , '' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO aeo_d_product (
            id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
        )
        SELECT DISTINCT 
              to_id
            , null as client_id
            , CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END
            , CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END 
            , a.levelid
            , indx
            
            , now()::date
            , version_id
            , now()
            , v_pivot_user_id
            , now()
            , v_pivot_user_id
            , record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_d_product b
        WHERE a.from_id = b.id
        ;

/*
    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_style,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

*/
    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_stylecolor,
            to_new_style,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_stylecolorsize,
            to_new_stylecolor,
            to_new_style,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

/*
    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_styleattributes (
            product,
            sty_knit_or_woven,
            sty_fabrication,
            sty_sleeve_length,
            sty_leg_opening,
            sty_brand,
            sty_body_style_silhouette,
            sty_occasion_usage,
            sty_detail,
            sty_finish_style,
            sty_private_label,
            sty_license,
            sty_license_vs_non_licensed,
            sty_hazmat_code,
            sty_prop_65_warning,
            sty_material_content,
            sty_item_type,
            sty_dwrise,
            sty_length,
            sty_neckline,
            sty_toeshape,
            sty_heel_height,
            sty_bottom_length,
            sty_v_360_smoothing,
            sty_franchise,
            sty_key_item,
            sty_single_vs_multi_pack,
            sty_ticket_type,
            sty_spec_style,
            sty_size_range,
            ccstylecreatedate,
            sty_is_locked,
            sty_s5_adopted,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            plm_size_range,
            sty_knit_fit,
            sty_patterned_after,
            sty_spec_style_desc
        )
        SELECT
            to_id,
            sty_knit_or_woven,
            sty_fabrication,
            sty_sleeve_length,
            sty_leg_opening,
            sty_brand,
            sty_body_style_silhouette,
            sty_occasion_usage,
            sty_detail,
            sty_finish_style,
            sty_private_label,
            sty_license,
            sty_license_vs_non_licensed,
                null as sty_hazmat_code,
                null as sty_prop_65_warning,
            sty_material_content,
            sty_item_type,
            sty_dwrise,
            sty_length,
            sty_neckline,
            sty_toeshape,
            sty_heel_height,
            sty_bottom_length,
            sty_v_360_smoothing,
            sty_franchise,
            sty_key_item,
            sty_single_vs_multi_pack,
                null as sty_ticket_type,
                null as sty_spec_style,
            sty_size_range,
                null as ccstylecreatedate,
                null as sty_is_locked,
                null as sty_s5_adopted,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
                null as plm_size_range,
                sty_knit_fit,
                sty_patterned_after,
                null as sty_spec_style_desc
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
*/   
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_stylecolorattributes (
            product,
            cccolorid,
            cccolor,
            color_name,
            cc_color_desc,
            cccolorfamily,
            cc_color_group,
            cc_color_code,
            ccstylecolorcreatedate,
            cc_size_range_code,
            cc_spec_stylecolor,
            cc_attribute_1,
            cc_attribute_2,
            cc_attribute_3,
            cc_attribute_4,
            cc_attribute_5,
            cc_attribute_6,
            cc_attribute_7,
            cc_assortment_architecture,
            cc_price_bucket,
            cc_a_module,
            cc_c_responsive,
            cc_f_print_pattern,
            cc_g_color_family,
            cc_h_denim_wash,
            cc_i_fabric,
            cc_j_logo,
            cc_k_license_collab,
            cc_l_doorbuster,
            cc_m_exclusive,
            cc_n_dpc,
            cc_h_placeholder_type_booking_track_testing,
            cc_j_print_pattern_wash_color_family,
            cc_spec_stylecolor_store_cad,
            cc_spec_stylecolor_ecom_us,
            cc_spec_stylecolor_ecom_cad,
            stylecolor_open_1,
            stylecolor_open_2,
            stylecolor_open_3,
            stylecolor_open_4,
            stylecolor_open_5,
            stylecolor_open_6,
            stylecolor_open_7,
            stylecolor_open_8,
            stylecolor_open_9,
            stylecolor_open_10,
            stylecolor_name,
            style_name,
            subclass_name,
            class_name,
            department_name,
            division_name,
            brand_name,
            isassortment,
            merch_comments,
            plan_comments,
            allocator_comments,
            cc_is_locked,
            cc_s5_adopted,
            cc_prepublish,
            cc_prepublished_at,
            cc_floorset,
            cc_use_sys_floorset,
            cc_num_clones_s5,
            cc_num_times_cloned_s5,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            to_id,
            null as cccolorid,
            a.cccolor as cccolor,
            null as olor_name,
            null as cc_color_desc,
            a.cccolorfamily as cccolorfamily,
            null as cc_color_group,
            null as cc_color_code,
            null as ccstylecolorcreatedate,
            cc_size_range_code,
            null as cc_spec_stylecolor,
            cc_attribute_1,
            cc_attribute_2,
            cc_attribute_3,
            cc_attribute_4,
            cc_attribute_5,
            cc_attribute_6,
            cc_attribute_7,
            cc_assortment_architecture,
            cc_price_bucket,
            cc_a_module,
            cc_c_responsive,
            cc_f_print_pattern,
            cc_g_color_family,
            cc_h_denim_wash,
            cc_i_fabric,
            cc_j_logo,
            cc_k_license_collab,
            cc_l_doorbuster,
            cc_m_exclusive,
            cc_n_dpc,
            cc_h_placeholder_type_booking_track_testing,
            cc_j_print_pattern_wash_color_family,
            null as cc_spec_stylecolor_store_cad,
            null as cc_spec_stylecolor_ecom_us,
            null as cc_spec_stylecolor_ecom_cad,
            null as stylecolor_open_1,
            null as stylecolor_open_2,
            null as stylecolor_open_3,
            null as stylecolor_open_4,
            null as stylecolor_open_5,
            null as stylecolor_open_6,
            null as stylecolor_open_7,
            null as stylecolor_open_8,
            null as stylecolor_open_9,
            null as stylecolor_open_10,
            stylecolor_name,
            style_name,
            subclass_name,
            class_name,
            department_name,
            division_name,
            brand_name,
            isassortment,
            null as merch_comments,
            null as plan_comments,
            null as allocator_comments,
            null as cc_is_locked,
            cc_s5_adopted,
            null as cc_prepublish,
            null as cc_prepublished_at,
            null as cc_floorset,
            null as cc_use_sys_floorset,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_sizeattributes (
            product,
            parent_id,
            size_code,
            size_name,
            sizeattribute,
            isvalid,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            ccstylecolorsizecreatedate
        )
        SELECT
            to_new_stylecolorsize,
            to_new_stylecolor,
            size_code,
            size_name,
            sizeattribute,
            isvalid,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            NULL
        FROM aeo_style_clone_stylecolor_size a,
             aeo_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_stylecolorchannelattributes (
            product,
            location,
            dbt_wk,
            relaunchweek,
            erlstmkdnwk,
            exitdate,
            initrcptwk,
            too,
            mkdnwks,
            last_inv_wk,
            lstfpwk,
            last_rcpt_wk,
            lastdcorder,
            act_initrcptwk,
            act_dbt_wk,
            irw_indx,
            dbtwk_indx,
            relaunchwk_indx,
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            preview_wks,
            preview_qty,
            plannedselldnwk,
            ccmdstrategy,
            slsrnk_store,
            slsrnk_ecom,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            cc_presmin,
            cc_presmin_weeks,
            cc_rcptint,
            cc_return_u_pct_store,
            cc_return_u_pct_ecom,
            cc_return_u_pct_cross,
            cc_ordermultiple,
            cc_ordermin,
            cc_buy_aps_letter,
            ccticketpricechannel,
            ccticketpricechannel_override,
            cc_imupct,
            cc_discount_pct,
            cc_existingwac,
            cc_systemcost,
            cc_plan_cost,
            ssnprf,
            adjaps_store,
            adjaps_ecom,
            smoothing_strategy,
            in_season_flag,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            keep_initial_range_plan,
            cc_sizeelig_rangecode,
            cc_presmin_stylecolor,
            cc_presmin_weeks_stylecolor,
            cc_final_cost,
            cc_discount_pct_store,
            cc_discount_pct_ecom,
            irw_debut_offset,
            cc_service_level_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            sclr_alloc_max,
            sclr_presmin,
            sclr_alloc_min,
            sclr_presmin_weeks,
            sclr_tgt_fwoc,
            sclr_fringe_flag,
            act_slsrnk_store,
            act_aps_store,
            act_aps_mult_adj_store,
            act_slsrnk_ecom,
            act_aps_ecom,
            act_aps_mult_adj_ecom,
            use_act_aps_or_act_rank,
            use_valid_sizes_from,
            apply_size_mins_to,
            cc_addoff_store,
            cc_addoff_ecom,
            irw_floorset,
            irw_superset,
            irw_floorset_display,
            irw_superset_display,
            irw_floorset_id,
            cc_size_eligibility_profile,
            cloned_at,
            initrcptwk_store_cad,
            initrcptwk_ecom_us,
            initrcptwk_ecom_cad,
            irw_debut_offset_store_cad,
            irw_debut_offset_ecom_us,
            irw_debut_offset_ecom_cad,
            dbt_wk_store_cad,
            dbt_wk_ecom_us,
            dbt_wk_ecom_cad,
            too_store_cad,
            too_ecom_us,
            too_ecom_cad,
            erlstmkdnwk_store_cad,
            erlstmkdnwk_ecom_us,
            erlstmkdnwk_ecom_cad,
            mkdnwks_store_cad,
            mkdnwks_ecom_us,
            mkdnwks_ecom_cad,
            exitdate_store_cad,
            exitdate_ecom_us,
            exitdate_ecom_cad,
            last_rcpt_wk_store_cad,
            last_rcpt_wk_ecom_us,
            last_rcpt_wk_ecom_cad,
            slsrnk_store_cad,
            slsrnk_ecom_cad,
            cc_addoff_ecom_cad,
            cc_addoff_store_cad,
            cc_orig_unit_retail,
            cc_orig_unit_retail_store_cad,
            cc_orig_unit_retail_ecom_us,
            cc_orig_unit_retail_ecom_cad,
            cc_plan_cost_store_cad,
            cc_plan_cost_ecom_us,
            cc_plan_cost_ecom_cad,
            cc_systemcost_store_cad,
            cc_systemcost_ecom_us,
            cc_systemcost_ecom_cad,
            cc_discount_pct_store_cad,
            cc_discount_pct_ecom_us,
            cc_discount_pct_ecom_cad,
            ccmdstrategy_store_cad,
            ccmdstrategy_ecom_us,
            ccmdstrategy_ecom_cad,
            cc_validsizes_store_cad,
            cc_validsizes_ecom_cad,
            cc_service_level_store_cad,
            cc_service_level_ecom_cad,
            cc_presmin_store_cad,
            cc_presmin_ecom_us,
            cc_presmin_ecom_cad,
            cc_presmin_weeks_store_cad,
            cc_presmin_weeks_ecom_us,
            cc_presmin_weeks_ecom_cad,
            cc_rcptint_store_cad,
            cc_rcptint_ecom_us,
            cc_rcptint_ecom_cad,
            cc_ordermin_store_cad,
            cc_ordermin_ecom_us,
            cc_ordermin_ecom_cad,
            cc_lead_time_store_cad,
            cc_lead_time_ecom_us,
            cc_lead_time_ecom_cad,
            cc_return_u_pct_store_cad,
            cc_return_u_pct_ecom_cad,
            cc_ordermultiple_store_cad,
            cc_ordermultiple_ecom_us,
            cc_ordermultiple_ecom_cad,
            ccticketpricechannel_store_cad,
            ccticketpricechannel_ecom_us,
            ccticketpricechannel_ecom_cad,
            ccticketpricechannel_store_cad_override,
            ccticketpricechannel_ecom_us_override,
            ccticketpricechannel_ecom_cad_override
        )
        SELECT
            to_id,
            location,
            dbt_wk,
            relaunchweek,
            erlstmkdnwk,
            exitdate,
            initrcptwk,
            too,
            mkdnwks,
            last_inv_wk,
            lstfpwk,
            last_rcpt_wk,
            lastdcorder,
            act_initrcptwk,
            act_dbt_wk,
            irw_indx,
            dbtwk_indx,
            relaunchwk_indx,
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            preview_wks,
            preview_qty,
            plannedselldnwk,
            ccmdstrategy,
            slsrnk_store,
            slsrnk_ecom,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            cc_presmin,
            cc_presmin_weeks,
            cc_rcptint,
            cc_return_u_pct_store,
            cc_return_u_pct_ecom,
            cc_return_u_pct_cross,
            cc_ordermultiple,
            cc_ordermin,
            cc_buy_aps_letter,
            ccticketpricechannel,
            ccticketpricechannel_override,
            cc_imupct,
            cc_discount_pct,
            cc_existingwac,
            cc_systemcost,
            cc_plan_cost,
            ssnprf,
            adjaps_store,
            adjaps_ecom,
            smoothing_strategy,
            in_season_flag,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            1 as record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            keep_initial_range_plan,
            cc_sizeelig_rangecode,
            cc_presmin_stylecolor,
            cc_presmin_weeks_stylecolor,
            cc_final_cost,
            cc_discount_pct_store,
            cc_discount_pct_ecom,
            irw_debut_offset,
            cc_service_level_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            sclr_alloc_max,
            sclr_presmin,
            sclr_alloc_min,
            sclr_presmin_weeks,
            sclr_tgt_fwoc,
            sclr_fringe_flag,
            act_slsrnk_store,
            act_aps_store,
            act_aps_mult_adj_store,
            act_slsrnk_ecom,
            act_aps_ecom,
            act_aps_mult_adj_ecom,
            use_act_aps_or_act_rank,
            use_valid_sizes_from,
            apply_size_mins_to,
            cc_addoff_store,
            cc_addoff_ecom,
            irw_floorset,
            irw_superset,
            irw_floorset_display,
            irw_superset_display,
            irw_floorset_id,
            cc_size_eligibility_profile,
            now(),
            initrcptwk_store_cad,
            initrcptwk_ecom_us,
            initrcptwk_ecom_cad,
            irw_debut_offset_store_cad,
            irw_debut_offset_ecom_us,
            irw_debut_offset_ecom_cad,
            dbt_wk_store_cad,
            dbt_wk_ecom_us,
            dbt_wk_ecom_cad,
            too_store_cad,
            too_ecom_us,
            too_ecom_cad,
            erlstmkdnwk_store_cad,
            erlstmkdnwk_ecom_us,
            erlstmkdnwk_ecom_cad,
            mkdnwks_store_cad,
            mkdnwks_ecom_us,
            mkdnwks_ecom_cad,
            exitdate_store_cad,
            exitdate_ecom_us,
            exitdate_ecom_cad,
            last_rcpt_wk_store_cad,
            last_rcpt_wk_ecom_us,
            last_rcpt_wk_ecom_cad,
            slsrnk_store_cad,
            slsrnk_ecom_cad,
            cc_addoff_ecom_cad,
            cc_addoff_store_cad,
            cc_orig_unit_retail,
            cc_orig_unit_retail_store_cad,
            cc_orig_unit_retail_ecom_us,
            cc_orig_unit_retail_ecom_cad,
            cc_plan_cost_store_cad,
            cc_plan_cost_ecom_us,
            cc_plan_cost_ecom_cad,
            cc_systemcost_store_cad,
            cc_systemcost_ecom_us,
            cc_systemcost_ecom_cad,
            cc_discount_pct_store_cad,
            cc_discount_pct_ecom_us,
            cc_discount_pct_ecom_cad,
            ccmdstrategy_store_cad,
            ccmdstrategy_ecom_us,
            ccmdstrategy_ecom_cad,
            cc_validsizes_store_cad,
            cc_validsizes_ecom_cad,
            cc_service_level_store_cad,
            cc_service_level_ecom_cad,
            cc_presmin_store_cad,
            cc_presmin_ecom_us,
            cc_presmin_ecom_cad,
            cc_presmin_weeks_store_cad,
            cc_presmin_weeks_ecom_us,
            cc_presmin_weeks_ecom_cad,
            cc_rcptint_store_cad,
            cc_rcptint_ecom_us,
            cc_rcptint_ecom_cad,
            cc_ordermin_store_cad,
            cc_ordermin_ecom_us,
            cc_ordermin_ecom_cad,
            cc_lead_time_store_cad,
            cc_lead_time_ecom_us,
            cc_lead_time_ecom_cad,
            cc_return_u_pct_store_cad,
            cc_return_u_pct_ecom_cad,
            cc_ordermultiple_store_cad,
            cc_ordermultiple_ecom_us,
            cc_ordermultiple_ecom_cad,
            ccticketpricechannel_store_cad,
            ccticketpricechannel_ecom_us,
            ccticketpricechannel_ecom_cad,
            ccticketpricechannel_store_cad_override,
            ccticketpricechannel_ecom_us_override,
            ccticketpricechannel_ecom_cad_override
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_imgattributes (
            indx,
            product,
            img,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            indx,
            to_id,
            img,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_itemprice (
            product,
            location,
            time,
            addoff,
            eo,
            eff_aur,
            department,
            event,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            excl_discount_pct,
            addoff_ecom,
            addoff_store,
            eo_store_cad,
            eo_ecom_us,
            eo_ecom_cad,
            excl_discount_pct_store_cad,
            excl_discount_pct_ecom_us,
            excl_discount_pct_ecom_cad,
            eff_aur_ecom,
            eff_aur_store_cad,
            eff_aur_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            addoff,
            eo,
            eff_aur,
            department,
            event,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            excl_discount_pct,
            addoff_ecom,
            addoff_store,
            eo_store_cad,
            eo_ecom_us,
            eo_ecom_cad,
            excl_discount_pct_store_cad,
            excl_discount_pct_ecom_us,
            excl_discount_pct_ecom_cad,
            eff_aur_ecom,
            eff_aur_store_cad,
            eff_aur_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_channeloverride (
            product,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            comments,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            testpo,
            floorsetpo,
            weekadjslsu_store_cad,
            weekadjslsu_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            comments,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            testpo,
            floorsetpo,
            weekadjslsu_store_cad,
            weekadjslsu_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_a_assortment (
            product,
            location,
            time,
            style,
            str_grade,
            str_climate,
            str_region_combo,
            str_hvlc,
            str_tourist_border_combo,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            str_grade_or,
            str_climate_or,
            str_region_combo_or,
            str_hvlc_or,
            str_tourist_border_combo_or,
            is_sclr_flrset_locked,
            str_grade_cad,
            str_climate_cad,
            str_region_combo_cad,
            str_hvlc_cad,
            str_tourist_border_combo_cad,
            ssg_cad,
            isfunded_cad,
            str_grade_ecom,
            isfunded_ecom,
            str_grade_ecom_cad,
            isfunded_ecom_cad,
            cc_flrset_open_1,
            cc_flrset_open_2,
            cc_flrset_open_3,
            cc_flrset_open_4,
            cc_flrset_open_5,
            cc_flrset_open_6,
            cc_flrset_open_7,
            cc_flrset_open_8,
            cc_flrset_open_9,
            cc_flrset_open_10
        )
        SELECT
            to_id,
            location,
            time,
            style,
            str_grade,
            str_climate,
            str_region_combo,
            str_hvlc,
            str_tourist_border_combo,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            str_grade_or,
            str_climate_or,
            str_region_combo_or,
            str_hvlc_or,
            str_tourist_border_combo_or,
            is_sclr_flrset_locked,
            str_grade_cad,
            str_climate_cad,
            str_region_combo_cad,
            str_hvlc_cad,
            str_tourist_border_combo_cad,
            ssg_cad,
            isfunded_cad,
            str_grade_ecom,
            isfunded_ecom,
            str_grade_ecom_cad,
            isfunded_ecom_cad,
            cc_flrset_open_1,
            cc_flrset_open_2,
            cc_flrset_open_3,
            cc_flrset_open_4,
            cc_flrset_open_5,
            cc_flrset_open_6,
            cc_flrset_open_7,
            cc_flrset_open_8,
            cc_flrset_open_9,
            cc_flrset_open_10
        FROM aeo_style_clone_flat_map_temp a,
             aeo_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_dc_adj (
            product,
            location,
            time,
            dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_isedited,
            dc_syscost,
            dc_lndcst,
            dc_sysvrp,
            dc_sc_useradj,
            dc_sc_finrev,
            po_indicator,
            po_shipmode,
            air_trigger,
            cut,
            published_at,
            is_prepublished,
            prepublished_at,
            last_prepublished,
            po_arr,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            dc_publish_ecom,
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            published_at_ecom,
            is_prepublished_ecom,
            prepublished_at_ecom,
            last_prepublished_ecom,
            reason_code,
            reason_code_ecom,
            pack_ind_flag,
            pack_ind_flag_ecom,
            show_in_pack,
            show_in_pack_ecom,
            prepack_pct,
            prepack_pct_ecom,
            default_fringe_indicator,
            default_fringe_indicator_ecom,
            email_to,
            dc_useradj_store_cad,
            dc_onorder_store_cad,
            dc_finrev_store_cad,
            dc_publish_store_cad,
            po_indicator_store_cad,
            po_shipmode_store_cad,
            air_trigger_store_cad,
            cut_store_cad,
            published_at_store_cad,
            is_prepublished_store_cad,
            prepublished_at_store_cad,
            last_prepublished_store_cad,
            reason_code_store_cad,
            pack_ind_flag_store_cad,
            show_in_pack_store_cad,
            prepack_pct_store_cad,
            default_fringe_indicator_store_cad,
            dc_useradj_ecom_cad,
            dc_onorder_ecom_cad,
            dc_finrev_ecom_cad,
            dc_publish_ecom_cad,
            po_indicator_ecom_cad,
            po_shipmode_ecom_cad,
            air_trigger_ecom_cad,
            cut_ecom_cad,
            published_at_ecom_cad,
            is_prepublished_ecom_cad,
            prepublished_at_ecom_cad,
            last_prepublished_ecom_cad,
            reason_code_ecom_cad,
            pack_ind_flag_ecom_cad,
            show_in_pack_ecom_cad,
            prepack_pct_ecom_cad,
            default_fringe_indicator_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            null as dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_isedited,
            dc_syscost,
            dc_lndcst,
            dc_sysvrp,
            dc_sc_useradj,
            dc_sc_finrev,
            po_indicator,
            po_shipmode,
            air_trigger,
            cut,
            null as published_at,
            null as is_prepublished,
            null as prepublished_at,
            null as last_prepublished,
            null as po_arr,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            null as published_at_ecom,
            null as is_prepublished_ecom,
            null as prepublished_at_ecom,
            null as last_prepublished_ecom,
            reason_code,
            reason_code_ecom,
            pack_ind_flag,
            pack_ind_flag_ecom,
            show_in_pack,
            show_in_pack_ecom,
            prepack_pct,
            prepack_pct_ecom,
            default_fringe_indicator,
            default_fringe_indicator_ecom,
            email_to,
            dc_useradj_store_cad,
            null as dc_onorder_store_cad,
            dc_finrev_store_cad,
            null as dc_publish_store_cad,
            po_indicator_store_cad,
            po_shipmode_store_cad,
            air_trigger_store_cad,
            cut_store_cad,
            null as published_at_store_cad,
            null as is_prepublished_store_cad,
            null as prepublished_at_store_cad,
            null as last_prepublished_store_cad,
            reason_code_store_cad,
            pack_ind_flag_store_cad,
            show_in_pack_store_cad,
            prepack_pct_store_cad,
            default_fringe_indicator_store_cad,
            dc_useradj_ecom_cad,
            null as dc_onorder_ecom_cad,
            dc_finrev_ecom_cad,
            null as dc_publish_ecom_cad,
            po_indicator_ecom_cad,
            po_shipmode_ecom_cad,
            air_trigger_ecom_cad,
            cut_ecom_cad,
            null as published_at_ecom_cad,
            null as is_prepublished_ecom_cad,
            null as prepublished_at_ecom_cad,
            null as last_prepublished_ecom_cad,
            reason_code_ecom_cad,
            pack_ind_flag_ecom_cad,
            show_in_pack_ecom_cad,
            prepack_pct_ecom_cad,
            default_fringe_indicator_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_dc_adj_size (
            product,
            location,
            time,
            dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_scadj,
            dc_ttluseradj,
            dc_scfinrev,
            dc_ttlfinrev,
            dc_isedited,
            dc_onorder_v,
            dc_onorder_c,
            current_week,
            dc_last_pub_u,
            dc_last_pub,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_onorder_v_ecom,
            dc_onorder_c_ecom,
            dc_finrev_ecom,
            dc_publish_ecom,
            dc_last_pub_u_ecom,
            dc_last_pub_ecom,
            dc_useradj_store_cad,
            dc_onorder_store_cad,
            dc_onorder_v_store_cad,
            dc_onorder_c_store_cad,
            dc_finrev_store_cad,
            dc_publish_store_cad,
            dc_last_pub_u_store_cad,
            dc_last_pub_store_cad,
            dc_useradj_ecom_cad,
            dc_onorder_ecom_cad,
            dc_onorder_v_ecom_cad,
            dc_onorder_c_ecom_cad,
            dc_finrev_ecom_cad,
            dc_publish_ecom_cad,
            dc_last_pub_u_ecom_cad,
            dc_last_pub_ecom_cad
        )
        SELECT
            from_stylecolorsize,
            location,
            time,
            null as dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            null as dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_scadj,
            dc_ttluseradj,
            dc_scfinrev,
            dc_ttlfinrev,
            dc_isedited,
            null as dc_onorder_v,
            null as dc_onorder_c,
            current_week,
            null as dc_last_pub_u,
            null as dc_last_pub,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom,
            dc_useradj_store_cad,
            null as dc_onorder_store_cad,
            null as dc_onorder_v_store_cad,
            null as dc_onorder_c_store_cad,
            dc_finrev_store_cad,
            null as dc_publish_store_cad,
            null as dc_last_pub_u_store_cad,
            null as dc_last_pub_store_cad,
            dc_useradj_ecom_cad,
            null as dc_onorder_ecom_cad,
            null as dc_onorder_v_ecom_cad,
            null as dc_onorder_c_ecom_cad,
            dc_finrev_ecom_cad,
            null as dc_publish_ecom_cad,
            null as dc_last_pub_u_ecom_cad,
            null as dc_last_pub_ecom_cad
        FROM aeo_style_clone_stylecolor_size a,
             aeo_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO aeo_an_price_storecount_info (
            product,
            channel,
            time,
            selling_channel,
            isfunded,
            store_count,
            in_season_flag,
            dbt_wk_date,
            last_rcpt_wk_date,
            erlstmkdnwk_date,
            exitdate_date,
            weekdate,
            price_status,
            seq,
            ccticketprice,
            curp,
            selling_price,
            expressed_aur,
            corpexcl,
            addoff,
            corpaddoff,
            v_a,
            v_b,
            ccdiscountpct,
            flow_flag
        )
        SELECT
            to_id,
            channel,
            time,
            selling_channel,
            isfunded,
            store_count,
            in_season_flag,
            dbt_wk_date,
            last_rcpt_wk_date,
            erlstmkdnwk_date,
            exitdate_date,
            weekdate,
            price_status,
            seq,
            ccticketprice,
            curp,
            selling_price,
            expressed_aur,
            corpexcl,
            addoff,
            corpaddoff,
            v_a,
            v_b,
            ccdiscountpct,
            flow_flag
        FROM aeo_style_clone_flat_map_temp a,
             aeo_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
/*
        INSERT INTO aeo_l_dependencylookup (
            lookup_id,
            lookup_value,
            target_id,
            target_value
        )
        SELECT DISTINCT
            'style'    AS lookup_id,
            from_id    AS lookup_value,
            'patternedtostyle' AS target_id,
            to_id      AS target_value
        FROM aeo_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';
*/

        INSERT INTO aeo_l_dependencylookup (
            lookup_id,
            lookup_value,
            target_id,
            target_value
        )
        SELECT DISTINCT
            'stylecolor' AS lookup_id,
            from_id      AS lookup_value,
            'patternedtostylecolor' AS target_id,
            to_id        AS target_value
        FROM aeo_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';


-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS aeo_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.aeo_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 530 (class 1255 OID 134295520)
-- Name: aeo_plan_these_cloned_style_stylecolors_proc(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.aeo_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN


    -- ----------------------------------
    -- UPDATE picked_for_planning FLAG
    -- ----------------------------------

    -- Freeze this user's unpicked selection to avoid races
    CREATE TEMPORARY TABLE tmp_selected
    AS
    SELECT style, stylecolor, session_id, updated_by, picked_for_planning
    FROM aeo_plan_these_cloned_style_stylecolors
    WHERE updated_by = v_pivot_user_id
      AND picked_for_planning = 0
    ;

    UPDATE
        aeo_style_clone_stylecolor_size
    SET 
        picked_for_planning = 1 
    WHERE 
        (to_new_stylecolor, session_id) IN (SELECT stylecolor, session_id FROM tmp_selected)
        AND updated_by = v_pivot_user_id
    ;


    -- ----------------------------------
    -- MARK FOR DELETION UNUSED PRODUCTS 
    -- ----------------------------------


    CREATE TEMPORARY TABLE all_un_used_products
    AS  
    SELECT 
        DISTINCT to_new_style AS product, 'style' AS levelid 
    FROM 
        aeo_style_clone_stylecolor_size s
    WHERE s.updated_by = v_pivot_user_id
      AND s.picked_for_planning = 0
      AND NOT EXISTS (
            SELECT 1 FROM tmp_selected t
            WHERE t.style = s.to_new_style AND t.session_id = s.session_id
      )

    UNION ALL 

    SELECT 
        DISTINCT to_new_stylecolor AS product, 'stylecolor' AS levelid 
    FROM 
        aeo_style_clone_stylecolor_size s
    WHERE s.updated_by = v_pivot_user_id
      AND s.picked_for_planning = 0
      AND NOT EXISTS (
            SELECT 1 FROM tmp_selected t
            WHERE t.stylecolor = s.to_new_stylecolor AND t.session_id = s.session_id
      )

    UNION ALL 

    -- If you truly have a to_new_stylecolorsize column, keep this block; otherwise remove it.
    SELECT 
        DISTINCT to_new_stylecolorsize AS product, 'stylecolorsize' AS levelid 
    FROM 
        aeo_style_clone_stylecolor_size s
    WHERE s.updated_by = v_pivot_user_id
      AND s.picked_for_planning = 0
      AND NOT EXISTS (
            SELECT 1 FROM tmp_selected t
            WHERE t.stylecolor = s.to_new_stylecolor AND t.session_id = s.session_id
      )
    ;

    -- ------------------------------------
    -- PRUNE UNUSED ROWS FROM CLONE STAGING
    -- ------------------------------------
    DELETE FROM aeo_style_clone_stylecolor_size a 
    WHERE 
        a.updated_by = v_pivot_user_id
        AND a.session_id IN (SELECT DISTINCT session_id FROM tmp_selected)
        AND 
        (
            a.to_new_style IN (
                SELECT product FROM all_un_used_products WHERE levelid = 'style'
            )
        OR
            a.to_new_stylecolor IN (
                SELECT product FROM all_un_used_products WHERE levelid = 'stylecolor'
            )
        OR
            a.to_new_stylecolorsize IN (
                SELECT product FROM all_un_used_products WHERE levelid = 'stylecolorsize'
            )
        )
    ;

    -- ------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW
    -- ------------------------------------
    /*
    delete from aeo_d_product where id in (select distinct product from all_un_used_products);

    delete from aeo_h_prodstd where id in (select distinct product from all_un_used_products);
   
    delete from aeo_a_assortment where product in (select distinct product from all_un_used_products);

    delete from aeo_ma_styleattributes where product in (select distinct product from all_un_used_products);

    delete from aeo_ma_stylecolorattributes where product in (select distinct product from all_un_used_products);

    delete from aeo_ma_sizeattributes where product in (select distinct product from all_un_used_products);

    delete from aeo_ma_imgattributes where product in (select distinct product from all_un_used_products);

    delete from aeo_p_dc_adj where product in (select distinct product from all_un_used_products);

    delete from aeo_p_dc_adj_size where product in (select distinct product from all_un_used_products);

    delete from aeo_p_itemprice where product in (select distinct product from all_un_used_products);

    delete from aeo_p_channeloverride where product in (select distinct product from all_un_used_products);

    delete from aeo_an_price_storecount_info where product in (select distinct product from all_un_used_products);
    */


    -- --------------------------------------------------------------------------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW, SIMULATING REMOVE FROM ASSORTMENT, LIKELY DATA EXISTS IN CLICKHOUSE
    -- --------------------------------------------------------------------------------------------------------
    DELETE FROM aeo_a_assortment 
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products);

    UPDATE aeo_ma_stylecolorchannelattributes
    SET record_state = 1
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products WHERE levelid = 'stylecolor')
    ;

    UPDATE aeo_ma_stylecolorchannelattributes
    SET record_state = 0
    WHERE product IN (select distinct stylecolor from tmp_selected)
    ;

    ------------------------------------
    -- INSERT IN PLAN QUEUE FOR PLANNING
    ------------------------------------

    INSERT INTO plan_queue (product, location, initiator, initiated_at, queued)
    SELECT 
        DISTINCT a.stylecolor, b.location, v_pivot_user_id, now(), now()
    FROM 
        tmp_selected a, aeo_ma_stylecolorchannelattributes b where a.stylecolor = b.product
    ;


    ------------------------------------
    -- UPDATE picked_for_planning FLAG
    -- ------------------------------------
    UPDATE 
        aeo_plan_these_cloned_style_stylecolors 
    SET 
        picked_for_planning = 1 
    WHERE 
        updated_by = v_pivot_user_id 
        AND picked_for_planning = 0
        AND (stylecolor, session_id) IN (SELECT stylecolor, session_id FROM tmp_selected)
    ;

DROP TABLE IF EXISTS all_un_used_products;
DROP TABLE IF EXISTS tmp_selected;

END;
$$;


ALTER PROCEDURE public.aeo_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 531 (class 1255 OID 134295524)
-- Name: aeo_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.aeo_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE aeo_style_clone_flat_map_temp AS
    SELECT * 
    FROM (
        SELECT DISTINCT
            from_style        AS from_id,
            to_new_style      AS to_id,
            'style'           AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , to_new_style_name as to_name
            , to_new_style_desc as to_desc
            , '' as cccolor
            , '' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND session_id = v_session_id

        UNION ALL
        SELECT DISTINCT
            from_stylecolor   AS from_id,
            to_new_stylecolor AS to_id,
            'stylecolor'      AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , to_new_stylecolor_name as to_name
            , to_new_stylecolor_desc as to_desc
            , RIGHT(to_new_stylecolor_name, 8) as cccolor
            , 'TBD' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND session_id = v_session_id

        UNION ALL
        SELECT DISTINCT
            from_stylecolorsize   AS from_id,
            to_new_stylecolorsize AS to_id,
            'stylecolorsize'      AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , '' as to_name 
            , '' as to_desc
            , '' as cccolor
            , '' as cccolorfamily
        FROM aeo_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO aeo_d_product (
            id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
        )
        SELECT DISTINCT 
              to_id
            , null as client_id
            , CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END
            , CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END 
            , a.levelid
            , indx
            
            , now()::date
            , version_id
            , now()
            , v_pivot_user_id
            , now()
            , v_pivot_user_id
            , record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_d_product b
        WHERE a.from_id = b.id
        ;


    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_style,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_stylecolor,
            to_new_style,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT DISTINCT
            to_new_stylecolorsize,
            to_new_stylecolor,
            to_new_style,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_stylecolor_size a,
             aeo_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_styleattributes (
            product,
            sty_e_top_bottom,
            sty_b_end_use,
            sty_c_division_specific_1,
            sty_d_division_specific_2,
            sty_e_q1,
            sty_f_hang_fold_packs,
            sty_g_length,
            sty_k_partnerships,
            sty_l_q2,
            sty_m_q3,
            sty_n_q4,
            sty_spec_style,
            sty_size_model_code,
            sty_size_model_name,
            ccstylecreatedate,
            sty_size_range,
            sty_vendor_id,
            sty_vendor_name,
            sty_spec_style_store_cad,
            sty_spec_style_ecom_us,
            sty_spec_style_ecom_cad,
            sty_patterned_after,
            sty_is_locked,
            sty_s5_adopted,
            sty_num_clones_s5,
            sty_num_times_cloned_s5,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            to_id,
            sty_e_top_bottom,
            sty_b_end_use,
            null as sty_c_division_specific_1,
            null as sty_d_division_specific_2,
            sty_e_q1,
            sty_f_hang_fold_packs,
            sty_g_length,
            sty_k_partnerships,
            null as sty_l_q2,
            null as sty_m_q3,
            null as sty_n_q4,
            null as sty_spec_style,
            sty_size_model_code,
            sty_size_model_name,
            null as ccstylecreatedate,
            sty_size_range,
            null as sty_vendor_id,
            null as sty_vendor_name,
            null as sty_spec_style_store_cad,
            null as sty_spec_style_ecom_us,
            null as sty_spec_style_ecom_cad,
            null as sty_patterned_after,
            null as sty_is_locked,
            sty_s5_adopted,
            null as sty_num_clones_s5,
            null as sty_num_times_cloned_s5,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_stylecolorattributes (
            product,
            cccolorid,
            cccolor,
            color_name,
            cc_color_desc,
            cccolorfamily,
            cc_color_group,
            cc_color_code,
            ccstylecolorcreatedate,
            cc_size_range_code,
            cc_spec_stylecolor,
            cc_attribute_1,
            cc_attribute_2,
            cc_attribute_3,
            cc_attribute_4,
            cc_attribute_5,
            cc_attribute_6,
            cc_attribute_7,
            cc_assortment_architecture,
            cc_price_bucket,
            cc_a_module,
            cc_c_responsive,
            cc_f_print_pattern,
            cc_g_color_family,
            cc_h_denim_wash,
            cc_i_fabric,
            cc_j_logo,
            cc_k_license_collab,
            cc_l_doorbuster,
            cc_m_exclusive,
            cc_n_dpc,
            cc_h_placeholder_type_booking_track_testing,
            cc_j_print_pattern_wash_color_family,
            cc_spec_stylecolor_store_cad,
            cc_spec_stylecolor_ecom_us,
            cc_spec_stylecolor_ecom_cad,
            stylecolor_open_1,
            stylecolor_open_2,
            stylecolor_open_3,
            stylecolor_open_4,
            stylecolor_open_5,
            stylecolor_open_6,
            stylecolor_open_7,
            stylecolor_open_8,
            stylecolor_open_9,
            stylecolor_open_10,
            stylecolor_name,
            style_name,
            subclass_name,
            class_name,
            department_name,
            division_name,
            brand_name,
            isassortment,
            merch_comments,
            plan_comments,
            allocator_comments,
            cc_is_locked,
            cc_s5_adopted,
            cc_prepublish,
            cc_prepublished_at,
            cc_floorset,
            cc_use_sys_floorset,
            cc_num_clones_s5,
            cc_num_times_cloned_s5,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            to_id,
            null as cccolorid,
            a.cccolor as cccolor,
            null as olor_name,
            null as cc_color_desc,
            a.cccolorfamily as cccolorfamily,
            null as cc_color_group,
            null as cc_color_code,
            null as ccstylecolorcreatedate,
            cc_size_range_code,
            null as cc_spec_stylecolor,
            cc_attribute_1,
            cc_attribute_2,
            cc_attribute_3,
            cc_attribute_4,
            cc_attribute_5,
            cc_attribute_6,
            cc_attribute_7,
            cc_assortment_architecture,
            cc_price_bucket,
            cc_a_module,
            cc_c_responsive,
            cc_f_print_pattern,
            cc_g_color_family,
            cc_h_denim_wash,
            cc_i_fabric,
            cc_j_logo,
            cc_k_license_collab,
            cc_l_doorbuster,
            cc_m_exclusive,
            cc_n_dpc,
            cc_h_placeholder_type_booking_track_testing,
            cc_j_print_pattern_wash_color_family,
            null as cc_spec_stylecolor_store_cad,
            null as cc_spec_stylecolor_ecom_us,
            null as cc_spec_stylecolor_ecom_cad,
            null as stylecolor_open_1,
            null as stylecolor_open_2,
            null as stylecolor_open_3,
            null as stylecolor_open_4,
            null as stylecolor_open_5,
            null as stylecolor_open_6,
            null as stylecolor_open_7,
            null as stylecolor_open_8,
            null as stylecolor_open_9,
            null as stylecolor_open_10,
            stylecolor_name,
            style_name,
            subclass_name,
            class_name,
            department_name,
            division_name,
            brand_name,
            isassortment,
            null as merch_comments,
            null as plan_comments,
            null as allocator_comments,
            null as cc_is_locked,
            cc_s5_adopted,
            null as cc_prepublish,
            null as cc_prepublished_at,
            null as cc_floorset,
            null as cc_use_sys_floorset,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_sizeattributes (
            product,
            parent_id,
            size_code,
            size_name,
            sizeattribute,
            isvalid,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            ccstylecolorsizecreatedate
        )
        SELECT
            to_new_stylecolorsize,
            to_new_stylecolor,
            size_code,
            size_name,
            sizeattribute,
            isvalid,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            NULL
        FROM aeo_style_clone_stylecolor_size a,
             aeo_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_stylecolorchannelattributes (
            product,
            location,
            dbt_wk,
            relaunchweek,
            erlstmkdnwk,
            exitdate,
            initrcptwk,
            too,
            mkdnwks,
            last_inv_wk,
            lstfpwk,
            last_rcpt_wk,
            lastdcorder,
            act_initrcptwk,
            act_dbt_wk,
            irw_indx,
            dbtwk_indx,
            relaunchwk_indx,
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            preview_wks,
            preview_qty,
            plannedselldnwk,
            ccmdstrategy,
            slsrnk_store,
            slsrnk_ecom,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            cc_presmin,
            cc_presmin_weeks,
            cc_rcptint,
            cc_return_u_pct_store,
            cc_return_u_pct_ecom,
            cc_return_u_pct_cross,
            cc_ordermultiple,
            cc_ordermin,
            cc_buy_aps_letter,
            ccticketpricechannel,
            ccticketpricechannel_override,
            cc_imupct,
            cc_discount_pct,
            cc_existingwac,
            cc_systemcost,
            cc_plan_cost,
            ssnprf,
            adjaps_store,
            adjaps_ecom,
            smoothing_strategy,
            in_season_flag,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            keep_initial_range_plan,
            cc_sizeelig_rangecode,
            cc_presmin_stylecolor,
            cc_presmin_weeks_stylecolor,
            cc_final_cost,
            cc_discount_pct_store,
            cc_discount_pct_ecom,
            irw_debut_offset,
            cc_service_level_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            sclr_alloc_max,
            sclr_presmin,
            sclr_alloc_min,
            sclr_presmin_weeks,
            sclr_tgt_fwoc,
            sclr_fringe_flag,
            act_slsrnk_store,
            act_aps_store,
            act_aps_mult_adj_store,
            act_slsrnk_ecom,
            act_aps_ecom,
            act_aps_mult_adj_ecom,
            use_act_aps_or_act_rank,
            use_valid_sizes_from,
            apply_size_mins_to,
            cc_addoff_store,
            cc_addoff_ecom,
            irw_floorset,
            irw_superset,
            irw_floorset_display,
            irw_superset_display,
            irw_floorset_id,
            cc_size_eligibility_profile,
            cloned_at,
            initrcptwk_store_cad,
            initrcptwk_ecom_us,
            initrcptwk_ecom_cad,
            irw_debut_offset_store_cad,
            irw_debut_offset_ecom_us,
            irw_debut_offset_ecom_cad,
            dbt_wk_store_cad,
            dbt_wk_ecom_us,
            dbt_wk_ecom_cad,
            too_store_cad,
            too_ecom_us,
            too_ecom_cad,
            erlstmkdnwk_store_cad,
            erlstmkdnwk_ecom_us,
            erlstmkdnwk_ecom_cad,
            mkdnwks_store_cad,
            mkdnwks_ecom_us,
            mkdnwks_ecom_cad,
            exitdate_store_cad,
            exitdate_ecom_us,
            exitdate_ecom_cad,
            last_rcpt_wk_store_cad,
            last_rcpt_wk_ecom_us,
            last_rcpt_wk_ecom_cad,
            slsrnk_store_cad,
            slsrnk_ecom_cad,
            cc_addoff_ecom_cad,
            cc_addoff_store_cad,
            cc_orig_unit_retail,
            cc_orig_unit_retail_store_cad,
            cc_orig_unit_retail_ecom_us,
            cc_orig_unit_retail_ecom_cad,
            cc_plan_cost_store_cad,
            cc_plan_cost_ecom_us,
            cc_plan_cost_ecom_cad,
            cc_systemcost_store_cad,
            cc_systemcost_ecom_us,
            cc_systemcost_ecom_cad,
            cc_discount_pct_store_cad,
            cc_discount_pct_ecom_us,
            cc_discount_pct_ecom_cad,
            ccmdstrategy_store_cad,
            ccmdstrategy_ecom_us,
            ccmdstrategy_ecom_cad,
            cc_validsizes_store_cad,
            cc_validsizes_ecom_cad,
            cc_service_level_store_cad,
            cc_service_level_ecom_cad,
            cc_presmin_store_cad,
            cc_presmin_ecom_us,
            cc_presmin_ecom_cad,
            cc_presmin_weeks_store_cad,
            cc_presmin_weeks_ecom_us,
            cc_presmin_weeks_ecom_cad,
            cc_rcptint_store_cad,
            cc_rcptint_ecom_us,
            cc_rcptint_ecom_cad,
            cc_ordermin_store_cad,
            cc_ordermin_ecom_us,
            cc_ordermin_ecom_cad,
            cc_lead_time_store_cad,
            cc_lead_time_ecom_us,
            cc_lead_time_ecom_cad,
            cc_return_u_pct_store_cad,
            cc_return_u_pct_ecom_cad,
            cc_ordermultiple_store_cad,
            cc_ordermultiple_ecom_us,
            cc_ordermultiple_ecom_cad,
            ccticketpricechannel_store_cad,
            ccticketpricechannel_ecom_us,
            ccticketpricechannel_ecom_cad,
            ccticketpricechannel_store_cad_override,
            ccticketpricechannel_ecom_us_override,
            ccticketpricechannel_ecom_cad_override
        )
        SELECT
            to_id,
            location,
            dbt_wk,
            relaunchweek,
            erlstmkdnwk,
            exitdate,
            initrcptwk,
            too,
            mkdnwks,
            last_inv_wk,
            lstfpwk,
            last_rcpt_wk,
            lastdcorder,
            act_initrcptwk,
            act_dbt_wk,
            irw_indx,
            dbtwk_indx,
            relaunchwk_indx,
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            preview_wks,
            preview_qty,
            plannedselldnwk,
            ccmdstrategy,
            slsrnk_store,
            slsrnk_ecom,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            cc_presmin,
            cc_presmin_weeks,
            cc_rcptint,
            cc_return_u_pct_store,
            cc_return_u_pct_ecom,
            cc_return_u_pct_cross,
            cc_ordermultiple,
            cc_ordermin,
            cc_buy_aps_letter,
            ccticketpricechannel,
            ccticketpricechannel_override,
            cc_imupct,
            cc_discount_pct,
            cc_existingwac,
            cc_systemcost,
            cc_plan_cost,
            ssnprf,
            adjaps_store,
            adjaps_ecom,
            smoothing_strategy,
            in_season_flag,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            1 as record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            keep_initial_range_plan,
            cc_sizeelig_rangecode,
            cc_presmin_stylecolor,
            cc_presmin_weeks_stylecolor,
            cc_final_cost,
            cc_discount_pct_store,
            cc_discount_pct_ecom,
            irw_debut_offset,
            cc_service_level_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            sclr_alloc_max,
            sclr_presmin,
            sclr_alloc_min,
            sclr_presmin_weeks,
            sclr_tgt_fwoc,
            sclr_fringe_flag,
            act_slsrnk_store,
            act_aps_store,
            act_aps_mult_adj_store,
            act_slsrnk_ecom,
            act_aps_ecom,
            act_aps_mult_adj_ecom,
            use_act_aps_or_act_rank,
            use_valid_sizes_from,
            apply_size_mins_to,
            cc_addoff_store,
            cc_addoff_ecom,
            irw_floorset,
            irw_superset,
            irw_floorset_display,
            irw_superset_display,
            irw_floorset_id,
            cc_size_eligibility_profile,
            now(),
            initrcptwk_store_cad,
            initrcptwk_ecom_us,
            initrcptwk_ecom_cad,
            irw_debut_offset_store_cad,
            irw_debut_offset_ecom_us,
            irw_debut_offset_ecom_cad,
            dbt_wk_store_cad,
            dbt_wk_ecom_us,
            dbt_wk_ecom_cad,
            too_store_cad,
            too_ecom_us,
            too_ecom_cad,
            erlstmkdnwk_store_cad,
            erlstmkdnwk_ecom_us,
            erlstmkdnwk_ecom_cad,
            mkdnwks_store_cad,
            mkdnwks_ecom_us,
            mkdnwks_ecom_cad,
            exitdate_store_cad,
            exitdate_ecom_us,
            exitdate_ecom_cad,
            last_rcpt_wk_store_cad,
            last_rcpt_wk_ecom_us,
            last_rcpt_wk_ecom_cad,
            slsrnk_store_cad,
            slsrnk_ecom_cad,
            cc_addoff_ecom_cad,
            cc_addoff_store_cad,
            cc_orig_unit_retail,
            cc_orig_unit_retail_store_cad,
            cc_orig_unit_retail_ecom_us,
            cc_orig_unit_retail_ecom_cad,
            cc_plan_cost_store_cad,
            cc_plan_cost_ecom_us,
            cc_plan_cost_ecom_cad,
            cc_systemcost_store_cad,
            cc_systemcost_ecom_us,
            cc_systemcost_ecom_cad,
            cc_discount_pct_store_cad,
            cc_discount_pct_ecom_us,
            cc_discount_pct_ecom_cad,
            ccmdstrategy_store_cad,
            ccmdstrategy_ecom_us,
            ccmdstrategy_ecom_cad,
            cc_validsizes_store_cad,
            cc_validsizes_ecom_cad,
            cc_service_level_store_cad,
            cc_service_level_ecom_cad,
            cc_presmin_store_cad,
            cc_presmin_ecom_us,
            cc_presmin_ecom_cad,
            cc_presmin_weeks_store_cad,
            cc_presmin_weeks_ecom_us,
            cc_presmin_weeks_ecom_cad,
            cc_rcptint_store_cad,
            cc_rcptint_ecom_us,
            cc_rcptint_ecom_cad,
            cc_ordermin_store_cad,
            cc_ordermin_ecom_us,
            cc_ordermin_ecom_cad,
            cc_lead_time_store_cad,
            cc_lead_time_ecom_us,
            cc_lead_time_ecom_cad,
            cc_return_u_pct_store_cad,
            cc_return_u_pct_ecom_cad,
            cc_ordermultiple_store_cad,
            cc_ordermultiple_ecom_us,
            cc_ordermultiple_ecom_cad,
            ccticketpricechannel_store_cad,
            ccticketpricechannel_ecom_us,
            ccticketpricechannel_ecom_cad,
            ccticketpricechannel_store_cad_override,
            ccticketpricechannel_ecom_us_override,
            ccticketpricechannel_ecom_cad_override
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_ma_imgattributes (
            indx,
            product,
            img,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            indx,
            to_id,
            img,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state
        FROM aeo_style_clone_flat_map_temp a,
             aeo_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_itemprice (
            product,
            location,
            time,
            addoff,
            eo,
            eff_aur,
            department,
            event,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            excl_discount_pct,
            addoff_ecom,
            addoff_store,
            eo_store_cad,
            eo_ecom_us,
            eo_ecom_cad,
            excl_discount_pct_store_cad,
            excl_discount_pct_ecom_us,
            excl_discount_pct_ecom_cad,
            eff_aur_ecom,
            eff_aur_store_cad,
            eff_aur_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            addoff,
            eo,
            eff_aur,
            department,
            event,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            excl_discount_pct,
            addoff_ecom,
            addoff_store,
            eo_store_cad,
            eo_ecom_us,
            eo_ecom_cad,
            excl_discount_pct_store_cad,
            excl_discount_pct_ecom_us,
            excl_discount_pct_ecom_cad,
            eff_aur_ecom,
            eff_aur_store_cad,
            eff_aur_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_channeloverride (
            product,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            comments,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            testpo,
            floorsetpo,
            weekadjslsu_store_cad,
            weekadjslsu_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            comments,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            testpo,
            floorsetpo,
            weekadjslsu_store_cad,
            weekadjslsu_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_a_assortment (
            product,
            location,
            time,
            style,
            str_grade,
            str_climate,
            str_region_combo,
            str_hvlc,
            str_tourist_border_combo,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            str_grade_or,
            str_climate_or,
            str_region_combo_or,
            str_hvlc_or,
            str_tourist_border_combo_or,
            is_sclr_flrset_locked,
            str_grade_cad,
            str_climate_cad,
            str_region_combo_cad,
            str_hvlc_cad,
            str_tourist_border_combo_cad,
            ssg_cad,
            isfunded_cad,
            str_grade_ecom,
            isfunded_ecom,
            str_grade_ecom_cad,
            isfunded_ecom_cad,
            cc_flrset_open_1,
            cc_flrset_open_2,
            cc_flrset_open_3,
            cc_flrset_open_4,
            cc_flrset_open_5,
            cc_flrset_open_6,
            cc_flrset_open_7,
            cc_flrset_open_8,
            cc_flrset_open_9,
            cc_flrset_open_10
        )
        SELECT
            to_id,
            location,
            time,
            style,
            str_grade,
            str_climate,
            str_region_combo,
            str_hvlc,
            str_tourist_border_combo,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            str_grade_or,
            str_climate_or,
            str_region_combo_or,
            str_hvlc_or,
            str_tourist_border_combo_or,
            is_sclr_flrset_locked,
            str_grade_cad,
            str_climate_cad,
            str_region_combo_cad,
            str_hvlc_cad,
            str_tourist_border_combo_cad,
            ssg_cad,
            isfunded_cad,
            str_grade_ecom,
            isfunded_ecom,
            str_grade_ecom_cad,
            isfunded_ecom_cad,
            cc_flrset_open_1,
            cc_flrset_open_2,
            cc_flrset_open_3,
            cc_flrset_open_4,
            cc_flrset_open_5,
            cc_flrset_open_6,
            cc_flrset_open_7,
            cc_flrset_open_8,
            cc_flrset_open_9,
            cc_flrset_open_10
        FROM aeo_style_clone_flat_map_temp a,
             aeo_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
        INSERT INTO aeo_p_dc_adj (
            product,
            location,
            time,
            dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_isedited,
            dc_syscost,
            dc_lndcst,
            dc_sysvrp,
            dc_sc_useradj,
            dc_sc_finrev,
            po_indicator,
            po_shipmode,
            air_trigger,
            cut,
            published_at,
            is_prepublished,
            prepublished_at,
            last_prepublished,
            po_arr,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            dc_publish_ecom,
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            published_at_ecom,
            is_prepublished_ecom,
            prepublished_at_ecom,
            last_prepublished_ecom,
            reason_code,
            reason_code_ecom,
            pack_ind_flag,
            pack_ind_flag_ecom,
            show_in_pack,
            show_in_pack_ecom,
            prepack_pct,
            prepack_pct_ecom,
            default_fringe_indicator,
            default_fringe_indicator_ecom,
            email_to,
            dc_useradj_store_cad,
            dc_onorder_store_cad,
            dc_finrev_store_cad,
            dc_publish_store_cad,
            po_indicator_store_cad,
            po_shipmode_store_cad,
            air_trigger_store_cad,
            cut_store_cad,
            published_at_store_cad,
            is_prepublished_store_cad,
            prepublished_at_store_cad,
            last_prepublished_store_cad,
            reason_code_store_cad,
            pack_ind_flag_store_cad,
            show_in_pack_store_cad,
            prepack_pct_store_cad,
            default_fringe_indicator_store_cad,
            dc_useradj_ecom_cad,
            dc_onorder_ecom_cad,
            dc_finrev_ecom_cad,
            dc_publish_ecom_cad,
            po_indicator_ecom_cad,
            po_shipmode_ecom_cad,
            air_trigger_ecom_cad,
            cut_ecom_cad,
            published_at_ecom_cad,
            is_prepublished_ecom_cad,
            prepublished_at_ecom_cad,
            last_prepublished_ecom_cad,
            reason_code_ecom_cad,
            pack_ind_flag_ecom_cad,
            show_in_pack_ecom_cad,
            prepack_pct_ecom_cad,
            default_fringe_indicator_ecom_cad
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            null as dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_isedited,
            dc_syscost,
            dc_lndcst,
            dc_sysvrp,
            dc_sc_useradj,
            dc_sc_finrev,
            po_indicator,
            po_shipmode,
            air_trigger,
            cut,
            null as published_at,
            null as is_prepublished,
            null as prepublished_at,
            null as last_prepublished,
            null as po_arr,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            null as published_at_ecom,
            null as is_prepublished_ecom,
            null as prepublished_at_ecom,
            null as last_prepublished_ecom,
            reason_code,
            reason_code_ecom,
            pack_ind_flag,
            pack_ind_flag_ecom,
            show_in_pack,
            show_in_pack_ecom,
            prepack_pct,
            prepack_pct_ecom,
            default_fringe_indicator,
            default_fringe_indicator_ecom,
            email_to,
            dc_useradj_store_cad,
            null as dc_onorder_store_cad,
            dc_finrev_store_cad,
            null as dc_publish_store_cad,
            po_indicator_store_cad,
            po_shipmode_store_cad,
            air_trigger_store_cad,
            cut_store_cad,
            null as published_at_store_cad,
            null as is_prepublished_store_cad,
            null as prepublished_at_store_cad,
            null as last_prepublished_store_cad,
            reason_code_store_cad,
            pack_ind_flag_store_cad,
            show_in_pack_store_cad,
            prepack_pct_store_cad,
            default_fringe_indicator_store_cad,
            dc_useradj_ecom_cad,
            null as dc_onorder_ecom_cad,
            dc_finrev_ecom_cad,
            null as dc_publish_ecom_cad,
            po_indicator_ecom_cad,
            po_shipmode_ecom_cad,
            air_trigger_ecom_cad,
            cut_ecom_cad,
            null as published_at_ecom_cad,
            null as is_prepublished_ecom_cad,
            null as prepublished_at_ecom_cad,
            null as last_prepublished_ecom_cad,
            reason_code_ecom_cad,
            pack_ind_flag_ecom_cad,
            show_in_pack_ecom_cad,
            prepack_pct_ecom_cad,
            default_fringe_indicator_ecom_cad
        FROM aeo_style_clone_flat_map_temp a,
             aeo_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO aeo_p_dc_adj_size (
            product,
            location,
            time,
            dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_scadj,
            dc_ttluseradj,
            dc_scfinrev,
            dc_ttlfinrev,
            dc_isedited,
            dc_onorder_v,
            dc_onorder_c,
            current_week,
            dc_last_pub_u,
            dc_last_pub,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_onorder_v_ecom,
            dc_onorder_c_ecom,
            dc_finrev_ecom,
            dc_publish_ecom,
            dc_last_pub_u_ecom,
            dc_last_pub_ecom,
            dc_useradj_store_cad,
            dc_onorder_store_cad,
            dc_onorder_v_store_cad,
            dc_onorder_c_store_cad,
            dc_finrev_store_cad,
            dc_publish_store_cad,
            dc_last_pub_u_store_cad,
            dc_last_pub_store_cad,
            dc_useradj_ecom_cad,
            dc_onorder_ecom_cad,
            dc_onorder_v_ecom_cad,
            dc_onorder_c_ecom_cad,
            dc_finrev_ecom_cad,
            dc_publish_ecom_cad,
            dc_last_pub_u_ecom_cad,
            dc_last_pub_ecom_cad
        )
        SELECT
            from_stylecolorsize,
            location,
            time,
            null as dc_publish,
            is_locked,
            dc_uservrp,
            dc_lockedqty,
            dc_useradj,
            null as dc_onorder,
            dc_finrev,
            dc_validwk,
            dc_finalqty,
            dc_adjcost,
            const_y_n,
            sbkt,
            dc_scadj,
            dc_ttluseradj,
            dc_scfinrev,
            dc_ttlfinrev,
            dc_isedited,
            null as dc_onorder_v,
            null as dc_onorder_c,
            current_week,
            null as dc_last_pub_u,
            null as dc_last_pub,
            now()::date,
            version_id,
            now(),
            v_pivot_user_id,
            now(),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom,
            dc_useradj_store_cad,
            null as dc_onorder_store_cad,
            null as dc_onorder_v_store_cad,
            null as dc_onorder_c_store_cad,
            dc_finrev_store_cad,
            null as dc_publish_store_cad,
            null as dc_last_pub_u_store_cad,
            null as dc_last_pub_store_cad,
            dc_useradj_ecom_cad,
            null as dc_onorder_ecom_cad,
            null as dc_onorder_v_ecom_cad,
            null as dc_onorder_c_ecom_cad,
            dc_finrev_ecom_cad,
            null as dc_publish_ecom_cad,
            null as dc_last_pub_u_ecom_cad,
            null as dc_last_pub_ecom_cad
        FROM aeo_style_clone_stylecolor_size a,
             aeo_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO aeo_an_price_storecount_info (
            product,
            channel,
            time,
            selling_channel,
            isfunded,
            store_count,
            in_season_flag,
            dbt_wk_date,
            last_rcpt_wk_date,
            erlstmkdnwk_date,
            exitdate_date,
            weekdate,
            price_status,
            seq,
            ccticketprice,
            curp,
            selling_price,
            expressed_aur,
            corpexcl,
            addoff,
            corpaddoff,
            v_a,
            v_b,
            ccdiscountpct,
            flow_flag
        )
        SELECT
            to_id,
            channel,
            time,
            selling_channel,
            isfunded,
            store_count,
            in_season_flag,
            dbt_wk_date,
            last_rcpt_wk_date,
            erlstmkdnwk_date,
            exitdate_date,
            weekdate,
            price_status,
            seq,
            ccticketprice,
            curp,
            selling_price,
            expressed_aur,
            corpexcl,
            addoff,
            corpaddoff,
            v_a,
            v_b,
            ccdiscountpct,
            flow_flag
        FROM aeo_style_clone_flat_map_temp a,
             aeo_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;



    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO aeo_l_dependencylookup (
            lookup_id,
            lookup_value,
            target_id,
            target_value
        )
        SELECT DISTINCT
            'style'    AS lookup_id,
            from_id    AS lookup_value,
            'patternedtostyle' AS target_id,
            to_id      AS target_value
        FROM aeo_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';


        INSERT INTO aeo_l_dependencylookup (
            lookup_id,
            lookup_value,
            target_id,
            target_value
        )
        SELECT DISTINCT
            'stylecolor' AS lookup_id,
            from_id      AS lookup_value,
            'patternedtostylecolor' AS target_id,
            to_id        AS target_value
        FROM aeo_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';


-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS aeo_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.aeo_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 532 (class 1255 OID 134295526)
-- Name: aeo_style_clone_stylecolor_size_proc_dummy(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.aeo_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- just return the input params
    RAISE NOTICE 'Session ID: %, Pivot User ID: %', p_session_id, p_pivot_user_id;

    -- if you want an actual SELECT result
    -- you can use PERFORM inside procedure
    -- but in Postgres procedures (as opposed to functions)
    -- SELECT output is not directly returned
    -- use RAISE NOTICE or OUT params
END;
$$;


ALTER PROCEDURE public.aeo_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 489 (class 1255 OID 134295475)
-- Name: after_add_to_assortment(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE
r refcursor;
BEGIN
  OPEN r FOR SELECT "jobid FROM plan_queue LIMIT 1";
 RETURN r;

END;
$$;


ALTER FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 494 (class 1255 OID 134295476)
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
    new.store_count := get_store_count(
      (select slsstart from aeo_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_climate)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_region_combo)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_hvlc)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_tourist_border_combo)), ','), 
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM aeo_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 503 (class 1255 OID 134295477)
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
  scWeekCount_pub = (select COUNT(*) from aeo_p_dc_adj 
   where product = stylecolorId 
   --and location = (select dc from aeo_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from aeo_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from aeo_p_dc_adj_size
   where product in (select id from aeo_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from aeo_l_dclookup where channel = channelId)
   and (dc_onorder > 0 or dc_onorder_ecom > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 504 (class 1255 OID 134295481)
-- Name: check_isprepublishable(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.check_isprepublishable(stylecolorid text) RETURNS text
    LANGUAGE plpgsql
    AS $$
 declare
 v_isprepublishable text;
 BEGIN
 v_isprepublishable:=1;
 /*
  select
  CASE
          WHEN (
                 COALESCE(length(btrim("substring"(a.erp_stylecolor_id, 1, 1))), 0) 
               ) = 1 
               AND (cc_pim_status is null or cc_pim_status = '' or upper(cc_pim_status) <> 'DROPPED')
               AND (cardinality(c.cc_validsizes_store) > 0 or cardinality(c.cc_validsizes_ecom) > 0)
               AND sty_size_run_name = pim_size_run_name
          THEN '1'::text
          ELSE '0'::text
      END AS isprepublishable
      into v_isprepublishable
  FROM aeo_ma_stylecolorattributes a
  JOIN aeo_h_prodstd b ON a.product = b.id
  JOIN aeo_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, cc_validsizes_store, cc_validsizes_ecom
                   from aeo_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  where a.product = stylecolorid
  ;
*/
  return v_isprepublishable;
 END;
$$;


ALTER FUNCTION public.check_isprepublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 505 (class 1255 OID 134295482)
-- Name: check_ispublishable(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.check_ispublishable(stylecolorid text) RETURNS text
    LANGUAGE plpgsql
    AS $$
 declare
 v_ispublishable text;
 BEGIN
 v_ispublishable:=1;
 /*
  select
  CASE
          WHEN (
                 COALESCE(length(btrim("substring"(a.erp_stylecolor_id, 1, 1))), 0)
               ) = 1 
               AND (cc_pim_status is null or cc_pim_status = '' or upper(cc_pim_status) <> 'DROPPED')
               AND (cardinality(c.cc_validsizes_store) > 0 or cardinality(c.cc_validsizes_ecom) > 0)
               AND sty_size_run_name = pim_size_run_name
          THEN '1'::text
          ELSE '0'::text
      END AS ispublishable
      into v_ispublishable
  FROM aeo_ma_stylecolorattributes a
  JOIN aeo_h_prodstd b ON a.product = b.id
  JOIN aeo_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, cc_validsizes_store, cc_validsizes_ecom
                   from aeo_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  where a.product = stylecolorid
  ;
*/

  return v_ispublishable;
 END;
$$;


ALTER FUNCTION public.check_ispublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 506 (class 1255 OID 134295483)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          UPDATE aeo_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 507 (class 1255 OID 134295484)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from aeo_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 508 (class 1255 OID 134295485)
-- Name: delete_records(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.delete_records(IN v_uid text)
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN


delete from aeo_ma_stylecolorattributes where product in (v_uid);
delete from aeo_ma_stylecolorchannelattributes where product in (v_uid);
delete from aeo_a_assortment where product in (v_uid);
delete from aeo_ma_sizeattributes where product in (Select id from aeo_h_prodstd where ancestor0 in (v_uid));
delete from aeo_p_dc_adj where product in (v_uid);
delete from aeo_p_dc_adj_size where product in (Select id from aeo_h_prodstd where ancestor0 in (v_uid));
delete from aeo_p_itemprice where product in (v_uid);
delete from aeo_p_channeloverride where product in (v_uid);


delete from aeo_d_product where id in (v_uid);
delete from aeo_d_product where id in (Select ancestor0 from aeo_h_prodstd where id in (v_uid));
delete from aeo_h_prodstd where id in (v_uid);
delete from aeo_h_prodstd where ancestor0 in (v_uid);


END;
$$;


ALTER PROCEDURE public.delete_records(IN v_uid text) OWNER TO psql;

--
-- TOC entry 509 (class 1255 OID 134295486)
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
-- TOC entry 510 (class 1255 OID 134295487)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE aeo_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 511 (class 1255 OID 134295488)
-- Name: fetch_store_count(text, text, text[], text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 DECLARE
  sls_start     text;
  dept_var      text;
  subclass_var  text;
 BEGIN

 select ancestor3 into dept_var
 from aeo_h_prodstd where id = productId;

 select ancestor1 into subclass_var
 from aeo_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from aeo_ma_dptflrsetattributes a
 where time = floorsetId and product = dept_var;

RETURN(
  SELECT
  count(*)
FROM
  (
    (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as a
    ) as gr
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_climate'
            AND value = ANY( str_climate )
        ) as a
    ) as ssc USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[]) OWNER TO psql;

--
-- TOC entry 512 (class 1255 OID 134295495)
-- Name: fetch_store_count(text, text, text[], text[], text[], text[], text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[], str_region_combo text[], str_hvlc text[], str_tourist_border_combo text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 DECLARE
  sls_start     text;
  dept_var      text;
  subclass_var  text;
 BEGIN

 select ancestor3 into dept_var
 from aeo_h_prodstd where id = productId;

 select ancestor1 into subclass_var
 from aeo_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from aeo_ma_dptflrsetattributes a
 where time = floorsetId and product = dept_var;

RETURN(
  SELECT
  count(*)
FROM
  (
    (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as a
    ) as gr
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_climate'
            AND value = ANY( str_climate )
        ) as a
    ) as ssc USING (store)
    INNER JOIN (
            SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_region_combo'
            AND value = ANY( str_region_combo )
        ) as a
    ) as sc USING (store)
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_hvlc'
            AND value = ANY( str_hvlc )
        ) as a
    ) as ssb USING (store)
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
         unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = sls_start
            AND product = subclass_var
            AND id = 'str_tourist_border_combo'
            AND value = ANY( str_tourist_border_combo )
        ) as a
    ) as sgr USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[], str_region_combo text[], str_hvlc text[], str_tourist_border_combo text[]) OWNER TO psql;

--
-- TOC entry 487 (class 1255 OID 134295471)
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
          , planned_sell_down_week
          , too
          , mkdnwks
          , last_rcpt_wk
          , erlstmkdnwk
          , exitdate
          , ccmdstrategy
          , presmin
          , presmin_weeks
          , retpct_str
          , retpct_ecomm
          , retpct_cross
          , ccrcptint
          , ccordermultiple
          , slsrnk_store
          , slsrnk_ecom
          , irw_debut_offset
          , use_act_aps_or_act_rank
          , use_valid_sizes_from
          , apply_size_mins_to
          , cc_addoff_store
          , cc_addoff_ecom
          , cc_service_level
          , cc_service_level_ecom

          --, initrcptwk_store_cad                   
          --, initrcptwk_ecom_us                     
          --, initrcptwk_ecom_cad                    
          --, irw_debut_offset_store_cad             
          --, irw_debut_offset_ecom_us               
          --, irw_debut_offset_ecom_cad              
          --, dbt_wk_store_cad                       
          --, dbt_wk_ecom_us                         
          --, dbt_wk_ecom_cad                        
          --, too_store_cad                          
          --, too_ecom_us                            
          --, too_ecom_cad                           
          --, erlstmkdnwk_store_cad                  
          --, erlstmkdnwk_ecom_us                    
          --, erlstmkdnwk_ecom_cad                   
          --, mkdnwks_store_cad                      
          --, mkdnwks_ecom_us                        
          --, mkdnwks_ecom_cad                       
          --, exitdate_store_cad                     
          --, exitdate_ecom_us                       
          --, exitdate_ecom_cad                      
          --, last_rcpt_wk_store_cad                 
          --, last_rcpt_wk_ecom_us                   
          --, last_rcpt_wk_ecom_cad                  
          --, slsrnk_store_cad                       
          --, slsrnk_ecom_cad                        
          --, cc_addoff_ecom_cad                     
          --, cc_addoff_store_cad                            
          --, cc_current_unit_retail                 
          --, cc_current_unit_retail_store_cad       
          --, cc_current_unit_retail_ecom_us         
          --, cc_current_unit_retail_ecom_cad        
          --, cc_plan_cost_store_cad                 
          --, cc_plan_cost_ecom_us                   
          --, cc_plan_cost_ecom_cad                  
          --, cc_systemcost_store_cad                
          --, cc_systemcost_ecom_us                  
          --, cc_systemcost_ecom_cad                 
          , cc_discount_pct_store_cad              
          , cc_discount_pct_ecom_us                
          , cc_discount_pct_ecom_cad               
          --, ccmdstrategy_store_cad                 
          --, ccmdstrategy_ecom_us                   
          --, ccmdstrategy_ecom_cad                  
          --, cc_validsizes_store_cad                
          --, cc_validsizes_ecom_cad                 
          --, cc_service_level_store_cad             
          --, cc_service_level_ecom_cad              
          --, cc_presmin_store_cad                   
          --, cc_presmin_ecom_us                     
          --, cc_presmin_ecom_cad                    
          --, cc_presmin_weeks_store_cad             
          --, cc_presmin_weeks_ecom_us               
          --, cc_presmin_weeks_ecom_cad              
          --, cc_rcptint_store_cad                   
          --, cc_rcptint_ecom_us                     
          --, cc_rcptint_ecom_cad                    
          --, cc_ordermin_store_cad                  
          --, cc_ordermin_ecom_us                    
          --, cc_ordermin_ecom_cad                   
          --, cc_lead_time_store_cad                 
          --, cc_lead_time_ecom_us                   
          --, cc_lead_time_ecom_cad                  
          --, cc_return_u_pct_store_cad              
          --, cc_return_u_pct_ecom_cad               
          --, cc_ordermultiple_store_cad             
          --, cc_ordermultiple_ecom_us               
          --, cc_ordermultiple_ecom_cad              
          --, ccticketpricechannel_store_cad         
          --, ccticketpricechannel_ecom_us           
          --, ccticketpricechannel_ecom_cad          
          --, ccticketpricechannel_store_cad_override
          --, ccticketpricechannel_ecom_us_override  
          --, ccticketpricechannel_ecom_cad_override 
        )
        SELECT distinct
            '''||$1||''','''||$2||''','''||$3||''','''||$4||''','''||$5||'''
          , e.id
          , ap_start
          , default_planned_sell_down_week
          , weeks_at_fp::integer
          , c.indx - b.indx as mkdnwks
          , f.id as last_rcpt_wk
          , markdown_week
          , exit_week
          , default_ccmdstrategy
          , default_presmin
          , default_presmin_weeks
          , default_retpct_str
          , default_retpct_ecom
          , default_crosschannel_retpct_ecom
          , default_ccrcptint
          , default_ccordermultiple_uom
          , default_slsrnk_store
          , default_slsrnk_ecom
          , irw_debut_offset

          , ''Copy Rating''                 -- use_act_aps_or_act_rank
          , ''Defaults – All Valid Sizes''  -- use_valid_sizes_from
          , ''Core Sizes Only''             -- apply_size_mins_to
          , 0.1::real                             -- cc_addoff_store
          , 0.1::real                             -- cc_addoff_ecom

          , default_service_level_stores
          , default_service_level_ecom

          --, initrcptwk_store_cad                   
          --, initrcptwk_ecom_us                     
          --, initrcptwk_ecom_cad                    
          --, irw_debut_offset_store_cad             
          --, irw_debut_offset_ecom_us               
          --, irw_debut_offset_ecom_cad              
          --, dbt_wk_store_cad                       
          --, dbt_wk_ecom_us                         
          --, dbt_wk_ecom_cad                        
          --, too_store_cad                          
          --, too_ecom_us                            
          --, too_ecom_cad                           
          --, erlstmkdnwk_store_cad                  
          --, erlstmkdnwk_ecom_us                    
          --, erlstmkdnwk_ecom_cad                   
          --, mkdnwks_store_cad                      
          --, mkdnwks_ecom_us                        
          --, mkdnwks_ecom_cad                       
          --, exitdate_store_cad                     
          --, exitdate_ecom_us                       
          --, exitdate_ecom_cad                      
          --, last_rcpt_wk_store_cad                 
          --, last_rcpt_wk_ecom_us                   
          --, last_rcpt_wk_ecom_cad                  
          --, slsrnk_store_cad                       
          --, slsrnk_ecom_cad                        
          --, cc_addoff_ecom_cad                     
          --, cc_addoff_store_cad                               
          --, cc_current_unit_retail                 
          --, cc_current_unit_retail_store_cad       
          --, cc_current_unit_retail_ecom_us         
          --, cc_current_unit_retail_ecom_cad        
          --, cc_plan_cost_store_cad                 
          --, cc_plan_cost_ecom_us                   
          --, cc_plan_cost_ecom_cad                  
          --, cc_systemcost_store_cad                
          --, cc_systemcost_ecom_us                  
          --, cc_systemcost_ecom_cad                 
          , default_ccdiscountpct_store_cad              
          , default_ccdiscountpct_ecom                
          , default_ccdiscountpct_ecom_cad               
          --, ccmdstrategy_store_cad                 
          --, ccmdstrategy_ecom_us                   
          --, ccmdstrategy_ecom_cad                  
          --, cc_validsizes_store_cad                
          --, cc_validsizes_ecom_cad                 
          --, cc_service_level_store_cad             
          --, cc_service_level_ecom_cad              
          --, cc_presmin_store_cad                   
          --, cc_presmin_ecom_us                     
          --, cc_presmin_ecom_cad                    
          --, cc_presmin_weeks_store_cad             
          --, cc_presmin_weeks_ecom_us               
          --, cc_presmin_weeks_ecom_cad              
          --, cc_rcptint_store_cad                   
          --, cc_rcptint_ecom_us                     
          --, cc_rcptint_ecom_cad                    
          --, cc_ordermin_store_cad                  
          --, cc_ordermin_ecom_us                    
          --, cc_ordermin_ecom_cad                   
          --, cc_lead_time_store_cad                 
          --, cc_lead_time_ecom_us                   
          --, cc_lead_time_ecom_cad                  
          --, cc_return_u_pct_store_cad              
          --, cc_return_u_pct_ecom_cad               
          --, cc_ordermultiple_store_cad             
          --, cc_ordermultiple_ecom_us               
          --, cc_ordermultiple_ecom_cad              
          --, ccticketpricechannel_store_cad         
          --, ccticketpricechannel_ecom_us           
          --, ccticketpricechannel_ecom_cad          
          --, ccticketpricechannel_store_cad_override
          --, ccticketpricechannel_ecom_us_override  
          --, ccticketpricechannel_ecom_cad_override 

        FROM 
          aeo_ma_dptflrsetattributes a, 
          aeo_d_time b,
          aeo_d_time c,
          aeo_d_time d,
          aeo_d_time e,
          aeo_d_time f
        WHERE 
          product = '''||$2||'''
          and time = '''||$5||'''
          and a.markdown_week = b.id
          and a.exit_week = c.id
          and a.ap_start = d.id
          and d.indx = e.indx + a.irw_debut_offset
          and f.indx = b.indx - 4
          ';
  delete_s3 := ' 
     delete from cart_ranging where jsessionid = '''||$1||''' and scope_product='''||$2||''' 
     and scope_start = '''||$4||''' and scope_floorset = '''||$5||'''  
             ';
  insert_s4 := '
  insert into cart_ranging 
(jsessionid,scope_product,scope_location,scope_start,scope_floorset
   ,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,isfunded, indx, store_count)
select 
  '''||$1||''',product,'''||$3||''','''||$4||'''
  , time 
  , default_grade
  , default_strclimate
  , default_str_region_combo
  , default_str_hvlc
  , default_str_tourist_border_combo
  , default_ssg
  , isfunded
  , indx
  , store_count
  FROM (
  select a.product, time,default_grade,default_strclimate,default_str_region_combo,default_str_hvlc,default_str_tourist_border_combo, default_ssg
   ,1 as isfunded, a.indx, 
   array_length(stores, 1) as store_count
  FROM aeo_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from aeo_serviceparams where id=''plan_current'') c,
   (select value as plan_end from aeo_serviceparams where id=''plan_end'') d,
   aeo_l_ssglookup e
  where 
  b.jsessionid = '''||$1||'''
  and b.scope_product = '''||$2||'''
  and b.scope_location = '''||$3||'''
  and a.product = b.scope_product
     and a.ap_start <= least(d.plan_end,b.exitdate) and a.ap_end > greatest(b.dbt_wk,c.plan_current)
  and e.product = '''||$2||'''
  and e.ssg_id = array_to_string(default_ssg, '','')
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
-- TOC entry 486 (class 1255 OID 134295470)
-- Name: get_store_count(text, text[], text[], text[], text[], text[], text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, str_grade text[], str_climate text[], str_region_combo text[], str_hvlc text[], str_tourist_border_combo text[], productval text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 BEGIN
RETURN(
  SELECT
  count(*)
FROM
  (
    (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as a
    ) as gr
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_climate'
            AND value = ANY( str_climate )
        ) as a
    ) as ssc USING (store)
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_region_combo'
            AND value = ANY( str_region_combo )
        ) as a
    ) as sc USING (store)
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_hvlc'
            AND value = ANY( str_hvlc )
        ) as a
    ) as ssb USING (store)
    INNER JOIN (
      SELECT
        distinct(a.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            aeo_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_tourist_border_combo'
            AND value = ANY( str_tourist_border_combo )
        ) as a
    ) as sgr USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.get_store_count(week text, str_grade text[], str_climate text[], str_region_combo text[], str_hvlc text[], str_tourist_border_combo text[], productval text) OWNER TO psql;

--
-- TOC entry 513 (class 1255 OID 134295496)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from aeo_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 514 (class 1255 OID 134295497)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

update aeo_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update aeo_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from aeo_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 515 (class 1255 OID 134295498)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE aeo_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 516 (class 1255 OID 97070025)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 485 (class 1255 OID 97070026)
-- Name: notify_plan_queue_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_plan_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY plan_queue_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_plan_queue_change() OWNER TO psql;

--
-- TOC entry 517 (class 1255 OID 134295499)
-- Name: on_publish_remove_from_worklist(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.on_publish_remove_from_worklist() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  DELETE FROM user_worklist WHERE user_id = NEW.updated_by and product=NEW.worklist_id;
  RETURN NEW;
  
END;
$$;


ALTER FUNCTION public.on_publish_remove_from_worklist() OWNER TO psql;

--
-- TOC entry 518 (class 1255 OID 134295500)
-- Name: on_unpublish_remove_from_worklist(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.on_unpublish_remove_from_worklist() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  DELETE FROM user_worklist WHERE user_id = NEW.updated_by and (product=NEW.worklist_id OR product in (select worklist_id from worklist_map where product=NEW.product));
  INSERT INTO user_worklist (user_id, product) select updated_by, worklist_id from aeo_p_stylecolor_worklist
  where updated_by=NEW.updated_by and worklist_id=NEW.worklist_id ; 
  RETURN NEW;
  
END;
$$;


ALTER FUNCTION public.on_unpublish_remove_from_worklist() OWNER TO psql;

--
-- TOC entry 519 (class 1255 OID 97070027)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM aeo_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 520 (class 1255 OID 134295501)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
sls_start     text;
dept_var      text;
subclass_var  text;
BEGIN

  select ancestor3 into dept_var
  from aeo_h_prodstd where id = NEW.product;

  select ancestor1 into subclass_var
  from aeo_h_prodstd where id = NEW.product;

  select a.slsstart into sls_start 
  from aeo_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;

  -- 
  if (cardinality(OLD.SSG) > 0 or OLD.SSG is not null) 
    and (cardinality(OLD.str_grade)                = 0 and
         cardinality(OLD.str_climate)              = 0 and
         cardinality(OLD.str_region_combo)         = 0 and
         cardinality(OLD.str_hvlc)                 = 0 and
         cardinality(OLD.str_tourist_border_combo) = 0 
        ) 
    and (cardinality(NEW.str_grade) > 0 or
         cardinality(NEW.str_climate) > 0 or
         cardinality(NEW.str_region_combo) > 0 or
         cardinality(NEW.str_hvlc) > 0 or
         cardinality(NEW.str_tourist_border_combo) > 0 
        ) 
  then
      NEW.SSG := '{}'::text[];

      if cardinality(NEW.str_grade) = 0 then 
        select default_grade into NEW.str_grade from aeo_ma_dptflrsetattributes where time = NEW.time and product = dept_var;
      end if;
      if cardinality(NEW.str_climate) = 0 then
        select default_strclimate into NEW.str_climate from aeo_ma_dptflrsetattributes where time = NEW.time and product = dept_var;
      end if;
      if cardinality(NEW.str_region_combo) = 0 then
        select default_str_region_combo into NEW.str_region_combo from aeo_ma_dptflrsetattributes where time = NEW.time and product = dept_var;
      end if;
      if cardinality(NEW.str_hvlc) = 0 then
        select default_str_hvlc into NEW.str_hvlc from aeo_ma_dptflrsetattributes where time = NEW.time and product = dept_var;
      end if;
      if cardinality(NEW.str_tourist_border_combo) = 0 then
        select default_str_tourist_border_combo into NEW.str_tourist_border_combo from aeo_ma_dptflrsetattributes where time = NEW.time and product = dept_var;
      end if;
  elsif (cardinality(OLD.SSG) = 0 or OLD.SSG is null) 
    and (cardinality(OLD.str_grade)         > 0 or
         cardinality(OLD.str_climate) > 0 or
         cardinality(OLD.str_region_combo)      > 0 or
         cardinality(OLD.str_hvlc)  > 0 or
         cardinality(OLD.str_tourist_border_combo)    > 0 
        ) 
    and cardinality(NEW.ssg) > 0
   then
      NEW.str_grade                  :=  '{}'::text[];
      NEW.str_climate                :=  '{}'::text[];
      NEW.str_region_combo           :=  '{}'::text[];
      NEW.str_hvlc                   :=  '{}'::text[];
      NEW.str_tourist_border_combo   :=  '{}'::text[];
         
  end if;

  if cardinality(NEW.SSG) = 0 or NEW.SSG is null then 
  
      NEW.store_count := get_store_count(
                                           sls_start
                                          ,NEW.str_grade
                                          ,NEW.str_climate
                                          ,NEW.str_region_combo
                                          ,NEW.str_hvlc
                                          ,NEW.str_tourist_border_combo
                                          ,subclass_var
                                        );
  else 
      select cardinality(stores) into NEW.store_count
      from aeo_l_ssglookup 
      where ssg_id = array_to_string(NEW.SSG, ',')
        and product = dept_var;

  end if;

  update aeo_a_assortment a
  set str_grade = NEW.str_grade
     ,str_climate = NEW.str_climate
     ,str_region_combo = NEW.str_region_combo
     ,str_hvlc = NEW.str_hvlc
     ,str_tourist_border_combo = NEW.str_tourist_border_combo
     ,ssg = NEW.ssg
     ,store_count = NEW.store_count
  where product = NEW.product
    and location = NEW.location
    and time in (select id from aeo_d_time where indx >= (select indx from aeo_d_time where id = NEW.time) and time in (select time from aeo_a_assortment where product = NEW.product and location = NEW.location))
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 521 (class 1255 OID 134295502)
-- Name: remove_from_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_from_assortment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
rec_count integer;
v_specstyleid text;
v_specstylecolorid text;
v_index text;
v_subclass text;
BEGIN

IF NEW.cloned_at IS NOT NULL THEN
  RETURN NEW;
END IF;

--  select sty_spec_style into v_specstyleid 
--  from aeo_ma_styleattributes where product = (select ancestor0 from aeo_h_prodstd where id = NEW.product) ;
--
--  select cc_spec_stylecolor into v_specstylecolorid
--  from aeo_ma_stylecolorattributes where product = NEW.product;
--
--  select ancestor1 into v_subclass from aeo_h_prodstd where id = NEW.product;
--
--  if v_specstylecolorid is not null then
--    update aeo_ma_stylecolorattributes a
--    set cc_spec_stylecolor = null
--    where product = NEW.product;
--
--    select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from aeo_l_dependencylookup;
--
--    insert into aeo_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
--    values('specstyle_id', v_specstyleid, 'specstylecolor_id', v_specstylecolorid, v_index);
--  end if;

  select count(*) into rec_count
  from aeo_ma_stylecolorchannelattributes 
  where record_state = 0
  and product in (select id from aeo_h_prodstd where ancestor0 in (select ancestor0 from aeo_h_prodstd where id = NEW.product));

  if rec_count = 0 and v_specstyleid is not null then
    update aeo_ma_styleattributes set sty_spec_style = null
    where product in (select ancestor0 from aeo_h_prodstd where id = NEW.product);
    --if v_specstyleid is not null then
    --  select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from aeo_l_dependencylookup;
    --
    --  insert into aeo_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
    --  values('subclass', v_subclass, 'specstyle_id', v_specstyleid, v_index);
    --end if;
  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.remove_from_assortment() OWNER TO psql;

--
-- TOC entry 522 (class 1255 OID 134295503)
-- Name: reset_to_prev_if_approved(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.reset_to_prev_if_approved() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_clustering_status real;
BEGIN
    -- Fetch clustering status for the current store_cluster_id
    SELECT clustering_status 
    INTO v_clustering_status
    FROM aeo_p_approvedclusters 
    WHERE cluster_id = NEW.store_cluster_id;

    -- Update reassigned_cluster based on the clustering status
    UPDATE aeo_p_reassigncluster 
    SET reassigned_cluster = CASE 
                                WHEN v_clustering_status = 1 THEN OLD.reassigned_cluster 
                                ELSE NEW.reassigned_cluster 
                             END
    WHERE 
        store_cluster_id = NEW.store_cluster_id
    and product = NEW.product 
    and location = NEW.location 
    and time = NEW.time
    ;

    -- Return the NEW record
    RETURN NEW;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case where no cluster_id is found in aeo_p_approvedclusters
        RAISE NOTICE 'No clustering status found for store_cluster_id %', NEW.store_cluster_id;
        RETURN NEW;
    WHEN OTHERS THEN
        -- Handle other exceptions
        RAISE NOTICE 'An error occurred: %', SQLERRM;
        RETURN NEW;
END;
$$;


ALTER FUNCTION public.reset_to_prev_if_approved() OWNER TO psql;

--
-- TOC entry 523 (class 1255 OID 134295507)
-- Name: revert_to_original(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.revert_to_original() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  RETURN NULL;
END;
$$;


ALTER FUNCTION public.revert_to_original() OWNER TO psql;

--
-- TOC entry 524 (class 1255 OID 134295508)
-- Name: set_floorset_fields_on_initrcptwk_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_floorset_fields_on_initrcptwk_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dept              text;  -- ancestor3
  v_superset_id       text;
  v_superset_name     text;
  v_time              text;
  v_floorset_uda      text;
  v_floorset_uda_name text;
BEGIN
  IF TG_OP = 'INSERT'
     OR (TG_OP = 'UPDATE' AND NEW.initrcptwk IS DISTINCT FROM OLD.initrcptwk) THEN

    IF NEW.initrcptwk IS NULL THEN
      RETURN NEW;
    END IF;

    -- product -> ancestor3 (department)
    SELECT h.ancestor3
      INTO v_dept
    FROM aeo_h_prodstd h
    WHERE h.id = NEW.product
    LIMIT 1;

    IF v_dept IS NOT NULL THEN
      -- pick the floorset row whose receipt window contains NEW.initrcptwk
      SELECT
          d.superset_id::text,
          d.superset_name::text,
          d."time"::text,
          d.floorset_uda::text,
          substr(d.floorset_uda, 4)   -- adjust if your naming isn’t prefix-based
      INTO v_superset_id, v_superset_name, v_time, v_floorset_uda, v_floorset_uda_name
      FROM aeo_ma_dptflrsetattributes d
      WHERE d.product = v_dept
        AND NEW.initrcptwk >= d.rcptstart
        AND NEW.initrcptwk <= d.rcptend
      ORDER BY d.rcptstart DESC
      LIMIT 1;

      -- write back only when found
      IF v_superset_id IS NOT NULL THEN
        NEW.irw_superset := v_superset_id;
      END IF;

      IF v_superset_name IS NOT NULL THEN
        NEW.irw_superset_display := v_superset_name;
      END IF;

      IF v_time IS NOT NULL THEN
        NEW.irw_floorset_id := v_time;
      END IF;

      IF v_floorset_uda IS NOT NULL THEN
        NEW.irw_floorset := v_floorset_uda;
      END IF;

      IF v_floorset_uda_name IS NOT NULL THEN
        NEW.irw_floorset_display := v_floorset_uda_name;
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_floorset_fields_on_initrcptwk_change() OWNER TO psql;

--
-- TOC entry 525 (class 1255 OID 134295509)
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
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from aeo_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';
EXECUTE s1;
s2 := '
  update aeo_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';
EXECUTE s2;
s3 := '
  update aeo_ma_sizeattributes a
  set isvalid=b.isvalid
  from '||table_temp_isvalid_master||' b
  where a.parent_id=b.product
  and a.sizeattribute=b.validsizes
  ';
EXECUTE s3;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_isvalid() OWNER TO psql;

--
-- TOC entry 527 (class 1255 OID 134295510)
-- Name: sizerangecode_validsizes_members(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sizerangecode_validsizes_members() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
  table_temp_rangecode_master text;
  v_uuid text;
  v_product text := NEW.product;
  v_location text := NEW.location;
  v_ccrangecode text := NEW.ccrangecode;
  v_sty_size_range text;
BEGIN
  -- Parse size range safely
  v_sty_size_range := split_part(v_ccrangecode, ' - ', 1);

  -- Temp table name
  SELECT replace(uuid_generate_v4()::text, '-', '_') INTO v_uuid;
  table_temp_rangecode_master := format('table_temp_rangecode_master_%s', v_uuid);

  -- Build work table
  EXECUTE format('DROP TABLE IF EXISTS %I', table_temp_rangecode_master);
  EXECUTE format(
    'CREATE TEMP TABLE %I ON COMMIT DROP AS
       SELECT DISTINCT $1::text AS product,
                        $2::text AS location,
                        lookup_value AS ccrangecode,
                        target_value AS master_size_attr,
                        uuid_generate_v4()::text AS memberid,
                        0::int AS member_exists,
                        b.size_code AS size_code,
                        b.size_attribute AS size_name
         FROM aeo_l_dependencylookup a
         JOIN aeo_size_range_mapping b
           ON a.lookup_value = b.sty_size_range AND a.target_value = b.sizeattribute
        WHERE a.lookup_id = ''size_range''
          AND a.lookup_value = $3::text', table_temp_rangecode_master)
  USING v_product, v_location, v_sty_size_range;

  -- Tag existing members
  EXECUTE format(
    'UPDATE %I a
        SET memberid = b.product, member_exists = 1
       FROM aeo_ma_sizeattributes b
      WHERE a.product = b.parent_id AND a.master_size_attr = b.sizeattribute',
    table_temp_rangecode_master);

  -- Invalidate current children
  UPDATE aeo_ma_sizeattributes
     SET isvalid = 0
   WHERE parent_id = v_product;

  -- Remove dup rows about to refresh
  EXECUTE format(
    'DELETE FROM aeo_ma_sizeattributes
      WHERE product IN (SELECT memberid FROM %I)', table_temp_rangecode_master);

  -- Insert/refresh members
  EXECUTE format(
    'INSERT INTO aeo_ma_sizeattributes (product, sizeattribute, parent_id, isvalid, size_code, size_name)
     SELECT  memberid, master_size_attr, product, 1 as isvalid, size_code, size_name FROM %I',
    table_temp_rangecode_master);

  -- Ensure dim rows exist for new members
  EXECUTE format(
    'DELETE FROM aeo_d_product WHERE id IN (SELECT memberid FROM %I WHERE member_exists=0);',
    table_temp_rangecode_master);
  EXECUTE format(
    'INSERT INTO aeo_d_product (id, name, description, levelid)
     SELECT memberid, b.name||'':''||a.size_name, b.description||'':''||a.size_name, ''stylecolorsize''
       FROM %I as a,
       aeo_d_product b 
       WHERE member_exists=0
       and b.id = a.product;',
    table_temp_rangecode_master);

  -- Copy hierarchy for new members
  EXECUTE format(
    'DELETE FROM aeo_h_prodstd WHERE id IN (SELECT memberid FROM %I WHERE member_exists=0);',
    table_temp_rangecode_master);
  EXECUTE format(
    'INSERT INTO aeo_h_prodstd
           (id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4, ancestor5, ancestor6, version_id, created_at, created_by, updated_at, updated_by, record_state)
     SELECT memberid  ,id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4, ancestor5, version_id, created_at, created_by, updated_at, updated_by,record_state
       FROM aeo_h_prodstd h
       JOIN (SELECT memberid, product FROM %I WHERE member_exists=0) t
         ON h.id = t.product;',
    table_temp_rangecode_master);

  -- Clear DC user adj for invalidated sizes
  UPDATE aeo_p_dc_adj_size a
     SET dc_useradj = NULL
   WHERE product IN (
         SELECT product
           FROM aeo_ma_sizeattributes
          WHERE isvalid = 0 AND parent_id = v_product
       );

  RETURN NEW;
END;
$_$;


ALTER FUNCTION public.sizerangecode_validsizes_members() OWNER TO psql;

--
-- TOC entry 528 (class 1255 OID 134295511)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_relaunchweek text;
BEGIN
    --RAISE NOTICE 'OLD.dbt_wk: %', OLD.dbt_wk;
    --RAISE NOTICE 'OLD.relaunchweek: %', OLD.relaunchweek;
    --RAISE NOTICE 'OLD.exitdate: %', OLD.exitdate;
    --RAISE NOTICE 'NEW.dbt_wk: %', NEW.dbt_wk;
    --RAISE NOTICE 'NEW.relaunchweek: %', NEW.relaunchweek;
    --RAISE NOTICE 'NEW.exitdate: %', NEW.exitdate;
    v_relaunchweek := Case When NEW.relaunchweek = '' THEN null Else NEW.relaunchweek END;
    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from aeo_ma_dptflrsetattributes a, aeo_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from aeo_h_prodstd where id=NEW.product)
    and b.product = NEW.product
    and b.location = NEW.location
    and ap_start <= NEW.exitdate and ap_end >= COALESCE(v_relaunchweek, NEW.dbt_wk)
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style,indx, isfunded, store_count
    from aeo_a_assortment a, aeo_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from aeo_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from aeo_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into aeo_a_assortment 
        (product,location,time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into aeo_a_assortment 
        (product,location,time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into aeo_a_assortment 
        (product,location,time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update aeo_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, COALESCE(c.relaunchweek, c.dbt_wk) as dbt_wk, d.ap_start, d.ap_end  from aeo_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.ap_start,b.ap_end from aeo_a_assortment a 
          join (select c.time,ap_start,ap_end from aeo_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.ap_start 
    and c.dbt_wk <= d.ap_end) filtered 
    where aeo_a_assortment.time=filtered.time and aeo_a_assortment.product=filtered.product;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 533 (class 1255 OID 134295527)
-- Name: trg_allow_scaling_set_overflow_ok(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_allow_scaling_set_overflow_ok() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only act if allow_scaling was false and is now being set to true
  IF OLD.allow_scaling IS DISTINCT FROM TRUE AND NEW.allow_scaling = TRUE THEN
    -- Only override overflow_ok if the user hasn't explicitly set it to false
    IF NEW.overflow_ok IS DISTINCT FROM TRUE THEN
      NEW.overflow_ok := TRUE;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_allow_scaling_set_overflow_ok() OWNER TO psql;

--
-- TOC entry 534 (class 1255 OID 134295528)
-- Name: trg_ins_stylecolor_alloc_attrs(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_ins_stylecolor_alloc_attrs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO aeo_ma_stylecolor_alloc_attributes (product)
    VALUES (NEW.product)
    ON CONFLICT (product) DO NOTHING;      -- avoids duplicate-key errors
    RETURN NEW;                            -- preserve normal insert behaviour
END;
$$;


ALTER FUNCTION public.trg_ins_stylecolor_alloc_attrs() OWNER TO psql;

--
-- TOC entry 535 (class 1255 OID 134295529)
-- Name: trg_sclr_allow_scaling_set_overflow_ok(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_sclr_allow_scaling_set_overflow_ok() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only act if sclr_allow_scaling was not 1.0 before and is now being set to 1.0
  IF OLD.sclr_allow_scaling IS DISTINCT FROM 1.0 AND NEW.sclr_allow_scaling = 1.0 THEN
    -- Only override overflow_ok if it's not already 1.0
    IF NEW.sclr_overflow_ok IS DISTINCT FROM 1.0 THEN
      NEW.sclr_overflow_ok := 1.0;
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_sclr_allow_scaling_set_overflow_ok() OWNER TO psql;

--
-- TOC entry 536 (class 1255 OID 134295530)
-- Name: trg_set_apply_targets_to_plan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_set_apply_targets_to_plan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.floorset_uda ILIKE '%Carryover%' OR NEW.floorset_uda ILIKE '%Future%' THEN
        NEW.apply_targets_to_plan := NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_set_apply_targets_to_plan() OWNER TO psql;

--
-- TOC entry 537 (class 1255 OID 134295531)
-- Name: trg_sum_override_array(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_sum_override_array() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.sclr_loc_wrk_size_user_override IS NOT NULL THEN
    -- Filter out NULLs and sum remaining values
    SELECT SUM(x)::int
    INTO NEW.sclr_loc_wrk_alloc_sclr_qty
    FROM unnest(NEW.sclr_loc_wrk_size_user_override) AS x
    WHERE x IS NOT NULL and x > 0;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_sum_override_array() OWNER TO psql;

--
-- TOC entry 526 (class 1255 OID 134295535)
-- Name: trg_sync_alloc_and_override(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_sync_alloc_and_override() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Case 1: If NEW override array is present, sum into alloc qty
  IF NEW.sclr_loc_wrk_size_user_override IS NOT NULL THEN
    SELECT SUM(x)::int
    INTO NEW.sclr_loc_wrk_alloc_sclr_qty
    FROM unnest(NEW.sclr_loc_wrk_size_user_override) AS x
    WHERE x IS NOT NULL and x >= 0;

  -- Case 2: If alloc qty is provided, and override is NOT being set
  ELSIF NEW.sclr_loc_wrk_alloc_sclr_qty IS NOT NULL
     AND (
       OLD.sclr_loc_wrk_size_user_override IS NULL OR
       array_length(OLD.sclr_loc_wrk_size_user_override, 1) IS NULL
     )
  THEN
    NEW.sclr_loc_wrk_size_user_override := NULL;
    NEW.sclr_loc_alloc_sizeattr_for_size_override := NULL;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_sync_alloc_and_override() OWNER TO psql;

--
-- TOC entry 490 (class 1255 OID 134295536)
-- Name: trigger_final_cost(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_final_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_final_cost real;
BEGIN

  update aeo_ma_stylecolorchannelattributes a
  set cc_final_cost =  NEW.cc_plan_cost
  from aeo_ma_stylecolorattributes b
  where a.product = b.product and a.product = NEW.product;

  select cc_final_cost into v_final_cost
  from aeo_ma_stylecolorchannelattributes where product = NEW.product;

  update aeo_ma_stylecolorchannelattributes 
  set cc_imupct = coalesce(round(((NEW.ccticketpricechannel-v_final_cost)/NEW.ccticketpricechannel)::numeric, 2),0.0)
  where product = NEW.product;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_final_cost() OWNER TO psql;

--
-- TOC entry 538 (class 1255 OID 134295537)
-- Name: trigger_set_cp_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_cp_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dc_publish real; 
BEGIN
  select dc_publish into v_dc_publish from aeo_p_dc_adj where product = NEW.product and time = NEW.time and location = NEW.location;

 IF NEW.po_status = 1
 THEN
   NEW.created_at = NOW()::timestamp(0);
   NEW.created_by = 'user_published';

  IF v_dc_publish = 1
  THEN
    insert into sync_outbound_dataqueue (product,time,publish_type)
    select NEW.product, NEW.time, 'PO' as publish_type;
  END IF;

  IF v_dc_publish is null OR v_dc_publish != 1
  THEN
    NEW.po_status := 0;
  END IF;

 END IF; 
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_cp_publish_timestamp() OWNER TO psql;

--
-- TOC entry 539 (class 1255 OID 134295538)
-- Name: trigger_set_dc_ttl_useradj(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_dc_ttl_useradj() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.dc_ttluseradj = NEW.dc_useradj + NEW.dc_useradj_ecom;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_dc_ttl_useradj() OWNER TO psql;

--
-- TOC entry 540 (class 1255 OID 134295539)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from aeo_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 541 (class 1255 OID 134295543)
-- Name: trigger_set_pack_ind_flag(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_pack_ind_flag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF NEW.reason_code = 'Initial'
 THEN

  NEW.pack_ind_flag := 'TRUE';

 END IF; 
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_pack_ind_flag() OWNER TO psql;

--
-- TOC entry 542 (class 1255 OID 134295544)
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

   insert into sync_outbound_dataqueue (product,time,publish_type)
   select NEW.product, NEW.time, 'RDY4PO' as publish_type
   ;

   update aeo_ma_stylecolorchannelattributes 
   set cc_first_publish_date = coalesce(cc_first_publish_date, NOW()::timestamp(0)),
       cc_first_publish_snapshot_op = coalesce(cc_first_publish_snapshot_op, 1)
   where product = NEW.product;

 END IF; 
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 543 (class 1255 OID 134295545)
-- Name: trigger_set_size_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_size_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare curSizeId integer;
BEGIN
IF (NEW.size_id is null or new.size_id = '99999')
then
    select size_id into curSizeId from size_ids si where si.size_name = new.sizeattribute;
    new.size_id = curSizeId;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_size_id() OWNER TO psql;

--
-- TOC entry 544 (class 1255 OID 134295546)
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
-- TOC entry 545 (class 1255 OID 134295547)
-- Name: update_cc_validsizes_on_ccrangecode(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_validsizes_on_ccrangecode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_store  text[];
  v_ecom   text[];
  v_cc_size_eligibility_profile text;
BEGIN
  -- 1) Model – All Valid Sizes → clear profile and bypass
  IF NEW.use_valid_sizes_from = 'Model – All Valid Sizes' THEN
    NEW.cc_size_eligibility_profile := NULL;
    RETURN NEW;
  END IF;

  -- 2) Profile change → rebuild using the named profile (if provided)
  IF TG_OP = 'UPDATE'
     AND NEW.cc_size_eligibility_profile IS DISTINCT FROM OLD.cc_size_eligibility_profile
     AND NEW.cc_size_eligibility_profile IS NOT NULL
  THEN
    -- Bail if nothing matches this profile
    IF NOT EXISTS (
      SELECT 1
      FROM aeo_l_sizeeligibility_with_ccrangecode e
      WHERE e.ccrangecode = NEW.ccrangecode
        AND e.size_eligibility_default_display_name = NEW.cc_size_eligibility_profile
        AND (e.store_ineligible = 0 OR e.web_ineligible = 0)
    ) THEN
      RETURN NEW;
    END IF;

    SELECT
      ARRAY_AGG(DISTINCT e.sizeattribute::text ORDER BY e.sizeattribute::text)
        FILTER (WHERE e.store_ineligible = 0),
      ARRAY_AGG(DISTINCT e.sizeattribute::text ORDER BY e.sizeattribute::text)
        FILTER (WHERE e.web_ineligible = 0)
    INTO v_store, v_ecom
    FROM aeo_l_sizeeligibility_with_ccrangecode e
    WHERE e.ccrangecode = NEW.ccrangecode
      AND e.size_eligibility_default_display_name = NEW.cc_size_eligibility_profile;

    NEW.cc_validsizes_store := COALESCE(v_store, '{}'::text[]);
    NEW.cc_validsizes_ecom  := COALESCE(v_ecom,  '{}'::text[]);
    RETURN NEW;
  END IF;

  -- 3) Defaults – All Valid Sizes OR ccrangecode changed → rebuild using default set
  IF NEW.use_valid_sizes_from = 'Defaults – All Valid Sizes'
     -- OR (TG_OP = 'UPDATE' AND NEW.ccrangecode IS DISTINCT FROM OLD.ccrangecode)
  THEN
    -- Bail if no default rows exist
    IF NOT EXISTS (
      SELECT 1
      FROM aeo_l_sizeeligibility_with_ccrangecode e
      WHERE e.ccrangecode = NEW.ccrangecode
        AND e.is_default = 1
        AND (e.store_ineligible = 0 OR e.web_ineligible = 0)
    ) THEN
        NEW.cc_size_eligibility_profile := NULL;
      RETURN NEW;
    END IF;

    SELECT
      ARRAY_AGG(DISTINCT e.sizeattribute::text ORDER BY e.sizeattribute::text)
        FILTER (WHERE e.store_ineligible = 0),
      ARRAY_AGG(DISTINCT e.sizeattribute::text ORDER BY e.sizeattribute::text)
        FILTER (WHERE e.web_ineligible = 0),
      MIN(e.size_eligibility_default_display_name)::text
    INTO v_store, v_ecom, v_cc_size_eligibility_profile
    FROM aeo_l_sizeeligibility_with_ccrangecode e
    WHERE e.ccrangecode = NEW.ccrangecode
      AND e.is_default = 1;

    NEW.cc_validsizes_store := COALESCE(v_store, '{}'::text[]);
    NEW.cc_validsizes_ecom  := COALESCE(v_ecom,  '{}'::text[]);
    NEW.cc_size_eligibility_profile := v_cc_size_eligibility_profile;
    RETURN NEW;
  END IF;

  -- 4) Anything else → no change
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_cc_validsizes_on_ccrangecode() OWNER TO psql;

--
-- TOC entry 546 (class 1255 OID 134295548)
-- Name: update_ccrangecode_on_class_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ccrangecode_on_class_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_size_range  text;
  v_new_ccrange text;
BEGIN
  -- Get the parent product’s size range (to build the code)
  SELECT sa.sty_size_range
  INTO v_size_range
  FROM aeo_ma_styleattributes sa
  WHERE sa.product = NEW.id
  LIMIT 1;

  IF v_size_range IS NULL OR NEW.ancestor1 IS NULL THEN
    RETURN NEW;
  END IF;

  v_new_ccrange := btrim(v_size_range) || ' - ' || btrim(NEW.ancestor1);

  -- Update only children: all rows in aeo_h_prodstd with ancestor0 = NEW.id
  UPDATE aeo_ma_stylecolorchannelattributes s
  SET ccrangecode = v_new_ccrange
  FROM (
    SELECT id
    FROM aeo_h_prodstd
    WHERE ancestor0 = NEW.id
  ) ch
  WHERE s.product = ch.id
    AND s.ccrangecode IS DISTINCT FROM v_new_ccrange;

  RETURN NEW; -- AFTER trigger
END;
$$;


ALTER FUNCTION public.update_ccrangecode_on_class_change() OWNER TO psql;

--
-- TOC entry 547 (class 1255 OID 134295549)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

  v_style_description aeo_d_product.description%type;
  v_style_name aeo_d_product.name%type;

BEGIN

  select name, description into v_style_name, v_style_description 
  from aeo_d_product where id = (select ancestor0 from aeo_h_prodstd where id = NEW.product);
  
  NEW.cc_color_desc := NEW.cccolor;

  select target_value into NEW.cc_color_code
  from aeo_l_dependencylookup
  where lookup_id = 'cccolor' and target_id = 'color_code' and lookup_value = NEW.cccolor;
 
  select target_value into NEW.cccolorfamily
  from aeo_l_dependencylookup 
  where lookup_id = 'cccolor' and target_id = 'cccolorfamily' and lookup_value = NEW.cccolor;

  select target_value into NEW.color_name
  from aeo_l_dependencylookup 
  where lookup_id = 'cccolor' and target_id = 'color_description' and lookup_value = NEW.cccolor;

  select target_value into NEW.cccolorid
  from aeo_l_dependencylookup 
  where lookup_id = 'cccolor' and target_id = 'color_id' and lookup_value = NEW.cccolor;

  select target_value into NEW.cc_color_group
  from aeo_l_dependencylookup 
  where lookup_id = 'cccolor' and target_id = 'color_group' and lookup_value = NEW.cccolor;


  if NEW.cccolor is not null and NEW.cccolor <> '' then
    
  update aeo_ma_stylecolorattributes
    set cc_color_code = NEW.cc_color_code
       ,color_name = NEW.color_name
       ,cccolorfamily = NEW.cccolorfamily
       ,cccolorid = NEW.cccolorid
       ,cc_color_group = NEW.cc_color_group
  where product = new.product;
  
    update aeo_d_product 
    set description = v_style_description || ':' || NEW.color_name,
        name = v_style_name || NEW.cc_color_code
    where id = NEW.product;

  end if;
 
 if NEW.cccolor is null or NEW.cccolor = '' then
 update aeo_d_product 
    set description = v_style_description || ' No Color',
    name = v_style_name || ' NoColor'
    where id = NEW.product;

   update aeo_ma_stylecolorattributes 
   set cc_color_code = null
       ,color_name = null
       ,cccolorfamily = null
       ,cccolorid = null
       ,cc_color_group = null
   where product = new.product;
 
 end if;
   
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 548 (class 1255 OID 134295550)
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
 from aeo_p_itemprice 
 where product=NEW.product and location=NEW.location and time=NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
 from aeo_l_priceeventlookup 
 where product=NEW.department and location=NEW.location and ccpriceevent=NEW.event;

select cc_discount_pct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
 from aeo_ma_stylecolorchannelattributes 
 where product=NEW.product and location=NEW.location;
/*
select cc_current_price::real into v_ticketprice 
 from aeo_ma_stylecolorattributes 
 where product =NEW.product;


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
update aeo_p_itemprice a set eff_aur=final_eff_aur where product=NEW.product and location=NEW.location and time=NEW.time;

-- update aeo_an_price_storecount_info set expressed_aur=final_eff_aur where product=NEW.product and channel=NEW.location and time=NEW.time
--   ;
-- 
-- update aeo_an_price_storecount_info a
--   set v_A=b.v_A
-- FROM
--   (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A from aeo_an_price_storecount_info a
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time) b
-- WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
-- ;
-- 
--   update aeo_an_price_storecount_info a
--     set v_B=b.v_B
--   FROM
--     (select product, time, seq, addoff, corpaddoff
--       , case when seq=0 then
--           (case when final_eff_aur > 0 then final_eff_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
--        else curp end as v_B
--        from aeo_an_price_storecount_info a 
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--     ) b
--   WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--   ;
-- 
-- update aeo_an_price_storecount_info set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)
--   WHERE product=NEW.product and channel=NEW.location and time=NEW.time;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 549 (class 1255 OID 134295554)
-- Name: update_eligibility_from_null_to_zero(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_eligibility_from_null_to_zero() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- Clear the selected clusters for the product in blk_ma_stylecolorchannelattributes table
      UPDATE aeo_p_stylecolor_store_eligibility
      SET sclr_str_eligibility = 0
      WHERE sclr_str_eligibility is null and product = NEW.product and location = NEW.location;

      RETURN NEW;
  END;
  $$;


ALTER FUNCTION public.update_eligibility_from_null_to_zero() OWNER TO psql;

--
-- TOC entry 550 (class 1255 OID 134295555)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN


  if NEW.name <> OLD.name or NEW.description <> OLD.description then
    update aeo_d_product x
    set description = NEW.description || ':' || y.color_name,
        name = NEW.name || y.cc_color_code
    from (select a.id, b.cc_color_code, b.color_name from aeo_h_prodstd a, aeo_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
    where x.id = y.id;

     update aeo_ma_stylecolorattributes n
    set stylecolor_name = NEW.name || ':' || m.color_name,
        style_name = NEW.name
    from (select a.id, b.cc_color_code, b.color_name from aeo_h_prodstd a, aeo_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) m
    where n.product = m.id;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 551 (class 1255 OID 134295556)
-- Name: update_stylecolorchannelattributes_ccrangecode(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorchannelattributes_ccrangecode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Act only when the style’s size range actually changed (NULL-safe)
  IF TG_OP = 'UPDATE' AND NEW.sty_size_range IS DISTINCT FROM OLD.sty_size_range THEN
    /*
      For every stylecolor (ancestor0 = this style), do all in one set-based UPDATE:
        - ccrangecode := "<new size range> - <class>"  (ancestor1, per version B)
        - cc_validsizes_store/ecom := lookup-driven array for that size range
          (ordered, distinct; same array for store & ecom as in B)
    */
    UPDATE aeo_ma_stylecolorchannelattributes AS a
    SET
      ccrangecode          = NEW.sty_size_range || ' - ' || h.ancestor2, -- matching on stylecolor and class is ancestor2
      cc_validsizes_store  = COALESCE(l.validsizes, '{}'::text[]),
      cc_validsizes_ecom   = COALESCE(l.validsizes, '{}'::text[])
    FROM aeo_h_prodstd AS h
    -- size-range lookup once, applied to all rows (same size range for this style)
    LEFT JOIN (
      SELECT ARRAY_AGG(DISTINCT target_value ORDER BY target_value)::text[] AS validsizes
      FROM aeo_l_dependencylookup
      WHERE lookup_id = 'size_range'
        AND lookup_value = NEW.sty_size_range
    ) AS l ON TRUE
    WHERE a.product = h.id
      AND h.ancestor0 = NEW.product
      AND (
           a.ccrangecode IS DISTINCT FROM NEW.sty_size_range || ' - ' || h.ancestor1
        OR a.cc_validsizes_store IS DISTINCT FROM COALESCE(l.validsizes, '{}'::text[])
        OR a.cc_validsizes_ecom  IS DISTINCT FROM COALESCE(l.validsizes, '{}'::text[])
      );
    -- If you also have a separate trigger on aeo_ma_stylecolorchannelattributes that recomputes
    -- valid sizes on ccrangecode change, it will fire here. Keep it if you want that logic to win;
    -- disable it if you want these lookup-based arrays to be the source of truth.
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorchannelattributes_ccrangecode() OWNER TO psql;

--
-- TOC entry 552 (class 1255 OID 134295566)
-- Name: update_trigger_cartparams_irw_debut_offset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_trigger_cartparams_irw_debut_offset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.dbt_wk IS DISTINCT FROM OLD.dbt_wk THEN
    SELECT irw_offset.id
    INTO NEW.initrcptwk
    FROM aeo_d_time current
    INNER JOIN aeo_d_time irw_offset
      ON current.indx - NEW.irw_debut_offset = irw_offset.indx
    WHERE current.levelid = 'week'
      AND current.id = NEW.dbt_wk;
  END IF;

    -- Notify the user running the UPDATE
    RAISE NOTICE 'initrcptwk set to % for dbt_wk = % (updated by %)', 
                 NEW.initrcptwk, NEW.dbt_wk, session_user;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_trigger_cartparams_irw_debut_offset() OWNER TO psql;

--
-- TOC entry 553 (class 1255 OID 134295567)
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
    select b.product,b.location,a.indx,a.time from aeo_ma_dptflrsetattributes a, cart_params_temp b, 
    (select value as plan_current from aeo_serviceparams where id='plan_current') c,
    (select value as plan_end from aeo_serviceparams where id='plan_end') d
    where 
    a.product=b.product
    and b.product = NEW.scope_product
    and b.location = NEW.scope_location
    and ap_start <= least(plan_end,exitdate) and ap_end >= greatest(dbt_wk,plan_current)
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
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, c.indx from 
    temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||min(indx) from temp_old group by scope_product, scope_location)
    and c.indx < a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, c.indx from 
    temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||max(indx) from temp_old group by scope_product, scope_location)
    and c.indx > a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade,str_climate,str_region_combo,str_hvlc,str_tourist_border_combo,ssg,str_grade_or,str_climate_or,str_region_combo_or,str_hvlc_or,str_tourist_border_combo_or,flnrange,isfunded, c.indx from 
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
-- TOC entry 554 (class 1255 OID 134295568)
-- Name: update_week_indxes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_week_indxes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_irw_indx int;
v_dbtwk_indx int;
v_relaunchwk_indx int;
v_mdstart_indx int;
v_lastdcorder_indx int;
v_exitdate_indx int;
v_initrcptwk text;
v_lastdcorder text;
v_relaunchweek text;

v_lastdcorder_indx_auto_roll int;
v_lastdcorder_auto_roll text;

BEGIN
v_relaunchweek := Case When NEW.relaunchweek = '' THEN null Else NEW.relaunchweek END;
--v_irw_indx := (select indx from aeo_d_time where id =''||NEW.initrcptwk||'');
v_dbtwk_indx := (select indx from aeo_d_time where id = COALESCE(''||v_relaunchweek||'',''||NEW.dbt_wk||''));
v_relaunchwk_indx := (select indx from aeo_d_time where id = ''||v_relaunchweek||'');
v_mdstart_indx := (select indx  from aeo_d_time where id = ''||NEW.erlstmkdnwk||'');
--v_lastdcorder_indx := (select indx from aeo_d_time where id =''||NEW.lastdcorder||'');
v_exitdate_indx := (select indx  from aeo_d_time where id = ''||NEW.exitdate||'');

select min(v_dbtwk_indx - irw_debut_offset)
into v_irw_indx
from aeo_ma_dptflrsetattributes a, aeo_h_prodstd b
where b.id = NEW.product
and b.ancestor3 = a.product and NEW.dbt_wk between ap_start and ap_end
;

--v_irw_indx := v_dbtwk_indx - 1;
v_initrcptwk := (select id from aeo_d_time where indx= v_irw_indx);
v_lastdcorder_indx := v_mdstart_indx - 4;
v_lastdcorder := (select id from aeo_d_time where indx= v_lastdcorder_indx);


-- NEW FOR ROLL FORWARD
v_lastdcorder_indx_auto_roll := v_mdstart_indx - 1;
v_lastdcorder_auto_roll := (select id from aeo_d_time where indx= v_lastdcorder_indx_auto_roll);


if (NEW.dbt_wk != OLD.dbt_wk AND OLD.dbt_wk = OLD.act_dbt_wk and new.dbt_wk < new.erlstmkdnwk) then
    
    UPDATE aeo_ma_stylecolorchannelattributes
    SET act_dbt_wk = NEW.dbt_wk
    WHERE
    product = NEW.product
    and location = NEW.location;

end if;

if (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate AND new.exitdate > new.erlstmkdnwk)
then
  if new.auto_rollforward = FALSE
  then
      update aeo_ma_stylecolorchannelattributes
      set 
      irw_indx = v_irw_indx,
      dbtwk_indx = v_dbtwk_indx,
      relaunchwk_indx = v_relaunchwk_indx,
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
  else 
      update aeo_ma_stylecolorchannelattributes
      set 
      irw_indx = v_irw_indx,
      dbtwk_indx = v_dbtwk_indx,
      relaunchwk_indx = v_relaunchwk_indx,
      mdstart_indx = v_mdstart_indx, 
      lastdcorder_indx = v_lastdcorder_indx,
      exitdate_indx = v_exitdate_indx,
      too = v_mdstart_indx - v_dbtwk_indx,
      mkdnwks = v_exitdate_indx - v_mdstart_indx,
      initrcptwk = v_initrcptwk,

      -- modified
      last_rcpt_wk = v_lastdcorder_auto_roll,
      lastdcorder = v_lastdcorder_auto_roll,
      planned_sell_down_week = v_lastdcorder_auto_roll
      WHERE 
      product = NEW.product
      and location = NEW.location;

  end if;

end if;



RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 267 (class 1259 OID 108253404)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 266 (class 1259 OID 108253399)
-- Name: actuals_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL,
    net_sls_r_web_adj double precision,
    net_sls_r_store_adj double precision,
    net_sls_r_adj double precision,
    net_sls_u_web_adj double precision,
    net_sls_u_store_adj double precision,
    net_sls_u_adj double precision,
    net_sls_c_web_adj double precision,
    net_sls_c_store_adj double precision,
    net_sls_c_adj double precision,
    net_sls_r_curp_web_adj double precision,
    net_sls_r_curp_store_adj double precision,
    net_sls_r_curp_adj double precision,
    dmd_r_web_adj double precision,
    dmd_r_store_adj double precision,
    dmd_r_adj double precision,
    dmd_u_web_adj double precision,
    dmd_u_store_adj double precision,
    dmd_u_adj double precision,
    dmd_c_web_adj double precision,
    dmd_c_store_adj double precision,
    dmd_c_adj double precision,
    dmd_r_curp_web_adj double precision,
    dmd_r_curp_store_adj double precision,
    dmd_r_curp_adj double precision,
    return_r_web_adj double precision,
    return_r_store_adj double precision,
    return_r_total_adj double precision,
    return_u_web_adj double precision,
    return_u_store_adj double precision,
    return_u_total_adj double precision,
    return_c_web_adj double precision,
    return_c_store_adj double precision,
    return_c_total_adj double precision,
    pos_md_r_web_adj double precision,
    pos_md_r_store_adj double precision,
    pos_md_r_adj double precision,
    perm_md_r_web_adj double precision,
    perm_md_r_store_adj double precision,
    perm_md_r_adj double precision,
    perm_md_c_web_adj double precision,
    perm_md_c_store_adj double precision,
    perm_md_c_adj double precision,
    net_sls_margin_r_web_adj double precision,
    net_sls_margin_r_store_adj double precision,
    net_sls_margin_r_adj double precision,
    dmd_margin_r_web_adj double precision,
    dmd_margin_r_store_adj double precision,
    dmd_margin_r_adj double precision
);


ALTER TABLE mfp.actuals_wide OWNER TO psql;

--
-- TOC entry 268 (class 1259 OID 108253422)
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
-- TOC entry 269 (class 1259 OID 108253430)
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
-- TOC entry 358 (class 1259 OID 128873002)
-- Name: location_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.location_denorm AS
 SELECT global_region.id AS global_region,
    alt_country.id AS alt_country
   FROM (( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'alt_country'::text))) alt_country
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = alt_country.id) AND (hierarchies.hierarchy = 'locstd'::text))) global_region ON (true));


ALTER VIEW mfp.location_denorm OWNER TO psql;

--
-- TOC entry 357 (class 1259 OID 128872997)
-- Name: product_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.product_denorm AS
 SELECT brand_group.id AS brand_group,
    brand.id AS brand,
    division.id AS division,
    subdivision.id AS subdivision,
    department.id AS department,
    class.id AS class
   FROM (((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'class'::text))) class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) subdivision ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = subdivision.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = brand.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand_group ON (true));


ALTER VIEW mfp.product_denorm OWNER TO psql;

--
-- TOC entry 356 (class 1259 OID 128872992)
-- Name: time_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.time_denorm AS
 SELECT season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = week.id) AND (hierarchies.hierarchy = 'timestd'::text))) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = month.id) AND (hierarchies.hierarchy = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) season ON (true));


ALTER VIEW mfp.time_denorm OWNER TO psql;

--
-- TOC entry 359 (class 1259 OID 128873006)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".week AS time_week,
    "time".season AS time_season,
    product.class AS product_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c,
    wide.net_sls_r_web_adj,
    wide.net_sls_r_store_adj,
    wide.net_sls_r_adj,
    wide.net_sls_u_web_adj,
    wide.net_sls_u_store_adj,
    wide.net_sls_u_adj,
    wide.net_sls_c_web_adj,
    wide.net_sls_c_store_adj,
    wide.net_sls_c_adj,
    wide.net_sls_r_curp_web_adj,
    wide.net_sls_r_curp_store_adj,
    wide.net_sls_r_curp_adj,
    wide.dmd_r_web_adj,
    wide.dmd_r_store_adj,
    wide.dmd_r_adj,
    wide.dmd_u_web_adj,
    wide.dmd_u_store_adj,
    wide.dmd_u_adj,
    wide.dmd_c_web_adj,
    wide.dmd_c_store_adj,
    wide.dmd_c_adj,
    wide.dmd_r_curp_web_adj,
    wide.dmd_r_curp_store_adj,
    wide.dmd_r_curp_adj,
    wide.return_r_web_adj,
    wide.return_r_store_adj,
    wide.return_r_total_adj,
    wide.return_u_web_adj,
    wide.return_u_store_adj,
    wide.return_u_total_adj,
    wide.return_c_web_adj,
    wide.return_c_store_adj,
    wide.return_c_total_adj,
    wide.pos_md_r_web_adj,
    wide.pos_md_r_store_adj,
    wide.pos_md_r_adj,
    wide.perm_md_r_web_adj,
    wide.perm_md_r_store_adj,
    wide.perm_md_r_adj,
    wide.perm_md_c_web_adj,
    wide.perm_md_c_store_adj,
    wide.perm_md_c_adj,
    wide.net_sls_margin_r_web_adj,
    wide.net_sls_margin_r_store_adj,
    wide.net_sls_margin_r_adj,
    wide.dmd_margin_r_web_adj,
    wide.dmd_margin_r_store_adj,
    wide.dmd_margin_r_adj
   FROM (((mfp.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 278 (class 1259 OID 108253632)
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
-- TOC entry 272 (class 1259 OID 108253578)
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
-- TOC entry 353 (class 1259 OID 128872207)
-- Name: dimensions_bkp_0911; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_bkp_0911 (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE mfp.dimensions_bkp_0911 OWNER TO psql;

--
-- TOC entry 354 (class 1259 OID 128872212)
-- Name: hierarchies_bkp_0911; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_bkp_0911 (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE mfp.hierarchies_bkp_0911 OWNER TO psql;

--
-- TOC entry 265 (class 1259 OID 108253392)
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
-- TOC entry 280 (class 1259 OID 108253702)
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
-- TOC entry 281 (class 1259 OID 108253707)
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
    location text NOT NULL
);


ALTER TABLE mfp.plan_archives OWNER TO psql;

--
-- TOC entry 276 (class 1259 OID 108253606)
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
-- TOC entry 271 (class 1259 OID 108253559)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL,
    net_sls_r_web_adj double precision,
    net_sls_r_store_adj double precision,
    net_sls_r_adj double precision,
    net_sls_u_web_adj double precision,
    net_sls_u_store_adj double precision,
    net_sls_u_adj double precision,
    net_sls_c_web_adj double precision,
    net_sls_c_store_adj double precision,
    net_sls_c_adj double precision,
    net_sls_r_curp_web_adj double precision,
    net_sls_r_curp_store_adj double precision,
    net_sls_r_curp_adj double precision,
    dmd_r_web_adj double precision,
    dmd_r_store_adj double precision,
    dmd_r_adj double precision,
    dmd_u_web_adj double precision,
    dmd_u_store_adj double precision,
    dmd_u_adj double precision,
    dmd_c_web_adj double precision,
    dmd_c_store_adj double precision,
    dmd_c_adj double precision,
    dmd_r_curp_web_adj double precision,
    dmd_r_curp_store_adj double precision,
    dmd_r_curp_adj double precision,
    return_r_web_adj double precision,
    return_r_store_adj double precision,
    return_r_total_adj double precision,
    return_u_web_adj double precision,
    return_u_store_adj double precision,
    return_u_total_adj double precision,
    return_c_web_adj double precision,
    return_c_store_adj double precision,
    return_c_total_adj double precision,
    pos_md_r_web_adj double precision,
    pos_md_r_store_adj double precision,
    pos_md_r_adj double precision,
    perm_md_r_web_adj double precision,
    perm_md_r_store_adj double precision,
    perm_md_r_adj double precision,
    perm_md_c_web_adj double precision,
    perm_md_c_store_adj double precision,
    perm_md_c_adj double precision,
    net_sls_margin_r_web_adj double precision,
    net_sls_margin_r_store_adj double precision,
    net_sls_margin_r_adj double precision,
    dmd_margin_r_web_adj double precision,
    dmd_margin_r_store_adj double precision,
    dmd_margin_r_adj double precision
);


ALTER TABLE mfp.plan_data_wide OWNER TO psql;

--
-- TOC entry 282 (class 1259 OID 108253716)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL,
    net_sls_r_web_adj double precision,
    net_sls_r_store_adj double precision,
    net_sls_r_adj double precision,
    net_sls_u_web_adj double precision,
    net_sls_u_store_adj double precision,
    net_sls_u_adj double precision,
    net_sls_c_web_adj double precision,
    net_sls_c_store_adj double precision,
    net_sls_c_adj double precision,
    net_sls_r_curp_web_adj double precision,
    net_sls_r_curp_store_adj double precision,
    net_sls_r_curp_adj double precision,
    dmd_r_web_adj double precision,
    dmd_r_store_adj double precision,
    dmd_r_adj double precision,
    dmd_u_web_adj double precision,
    dmd_u_store_adj double precision,
    dmd_u_adj double precision,
    dmd_c_web_adj double precision,
    dmd_c_store_adj double precision,
    dmd_c_adj double precision,
    dmd_r_curp_web_adj double precision,
    dmd_r_curp_store_adj double precision,
    dmd_r_curp_adj double precision,
    return_r_web_adj double precision,
    return_r_store_adj double precision,
    return_r_total_adj double precision,
    return_u_web_adj double precision,
    return_u_store_adj double precision,
    return_u_total_adj double precision,
    return_c_web_adj double precision,
    return_c_store_adj double precision,
    return_c_total_adj double precision,
    pos_md_r_web_adj double precision,
    pos_md_r_store_adj double precision,
    pos_md_r_adj double precision,
    perm_md_r_web_adj double precision,
    perm_md_r_store_adj double precision,
    perm_md_r_adj double precision,
    perm_md_c_web_adj double precision,
    perm_md_c_store_adj double precision,
    perm_md_c_adj double precision,
    net_sls_margin_r_web_adj double precision,
    net_sls_margin_r_store_adj double precision,
    net_sls_margin_r_adj double precision,
    dmd_margin_r_web_adj double precision,
    dmd_margin_r_store_adj double precision,
    dmd_margin_r_adj double precision
);


ALTER TABLE mfp.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 274 (class 1259 OID 108253591)
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
-- TOC entry 279 (class 1259 OID 108253690)
-- Name: plan_init_status; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp.plan_init_status OWNER TO psql;

--
-- TOC entry 275 (class 1259 OID 108253592)
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
    module text NOT NULL
);


ALTER TABLE mfp.plans OWNER TO psql;

--
-- TOC entry 273 (class 1259 OID 108253583)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    storecount_store double precision,
    storecount_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_curp double precision,
    net_sls_r_curp_store double precision,
    net_sls_r_curp_web double precision,
    dmd_r double precision,
    dmd_r_store double precision,
    dmd_r_web double precision,
    dmd_u double precision,
    dmd_u_store double precision,
    dmd_u_web double precision,
    dmd_c double precision,
    dmd_c_store double precision,
    dmd_c_web double precision,
    dmd_r_curp double precision,
    dmd_r_curp_store double precision,
    dmd_r_curp_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    pst_boh_r double precision,
    pst_boh_u double precision,
    pst_boh_c double precision,
    pst_eoh_u double precision,
    pst_eoh_r double precision,
    pst_eoh_c double precision,
    rec_r double precision,
    rec_r_air double precision,
    rec_r_ocean double precision,
    rec_u double precision,
    rec_u_air double precision,
    rec_u_ocean double precision,
    rec_c double precision,
    rec_c_air double precision,
    rec_c_ocean double precision,
    on_order_u double precision,
    on_order_u_air double precision,
    on_order_u_ocean double precision,
    on_order_r double precision,
    on_order_r_air double precision,
    on_order_r_ocean double precision,
    on_order_c double precision,
    on_order_c_air double precision,
    on_order_c_ocean double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r double precision,
    inv_adjustment_c double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    net_sls_margin_r double precision,
    net_sls_margin_r_store double precision,
    net_sls_margin_r_web double precision,
    dmd_margin_r double precision,
    dmd_margin_r_store double precision,
    dmd_margin_r_web double precision,
    return_u_total double precision,
    return_u_store double precision,
    return_u_web double precision,
    return_r_total double precision,
    return_r_store double precision,
    return_r_web double precision,
    return_c_total double precision,
    return_c_store double precision,
    return_c_web double precision,
    pst_transfer_u double precision,
    pst_transfer_r double precision,
    pst_transfer_c double precision,
    net_sls_r_web_adj double precision,
    net_sls_r_store_adj double precision,
    net_sls_r_adj double precision,
    net_sls_u_web_adj double precision,
    net_sls_u_store_adj double precision,
    net_sls_u_adj double precision,
    net_sls_c_web_adj double precision,
    net_sls_c_store_adj double precision,
    net_sls_c_adj double precision,
    net_sls_r_curp_web_adj double precision,
    net_sls_r_curp_store_adj double precision,
    net_sls_r_curp_adj double precision,
    dmd_r_web_adj double precision,
    dmd_r_store_adj double precision,
    dmd_r_adj double precision,
    dmd_u_web_adj double precision,
    dmd_u_store_adj double precision,
    dmd_u_adj double precision,
    dmd_c_web_adj double precision,
    dmd_c_store_adj double precision,
    dmd_c_adj double precision,
    dmd_r_curp_web_adj double precision,
    dmd_r_curp_store_adj double precision,
    dmd_r_curp_adj double precision,
    return_r_web_adj double precision,
    return_r_store_adj double precision,
    return_r_total_adj double precision,
    return_u_web_adj double precision,
    return_u_store_adj double precision,
    return_u_total_adj double precision,
    return_c_web_adj double precision,
    return_c_store_adj double precision,
    return_c_total_adj double precision,
    pos_md_r_web_adj double precision,
    pos_md_r_store_adj double precision,
    pos_md_r_adj double precision,
    perm_md_r_web_adj double precision,
    perm_md_r_store_adj double precision,
    perm_md_r_adj double precision,
    perm_md_c_web_adj double precision,
    perm_md_c_store_adj double precision,
    perm_md_c_adj double precision,
    net_sls_margin_r_web_adj double precision,
    net_sls_margin_r_store_adj double precision,
    net_sls_margin_r_adj double precision,
    dmd_margin_r_web_adj double precision,
    dmd_margin_r_store_adj double precision,
    dmd_margin_r_adj double precision
);


ALTER TABLE mfp.sys_gen_wide OWNER TO psql;

--
-- TOC entry 360 (class 1259 OID 128873022)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".season AS time_season,
    product.class AS product_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c,
    wide.net_sls_r_web_adj,
    wide.net_sls_r_store_adj,
    wide.net_sls_r_adj,
    wide.net_sls_u_web_adj,
    wide.net_sls_u_store_adj,
    wide.net_sls_u_adj,
    wide.net_sls_c_web_adj,
    wide.net_sls_c_store_adj,
    wide.net_sls_c_adj,
    wide.net_sls_r_curp_web_adj,
    wide.net_sls_r_curp_store_adj,
    wide.net_sls_r_curp_adj,
    wide.dmd_r_web_adj,
    wide.dmd_r_store_adj,
    wide.dmd_r_adj,
    wide.dmd_u_web_adj,
    wide.dmd_u_store_adj,
    wide.dmd_u_adj,
    wide.dmd_c_web_adj,
    wide.dmd_c_store_adj,
    wide.dmd_c_adj,
    wide.dmd_r_curp_web_adj,
    wide.dmd_r_curp_store_adj,
    wide.dmd_r_curp_adj,
    wide.return_r_web_adj,
    wide.return_r_store_adj,
    wide.return_r_total_adj,
    wide.return_u_web_adj,
    wide.return_u_store_adj,
    wide.return_u_total_adj,
    wide.return_c_web_adj,
    wide.return_c_store_adj,
    wide.return_c_total_adj,
    wide.pos_md_r_web_adj,
    wide.pos_md_r_store_adj,
    wide.pos_md_r_adj,
    wide.perm_md_r_web_adj,
    wide.perm_md_r_store_adj,
    wide.perm_md_r_adj,
    wide.perm_md_c_web_adj,
    wide.perm_md_c_store_adj,
    wide.perm_md_c_adj,
    wide.net_sls_margin_r_web_adj,
    wide.net_sls_margin_r_store_adj,
    wide.net_sls_margin_r_adj,
    wide.dmd_margin_r_web_adj,
    wide.dmd_margin_r_store_adj,
    wide.dmd_margin_r_adj
   FROM (((mfp.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 277 (class 1259 OID 108253615)
-- Name: tyly; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp.tyly OWNER TO psql;

--
-- TOC entry 355 (class 1259 OID 128872217)
-- Name: tyly_bkp_0911; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly_bkp_0911 (
    ty text,
    ly text
);


ALTER TABLE mfp.tyly_bkp_0911 OWNER TO psql;

--
-- TOC entry 270 (class 1259 OID 108253552)
-- Name: user_kv_store; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp.user_kv_store OWNER TO psql;

--
-- TOC entry 285 (class 1259 OID 108253769)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_channel_plan.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 284 (class 1259 OID 108253764)
-- Name: actuals_wide; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_channel_plan.actuals_wide OWNER TO psql;

--
-- TOC entry 286 (class 1259 OID 108253786)
-- Name: dimensions; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE mfp_channel_plan.dimensions OWNER TO psql;

--
-- TOC entry 287 (class 1259 OID 108253794)
-- Name: hierarchies; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE mfp_channel_plan.hierarchies OWNER TO psql;

--
-- TOC entry 340 (class 1259 OID 108299105)
-- Name: location_denorm; Type: VIEW; Schema: mfp_channel_plan; Owner: psql
--

CREATE VIEW mfp_channel_plan.location_denorm AS
 SELECT global_region.id AS global_region,
    alt_country.id AS alt_country
   FROM (( SELECT dimensions.id
           FROM mfp_channel_plan.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'alt_country'::text))) alt_country
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = alt_country.id) AND (hierarchies.hierarchy = 'locstd'::text))) global_region ON (true));


ALTER VIEW mfp_channel_plan.location_denorm OWNER TO psql;

--
-- TOC entry 339 (class 1259 OID 108299100)
-- Name: product_denorm; Type: VIEW; Schema: mfp_channel_plan; Owner: psql
--

CREATE VIEW mfp_channel_plan.product_denorm AS
 SELECT brand_group.id AS brand_group,
    brand.id AS brand,
    division.id AS division,
    subdivision.id AS subdivision,
    department.id AS department,
    super_class.id AS super_class
   FROM (((((( SELECT dimensions.id
           FROM mfp_channel_plan.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'super_class'::text))) super_class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = super_class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) subdivision ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = subdivision.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = brand.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand_group ON (true));


ALTER VIEW mfp_channel_plan.product_denorm OWNER TO psql;

--
-- TOC entry 338 (class 1259 OID 108299095)
-- Name: time_denorm; Type: VIEW; Schema: mfp_channel_plan; Owner: psql
--

CREATE VIEW mfp_channel_plan.time_denorm AS
 SELECT season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((( SELECT dimensions.id
           FROM mfp_channel_plan.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = week.id) AND (hierarchies.hierarchy = 'timestd'::text))) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = month.id) AND (hierarchies.hierarchy = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_channel_plan.hierarchies
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) season ON (true));


ALTER VIEW mfp_channel_plan.time_denorm OWNER TO psql;

--
-- TOC entry 341 (class 1259 OID 108299109)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_channel_plan; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_channel_plan.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_channel_plan.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_channel_plan.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp_channel_plan.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_channel_plan.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_channel_plan.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 296 (class 1259 OID 108253993)
-- Name: comments; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_channel_plan.comments OWNER TO psql;

--
-- TOC entry 290 (class 1259 OID 108253942)
-- Name: currency_exchange_rates; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE mfp_channel_plan.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 283 (class 1259 OID 108253757)
-- Name: metadata; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp_channel_plan.metadata OWNER TO psql;

--
-- TOC entry 298 (class 1259 OID 108254066)
-- Name: paired_dimension_links; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE mfp_channel_plan.paired_dimension_links OWNER TO psql;

--
-- TOC entry 299 (class 1259 OID 108254071)
-- Name: plan_archives; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plan_archives (
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
    location text NOT NULL
);


ALTER TABLE mfp_channel_plan.plan_archives OWNER TO psql;

--
-- TOC entry 294 (class 1259 OID 108253967)
-- Name: plan_audit_log; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_channel_plan.plan_audit_log OWNER TO psql;

--
-- TOC entry 289 (class 1259 OID 108253923)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_channel_plan.plan_data_wide OWNER TO psql;

--
-- TOC entry 300 (class 1259 OID 108254080)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_channel_plan.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 292 (class 1259 OID 108253952)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: mfp_channel_plan; Owner: psql
--

CREATE SEQUENCE mfp_channel_plan.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp_channel_plan.plan_id_ticker OWNER TO psql;

--
-- TOC entry 297 (class 1259 OID 108254054)
-- Name: plan_init_status; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp_channel_plan.plan_init_status OWNER TO psql;

--
-- TOC entry 293 (class 1259 OID 108253953)
-- Name: plans; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.plans (
    id integer DEFAULT nextval('mfp_channel_plan.plan_id_ticker'::regclass) NOT NULL,
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
    module text NOT NULL
);


ALTER TABLE mfp_channel_plan.plans OWNER TO psql;

--
-- TOC entry 291 (class 1259 OID 108253947)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    storecount_store double precision,
    storecount_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_curp double precision,
    net_sls_r_curp_store double precision,
    net_sls_r_curp_web double precision,
    dmd_r double precision,
    dmd_r_store double precision,
    dmd_r_web double precision,
    dmd_u double precision,
    dmd_u_store double precision,
    dmd_u_web double precision,
    dmd_c double precision,
    dmd_c_store double precision,
    dmd_c_web double precision,
    dmd_r_curp double precision,
    dmd_r_curp_store double precision,
    dmd_r_curp_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    pst_boh_r double precision,
    pst_boh_u double precision,
    pst_boh_c double precision,
    pst_eoh_u double precision,
    pst_eoh_r double precision,
    pst_eoh_c double precision,
    rec_r double precision,
    rec_r_air double precision,
    rec_r_ocean double precision,
    rec_u double precision,
    rec_u_air double precision,
    rec_u_ocean double precision,
    rec_c double precision,
    rec_c_air double precision,
    rec_c_ocean double precision,
    on_order_u double precision,
    on_order_u_air double precision,
    on_order_u_ocean double precision,
    on_order_r double precision,
    on_order_r_air double precision,
    on_order_r_ocean double precision,
    on_order_c double precision,
    on_order_c_air double precision,
    on_order_c_ocean double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r double precision,
    inv_adjustment_c double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    net_sls_margin_r double precision,
    net_sls_margin_r_store double precision,
    net_sls_margin_r_web double precision,
    dmd_margin_r double precision,
    dmd_margin_r_store double precision,
    dmd_margin_r_web double precision,
    return_u_total double precision,
    return_u_store double precision,
    return_u_web double precision,
    return_r_total double precision,
    return_r_store double precision,
    return_r_web double precision,
    return_c_total double precision,
    return_c_store double precision,
    return_c_web double precision,
    pst_transfer_u double precision,
    pst_transfer_r double precision,
    pst_transfer_c double precision
);


ALTER TABLE mfp_channel_plan.sys_gen_wide OWNER TO psql;

--
-- TOC entry 342 (class 1259 OID 108299116)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_channel_plan; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_channel_plan.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_channel_plan.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_channel_plan.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp_channel_plan.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_channel_plan.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_channel_plan.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 295 (class 1259 OID 108253976)
-- Name: tyly; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp_channel_plan.tyly OWNER TO psql;

--
-- TOC entry 288 (class 1259 OID 108253916)
-- Name: user_kv_store; Type: TABLE; Schema: mfp_channel_plan; Owner: psql
--

CREATE TABLE mfp_channel_plan.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp_channel_plan.user_kv_store OWNER TO psql;

--
-- TOC entry 303 (class 1259 OID 108254136)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_long_range.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 302 (class 1259 OID 108254131)
-- Name: actuals_wide; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_long_range.actuals_wide OWNER TO psql;

--
-- TOC entry 304 (class 1259 OID 108254154)
-- Name: dimensions; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE mfp_long_range.dimensions OWNER TO psql;

--
-- TOC entry 305 (class 1259 OID 108254162)
-- Name: hierarchies; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE mfp_long_range.hierarchies OWNER TO psql;

--
-- TOC entry 345 (class 1259 OID 108299140)
-- Name: location_denorm; Type: VIEW; Schema: mfp_long_range; Owner: psql
--

CREATE VIEW mfp_long_range.location_denorm AS
 SELECT global_region.id AS global_region,
    alt_country.id AS alt_country
   FROM (( SELECT dimensions.id
           FROM mfp_long_range.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'alt_country'::text))) alt_country
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = alt_country.id) AND (hierarchies.hierarchy = 'locstd'::text))) global_region ON (true));


ALTER VIEW mfp_long_range.location_denorm OWNER TO psql;

--
-- TOC entry 344 (class 1259 OID 108299135)
-- Name: product_denorm; Type: VIEW; Schema: mfp_long_range; Owner: psql
--

CREATE VIEW mfp_long_range.product_denorm AS
 SELECT brand_group.id AS brand_group,
    brand.id AS brand,
    division.id AS division,
    subdivision.id AS subdivision,
    department.id AS department,
    super_class.id AS super_class
   FROM (((((( SELECT dimensions.id
           FROM mfp_long_range.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'super_class'::text))) super_class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = super_class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) subdivision ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = subdivision.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = brand.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand_group ON (true));


ALTER VIEW mfp_long_range.product_denorm OWNER TO psql;

--
-- TOC entry 343 (class 1259 OID 108299130)
-- Name: time_denorm; Type: VIEW; Schema: mfp_long_range; Owner: psql
--

CREATE VIEW mfp_long_range.time_denorm AS
 SELECT season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((( SELECT dimensions.id
           FROM mfp_long_range.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = week.id) AND (hierarchies.hierarchy = 'timestd'::text))) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = month.id) AND (hierarchies.hierarchy = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_long_range.hierarchies
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) season ON (true));


ALTER VIEW mfp_long_range.time_denorm OWNER TO psql;

--
-- TOC entry 346 (class 1259 OID 108299144)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_long_range; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_long_range.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_long_range.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_long_range.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp_long_range.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_long_range.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_long_range.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 314 (class 1259 OID 108254361)
-- Name: comments; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_long_range.comments OWNER TO psql;

--
-- TOC entry 308 (class 1259 OID 108254310)
-- Name: currency_exchange_rates; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE mfp_long_range.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 301 (class 1259 OID 108254124)
-- Name: metadata; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp_long_range.metadata OWNER TO psql;

--
-- TOC entry 316 (class 1259 OID 108254431)
-- Name: paired_dimension_links; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE mfp_long_range.paired_dimension_links OWNER TO psql;

--
-- TOC entry 317 (class 1259 OID 108254436)
-- Name: plan_archives; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plan_archives (
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
    location text NOT NULL
);


ALTER TABLE mfp_long_range.plan_archives OWNER TO psql;

--
-- TOC entry 312 (class 1259 OID 108254335)
-- Name: plan_audit_log; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_long_range.plan_audit_log OWNER TO psql;

--
-- TOC entry 307 (class 1259 OID 108254291)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_long_range.plan_data_wide OWNER TO psql;

--
-- TOC entry 318 (class 1259 OID 108254445)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_long_range.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 310 (class 1259 OID 108254320)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: mfp_long_range; Owner: psql
--

CREATE SEQUENCE mfp_long_range.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp_long_range.plan_id_ticker OWNER TO psql;

--
-- TOC entry 315 (class 1259 OID 108254419)
-- Name: plan_init_status; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp_long_range.plan_init_status OWNER TO psql;

--
-- TOC entry 311 (class 1259 OID 108254321)
-- Name: plans; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.plans (
    id integer DEFAULT nextval('mfp_long_range.plan_id_ticker'::regclass) NOT NULL,
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
    module text NOT NULL
);


ALTER TABLE mfp_long_range.plans OWNER TO psql;

--
-- TOC entry 309 (class 1259 OID 108254315)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    storecount_store double precision,
    storecount_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_curp double precision,
    net_sls_r_curp_store double precision,
    net_sls_r_curp_web double precision,
    dmd_r double precision,
    dmd_r_store double precision,
    dmd_r_web double precision,
    dmd_u double precision,
    dmd_u_store double precision,
    dmd_u_web double precision,
    dmd_c double precision,
    dmd_c_store double precision,
    dmd_c_web double precision,
    dmd_r_curp double precision,
    dmd_r_curp_store double precision,
    dmd_r_curp_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    pst_boh_r double precision,
    pst_boh_u double precision,
    pst_boh_c double precision,
    pst_eoh_u double precision,
    pst_eoh_r double precision,
    pst_eoh_c double precision,
    rec_r double precision,
    rec_r_air double precision,
    rec_r_ocean double precision,
    rec_u double precision,
    rec_u_air double precision,
    rec_u_ocean double precision,
    rec_c double precision,
    rec_c_air double precision,
    rec_c_ocean double precision,
    on_order_u double precision,
    on_order_u_air double precision,
    on_order_u_ocean double precision,
    on_order_r double precision,
    on_order_r_air double precision,
    on_order_r_ocean double precision,
    on_order_c double precision,
    on_order_c_air double precision,
    on_order_c_ocean double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r double precision,
    inv_adjustment_c double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    net_sls_margin_r double precision,
    net_sls_margin_r_store double precision,
    net_sls_margin_r_web double precision,
    dmd_margin_r double precision,
    dmd_margin_r_store double precision,
    dmd_margin_r_web double precision,
    return_u_total double precision,
    return_u_store double precision,
    return_u_web double precision,
    return_r_total double precision,
    return_r_store double precision,
    return_r_web double precision,
    return_c_total double precision,
    return_c_store double precision,
    return_c_web double precision,
    pst_transfer_u double precision,
    pst_transfer_r double precision,
    pst_transfer_c double precision
);


ALTER TABLE mfp_long_range.sys_gen_wide OWNER TO psql;

--
-- TOC entry 347 (class 1259 OID 108299151)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_long_range; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_long_range.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.brand_group AS product_brand_group,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_long_range.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_long_range.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.brand_group
           FROM mfp_long_range.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_long_range.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_long_range.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 313 (class 1259 OID 108254344)
-- Name: tyly; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp_long_range.tyly OWNER TO psql;

--
-- TOC entry 306 (class 1259 OID 108254284)
-- Name: user_kv_store; Type: TABLE; Schema: mfp_long_range; Owner: psql
--

CREATE TABLE mfp_long_range.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp_long_range.user_kv_store OWNER TO psql;

--
-- TOC entry 321 (class 1259 OID 108254498)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_total_aeo.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 320 (class 1259 OID 108254493)
-- Name: actuals_wide; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_total_aeo.actuals_wide OWNER TO psql;

--
-- TOC entry 322 (class 1259 OID 108254516)
-- Name: dimensions; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE mfp_total_aeo.dimensions OWNER TO psql;

--
-- TOC entry 323 (class 1259 OID 108254524)
-- Name: hierarchies; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE mfp_total_aeo.hierarchies OWNER TO psql;

--
-- TOC entry 350 (class 1259 OID 108299175)
-- Name: location_denorm; Type: VIEW; Schema: mfp_total_aeo; Owner: psql
--

CREATE VIEW mfp_total_aeo.location_denorm AS
 SELECT global_region.id AS global_region,
    alt_country.id AS alt_country
   FROM (( SELECT dimensions.id
           FROM mfp_total_aeo.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'alt_country'::text))) alt_country
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = alt_country.id) AND (hierarchies.hierarchy = 'locstd'::text))) global_region ON (true));


ALTER VIEW mfp_total_aeo.location_denorm OWNER TO psql;

--
-- TOC entry 349 (class 1259 OID 108299170)
-- Name: product_denorm; Type: VIEW; Schema: mfp_total_aeo; Owner: psql
--

CREATE VIEW mfp_total_aeo.product_denorm AS
 SELECT total_prod.id AS total_prod,
    brand_group.id AS brand_group,
    brand.id AS brand,
    division.id AS division,
    subdivision.id AS subdivision,
    department.id AS department,
    super_class.id AS super_class
   FROM ((((((( SELECT dimensions.id
           FROM mfp_total_aeo.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'super_class'::text))) super_class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = super_class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) subdivision ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = subdivision.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = brand.id) AND (hierarchies.hierarchy = 'prodstd'::text))) brand_group ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = brand_group.id) AND (hierarchies.hierarchy = 'prodstd'::text))) total_prod ON (true));


ALTER VIEW mfp_total_aeo.product_denorm OWNER TO psql;

--
-- TOC entry 348 (class 1259 OID 108299165)
-- Name: time_denorm; Type: VIEW; Schema: mfp_total_aeo; Owner: psql
--

CREATE VIEW mfp_total_aeo.time_denorm AS
 SELECT season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((( SELECT dimensions.id
           FROM mfp_total_aeo.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = week.id) AND (hierarchies.hierarchy = 'timestd'::text))) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = month.id) AND (hierarchies.hierarchy = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp_total_aeo.hierarchies
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) season ON (true));


ALTER VIEW mfp_total_aeo.time_denorm OWNER TO psql;

--
-- TOC entry 351 (class 1259 OID 108299179)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_total_aeo; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_total_aeo.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.total_prod AS product_total_prod,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_total_aeo.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_total_aeo.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.total_prod
           FROM mfp_total_aeo.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_total_aeo.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_total_aeo.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 332 (class 1259 OID 108254723)
-- Name: comments; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_total_aeo.comments OWNER TO psql;

--
-- TOC entry 326 (class 1259 OID 108254672)
-- Name: currency_exchange_rates; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE mfp_total_aeo.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 319 (class 1259 OID 108254486)
-- Name: metadata; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp_total_aeo.metadata OWNER TO psql;

--
-- TOC entry 334 (class 1259 OID 108254793)
-- Name: paired_dimension_links; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE mfp_total_aeo.paired_dimension_links OWNER TO psql;

--
-- TOC entry 335 (class 1259 OID 108254798)
-- Name: plan_archives; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plan_archives (
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
    location text NOT NULL
);


ALTER TABLE mfp_total_aeo.plan_archives OWNER TO psql;

--
-- TOC entry 330 (class 1259 OID 108254697)
-- Name: plan_audit_log; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_total_aeo.plan_audit_log OWNER TO psql;

--
-- TOC entry 325 (class 1259 OID 108254653)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_total_aeo.plan_data_wide OWNER TO psql;

--
-- TOC entry 336 (class 1259 OID 108254807)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    storecount_store double precision NOT NULL,
    storecount_web double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_u_store double precision NOT NULL,
    net_sls_u_web double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_r_store double precision NOT NULL,
    net_sls_r_web double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_c_store double precision NOT NULL,
    net_sls_c_web double precision NOT NULL,
    net_sls_r_curp double precision NOT NULL,
    net_sls_r_curp_store double precision NOT NULL,
    net_sls_r_curp_web double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_store double precision NOT NULL,
    dmd_r_web double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_u_store double precision NOT NULL,
    dmd_u_web double precision NOT NULL,
    dmd_c double precision NOT NULL,
    dmd_c_store double precision NOT NULL,
    dmd_c_web double precision NOT NULL,
    dmd_r_curp double precision NOT NULL,
    dmd_r_curp_store double precision NOT NULL,
    dmd_r_curp_web double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    pos_md_r_store double precision NOT NULL,
    pos_md_r_web double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    pst_boh_r double precision NOT NULL,
    pst_boh_u double precision NOT NULL,
    pst_boh_c double precision NOT NULL,
    pst_eoh_u double precision NOT NULL,
    pst_eoh_r double precision NOT NULL,
    pst_eoh_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_r_air double precision NOT NULL,
    rec_r_ocean double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_u_air double precision NOT NULL,
    rec_u_ocean double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_c_air double precision NOT NULL,
    rec_c_ocean double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_u_air double precision NOT NULL,
    on_order_u_ocean double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_r_air double precision NOT NULL,
    on_order_r_ocean double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_c_air double precision NOT NULL,
    on_order_c_ocean double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    perm_md_r double precision NOT NULL,
    perm_md_r_store double precision NOT NULL,
    perm_md_r_web double precision NOT NULL,
    perm_md_c double precision NOT NULL,
    perm_md_c_store double precision NOT NULL,
    perm_md_c_web double precision NOT NULL,
    net_sls_margin_r double precision NOT NULL,
    net_sls_margin_r_store double precision NOT NULL,
    net_sls_margin_r_web double precision NOT NULL,
    dmd_margin_r double precision NOT NULL,
    dmd_margin_r_store double precision NOT NULL,
    dmd_margin_r_web double precision NOT NULL,
    return_u_total double precision NOT NULL,
    return_u_store double precision NOT NULL,
    return_u_web double precision NOT NULL,
    return_r_total double precision NOT NULL,
    return_r_store double precision NOT NULL,
    return_r_web double precision NOT NULL,
    return_c_total double precision NOT NULL,
    return_c_store double precision NOT NULL,
    return_c_web double precision NOT NULL,
    pst_transfer_u double precision NOT NULL,
    pst_transfer_r double precision NOT NULL,
    pst_transfer_c double precision NOT NULL
);


ALTER TABLE mfp_total_aeo.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 328 (class 1259 OID 108254682)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: mfp_total_aeo; Owner: psql
--

CREATE SEQUENCE mfp_total_aeo.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp_total_aeo.plan_id_ticker OWNER TO psql;

--
-- TOC entry 333 (class 1259 OID 108254781)
-- Name: plan_init_status; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp_total_aeo.plan_init_status OWNER TO psql;

--
-- TOC entry 329 (class 1259 OID 108254683)
-- Name: plans; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.plans (
    id integer DEFAULT nextval('mfp_total_aeo.plan_id_ticker'::regclass) NOT NULL,
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
    module text NOT NULL
);


ALTER TABLE mfp_total_aeo.plans OWNER TO psql;

--
-- TOC entry 327 (class 1259 OID 108254677)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    storecount_store double precision,
    storecount_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_curp double precision,
    net_sls_r_curp_store double precision,
    net_sls_r_curp_web double precision,
    dmd_r double precision,
    dmd_r_store double precision,
    dmd_r_web double precision,
    dmd_u double precision,
    dmd_u_store double precision,
    dmd_u_web double precision,
    dmd_c double precision,
    dmd_c_store double precision,
    dmd_c_web double precision,
    dmd_r_curp double precision,
    dmd_r_curp_store double precision,
    dmd_r_curp_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    pst_boh_r double precision,
    pst_boh_u double precision,
    pst_boh_c double precision,
    pst_eoh_u double precision,
    pst_eoh_r double precision,
    pst_eoh_c double precision,
    rec_r double precision,
    rec_r_air double precision,
    rec_r_ocean double precision,
    rec_u double precision,
    rec_u_air double precision,
    rec_u_ocean double precision,
    rec_c double precision,
    rec_c_air double precision,
    rec_c_ocean double precision,
    on_order_u double precision,
    on_order_u_air double precision,
    on_order_u_ocean double precision,
    on_order_r double precision,
    on_order_r_air double precision,
    on_order_r_ocean double precision,
    on_order_c double precision,
    on_order_c_air double precision,
    on_order_c_ocean double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r double precision,
    inv_adjustment_c double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    net_sls_margin_r double precision,
    net_sls_margin_r_store double precision,
    net_sls_margin_r_web double precision,
    dmd_margin_r double precision,
    dmd_margin_r_store double precision,
    dmd_margin_r_web double precision,
    return_u_total double precision,
    return_u_store double precision,
    return_u_web double precision,
    return_r_total double precision,
    return_r_store double precision,
    return_r_web double precision,
    return_c_total double precision,
    return_c_store double precision,
    return_c_web double precision,
    pst_transfer_u double precision,
    pst_transfer_r double precision,
    pst_transfer_c double precision
);


ALTER TABLE mfp_total_aeo.sys_gen_wide OWNER TO psql;

--
-- TOC entry 352 (class 1259 OID 108299186)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp_total_aeo; Owner: psql
--

CREATE MATERIALIZED VIEW mfp_total_aeo.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".season AS time_season,
    product.super_class AS product_super_class,
    product.department AS product_department,
    product.division AS product_division,
    product.total_prod AS product_total_prod,
    location.alt_country AS location_alt_country,
    location.global_region AS location_global_region,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.storecount_store,
    wide.storecount_web,
    wide.net_sls_u,
    wide.net_sls_u_store,
    wide.net_sls_u_web,
    wide.net_sls_r,
    wide.net_sls_r_store,
    wide.net_sls_r_web,
    wide.net_sls_c,
    wide.net_sls_c_store,
    wide.net_sls_c_web,
    wide.net_sls_r_curp,
    wide.net_sls_r_curp_store,
    wide.net_sls_r_curp_web,
    wide.dmd_r,
    wide.dmd_r_store,
    wide.dmd_r_web,
    wide.dmd_u,
    wide.dmd_u_store,
    wide.dmd_u_web,
    wide.dmd_c,
    wide.dmd_c_store,
    wide.dmd_c_web,
    wide.dmd_r_curp,
    wide.dmd_r_curp_store,
    wide.dmd_r_curp_web,
    wide.pos_md_r,
    wide.pos_md_r_store,
    wide.pos_md_r_web,
    wide.boh_r,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.pst_boh_r,
    wide.pst_boh_u,
    wide.pst_boh_c,
    wide.pst_eoh_u,
    wide.pst_eoh_r,
    wide.pst_eoh_c,
    wide.rec_r,
    wide.rec_r_air,
    wide.rec_r_ocean,
    wide.rec_u,
    wide.rec_u_air,
    wide.rec_u_ocean,
    wide.rec_c,
    wide.rec_c_air,
    wide.rec_c_ocean,
    wide.on_order_u,
    wide.on_order_u_air,
    wide.on_order_u_ocean,
    wide.on_order_r,
    wide.on_order_r_air,
    wide.on_order_r_ocean,
    wide.on_order_c,
    wide.on_order_c_air,
    wide.on_order_c_ocean,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r,
    wide.inv_adjustment_c,
    wide.perm_md_r,
    wide.perm_md_r_store,
    wide.perm_md_r_web,
    wide.perm_md_c,
    wide.perm_md_c_store,
    wide.perm_md_c_web,
    wide.net_sls_margin_r,
    wide.net_sls_margin_r_store,
    wide.net_sls_margin_r_web,
    wide.dmd_margin_r,
    wide.dmd_margin_r_store,
    wide.dmd_margin_r_web,
    wide.return_u_total,
    wide.return_u_store,
    wide.return_u_web,
    wide.return_r_total,
    wide.return_r_store,
    wide.return_r_web,
    wide.return_c_total,
    wide.return_c_store,
    wide.return_c_web,
    wide.pst_transfer_u,
    wide.pst_transfer_r,
    wide.pst_transfer_c
   FROM (((mfp_total_aeo.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.season
           FROM mfp_total_aeo.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.super_class,
            product_denorm.department,
            product_denorm.division,
            product_denorm.total_prod
           FROM mfp_total_aeo.product_denorm) product ON ((product.super_class = wide.product)))
     JOIN ( SELECT location_denorm.alt_country,
            location_denorm.global_region
           FROM mfp_total_aeo.location_denorm) location ON ((location.alt_country = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp_total_aeo.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 331 (class 1259 OID 108254706)
-- Name: tyly; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp_total_aeo.tyly OWNER TO psql;

--
-- TOC entry 324 (class 1259 OID 108254646)
-- Name: user_kv_store; Type: TABLE; Schema: mfp_total_aeo; Owner: psql
--

CREATE TABLE mfp_total_aeo.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp_total_aeo.user_kv_store OWNER TO psql;

--
-- TOC entry 365 (class 1259 OID 134294542)
-- Name: aeo_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    style text,
    str_grade text[],
    str_climate text[],
    str_region_combo text[],
    str_hvlc text[],
    str_tourist_border_combo text[],
    ssg text[],
    flnrange text[],
    plan_type text DEFAULT 'plan'::text NOT NULL,
    isfunded integer DEFAULT 1,
    store_count integer DEFAULT 0,
    propagate_ranging integer DEFAULT 1,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    str_grade_or text[],
    str_climate_or text[],
    str_region_combo_or text[],
    str_hvlc_or text[],
    str_tourist_border_combo_or text[],
    is_sclr_flrset_locked text,
    str_grade_cad text[],
    str_climate_cad text[],
    str_region_combo_cad text[],
    str_hvlc_cad text[],
    str_tourist_border_combo_cad text[],
    ssg_cad text[],
    isfunded_cad integer DEFAULT 1,
    str_grade_ecom text[],
    isfunded_ecom integer DEFAULT 1,
    str_grade_ecom_cad text[],
    isfunded_ecom_cad integer DEFAULT 1,
    cc_flrset_open_1 text,
    cc_flrset_open_2 text,
    cc_flrset_open_3 text,
    cc_flrset_open_4 text,
    cc_flrset_open_5 text,
    cc_flrset_open_6 text,
    cc_flrset_open_7 text,
    cc_flrset_open_8 text,
    cc_flrset_open_9 text,
    cc_flrset_open_10 text
);


ALTER TABLE public.aeo_a_assortment OWNER TO psql;

--
-- TOC entry 406 (class 1259 OID 134294846)
-- Name: aeo_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_an_price_storecount_info (
    product text NOT NULL,
    channel text NOT NULL,
    "time" text NOT NULL,
    selling_channel text NOT NULL,
    isfunded integer,
    store_count integer,
    in_season_flag text,
    dbt_wk_date text,
    last_rcpt_wk_date text,
    erlstmkdnwk_date text,
    exitdate_date text,
    weekdate text,
    price_status text,
    seq bigint,
    ccticketprice double precision,
    curp real,
    selling_price real,
    expressed_aur real,
    corpexcl real,
    addoff real,
    corpaddoff real,
    v_a real,
    v_b real,
    ccdiscountpct real,
    flow_flag text
);


ALTER TABLE public.aeo_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 407 (class 1259 OID 134294851)
-- Name: aeo_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_authorization (
    tenantid text,
    roleid text NOT NULL,
    authid text NOT NULL,
    access text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_authorization OWNER TO psql;

--
-- TOC entry 214 (class 1259 OID 97070028)
-- Name: aeo_cluster_view_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_cluster_view_tbl (
    grade text,
    cluster text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_cluster_view_tbl OWNER TO psql;

--
-- TOC entry 371 (class 1259 OID 134294626)
-- Name: aeo_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_corpdisc (
    department text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    prodlife text NOT NULL,
    corpaddoff real DEFAULT 0.0,
    corpexcl real DEFAULT 0.0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    corpaddoff_ecom real,
    corpaddoff_ecom_cad real,
    corpaddoff_store_cad real,
    corpexcl_ecom real,
    corpexcl_stores_cad real,
    corpexcl_ecom_cad real
);


ALTER TABLE public.aeo_corpdisc OWNER TO psql;

--
-- TOC entry 215 (class 1259 OID 97070040)
-- Name: aeo_corpdisc_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_corpdisc_temp (
    department text,
    product text,
    "time" text,
    corpaddoff real,
    corpexcl_ecom real,
    corpexcl real
);


ALTER TABLE public.aeo_corpdisc_temp OWNER TO psql;

--
-- TOC entry 216 (class 1259 OID 97070045)
-- Name: aeo_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_d_cluster (
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


ALTER TABLE public.aeo_d_cluster OWNER TO psql;

--
-- TOC entry 217 (class 1259 OID 97070057)
-- Name: aeo_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_d_location (
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


ALTER TABLE public.aeo_d_location OWNER TO psql;

--
-- TOC entry 218 (class 1259 OID 97070069)
-- Name: aeo_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_d_prodlife (
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


ALTER TABLE public.aeo_d_prodlife OWNER TO psql;

--
-- TOC entry 219 (class 1259 OID 97070081)
-- Name: aeo_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_d_product (
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


ALTER TABLE public.aeo_d_product OWNER TO psql;

--
-- TOC entry 220 (class 1259 OID 97070093)
-- Name: aeo_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_d_time (
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


ALTER TABLE public.aeo_d_time OWNER TO psql;

--
-- TOC entry 409 (class 1259 OID 134294875)
-- Name: aeo_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_designimages (
    product text,
    img text
);


ALTER TABLE public.aeo_designimages OWNER TO psql;

--
-- TOC entry 410 (class 1259 OID 134294883)
-- Name: aeo_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_eohdata_stylecolor (
    product text NOT NULL,
    channel text,
    eohu real
);


ALTER TABLE public.aeo_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 221 (class 1259 OID 97070110)
-- Name: aeo_floorset_week_attributes_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_floorset_week_attributes_tbl (
    floorset text,
    month text,
    week text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_floorset_week_attributes_tbl OWNER TO psql;

--
-- TOC entry 228 (class 1259 OID 97070192)
-- Name: aeo_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_timeflrset (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_timeflrset OWNER TO psql;

--
-- TOC entry 411 (class 1259 OID 134294888)
-- Name: aeo_for_tgt_flrset_hier; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.aeo_for_tgt_flrset_hier AS
 SELECT a.id,
    a.indx,
    b.ancestor0 AS superset,
    b.ancestor1 AS fiscal_year,
    (now())::timestamp(0) without time zone AS updated_at
   FROM public.aeo_d_time a,
    public.aeo_h_timeflrset b
  WHERE ((a.levelid = 'floorset'::text) AND (a.id = b.id));


ALTER VIEW public.aeo_for_tgt_flrset_hier OWNER TO psql;

--
-- TOC entry 222 (class 1259 OID 97070122)
-- Name: aeo_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_clusterstd OWNER TO psql;

--
-- TOC entry 223 (class 1259 OID 97070134)
-- Name: aeo_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_locdc OWNER TO psql;

--
-- TOC entry 224 (class 1259 OID 97070146)
-- Name: aeo_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_locdcstd (
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


ALTER TABLE public.aeo_h_locdcstd OWNER TO psql;

--
-- TOC entry 225 (class 1259 OID 97070158)
-- Name: aeo_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_locstd OWNER TO psql;

--
-- TOC entry 226 (class 1259 OID 97070169)
-- Name: aeo_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_prodlifestd OWNER TO psql;

--
-- TOC entry 227 (class 1259 OID 97070181)
-- Name: aeo_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_prodstd (
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
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_h_prodstd OWNER TO psql;

--
-- TOC entry 229 (class 1259 OID 97070204)
-- Name: aeo_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_h_timestd (
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


ALTER TABLE public.aeo_h_timestd OWNER TO psql;

--
-- TOC entry 230 (class 1259 OID 97070216)
-- Name: aeo_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_dclookup (
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


ALTER TABLE public.aeo_l_dclookup OWNER TO psql;

--
-- TOC entry 412 (class 1259 OID 134294892)
-- Name: aeo_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_dependencylookup (
    lookup_id text,
    lookup_value text DEFAULT 'Undefined'::text,
    target_id text,
    target_value text DEFAULT 'Undefined'::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    index text
);


ALTER TABLE public.aeo_l_dependencylookup OWNER TO psql;

--
-- TOC entry 463 (class 1259 OID 134305899)
-- Name: aeo_l_dependencylookup_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.aeo_l_dependencylookup_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aeo_l_dependencylookup_seq OWNER TO psql;

--
-- TOC entry 413 (class 1259 OID 134294906)
-- Name: aeo_l_pricebandlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_pricebandlookup (
    product text,
    ticket_price_min real,
    ticket_price_max real,
    price_band text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_l_pricebandlookup OWNER TO psql;

--
-- TOC entry 414 (class 1259 OID 134294918)
-- Name: aeo_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_priceeventlookup (
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


ALTER TABLE public.aeo_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 368 (class 1259 OID 134294595)
-- Name: aeo_l_sizeeligibility; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_sizeeligibility (
    department text,
    size_model_code text,
    size_eligibility_default_display_name text,
    size_attribute text,
    sty_size_range text,
    sizeattribute text,
    store_ineligible integer,
    web_ineligible integer,
    is_default integer
);


ALTER TABLE public.aeo_l_sizeeligibility OWNER TO psql;

--
-- TOC entry 466 (class 1259 OID 134305920)
-- Name: aeo_l_sizeeligibility_with_ccrangecode; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_sizeeligibility_with_ccrangecode (
    department text,
    size_model_code text,
    size_eligibility_default_display_name text,
    size_attribute text,
    sty_size_range text,
    sizeattribute text,
    store_ineligible integer,
    web_ineligible integer,
    is_default integer,
    class text,
    ccrangecode text
);


ALTER TABLE public.aeo_l_sizeeligibility_with_ccrangecode OWNER TO psql;

--
-- TOC entry 370 (class 1259 OID 134294605)
-- Name: aeo_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_ssglookup (
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


ALTER TABLE public.aeo_l_ssglookup OWNER TO psql;

--
-- TOC entry 415 (class 1259 OID 134294932)
-- Name: aeo_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_storedclookup (
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


ALTER TABLE public.aeo_l_storedclookup OWNER TO psql;

--
-- TOC entry 416 (class 1259 OID 134294950)
-- Name: aeo_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_storelookup (
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


ALTER TABLE public.aeo_l_storelookup OWNER TO psql;

--
-- TOC entry 369 (class 1259 OID 134294600)
-- Name: aeo_l_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_l_ticketprice (
    product text,
    usd_ticket_price real,
    cad_ticket_price real,
    price_band text
);


ALTER TABLE public.aeo_l_ticketprice OWNER TO psql;

--
-- TOC entry 459 (class 1259 OID 134298559)
-- Name: aeo_location_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_location_attributes (
    id text,
    name text,
    description text,
    levelid text,
    latitude text,
    longitude text
);


ALTER TABLE public.aeo_location_attributes OWNER TO psql;

--
-- TOC entry 231 (class 1259 OID 97070234)
-- Name: aeo_ma_channelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_channelattributes (
    indx integer,
    location text,
    ch_latitude text,
    ch_longitude text
);


ALTER TABLE public.aeo_ma_channelattributes OWNER TO psql;

--
-- TOC entry 417 (class 1259 OID 134294967)
-- Name: aeo_ma_departmentalloc_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_departmentalloc_attributes (
    product text NOT NULL,
    alloc_rule_fair_share boolean DEFAULT false,
    alloc_rule_layered boolean DEFAULT true,
    alloc_rule_curr_oh boolean DEFAULT true,
    alloc_fcst_asst_plan boolean DEFAULT true,
    alloc_fcst_recalib boolean DEFAULT false,
    alloc_rule_adjust_dbt boolean DEFAULT true,
    alloc_rule_adjust_md boolean DEFAULT true,
    eventdate date DEFAULT (now())::date,
    version_id bigint DEFAULT 0,
    created_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    created_by text,
    updated_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    updated_by text,
    record_state smallint DEFAULT 0,
    alloc_ecom_rsv_alloc_min boolean DEFAULT false,
    alloc_ecom_rsv_alloc_exact boolean DEFAULT true,
    alloc_aps_index boolean DEFAULT true,
    alloc_sales_index boolean DEFAULT false,
    alloc_blended_index boolean DEFAULT false,
    min_shortfall_policy boolean DEFAULT true,
    overflow_ok boolean DEFAULT true,
    round_robin_excess_global boolean DEFAULT true,
    treat_alloc_min_as_minorder boolean DEFAULT true,
    ecomm_need_as_moq boolean DEFAULT true,
    have_max_num_stores_with_packs boolean DEFAULT true,
    assign_pack_to_zero_ideal boolean DEFAULT true,
    allow_scaling boolean DEFAULT true,
    default_allocation_basis text DEFAULT 'Assortment'::text,
    apply_projected_trend boolean DEFAULT true
);


ALTER TABLE public.aeo_ma_departmentalloc_attributes OWNER TO psql;

--
-- TOC entry 418 (class 1259 OID 134294999)
-- Name: aeo_ma_departmentquarter_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_departmentquarter_attributes (
    product text NOT NULL,
    "time" text NOT NULL,
    dq_clustering_level text DEFAULT 'Class'::text,
    dq_include_vendors boolean DEFAULT false,
    dq_enum_vendors_cutoff boolean DEFAULT true,
    dq_clustering_prefix text DEFAULT 'TIER'::text,
    dq_num_clusters text DEFAULT '6'::text,
    dq_clustering_type text DEFAULT 'ML Basis'::text,
    dq_ecom_separate boolean DEFAULT true,
    eventdate date DEFAULT (now())::date,
    version_id bigint DEFAULT 0,
    created_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    created_by text,
    updated_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    updated_by text,
    record_state smallint DEFAULT 0,
    dq_cluster_group boolean DEFAULT true,
    dq_metric_1 text DEFAULT 'FP Gross R$ Sales'::text,
    dq_metric_2 text DEFAULT 'FP Gross FGM $'::text
);


ALTER TABLE public.aeo_ma_departmentquarter_attributes OWNER TO psql;

--
-- TOC entry 232 (class 1259 OID 97070239)
-- Name: aeo_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_dptflrsetattributes (
    indx integer,
    product text,
    "time" text,
    floorset_name text,
    dept_name text,
    superset_id text,
    superset_name text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    weeks_at_fp text,
    markdown_week text,
    exit_week text,
    ly_rcptstart text,
    ly_rcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    floorset_uda text,
    ly_floorset_uda text,
    default_slsrnk_store real,
    default_slsrnk_ecom real,
    default_store_vol_grade text[],
    default_store_climate text[],
    default_store_capacity text[],
    default_store_banner text[],
    default_store_geo_region text[],
    default_store_hazmat text[],
    irw_debut_offset integer,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_retpct_str real,
    default_retpct_ecom real,
    default_crosschannel_retpct_ecom real,
    default_ccordermultiple_uom integer,
    default_ccmdstrategy text,
    default_lead_time integer,
    default_ccdiscountpct real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    prepack_pct_default real,
    override_fringe_indicator text,
    min_order_qty character varying(500),
    service_level_stores character varying(500),
    service_level_ecom character varying(500),
    default_discount_pres_stores character varying(500),
    default_discount_pres_ecom character varying(500),
    default_discount_pres_stores_ca character varying(500),
    default_discount_pres_ecom_ca character varying(500),
    default_ssg character varying(500)
);


ALTER TABLE public.aeo_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 241 (class 1259 OID 97070345)
-- Name: aeo_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_serviceparams (
    id text NOT NULL,
    type text,
    value text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_serviceparams OWNER TO psql;

--
-- TOC entry 419 (class 1259 OID 134295019)
-- Name: aeo_ma_dptflrsetattributes_view_verification; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.aeo_ma_dptflrsetattributes_view_verification AS
 SELECT a.product AS department,
    b.id AS "time",
    a."time" AS floorset
   FROM public.aeo_ma_dptflrsetattributes a,
    public.aeo_d_time b
  WHERE ((b.id >= a.rcptstart) AND (b.id <= a.rcptend) AND (a.rcptend >= ( SELECT aeo_serviceparams.value
           FROM public.aeo_serviceparams
          WHERE (aeo_serviceparams.id = 'plan_current'::text))));


ALTER VIEW public.aeo_ma_dptflrsetattributes_view_verification OWNER TO psql;

--
-- TOC entry 233 (class 1259 OID 97070251)
-- Name: aeo_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_imgattributes (
    indx integer,
    product text,
    img text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_ma_imgattributes OWNER TO psql;

--
-- TOC entry 420 (class 1259 OID 134295024)
-- Name: aeo_ma_imgattributes_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_imgattributes_archive (
    indx integer,
    product text,
    img text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sync_date timestamp(0) without time zone DEFAULT CURRENT_DATE
);


ALTER TABLE public.aeo_ma_imgattributes_archive OWNER TO psql;

--
-- TOC entry 234 (class 1259 OID 97070263)
-- Name: aeo_ma_marketplaceattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_marketplaceattributes (
    indx integer,
    location text,
    mkt_latitude text,
    mkt_longitude text
);


ALTER TABLE public.aeo_ma_marketplaceattributes OWNER TO psql;

--
-- TOC entry 235 (class 1259 OID 97070268)
-- Name: aeo_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_sizeattributes (
    product text,
    parent_id text,
    size_code text,
    sizeattribute text,
    isvalid integer,
    upc_id text,
    originated_from_blank text,
    originated_from_blank_sku text,
    dropship_sku text,
    sku_create_date text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    ccctylecolorsizecreatedate text
);


ALTER TABLE public.aeo_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 236 (class 1259 OID 97070280)
-- Name: aeo_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_storeattributes (
    location text,
    strname text,
    str_marketplace_cd text,
    str_dc_flag text,
    str_primary_dc text,
    str_secondary_dc text,
    str_selling_channel text,
    str_region_name text,
    str_district_name text,
    str_open_date text,
    str_close_date text,
    str_addressline1_desc text,
    str_city_nm text,
    str_state text,
    str_postal_code text,
    str_climate text,
    str_store_type text,
    str_ae_volume_grade text,
    str_aerie_volume_grade text,
    str_offline_volume_grade text,
    str_todd_volume_grade text,
    str_boss text,
    str_ae_format text,
    str_ae77 text,
    str_aerie_offline_format text,
    str_store_set_up text,
    str_aerie_shop text,
    str_aerie_store_design text,
    str_bts_peak text,
    str_d48_jewelry text,
    str_mens_active text,
    str_mens_underwear text,
    str_outlet_strategy text,
    str_uniform_stores text,
    str_m_btms_acc_assort_tier text,
    str_m_tops_assortment_tier text,
    str_m_underwear_assort_tier text,
    str_w_btms_acc_assort_tier text,
    str_w_tops_assortment_tier text,
    str_todd_format text,
    str_footwear text,
    str_comp_type text,
    str_latitude text,
    str_longitude text,
    str_mfp_alt_country text,
    str_esg_brand text,
    str_bbr_sell_channel text,
    str_square_footage text,
    str_capacity text,
    str_summer_swell text,
    channel_name text,
    channel_desc text,
    marketplace_name text,
    marketplace_desc text,
    global_region_name text,
    global_region_desc text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_ma_storeattributes OWNER TO psql;

--
-- TOC entry 421 (class 1259 OID 134295037)
-- Name: aeo_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_storeattributes_lat_long (
    indx integer,
    location text,
    strlatlong_latitude text,
    strlatlong_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 237 (class 1259 OID 97070297)
-- Name: aeo_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_styleattributes (
    product text,
    sty_style_only text,
    sty_style_description text,
    sty_erp_class text,
    sty_erp_class_name text,
    sty_tsn_backbone_style_id text,
    sty_size_range text,
    sty_real_good text,
    sty_fabric_type text,
    sty_fabric_name text,
    sty_silo_length text,
    sty_neckline text,
    sty_sleeve_length text,
    sty_rise text,
    sty_coverage text,
    sty_built_in_shelf text,
    sty_curvy text,
    sty_stretch text,
    sty_brushed text,
    sty_fabric_detail text,
    sty_size_modification text,
    sty_d_dd text,
    sty_wireless text,
    sty_lining text,
    sty_pads text,
    sty_inseam text,
    sty_pockets text,
    sty_adjustability text,
    sty_outerwear_fabric text,
    sty_multipack text,
    sty_active text,
    sty_shade text,
    sty_addtl_laces text,
    sty_hooded text,
    sty_cold_weather text,
    sty_occasion text,
    sty_waistband text,
    sty_silo text,
    sty_fit text,
    sty_program text,
    sty_franchise text,
    sty_promo_driver text,
    sty_ae77 text,
    sty_category text,
    sty_third_party text,
    sty_third_party_brand text,
    sty_bucket text,
    sty_liability text,
    sty_uniform text,
    sty_hem_detail text,
    sty_comp_new text,
    sty_subbrand text,
    sty_true_sleep text,
    sty_ip_vendor_nbr text,
    sty_tops_bottoms text,
    sty_originated_from_blank text,
    sty_originated_from_blank_style text,
    sty_spec_style_id text,
    sty_alpha_numeric text,
    sty_subprogram text,
    sty_style_create_date text,
    ccstylecreatedate text,
    sty_is_locked text,
    sty_s5_adopted text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    plm_size_range text,
    sty_short_description text
);


ALTER TABLE public.aeo_ma_styleattributes OWNER TO psql;

--
-- TOC entry 422 (class 1259 OID 134295049)
-- Name: aeo_ma_stylecolor_alloc_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_stylecolor_alloc_attributes (
    product text NOT NULL,
    sclr_alloc_rule_fair_share real,
    sclr_alloc_rule_layered real,
    sclr_alloc_rule_curr_oh real,
    sclr_alloc_fcst_asst_plan real,
    sclr_alloc_fcst_recalib real,
    sclr_alloc_rule_adjust_dbt real,
    sclr_alloc_rule_adjust_md real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 0,
    created_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    created_by text,
    updated_at timestamp without time zone DEFAULT (now())::timestamp(0) without time zone,
    updated_by text,
    record_state smallint DEFAULT 0,
    sclr_alloc_ecom_rsv_alloc_min real,
    sclr_alloc_ecom_rsv_alloc_exact real,
    sclr_alloc_aps_index real,
    sclr_alloc_sales_index real,
    sclr_alloc_blended_index real,
    sclr_min_shortfall_policy real,
    sclr_overflow_ok real,
    sclr_round_robin_excess_global real,
    sclr_treat_alloc_min_as_minorder real,
    sclr_ecomm_need_as_moq real,
    sclr_have_max_num_stores_with_packs real,
    sclr_assign_pack_to_zero_ideal real,
    sclr_allow_scaling real,
    sclr_default_allocation_basis text,
    excess_eligible_stores text[] DEFAULT '{AA,A,B,C,D,E}'::text[],
    weight_need text DEFAULT 'Medium'::text,
    worklist text,
    sclr_apply_projected_trend real
);


ALTER TABLE public.aeo_ma_stylecolor_alloc_attributes OWNER TO psql;

--
-- TOC entry 238 (class 1259 OID 97070309)
-- Name: aeo_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_stylecolorattributes (
    product text,
    cccolor text,
    cccolorfamily text,
    cccolorid text,
    cc_stylecolor_description text,
    cc_color_id text,
    cc_color_name text,
    cc_color_family text,
    cc_tsn_backbone_style_color_id text,
    cc_original_ticket_price text,
    cc_current_ticket_price text,
    cc_original_ticket_price_can text,
    cc_current_ticket_price_can text,
    cc_original_ticket_price_mex text,
    cc_current_ticket_price_mex text,
    cc_actual_first_receipt_week text,
    cc_actual_first_sale_week text,
    cc_actual_md_week text,
    cc_actual_last_receipt_week text,
    cc_assortment_architecture text,
    cc_pattern_type text,
    cc_color_type text,
    cc_wash text,
    cc_dropship text,
    cc_holiday_seasonal text,
    cc_collection text,
    cc_season_code text,
    cc_season_code_yoy text,
    cc_original_floorset text,
    cc_original_floorset_yoy text,
    original_floorset_no_year text,
    holiday_print text,
    cc_actual_floorset_delivery text,
    cc_actual_floorset_yoy text,
    cc_end_floorset text,
    cc_store_group text,
    cc_licensed text,
    cc_license_brand text,
    cc_novelty text,
    cc_graphic_type text,
    cc_lengths text,
    cc_pack_size text,
    cc_web_inseam text,
    cc_print text,
    cc_seasonal_trend text,
    cc_xxs_in_stores text,
    cc_cda_deviation text,
    cc_basic_call text,
    cc_matchback text,
    cc_originated_from_blank text,
    cc_originated_from_blank_sty_col text,
    cc_fob text,
    cc_elc text,
    cc_fashion text,
    cc_beauty_type text,
    cc_spec_style_color text,
    cc_gbb text,
    cc_key_item text,
    cc_price_range text,
    cc_intl_floorset_override text,
    cc_intl_must_have text,
    cc_intl_franchise text,
    cc_upside text,
    cc_graphic_placement text,
    ccstylecolorcreatedate text,
    total_product_name text,
    brand_group_name text,
    brand_name text,
    division_name text,
    subdivision_name text,
    department_name text,
    class_name text,
    style_name text,
    stylecolor_name text,
    isassortment text,
    merch_comments text,
    plan_comments text,
    allocator_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish integer,
    cc_prepublished_at timestamp without time zone,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_specstylecolor_status text,
    cc_end_floorset_yoy text,
    cc_actual_end_floorset text,
    cc_actual_end_floorset_yoy text
);


ALTER TABLE public.aeo_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 364 (class 1259 OID 134294492)
-- Name: aeo_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_stylecolorchannelattributes (
    product text NOT NULL,
    location text NOT NULL,
    dbt_wk text,
    relaunchweek text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    too smallint,
    mkdnwks smallint,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    act_initrcptwk text,
    act_dbt_wk text,
    irw_indx integer,
    dbtwk_indx integer,
    relaunchwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    preview_wks smallint,
    preview_qty smallint,
    plannedselldnwk text,
    ccmdstrategy text,
    slsrnk_store real DEFAULT 3,
    slsrnk_ecom real DEFAULT 3,
    validsizes text[] DEFAULT ARRAY[]::text[],
    cc_validsizes_store text[] DEFAULT ARRAY[]::text[],
    cc_validsizes_ecom text[] DEFAULT ARRAY[]::text[],
    ccrangecode text,
    cc_presmin integer,
    cc_presmin_weeks integer,
    cc_rcptint integer,
    cc_return_u_pct_store real,
    cc_return_u_pct_ecom real,
    cc_return_u_pct_cross real,
    cc_ordermultiple integer,
    cc_ordermin integer,
    cc_buy_aps_letter text,
    ccticketpricechannel real DEFAULT '0.01'::real,
    ccticketpricechannel_override real,
    cc_imupct real DEFAULT 0.0,
    cc_discount_pct real DEFAULT 0.0,
    cc_existingwac real DEFAULT 0.0,
    cc_systemcost real DEFAULT 0.0,
    cc_plan_cost real DEFAULT 0.0,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text DEFAULT 'No'::text,
    auto_rollforward boolean DEFAULT false,
    irr_mode text DEFAULT 'Normal'::text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real DEFAULT 0.7,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real DEFAULT 0.0,
    cc_discount_pct_ecom real DEFAULT 0.0,
    irw_debut_offset integer,
    cc_service_level_ecom real DEFAULT 0.95,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real DEFAULT 4,
    sclr_fringe_flag real DEFAULT 1,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    use_valid_sizes_from text DEFAULT 'Defaults – All Valid Sizes'::text,
    apply_size_mins_to text DEFAULT 'Core Sizes Only'::text,
    cc_addoff_store real,
    cc_addoff_ecom real,
    irw_floorset text,
    irw_superset text,
    irw_floorset_display text,
    irw_superset_display text,
    irw_floorset_id text,
    cc_size_eligibility_profile text,
    cloned_at timestamp(0) without time zone,
    initrcptwk_store_cad text,
    initrcptwk_ecom_us text,
    initrcptwk_ecom_cad text,
    irw_debut_offset_store_cad integer,
    irw_debut_offset_ecom_us integer,
    irw_debut_offset_ecom_cad integer,
    dbt_wk_store_cad text,
    dbt_wk_ecom_us text,
    dbt_wk_ecom_cad text,
    too_store_cad smallint,
    too_ecom_us smallint,
    too_ecom_cad smallint,
    erlstmkdnwk_store_cad text,
    erlstmkdnwk_ecom_us text,
    erlstmkdnwk_ecom_cad text,
    mkdnwks_store_cad smallint,
    mkdnwks_ecom_us smallint,
    mkdnwks_ecom_cad smallint,
    exitdate_store_cad text,
    exitdate_ecom_us text,
    exitdate_ecom_cad text,
    last_rcpt_wk_store_cad text,
    last_rcpt_wk_ecom_us text,
    last_rcpt_wk_ecom_cad text,
    slsrnk_store_cad real DEFAULT 3,
    slsrnk_ecom_cad real DEFAULT 3,
    cc_addoff_ecom_cad real,
    cc_addoff_store_cad real,
    cc_orig_unit_retail real,
    cc_orig_unit_retail_store_cad real,
    cc_orig_unit_retail_ecom_us real,
    cc_orig_unit_retail_ecom_cad real,
    cc_plan_cost_store_cad real,
    cc_plan_cost_ecom_us real,
    cc_plan_cost_ecom_cad real,
    cc_systemcost_store_cad real,
    cc_systemcost_ecom_us real,
    cc_systemcost_ecom_cad real,
    cc_discount_pct_store_cad real,
    cc_discount_pct_ecom_us real,
    cc_discount_pct_ecom_cad real,
    ccmdstrategy_store_cad text,
    ccmdstrategy_ecom_us text,
    ccmdstrategy_ecom_cad text,
    cc_validsizes_store_cad text[] DEFAULT ARRAY[]::text[],
    cc_validsizes_ecom_cad text[] DEFAULT ARRAY[]::text[],
    cc_service_level_store_cad real,
    cc_service_level_ecom_cad real,
    cc_presmin_store_cad integer,
    cc_presmin_ecom_us integer,
    cc_presmin_ecom_cad integer,
    cc_presmin_weeks_store_cad integer,
    cc_presmin_weeks_ecom_us integer,
    cc_presmin_weeks_ecom_cad integer,
    cc_rcptint_store_cad integer,
    cc_rcptint_ecom_us integer,
    cc_rcptint_ecom_cad integer,
    cc_ordermin_store_cad integer,
    cc_ordermin_ecom_us integer,
    cc_ordermin_ecom_cad integer,
    cc_lead_time_store_cad integer,
    cc_lead_time_ecom_us integer,
    cc_lead_time_ecom_cad integer,
    cc_return_u_pct_store_cad real,
    cc_return_u_pct_ecom_cad real,
    cc_ordermultiple_store_cad integer,
    cc_ordermultiple_ecom_us integer,
    cc_ordermultiple_ecom_cad integer,
    ccticketpricechannel_store_cad real DEFAULT '0.01'::real,
    ccticketpricechannel_ecom_us real DEFAULT '0.01'::real,
    ccticketpricechannel_ecom_cad real DEFAULT '0.01'::real,
    ccticketpricechannel_store_cad_override real,
    ccticketpricechannel_ecom_us_override real,
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real
);


ALTER TABLE public.aeo_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 239 (class 1259 OID 97070321)
-- Name: aeo_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_ma_weekattributes (
    "time" text,
    start_date text,
    end_date text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_ma_weekattributes OWNER TO psql;

--
-- TOC entry 408 (class 1259 OID 134294863)
-- Name: aeo_p_approvedclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_approvedclusters (
    product text NOT NULL,
    "time" text NOT NULL,
    cluster_id text NOT NULL,
    clustering_status real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_approvedclusters OWNER TO psql;

--
-- TOC entry 423 (class 1259 OID 134295061)
-- Name: aeo_p_casepack; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_casepack (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    case_pack_id text NOT NULL,
    po_pack_pct real,
    po_pack_config_min real,
    po_pack_config_max real,
    po_pack_qty_min real,
    po_pack_qty_max real,
    po_pack_sku_min real,
    po_pack_sku_max real,
    po_min_packs_per_store real,
    po_max_packs_per_store real,
    po_fringe_included text,
    po_threshold_var_plan_pct real,
    po_status real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_casepack OWNER TO psql;

--
-- TOC entry 367 (class 1259 OID 134294580)
-- Name: aeo_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_channeloverride (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    weekadjaps real,
    weekadjaps_ecom real,
    weekadjslsu real,
    weekadjslsu_ecom real,
    comments text DEFAULT ''::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    testpo text,
    floorsetpo text,
    weekadjslsu_store_cad real,
    weekadjslsu_ecom_cad real
);


ALTER TABLE public.aeo_p_channeloverride OWNER TO psql;

--
-- TOC entry 362 (class 1259 OID 134294465)
-- Name: aeo_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_dc_adj (
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
    dc_sc_useradj real,
    dc_sc_finrev real,
    po_indicator text,
    po_shipmode text,
    air_trigger text,
    cut text,
    published_at timestamp(0) without time zone,
    is_prepublished real,
    prepublished_at timestamp(0) without time zone,
    last_prepublished real,
    po_arr text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    dc_useradj_ecom real,
    dc_onorder_ecom real,
    dc_finrev_ecom real,
    dc_publish_ecom real,
    po_indicator_ecom text,
    po_shipmode_ecom text,
    air_trigger_ecom text,
    cut_ecom text,
    published_at_ecom timestamp(0) without time zone,
    is_prepublished_ecom real,
    prepublished_at_ecom timestamp(0) without time zone,
    last_prepublished_ecom real,
    reason_code text,
    reason_code_ecom text,
    pack_ind_flag text DEFAULT 'N'::text NOT NULL,
    pack_ind_flag_ecom text DEFAULT 'N'::text NOT NULL,
    show_in_pack text,
    show_in_pack_ecom text,
    prepack_pct real,
    prepack_pct_ecom real,
    default_fringe_indicator text DEFAULT 'N'::text NOT NULL,
    default_fringe_indicator_ecom text DEFAULT 'N'::text NOT NULL,
    email_to text,
    dc_useradj_store_cad real,
    dc_onorder_store_cad real,
    dc_finrev_store_cad real,
    dc_publish_store_cad real,
    po_indicator_store_cad text,
    po_shipmode_store_cad text,
    air_trigger_store_cad text,
    cut_store_cad text,
    published_at_store_cad timestamp(0) without time zone,
    is_prepublished_store_cad real,
    prepublished_at_store_cad timestamp(0) without time zone,
    last_prepublished_store_cad real,
    reason_code_store_cad text,
    pack_ind_flag_store_cad text DEFAULT 'N'::text NOT NULL,
    show_in_pack_store_cad text,
    prepack_pct_store_cad real,
    default_fringe_indicator_store_cad text DEFAULT 'N'::text NOT NULL,
    dc_useradj_ecom_cad real,
    dc_onorder_ecom_cad real,
    dc_finrev_ecom_cad real,
    dc_publish_ecom_cad real,
    po_indicator_ecom_cad text,
    po_shipmode_ecom_cad text,
    air_trigger_ecom_cad text,
    cut_ecom_cad text,
    published_at_ecom_cad timestamp(0) without time zone,
    is_prepublished_ecom_cad real,
    prepublished_at_ecom_cad timestamp(0) without time zone,
    last_prepublished_ecom_cad real,
    reason_code_ecom_cad text,
    pack_ind_flag_ecom_cad text DEFAULT 'N'::text NOT NULL,
    show_in_pack_ecom_cad text,
    prepack_pct_ecom_cad real,
    default_fringe_indicator_ecom_cad text DEFAULT 'N'::text NOT NULL
);


ALTER TABLE public.aeo_p_dc_adj OWNER TO psql;

--
-- TOC entry 363 (class 1259 OID 134294485)
-- Name: aeo_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_dc_adj_size (
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
    dc_onorder_v real,
    dc_onorder_c real,
    current_week text,
    dc_last_pub_u real,
    dc_last_pub timestamp without time zone,
    eventdate date DEFAULT (now())::date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text,
    record_state smallint,
    dc_useradj_ecom real,
    dc_onorder_ecom real,
    dc_onorder_v_ecom real,
    dc_onorder_c_ecom real,
    dc_finrev_ecom real,
    dc_publish_ecom real,
    dc_last_pub_u_ecom real,
    dc_last_pub_ecom timestamp without time zone,
    dc_useradj_store_cad real,
    dc_onorder_store_cad real,
    dc_onorder_v_store_cad real,
    dc_onorder_c_store_cad real,
    dc_finrev_store_cad real,
    dc_publish_store_cad real,
    dc_last_pub_u_store_cad real,
    dc_last_pub_store_cad timestamp without time zone,
    dc_useradj_ecom_cad real,
    dc_onorder_ecom_cad real,
    dc_onorder_v_ecom_cad real,
    dc_onorder_c_ecom_cad real,
    dc_finrev_ecom_cad real,
    dc_publish_ecom_cad real,
    dc_last_pub_u_ecom_cad real,
    dc_last_pub_ecom_cad timestamp without time zone
);


ALTER TABLE public.aeo_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 424 (class 1259 OID 134295076)
-- Name: aeo_p_dept_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_dept_store_attr_plan (
    product text NOT NULL,
    location text NOT NULL,
    dept_str_open_week text,
    dept_str_close_week text,
    dept_str_like_store text,
    dept_str_like_store_valid_from text,
    dept_str_like_store_valid_upto text,
    dept_str_like_store_perf_factor real,
    dept_str_is_valid real,
    dept_str_priority real,
    dept_str_like_store_ty_shp_r real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_dept_store_attr_plan OWNER TO psql;

--
-- TOC entry 366 (class 1259 OID 134294566)
-- Name: aeo_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_itemprice (
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
    record_state smallint DEFAULT 0,
    excl_discount_pct real,
    addoff_ecom real,
    addoff_store real,
    eo_store_cad real,
    eo_ecom_us real,
    eo_ecom_cad real,
    excl_discount_pct_store_cad real,
    excl_discount_pct_ecom_us real,
    excl_discount_pct_ecom_cad real,
    eff_aur_ecom real,
    eff_aur_store_cad real,
    eff_aur_ecom_cad real
);


ALTER TABLE public.aeo_p_itemprice OWNER TO psql;

--
-- TOC entry 425 (class 1259 OID 134295088)
-- Name: aeo_p_reassigncluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_reassigncluster (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    store_cluster_id text NOT NULL,
    reassigned_cluster text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_reassigncluster OWNER TO psql;

--
-- TOC entry 426 (class 1259 OID 134295100)
-- Name: aeo_p_receditclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_receditclusters (
    product text NOT NULL,
    "time" text NOT NULL,
    po_id_for_clusters text NOT NULL,
    cl_00 real,
    cl_01 real,
    cl_02 real,
    cl_03 real,
    cl_04 real,
    cl_05 real,
    cl_06 real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_receditclusters OWNER TO psql;

--
-- TOC entry 427 (class 1259 OID 134295112)
-- Name: aeo_p_receditstores; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_receditstores (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    po_id_for_stores text NOT NULL,
    store_rec_edit real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_receditstores OWNER TO psql;

--
-- TOC entry 428 (class 1259 OID 134295124)
-- Name: aeo_p_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_store_attr_plan (
    location text NOT NULL,
    str_open_week text,
    str_close_week text,
    str_like_store text,
    str_like_store_valid_from text,
    str_like_store_valid_upto text,
    str_like_store_perf_factor real,
    str_is_valid real,
    str_priority real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_store_attr_plan OWNER TO psql;

--
-- TOC entry 429 (class 1259 OID 134295139)
-- Name: aeo_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_strategy_params (
    product text NOT NULL,
    location text NOT NULL,
    floorset_uda text NOT NULL,
    ly_floorset text,
    lly_floorset text,
    quarter_start text,
    target_sales_start text,
    target_sales_end text,
    target_receipt_start text,
    target_receipt_end text,
    ly_sales_start text,
    ly_sales_end text,
    ly_receipt_start text,
    ly_receipt_end text,
    lly_sales_start text,
    lly_sales_end text,
    lly_receipt_start text,
    lly_receipt_end text,
    rec_magnitude integer DEFAULT 0,
    ref_avg_cc_count text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    apply_targets_to_plan integer
);


ALTER TABLE public.aeo_p_strategy_params OWNER TO psql;

--
-- TOC entry 430 (class 1259 OID 134295152)
-- Name: aeo_p_stylecolor_channel_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_channel_alloc_params (
    product text NOT NULL,
    location text NOT NULL,
    sclr_def_alloc_sizeattr text[],
    sclr_def_presmin real,
    sclr_def_presmin_weeks real,
    sclr_def_fringe_flag real DEFAULT 1,
    sclr_def_target_fwoc_override real,
    sclr_def_service_level real,
    sclr_def_alloc_min real,
    sclr_def_alloc_max real,
    sclr_def_size_eligibility integer[],
    sclr_def_size_min_by_size_override integer[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_stylecolor_channel_alloc_params OWNER TO psql;

--
-- TOC entry 431 (class 1259 OID 134295165)
-- Name: aeo_p_stylecolor_store_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_store_alloc_params (
    product text NOT NULL,
    location text NOT NULL,
    sclr_loc_eligibility integer,
    sclr_loc_tgt_fp_st_pct real,
    sclr_loc_alloc_sizeattr text[],
    sclr_loc_presmin real,
    sclr_loc_presmin_weeks real,
    sclr_loc_target_fwoc_override real,
    sclr_loc_service_level real,
    sclr_loc_alloc_min real,
    sclr_loc_alloc_max real,
    sclr_loc_size_eligibility integer[],
    sclr_loc_size_min_by_size_override integer[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sclr_loc_fringe_flag real DEFAULT 1,
    sclr_loc_alloc_sizeattr_for_size_min text[]
);


ALTER TABLE public.aeo_p_stylecolor_store_alloc_params OWNER TO psql;

--
-- TOC entry 432 (class 1259 OID 134295178)
-- Name: aeo_p_stylecolor_store_eligibility; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_store_eligibility (
    product text NOT NULL,
    location text NOT NULL,
    sclr_str_eligibility integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_stylecolor_store_eligibility OWNER TO psql;

--
-- TOC entry 433 (class 1259 OID 134295190)
-- Name: aeo_p_stylecolor_store_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_store_worklist (
    product text NOT NULL,
    "time" text NOT NULL,
    location text NOT NULL,
    worklist_id text NOT NULL,
    sclr_loc_wrk_alloc_sclr_qty real,
    sclr_loc_wrk_alloc_size_qty integer[],
    sclr_loc_wrk_alloc_sizeattr text[],
    sclr_loc_wrk_presmin real,
    sclr_loc_wrk_presmin_weeks real,
    sclr_loc_wrk_target_fwoc_override real,
    sclr_loc_wrk_service_level real,
    sclr_loc_wrk_alloc_min real,
    sclr_loc_wrk_alloc_max real,
    sclr_loc_wrk_size_eligibility integer[],
    sclr_loc_wrk_size_min_by_size_override integer[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying DEFAULT 'system'::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying DEFAULT 'system'::character varying,
    record_state smallint DEFAULT 0,
    sclr_loc_wrk_fringe_flag real DEFAULT 1,
    sclr_loc_wrk_size_user_override integer[],
    sclr_loc_alloc_sizeattr_for_size_override text[]
);


ALTER TABLE public.aeo_p_stylecolor_store_worklist OWNER TO psql;

--
-- TOC entry 434 (class 1259 OID 134295203)
-- Name: aeo_p_stylecolor_sysmanaged_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_sysmanaged_attr_plan (
    product text NOT NULL,
    location text NOT NULL,
    cc_floorset_override_plan text,
    cc_use_sys_floorset_override_plan integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.aeo_p_stylecolor_sysmanaged_attr_plan OWNER TO psql;

--
-- TOC entry 435 (class 1259 OID 134295208)
-- Name: aeo_p_stylecolor_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolor_worklist (
    product text NOT NULL,
    "time" text NOT NULL,
    location text NOT NULL,
    worklist_id text NOT NULL,
    sclr_wrk_auto_allocation text,
    sclr_wrk_alloc_rule text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    in_worklist real,
    sclr_wrk_prepack_holdback real,
    sclr_wrk_prepack_transfer real,
    sclr_wrk_approved real,
    sclr_wrk_released real,
    sclr_wrk_status real
);


ALTER TABLE public.aeo_p_stylecolor_worklist OWNER TO psql;

--
-- TOC entry 436 (class 1259 OID 134295220)
-- Name: aeo_p_stylecolorsize_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_stylecolorsize_worklist (
    product text NOT NULL,
    "time" text NOT NULL,
    location text NOT NULL,
    worklist_id text NOT NULL,
    sz_wrk_holdback real,
    sz_wrk_ecomm_reserve real,
    sz_wrk_stores_reserve real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sz_wrk_loose_holdback real,
    sz_wrk_loose_transfer real
);


ALTER TABLE public.aeo_p_stylecolorsize_worklist OWNER TO psql;

--
-- TOC entry 437 (class 1259 OID 134295232)
-- Name: aeo_p_target_include_exclude; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_p_target_include_exclude (
    product text NOT NULL,
    "time" text NOT NULL,
    ly_lly_key text NOT NULL,
    include_in_target_for_checkbox integer,
    include_in_target integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_p_target_include_exclude OWNER TO psql;

--
-- TOC entry 438 (class 1259 OID 134295244)
-- Name: aeo_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_pg_batch_validation (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value text,
    previous1_value text,
    previous2_value text,
    previous3_value text,
    previous4_value text,
    curr_prev_percentage_diff text,
    diff_percentage_threshold text,
    check_percentage_diff text,
    check_zero_value text,
    check_curr_prev_diff text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.aeo_pg_batch_validation OWNER TO psql;

--
-- TOC entry 439 (class 1259 OID 134295253)
-- Name: aeo_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_pg_batch_validation_archive (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value text,
    previous1_value text,
    previous2_value text,
    previous3_value text,
    previous4_value text,
    curr_prev_percentage_diff text,
    diff_percentage_threshold text,
    check_percentage_diff text,
    check_zero_value text,
    check_curr_prev_diff text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.aeo_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 440 (class 1259 OID 134295259)
-- Name: aeo_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_pg_batch_validation_failure (
    failure_message text,
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value text,
    previous1_value text,
    previous2_value text,
    previous3_value text,
    previous4_value text,
    curr_prev_percentage_diff text,
    diff_percentage_threshold text,
    check_percentage_diff text,
    check_zero_value text,
    check_curr_prev_diff text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.aeo_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 441 (class 1259 OID 134295265)
-- Name: aeo_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_pg_batch_validation_previous (
    id text,
    stage text,
    source_table text,
    validation_description text,
    validation_condition text,
    current_value text,
    previous1_value text,
    previous2_value text,
    previous3_value text,
    previous4_value text,
    curr_prev_percentage_diff text,
    diff_percentage_threshold text,
    check_percentage_diff text,
    check_zero_value text,
    check_curr_prev_diff text,
    int_sequence integer,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.aeo_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 442 (class 1259 OID 134295271)
-- Name: aeo_plan_these_cloned_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_plan_these_cloned_style_stylecolors (
    style text NOT NULL,
    stylecolor text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    picked_for_planning integer
);


ALTER TABLE public.aeo_plan_these_cloned_style_stylecolors OWNER TO psql;

--
-- TOC entry 240 (class 1259 OID 97070333)
-- Name: aeo_prodlife_view_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_prodlife_view_tbl (
    merchcat text,
    prodlife text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_prodlife_view_tbl OWNER TO psql;

--
-- TOC entry 443 (class 1259 OID 134295276)
-- Name: aeo_replannable_choices; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_replannable_choices (
    product text
);


ALTER TABLE public.aeo_replannable_choices OWNER TO psql;

--
-- TOC entry 444 (class 1259 OID 134295281)
-- Name: aeo_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_roledimension (
    tenantid text NOT NULL,
    roleid text NOT NULL,
    dimensionid text NOT NULL,
    levelids text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_roledimension OWNER TO psql;

--
-- TOC entry 445 (class 1259 OID 134295293)
-- Name: aeo_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_servicedefn (
    service text,
    authlevels text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_servicedefn OWNER TO psql;

--
-- TOC entry 446 (class 1259 OID 134295305)
-- Name: aeo_size_range_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_size_range_mapping (
    size_model_code text,
    size_model_name text,
    size_code text,
    size_attribute text,
    size_desc text,
    sty_size_range text,
    sizeattribute text,
    brand_id text
);


ALTER TABLE public.aeo_size_range_mapping OWNER TO psql;

--
-- TOC entry 447 (class 1259 OID 134295310)
-- Name: aeo_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.aeo_sizinglookup OWNER TO psql;

--
-- TOC entry 448 (class 1259 OID 134295315)
-- Name: aeo_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.aeo_specimages OWNER TO psql;

--
-- TOC entry 449 (class 1259 OID 134295323)
-- Name: aeo_specimages_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_specimages_intraday (
    product text NOT NULL,
    img text
);


ALTER TABLE public.aeo_specimages_intraday OWNER TO psql;

--
-- TOC entry 361 (class 1259 OID 134294452)
-- Name: aeo_stocking_locations_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_stocking_locations_tbl (
    stocking_location text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_stocking_locations_tbl OWNER TO psql;

--
-- TOC entry 242 (class 1259 OID 97070369)
-- Name: aeo_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.aeo_store_hier_attr AS
 SELECT s.location,
    s.strname,
    s.str_marketplace_cd,
    s.str_dc_flag,
    s.str_primary_dc,
    s.str_secondary_dc,
    s.str_selling_channel,
    s.str_region_name,
    s.str_district_name,
    s.str_open_date,
    s.str_close_date,
    s.str_addressline1_desc,
    s.str_city_nm,
    s.str_state,
    s.str_postal_code,
    s.str_climate,
    s.str_store_type,
    s.str_ae_volume_grade,
    s.str_aerie_volume_grade,
    s.str_offline_volume_grade,
    s.str_todd_volume_grade,
    s.str_boss,
    s.str_ae_format,
    s.str_ae77,
    s.str_aerie_offline_format,
    s.str_store_set_up,
    s.str_aerie_shop,
    s.str_aerie_store_design,
    s.str_bts_peak,
    s.str_d48_jewelry,
    s.str_mens_active,
    s.str_mens_underwear,
    s.str_outlet_strategy,
    s.str_uniform_stores,
    s.str_m_btms_acc_assort_tier,
    s.str_m_tops_assortment_tier,
    s.str_m_underwear_assort_tier,
    s.str_w_btms_acc_assort_tier,
    s.str_w_tops_assortment_tier,
    s.str_todd_format,
    s.str_footwear,
    s.str_comp_type,
    s.str_latitude,
    s.str_longitude,
    s.str_mfp_alt_country,
    s.str_esg_brand,
    s.str_bbr_sell_channel,
    s.str_square_footage,
    s.str_capacity,
    s.str_summer_swell,
    s.channel_name,
    s.channel_desc,
    s.marketplace_name,
    s.marketplace_desc,
    s.global_region_name,
    s.global_region_desc,
    h.id AS store,
    h.ancestor0 AS channel,
    h.ancestor1 AS marketplace,
    h.ancestor2 AS global_region,
    h.ancestor3 AS total_location,
    s.eventdate,
    s.version_id,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by,
    s.record_state
   FROM (public.aeo_ma_storeattributes s
     LEFT JOIN public.aeo_h_locstd h ON ((h.id = s.location)));


ALTER VIEW public.aeo_store_hier_attr OWNER TO psql;

--
-- TOC entry 450 (class 1259 OID 134295331)
-- Name: aeo_style_clone_stylecolor_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_style_clone_stylecolor_size (
    from_style text,
    to_new_style text NOT NULL,
    from_stylecolor text NOT NULL,
    to_new_stylecolor text NOT NULL,
    from_stylecolorsize text NOT NULL,
    to_new_stylecolorsize text NOT NULL,
    updated_by text NOT NULL,
    session_id text NOT NULL,
    picked_for_planning integer,
    clone_ordinal integer,
    to_new_style_name text,
    to_new_style_desc text,
    to_new_stylecolor_name text,
    to_new_stylecolor_desc text
);


ALTER TABLE public.aeo_style_clone_stylecolor_size OWNER TO psql;

--
-- TOC entry 451 (class 1259 OID 134295336)
-- Name: aeo_style_merge_archives_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_style_merge_archives_tbl (
    source_style_id text NOT NULL,
    target_style_id text NOT NULL,
    source_stylecolor_id text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.aeo_style_merge_archives_tbl OWNER TO psql;

--
-- TOC entry 452 (class 1259 OID 134295345)
-- Name: aeo_style_merge_reparent; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_style_merge_reparent (
    source_stylecolor_id text NOT NULL,
    source_style_id text NOT NULL,
    target_style_id text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    cccolor text,
    action text
);


ALTER TABLE public.aeo_style_merge_reparent OWNER TO psql;

--
-- TOC entry 264 (class 1259 OID 98616447)
-- Name: aeo_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.aeo_stylecolor_hier_attr AS
 SELECT a.product,
    a.cccolor,
    a.cccolorfamily,
    a.cccolorid,
    a.cc_stylecolor_description,
    a.cc_color_id,
    a.cc_color_name,
    a.cc_color_family,
    a.cc_tsn_backbone_style_color_id,
    a.cc_original_ticket_price,
    a.cc_current_ticket_price,
    a.cc_original_ticket_price_can,
    a.cc_current_ticket_price_can,
    a.cc_original_ticket_price_mex,
    a.cc_current_ticket_price_mex,
    a.cc_actual_first_receipt_week,
    a.cc_actual_first_sale_week,
    a.cc_actual_md_week,
    a.cc_actual_last_receipt_week,
    a.cc_assortment_architecture,
    a.cc_pattern_type,
    a.cc_color_type,
    a.cc_wash,
    a.cc_dropship,
    a.cc_holiday_seasonal,
    a.cc_collection,
    a.cc_season_code,
    a.cc_season_code_yoy,
    a.cc_original_floorset,
    a.cc_original_floorset_yoy,
    a.original_floorset_no_year,
    a.holiday_print,
    a.cc_actual_floorset_delivery,
    a.cc_actual_floorset_yoy,
    a.cc_end_floorset,
    a.cc_store_group,
    a.cc_licensed,
    a.cc_license_brand,
    a.cc_novelty,
    a.cc_graphic_type,
    a.cc_lengths,
    a.cc_pack_size,
    a.cc_web_inseam,
    a.cc_print,
    a.cc_seasonal_trend,
    a.cc_xxs_in_stores,
    a.cc_cda_deviation,
    a.cc_basic_call,
    a.cc_matchback,
    a.cc_originated_from_blank,
    a.cc_originated_from_blank_sty_col,
    a.cc_fob,
    a.cc_elc,
    a.cc_fashion,
    a.cc_beauty_type,
    a.cc_spec_style_color,
    a.cc_gbb,
    a.cc_key_item,
    a.cc_price_range,
    a.cc_intl_floorset_override,
    a.cc_intl_must_have,
    a.cc_intl_franchise,
    a.cc_upside,
    a.cc_graphic_placement,
    a.ccstylecolorcreatedate,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    a.cc_prepublished_at,
    a.cc_specstylecolor_status,
    b.sty_style_only,
    b.sty_style_description,
    b.sty_erp_class,
    b.sty_erp_class_name,
    b.sty_tsn_backbone_style_id,
    b.sty_size_range,
    b.sty_real_good,
    b.sty_fabric_type,
    b.sty_fabric_name,
    b.sty_silo_length,
    b.sty_neckline,
    b.sty_sleeve_length,
    b.sty_rise,
    b.sty_coverage,
    b.sty_built_in_shelf,
    b.sty_curvy,
    b.sty_stretch,
    b.sty_brushed,
    b.sty_fabric_detail,
    b.sty_size_modification,
    b.sty_d_dd,
    b.sty_wireless,
    b.sty_lining,
    b.sty_pads,
    b.sty_inseam,
    b.sty_pockets,
    b.sty_adjustability,
    b.sty_outerwear_fabric,
    b.sty_multipack,
    b.sty_active,
    b.sty_shade,
    b.sty_addtl_laces,
    b.sty_hooded,
    b.sty_cold_weather,
    b.sty_occasion,
    b.sty_waistband,
    b.sty_silo,
    b.sty_fit,
    b.sty_program,
    b.sty_franchise,
    b.sty_promo_driver,
    b.sty_ae77,
    b.sty_category,
    b.sty_third_party,
    b.sty_third_party_brand,
    b.sty_bucket,
    b.sty_liability,
    b.sty_uniform,
    b.sty_hem_detail,
    b.sty_comp_new,
    b.sty_subbrand,
    b.sty_true_sleep,
    b.sty_ip_vendor_nbr,
    b.sty_tops_bottoms,
    b.sty_originated_from_blank,
    b.sty_originated_from_blank_style,
    b.sty_spec_style_id,
    b.sty_alpha_numeric,
    b.sty_subprogram,
    b.sty_style_create_date,
    b.ccstylecreatedate,
    b.sty_is_locked,
    b.sty_s5_adopted,
    b.sty_num_clones_s5,
    b.sty_num_times_cloned_s5,
    b.plm_size_range,
    b.sty_short_description,
    a.product AS stylecolor,
    h.ancestor0 AS style,
    h.ancestor1 AS class,
    h.ancestor2 AS department,
    h.ancestor3 AS subdivision,
    h.ancestor4 AS division,
    h.ancestor5 AS brand,
    h.ancestor6 AS brand_group,
    h.ancestor7 AS total_product,
    c.name AS stylecolor_name,
    c.description AS stylecolor_desc,
    d.name AS style_name,
    d.description AS style_desc,
    e.name AS class_name,
    e.description AS class_desc,
    f.name AS department_name,
    f.description AS department_desc,
    g.name AS subdivision_name,
    g.description AS subdivision_desc,
    i.name AS division_name,
    i.description AS division_desc,
    j.name AS brand_name,
    j.description AS brand_desc,
    k.name AS brand_group_name,
    k.description AS brand_group_desc,
    l.name AS total_product_name,
    l.description AS total_product_desc,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.allocator_comments,
    a.cc_end_floorset_yoy,
    a.cc_actual_end_floorset,
    a.cc_actual_end_floorset_yoy,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state
   FROM (((((((((((public.aeo_ma_stylecolorattributes a
     JOIN public.aeo_h_prodstd h ON ((h.id = a.product)))
     JOIN public.aeo_ma_styleattributes b ON ((b.product = h.ancestor0)))
     JOIN public.aeo_d_product c ON (((a.product = c.id) AND (c.levelid = 'stylecolor'::text))))
     JOIN public.aeo_d_product d ON (((h.ancestor0 = d.id) AND (d.levelid = 'style'::text))))
     JOIN public.aeo_d_product e ON (((h.ancestor1 = e.id) AND (e.levelid = 'class'::text))))
     JOIN public.aeo_d_product f ON (((h.ancestor2 = f.id) AND (f.levelid = 'department'::text))))
     JOIN public.aeo_d_product g ON (((h.ancestor3 = g.id) AND (g.levelid = 'subdivision'::text))))
     JOIN public.aeo_d_product i ON (((h.ancestor4 = i.id) AND (i.levelid = 'division'::text))))
     JOIN public.aeo_d_product j ON (((h.ancestor5 = j.id) AND (j.levelid = 'brand'::text))))
     JOIN public.aeo_d_product k ON (((h.ancestor6 = k.id) AND (k.levelid = 'brand_group'::text))))
     JOIN public.aeo_d_product l ON (((h.ancestor7 = l.id) AND (l.levelid = 'total_product'::text))));


ALTER VIEW public.aeo_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 453 (class 1259 OID 134295351)
-- Name: aeo_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_swatches (
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


ALTER TABLE public.aeo_swatches OWNER TO psql;

--
-- TOC entry 243 (class 1259 OID 97070391)
-- Name: aeo_time_attributes_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_time_attributes_tbl (
    week text,
    month text,
    quarter text,
    season text,
    year text,
    cctytime text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.aeo_time_attributes_tbl OWNER TO psql;

--
-- TOC entry 454 (class 1259 OID 134295363)
-- Name: aeo_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.aeo_v_memberbasedvalidvalues (
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


ALTER TABLE public.aeo_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 244 (class 1259 OID 97070403)
-- Name: agent_conversations; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.agent_conversations (
    conversation_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.agent_conversations OWNER TO psql;

--
-- TOC entry 245 (class 1259 OID 97070411)
-- Name: agent_conversations_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.agent_conversations_log (
    conversation_id uuid NOT NULL,
    message_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    message_sender public.agent_sender NOT NULL,
    message_content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.agent_conversations_log OWNER TO psql;

--
-- TOC entry 246 (class 1259 OID 97070418)
-- Name: allocation_plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.allocation_plan_queue (
    jobid uuid NOT NULL,
    initiator text NOT NULL,
    model_defn_path text NOT NULL,
    scope json NOT NULL,
    state public.queue_state,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    error text,
    instance_id text
);


ALTER TABLE public.allocation_plan_queue OWNER TO psql;

--
-- TOC entry 247 (class 1259 OID 97070425)
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
-- TOC entry 373 (class 1259 OID 134294650)
-- Name: ata_cart_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_master (
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
    isprocessed integer,
    initiator text,
    img text,
    job_priority integer,
    new_stylecolor_id text,
    scope_floorset text,
    department text
);


ALTER TABLE public.ata_cart_master OWNER TO psql;

--
-- TOC entry 374 (class 1259 OID 134294655)
-- Name: ata_cart_master_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_master_archive (
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
    isprocessed integer,
    initiator text,
    img text,
    job_priority integer,
    new_stylecolor_id text,
    scope_floorset text,
    department text,
    updated_at date
);


ALTER TABLE public.ata_cart_master_archive OWNER TO psql;

--
-- TOC entry 375 (class 1259 OID 134294660)
-- Name: ata_cart_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_params (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    initrcptwk text,
    dbt_wk text,
    planned_sell_down_week text,
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
    retpct_str real,
    retpct_ecomm real,
    retpct_cross real,
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk_store real,
    slsrnk_ecom real,
    auto_rollforward boolean,
    sty_size_type text,
    sty_size_range text,
    class text,
    subclass text,
    cc_cluster_group text,
    irw_debut_offset integer,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    use_valid_sizes_from text DEFAULT 'Defaults – All Valid Sizes'::text,
    apply_size_mins_to text DEFAULT 'Core Sizes Only'::text,
    cc_addoff_store real,
    cc_addoff_ecom real
);


ALTER TABLE public.ata_cart_params OWNER TO psql;

--
-- TOC entry 376 (class 1259 OID 134294668)
-- Name: ata_cart_params_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_params_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    initrcptwk text,
    dbt_wk text,
    planned_sell_down_week text,
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
    retpct_str real,
    retpct_ecomm real,
    retpct_cross real,
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk_store real,
    slsrnk_ecom real,
    auto_rollforward boolean,
    sty_size_type text,
    sty_size_range text,
    class text,
    subclass text,
    cc_cluster_group text,
    irw_debut_offset integer,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    use_valid_sizes_from text DEFAULT 'Defaults – All Valid Sizes'::text,
    apply_size_mins_to text DEFAULT 'Core Sizes Only'::text,
    cc_addoff_store real,
    cc_addoff_ecom real,
    updated_at date
);


ALTER TABLE public.ata_cart_params_archive OWNER TO psql;

--
-- TOC entry 377 (class 1259 OID 134294677)
-- Name: ata_cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_store_climate text[],
    str_capacity text[],
    str_store_banner text[],
    str_geo_region text[],
    str_hazmat text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_store_climate_or text[],
    str_capacity_or text[],
    str_store_banner_or text[],
    str_geo_region_or text[],
    str_hazmat_or text[]
);


ALTER TABLE public.ata_cart_ranging OWNER TO psql;

--
-- TOC entry 378 (class 1259 OID 134294682)
-- Name: ata_cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_store_climate text[],
    str_capacity text[],
    str_store_banner text[],
    str_geo_region text[],
    str_hazmat text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_store_climate_or text[],
    str_capacity_or text[],
    str_store_banner_or text[],
    str_geo_region_or text[],
    str_hazmat_or text[],
    updated_at date
);


ALTER TABLE public.ata_cart_ranging_archive OWNER TO psql;

--
-- TOC entry 379 (class 1259 OID 134294690)
-- Name: ata_plan_these_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ata_plan_these_style_stylecolors (
    style text,
    stylecolor text,
    session_id text,
    updated_by text,
    picked_for_planning integer
);


ALTER TABLE public.ata_plan_these_style_stylecolors OWNER TO psql;

--
-- TOC entry 380 (class 1259 OID 134294695)
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
-- TOC entry 381 (class 1259 OID 134294703)
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
-- TOC entry 248 (class 1259 OID 97070433)
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
-- TOC entry 249 (class 1259 OID 97070438)
-- Name: cart_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master (
    jsessionid text
);


ALTER TABLE public.cart_master OWNER TO psql;

--
-- TOC entry 382 (class 1259 OID 134294708)
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
    job_priority integer DEFAULT 2,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.cart_master_archive OWNER TO psql;

--
-- TOC entry 383 (class 1259 OID 134294716)
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
    planned_sell_down_week text,
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
    retpct_str real,
    retpct_ecomm real,
    retpct_cross real,
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk_store real,
    slsrnk_ecom real,
    auto_rollforward boolean,
    sty_size_type text,
    sty_size_range text,
    class text,
    subclass text,
    cc_cluster_group text,
    irw_debut_offset integer,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    use_valid_sizes_from text DEFAULT 'Defaults – All Valid Sizes'::text,
    apply_size_mins_to text DEFAULT 'Core Sizes Only'::text,
    cc_addoff_store real,
    cc_addoff_ecom real,
    cc_service_level real,
    cc_service_level_ecom real,
    initrcptwk_store_cad text,
    initrcptwk_ecom_us text,
    initrcptwk_ecom_cad text,
    irw_debut_offset_store_cad integer,
    irw_debut_offset_ecom_us integer,
    irw_debut_offset_ecom_cad integer,
    dbt_wk_store_cad text,
    dbt_wk_ecom_us text,
    dbt_wk_ecom_cad text,
    too_store_cad smallint,
    too_ecom_us smallint,
    too_ecom_cad smallint,
    erlstmkdnwk_store_cad text,
    erlstmkdnwk_ecom_us text,
    erlstmkdnwk_ecom_cad text,
    mkdnwks_store_cad smallint,
    mkdnwks_ecom_us smallint,
    mkdnwks_ecom_cad smallint,
    exitdate_store_cad text,
    exitdate_ecom_us text,
    exitdate_ecom_cad text,
    last_rcpt_wk_store_cad text,
    last_rcpt_wk_ecom_us text,
    last_rcpt_wk_ecom_cad text,
    slsrnk_store_cad real,
    slsrnk_ecom_cad real,
    cc_addoff_ecom_cad real,
    cc_addoff_store_cad real,
    cc_orig_unit_retail real,
    cc_orig_unit_retail_store_cad real,
    cc_orig_unit_retail_ecom_us real,
    cc_orig_unit_retail_ecom_cad real,
    cc_plan_cost_store_cad real,
    cc_plan_cost_ecom_us real,
    cc_plan_cost_ecom_cad real,
    cc_systemcost_store_cad real,
    cc_systemcost_ecom_us real,
    cc_systemcost_ecom_cad real,
    cc_discount_pct_store_cad real,
    cc_discount_pct_ecom_us real,
    cc_discount_pct_ecom_cad real,
    ccmdstrategy_store_cad text,
    ccmdstrategy_ecom_us text,
    ccmdstrategy_ecom_cad text,
    cc_validsizes_store_cad text[],
    cc_validsizes_ecom_cad text[],
    cc_service_level_store_cad real,
    cc_service_level_ecom_cad real,
    cc_presmin_store_cad integer,
    cc_presmin_ecom_us integer,
    cc_presmin_ecom_cad integer,
    cc_presmin_weeks_store_cad integer,
    cc_presmin_weeks_ecom_us integer,
    cc_presmin_weeks_ecom_cad integer,
    cc_rcptint_store_cad integer,
    cc_rcptint_ecom_us integer,
    cc_rcptint_ecom_cad integer,
    cc_ordermin_store_cad integer,
    cc_ordermin_ecom_us integer,
    cc_ordermin_ecom_cad integer,
    cc_lead_time_store_cad integer,
    cc_lead_time_ecom_us integer,
    cc_lead_time_ecom_cad integer,
    cc_return_u_pct_store_cad real,
    cc_return_u_pct_ecom_cad real,
    cc_ordermultiple_store_cad integer,
    cc_ordermultiple_ecom_us integer,
    cc_ordermultiple_ecom_cad integer,
    ccticketpricechannel_store_cad real,
    ccticketpricechannel_ecom_us real,
    ccticketpricechannel_ecom_cad real,
    ccticketpricechannel_store_cad_override real,
    ccticketpricechannel_ecom_us_override real,
    ccticketpricechannel_ecom_cad_override real
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 384 (class 1259 OID 134294724)
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
    planned_sell_down_week text,
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
    retpct_str real,
    retpct_ecomm real,
    retpct_cross real,
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk_store real,
    slsrnk_ecom real,
    auto_rollforward boolean,
    sty_size_type text,
    sty_size_range text,
    class text,
    subclass text,
    cc_cluster_group text,
    irw_debut_offset integer,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    use_valid_sizes_from text DEFAULT 'Defaults – All Valid Sizes'::text,
    apply_size_mins_to text DEFAULT 'Core Sizes Only'::text,
    cc_addoff_store real,
    cc_addoff_ecom real,
    cc_service_level real,
    cc_service_level_ecom real,
    initrcptwk_store_cad text,
    initrcptwk_ecom_us text,
    initrcptwk_ecom_cad text,
    irw_debut_offset_store_cad integer,
    irw_debut_offset_ecom_us integer,
    irw_debut_offset_ecom_cad integer,
    dbt_wk_store_cad text,
    dbt_wk_ecom_us text,
    dbt_wk_ecom_cad text,
    too_store_cad smallint,
    too_ecom_us smallint,
    too_ecom_cad smallint,
    erlstmkdnwk_store_cad text,
    erlstmkdnwk_ecom_us text,
    erlstmkdnwk_ecom_cad text,
    mkdnwks_store_cad smallint,
    mkdnwks_ecom_us smallint,
    mkdnwks_ecom_cad smallint,
    exitdate_store_cad text,
    exitdate_ecom_us text,
    exitdate_ecom_cad text,
    last_rcpt_wk_store_cad text,
    last_rcpt_wk_ecom_us text,
    last_rcpt_wk_ecom_cad text,
    slsrnk_store_cad real,
    slsrnk_ecom_cad real,
    cc_addoff_ecom_cad real,
    cc_addoff_store_cad real,
    cc_orig_unit_retail real,
    cc_orig_unit_retail_store_cad real,
    cc_orig_unit_retail_ecom_us real,
    cc_orig_unit_retail_ecom_cad real,
    cc_plan_cost_store_cad real,
    cc_plan_cost_ecom_us real,
    cc_plan_cost_ecom_cad real,
    cc_systemcost_store_cad real,
    cc_systemcost_ecom_us real,
    cc_systemcost_ecom_cad real,
    cc_discount_pct_store_cad real,
    cc_discount_pct_ecom_us real,
    cc_discount_pct_ecom_cad real,
    ccmdstrategy_store_cad text,
    ccmdstrategy_ecom_us text,
    ccmdstrategy_ecom_cad text,
    cc_validsizes_store_cad text[],
    cc_validsizes_ecom_cad text[],
    cc_service_level_store_cad real,
    cc_service_level_ecom_cad real,
    cc_presmin_store_cad integer,
    cc_presmin_ecom_us integer,
    cc_presmin_ecom_cad integer,
    cc_presmin_weeks_store_cad integer,
    cc_presmin_weeks_ecom_us integer,
    cc_presmin_weeks_ecom_cad integer,
    cc_rcptint_store_cad integer,
    cc_rcptint_ecom_us integer,
    cc_rcptint_ecom_cad integer,
    cc_ordermin_store_cad integer,
    cc_ordermin_ecom_us integer,
    cc_ordermin_ecom_cad integer,
    cc_lead_time_store_cad integer,
    cc_lead_time_ecom_us integer,
    cc_lead_time_ecom_cad integer,
    cc_return_u_pct_store_cad real,
    cc_return_u_pct_ecom_cad real,
    cc_ordermultiple_store_cad integer,
    cc_ordermultiple_ecom_us integer,
    cc_ordermultiple_ecom_cad integer,
    ccticketpricechannel_store_cad real,
    ccticketpricechannel_ecom_us real,
    ccticketpricechannel_ecom_cad real,
    ccticketpricechannel_store_cad_override real,
    ccticketpricechannel_ecom_us_override real,
    ccticketpricechannel_ecom_cad_override real
);


ALTER TABLE public.cart_params_archive OWNER TO psql;

--
-- TOC entry 250 (class 1259 OID 97070448)
-- Name: cart_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_queue (
    cart_id text NOT NULL,
    user_id text NOT NULL,
    scope_id uuid NOT NULL,
    state public.queue_state NOT NULL,
    error_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    instance_id text
);


ALTER TABLE public.cart_queue OWNER TO psql;

--
-- TOC entry 385 (class 1259 OID 134294732)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_climate text[],
    str_region_combo text[],
    str_hvlc text[],
    str_tourist_border_combo text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_climate_or text[],
    str_region_combo_or text[],
    str_hvlc_or text[],
    str_tourist_border_combo_or text[],
    str_grade_cad text[],
    str_climate_cad text[],
    str_region_combo_cad text[],
    str_hvlc_cad text[],
    str_tourist_border_combo_cad text[],
    ssg_cad text[],
    isfunded_cad integer,
    str_grade_ecom text[],
    isfunded_ecom integer,
    str_grade_ecom_cad text[],
    isfunded_ecom_cad integer
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 386 (class 1259 OID 134294737)
-- Name: cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_climate text[],
    str_region_combo text[],
    str_hvlc text[],
    str_tourist_border_combo text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_climate_or text[],
    str_region_combo_or text[],
    str_hvlc_or text[],
    str_tourist_border_combo_or text[],
    str_grade_cad text[],
    str_climate_cad text[],
    str_region_combo_cad text[],
    str_hvlc_cad text[],
    str_tourist_border_combo_cad text[],
    ssg_cad text[],
    isfunded_cad integer,
    str_grade_ecom text[],
    isfunded_ecom integer,
    str_grade_ecom_cad text[],
    isfunded_ecom_cad integer
);


ALTER TABLE public.cart_ranging_archive OWNER TO psql;

--
-- TOC entry 337 (class 1259 OID 108257938)
-- Name: current_week; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.current_week (
    current_week character varying(20)
);


ALTER TABLE public.current_week OWNER TO psql;

--
-- TOC entry 387 (class 1259 OID 134294742)
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
-- TOC entry 388 (class 1259 OID 134294747)
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
-- TOC entry 389 (class 1259 OID 134294750)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 390 (class 1259 OID 134294755)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    department text,
    default_discount real
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 391 (class 1259 OID 134294760)
-- Name: delete_me_user_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_user_worklist (
    user_id text,
    product text,
    type text,
    updated_at timestamp without time zone,
    name text
);


ALTER TABLE public.delete_me_user_worklist OWNER TO psql;

--
-- TOC entry 392 (class 1259 OID 134294765)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 393 (class 1259 OID 134294773)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 394 (class 1259 OID 134294778)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 395 (class 1259 OID 134294783)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 396 (class 1259 OID 134294788)
-- Name: dept_plan_items_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_temp OWNER TO psql;

--
-- TOC entry 251 (class 1259 OID 97070468)
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
-- TOC entry 397 (class 1259 OID 134294793)
-- Name: failed_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_items (
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


ALTER TABLE public.failed_items OWNER TO psql;

--
-- TOC entry 252 (class 1259 OID 97070475)
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
-- TOC entry 398 (class 1259 OID 134294798)
-- Name: fcstable_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.fcstable_product (
    product text
);


ALTER TABLE public.fcstable_product OWNER TO psql;

--
-- TOC entry 399 (class 1259 OID 134294809)
-- Name: flrset_hierarchy_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.flrset_hierarchy_prep (
    product text,
    floorset text,
    superset text,
    year text,
    min_rcptstart text,
    prev_flrset character varying(100),
    next_flrset character varying(100),
    prev_superset character varying(100),
    next_superset character varying(100),
    indx bigint,
    floorset_name text,
    superset_name text
);


ALTER TABLE public.flrset_hierarchy_prep OWNER TO psql;

--
-- TOC entry 400 (class 1259 OID 134294814)
-- Name: md_strategy; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.md_strategy (
    mdstrategy text,
    seq smallint,
    md_disc real,
    factor real,
    eventdate date
);


ALTER TABLE public.md_strategy OWNER TO psql;

--
-- TOC entry 464 (class 1259 OID 134305905)
-- Name: mdstrategy_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.mdstrategy_l_dependencylookup (
    department text,
    mdstrategy text,
    seq integer,
    weeks text,
    md text
);


ALTER TABLE public.mdstrategy_l_dependencylookup OWNER TO psql;

--
-- TOC entry 474 (class 1259 OID 139069876)
-- Name: mfp_channel_plan_export; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.mfp_channel_plan_export (
    "BRAND_IDENTIFIER" text,
    "PRODUCT" text,
    "LOCATION" text,
    "WEEK" text,
    "VERSION" text,
    "CURRENCY" text,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_current_tkt double precision,
    net_sls_r_current_tkt_store double precision,
    net_sls_r_current_tkt_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    dmd_r_web double precision,
    return_r_web double precision,
    dmd_u_web double precision,
    dmd_c_web double precision,
    "MODIFY_BY" text,
    "MODIFY_TIMESTAMP" text
);


ALTER TABLE public.mfp_channel_plan_export OWNER TO psql;

--
-- TOC entry 473 (class 1259 OID 139069847)
-- Name: mfp_product_plan_export; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.mfp_product_plan_export (
    "BRAND_IDENTIFIER" text,
    "PRODUCT" text,
    "LOCATION" text,
    "WEEK" text,
    "VERSION" text,
    "CURRENCY" text,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    pst_eoh_r double precision,
    pst_eoh_u double precision,
    pst_eoh_c double precision,
    pst_boh_r double precision,
    pst_boh_u double precision,
    pst_boh_c double precision,
    ats_inv_r double precision,
    ats_inv_u double precision,
    ats_inv_c double precision,
    eoh_r double precision,
    eoh_u double precision,
    eoh_c double precision,
    pst_transfer_r double precision,
    pst_transfer_u double precision,
    pst_transfer_c double precision,
    inv_adjustment_r double precision,
    inv_adjustment_u double precision,
    inv_adjustment_c double precision,
    rec_r double precision,
    rec_u double precision,
    rec_c double precision,
    rec_r_air double precision,
    rec_u_air double precision,
    rec_c_air double precision,
    rec_r_ocean double precision,
    rec_u_ocean double precision,
    rec_c_ocean double precision,
    store_count_web double precision,
    store_count_store double precision,
    store_count_total double precision,
    net_sls_r double precision,
    net_sls_r_store double precision,
    net_sls_r_web double precision,
    net_sls_u double precision,
    net_sls_u_store double precision,
    net_sls_u_web double precision,
    net_sls_c double precision,
    net_sls_c_store double precision,
    net_sls_c_web double precision,
    net_sls_r_current_tkt double precision,
    net_sls_r_current_tkt_store double precision,
    net_sls_r_current_tkt_web double precision,
    pos_md_r double precision,
    pos_md_r_store double precision,
    pos_md_r_web double precision,
    perm_md_r double precision,
    perm_md_r_store double precision,
    perm_md_r_web double precision,
    perm_md_c double precision,
    perm_md_c_store double precision,
    perm_md_c_web double precision,
    dmd_r_web double precision,
    return_r_web double precision,
    dmd_u_web double precision,
    dmd_c_web double precision,
    on_order_r double precision,
    on_order_u double precision,
    on_order_c double precision,
    on_order_r_air double precision,
    on_order_u_air double precision,
    on_order_c_air double precision,
    on_order_r_ocean double precision,
    on_order_u_ocean double precision,
    on_order_c_ocean double precision,
    "MODIFY_BY" text,
    "MODIFY_TIMESTAMP" text
);


ALTER TABLE public.mfp_product_plan_export OWNER TO psql;

--
-- TOC entry 372 (class 1259 OID 134294645)
-- Name: perf_assortperiod_week; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT aeo_ma_dptflrsetattributes.product,
            aeo_ma_dptflrsetattributes."time",
            aeo_ma_dptflrsetattributes.rcptstart,
            aeo_ma_dptflrsetattributes.rcptend
           FROM public.aeo_ma_dptflrsetattributes) a,
    public.aeo_d_time b
  WHERE ((b.levelid = ('week'::character varying(4))::text) AND (b.id >= a.rcptstart) AND (b.id <= a.rcptend));


ALTER VIEW public.perf_assortperiod_week OWNER TO psql;

--
-- TOC entry 253 (class 1259 OID 97070480)
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
-- TOC entry 254 (class 1259 OID 97070485)
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
-- TOC entry 255 (class 1259 OID 97070491)
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
-- TOC entry 468 (class 1259 OID 134365492)
-- Name: plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue (
    jobid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    processing_start timestamp with time zone,
    processing_end timestamp with time zone,
    size_start timestamp with time zone,
    size_end timestamp with time zone,
    completed timestamp with time zone,
    error text,
    initiator uuid NOT NULL,
    initiated_at timestamp with time zone DEFAULT '2026-09-14 21:58:30.447352'::timestamp without time zone NOT NULL,
    forecast_start timestamp with time zone,
    forecast_end timestamp with time zone
);


ALTER TABLE public.plan_queue OWNER TO psql;

--
-- TOC entry 471 (class 1259 OID 134667909)
-- Name: plan_status; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.plan_status AS
 SELECT plan_queue.jobid,
    plan_queue.product,
    plan_queue.location,
    plan_queue.initiator,
        CASE
            WHEN ((plan_queue.completed IS NOT NULL) AND (plan_queue.error IS NULL)) THEN 'COMPLETED'::text
            WHEN ((plan_queue.completed IS NOT NULL) AND (plan_queue.error IS NOT NULL)) THEN 'FAILED'::text
            WHEN ((plan_queue.size_start IS NULL) AND (plan_queue.forecast_start IS NULL)) THEN 'PENDING'::text
            WHEN (((plan_queue.size_start IS NOT NULL) AND (plan_queue.size_end IS NULL)) OR ((plan_queue.forecast_start IS NOT NULL) AND (plan_queue.forecast_end IS NULL))) THEN 'PREDICTING'::text
            WHEN ((plan_queue.processing_start IS NOT NULL) AND (plan_queue.processing_end IS NULL)) THEN 'PROCESSING'::text
            ELSE 'STALLED'::text
        END AS status
   FROM public.plan_queue;


ALTER VIEW public.plan_status OWNER TO psql;

--
-- TOC entry 401 (class 1259 OID 134294819)
-- Name: prev_next_flrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.prev_next_flrset (
    product text,
    floorset text,
    min_rcptstart text,
    rn bigint,
    prev character varying(100),
    next character varying(100)
);


ALTER TABLE public.prev_next_flrset OWNER TO psql;

--
-- TOC entry 402 (class 1259 OID 134294824)
-- Name: prev_next_superset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.prev_next_superset (
    product text,
    superset text,
    min_rcptstart text,
    rn bigint,
    prev character varying(100),
    next character varying(100)
);


ALTER TABLE public.prev_next_superset OWNER TO psql;

--
-- TOC entry 403 (class 1259 OID 134294829)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 404 (class 1259 OID 134294834)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 467 (class 1259 OID 134357197)
-- Name: scope; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.scope (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    app_name text NOT NULL,
    user_id text NOT NULL,
    params json NOT NULL,
    filter_conditions json DEFAULT '{"filterConditions": []}'::json NOT NULL
);


ALTER TABLE public.scope OWNER TO psql;

--
-- TOC entry 256 (class 1259 OID 97070524)
-- Name: seq_area; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_area
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_area OWNER TO psql;

--
-- TOC entry 460 (class 1259 OID 134298564)
-- Name: seq_channel; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_channel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_channel OWNER TO psql;

--
-- TOC entry 257 (class 1259 OID 97070526)
-- Name: seq_district; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_district
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_district OWNER TO psql;

--
-- TOC entry 461 (class 1259 OID 134298565)
-- Name: seq_marketplace; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_marketplace
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_marketplace OWNER TO psql;

--
-- TOC entry 258 (class 1259 OID 97070528)
-- Name: seq_region; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_region
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_region OWNER TO psql;

--
-- TOC entry 259 (class 1259 OID 97070529)
-- Name: seq_sellingchannel; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_sellingchannel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_sellingchannel OWNER TO psql;

--
-- TOC entry 462 (class 1259 OID 134298566)
-- Name: seq_store; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_store
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_store OWNER TO psql;

--
-- TOC entry 260 (class 1259 OID 97070531)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 458 (class 1259 OID 134295469)
-- Name: style_sequence; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.style_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.style_sequence OWNER TO psql;

--
-- TOC entry 405 (class 1259 OID 134294839)
-- Name: sync_outbound_dataqueue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue (
    product text NOT NULL,
    "time" text NOT NULL,
    publish_type text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.sync_outbound_dataqueue OWNER TO psql;

--
-- TOC entry 465 (class 1259 OID 134305910)
-- Name: tmp_aeo_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_aeo_v_memberbasedvalidvalues (
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


ALTER TABLE public.tmp_aeo_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 261 (class 1259 OID 97070536)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 262 (class 1259 OID 97070541)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 469 (class 1259 OID 134667869)
-- Name: undo_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_log (
    undo_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    department text NOT NULL,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by text,
    updated_at timestamp with time zone,
    channel text NOT NULL,
    status public.undo_status,
    plan_measure text[] NOT NULL,
    member_tie text[] NOT NULL
);


ALTER TABLE public.undo_log OWNER TO psql;

--
-- TOC entry 470 (class 1259 OID 134667888)
-- Name: undo_modifications; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_modifications (
    undo_id uuid,
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
-- TOC entry 263 (class 1259 OID 97070559)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 472 (class 1259 OID 134697171)
-- Name: user_metadata_get_api; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata_get_api (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata_get_api OWNER TO psql;

--
-- TOC entry 455 (class 1259 OID 134295375)
-- Name: user_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl (
    tenantid text NOT NULL,
    id text NOT NULL,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.user_tbl OWNER TO psql;

--
-- TOC entry 456 (class 1259 OID 134295387)
-- Name: user_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_worklist (
    user_id text NOT NULL,
    product text NOT NULL,
    type text DEFAULT 'active'::text NOT NULL,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    name text DEFAULT '⚠️❓❓'::text NOT NULL
);


ALTER TABLE public.user_worklist OWNER TO psql;

--
-- TOC entry 457 (class 1259 OID 134295395)
-- Name: worklist_map; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.worklist_map (
    product text,
    worklist_id text NOT NULL
);


ALTER TABLE public.worklist_map OWNER TO psql;

--
-- TOC entry 5882 (class 2606 OID 108253639)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5867 (class 2606 OID 108253614)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5869 (class 2606 OID 108253428)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5871 (class 2606 OID 108253437)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5864 (class 2606 OID 108253398)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 5884 (class 2606 OID 108253694)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5876 (class 2606 OID 108253701)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 5878 (class 2606 OID 108253605)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 5880 (class 2606 OID 108253621)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5873 (class 2606 OID 108253558)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 5904 (class 2606 OID 108254003)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5889 (class 2606 OID 108253975)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5891 (class 2606 OID 108253792)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5893 (class 2606 OID 108253801)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5886 (class 2606 OID 108253763)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 5906 (class 2606 OID 108254058)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5898 (class 2606 OID 108254065)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 5900 (class 2606 OID 108253966)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 5902 (class 2606 OID 108253982)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5895 (class 2606 OID 108253922)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 5926 (class 2606 OID 108254368)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5911 (class 2606 OID 108254343)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5913 (class 2606 OID 108254160)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5915 (class 2606 OID 108254169)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5908 (class 2606 OID 108254130)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 5928 (class 2606 OID 108254423)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5920 (class 2606 OID 108254430)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 5922 (class 2606 OID 108254334)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 5924 (class 2606 OID 108254350)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5917 (class 2606 OID 108254290)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 5948 (class 2606 OID 108254730)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5933 (class 2606 OID 108254705)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5935 (class 2606 OID 108254522)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5937 (class 2606 OID 108254531)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5930 (class 2606 OID 108254492)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 5950 (class 2606 OID 108254785)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5942 (class 2606 OID 108254792)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 5944 (class 2606 OID 108254696)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 5946 (class 2606 OID 108254712)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5939 (class 2606 OID 108254652)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 5983 (class 2606 OID 134294562)
-- Name: aeo_a_assortment aeo_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_a_assortment
    ADD CONSTRAINT aeo_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 5993 (class 2606 OID 134295405)
-- Name: aeo_an_price_storecount_info aeo_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_an_price_storecount_info
    ADD CONSTRAINT aeo_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 5995 (class 2606 OID 134295407)
-- Name: aeo_authorization aeo_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_authorization
    ADD CONSTRAINT aeo_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 5999 (class 2606 OID 134295409)
-- Name: aeo_eohdata_stylecolor aeo_eohdata_stylecolor_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_eohdata_stylecolor
    ADD CONSTRAINT aeo_eohdata_stylecolor_pkey PRIMARY KEY (product);


--
-- TOC entry 5991 (class 2606 OID 134294641)
-- Name: aeo_corpdisc aeo_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_corpdisc
    ADD CONSTRAINT aeo_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time", prodlife);


--
-- TOC entry 5828 (class 2606 OID 134295411)
-- Name: aeo_l_dclookup aeo_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_l_dclookup
    ADD CONSTRAINT aeo_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 6002 (class 2606 OID 134295413)
-- Name: aeo_l_priceeventlookup aeo_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_l_priceeventlookup
    ADD CONSTRAINT aeo_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 5989 (class 2606 OID 134294620)
-- Name: aeo_l_ssglookup aeo_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_l_ssglookup
    ADD CONSTRAINT aeo_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 6004 (class 2606 OID 134295418)
-- Name: aeo_l_storedclookup aeo_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_l_storedclookup
    ADD CONSTRAINT aeo_l_storedclookup_pkey PRIMARY KEY (store, dc, priority);


--
-- TOC entry 6006 (class 2606 OID 134295420)
-- Name: aeo_l_storelookup aeo_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_l_storelookup
    ADD CONSTRAINT aeo_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 6008 (class 2606 OID 134295422)
-- Name: aeo_ma_departmentalloc_attributes aeo_ma_departmentalloc_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_ma_departmentalloc_attributes
    ADD CONSTRAINT aeo_ma_departmentalloc_attributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6010 (class 2606 OID 134295424)
-- Name: aeo_ma_departmentquarter_attributes aeo_ma_departmentquarter_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_ma_departmentquarter_attributes
    ADD CONSTRAINT aeo_ma_departmentquarter_attributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 6012 (class 2606 OID 134295426)
-- Name: aeo_ma_stylecolor_alloc_attributes aeo_ma_stylecolor_alloc_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_ma_stylecolor_alloc_attributes
    ADD CONSTRAINT aeo_ma_stylecolor_alloc_attributes_pkey PRIMARY KEY (product);


--
-- TOC entry 5981 (class 2606 OID 134294541)
-- Name: aeo_ma_stylecolorchannelattributes aeo_ma_stylecolorchannelattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_ma_stylecolorchannelattributes
    ADD CONSTRAINT aeo_ma_stylecolorchannelattributes_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5997 (class 2606 OID 134295428)
-- Name: aeo_p_approvedclusters aeo_p_approvedclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_approvedclusters
    ADD CONSTRAINT aeo_p_approvedclusters_pkey PRIMARY KEY (product, "time", cluster_id);


--
-- TOC entry 6014 (class 2606 OID 134295430)
-- Name: aeo_p_casepack aeo_p_casepack_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_casepack
    ADD CONSTRAINT aeo_p_casepack_pkey PRIMARY KEY (product, location, "time", case_pack_id);


--
-- TOC entry 5987 (class 2606 OID 134294594)
-- Name: aeo_p_channeloverride aeo_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_channeloverride
    ADD CONSTRAINT aeo_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 6016 (class 2606 OID 134295432)
-- Name: aeo_p_dept_store_attr_plan aeo_p_dept_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_dept_store_attr_plan
    ADD CONSTRAINT aeo_p_dept_store_attr_plan_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5985 (class 2606 OID 134294579)
-- Name: aeo_p_itemprice aeo_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_itemprice
    ADD CONSTRAINT aeo_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 6018 (class 2606 OID 134295434)
-- Name: aeo_p_reassigncluster aeo_p_reassigncluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_reassigncluster
    ADD CONSTRAINT aeo_p_reassigncluster_pkey PRIMARY KEY (product, location, "time", store_cluster_id);


--
-- TOC entry 6020 (class 2606 OID 134295436)
-- Name: aeo_p_receditclusters aeo_p_receditclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_receditclusters
    ADD CONSTRAINT aeo_p_receditclusters_pkey PRIMARY KEY (product, "time", po_id_for_clusters);


--
-- TOC entry 6022 (class 2606 OID 134295438)
-- Name: aeo_p_receditstores aeo_p_receditstores_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_receditstores
    ADD CONSTRAINT aeo_p_receditstores_pkey PRIMARY KEY (product, location, "time", po_id_for_stores);


--
-- TOC entry 6024 (class 2606 OID 134295440)
-- Name: aeo_p_store_attr_plan aeo_p_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_store_attr_plan
    ADD CONSTRAINT aeo_p_store_attr_plan_pkey PRIMARY KEY (location);


--
-- TOC entry 6028 (class 2606 OID 134295442)
-- Name: aeo_p_stylecolor_channel_alloc_params aeo_p_stylecolor_channel_alloc_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_channel_alloc_params
    ADD CONSTRAINT aeo_p_stylecolor_channel_alloc_params_pkey PRIMARY KEY (product, location);


--
-- TOC entry 6030 (class 2606 OID 134295447)
-- Name: aeo_p_stylecolor_store_alloc_params aeo_p_stylecolor_store_alloc_params_okey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_store_alloc_params
    ADD CONSTRAINT aeo_p_stylecolor_store_alloc_params_okey PRIMARY KEY (product, location);


--
-- TOC entry 6032 (class 2606 OID 134295449)
-- Name: aeo_p_stylecolor_store_eligibility aeo_p_stylecolor_store_eligibility_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_store_eligibility
    ADD CONSTRAINT aeo_p_stylecolor_store_eligibility_pkey PRIMARY KEY (product, location);


--
-- TOC entry 6034 (class 2606 OID 134295454)
-- Name: aeo_p_stylecolor_store_worklist aeo_p_stylecolor_store_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_store_worklist
    ADD CONSTRAINT aeo_p_stylecolor_store_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 6038 (class 2606 OID 134295456)
-- Name: aeo_p_stylecolor_worklist aeo_p_stylecolor_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_worklist
    ADD CONSTRAINT aeo_p_stylecolor_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 6040 (class 2606 OID 134295458)
-- Name: aeo_p_stylecolorsize_worklist aeo_p_stylecolorsize_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolorsize_worklist
    ADD CONSTRAINT aeo_p_stylecolorsize_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 6042 (class 2606 OID 134295460)
-- Name: aeo_p_target_include_exclude aeo_p_target_include_exclude_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_target_include_exclude
    ADD CONSTRAINT aeo_p_target_include_exclude_pkey PRIMARY KEY (product, "time", ly_lly_key);


--
-- TOC entry 6045 (class 2606 OID 134295462)
-- Name: aeo_roledimension aeo_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_roledimension
    ADD CONSTRAINT aeo_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 6047 (class 2606 OID 134295464)
-- Name: aeo_specimages aeo_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_specimages
    ADD CONSTRAINT aeo_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 5846 (class 2606 OID 97070576)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 5844 (class 2606 OID 97070578)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 5848 (class 2606 OID 97070580)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 5850 (class 2606 OID 97070582)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 5852 (class 2606 OID 97070586)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 5854 (class 2606 OID 97070588)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 5859 (class 2606 OID 97070590)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 6036 (class 2606 OID 134295401)
-- Name: aeo_p_stylecolor_sysmanaged_attr_plan pk_stylecolor_sysmanaged_attr_plan; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_stylecolor_sysmanaged_attr_plan
    ADD CONSTRAINT pk_stylecolor_sysmanaged_attr_plan PRIMARY KEY (product, location);


--
-- TOC entry 6056 (class 2606 OID 134365499)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 6054 (class 2606 OID 134357204)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 6026 (class 2606 OID 134295403)
-- Name: aeo_p_strategy_params strategy_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.aeo_p_strategy_params
    ADD CONSTRAINT strategy_params_pkey PRIMARY KEY (product, location, floorset_uda);


--
-- TOC entry 5856 (class 2606 OID 97070598)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 6058 (class 2606 OID 134667877)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 6060 (class 2606 OID 134697177)
-- Name: user_metadata_get_api user_metadata_get_api_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata_get_api
    ADD CONSTRAINT user_metadata_get_api_pkey PRIMARY KEY (uid);


--
-- TOC entry 5862 (class 2606 OID 97070602)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 5972 (class 1259 OID 128873029)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp.actuals_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5973 (class 1259 OID 128873031)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp.actuals_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5974 (class 1259 OID 128873047)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp.actuals_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5975 (class 1259 OID 128873054)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON mfp.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 5865 (class 1259 OID 108253653)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 5874 (class 1259 OID 108253612)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp.plan_data_wide USING hash (id);


--
-- TOC entry 5976 (class 1259 OID 128873030)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp.sys_gen_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5977 (class 1259 OID 128873040)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp.sys_gen_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5978 (class 1259 OID 128873051)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp.sys_gen_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5951 (class 1259 OID 108299123)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp_channel_plan.actuals_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5952 (class 1259 OID 108299125)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp_channel_plan.actuals_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5953 (class 1259 OID 108299127)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp_channel_plan.actuals_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5954 (class 1259 OID 108299129)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON mfp_channel_plan.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 5887 (class 1259 OID 108254017)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp_channel_plan.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 5896 (class 1259 OID 108253973)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp_channel_plan.plan_data_wide USING hash (id);


--
-- TOC entry 5955 (class 1259 OID 108299124)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp_channel_plan.sys_gen_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5956 (class 1259 OID 108299126)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp_channel_plan.sys_gen_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5957 (class 1259 OID 108299128)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp_channel_plan; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp_channel_plan.sys_gen_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5958 (class 1259 OID 108299158)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp_long_range.actuals_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5959 (class 1259 OID 108299160)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp_long_range.actuals_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5960 (class 1259 OID 108299162)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp_long_range.actuals_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5961 (class 1259 OID 108299164)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON mfp_long_range.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 5909 (class 1259 OID 108254382)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp_long_range.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 5918 (class 1259 OID 108254341)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp_long_range.plan_data_wide USING hash (id);


--
-- TOC entry 5962 (class 1259 OID 108299159)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp_long_range.sys_gen_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5963 (class 1259 OID 108299161)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp_long_range.sys_gen_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5964 (class 1259 OID 108299163)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp_long_range; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp_long_range.sys_gen_wide_denorm USING btree (time_season, product_brand_group, location_global_region);


--
-- TOC entry 5965 (class 1259 OID 108299193)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp_total_aeo.actuals_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5966 (class 1259 OID 108299195)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp_total_aeo.actuals_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5967 (class 1259 OID 108299197)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp_total_aeo.actuals_wide_denorm USING btree (time_season, product_total_prod, location_global_region);


--
-- TOC entry 5968 (class 1259 OID 108299199)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON mfp_total_aeo.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 5931 (class 1259 OID 108254744)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp_total_aeo.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 5940 (class 1259 OID 108254703)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp_total_aeo.plan_data_wide USING hash (id);


--
-- TOC entry 5969 (class 1259 OID 108299194)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp_total_aeo.sys_gen_wide_denorm USING btree (time_season, product_department, location_global_region);


--
-- TOC entry 5970 (class 1259 OID 108299196)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp_total_aeo.sys_gen_wide_denorm USING btree (time_season, product_division, location_global_region);


--
-- TOC entry 5971 (class 1259 OID 108299198)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp_total_aeo; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp_total_aeo.sys_gen_wide_denorm USING btree (time_season, product_total_prod, location_global_region);


--
-- TOC entry 5774 (class 1259 OID 97070605)
-- Name: aeo_cluster_view_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_cluster_view_tbl_record_state ON public.aeo_cluster_view_tbl USING btree (record_state);


--
-- TOC entry 5775 (class 1259 OID 97070606)
-- Name: aeo_d_cluster_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_cluster_levelid ON public.aeo_d_cluster USING btree (levelid);


--
-- TOC entry 5776 (class 1259 OID 97070607)
-- Name: aeo_d_cluster_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_d_cluster_pkey ON public.aeo_d_cluster USING btree (id);


--
-- TOC entry 5777 (class 1259 OID 97070608)
-- Name: aeo_d_cluster_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_cluster_record_state ON public.aeo_d_cluster USING btree (record_state);


--
-- TOC entry 5778 (class 1259 OID 97070609)
-- Name: aeo_d_location_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_location_levelid ON public.aeo_d_location USING btree (levelid);


--
-- TOC entry 5779 (class 1259 OID 97070610)
-- Name: aeo_d_location_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_d_location_pkey ON public.aeo_d_location USING btree (id);


--
-- TOC entry 5780 (class 1259 OID 97070611)
-- Name: aeo_d_location_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_location_record_state ON public.aeo_d_location USING btree (record_state);


--
-- TOC entry 5781 (class 1259 OID 97070612)
-- Name: aeo_d_prodlife_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_prodlife_levelid ON public.aeo_d_prodlife USING btree (levelid);


--
-- TOC entry 5782 (class 1259 OID 97070613)
-- Name: aeo_d_prodlife_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_d_prodlife_pkey ON public.aeo_d_prodlife USING btree (id);


--
-- TOC entry 5783 (class 1259 OID 97070614)
-- Name: aeo_d_prodlife_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_prodlife_record_state ON public.aeo_d_prodlife USING btree (record_state);


--
-- TOC entry 5784 (class 1259 OID 97070615)
-- Name: aeo_d_product_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_product_levelid ON public.aeo_d_product USING btree (levelid);


--
-- TOC entry 5785 (class 1259 OID 97070616)
-- Name: aeo_d_product_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_d_product_pkey ON public.aeo_d_product USING btree (id);


--
-- TOC entry 5786 (class 1259 OID 97070620)
-- Name: aeo_d_product_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_product_record_state ON public.aeo_d_product USING btree (record_state);


--
-- TOC entry 5787 (class 1259 OID 97070621)
-- Name: aeo_d_time_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_time_levelid ON public.aeo_d_time USING btree (levelid);


--
-- TOC entry 5788 (class 1259 OID 97070622)
-- Name: aeo_d_time_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_d_time_pkey ON public.aeo_d_time USING btree (id);


--
-- TOC entry 5789 (class 1259 OID 97070623)
-- Name: aeo_d_time_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_d_time_record_state ON public.aeo_d_time USING btree (record_state);


--
-- TOC entry 5790 (class 1259 OID 97070624)
-- Name: aeo_floorset_week_attributes_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_floorset_week_attributes_tbl_record_state ON public.aeo_floorset_week_attributes_tbl USING btree (record_state);


--
-- TOC entry 5791 (class 1259 OID 97070625)
-- Name: aeo_h_clusterstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_clusterstd_pkey ON public.aeo_h_clusterstd USING btree (id);


--
-- TOC entry 5792 (class 1259 OID 97070626)
-- Name: aeo_h_clusterstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_clusterstd_record_state ON public.aeo_h_clusterstd USING btree (record_state);


--
-- TOC entry 5793 (class 1259 OID 97070627)
-- Name: aeo_h_locdc_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_locdc_pkey ON public.aeo_h_locdc USING btree (id);


--
-- TOC entry 5794 (class 1259 OID 97070628)
-- Name: aeo_h_locdc_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locdc_record_state ON public.aeo_h_locdc USING btree (record_state);


--
-- TOC entry 5795 (class 1259 OID 97070629)
-- Name: aeo_h_locdcstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locdcstd_ancestor0 ON public.aeo_h_locdcstd USING btree (ancestor0);


--
-- TOC entry 5796 (class 1259 OID 97070630)
-- Name: aeo_h_locdcstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_locdcstd_pkey ON public.aeo_h_locdcstd USING btree (id);


--
-- TOC entry 5797 (class 1259 OID 97070631)
-- Name: aeo_h_locdcstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locdcstd_record_state ON public.aeo_h_locdcstd USING btree (record_state);


--
-- TOC entry 5798 (class 1259 OID 97070632)
-- Name: aeo_h_locstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locstd_ancestor0 ON public.aeo_h_locstd USING btree (ancestor0);


--
-- TOC entry 5799 (class 1259 OID 97070633)
-- Name: aeo_h_locstd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locstd_ancestor1 ON public.aeo_h_locstd USING btree (ancestor1);


--
-- TOC entry 5800 (class 1259 OID 97070634)
-- Name: aeo_h_locstd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locstd_ancestor2 ON public.aeo_h_locstd USING btree (ancestor2);


--
-- TOC entry 5801 (class 1259 OID 97070635)
-- Name: aeo_h_locstd_ancestor3; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locstd_ancestor3 ON public.aeo_h_locstd USING btree (ancestor3);


--
-- TOC entry 5802 (class 1259 OID 97070636)
-- Name: aeo_h_locstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_locstd_pkey ON public.aeo_h_locstd USING btree (id);


--
-- TOC entry 5803 (class 1259 OID 97070637)
-- Name: aeo_h_locstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_locstd_record_state ON public.aeo_h_locstd USING btree (record_state);


--
-- TOC entry 5804 (class 1259 OID 97070638)
-- Name: aeo_h_prodlifestd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_prodlifestd_pkey ON public.aeo_h_prodlifestd USING btree (id);


--
-- TOC entry 5805 (class 1259 OID 97070639)
-- Name: aeo_h_prodlifestd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodlifestd_record_state ON public.aeo_h_prodlifestd USING btree (record_state);


--
-- TOC entry 5806 (class 1259 OID 97070640)
-- Name: aeo_h_prodstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor0 ON public.aeo_h_prodstd USING btree (ancestor0);


--
-- TOC entry 5807 (class 1259 OID 97070644)
-- Name: aeo_h_prodstd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor1 ON public.aeo_h_prodstd USING btree (ancestor1);


--
-- TOC entry 5808 (class 1259 OID 97070645)
-- Name: aeo_h_prodstd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor2 ON public.aeo_h_prodstd USING btree (ancestor2);


--
-- TOC entry 5809 (class 1259 OID 97070646)
-- Name: aeo_h_prodstd_ancestor3; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor3 ON public.aeo_h_prodstd USING btree (ancestor3);


--
-- TOC entry 5810 (class 1259 OID 97070647)
-- Name: aeo_h_prodstd_ancestor4; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor4 ON public.aeo_h_prodstd USING btree (ancestor4);


--
-- TOC entry 5811 (class 1259 OID 97070648)
-- Name: aeo_h_prodstd_ancestor5; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor5 ON public.aeo_h_prodstd USING btree (ancestor5);


--
-- TOC entry 5812 (class 1259 OID 97070649)
-- Name: aeo_h_prodstd_ancestor6; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor6 ON public.aeo_h_prodstd USING btree (ancestor6);


--
-- TOC entry 5813 (class 1259 OID 97070650)
-- Name: aeo_h_prodstd_ancestor7; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor7 ON public.aeo_h_prodstd USING btree (ancestor7);


--
-- TOC entry 5814 (class 1259 OID 97070651)
-- Name: aeo_h_prodstd_ancestor8; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_ancestor8 ON public.aeo_h_prodstd USING btree (ancestor8);


--
-- TOC entry 5815 (class 1259 OID 97070652)
-- Name: aeo_h_prodstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_prodstd_pkey ON public.aeo_h_prodstd USING btree (id);


--
-- TOC entry 5816 (class 1259 OID 97070653)
-- Name: aeo_h_prodstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_prodstd_record_state ON public.aeo_h_prodstd USING btree (record_state);


--
-- TOC entry 5817 (class 1259 OID 97070654)
-- Name: aeo_h_timeflrset_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timeflrset_ancestor0 ON public.aeo_h_timeflrset USING btree (ancestor0);


--
-- TOC entry 5818 (class 1259 OID 97070655)
-- Name: aeo_h_timeflrset_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timeflrset_ancestor1 ON public.aeo_h_timeflrset USING btree (ancestor1);


--
-- TOC entry 5819 (class 1259 OID 97070656)
-- Name: aeo_h_timeflrset_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_timeflrset_pkey ON public.aeo_h_timeflrset USING btree (id);


--
-- TOC entry 5820 (class 1259 OID 97070657)
-- Name: aeo_h_timeflrset_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timeflrset_record_state ON public.aeo_h_timeflrset USING btree (record_state);


--
-- TOC entry 5821 (class 1259 OID 97070658)
-- Name: aeo_h_timestd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timestd_ancestor0 ON public.aeo_h_timestd USING btree (ancestor0);


--
-- TOC entry 5822 (class 1259 OID 97070659)
-- Name: aeo_h_timestd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timestd_ancestor1 ON public.aeo_h_timestd USING btree (ancestor1);


--
-- TOC entry 5823 (class 1259 OID 97070660)
-- Name: aeo_h_timestd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timestd_ancestor2 ON public.aeo_h_timestd USING btree (ancestor2);


--
-- TOC entry 5824 (class 1259 OID 97070661)
-- Name: aeo_h_timestd_ancestor3; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timestd_ancestor3 ON public.aeo_h_timestd USING btree (ancestor3);


--
-- TOC entry 5825 (class 1259 OID 97070662)
-- Name: aeo_h_timestd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_h_timestd_pkey ON public.aeo_h_timestd USING btree (id);


--
-- TOC entry 5826 (class 1259 OID 97070663)
-- Name: aeo_h_timestd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_h_timestd_record_state ON public.aeo_h_timestd USING btree (record_state);


--
-- TOC entry 5829 (class 1259 OID 97070664)
-- Name: aeo_l_dclookup_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_l_dclookup_record_state ON public.aeo_l_dclookup USING btree (record_state);


--
-- TOC entry 5830 (class 1259 OID 97070665)
-- Name: aeo_ma_channelattributes_location; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_channelattributes_location ON public.aeo_ma_channelattributes USING btree (location);


--
-- TOC entry 5831 (class 1259 OID 97070666)
-- Name: aeo_ma_dptflrsetattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_dptflrsetattributes_record_state ON public.aeo_ma_dptflrsetattributes USING btree (record_state);


--
-- TOC entry 5832 (class 1259 OID 97070667)
-- Name: aeo_ma_imgattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_imgattributes_record_state ON public.aeo_ma_imgattributes USING btree (record_state);


--
-- TOC entry 5833 (class 1259 OID 97070668)
-- Name: aeo_ma_marketplaceattributes_location; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_marketplaceattributes_location ON public.aeo_ma_marketplaceattributes USING btree (location);


--
-- TOC entry 5834 (class 1259 OID 97070669)
-- Name: aeo_ma_sizeattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_sizeattributes_record_state ON public.aeo_ma_sizeattributes USING btree (record_state);


--
-- TOC entry 5835 (class 1259 OID 97070671)
-- Name: aeo_ma_storeattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_storeattributes_record_state ON public.aeo_ma_storeattributes USING btree (record_state);


--
-- TOC entry 5836 (class 1259 OID 97070672)
-- Name: aeo_ma_styleattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_styleattributes_record_state ON public.aeo_ma_styleattributes USING btree (record_state);


--
-- TOC entry 5837 (class 1259 OID 97070673)
-- Name: aeo_ma_stylecolorattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_stylecolorattributes_record_state ON public.aeo_ma_stylecolorattributes USING btree (record_state);


--
-- TOC entry 5838 (class 1259 OID 97070674)
-- Name: aeo_ma_weekattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_ma_weekattributes_record_state ON public.aeo_ma_weekattributes USING btree (record_state);


--
-- TOC entry 6043 (class 1259 OID 134295467)
-- Name: aeo_plan_these_cloned_style_stylecolors_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_plan_these_cloned_style_stylecolors_session_id_idx ON public.aeo_plan_these_cloned_style_stylecolors USING btree (session_id);


--
-- TOC entry 5839 (class 1259 OID 97070675)
-- Name: aeo_prodlife_view_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_prodlife_view_tbl_record_state ON public.aeo_prodlife_view_tbl USING btree (record_state);


--
-- TOC entry 5840 (class 1259 OID 97070676)
-- Name: aeo_serviceparams_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX aeo_serviceparams_pkey ON public.aeo_serviceparams USING btree (id);


--
-- TOC entry 5841 (class 1259 OID 97070677)
-- Name: aeo_serviceparams_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_serviceparams_record_state ON public.aeo_serviceparams USING btree (record_state);


--
-- TOC entry 5979 (class 1259 OID 134294464)
-- Name: aeo_stocking_locations_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_stocking_locations_tbl_record_state ON public.aeo_stocking_locations_tbl USING btree (record_state);


--
-- TOC entry 6048 (class 1259 OID 134295468)
-- Name: aeo_style_clone_stylecolor_size_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_style_clone_stylecolor_size_session_id_idx ON public.aeo_style_clone_stylecolor_size USING btree (session_id);


--
-- TOC entry 5842 (class 1259 OID 97070679)
-- Name: aeo_time_attributes_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX aeo_time_attributes_tbl_record_state ON public.aeo_time_attributes_tbl USING btree (record_state);


--
-- TOC entry 6050 (class 1259 OID 134305925)
-- Name: idx_aeo_l_sizeeligibility_ccrangecode; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_aeo_l_sizeeligibility_ccrangecode ON public.aeo_l_sizeeligibility_with_ccrangecode USING btree (ccrangecode);


--
-- TOC entry 6049 (class 1259 OID 134295465)
-- Name: idx_aeo_style_merge_reparent_session; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_aeo_style_merge_reparent_session ON public.aeo_style_merge_reparent USING btree (session_id);


--
-- TOC entry 6051 (class 1259 OID 134305926)
-- Name: idx_sizeeligibility_range_member_store; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_sizeeligibility_range_member_store ON public.aeo_l_sizeeligibility_with_ccrangecode USING btree (size_model_code, size_attribute) WHERE (store_ineligible = 1);


--
-- TOC entry 6052 (class 1259 OID 134305927)
-- Name: idx_sizeeligibility_range_member_web; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_sizeeligibility_range_member_web ON public.aeo_l_sizeeligibility_with_ccrangecode USING btree (size_model_code, size_attribute) WHERE (web_ineligible = 1);


--
-- TOC entry 6000 (class 1259 OID 134295466)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.aeo_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 5857 (class 1259 OID 97070680)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 5860 (class 1259 OID 97070681)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 6101 (class 2620 OID 134295569)
-- Name: aeo_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.store_eligibility_trigger();


--
-- TOC entry 6102 (class 2620 OID 134295573)
-- Name: aeo_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.dbt_wk >= new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 6103 (class 2620 OID 134295574)
-- Name: aeo_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((((new.relaunchweek IS NULL) AND (new.exitdate <= new.erlstmkdnwk)) OR ((new.relaunchweek IS NOT NULL) AND (new.exitdate <= new.erlstmkdnwk))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();


--
-- TOC entry 6104 (class 2620 OID 134295575)
-- Name: aeo_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((((new.relaunchweek IS NULL) AND ((new.erlstmkdnwk <= new.dbt_wk) OR (new.exitdate <= new.erlstmkdnwk))) OR ((new.relaunchweek IS NOT NULL) AND ((new.erlstmkdnwk <= new.relaunchweek) OR (new.exitdate <= new.erlstmkdnwk)))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.md_trigger_on_update_validity_check();


--
-- TOC entry 6094 (class 2620 OID 97070682)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 6136 (class 2620 OID 134667898)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 6131 (class 2620 OID 134295576)
-- Name: aeo_p_stylecolor_worklist on_publish_remove_from_worklist_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_publish_remove_from_worklist_trigger AFTER UPDATE ON public.aeo_p_stylecolor_worklist FOR EACH ROW WHEN (((new.in_worklist = (1)::double precision) AND (old.in_worklist = (0)::double precision))) EXECUTE FUNCTION public.on_publish_remove_from_worklist();

ALTER TABLE public.aeo_p_stylecolor_worklist DISABLE TRIGGER on_publish_remove_from_worklist_trigger;


--
-- TOC entry 6132 (class 2620 OID 134295577)
-- Name: aeo_p_stylecolor_worklist on_publish_remove_from_worklist_trigger_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_publish_remove_from_worklist_trigger_insert AFTER INSERT ON public.aeo_p_stylecolor_worklist FOR EACH ROW WHEN ((new.in_worklist = (1)::double precision)) EXECUTE FUNCTION public.on_publish_remove_from_worklist();

ALTER TABLE public.aeo_p_stylecolor_worklist DISABLE TRIGGER on_publish_remove_from_worklist_trigger_insert;


--
-- TOC entry 6133 (class 2620 OID 134295578)
-- Name: aeo_p_stylecolor_worklist on_unpublish_remove_from_worklist_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_unpublish_remove_from_worklist_trigger AFTER UPDATE ON public.aeo_p_stylecolor_worklist FOR EACH ROW WHEN (((new.in_worklist = (0)::double precision) AND (old.in_worklist = (1)::double precision))) EXECUTE FUNCTION public.on_unpublish_remove_from_worklist();

ALTER TABLE public.aeo_p_stylecolor_worklist DISABLE TRIGGER on_unpublish_remove_from_worklist_trigger;


--
-- TOC entry 6099 (class 2620 OID 134295582)
-- Name: aeo_p_dc_adj_size set_dc_ttluseradj_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_dc_ttluseradj_p_dc_adj_size BEFORE INSERT OR UPDATE ON public.aeo_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_dc_ttl_useradj();


--
-- TOC entry 6134 (class 2620 OID 134295585)
-- Name: aeo_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.aeo_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION public.trigger_set_indx_valid_values();


--
-- TOC entry 6095 (class 2620 OID 134295587)
-- Name: aeo_p_dc_adj set_pack_ind_flag; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_pack_ind_flag BEFORE INSERT OR UPDATE OF reason_code ON public.aeo_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_pack_ind_flag();


--
-- TOC entry 6116 (class 2620 OID 134295588)
-- Name: aeo_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.aeo_a_assortment FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6125 (class 2620 OID 134295589)
-- Name: aeo_p_casepack set_timestamp_cp_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish BEFORE UPDATE OF po_status ON public.aeo_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 6126 (class 2620 OID 134295590)
-- Name: aeo_p_casepack set_timestamp_cp_publish_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish_ins BEFORE INSERT ON public.aeo_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 6120 (class 2620 OID 134295591)
-- Name: aeo_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.aeo_p_channeloverride FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6096 (class 2620 OID 134295592)
-- Name: aeo_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.aeo_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6100 (class 2620 OID 134295593)
-- Name: aeo_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.aeo_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6097 (class 2620 OID 134295594)
-- Name: aeo_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.aeo_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 6098 (class 2620 OID 134295595)
-- Name: aeo_p_dc_adj set_timestamp_p_dc_publish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj_ins BEFORE INSERT ON public.aeo_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 6089 (class 2620 OID 134295596)
-- Name: aeo_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.aeo_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6090 (class 2620 OID 134295597)
-- Name: aeo_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.aeo_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6105 (class 2620 OID 134295598)
-- Name: aeo_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6092 (class 2620 OID 134295599)
-- Name: aeo_ma_stylecolorattributes set_timestamp_stylecolorattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_stylecolorattr BEFORE UPDATE ON public.aeo_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6135 (class 2620 OID 134295603)
-- Name: worklist_map trg_ai_worklist_map; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_ai_worklist_map AFTER INSERT ON public.worklist_map FOR EACH ROW EXECUTE FUNCTION public.trg_ins_stylecolor_alloc_attrs();


--
-- TOC entry 6106 (class 2620 OID 134295604)
-- Name: aeo_ma_stylecolorchannelattributes trg_cc_validsizes_on_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_cc_validsizes_on_change BEFORE UPDATE OF ccrangecode, use_valid_sizes_from, cc_size_eligibility_profile ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() < 2)) EXECUTE FUNCTION public.update_cc_validsizes_on_ccrangecode();


--
-- TOC entry 6127 (class 2620 OID 134295605)
-- Name: aeo_p_strategy_params trg_p_strategy_params_set_apply_targets; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_p_strategy_params_set_apply_targets BEFORE INSERT OR UPDATE ON public.aeo_p_strategy_params FOR EACH ROW EXECUTE FUNCTION public.trg_set_apply_targets_to_plan();


--
-- TOC entry 6107 (class 2620 OID 134295606)
-- Name: aeo_ma_stylecolorchannelattributes trg_set_floorset_fields_on_initrcptwk_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_floorset_fields_on_initrcptwk_change BEFORE INSERT OR UPDATE OF initrcptwk ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.set_floorset_fields_on_initrcptwk_change();


--
-- TOC entry 6123 (class 2620 OID 134295607)
-- Name: aeo_ma_departmentalloc_attributes trg_set_overflow_ok_when_scaling; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_overflow_ok_when_scaling BEFORE UPDATE ON public.aeo_ma_departmentalloc_attributes FOR EACH ROW EXECUTE FUNCTION public.trg_allow_scaling_set_overflow_ok();


--
-- TOC entry 6124 (class 2620 OID 134295608)
-- Name: aeo_ma_stylecolor_alloc_attributes trg_set_sclr_overflow_ok_when_scaling; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_sclr_overflow_ok_when_scaling BEFORE UPDATE ON public.aeo_ma_stylecolor_alloc_attributes FOR EACH ROW EXECUTE FUNCTION public.trg_sclr_allow_scaling_set_overflow_ok();


--
-- TOC entry 6129 (class 2620 OID 134295609)
-- Name: aeo_p_stylecolor_store_worklist trg_sync_alloc_and_override_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_sync_alloc_and_override_trigger BEFORE INSERT OR UPDATE ON public.aeo_p_stylecolor_store_worklist FOR EACH ROW EXECUTE FUNCTION public.trg_sync_alloc_and_override();

ALTER TABLE public.aeo_p_stylecolor_store_worklist DISABLE TRIGGER trg_sync_alloc_and_override_trigger;


--
-- TOC entry 6117 (class 2620 OID 134295616)
-- Name: aeo_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF str_grade, str_climate, str_region_combo, str_hvlc, str_tourist_border_combo, ssg, str_grade_or, str_climate_or, str_region_combo_or, str_hvlc_or, str_tourist_border_combo_or ON public.aeo_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.propagate_assortment_to_floorsets();


--
-- TOC entry 6130 (class 2620 OID 134295617)
-- Name: aeo_p_stylecolor_store_worklist trg_update_alloc_qty; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_alloc_qty BEFORE INSERT OR UPDATE ON public.aeo_p_stylecolor_store_worklist FOR EACH ROW EXECUTE FUNCTION public.trg_sum_override_array();

ALTER TABLE public.aeo_p_stylecolor_store_worklist DISABLE TRIGGER trg_update_alloc_qty;


--
-- TOC entry 6128 (class 2620 OID 134295618)
-- Name: aeo_p_stylecolor_store_eligibility trg_update_eligibility_from_null_to_zero; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_eligibility_from_null_to_zero AFTER UPDATE OF sclr_str_eligibility ON public.aeo_p_stylecolor_store_eligibility FOR EACH ROW WHEN (((new.sclr_str_eligibility IS NULL) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.update_eligibility_from_null_to_zero();


--
-- TOC entry 6093 (class 2620 OID 134295619)
-- Name: aeo_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER UPDATE OF cccolor ON public.aeo_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_color_change();


--
-- TOC entry 6121 (class 2620 OID 134295620)
-- Name: cart_params trigger_cartparams_irw_debut_offset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_irw_debut_offset BEFORE UPDATE OF dbt_wk ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_irw_debut_offset();


--
-- TOC entry 6122 (class 2620 OID 134295621)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_ranging();


--
-- TOC entry 6108 (class 2620 OID 134295622)
-- Name: aeo_ma_stylecolorchannelattributes trigger_cost; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cost AFTER UPDATE OF cc_plan_cost ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_final_cost();


--
-- TOC entry 6118 (class 2620 OID 134295623)
-- Name: aeo_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.aeo_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.update_eff_aur();


--
-- TOC entry 6109 (class 2620 OID 134295624)
-- Name: aeo_ma_stylecolorchannelattributes trigger_for_time_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx AFTER INSERT OR UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 6110 (class 2620 OID 134295625)
-- Name: aeo_ma_stylecolorchannelattributes trigger_for_time_indx_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_insert AFTER INSERT ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 6111 (class 2620 OID 134295626)
-- Name: aeo_ma_stylecolorchannelattributes trigger_for_time_indx_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_update AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 6119 (class 2620 OID 134295630)
-- Name: aeo_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.aeo_p_itemprice FOR EACH ROW EXECUTE FUNCTION public.itemprice_fetchdepartment();


--
-- TOC entry 6112 (class 2620 OID 134295631)
-- Name: aeo_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.lifecycle_plan_update();


--
-- TOC entry 6113 (class 2620 OID 134295632)
-- Name: aeo_ma_stylecolorchannelattributes trigger_remove_from_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_remove_from_assortment AFTER UPDATE OF record_state ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((new.record_state = 1)) EXECUTE FUNCTION public.remove_from_assortment();


--
-- TOC entry 6114 (class 2620 OID 134295633)
-- Name: aeo_ma_stylecolorchannelattributes trigger_sizerangecode_isvalid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_isvalid AFTER UPDATE OF validsizes ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_isvalid();


--
-- TOC entry 6115 (class 2620 OID 134295634)
-- Name: aeo_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.aeo_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_validsizes_members();


--
-- TOC entry 6087 (class 2620 OID 134295635)
-- Name: aeo_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.aeo_d_product FOR EACH ROW WHEN ((new.levelid = 'style'::text)) EXECUTE FUNCTION public.update_name_description();


--
-- TOC entry 6091 (class 2620 OID 134295636)
-- Name: aeo_ma_styleattributes update_ccrangecode; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccrangecode AFTER UPDATE OF sty_size_range ON public.aeo_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_stylecolorchannelattributes_ccrangecode();


--
-- TOC entry 6088 (class 2620 OID 134295643)
-- Name: aeo_h_prodstd update_ccsizerange_after_class_change_ancestor1; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccsizerange_after_class_change_ancestor1 AFTER UPDATE OF ancestor1 ON public.aeo_h_prodstd FOR EACH ROW WHEN (((new.ancestor1 ~~ 'CL-%'::text) AND (new.ancestor1 IS DISTINCT FROM old.ancestor1))) EXECUTE FUNCTION public.update_ccrangecode_on_class_change();


--
-- TOC entry 6064 (class 2606 OID 108253443)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp.dimensions(id);


--
-- TOC entry 6065 (class 2606 OID 108253438)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp.dimensions(id);


--
-- TOC entry 6066 (class 2606 OID 108253627)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp.dimensions(id);


--
-- TOC entry 6068 (class 2606 OID 108253645)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp.plans(id) ON DELETE CASCADE;


--
-- TOC entry 6069 (class 2606 OID 108253695)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp.plans(id);


--
-- TOC entry 6067 (class 2606 OID 108253622)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp.dimensions(id);


--
-- TOC entry 6070 (class 2606 OID 108253807)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp_channel_plan.dimensions(id);


--
-- TOC entry 6071 (class 2606 OID 108253802)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp_channel_plan.dimensions(id);


--
-- TOC entry 6072 (class 2606 OID 108253988)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp_channel_plan.dimensions(id);


--
-- TOC entry 6074 (class 2606 OID 108254009)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp_channel_plan.plans(id) ON DELETE CASCADE;


--
-- TOC entry 6075 (class 2606 OID 108254059)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp_channel_plan.plans(id);


--
-- TOC entry 6073 (class 2606 OID 108253983)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_channel_plan; Owner: psql
--

ALTER TABLE ONLY mfp_channel_plan.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp_channel_plan.dimensions(id);


--
-- TOC entry 6076 (class 2606 OID 108254175)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp_long_range.dimensions(id);


--
-- TOC entry 6077 (class 2606 OID 108254170)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp_long_range.dimensions(id);


--
-- TOC entry 6078 (class 2606 OID 108254356)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp_long_range.dimensions(id);


--
-- TOC entry 6080 (class 2606 OID 108254374)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp_long_range.plans(id) ON DELETE CASCADE;


--
-- TOC entry 6081 (class 2606 OID 108254424)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp_long_range.plans(id);


--
-- TOC entry 6079 (class 2606 OID 108254351)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_long_range; Owner: psql
--

ALTER TABLE ONLY mfp_long_range.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp_long_range.dimensions(id);


--
-- TOC entry 6082 (class 2606 OID 108297614)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp_total_aeo.dimensions(id);


--
-- TOC entry 6084 (class 2606 OID 108254736)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp_total_aeo.plans(id) ON DELETE CASCADE;


--
-- TOC entry 6085 (class 2606 OID 108254786)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp_total_aeo.plans(id);


--
-- TOC entry 6083 (class 2606 OID 108297609)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_total_aeo; Owner: psql
--

ALTER TABLE ONLY mfp_total_aeo.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp_total_aeo.dimensions(id);


--
-- TOC entry 6063 (class 2606 OID 97070684)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 6061 (class 2606 OID 97070699)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.agent_conversations(conversation_id);


--
-- TOC entry 6062 (class 2606 OID 97070704)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES public.allocation_plan_queue(jobid);


--
-- TOC entry 6086 (class 2606 OID 134667904)
-- Name: undo_modifications fk_undoModifications_undoLog; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT "fk_undoModifications_undoLog" FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 6307 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:09:38 IST

--
-- PostgreSQL database dump complete
--

\unrestrict hgf3LhGEFUb6KmNHrP833t3hiIWIp9iGbrrNqn4uge4NwLSBQMAMlV21MhhR8te

