-- ENV: QA | DB: gap | dumped: 2026-10-01 15:06 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict 7XyGJKdxdWDi14EnHtDK2cG4m0wtRgi5ta7yLc2hwwxg2drj6BUVYHMOOSIDiK9

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:06:38 IST

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
-- TOC entry 18 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 16 (class 2615 OID 134584946)
-- Name: target_setting; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA target_setting;


ALTER SCHEMA target_setting OWNER TO psql;

--
-- TOC entry 17 (class 2615 OID 134584947)
-- Name: target_setting_bkup; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA target_setting_bkup;


ALTER SCHEMA target_setting_bkup OWNER TO psql;

--
-- TOC entry 2 (class 3079 OID 103521302)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 6146 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1157 (class 1247 OID 134584949)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 1160 (class 1247 OID 134584956)
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
-- TOC entry 1163 (class 1247 OID 134584968)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 1166 (class 1247 OID 134584974)
-- Name: approval; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE target_setting.approval OWNER TO psql;

--
-- TOC entry 1169 (class 1247 OID 134584980)
-- Name: permission; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE target_setting.permission OWNER TO psql;

--
-- TOC entry 1172 (class 1247 OID 134584988)
-- Name: scopetype; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE target_setting.scopetype OWNER TO psql;

--
-- TOC entry 483 (class 1255 OID 134585003)
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
    from gap_h_prodstd b
    where
    b.id = a.incoming_style_id
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from gap_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from gap_d_product b
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
    (select lookup_value as cccolor, target_value color_description from gap_l_dependencylookup where target_id = ''color_description'' and lookup_id = ''cccolor'') b,
    (select lookup_value as cccolor, target_value color_code from gap_l_dependencylookup where target_id = ''color_code'' and lookup_id = ''cccolor'') c
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
                 , gap_ma_styleattributes c
                 , gap_l_dependencylookup d
                 , gap_size_range_mapping e
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
                 , gap_ma_sizeattributes b
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
(select distinct product,location  from gap_ma_stylecolorchannelattributes where record_state = 0 and (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from gap_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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

s8 := 'delete from gap_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';


s9 := '
    INSERT INTO gap_d_product
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
delete from gap_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s11 := '
    INSERT INTO gap_d_product
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
delete from gap_d_product where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s13 := '
    INSERT INTO gap_d_product
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
delete from gap_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s15 := '
INSERT INTO gap_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from gap_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
'
;



s16 := '
delete from gap_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO gap_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from gap_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
'
;



s18 := '
delete from gap_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO gap_h_prodstd
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
gap_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s20 := '
delete from gap_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from gap_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''cccolorfamily'' and lookup_value=a.cccolor
';

s21_1 := '
update '||table_cart_master_temp||' a set cccolorid = b.target_value from gap_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_id'' and lookup_value=a.cccolor
';

s21_2 := '
update '||table_cart_master_temp||' a set color_name = b.target_value from gap_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_description'' and lookup_value=a.cccolor
';

s21_3 := '
update '||table_cart_master_temp||' a set cc_color_group = b.target_value from gap_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_group'' and lookup_value=a.cccolor
';

s21_4 := '
update '||table_cart_master_temp||' a set cc_color_code = b.target_value from gap_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''color_code'' and lookup_value=a.cccolor
';


s22 := '
delete from gap_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s23 := '
delete from gap_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';





s24 := '
insert into gap_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


s25 := '
insert into gap_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


-- STYLE ATTRIBUTES

S26 := '
INSERT INTO gap_ma_styleattributes
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
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name from '||table_cart_master_temp||') a, gap_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
';


s26_X := '
Update gap_ma_styleattributes b
set sty_is_locked = ''Y'', sty_s5_adopted = ''Y''
from (select distinct final_style_id, style_type, stylecolor_type, incoming_style_id  from '||table_cart_master_temp||') a
where a.incoming_style_id=b.product
and a.style_type=''existing'' and a.stylecolor_type=''existing''
';


-- STYLECOLOR ATTRIBUTES

s27 := '
delete from gap_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



s28 := '
INSERT INTO gap_ma_stylecolorattributes
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
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily,cccolorid,color_name,cc_color_desc,cc_color_group,cc_color_code, stylecolor_name, style_name  from '||table_cart_master_temp||') a, gap_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
';


s28_X := '
Update gap_ma_stylecolorattributes b
set isassortment = ''true'', cc_is_locked = ''Y'', cc_s5_adopted = ''Y''
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily  from '||table_cart_master_temp||') a
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
';

/*
s28_X1 := '
Update gap_ma_stylecolorattributes b
set cc_price_band = a.price_band
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, usd_ticket_price, price_band  from '||table_cart_master_temp||' x, gap_h_prodstd z, gap_l_ticketprice y where x.final_stylecolor_id = z.id and z.ancestor3 = y.product) a
where a.final_stylecolor_id=b.product
and b.cc_orig_unit_retail = a.usd_ticket_price
and a.stylecolor_type=''similar''
';

s28_X2 := '
Update gap_ma_stylecolorattributes b
set cc_good_better_best = a.price_band
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, subclass_id, ticket_price_min, ticket_price_max, price_band  from '||table_cart_master_temp||' x, gap_l_pricebandlookup y where x.subclass_id = y.product) a
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
from gap_specimages si
 inner join
gap_ma_stylecolorattributes sa
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
  (select distinct product, img from gap_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, stylecolor_id from '||table_spec_img||') d
on
d.stylecolor_id = c.final_stylecolor_id;

'
;


s31 := '
delete from gap_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;

s32 := '
insert into gap_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES

s33 := '
delete from gap_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';



s34 := '
insert into gap_ma_sizeattributes
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

  , c.default_ccdiscountpct_ecom
  , c.default_ccdiscountpct_store_cad
  , c.default_ccdiscountpct_ecom_cad

from (select distinct * from cart_params) a, gap_ma_dptflrsetattributes c, '||table_input_t1||' b
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

  , b.ccticketpricechannel_ecom_us
  , b.ccticketpricechannel_store_cad
  , b.ccticketpricechannel_ecom_cad

  , a.default_ccdiscountpct_ecom
  , a.default_ccdiscountpct_store_cad
  , a.default_ccdiscountpct_ecom_cad

  , coalesce(b.cc_plan_cost_ecom_us, .01::real) as cc_plan_cost_ecom_us
  , coalesce(b.cc_plan_cost_store_cad, .01::real) as cc_plan_cost_store_cad
  , coalesce(b.cc_plan_cost_ecom_cad, .01::real) as cc_plan_cost_ecom_cad

FROM
'||table_default_cart_params||' a, gap_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||' where style_type = ''similar'') c,
 gap_ma_stylecolorattributes d, gap_ma_stylecolorattributes e
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

  , e.ccticketpricechannel_ecom_us
  , e.ccticketpricechannel_store_cad
  , e.ccticketpricechannel_ecom_cad

  , a.default_ccdiscountpct_ecom
  , a.default_ccdiscountpct_store_cad
  , a.default_ccdiscountpct_ecom_cad

  , e.cc_plan_cost_ecom_us
  , e.cc_plan_cost_store_cad
  , e.cc_plan_cost_ecom_cad
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id, style_type from '||table_cart_master_temp||' where style_type = ''existing'') b,
gap_ma_styleattributes c,
gap_ma_stylecolorattributes d,
gap_ma_stylecolorchannelattributes e
--(select array_agg(target_value) as validsizes, lookup_value as sty_size_run_name from gap_l_dependencylookup where lookup_id = ''size_range'' group by lookup_value) e
where a.jsessionid=b.jsessionid
and b.final_style_id = c.product
and b.final_stylecolor_id = d.product
and b.incoming_stylecolor_id = e.product
and a.scope_location = e.location
--and c.sty_size_range = e.sty_size_run_name
'
;



s37 := '
delete from gap_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into gap_ma_stylecolorchannelattributes (
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

  , ccticketpricechannel_ecom_us
  , ccticketpricechannel_store_cad
  , ccticketpricechannel_ecom_cad

  , cc_discount_pct_ecom_us
  , cc_discount_pct_store_cad
  , cc_discount_pct_ecom_cad

  , cc_plan_cost_ecom_us
  , cc_plan_cost_store_cad
  , cc_plan_cost_ecom_cad

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
  , coalesce(cc_orig_unit_retail_store_cad, cc_orig_unit_retail)
  , coalesce(cc_orig_unit_retail_ecom_us, cc_orig_unit_retail)
  , coalesce(cc_orig_unit_retail_ecom_cad, cc_orig_unit_retail)

  , coalesce(ccticketpricechannel_ecom_us,ccticketpricechannel)
  , coalesce(ccticketpricechannel_store_cad,ccticketpricechannel)
  , coalesce(ccticketpricechannel_ecom_cad,ccticketpricechannel)

  , coalesce(default_ccdiscountpct_ecom, default_ccdiscountpct)
  , coalesce(default_ccdiscountpct_store_cad, default_ccdiscountpct)
  , coalesce(default_ccdiscountpct_ecom_cad, default_ccdiscountpct)

  , coalesce(cc_plan_cost_ecom_us, cc_plan_cost)
  , coalesce(cc_plan_cost_store_cad, cc_plan_cost)
  , coalesce(cc_plan_cost_ecom_cad, cc_plan_cost)
FROM
 '||table_temp_sclr_chnl_attr||' a,
(select b.id, ap_start, ap_end, irw_debut_offset
      from gap_ma_dptflrsetattributes a, gap_h_prodstd b
      where b.ancestor3 = a.product and b.id in (select product from '||table_temp_sclr_chnl_attr||')
     ) b
where a.product = b.id
and a.dbt_wk between ap_start and ap_end;
 ';




-- ASSORTMENT MODEL

s51 := '
update gap_ma_stylecolorchannelattributes a
set plan_current = v_plan_current,
    ccrangecode = d.ccrangecode,
    use_valid_sizes_from = d.use_valid_sizes_from
from (select value as v_plan_current from gap_serviceparams where id=''plan_current'') b,
     gap_ma_stylecolorattributes c, (select product, ccrangecode, use_valid_sizes_from from '||table_temp_sclr_chnl_attr||') d
where (a.product, a.location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product = c.product
and a.product = d.product
';

/*
-- When adding a color to an exsting style, we will take the max of various attributes and cost for the parent style and apply them to the newly added stylecolor
s51_1 := '
update gap_ma_stylecolorchannelattributes a
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
    gap_ma_styleattributes x,
    gap_h_prodstd y,
    gap_ma_stylecolorattributes d,
    (
      select distinct final_stylecolor_id, final_style_id, style_type
      from  '||table_cart_master_temp||'
      where jsessionid in (select jsid from  '||table_input_t1||') and style_type = ''existing''
    ) z,
    (
      select a.ancestor0, max(b.cc_validsizes_store) as cc_validsizes_store_existing, max(b.cc_validsizes_ecom) as cc_validsizes_ecom_existing, max(b.cc_ordpolicy) as cc_ordpolicy_existing,
             max(b.cc_ordermultiple) as cc_ordermultiple_existing, max(b.cc_existingwac) as cc_existingwac_existing, max(b.cc_systemcost) as cc_systemcost_existing, max(b.cc_plan_cost) as cc_plan_cost_existing,
             max(b.cc_landed_cost) as cc_landed_cost_existing, max(b.cc_target_cost) as cc_target_cost_existing
      from gap_h_prodstd a
      join gap_ma_stylecolorchannelattributes b
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
        -- V4.5: seed the eight floorset price/cost columns from scch.
        -- Nothing in this function is an UPDATE, so neither trg_upd_scch_pricing
        -- nor trg_upd_assortment_pricing fires anywhere on this path: s37/s38 and
        -- s40/s41 are DELETE + INSERT. Without this seeding the columns stay NULL.
        -- Source is gap_ma_stylecolorchannelattributes, already rebuilt by s38
        -- above, so it is authoritative here and is also what
        -- v4_5_reconciliation.sql compares against - seeding from it makes the
        -- invariant true by construction. Every floorset row for a product gets
        -- the same value, so MAX = MIN and the eight _enabled flags stay 0,
        -- which is what s38 leaves them at by DEFAULT.
        -- V4.6 seed rule: COPY WHAT SCCH ACTUALLY HAS, invent nothing.
        --   * a real scch value (including a channel-specific one) is copied
        --     straight through - most rows DO have real ecom/cad prices, and
        --     dropping them would make the floorset grid show the base price
        --     for CAD instead of the real CAD price;
        --   * NULL stays NULL, which is the inheritance marker - the UI resolves
        --     COALESCE(variant, base) and the trigger materialises on first edit;
        --   * a SENTINEL (0 or the 0.01 floor) is mapped to NULL rather than
        --     copied. 1,294 of 4,376 scch rows carry cc_plan_cost = 0, which
        --     already makes cc_imupct read as 100% margin; copying it into eight
        --     more columns would make a placeholder look like data.
        , CASE WHEN e.ccticketpricechannel           > 0.01 THEN e.ccticketpricechannel           END as cc_ticketprice_flrset
        , CASE WHEN e.ccticketpricechannel_ecom_us   > 0.01 THEN e.ccticketpricechannel_ecom_us   END as cc_ticketprice_flrset_ecom_us
        , CASE WHEN e.ccticketpricechannel_store_cad > 0.01 THEN e.ccticketpricechannel_store_cad END as cc_ticketprice_flrset_store_cad
        , CASE WHEN e.ccticketpricechannel_ecom_cad  > 0.01 THEN e.ccticketpricechannel_ecom_cad  END as cc_ticketprice_flrset_ecom_cad
        , CASE WHEN e.cc_plan_cost                   > 0.01 THEN e.cc_plan_cost                   END as cc_plan_cost_flrset
        , CASE WHEN e.cc_plan_cost_ecom_us           > 0.01 THEN e.cc_plan_cost_ecom_us           END as cc_plan_cost_flrset_ecom_us
        , CASE WHEN e.cc_plan_cost_store_cad         > 0.01 THEN e.cc_plan_cost_store_cad         END as cc_plan_cost_flrset_store_cad
        , CASE WHEN e.cc_plan_cost_ecom_cad          > 0.01 THEN e.cc_plan_cost_ecom_cad          END as cc_plan_cost_flrset_ecom_cad
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c,
    gap_ma_stylecolorattributes d
    -- LEFT JOIN LATERAL, deliberately, not an inner join. An inner join would
    -- DROP any assortment row whose scch row is missing, silently changing what
    -- this function creates. This way a missing scch row yields NULLs in the
    -- eight columns and the assortment row is still produced, so the row set is
    -- byte-identical to the pre-v4.5 behaviour.
    LEFT JOIN LATERAL (
        SELECT z.ccticketpricechannel, z.ccticketpricechannel_ecom_us,
               z.ccticketpricechannel_store_cad, z.ccticketpricechannel_ecom_cad,
               z.cc_plan_cost, z.cc_plan_cost_ecom_us,
               z.cc_plan_cost_store_cad, z.cc_plan_cost_ecom_cad
          FROM gap_ma_stylecolorchannelattributes z
         WHERE z.product  = c.final_stylecolor_id
           AND z.location = a.scope_location
         LIMIT 1
    ) e ON TRUE
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
delete from gap_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';

s41 := '

    insert into gap_a_assortment (
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
        -- V4.5: seeded from scch in s39; see the note there.
        , cc_ticketprice_flrset
        , cc_ticketprice_flrset_ecom_us
        , cc_ticketprice_flrset_store_cad
        , cc_ticketprice_flrset_ecom_cad
        , cc_plan_cost_flrset
        , cc_plan_cost_flrset_ecom_us
        , cc_plan_cost_flrset_store_cad
        , cc_plan_cost_flrset_ecom_cad)
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
        , cc_ticketprice_flrset
        , cc_ticketprice_flrset_ecom_us
        , cc_ticketprice_flrset_store_cad
        , cc_ticketprice_flrset_ecom_cad
        , cc_plan_cost_flrset
        , cc_plan_cost_flrset_ecom_us
        , cc_plan_cost_flrset_store_cad
        , cc_plan_cost_flrset_ecom_cad
    FROM
       '||table_temp_assort||'
';



RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

s42 := '
create temporary table '||table_final_list||' AS
select distinct a.product, a.location
from
(select distinct product,location  from gap_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from gap_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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
          FROM gap_ma_stylecolorchannelattributes AS a
          , gap_d_time AS b
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
              FROM gap_h_prodstd
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
            (select a.* from '||tst_df_with_style||' a, gap_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.ccticketpricechannel::real, curp=ccticketpricechannel::real
          from gap_ma_stylecolorchannelattributes b
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
          from gap_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff
          from gap_p_itemprice b
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
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, gap_d_time b, gap_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from gap_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from gap_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from gap_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from gap_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from gap_ma_weekattributes b where a.time=b.time';


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
              FROM (select * from gap_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM gap_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM gap_ma_dptflrsetattributes AS a
              , gap_d_time AS b
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
          WHERE time >= (select value from gap_serviceparams where id=''plan_current'')
          AND time <= (select value from gap_serviceparams where id=''plan_end'')
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


s114 := 'delete from gap_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into gap_an_price_storecount_info
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
-- TOC entry 484 (class 1255 OID 134585005)
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
-- TOC entry 499 (class 1255 OID 134585006)
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
      (select slsstart from gap_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_climate)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_region_combo)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_hvlc)), ','), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.str_tourist_border_combo)), ','), 
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM gap_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 500 (class 1255 OID 134585007)
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
  scWeekCount_pub = (select COUNT(*) from gap_p_dc_adj 
   where product = stylecolorId 
   --and location = (select dc from gap_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from gap_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from gap_p_dc_adj_size
   where product in (select id from gap_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from gap_l_dclookup where channel = channelId)
   and (dc_onorder > 0 or dc_onorder_ecom > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 501 (class 1255 OID 134585008)
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
  FROM gap_ma_stylecolorattributes a
  JOIN gap_h_prodstd b ON a.product = b.id
  JOIN gap_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, cc_validsizes_store, cc_validsizes_ecom
                   from gap_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  where a.product = stylecolorid
  ;
*/
  return v_isprepublishable;
 END;
$$;


ALTER FUNCTION public.check_isprepublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 502 (class 1255 OID 134585009)
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
  FROM gap_ma_stylecolorattributes a
  JOIN gap_h_prodstd b ON a.product = b.id
  JOIN gap_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, cc_validsizes_store, cc_validsizes_ecom
                   from gap_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  where a.product = stylecolorid
  ;
*/

  return v_ispublishable;
 END;
$$;


ALTER FUNCTION public.check_ispublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 503 (class 1255 OID 134585010)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from gap_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 504 (class 1255 OID 134585011)
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


delete from gap_ma_stylecolorattributes where product in (v_uid);
delete from gap_ma_stylecolorchannelattributes where product in (v_uid);
delete from gap_a_assortment where product in (v_uid);
delete from gap_ma_sizeattributes where product in (Select id from gap_h_prodstd where ancestor0 in (v_uid));
delete from gap_p_dc_adj where product in (v_uid);
delete from gap_p_dc_adj_size where product in (Select id from gap_h_prodstd where ancestor0 in (v_uid));
delete from gap_p_itemprice where product in (v_uid);
delete from gap_p_channeloverride where product in (v_uid);


delete from gap_d_product where id in (v_uid);
delete from gap_d_product where id in (Select ancestor0 from gap_h_prodstd where id in (v_uid));
delete from gap_h_prodstd where id in (v_uid);
delete from gap_h_prodstd where ancestor0 in (v_uid);


END;
$$;


ALTER PROCEDURE public.delete_records(IN v_uid text) OWNER TO psql;

--
-- TOC entry 505 (class 1255 OID 134585012)
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
-- TOC entry 506 (class 1255 OID 134585013)
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
 from gap_h_prodstd where id = productId;

 select ancestor1 into subclass_var
 from gap_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from gap_ma_dptflrsetattributes a
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
            gap_l_storelookup
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
            gap_l_storelookup
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
-- TOC entry 507 (class 1255 OID 134585014)
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
 from gap_h_prodstd where id = productId;

 select ancestor1 into subclass_var
 from gap_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from gap_ma_dptflrsetattributes a
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
-- TOC entry 508 (class 1255 OID 134585015)
-- Name: gap_no_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.gap_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE gap_style_clone_flat_map_temp AS
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
        FROM gap_style_clone_stylecolor_size
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
        FROM gap_style_clone_stylecolor_size
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
        FROM gap_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO gap_d_product (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_d_product b
        WHERE a.from_id = b.id
        ;

/*
    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

*/
    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
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
    
        INSERT INTO gap_ma_styleattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
*/   
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_stylecolorattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_sizeattributes (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_stylecolorchannelattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_imgattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_itemprice (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_channeloverride (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_a_assortment (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_dc_adj (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_dc_adj_size (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO gap_an_price_storecount_info (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
/*
        INSERT INTO gap_l_dependencylookup (
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
        FROM gap_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';
*/

        INSERT INTO gap_l_dependencylookup (
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
        FROM gap_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';


-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS gap_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.gap_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 509 (class 1255 OID 134585017)
-- Name: gap_plan_these_cloned_style_stylecolors_proc(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.gap_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text)
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
    FROM gap_plan_these_cloned_style_stylecolors
    WHERE updated_by = v_pivot_user_id
      AND picked_for_planning = 0
    ;

    UPDATE
        gap_style_clone_stylecolor_size
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
        gap_style_clone_stylecolor_size s
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
        gap_style_clone_stylecolor_size s
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
        gap_style_clone_stylecolor_size s
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
    DELETE FROM gap_style_clone_stylecolor_size a 
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
    delete from gap_d_product where id in (select distinct product from all_un_used_products);

    delete from gap_h_prodstd where id in (select distinct product from all_un_used_products);
   
    delete from gap_a_assortment where product in (select distinct product from all_un_used_products);

    delete from gap_ma_styleattributes where product in (select distinct product from all_un_used_products);

    delete from gap_ma_stylecolorattributes where product in (select distinct product from all_un_used_products);

    delete from gap_ma_sizeattributes where product in (select distinct product from all_un_used_products);

    delete from gap_ma_imgattributes where product in (select distinct product from all_un_used_products);

    delete from gap_p_dc_adj where product in (select distinct product from all_un_used_products);

    delete from gap_p_dc_adj_size where product in (select distinct product from all_un_used_products);

    delete from gap_p_itemprice where product in (select distinct product from all_un_used_products);

    delete from gap_p_channeloverride where product in (select distinct product from all_un_used_products);

    delete from gap_an_price_storecount_info where product in (select distinct product from all_un_used_products);
    */


    -- --------------------------------------------------------------------------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW, SIMULATING REMOVE FROM ASSORTMENT, LIKELY DATA EXISTS IN CLICKHOUSE
    -- --------------------------------------------------------------------------------------------------------
    DELETE FROM gap_a_assortment 
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products);

    UPDATE gap_ma_stylecolorchannelattributes
    SET record_state = 1
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products WHERE levelid = 'stylecolor')
    ;

    UPDATE gap_ma_stylecolorchannelattributes
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
        tmp_selected a, gap_ma_stylecolorchannelattributes b where a.stylecolor = b.product
    ;


    ------------------------------------
    -- UPDATE picked_for_planning FLAG
    -- ------------------------------------
    UPDATE 
        gap_plan_these_cloned_style_stylecolors 
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


ALTER PROCEDURE public.gap_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 510 (class 1255 OID 134585018)
-- Name: gap_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.gap_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE gap_style_clone_flat_map_temp AS
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
        FROM gap_style_clone_stylecolor_size
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
        FROM gap_style_clone_stylecolor_size
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
        FROM gap_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO gap_d_product (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_d_product b
        WHERE a.from_id = b.id
        ;


    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_h_prodstd (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_styleattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_stylecolorattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_sizeattributes (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_stylecolorchannelattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_ma_imgattributes (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_itemprice (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_channeloverride (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_a_assortment (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
        INSERT INTO gap_p_dc_adj (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO gap_p_dc_adj_size (
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
        FROM gap_style_clone_stylecolor_size a,
             gap_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO gap_an_price_storecount_info (
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
        FROM gap_style_clone_flat_map_temp a,
             gap_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;



    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO gap_l_dependencylookup (
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
        FROM gap_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';


        INSERT INTO gap_l_dependencylookup (
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
        FROM gap_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';


-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS gap_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.gap_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 511 (class 1255 OID 134585020)
-- Name: gap_style_clone_stylecolor_size_proc_dummy(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.gap_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text)
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


ALTER PROCEDURE public.gap_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 512 (class 1255 OID 134585021)
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
          , cc_addoff_ecom_cad
          , cc_addoff_store_cad
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
          , 0.1::real as cc_addoff_ecom_cad
          , 0.1::real as cc_addoff_store_cad
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
          gap_ma_dptflrsetattributes a,
          gap_d_time b,
          gap_d_time c,
          gap_d_time d,
          gap_d_time e,
          gap_d_time f
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
  FROM gap_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from gap_serviceparams where id=''plan_current'') c,
   (select value as plan_end from gap_serviceparams where id=''plan_end'') d,
   gap_l_ssglookup e
  where
  b.jsessionid = '''||$1||'''
  and b.scope_product = '''||$2||'''
  and b.scope_location = '''||$3||'''
  and a.product = b.scope_product
          -- CHANGED BY CA ON 08.12.2026
          -- and a.ap_start <= least(d.plan_end,b.exitdate) and a.ap_end > greatest(b.dbt_wk,c.plan_current)

          -- V4.6: window aligned to store_eligibility_trigger.
          --   trigger: ap_start <= exitdate
          --            ap_end   >= coalesce(relaunchweek, least(initrcptwk, dbt_wk))
          -- initrcptwk is irw_debut_offset weeks before debut, so least() is always
          -- initrcptwk and the range now covers the receipt period. The plan_current /
          -- plan_end clamp is gone: the trigger has no clamp, and it already creates
          -- those rows on the first lifecycle date edit. relaunchweek is not a
          -- cart_params column and a new placeholder has none, so the coalesce
          -- collapses; add it here if that column is ever introduced.

  and a.ap_start <= least(d.plan_end,b.exitdate)
  and a.ap_end   >= greatest(least(b.initrcptwk, b.dbt_wk),c.plan_current)

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
-- TOC entry 513 (class 1255 OID 134585023)
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
            gap_l_storelookup
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
-- TOC entry 514 (class 1255 OID 134585024)
-- Name: guard_scch_pricing_edits(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.guard_scch_pricing_edits() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_reverted text := NULL;
BEGIN
    IF NEW.ccticketpricechannel IS DISTINCT FROM OLD.ccticketpricechannel
       AND COALESCE(NEW.cc_ticketprice_flrset_enabled, 0) = 1
    THEN
        NEW.ccticketpricechannel := OLD.ccticketpricechannel;
        v_reverted := concat_ws(', ', v_reverted, 'ccticketpricechannel');
    END IF;

    IF NEW.ccticketpricechannel_ecom_us IS DISTINCT FROM OLD.ccticketpricechannel_ecom_us
       AND COALESCE(NEW.cc_ticketprice_flrset_ecom_us_enabled, 0) = 1
    THEN
        NEW.ccticketpricechannel_ecom_us := OLD.ccticketpricechannel_ecom_us;
        v_reverted := concat_ws(', ', v_reverted, 'ccticketpricechannel_ecom_us');
    END IF;

    IF NEW.ccticketpricechannel_store_cad IS DISTINCT FROM OLD.ccticketpricechannel_store_cad
       AND COALESCE(NEW.cc_ticketprice_flrset_store_cad_enabled, 0) = 1
    THEN
        NEW.ccticketpricechannel_store_cad := OLD.ccticketpricechannel_store_cad;
        v_reverted := concat_ws(', ', v_reverted, 'ccticketpricechannel_store_cad');
    END IF;

    IF NEW.ccticketpricechannel_ecom_cad IS DISTINCT FROM OLD.ccticketpricechannel_ecom_cad
       AND COALESCE(NEW.cc_ticketprice_flrset_ecom_cad_enabled, 0) = 1
    THEN
        NEW.ccticketpricechannel_ecom_cad := OLD.ccticketpricechannel_ecom_cad;
        v_reverted := concat_ws(', ', v_reverted, 'ccticketpricechannel_ecom_cad');
    END IF;

    IF NEW.cc_plan_cost IS DISTINCT FROM OLD.cc_plan_cost
       AND COALESCE(NEW.cc_plan_cost_flrset_enabled, 0) = 1
    THEN
        NEW.cc_plan_cost := OLD.cc_plan_cost;
        v_reverted := concat_ws(', ', v_reverted, 'cc_plan_cost');
    END IF;

    IF NEW.cc_plan_cost_ecom_us IS DISTINCT FROM OLD.cc_plan_cost_ecom_us
       AND COALESCE(NEW.cc_plan_cost_flrset_ecom_us_enabled, 0) = 1
    THEN
        NEW.cc_plan_cost_ecom_us := OLD.cc_plan_cost_ecom_us;
        v_reverted := concat_ws(', ', v_reverted, 'cc_plan_cost_ecom_us');
    END IF;

    IF NEW.cc_plan_cost_store_cad IS DISTINCT FROM OLD.cc_plan_cost_store_cad
       AND COALESCE(NEW.cc_plan_cost_flrset_store_cad_enabled, 0) = 1
    THEN
        NEW.cc_plan_cost_store_cad := OLD.cc_plan_cost_store_cad;
        v_reverted := concat_ws(', ', v_reverted, 'cc_plan_cost_store_cad');
    END IF;

    IF NEW.cc_plan_cost_ecom_cad IS DISTINCT FROM OLD.cc_plan_cost_ecom_cad
       AND COALESCE(NEW.cc_plan_cost_flrset_ecom_cad_enabled, 0) = 1
    THEN
        NEW.cc_plan_cost_ecom_cad := OLD.cc_plan_cost_ecom_cad;
        v_reverted := concat_ws(', ', v_reverted, 'cc_plan_cost_ecom_cad');
    END IF;

    IF v_reverted IS NOT NULL THEN
        RAISE WARNING
          'Product %: style-level edit ignored for % because that column varies by floorset. Edit it on the floorsets instead.',
          NEW.product, v_reverted;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.guard_scch_pricing_edits() OWNER TO psql;

--
-- TOC entry 515 (class 1255 OID 134585025)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from gap_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 516 (class 1255 OID 134585026)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE

BEGIN

update gap_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update gap_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from gap_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 517 (class 1255 OID 134585027)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN EXECUTE 'NOTIFY pivot_execution_change'; RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 518 (class 1255 OID 134585028)
-- Name: notify_plan_queue_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_plan_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY plan_queue_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_plan_queue_change() OWNER TO psql;

--
-- TOC entry 519 (class 1255 OID 134585029)
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
-- TOC entry 520 (class 1255 OID 134585030)
-- Name: on_unpublish_remove_from_worklist(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.on_unpublish_remove_from_worklist() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  DELETE FROM user_worklist WHERE user_id = NEW.updated_by and (product=NEW.worklist_id OR product in (select worklist_id from worklist_map where product=NEW.product));
  INSERT INTO user_worklist (user_id, product) select updated_by, worklist_id from gap_p_stylecolor_worklist
  where updated_by=NEW.updated_by and worklist_id=NEW.worklist_id ; 
  RETURN NEW;
  
END;
$$;


ALTER FUNCTION public.on_unpublish_remove_from_worklist() OWNER TO psql;

--
-- TOC entry 521 (class 1255 OID 134585031)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM gap_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 522 (class 1255 OID 134585032)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_start_indx                      integer;
    v_default_grade                   text[];
    v_default_climate                 text[];
    v_default_region                  text[];
    v_default_hvlc                    text[];
    v_default_tourist_border          text[];
BEGIN
    SELECT t.indx
      INTO v_start_indx
      FROM public.gap_d_time AS t
     WHERE t.id = NEW."time"
       AND t.levelid = 'floorset';

    -- If an existing SSG is being replaced by explicit store attributes, clear SSG.
    IF COALESCE(cardinality(OLD.ssg), 0) > 0
       AND (
              COALESCE(cardinality(OLD.str_grade), 0) = 0
           OR COALESCE(cardinality(OLD.str_climate), 0) = 0
           OR COALESCE(cardinality(OLD.str_region_combo), 0) = 0
           OR COALESCE(cardinality(OLD.str_hvlc), 0) = 0
           OR COALESCE(cardinality(OLD.str_tourist_border_combo), 0) = 0
       )
       AND (
              COALESCE(cardinality(NEW.str_grade), 0) > 0
           OR COALESCE(cardinality(NEW.str_climate), 0) > 0
           OR COALESCE(cardinality(NEW.str_region_combo), 0) > 0
           OR COALESCE(cardinality(NEW.str_hvlc), 0) > 0
           OR COALESCE(cardinality(NEW.str_tourist_border_combo), 0) > 0
       )
    THEN
        NEW.ssg := '{}'::text[];
    END IF;

    -- Load all default arrays in one scan instead of five separate scans.
    IF COALESCE(cardinality(NEW.ssg), 0) = 0 THEN
        SELECT
            array_agg(v.attributevalue ORDER BY v.attributevalue)
                FILTER (WHERE v.attributeid = 'str_grade'),
            array_agg(v.attributevalue ORDER BY v.attributevalue)
                FILTER (WHERE v.attributeid = 'str_climate'),
            array_agg(v.attributevalue ORDER BY v.attributevalue)
                FILTER (WHERE v.attributeid = 'str_region_combo'),
            array_agg(v.attributevalue ORDER BY v.attributevalue)
                FILTER (WHERE v.attributeid = 'str_hvlc'),
            array_agg(v.attributevalue ORDER BY v.attributevalue)
                FILTER (WHERE v.attributeid = 'str_tourist_border_combo')
        INTO
            v_default_grade,
            v_default_climate,
            v_default_region,
            v_default_hvlc,
            v_default_tourist_border
        FROM public.gap_v_memberbasedvalidvalues AS v
        WHERE v.attributeid IN (
            'str_grade',
            'str_climate',
            'str_region_combo',
            'str_hvlc',
            'str_tourist_border_combo'
        );

        IF COALESCE(cardinality(NEW.str_grade), 0) = 0 THEN
            NEW.str_grade := COALESCE(v_default_grade, '{}'::text[]);
        END IF;
        IF COALESCE(cardinality(NEW.str_climate), 0) = 0 THEN
            NEW.str_climate := COALESCE(v_default_climate, '{}'::text[]);
        END IF;
        IF COALESCE(cardinality(NEW.str_region_combo), 0) = 0 THEN
            NEW.str_region_combo := COALESCE(v_default_region, '{}'::text[]);
        END IF;
        IF COALESCE(cardinality(NEW.str_hvlc), 0) = 0 THEN
            NEW.str_hvlc := COALESCE(v_default_hvlc, '{}'::text[]);
        END IF;
        IF COALESCE(cardinality(NEW.str_tourist_border_combo), 0) = 0 THEN
            NEW.str_tourist_border_combo := COALESCE(v_default_tourist_border, '{}'::text[]);
        END IF;
    END IF;

    -- Assigning an SSG replaces explicit ranging attributes.
    IF COALESCE(cardinality(OLD.ssg), 0) = 0
       AND COALESCE(cardinality(NEW.ssg), 0) > 0
    THEN
        NEW.str_grade                := '{}'::text[];
        NEW.str_climate              := '{}'::text[];
        NEW.str_region_combo         := '{}'::text[];
        NEW.str_hvlc                 := '{}'::text[];
        NEW.str_tourist_border_combo := '{}'::text[];
    END IF;

    IF COALESCE(cardinality(NEW.ssg), 0) = 0 THEN
        NEW.ssg := '{}'::text[];
    END IF;

    -- AFTER trigger: NEW is a working copy only. For non-floorset rows,
    -- preserve original behavior: do not persist normalization/defaulting
    -- and do not propagate.
    IF v_start_indx IS NULL THEN
        RETURN NEW;
    END IF;

    -- Propagate only to later floorsets of the same plan_type.
    UPDATE public.gap_a_assortment AS a
       SET str_grade                   = NEW.str_grade,
           str_climate                 = NEW.str_climate,
           str_region_combo            = NEW.str_region_combo,
           str_hvlc                    = NEW.str_hvlc,
           str_tourist_border_combo    = NEW.str_tourist_border_combo,
           ssg                         = NEW.ssg,
           str_grade_or                = NEW.str_grade_or,
           str_climate_or              = NEW.str_climate_or,
           str_region_combo_or         = NEW.str_region_combo_or,
           str_hvlc_or                 = NEW.str_hvlc_or,
           str_tourist_border_combo_or = NEW.str_tourist_border_combo_or
      FROM public.gap_d_time AS t
     WHERE a.product   = NEW.product
       AND a.location  = NEW.location
       AND a.plan_type = NEW.plan_type
       AND t.id        = a."time"
       AND t.levelid   = 'floorset'
       AND t.indx     >= v_start_indx;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 523 (class 1255 OID 134585033)
-- Name: propagate_pricing_to_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_pricing_to_assortment() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_locked text;
BEGIN
    IF pg_trigger_depth() > 1 THEN
        RETURN NULL;
    END IF;

    -- The trigger carries no UPDATE OF column list, because PostgreSQL forbids
    -- combining one with transition tables. So this fires on EVERY update to
    -- gap_ma_stylecolorchannelattributes and the column filter has to be here.
    IF NOT EXISTS (
        SELECT 1
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product  = n.product
            AND o.location = n.location
         WHERE n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel
            OR n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us
            OR n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad
            OR n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad
            OR n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost
            OR n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us
            OR n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad
            OR n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad
    ) THEN
        RETURN NULL;
    END IF;

    -- Refuse to flatten a column that genuinely varies by floorset. The
    -- application should never send this; if it does, fail loudly on the first
    -- occurrence rather than diverging the two tables.
    SELECT string_agg(DISTINCT n.product, ', ')
      INTO v_locked
      FROM new_rows AS n
      JOIN old_rows AS o
        ON  o.product  = n.product
        AND o.location = n.location
     WHERE (n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel
            AND COALESCE(n.cc_ticketprice_flrset_enabled, 0)           = 1)
        OR (n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us
            AND COALESCE(n.cc_ticketprice_flrset_ecom_us_enabled, 0)   = 1)
        OR (n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad
            AND COALESCE(n.cc_ticketprice_flrset_store_cad_enabled, 0) = 1)
        OR (n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad
            AND COALESCE(n.cc_ticketprice_flrset_ecom_cad_enabled, 0)  = 1)
        OR (n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost
            AND COALESCE(n.cc_plan_cost_flrset_enabled, 0)             = 1)
        OR (n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us
            AND COALESCE(n.cc_plan_cost_flrset_ecom_us_enabled, 0)     = 1)
        OR (n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad
            AND COALESCE(n.cc_plan_cost_flrset_store_cad_enabled, 0)   = 1)
        OR (n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad
            AND COALESCE(n.cc_plan_cost_flrset_ecom_cad_enabled, 0)    = 1);

    IF v_locked IS NOT NULL THEN
        RAISE EXCEPTION
          'Ticket price / plan cost edited at style level on product(s) %, but that column varies by floorset (_enabled = 1). Edit it on the floorsets instead.',
          v_locked
          USING ERRCODE = 'raise_exception';
    END IF;

    -- Down-write. Per column and per row: only columns that actually changed are
    -- written, and the _enabled test is repeated here as a second line of defence
    -- even though the guard above has already rejected those rows.
    WITH delta AS (
        SELECT n.product,
               n.location,
               n.ccticketpricechannel,
               n.ccticketpricechannel_ecom_us,
               n.ccticketpricechannel_store_cad,
               n.ccticketpricechannel_ecom_cad,
               n.cc_plan_cost,
               n.cc_plan_cost_ecom_us,
               n.cc_plan_cost_store_cad,
               n.cc_plan_cost_ecom_cad,
               (n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel
                AND COALESCE(n.cc_ticketprice_flrset_enabled, 0)           = 0) AS ch_tp,
               (n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us
                AND COALESCE(n.cc_ticketprice_flrset_ecom_us_enabled, 0)   = 0) AS ch_tp_eus,
               (n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad
                AND COALESCE(n.cc_ticketprice_flrset_store_cad_enabled, 0) = 0) AS ch_tp_scad,
               (n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad
                AND COALESCE(n.cc_ticketprice_flrset_ecom_cad_enabled, 0)  = 0) AS ch_tp_ecad,
               (n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost
                AND COALESCE(n.cc_plan_cost_flrset_enabled, 0)             = 0) AS ch_pc,
               (n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us
                AND COALESCE(n.cc_plan_cost_flrset_ecom_us_enabled, 0)     = 0) AS ch_pc_eus,
               (n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad
                AND COALESCE(n.cc_plan_cost_flrset_store_cad_enabled, 0)   = 0) AS ch_pc_scad,
               (n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad
                AND COALESCE(n.cc_plan_cost_flrset_ecom_cad_enabled, 0)    = 0) AS ch_pc_ecad
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product  = n.product
            AND o.location = n.location
         WHERE n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel
            OR n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us
            OR n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad
            OR n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad
            OR n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost
            OR n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us
            OR n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad
            OR n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad
    )
    -- V4.6 SENTINEL RULE, applied here as well as in the seed and the backfill so
    -- all three entry points agree on what reaches the floorset columns:
    --     real value  -> copied through
    --     NULL        -> stays NULL, the inheritance marker
    --     sentinel    -> mapped to NULL
    -- The sentinel is 0 or the 0.01 floor. 1,294 of 4,376 scch rows carry
    -- cc_plan_cost = 0, which already makes cc_imupct read as 100% margin; without
    -- the gate a style-level edit would copy that placeholder into every floorset
    -- row and it would stop looking like a placeholder. The gate covers ticket
    -- price too, because a zero there is worse than wrong - trigger_final_cost
    -- divides by it and raises division_by_zero.
    UPDATE public.gap_a_assortment AS a
       SET cc_ticketprice_flrset =
               CASE WHEN d.ch_tp      THEN NULLIF(GREATEST(d.ccticketpricechannel,           0.01::real), 0.01::real) ELSE a.cc_ticketprice_flrset           END,
           cc_ticketprice_flrset_ecom_us =
               CASE WHEN d.ch_tp_eus  THEN NULLIF(GREATEST(d.ccticketpricechannel_ecom_us,   0.01::real), 0.01::real) ELSE a.cc_ticketprice_flrset_ecom_us   END,
           cc_ticketprice_flrset_store_cad =
               CASE WHEN d.ch_tp_scad THEN NULLIF(GREATEST(d.ccticketpricechannel_store_cad, 0.01::real), 0.01::real) ELSE a.cc_ticketprice_flrset_store_cad END,
           cc_ticketprice_flrset_ecom_cad =
               CASE WHEN d.ch_tp_ecad THEN NULLIF(GREATEST(d.ccticketpricechannel_ecom_cad,  0.01::real), 0.01::real) ELSE a.cc_ticketprice_flrset_ecom_cad  END,
           cc_plan_cost_flrset =
               CASE WHEN d.ch_pc      THEN NULLIF(GREATEST(d.cc_plan_cost,                   0.01::real), 0.01::real) ELSE a.cc_plan_cost_flrset             END,
           cc_plan_cost_flrset_ecom_us =
               CASE WHEN d.ch_pc_eus  THEN NULLIF(GREATEST(d.cc_plan_cost_ecom_us,           0.01::real), 0.01::real) ELSE a.cc_plan_cost_flrset_ecom_us     END,
           cc_plan_cost_flrset_store_cad =
               CASE WHEN d.ch_pc_scad THEN NULLIF(GREATEST(d.cc_plan_cost_store_cad,         0.01::real), 0.01::real) ELSE a.cc_plan_cost_flrset_store_cad   END,
           cc_plan_cost_flrset_ecom_cad =
               CASE WHEN d.ch_pc_ecad THEN NULLIF(GREATEST(d.cc_plan_cost_ecom_cad,          0.01::real), 0.01::real) ELSE a.cc_plan_cost_flrset_ecom_cad    END
      FROM delta AS d
     WHERE a.product = d.product;

    -- ---------------------------------------------------------------- 2. REFRESH FLAGS
    -- The gap_a_assortment UPDATE above fires propagate_pricing_to_floorsets() at
    -- nested trigger depth, where that function intentionally returns immediately.
    -- Therefore THIS reverse path must refresh the SCA _enabled flags itself from
    -- the post-down-write floorset state. Without this step, changing a child SCA
    -- value back to NULL restores inheritance in gap_a_assortment but can leave the
    -- child flag stale at 0, allowing a later style-level edit to flatten a genuinely
    -- varied inherited curve.
    --
    -- Keep this definition symmetric with the floorset -> SCA rollup:
    --   BASE flag  = variation of the stored base vector
    --   CHILD flag = variation of COALESCE(child, base), i.e. what the UI resolves
    --
    -- Only flags whose value can have changed are refreshed. A child flag depends
    -- on both its own child column and its base column, so a base edit refreshes all
    -- three children for that measure as well.
    WITH ch AS (
        SELECT n.product,
               bool_or(n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel)           AS ch_tp,
               bool_or(n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us)   AS ch_tp_eus,
               bool_or(n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad) AS ch_tp_scad,
               bool_or(n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad)  AS ch_tp_ecad,
               bool_or(n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost)                   AS ch_pc,
               bool_or(n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us)           AS ch_pc_eus,
               bool_or(n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad)         AS ch_pc_scad,
               bool_or(n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad)          AS ch_pc_ecad
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product  = n.product
            AND o.location = n.location
         GROUP BY n.product
        HAVING bool_or(n.ccticketpricechannel           IS DISTINCT FROM o.ccticketpricechannel)
            OR bool_or(n.ccticketpricechannel_ecom_us   IS DISTINCT FROM o.ccticketpricechannel_ecom_us)
            OR bool_or(n.ccticketpricechannel_store_cad IS DISTINCT FROM o.ccticketpricechannel_store_cad)
            OR bool_or(n.ccticketpricechannel_ecom_cad  IS DISTINCT FROM o.ccticketpricechannel_ecom_cad)
            OR bool_or(n.cc_plan_cost                   IS DISTINCT FROM o.cc_plan_cost)
            OR bool_or(n.cc_plan_cost_ecom_us           IS DISTINCT FROM o.cc_plan_cost_ecom_us)
            OR bool_or(n.cc_plan_cost_store_cad         IS DISTINCT FROM o.cc_plan_cost_store_cad)
            OR bool_or(n.cc_plan_cost_ecom_cad          IS DISTINCT FROM o.cc_plan_cost_ecom_cad)
    ),
    mx AS (
        SELECT a.product,
               (max(a.cc_ticketprice_flrset)
                    IS DISTINCT FROM min(a.cc_ticketprice_flrset)) AS v_tp,
               (max(COALESCE(a.cc_ticketprice_flrset_ecom_us, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_ecom_us, a.cc_ticketprice_flrset))) AS v_tp_eus,
               (max(COALESCE(a.cc_ticketprice_flrset_store_cad, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_store_cad, a.cc_ticketprice_flrset))) AS v_tp_scad,
               (max(COALESCE(a.cc_ticketprice_flrset_ecom_cad, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_ecom_cad, a.cc_ticketprice_flrset))) AS v_tp_ecad,
               (max(a.cc_plan_cost_flrset)
                    IS DISTINCT FROM min(a.cc_plan_cost_flrset)) AS v_pc,
               (max(COALESCE(a.cc_plan_cost_flrset_ecom_us, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_ecom_us, a.cc_plan_cost_flrset))) AS v_pc_eus,
               (max(COALESCE(a.cc_plan_cost_flrset_store_cad, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_store_cad, a.cc_plan_cost_flrset))) AS v_pc_scad,
               (max(COALESCE(a.cc_plan_cost_flrset_ecom_cad, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_ecom_cad, a.cc_plan_cost_flrset))) AS v_pc_ecad
          FROM public.gap_a_assortment AS a
          JOIN ch ON ch.product = a.product
         GROUP BY a.product
    )
    UPDATE public.gap_ma_stylecolorchannelattributes AS s
       SET cc_ticketprice_flrset_enabled =
               CASE WHEN c.ch_tp THEN CASE WHEN m.v_tp THEN 1 ELSE 0 END
                                 ELSE s.cc_ticketprice_flrset_enabled END,
           cc_ticketprice_flrset_ecom_us_enabled =
               CASE WHEN (c.ch_tp_eus OR c.ch_tp) THEN CASE WHEN m.v_tp_eus THEN 1 ELSE 0 END
                                                      ELSE s.cc_ticketprice_flrset_ecom_us_enabled END,
           cc_ticketprice_flrset_store_cad_enabled =
               CASE WHEN (c.ch_tp_scad OR c.ch_tp) THEN CASE WHEN m.v_tp_scad THEN 1 ELSE 0 END
                                                       ELSE s.cc_ticketprice_flrset_store_cad_enabled END,
           cc_ticketprice_flrset_ecom_cad_enabled =
               CASE WHEN (c.ch_tp_ecad OR c.ch_tp) THEN CASE WHEN m.v_tp_ecad THEN 1 ELSE 0 END
                                                       ELSE s.cc_ticketprice_flrset_ecom_cad_enabled END,
           cc_plan_cost_flrset_enabled =
               CASE WHEN c.ch_pc THEN CASE WHEN m.v_pc THEN 1 ELSE 0 END
                                 ELSE s.cc_plan_cost_flrset_enabled END,
           cc_plan_cost_flrset_ecom_us_enabled =
               CASE WHEN (c.ch_pc_eus OR c.ch_pc) THEN CASE WHEN m.v_pc_eus THEN 1 ELSE 0 END
                                                      ELSE s.cc_plan_cost_flrset_ecom_us_enabled END,
           cc_plan_cost_flrset_store_cad_enabled =
               CASE WHEN (c.ch_pc_scad OR c.ch_pc) THEN CASE WHEN m.v_pc_scad THEN 1 ELSE 0 END
                                                       ELSE s.cc_plan_cost_flrset_store_cad_enabled END,
           cc_plan_cost_flrset_ecom_cad_enabled =
               CASE WHEN (c.ch_pc_ecad OR c.ch_pc) THEN CASE WHEN m.v_pc_ecad THEN 1 ELSE 0 END
                                                       ELSE s.cc_plan_cost_flrset_ecom_cad_enabled END
      FROM ch AS c
      JOIN mx AS m
        ON m.product = c.product
     WHERE s.product = c.product;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.propagate_pricing_to_assortment() OWNER TO psql;

--
-- TOC entry 524 (class 1255 OID 134585035)
-- Name: propagate_pricing_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_pricing_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    -- Depth guard lives in the body rather than in a WHEN clause: this is a
    -- statement-level trigger and the body test is portable. Inside a trigger
    -- function the depth already counts this invocation, so 1 means top level.
    IF pg_trigger_depth() > 1 THEN
        RETURN NULL;
    END IF;

    -- The trigger carries no UPDATE OF column list, because PostgreSQL forbids
    -- combining one with transition tables. So this fires on EVERY update to
    -- gap_a_assortment and the column filter has to be here. Bail on the cheap
    -- test first rather than running two statements that would no-op.
    IF NOT EXISTS (
        SELECT 1
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product   = n.product
            AND o."time"    = n."time"
            AND o.location  = n.location
            AND o.plan_type = n.plan_type
         WHERE n.cc_ticketprice_flrset           IS DISTINCT FROM o.cc_ticketprice_flrset
            OR n.cc_ticketprice_flrset_ecom_us   IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_us
            OR n.cc_ticketprice_flrset_store_cad IS DISTINCT FROM o.cc_ticketprice_flrset_store_cad
            OR n.cc_ticketprice_flrset_ecom_cad  IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_cad
            OR n.cc_plan_cost_flrset             IS DISTINCT FROM o.cc_plan_cost_flrset
            OR n.cc_plan_cost_flrset_ecom_us     IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_us
            OR n.cc_plan_cost_flrset_store_cad   IS DISTINCT FROM o.cc_plan_cost_flrset_store_cad
            OR n.cc_plan_cost_flrset_ecom_cad    IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_cad
    ) THEN
        RETURN NULL;
    END IF;

    -- ---------------------------------------------------------------- 1. PROPAGATE
    -- Each edited floorset pushes only its CHANGED columns forward to every later
    -- floorset of the same product/location/plan_type. Unchanged columns keep the
    -- target row's own value.
    WITH delta AS (
        SELECT n.product,
               n.location,
               n.plan_type,
               t.indx AS start_indx,
               n.cc_ticketprice_flrset,
               n.cc_ticketprice_flrset_ecom_us,
               n.cc_ticketprice_flrset_store_cad,
               n.cc_ticketprice_flrset_ecom_cad,
               n.cc_plan_cost_flrset,
               n.cc_plan_cost_flrset_ecom_us,
               n.cc_plan_cost_flrset_store_cad,
               n.cc_plan_cost_flrset_ecom_cad,
               (n.cc_ticketprice_flrset           IS DISTINCT FROM o.cc_ticketprice_flrset)           AS ch_tp,
               (n.cc_ticketprice_flrset_ecom_us   IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_us)   AS ch_tp_eus,
               (n.cc_ticketprice_flrset_store_cad IS DISTINCT FROM o.cc_ticketprice_flrset_store_cad) AS ch_tp_scad,
               (n.cc_ticketprice_flrset_ecom_cad  IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_cad)  AS ch_tp_ecad,
               (n.cc_plan_cost_flrset             IS DISTINCT FROM o.cc_plan_cost_flrset)             AS ch_pc,
               (n.cc_plan_cost_flrset_ecom_us     IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_us)     AS ch_pc_eus,
               (n.cc_plan_cost_flrset_store_cad   IS DISTINCT FROM o.cc_plan_cost_flrset_store_cad)   AS ch_pc_scad,
               (n.cc_plan_cost_flrset_ecom_cad    IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_cad)    AS ch_pc_ecad
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product   = n.product
            AND o."time"    = n."time"
            AND o.location  = n.location
            AND o.plan_type = n.plan_type
          JOIN public.gap_d_time AS t
            ON  t.id      = n."time"
            AND t.levelid = 'floorset'
         WHERE n.cc_ticketprice_flrset           IS DISTINCT FROM o.cc_ticketprice_flrset
            OR n.cc_ticketprice_flrset_ecom_us   IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_us
            OR n.cc_ticketprice_flrset_store_cad IS DISTINCT FROM o.cc_ticketprice_flrset_store_cad
            OR n.cc_ticketprice_flrset_ecom_cad  IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_cad
            OR n.cc_plan_cost_flrset             IS DISTINCT FROM o.cc_plan_cost_flrset
            OR n.cc_plan_cost_flrset_ecom_us     IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_us
            OR n.cc_plan_cost_flrset_store_cad   IS DISTINCT FROM o.cc_plan_cost_flrset_store_cad
            OR n.cc_plan_cost_flrset_ecom_cad    IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_cad
    )
    UPDATE public.gap_a_assortment AS a
       SET cc_ticketprice_flrset =
               CASE WHEN NOT d.ch_tp                        THEN a.cc_ticketprice_flrset
                    WHEN t2.indx >= d.start_indx           THEN d.cc_ticketprice_flrset
                    ELSE a.cc_ticketprice_flrset
               END,
           cc_plan_cost_flrset =
               CASE WHEN NOT d.ch_pc                        THEN a.cc_plan_cost_flrset
                    WHEN t2.indx >= d.start_indx           THEN d.cc_plan_cost_flrset
                    ELSE a.cc_plan_cost_flrset
               END,
           cc_ticketprice_flrset_ecom_us =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_tp_eus                        THEN a.cc_ticketprice_flrset_ecom_us
                    WHEN t2.indx >= d.start_indx           THEN d.cc_ticketprice_flrset_ecom_us
                    ELSE COALESCE(a.cc_ticketprice_flrset_ecom_us,
                                  CASE WHEN d.ch_tp AND t2.indx >= d.start_indx THEN d.cc_ticketprice_flrset ELSE a.cc_ticketprice_flrset END)
               END,
           cc_ticketprice_flrset_store_cad =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_tp_scad                        THEN a.cc_ticketprice_flrset_store_cad
                    WHEN t2.indx >= d.start_indx           THEN d.cc_ticketprice_flrset_store_cad
                    ELSE COALESCE(a.cc_ticketprice_flrset_store_cad,
                                  CASE WHEN d.ch_tp AND t2.indx >= d.start_indx THEN d.cc_ticketprice_flrset ELSE a.cc_ticketprice_flrset END)
               END,
           cc_ticketprice_flrset_ecom_cad =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_tp_ecad                        THEN a.cc_ticketprice_flrset_ecom_cad
                    WHEN t2.indx >= d.start_indx           THEN d.cc_ticketprice_flrset_ecom_cad
                    ELSE COALESCE(a.cc_ticketprice_flrset_ecom_cad,
                                  CASE WHEN d.ch_tp AND t2.indx >= d.start_indx THEN d.cc_ticketprice_flrset ELSE a.cc_ticketprice_flrset END)
               END,
           cc_plan_cost_flrset_ecom_us =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_pc_eus                        THEN a.cc_plan_cost_flrset_ecom_us
                    WHEN t2.indx >= d.start_indx           THEN d.cc_plan_cost_flrset_ecom_us
                    ELSE COALESCE(a.cc_plan_cost_flrset_ecom_us,
                                  CASE WHEN d.ch_pc AND t2.indx >= d.start_indx THEN d.cc_plan_cost_flrset ELSE a.cc_plan_cost_flrset END)
               END,
           cc_plan_cost_flrset_store_cad =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_pc_scad                        THEN a.cc_plan_cost_flrset_store_cad
                    WHEN t2.indx >= d.start_indx           THEN d.cc_plan_cost_flrset_store_cad
                    ELSE COALESCE(a.cc_plan_cost_flrset_store_cad,
                                  CASE WHEN d.ch_pc AND t2.indx >= d.start_indx THEN d.cc_plan_cost_flrset ELSE a.cc_plan_cost_flrset END)
               END,
           cc_plan_cost_flrset_ecom_cad =
               -- V4.6 third branch: MATERIALISE ON EDIT. Floorsets before the
               -- edited one still inherit, so write down what they already
               -- resolve to. Row-wise from THIS row's base, because the base
               -- column can itself vary by floorset. base_eff picks up a base
               -- value changed in this same statement, since SET expressions
               -- otherwise see the pre-update row.
               CASE WHEN NOT d.ch_pc_ecad                        THEN a.cc_plan_cost_flrset_ecom_cad
                    WHEN t2.indx >= d.start_indx           THEN d.cc_plan_cost_flrset_ecom_cad
                    ELSE COALESCE(a.cc_plan_cost_flrset_ecom_cad,
                                  CASE WHEN d.ch_pc AND t2.indx >= d.start_indx THEN d.cc_plan_cost_flrset ELSE a.cc_plan_cost_flrset END)
               END
      FROM delta AS d
      JOIN public.gap_d_time AS t2
        ON t2.levelid = 'floorset'
     WHERE a.product   = d.product
       AND a.location  = d.location
       AND a.plan_type = d.plan_type
       AND a."time"    = t2.id
       AND (
              -- Normal forward propagation for every changed price/cost column.
              t2.indx >= d.start_indx

              -- V4.6 FIX: for rows BEFORE the edited floorset, update only when
              -- a changed CHANNEL variant is still NULL and therefore genuinely
              -- needs its inherited base materialised. This avoids timestamp/WAL
              -- churn on earlier rows for base-only edits or already-materialised
              -- channel values. A NULL base would still produce NULL, so skip it.
           OR (
                  t2.indx < d.start_indx
              AND (
                     (d.ch_tp_eus
                      AND a.cc_ticketprice_flrset_ecom_us IS NULL
                      AND a.cc_ticketprice_flrset IS NOT NULL)
                  OR (d.ch_tp_scad
                      AND a.cc_ticketprice_flrset_store_cad IS NULL
                      AND a.cc_ticketprice_flrset IS NOT NULL)
                  OR (d.ch_tp_ecad
                      AND a.cc_ticketprice_flrset_ecom_cad IS NULL
                      AND a.cc_ticketprice_flrset IS NOT NULL)
                  OR (d.ch_pc_eus
                      AND a.cc_plan_cost_flrset_ecom_us IS NULL
                      AND a.cc_plan_cost_flrset IS NOT NULL)
                  OR (d.ch_pc_scad
                      AND a.cc_plan_cost_flrset_store_cad IS NULL
                      AND a.cc_plan_cost_flrset IS NOT NULL)
                  OR (d.ch_pc_ecad
                      AND a.cc_plan_cost_flrset_ecom_cad IS NULL
                      AND a.cc_plan_cost_flrset IS NOT NULL)
              )
           )
       );

    -- ------------------------------------------------------------------ 2. ROLLUP
    -- One scch statement for all sixteen target columns plus cc_final_cost and
    -- cc_imupct. MAX is taken AFTER propagation so it reflects the settled state.
    -- A NULL max never overwrites an existing scch value, which is what keeps the
    -- _enabled flags meaningful once set.
    --
    -- calc resolves the effective post-rollup price per product. It must be computed
    -- here rather than read back from s.*, because every SET expression in an UPDATE
    -- sees the pre-update row.
    WITH ch AS (
        SELECT n.product,
               bool_or(n.cc_ticketprice_flrset           IS DISTINCT FROM o.cc_ticketprice_flrset)           AS ch_tp,
               bool_or(n.cc_ticketprice_flrset_ecom_us   IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_us)   AS ch_tp_eus,
               bool_or(n.cc_ticketprice_flrset_store_cad IS DISTINCT FROM o.cc_ticketprice_flrset_store_cad) AS ch_tp_scad,
               bool_or(n.cc_ticketprice_flrset_ecom_cad  IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_cad)  AS ch_tp_ecad,
               bool_or(n.cc_plan_cost_flrset             IS DISTINCT FROM o.cc_plan_cost_flrset)             AS ch_pc,
               bool_or(n.cc_plan_cost_flrset_ecom_us     IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_us)     AS ch_pc_eus,
               bool_or(n.cc_plan_cost_flrset_store_cad   IS DISTINCT FROM o.cc_plan_cost_flrset_store_cad)   AS ch_pc_scad,
               bool_or(n.cc_plan_cost_flrset_ecom_cad    IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_cad)    AS ch_pc_ecad
          FROM new_rows AS n
          JOIN old_rows AS o
            ON  o.product   = n.product
            AND o."time"    = n."time"
            AND o.location  = n.location
            AND o.plan_type = n.plan_type
         GROUP BY n.product
        HAVING bool_or(n.cc_ticketprice_flrset           IS DISTINCT FROM o.cc_ticketprice_flrset)
            OR bool_or(n.cc_ticketprice_flrset_ecom_us   IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_us)
            OR bool_or(n.cc_ticketprice_flrset_store_cad IS DISTINCT FROM o.cc_ticketprice_flrset_store_cad)
            OR bool_or(n.cc_ticketprice_flrset_ecom_cad  IS DISTINCT FROM o.cc_ticketprice_flrset_ecom_cad)
            OR bool_or(n.cc_plan_cost_flrset             IS DISTINCT FROM o.cc_plan_cost_flrset)
            OR bool_or(n.cc_plan_cost_flrset_ecom_us     IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_us)
            OR bool_or(n.cc_plan_cost_flrset_store_cad   IS DISTINCT FROM o.cc_plan_cost_flrset_store_cad)
            OR bool_or(n.cc_plan_cost_flrset_ecom_cad    IS DISTINCT FROM o.cc_plan_cost_flrset_ecom_cad)
    ),
    mx AS (
        SELECT a.product,
               max(a.cc_ticketprice_flrset)           AS m_tp,
               max(a.cc_ticketprice_flrset_ecom_us)   AS m_tp_eus,
               max(a.cc_ticketprice_flrset_store_cad) AS m_tp_scad,
               max(a.cc_ticketprice_flrset_ecom_cad)  AS m_tp_ecad,
               max(a.cc_plan_cost_flrset)             AS m_pc,
               max(a.cc_plan_cost_flrset_ecom_us)     AS m_pc_eus,
               max(a.cc_plan_cost_flrset_store_cad)   AS m_pc_scad,
               max(a.cc_plan_cost_flrset_ecom_cad)    AS m_pc_ecad,
               -- _enabled is DERIVED, not latched: it means "this column genuinely
               -- varies by floorset", i.e. the vector does not collapse to a scalar.
               -- V4.6: for the six CHANNEL VARIANTS this uses RESOLVED values,
               -- COALESCE(variant, base), because that is what the user sees.
               -- Computed from stored values it reads 0 on a partially populated
               -- variant (aggregates ignore NULLs), which would leave the style-edit
               -- screen open and let a style-level edit flatten a real floorset
               -- price, bypassing scch_05_guard_pricing. The rollup VALUE below
               -- stays max(raw), so NULL still means NULL.
               (max(a.cc_ticketprice_flrset)
                    IS DISTINCT FROM min(a.cc_ticketprice_flrset))           AS v_tp,
               (max(COALESCE(a.cc_ticketprice_flrset_ecom_us, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_ecom_us, a.cc_ticketprice_flrset)))   AS v_tp_eus,
               (max(COALESCE(a.cc_ticketprice_flrset_store_cad, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_store_cad, a.cc_ticketprice_flrset))) AS v_tp_scad,
               (max(COALESCE(a.cc_ticketprice_flrset_ecom_cad, a.cc_ticketprice_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_ticketprice_flrset_ecom_cad, a.cc_ticketprice_flrset)))  AS v_tp_ecad,
               (max(a.cc_plan_cost_flrset)
                    IS DISTINCT FROM min(a.cc_plan_cost_flrset))             AS v_pc,
               (max(COALESCE(a.cc_plan_cost_flrset_ecom_us, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_ecom_us, a.cc_plan_cost_flrset)))     AS v_pc_eus,
               (max(COALESCE(a.cc_plan_cost_flrset_store_cad, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_store_cad, a.cc_plan_cost_flrset)))   AS v_pc_scad,
               (max(COALESCE(a.cc_plan_cost_flrset_ecom_cad, a.cc_plan_cost_flrset))
                    IS DISTINCT FROM min(COALESCE(a.cc_plan_cost_flrset_ecom_cad, a.cc_plan_cost_flrset)))    AS v_pc_ecad
          FROM public.gap_a_assortment AS a
          JOIN ch ON ch.product = a.product
         GROUP BY a.product
    ),
    calc AS (
        SELECT c.product,
               c.ch_tp, c.ch_tp_eus, c.ch_tp_scad, c.ch_tp_ecad,
               c.ch_pc, c.ch_pc_eus, c.ch_pc_scad, c.ch_pc_ecad,
               m.m_tp, m.m_tp_eus, m.m_tp_scad, m.m_tp_ecad,
               m.m_pc, m.m_pc_eus, m.m_pc_scad, m.m_pc_ecad,
               m.v_tp, m.v_tp_eus, m.v_tp_scad, m.v_tp_ecad,
               m.v_pc, m.v_pc_eus, m.v_pc_scad, m.v_pc_ecad,
               (c.ch_tp AND m.m_tp IS NOT NULL) AS do_tp,
               (c.ch_pc AND m.m_pc IS NOT NULL) AS do_pc,
               CASE WHEN c.ch_tp AND m.m_tp IS NOT NULL
                    THEN m.m_tp
                    ELSE t.ccticketpricechannel
               END AS price_eff
          FROM ch AS c
          JOIN mx AS m
            ON m.product = c.product
          JOIN public.gap_ma_stylecolorchannelattributes AS t
            ON t.product = c.product
    )
    UPDATE public.gap_ma_stylecolorchannelattributes AS s
       SET ccticketpricechannel =
               CASE WHEN k.do_tp THEN k.m_tp ELSE s.ccticketpricechannel          END,
           cc_ticketprice_flrset_enabled =
               CASE WHEN k.ch_tp THEN (CASE WHEN k.v_tp THEN 1 ELSE 0 END)
                                 ELSE s.cc_ticketprice_flrset_enabled END,
           ccticketpricechannel_ecom_us =
               CASE WHEN k.ch_tp_eus  AND k.m_tp_eus  IS NOT NULL THEN k.m_tp_eus  ELSE s.ccticketpricechannel_ecom_us   END,
           cc_ticketprice_flrset_ecom_us_enabled =
               CASE WHEN (k.ch_tp_eus OR k.ch_tp)  THEN (CASE WHEN k.v_tp_eus  THEN 1 ELSE 0 END) ELSE s.cc_ticketprice_flrset_ecom_us_enabled END,
           ccticketpricechannel_store_cad =
               CASE WHEN k.ch_tp_scad AND k.m_tp_scad IS NOT NULL THEN k.m_tp_scad ELSE s.ccticketpricechannel_store_cad END,
           cc_ticketprice_flrset_store_cad_enabled =
               CASE WHEN (k.ch_tp_scad OR k.ch_tp) THEN (CASE WHEN k.v_tp_scad THEN 1 ELSE 0 END) ELSE s.cc_ticketprice_flrset_store_cad_enabled END,
           ccticketpricechannel_ecom_cad =
               CASE WHEN k.ch_tp_ecad AND k.m_tp_ecad IS NOT NULL THEN k.m_tp_ecad ELSE s.ccticketpricechannel_ecom_cad  END,
           cc_ticketprice_flrset_ecom_cad_enabled =
               CASE WHEN (k.ch_tp_ecad OR k.ch_tp) THEN (CASE WHEN k.v_tp_ecad THEN 1 ELSE 0 END) ELSE s.cc_ticketprice_flrset_ecom_cad_enabled END,
           cc_plan_cost =
               CASE WHEN k.do_pc THEN k.m_pc ELSE s.cc_plan_cost                  END,
           cc_plan_cost_flrset_enabled =
               CASE WHEN k.ch_pc THEN (CASE WHEN k.v_pc THEN 1 ELSE 0 END)
                                 ELSE s.cc_plan_cost_flrset_enabled END,
           cc_plan_cost_ecom_us =
               CASE WHEN k.ch_pc_eus  AND k.m_pc_eus  IS NOT NULL THEN k.m_pc_eus  ELSE s.cc_plan_cost_ecom_us   END,
           cc_plan_cost_flrset_ecom_us_enabled =
               CASE WHEN (k.ch_pc_eus OR k.ch_pc)  THEN (CASE WHEN k.v_pc_eus  THEN 1 ELSE 0 END) ELSE s.cc_plan_cost_flrset_ecom_us_enabled END,
           cc_plan_cost_store_cad =
               CASE WHEN k.ch_pc_scad AND k.m_pc_scad IS NOT NULL THEN k.m_pc_scad ELSE s.cc_plan_cost_store_cad END,
           cc_plan_cost_flrset_store_cad_enabled =
               CASE WHEN (k.ch_pc_scad OR k.ch_pc) THEN (CASE WHEN k.v_pc_scad THEN 1 ELSE 0 END) ELSE s.cc_plan_cost_flrset_store_cad_enabled END,
           cc_plan_cost_ecom_cad =
               CASE WHEN k.ch_pc_ecad AND k.m_pc_ecad IS NOT NULL THEN k.m_pc_ecad ELSE s.cc_plan_cost_ecom_cad  END,
           cc_plan_cost_flrset_ecom_cad_enabled =
               CASE WHEN (k.ch_pc_ecad OR k.ch_pc) THEN (CASE WHEN k.v_pc_ecad THEN 1 ELSE 0 END) ELSE s.cc_plan_cost_flrset_ecom_cad_enabled END,
           -- Same work trigger_final_cost would have done, without the per-row cascade.
           cc_final_cost =
               CASE WHEN k.do_pc THEN k.m_pc ELSE s.cc_final_cost END,
           cc_imupct =
               CASE WHEN k.do_pc
                    THEN COALESCE(
                             round(((k.price_eff - k.m_pc) / k.price_eff)::numeric, 2),
                             0.0
                         )
                    ELSE s.cc_imupct
               END
      FROM calc AS k
     WHERE s.product = k.product;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.propagate_pricing_to_floorsets() OWNER TO psql;

--
-- TOC entry 525 (class 1255 OID 134585037)
-- Name: remove_from_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_from_assortment() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.remove_from_assortment() OWNER TO psql;

--
-- TOC entry 526 (class 1255 OID 134585038)
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
    FROM gap_p_approvedclusters 
    WHERE cluster_id = NEW.store_cluster_id;

    -- Update reassigned_cluster based on the clustering status
    UPDATE gap_p_reassigncluster 
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
        -- Handle case where no cluster_id is found in gap_p_approvedclusters
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
-- TOC entry 527 (class 1255 OID 134585039)
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
-- TOC entry 528 (class 1255 OID 134585040)
-- Name: set_floorset_fields_on_initrcptwk_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_floorset_fields_on_initrcptwk_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
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
    FROM gap_h_prodstd h
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
      FROM gap_ma_dptflrsetattributes d
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
-- TOC entry 529 (class 1255 OID 134585041)
-- Name: sizerangecode_isvalid(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sizerangecode_isvalid() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    UPDATE public.gap_ma_sizeattributes AS s
       SET isvalid = CASE
           WHEN s.sizeattribute = ANY(COALESCE(NEW.validsizes, '{}'::text[])) THEN 1
           ELSE 0
       END
     WHERE s.parent_id = NEW.product
       AND s.isvalid IS DISTINCT FROM CASE
           WHEN s.sizeattribute = ANY(COALESCE(NEW.validsizes, '{}'::text[])) THEN 1
           ELSE 0
       END;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_isvalid() OWNER TO psql;

--
-- TOC entry 531 (class 1255 OID 134585042)
-- Name: sizerangecode_validsizes_members(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sizerangecode_validsizes_members() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_product        text := NEW.product;
    v_sty_size_range text;
BEGIN
    v_sty_size_range := split_part(NEW.ccrangecode, ' - ', 1);

    -- Start by invalidating all current children. Matching members are revalidated
    -- below; this preserves members that fall out of the new range as inactive.
    UPDATE public.gap_ma_sizeattributes AS s
       SET isvalid = 0
     WHERE s.parent_id = v_product
       AND s.isvalid IS DISTINCT FROM 0;

    IF v_sty_size_range IS NOT NULL THEN
        WITH candidates AS MATERIALIZED (
            SELECT DISTINCT
                   d.target_value::text AS sizeattribute,
                   m.size_code::text    AS size_code,
                   m.size_attribute::text AS size_name
              FROM public.gap_l_dependencylookup AS d
              JOIN public.gap_size_range_mapping AS m
                ON m.sty_size_range = d.lookup_value
               AND m.sizeattribute = d.target_value
             WHERE d.lookup_id = 'size_range'
               AND d.lookup_value = v_sty_size_range
        )
        UPDATE public.gap_ma_sizeattributes AS s
           SET isvalid  = 1,
               size_code = c.size_code,
               size_name = c.size_name
          FROM candidates AS c
         WHERE s.parent_id = v_product
           AND s.sizeattribute = c.sizeattribute
           AND (
                  s.isvalid IS DISTINCT FROM 1
               OR s.size_code IS DISTINCT FROM c.size_code
               OR s.size_name IS DISTINCT FROM c.size_name
           );

        WITH candidates AS MATERIALIZED (
            SELECT DISTINCT
                   d.target_value::text AS sizeattribute,
                   m.size_code::text    AS size_code,
                   m.size_attribute::text AS size_name
              FROM public.gap_l_dependencylookup AS d
              JOIN public.gap_size_range_mapping AS m
                ON m.sty_size_range = d.lookup_value
               AND m.sizeattribute = d.target_value
             WHERE d.lookup_id = 'size_range'
               AND d.lookup_value = v_sty_size_range
        ),
        new_members AS (
            INSERT INTO public.gap_ma_sizeattributes
                (product, sizeattribute, parent_id, isvalid, size_code, size_name)
            SELECT uuid_generate_v4()::text,
                   c.sizeattribute,
                   v_product,
                   1,
                   c.size_code,
                   c.size_name
              FROM candidates AS c
             WHERE NOT EXISTS (
                 SELECT 1
                   FROM public.gap_ma_sizeattributes AS e
                  WHERE e.parent_id = v_product
                    AND e.sizeattribute = c.sizeattribute
             )
            RETURNING product, parent_id, sizeattribute, size_code, size_name
        ),
        inserted_dim AS (
            INSERT INTO public.gap_d_product (id, name, description, levelid)
            SELECT n.product,
                   p.name || ':' || n.size_name,
                   p.description || ':' || n.size_name,
                   'stylecolorsize'
              FROM new_members AS n
              JOIN public.gap_d_product AS p
                ON p.id = n.parent_id
            ON CONFLICT (id) DO NOTHING
            RETURNING id
        )
        INSERT INTO public.gap_h_prodstd
            (id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4, ancestor5, ancestor6,
             version_id, created_at, created_by, updated_at, updated_by, record_state)
        SELECT n.product,
               h.id,
               h.ancestor0,
               h.ancestor1,
               h.ancestor2,
               h.ancestor3,
               h.ancestor4,
               h.ancestor5,
               h.version_id,
               h.created_at,
               h.created_by,
               h.updated_at,
               h.updated_by,
               h.record_state
          FROM new_members AS n
          JOIN public.gap_h_prodstd AS h
            ON h.id = n.parent_id
        ON CONFLICT (id) DO NOTHING;
    END IF;

    UPDATE public.gap_p_dc_adj_size AS d
       SET dc_useradj = NULL
      FROM public.gap_ma_sizeattributes AS s
     WHERE s.parent_id = v_product
       AND s.isvalid = 0
       AND d.product = s.product
       AND d.dc_useradj IS NOT NULL;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_validsizes_members() OWNER TO psql;

--
-- TOC entry 532 (class 1255 OID 134585043)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_deleted         integer := 0;
    v_dept            text;
    v_relaunchweek    text;
    v_irw_indx        integer;
    v_dbtwk_indx      integer;
    v_initrcptwk      text;
    v_effective_start text;
BEGIN
    -- Source behavior: blank relaunch means no relaunch in this function.
    v_relaunchweek := CASE
        WHEN NEW.relaunchweek = '' THEN NULL
        ELSE NEW.relaunchweek
    END;

    -- Preserve the source function's self-contained IRW derivation. Do not use
    -- NEW.initrcptwk here as a substitute: the source derives it independently.
    v_dbtwk_indx := (
        SELECT t.indx
          FROM public.gap_d_time AS t
         WHERE t.id = COALESCE(v_relaunchweek, NEW.dbt_wk)
    );

    SELECT min(v_dbtwk_indx - d.irw_debut_offset)
      INTO v_irw_indx
      FROM public.gap_ma_dptflrsetattributes AS d,
           public.gap_h_prodstd AS h
     WHERE h.id = NEW.product
       AND h.ancestor3 = d.product
       AND NEW.dbt_wk BETWEEN d.ap_start AND d.ap_end;

    v_initrcptwk := (
        SELECT t.id
          FROM public.gap_d_time AS t
         WHERE t.indx = v_irw_indx
    );

    v_effective_start := COALESCE(
        v_relaunchweek,
        LEAST(v_initrcptwk, NEW.dbt_wk)
    );

    SELECT h.ancestor3
      INTO v_dept
      FROM public.gap_h_prodstd AS h
     WHERE h.id = NEW.product;

    IF v_dept IS NULL
       OR v_effective_start IS NULL
       OR NEW.exitdate IS NULL
    THEN
        RETURN NEW;
    END IF;

    -- Extend earlier: clone the earliest existing PLAN assortment row. Existing
    -- in-window rows are never deleted/reinserted.
    WITH target AS MATERIALIZED (
        SELECT DISTINCT d.indx, d."time"
          FROM public.gap_ma_dptflrsetattributes AS d
         WHERE d.product = v_dept
           AND d.ap_start <= NEW.exitdate
           AND d.ap_end >= v_effective_start
    ),
    first_old AS (
        SELECT a.*, d.indx AS source_indx
          FROM public.gap_a_assortment AS a
          JOIN public.gap_ma_dptflrsetattributes AS d
            ON d.product = v_dept
           AND d."time" = a."time"
         WHERE a.product = NEW.product
           AND a.location = NEW.location
           AND a.plan_type = 'plan'
         ORDER BY d.indx, d."time"
         LIMIT 1
    )
    INSERT INTO public.gap_a_assortment (
        product,
        location,
        "time",
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
        created_by,
        updated_by,
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
        cc_flrset_open_10,
        cc_ticketprice_flrset,
        cc_ticketprice_flrset_ecom_us,
        cc_ticketprice_flrset_store_cad,
        cc_ticketprice_flrset_ecom_cad,
        cc_plan_cost_flrset,
        cc_plan_cost_flrset_ecom_us,
        cc_plan_cost_flrset_store_cad,
        cc_plan_cost_flrset_ecom_cad
    )
    SELECT
        f.product,
        f.location,
        t."time",
        f.style,
        f.str_grade,
        f.str_climate,
        f.str_region_combo,
        f.str_hvlc,
        f.str_tourist_border_combo,
        f.ssg,
        f.flnrange,
        f.plan_type,
        f.isfunded,
        f.store_count,
        f.propagate_ranging,
        f.created_by,
        f.updated_by,
        f.str_grade_or,
        f.str_climate_or,
        f.str_region_combo_or,
        f.str_hvlc_or,
        f.str_tourist_border_combo_or,
        f.is_sclr_flrset_locked,
        f.str_grade_cad,
        f.str_climate_cad,
        f.str_region_combo_cad,
        f.str_hvlc_cad,
        f.str_tourist_border_combo_cad,
        f.ssg_cad,
        f.isfunded_cad,
        f.str_grade_ecom,
        f.isfunded_ecom,
        f.str_grade_ecom_cad,
        f.isfunded_ecom_cad,
        f.cc_flrset_open_1,
        f.cc_flrset_open_2,
        f.cc_flrset_open_3,
        f.cc_flrset_open_4,
        f.cc_flrset_open_5,
        f.cc_flrset_open_6,
        f.cc_flrset_open_7,
        f.cc_flrset_open_8,
        f.cc_flrset_open_9,
        f.cc_flrset_open_10,
        f.cc_ticketprice_flrset,
        f.cc_ticketprice_flrset_ecom_us,
        f.cc_ticketprice_flrset_store_cad,
        f.cc_ticketprice_flrset_ecom_cad,
        f.cc_plan_cost_flrset,
        f.cc_plan_cost_flrset_ecom_us,
        f.cc_plan_cost_flrset_store_cad,
        f.cc_plan_cost_flrset_ecom_cad
      FROM first_old AS f
      JOIN target AS t
        ON t.indx < f.source_indx
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;

    -- Extend later: clone the latest existing PLAN assortment row.
    WITH target AS MATERIALIZED (
        SELECT DISTINCT d.indx, d."time"
          FROM public.gap_ma_dptflrsetattributes AS d
         WHERE d.product = v_dept
           AND d.ap_start <= NEW.exitdate
           AND d.ap_end >= v_effective_start
    ),
    last_old AS (
        SELECT a.*, d.indx AS source_indx
          FROM public.gap_a_assortment AS a
          JOIN public.gap_ma_dptflrsetattributes AS d
            ON d.product = v_dept
           AND d."time" = a."time"
         WHERE a.product = NEW.product
           AND a.location = NEW.location
           AND a.plan_type = 'plan'
         ORDER BY d.indx DESC, d."time" DESC
         LIMIT 1
    )
    INSERT INTO public.gap_a_assortment (
        product,
        location,
        "time",
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
        created_by,
        updated_by,
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
        cc_flrset_open_10,
        cc_ticketprice_flrset,
        cc_ticketprice_flrset_ecom_us,
        cc_ticketprice_flrset_store_cad,
        cc_ticketprice_flrset_ecom_cad,
        cc_plan_cost_flrset,
        cc_plan_cost_flrset_ecom_us,
        cc_plan_cost_flrset_store_cad,
        cc_plan_cost_flrset_ecom_cad
    )
    SELECT
        l.product,
        l.location,
        t."time",
        l.style,
        l.str_grade,
        l.str_climate,
        l.str_region_combo,
        l.str_hvlc,
        l.str_tourist_border_combo,
        l.ssg,
        l.flnrange,
        l.plan_type,
        l.isfunded,
        l.store_count,
        l.propagate_ranging,
        l.created_by,
        l.updated_by,
        l.str_grade_or,
        l.str_climate_or,
        l.str_region_combo_or,
        l.str_hvlc_or,
        l.str_tourist_border_combo_or,
        l.is_sclr_flrset_locked,
        l.str_grade_cad,
        l.str_climate_cad,
        l.str_region_combo_cad,
        l.str_hvlc_cad,
        l.str_tourist_border_combo_cad,
        l.ssg_cad,
        l.isfunded_cad,
        l.str_grade_ecom,
        l.isfunded_ecom,
        l.str_grade_ecom_cad,
        l.isfunded_ecom_cad,
        l.cc_flrset_open_1,
        l.cc_flrset_open_2,
        l.cc_flrset_open_3,
        l.cc_flrset_open_4,
        l.cc_flrset_open_5,
        l.cc_flrset_open_6,
        l.cc_flrset_open_7,
        l.cc_flrset_open_8,
        l.cc_flrset_open_9,
        l.cc_flrset_open_10,
        l.cc_ticketprice_flrset,
        l.cc_ticketprice_flrset_ecom_us,
        l.cc_ticketprice_flrset_store_cad,
        l.cc_ticketprice_flrset_ecom_cad,
        l.cc_plan_cost_flrset,
        l.cc_plan_cost_flrset_ecom_us,
        l.cc_plan_cost_flrset_store_cad,
        l.cc_plan_cost_flrset_ecom_cad
      FROM last_old AS l
      JOIN target AS t
        ON t.indx > l.source_indx
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;

    -- Contract only PLAN rows that fall outside the new source-derived window.
    -- Preserve source behavior that an empty target window does not wipe data.
    WITH target AS MATERIALIZED (
        SELECT DISTINCT d."time"
          FROM public.gap_ma_dptflrsetattributes AS d
         WHERE d.product = v_dept
           AND d.ap_start <= NEW.exitdate
           AND d.ap_end >= v_effective_start
    )
    DELETE FROM public.gap_a_assortment AS a
     WHERE a.product = NEW.product
       AND a.location = NEW.location
       AND a.plan_type = 'plan'
       AND EXISTS (SELECT 1 FROM target)
       AND NOT EXISTS (
              SELECT 1
                FROM target AS t
               WHERE t."time" = a."time"
       );

    -- V4.6 FIX: a contraction can delete the floorset that held the MAX price or cost,
    -- which would leave scch quoting a value no surviving floorset carries and the
    -- _enabled flags stale. DELETE fires no pricing trigger, so re-derive here.
    -- Skipped entirely when nothing was deleted, which is the common case.
    -- Runs at depth 2, so scch_05_guard_pricing, trg_upd_scch_pricing and
    -- trigger_cost are all correctly inert for this write.
    GET DIAGNOSTICS v_deleted = ROW_COUNT;

    IF v_deleted > 0 THEN
        UPDATE public.gap_ma_stylecolorchannelattributes AS s
           SET ccticketpricechannel           = COALESCE(m.mx_tp,      s.ccticketpricechannel),
               ccticketpricechannel_ecom_us   = COALESCE(m.mx_tp_eus,  s.ccticketpricechannel_ecom_us),
               ccticketpricechannel_store_cad = COALESCE(m.mx_tp_scad, s.ccticketpricechannel_store_cad),
               ccticketpricechannel_ecom_cad  = COALESCE(m.mx_tp_ecad, s.ccticketpricechannel_ecom_cad),
               cc_plan_cost                   = COALESCE(m.mx_pc,      s.cc_plan_cost),
               cc_plan_cost_ecom_us           = COALESCE(m.mx_pc_eus,  s.cc_plan_cost_ecom_us),
               cc_plan_cost_store_cad         = COALESCE(m.mx_pc_scad, s.cc_plan_cost_store_cad),
               cc_plan_cost_ecom_cad          = COALESCE(m.mx_pc_ecad, s.cc_plan_cost_ecom_cad),
               cc_ticketprice_flrset_enabled           = CASE WHEN m.mx_tp       IS DISTINCT FROM m.mn_tp       THEN 1 ELSE 0 END,
               -- V4.6 FIX: channel flags are based on RESOLVED values, not raw
               -- nullable variant storage. Raw MAX remains authoritative for the
               -- scch rollup value above; only the variation test resolves inheritance.
               cc_ticketprice_flrset_ecom_us_enabled   = CASE WHEN m.mxr_tp_eus  IS DISTINCT FROM m.mnr_tp_eus  THEN 1 ELSE 0 END,
               cc_ticketprice_flrset_store_cad_enabled = CASE WHEN m.mxr_tp_scad IS DISTINCT FROM m.mnr_tp_scad THEN 1 ELSE 0 END,
               cc_ticketprice_flrset_ecom_cad_enabled  = CASE WHEN m.mxr_tp_ecad IS DISTINCT FROM m.mnr_tp_ecad THEN 1 ELSE 0 END,
               cc_plan_cost_flrset_enabled             = CASE WHEN m.mx_pc       IS DISTINCT FROM m.mn_pc       THEN 1 ELSE 0 END,
               cc_plan_cost_flrset_ecom_us_enabled     = CASE WHEN m.mxr_pc_eus  IS DISTINCT FROM m.mnr_pc_eus  THEN 1 ELSE 0 END,
               cc_plan_cost_flrset_store_cad_enabled   = CASE WHEN m.mxr_pc_scad IS DISTINCT FROM m.mnr_pc_scad THEN 1 ELSE 0 END,
               cc_plan_cost_flrset_ecom_cad_enabled    = CASE WHEN m.mxr_pc_ecad IS DISTINCT FROM m.mnr_pc_ecad THEN 1 ELSE 0 END,
               cc_final_cost = CASE WHEN m.mx_pc IS NOT NULL THEN m.mx_pc ELSE s.cc_final_cost END,
               -- NULLIF on the divisor is a DELIBERATE local deviation from
               -- trigger_final_cost, which raises division_by_zero on a zero price.
               -- Aborting a lifecycle date edit because of a zero price would be a
               -- regression on a certified path; here a zero price yields 0.0.
               cc_imupct = CASE
                   WHEN m.mx_pc IS NOT NULL
                   THEN COALESCE(round(
                            ((COALESCE(m.mx_tp, s.ccticketpricechannel) - m.mx_pc)
                             / NULLIF(COALESCE(m.mx_tp, s.ccticketpricechannel), 0))::numeric, 2), 0.0)
                   ELSE s.cc_imupct
               END
          FROM (
              SELECT max(x.cc_ticketprice_flrset)           AS mx_tp,
                     min(x.cc_ticketprice_flrset)           AS mn_tp,
                     -- Raw MAX feeds the scch rollup value; resolved MAX/MIN feed
                     -- only the channel _enabled flag. This matches the canonical
                     -- V4.6 pricing-rollup semantics below.
                     max(x.cc_ticketprice_flrset_ecom_us)   AS mx_tp_eus,
                     max(COALESCE(x.cc_ticketprice_flrset_ecom_us, x.cc_ticketprice_flrset))
                                                               AS mxr_tp_eus,
                     min(COALESCE(x.cc_ticketprice_flrset_ecom_us, x.cc_ticketprice_flrset))
                                                               AS mnr_tp_eus,
                     max(x.cc_ticketprice_flrset_store_cad) AS mx_tp_scad,
                     max(COALESCE(x.cc_ticketprice_flrset_store_cad, x.cc_ticketprice_flrset))
                                                               AS mxr_tp_scad,
                     min(COALESCE(x.cc_ticketprice_flrset_store_cad, x.cc_ticketprice_flrset))
                                                               AS mnr_tp_scad,
                     max(x.cc_ticketprice_flrset_ecom_cad)  AS mx_tp_ecad,
                     max(COALESCE(x.cc_ticketprice_flrset_ecom_cad, x.cc_ticketprice_flrset))
                                                               AS mxr_tp_ecad,
                     min(COALESCE(x.cc_ticketprice_flrset_ecom_cad, x.cc_ticketprice_flrset))
                                                               AS mnr_tp_ecad,
                     max(x.cc_plan_cost_flrset)             AS mx_pc,
                     min(x.cc_plan_cost_flrset)             AS mn_pc,
                     max(x.cc_plan_cost_flrset_ecom_us)     AS mx_pc_eus,
                     max(COALESCE(x.cc_plan_cost_flrset_ecom_us, x.cc_plan_cost_flrset))
                                                               AS mxr_pc_eus,
                     min(COALESCE(x.cc_plan_cost_flrset_ecom_us, x.cc_plan_cost_flrset))
                                                               AS mnr_pc_eus,
                     max(x.cc_plan_cost_flrset_store_cad)   AS mx_pc_scad,
                     max(COALESCE(x.cc_plan_cost_flrset_store_cad, x.cc_plan_cost_flrset))
                                                               AS mxr_pc_scad,
                     min(COALESCE(x.cc_plan_cost_flrset_store_cad, x.cc_plan_cost_flrset))
                                                               AS mnr_pc_scad,
                     max(x.cc_plan_cost_flrset_ecom_cad)    AS mx_pc_ecad,
                     max(COALESCE(x.cc_plan_cost_flrset_ecom_cad, x.cc_plan_cost_flrset))
                                                               AS mxr_pc_ecad,
                     min(COALESCE(x.cc_plan_cost_flrset_ecom_cad, x.cc_plan_cost_flrset))
                                                               AS mnr_pc_ecad
                FROM public.gap_a_assortment AS x
               WHERE x.product = NEW.product
          ) AS m
         WHERE s.product = NEW.product;
    END IF;

    -- Preserve the original funding rule and write scope. In particular, the
    -- source query is product-wide and keys funding directly from channel dbt_wk.
    UPDATE public.gap_a_assortment AS a
       SET isfunded = 1
      FROM public.gap_ma_dptflrsetattributes AS d
     WHERE a.product = NEW.product
       AND a."time" = d."time"
       AND d.product = v_dept
       AND EXISTS (
              SELECT 1
                FROM public.gap_ma_stylecolorchannelattributes AS c
               WHERE c.product = NEW.product
                 AND c.dbt_wk >= d.ap_start
                 AND c.dbt_wk <= d.ap_end
       );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 533 (class 1255 OID 134585045)
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
-- TOC entry 534 (class 1255 OID 134585046)
-- Name: trg_ins_stylecolor_alloc_attrs(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trg_ins_stylecolor_alloc_attrs() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO gap_ma_stylecolor_alloc_attributes (product)
    VALUES (NEW.product)
    ON CONFLICT (product) DO NOTHING;      -- avoids duplicate-key errors
    RETURN NEW;                            -- preserve normal insert behaviour
END;
$$;


ALTER FUNCTION public.trg_ins_stylecolor_alloc_attrs() OWNER TO psql;

--
-- TOC entry 535 (class 1255 OID 134585047)
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
-- TOC entry 536 (class 1255 OID 134585048)
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
-- TOC entry 537 (class 1255 OID 134585049)
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
-- TOC entry 538 (class 1255 OID 134585050)
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
-- TOC entry 539 (class 1255 OID 134585051)
-- Name: trigger_final_cost(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_final_cost() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    UPDATE public.gap_ma_stylecolorchannelattributes AS a
       SET cc_final_cost = NEW.cc_plan_cost,
           cc_imupct = COALESCE(
               round(((a.ccticketpricechannel - NEW.cc_plan_cost)
                       / a.ccticketpricechannel)::numeric, 2),
               0.0
           )
     WHERE a.product = NEW.product
       AND (
              a.cc_final_cost IS DISTINCT FROM NEW.cc_plan_cost
           OR a.cc_imupct IS DISTINCT FROM COALESCE(
                  round(((a.ccticketpricechannel - NEW.cc_plan_cost)
                          / a.ccticketpricechannel)::numeric, 2),
                  0.0
              )::real
       );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_final_cost() OWNER TO psql;

--
-- TOC entry 540 (class 1255 OID 134585052)
-- Name: trigger_set_cp_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_cp_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dc_publish real; 
BEGIN
  select dc_publish into v_dc_publish from gap_p_dc_adj where product = NEW.product and time = NEW.time and location = NEW.location;

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
-- TOC entry 541 (class 1255 OID 134585053)
-- Name: trigger_set_dc_ttl_useradj(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_dc_ttl_useradj() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    NEW.dc_ttluseradj := CASE
        WHEN NEW.dc_useradj IS NULL AND NEW.dc_useradj_ecom IS NULL THEN NULL
        ELSE COALESCE(NEW.dc_useradj, 0) + COALESCE(NEW.dc_useradj_ecom, 0)
    END;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_dc_ttl_useradj() OWNER TO psql;

--
-- TOC entry 542 (class 1255 OID 134585054)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from gap_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 543 (class 1255 OID 134585055)
-- Name: trigger_set_pack_ind_flag(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_pack_ind_flag() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
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
-- TOC entry 530 (class 1255 OID 134585056)
-- Name: trigger_set_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
 IF NEW.dc_publish = 1
 THEN
   NEW.created_at = NOW()::timestamp(0);
   NEW.published_at = NOW()::timestamp(0);

   insert into sync_outbound_dataqueue (product,time,publish_type)
   select NEW.product, NEW.time, 'RDY4PO' as publish_type
   ;

   update gap_ma_stylecolorchannelattributes
   set cc_first_publish_date = coalesce(cc_first_publish_date, NOW()::timestamp(0)),
       cc_first_publish_snapshot_op = coalesce(cc_first_publish_snapshot_op, 1)
   where product = NEW.product;

 END IF;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 485 (class 1255 OID 134585057)
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
-- TOC entry 486 (class 1255 OID 134585058)
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
  NEW.updated_at = NOW()::timestamp(0);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO psql;

--
-- TOC entry 487 (class 1255 OID 134585059)
-- Name: update_cc_use_sys_floorset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_use_sys_floorset() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    IF NEW.cc_floorset IS NOT NULL AND NEW.cc_floorset <> '' THEN
        NEW.cc_use_sys_floorset := FALSE;
    ELSIF (NEW.cc_floorset IS NULL OR NEW.cc_floorset = '')
       AND (OLD.cc_floorset IS NOT NULL AND OLD.cc_floorset <> '') THEN
        NEW.cc_use_sys_floorset := TRUE;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_cc_use_sys_floorset() OWNER TO psql;

--
-- TOC entry 544 (class 1255 OID 134585060)
-- Name: update_cc_validsizes_on_ccrangecode(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_validsizes_on_ccrangecode() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
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
      FROM gap_l_sizeeligibility_with_ccrangecode e
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
    FROM gap_l_sizeeligibility_with_ccrangecode e
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
      FROM gap_l_sizeeligibility_with_ccrangecode e
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
    FROM gap_l_sizeeligibility_with_ccrangecode e
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
-- TOC entry 545 (class 1255 OID 134585061)
-- Name: update_ccrangecode_on_class_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ccrangecode_on_class_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_size_range  text;
    v_new_ccrange text;
BEGIN
    -- gap_h_prodstd carries hierarchy ancestors but not the product level.
    -- Resolve the triggering row's level from gap_d_product.
    IF NOT EXISTS (
        SELECT 1
          FROM public.gap_d_product AS p
         WHERE p.id = NEW.id
           AND p.levelid = 'style'
    ) THEN
        RETURN NEW;
    END IF;

    SELECT s.sty_size_range
      INTO v_size_range
      FROM public.gap_ma_styleattributes AS s
     WHERE s.product = NEW.id;

    IF v_size_range IS NULL OR NEW.ancestor1 IS NULL THEN
        RETURN NEW;
    END IF;

    v_new_ccrange := btrim(v_size_range) || ' - ' || btrim(NEW.ancestor1);

    UPDATE public.gap_ma_stylecolorchannelattributes AS s
       SET ccrangecode = v_new_ccrange
      FROM public.gap_h_prodstd AS ch
     WHERE ch.ancestor0 = NEW.id
       AND EXISTS (
           SELECT 1
             FROM public.gap_d_product AS cp
            WHERE cp.id = ch.id
              AND cp.levelid = 'stylecolor'
       )
       AND s.product = ch.id
       AND s.ccrangecode IS DISTINCT FROM v_new_ccrange;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_ccrangecode_on_class_change() OWNER TO psql;

--
-- TOC entry 546 (class 1255 OID 134585062)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_style_name        text;
    v_style_description text;
    v_color_code        text;
    v_color_name        text;
    v_color_id          text;
    v_color_group       text;
    v_new_name          text;
    v_new_description   text;
BEGIN
    SELECT p.name, p.description
      INTO v_style_name, v_style_description
      FROM public.gap_h_prodstd AS h
      JOIN public.gap_d_product AS p
        ON p.id = h.ancestor0
     WHERE h.id = NEW.product;

    IF NULLIF(NEW.cccolor, '') IS NOT NULL THEN
        -- One indexed scan (ldl_lookuptarget) instead of five scalar subqueries.
        SELECT max(d.target_value) FILTER (WHERE d.target_id = 'color_code'),
               max(d.target_value) FILTER (WHERE d.target_id = 'color_description'),
               max(d.target_value) FILTER (WHERE d.target_id = 'color_id'),
               max(d.target_value) FILTER (WHERE d.target_id = 'color_group')
          INTO v_color_code, v_color_name, v_color_id, v_color_group
          FROM public.gap_l_dependencylookup AS d
         WHERE d.lookup_id = 'cccolor'
           AND d.lookup_value = NEW.cccolor
           AND d.target_id IN ('color_code','color_description','color_id','color_group');

        v_new_name        := v_style_name || v_color_code;
        v_new_description := v_style_description || ':' || v_color_name;
    ELSE
        -- Four locals stay NULL, which is what the original's no-color branch wrote.
        v_new_name        := v_style_name || ' NoColor';
        v_new_description := v_style_description || ' No Color';
    END IF;

    UPDATE public.gap_ma_stylecolorattributes AS a
       SET cc_color_code  = v_color_code,
           color_name     = v_color_name,
           cccolorid      = v_color_id,
           cc_color_group = v_color_group
     WHERE a.product = NEW.product
       AND (   a.cc_color_code  IS DISTINCT FROM v_color_code
            OR a.color_name     IS DISTINCT FROM v_color_name
            OR a.cccolorid      IS DISTINCT FROM v_color_id
            OR a.cc_color_group IS DISTINCT FROM v_color_group);

    UPDATE public.gap_d_product AS p
       SET description = v_new_description,
           name        = v_new_name
     WHERE p.id = NEW.product
       AND (   p.description IS DISTINCT FROM v_new_description
            OR p.name        IS DISTINCT FROM v_new_name);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 547 (class 1255 OID 134585063)
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
 from gap_p_itemprice 
 where product=NEW.product and location=NEW.location and time=NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
 from gap_l_priceeventlookup 
 where product=NEW.department and location=NEW.location and ccpriceevent=NEW.event;

select cc_discount_pct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
 from gap_ma_stylecolorchannelattributes 
 where product=NEW.product and location=NEW.location;
/*
select cc_current_price::real into v_ticketprice 
 from gap_ma_stylecolorattributes 
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
update gap_p_itemprice a set eff_aur=final_eff_aur where product=NEW.product and location=NEW.location and time=NEW.time;

-- update gap_an_price_storecount_info set expressed_aur=final_eff_aur where product=NEW.product and channel=NEW.location and time=NEW.time
--   ;
-- 
-- update gap_an_price_storecount_info a
--   set v_A=b.v_A
-- FROM
--   (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A from gap_an_price_storecount_info a
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time) b
-- WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
-- ;
-- 
--   update gap_an_price_storecount_info a
--     set v_B=b.v_B
--   FROM
--     (select product, time, seq, addoff, corpaddoff
--       , case when seq=0 then
--           (case when final_eff_aur > 0 then final_eff_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
--        else curp end as v_B
--        from gap_an_price_storecount_info a 
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--     ) b
--   WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--   ;
-- 
-- update gap_an_price_storecount_info set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)
--   WHERE product=NEW.product and channel=NEW.location and time=NEW.time;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 548 (class 1255 OID 134585064)
-- Name: update_eligibility_from_null_to_zero(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_eligibility_from_null_to_zero() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- Clear the selected clusters for the product in blk_ma_stylecolorchannelattributes table
      UPDATE gap_p_stylecolor_store_eligibility
      SET sclr_str_eligibility = 0
      WHERE sclr_str_eligibility is null and product = NEW.product and location = NEW.location;

      RETURN NEW;
  END;
  $$;


ALTER FUNCTION public.update_eligibility_from_null_to_zero() OWNER TO psql;

--
-- TOC entry 549 (class 1255 OID 134585065)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE

BEGIN


  if NEW.name <> OLD.name or NEW.description <> OLD.description then
    update gap_d_product x
    set description = NEW.description || ':' || y.color_name,
        name = NEW.name || y.cc_color_code
    from (select a.id, b.cc_color_code, b.color_name from gap_h_prodstd a, gap_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
    where x.id = y.id;

     update gap_ma_stylecolorattributes n
    set stylecolor_name = NEW.name || ':' || m.color_name,
        style_name = NEW.name
    from (select a.id, b.cc_color_code, b.color_name from gap_h_prodstd a, gap_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) m
    where n.product = m.id;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 550 (class 1255 OID 134585066)
-- Name: update_on_auto_rollforward(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_on_auto_rollforward() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE


BEGIN

update gap_ma_stylecolorchannelattributes
set exitdate = (select value from gap_serviceparams where id = 'extended_range'),
    erlstmkdnwk = (select id from gap_d_time where indx = (select indx - 1 from gap_d_time where id = (select value from gap_serviceparams where id = 'extended_range')))
where product = new.product;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_on_auto_rollforward() OWNER TO psql;

--
-- TOC entry 551 (class 1255 OID 134585067)
-- Name: update_stylecolorchannelattributes_ccrangecode(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorchannelattributes_ccrangecode() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
BEGIN
    IF NEW.sty_size_range IS NOT DISTINCT FROM OLD.sty_size_range THEN
        RETURN NEW;
    END IF;

    UPDATE public.gap_ma_stylecolorchannelattributes AS a
       SET ccrangecode = NEW.sty_size_range || ' - ' || h.ancestor2,
           cc_validsizes_store = COALESCE(l.validsizes, '{}'::text[]),
           cc_validsizes_ecom  = COALESCE(l.validsizes, '{}'::text[])
      FROM public.gap_h_prodstd AS h
      JOIN public.gap_d_product AS p
        ON p.id = h.id
       AND p.levelid = 'stylecolor'
      LEFT JOIN LATERAL (
          SELECT array_agg(DISTINCT d.target_value ORDER BY d.target_value)::text[] AS validsizes
            FROM public.gap_l_dependencylookup AS d
           WHERE d.lookup_id = 'size_range'
             AND d.lookup_value = NEW.sty_size_range
      ) AS l ON TRUE
     WHERE a.product = h.id
       AND h.ancestor0 = NEW.product
       AND (
              a.ccrangecode IS DISTINCT FROM NEW.sty_size_range || ' - ' || h.ancestor2
           OR a.cc_validsizes_store IS DISTINCT FROM COALESCE(l.validsizes, '{}'::text[])
           OR a.cc_validsizes_ecom IS DISTINCT FROM COALESCE(l.validsizes, '{}'::text[])
       );

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorchannelattributes_ccrangecode() OWNER TO psql;

--
-- TOC entry 552 (class 1255 OID 134585068)
-- Name: update_trigger_cartparams_irw_debut_offset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_trigger_cartparams_irw_debut_offset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.dbt_wk IS DISTINCT FROM OLD.dbt_wk THEN
    SELECT irw_offset.id
    INTO NEW.initrcptwk
    FROM gap_d_time current
    INNER JOIN gap_d_time irw_offset
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
-- TOC entry 553 (class 1255 OID 134585069)
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
    select b.product,b.location,a.indx,a.time from gap_ma_dptflrsetattributes a, cart_params_temp b, 
    (select value as plan_current from gap_serviceparams where id='plan_current') c,
    (select value as plan_end from gap_serviceparams where id='plan_end') d
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
-- TOC entry 554 (class 1255 OID 134585070)
-- Name: update_week_indxes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_week_indxes() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_relaunchweek                 text;
    v_dbtwk_indx                   integer;
    v_relaunchwk_indx              integer;
    v_mdstart_indx                 integer;
    v_exitdate_indx                integer;
    v_irw_indx                     integer;
    v_lastdcorder_indx             integer;
    v_initrcptwk                   text;
    v_lastdcorder                  text;
    v_lastdcorder_auto_roll        text;
    v_update_act_dbt               boolean := FALSE;
    v_update_indexes               boolean := FALSE;
    v_roll                         boolean := FALSE;
BEGIN
    v_relaunchweek := NULLIF(NEW.relaunchweek, '');

    IF TG_OP = 'UPDATE'
       AND NEW.dbt_wk IS DISTINCT FROM OLD.dbt_wk
       AND OLD.dbt_wk = OLD.act_dbt_wk
       AND NEW.dbt_wk < NEW.erlstmkdnwk
    THEN
        v_update_act_dbt := TRUE;
    END IF;

    SELECT max(t.indx) FILTER (WHERE t.id = COALESCE(v_relaunchweek, NEW.dbt_wk)),
           max(t.indx) FILTER (WHERE t.id = v_relaunchweek),
           max(t.indx) FILTER (WHERE t.id = NEW.erlstmkdnwk),
           max(t.indx) FILTER (WHERE t.id = NEW.exitdate)
      INTO v_dbtwk_indx,
           v_relaunchwk_indx,
           v_mdstart_indx,
           v_exitdate_indx
      FROM public.gap_d_time AS t
     WHERE t.id IN (
           COALESCE(v_relaunchweek, NEW.dbt_wk),
           v_relaunchweek,
           NEW.erlstmkdnwk,
           NEW.exitdate
     );

    -- Preserve the original write-window guard exactly. The effective debut
    -- index may come from relaunchweek, but the legacy decision to write the
    -- derived fields was based on dbt_wk < markdown < exitdate.
    v_update_indexes :=
           NEW.dbt_wk < NEW.erlstmkdnwk
       AND NEW.erlstmkdnwk < NEW.exitdate;

    IF v_update_act_dbt THEN
        NEW.act_dbt_wk := NEW.dbt_wk;
    END IF;

    -- Preserve legacy three-valued semantics exactly:
    -- TRUE  -> derive/write lifecycle fields
    -- FALSE -> leave existing/supplied derived fields untouched
    -- NULL  -> leave existing/supplied derived fields untouched
    --
    -- Do NOT invert this boolean guard: NOT NULL is NULL in SQL.
    IF v_update_indexes IS NOT TRUE THEN
        RETURN NEW;
    END IF;

    SELECT min(v_dbtwk_indx - d.irw_debut_offset)
      INTO v_irw_indx
      FROM public.gap_h_prodstd AS h
      JOIN public.gap_ma_dptflrsetattributes AS d
        ON d.product = h.ancestor3
     WHERE h.id = NEW.product
       AND NEW.dbt_wk BETWEEN d.ap_start AND d.ap_end;

    v_lastdcorder_indx := v_mdstart_indx - 4;

    -- gap_d_time.indx is a certified unique invariant in GAP. Scalar lookups
    -- deliberately fail loudly if that invariant is violated later.
    v_initrcptwk := (
        SELECT t.id FROM public.gap_d_time AS t WHERE t.indx = v_irw_indx
    );
    v_lastdcorder := (
        SELECT t.id FROM public.gap_d_time AS t WHERE t.indx = v_lastdcorder_indx
    );
    v_lastdcorder_auto_roll := (
        SELECT t.id FROM public.gap_d_time AS t WHERE t.indx = v_mdstart_indx - 1
    );

    v_roll := (NEW.auto_rollforward IS DISTINCT FROM FALSE);

    NEW.irw_indx := v_irw_indx;
    NEW.dbtwk_indx := v_dbtwk_indx;
    NEW.relaunchwk_indx := v_relaunchwk_indx;
    NEW.mdstart_indx := v_mdstart_indx;
    NEW.exitdate_indx := v_exitdate_indx;
    NEW.too := v_mdstart_indx - v_dbtwk_indx;
    NEW.mkdnwks := v_exitdate_indx - v_mdstart_indx;
    NEW.initrcptwk := v_initrcptwk;

    IF v_roll THEN
        NEW.lastdcorder_indx := v_lastdcorder_indx;
        NEW.last_rcpt_wk := v_lastdcorder_auto_roll;
        NEW.lastdcorder := v_lastdcorder_auto_roll;
        NEW.planned_sell_down_week := v_lastdcorder_auto_roll;
    ELSE
        NEW.lastdcorder_indx := v_lastdcorder_indx;
        NEW.last_rcpt_wk := v_lastdcorder;
        NEW.lastdcorder := v_lastdcorder;
        -- Preserve existing planned_sell_down_week in non-roll mode.
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

--
-- TOC entry 555 (class 1255 OID 134585071)
-- Name: validate_lifecycle_weeks(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_lifecycle_weeks() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    v_bad_dbt  boolean;
    v_bad_exit boolean;
    v_bad_md   boolean;
BEGIN
    -- IMPORTANT: compute all three validity decisions before changing NEW.
    -- The original package's independent AFTER-trigger WHEN clauses all saw the
    -- originally submitted row. Mutating NEW after the first check would otherwise
    -- change the outcome of a simultaneous DBT/Exit/Markdown edit.
    v_bad_dbt :=
           NEW.dbt_wk IS DISTINCT FROM OLD.dbt_wk
       AND NEW.dbt_wk >= NEW.erlstmkdnwk;

    v_bad_exit :=
           NEW.exitdate IS DISTINCT FROM OLD.exitdate
       AND NEW.exitdate <= NEW.erlstmkdnwk;

    v_bad_md :=
           NEW.erlstmkdnwk IS DISTINCT FROM OLD.erlstmkdnwk
       AND (
              (
                  NEW.relaunchweek IS NULL
                  AND (
                         NEW.erlstmkdnwk <= NEW.dbt_wk
                      OR NEW.exitdate <= NEW.erlstmkdnwk
                  )
              )
           OR (
                  NEW.relaunchweek IS NOT NULL
                  AND (
                         NEW.erlstmkdnwk <= NEW.relaunchweek
                      OR NEW.exitdate <= NEW.erlstmkdnwk
                  )
              )
       );

    IF v_bad_dbt IS TRUE THEN
        NEW.dbt_wk := OLD.dbt_wk;
    END IF;

    IF v_bad_exit IS TRUE THEN
        NEW.exitdate := OLD.exitdate;
    END IF;

    IF v_bad_md IS TRUE THEN
        NEW.erlstmkdnwk := OLD.erlstmkdnwk;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_lifecycle_weeks() OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 242 (class 1259 OID 134585072)
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
-- TOC entry 243 (class 1259 OID 134585080)
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
-- TOC entry 244 (class 1259 OID 134585087)
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
-- TOC entry 245 (class 1259 OID 134585094)
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
-- TOC entry 246 (class 1259 OID 134585102)
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
-- TOC entry 247 (class 1259 OID 134585107)
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
-- TOC entry 248 (class 1259 OID 134585112)
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
-- TOC entry 249 (class 1259 OID 134585120)
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
-- TOC entry 250 (class 1259 OID 134585128)
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
-- TOC entry 251 (class 1259 OID 134585133)
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
-- TOC entry 252 (class 1259 OID 134585138)
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
-- TOC entry 253 (class 1259 OID 134585143)
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
-- TOC entry 254 (class 1259 OID 134585148)
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
-- TOC entry 255 (class 1259 OID 134585153)
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
-- TOC entry 256 (class 1259 OID 134585158)
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
-- TOC entry 257 (class 1259 OID 134585163)
-- Name: bulk_import_run_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_run_params (
    run_id integer NOT NULL,
    param text NOT NULL,
    str_value text
);


ALTER TABLE public.bulk_import_run_params OWNER TO psql;

--
-- TOC entry 258 (class 1259 OID 134585168)
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
-- TOC entry 259 (class 1259 OID 134585169)
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
-- TOC entry 260 (class 1259 OID 134585176)
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
-- TOC entry 261 (class 1259 OID 134585183)
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
-- TOC entry 262 (class 1259 OID 134585191)
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
-- TOC entry 263 (class 1259 OID 134585199)
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
-- TOC entry 264 (class 1259 OID 134585206)
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
-- TOC entry 265 (class 1259 OID 134585211)
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
-- TOC entry 266 (class 1259 OID 134585216)
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
-- TOC entry 267 (class 1259 OID 134585221)
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
-- TOC entry 268 (class 1259 OID 134585224)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 269 (class 1259 OID 134585229)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    department text,
    default_discount real
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 270 (class 1259 OID 134585234)
-- Name: default_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_l_dependencylookup (
    lookup_id text,
    lookup_value text,
    target_id text,
    target_value text
);


ALTER TABLE public.default_l_dependencylookup OWNER TO psql;

--
-- TOC entry 271 (class 1259 OID 134585239)
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
-- TOC entry 272 (class 1259 OID 134585244)
-- Name: deleteme_gap_d_product_20260830; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_gap_d_product_20260830 (
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


ALTER TABLE public.deleteme_gap_d_product_20260830 OWNER TO psql;

--
-- TOC entry 273 (class 1259 OID 134585249)
-- Name: deleteme_gap_d_product_oldhier; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_gap_d_product_oldhier (
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


ALTER TABLE public.deleteme_gap_d_product_oldhier OWNER TO psql;

--
-- TOC entry 274 (class 1259 OID 134585254)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 275 (class 1259 OID 134585259)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 276 (class 1259 OID 134585264)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 277 (class 1259 OID 134585269)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 278 (class 1259 OID 134585274)
-- Name: dept_plan_items_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_temp OWNER TO psql;

--
-- TOC entry 279 (class 1259 OID 134585279)
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
-- TOC entry 280 (class 1259 OID 134585286)
-- Name: eligibility_corr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.eligibility_corr (
    department text NOT NULL,
    size_range text NOT NULL,
    sizeattr text NOT NULL,
    web_eligible smallint DEFAULT 0 NOT NULL,
    store_eligible smallint DEFAULT 0 NOT NULL,
    store_ineligible smallint DEFAULT 0 NOT NULL,
    web_ineligible smallint DEFAULT 0 NOT NULL,
    CONSTRAINT eligibility_corr_store_eligible_chk CHECK ((store_eligible = ANY (ARRAY[0, 1]))),
    CONSTRAINT eligibility_corr_store_ineligible_chk CHECK ((store_ineligible = ANY (ARRAY[0, 1]))),
    CONSTRAINT eligibility_corr_web_eligible_chk CHECK ((web_eligible = ANY (ARRAY[0, 1]))),
    CONSTRAINT eligibility_corr_web_ineligible_chk CHECK ((web_ineligible = ANY (ARRAY[0, 1])))
);


ALTER TABLE public.eligibility_corr OWNER TO psql;

--
-- TOC entry 281 (class 1259 OID 134585299)
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
    priority integer,
    instance_id text
);


ALTER TABLE public.failed_items OWNER TO psql;

--
-- TOC entry 282 (class 1259 OID 134585304)
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
-- TOC entry 283 (class 1259 OID 134585309)
-- Name: fcstable_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.fcstable_product (
    product text
);


ALTER TABLE public.fcstable_product OWNER TO psql;

--
-- TOC entry 284 (class 1259 OID 134585314)
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
-- TOC entry 285 (class 1259 OID 134585319)
-- Name: gap_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_a_assortment (
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
    cc_flrset_open_10 text,
    cc_ticketprice_flrset real,
    cc_ticketprice_flrset_ecom_us real,
    cc_ticketprice_flrset_store_cad real,
    cc_ticketprice_flrset_ecom_cad real,
    cc_plan_cost_flrset real,
    cc_plan_cost_flrset_ecom_us real,
    cc_plan_cost_flrset_store_cad real,
    cc_plan_cost_flrset_ecom_cad real
);


ALTER TABLE public.gap_a_assortment OWNER TO psql;

--
-- TOC entry 286 (class 1259 OID 134585338)
-- Name: gap_a_assortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_a_assortment_bk (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_climate text[],
    str_region_combo text[],
    str_hvlc text[],
    str_tourist_border_combo text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
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
    isfunded_cad integer,
    str_grade_ecom text[],
    isfunded_ecom integer,
    str_grade_ecom_cad text[],
    isfunded_ecom_cad integer,
    cc_flrset_open_1 text,
    cc_flrset_open_2 text,
    cc_flrset_open_3 text,
    cc_flrset_open_4 text,
    cc_flrset_open_5 text,
    cc_flrset_open_6 text,
    cc_flrset_open_7 text,
    cc_flrset_open_8 text,
    cc_flrset_open_9 text,
    cc_flrset_open_10 text,
    cc_ticketprice_flrset real,
    cc_ticketprice_flrset_ecom_us real,
    cc_ticketprice_flrset_store_cad real,
    cc_ticketprice_flrset_ecom_cad real,
    cc_plan_cost_flrset real,
    cc_plan_cost_flrset_ecom_us real,
    cc_plan_cost_flrset_store_cad real,
    cc_plan_cost_flrset_ecom_cad real
);


ALTER TABLE public.gap_a_assortment_bk OWNER TO psql;

--
-- TOC entry 287 (class 1259 OID 134585343)
-- Name: gap_a_assortment_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_a_assortment_bkp (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_climate text[],
    str_region_combo text[],
    str_hvlc text[],
    str_tourist_border_combo text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
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
    isfunded_cad integer,
    str_grade_ecom text[],
    isfunded_ecom integer,
    str_grade_ecom_cad text[],
    isfunded_ecom_cad integer,
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


ALTER TABLE public.gap_a_assortment_bkp OWNER TO psql;

--
-- TOC entry 288 (class 1259 OID 134585348)
-- Name: gap_a_assortment_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_a_assortment_storecount (
    product text,
    "time" text,
    location text,
    ssg text[],
    department text,
    store_count integer
);


ALTER TABLE public.gap_a_assortment_storecount OWNER TO psql;

--
-- TOC entry 289 (class 1259 OID 134585353)
-- Name: gap_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_an_price_storecount_info (
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


ALTER TABLE public.gap_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 290 (class 1259 OID 134585358)
-- Name: gap_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_authorization (
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


ALTER TABLE public.gap_authorization OWNER TO psql;

--
-- TOC entry 291 (class 1259 OID 134585370)
-- Name: gap_c_conversion_file; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_file (
    brand text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_desc text,
    orig_price_us real,
    orig_price_cad real,
    curr_price_us real,
    curr_price_cad real,
    plan_cost_us real,
    plan_cost_ecom_us real,
    plan_cost_cad real,
    plan_cost_ecom_cad real,
    bom_style_id text,
    bom_style_color_id text,
    cc_discount_pct real,
    cc_discount_pct_ecom_us real,
    cc_discount_pct_store_cad real,
    cc_discount_pct_ecom_cad real,
    debut_week text,
    md_week text,
    exit_week text,
    auto_roll_forward boolean,
    md_strategy text,
    ssg text,
    size_range text,
    valid_sizes_stores text,
    valid_sizes_ecom text,
    cc_size_eligibility_profile text,
    size_min real,
    size_min_weeks real,
    pre_ssn_rating_strs real,
    pre_ssn_rating_ecom real,
    receipt_interval real,
    return_rate_strs real,
    return_rate_ecom real,
    order_min real,
    order_multiple real,
    cc_service_level real,
    cc_service_level_ecom real,
    irw_debut_offset real
);


ALTER TABLE public.gap_c_conversion_file OWNER TO psql;

--
-- TOC entry 292 (class 1259 OID 134585375)
-- Name: gap_c_conversion_file_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_file_lifecycle (
    brand text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_desc text,
    orig_price_us real,
    orig_price_cad real,
    curr_price_us real,
    curr_price_cad real,
    plan_cost_us real,
    plan_cost_ecom_us real,
    plan_cost_cad real,
    plan_cost_ecom_cad real,
    bom_style_id text,
    bom_style_color_id text,
    cc_discount_pct real,
    cc_discount_pct_ecom_us real,
    cc_discount_pct_store_cad real,
    cc_discount_pct_ecom_cad real,
    debut_week text,
    md_week text,
    exit_week text,
    auto_roll_forward boolean,
    md_strategy text,
    ssg text,
    size_range text,
    valid_sizes_stores text,
    valid_sizes_ecom text,
    cc_size_eligibility_profile text,
    size_min real,
    size_min_weeks real,
    pre_ssn_rating_strs real,
    pre_ssn_rating_ecom real,
    receipt_interval real,
    return_rate_strs real,
    return_rate_ecom real,
    order_min real,
    order_multiple real,
    cc_service_level real,
    cc_service_level_ecom real,
    irw_debut_offset real,
    irw text,
    initrcptwk text,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    style text,
    subclass text,
    class text,
    department text
);


ALTER TABLE public.gap_c_conversion_file_lifecycle OWNER TO psql;

--
-- TOC entry 293 (class 1259 OID 134585380)
-- Name: gap_c_conversion_history_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_history_lifecycle (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[],
    original_ticket_price real,
    current_ticket_price real,
    avg_unit_cost real,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    style text,
    subclass text,
    class text,
    department text,
    sty_size_range text
);


ALTER TABLE public.gap_c_conversion_history_lifecycle OWNER TO psql;

--
-- TOC entry 294 (class 1259 OID 134585385)
-- Name: gap_c_conversion_history_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_history_stylecolorchannelattributes (
    product text,
    location text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    too integer,
    mkdnwks integer,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    act_initrcptwk text,
    act_dbt_wk text,
    irw_indx integer,
    dbtwk_indx integer,
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    ccmdstrategy text,
    slsrnk_store integer,
    slsrnk_ecom integer,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    cc_presmin integer,
    cc_presmin_weeks integer,
    cc_rcptint integer,
    cc_return_u_pct_store numeric,
    cc_return_u_pct_ecom numeric,
    cc_return_u_pct_cross numeric,
    cc_ordermultiple integer,
    cc_ordermin integer,
    ccticketpricechannel real,
    cc_orig_unit_retail real,
    cc_imupct real,
    cc_discount_pct numeric,
    cc_plan_cost real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text
);


ALTER TABLE public.gap_c_conversion_history_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 295 (class 1259 OID 134585390)
-- Name: gap_c_conversion_history_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_history_validsizes (
    product text,
    valid_sizes text
);


ALTER TABLE public.gap_c_conversion_history_validsizes OWNER TO psql;

--
-- TOC entry 296 (class 1259 OID 134585395)
-- Name: gap_c_conversion_validsizes_final; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_conversion_validsizes_final (
    stylecolor text,
    cc_validsizes_store_us text[],
    cc_validsizes_store_cad text[],
    cc_validsizes_ecom_us text[],
    cc_validsizes_ecom_cad text[]
);


ALTER TABLE public.gap_c_conversion_validsizes_final OWNER TO psql;

--
-- TOC entry 297 (class 1259 OID 134585400)
-- Name: gap_c_cutover_prep_history; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_c_cutover_prep_history (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[],
    original_ticket_price real,
    current_ticket_price real,
    avg_unit_cost real
);


ALTER TABLE public.gap_c_cutover_prep_history OWNER TO psql;

--
-- TOC entry 298 (class 1259 OID 134585405)
-- Name: gap_cluster_view_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_cluster_view_tbl (
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


ALTER TABLE public.gap_cluster_view_tbl OWNER TO psql;

--
-- TOC entry 299 (class 1259 OID 134585417)
-- Name: gap_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_corpdisc (
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


ALTER TABLE public.gap_corpdisc OWNER TO psql;

--
-- TOC entry 300 (class 1259 OID 134585431)
-- Name: gap_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_corpdisc_backup (
    department text,
    product text,
    location text,
    "time" text,
    prodlife text,
    corpaddoff real,
    corpexcl real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    corpaddoff_ecom real,
    corpaddoff_ecom_cad real,
    corpaddoff_store_cad real,
    corpexcl_ecom real,
    corpexcl_stores_cad real,
    corpexcl_ecom_cad real
);


ALTER TABLE public.gap_corpdisc_backup OWNER TO psql;

--
-- TOC entry 301 (class 1259 OID 134585436)
-- Name: gap_corpdisc_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_corpdisc_temp (
    department text,
    product text,
    "time" text,
    corpaddoff_ecom real,
    corpaddoff_store real,
    corpaddoff_ecom_cad real,
    corpaddoff_store_cad real,
    corpexcl_stores real,
    corpexcl_ecom real,
    corpexcl_ecom_cad real,
    corpexcl_stores_cad real
);


ALTER TABLE public.gap_corpdisc_temp OWNER TO psql;

--
-- TOC entry 302 (class 1259 OID 134585441)
-- Name: gap_cost_update; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_cost_update (
    product text NOT NULL,
    avg_unit_cost_store_us numeric(18,4),
    avg_unit_cost_store_cad numeric(18,4),
    avg_unit_cost_ecom_us numeric(18,4),
    avg_unit_cost_ecom_cad numeric(18,4)
);


ALTER TABLE public.gap_cost_update OWNER TO psql;

--
-- TOC entry 303 (class 1259 OID 134585446)
-- Name: gap_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_cluster (
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


ALTER TABLE public.gap_d_cluster OWNER TO psql;

--
-- TOC entry 304 (class 1259 OID 134585458)
-- Name: gap_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_location (
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


ALTER TABLE public.gap_d_location OWNER TO psql;

--
-- TOC entry 305 (class 1259 OID 134585470)
-- Name: gap_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_prodlife (
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


ALTER TABLE public.gap_d_prodlife OWNER TO psql;

--
-- TOC entry 306 (class 1259 OID 134585482)
-- Name: gap_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_product (
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


ALTER TABLE public.gap_d_product OWNER TO psql;

--
-- TOC entry 307 (class 1259 OID 134585494)
-- Name: gap_d_product_delete_old_hier; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_product_delete_old_hier (
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


ALTER TABLE public.gap_d_product_delete_old_hier OWNER TO psql;

--
-- TOC entry 308 (class 1259 OID 134585499)
-- Name: gap_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_d_time (
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


ALTER TABLE public.gap_d_time OWNER TO psql;

--
-- TOC entry 309 (class 1259 OID 134585511)
-- Name: gap_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_designimages (
    product text,
    img text
);


ALTER TABLE public.gap_designimages OWNER TO psql;

--
-- TOC entry 310 (class 1259 OID 134585516)
-- Name: gap_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_eohdata_stylecolor (
    product text NOT NULL,
    channel text,
    eohu real
);


ALTER TABLE public.gap_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 311 (class 1259 OID 134585521)
-- Name: gap_floorset_week_attributes_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_floorset_week_attributes_tbl (
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


ALTER TABLE public.gap_floorset_week_attributes_tbl OWNER TO psql;

--
-- TOC entry 312 (class 1259 OID 134585533)
-- Name: gap_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_timeflrset (
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


ALTER TABLE public.gap_h_timeflrset OWNER TO psql;

--
-- TOC entry 313 (class 1259 OID 134585545)
-- Name: gap_for_tgt_flrset_hier; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.gap_for_tgt_flrset_hier AS
 SELECT a.id,
    a.indx,
    b.ancestor0 AS superset,
    b.ancestor1 AS fiscal_year,
    (now())::timestamp(0) without time zone AS updated_at
   FROM public.gap_d_time a,
    public.gap_h_timeflrset b
  WHERE ((a.levelid = 'floorset'::text) AND (a.id = b.id));


ALTER VIEW public.gap_for_tgt_flrset_hier OWNER TO psql;

--
-- TOC entry 314 (class 1259 OID 134585549)
-- Name: gap_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_h_clusterstd OWNER TO psql;

--
-- TOC entry 315 (class 1259 OID 134585561)
-- Name: gap_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_h_locdc OWNER TO psql;

--
-- TOC entry 316 (class 1259 OID 134585573)
-- Name: gap_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_locdcstd (
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


ALTER TABLE public.gap_h_locdcstd OWNER TO psql;

--
-- TOC entry 317 (class 1259 OID 134585585)
-- Name: gap_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_h_locstd OWNER TO psql;

--
-- TOC entry 318 (class 1259 OID 134585596)
-- Name: gap_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_h_prodlifestd OWNER TO psql;

--
-- TOC entry 319 (class 1259 OID 134585608)
-- Name: gap_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_prodstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_h_prodstd OWNER TO psql;

--
-- TOC entry 320 (class 1259 OID 134585619)
-- Name: gap_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_h_timestd (
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


ALTER TABLE public.gap_h_timestd OWNER TO psql;

--
-- TOC entry 321 (class 1259 OID 134585631)
-- Name: gap_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_dclookup (
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


ALTER TABLE public.gap_l_dclookup OWNER TO psql;

--
-- TOC entry 322 (class 1259 OID 134585643)
-- Name: gap_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_dependencylookup (
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


ALTER TABLE public.gap_l_dependencylookup OWNER TO psql;

--
-- TOC entry 323 (class 1259 OID 134585657)
-- Name: gap_l_dependencylookup_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.gap_l_dependencylookup_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gap_l_dependencylookup_seq OWNER TO psql;

--
-- TOC entry 324 (class 1259 OID 134585658)
-- Name: gap_l_pricebandlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_pricebandlookup (
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


ALTER TABLE public.gap_l_pricebandlookup OWNER TO psql;

--
-- TOC entry 325 (class 1259 OID 134585670)
-- Name: gap_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_priceeventlookup (
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


ALTER TABLE public.gap_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 326 (class 1259 OID 134585684)
-- Name: gap_l_sizeeligibility; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_sizeeligibility (
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


ALTER TABLE public.gap_l_sizeeligibility OWNER TO psql;

--
-- TOC entry 327 (class 1259 OID 134585689)
-- Name: gap_l_sizeeligibility_eb_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_sizeeligibility_eb_bkp (
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


ALTER TABLE public.gap_l_sizeeligibility_eb_bkp OWNER TO psql;

--
-- TOC entry 328 (class 1259 OID 134585694)
-- Name: gap_l_sizeeligibility_with_ccrangecode; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_sizeeligibility_with_ccrangecode (
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


ALTER TABLE public.gap_l_sizeeligibility_with_ccrangecode OWNER TO psql;

--
-- TOC entry 329 (class 1259 OID 134585699)
-- Name: gap_l_sizeeligibility_with_ccrangecode_eb_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_sizeeligibility_with_ccrangecode_eb_bkp (
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


ALTER TABLE public.gap_l_sizeeligibility_with_ccrangecode_eb_bkp OWNER TO psql;

--
-- TOC entry 330 (class 1259 OID 134585704)
-- Name: gap_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_ssglookup (
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


ALTER TABLE public.gap_l_ssglookup OWNER TO psql;

--
-- TOC entry 331 (class 1259 OID 134585718)
-- Name: gap_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_storedclookup (
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


ALTER TABLE public.gap_l_storedclookup OWNER TO psql;

--
-- TOC entry 332 (class 1259 OID 134585730)
-- Name: gap_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_storelookup (
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


ALTER TABLE public.gap_l_storelookup OWNER TO psql;

--
-- TOC entry 333 (class 1259 OID 134585744)
-- Name: gap_l_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_l_ticketprice (
    product text,
    usd_ticket_price real,
    cad_ticket_price real,
    price_band text
);


ALTER TABLE public.gap_l_ticketprice OWNER TO psql;

--
-- TOC entry 334 (class 1259 OID 134585749)
-- Name: gap_ma_departmentalloc_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_departmentalloc_attributes (
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


ALTER TABLE public.gap_ma_departmentalloc_attributes OWNER TO psql;

--
-- TOC entry 335 (class 1259 OID 134585781)
-- Name: gap_ma_departmentquarter_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_departmentquarter_attributes (
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


ALTER TABLE public.gap_ma_departmentquarter_attributes OWNER TO psql;

--
-- TOC entry 336 (class 1259 OID 134585801)
-- Name: gap_ma_departmentquarter_attributes_temporary; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_departmentquarter_attributes_temporary (
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


ALTER TABLE public.gap_ma_departmentquarter_attributes_temporary OWNER TO psql;

--
-- TOC entry 337 (class 1259 OID 134585821)
-- Name: gap_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_dptflrsetattributes (
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
    default_planned_sell_down_week text,
    floorset_uda text,
    ly_floorset_uda text,
    default_slsrnk_store real,
    default_slsrnk_ecom real,
    default_grade text[],
    default_strclimate text[],
    default_str_region_combo text[],
    default_str_hvlc text[],
    default_str_tourist_border_combo text[],
    default_ssg text[],
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
    default_ccdiscountpct_ecom real,
    default_ccdiscountpct_store_cad real,
    default_ccdiscountpct_ecom_cad real,
    default_service_level_stores real,
    default_service_level_ecom real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    prepack_pct_default real,
    override_fringe_indicator text
);


ALTER TABLE public.gap_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 338 (class 1259 OID 134585833)
-- Name: gap_ma_dptflrsetattributes_bkp_wrong_08232026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_dptflrsetattributes_bkp_wrong_08232026 (
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
    default_planned_sell_down_week text,
    floorset_uda text,
    ly_floorset_uda text,
    default_slsrnk_store real,
    default_slsrnk_ecom real,
    default_grade text[],
    default_strclimate text[],
    default_str_region_combo text[],
    default_str_hvlc text[],
    default_str_tourist_border_combo text[],
    default_ssg text[],
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
    default_ccdiscountpct_ecom real,
    default_ccdiscountpct_store_cad real,
    default_ccdiscountpct_ecom_cad real,
    default_service_level_stores real,
    default_service_level_ecom real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    prepack_pct_default real,
    override_fringe_indicator text
);


ALTER TABLE public.gap_ma_dptflrsetattributes_bkp_wrong_08232026 OWNER TO psql;

--
-- TOC entry 339 (class 1259 OID 134585838)
-- Name: gap_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_serviceparams (
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


ALTER TABLE public.gap_serviceparams OWNER TO psql;

--
-- TOC entry 340 (class 1259 OID 134585850)
-- Name: gap_ma_dptflrsetattributes_view_verification; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.gap_ma_dptflrsetattributes_view_verification AS
 SELECT a.product AS department,
    b.id AS "time",
    a."time" AS floorset
   FROM public.gap_ma_dptflrsetattributes a,
    public.gap_d_time b
  WHERE ((b.id >= a.rcptstart) AND (b.id <= a.rcptend) AND (a.rcptend >= ( SELECT gap_serviceparams.value
           FROM public.gap_serviceparams
          WHERE (gap_serviceparams.id = 'plan_current'::text))));


ALTER VIEW public.gap_ma_dptflrsetattributes_view_verification OWNER TO psql;

--
-- TOC entry 341 (class 1259 OID 134585855)
-- Name: gap_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_imgattributes (
    indx integer,
    product text NOT NULL,
    img text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_ma_imgattributes OWNER TO psql;

--
-- TOC entry 342 (class 1259 OID 134585867)
-- Name: gap_ma_imgattributes_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_imgattributes_archive (
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


ALTER TABLE public.gap_ma_imgattributes_archive OWNER TO psql;

--
-- TOC entry 343 (class 1259 OID 134585880)
-- Name: gap_ma_imgattributes_watermark_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_imgattributes_watermark_archive (
    product text NOT NULL,
    stylecolor text NOT NULL,
    source_img_url text NOT NULL,
    ph_img_name text NOT NULL,
    ai_ph_img_name text NOT NULL,
    ph_oci_object text NOT NULL,
    ai_ph_oci_object text NOT NULL,
    first_processed_at timestamp with time zone DEFAULT now() NOT NULL,
    last_processed_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.gap_ma_imgattributes_watermark_archive OWNER TO psql;

--
-- TOC entry 344 (class 1259 OID 134585888)
-- Name: gap_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_sizeattributes (
    product text NOT NULL,
    parent_id text,
    sizeattribute text NOT NULL,
    size_code text,
    size_name text,
    ccstylecolorsizecreatedate text,
    isvalid integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 345 (class 1259 OID 134585900)
-- Name: gap_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_storeattributes (
    location text,
    strname text,
    str_open_date text,
    str_close_date text,
    str_location_purpose text,
    str_brand_number text,
    str_enterprise_brand_description text,
    str_enterprise_market_number text,
    str_enterprise_market_description text,
    str_enterprise_channel_number text,
    str_enterprise_channel_description text,
    str_merchandise_channel_number text,
    str_merchandise_channel_description text,
    str_location_status text,
    str_location_status_id text,
    str_currency_code text,
    str_sales_area text,
    str_total_improved_area text,
    str_build_location_type text,
    str_format_type text,
    str_is_lifestyle text,
    str_location_vintage text,
    str_store_level text,
    str_is_outlet text,
    str_in_outlet_mall text,
    str_timezone text,
    str_country_number text,
    str_country_name text,
    str_country_abbreviated_name text,
    str_zone_number text,
    str_zone_name text,
    str_zone_abbreviated_name text,
    str_region_number text,
    str_region_name text,
    str_region_abbreviated_name text,
    str_district_number text,
    str_district_name text,
    str_district_abbreviated_name text,
    str_address_line1 text,
    str_address_line2 text,
    str_address_line3 text,
    str_state_province_code text,
    str_state_province_name text,
    str_city text,
    str_county text,
    str_postal_code text,
    str_latitude text,
    str_longitude text,
    str_store_id text,
    str_store_name text,
    str_box_type text,
    str_had_ioc text,
    str_dc text,
    str_total_sq_ft text,
    str_selling_sq_ft text,
    str_backroom_sq_ft text,
    str_climate text,
    str_gap_tourist_border text,
    str_on_tourist text,
    str_on_border text,
    str_tourist_border_combo text,
    str_region_combo text,
    str_location_type text,
    str_mall_group text,
    str_density text,
    str_density_group text,
    str_top_stores text,
    str_comp_status text,
    str_hvlc text,
    str_service_level text,
    str_on_ono text,
    str_territory text,
    str_rfid_rollout text,
    str_volume_group text,
    str_open_status text,
    str_owner text,
    str_store_concept text,
    str_store_type text,
    str_vintage text,
    str_pooler text,
    str_3_kings_stores text,
    str_on_div_30_80_funzone_level text,
    str_on_div_31_81_girls_level text,
    str_on_div_32_82_mens_level text,
    str_on_div_34_84_womens_level text,
    str_on_div_35_85_accessories_level text,
    str_on_36_86_boys_level text,
    str_on_37_87_baby_level text,
    str_on_37_87_newborn_level text,
    str_on_38_88_plus_level text,
    str_on_div_30_seasonality text,
    str_on_div_31_seasonality text,
    str_on_div_32_seasonality text,
    str_on_div_34_seasonality text,
    str_on_div_35_seasonality text,
    str_on_div_36_seasonality text,
    str_on_div_37_seasonality text,
    str_on_div_38_seasonality text,
    str_on_div_30_elasticity text,
    str_on_div_31_elasticity text,
    str_on_div_32_elasticity text,
    str_on_div_34_elasticity text,
    str_on_div_35_elasticity text,
    str_on_div_36_elasticity text,
    str_on_div_37_elasticity text,
    str_on_div_38_elasticity text,
    str_on_div_30_pem text,
    str_on_div_31_pem text,
    str_on_div_32_pem text,
    str_on_div_34_pem text,
    str_on_div_35_pem text,
    str_on_div_36_pem text,
    str_on_div_37_pem text,
    str_on_div_38_pem text,
    channel_name text,
    channel_desc text,
    market_name text,
    market_desc text,
    selling_channel_name text,
    selling_channel_desc text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    str_grade text,
    str_dc_or_store text
);


ALTER TABLE public.gap_ma_storeattributes OWNER TO psql;

--
-- TOC entry 346 (class 1259 OID 134585912)
-- Name: gap_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_storeattributes_lat_long (
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


ALTER TABLE public.gap_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 347 (class 1259 OID 134585924)
-- Name: gap_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_styleattributes (
    product text NOT NULL,
    sty_e_top_bottom text,
    sty_b_end_use text,
    sty_c_division_specific_1 text,
    sty_d_division_specific_2 text,
    sty_e_q1 text,
    sty_f_hang_fold_packs text,
    sty_g_length text,
    sty_k_partnerships text,
    sty_l_q2 text,
    sty_m_q3 text,
    sty_n_q4 text,
    sty_spec_style text,
    sty_size_model_code text,
    sty_size_model_name text,
    ccstylecreatedate text,
    sty_size_range text,
    sty_vendor_id text,
    sty_vendor_name text,
    sty_spec_style_store_cad text,
    sty_spec_style_ecom_us text,
    sty_spec_style_ecom_cad text,
    sty_patterned_after text,
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
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_ma_styleattributes OWNER TO psql;

--
-- TOC entry 348 (class 1259 OID 134585936)
-- Name: gap_ma_stylecolor_alloc_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolor_alloc_attributes (
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


ALTER TABLE public.gap_ma_stylecolor_alloc_attributes OWNER TO psql;

--
-- TOC entry 349 (class 1259 OID 134585948)
-- Name: gap_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorattributes (
    product text NOT NULL,
    cccolorid text,
    cccolor text,
    color_name text,
    cc_color_desc text,
    cccolorfamily text,
    cc_color_group text,
    cc_color_code text,
    ccstylecolorcreatedate text,
    cc_size_range_code text,
    cc_spec_stylecolor text,
    cc_attribute_1 text,
    cc_attribute_2 text,
    cc_attribute_3 text,
    cc_attribute_4 text,
    cc_attribute_5 text,
    cc_attribute_6 text,
    cc_attribute_7 text,
    cc_assortment_architecture text,
    cc_price_bucket text,
    cc_a_module text,
    cc_c_responsive text,
    cc_f_print_pattern text,
    cc_g_color_family text,
    cc_h_denim_wash text,
    cc_i_fabric text,
    cc_j_logo text,
    cc_k_license_collab text,
    cc_l_doorbuster text,
    cc_m_exclusive text,
    cc_n_dpc text,
    cc_h_placeholder_type_booking_track_testing text,
    cc_j_print_pattern_wash_color_family text,
    cc_spec_stylecolor_store_cad text,
    cc_spec_stylecolor_ecom_us text,
    cc_spec_stylecolor_ecom_cad text,
    stylecolor_open_1 text,
    stylecolor_open_2 text,
    stylecolor_open_3 text,
    stylecolor_open_4 text,
    stylecolor_open_5 text,
    stylecolor_open_6 text,
    stylecolor_open_7 text,
    stylecolor_open_8 text,
    stylecolor_open_9 text,
    stylecolor_open_10 text,
    stylecolor_name text,
    style_name text,
    subclass_name text,
    class_name text,
    department_name text,
    division_name text,
    brand_name text,
    isassortment text,
    merch_comments text,
    plan_comments text,
    allocator_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish integer,
    cc_prepublished_at timestamp without time zone,
    cc_floorset text,
    cc_use_sys_floorset boolean DEFAULT true,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_img_watermark text,
    cc_ai_img_watermark text
);


ALTER TABLE public.gap_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 350 (class 1259 OID 134585961)
-- Name: gap_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes (
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
    ccticketpricechannel_store_cad real,
    ccticketpricechannel_ecom_us real,
    ccticketpricechannel_ecom_cad real,
    ccticketpricechannel_store_cad_override real,
    ccticketpricechannel_ecom_us_override real,
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real DEFAULT 0,
    cc_ticketprice_flrset_ecom_us_enabled real DEFAULT 0,
    cc_ticketprice_flrset_store_cad_enabled real DEFAULT 0,
    cc_ticketprice_flrset_ecom_cad_enabled real DEFAULT 0,
    cc_plan_cost_flrset_enabled real DEFAULT 0,
    cc_plan_cost_flrset_ecom_us_enabled real DEFAULT 0,
    cc_plan_cost_flrset_store_cad_enabled real DEFAULT 0,
    cc_plan_cost_flrset_ecom_cad_enabled real DEFAULT 0
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 351 (class 1259 OID 134586008)
-- Name: gap_ma_stylecolorchannelattributes_0815; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes_0815 (
    product text,
    location text,
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
    slsrnk_store real,
    slsrnk_ecom real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
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
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    cc_imupct real,
    cc_discount_pct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real,
    cc_discount_pct_ecom real,
    irw_debut_offset integer,
    cc_service_level_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real,
    sclr_fringe_flag real,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    use_valid_sizes_from text,
    apply_size_mins_to text,
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
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real,
    cc_ticketprice_flrset_ecom_us_enabled real,
    cc_ticketprice_flrset_store_cad_enabled real,
    cc_ticketprice_flrset_ecom_cad_enabled real,
    cc_plan_cost_flrset_enabled real,
    cc_plan_cost_flrset_ecom_us_enabled real,
    cc_plan_cost_flrset_store_cad_enabled real,
    cc_plan_cost_flrset_ecom_cad_enabled real
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes_0815 OWNER TO psql;

--
-- TOC entry 352 (class 1259 OID 134586013)
-- Name: gap_ma_stylecolorchannelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes_bk (
    product text,
    location text,
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
    slsrnk_store real,
    slsrnk_ecom real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
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
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    cc_imupct real,
    cc_discount_pct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real,
    cc_discount_pct_ecom real,
    irw_debut_offset integer,
    cc_service_level_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real,
    sclr_fringe_flag real,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    use_valid_sizes_from text,
    apply_size_mins_to text,
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
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real,
    cc_ticketprice_flrset_ecom_us_enabled real,
    cc_ticketprice_flrset_store_cad_enabled real,
    cc_ticketprice_flrset_ecom_cad_enabled real,
    cc_plan_cost_flrset_enabled real,
    cc_plan_cost_flrset_ecom_us_enabled real,
    cc_plan_cost_flrset_store_cad_enabled real,
    cc_plan_cost_flrset_ecom_cad_enabled real
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes_bk OWNER TO psql;

--
-- TOC entry 353 (class 1259 OID 134586018)
-- Name: gap_ma_stylecolorchannelattributes_bk_20260824; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes_bk_20260824 (
    product text,
    location text,
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
    slsrnk_store real,
    slsrnk_ecom real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
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
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    cc_imupct real,
    cc_discount_pct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real,
    cc_discount_pct_ecom real,
    irw_debut_offset integer,
    cc_service_level_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real,
    sclr_fringe_flag real,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    use_valid_sizes_from text,
    apply_size_mins_to text,
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
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real,
    cc_ticketprice_flrset_ecom_us_enabled real,
    cc_ticketprice_flrset_store_cad_enabled real,
    cc_ticketprice_flrset_ecom_cad_enabled real,
    cc_plan_cost_flrset_enabled real,
    cc_plan_cost_flrset_ecom_us_enabled real,
    cc_plan_cost_flrset_store_cad_enabled real,
    cc_plan_cost_flrset_ecom_cad_enabled real
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes_bk_20260824 OWNER TO psql;

--
-- TOC entry 354 (class 1259 OID 134586023)
-- Name: gap_ma_stylecolorchannelattributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes_bkp (
    product text,
    location text,
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
    slsrnk_store real,
    slsrnk_ecom real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
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
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    cc_imupct real,
    cc_discount_pct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real,
    cc_discount_pct_ecom real,
    irw_debut_offset integer,
    cc_service_level_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real,
    sclr_fringe_flag real,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    use_valid_sizes_from text,
    apply_size_mins_to text,
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
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real,
    cc_ticketprice_flrset_ecom_us_enabled real,
    cc_ticketprice_flrset_store_cad_enabled real,
    cc_ticketprice_flrset_ecom_cad_enabled real,
    cc_plan_cost_flrset_enabled real,
    cc_plan_cost_flrset_ecom_us_enabled real,
    cc_plan_cost_flrset_store_cad_enabled real,
    cc_plan_cost_flrset_ecom_cad_enabled real
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes_bkp OWNER TO psql;

--
-- TOC entry 355 (class 1259 OID 134586028)
-- Name: gap_ma_stylecolorchannelattributes_bkp_blank_initrcptw; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_stylecolorchannelattributes_bkp_blank_initrcptw (
    product text,
    location text,
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
    slsrnk_store real,
    slsrnk_ecom real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
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
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    cc_imupct real,
    cc_discount_pct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    ssnprf text,
    adjaps_store real,
    adjaps_ecom real,
    smoothing_strategy text,
    in_season_flag text,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text,
    keep_initial_range_plan integer,
    cc_sizeelig_rangecode text,
    cc_presmin_stylecolor integer,
    cc_presmin_weeks_stylecolor integer,
    cc_final_cost real,
    cc_discount_pct_store real,
    cc_discount_pct_ecom real,
    irw_debut_offset integer,
    cc_service_level_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    sclr_alloc_max real,
    sclr_presmin real,
    sclr_alloc_min real,
    sclr_presmin_weeks real,
    sclr_tgt_fwoc real,
    sclr_fringe_flag real,
    act_slsrnk_store real,
    act_aps_store real,
    act_aps_mult_adj_store real,
    act_slsrnk_ecom real,
    act_aps_ecom real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    use_valid_sizes_from text,
    apply_size_mins_to text,
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
    ccticketpricechannel_ecom_cad_override real,
    adjaps_store_cad real,
    adjaps_ecom_cad real,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom_cad real,
    cc_ticketprice_flrset_enabled real,
    cc_ticketprice_flrset_ecom_us_enabled real,
    cc_ticketprice_flrset_store_cad_enabled real,
    cc_ticketprice_flrset_ecom_cad_enabled real,
    cc_plan_cost_flrset_enabled real,
    cc_plan_cost_flrset_ecom_us_enabled real,
    cc_plan_cost_flrset_store_cad_enabled real,
    cc_plan_cost_flrset_ecom_cad_enabled real
);


ALTER TABLE public.gap_ma_stylecolorchannelattributes_bkp_blank_initrcptw OWNER TO psql;

--
-- TOC entry 356 (class 1259 OID 134586033)
-- Name: gap_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_ma_weekattributes (
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


ALTER TABLE public.gap_ma_weekattributes OWNER TO psql;

--
-- TOC entry 357 (class 1259 OID 134586045)
-- Name: gap_p_approvedclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_approvedclusters (
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


ALTER TABLE public.gap_p_approvedclusters OWNER TO psql;

--
-- TOC entry 358 (class 1259 OID 134586057)
-- Name: gap_p_casepack; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_casepack (
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


ALTER TABLE public.gap_p_casepack OWNER TO psql;

--
-- TOC entry 359 (class 1259 OID 134586069)
-- Name: gap_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_channeloverride (
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
    weekadjslsu_ecom_cad real,
    weekadjaps_store_cad real,
    weekadjaps_ecom_cad real
);


ALTER TABLE public.gap_p_channeloverride OWNER TO psql;

--
-- TOC entry 360 (class 1259 OID 134586082)
-- Name: gap_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_dc_adj (
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
    pack_ind_flag text DEFAULT 'Y'::text NOT NULL,
    pack_ind_flag_ecom text DEFAULT 'Y'::text NOT NULL,
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
    pack_ind_flag_store_cad text DEFAULT 'Y'::text NOT NULL,
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
    pack_ind_flag_ecom_cad text DEFAULT 'Y'::text NOT NULL,
    show_in_pack_ecom_cad text,
    prepack_pct_ecom_cad real,
    default_fringe_indicator_ecom_cad text DEFAULT 'N'::text NOT NULL,
    dc_adjcost_ecom real,
    dc_adjcost_store_cad real,
    dc_adjcost_ecom_cad real
);


ALTER TABLE public.gap_p_dc_adj OWNER TO psql;

--
-- TOC entry 361 (class 1259 OID 134586102)
-- Name: gap_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_dc_adj_size (
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


ALTER TABLE public.gap_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 362 (class 1259 OID 134586109)
-- Name: gap_p_dept_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_dept_store_attr_plan (
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


ALTER TABLE public.gap_p_dept_store_attr_plan OWNER TO psql;

--
-- TOC entry 363 (class 1259 OID 134586121)
-- Name: gap_p_history_pivot; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_history_pivot (
    product uuid NOT NULL,
    original_ticket_price_store_us numeric(18,4),
    original_ticket_price_store_cad numeric(18,4),
    original_ticket_price_ecom_us numeric(18,4),
    original_ticket_price_ecom_cad numeric(18,4),
    current_ticket_price_store_us numeric(18,4),
    current_ticket_price_store_cad numeric(18,4),
    current_ticket_price_ecom_us numeric(18,4),
    current_ticket_price_ecom_cad numeric(18,4),
    avg_unit_cost_store_us numeric(18,4),
    avg_unit_cost_store_cad numeric(18,4),
    avg_unit_cost_ecom_us numeric(18,4),
    avg_unit_cost_ecom_cad numeric(18,4),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.gap_p_history_pivot OWNER TO psql;

--
-- TOC entry 364 (class 1259 OID 134586126)
-- Name: gap_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_itemprice (
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
    eff_aur_ecom_cad real,
    addoff_store_cad real,
    addoff_ecom_cad real
);


ALTER TABLE public.gap_p_itemprice OWNER TO psql;

--
-- TOC entry 365 (class 1259 OID 134586138)
-- Name: gap_p_reassigncluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_reassigncluster (
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


ALTER TABLE public.gap_p_reassigncluster OWNER TO psql;

--
-- TOC entry 366 (class 1259 OID 134586150)
-- Name: gap_p_receditclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_receditclusters (
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


ALTER TABLE public.gap_p_receditclusters OWNER TO psql;

--
-- TOC entry 367 (class 1259 OID 134586162)
-- Name: gap_p_receditstores; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_receditstores (
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


ALTER TABLE public.gap_p_receditstores OWNER TO psql;

--
-- TOC entry 368 (class 1259 OID 134586174)
-- Name: gap_p_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_store_attr_plan (
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


ALTER TABLE public.gap_p_store_attr_plan OWNER TO psql;

--
-- TOC entry 369 (class 1259 OID 134586186)
-- Name: gap_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_strategy_params (
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


ALTER TABLE public.gap_p_strategy_params OWNER TO psql;

--
-- TOC entry 370 (class 1259 OID 134586199)
-- Name: gap_p_strategy_params_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_strategy_params_bkp (
    product text,
    location text,
    floorset_uda text,
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
    rec_magnitude integer,
    ref_avg_cc_count text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    apply_targets_to_plan integer
);


ALTER TABLE public.gap_p_strategy_params_bkp OWNER TO psql;

--
-- TOC entry 371 (class 1259 OID 134586207)
-- Name: gap_p_stylecolor_channel_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_channel_alloc_params (
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


ALTER TABLE public.gap_p_stylecolor_channel_alloc_params OWNER TO psql;

--
-- TOC entry 372 (class 1259 OID 134586220)
-- Name: gap_p_stylecolor_store_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_store_alloc_params (
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


ALTER TABLE public.gap_p_stylecolor_store_alloc_params OWNER TO psql;

--
-- TOC entry 373 (class 1259 OID 134586233)
-- Name: gap_p_stylecolor_store_eligibility; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_store_eligibility (
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


ALTER TABLE public.gap_p_stylecolor_store_eligibility OWNER TO psql;

--
-- TOC entry 374 (class 1259 OID 134586245)
-- Name: gap_p_stylecolor_store_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_store_worklist (
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


ALTER TABLE public.gap_p_stylecolor_store_worklist OWNER TO psql;

--
-- TOC entry 375 (class 1259 OID 134586258)
-- Name: gap_p_stylecolor_sysmanaged_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_sysmanaged_attr_plan (
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


ALTER TABLE public.gap_p_stylecolor_sysmanaged_attr_plan OWNER TO psql;

--
-- TOC entry 376 (class 1259 OID 134586263)
-- Name: gap_p_stylecolor_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolor_worklist (
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


ALTER TABLE public.gap_p_stylecolor_worklist OWNER TO psql;

--
-- TOC entry 377 (class 1259 OID 134586275)
-- Name: gap_p_stylecolorsize_worklist; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_stylecolorsize_worklist (
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


ALTER TABLE public.gap_p_stylecolorsize_worklist OWNER TO psql;

--
-- TOC entry 378 (class 1259 OID 134586290)
-- Name: gap_p_target_include_exclude; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_p_target_include_exclude (
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


ALTER TABLE public.gap_p_target_include_exclude OWNER TO psql;

--
-- TOC entry 379 (class 1259 OID 134586302)
-- Name: gap_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_pg_batch_validation (
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


ALTER TABLE public.gap_pg_batch_validation OWNER TO psql;

--
-- TOC entry 380 (class 1259 OID 134586308)
-- Name: gap_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_pg_batch_validation_archive (
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


ALTER TABLE public.gap_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 381 (class 1259 OID 134586314)
-- Name: gap_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_pg_batch_validation_failure (
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


ALTER TABLE public.gap_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 382 (class 1259 OID 134586320)
-- Name: gap_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_pg_batch_validation_previous (
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


ALTER TABLE public.gap_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 383 (class 1259 OID 134586326)
-- Name: gap_plan_these_cloned_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_plan_these_cloned_style_stylecolors (
    style text NOT NULL,
    stylecolor text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    picked_for_planning integer
);


ALTER TABLE public.gap_plan_these_cloned_style_stylecolors OWNER TO psql;

--
-- TOC entry 384 (class 1259 OID 134586331)
-- Name: gap_price_update; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_price_update (
    product text NOT NULL,
    original_ticket_price_store_us numeric(18,4),
    original_ticket_price_store_cad numeric(18,4),
    original_ticket_price_ecom_us numeric(18,4),
    original_ticket_price_ecom_cad numeric(18,4),
    current_ticket_price_store_us numeric(18,4),
    current_ticket_price_store_cad numeric(18,4),
    current_ticket_price_ecom_us numeric(18,4),
    current_ticket_price_ecom_cad numeric(18,4)
);


ALTER TABLE public.gap_price_update OWNER TO psql;

--
-- TOC entry 385 (class 1259 OID 134586336)
-- Name: gap_prodlife_view_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_prodlife_view_tbl (
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


ALTER TABLE public.gap_prodlife_view_tbl OWNER TO psql;

--
-- TOC entry 386 (class 1259 OID 134586348)
-- Name: gap_replannable_choices; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_replannable_choices (
    product text
);


ALTER TABLE public.gap_replannable_choices OWNER TO psql;

--
-- TOC entry 387 (class 1259 OID 134586353)
-- Name: gap_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_roledimension (
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


ALTER TABLE public.gap_roledimension OWNER TO psql;

--
-- TOC entry 388 (class 1259 OID 134586365)
-- Name: gap_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_servicedefn (
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


ALTER TABLE public.gap_servicedefn OWNER TO psql;

--
-- TOC entry 389 (class 1259 OID 134586377)
-- Name: gap_size_range_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_size_range_mapping (
    size_model_code text,
    size_model_name text,
    size_code text,
    size_attribute text,
    size_desc text,
    sty_size_range text,
    sizeattribute text,
    brand_id text
);


ALTER TABLE public.gap_size_range_mapping OWNER TO psql;

--
-- TOC entry 390 (class 1259 OID 134586385)
-- Name: gap_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.gap_sizinglookup OWNER TO psql;

--
-- TOC entry 391 (class 1259 OID 134586390)
-- Name: gap_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.gap_specimages OWNER TO psql;

--
-- TOC entry 392 (class 1259 OID 134586395)
-- Name: gap_specimages_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_specimages_intraday (
    product text NOT NULL,
    img text
);


ALTER TABLE public.gap_specimages_intraday OWNER TO psql;

--
-- TOC entry 393 (class 1259 OID 134586400)
-- Name: gap_stocking_locations_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_stocking_locations_tbl (
    stocking_location text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.gap_stocking_locations_tbl OWNER TO psql;

--
-- TOC entry 394 (class 1259 OID 134586412)
-- Name: gap_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.gap_store_hier_attr AS
 SELECT s.location,
    ((d.name || ': '::text) || d.description) AS strname,
    s.str_open_date,
    s.str_close_date,
    s.str_location_purpose,
    s.str_brand_number,
    s.str_enterprise_brand_description,
    s.str_enterprise_market_number,
    s.str_enterprise_market_description,
    s.str_enterprise_channel_number,
    s.str_enterprise_channel_description,
    s.str_merchandise_channel_number,
    s.str_merchandise_channel_description,
    s.str_location_status,
    s.str_location_status_id,
    s.str_currency_code,
    s.str_sales_area,
    s.str_total_improved_area,
    s.str_build_location_type,
    s.str_format_type,
    s.str_is_lifestyle,
    s.str_location_vintage,
    s.str_store_level,
    s.str_is_outlet,
    s.str_in_outlet_mall,
    s.str_timezone,
    s.str_country_number,
    s.str_country_name,
    s.str_country_abbreviated_name,
    s.str_zone_number,
    s.str_zone_name,
    s.str_zone_abbreviated_name,
    s.str_region_number,
    s.str_region_name,
    s.str_region_abbreviated_name,
    s.str_district_number,
    s.str_district_name,
    s.str_district_abbreviated_name,
    s.str_address_line1,
    s.str_address_line2,
    s.str_address_line3,
    s.str_state_province_code,
    s.str_state_province_name,
    s.str_city,
    s.str_county,
    s.str_postal_code,
    s.str_latitude,
    s.str_longitude,
    s.str_store_id,
    s.str_store_name,
    s.str_box_type,
    s.str_had_ioc,
    s.str_dc,
    s.str_total_sq_ft,
    s.str_selling_sq_ft,
    s.str_backroom_sq_ft,
    s.str_climate,
    s.str_gap_tourist_border,
    s.str_on_tourist,
    s.str_on_border,
    s.str_tourist_border_combo,
    s.str_region_combo,
    s.str_location_type,
    s.str_mall_group,
    s.str_density,
    s.str_density_group,
    s.str_top_stores,
    s.str_comp_status,
    s.str_hvlc,
    s.str_service_level,
    s.str_on_ono,
    s.str_territory,
    s.str_rfid_rollout,
    s.str_volume_group,
    s.str_open_status,
    s.str_owner,
    s.str_store_concept,
    s.str_store_type,
    s.str_vintage,
    s.str_pooler,
    s.str_3_kings_stores,
    s.str_on_div_30_80_funzone_level,
    s.str_on_div_31_81_girls_level,
    s.str_on_div_32_82_mens_level,
    s.str_on_div_34_84_womens_level,
    s.str_on_div_35_85_accessories_level,
    s.str_on_36_86_boys_level,
    s.str_on_37_87_baby_level,
    s.str_on_37_87_newborn_level,
    s.str_on_38_88_plus_level,
    s.str_on_div_30_seasonality,
    s.str_on_div_31_seasonality,
    s.str_on_div_32_seasonality,
    s.str_on_div_34_seasonality,
    s.str_on_div_35_seasonality,
    s.str_on_div_36_seasonality,
    s.str_on_div_37_seasonality,
    s.str_on_div_38_seasonality,
    s.str_on_div_30_elasticity,
    s.str_on_div_31_elasticity,
    s.str_on_div_32_elasticity,
    s.str_on_div_34_elasticity,
    s.str_on_div_35_elasticity,
    s.str_on_div_36_elasticity,
    s.str_on_div_37_elasticity,
    s.str_on_div_38_elasticity,
    s.str_on_div_30_pem,
    s.str_on_div_31_pem,
    s.str_on_div_32_pem,
    s.str_on_div_34_pem,
    s.str_on_div_35_pem,
    s.str_on_div_36_pem,
    s.str_on_div_37_pem,
    s.str_on_div_38_pem,
    s.channel_name,
    s.channel_desc,
    s.market_name,
    s.market_desc,
    s.selling_channel_name,
    s.selling_channel_desc,
    s.str_grade,
    s.str_dc_or_store,
    h.id AS store,
    h.ancestor0 AS selling_channel,
    h.ancestor1 AS market,
    h.ancestor2 AS channel,
    s.eventdate,
    s.version_id,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by,
    s.record_state
   FROM ((public.gap_ma_storeattributes s
     LEFT JOIN public.gap_h_locstd h ON ((h.id = s.location)))
     LEFT JOIN public.gap_d_location d ON ((s.location = d.id)));


ALTER VIEW public.gap_store_hier_attr OWNER TO psql;

--
-- TOC entry 395 (class 1259 OID 134586417)
-- Name: gap_style_clone_stylecolor_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_style_clone_stylecolor_size (
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


ALTER TABLE public.gap_style_clone_stylecolor_size OWNER TO psql;

--
-- TOC entry 396 (class 1259 OID 134586422)
-- Name: gap_style_merge_archives_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_style_merge_archives_tbl (
    source_style_id text NOT NULL,
    target_style_id text NOT NULL,
    source_stylecolor_id text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.gap_style_merge_archives_tbl OWNER TO psql;

--
-- TOC entry 397 (class 1259 OID 134586428)
-- Name: gap_style_merge_reparent; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_style_merge_reparent (
    source_stylecolor_id text NOT NULL,
    source_style_id text NOT NULL,
    target_style_id text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    cccolor text,
    action text
);


ALTER TABLE public.gap_style_merge_reparent OWNER TO psql;

--
-- TOC entry 398 (class 1259 OID 134586434)
-- Name: gap_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.gap_stylecolor_hier_attr AS
 SELECT a.product,
    c.client_id,
    a.cccolorid,
    a.cccolor,
    a.color_name,
    a.cc_color_desc,
    a.cccolorfamily,
    a.cc_color_group,
    a.cc_color_code,
    a.ccstylecolorcreatedate,
    a.cc_size_range_code,
    a.cc_spec_stylecolor,
    a.cc_attribute_1,
    a.cc_attribute_2,
    a.cc_attribute_3,
    a.cc_attribute_4,
    a.cc_attribute_5,
    a.cc_attribute_6,
    a.cc_attribute_7,
    a.cc_assortment_architecture,
    a.cc_price_bucket,
    a.cc_a_module,
    a.cc_c_responsive,
    a.cc_f_print_pattern,
    a.cc_g_color_family,
    a.cc_h_denim_wash,
    a.cc_i_fabric,
    a.cc_j_logo,
    a.cc_k_license_collab,
    a.cc_l_doorbuster,
    a.cc_m_exclusive,
    a.cc_n_dpc,
    a.cc_h_placeholder_type_booking_track_testing,
    a.cc_j_print_pattern_wash_color_family,
    a.cc_spec_stylecolor_store_cad,
    a.cc_spec_stylecolor_ecom_us,
    a.cc_spec_stylecolor_ecom_cad,
    a.stylecolor_open_1,
    a.stylecolor_open_2,
    a.stylecolor_open_3,
    a.stylecolor_open_4,
    a.stylecolor_open_5,
    a.stylecolor_open_6,
    a.stylecolor_open_7,
    a.stylecolor_open_8,
    a.stylecolor_open_9,
    a.stylecolor_open_10,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.allocator_comments,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    a.cc_prepublished_at,
    a.cc_floorset,
        CASE
            WHEN (a.cc_use_sys_floorset = true) THEN 1
            ELSE 0
        END AS cc_use_sys_floorset,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5,
    b.sty_e_top_bottom,
    b.sty_b_end_use,
    b.sty_c_division_specific_1,
    b.sty_d_division_specific_2,
    b.sty_e_q1,
    b.sty_f_hang_fold_packs,
    b.sty_g_length,
    b.sty_k_partnerships,
    b.sty_l_q2,
    b.sty_m_q3,
    b.sty_n_q4,
    b.sty_spec_style,
    b.sty_size_model_code,
    b.sty_size_model_name,
    b.ccstylecreatedate,
    b.sty_size_range,
    b.sty_vendor_id,
    b.sty_vendor_name,
    b.sty_spec_style_store_cad,
    b.sty_spec_style_ecom_us,
    b.sty_spec_style_ecom_cad,
    b.sty_patterned_after,
    b.sty_is_locked,
    b.sty_s5_adopted,
    b.sty_num_clones_s5,
    b.sty_num_times_cloned_s5,
    a.product AS stylecolor,
    h.ancestor0 AS style,
    h.ancestor1 AS subclass,
    h.ancestor2 AS class,
    h.ancestor3 AS department,
    h.ancestor4 AS division,
    h.ancestor5 AS brand,
    c.name AS stylecolor_name,
    c.description AS stylecolor_desc,
    d.name AS style_name,
    d.description AS style_desc,
    e.name AS subclass_name,
    e.description AS subclass_desc,
    f.name AS class_name,
    f.description AS class_desc,
    g.name AS department_name,
    g.description AS department_desc,
    i.name AS division_name,
    i.description AS division_desc,
    j.name AS brand_name,
    j.description AS brand_desc,
    a.eventdate,
    a.version_id,
    date_trunc('sec'::text, a.created_at) AS created_at,
    a.created_by,
    GREATEST(date_trunc('sec'::text, a.updated_at), date_trunc('sec'::text, c.updated_at)) AS updated_at,
    a.updated_by,
    a.record_state,
    a.cc_img_watermark,
    a.cc_ai_img_watermark
   FROM (((((((((public.gap_ma_stylecolorattributes a
     JOIN public.gap_h_prodstd h ON ((h.id = a.product)))
     JOIN public.gap_ma_styleattributes b ON ((b.product = h.ancestor0)))
     JOIN public.gap_d_product c ON (((a.product = c.id) AND (c.levelid = 'stylecolor'::text))))
     JOIN public.gap_d_product d ON (((h.ancestor0 = d.id) AND (d.levelid = 'style'::text))))
     JOIN public.gap_d_product e ON (((h.ancestor1 = e.id) AND (e.levelid = 'subclass'::text))))
     JOIN public.gap_d_product f ON (((h.ancestor2 = f.id) AND (f.levelid = 'class'::text))))
     JOIN public.gap_d_product g ON (((h.ancestor3 = g.id) AND (g.levelid = 'department'::text))))
     JOIN public.gap_d_product i ON (((h.ancestor4 = i.id) AND (i.levelid = 'division'::text))))
     JOIN public.gap_d_product j ON (((h.ancestor5 = j.id) AND (j.levelid = 'brand'::text))));


ALTER VIEW public.gap_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 399 (class 1259 OID 134586439)
-- Name: gap_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_swatches (
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


ALTER TABLE public.gap_swatches OWNER TO psql;

--
-- TOC entry 400 (class 1259 OID 134586451)
-- Name: gap_time_attributes_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_time_attributes_tbl (
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


ALTER TABLE public.gap_time_attributes_tbl OWNER TO psql;

--
-- TOC entry 401 (class 1259 OID 134586463)
-- Name: gap_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.gap_v_memberbasedvalidvalues (
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


ALTER TABLE public.gap_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 402 (class 1259 OID 134586475)
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
-- TOC entry 403 (class 1259 OID 134586480)
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
-- TOC entry 404 (class 1259 OID 134586485)
-- Name: perf_assortperiod_week; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT gap_ma_dptflrsetattributes.product,
            gap_ma_dptflrsetattributes."time",
            gap_ma_dptflrsetattributes.rcptstart,
            gap_ma_dptflrsetattributes.rcptend
           FROM public.gap_ma_dptflrsetattributes) a,
    public.gap_d_time b
  WHERE ((b.levelid = ('week'::character varying(4))::text) AND (b.id >= a.rcptstart) AND (b.id <= a.rcptend));


ALTER VIEW public.perf_assortperiod_week OWNER TO psql;

--
-- TOC entry 405 (class 1259 OID 134586490)
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
-- TOC entry 406 (class 1259 OID 134586495)
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
-- TOC entry 407 (class 1259 OID 134586501)
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
-- TOC entry 408 (class 1259 OID 134586507)
-- Name: plan_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_products (
    product text
);


ALTER TABLE public.plan_products OWNER TO psql;

--
-- TOC entry 409 (class 1259 OID 134586512)
-- Name: plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue (
    jobid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    initiator text NOT NULL,
    initiated_at timestamp with time zone DEFAULT now() NOT NULL,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    priority integer DEFAULT 1 NOT NULL,
    instance_id text
);


ALTER TABLE public.plan_queue OWNER TO psql;

--
-- TOC entry 410 (class 1259 OID 134586521)
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
    priority integer,
    instance_id text
);


ALTER TABLE public.plan_queue_fails OWNER TO psql;

--
-- TOC entry 411 (class 1259 OID 134586526)
-- Name: plan_queue_last_run; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_last_run (
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
    priority integer,
    instance_id text
);


ALTER TABLE public.plan_queue_last_run OWNER TO psql;

--
-- TOC entry 412 (class 1259 OID 134586531)
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
   FROM public.plan_queue;


ALTER VIEW public.plan_status OWNER TO psql;

--
-- TOC entry 413 (class 1259 OID 134586535)
-- Name: prep_for_gap_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.prep_for_gap_ma_imgattributes (
    product text,
    img text,
    ph_img text,
    ai_ph_img text,
    stylecolor text
);


ALTER TABLE public.prep_for_gap_ma_imgattributes OWNER TO psql;

--
-- TOC entry 414 (class 1259 OID 134586540)
-- Name: prev_gap_ma_departmentquarter_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.prev_gap_ma_departmentquarter_attributes (
    product text,
    "time" text,
    dq_clustering_level text,
    dq_include_vendors boolean,
    dq_enum_vendors_cutoff boolean,
    dq_clustering_prefix text,
    dq_num_clusters text,
    dq_clustering_type text,
    dq_ecom_separate boolean,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    dq_cluster_group boolean,
    dq_metric_1 text,
    dq_metric_2 text
);


ALTER TABLE public.prev_gap_ma_departmentquarter_attributes OWNER TO psql;

--
-- TOC entry 415 (class 1259 OID 134586545)
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
-- TOC entry 416 (class 1259 OID 134586550)
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
-- TOC entry 417 (class 1259 OID 134586555)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 418 (class 1259 OID 134586560)
-- Name: s5_analytics_inseason_sls_rnk_transposed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_analytics_inseason_sls_rnk_transposed (
    stylecolor text,
    raw_aps_store real,
    raw_aps_store_cad real,
    raw_aps_ecom real,
    raw_aps_ecom_cad real,
    act_slsrnk_store real,
    act_slsrnk_store_cad real,
    act_slsrnk_ecom real,
    act_slsrnk_ecom_cad real,
    clean_aps_store real,
    clean_aps_store_cad real,
    clean_aps_ecom real,
    clean_aps_ecom_cad real,
    act_aps_mult_adj_store real,
    act_aps_mult_adj_store_cad real,
    act_aps_mult_adj_ecom real,
    act_aps_mult_adj_ecom_cad real
);


ALTER TABLE public.s5_analytics_inseason_sls_rnk_transposed OWNER TO psql;

--
-- TOC entry 419 (class 1259 OID 134586565)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 420 (class 1259 OID 134586570)
-- Name: scope; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.scope (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    app_name text NOT NULL,
    user_id text NOT NULL,
    params json NOT NULL,
    filter_conditions json DEFAULT '{"filterConditions": []}'::json NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.scope OWNER TO psql;

--
-- TOC entry 421 (class 1259 OID 134586579)
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
-- TOC entry 422 (class 1259 OID 134586580)
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
-- TOC entry 423 (class 1259 OID 134586581)
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
-- TOC entry 424 (class 1259 OID 134586582)
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
-- TOC entry 425 (class 1259 OID 134586583)
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
-- TOC entry 426 (class 1259 OID 134586584)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 427 (class 1259 OID 134586589)
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
-- TOC entry 428 (class 1259 OID 134586590)
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
-- TOC entry 429 (class 1259 OID 134586597)
-- Name: temp1_gap_c_week1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_gap_c_week1 (
    week text,
    week_minus_1 text
);


ALTER TABLE public.temp1_gap_c_week1 OWNER TO psql;

--
-- TOC entry 430 (class 1259 OID 134586602)
-- Name: temp1_gap_c_week4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_gap_c_week4 (
    week text,
    week_minus_4 text
);


ALTER TABLE public.temp1_gap_c_week4 OWNER TO psql;

--
-- TOC entry 431 (class 1259 OID 134586607)
-- Name: temp_cc_plan_cost_issues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_cc_plan_cost_issues (
    product text,
    cc_plan_cost real
);


ALTER TABLE public.temp_cc_plan_cost_issues OWNER TO psql;

--
-- TOC entry 432 (class 1259 OID 134586612)
-- Name: temp_ccticketpricechannel_issues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_ccticketpricechannel_issues (
    product text,
    ccticketpricechannel real
);


ALTER TABLE public.temp_ccticketpricechannel_issues OWNER TO psql;

--
-- TOC entry 433 (class 1259 OID 134586617)
-- Name: tmp_gap_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_gap_v_memberbasedvalidvalues (
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


ALTER TABLE public.tmp_gap_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 434 (class 1259 OID 134586622)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 435 (class 1259 OID 134586627)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 436 (class 1259 OID 134586632)
-- Name: undo_log; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_log (
    undo_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
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
-- TOC entry 437 (class 1259 OID 134586640)
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
-- TOC entry 438 (class 1259 OID 134586645)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 439 (class 1259 OID 134586650)
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
-- TOC entry 440 (class 1259 OID 134586662)
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
-- TOC entry 441 (class 1259 OID 134586670)
-- Name: worklist_map; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.worklist_map (
    product text,
    worklist_id text NOT NULL
);


ALTER TABLE public.worklist_map OWNER TO psql;

--
-- TOC entry 442 (class 1259 OID 134586675)
-- Name: actuals_stage_wide; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    ttl_cc_count double precision NOT NULL,
    strcntwk double precision NOT NULL,
    sales_start_boh_u double precision NOT NULL,
    receipt_start_boh_u double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_c double precision NOT NULL,
    gross_sales_u double precision NOT NULL,
    gross_sales_tktp double precision NOT NULL,
    gross_sales_r double precision NOT NULL,
    funded_cc_count double precision NOT NULL,
    ref_store_count double precision NOT NULL,
    ref_avg_cc_count double precision NOT NULL,
    ref_max_cc_count double precision NOT NULL,
    ref_min_cc_count double precision NOT NULL,
    ref_strcntwk double precision NOT NULL,
    ref_distinct_cc_count double precision NOT NULL,
    ref_funded_receipt_start_boh_u double precision NOT NULL,
    ref_funded_sales_start_boh_u double precision NOT NULL,
    ref_funded_receipt_start_rec_u double precision NOT NULL,
    ref_receipt_start_sls_u double precision NOT NULL,
    ref_ttl_store_count double precision NOT NULL,
    weekcount double precision NOT NULL
);


ALTER TABLE target_setting.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 443 (class 1259 OID 134586680)
-- Name: actuals_wide; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    ttl_cc_count double precision NOT NULL,
    strcntwk double precision NOT NULL,
    sales_start_boh_u double precision NOT NULL,
    receipt_start_boh_u double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_c double precision NOT NULL,
    gross_sales_u double precision NOT NULL,
    gross_sales_tktp double precision NOT NULL,
    gross_sales_r double precision NOT NULL,
    funded_cc_count double precision NOT NULL,
    ref_store_count double precision NOT NULL,
    ref_avg_cc_count double precision NOT NULL,
    ref_max_cc_count double precision NOT NULL,
    ref_min_cc_count double precision NOT NULL,
    ref_strcntwk double precision NOT NULL,
    ref_distinct_cc_count double precision NOT NULL,
    ref_funded_receipt_start_boh_u double precision NOT NULL,
    ref_funded_sales_start_boh_u double precision NOT NULL,
    ref_funded_receipt_start_rec_u double precision NOT NULL,
    ref_receipt_start_sls_u double precision NOT NULL,
    ref_ttl_store_count double precision NOT NULL,
    weekcount double precision NOT NULL,
    strcntwk_ttl_int double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.actuals_wide OWNER TO psql;

--
-- TOC entry 444 (class 1259 OID 134586685)
-- Name: dimensions; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE target_setting.dimensions OWNER TO psql;

--
-- TOC entry 445 (class 1259 OID 134586690)
-- Name: hierarchies; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE target_setting.hierarchies OWNER TO psql;

--
-- TOC entry 446 (class 1259 OID 134586695)
-- Name: location_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.location_denorm AS
 SELECT channel.id AS channel,
    selling_channel.id AS selling_channel,
    grade.id AS grade
   FROM ((( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'grade'::text))) grade
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = grade.id) AND (hierarchies.hierarchy = 'locstd'::text))) selling_channel ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = selling_channel.id) AND (hierarchies.hierarchy = 'locstd'::text))) channel ON (true));


ALTER VIEW target_setting.location_denorm OWNER TO psql;

--
-- TOC entry 447 (class 1259 OID 134586699)
-- Name: product_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.product_denorm AS
 SELECT prodrootlevel.id AS prodrootlevel,
    division.id AS division,
    department.id AS department,
    class.id AS class
   FROM (((( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'class'::text))) class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) prodrootlevel ON (true));


ALTER VIEW target_setting.product_denorm OWNER TO psql;

--
-- TOC entry 448 (class 1259 OID 134586704)
-- Name: time_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.time_denorm AS
 SELECT timerootlevel.id AS timerootlevel,
    fiscal_year.id AS fiscal_year,
    quarter.id AS quarter,
    floorset_uda.id AS floorset_uda
   FROM (((( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE ((dimensions.dimension = 'time'::text) AND (dimensions.levelid = 'floorset_uda'::text))) floorset_uda
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = floorset_uda.id) AND (hierarchies.hierarchy = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) fiscal_year ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = fiscal_year.id) AND (hierarchies.hierarchy = 'timestd'::text))) timerootlevel ON (true));


ALTER VIEW target_setting.time_denorm OWNER TO psql;

--
-- TOC entry 449 (class 1259 OID 134586709)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: target_setting; Owner: psql
--

CREATE MATERIALIZED VIEW target_setting.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".floorset_uda AS time_floorset_uda,
    "time".quarter AS time_quarter,
    product.class AS product_class,
    product.department AS product_department,
    location.grade AS location_grade,
    location.channel AS location_channel,
    wide."time",
    wide.product,
    wide.location,
    wide.ttl_cc_count,
    wide.strcntwk,
    wide.sales_start_boh_u,
    wide.receipt_start_boh_u,
    wide.rec_u,
    wide.rec_r,
    wide.rec_c,
    wide.gross_sales_u,
    wide.gross_sales_tktp,
    wide.gross_sales_r,
    wide.funded_cc_count,
    wide.ref_store_count,
    wide.ref_avg_cc_count,
    wide.ref_max_cc_count,
    wide.ref_min_cc_count,
    wide.ref_strcntwk,
    wide.ref_distinct_cc_count,
    wide.ref_funded_receipt_start_boh_u,
    wide.ref_funded_sales_start_boh_u,
    wide.ref_funded_receipt_start_rec_u,
    wide.ref_receipt_start_sls_u,
    wide.ref_ttl_store_count,
    wide.weekcount,
    wide.strcntwk_ttl_int,
    wide.dilute_ratio
   FROM (((target_setting.actuals_wide wide
     JOIN ( SELECT time_denorm.floorset_uda,
            time_denorm.quarter
           FROM target_setting.time_denorm) "time" ON (("time".floorset_uda = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department
           FROM target_setting.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.grade,
            location_denorm.channel
           FROM target_setting.location_denorm) location ON ((location.grade = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW target_setting.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 450 (class 1259 OID 134586716)
-- Name: comments; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE target_setting.comments OWNER TO psql;

--
-- TOC entry 451 (class 1259 OID 134586722)
-- Name: currency_exchange_rates; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE target_setting.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 452 (class 1259 OID 134586728)
-- Name: dimensions_07272026_bkp; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.dimensions_07272026_bkp (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE target_setting.dimensions_07272026_bkp OWNER TO psql;

--
-- TOC entry 453 (class 1259 OID 134586733)
-- Name: hierarchies_07272026_bkp; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.hierarchies_07272026_bkp (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE target_setting.hierarchies_07272026_bkp OWNER TO psql;

--
-- TOC entry 454 (class 1259 OID 134586738)
-- Name: metadata; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE target_setting.metadata OWNER TO psql;

--
-- TOC entry 455 (class 1259 OID 134586743)
-- Name: paired_dimension_links; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE target_setting.paired_dimension_links OWNER TO psql;

--
-- TOC entry 456 (class 1259 OID 134586748)
-- Name: plan_archives; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_archives (
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


ALTER TABLE target_setting.plan_archives OWNER TO psql;

--
-- TOC entry 457 (class 1259 OID 134586757)
-- Name: plan_audit_log; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE target_setting.plan_audit_log OWNER TO psql;

--
-- TOC entry 458 (class 1259 OID 134586763)
-- Name: plan_data_wide; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    ttl_cc_count double precision NOT NULL,
    strcntwk double precision NOT NULL,
    sales_start_boh_u double precision NOT NULL,
    receipt_start_boh_u double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_c double precision NOT NULL,
    gross_sales_u double precision NOT NULL,
    gross_sales_tktp double precision NOT NULL,
    gross_sales_r double precision NOT NULL,
    funded_cc_count double precision NOT NULL,
    ref_store_count double precision NOT NULL,
    ref_avg_cc_count double precision NOT NULL,
    ref_max_cc_count double precision NOT NULL,
    ref_min_cc_count double precision NOT NULL,
    ref_strcntwk double precision NOT NULL,
    ref_distinct_cc_count double precision NOT NULL,
    ref_funded_receipt_start_boh_u double precision NOT NULL,
    ref_funded_sales_start_boh_u double precision NOT NULL,
    ref_funded_receipt_start_rec_u double precision NOT NULL,
    ref_receipt_start_sls_u double precision NOT NULL,
    ref_ttl_store_count double precision NOT NULL,
    weekcount double precision NOT NULL,
    strcntwk_ttl_int double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.plan_data_wide OWNER TO psql;

--
-- TOC entry 459 (class 1259 OID 134586768)
-- Name: plan_data_wide_archives; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_data_wide_archives (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    ttl_cc_count double precision NOT NULL,
    strcntwk double precision NOT NULL,
    sales_start_boh_u double precision NOT NULL,
    receipt_start_boh_u double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_c double precision NOT NULL,
    gross_sales_u double precision NOT NULL,
    gross_sales_tktp double precision NOT NULL,
    gross_sales_r double precision NOT NULL,
    funded_cc_count double precision NOT NULL,
    ref_store_count double precision NOT NULL,
    ref_avg_cc_count double precision NOT NULL,
    ref_max_cc_count double precision NOT NULL,
    ref_min_cc_count double precision NOT NULL,
    ref_strcntwk double precision NOT NULL,
    ref_distinct_cc_count double precision NOT NULL,
    ref_funded_receipt_start_boh_u double precision NOT NULL,
    ref_funded_sales_start_boh_u double precision NOT NULL,
    ref_funded_receipt_start_rec_u double precision NOT NULL,
    ref_receipt_start_sls_u double precision NOT NULL,
    ref_ttl_store_count double precision NOT NULL,
    weekcount double precision NOT NULL,
    strcntwk_ttl_int double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 460 (class 1259 OID 134586773)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: target_setting; Owner: psql
--

CREATE SEQUENCE target_setting.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE target_setting.plan_id_ticker OWNER TO psql;

--
-- TOC entry 461 (class 1259 OID 134586774)
-- Name: plan_init_status; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE target_setting.plan_init_status OWNER TO psql;

--
-- TOC entry 462 (class 1259 OID 134586777)
-- Name: plans; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plans (
    id integer DEFAULT nextval('target_setting.plan_id_ticker'::regclass) NOT NULL,
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


ALTER TABLE target_setting.plans OWNER TO psql;

--
-- TOC entry 463 (class 1259 OID 134586786)
-- Name: sys_gen_wide; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    ttl_cc_count double precision,
    strcntwk double precision,
    sales_start_boh_u double precision,
    receipt_start_boh_u double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    gross_sales_u double precision,
    gross_sales_tktp double precision,
    gross_sales_r double precision,
    funded_cc_count double precision,
    ref_store_count double precision,
    ref_avg_cc_count double precision,
    ref_max_cc_count double precision,
    ref_min_cc_count double precision,
    ref_strcntwk double precision,
    ref_distinct_cc_count double precision,
    ref_funded_receipt_start_boh_u double precision,
    ref_funded_sales_start_boh_u double precision,
    ref_funded_receipt_start_rec_u double precision,
    ref_receipt_start_sls_u double precision,
    ref_ttl_store_count double precision,
    weekcount double precision,
    strcntwk_ttl_int double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.sys_gen_wide OWNER TO psql;

--
-- TOC entry 464 (class 1259 OID 134586791)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: target_setting; Owner: psql
--

CREATE MATERIALIZED VIEW target_setting.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".floorset_uda AS time_floorset_uda,
    "time".quarter AS time_quarter,
    product.class AS product_class,
    product.department AS product_department,
    location.grade AS location_grade,
    location.channel AS location_channel,
    wide."time",
    wide.product,
    wide.location,
    wide.ttl_cc_count,
    wide.strcntwk,
    wide.sales_start_boh_u,
    wide.receipt_start_boh_u,
    wide.rec_u,
    wide.rec_r,
    wide.rec_c,
    wide.gross_sales_u,
    wide.gross_sales_tktp,
    wide.gross_sales_r,
    wide.funded_cc_count,
    wide.ref_store_count,
    wide.ref_avg_cc_count,
    wide.ref_max_cc_count,
    wide.ref_min_cc_count,
    wide.ref_strcntwk,
    wide.ref_distinct_cc_count,
    wide.ref_funded_receipt_start_boh_u,
    wide.ref_funded_sales_start_boh_u,
    wide.ref_funded_receipt_start_rec_u,
    wide.ref_receipt_start_sls_u,
    wide.ref_ttl_store_count,
    wide.weekcount,
    wide.strcntwk_ttl_int,
    wide.dilute_ratio
   FROM (((target_setting.sys_gen_wide wide
     JOIN ( SELECT time_denorm.floorset_uda,
            time_denorm.quarter
           FROM target_setting.time_denorm) "time" ON (("time".floorset_uda = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department
           FROM target_setting.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.grade,
            location_denorm.channel
           FROM target_setting.location_denorm) location ON ((location.grade = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW target_setting.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 465 (class 1259 OID 134586798)
-- Name: tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE target_setting.tyly OWNER TO psql;

--
-- TOC entry 466 (class 1259 OID 134586803)
-- Name: user_kv_store; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE target_setting.user_kv_store OWNER TO psql;

--
-- TOC entry 467 (class 1259 OID 134586808)
-- Name: bkp_dimensions; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.bkp_dimensions (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE target_setting_bkup.bkp_dimensions OWNER TO psql;

--
-- TOC entry 468 (class 1259 OID 134586813)
-- Name: bkp_hierarchies; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.bkp_hierarchies (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE target_setting_bkup.bkp_hierarchies OWNER TO psql;

--
-- TOC entry 469 (class 1259 OID 134586818)
-- Name: bkp_tyly; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.bkp_tyly (
    ty text,
    ly text
);


ALTER TABLE target_setting_bkup.bkp_tyly OWNER TO psql;

--
-- TOC entry 470 (class 1259 OID 134586823)
-- Name: dimensions; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE target_setting_bkup.dimensions OWNER TO psql;

--
-- TOC entry 471 (class 1259 OID 134586828)
-- Name: hierarchies; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE target_setting_bkup.hierarchies OWNER TO psql;

--
-- TOC entry 472 (class 1259 OID 134586833)
-- Name: tyly; Type: TABLE; Schema: target_setting_bkup; Owner: psql
--

CREATE TABLE target_setting_bkup.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE target_setting_bkup.tyly OWNER TO psql;

--
-- TOC entry 5680 (class 2606 OID 134641287)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 5678 (class 2606 OID 134641289)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 5682 (class 2606 OID 134641291)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 5684 (class 2606 OID 134641293)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 5686 (class 2606 OID 134641295)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 5688 (class 2606 OID 134641297)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 5690 (class 2606 OID 134641299)
-- Name: eligibility_corr eligibility_corr_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.eligibility_corr
    ADD CONSTRAINT eligibility_corr_pk PRIMARY KEY (department, size_range, sizeattr);


--
-- TOC entry 5692 (class 2606 OID 134641301)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 5697 (class 2606 OID 134641303)
-- Name: gap_a_assortment gap_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_a_assortment
    ADD CONSTRAINT gap_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 5700 (class 2606 OID 134641305)
-- Name: gap_an_price_storecount_info gap_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_an_price_storecount_info
    ADD CONSTRAINT gap_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 5702 (class 2606 OID 134641307)
-- Name: gap_authorization gap_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_authorization
    ADD CONSTRAINT gap_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 5707 (class 2606 OID 134641309)
-- Name: gap_cost_update gap_cost_update_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_cost_update
    ADD CONSTRAINT gap_cost_update_pkey PRIMARY KEY (product);


--
-- TOC entry 5725 (class 2606 OID 134641311)
-- Name: gap_eohdata_stylecolor gap_eohdata_stylecolor_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_eohdata_stylecolor
    ADD CONSTRAINT gap_eohdata_stylecolor_pkey PRIMARY KEY (product);


--
-- TOC entry 5705 (class 2606 OID 134641313)
-- Name: gap_corpdisc gap_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_corpdisc
    ADD CONSTRAINT gap_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time", prodlife);


--
-- TOC entry 5761 (class 2606 OID 134641315)
-- Name: gap_l_dclookup gap_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_l_dclookup
    ADD CONSTRAINT gap_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 5765 (class 2606 OID 134641317)
-- Name: gap_l_priceeventlookup gap_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_l_priceeventlookup
    ADD CONSTRAINT gap_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 5857 (class 2606 OID 134641319)
-- Name: gap_sizinglookup gap_l_sizinglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_sizinglookup
    ADD CONSTRAINT gap_l_sizinglookup_pkey UNIQUE (sizerange, size, strselling_channel);


--
-- TOC entry 5770 (class 2606 OID 134641321)
-- Name: gap_l_ssglookup gap_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_l_ssglookup
    ADD CONSTRAINT gap_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 5772 (class 2606 OID 134641323)
-- Name: gap_l_storedclookup gap_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_l_storedclookup
    ADD CONSTRAINT gap_l_storedclookup_pkey PRIMARY KEY (store, dc, priority);


--
-- TOC entry 5774 (class 2606 OID 134641325)
-- Name: gap_l_storelookup gap_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_l_storelookup
    ADD CONSTRAINT gap_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 5776 (class 2606 OID 134641327)
-- Name: gap_ma_departmentalloc_attributes gap_ma_departmentalloc_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_departmentalloc_attributes
    ADD CONSTRAINT gap_ma_departmentalloc_attributes_pkey PRIMARY KEY (product);


--
-- TOC entry 5778 (class 2606 OID 134641329)
-- Name: gap_ma_departmentquarter_attributes gap_ma_departmentquarter_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_departmentquarter_attributes
    ADD CONSTRAINT gap_ma_departmentquarter_attributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 5780 (class 2606 OID 134641331)
-- Name: gap_ma_departmentquarter_attributes_temporary gap_ma_departmentquarter_attributes_temporary_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_departmentquarter_attributes_temporary
    ADD CONSTRAINT gap_ma_departmentquarter_attributes_temporary_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 5788 (class 2606 OID 134641333)
-- Name: gap_ma_imgattributes gap_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_imgattributes
    ADD CONSTRAINT gap_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 5791 (class 2606 OID 134641335)
-- Name: gap_ma_imgattributes_watermark_archive gap_ma_imgattributes_watermark_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_imgattributes_watermark_archive
    ADD CONSTRAINT gap_ma_imgattributes_watermark_archive_pkey PRIMARY KEY (product);


--
-- TOC entry 5795 (class 2606 OID 134641337)
-- Name: gap_ma_sizeattributes gap_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_sizeattributes
    ADD CONSTRAINT gap_ma_sizeattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 5801 (class 2606 OID 134641339)
-- Name: gap_ma_stylecolor_alloc_attributes gap_ma_stylecolor_alloc_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_stylecolor_alloc_attributes
    ADD CONSTRAINT gap_ma_stylecolor_alloc_attributes_pkey PRIMARY KEY (product);


--
-- TOC entry 5805 (class 2606 OID 134641341)
-- Name: gap_ma_stylecolorchannelattributes gap_ma_stylecolorchannelattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_ma_stylecolorchannelattributes
    ADD CONSTRAINT gap_ma_stylecolorchannelattributes_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5808 (class 2606 OID 134641343)
-- Name: gap_p_approvedclusters gap_p_approvedclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_approvedclusters
    ADD CONSTRAINT gap_p_approvedclusters_pkey PRIMARY KEY (product, "time", cluster_id);


--
-- TOC entry 5810 (class 2606 OID 134641345)
-- Name: gap_p_casepack gap_p_casepack_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_casepack
    ADD CONSTRAINT gap_p_casepack_pkey PRIMARY KEY (product, location, "time", case_pack_id);


--
-- TOC entry 5812 (class 2606 OID 134641347)
-- Name: gap_p_channeloverride gap_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_channeloverride
    ADD CONSTRAINT gap_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 5814 (class 2606 OID 134641349)
-- Name: gap_p_dc_adj gap_p_dc_adj_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_dc_adj
    ADD CONSTRAINT gap_p_dc_adj_pk UNIQUE (product, location, "time");


--
-- TOC entry 5816 (class 2606 OID 134641351)
-- Name: gap_p_dc_adj_size gap_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_dc_adj_size
    ADD CONSTRAINT gap_p_dc_adj_size_pk UNIQUE (product, location, "time");


--
-- TOC entry 5818 (class 2606 OID 134641356)
-- Name: gap_p_dept_store_attr_plan gap_p_dept_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_dept_store_attr_plan
    ADD CONSTRAINT gap_p_dept_store_attr_plan_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5820 (class 2606 OID 134641358)
-- Name: gap_p_history_pivot gap_p_history_pivot_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_history_pivot
    ADD CONSTRAINT gap_p_history_pivot_pkey PRIMARY KEY (product);


--
-- TOC entry 5822 (class 2606 OID 134641360)
-- Name: gap_p_itemprice gap_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_itemprice
    ADD CONSTRAINT gap_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 5824 (class 2606 OID 134641362)
-- Name: gap_p_reassigncluster gap_p_reassigncluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_reassigncluster
    ADD CONSTRAINT gap_p_reassigncluster_pkey PRIMARY KEY (product, location, "time", store_cluster_id);


--
-- TOC entry 5826 (class 2606 OID 134641364)
-- Name: gap_p_receditclusters gap_p_receditclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_receditclusters
    ADD CONSTRAINT gap_p_receditclusters_pkey PRIMARY KEY (product, "time", po_id_for_clusters);


--
-- TOC entry 5828 (class 2606 OID 134641366)
-- Name: gap_p_receditstores gap_p_receditstores_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_receditstores
    ADD CONSTRAINT gap_p_receditstores_pkey PRIMARY KEY (product, location, "time", po_id_for_stores);


--
-- TOC entry 5830 (class 2606 OID 134641368)
-- Name: gap_p_store_attr_plan gap_p_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_store_attr_plan
    ADD CONSTRAINT gap_p_store_attr_plan_pkey PRIMARY KEY (location);


--
-- TOC entry 5834 (class 2606 OID 134641370)
-- Name: gap_p_stylecolor_channel_alloc_params gap_p_stylecolor_channel_alloc_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_channel_alloc_params
    ADD CONSTRAINT gap_p_stylecolor_channel_alloc_params_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5836 (class 2606 OID 134641372)
-- Name: gap_p_stylecolor_store_alloc_params gap_p_stylecolor_store_alloc_params_okey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_store_alloc_params
    ADD CONSTRAINT gap_p_stylecolor_store_alloc_params_okey PRIMARY KEY (product, location);


--
-- TOC entry 5838 (class 2606 OID 134641374)
-- Name: gap_p_stylecolor_store_eligibility gap_p_stylecolor_store_eligibility_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_store_eligibility
    ADD CONSTRAINT gap_p_stylecolor_store_eligibility_pkey PRIMARY KEY (product, location);


--
-- TOC entry 5840 (class 2606 OID 134641376)
-- Name: gap_p_stylecolor_store_worklist gap_p_stylecolor_store_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_store_worklist
    ADD CONSTRAINT gap_p_stylecolor_store_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 5844 (class 2606 OID 134641378)
-- Name: gap_p_stylecolor_worklist gap_p_stylecolor_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_worklist
    ADD CONSTRAINT gap_p_stylecolor_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 5846 (class 2606 OID 134641380)
-- Name: gap_p_stylecolorsize_worklist gap_p_stylecolorsize_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolorsize_worklist
    ADD CONSTRAINT gap_p_stylecolorsize_worklist_pkey PRIMARY KEY (product, "time", location, worklist_id);


--
-- TOC entry 5848 (class 2606 OID 134641382)
-- Name: gap_p_target_include_exclude gap_p_target_include_exclude_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_target_include_exclude
    ADD CONSTRAINT gap_p_target_include_exclude_pkey PRIMARY KEY (product, "time", ly_lly_key);


--
-- TOC entry 5851 (class 2606 OID 134641384)
-- Name: gap_price_update gap_price_update_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_price_update
    ADD CONSTRAINT gap_price_update_pkey PRIMARY KEY (product);


--
-- TOC entry 5854 (class 2606 OID 134641386)
-- Name: gap_roledimension gap_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_roledimension
    ADD CONSTRAINT gap_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 5859 (class 2606 OID 134641388)
-- Name: gap_specimages gap_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_specimages
    ADD CONSTRAINT gap_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 5865 (class 2606 OID 134641390)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 5842 (class 2606 OID 134641392)
-- Name: gap_p_stylecolor_sysmanaged_attr_plan pk_stylecolor_sysmanaged_attr_plan; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_stylecolor_sysmanaged_attr_plan
    ADD CONSTRAINT pk_stylecolor_sysmanaged_attr_plan PRIMARY KEY (product, location);


--
-- TOC entry 5867 (class 2606 OID 134641394)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 5871 (class 2606 OID 134641396)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 5873 (class 2606 OID 134641398)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 5832 (class 2606 OID 134641400)
-- Name: gap_p_strategy_params strategy_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.gap_p_strategy_params
    ADD CONSTRAINT strategy_params_pkey PRIMARY KEY (product, location, floorset_uda);


--
-- TOC entry 5694 (class 2606 OID 134641402)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 5876 (class 2606 OID 134641404)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 5878 (class 2606 OID 134641406)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 5880 (class 2606 OID 134641408)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 5882 (class 2606 OID 134641410)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 5884 (class 2606 OID 134641412)
-- Name: worklist_map worklist_map_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.worklist_map
    ADD CONSTRAINT worklist_map_pkey PRIMARY KEY (worklist_id);


--
-- TOC entry 5895 (class 2606 OID 134641414)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 5887 (class 2606 OID 134641416)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5889 (class 2606 OID 134641418)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5891 (class 2606 OID 134641420)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5897 (class 2606 OID 134641422)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 5900 (class 2606 OID 134641424)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 5902 (class 2606 OID 134641426)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 5904 (class 2606 OID 134641428)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 5907 (class 2606 OID 134641430)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5909 (class 2606 OID 134641432)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 5911 (class 2606 OID 134641434)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 5913 (class 2606 OID 134641436)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 5915 (class 2606 OID 134641438)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 5917 (class 2606 OID 134641440)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 5698 (class 1259 OID 134641441)
-- Name: gap_a_assortment_product_location_plan_time; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_a_assortment_product_location_plan_time ON public.gap_a_assortment USING btree (product, location, plan_type, "time");


--
-- TOC entry 5703 (class 1259 OID 134641442)
-- Name: gap_cluster_view_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_cluster_view_tbl_record_state ON public.gap_cluster_view_tbl USING btree (record_state);


--
-- TOC entry 5708 (class 1259 OID 134641443)
-- Name: gap_d_cluster_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_cluster_levelid ON public.gap_d_cluster USING btree (levelid);


--
-- TOC entry 5709 (class 1259 OID 134641444)
-- Name: gap_d_cluster_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_cluster_pkey ON public.gap_d_cluster USING btree (id);


--
-- TOC entry 5710 (class 1259 OID 134641445)
-- Name: gap_d_cluster_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_cluster_record_state ON public.gap_d_cluster USING btree (record_state);


--
-- TOC entry 5711 (class 1259 OID 134641446)
-- Name: gap_d_location_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_location_levelid ON public.gap_d_location USING btree (levelid);


--
-- TOC entry 5712 (class 1259 OID 134641447)
-- Name: gap_d_location_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_location_pkey ON public.gap_d_location USING btree (id);


--
-- TOC entry 5713 (class 1259 OID 134641448)
-- Name: gap_d_location_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_location_record_state ON public.gap_d_location USING btree (record_state);


--
-- TOC entry 5714 (class 1259 OID 134641449)
-- Name: gap_d_prodlife_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_prodlife_levelid ON public.gap_d_prodlife USING btree (levelid);


--
-- TOC entry 5715 (class 1259 OID 134641450)
-- Name: gap_d_prodlife_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_prodlife_pkey ON public.gap_d_prodlife USING btree (id);


--
-- TOC entry 5716 (class 1259 OID 134641451)
-- Name: gap_d_prodlife_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_prodlife_record_state ON public.gap_d_prodlife USING btree (record_state);


--
-- TOC entry 5717 (class 1259 OID 134641452)
-- Name: gap_d_product_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_product_levelid ON public.gap_d_product USING btree (levelid);


--
-- TOC entry 5718 (class 1259 OID 134641453)
-- Name: gap_d_product_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_product_pkey ON public.gap_d_product USING btree (id);


--
-- TOC entry 5719 (class 1259 OID 134641454)
-- Name: gap_d_product_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_product_record_state ON public.gap_d_product USING btree (record_state);


--
-- TOC entry 5720 (class 1259 OID 134641455)
-- Name: gap_d_time_indx_unique; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_time_indx_unique ON public.gap_d_time USING btree (indx);


--
-- TOC entry 5721 (class 1259 OID 134641456)
-- Name: gap_d_time_levelid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_time_levelid ON public.gap_d_time USING btree (levelid);


--
-- TOC entry 5722 (class 1259 OID 134641457)
-- Name: gap_d_time_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_d_time_pkey ON public.gap_d_time USING btree (id);


--
-- TOC entry 5723 (class 1259 OID 134641458)
-- Name: gap_d_time_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_d_time_record_state ON public.gap_d_time USING btree (record_state);


--
-- TOC entry 5726 (class 1259 OID 134641459)
-- Name: gap_floorset_week_attributes_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_floorset_week_attributes_tbl_record_state ON public.gap_floorset_week_attributes_tbl USING btree (record_state);


--
-- TOC entry 5731 (class 1259 OID 134641460)
-- Name: gap_h_clusterstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_clusterstd_pkey ON public.gap_h_clusterstd USING btree (id);


--
-- TOC entry 5732 (class 1259 OID 134641461)
-- Name: gap_h_clusterstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_clusterstd_record_state ON public.gap_h_clusterstd USING btree (record_state);


--
-- TOC entry 5733 (class 1259 OID 134641462)
-- Name: gap_h_locdc_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_locdc_pkey ON public.gap_h_locdc USING btree (id);


--
-- TOC entry 5734 (class 1259 OID 134641463)
-- Name: gap_h_locdc_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locdc_record_state ON public.gap_h_locdc USING btree (record_state);


--
-- TOC entry 5735 (class 1259 OID 134641464)
-- Name: gap_h_locdcstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locdcstd_ancestor0 ON public.gap_h_locdcstd USING btree (ancestor0);


--
-- TOC entry 5736 (class 1259 OID 134641465)
-- Name: gap_h_locdcstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_locdcstd_pkey ON public.gap_h_locdcstd USING btree (id);


--
-- TOC entry 5737 (class 1259 OID 134641466)
-- Name: gap_h_locdcstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locdcstd_record_state ON public.gap_h_locdcstd USING btree (record_state);


--
-- TOC entry 5738 (class 1259 OID 134641467)
-- Name: gap_h_locstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locstd_ancestor0 ON public.gap_h_locstd USING btree (ancestor0);


--
-- TOC entry 5739 (class 1259 OID 134641468)
-- Name: gap_h_locstd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locstd_ancestor1 ON public.gap_h_locstd USING btree (ancestor1);


--
-- TOC entry 5740 (class 1259 OID 134641469)
-- Name: gap_h_locstd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locstd_ancestor2 ON public.gap_h_locstd USING btree (ancestor2);


--
-- TOC entry 5741 (class 1259 OID 134641470)
-- Name: gap_h_locstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_locstd_pkey ON public.gap_h_locstd USING btree (id);


--
-- TOC entry 5742 (class 1259 OID 134641471)
-- Name: gap_h_locstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_locstd_record_state ON public.gap_h_locstd USING btree (record_state);


--
-- TOC entry 5743 (class 1259 OID 134641472)
-- Name: gap_h_prodlifestd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_prodlifestd_pkey ON public.gap_h_prodlifestd USING btree (id);


--
-- TOC entry 5744 (class 1259 OID 134641473)
-- Name: gap_h_prodlifestd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodlifestd_record_state ON public.gap_h_prodlifestd USING btree (record_state);


--
-- TOC entry 5745 (class 1259 OID 134641474)
-- Name: gap_h_prodstd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor0 ON public.gap_h_prodstd USING btree (ancestor0);


--
-- TOC entry 5746 (class 1259 OID 134641475)
-- Name: gap_h_prodstd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor1 ON public.gap_h_prodstd USING btree (ancestor1);


--
-- TOC entry 5747 (class 1259 OID 134641476)
-- Name: gap_h_prodstd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor2 ON public.gap_h_prodstd USING btree (ancestor2);


--
-- TOC entry 5748 (class 1259 OID 134641477)
-- Name: gap_h_prodstd_ancestor3; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor3 ON public.gap_h_prodstd USING btree (ancestor3);


--
-- TOC entry 5749 (class 1259 OID 134641478)
-- Name: gap_h_prodstd_ancestor4; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor4 ON public.gap_h_prodstd USING btree (ancestor4);


--
-- TOC entry 5750 (class 1259 OID 134641479)
-- Name: gap_h_prodstd_ancestor5; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor5 ON public.gap_h_prodstd USING btree (ancestor5);


--
-- TOC entry 5751 (class 1259 OID 134641480)
-- Name: gap_h_prodstd_ancestor6; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_ancestor6 ON public.gap_h_prodstd USING btree (ancestor6);


--
-- TOC entry 5752 (class 1259 OID 134641481)
-- Name: gap_h_prodstd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_prodstd_pkey ON public.gap_h_prodstd USING btree (id);


--
-- TOC entry 5753 (class 1259 OID 134641482)
-- Name: gap_h_prodstd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_prodstd_record_state ON public.gap_h_prodstd USING btree (record_state);


--
-- TOC entry 5727 (class 1259 OID 134641483)
-- Name: gap_h_timeflrset_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timeflrset_ancestor0 ON public.gap_h_timeflrset USING btree (ancestor0);


--
-- TOC entry 5728 (class 1259 OID 134641484)
-- Name: gap_h_timeflrset_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timeflrset_ancestor1 ON public.gap_h_timeflrset USING btree (ancestor1);


--
-- TOC entry 5729 (class 1259 OID 134641485)
-- Name: gap_h_timeflrset_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_timeflrset_pkey ON public.gap_h_timeflrset USING btree (id);


--
-- TOC entry 5730 (class 1259 OID 134641486)
-- Name: gap_h_timeflrset_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timeflrset_record_state ON public.gap_h_timeflrset USING btree (record_state);


--
-- TOC entry 5754 (class 1259 OID 134641487)
-- Name: gap_h_timestd_ancestor0; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timestd_ancestor0 ON public.gap_h_timestd USING btree (ancestor0);


--
-- TOC entry 5755 (class 1259 OID 134641488)
-- Name: gap_h_timestd_ancestor1; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timestd_ancestor1 ON public.gap_h_timestd USING btree (ancestor1);


--
-- TOC entry 5756 (class 1259 OID 134641489)
-- Name: gap_h_timestd_ancestor2; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timestd_ancestor2 ON public.gap_h_timestd USING btree (ancestor2);


--
-- TOC entry 5757 (class 1259 OID 134641490)
-- Name: gap_h_timestd_ancestor3; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timestd_ancestor3 ON public.gap_h_timestd USING btree (ancestor3);


--
-- TOC entry 5758 (class 1259 OID 134641491)
-- Name: gap_h_timestd_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_h_timestd_pkey ON public.gap_h_timestd USING btree (id);


--
-- TOC entry 5759 (class 1259 OID 134641492)
-- Name: gap_h_timestd_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_h_timestd_record_state ON public.gap_h_timestd USING btree (record_state);


--
-- TOC entry 5762 (class 1259 OID 134641493)
-- Name: gap_l_dclookup_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_l_dclookup_record_state ON public.gap_l_dclookup USING btree (record_state);


--
-- TOC entry 5781 (class 1259 OID 134641494)
-- Name: gap_ma_dptflrsetattributes_product_ap_window; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_dptflrsetattributes_product_ap_window ON public.gap_ma_dptflrsetattributes USING btree (product, ap_start, ap_end);


--
-- TOC entry 5782 (class 1259 OID 134641495)
-- Name: gap_ma_dptflrsetattributes_product_rcpt_window; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_dptflrsetattributes_product_rcpt_window ON public.gap_ma_dptflrsetattributes USING btree (product, rcptstart, rcptend);


--
-- TOC entry 5783 (class 1259 OID 134641496)
-- Name: gap_ma_dptflrsetattributes_product_time; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_dptflrsetattributes_product_time ON public.gap_ma_dptflrsetattributes USING btree (product, "time");


--
-- TOC entry 5784 (class 1259 OID 134641497)
-- Name: gap_ma_dptflrsetattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_dptflrsetattributes_record_state ON public.gap_ma_dptflrsetattributes USING btree (record_state);


--
-- TOC entry 5789 (class 1259 OID 134641498)
-- Name: gap_ma_imgattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_imgattributes_record_state ON public.gap_ma_imgattributes USING btree (record_state);


--
-- TOC entry 5792 (class 1259 OID 134641499)
-- Name: gap_ma_imgattributes_watermark_archive_stylecolor_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_imgattributes_watermark_archive_stylecolor_idx ON public.gap_ma_imgattributes_watermark_archive USING btree (stylecolor);


--
-- TOC entry 5793 (class 1259 OID 134641500)
-- Name: gap_ma_sizeattributes_parent_sizeattribute; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_sizeattributes_parent_sizeattribute ON public.gap_ma_sizeattributes USING btree (parent_id, sizeattribute) INCLUDE (product, isvalid);


--
-- TOC entry 5796 (class 1259 OID 134641501)
-- Name: gap_ma_sizeattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_sizeattributes_record_state ON public.gap_ma_sizeattributes USING btree (record_state);


--
-- TOC entry 5797 (class 1259 OID 134641502)
-- Name: gap_ma_storeattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_storeattributes_record_state ON public.gap_ma_storeattributes USING btree (record_state);


--
-- TOC entry 5798 (class 1259 OID 134641503)
-- Name: gap_ma_styleattributes_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_ma_styleattributes_pkey ON public.gap_ma_styleattributes USING btree (product);


--
-- TOC entry 5799 (class 1259 OID 134641504)
-- Name: gap_ma_styleattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_styleattributes_record_state ON public.gap_ma_styleattributes USING btree (record_state);


--
-- TOC entry 5802 (class 1259 OID 134641505)
-- Name: gap_ma_stylecolorattributes_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_ma_stylecolorattributes_pkey ON public.gap_ma_stylecolorattributes USING btree (product);


--
-- TOC entry 5803 (class 1259 OID 134641506)
-- Name: gap_ma_stylecolorattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_stylecolorattributes_record_state ON public.gap_ma_stylecolorattributes USING btree (record_state);


--
-- TOC entry 5806 (class 1259 OID 134641507)
-- Name: gap_ma_weekattributes_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_ma_weekattributes_record_state ON public.gap_ma_weekattributes USING btree (record_state);


--
-- TOC entry 5849 (class 1259 OID 134641508)
-- Name: gap_plan_these_cloned_style_stylecolors_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_plan_these_cloned_style_stylecolors_session_id_idx ON public.gap_plan_these_cloned_style_stylecolors USING btree (session_id);


--
-- TOC entry 5852 (class 1259 OID 134641509)
-- Name: gap_prodlife_view_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_prodlife_view_tbl_record_state ON public.gap_prodlife_view_tbl USING btree (record_state);


--
-- TOC entry 5785 (class 1259 OID 134641510)
-- Name: gap_serviceparams_pkey; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX gap_serviceparams_pkey ON public.gap_serviceparams USING btree (id);


--
-- TOC entry 5786 (class 1259 OID 134641511)
-- Name: gap_serviceparams_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_serviceparams_record_state ON public.gap_serviceparams USING btree (record_state);


--
-- TOC entry 5855 (class 1259 OID 134641512)
-- Name: gap_size_range_mapping_range_sizeattribute; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_size_range_mapping_range_sizeattribute ON public.gap_size_range_mapping USING btree (sty_size_range, sizeattribute) INCLUDE (size_code, size_attribute);


--
-- TOC entry 5860 (class 1259 OID 134641513)
-- Name: gap_stocking_locations_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_stocking_locations_tbl_record_state ON public.gap_stocking_locations_tbl USING btree (record_state);


--
-- TOC entry 5861 (class 1259 OID 134641514)
-- Name: gap_style_clone_stylecolor_size_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_style_clone_stylecolor_size_session_id_idx ON public.gap_style_clone_stylecolor_size USING btree (session_id);


--
-- TOC entry 5863 (class 1259 OID 134641515)
-- Name: gap_time_attributes_tbl_record_state; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX gap_time_attributes_tbl_record_state ON public.gap_time_attributes_tbl USING btree (record_state);


--
-- TOC entry 5766 (class 1259 OID 134641516)
-- Name: idx_gap_l_sizeeligibility_ccrangecode; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_gap_l_sizeeligibility_ccrangecode ON public.gap_l_sizeeligibility_with_ccrangecode USING btree (ccrangecode);


--
-- TOC entry 5862 (class 1259 OID 134641517)
-- Name: idx_gap_style_merge_reparent_session; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_gap_style_merge_reparent_session ON public.gap_style_merge_reparent USING btree (session_id);


--
-- TOC entry 5767 (class 1259 OID 134641518)
-- Name: idx_sizeeligibility_range_member_store; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_sizeeligibility_range_member_store ON public.gap_l_sizeeligibility_with_ccrangecode USING btree (sty_size_range, sizeattribute) WHERE (store_ineligible = 1);


--
-- TOC entry 5768 (class 1259 OID 134641519)
-- Name: idx_sizeeligibility_range_member_web; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX idx_sizeeligibility_range_member_web ON public.gap_l_sizeeligibility_with_ccrangecode USING btree (sty_size_range, sizeattribute) WHERE (web_ineligible = 1);


--
-- TOC entry 5763 (class 1259 OID 134641520)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.gap_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 5868 (class 1259 OID 134641524)
-- Name: prep_for_gap_ma_imgattributes_product_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX prep_for_gap_ma_imgattributes_product_idx ON public.prep_for_gap_ma_imgattributes USING btree (product);


--
-- TOC entry 5869 (class 1259 OID 134641525)
-- Name: prep_for_gap_ma_imgattributes_stylecolor_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX prep_for_gap_ma_imgattributes_stylecolor_idx ON public.prep_for_gap_ma_imgattributes USING btree (stylecolor);


--
-- TOC entry 5695 (class 1259 OID 134641526)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 5874 (class 1259 OID 134641527)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 5892 (class 1259 OID 134641528)
-- Name: actuals_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_denorm_target_setting ON target_setting.actuals_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 5893 (class 1259 OID 134641529)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON target_setting.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 5885 (class 1259 OID 134641530)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON target_setting.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 5898 (class 1259 OID 134641531)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON target_setting.plan_data_wide USING hash (id);


--
-- TOC entry 5905 (class 1259 OID 134641532)
-- Name: sys_gen_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_target_setting ON target_setting.sys_gen_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 5952 (class 2620 OID 134641533)
-- Name: gap_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((pg_trigger_depth() = 0) AND (COALESCE(NULLIF(new.relaunchweek, ''::text), new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.dbt_wk IS DISTINCT FROM new.dbt_wk) OR (old.relaunchweek IS DISTINCT FROM new.relaunchweek) OR (old.exitdate IS DISTINCT FROM new.exitdate)))) EXECUTE FUNCTION public.store_eligibility_trigger();


--
-- TOC entry 5987 (class 2620 OID 134641534)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 5988 (class 2620 OID 134641535)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 5983 (class 2620 OID 134641536)
-- Name: gap_p_stylecolor_worklist on_publish_remove_from_worklist_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_publish_remove_from_worklist_trigger AFTER UPDATE ON public.gap_p_stylecolor_worklist FOR EACH ROW WHEN (((new.in_worklist = (1)::double precision) AND (old.in_worklist = (0)::double precision))) EXECUTE FUNCTION public.on_publish_remove_from_worklist();

ALTER TABLE public.gap_p_stylecolor_worklist DISABLE TRIGGER on_publish_remove_from_worklist_trigger;


--
-- TOC entry 5984 (class 2620 OID 134641537)
-- Name: gap_p_stylecolor_worklist on_publish_remove_from_worklist_trigger_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_publish_remove_from_worklist_trigger_insert AFTER INSERT ON public.gap_p_stylecolor_worklist FOR EACH ROW WHEN ((new.in_worklist = (1)::double precision)) EXECUTE FUNCTION public.on_publish_remove_from_worklist();

ALTER TABLE public.gap_p_stylecolor_worklist DISABLE TRIGGER on_publish_remove_from_worklist_trigger_insert;


--
-- TOC entry 5985 (class 2620 OID 134641538)
-- Name: gap_p_stylecolor_worklist on_unpublish_remove_from_worklist_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_unpublish_remove_from_worklist_trigger AFTER UPDATE ON public.gap_p_stylecolor_worklist FOR EACH ROW WHEN (((new.in_worklist = (0)::double precision) AND (old.in_worklist = (1)::double precision))) EXECUTE FUNCTION public.on_unpublish_remove_from_worklist();

ALTER TABLE public.gap_p_stylecolor_worklist DISABLE TRIGGER on_unpublish_remove_from_worklist_trigger;


--
-- TOC entry 5953 (class 2620 OID 134641539)
-- Name: gap_ma_stylecolorchannelattributes scch_05_guard_pricing; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_05_guard_pricing BEFORE UPDATE OF ccticketpricechannel, ccticketpricechannel_ecom_us, ccticketpricechannel_store_cad, ccticketpricechannel_ecom_cad, cc_plan_cost, cc_plan_cost_ecom_us, cc_plan_cost_store_cad, cc_plan_cost_ecom_cad ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.guard_scch_pricing_edits();


--
-- TOC entry 5954 (class 2620 OID 134641540)
-- Name: gap_ma_stylecolorchannelattributes scch_10_validate_lifecycle; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_10_validate_lifecycle BEFORE UPDATE OF dbt_wk, erlstmkdnwk, exitdate ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((pg_trigger_depth() = 0) AND ((new.dbt_wk IS DISTINCT FROM old.dbt_wk) OR (new.erlstmkdnwk IS DISTINCT FROM old.erlstmkdnwk) OR (new.exitdate IS DISTINCT FROM old.exitdate)))) EXECUTE FUNCTION public.validate_lifecycle_weeks();


--
-- TOC entry 5955 (class 2620 OID 134641541)
-- Name: gap_ma_stylecolorchannelattributes scch_20_derive_week_indexes_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_20_derive_week_indexes_insert BEFORE INSERT ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 5956 (class 2620 OID 134641542)
-- Name: gap_ma_stylecolorchannelattributes scch_20_derive_week_indexes_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_20_derive_week_indexes_update BEFORE UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 5957 (class 2620 OID 134641543)
-- Name: gap_ma_stylecolorchannelattributes scch_30_set_floorset_fields_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_30_set_floorset_fields_insert BEFORE INSERT ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.set_floorset_fields_on_initrcptwk_change();


--
-- TOC entry 5958 (class 2620 OID 134641544)
-- Name: gap_ma_stylecolorchannelattributes scch_30_set_floorset_fields_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER scch_30_set_floorset_fields_update BEFORE UPDATE ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((pg_trigger_depth() = 0) AND (new.initrcptwk IS DISTINCT FROM old.initrcptwk))) EXECUTE FUNCTION public.set_floorset_fields_on_initrcptwk_change();


--
-- TOC entry 5975 (class 2620 OID 134641545)
-- Name: gap_p_dc_adj_size set_dc_ttluseradj_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_dc_ttluseradj_p_dc_adj_size BEFORE INSERT OR UPDATE ON public.gap_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_dc_ttl_useradj();


--
-- TOC entry 5986 (class 2620 OID 134641546)
-- Name: gap_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.gap_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION public.trigger_set_indx_valid_values();


--
-- TOC entry 5971 (class 2620 OID 134641547)
-- Name: gap_p_dc_adj set_pack_ind_flag; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_pack_ind_flag BEFORE INSERT OR UPDATE OF reason_code ON public.gap_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_pack_ind_flag();


--
-- TOC entry 5939 (class 2620 OID 134641548)
-- Name: gap_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.gap_a_assortment FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5968 (class 2620 OID 134641549)
-- Name: gap_p_casepack set_timestamp_cp_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish BEFORE UPDATE OF po_status ON public.gap_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 5969 (class 2620 OID 134641550)
-- Name: gap_p_casepack set_timestamp_cp_publish_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish_ins BEFORE INSERT ON public.gap_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 5970 (class 2620 OID 134641551)
-- Name: gap_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.gap_p_channeloverride FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5972 (class 2620 OID 134641552)
-- Name: gap_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.gap_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5976 (class 2620 OID 134641553)
-- Name: gap_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.gap_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5973 (class 2620 OID 134641554)
-- Name: gap_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.gap_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 5974 (class 2620 OID 134641555)
-- Name: gap_p_dc_adj set_timestamp_p_dc_publish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj_ins BEFORE INSERT ON public.gap_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 5945 (class 2620 OID 134641556)
-- Name: gap_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.gap_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5946 (class 2620 OID 134641557)
-- Name: gap_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.gap_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5959 (class 2620 OID 134641558)
-- Name: gap_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5949 (class 2620 OID 134641559)
-- Name: gap_ma_stylecolorattributes set_timestamp_stylecolorattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_stylecolorattr BEFORE UPDATE ON public.gap_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 5989 (class 2620 OID 134641560)
-- Name: worklist_map trg_ai_worklist_map; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_ai_worklist_map AFTER INSERT ON public.worklist_map FOR EACH ROW EXECUTE FUNCTION public.trg_ins_stylecolor_alloc_attrs();


--
-- TOC entry 5960 (class 2620 OID 134641561)
-- Name: gap_ma_stylecolorchannelattributes trg_cc_validsizes_on_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_cc_validsizes_on_change BEFORE UPDATE OF ccrangecode, use_valid_sizes_from, cc_size_eligibility_profile ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() < 2)) EXECUTE FUNCTION public.update_cc_validsizes_on_ccrangecode();


--
-- TOC entry 5979 (class 2620 OID 134641562)
-- Name: gap_p_strategy_params trg_p_strategy_params_set_apply_targets; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_p_strategy_params_set_apply_targets BEFORE INSERT OR UPDATE ON public.gap_p_strategy_params FOR EACH ROW EXECUTE FUNCTION public.trg_set_apply_targets_to_plan();


--
-- TOC entry 5944 (class 2620 OID 134641563)
-- Name: gap_ma_departmentalloc_attributes trg_set_overflow_ok_when_scaling; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_overflow_ok_when_scaling BEFORE UPDATE ON public.gap_ma_departmentalloc_attributes FOR EACH ROW EXECUTE FUNCTION public.trg_allow_scaling_set_overflow_ok();


--
-- TOC entry 5948 (class 2620 OID 134641564)
-- Name: gap_ma_stylecolor_alloc_attributes trg_set_sclr_overflow_ok_when_scaling; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_sclr_overflow_ok_when_scaling BEFORE UPDATE ON public.gap_ma_stylecolor_alloc_attributes FOR EACH ROW EXECUTE FUNCTION public.trg_sclr_allow_scaling_set_overflow_ok();


--
-- TOC entry 5981 (class 2620 OID 134641565)
-- Name: gap_p_stylecolor_store_worklist trg_sync_alloc_and_override_trigger; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_sync_alloc_and_override_trigger BEFORE INSERT OR UPDATE ON public.gap_p_stylecolor_store_worklist FOR EACH ROW EXECUTE FUNCTION public.trg_sync_alloc_and_override();

ALTER TABLE public.gap_p_stylecolor_store_worklist DISABLE TRIGGER trg_sync_alloc_and_override_trigger;


--
-- TOC entry 5940 (class 2620 OID 134641566)
-- Name: gap_a_assortment trg_upd_assortment_pricing; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_pricing AFTER UPDATE ON public.gap_a_assortment REFERENCING OLD TABLE AS old_rows NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION public.propagate_pricing_to_floorsets();


--
-- TOC entry 5941 (class 2620 OID 134641567)
-- Name: gap_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF str_grade, str_climate, str_region_combo, str_hvlc, str_tourist_border_combo, ssg, str_grade_or, str_climate_or, str_region_combo_or, str_hvlc_or, str_tourist_border_combo_or ON public.gap_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.propagate_assortment_to_floorsets();


--
-- TOC entry 5961 (class 2620 OID 134641568)
-- Name: gap_ma_stylecolorchannelattributes trg_upd_scch_pricing; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_scch_pricing AFTER UPDATE ON public.gap_ma_stylecolorchannelattributes REFERENCING OLD TABLE AS old_rows NEW TABLE AS new_rows FOR EACH STATEMENT EXECUTE FUNCTION public.propagate_pricing_to_assortment();


--
-- TOC entry 5982 (class 2620 OID 134641569)
-- Name: gap_p_stylecolor_store_worklist trg_update_alloc_qty; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_alloc_qty BEFORE INSERT OR UPDATE ON public.gap_p_stylecolor_store_worklist FOR EACH ROW EXECUTE FUNCTION public.trg_sum_override_array();

ALTER TABLE public.gap_p_stylecolor_store_worklist DISABLE TRIGGER trg_update_alloc_qty;


--
-- TOC entry 5950 (class 2620 OID 134641570)
-- Name: gap_ma_stylecolorattributes trg_update_cc_floorset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_cc_floorset BEFORE UPDATE OF cc_floorset ON public.gap_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_use_sys_floorset();


--
-- TOC entry 5980 (class 2620 OID 134641571)
-- Name: gap_p_stylecolor_store_eligibility trg_update_eligibility_from_null_to_zero; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_eligibility_from_null_to_zero AFTER UPDATE OF sclr_str_eligibility ON public.gap_p_stylecolor_store_eligibility FOR EACH ROW WHEN (((new.sclr_str_eligibility IS NULL) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.update_eligibility_from_null_to_zero();


--
-- TOC entry 5951 (class 2620 OID 134641572)
-- Name: gap_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER UPDATE OF cccolor ON public.gap_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_color_change();


--
-- TOC entry 5962 (class 2620 OID 134641573)
-- Name: gap_ma_stylecolorchannelattributes trigger_auto_rollforward; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_auto_rollforward AFTER UPDATE OF auto_rollforward ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((new.auto_rollforward IS TRUE)) EXECUTE FUNCTION public.update_on_auto_rollforward();


--
-- TOC entry 5937 (class 2620 OID 134641574)
-- Name: cart_params trigger_cartparams_irw_debut_offset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_irw_debut_offset BEFORE UPDATE OF dbt_wk ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_irw_debut_offset();


--
-- TOC entry 5938 (class 2620 OID 134641575)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_ranging();


--
-- TOC entry 5963 (class 2620 OID 134641576)
-- Name: gap_ma_stylecolorchannelattributes trigger_cost; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cost AFTER UPDATE OF cc_plan_cost ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.trigger_final_cost();


--
-- TOC entry 5977 (class 2620 OID 134641577)
-- Name: gap_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.gap_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.update_eff_aur();


--
-- TOC entry 5978 (class 2620 OID 134641578)
-- Name: gap_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.gap_p_itemprice FOR EACH ROW EXECUTE FUNCTION public.itemprice_fetchdepartment();


--
-- TOC entry 5964 (class 2620 OID 134641579)
-- Name: gap_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.lifecycle_plan_update();


--
-- TOC entry 5965 (class 2620 OID 134641580)
-- Name: gap_ma_stylecolorchannelattributes trigger_remove_from_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_remove_from_assortment AFTER UPDATE OF record_state ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((new.record_state = 1)) EXECUTE FUNCTION public.remove_from_assortment();


--
-- TOC entry 5966 (class 2620 OID 134641581)
-- Name: gap_ma_stylecolorchannelattributes trigger_sizerangecode_isvalid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_isvalid AFTER UPDATE OF validsizes ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_isvalid();


--
-- TOC entry 5967 (class 2620 OID 134641582)
-- Name: gap_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.gap_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_validsizes_members();


--
-- TOC entry 5942 (class 2620 OID 134641583)
-- Name: gap_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.gap_d_product FOR EACH ROW WHEN ((new.levelid = 'style'::text)) EXECUTE FUNCTION public.update_name_description();


--
-- TOC entry 5947 (class 2620 OID 134641584)
-- Name: gap_ma_styleattributes update_ccrangecode; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccrangecode AFTER UPDATE OF sty_size_range ON public.gap_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_stylecolorchannelattributes_ccrangecode();


--
-- TOC entry 5943 (class 2620 OID 134641585)
-- Name: gap_h_prodstd update_ccsizerange_after_class_change_ancestor1; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccsizerange_after_class_change_ancestor1 AFTER UPDATE OF ancestor1 ON public.gap_h_prodstd FOR EACH ROW WHEN ((new.ancestor1 IS DISTINCT FROM old.ancestor1)) EXECUTE FUNCTION public.update_ccrangecode_on_class_change();


--
-- TOC entry 5919 (class 2606 OID 134641586)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 5920 (class 2606 OID 134641591)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 5922 (class 2606 OID 134641596)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 5918 (class 2606 OID 134641601)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.agent_conversations(conversation_id);


--
-- TOC entry 5925 (class 2606 OID 134641606)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 5926 (class 2606 OID 134641611)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 5921 (class 2606 OID 134641616)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 5924 (class 2606 OID 134641621)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 5923 (class 2606 OID 134641626)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.user_metadata(uid);


--
-- TOC entry 5927 (class 2606 OID 134641631)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 5928 (class 2606 OID 134641636)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 5931 (class 2606 OID 134641641)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 5929 (class 2606 OID 134641646)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES target_setting.plans(id) ON DELETE CASCADE;


--
-- TOC entry 5930 (class 2606 OID 134641651)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES target_setting.plans(id);


--
-- TOC entry 5932 (class 2606 OID 134641656)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 5933 (class 2606 OID 134641661)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES target_setting_bkup.dimensions(id);


--
-- TOC entry 5934 (class 2606 OID 134641666)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES target_setting_bkup.dimensions(id);


--
-- TOC entry 5935 (class 2606 OID 134641671)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES target_setting_bkup.dimensions(id);


--
-- TOC entry 5936 (class 2606 OID 134641676)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting_bkup; Owner: psql
--

ALTER TABLE ONLY target_setting_bkup.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES target_setting_bkup.dimensions(id);


--
-- TOC entry 6145 (class 0 OID 0)
-- Dependencies: 18
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:07:54 IST

--
-- PostgreSQL database dump complete
--

\unrestrict 7XyGJKdxdWDi14EnHtDK2cG4m0wtRgi5ta7yLc2hwwxg2drj6BUVYHMOOSIDiK9

