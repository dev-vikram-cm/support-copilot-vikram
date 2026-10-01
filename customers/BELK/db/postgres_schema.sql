-- ENV: QA | DB: belk | dumped: 2026-10-01 15:05 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict jkbIu7qjySpJCqS2qsTLAtXUDnAl6fYwHk6Vt2qzuZAbppS2Iep7VopHlL47jHQ

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:05:11 IST

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
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 1484 (class 2615 OID 129294709)
-- Name: target_setting; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA target_setting;


ALTER SCHEMA target_setting OWNER TO psql;

--
-- TOC entry 2 (class 3079 OID 44073)
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- TOC entry 8070 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


--
-- TOC entry 3 (class 3079 OID 44094)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 8071 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 2808 (class 1247 OID 129294711)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 2811 (class 1247 OID 129294718)
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
-- TOC entry 2814 (class 1247 OID 129294730)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 2817 (class 1247 OID 129294736)
-- Name: approval; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE target_setting.approval OWNER TO psql;

--
-- TOC entry 2820 (class 1247 OID 129294742)
-- Name: permission; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE target_setting.permission OWNER TO psql;

--
-- TOC entry 2823 (class 1247 OID 129294750)
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
-- TOC entry 2123 (class 1255 OID 129294765)
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
s7_x text;
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
s21_x text;
s22 text;
s23 text;
s24 text;
s25 text;
s26 text;
--s26_X text;
s27 text;
s28 text;
s28_1 text;
s28_X text;
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
s51_x text;
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

BEGIN



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
    ,  null::text cccolorfamily
    ,  null::text cccolorid
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
    from blk_h_prodstd b
    where
    b.id = a.incoming_style_id
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from blk_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from blk_d_product b
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
    , case when stylecolor_type = ''similar'' then style_name||''.''||cccolorid else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = ''similar'' then style_description ||'' ''||cccolordesc else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    , cccolorid
    , cccolordesc
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, b.cccolor,
    b.cccolorid, b.cccolordesc
    , style_name, style_description, stylecolor_name, stylecolor_description
    from '||table_cart_master_temp||' a, (select attributekey as cccolorid, attributevalue as cccolordesc, attributekey || '' '' || attributevalue as cccolor from blk_v_memberbasedvalidvalues where attributeid = ''cccolorid'') b 
    where substr(a.cccolor, 1, (position('' '' in a.cccolor)) - 1) = b.cccolorid and jsessionid in (select jsid from '||table_input_t1||')
    ) x
    '
    ;



s6 := '
    Update '||table_cart_master_temp||' a set
    final_stylecolor_id = b.final_stylecolor_id
    , stylecolor_name = displayed_stylecolor_name
    , stylecolor_description = displayed_stylecolor_description
    , cccolor = b.cccolor
    from '||table_cart_stylecolor||' b
    where
    a.incoming_stylecolor_id=b.incoming_stylecolor_id
    and substr(a.cccolor, 1, (position('' '' in a.cccolor)) - 1) = b.cccolorid
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
           stylecolorsize_id AS final_stylecolorsize_id
         , sizeattribute    AS size_name
         , sizeattribute    AS size_description
         , incoming_stylecolor_id
         , incoming_style_id
         , final_style_id
         , final_stylecolor_id
         , stylecolor_type
         , jsessionid
         , size_member_id
         , source_member_id
         , source_member_name
         , sku_dropship_indicator
         , sku_replenishment_flag
         , sku_extended_size
         , sku_status
         , isvalid
    FROM   (SELECT
           a.incoming_stylecolor_id
           , a.incoming_style_id
           , b.product stylecolorsize_id
           , b.parent_id
           , null as size_member_id
           , b.sizeattribute
           , null as source_member_id
           , b.source_member_name
           , b.sku_dropship_indicator
           , b.sku_replenishment_flag
           , b.sku_extended_size
           , b.sku_status
           , b.isvalid
           , a.jsessionid
           , a.style_type
           , a.stylecolor_type
           , a.final_style_id
           , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                 , blk_ma_sizeattributes b
          WHERE  a.incoming_stylecolor_id = b.parent_id
          AND stylecolor_type = ''existing''
          )x
          '
          ;

s7_x := '
    insert into '||table_cart_stylecolorsize||'
    SELECT
           uuid_generate_v4()::text AS final_stylecolorsize_id
         , ''NA''                   AS size_name
         , ''NA''                   AS size_description
         , a.incoming_stylecolor_id
         , a.incoming_style_id
         , a.final_style_id
         , a.final_stylecolor_id
         , a.stylecolor_type
         , a.jsessionid
         , null                     AS size_member_id
         , null                     AS source_member_id
         , null                     AS source_member_name
         , null                     AS sku_dropship_indicator
         , null                     AS sku_replenishment_flag
         , null                     AS sku_extended_size
         , 0                        AS sku_status
         , 1                        AS isvalid
          FROM   '||table_cart_master_temp||' a
          WHERE stylecolor_type = ''similar''
          '
          ;


s8 := 'delete from blk_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';


s9 := '
    INSERT INTO blk_d_product
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
delete from blk_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s11 := '
    INSERT INTO blk_d_product
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
delete from blk_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s13 := '
    INSERT INTO blk_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT final_stylecolorsize_id            AS id
           , size_name        AS NAME
           , size_description AS description
           , ''stylecolorsize'' AS levelid
    FROM   '||table_cart_stylecolorsize||'
    WHERE stylecolor_type=''similar''
    '
    ;



-- CREATING HIERARCHY

s14 := '
delete from blk_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s15 := '
INSERT INTO blk_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from blk_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
'
;



s16 := '
delete from blk_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO blk_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from blk_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
'
;



s18 := '
delete from blk_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO blk_h_prodstd
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
blk_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s20 := '
delete from blk_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from blk_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''cccolorfamily'' and lookup_value=a.cccolor
';

s21_x := '
update '||table_cart_master_temp||' a set cccolorid = b.attributekey from blk_v_memberbasedvalidvalues b where b.attributeid = ''cccolorid'' and attributekey || '' '' || attributevalue=a.cccolor
';


s22 := '
delete from blk_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s23 := '
delete from blk_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';





s24 := '
insert into blk_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


s25 := '
insert into blk_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- STYLE ATTRIBUTES

S26 := '
INSERT INTO blk_ma_styleattributes
            (product      
            ,sty_vpn
            ,sty_supplier_number
            ,sty_supplier_name
            ,sty_size_range
            ,sty_style_type
            ,ccstylecreatedate
            ,sty_style_status
            ,supp_supplier_site_id
            ,supp_supplier_name
            ,supp_parent_supplier_id
            ,supp_parent_supplier_name
            ,supp_status
            ,supp_class_group
            ,supp_brand_mindset
            ,supp_brand_type
            ,supp_brand
            ,supp_priceband
            ,supp_bi_flg
            ,supp_grp_parent_id
            ,supp_grp_standard_id
            ,supp_grp_brand_id
            ,supp_ninebox
            ,supp_lifestyle
            ,supp_direct_ship_ind
            ,class_group_id
            ,class_group_name
            ,dpt_department_id
            ,dpt_gmm_id
            ,dpt_gmm_desc
            ,dpt_dmm_id
            ,dpt_dmm_desc
            ,dpt_buyer_id
            ,dpt_buyer_desc
            ,dpt_sr_planner_id
            ,dpt_sr_planner_desc
            ,dpt_planner_id
            ,dpt_planner_desc
            ,dpt_dir_id
            ,dpt_dir_desc
            ,dpt_vp_id
            ,dpt_vp_desc
            ,dpt_svp_id
            ,dpt_svp_desc
            ,dpt_evp_id
            ,dpt_evp_desc
            ,dpt_marketplace_indicator
            ,dpt_memo_dept_indicator
            ,dpt_royalty_pct
            ,sty_s5_adopted
            ,sty_vpn_id_non_plm
            )
SELECT final_style_id as product
            ,null as sty_vpn
            ,sty_supplier_number
            ,sty_supplier_name
            ,b.sty_size_range
            ,sty_style_type
            --,b.ccstylecreatedate
            ,null as ccstylecreatedate  --Inherting ccstylecreatedate from similar style will restrict the user from editing the style id and desc; so we set it to null until it is created in client host system
            ,b.sty_style_status
            ,supp_supplier_site_id
            ,supp_supplier_name
            ,supp_parent_supplier_id
            ,supp_parent_supplier_name
            ,supp_status
            ,supp_class_group
            ,supp_brand_mindset
            ,supp_brand_type
            ,supp_brand
            ,supp_priceband
            ,supp_bi_flg
            ,supp_grp_parent_id
            ,supp_grp_standard_id
            ,supp_grp_brand_id
            ,supp_ninebox
            ,supp_lifestyle
            ,supp_direct_ship_ind
            ,b.class_group_id
            ,b.class_group_name
            ,b.dpt_department_id
            ,b.dpt_gmm_id
            ,b.dpt_gmm_desc
            ,b.dpt_dmm_id
            ,b.dpt_dmm_desc
            ,b.dpt_buyer_id
            ,b.dpt_buyer_desc
            ,b.dpt_sr_planner_id
            ,b.dpt_sr_planner_desc
            ,b.dpt_planner_id
            ,b.dpt_planner_desc
            ,b.dpt_dir_id
            ,b.dpt_dir_desc
            ,b.dpt_vp_id
            ,b.dpt_vp_desc
            ,b.dpt_svp_id
            ,b.dpt_svp_desc
            ,b.dpt_evp_id
            ,b.dpt_evp_desc
            ,b.dpt_marketplace_indicator
            ,b.dpt_memo_dept_indicator
            ,b.dpt_royalty_pct
            ,''Y''
            ,null as sty_vpn_id_non_plm
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name from '||table_cart_master_temp||') a, blk_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
';

/*
s26_X := '
Update blk_ma_styleattributes b
set pim_size_run_id = sty_size_run_id, pim_size_run_name = sty_size_run_name, sty_is_locked = ''Y'', sty_s5_adopted = ''Y''
from (select distinct final_style_id, style_type, incoming_style_id  from '||table_cart_master_temp||') a
where a.incoming_style_id=b.product
and a.style_type=''existing''
';
*/


-- STYLECOLOR ATTRIBUTES

s27 := '
delete from blk_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



s28 := '
INSERT INTO blk_ma_stylecolorattributes
        (product
        ,cc_initial_launch_month
        ,cccolor
        ,cc_diff_type
        ,cc_color_desc
        ,cc_colorfamily_code
        ,cccolorfamily
        ,cc_merch_color_name
        ,cc_vpn
        ,cc_vpn_color
        ,cc_first_rec_week
        ,cc_first_inv_week
        ,cc_first_sale_week
        ,cc_first_md_week
        ,cc_last_md_week
        ,cc_msrp
        ,cc_current_retail
        ,ccstylecolorcreatedate
        ,cc_dropship_indicator
        ,cc_replenishemnt_indicator
        ,cc_selling_season
        ,cc_selling_year
        ,cc_segment_buy
        ,cc_silhouette
        ,cc_subcategory
        ,cc_program_name
        ,cc_print_vs_solid
        ,cc_sleeve_length
        ,cc_fashion_vs_basic
        ,cc_top_length
        ,cc_denim_rise
        ,cc_bottom_fit
        ,cc_dress_length
        ,cc_neckline
        ,cc_inseam
        ,cc_lounge_vs_sleep
        ,cc_bottom_silo
        ,cc_robe
        ,cc_print_type
        ,cc_fit_solution
        ,cc_d_cup_available
        ,cc_occasion
        ,cc_categories
        ,cc_cut_fit
        ,cc_construction
        ,cc_bridal_registry
        ,cc_levi_fits
        ,cc_graphic_type
        ,cc_classification
        ,cc_young_contemporary
        ,cc_short_inseam
        ,cc_denim_trends
        ,cc_collegiate
        ,cc_set
        ,cc_material
        ,cc_configuration
        ,cc_bedding_accessories
        ,cc_fabric_description
        ,cc_black_friday_ind
        ,cc_superbuy_ind
        ,cc_aa_ind
        ,cc_coastal_ind
        ,cc_lodge_ind
        ,cc_white_dinnerware_ind
        ,cc_customer_need
        ,cc_fashion_jewelry
        ,cc_material_color
        ,cc_material_type
        ,cc_jewelry_presentation
        ,cc_necklaces
        ,cc_texture_pattern
        ,cc_high_value_status
        ,cc_fine_jewelry_metal
        ,cc_stone
        ,cc_bridal
        ,cc_metal_type
        ,cc_chain_type
        ,cc_bracelets
        ,cc_ears
        ,cc_ring
        ,cc_dial_color
        ,cc_watch
        ,cc_dtw_fine_jewelry
        ,cc_gold_mkt_fine_jewelry
        ,cc_grams_fine_jewelry
        ,cc_silver_mkt_fine_jewelry
        ,cc_silver_grams
        ,cc_ctw_fine_jewelry
        ,cc_shoe_type
        ,cc_shaft_height
        ,cc_outsole
        ,cc_closure
        ,cc_toe_type
        ,cc_sole_type
        ,cc_toe_character
        ,cc_heel_type
        ,cc_heel_height
        ,cc_fabric_type
        ,cc_width
        ,cc_tech_features
        ,cc_skechers_division
        ,cc_level_of_presentation
        ,cc_fragrance_scents
        ,cc_total_makeup
        ,cc_makeup_total_face
        ,cc_total_fragrance
        ,cc_makeup_total_lip
        ,cc_total_skincare
        ,cc_makeup_total_eye
        ,cc_skincare_total_face
        ,cc_styclr_status
        ,cc_skulist_id
        ,cc_skulist_desc
        ,total_brand_name
        ,division_name
        ,group_name
        ,department_name
        ,class_name
        ,subclass_name
        ,cc_s5_adopted
        ,cc_nrf_color_code_non_plm
        ,cc_nrf_color_desc_non_plm
        ,isassortment
        ,cccolorid
        ,cc_cost
        )
SELECT final_stylecolor_id as product
        ,b.cc_initial_launch_month
        ,a.cccolor
        ,b.cc_diff_type
        ,b.cc_color_desc
        ,b.cc_colorfamily_code
        ,a.cccolorfamily
        ,null as cc_merch_color_name
        ,null as cc_vpn
        ,null as cc_vpn_color
        ,null as cc_first_rec_week
        ,null as cc_first_inv_week
        ,null as cc_first_sale_week
        ,null as cc_first_md_week
        ,null as cc_last_md_week
        ,b.cc_msrp
        ,b.cc_msrp -- set cc_current_retail = msrp for new items
        --,b.ccstylecolorcreatedate
        ,null as ccstylecolorcreatedate   --Inherting ccstylecolorcreatedate from similar stylecolor will restrict the user from removing the stylecolor; so we set it to null until it is created in client host system
        ,b.cc_dropship_indicator
        ,b.cc_replenishemnt_indicator
        ,b.cc_selling_season
        ,b.cc_selling_year
        ,b.cc_segment_buy
        ,b.cc_silhouette
        ,b.cc_subcategory
        ,b.cc_program_name
        ,b.cc_print_vs_solid
        ,b.cc_sleeve_length
        ,b.cc_fashion_vs_basic
        ,b.cc_top_length
        ,b.cc_denim_rise
        ,b.cc_bottom_fit
        ,b.cc_dress_length
        ,b.cc_neckline
        ,b.cc_inseam
        ,b.cc_lounge_vs_sleep
        ,b.cc_bottom_silo
        ,b.cc_robe
        ,b.cc_print_type
        ,b.cc_fit_solution
        ,b.cc_d_cup_available
        ,b.cc_occasion
        ,b.cc_categories
        ,b.cc_cut_fit
        ,b.cc_construction
        ,b.cc_bridal_registry
        ,b.cc_levi_fits
        ,b.cc_graphic_type
        ,b.cc_classification
        ,b.cc_young_contemporary
        ,b.cc_short_inseam
        ,b.cc_denim_trends
        ,b.cc_collegiate
        ,b.cc_set
        ,b.cc_material
        ,b.cc_configuration
        ,b.cc_bedding_accessories
        ,b.cc_fabric_description
        ,b.cc_black_friday_ind
        ,b.cc_superbuy_ind
        ,b.cc_aa_ind
        ,b.cc_coastal_ind
        ,b.cc_lodge_ind
        ,b.cc_white_dinnerware_ind
        ,b.cc_customer_need
        ,b.cc_fashion_jewelry
        ,b.cc_material_color
        ,b.cc_material_type
        ,b.cc_jewelry_presentation
        ,b.cc_necklaces
        ,b.cc_texture_pattern
        ,b.cc_high_value_status
        ,b.cc_fine_jewelry_metal
        ,b.cc_stone
        ,b.cc_bridal
        ,b.cc_metal_type
        ,b.cc_chain_type
        ,b.cc_bracelets
        ,b.cc_ears
        ,b.cc_ring
        ,b.cc_dial_color
        ,b.cc_watch
        ,b.cc_dtw_fine_jewelry
        ,b.cc_gold_mkt_fine_jewelry
        ,b.cc_grams_fine_jewelry
        ,b.cc_silver_mkt_fine_jewelry
        ,b.cc_silver_grams
        ,b.cc_ctw_fine_jewelry
        ,b.cc_shoe_type
        ,b.cc_shaft_height
        ,b.cc_outsole
        ,b.cc_closure
        ,b.cc_toe_type
        ,b.cc_sole_type
        ,b.cc_toe_character
        ,b.cc_heel_type
        ,b.cc_heel_height
        ,b.cc_fabric_type
        ,b.cc_width
        ,b.cc_tech_features
        ,b.cc_skechers_division
        ,b.cc_level_of_presentation
        ,b.cc_fragrance_scents
        ,b.cc_total_makeup
        ,b.cc_makeup_total_face
        ,b.cc_total_fragrance
        ,b.cc_makeup_total_lip
        ,b.cc_total_skincare
        ,b.cc_makeup_total_eye
        ,b.cc_skincare_total_face
        ,b.cc_styclr_status
        ,b.cc_skulist_id
        ,b.cc_skulist_desc
        ,b.total_brand_name
        ,b.division_name
        ,b.group_name
        ,b.department_name
        ,b.class_name
        ,b.subclass_name
        ,''Y''
        ,b.cc_nrf_color_code_non_plm
        ,b.cc_nrf_color_desc_non_plm
        ,''true''
        ,a.cccolorid
        ,null as cc_cost
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, cccolorid  from '||table_cart_master_temp||') a, blk_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
';


s28_X := '
Update blk_ma_stylecolorattributes b
set isassortment = ''true'', cc_is_locked = case when b.ccstylecolorcreatedate is not null then ''Y'' else null end, cc_s5_adopted = ''Y''
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily,cccolorid  from '||table_cart_master_temp||') a
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
';

s28_Y := '
Update blk_ma_stylecolorattributes b
set cc_vpn = sty_vpn
from 
(
        select distinct final_style_id, final_stylecolor_id, coalesce(y.sty_vpn_final, y.sty_vpn, y.sty_vpn_id_non_plm) as sty_vpn
                                        from '||table_cart_master_temp||' x
                                        join blk_ma_styleattributes y
                                        on x.final_style_id = y.product
                                        where x.style_type = ''existing''
) a
where a.final_stylecolor_id=b.product
';


-- IMAGE ATTRIBUTES START

s29 := 'drop table if exists '||table_ma_imgattr||'';

s29_1 := '
create temporary table '||table_spec_img||' as
select
 distinct si.product, si.img, sa.product as style_id
from blk_specimages si
 inner join
blk_ma_styleattributes sa
 on sa.product = si.product
where sa.product in (select final_style_id from '||table_cart_master_temp||' where jsessionid in (select jsid from '||table_input_t1||'));
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
  (select distinct product, img from blk_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, style_id from '||table_spec_img||') d
on
d.style_id = c.final_style_id;

'
;


s31 := '
delete from blk_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;

s32 := '
insert into blk_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES

s33 := '
delete from blk_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';



s34 := '
insert into blk_ma_sizeattributes
    (product,
    parent_id,
    size_member_id,
    sizeattribute,
    source_member_id,
    source_member_name,
    sku_dropship_indicator,
    sku_replenishment_flag,
    sku_extended_size,
    sku_status,
    isvalid
    )
SELECT
    distinct final_stylecolorsize_id,
    final_stylecolor_id,
    size_member_id,
    size_name,
    source_member_id,
    source_member_name,
    sku_dropship_indicator,
    sku_replenishment_flag,
    sku_extended_size,
    sku_status,
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
  , a.ccrcptint as default_ccrcptint
  , a.ccordermultiple as default_ccordermultiple
  , a.ccordpolicy as default_ccordpolicy
  , a.slsrnk
  , a.cc_cluster_group -- added on 09212024
  , a.cc_service_level as default_service_level
from (select distinct * from cart_params) a, blk_ma_dptflrsetattributes c, '||table_input_t1||' b
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

  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  , coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , null as ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , ''{NA}''::text[] as cc_validsizes_store
  , ''{NA}''::text[] as cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , cc_existingwac
  , cc_systemcost
  , cc_landed_cost -- needs to go into cc_target_cost
  , a.slsrnk, a.cc_cluster_group -- added on 09212024
  , cc_imupct
  , null::real as cc_return_u_pct
  , cc_plan_cost
  , cc_target_cost
  , d.cc_msrp
  , a.default_service_level as cc_service_level
FROM
'||table_default_cart_params||' a, blk_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||' where style_type = ''similar'') c,
 blk_ma_stylecolorattributes d
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location and c.final_stylecolor_id = d.product
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

  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  , coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , cc_validsizes_store
  , cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , cc_existingwac
  , cc_systemcost
  , cc_landed_cost
  , a.slsrnk, a.cc_cluster_group
  , cc_imupct
  , null::real as cc_return_u_pct
  , cc_plan_cost
  , cc_target_cost
  , null::real as cc_msrp
  , a.default_service_level as cc_service_level
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id, style_type from '||table_cart_master_temp||' where style_type = ''existing'') b,
blk_ma_styleattributes c, 
--blk_ma_stylecolorattributes d,
blk_ma_stylecolorchannelattributes e 
--(select array_agg(target_value) as validsizes, lookup_value as sty_size_run_name from blk_l_dependencylookup where lookup_id = ''size_range'' group by lookup_value) e
where a.jsessionid=b.jsessionid 
and b.final_style_id = c.product 
--and b.final_stylecolor_id = d.product 
and b.incoming_stylecolor_id = e.product
and a.scope_location = e.location
--and c.sty_size_range = e.sty_size_run_name
'
;



s37 := '
delete from blk_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into blk_ma_stylecolorchannelattributes (
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
, cc_ordpolicy
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
, cc_existingwac
, cc_systemcost
, cc_landed_cost
, slsrnk, cc_cluster_group
, ccticketpricechannel
, cc_return_u_pct
, cc_plan_cost
, cc_target_cost
, cc_service_level
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
, cc_ordpolicy
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
, cc_existingwac
, cc_systemcost
, cc_landed_cost
, slsrnk, cc_cluster_group
, cc_msrp
, cc_return_u_pct
, cc_plan_cost
, cc_target_cost
, cc_service_level
FROM
 '||table_temp_sclr_chnl_attr||'
 ';




-- ASSORTMENT MODEL

s51 := '
update blk_ma_stylecolorchannelattributes a
set
  cc_discount_pct = default_discount
--, ccmdstrategy = default_md
from 
(
    select id, ancestor3, default_discount /*default_md,*/ 
    from blk_h_prodstd a, default_disc_md b
    where a.ancestor3=b.department
) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product=b.id
';

s51_x := '
update blk_ma_stylecolorchannelattributes
set plan_current = (select value as v_plan_current from blk_serviceparams where id=''plan_current'')
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

-- When adding a color to an exsting style, we will take the max of various attributes and cost for the parent style and apply them to the newly added stylecolor
s51_1 := '
update blk_ma_stylecolorchannelattributes a
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
 ,plan_current = (select value from blk_serviceparams where id=''plan_current'')
 --,cc_imupct = coalesce(round((((cc_msrp::real-coalesce(cc_actual_cost,cc_estimated_cost)::real)/cc_msrp::real)::numeric), 2)::real,0.0)::real
from 
(
  select d.product, x.sty_size_range || '' - '' || y.ancestor2 as rangecode, a.cc_validsizes_store_existing, a.cc_validsizes_ecom_existing, style_type, cc_msrp, cc_current_retail, a.cc_ordpolicy_existing, a.cc_ordermultiple_existing, a.cc_existingwac_existing, 
        a.cc_systemcost_existing, a.cc_plan_cost_existing,a.cc_landed_cost_existing, a.cc_target_cost_existing
  from 
    blk_ma_styleattributes x, 
    blk_h_prodstd y, 
    blk_ma_stylecolorattributes d,
    (
      select distinct final_stylecolor_id, final_style_id, style_type 
      from  '||table_cart_master_temp||' 
      where jsessionid in (select jsid from  '||table_input_t1||') and style_type = ''existing''
    ) z,
    (
      select a.ancestor0, max(b.cc_validsizes_store) as cc_validsizes_store_existing, max(b.cc_validsizes_ecom) as cc_validsizes_ecom_existing, max(b.cc_ordpolicy) as cc_ordpolicy_existing, 
             max(b.cc_ordermultiple) as cc_ordermultiple_existing, max(b.cc_existingwac) as cc_existingwac_existing, max(b.cc_systemcost) as cc_systemcost_existing, max(b.cc_plan_cost) as cc_plan_cost_existing, 
             max(b.cc_landed_cost) as cc_landed_cost_existing, max(b.cc_target_cost) as cc_target_cost_existing
      from blk_h_prodstd a
      join blk_ma_stylecolorchannelattributes b
      on a.id = b.product
      where a.ancestor0 in (select distinct final_style_id from  '||table_cart_master_temp||')
      group by a.ancestor0 
    ) a
    where x.product = z.final_style_id 
    and y.id = z.final_stylecolor_id 
    and d.product = z.final_stylecolor_id
    and x.product = a.ancestor0
) b
where a.product = b.product 
and (a.product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s39 := '
    create temporary table '||table_temp_assort||' AS
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(str_grade as text[]) as str_grade
        , cast(str_segmentation as text[]) as str_segmentation
        , cast(str_sub_segmentation as text[]) as str_sub_segmentation
        , cast(str_aa_ind as text[]) as str_aa_ind
        , cast(str_hisp_ind as text[]) as str_hisp_ind
        , cast(str_lifestyle_01 as text[]) as str_lifestyle_01
        , cast(str_lifestyle_02 as text[]) as str_lifestyle_02
        , cast(str_lifestyle_03 as text[]) as str_lifestyle_03
        , cast(str_lifestyle_04 as text[]) as str_lifestyle_04
        , cast(str_climate as text[]) as str_climate
        , cast(str_state as text[]) as str_state       
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , store_count
        , d.cc_msrp as a_msrp
        , d.cc_msrp as a_current_retail
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c,
    blk_ma_stylecolorattributes d
    where a.jsessionid=c.jsessionid
    and a.jsessionid = b.jsid
    and a.scope_product = b.scope_product
    and a.scope_location = b.scope_location
    and a.scope_start = b.scope_start
    and c.final_stylecolor_id = d.product
    '
    ;



s40 := '
delete from blk_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';



s41 := '

    insert into blk_a_assortment (
          product
        , location
        , "time"
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , a_msrp
        , a_current_retail)
    SELECT
          product
        , location
        , "time"
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , a_msrp
        , a_current_retail
    FROM
       '||table_temp_assort||'
';

s41_1 := '
update blk_ma_stylecolorattributes a
set
  cc_initial_launch_month = floorset
from (select min(time) as floorset from '||table_temp_assort||') b
where a.product in (select distinct final_stylecolor_id from '||table_cart_master_temp||')
';



RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

s42 := '
create temporary table '||table_final_list||' AS
select distinct a.product, a.location
from
(select distinct product,location  from blk_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from blk_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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
          FROM blk_ma_stylecolorchannelattributes AS a
          , blk_d_time AS b
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
              FROM blk_h_prodstd
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
            (select a.* from '||tst_df_with_style||' a, blk_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.cc_current_retail::real, curp=cc_current_retail::real
          from blk_ma_stylecolorattributes b
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
          from blk_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff
          from blk_p_itemprice b
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
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, blk_d_time b, blk_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from blk_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from blk_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from blk_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from blk_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from blk_ma_weekattributes b where a.time=b.time';


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
              FROM (select * from blk_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM blk_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM blk_ma_dptflrsetattributes AS a
              , blk_d_time AS b
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
          WHERE time >= (select value from blk_serviceparams where id=''plan_current'')
          AND time <= (select value from blk_serviceparams where id=''plan_end'')
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


s114 := 'delete from blk_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into blk_an_price_storecount_info
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
RAISE NOTICE 's21_x: %', s21_x;
RAISE NOTICE 's22: %', s22;
RAISE NOTICE 's23: %', s23;
RAISE NOTICE 's24: %', s24;
RAISE NOTICE 's25: %', s25;
RAISE NOTICE 's26: %', s26;
RAISE NOTICE 's26_X: %', s26_X;
RAISE NOTICE 's27: %', s27;
RAISE NOTICE 's28: %', s28;
RAISE NOTICE 's28_X: %', s28_X;
RAISE NOTICE 's28_Y: %', s28_Y;
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
RAISE NOTICE 's41_1: %', s41_1;

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
EXECUTE s7_x;
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
EXECUTE s21_x;
-- insert into trigger_test_delete_me values ('s21_x:', clock_timestamp());
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
--EXECUTE s26_X;
-- insert into trigger_test_delete_me values ('s26_X:', clock_timestamp());
EXECUTE s27;
-- insert into trigger_test_delete_me values ('s27:', clock_timestamp());
EXECUTE s28;
-- insert into trigger_test_delete_me values ('s28:', clock_timestamp());
EXECUTE s28_X;
-- insert into trigger_test_delete_me values ('s28_X:', clock_timestamp());
EXECUTE s28_Y;
-- insert into trigger_test_delete_me values ('s28_Y:', clock_timestamp());
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
EXECUTE s51_x;
EXECUTE s51_1;
-- insert into trigger_test_delete_me values ('s51_1:', clock_timestamp());
EXECUTE s39;
-- insert into trigger_test_delete_me values ('s39:', clock_timestamp());
EXECUTE s40;
-- insert into trigger_test_delete_me values ('s40:', clock_timestamp());
EXECUTE s41;
-- insert into trigger_test_delete_me values ('s41:', clock_timestamp());
EXECUTE s41_1;
-- insert into trigger_test_delete_me values ('s41_1:', clock_timestamp());
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
-- TOC entry 2119 (class 1255 OID 129294767)
-- Name: after_add_to_assortment(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE
dummy refcursor;
BEGIN

 OPEN dummy FOR select 'unused';
 RETURN dummy;

END;
$$;


ALTER FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2120 (class 1255 OID 129294768)
-- Name: auto_rollforward_true(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.auto_rollforward_true() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

begin

update blk_ma_stylecolorchannelattributes
set exitdate = (select value from blk_serviceparams where id = 'extended_range'),
    erlstmkdnwk = (select id from blk_d_time where indx = (select indx - 1 from blk_d_time where id = (select value from blk_serviceparams where id = 'extended_range'))),
    exitdate_indx = (select indx from blk_d_time where id = (select value from blk_serviceparams where id = 'extended_range')),
    mdstart_indx = (select indx - 1 from blk_d_time where id = (select value from blk_serviceparams where id = 'extended_range'))
where product = new.product
and auto_rollforward is true
;


  return NEW;
END;
$$;


ALTER FUNCTION public.auto_rollforward_true() OWNER TO psql;

--
-- TOC entry 2121 (class 1255 OID 129294769)
-- Name: blk_no_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.blk_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE blk_style_clone_flat_map_temp AS
    SELECT * 
    FROM (
        SELECT DISTINCT
            from_stylecolor   AS from_id,
            to_new_stylecolor AS to_id,
            'stylecolor'      AS levelid,
            updated_by, session_id, clone_ordinal::text as clone_ordinal
            , to_new_stylecolor_name as to_name
            , to_new_stylecolor_desc as to_desc
            , RIGHT(to_new_stylecolor_name, 8) as cccolor
            , 'TBD' as cccolorfamily
        FROM blk_style_clone_stylecolor_size
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
        FROM blk_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;
/*
    Insert Into blk_style_clone_flat_map_temp_archive
        Select from_id
            , to_id
            , levelid
            , session_id
            , clone_ordinal
            , to_name
            , to_desc
            , cccolor
            , cccolorfamily
            , now()::date as eventdate
            , '' as version_id
            , now() as created_at
            , v_pivot_user_id as created_by
            , now() as updated_at
            , v_pivot_user_id as updated_by
        from blk_style_clone_flat_map_temp;

                Insert Into blk_style_clone_stylecolor_size_archive
        Select from_style, to_new_style, from_stylecolor, to_new_stylecolor, from_stylecolorsize, to_new_stylecolorsize, session_id, picked_for_planning, clone_ordinal, to_new_style_name, to_new_style_desc, to_new_stylecolor_name, to_new_stylecolor_desc, now()::date as eventdate, now() as created_at, v_pivot_user_id as created_by , now() as updated_at, v_pivot_user_id as updated_by
        from blk_style_clone_stylecolor_size_archive;
*/
    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO blk_d_product (
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
        FROM blk_style_clone_flat_map_temp a,
             blk_d_product b
        WHERE a.from_id = b.id
        ;

    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
        INSERT INTO blk_h_prodstd (
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
            to_new_stylecolor,
            to_new_style,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
        INSERT INTO blk_h_prodstd (
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
            to_new_stylecolorsize,
            to_new_stylecolor,
            to_new_style,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

 
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_stylecolorattributes (
            product,
            cc_initial_launch_month,
            cccolor,
            cc_diff_type,
            cc_color_desc,
            cc_colorfamily_code,
            cccolorfamily,
            cc_merch_color_name,
            cc_vpn,
            cc_vpn_color,
            cc_first_rec_week,
            cc_first_inv_week,
            cc_first_sale_week,
            cc_first_md_week,
            cc_last_md_week,
            cc_msrp,
            cc_current_retail,
            ccstylecolorcreatedate,
            cc_dropship_indicator,
            cc_replenishemnt_indicator,
            cc_selling_season,
            cc_selling_year,
            cc_segment_buy,
            cc_silhouette,
            cc_subcategory,
            cc_program_name,
            cc_print_vs_solid,
            cc_sleeve_length,
            cc_fashion_vs_basic,
            cc_top_length,
            cc_denim_rise,
            cc_bottom_fit,
            cc_dress_length,
            cc_neckline,
            cc_inseam,
            cc_lounge_vs_sleep,
            cc_bottom_silo,
            cc_robe,
            cc_print_type,
            cc_fit_solution,
            cc_d_cup_available,
            cc_occasion,
            cc_categories,
            cc_cut_fit,
            cc_construction,
            cc_bridal_registry,
            cc_levi_fits,
            cc_graphic_type,
            cc_classification,
            cc_young_contemporary,
            cc_short_inseam,
            cc_denim_trends,
            cc_collegiate,
            cc_set,
            cc_material,
            cc_configuration,
            cc_bedding_accessories,
            cc_fabric_description,
            cc_black_friday_ind,
            cc_superbuy_ind,
            cc_aa_ind,
            cc_coastal_ind,
            cc_lodge_ind,
            cc_white_dinnerware_ind,
            cc_customer_need,
            cc_fashion_jewelry,
            cc_material_color,
            cc_material_type,
            cc_jewelry_presentation,
            cc_necklaces,
            cc_texture_pattern,
            cc_high_value_status,
            cc_fine_jewelry_metal,
            cc_stone,
            cc_bridal,
            cc_metal_type,
            cc_chain_type,
            cc_bracelets,
            cc_ears,
            cc_ring,
            cc_dial_color,
            cc_watch,
            cc_dtw_fine_jewelry,
            cc_gold_mkt_fine_jewelry,
            cc_grams_fine_jewelry,
            cc_silver_mkt_fine_jewelry,
            cc_silver_grams,
            cc_ctw_fine_jewelry,
            cc_shoe_type,
            cc_shaft_height,
            cc_outsole,
            cc_closure,
            cc_toe_type,
            cc_sole_type,
            cc_toe_character,
            cc_heel_type,
            cc_heel_height,
            cc_fabric_type,
            cc_width,
            cc_tech_features,
            cc_skechers_division,
            cc_level_of_presentation,
            cc_fragrance_scents,
            cc_total_makeup,
            cc_makeup_total_face,
            cc_total_fragrance,
            cc_makeup_total_lip,
            cc_total_skincare,
            cc_makeup_total_eye,
            cc_skincare_total_face,
            cc_styclr_status,
            cc_skulist_id,
            cc_skulist_desc,
            total_brand_name,
            division_name,
            group_name,
            department_name,
            class_name,
            subclass_name,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            isassortment,
            merch_comments,
            plan_comments,
            cc_is_locked,
            cc_s5_adopted,
            cc_prepublish,
            cc_prepublished_at,
            cc_nrf_color_code_non_plm,
            cc_nrf_color_desc_non_plm,
            cc_set_flag,
            cc_price_exception,
            cc_last_published_by,
            cc_last_published_on,
            cc_s5_stylecolor_status,
            cc_s5_stylecolor_status_msg,
            supp_brand_95,
            cc_vpn_color_desc,
            cc_vpn_color_display,
            cccolorid,
            cc_orin_stylecolor,
            cc_cost,
            cc_buy_period_descr,
            cc_vpn_buy_period,
            cc_floorset,
            cc_use_sys_floorset,
            cc_num_clones_s5,
            cc_num_times_cloned_s5
        )
        SELECT
            to_id,
            cc_initial_launch_month,
            a.cccolor  || ' ',
            cc_diff_type, --Check if null or what values this gets
            cc_color_desc,
            cc_colorfamily_code,
            a.cccolorfamily, --a.cccolorfamily
            null as cc_merch_color_name,
            null as cc_vpn,
            null as cc_vpn_color,
            null as cc_first_rec_week,
            null as cc_first_inv_week,
            null as cc_first_sale_week,
            null as cc_first_md_week,
            null as cc_last_md_week,
            cc_msrp,
            cc_current_retail,
            null as ccstylecolorcreatedate,
            cc_dropship_indicator,
            cc_replenishemnt_indicator,
            cc_selling_season,
            cc_selling_year,
            cc_segment_buy,
            cc_silhouette,
            cc_subcategory,
            cc_program_name,
            cc_print_vs_solid,
            cc_sleeve_length,
            cc_fashion_vs_basic,
            cc_top_length,
            cc_denim_rise,
            cc_bottom_fit,
            cc_dress_length,
            cc_neckline,
            cc_inseam,
            cc_lounge_vs_sleep,
            cc_bottom_silo,
            cc_robe,
            cc_print_type,
            cc_fit_solution,
            cc_d_cup_available,
            cc_occasion,
            cc_categories,
            cc_cut_fit,
            cc_construction,
            cc_bridal_registry,
            cc_levi_fits,
            cc_graphic_type,
            cc_classification,
            cc_young_contemporary,
            cc_short_inseam,
            cc_denim_trends,
            cc_collegiate,
            cc_set,
            cc_material,
            cc_configuration,
            cc_bedding_accessories,
            cc_fabric_description,
            cc_black_friday_ind,
            cc_superbuy_ind,
            cc_aa_ind,
            cc_coastal_ind,
            cc_lodge_ind,
            cc_white_dinnerware_ind,
            cc_customer_need,
            cc_fashion_jewelry,
            cc_material_color,
            cc_material_type,
            cc_jewelry_presentation,
            cc_necklaces,
            cc_texture_pattern,
            cc_high_value_status,
            cc_fine_jewelry_metal,
            cc_stone,
            cc_bridal,
            cc_metal_type,
            cc_chain_type,
            cc_bracelets,
            cc_ears,
            cc_ring,
            cc_dial_color,
            cc_watch,
            cc_dtw_fine_jewelry,
            cc_gold_mkt_fine_jewelry,
            cc_grams_fine_jewelry,
            cc_silver_mkt_fine_jewelry,
            cc_silver_grams,
            cc_ctw_fine_jewelry,
            cc_shoe_type,
            cc_shaft_height,
            cc_outsole,
            cc_closure,
            cc_toe_type,
            cc_sole_type,
            cc_toe_character,
            cc_heel_type,
            cc_heel_height,
            cc_fabric_type,
            cc_width,
            cc_tech_features,
            cc_skechers_division,
            cc_level_of_presentation,
            cc_fragrance_scents,
            cc_total_makeup,
            cc_makeup_total_face,
            cc_total_fragrance,
            cc_makeup_total_lip,
            cc_total_skincare,
            cc_makeup_total_eye,
            cc_skincare_total_face,
            cc_styclr_status,
            cc_skulist_id,
            cc_skulist_desc,
            total_brand_name,
            division_name,
            group_name,
            department_name,
            class_name,
            subclass_name,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            isassortment, --testing
            null as merch_comments,
            null as plan_comments,
            null as cc_is_locked,
            null as cc_s5_adopted,
            null as cc_prepublish,
            null as cc_prepublished_at,
            null as cc_nrf_color_code_non_plm,
            null as cc_nrf_color_desc_non_plm,
            null as cc_set_flag,
            null as cc_price_exception,
            null as cc_last_published_by,
            null as cc_last_published_on,
            null as cc_s5_stylecolor_status,
            null as cc_s5_stylecolor_status_msg,
            null as supp_brand_95,
            null as cc_vpn_color_desc,
            null as cc_vpn_color_display,
            b.cccolorid || ' ',
            null as cc_orin_stylecolor,
            cc_cost,
            null as cc_buy_period_descr,
            null as cc_vpn_buy_period,
            cc_floorset,
            null as cc_use_sys_floorset,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    -------------------------------------------------------------------- 
        INSERT INTO blk_ma_sizeattributes (
            product,
            parent_id,
            size_member_id,
            sizeattribute,
            source_member_id,
            source_member_name,
            sku_dropship_indicator,
            sku_replenishment_flag,
            sku_extended_size,
            sku_status,
            isvalid,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            to_new_stylecolorsize,
            to_new_stylecolor,
            size_member_id,
            sizeattribute,
            source_member_id, --test this
            source_member_name, --test this
            sku_dropship_indicator,
            sku_replenishment_flag,
            sku_extended_size,
            sku_status,
            isvalid,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_stylecolorchannelattributes (         
            product,
            location,
            dbt_wk,
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
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            slsrnk,
            ccticketpricechannel,
            ccticketpricechannel_override,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            ccmdstrategy,
            cc_presmin_weeks,
            cc_presmin,
            cc_ordpolicy,
            cc_rcptint,
            cc_ordermultiple,
            cc_discount_pct,
            cc_imupct,
            cc_existingwac,
            cc_systemcost,
            ssnprf,
            adjaps,
            relaunchweek,
            cc_plan_cost,
            cc_landed_cost,
            cc_target_cost,
            cc_flrset,
            cc_season,
            inseason_adjaps,
            smoothing_strategy,
            in_season_flag,
            lifecycle_applied,
            cc_return_u_pct,
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
            cc_cluster_group_or,
            cc_selected_clusters_or,
            relaunch_dbt_wk,
            relaunch_dbt_wk_indx,
            relaunch_erlstmkdnwk,
            relaunch_erlstmkdnwk_indx,
            relaunch_exitdate,
            relaunch_exitdate_indx,
            relaunch_initrcptwk,
            relaunch_initrcptwk_indx,
            relaunch_too,
            relaunch_mkdnwks,
            relaunch_last_rcpt_wk,
            relaunch_last_rcpt_wk_indx,
            relaunch_planned_sell_down_week,
            relaunch_planned_sell_down_week_indx,
            relaunch_cc_cluster_group,
            relaunch_is_valid,
            cloned_at
        )
        SELECT
            to_id,
            location,
            dbt_wk,
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
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            slsrnk,
            ccticketpricechannel,
            ccticketpricechannel_override,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            ccmdstrategy,
            cc_presmin_weeks,
            cc_presmin,
            cc_ordpolicy,
            cc_rcptint,
            cc_ordermultiple,
            cc_discount_pct,
            cc_imupct,
            cc_existingwac,
            cc_systemcost,
            ssnprf,
            adjaps,
            null as relaunchweek,
            cc_plan_cost,
            cc_landed_cost,
            cc_target_cost,
            cc_flrset,
            cc_season,
            inseason_adjaps,
            smoothing_strategy,
            in_season_flag,
            lifecycle_applied,
            cc_return_u_pct,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            1 as record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            cc_cluster_group_or,
            cc_selected_clusters_or,
            null as relaunch_dbt_wk,
            null as relaunch_dbt_wk_indx,
            null as relaunch_erlstmkdnwk,
            null as relaunch_erlstmkdnwk_indx,
            null as relaunch_exitdate,
            null as relaunch_exitdate_indx,
            null as relaunch_initrcptwk,
            null as relaunch_initrcptwk_indx,
            null as relaunch_too,
            null as relaunch_mkdnwks,
            null as relaunch_last_rcpt_wk,
            null as relaunch_last_rcpt_wk_indx,
            null as relaunch_planned_sell_down_week,
            null as relaunch_planned_sell_down_week_indx,
            null as relaunch_cc_cluster_group,
            null as relaunch_is_valid,
            date_trunc('sec'::text, CURRENT_TIMESTAMP) as cloned_at
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_imgattributes (
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_itemprice (
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
            excl_discount_pct
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            excl_discount_pct
        FROM blk_style_clone_flat_map_temp a,
             blk_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_channeloverride (
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
            floorsetpo
        )
        SELECT
            to_id,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            null as comments,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            testpo,
            floorsetpo
        FROM blk_style_clone_flat_map_temp a,
             blk_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
        INSERT INTO blk_a_assortment (
            product,
            location,
            time,
            style,
            str_grade,
            str_segmentation,
            str_sub_segmentation,
            str_aa_ind,
            str_hisp_ind,
            str_lifestyle_01,
            str_lifestyle_02,
            str_lifestyle_03,
            str_lifestyle_04,
            str_climate,
            str_state,
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
            a_msrp,
            a_current_retail,
            a_current_retail_override,
            str_grade_or,
            str_segmentation_or,
            str_sub_segmentation_or,
            str_aa_ind_or,
            str_hisp_ind_or,
            str_lifestyle_01_or,
            str_lifestyle_02_or,
            str_lifestyle_03_or,
            str_lifestyle_04_or,
            str_climate_or,
            str_state_or
        )
        SELECT
            to_id,
            location,
            time,
            style, --this might be old style, should be the to_id_style
            str_grade,
            str_segmentation,
            str_sub_segmentation,
            str_aa_ind,
            str_hisp_ind,
            str_lifestyle_01,
            str_lifestyle_02,
            str_lifestyle_03,
            str_lifestyle_04,
            str_climate,
            str_state,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            a_msrp,
            a_current_retail,
            a_current_retail_override,
            str_grade_or,
            str_segmentation_or,
            str_sub_segmentation_or,
            str_aa_ind_or,
            str_hisp_ind_or,
            str_lifestyle_01_or,
            str_lifestyle_02_or,
            str_lifestyle_03_or,
            str_lifestyle_04_or,
            str_climate_or,
            str_state_or
        FROM blk_style_clone_flat_map_temp a,
             blk_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_dc_adj (
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
            last_prepublished_ecom
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,--SUP-4034
            is_locked, --test this
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
            null as published_at,
            null as is_prepublished,
            null as prepublished_at,
            null as last_prepublished,
            null as po_arr,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,--SUP-4034
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            null as published_at_ecom,
            null as is_prepublished_ecom,
            null as prepublished_at_ecom,
            null as last_prepublished_ecom
        FROM blk_style_clone_flat_map_temp a,
             blk_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_dc_adj_size (
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
            dc_last_pub_ecom
        )
        SELECT
            from_stylecolorsize,
            location,
            time,
            null as dc_publish, --Why is this null and the other stuff not null at stylecolor level
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom
        FROM blk_style_clone_stylecolor_size a,
             blk_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO blk_an_price_storecount_info (
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
        FROM blk_style_clone_flat_map_temp a,
             blk_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;

    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO blk_l_dependencylookup (
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
        FROM blk_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';


-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS blk_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.blk_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2122 (class 1255 OID 129294771)
-- Name: blk_p_strategy_params_sync(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.blk_p_strategy_params_sync() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if any of the target fields changed
  IF TG_OP = 'UPDATE' AND (
    NEW.rec_magnitude IS DISTINCT FROM OLD.rec_magnitude OR
    NEW.apply_targets_to_plan IS DISTINCT FROM OLD.apply_targets_to_plan OR
    NEW.cluster_group_selected_type IS DISTINCT FROM OLD.cluster_group_selected_type
  ) THEN
    UPDATE public.blk_p_strategy_params p
    SET rec_magnitude = NEW.rec_magnitude,
        apply_targets_to_plan = NEW.apply_targets_to_plan,
        cluster_group_selected_type = NEW.cluster_group_selected_type,
        updated_at = date_trunc('sec', CURRENT_TIMESTAMP),
        updated_by = NEW.updated_by
    WHERE p.product = NEW.product
      AND p.quarter = NEW.quarter  -- Changed from quarter_start to quarter
      -- avoid re-updating the same physical row (PK)
      AND (p.product, p.location, p.floorset_uda) <> (NEW.product, NEW.location, NEW.floorset_uda);
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.blk_p_strategy_params_sync() OWNER TO psql;

--
-- TOC entry 2124 (class 1255 OID 129294772)
-- Name: blk_plan_these_cloned_style_stylecolors_proc(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.blk_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text)
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
    FROM blk_plan_these_cloned_style_stylecolors
    WHERE updated_by = v_pivot_user_id
      AND picked_for_planning = 0
    ;

    UPDATE
        blk_style_clone_stylecolor_size
    SET 
        picked_for_planning = 1 
    WHERE 
        (to_new_stylecolor, session_id) IN (select stylecolor, session_id from blk_plan_these_cloned_style_stylecolors where updated_by = v_pivot_user_id)
    ;


    -- ----------------------------------
    -- MARK FOR DELETION UNUSED PRODUCTS 
    -- ----------------------------------


    CREATE TEMPORARY TABLE all_un_used_products
    AS  
    SELECT 
        DISTINCT to_new_style AS product, 'style' AS levelid 
    FROM 
        blk_style_clone_stylecolor_size s
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
        blk_style_clone_stylecolor_size s
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
        blk_style_clone_stylecolor_size s
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
    DELETE FROM blk_style_clone_stylecolor_size a 
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
    delete from blk_d_product where id in (select distinct product from all_un_used_products);

    delete from blk_h_prodstd where id in (select distinct product from all_un_used_products);
   
    delete from blk_a_assortment where product in (select distinct product from all_un_used_products);

    delete from blk_ma_styleattributes where product in (select distinct product from all_un_used_products);

    delete from blk_ma_stylecolorattributes where product in (select distinct product from all_un_used_products);

    delete from blk_ma_sizeattributes where product in (select distinct product from all_un_used_products);

    delete from blk_ma_imgattributes where product in (select distinct product from all_un_used_products);

    delete from blk_p_dc_adj where product in (select distinct product from all_un_used_products);

    delete from blk_p_dc_adj_size where product in (select distinct product from all_un_used_products);

    delete from blk_p_itemprice where product in (select distinct product from all_un_used_products);

    delete from blk_p_channeloverride where product in (select distinct product from all_un_used_products);

    delete from blk_an_price_storecount_info where product in (select distinct product from all_un_used_products);
    */

    -- --------------------------------------------------------------------------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW, SIMULATING REMOVE FROM ASSORTMENT, LIKELY DATA EXISTS IN CLICKHOUSE
    -- --------------------------------------------------------------------------------------------------------
    delete from blk_a_assortment where product in (select distinct product from all_un_used_products);
    update blk_ma_stylecolorchannelattributes set record_state=1 where product in (select distinct product from all_un_used_products);

    update blk_ma_stylecolorchannelattributes 
    set record_state=0
    where product in (select distinct stylecolor from tmp_selected);

    ------------------------------------
    -- INSERT IN PLAN QUEUE FOR PLANNING
    ------------------------------------

    INSERT INTO plan_queue (product, location, initiator, initiated_at, queued)
    select 
        distinct stylecolor, 'CP-1' as location, updated_by, now(), now() 
    FROM 
        tmp_selected
    ;

    ------------------------------------
    -- UPDATE picked_for_planning FLAG
    ------------------------------------
    UPDATE 
        blk_plan_these_cloned_style_stylecolors 
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


ALTER PROCEDURE public.blk_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2181 (class 1255 OID 134214555)
-- Name: blk_plan_these_cloned_style_stylecolors_proc(text, text, text, text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.blk_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text, IN p_department text, IN p_channel text, IN p_floorset text, IN p_uuids text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_pstart TEXT;
    v_pend TEXT;
    v_supp_supplier_site_id TEXT;
BEGIN

    CREATE TEMPORARY TABLE bpt_new_styles ON COMMIT DROP AS 
    SELECT 
        pass.preasst_uuid as style_id,
        pass.preasst_style_name as style_name,
        pass.preasst_class as class_id,
        h_prod.id as subclass_id,
        pass.preasst_color_count as color_count,
        pass.preasst_supplier as supplier, --supp_supplier_site_id
        pass.preasst_styletype as styletype --sty_style_type
    FROM blk_p_preassortment_stylesheet pass
    LEFT JOIN blk_h_prodstd h_prod
    on h_prod.ancestor0 = pass.preasst_class
    WHERE 
        preasst_uuid = ANY(string_to_array(p_uuids, ',')::text[])
        AND preasst_uuid NOT IN (select id from blk_d_product)
        AND pass.record_state != 1;

    CREATE TEMPORARY TABLE colors_per_style ON COMMIT DROP AS
    SELECT
        ns.style_id as style_id,
        ns.style_name as style_name,
        gen_random_uuid()::text as stylecolor_id,
        series.clr_num as clr_num
    FROM bpt_new_styles ns
    CROSS JOIN LATERAL generate_series(1, ns.color_count) as series(clr_num);

    CREATE TEMPORARY TABLE new_colors ON COMMIT DROP AS
    SELECT
        cps.style_id as style_id,
        cps.style_name as style_name,
        cps.stylecolor_id as stylecolor_id,
        cc.cccolorid as cccolorid,
        cc.cccolorname as cccolorname,
        cc.cccolor_indx as cccolor_indx
    FROM colors_per_style cps
    INNER JOIN (
        SELECT 
            attributekey as cccolorid,
            attributevalue as cccolorname,
            indx as cccolor_indx,
            ROW_NUMBER() OVER (ORDER BY indx) AS ccolor_row_num
        FROM blk_v_memberbasedvalidvalues
        WHERE
            attributeid = 'cccolorid'
        ORDER BY cccolor_indx
    ) cc
    ON cc.ccolor_row_num = cps.clr_num;
    /*SELECT DISTINCT ON (stylecolor_id)
        *
    FROM (
        SELECT DISTINCT ON (style_id, cccolor_indx)
            cps.style_id as style_id,
            cps.style_name as style_name,
            cps.stylecolor_id as stylecolor_id,
            cc.cccolorid as cccolorid,
            cc.cccolor_indx as cccolor_indx
        FROM colors_per_style cps
        INNER JOIN (
            SELECT 
                attributekey as cccolorid,
                attributevalue as cccolorname,
                indx as cccolor_indx
            FROM blk_v_memberbasedvalidvalues
            WHERE
                attributeid = 'cccolorid'
            ORDER BY cccolor_indx
        ) cc
        ON cc.ccolor_row_num = cps.clr_num
        ORDER BY style_id, cccolor_indx
    );*/

    /* generate style level data */
    CREATE TEMPORARY TABLE style_d_product ON COMMIT DROP AS
    SELECT
        style_id as id,
        null as client_id,
        style_name as name,
        style_name as description,
        'style'::text as levelid
    FROM bpt_new_styles;
    CREATE TEMPORARY TABLE style_h_prodstd ON COMMIT DROP AS
    SELECT
        ns.style_id as id,
        id as ancestor0,
        ancestor0 as ancestor1,
        ancestor1 as ancestor2,
        ancestor2 as ancestor3,
        ancestor3 as ancestor4,
        ancestor4 as ancestor5,
        ancestor5 as ancestor6,
        ancestor6 as ancestor7
    FROM
        bpt_new_styles ns
    LEFT JOIN blk_h_prodstd h_prod
    ON ns.subclass_id = h_prod.id;

    /* supp_supplier_site_id */
    SELECT 
        target_value into v_supp_supplier_site_id
    FROM blk_l_dependencylookup
    WHERE
        target_id = 'supp_supplier_site_id'
        AND lookup_id = 'department'
        AND lookup_value = p_department
    ORDER BY index ASC
    LIMIT 1
    ;
    CREATE TEMPORARY TABLE style_attrs ON COMMIT DROP AS
    SELECT
        ns.style_id as product
        , ns.styletype as sty_style_type
        , ns.supplier as supp_supplier_site_id
    FROM 
        bpt_new_styles ns
    ;

    /* generate stylecolor level data */
    CREATE TEMPORARY TABLE stylecolor_d_product ON COMMIT DROP AS
    SELECT
        nc.stylecolor_id as id,
        nc.style_name || '-' || nc.cccolorid as name, -- I can use the trigger to get these set correctly
        nc.style_name || '-' || nc.cccolorid as description,
        'stylecolor'::text as levelid
    FROM new_colors nc;

    CREATE TEMPORARY TABLE stylecolor_h_prod ON COMMIT DROP AS
    SELECT
        nc.stylecolor_id as id,
        h_prod.id as ancestor0,
        h_prod.ancestor0 as ancestor1,
        h_prod.ancestor1 as ancestor2,
        h_prod.ancestor2 as ancestor3,
        h_prod.ancestor3 as ancestor4,
        h_prod.ancestor4 as ancestor5,
        h_prod.ancestor5 as ancestor6,
        h_prod.ancestor6 as ancestor7
    FROM
        new_colors nc
    LEFT JOIN style_h_prodstd h_prod
    ON nc.style_id = h_prod.id;

    CREATE TEMPORARY TABLE stylecolor_attrs ON COMMIT DROP AS
    SELECT
        nc.stylecolor_id as product
        , nc.cccolorid as cccolorid
        , nc.cccolorid as cccolor
        , nc.cccolorname as cc_color_desc
        , 2.0 as cc_msrp
    FROM
        new_colors nc;
    /* generate size data */
    CREATE TEMPORARY TABLE size_attrs ON COMMIT DROP AS
    SELECT
        uuid_generate_v4()::text AS sku_id
        , 'NA' as size_name
        , 'NA' as size_description
        , nc.stylecolor_id as stylecolor_id
        , nc.style_id as style_id
        , 0 as sku_status
        , 1 as isvalid
    FROM new_colors nc;
    CREATE TEMPORARY TABLE size_d_product ON COMMIT DROP AS
    SELECT
        sku_id as id
        , size_name as name
        , size_description as description
        , 'stylecolorsize'::text as levelid
    FROM size_attrs;
    CREATE TEMPORARY TABLE size_h_prod ON COMMIT DROP AS
    SELECT
        sa.sku_id as id
        , h_prod.id as ancestor0
        , h_prod.ancestor0 as ancestor1
        , h_prod.ancestor1 as ancestor2
        , h_prod.ancestor2 as ancestor3
        , h_prod.ancestor3 as ancestor4
        , h_prod.ancestor4 as ancestor5
        , h_prod.ancestor5 as ancestor6
        , h_prod.ancestor6 as ancestor7
    FROM size_attrs sa
    LEFT JOIN stylecolor_h_prod h_prod
    ON sa.stylecolor_id = h_prod.id;

    -- insert into '||table_cart_stylecolorsize||'
    -- SELECT
    --        uuid_generate_v4()::text AS final_stylecolorsize_id
    --      , ''NA''                   AS size_name
    --      , ''NA''                   AS size_description
    --      , a.incoming_stylecolor_id
    --      , a.incoming_style_id
    --      , a.final_style_id
    --      , a.final_stylecolor_id
    --      , a.stylecolor_type
    --      , a.jsessionid
    --      , null                     AS size_member_id
    --      , null                     AS source_member_id
    --      , null                     AS source_member_name
    --      , null                     AS sku_dropship_indicator
    --      , null                     AS sku_replenishment_flag
    --      , null                     AS sku_extended_size
    --      , 0                        AS sku_status
    --      , 1                        AS isvalid
    --       FROM   '||table_cart_master_temp||' a
    --       WHERE stylecolor_type = ''similar''
    --       '
    --       ;
    /* generate channel data */
    /* blk_p_approvedclusters get cc_cluster, prices/costs*/
    CREATE TEMPORARY TABLE stylecolorchannel_attrs ON COMMIT DROP AS
    SELECT 
        nc.stylecolor_id AS product
        , p_channel AS location
        , default_dbt_wk as dbt_wk
        , default_initrcptwk as initrcptwk
        , default_too as too
        , default_mkdnwks as mkdnwks
        , default_last_inv_wk as last_inv_wk
        , default_lstfpwk as lstfpwk
        , default_last_rcpt_wk as last_rcpt_wk
        , default_erlstmkdnwk as erlstmkdnwk
        , default_exitdate as exitdate
        , default_ccmdstrategy as ccmdstrategy
        , default_presmin as cc_presmin
        , default_presmin_weeks as cc_presmin_weeks
        , default_ccrcptint as cc_rcptint
        , default_ccordermultiple as cc_ordermultiple
        , default_ccordpolicy as cc_ordpolicy
        , ap_start
        , ap_end
        , slsstart
        , slsend
        
        /*
        validsizes // array(string) already defaults
        cc_presmin_weeks // int32
        cc_presmin // int32
        cc_rcptint // int32
        adjaps // float32
        cc_plan_cost // float32
        cc_landed_cost // float32
        cc_target_cost // float32

        */
        , 1.0 as adjaps
        , 0.1 as cc_plan_cost
        , 0.1 as cc_landed_cost
        , 0.1 as cc_target_cost
        
        /*, ccrangecode
        , ssnprf
        , validsizes
        , cc_validsizes_store
        , cc_validsizes_ecom
        , cc_imupct
        , cc_existingwac
        , cc_systemcost
        , cc_landed_cost
        , slsrnk
        , cc_cluster_group
        , ccticketpricechannel
        , cc_return_u_pct
        , cc_plan_cost
        , cc_target_cost
        , cc_service_level*/
    FROM
        new_colors nc
    CROSS JOIN (
        select 
            *
        FROM blk_ma_dptflrsetattributes
        WHERE 
            product = p_department
            AND time = p_floorset
    ) dfa
    ;
    /* generate assortment data */
    -- create only first floorset then trigger to populate rest
    CREATE TEMPORARY TABLE all_floorsets ON COMMIT DROP AS
    SELECT
        DISTINCT
        p_channel as location,
        a.indx,
        a.time
    FROM 
        blk_ma_dptflrsetattributes a,
        stylecolorchannel_attrs b
    WHERE
        a.product = p_department
        AND b.location = p_channel
        AND a.slsstart <= b.exitdate
        AND a.slsend >= b.dbt_wk
    ORDER BY indx;

    CREATE TEMPORARY TABLE assortment_flrsets ON COMMIT DROP AS
    SELECT 
          nc.stylecolor_id as product
        , p_channel as location
        , all_flr.time as time
        , style_id as style
        , default_str_grade as str_grade
        , default_str_segmentation as str_segmentation
        , default_str_sub_segmentation as str_sub_segmentation
        , default_str_aa_ind as str_aa_ind
        , default_str_hisp_ind as str_hisp_ind
        , default_str_lifestyle_01 as str_lifestyle_01
        , default_str_lifestyle_02 as str_lifestyle_02
        , default_str_lifestyle_03 as str_lifestyle_03
        , default_str_lifestyle_04 as str_lifestyle_04
        , default_str_climate as str_climate
        , default_str_state as str_state
        , default_ssg as ssg
        , default_flnrange as flnrange
        , default_str_grade_or as str_grade_or
        , default_str_segmentation_or as str_segmentation_or
        , default_str_sub_segmentation_or as str_sub_segmentation_or
        , default_str_aa_ind_or as str_aa_ind_or
        , default_str_hisp_ind_or as str_hisp_ind_or
        , default_str_lifestyle_01_or as str_lifestyle_01_or
        , default_str_lifestyle_02_or as str_lifestyle_02_or
        , default_str_lifestyle_03_or as str_lifestyle_03_or
        , default_str_lifestyle_04_or as str_lifestyle_04_or
        , default_str_climate_or as str_climate_or
        , default_str_state_or as str_state_or
        , ''::text as plan_type
        --, store_count
        --, a_msrpq
        --, a_current_retail
    FROM
        new_colors nc
    CROSS JOIN (
        select 
            *
        FROM blk_ma_dptflrsetattributes
        WHERE 
            product = p_department
            AND time = p_floorset
    ) dfa
    CROSS JOIN (
        select 
            *
        FROM all_floorsets
    ) all_flr
    ;

    /* do inserts */
    INSERT INTO blk_h_prodstd(
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    )
    SELECT 
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    FROM style_h_prodstd;
    INSERT INTO blk_h_prodstd(
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    )
    SELECT 
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    FROM stylecolor_h_prod;
    INSERT INTO blk_h_prodstd(
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    )
    SELECT 
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    FROM size_h_prod;

    INSERT INTO blk_d_product(
        id
        , name
        , description
        , levelid
    )
    select 
        id
        , name
        , description
        , levelid
    from style_d_product;
    INSERT INTO blk_d_product(
        id
        , name
        , description
        , levelid
    )
    select 
        id
        , name
        , description
        , levelid
    from stylecolor_d_product;
    INSERT INTO blk_d_product(
        id
        , name
        , description
        , levelid
    )
    select 
        id
        , name
        , description
        , levelid
    from size_d_product;

    INSERT INTO blk_ma_styleattributes(
        product
        , sty_style_type
        , supp_supplier_site_id
    )
    select 
        product
        , sty_style_type
        , supp_supplier_site_id
    from style_attrs;

    INSERT INTO blk_ma_stylecolorattributes(
        product
        , cccolorid
        , cccolor
        , cc_color_desc
        , cc_msrp
    ) 
    select 
        product
        , cccolorid
        , cccolorid || ' ' || cc_color_desc as cccolor
        , cc_color_desc
        , cc_msrp
    from stylecolor_attrs;
    INSERT INTO blk_ma_imgattributes(
        product
    ) select 
        product
    from stylecolor_attrs;
    INSERT INTO blk_ma_sizeattributes(
        product
        , parent_id
        , sizeattribute
        , sku_status
        , isvalid
    ) SELECT 
        sku_id as product
        , stylecolor_id as parent_id
        , size_name as sizeattribute
        , sku_status
        , isvalid
    FROM size_attrs;

    INSERT INTO blk_ma_stylecolorchannelattributes(
        product
        , location
        , dbt_wk
        , initrcptwk
        , too
        , mkdnwks
        , last_inv_wk
        , lstfpwk
        , last_rcpt_wk
        , erlstmkdnwk
        , exitdate
        , ccmdstrategy
        , cc_presmin
        , cc_presmin_weeks
        , cc_rcptint
        , cc_ordermultiple
        , cc_ordpolicy
        
        , adjaps
        , cc_plan_cost
        , cc_landed_cost
        , cc_target_cost
    )
    SELECT 
        product
        , location
        , dbt_wk
        , initrcptwk
        , too
        , mkdnwks
        , last_inv_wk
        , lstfpwk
        , last_rcpt_wk
        , erlstmkdnwk
        , exitdate
        , ccmdstrategy
        , cc_presmin
        , cc_presmin_weeks
        , cc_rcptint
        , cc_ordermultiple
        , cc_ordpolicy

        , adjaps
        , cc_plan_cost
        , cc_landed_cost
        , cc_target_cost
    from stylecolorchannel_attrs;
    INSERT INTO blk_a_assortment (
        product
        , location
        , time
        , style
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , isfunded
        , str_grade_or
        , str_segmentation_or
        , str_sub_segmentation_or
        , str_aa_ind_or
        , str_hisp_ind_or
        , str_lifestyle_01_or
        , str_lifestyle_02_or
        , str_lifestyle_03_or
        , str_lifestyle_04_or
        , str_climate_or
        , str_state_or
        , plan_type
    )
    SELECT 
        product
        , location
        , time
        , style
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , 1 as isfunded
        , str_grade_or
        , str_segmentation_or
        , str_sub_segmentation_or
        , str_aa_ind_or
        , str_hisp_ind_or
        , str_lifestyle_01_or
        , str_lifestyle_02_or
        , str_lifestyle_03_or
        , str_lifestyle_04_or
        , str_climate_or
        , str_state_or
        , plan_type
    FROM assortment_flrsets;


    -- UPDATE blk_ma_stylecolorchannelattributes AS upd
    -- SET 
    --     dbt_wk = ref.dbt_wk
    --     , erlstmkdnwk = ref.erlstmkdnwk
    --     , exitdate = ref.exitdate
    -- FROM stylecolorchannel_attrs as ref
    -- WHERE
    --     ref.product = upd.product
    --     AND ref.location = upd.location
    -- ;

    INSERT INTO blk_p_preassortment_status (
        product,
        is_preasst
    ) SELECT 
        stylecolor_id as product,
        1 as is_preasst
    FROM 
        new_colors;

    UPDATE blk_p_preassortment_stylesheet 
        SET record_state = 1
    WHERE preasst_uuid = ANY(string_to_array(p_uuids, ',')::text[]);


    INSERT INTO plan_queue(
        product
        , location
        , initiator
        , queued
    ) SELECT 
        stylecolor_id as product
        , p_channel as location
        , p_pivot_user_id as initiator
        , now() as queued
    FROM new_colors;


END;
$$;


ALTER PROCEDURE public.blk_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text, IN p_department text, IN p_channel text, IN p_floorset text, IN p_uuids text) OWNER TO psql;

--
-- TOC entry 2125 (class 1255 OID 129294773)
-- Name: blk_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.blk_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE blk_style_clone_flat_map_temp AS
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
        FROM blk_style_clone_stylecolor_size
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
        FROM blk_style_clone_stylecolor_size
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
        FROM blk_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND session_id = v_session_id
    ) x;
/*
        Insert Into blk_style_clone_flat_map_temp_archive
        Select from_id
            , to_id
            , levelid
            , session_id
            , clone_ordinal
            , to_name
            , to_desc
            , cccolor
            , cccolorfamily
            , now()::date as eventdate
            , '' as version_id
            , now() as created_at
            , v_pivot_user_id as created_by
            , now() as updated_at
            , v_pivot_user_id as updated_by
        from blk_style_clone_flat_map_temp;

        Insert Into blk_style_clone_stylecolor_size_archive
        Select from_style, to_new_style, from_stylecolor, to_new_stylecolor, from_stylecolorsize, to_new_stylecolorsize, session_id, picked_for_planning, clone_ordinal, to_new_style_name, to_new_style_desc, to_new_stylecolor_name, to_new_stylecolor_desc, now()::date as eventdate, now() as created_at, v_pivot_user_id as created_by , now() as updated_at, v_pivot_user_id as updated_by
        from blk_style_clone_stylecolor_size_archive;
*/
    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO blk_d_product (
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
        FROM blk_style_clone_flat_map_temp a,
             blk_d_product b
        WHERE a.from_id = b.id
        ;

    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
        INSERT INTO blk_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
        INSERT INTO blk_h_prodstd (
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
            to_new_stylecolor,
            to_new_style,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO blk_h_prodstd (
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
            to_new_stylecolorsize,
            to_new_stylecolor,
            to_new_style,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
            ancestor6,
            ancestor7,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_styleattributes(
            product,
            sty_vpn,
            sty_supplier_number,
            sty_supplier_name,
            sty_size_range,
            sty_style_type,
            ccstylecreatedate,
            sty_style_status,
            supp_supplier_site_id,
            supp_supplier_name,
            supp_parent_supplier_id,
            supp_parent_supplier_name,
            supp_status,
            supp_class_group,
            supp_brand_mindset,
            supp_brand_type,
            supp_brand,
            supp_priceband,
            supp_bi_flg,
            supp_grp_parent_id,
            supp_grp_standard_id,
            supp_grp_brand_id,
            supp_ninebox,
            supp_lifestyle,
            supp_direct_ship_ind,
            class_group_id,
            class_group_name,
            dpt_department_id,
            dpt_gmm_id,
            dpt_gmm_desc,
            dpt_dmm_id,
            dpt_dmm_desc,
            dpt_buyer_id,
            dpt_buyer_desc,
            dpt_sr_planner_id,
            dpt_sr_planner_desc,
            dpt_planner_id,
            dpt_planner_desc,
            dpt_dir_id,
            dpt_dir_desc,
            dpt_vp_id,
            dpt_vp_desc,
            dpt_svp_id,
            dpt_svp_desc,
            dpt_evp_id,
            dpt_evp_desc,
            dpt_marketplace_indicator,
            dpt_memo_dept_indicator,
            dpt_royalty_pct,
            sty_is_locked,
            sty_s5_adopted,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            sty_vpn_id_non_plm,
            sty_vpn_final,
            sty_orin_style,
            sty_style_name,
            sty_style_description,
            sty_buy_period_descr,
            sty_dpt_buy_period,
            sty_vpn_buy_period,
            sty_num_clones_s5,
            sty_num_times_cloned_s5
        )
        Select 
            to_id,
            null as sty_vpn,
            sty_supplier_number,
            sty_supplier_name,
            sty_size_range,
            sty_style_type,
            null as ccstylecreatedate,
            sty_style_status,
            supp_supplier_site_id,
            supp_supplier_name,
            supp_parent_supplier_id,
            supp_parent_supplier_name,
            supp_status,
            supp_class_group,
            supp_brand_mindset,
            supp_brand_type,
            supp_brand,
            supp_priceband,
            supp_bi_flg,
            supp_grp_parent_id,
            supp_grp_standard_id,
            supp_grp_brand_id,
            supp_ninebox,
            supp_lifestyle,
            supp_direct_ship_ind,
            class_group_id,
            class_group_name,
            dpt_department_id,
            dpt_gmm_id,
            dpt_gmm_desc,
            dpt_dmm_id,
            dpt_dmm_desc,
            dpt_buyer_id,
            dpt_buyer_desc,
            dpt_sr_planner_id,
            dpt_sr_planner_desc,
            dpt_planner_id,
            dpt_planner_desc,
            dpt_dir_id,
            dpt_dir_desc,
            dpt_vp_id,
            dpt_vp_desc,
            dpt_svp_id,
            dpt_svp_desc,
            dpt_evp_id,
            dpt_evp_desc,
            dpt_marketplace_indicator,
            dpt_memo_dept_indicator,
            dpt_royalty_pct,
            null as sty_is_locked,
            null as sty_s5_adopted,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            sty_vpn_id_non_plm,
            null as sty_vpn_final,
            sty_orin_style,
            sty_style_name,
            sty_style_description,
            sty_buy_period_descr,
            sty_dpt_buy_period,
            null as sty_vpn_buy_period,
            null as sty_num_clones_s5,
            null as sty_num_times_cloned_s5
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;        
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_stylecolorattributes (
            product,
            cc_initial_launch_month,
            cccolor,
            cc_diff_type,
            cc_color_desc,
            cc_colorfamily_code,
            cccolorfamily,
            cc_merch_color_name,
            cc_vpn,
            cc_vpn_color,
            cc_first_rec_week,
            cc_first_inv_week,
            cc_first_sale_week,
            cc_first_md_week,
            cc_last_md_week,
            cc_msrp,
            cc_current_retail,
            ccstylecolorcreatedate,
            cc_dropship_indicator,
            cc_replenishemnt_indicator,
            cc_selling_season,
            cc_selling_year,
            cc_segment_buy,
            cc_silhouette,
            cc_subcategory,
            cc_program_name,
            cc_print_vs_solid,
            cc_sleeve_length,
            cc_fashion_vs_basic,
            cc_top_length,
            cc_denim_rise,
            cc_bottom_fit,
            cc_dress_length,
            cc_neckline,
            cc_inseam,
            cc_lounge_vs_sleep,
            cc_bottom_silo,
            cc_robe,
            cc_print_type,
            cc_fit_solution,
            cc_d_cup_available,
            cc_occasion,
            cc_categories,
            cc_cut_fit,
            cc_construction,
            cc_bridal_registry,
            cc_levi_fits,
            cc_graphic_type,
            cc_classification,
            cc_young_contemporary,
            cc_short_inseam,
            cc_denim_trends,
            cc_collegiate,
            cc_set,
            cc_material,
            cc_configuration,
            cc_bedding_accessories,
            cc_fabric_description,
            cc_black_friday_ind,
            cc_superbuy_ind,
            cc_aa_ind,
            cc_coastal_ind,
            cc_lodge_ind,
            cc_white_dinnerware_ind,
            cc_customer_need,
            cc_fashion_jewelry,
            cc_material_color,
            cc_material_type,
            cc_jewelry_presentation,
            cc_necklaces,
            cc_texture_pattern,
            cc_high_value_status,
            cc_fine_jewelry_metal,
            cc_stone,
            cc_bridal,
            cc_metal_type,
            cc_chain_type,
            cc_bracelets,
            cc_ears,
            cc_ring,
            cc_dial_color,
            cc_watch,
            cc_dtw_fine_jewelry,
            cc_gold_mkt_fine_jewelry,
            cc_grams_fine_jewelry,
            cc_silver_mkt_fine_jewelry,
            cc_silver_grams,
            cc_ctw_fine_jewelry,
            cc_shoe_type,
            cc_shaft_height,
            cc_outsole,
            cc_closure,
            cc_toe_type,
            cc_sole_type,
            cc_toe_character,
            cc_heel_type,
            cc_heel_height,
            cc_fabric_type,
            cc_width,
            cc_tech_features,
            cc_skechers_division,
            cc_level_of_presentation,
            cc_fragrance_scents,
            cc_total_makeup,
            cc_makeup_total_face,
            cc_total_fragrance,
            cc_makeup_total_lip,
            cc_total_skincare,
            cc_makeup_total_eye,
            cc_skincare_total_face,
            cc_styclr_status,
            cc_skulist_id,
            cc_skulist_desc,
            total_brand_name,
            division_name,
            group_name,
            department_name,
            class_name,
            subclass_name,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            isassortment,
            merch_comments,
            plan_comments,
            cc_is_locked,
            cc_s5_adopted,
            cc_prepublish,
            cc_prepublished_at,
            cc_nrf_color_code_non_plm,
            cc_nrf_color_desc_non_plm,
            cc_set_flag,
            cc_price_exception,
            cc_last_published_by,
            cc_last_published_on,
            cc_s5_stylecolor_status,
            cc_s5_stylecolor_status_msg,
            supp_brand_95,
            cc_vpn_color_desc,
            cc_vpn_color_display,
            cccolorid,
            cc_orin_stylecolor,
            cc_cost,
            cc_buy_period_descr,
            cc_vpn_buy_period,
            cc_floorset,
            cc_use_sys_floorset,
            cc_num_clones_s5,
            cc_num_times_cloned_s5
        )
        SELECT
            to_id,
            cc_initial_launch_month,
            a.cccolor || ' ',
            cc_diff_type,
            cc_color_desc,
            cc_colorfamily_code,
            a.cccolorfamily,
            null as cc_merch_color_name,
            null as cc_vpn,
            null as cc_vpn_color,
            null as cc_first_rec_week,
            null as cc_first_inv_week,
            null as cc_first_sale_week,
            null as cc_first_md_week,
            null as cc_last_md_week,
            cc_msrp,
            cc_current_retail,
            null as ccstylecolorcreatedate,
            cc_dropship_indicator,
            cc_replenishemnt_indicator,
            cc_selling_season,
            cc_selling_year,
            cc_segment_buy,
            cc_silhouette,
            cc_subcategory,
            cc_program_name,
            cc_print_vs_solid,
            cc_sleeve_length,
            cc_fashion_vs_basic,
            cc_top_length,
            cc_denim_rise,
            cc_bottom_fit,
            cc_dress_length,
            cc_neckline,
            cc_inseam,
            cc_lounge_vs_sleep,
            cc_bottom_silo,
            cc_robe,
            cc_print_type,
            cc_fit_solution,
            cc_d_cup_available,
            cc_occasion,
            cc_categories,
            cc_cut_fit,
            cc_construction,
            cc_bridal_registry,
            cc_levi_fits,
            cc_graphic_type,
            cc_classification,
            cc_young_contemporary,
            cc_short_inseam,
            cc_denim_trends,
            cc_collegiate,
            cc_set,
            cc_material,
            cc_configuration,
            cc_bedding_accessories,
            cc_fabric_description,
            cc_black_friday_ind,
            cc_superbuy_ind,
            cc_aa_ind,
            cc_coastal_ind,
            cc_lodge_ind,
            cc_white_dinnerware_ind,
            cc_customer_need,
            cc_fashion_jewelry,
            cc_material_color,
            cc_material_type,
            cc_jewelry_presentation,
            cc_necklaces,
            cc_texture_pattern,
            cc_high_value_status,
            cc_fine_jewelry_metal,
            cc_stone,
            cc_bridal,
            cc_metal_type,
            cc_chain_type,
            cc_bracelets,
            cc_ears,
            cc_ring,
            cc_dial_color,
            cc_watch,
            cc_dtw_fine_jewelry,
            cc_gold_mkt_fine_jewelry,
            cc_grams_fine_jewelry,
            cc_silver_mkt_fine_jewelry,
            cc_silver_grams,
            cc_ctw_fine_jewelry,
            cc_shoe_type,
            cc_shaft_height,
            cc_outsole,
            cc_closure,
            cc_toe_type,
            cc_sole_type,
            cc_toe_character,
            cc_heel_type,
            cc_heel_height,
            cc_fabric_type,
            cc_width,
            cc_tech_features,
            cc_skechers_division,
            cc_level_of_presentation,
            cc_fragrance_scents,
            cc_total_makeup,
            cc_makeup_total_face,
            cc_total_fragrance,
            cc_makeup_total_lip,
            cc_total_skincare,
            cc_makeup_total_eye,
            cc_skincare_total_face,
            cc_styclr_status,
            cc_skulist_id,
            cc_skulist_desc,
            total_brand_name,
            division_name,
            group_name,
            department_name,
            class_name,
            subclass_name,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            isassortment,
            null as merch_comments,
            null as plan_comments,
            null as cc_is_locked,
            null as cc_s5_adopted,
            null as cc_prepublish,
            null as cc_prepublished_at,
            null as cc_nrf_color_code_non_plm,
            null as cc_nrf_color_desc_non_plm,
            null as cc_set_flag,
            null as cc_price_exception,
            null as cc_last_published_by,
            null as cc_last_published_on,
            null as cc_s5_stylecolor_status,
            null as cc_s5_stylecolor_status_msg,
            null as supp_brand_95,
            null as cc_vpn_color_desc,
            null as cc_vpn_color_display,
            b.cccolorid || ' ',
            null as cc_orin_stylecolor,
            cc_cost,
            null as cc_buy_period_descr,
            null as cc_vpn_buy_period,
            cc_floorset,
            null as cc_use_sys_floorset,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_sizeattributes (
            product,
            parent_id,
            size_member_id,
            sizeattribute,
            source_member_id,
            source_member_name,
            sku_dropship_indicator,
            sku_replenishment_flag,
            sku_extended_size,
            sku_status,
            isvalid,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state
        )
        SELECT
            to_new_stylecolorsize,
            to_new_stylecolor,
            size_member_id,
            sizeattribute,
            source_member_id,
            source_member_name,
            sku_dropship_indicator,
            sku_replenishment_flag,
            sku_extended_size,
            sku_status,
            isvalid,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_stylecolor_size a,
             blk_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_stylecolorchannelattributes (         
            product,
            location,
            dbt_wk,
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
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            slsrnk,
            ccticketpricechannel,
            ccticketpricechannel_override,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            ccmdstrategy,
            cc_presmin_weeks,
            cc_presmin,
            cc_ordpolicy,
            cc_rcptint,
            cc_ordermultiple,
            cc_discount_pct,
            cc_imupct,
            cc_existingwac,
            cc_systemcost,
            ssnprf,
            adjaps,
            relaunchweek,
            cc_plan_cost,
            cc_landed_cost,
            cc_target_cost,
            cc_flrset,
            cc_season,
            inseason_adjaps,
            smoothing_strategy,
            in_season_flag,
            lifecycle_applied,
            cc_return_u_pct,
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
            cc_cluster_group_or,
            cc_selected_clusters_or,
            relaunch_dbt_wk,
            relaunch_dbt_wk_indx,
            relaunch_erlstmkdnwk,
            relaunch_erlstmkdnwk_indx,
            relaunch_exitdate,
            relaunch_exitdate_indx,
            relaunch_initrcptwk,
            relaunch_initrcptwk_indx,
            relaunch_too,
            relaunch_mkdnwks,
            relaunch_last_rcpt_wk,
            relaunch_last_rcpt_wk_indx,
            relaunch_planned_sell_down_week,
            relaunch_planned_sell_down_week_indx,
            relaunch_cc_cluster_group,
            relaunch_is_valid,
            cloned_at
        )
        SELECT
            to_id,
            location,
            dbt_wk,
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
            mdstart_indx,
            lastdcorder_indx,
            exitdate_indx,
            slsrnk,
            ccticketpricechannel,
            ccticketpricechannel_override,
            validsizes,
            cc_validsizes_store,
            cc_validsizes_ecom,
            ccrangecode,
            ccmdstrategy,
            cc_presmin_weeks,
            cc_presmin,
            cc_ordpolicy,
            cc_rcptint,
            cc_ordermultiple,
            cc_discount_pct,
            cc_imupct,
            cc_existingwac,
            cc_systemcost,
            ssnprf,
            adjaps,
            null as relaunchweek,
            cc_plan_cost,
            cc_landed_cost,
            cc_target_cost,
            cc_flrset,
            cc_season,
            inseason_adjaps,
            smoothing_strategy,
            in_season_flag,
            lifecycle_applied,
            cc_return_u_pct,
            auto_rollforward,
            irr_mode,
            plan_current,
            lock_agg_edit,
            cc_lead_time,
            cc_service_level,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            1 as record_state,
            cc_store_min_multiple,
            planned_sell_down_week,
            cc_selected_clusters,
            cc_cluster_group,
            cc_cluster_group_or,
            cc_selected_clusters_or,
            null as relaunch_dbt_wk,
            null as relaunch_dbt_wk_indx,
            null as relaunch_erlstmkdnwk,
            null as relaunch_erlstmkdnwk_indx,
            null as relaunch_exitdate,
            null as relaunch_exitdate_indx,
            null as relaunch_initrcptwk,
            null as relaunch_initrcptwk_indx,
            null as relaunch_too,
            null as relaunch_mkdnwks,
            null as relaunch_last_rcpt_wk,
            null as relaunch_last_rcpt_wk_indx,
            null as relaunch_planned_sell_down_week,
            null as relaunch_planned_sell_down_week_indx,
            null as relaunch_cc_cluster_group,
            null as relaunch_is_valid,
            date_trunc('sec'::text, CURRENT_TIMESTAMP) as cloned_at
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
        INSERT INTO blk_ma_imgattributes (
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state
        FROM blk_style_clone_flat_map_temp a,
             blk_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_itemprice (
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
            excl_discount_pct
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            excl_discount_pct
        FROM blk_style_clone_flat_map_temp a,
             blk_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_channeloverride (
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
            floorsetpo
        )
        SELECT
            to_id,
            location,
            time,
            weekadjaps,
            weekadjaps_ecom,
            weekadjslsu,
            weekadjslsu_ecom,
            null as comments,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            testpo,
            floorsetpo
        FROM blk_style_clone_flat_map_temp a,
             blk_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
        INSERT INTO blk_a_assortment (
            product,
            location,
            time,
            style,
            str_grade,
            str_segmentation,
            str_sub_segmentation,
            str_aa_ind,
            str_hisp_ind,
            str_lifestyle_01,
            str_lifestyle_02,
            str_lifestyle_03,
            str_lifestyle_04,
            str_climate,
            str_state,
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
            a_msrp,
            a_current_retail,
            a_current_retail_override,
            str_grade_or,
            str_segmentation_or,
            str_sub_segmentation_or,
            str_aa_ind_or,
            str_hisp_ind_or,
            str_lifestyle_01_or,
            str_lifestyle_02_or,
            str_lifestyle_03_or,
            str_lifestyle_04_or,
            str_climate_or,
            str_state_or
        )
        SELECT
            to_id,
            location,
            time,
            style,
            str_grade,
            str_segmentation,
            str_sub_segmentation,
            str_aa_ind,
            str_hisp_ind,
            str_lifestyle_01,
            str_lifestyle_02,
            str_lifestyle_03,
            str_lifestyle_04,
            str_climate,
            str_state,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            a_msrp,
            a_current_retail,
            a_current_retail_override,
            str_grade_or,
            str_segmentation_or,
            str_sub_segmentation_or,
            str_aa_ind_or,
            str_hisp_ind_or,
            str_lifestyle_01_or,
            str_lifestyle_02_or,
            str_lifestyle_03_or,
            str_lifestyle_04_or,
            str_climate_or,
            str_state_or
        FROM blk_style_clone_flat_map_temp a,
             blk_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
         INSERT INTO blk_p_dc_adj (
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
            last_prepublished_ecom
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,--SUP-4034
            is_locked, --test this
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
            null as published_at,
            null as is_prepublished,
            null as prepublished_at,
            null as last_prepublished,
            null as po_arr,
            now()::date,
            version_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,--SUP-4034
            po_indicator_ecom,
            po_shipmode_ecom,
            air_trigger_ecom,
            cut_ecom,
            null as published_at_ecom,
            null as is_prepublished_ecom,
            null as prepublished_at_ecom,
            null as last_prepublished_ecom
        FROM blk_style_clone_flat_map_temp a,
             blk_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;

    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
        INSERT INTO blk_p_dc_adj_size (
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
            dc_last_pub_ecom
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
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            date_trunc('sec'::text, CURRENT_TIMESTAMP),
            v_pivot_user_id,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom
        FROM blk_style_clone_stylecolor_size a,
             blk_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO blk_an_price_storecount_info (
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
        FROM blk_style_clone_flat_map_temp a,
             blk_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;

    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO blk_l_dependencylookup (
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
        FROM blk_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';


        INSERT INTO blk_l_dependencylookup (
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
        FROM blk_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';

-- DROP THE TEMPORARY TABLE
DROP TABLE IF EXISTS blk_style_clone_flat_map_temp;

END;
$$;


ALTER PROCEDURE public.blk_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2126 (class 1255 OID 129294775)
-- Name: blk_style_clone_stylecolor_size_proc_dummy(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.blk_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text)
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


ALTER PROCEDURE public.blk_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2127 (class 1255 OID 129294776)
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
      (select slsstart from blk_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strclimate)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','),
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM blk_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 2128 (class 1255 OID 129294777)
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
  scPrePub_pub INT;
 BEGIN
  scWeekCount_pub = (select COUNT(*) from blk_p_dc_adj
   where product = stylecolorId
   and location = (select dc from blk_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from blk_eohdata_stylecolor
   where product = stylecolorId
   and channel = channelId
   and (eohu > 0));
  scPrePub_pub = (select COUNT(*) from blk_ma_stylecolorattributes
	where product = stylecolorID
	and (cc_prepublish is true));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh + scPrePub_pub;
  sizeWeekCount = (select COUNT(*) from blk_p_dc_adj_size
   where product in (select id from blk_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from blk_l_dclookup where channel = channelId)
   and (dc_onorder > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 2129 (class 1255 OID 129294778)
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
                 COALESCE(length(btrim("substring"(a.class_name, 1, 1))), 0)
               ) = 1
               AND (a.subclass_name is not null or a.subclass_name <> '')
               AND (d.sty_vpn is not null or d.sty_vpn <> '' or d.sty_vpn_id_non_plm is not null or d.sty_vpn_id_non_plm <> '')
               AND (d.supp_supplier_site_id is not null or d.supp_supplier_site_id <> '')
               AND (a.cccolor is not null or a.cccolor <> '')
               AND (a.cc_merch_color_name is not null or a.cc_merch_color_name <> '')
               AND (d.sty_style_type is not null or d.sty_style_type <> '')
               AND (c.ccticketpricechannel::real is not null and c.ccticketpricechannel > 0)
          THEN '1'::text
          ELSE '0'::text
      END AS isprepublishable
      into v_isprepublishable
  FROM blk_ma_stylecolorattributes a
  JOIN blk_h_prodstd b ON a.product = b.id
  JOIN blk_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, validsizes, ccticketpricechannel
                   from blk_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  where a.product = stylecolorid
  ;

  return v_isprepublishable;
 END;
$$;


ALTER FUNCTION public.check_isprepublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 2130 (class 1255 OID 129294779)
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
                 COALESCE(length(btrim("substring"(a.class_name, 1, 1))), 0)
               ) = 1 
               AND (a.subclass_name is not null or a.subclass_name <> '')
               AND (a.ccstylecolorcreatedate is not null or a.ccstylecolorcreatedate <> '')      
               AND ((d.sty_style_type = 'PLM' and e.hq_id is not null) OR (d.sty_style_type = 'NON-PLM'))
               AND a.cc_styclr_status = '0'
               AND d.sty_style_status = '0'
               AND d.supp_status = '0'
          THEN '1'::text
          ELSE '0'::text
      END AS ispublishable
      into v_ispublishable
  FROM blk_ma_stylecolorattributes a
  JOIN blk_h_prodstd b ON a.product = b.id
  JOIN blk_ma_styleattributes d ON d.product = b.ancestor0
  LEFT OUTER JOIN (select distinct product, validsizes
                   from blk_ma_stylecolorchannelattributes
                  ) c ON a.product = c.product
  LEFT OUTER JOIN (SELECT DISTINCT product, hq_id
                   from blk_ma_stylecolorweekattributes) e on a.product = e.product
  where a.product = stylecolorid
  and a.product in (select distinct parent_id from blk_ma_sizeattributes)
  ;


  return v_ispublishable;
 END;
$$;


ALTER FUNCTION public.check_ispublishable(stylecolorid text) OWNER TO psql;

--
-- TOC entry 2183 (class 1255 OID 129294780)
-- Name: commit_upload_ata(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.commit_upload_ata(v__uid text, v__txid text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;
v__txid text;
stylecolor_ret refcursor;
input_uid text;
input_txid text;

v_default_initrcptwk text;
v_default_dbt_wk text;
v_default_too integer;
v_default_mkdnwks integer;
v_default_last_rcpt_wk text;
v_default_erlstmkdnwk text;
v_default_exitdate text;
v_default_preseason_sales_rating real;

v_default_initrcptwk_indx integer;
v_default_dbt_wk_indx integer;
v_default_erlstmkdnwk_indx integer;
v_default_exitdate_indx integer;
v_default_last_rcpt_wk_indx integer;

v__timestamp timestamp without time zone;


BEGIN 

/*
Tables where data is being inserted
  blk_d_product
  blk_h_prodstd
  blk_ma_styleattributes
  blk_ma_stylecolorattributes
  blk_ma_stylecolorchannelattributes
  blk_a_assortment
Prepare temp tables to be used for final insert
Insert data into above tables
insert data into below archive tables
  arc_bulkupload_d_product
  arc_bulkupload_h_prodstd
  arc_bulkupload_ma_styleattributes
  arc_bulkupload_ma_stylecolorattributes
  arc_bulkupload_ma_stylecolorchannelattributes
  arc_bulkupload_a_assortment
  arc_bulkupload_ma_sizeattributes
*/


select $1 into input_uid;
select $2 into input_txid;

insert into archives_addtoassortment
select a.*
from staging_addtoassortment a
where __txid=input_txid
;

select max(__timestamp) into v__timestamp from staging_addtoassortment where __txid=input_txid and __uid = input_uid;

-- ---------------------------------
-- =================================
-- Create temp tables
-- =================================
-- ---------------------------------

-- ===========
-- d_product
-- ===========

RAISE NOTICE 'Start temp_upload_ata_d_product:%', 'START:'|| now();
-- style
create temporary table temp_upload_ata_d_product on commit drop
AS 
select distinct
  coalesce(b.id, uuid_generate_v4()::text) as id,
  style_id as name,
  style_description as description,
  'style' as levelid
from (select distinct style_id, style_description from shadow_addtoassortment where __txid=input_txid and __uid = input_uid) a
left outer join blk_d_product b on a.style_id = b.name
;

--stylecolor
insert into temp_upload_ata_d_product
select distinct
  uuid_generate_v4()::text as id,
  style_id || '.' || color_id as name,
  style_description || ' ' || attributevalue as description,
  'stylecolor' as levelid
from (select distinct style_id, color_id, style_description from shadow_addtoassortment where __txid=input_txid and __uid = input_uid) a
join (select * from blk_v_memberbasedvalidvalues where attributeid = 'cccolorid') b on a.color_id = b.attributekey
;


--Needs to be figured out
insert into temp_upload_ata_d_product
select
  uuid_generate_v4()::text as id,
  'NA' as name,
  style_id || '.' || color_id || ' ' || 'NA' as description,
  'stylecolorsize' as levelid
from (select distinct style_id, color_id, style_description from shadow_addtoassortment where __txid=input_txid and __uid = input_uid) a
;

RAISE NOTICE 'Start temp_upload_ata_h_prodstd:%', 'START:'|| now();

-- ===========
-- h_prodstd
-- ===========
create temporary table temp_upload_ata_h_prodstd on commit drop
AS
SELECT DISTINCT
                  c.id as id
                , b.id as ancestor0
                , ancestor0 as ancestor1
                , ancestor1 as ancestor2
                , ancestor2 as ancestor3
                , ancestor3 as ancestor4
                , ancestor4 as ancestor5
                , ancestor5 as ancestor6
FROM shadow_addtoassortment a
join blk_h_prodstd b on 'SL-' || a.class = b.id
join temp_upload_ata_d_product c on a.style_id = c.name
where c.levelid = 'style'
and __txid=input_txid and __uid = input_uid
;

INSERT INTO temp_upload_ata_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
SELECT DISTINCT
                  c.id
                , d.id
                , b.id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
FROM shadow_addtoassortment a
join blk_h_prodstd b on 'SL-' || a.class = b.id
join temp_upload_ata_d_product c on a.style_id || '.' || a.color_id = c.name
join temp_upload_ata_d_product d on a.style_id = d.name
where c.levelid = 'stylecolor' and d.levelid = 'style'
and __txid=input_txid and __uid = input_uid
;


-- Need to figure out
INSERT INTO temp_upload_ata_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
SELECT DISTINCT
                  c.id
                , d.id
                , e.id
                , b.id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
FROM shadow_addtoassortment a
join blk_h_prodstd b on 'SL-' || a.class = b.id
join temp_upload_ata_d_product c on a.style_id || '.' || a.color_id = substr(c.description, 1, position(' ' in c.description) - 1)
join temp_upload_ata_d_product d on a.style_id || '.' || a.color_id = d.name
join temp_upload_ata_d_product e on a.style_id = e.name
where c.levelid = 'stylecolorsize' and d.levelid = 'stylecolor' and e.levelid = 'style'
and __txid=input_txid and __uid = input_uid
;


-- ==================
-- ma_styleattributes
-- ==================
RAISE NOTICE 'Start temp_upload_ata_ma_styleattributes:%', 'START:'|| now();
create temporary table temp_upload_ata_ma_styleattributes on commit drop
AS
SELECT distinct x.id as product
            ,null as sty_vpn
            ,null as sty_supplier_number
            ,null as sty_supplier_name
            ,'NONE' as sty_size_range
            ,style_type as sty_style_type
            ,null as ccstylecreatedate  --Inherting ccstylecreatedate from similar style will restrict the user from editing the style id and desc; so we set it to null until it is created in client host system
            ,null as sty_style_status
            ,supplier_site_id as supp_supplier_site_id
            ,null as supp_supplier_name
            ,null as supp_parent_supplier_id
            ,null as supp_parent_supplier_name
            ,null as supp_status
            ,null as supp_class_group
            ,null as supp_brand_mindset
            ,null as supp_brand_type
            ,null as supp_brand
            ,null as supp_priceband
            ,null as supp_bi_flg
            ,null as supp_grp_parent_id
            ,null as supp_grp_standard_id
            ,null as supp_grp_brand_id
            ,null as supp_ninebox
            ,null as supp_lifestyle
            ,null as supp_direct_ship_ind
            ,null as class_group_id
            ,null as class_group_name
            ,y.dpt_department_id
            ,y.dpt_gmm_id
            ,y.dpt_gmm_desc
            ,y.dpt_dmm_id
            ,y.dpt_dmm_desc
            ,y.dpt_buyer_id
            ,y.dpt_buyer_desc
            ,y.dpt_sr_planner_id
            ,y.dpt_sr_planner_desc
            ,y.dpt_planner_id
            ,y.dpt_planner_desc
            ,y.dpt_dir_id
            ,y.dpt_dir_desc
            ,y.dpt_vp_id
            ,y.dpt_vp_desc
            ,y.dpt_svp_id
            ,y.dpt_svp_desc
            ,y.dpt_evp_id
            ,y.dpt_evp_desc
            ,y.dpt_marketplace_indicator
            ,y.dpt_memo_dept_indicator
            ,y.dpt_royalty_pct
            ,'Y' as sty_s5_adopted
            ,case when style_type = 'NON-PLM' then vpn_id_non_plm else null end as sty_vpn_id_non_plm
            ,case when style_type = 'NON-PLM' then vpn_id_non_plm else null end as sty_vpn_final
from (select distinct style_id, style_type, department, class, b.id, supplier_site_id, vpn_id_non_plm
      from shadow_addtoassortment a, temp_upload_ata_d_product b
      where a.style_id = b.name and levelid = 'style'
      and __txid=input_txid and __uid = input_uid
     ) x, 
blk_departmentattributes y
where 'DP-' || x.department = y.department
and not exists (select 1 from blk_d_product a where x.id = a.id)
;


RAISE NOTICE 'Start temp_upload_ata_ma_styleattributes:%', 'UPDATE:'|| now();
  update temp_upload_ata_ma_styleattributes a set supp_bi_flg = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_bi_flg';
  update temp_upload_ata_ma_styleattributes a set supp_brand = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_brand';
  update temp_upload_ata_ma_styleattributes a set supp_brand_mindset = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_brand_mindset';
  update temp_upload_ata_ma_styleattributes a set supp_brand_type = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_brand_type';
  update temp_upload_ata_ma_styleattributes a set supp_class_group = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_class_group';
  update temp_upload_ata_ma_styleattributes a set supp_direct_ship_ind = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_direct_ship_ind';
  update temp_upload_ata_ma_styleattributes a set supp_grp_brand_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_grp_brand_id';
  update temp_upload_ata_ma_styleattributes a set supp_grp_parent_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_grp_parent_id';
  update temp_upload_ata_ma_styleattributes a set supp_grp_standard_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_grp_standard_id';
  update temp_upload_ata_ma_styleattributes a set supp_lifestyle = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_lifestyle';
  update temp_upload_ata_ma_styleattributes a set supp_ninebox = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_ninebox';
  update temp_upload_ata_ma_styleattributes a set supp_parent_supplier_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_parent_supplier_id';
  update temp_upload_ata_ma_styleattributes a set supp_parent_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_parent_supplier_name';
  update temp_upload_ata_ma_styleattributes a set supp_priceband = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_priceband';
  update temp_upload_ata_ma_styleattributes a set supp_status = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_status';
  update temp_upload_ata_ma_styleattributes a set supp_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_supplier_name';
  update temp_upload_ata_ma_styleattributes a set sty_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = a.supp_supplier_site_id and b.target_id = 'supp_supplier_name';
  update temp_upload_ata_ma_styleattributes a set sty_supplier_number = a.supp_supplier_site_id;


-- =======================
-- ma_stylecolorattributes
-- =======================
RAISE NOTICE 'Start temp_upload_ata_ma_stylecolorattributes:%', 'START:'|| now();
create temporary table temp_upload_ata_ma_stylecolorattributes on commit drop
AS
SELECT distinct b.id as product
        ,null as cc_initial_launch_month
        ,null as cccolor
        ,'C' cc_diff_type
        ,null as cc_color_desc
        ,null as cc_colorfamily_code
        ,null as cccolorfamily
        ,merch_color_name as cc_merch_color_name
        ,null as cc_vpn
        ,null as cc_vpn_color
        ,null as cc_first_rec_week
        ,null as cc_first_inv_week
        ,null as cc_first_sale_week
        ,null as cc_first_md_week
        ,null as cc_last_md_week
        ,original_price::real as cc_msrp
        ,original_price::real as cc_current_retail
        ,null as ccstylecolorcreatedate   --Inherting ccstylecolorcreatedate from similar stylecolor will restrict the user from removing the stylecolor; so we set it to null until it is created in client host system
        ,dropship_indicator as cc_dropship_indicator
        ,replenishment_indicator as cc_replenishemnt_indicator
        ,coalesce(selling_season, 'NONE') as cc_selling_season
        ,coalesce(selling_year, 'NONE') as cc_selling_year
        ,coalesce(segment_buy, 'NONE') as cc_segment_buy
        ,coalesce(silhouette, 'NONE') as cc_silhouette
        ,coalesce(subcategory, 'NONE') as cc_subcategory
        ,coalesce(program_name, 'NONE') as cc_program_name
        ,coalesce(print_vs_solid, 'NONE') as cc_print_vs_solid
        ,coalesce(sleeve_length, 'NONE') as cc_sleeve_length
        ,coalesce(fashion_vs_basic, 'NONE') as cc_fashion_vs_basic
        ,coalesce(top_length, 'NONE') as cc_top_length
        ,coalesce(denim_rise, 'NONE') as cc_denim_rise
        ,coalesce(bottom_fit, 'NONE') as cc_bottom_fit
        ,coalesce(dress_length, 'NONE') as cc_dress_length
        ,coalesce(neckline, 'NONE') as cc_neckline
        ,coalesce(inseam, 'NONE') as cc_inseam
        ,coalesce(lounge_vs_sleep, 'NONE') as cc_lounge_vs_sleep
        ,coalesce(bottom_silo, 'NONE') as cc_bottom_silo
        ,coalesce(robe, 'NONE') as cc_robe
        ,coalesce(print_type, 'NONE') as cc_print_type
        ,coalesce(fit_solution, 'NONE') as cc_fit_solution
        ,coalesce(d_cup_avail, 'NONE') as cc_d_cup_available
        ,coalesce(occasion, 'NONE') as cc_occasion
        ,coalesce(categories, 'NONE') as cc_categories
        ,coalesce(cut_fit, 'NONE') as cc_cut_fit
        ,coalesce(construction, 'NONE') as cc_construction
        ,coalesce(bridal_registry, 'NONE') as cc_bridal_registry
        ,coalesce(levi_fits, 'NONE') as cc_levi_fits
        ,coalesce(graphic_type, 'NONE') as cc_graphic_type
        ,coalesce(classification, 'NONE') as cc_classification
        ,coalesce(young_contemporary, 'NONE') as cc_young_contemporary
        ,coalesce(short_inseam, 'NONE') as cc_short_inseam
        ,coalesce(denim_trends, 'NONE') as cc_denim_trends
        ,coalesce(collegiate, 'NONE') as cc_collegiate
        ,coalesce(cc_set, 'NONE') as cc_set
        ,coalesce(material, 'NONE') as cc_material
        ,coalesce(cc_configuration, 'NONE') as cc_configuration
        ,coalesce(bedding_acc, 'NONE') as cc_bedding_accessories
        ,coalesce(fabric_desc, 'NONE') as cc_fabric_description
        ,'NONE' as cc_black_friday_ind
        ,coalesce(superbuy_ind, 'NONE') as cc_superbuy_ind
        ,coalesce(aa_indicator, 'NONE') as cc_aa_ind
        ,coalesce(coastal_ind, 'NONE') as cc_coastal_ind
        ,'NONE' as cc_lodge_ind
        ,coalesce(white_dinnerware_ind, 'NONE') as cc_white_dinnerware_ind
        ,coalesce(custom_need, 'NONE') as cc_customer_need
        ,coalesce(fashion_jewelry, 'NONE') as cc_fashion_jewelry
        ,coalesce(material_color, 'NONE') as cc_material_color
        ,coalesce(material_type, 'NONE') as cc_material_type
        ,coalesce(jewelry_presentation, 'NONE') as cc_jewelry_presentation
        ,coalesce(necklaces, 'NONE') as cc_necklaces
        ,coalesce(texture_pattern, 'NONE') as cc_texture_pattern
        ,coalesce(high_value_status, 'NONE') as cc_high_value_status
        ,coalesce(fine_jewelry_metal, 'NONE') as cc_fine_jewelry_metal
        ,coalesce(stone, 'NONE') as cc_stone
        ,coalesce(bridal, 'NONE') as cc_bridal
        ,coalesce(metal_type, 'NONE') as cc_metal_type
        ,coalesce(chain_type, 'NONE') as cc_chain_type
        ,coalesce(bracelets, 'NONE') as cc_bracelets
        ,coalesce(ears, 'NONE') as cc_ears
        ,coalesce(ring, 'NONE') as cc_ring
        ,coalesce(dial_color, 'NONE') as cc_dial_color
        ,coalesce(watch, 'NONE') as cc_watch
        ,coalesce(dtw_fine_dewelry, 'NONE') as cc_dtw_fine_jewelry
        ,coalesce(gold_mkt_fine_jewelry, 'NONE') as cc_gold_mkt_fine_jewelry
        ,coalesce(grams_fine_jewelry, 'NONE') as cc_grams_fine_jewelry
        ,coalesce(silver_mkt_fine_jewelry, 'NONE') as cc_silver_mkt_fine_jewelry
        ,coalesce(silver_grams, 'NONE') as cc_silver_grams
        ,coalesce(ctw_fine_jewelry, 'NONE') as cc_ctw_fine_jewelry
        ,coalesce(shoe_type, 'NONE') as cc_shoe_type
        ,coalesce(shaft_height, 'NONE') as cc_shaft_height
        ,coalesce(outsole, 'NONE') as cc_outsole
        ,coalesce(closure, 'NONE') as cc_closure
        ,coalesce(toe_type, 'NONE') as cc_toe_type
        ,coalesce(sole_type, 'NONE') as cc_sole_type
        ,coalesce(toe_character, 'NONE') as cc_toe_character
        ,coalesce(heel_type, 'NONE') as cc_heel_type
        ,coalesce(heel_height, 'NONE') as cc_heel_height
        ,'NONE' as cc_fabric_type
        ,coalesce(width, 'NONE') as cc_width
        ,coalesce(tech_features, 'NONE') as cc_tech_features
        ,coalesce(sketchers_div, 'NONE') as cc_skechers_division
        ,coalesce(level_of_presentation, 'NONE') as cc_level_of_presentation
        ,coalesce(fragrance_scents, 'NONE') as cc_fragrance_scents
        ,coalesce(total_makeup, 'NONE') as cc_total_makeup
        ,coalesce(makeup_total_face, 'NONE') as cc_makeup_total_face
        ,coalesce(total_fragrance, 'NONE') as cc_total_fragrance
        ,coalesce(makeup_total_lip, 'NONE') as cc_makeup_total_lip
        ,coalesce(total_skincare, 'NONE') as cc_total_skincare
        ,coalesce(makeup_total_eye, 'NONE') as cc_makeup_total_eye
        ,coalesce(skincare_total_face, 'NONE') as cc_skincare_total_face
        ,0 as cc_styclr_status
        ,null as cc_skulist_id
        ,null as cc_skulist_desc
        ,null as total_brand_name
        ,null as division_name
        ,null as group_name
        ,null as department_name
        ,null as class_name
        ,null as subclass_name
        ,'Y' as cc_s5_adopted
        ,null as cc_nrf_color_code_non_plm
        ,null as cc_nrf_color_desc_non_plm
        ,'true' as isassortment
        ,color_id as cccolorid
        ,null::real as cc_cost
from shadow_addtoassortment a, temp_upload_ata_d_product b
where a.style_id || '.' || a.color_id = b.name and levelid = 'stylecolor'
and __txid=input_txid and __uid = input_uid
;

RAISE NOTICE 'Start temp_upload_ata_ma_stylecolorattributes:%', 'UPDATE:'|| now();

update temp_upload_ata_ma_stylecolorattributes
set cccolor = attributekey || ' ' || attributevalue
from blk_v_memberbasedvalidvalues 
where attributeid = 'cccolorid' and attributekey = cccolorid
;

update temp_upload_ata_ma_stylecolorattributes a
set total_brand_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor6 = c.id
where a.product = b.id
;


update temp_upload_ata_ma_stylecolorattributes a
set division_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor5 = c.id
where a.product = b.id
;

update temp_upload_ata_ma_stylecolorattributes a
set group_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor4 = c.id
where a.product = b.id
;

update temp_upload_ata_ma_stylecolorattributes a
set department_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor3 = c.id
where a.product = b.id
;

update temp_upload_ata_ma_stylecolorattributes a
set class_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor2 = c.id
where a.product = b.id
;

update temp_upload_ata_ma_stylecolorattributes a
set subclass_name = c.name
from temp_upload_ata_h_prodstd b
join blk_d_product c on b.ancestor1 = c.id
where a.product = b.id
;

-- =======================
-- ma_sizeattributes
-- =======================

RAISE NOTICE 'Start temp_upload_ata_ma_sizeattributes:%', 'START:'|| now();
create temporary table temp_upload_ata_ma_sizeattributes on commit drop
AS
select 
c.id as product,
d.id as parent_id,
c.name as sizeattribute,
0 as sku_status,
1 as isvalid
from shadow_addtoassortment a
join (select * from temp_upload_ata_d_product where levelid = 'stylecolorsize') c on a.style_id || '.' || a.color_id = substr(c.description, 1, position(' ' in c.description) - 1)
join temp_upload_ata_d_product d on a.style_id || '.' || a.color_id = d.name
and __txid=input_txid and __uid = input_uid
;


-- ==============================
-- ma_stylecolorchannelattributes
-- ==============================
RAISE NOTICE 'Start temp_upload_ata_params:%', 'START:'|| now();
create temporary table temp_upload_ata_params on commit drop
AS
select distinct product, time, b.debut_week 
          , b.debut_week as default_initrcptwk
          , b.debut_week as default_dbt_wk
          , md.indx - dbt.indx as default_too
          , exit.indx - md.indx as default_mkdnwks
          , last_inv.id as default_last_inv_wk
          , last_fp.id as default_lstfpwk
          , last_rcpt.id as default_last_rcpt_wk
          , b.markdown_week as default_erlstmkdnwk
          , b.exit_week as default_exitdate
          , default_ccmdstrategy
          , default_presmin
          , default_presmin_weeks
          , default_ccrcptint
          , default_ccordermultiple
          , default_ccordpolicy
          , 3::real as default_slsrnk
          , planned_sell_down_week
		      , default_service_level
          , rank() over(partition by product, slsstart, time order by product, slsstart, time) as rnk
from blk_ma_dptflrsetattributes a,  shadow_addtoassortment b, blk_d_time dbt, blk_d_time md, blk_d_time exit, blk_d_time last_rcpt, blk_d_time last_inv, blk_d_time last_fp
where a.product = 'DP-' || b.department and debut_week between slsstart and slsend
and __txid=input_txid and __uid = input_uid
and b.debut_week = dbt.id and b.markdown_week = md.id and b.exit_week = exit.id and last_rcpt.indx = md.indx - 6 and last_inv.indx = exit.indx - 1 and last_fp.indx = md.indx - 1
;

RAISE NOTICE 'Start temp_upload_ata_ma_stylecolorchannelattributes:%', 'START:'|| now();
create temporary table temp_upload_ata_ma_stylecolorchannelattributes on commit drop
AS
select distinct 
  c.id as product
, 'CP-1' as location
, default_initrcptwk as initrcptwk
, a.debut_week as dbt_wk
, default_too as too
, default_mkdnwks as mkdnwks
, default_last_inv_wk as last_inv_wk
, default_lstfpwk as lstfpwk
, default_last_rcpt_wk as last_rcpt_wk
, markdown_week as erlstmkdnwk
, exit_week as exitdate
, default_ccmdstrategy as ccmdstrategy
, default_ccordpolicy as cc_ordpolicy
, null as ccrangecode
, 'class_default' as ssnprf
, '{NA}'::text[] as validsizes
, '{NA}'::text[] as cc_validsizes_store
, '{NA}'::text[] as cc_validsizes_ecom
, coalesce(pres_min::integer, default_presmin) as cc_presmin
, coalesce(pres_min_weeks::integer, default_presmin_weeks) as cc_presmin_weeks
, coalesce(receipt_interval::integer, default_ccrcptint) as cc_rcptint
, default_ccordermultiple as cc_ordermultiple
, store_min_multiple::integer as cc_store_min_multiple -- SUP-3813: template store_min_multiple feeds Store Multiple, not Order Multiple
, coalesce(round(((original_price::real - target_cost::real) / original_price::real)::numeric, 2),0.0) as cc_imupct
, target_cost::real as cc_existingwac
, target_cost::real as cc_systemcost
, target_cost::real as cc_landed_cost
, coalesce(sales_rating::real, default_slsrnk) as slsrnk
, null as cc_cluster_group
, original_price::real as ccticketpricechannel
, null::real as cc_return_u_pct
, target_cost::real as cc_plan_cost
, target_cost::real as cc_target_cost
, coalesce(service_level::real, default_service_level) as cc_service_level
, v_plan_current as plan_current
, null::real as cc_discount_pct
FROM shadow_addtoassortment a, temp_upload_ata_params b, temp_upload_ata_d_product c,
(select value as v_plan_current from blk_serviceparams where id='plan_current') d
where rnk = 1 and levelid = 'stylecolor'
and 'DP-' || a.department = b.product 
and a.debut_week = b.debut_week
and a.markdown_week = b.default_erlstmkdnwk
and a.exit_week = b.default_exitdate
and a.style_id || '.' || a.color_id = c.name
and __txid=input_txid and __uid = input_uid
;

RAISE NOTICE 'Start temp_upload_ata_ma_stylecolorchannelattributes:%', 'UPDATE:'|| now();
update temp_upload_ata_ma_stylecolorchannelattributes a
set cc_discount_pct = default_discount
from shadow_addtoassortment b, temp_upload_ata_d_product c, default_disc_md d
where __txid=input_txid and __uid = input_uid
and b.style_id || '.' || b.color_id = c.name and c.id = a.product 
and 'DP-' || b.department = d.department and 'CL-' || b.class = d.class and b.supplier_site_id = d.supplier_site_id
;

-- =======================
-- a_assortment
-- =======================
RAISE NOTICE 'Start temp_upload_ata_a_assortment:%', 'START:'|| now();
create temporary table temp_upload_ata_a_assortment on commit drop
AS
SELECT distinct 
    e.id as product
    , 'CP-1' as location
    , time
    , cast(default_str_grade as text[]) as str_grade
    , cast(default_str_segmentation as text[]) as str_segmentation
    , cast(default_str_sub_segmentation as text[]) as str_sub_segmentation
    , cast(default_str_aa_ind as text[]) as str_aa_ind
    , cast(default_str_hisp_ind as text[]) as str_hisp_ind
    , cast(default_str_lifestyle_01 as text[]) as str_lifestyle_01
    , cast(default_str_lifestyle_02 as text[]) as str_lifestyle_02
    , cast(default_str_lifestyle_03 as text[]) as str_lifestyle_03
    , cast(default_str_lifestyle_04 as text[]) as str_lifestyle_04
    , cast(default_str_climate as text[]) as str_climate
    , cast(default_str_state as text[]) as str_state       
    , cast(default_ssg as text[]) as ssg
    , cast(default_flnrange as text[]) as flnrange
    , 'plan' as plan_type
    , 1 as isfunded
    , f.ancestor0 as style
    , get_store_count(debut_week,
                      cast(default_str_climate as text[]),
                      cast(default_str_grade as text[]),
                      cast(default_str_segmentation as text[]),
                      cast(default_str_sub_segmentation as text[]),
                      cast(default_str_aa_ind as text[]),
                      cast(default_str_hisp_ind as text[]),
                      cast(default_str_lifestyle_01 as text[]),
                      cast(default_str_lifestyle_02 as text[]),
                      cast(default_str_lifestyle_03 as text[]),
                      cast(default_str_lifestyle_04 as text[]),
                      cast(default_str_state as text[]),
                      b.product
                     ) as store_count
    , original_price::real as a_msrp
    , original_price::real as a_current_retail
FROM
shadow_addtoassortment a, 
blk_ma_dptflrsetattributes b,
(select value as plan_current from blk_serviceparams where id='plan_current') c,
(select value as plan_end from blk_serviceparams where id='plan_end') d,
temp_upload_ata_d_product e,
temp_upload_ata_h_prodstd f
where 'DP-' || a.department = b.product
and b.slsstart <= least(d.plan_end,a.exit_week) and b.slsend >= greatest(a.debut_week,c.plan_current) 
and a.style_id || '.' || a.color_id = e.name and levelid = 'stylecolor'
and e.id = f.id
and __txid=input_txid and __uid = input_uid
;


-- ---------------------------------
-- =================================
-- insert into app tables
-- =================================
-- ---------------------------------

RAISE NOTICE 'Start blk_d_product:%', 'START:'|| now();
insert into blk_d_product
            (id
             , NAME
             , description
             , levelid)
select * from temp_upload_ata_d_product a where not exists (select 1 from blk_d_product b where a.id = b.id);

RAISE NOTICE 'Start blk_h_prodstd:%', 'START:'|| now();
insert into blk_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6)
select * from temp_upload_ata_h_prodstd a where not exists (select 1 from blk_h_prodstd b where a.id = b.id);

RAISE NOTICE 'Start blk_ma_styleattributes:%', 'START:'|| now();
insert into blk_ma_styleattributes
            (product
            ,sty_vpn
            ,sty_supplier_number
            ,sty_supplier_name
            ,sty_size_range
            ,sty_style_type
            ,ccstylecreatedate
            ,sty_style_status
            ,supp_supplier_site_id
            ,supp_supplier_name
            ,supp_parent_supplier_id
            ,supp_parent_supplier_name
            ,supp_status
            ,supp_class_group
            ,supp_brand_mindset
            ,supp_brand_type
            ,supp_brand
            ,supp_priceband
            ,supp_bi_flg
            ,supp_grp_parent_id
            ,supp_grp_standard_id
            ,supp_grp_brand_id
            ,supp_ninebox
            ,supp_lifestyle
            ,supp_direct_ship_ind
            ,class_group_id
            ,class_group_name
            ,dpt_department_id
            ,dpt_gmm_id
            ,dpt_gmm_desc
            ,dpt_dmm_id
            ,dpt_dmm_desc
            ,dpt_buyer_id
            ,dpt_buyer_desc
            ,dpt_sr_planner_id
            ,dpt_sr_planner_desc
            ,dpt_planner_id
            ,dpt_planner_desc
            ,dpt_dir_id
            ,dpt_dir_desc
            ,dpt_vp_id
            ,dpt_vp_desc
            ,dpt_svp_id
            ,dpt_svp_desc
            ,dpt_evp_id
            ,dpt_evp_desc
            ,dpt_marketplace_indicator
            ,dpt_memo_dept_indicator
            ,dpt_royalty_pct
            ,sty_s5_adopted
            ,sty_vpn_id_non_plm
            ,sty_vpn_final
            )
select * from temp_upload_ata_ma_styleattributes;

RAISE NOTICE 'Start blk_ma_stylecolorattributes:%', 'START:'|| now();
INSERT INTO blk_ma_stylecolorattributes
        (product
        ,cc_initial_launch_month
        ,cccolor
        ,cc_diff_type
        ,cc_color_desc
        ,cc_colorfamily_code
        ,cccolorfamily
        ,cc_merch_color_name
        ,cc_vpn
        ,cc_vpn_color
        ,cc_first_rec_week
        ,cc_first_inv_week
        ,cc_first_sale_week
        ,cc_first_md_week
        ,cc_last_md_week
        ,cc_msrp
        ,cc_current_retail
        ,ccstylecolorcreatedate
        ,cc_dropship_indicator
        ,cc_replenishemnt_indicator
        ,cc_selling_season
        ,cc_selling_year
        ,cc_segment_buy
        ,cc_silhouette
        ,cc_subcategory
        ,cc_program_name
        ,cc_print_vs_solid
        ,cc_sleeve_length
        ,cc_fashion_vs_basic
        ,cc_top_length
        ,cc_denim_rise
        ,cc_bottom_fit
        ,cc_dress_length
        ,cc_neckline
        ,cc_inseam
        ,cc_lounge_vs_sleep
        ,cc_bottom_silo
        ,cc_robe
        ,cc_print_type
        ,cc_fit_solution
        ,cc_d_cup_available
        ,cc_occasion
        ,cc_categories
        ,cc_cut_fit
        ,cc_construction
        ,cc_bridal_registry
        ,cc_levi_fits
        ,cc_graphic_type
        ,cc_classification
        ,cc_young_contemporary
        ,cc_short_inseam
        ,cc_denim_trends
        ,cc_collegiate
        ,cc_set
        ,cc_material
        ,cc_configuration
        ,cc_bedding_accessories
        ,cc_fabric_description
        ,cc_black_friday_ind
        ,cc_superbuy_ind
        ,cc_aa_ind
        ,cc_coastal_ind
        ,cc_lodge_ind
        ,cc_white_dinnerware_ind
        ,cc_customer_need
        ,cc_fashion_jewelry
        ,cc_material_color
        ,cc_material_type
        ,cc_jewelry_presentation
        ,cc_necklaces
        ,cc_texture_pattern
        ,cc_high_value_status
        ,cc_fine_jewelry_metal
        ,cc_stone
        ,cc_bridal
        ,cc_metal_type
        ,cc_chain_type
        ,cc_bracelets
        ,cc_ears
        ,cc_ring
        ,cc_dial_color
        ,cc_watch
        ,cc_dtw_fine_jewelry
        ,cc_gold_mkt_fine_jewelry
        ,cc_grams_fine_jewelry
        ,cc_silver_mkt_fine_jewelry
        ,cc_silver_grams
        ,cc_ctw_fine_jewelry
        ,cc_shoe_type
        ,cc_shaft_height
        ,cc_outsole
        ,cc_closure
        ,cc_toe_type
        ,cc_sole_type
        ,cc_toe_character
        ,cc_heel_type
        ,cc_heel_height
        ,cc_fabric_type
        ,cc_width
        ,cc_tech_features
        ,cc_skechers_division
        ,cc_level_of_presentation
        ,cc_fragrance_scents
        ,cc_total_makeup
        ,cc_makeup_total_face
        ,cc_total_fragrance
        ,cc_makeup_total_lip
        ,cc_total_skincare
        ,cc_makeup_total_eye
        ,cc_skincare_total_face
        ,cc_styclr_status
        ,cc_skulist_id
        ,cc_skulist_desc
        ,total_brand_name
        ,division_name
        ,group_name
        ,department_name
        ,class_name
        ,subclass_name
        ,cc_s5_adopted
        ,cc_nrf_color_code_non_plm
        ,cc_nrf_color_desc_non_plm
        ,isassortment
        ,cccolorid
        ,cc_cost
        )
select * from temp_upload_ata_ma_stylecolorattributes;

RAISE NOTICE 'Start blk_ma_sizeattributes:%', 'START:'|| now();
insert into blk_ma_sizeattributes(
  product,
  parent_id,
  sizeattribute,
  sku_status,
  isvalid
)
select * from temp_upload_ata_ma_sizeattributes;

RAISE NOTICE 'Start blk_ma_stylecolorchannelattributes:%', 'START:'|| now();
INSERT  into blk_ma_stylecolorchannelattributes (
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
, cc_ordpolicy
, ccrangecode
, ssnprf
, validsizes
, cc_validsizes_store
, cc_validsizes_ecom
, cc_presmin
, cc_presmin_weeks
, cc_rcptint
, cc_ordermultiple
, cc_store_min_multiple
, cc_imupct
, cc_existingwac
, cc_systemcost
, cc_landed_cost
, slsrnk, cc_cluster_group
, ccticketpricechannel
, cc_return_u_pct
, cc_plan_cost
, cc_target_cost
, cc_service_level
, plan_current
, cc_discount_pct
)
select * from temp_upload_ata_ma_stylecolorchannelattributes;

RAISE NOTICE 'Start blk_a_assortment:%', 'START:'|| now();
insert into blk_a_assortment (
      product
    , location
    , "time"
    , str_grade
    , str_segmentation
    , str_sub_segmentation
    , str_aa_ind
    , str_hisp_ind
    , str_lifestyle_01
    , str_lifestyle_02
    , str_lifestyle_03
    , str_lifestyle_04
    , str_climate
    , str_state
    , ssg
    , flnrange
    , plan_type
    , isfunded
    , style
    , store_count
    , a_msrp
    , a_current_retail)
select * from temp_upload_ata_a_assortment;

RAISE NOTICE 'Start blk_ma_stylecolorattributes:%', 'UPDATE:'|| now();
update blk_ma_stylecolorattributes a
set
  cc_initial_launch_month = floorset
from (select min(time) as floorset from temp_upload_ata_a_assortment) b
where a.product in (select distinct product from temp_upload_ata_ma_stylecolorchannelattributes)
;

insert into blk_ma_imgattributes (product)
select distinct product from temp_upload_ata_ma_stylecolorchannelattributes;

-- ---------------------------------
-- =================================
-- insert into archive tables
-- =================================
-- ---------------------------------

INSERT INTO arc_bulkupload_d_product
            (id
             , NAME
             , description
             , levelid
             , __txid
             , __uid
             , __timestamp
            )
select *, input_txid, input_uid, v__timestamp from temp_upload_ata_d_product
;

INSERT INTO arc_bulkupload_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5
             , ancestor6
             , __txid
             , __uid
             , __timestamp
            )
select *, input_txid, input_uid, v__timestamp from temp_upload_ata_h_prodstd;

INSERT INTO arc_bulkupload_ma_styleattributes
select a.*, input_txid, input_uid, v__timestamp 
from blk_ma_styleattributes a, temp_upload_ata_ma_styleattributes b
where a.product = b.product;

INSERT INTO arc_bulkupload_ma_stylecolorattributes
select a.*, input_txid, input_uid, v__timestamp 
from blk_ma_stylecolorattributes a, temp_upload_ata_ma_stylecolorattributes b
where a.product = b.product
;

INSERT into arc_bulkupload_ma_stylecolorchannelattributes
select a.*, input_txid, input_uid, v__timestamp 
from blk_ma_stylecolorchannelattributes a, temp_upload_ata_ma_stylecolorchannelattributes b
where a.product = b.product
;

INSERT INTO arc_bulkupload_a_assortment
select a.*, input_txid, input_uid, v__timestamp  
from blk_a_assortment a, temp_upload_ata_a_assortment b
where a.product = b.product
;



-- ---------------------------------
-- =================================
-- Upload Statistics
-- =================================
-- ---------------------------------
RAISE NOTICE 'Start upload_statistics:%', 'UPDATE:'|| now();
update upload_statistics 
set final_status = 'Upload Committed'
where (__txid, __timestamp) in (select __txid, max(__timestamp) from staging_addtoassortment where __txid=input_txid group by __txid)
;

delete from shadow_addtoassortment where __txid in (select __txid from upload_statistics where final_status = 'Upload Committed')
;

RAISE NOTICE 'COMMIT SUCCESSFUL ';

OPEN stylecolor_ret FOR
SELECT product
FROM temp_upload_ata_ma_stylecolorchannelattributes
;

-- select commit_upload ('test','5c09ce01-7093-4600-8ce8-fce9f6e64d7e');
RETURN stylecolor_ret;
END;
$_$;


ALTER FUNCTION public.commit_upload_ata(v__uid text, v__txid text) OWNER TO psql;

--
-- TOC entry 2186 (class 1255 OID 135479036)
-- Name: create_new_styles(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.create_new_styles(IN p_pivot_user_id text, IN p_style_stylecolor_list text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    CREATE TEMPORARY TABLE cns_split_list ON COMMIT DROP
    AS 
    SELECT a.*
    FROM (
        SELECT 
            split_part(style_stylecolor, '<<>>', 1) AS style_name,
            split_part(style_stylecolor, '<<>>', 2) AS stylecolor,
            style_stylecolor
        FROM UNNEST(string_to_array(p_style_stylecolor_list, ',')) AS t(style_stylecolor)
    ) a
    LEFT JOIN
        blk_d_product dp
    ON dp.name = style_name
    WHERE dp.name IS NULL
    ;

    CREATE TEMPORARY TABLE cns_new_styles ON COMMIT DROP AS
    SELECT
        gen_random_uuid()::text as style_id
        , style_name
        , stylecolor
        , hp.ancestor0 as ref_style
        , style_stylecolor
    FROM cns_split_list sp
    INNER JOIN blk_h_prodstd hp
        on hp.id = sp.stylecolor
    LEFT JOIN blk_d_product dp
        on dp.id = style_name
    where dp.id IS NULL;

    INSERT INTO blk_ma_styleattributes (
        product
        , sty_vpn
        , sty_supplier_number
        , sty_supplier_name
        , sty_size_range
        , sty_style_type
        , ccstylecreatedate
        , sty_style_status
        , supp_supplier_site_id
        , supp_supplier_name
        , supp_parent_supplier_id
        , supp_parent_supplier_name
        , supp_status
        , supp_class_group
        , supp_brand_mindset
        , supp_brand_type
        , supp_brand
        , supp_priceband
        , supp_bi_flg
        , supp_grp_parent_id
        , supp_grp_standard_id
        , supp_grp_brand_id
        , supp_ninebox
        , supp_lifestyle
        , supp_direct_ship_ind
        , class_group_id
        , class_group_name
        , dpt_department_id
        , dpt_gmm_id
        , dpt_gmm_desc
        , dpt_dmm_id
        , dpt_dmm_desc
        , dpt_buyer_id
        , dpt_buyer_desc
        , dpt_sr_planner_id
        , dpt_sr_planner_desc
        , dpt_planner_id
        , dpt_planner_desc
        , dpt_dir_id
        , dpt_dir_desc
        , dpt_vp_id
        , dpt_vp_desc
        , dpt_svp_id
        , dpt_svp_desc
        , dpt_evp_id
        , dpt_evp_desc
        , dpt_marketplace_indicator
        , dpt_memo_dept_indicator
        , dpt_royalty_pct
        , sty_is_locked
        , sty_s5_adopted
        , sty_vpn_id_non_plm
        , sty_vpn_final
        , sty_orin_style
        , sty_style_name
        , sty_style_description
        , sty_buy_period_descr
        , sty_dpt_buy_period
        , sty_vpn_buy_period
        , sty_num_clones_s5
        , sty_num_times_cloned_s5
    )
    SELECT 
        style_id as product
        , sty_vpn
        , sty_supplier_number
        , sty_supplier_name
        , sty_size_range
        , sty_style_type
        , ccstylecreatedate
        , sty_style_status
        , supp_supplier_site_id
        , supp_supplier_name
        , supp_parent_supplier_id
        , supp_parent_supplier_name
        , supp_status
        , supp_class_group
        , supp_brand_mindset
        , supp_brand_type
        , supp_brand
        , supp_priceband
        , supp_bi_flg
        , supp_grp_parent_id
        , supp_grp_standard_id
        , supp_grp_brand_id
        , supp_ninebox
        , supp_lifestyle
        , supp_direct_ship_ind
        , class_group_id
        , class_group_name
        , dpt_department_id
        , dpt_gmm_id
        , dpt_gmm_desc
        , dpt_dmm_id
        , dpt_dmm_desc
        , dpt_buyer_id
        , dpt_buyer_desc
        , dpt_sr_planner_id
        , dpt_sr_planner_desc
        , dpt_planner_id
        , dpt_planner_desc
        , dpt_dir_id
        , dpt_dir_desc
        , dpt_vp_id
        , dpt_vp_desc
        , dpt_svp_id
        , dpt_svp_desc
        , dpt_evp_id
        , dpt_evp_desc
        , dpt_marketplace_indicator
        , dpt_memo_dept_indicator
        , dpt_royalty_pct
        , sty_is_locked
        , sty_s5_adopted
        , sty_vpn_id_non_plm
        , sty_vpn_final
        , sty_orin_style
        , sty_style_name
        , sty_style_description
        , sty_buy_period_descr
        , sty_dpt_buy_period
        , sty_vpn_buy_period
        , sty_num_clones_s5
        , sty_num_times_cloned_s5
    FROM blk_ma_styleattributes sa
    INNER JOIN cns_new_styles ns
    ON ns.ref_style = sa.product;

    INSERT INTO blk_d_product (
        id
        , name
        , description
        , levelid
    ) SELECT 
        style_id as id
        , style_name as name
        , style_name as description
        , 'style' as levelid
    FROM cns_new_styles ns;

    INSERT INTO blk_h_prodstd (
        id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    ) SELECT
        style_id as id
        , ancestor0
        , ancestor1
        , ancestor2
        , ancestor3
        , ancestor4
        , ancestor5
        , ancestor6
        , ancestor7
    FROM cns_new_styles ns
    INNER JOIN blk_h_prodstd h_prod
        on ns.ref_style = h_prod.id;
    
    CREATE TEMPORARY TABLE temp_newly_created_styles ON COMMIT DROP AS
    SELECT 
        style_id
        , style_name
        , stylecolor as stylecolor_id
        , style_stylecolor
    FROM cns_new_styles;

END;
$$;


ALTER PROCEDURE public.create_new_styles(IN p_pivot_user_id text, IN p_style_stylecolor_list text) OWNER TO psql;

--
-- TOC entry 2096 (class 1255 OID 129294782)
-- Name: create_table_function(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.create_table_function() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE 'CREATE TABLE IF NOT EXISTS new_table (
        id SERIAL PRIMARY KEY,
        column1 VARCHAR(50),
        column2 INT,
        column3 DATE
    )';
END;
$$;


ALTER FUNCTION public.create_table_function() OWNER TO psql;

--
-- TOC entry 2095 (class 1255 OID 129294783)
-- Name: create_table_function_2(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.create_table_function_2() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE 'CREATE TABLE new_table_2 (
        id SERIAL PRIMARY KEY,
        column1 VARCHAR(50),
        column2 INT,
        column3 DATE
    )';
END;
$$;


ALTER FUNCTION public.create_table_function_2() OWNER TO psql;

--
-- TOC entry 2097 (class 1255 OID 129294784)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          UPDATE blk_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2098 (class 1255 OID 129294785)
-- Name: dbt_trigger_before_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_trigger_before_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If the new value is invalid, revert it to the old one.
    IF NEW.dbt_wk >= NEW.erlstmkdnwk OR OLD.dbt_wk < OLD.plan_current OR NEW.dbt_wk > COALESCE(OLD.relaunch_dbt_wk, 'FY99_W01')
    THEN
        NEW.dbt_wk := OLD.dbt_wk;  -- Just revert the in-flight update
    END IF;

    RETURN NEW;  -- Must return NEW in a BEFORE trigger
END;
$$;


ALTER FUNCTION public.dbt_trigger_before_update_validity_check() OWNER TO psql;

--
-- TOC entry 2099 (class 1255 OID 129294786)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from blk_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 2100 (class 1255 OID 129294787)
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
-- TOC entry 2101 (class 1255 OID 129294788)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- We replicate your condition: if (new.exitdate <= new.erlstmkdnwk)
    -- or (old.exitdate < old.plan_current), then revert to old.exitdate.
    IF (NEW.exitdate < NEW.erlstmkdnwk OR OLD.exitdate < OLD.plan_current) THEN -- changed
       NEW.exitdate := OLD.exitdate;
    END IF;

    RETURN NEW;  -- We must return NEW in a BEFORE trigger
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2102 (class 1255 OID 129294789)
-- Name: fetch_addtoassortment(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_addtoassortment(__product text, __location text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE ret refcursor;
BEGIN

OPEN ret FOR
SELECT 
null as style_id,
null as style_description,
null as department,
null as dept_name,
null as class,
null as class_name,
null as supplier_site_id,
null as supplier_site_name,
null as style_type,
null as vpn_id_non_plm,
null as color_id,
null as merch_color_name,
null as original_price,
null as target_cost,
null as debut_week,
null as markdown_week,
null as exit_week,
null as sales_rating,
null as pres_min,
null as pres_min_weeks,
null as receipt_interval,
null as store_min_multiple,
null as service_level,
null as dropship_indicator,
null as replenishment_indicator,
null as program_name,
null as segment_buy,
null as silhouette,
null as subcategory,
null as selling_season,
null as selling_year,
null as aa_indicator,
null as bottom_fit,
null as categories,
null as classification,
null as collegiate,
null as cut_fit,
null as denim_trends,
null as fabric_desc,
null as fashion_vs_basic,
null as graphic_type,
null as levi_fits,
null as print_type,
null as print_vs_solid,
null as short_inseam,
null as sleeve_length,
null as superbuy_ind,
null as young_contemporary,
null as bottom_silo,
null as d_cup_avail,
null as denim_rise,
null as dress_length,
null as fit_solution,
null as inseam,
null as lounge_vs_sleep,
null as neckline,
null as occasion,
null as robe,
null as top_length,
null as cc_set,
null as construction,
null as fashion_jewelry,
null as jewelry_presentation,
null as material_color,
null as material_type,
null as necklaces,
null as texture_pattern,
null as fragrance_scents,
null as level_of_presentation,
null as makeup_total_eye,
null as makeup_total_face,
null as makeup_total_lip,
null as skincare_total_face,
null as total_fragrance,
null as total_makeup,
null as total_skincare,
null as bracelets,
null as bridal,
null as chain_type,
null as ctw_fine_jewelry,
null as dial_color,
null as dtw_fine_dewelry,
null as ears,
null as fine_jewelry_metal,
null as gold_mkt_fine_jewelry,
null as grams_fine_jewelry,
null as high_value_status,
null as metal_type,
null as ring,
null as silver_grams,
null as silver_mkt_fine_jewelry,
null as stone,
null as watch,
null as bedding_acc,
null as bridal_registry,
null as coastal_ind,
null as cc_configuration,
null as custom_need,
null as material,
null as white_dinnerware_ind,
null as closure,
null as heel_height,
null as heel_type,
null as outsole,
null as shaft_height,
null as shoe_type,
null as sketchers_div,
null as sole_type,
null as tech_features,
null as toe_character,
null as toe_type,
null as width
;

return ret;
END;
$$;


ALTER FUNCTION public.fetch_addtoassortment(__product text, __location text) OWNER TO psql;

--
-- TOC entry 2103 (class 1255 OID 129294790)
-- Name: fetch_store_count(text, text, text[], text[], text[], text[], text[], text[], text[], text[], text[], text[], text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text, str_climate text[], str_grade text[], str_segmentation text[], str_sub_segmentation text[], str_aa_ind text[], str_hisp_ind text[], str_lifestyle_01 text[], str_lifestyle_02 text[], str_lifestyle_03 text[], str_lifestyle_04 text[], str_state text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 DECLARE
  sls_start     text;
  dept_var      text;
 BEGIN

 select ancestor3 into dept_var
 from blk_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from blk_ma_dptflrsetattributes a
 where time = floorsetId and product = dept_var;

RETURN(
  SELECT
  count(*)
FROM
  (
    (
      SELECT
        distinct(sc.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_climate'
            AND value = ANY( str_climate )
        ) as sc
    ) as sc
    INNER JOIN (
      SELECT
        distinct(gr.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as gr
    ) as gr USING (store)
        INNER JOIN (
      SELECT
        distinct(seg.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_segmentation'
            AND value = ANY( str_segmentation )
        ) as seg
    ) as seg USING (store)
        INNER JOIN (
      SELECT
        distinct(sseg.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_sub_segmentation'
            AND value = ANY( str_sub_segmentation )
        ) as sseg
    ) as sseg USING (store)
        INNER JOIN (
      SELECT
        distinct(aa.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_aa_ind'
            AND value = ANY( str_aa_ind )
        ) as aa
    ) as aa USING (store)
        INNER JOIN (
      SELECT
        distinct(his.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_hisp_ind'
            AND value = ANY( str_hisp_ind )
        ) as his
    ) as his USING (store)
        INNER JOIN (
      SELECT
        distinct(ls1.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_lifestyle_01'
            AND value = ANY( str_lifestyle_01 )
        ) as ls1
    ) as ls1 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls2.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_lifestyle_02'
            AND value = ANY( str_lifestyle_02 )
        ) as ls2
    ) as ls2 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls3.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_lifestyle_03'
            AND value = ANY( str_lifestyle_03 )
        ) as ls3
    ) as ls3 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls4.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_lifestyle_04'
            AND value = ANY( str_lifestyle_04 )
        ) as ls4
    ) as ls4 USING (store)
        INNER JOIN (
      SELECT
        distinct(st.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_state'
            AND value = ANY( str_state )
        ) as st
    ) as st USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text, str_climate text[], str_grade text[], str_segmentation text[], str_sub_segmentation text[], str_aa_ind text[], str_hisp_ind text[], str_lifestyle_01 text[], str_lifestyle_02 text[], str_lifestyle_03 text[], str_lifestyle_04 text[], str_state text[]) OWNER TO psql;

--
-- TOC entry 2104 (class 1255 OID 129294791)
-- Name: fn_validate_reset_inv_for_relaunch(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fn_validate_reset_inv_for_relaunch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_relaunch_is_valid BOOLEAN;
BEGIN
    -- Only check when someone is trying to set the flag to 1
    IF NEW.reset_inv_for_relaunch = 1 THEN

        -- Look up relaunch_is_valid for this product
        SELECT relaunch_is_valid
          INTO v_relaunch_is_valid
          FROM blk_ma_stylecolorchannelattributes
         WHERE product = NEW.product
         LIMIT 1;

        -- Force to 0 if:
        --   (a) product not found in attributes table, OR
        --   (b) relaunch_is_valid IS NULL, OR
        --   (c) relaunch_is_valid = false
        IF v_relaunch_is_valid IS NOT TRUE THEN
            NEW.reset_inv_for_relaunch := 0;

            RAISE NOTICE
                'reset_inv_for_relaunch forced to 0 for product [%]: relaunch_is_valid is not true',
                NEW.product;
        END IF;

    END IF;

    -- Stamp audit columns
    NEW.updated_at := CURRENT_TIMESTAMP;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_validate_reset_inv_for_relaunch() OWNER TO psql;

--
-- TOC entry 2105 (class 1255 OID 129294792)
-- Name: get_default_params(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_default_params(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
v_exists integer;
insert_s2 text;
delete_s3 text;
delete_s3_x text;
insert_s4 text;
v_exists_ranging integer;
BEGIN
  EXECUTE '(select count(*) from cart_params where 
          jsessionid = '''||$1||'''  
          and scope_product =  '''||$2||'''  
          and scope_location = '''||$3||'''  
          and scope_start = '''||$4||''' 
          )' into v_exists;

  EXECUTE '(select count(*) from cart_params where 
          jsessionid = '''||$1||'''  
          and scope_product =  '''||$2||'''  
          and scope_location = '''||$3||'''  
          and scope_start = '''||$4||''' 
          and scope_floorset = '''||$5||'''  
          )' into v_exists_ranging;

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
          , slsrnk
          , planned_sell_down_week
		  , cc_service_level
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
          , 3
          , planned_sell_down_week
		  , default_service_level
        FROM 
          blk_ma_dptflrsetattributes 
        WHERE 
          product = '''||$2||'''
          and time = '''||$5||'''
          ';
  delete_s3 := ' 
     delete from cart_ranging where jsessionid = '''||$1||''' and scope_product='''||$2||''' 
     and scope_start = '''||$4||''' and scope_floorset = '''||$5||'''  
             ';
  delete_s3_x := ' 
     delete from cart_ranging where jsessionid = '''||$1||''' and scope_product='''||$2||''' 
     and scope_start = '''||$4||''' 
             ';
  insert_s4 := '
  insert into cart_ranging 
(jsessionid, scope_product, scope_location, scope_start, scope_floorset, str_grade, str_segmentation, 
 str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, 
 str_lifestyle_04, str_climate, str_state, ssg, flnrange, isfunded, indx, store_count, 
 str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or 
 )
select 
  '''||$1||''',product,'''||$3||''','''||$4||''',time, 
    cast(default_str_grade as text[]) as default_str_grade
    , default_str_segmentation
    , default_str_sub_segmentation
    , default_str_aa_ind
    , default_str_hisp_ind
    , default_str_lifestyle_01
    , default_str_lifestyle_02
    , default_str_lifestyle_03
    , default_str_lifestyle_04
    , default_str_climate
    , default_str_state
    , default_ssg
    , default_flnrange
    , isfunded
    , indx
    , store_count
    , default_str_grade_or
    , default_str_segmentation_or
    , default_str_sub_segmentation_or
    , default_str_aa_ind_or
    , default_str_hisp_ind_or
    , default_str_lifestyle_01_or
    , default_str_lifestyle_02_or
    , default_str_lifestyle_03_or
    , default_str_lifestyle_04_or
    , default_str_climate_or
    , default_str_state_or
  FROM (
  select product, time,default_str_grade,default_str_segmentation,default_str_sub_segmentation,default_str_aa_ind,default_str_hisp_ind,     
           default_str_lifestyle_01,default_str_lifestyle_02,default_str_lifestyle_03,default_str_lifestyle_04,default_str_climate,default_str_state,default_ssg, 
         default_flnrange,1 as isfunded, a.indx, 
       get_store_count('''||$4||''',default_str_climate,default_str_grade,default_str_segmentation,default_str_sub_segmentation,default_str_aa_ind,default_str_hisp_ind,     
           default_str_lifestyle_01,default_str_lifestyle_02,default_str_lifestyle_03,default_str_lifestyle_04,default_str_state,product) as store_count,
           default_str_grade_or,default_str_segmentation_or,default_str_sub_segmentation_or,default_str_aa_ind_or,default_str_hisp_ind_or,default_str_lifestyle_01_or,default_str_lifestyle_02_or,default_str_lifestyle_03_or,default_str_lifestyle_04_or,default_str_climate_or,default_str_state_or 
  FROM blk_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from blk_serviceparams where id=''plan_current'') c,
   (select value as plan_end from blk_serviceparams where id=''plan_end'') d
  where 
  b.jsessionid = '''||$1||'''
  and b.scope_product = '''||$2||'''
  and b.scope_location = '''||$3||'''
  and a.product = b.scope_product
     and a.slsstart <= least(d.plan_end,b.exitdate) and a.slsend > greatest(b.dbt_wk,c.plan_current)
  )X
        ';
  IF  v_exists = 0
  THEN
  EXECUTE insert_s2;
  EXECUTE delete_s3;  
  EXECUTE insert_s4;
  END IF;

  -- There instances (unknown reason) where records will get removed from cart_ranging but not cart_params, thus v_exists > 0. This results in a No Data Found error.
  -- For these, we will remove any records from cart_ranging (via delete_s3_x) for that session/product/scope start and then re-insert them
  IF  v_exists > 0 and v_exists_ranging = 0
  THEN
  EXECUTE delete_s3_x;
  EXECUTE insert_s4;
  END IF;

 RETURN;
END;
$_$;


ALTER FUNCTION public.get_default_params(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2106 (class 1255 OID 129294794)
-- Name: get_store_count(text, text[], text[], text[], text[], text[], text[], text[], text[], text[], text[], text[], text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, str_climate text[], str_grade text[], str_segmentation text[], str_sub_segmentation text[], str_aa_ind text[], str_hisp_ind text[], str_lifestyle_01 text[], str_lifestyle_02 text[], str_lifestyle_03 text[], str_lifestyle_04 text[], str_state text[], productval text) RETURNS integer
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
        distinct(sc.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_climate'
            AND value = ANY( str_climate )
        ) as sc
    ) as sc
    INNER JOIN (
      SELECT
        distinct(gr.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as gr
    ) as gr USING (store)
        INNER JOIN (
      SELECT
        distinct(seg.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_segmentation'
            AND value = ANY( str_segmentation )
        ) as seg
    ) as seg USING (store)
        INNER JOIN (
      SELECT
        distinct(sseg.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_sub_segmentation'
            AND value = ANY( str_sub_segmentation )
        ) as sseg
    ) as sseg USING (store)
        INNER JOIN (
      SELECT
        distinct(aa.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_aa_ind'
            AND value = ANY( str_aa_ind )
        ) as aa
    ) as aa USING (store)
        INNER JOIN (
      SELECT
        distinct(his.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_hisp_ind'
            AND value = ANY( str_hisp_ind )
        ) as his
    ) as his USING (store)
        INNER JOIN (
      SELECT
        distinct(ls1.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_lifestyle_01'
            AND value = ANY( str_lifestyle_01 )
        ) as ls1
    ) as ls1 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls2.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_lifestyle_02'
            AND value = ANY( str_lifestyle_02 )
        ) as ls2
    ) as ls2 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls3.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_lifestyle_03'
            AND value = ANY( str_lifestyle_03 )
        ) as ls3
    ) as ls3 USING (store)
        INNER JOIN (
      SELECT
        distinct(ls4.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_lifestyle_04'
            AND value = ANY( str_lifestyle_04 )
        ) as ls4
    ) as ls4 USING (store)
        INNER JOIN (
      SELECT
        distinct(st.unnest) as store
      FROM
        (
          SELECT
            unnest(stores)
          FROM
            blk_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_state'
            AND value = ANY( str_state )
        ) as st
    ) as st USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.get_store_count(week text, str_climate text[], str_grade text[], str_segmentation text[], str_sub_segmentation text[], str_aa_ind text[], str_hisp_ind text[], str_lifestyle_01 text[], str_lifestyle_02 text[], str_lifestyle_03 text[], str_lifestyle_04 text[], str_state text[], productval text) OWNER TO psql;

--
-- TOC entry 2131 (class 1255 OID 129294795)
-- Name: insert_stylecolorweekattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.insert_stylecolorweekattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
 v_hq_id text;
begin

if not exists (select from blk_ma_stylecolorweekattributes where product = new.product) THEN

select MIN(HQ_ID) 
into v_hq_id
from blk_specstyle_attr_week 
where vpn_id = new.cc_vpn
and color_cd = new.cc_vpn_color
;


insert into blk_ma_stylecolorweekattributes
select styclr.product, atw.week_id as time, 'MASTER_DC' as location, styclr.cc_vpn, styclr.cc_vpn_color, hq_id, 
	atw.vpn_desc, atw.color_descr as cc_vpn_color_desc, atw.division, atw.department, 
	atw.buy_period_id, atw.buy_period_descr, atw.plm_color_status, atw.plm_style_status, atw.size_codes, atw.size_description, atw.season as buy_period_season, 
	atw.cost as plm_cost, atw.bi_vendor, atw.style_min, atw.style_max, atw.size_range, atw.pack_size_units, atw.color_way_desc,
	atw.cad_name, atw.image_url, atw.hq_lookup_key, current_date as eventdate, 1 as version_id,  date_trunc('sec'::text, current_timestamp)::timestamp as created_at, 'system' as created_by, 
 date_trunc('sec'::text, current_timestamp)::timestamp as updated_at, 'system' as updated_by, 0 as record_state
from blk_ma_stylecolorattributes styclr
join BLK_SPECSTYLE_ATTR_WEEK atw
on atw.vpn_id = new.cc_vpn
and atw.color_cd = new.cc_vpn_color
and atw.hq_id = v_hq_id
where styclr.product = new.product
;

end if;

update blk_ma_stylecolorchannelattributes d
set cc_target_cost = plm_cost
from
(
	select distinct A.PRODUCT, hq_id, buy_period_descr, B.cc_buy_period_descr, plm_cost::real as plm_cost, B.CC_COST, C.cc_target_cost 
	from blk_ma_stylecolorweekattributes A
	join blk_ma_stylecolorattributes b
	on A.product = B.product 
	and A.buy_period_descr = B.cc_buy_period_descr 
	join blk_ma_stylecolorchannelattributes c
	on A.product = C.product 
) e
where d.product = e.product
;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_stylecolorweekattributes() OWNER TO psql;

--
-- TOC entry 2132 (class 1255 OID 129294796)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from blk_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 2133 (class 1255 OID 129294797)
-- Name: lifecycle_blank_null(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_blank_null() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

	NEW.dbt_wk := OLD.dbt_wk;
	NEW.erlstmkdnwk := OLD.erlstmkdnwk;
	NEW.exitdate := OLD.exitdate;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_blank_null() OWNER TO psql;

--
-- TOC entry 2134 (class 1255 OID 129294798)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

update blk_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update blk_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from blk_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 2135 (class 1255 OID 129294799)
-- Name: lock_stylecolor(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lock_stylecolor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (NEW.cc_prepublish is true::boolean or NEW.cc_prepublish = 1::boolean) and (OLD.cc_prepublish is false::boolean or OLD.cc_prepublish = 0::boolean or OLD.cc_prepublish is null) then
	
  update blk_ma_stylecolorattributes 
	set cc_is_locked = 'Y',
      ccstylecolorcreatedate = '3000-01-01', -- Set create date super far in the future so that we know it's a temp lock
      cc_last_published_by = m.email
  from user_metadata m
  where updated_by = m.uid 
  and product = NEW.product;

  update blk_ma_styleattributes 
	set sty_is_locked = 'Y',
      ccstylecreatedate = '3000-01-01' -- Set create date super far in the future so that we know it's a temp lock
	where product = (select distinct ancestor0 from blk_h_prodstd where id = NEW.product)
  and sty_is_locked is null
  and ccstylecreatedate is null;

  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.lock_stylecolor() OWNER TO psql;

--
-- TOC entry 2136 (class 1255 OID 129294800)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW.erlstmkdnwk <= NEW.dbt_wk
        OR OLD.erlstmkdnwk < OLD.plan_current
        OR NEW.exitdate < NEW.erlstmkdnwk) THEN -- changed

        -- Revert to old value
        NEW.erlstmkdnwk := OLD.erlstmkdnwk;
    END IF;

    RETURN NEW;  -- Must return NEW in a BEFORE trigger
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2137 (class 1255 OID 129294801)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 2138 (class 1255 OID 129294802)
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
-- TOC entry 2139 (class 1255 OID 129294803)
-- Name: override_ticket_price(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.override_ticket_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

begin
	
	if new.a_current_retail_override is not null then
		update blk_a_assortment
		set a_current_retail = cast(new.a_current_retail_override as real)
		where product = new.product
		and time = new.time;
	end if;

	if new.a_current_retail_override is null then
		update blk_a_assortment
		set a_current_retail =
		(
			select case when ccstylecolorcreatedate is null or ccstylecolorcreatedate = '' then cc_msrp else cc_current_retail end
			from blk_ma_stylecolorattributes
			where product = new.product
		)
		where product = new.product
		and time = new.time;
	end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.override_ticket_price() OWNER TO psql;

--
-- TOC entry 2140 (class 1255 OID 129294804)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM blk_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 2141 (class 1255 OID 129294805)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
sls_start                   text;
dept_var                    text;
v_ssg                       text[];

v_default_grade             text[];
v_default_segmentation      text[];
v_default_sub_segmentation  text[];
v_default_aa_ind            text[];
v_default_hisp_ind          text[];
v_default_lifestyle_01      text[];
v_default_lifestyle_02      text[];
v_default_lifestyle_03      text[];
v_default_lifestyle_04      text[];
v_default_climate           text[];
v_default_state             text[];

BEGIN

  select ancestor3 into dept_var
  from blk_h_prodstd where id = NEW.product;

  select a.slsstart,default_str_grade,default_str_segmentation,default_str_sub_segmentation,default_str_aa_ind,default_str_hisp_ind,default_str_lifestyle_01,default_str_lifestyle_02,default_str_lifestyle_03,default_str_lifestyle_04,default_str_climate,default_str_state 
  into sls_start,v_default_grade,v_default_segmentation,v_default_sub_segmentation,v_default_aa_ind,v_default_hisp_ind,v_default_lifestyle_01,v_default_lifestyle_02,v_default_lifestyle_03,v_default_lifestyle_04,v_default_climate,v_default_state 
  from blk_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;

 -- str_grade flips from null to not null then wipe out ssg
  if cardinality(NEW.str_grade) > 0 and (cardinality(OLD.str_grade) = 0 or cardinality(OLD.str_grade) is null) then
    select '{}'::text[]
    into v_ssg;
  
      --NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_segmentation flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_segmentation) > 0 and (cardinality(OLD.str_segmentation) = 0 or cardinality(OLD.str_segmentation) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      --NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_sub_segmentation flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_sub_segmentation) > 0 and (cardinality(OLD.str_sub_segmentation) = 0 or cardinality(OLD.str_sub_segmentation) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      --NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_aa_ind flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_aa_ind) > 0 and (cardinality(OLD.str_aa_ind) = 0 or cardinality(OLD.str_aa_ind) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      --NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_hisp_ind flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_hisp_ind) > 0 and (cardinality(OLD.str_hisp_ind) = 0 or cardinality(OLD.str_hisp_ind) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      --NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_lifestyle_01 flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_lifestyle_01) > 0 and (cardinality(OLD.str_lifestyle_01) = 0 or cardinality(OLD.str_lifestyle_01) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      --NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_lifestyle_02 flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_lifestyle_02) > 0 and (cardinality(OLD.str_lifestyle_02) = 0 or cardinality(OLD.str_lifestyle_02) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      --NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_lifestyle_03 flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_lifestyle_03) > 0 and (cardinality(OLD.str_lifestyle_03) = 0 or cardinality(OLD.str_lifestyle_03) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      --NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_lifestyle_04 flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_lifestyle_04) > 0 and (cardinality(OLD.str_lifestyle_04) = 0 or cardinality(OLD.str_lifestyle_04) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      --NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_climate flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_climate) > 0 and (cardinality(OLD.str_climate) = 0 or cardinality(OLD.str_climate) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      --NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

 -- str_state flips from null to not null then wipe out ssg
  elsif cardinality(NEW.str_state) > 0 and (cardinality(OLD.str_state) = 0 or cardinality(OLD.str_state) is null) then
  select '{}'::text[]
  into v_ssg;
  
      NEW.str_grade               = CASE WHEN cardinality(NEW.str_grade           ) > 0 THEN NEW.str_grade               ELSE v_default_grade            END;
      NEW.str_segmentation        = CASE WHEN cardinality(NEW.str_segmentation    ) > 0 THEN NEW.str_segmentation        ELSE v_default_segmentation     END;
      NEW.str_sub_segmentation    = CASE WHEN cardinality(NEW.str_sub_segmentation) > 0 THEN NEW.str_sub_segmentation    ELSE v_default_sub_segmentation END;
      NEW.str_aa_ind              = CASE WHEN cardinality(NEW.str_aa_ind          ) > 0 THEN NEW.str_aa_ind              ELSE v_default_aa_ind           END;
      NEW.str_hisp_ind            = CASE WHEN cardinality(NEW.str_hisp_ind        ) > 0 THEN NEW.str_hisp_ind            ELSE v_default_hisp_ind         END;
      NEW.str_lifestyle_01        = CASE WHEN cardinality(NEW.str_lifestyle_01    ) > 0 THEN NEW.str_lifestyle_01        ELSE v_default_lifestyle_01     END;
      NEW.str_lifestyle_02        = CASE WHEN cardinality(NEW.str_lifestyle_02    ) > 0 THEN NEW.str_lifestyle_02        ELSE v_default_lifestyle_02     END;
      NEW.str_lifestyle_03        = CASE WHEN cardinality(NEW.str_lifestyle_03    ) > 0 THEN NEW.str_lifestyle_03        ELSE v_default_lifestyle_03     END;
      NEW.str_lifestyle_04        = CASE WHEN cardinality(NEW.str_lifestyle_04    ) > 0 THEN NEW.str_lifestyle_04        ELSE v_default_lifestyle_04     END;
      NEW.str_climate             = CASE WHEN cardinality(NEW.str_climate         ) > 0 THEN NEW.str_climate             ELSE v_default_climate          END;
      --NEW.str_state               = CASE WHEN cardinality(NEW.str_state           ) > 0 THEN NEW.str_state               ELSE v_default_state            END;

  -- SSG flips from null to not null
  elsif cardinality(NEW.ssg) > 0 and (cardinality(OLD.ssg) = 0 or cardinality(OLD.ssg) is null or cardinality(OLD.ssg) > 0 or cardinality(OLD.ssg) is not null) then
    v_ssg = NEW.SSG;

      NEW.str_climate             = '{}'::text[];
      NEW.str_grade               = '{}'::text[];
      NEW.str_segmentation        = '{}'::text[];
      NEW.str_sub_segmentation    = '{}'::text[];
      NEW.str_aa_ind              = '{}'::text[];
      NEW.str_hisp_ind            = '{}'::text[];
      NEW.str_lifestyle_01        = '{}'::text[];
      NEW.str_lifestyle_02        = '{}'::text[];
      NEW.str_lifestyle_03        = '{}'::text[];
      NEW.str_lifestyle_04        = '{}'::text[];
      NEW.str_state               = '{}'::text[]; 

 -- users are able to inadvertantly remove all ranges. If that happens then we'll put defaults back for all ranges
  elsif     (cardinality(NEW.ssg)                    = 0 OR cardinality(OLD.ssg)                    = 0 OR cardinality(NEW.ssg)                    is null OR cardinality(OLD.ssg)                    is null)
        and (cardinality(NEW.str_grade)              = 0 OR cardinality(OLD.str_grade)              = 0 OR cardinality(NEW.str_grade)              is null OR cardinality(OLD.str_grade)              is null) 
        and (cardinality(NEW.str_segmentation)       = 0 OR cardinality(OLD.str_segmentation)       = 0 OR cardinality(NEW.str_segmentation)       is null OR cardinality(OLD.str_segmentation)       is null) 
        and (cardinality(NEW.str_sub_segmentation)   = 0 OR cardinality(OLD.str_sub_segmentation)   = 0 OR cardinality(NEW.str_sub_segmentation)   is null OR cardinality(OLD.str_sub_segmentation)   is null) 
        and (cardinality(NEW.str_aa_ind)             = 0 OR cardinality(OLD.str_aa_ind)             = 0 OR cardinality(NEW.str_aa_ind)             is null OR cardinality(OLD.str_aa_ind)             is null) 
        and (cardinality(NEW.str_hisp_ind)           = 0 OR cardinality(OLD.str_hisp_ind)           = 0 OR cardinality(NEW.str_hisp_ind)           is null OR cardinality(OLD.str_hisp_ind)           is null) 
        and (cardinality(NEW.str_lifestyle_01)       = 0 OR cardinality(OLD.str_lifestyle_01)       = 0 OR cardinality(NEW.str_lifestyle_01)       is null OR cardinality(OLD.str_lifestyle_01)       is null) 
        and (cardinality(NEW.str_lifestyle_02)       = 0 OR cardinality(OLD.str_lifestyle_02)       = 0 OR cardinality(NEW.str_lifestyle_02)       is null OR cardinality(OLD.str_lifestyle_02)       is null) 
        and (cardinality(NEW.str_lifestyle_03)       = 0 OR cardinality(OLD.str_lifestyle_03)       = 0 OR cardinality(NEW.str_lifestyle_03)       is null OR cardinality(OLD.str_lifestyle_03)       is null) 
        and (cardinality(NEW.str_lifestyle_04)       = 0 OR cardinality(OLD.str_lifestyle_04)       = 0 OR cardinality(NEW.str_lifestyle_04)       is null OR cardinality(OLD.str_lifestyle_04)       is null) 
        and (cardinality(NEW.str_climate)            = 0 OR cardinality(OLD.str_climate)            = 0 OR cardinality(NEW.str_climate)            is null OR cardinality(OLD.str_climate)            is null) 
        and (cardinality(NEW.str_state)              = 0 OR cardinality(OLD.str_state)              = 0 OR cardinality(NEW.str_state)              is null OR cardinality(OLD.str_state)              is null) 
 then
      select '{}'::text[]
      into v_ssg;
  
      NEW.str_grade               = v_default_grade;
      NEW.str_segmentation        = v_default_segmentation;
      NEW.str_sub_segmentation    = v_default_sub_segmentation;
      NEW.str_aa_ind              = v_default_aa_ind;
      NEW.str_hisp_ind            = v_default_hisp_ind;
      NEW.str_lifestyle_01        = v_default_lifestyle_01;
      NEW.str_lifestyle_02        = v_default_lifestyle_02;
      NEW.str_lifestyle_03        = v_default_lifestyle_03;
      NEW.str_lifestyle_04        = v_default_lifestyle_04;
      NEW.str_climate             = v_default_climate;
      NEW.str_state               = v_default_state;

  end if;

  
  update blk_a_assortment a
  set 
       str_grade = NEW.str_grade
     , str_segmentation = NEW.str_segmentation
     , str_sub_segmentation = NEW.str_sub_segmentation
     , str_aa_ind = NEW.str_aa_ind
     , str_hisp_ind = NEW.str_hisp_ind
     , str_lifestyle_01 = NEW.str_lifestyle_01
     , str_lifestyle_02 = NEW.str_lifestyle_02
     , str_lifestyle_03 = NEW.str_lifestyle_03
     , str_lifestyle_04 = NEW.str_lifestyle_04
     , str_climate = NEW.str_climate
     , str_state = NEW.str_state
     , str_grade_or             = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_grade_or            END
     , str_segmentation_or      = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_segmentation_or     END
     , str_sub_segmentation_or  = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_sub_segmentation_or END
     , str_aa_ind_or            = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_aa_ind_or           END
     , str_hisp_ind_or          = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_hisp_ind_or         END
     , str_lifestyle_01_or      = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_lifestyle_01_or     END
     , str_lifestyle_02_or      = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_lifestyle_02_or     END
     , str_lifestyle_03_or      = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_lifestyle_03_or     END
     , str_lifestyle_04_or      = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_lifestyle_04_or     END
     , str_climate_or           = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_climate_or          END
     , str_state_or             = CASE WHEN NEW.str_grade = '{}'::text[] THEN '{}'::text[] ELSE NEW.str_state_or            END
     , ssg = v_ssg
     , store_count = NEW.store_count
  where product = NEW.product
    and location = NEW.location
    and time in (select id from blk_d_time where indx >= (select indx from blk_d_time where id = NEW.time) and time in (select time from blk_a_assortment where product = NEW.product and location = NEW.location))
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 2142 (class 1255 OID 129294807)
-- Name: remove_dup(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_dup() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
DELETE FROM plan_queue
 WHERE (product, initiator) IN
    (SELECT product, initiator
    FROM 
        (
            SELECT product, initiator,
             ROW_NUMBER() OVER ( PARTITION BY  product, initiator ORDER BY  initiated_at ) AS row_num
            FROM plan_queue 
            where (error is null) 
        ) t
        WHERE t.row_num > 1 );
RETURN NULL;
END;
$$;


ALTER FUNCTION public.remove_dup() OWNER TO psql;

--
-- TOC entry 2143 (class 1255 OID 129294808)
-- Name: remove_pinched_store(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_pinched_store() RETURNS trigger
    LANGUAGE plpgsql
    AS $$


DECLARE
v_uuid_temp text;
v_uuid text;

s1 text;
s2 text;
s3 text;
s4 text;
s5 text;
s6 text;

table_tmp_pinch_store_to_remove text;
table_tmp_pinch_store_all text;
table_tmp_record_to_remove text;
table_tmp_preview_p_pinchpo text;

v_pinch_user_po_plan_name_store text;
v_po_id text;
v_product text;
v_time text;
v_pinch_id text;
v_pinch_store_count integer;

--------------------------------------------------------------------------------------------------
--    This function is used when a store from an existing pinch po line is pinched again.   --
--  The store will be removed from the first pinch po line.                   --
--------------------------------------------------------------------------------------------------

BEGIN

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_tmp_pinch_store_to_remove := 'tmp_pinch_store_to_remove_'||v_uuid;
table_tmp_pinch_store_all := 'tmp_pinch_store_all_'||v_uuid;
table_tmp_record_to_remove := 'tmp_record_to_remove_'||v_uuid;
table_tmp_preview_p_pinchpo := 'tmp_preview_p_pinchpo_'||v_uuid;

v_pinch_user_po_plan_name_store := NEW.pinch_user_po_plan_name_store;
v_po_id                         := NEW.po_id;
v_product                       := NEW.product;
v_time                          := NEW.time;
v_pinch_id                      := NEW.pinch_id;
RAISE NOTICE 'INSIDE v_pinch_user_po_plan_name_store: %', v_pinch_user_po_plan_name_store;
RAISE NOTICE 'INSIDE v_po_id: %'                        , v_po_id;
RAISE NOTICE 'INSIDE v_product: %'                      , v_product;
RAISE NOTICE 'INSIDE v_time: %'                         , v_time;

  select count(pinched_stores) as pinch_store_count
  into v_pinch_store_count
  from
  (
    select po_id, product, time, unnest(pinched_stores) as pinched_stores
    from blk_p_pinchpo
    where po_id = v_po_id
    and product = v_product
    and time =    v_time
  ) a
  group by po_id, product, time, pinched_stores
  having  count(pinched_stores) > 1
  ;

  RAISE NOTICE 'INSIDE v_pinch_store_count: %', v_pinch_store_count;

IF v_pinch_store_count > 1 THEN

  -- 1.) Using the plan name, create table to find stores that exist more than once
    s1 := 'create temporary table ' || table_tmp_pinch_store_to_remove || ' as
    select po_id, product, time, pinched_stores, count(pinched_stores) as pinch_store_count
    from
    (
      select po_id, product, time, unnest(pinched_stores) as pinched_stores
      from blk_p_pinchpo
      where po_id = ''' || v_po_id || '''
      and product = ''' || v_product || '''
      and time =    ''' || v_time || '''
    ) a
    group by po_id, product, time, pinched_stores
    having  count(pinched_stores) > 1
    ';

    RAISE NOTICE 'INSIDE s1 %', s1;

    EXECUTE s1;

  --2.) Create table with all line for the plan name
    s3 := 'create temporary table ' || table_tmp_pinch_store_all || ' as
    select po_id, product, time, pinch_id, created_at, unnest(pinched_stores) as pinched_stores
    from blk_p_pinchpo
    where po_id = ''' || v_po_id || '''
    and product = ''' || v_product || '''
    and time =    ''' || v_time || '''
    ';

    RAISE NOTICE 'INSIDE s3 %', s3;

    EXECUTE s3;

  -- 3.) Create Table with lines that have the store found in step 1 above.
  --    Then sort the records on created_at (oldest first) and limit to 1 so that we isolate the oldest record.
  --    This is the record we will remove the store from so that it only exists once for this po.
    s4 := 'create temporary table ' || table_tmp_record_to_remove || ' as
    select po_id, product, time, pinch_id, created_at
    from ' || table_tmp_pinch_store_all || '
    where (po_id, product, time, pinched_stores) in (select po_id, product, time, pinched_stores from ' || table_tmp_pinch_store_to_remove || ')
    order by created_at
    limit 1
    ';

    RAISE NOTICE 'INSIDE s4 %', s4;

    EXECUTE s4;

  -- 4.) Create a 'preview' table so that we can see a before and after of the pinch line we are updating.
    s5 := 'create temporary table ' || table_tmp_preview_p_pinchpo || ' as
    select po_id, product, time, pinch_id, created_at, pinched_stores, array_remove(pinched_stores, (SELECT pinched_stores from ' || table_tmp_pinch_store_to_remove || '))
    from blk_p_pinchpo
    where (po_id, product, time, pinch_id, created_at) in (select po_id, product, time, pinch_id, created_at from  ' || table_tmp_record_to_remove || ')
    ';

    RAISE NOTICE 'INSIDE s5 %', s5;

    EXECUTE s5;

  -- 5.) Update p_pinchpo to remove the store from the old pinch line
    s6 := 'update blk_p_pinchpo
    set pinched_stores = array_remove(pinched_stores, (SELECT pinched_stores from ' || table_tmp_pinch_store_to_remove || '))
    where (po_id, product, time, pinch_id, created_at) in (select po_id, product, time, pinch_id, created_at from ' || table_tmp_record_to_remove || ')
    ';

    RAISE NOTICE 'INSIDE s6 %', s6;

    EXECUTE s6;

END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.remove_pinched_store() OWNER TO psql;

--
-- TOC entry 2144 (class 1255 OID 129294809)
-- Name: remove_styleattributes_supp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_styleattributes_supp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  
    update blk_ma_styleattributes set supp_bi_flg = null where product = NEW.product;
    update blk_ma_styleattributes set supp_brand = null where product = NEW.product;
    update blk_ma_styleattributes set supp_brand_mindset = null where product = NEW.product;
    update blk_ma_styleattributes set supp_brand_type = null where product = NEW.product;
    update blk_ma_styleattributes set supp_class_group = null where product = NEW.product;
    update blk_ma_styleattributes set supp_direct_ship_ind = null where product = NEW.product;
    update blk_ma_styleattributes set supp_grp_brand_id = null where product = NEW.product;
    update blk_ma_styleattributes set supp_grp_parent_id = null where product = NEW.product;
    update blk_ma_styleattributes set supp_grp_standard_id = null where product = NEW.product;
    update blk_ma_styleattributes set supp_lifestyle = null where product = NEW.product;
    update blk_ma_styleattributes set supp_ninebox =null where product = NEW.product;
    update blk_ma_styleattributes set supp_parent_supplier_id = null where product = NEW.product; 
    update blk_ma_styleattributes set supp_parent_supplier_name = null where product = NEW.product;
    update blk_ma_styleattributes set supp_priceband = null where product = NEW.product;
    update blk_ma_styleattributes set supp_status = null where product = NEW.product;
    update blk_ma_styleattributes set supp_supplier_name = null where product = NEW.product;
    update blk_ma_styleattributes set sty_supplier_name = null where product = NEW.product;
    update blk_ma_styleattributes set sty_supplier_number = null where product = NEW.product;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.remove_styleattributes_supp() OWNER TO psql;

--
-- TOC entry 2145 (class 1255 OID 129294810)
-- Name: reset_plan_type_to_plan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.reset_plan_type_to_plan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  update 
    blk_a_assortment set plan_type='plan' 
  where 
    product = NEW.product
    and location = NEW.location
    and time >= NEW.time
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.reset_plan_type_to_plan() OWNER TO psql;

--
-- TOC entry 2187 (class 1255 OID 139169443)
-- Name: revert_non_editable_columns(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.revert_non_editable_columns() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.cc_aa_ind := OLD.cc_aa_ind;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.revert_non_editable_columns() OWNER TO psql;

--
-- TOC entry 2146 (class 1255 OID 129294811)
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
-- TOC entry 2185 (class 1255 OID 129294812)
-- Name: set_design_img(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_design_img() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
   v_design_img text;
   v_archive_img text;
   v_style_type text;
   v_hold_img text;
BEGIN

	select distinct a.sty_style_type
	into v_style_type
	from blk_ma_styleattributes a
	join blk_h_prodstd b
	on a.product = b.ancestor0 
	where b.id = NEW.product 
	;

    select hold_img
    into v_hold_img
    from blk_ma_imgattributes
    where product = NEW.product
    ;

  if (v_style_type = 'PLM' and (v_hold_img <> 'YES' or v_hold_img is null)) THEN

  select distinct replace(image_url,'gs://','https://storage.cloud.google.com/')
  into v_design_img
  from blk_specstyle_attr_week
  where image_url is not null
  and vpn_id = NEW.cc_vpn;

  insert into blk_ma_imgattributes_archive
  select *, date_trunc('sec'::text, now()::timestamp) as archive_date
  from blk_ma_imgattributes
  where product = NEW.product;

  select img
  into v_archive_img
  from blk_ma_imgattributes_archive
  where (product, archive_date) in (select product, min(archive_date) from blk_ma_imgattributes_archive where product = NEW.product group by product); 

  update blk_ma_imgattributes
  set img = coalesce(v_design_img, v_archive_img, img)
  where product = NEW.product;

  end if;
 
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_design_img() OWNER TO psql;

--
-- TOC entry 2147 (class 1255 OID 129294813)
-- Name: set_prepublished_at(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_prepublished_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cc_prepublish is true then
    NEW.cc_prepublished_at = NOW()::timestamp(0) - interval '4 hours';
  END IF;
  IF NEW.cc_prepublish is not true then
    NEW.cc_prepublish = 0::boolean;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_prepublished_at() OWNER TO psql;

--
-- TOC entry 2148 (class 1255 OID 129294814)
-- Name: set_qs_status_to_in_use_on_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_qs_status_to_in_use_on_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.qs_status IS DISTINCT FROM 'IN USE'::text THEN
        NEW.qs_status := 'IN USE';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_qs_status_to_in_use_on_update() OWNER TO psql;

--
-- TOC entry 2149 (class 1255 OID 129294815)
-- Name: set_relaunch_is_valid_if_not_null(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_relaunch_is_valid_if_not_null() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If relaunch_dbt_wk is being updated to a non-null value,
    -- then set relaunch_is_valid to TRUE.
    IF NEW.relaunch_dbt_wk IS NOT NULL THEN
        NEW.relaunch_is_valid := TRUE;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_relaunch_is_valid_if_not_null() OWNER TO psql;

--
-- TOC entry 2150 (class 1255 OID 129294816)
-- Name: set_sty_dpt_buy_period(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_sty_dpt_buy_period() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dept text;
BEGIN

  if new.sty_buy_period_descr = '' or new.sty_buy_period_descr is null then
    update blk_ma_styleattributes 
      set sty_dpt_buy_period = null,
        sty_vpn_buy_period = null,
        sty_vpn = null 
    where product = new.product;

    update blk_ma_stylecolorattributes
      set cc_buy_period_descr = null
    where product in (select id from blk_h_prodstd where ancestor0 = new.product);

  elsif new.sty_buy_period_descr <> old.sty_buy_period_descr and new.sty_vpn is not null and new.sty_vpn <> '' then
    select ancestor2 
    into v_dept
    from blk_h_prodstd bhp 
    where id = new.product; 

    update blk_ma_styleattributes 
      set sty_dpt_buy_period = v_dept || '_' || sty_buy_period_descr,
        sty_vpn_buy_period = null,
        sty_vpn = null
    where product = new.product;

    update blk_ma_stylecolorattributes
      set cc_buy_period_descr = null,
          cc_vpn_buy_period = null
    where product in (select id from blk_h_prodstd where ancestor0 = new.product);

  else

    select ancestor2 
    into v_dept
    from blk_h_prodstd bhp 
    where id = new.product; 

    update blk_ma_styleattributes 
      set sty_dpt_buy_period = v_dept || '_' || sty_buy_period_descr
    where product = new.product;

    update blk_ma_stylecolorattributes
      set cc_buy_period_descr = new.sty_buy_period_descr
    where product in (select id from blk_h_prodstd where ancestor0 = new.product);

  end if;  

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.set_sty_dpt_buy_period() OWNER TO psql;

--
-- TOC entry 2151 (class 1255 OID 129294817)
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
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from blk_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';
EXECUTE s1;
s2 := '
  update blk_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';
EXECUTE s2;
s3 := '
  update blk_ma_sizeattributes a
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
-- TOC entry 2152 (class 1255 OID 129294818)
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
  s9 text;
  
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
  , lookup_value as ccrangecode,target_value as master_size_attr, uuid_generate_v4()::text as memberid, 0::int as member_exists 
  from blk_l_dependencylookup 
  where 
  lookup_id=''ccrangecode''
  and lookup_value= '''||v_ccrangecode||'''
    ';
s2 := '
  update '||table_temp_rangecode_master||' a set memberid = b.product, member_exists=1 from blk_ma_sizeattributes b 
  where a.product=b.parent_id and a.master_size_attr=b.sizeattribute
  ';
s3 := '
  update blk_ma_sizeattributes set isvalid=0 where parent_id='''||v_product||'''
  ';
s4 := '
  delete from blk_ma_sizeattributes where product in (select memberid from '||table_temp_rangecode_master||')
  ';
s5 := ' 
  insert into blk_ma_sizeattributes (product, sizeattribute, parent_id, isvalid)
  select memberid, master_size_attr, product, 1 as isvalid from '||table_temp_rangecode_master||' 
  ';
s6 := '
  delete from blk_d_product where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0)
  ';
s6x := '
  insert into blk_d_product (id, name, description, levelid) select memberid, product||''-''||master_size_attr, product||''-''||master_size_attr, ''stylecolorsize'' 
  from  '||table_temp_rangecode_master||' 
  where member_exists=0
  ';
s7 := '
  delete from blk_h_prodstd where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0);
  insert into blk_h_prodstd 
  (id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,ancestor8,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state) 
  select 
  memberid,id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
  from blk_h_prodstd a, (select memberid,product from  '||table_temp_rangecode_master||'  where member_exists=0) b
  where a.id=b.product
  ';
s8 := '
  update blk_ma_stylecolorchannelattributes a
  set validsizes=b.validsizes
  from (select product, location, array_agg(master_size_attr) as validsizes from  '||table_temp_rangecode_master||'  group by product, location) b
  where a.product=b.product and a.location=b.location
  ';
s9 := '
  update blk_p_dc_adj_size a
  set dc_useradj=null
  where product in (select product from blk_ma_sizeattributes where isvalid = 0 and parent_id='''||v_product||''')
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
EXECUTE s9;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_validsizes_members() OWNER TO psql;

--
-- TOC entry 2153 (class 1255 OID 129294819)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DROP TABLE IF EXISTS temp_new;
    DROP TABLE IF EXISTS temp_old;

    --------------------------------------------------------------------------
    -- 1) Create temporary tables (temp_new, temp_old)
    --------------------------------------------------------------------------

    CREATE TEMPORARY TABLE temp_new AS
    SELECT
        b.product,
        b.location,
        a.indx,
        a.time
    FROM
        blk_ma_dptflrsetattributes a,
        blk_ma_stylecolorchannelattributes b
    WHERE
        a.product IN (SELECT ancestor3 FROM blk_h_prodstd WHERE id = NEW.product)
        AND b.product = NEW.product
        AND b.location = NEW.location
        AND slsstart <= GREATEST(NEW.exitdate, COALESCE(NEW.relaunch_exitdate, NEW.exitdate))
        AND slsend >= LEAST(NEW.dbt_wk, COALESCE(NEW.relaunch_dbt_wk, NEW.dbt_wk))
    ORDER BY indx;


    CREATE TEMPORARY TABLE temp_old AS
    SELECT
        a.product,
        a.location,
        str_grade,
        str_segmentation,
        str_sub_segmentation,
        str_aa_ind,
        str_hisp_ind,
        str_lifestyle_01,
        str_lifestyle_02,
        str_lifestyle_03,
        str_lifestyle_04,
        str_climate,
        str_state,
        ssg,
        flnrange,
        plan_type,
        style,
        indx,
        isfunded,
        store_count,
        str_grade_or,
        str_segmentation_or,
        str_sub_segmentation_or,
        str_aa_ind_or,
        str_hisp_ind_or,
        str_lifestyle_01_or,
        str_lifestyle_02_or,
        str_lifestyle_03_or,
        str_lifestyle_04_or,
        str_climate_or,
        str_state_or
    FROM
        blk_a_assortment a,
        blk_ma_dptflrsetattributes b
    WHERE
        b.product IN (SELECT ancestor3 FROM blk_h_prodstd WHERE id = NEW.product)
        AND a.product = NEW.product
        AND a.location = NEW.location
        AND a.time = b.time;

    --------------------------------------------------------------------------
    -- 2) Delete relevant records in blk_a_assortment before re-inserting
    --------------------------------------------------------------------------
    DELETE FROM blk_a_assortment
    WHERE product = NEW.product
      AND location = NEW.location
      /* AND plan_type = 'plan'  <-- commented, maybe intentionally */
      AND EXISTS (SELECT 1 FROM temp_new);

    --------------------------------------------------------------------------
    -- 3) Re-insert records in blk_a_assortment (in 3 segments)
    --------------------------------------------------------------------------

    -- (a) Insert from the “lowest indx” in temp_old combined with temp_new
    INSERT INTO blk_a_assortment
    (
       product, location, time,
       str_grade, str_segmentation, str_sub_segmentation,
       str_aa_ind, str_hisp_ind,
       str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
       str_climate, str_state,
       ssg, flnrange, plan_type, style, isfunded, store_count,
       str_grade_or, str_segmentation_or, str_sub_segmentation_or,
       str_aa_ind_or, str_hisp_ind_or,
       str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
       str_lifestyle_04_or, str_climate_or, str_state_or
    )
    SELECT
        a.product,
        a.location,
        c.time,
        str_grade, str_segmentation, str_sub_segmentation,
        str_aa_ind, str_hisp_ind,
        str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
        str_climate, str_state,
        ssg, flnrange, plan_type, style, isfunded, store_count,
        str_grade_or, str_segmentation_or, str_sub_segmentation_or,
        str_aa_ind_or, str_hisp_ind_or,
        str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
        str_lifestyle_04_or, str_climate_or, str_state_or
    FROM temp_old a
    JOIN temp_new c
      ON a.product = c.product
     AND a.location = c.location
    WHERE a.product || a.location || a.indx IN (
        SELECT product || location || MIN(indx)
        FROM temp_old
        GROUP BY product, location
    )
    AND c.indx < a.indx;

    -- (b) Insert from the “highest indx” in temp_old combined with temp_new
    INSERT INTO blk_a_assortment
    (
       product, location, time,
       str_grade, str_segmentation, str_sub_segmentation,
       str_aa_ind, str_hisp_ind,
       str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
       str_climate, str_state,
       ssg, flnrange, plan_type, style, isfunded, store_count,
       str_grade_or, str_segmentation_or, str_sub_segmentation_or,
       str_aa_ind_or, str_hisp_ind_or,
       str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
       str_lifestyle_04_or, str_climate_or, str_state_or
    )
    SELECT
        a.product,
        a.location,
        c.time,
        str_grade, str_segmentation, str_sub_segmentation,
        str_aa_ind, str_hisp_ind,
        str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
        str_climate, str_state,
        ssg, flnrange, plan_type, style, isfunded, store_count,
        str_grade_or, str_segmentation_or, str_sub_segmentation_or,
        str_aa_ind_or, str_hisp_ind_or,
        str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
        str_lifestyle_04_or, str_climate_or, str_state_or
    FROM temp_old a
    JOIN temp_new c
      ON a.product = c.product
     AND a.location = c.location
    WHERE a.product || a.location || a.indx IN (
        SELECT product || location || MAX(indx)
        FROM temp_old
        GROUP BY product, location
    )
    AND c.indx > a.indx
    ORDER BY c.indx;

    -- (c) Insert where indx values line up exactly
    INSERT INTO blk_a_assortment
    (
       product, location, time,
       str_grade, str_segmentation, str_sub_segmentation,
       str_aa_ind, str_hisp_ind,
       str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
       str_climate, str_state,
       ssg, flnrange, plan_type, style, isfunded, store_count,
       str_grade_or, str_segmentation_or, str_sub_segmentation_or,
       str_aa_ind_or, str_hisp_ind_or,
       str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
       str_lifestyle_04_or, str_climate_or, str_state_or
    )
    SELECT
        a.product,
        a.location,
        c.time,
        str_grade, str_segmentation, str_sub_segmentation,
        str_aa_ind, str_hisp_ind,
        str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04,
        str_climate, str_state,
        ssg, flnrange, plan_type, style, isfunded, store_count,
        str_grade_or, str_segmentation_or, str_sub_segmentation_or,
        str_aa_ind_or, str_hisp_ind_or,
        str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or,
        str_lifestyle_04_or, str_climate_or, str_state_or
    FROM temp_old a
    JOIN temp_new c
      ON a.product = c.product
     AND a.location = c.location
    WHERE c.indx = a.indx;

    --------------------------------------------------------------------------
    -- 4) Cleanup temp tables
    --------------------------------------------------------------------------
    DROP TABLE temp_new;
    DROP TABLE temp_old;

    --------------------------------------------------------------------------
    -- 5) Make first floorset “funded”
    --------------------------------------------------------------------------
    UPDATE blk_a_assortment
    SET isfunded = 1
    FROM
    (
        SELECT d.time, c.product, c.dbt_wk, d.slsstart, d.slsend
        FROM blk_ma_stylecolorchannelattributes AS c
        JOIN
        (
            SELECT DISTINCT a.time, a.product, b.slsstart, b.slsend
            FROM blk_a_assortment a
            JOIN
            (
                SELECT c.time, slsstart, slsend
                FROM blk_ma_dptflrsetattributes c
            ) AS b
            ON (a.time = b.time)
            WHERE a.product = NEW.product
        ) AS d
        ON (c.product = d.product)
        WHERE c.dbt_wk >= d.slsstart
          AND c.dbt_wk <= d.slsend
    ) AS filtered
    WHERE blk_a_assortment.time = filtered.time
      AND blk_a_assortment.product = filtered.product;


    --------------------------------------------------------------------------
    -- 6) Find Gap Floorsets between Exit and Relaunch and mark then unfunded
    --------------------------------------------------------------------------

    UPDATE blk_a_assortment a
    SET isfunded = 0
    FROM (
          SELECT
              b.product,
              b.location,
              a.indx,
              a.time
          FROM
              blk_ma_dptflrsetattributes a,
              blk_ma_stylecolorchannelattributes b
          WHERE
              a.product IN (SELECT ancestor3 FROM blk_h_prodstd WHERE id = NEW.product)
              AND b.product = NEW.product
              AND b.location = NEW.location
              AND slsstart > NEW.exitdate
              AND slsend < NEW.relaunch_dbt_wk
          ORDER BY indx
        ) b
    WHERE
        a.product=b.product
        and a.time=b.time
        and a.location=b.location
    ;


    RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 2154 (class 1255 OID 129294821)
-- Name: test_1(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.test_1(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE
    s1 text;
    v_uuid_temp text;
    v_uuid text;
    table_input_t1 text;
    ref refcursor;
BEGIN
    EXECUTE '(select 1::text)' INTO v_uuid_temp;
    EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' INTO v_uuid;

    table_input_t1 := 'input_t1_'||v_uuid;

    s1 := 'create table '||table_input_t1||' as select '''||input_jsessionid||''' as jsid,'''||scope_product||''' as scope_product,'''||scope_location||''' as scope_location,'''||scope_start||''' as scope_start,'''||scope_floorset||''' as scope_floorset';
    
    EXECUTE s1;
    
    OPEN ref FOR EXECUTE 'SELECT * FROM ' || table_input_t1;
    
    RETURN ref;
END;
$$;


ALTER FUNCTION public.test_1(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2155 (class 1255 OID 129294822)
-- Name: test_2(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.test_2(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
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
s21_x text;
s22 text;
s23 text;
s24 text;
s25 text;
s26 text;
--s26_X text;
s27 text;
s28 text;
s28_1 text;
s28_X text;
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

BEGIN



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


s1 := 'create table '||table_input_t1||' as select '''||$1||''' as jsid,'''||$2||''' as scope_product,'''||$3||''' as scope_location ,'''||$4||''' as scope_start,'''||$5||''' as scope_floorset
    ';

-- delete from debug_stats_ts where stat_id='s1';

s2 := '
    create table '||table_cart_master_temp||' as
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
    ,  null::text cccolorid
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

s3 := '
    create table '||table_cart_style||' as
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
    from blk_h_prodstd b
    where
    b.id = a.incoming_style_id
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from blk_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from blk_d_product b
    where
    b.id = a.subclass_id
    ';



s5 := '
    create table '||table_cart_stylecolor||' as
    select jsessionid
    , style_sequence
    , case when stylecolor_type = ''similar'' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = ''similar'' then style_name||''.''||cccolorid else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = ''similar'' then style_description ||'' ''||cccolordesc else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    , cccolorid
    , cccolordesc
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, a.cccolor,
    b.cccolorid, b.cccolordesc
    , style_name, style_description, stylecolor_name, stylecolor_description
    from '||table_cart_master_temp||' a, (select attributekey as cccolorid, attributevalue as cccolordesc, attributekey || '' '' || attributevalue as cccolor from blk_v_memberbasedvalidvalues where attributeid = ''cccolorid'') b 
    where a.cccolor = b.cccolor and jsessionid in (select jsid from '||table_input_t1||')
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
    and a.cccolor=b.cccolor
    and a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.stylecolor_type=b.stylecolor_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    '
    ;



s7 := '
    CREATE table '||table_cart_stylecolorsize||' AS
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
         , size_member_id
         , source_member_id
         , source_member_name
         , sku_dropship_indicator
         , sku_replenishment_flag
         , sku_extended_size
         , sku_status
         , isvalid
    FROM   (SELECT
           a.incoming_stylecolor_id
           , a.incoming_style_id
           , b.product stylecolorsize_id
           , b.parent_id
           , null as size_member_id
           , b.sizeattribute
           , null as source_member_id
           , b.source_member_name
           , b.sku_dropship_indicator
           , b.sku_replenishment_flag
           , b.sku_extended_size
           , b.sku_status
           , b.isvalid
           , a.jsessionid
           , a.style_type
           , a.stylecolor_type
           , a.final_style_id
           , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                 , blk_ma_sizeattributes b
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x
          '
          ;




s8 := 'delete from blk_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';


s9 := '
    INSERT INTO blk_d_product
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
delete from blk_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s11 := '
    INSERT INTO blk_d_product
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
delete from blk_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s13 := '
    INSERT INTO blk_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT final_stylecolorsize_id            AS id
           , size_name        AS NAME
           , size_description AS description
           , ''stylecolorsize'' AS levelid
    FROM   '||table_cart_stylecolorsize||'
    WHERE stylecolor_type=''similar''
    '
    ;



-- CREATING HIERARCHY

s14 := '
delete from blk_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


s15 := '
INSERT INTO blk_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from blk_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
'
;



s16 := '
delete from blk_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO blk_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6 from blk_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
'
;



s18 := '
delete from blk_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO blk_h_prodstd
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
blk_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s20 := '
delete from blk_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from blk_l_dependencylookup b where b.lookup_id = ''cccolor'' and b.target_id=''cccolorfamily'' and lookup_value=a.cccolor
';

s21_x := '
update '||table_cart_master_temp||' a set cccolorid = b.attributekey from blk_v_memberbasedvalidvalues b where b.attributeid = ''cccolorid'' and attributekey || '' '' || attributevalue=a.cccolor
';


s22 := '
delete from blk_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s23 := '
delete from blk_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';





s24 := '
insert into blk_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';


s25 := '
insert into blk_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- STYLE ATTRIBUTES

S26 := '
INSERT INTO blk_ma_styleattributes
            (product      
            ,sty_vpn
            ,sty_supplier_number
            ,sty_supplier_name
            ,sty_size_range
            ,sty_style_type
            ,ccstylecreatedate
            ,sty_style_status
            ,supp_supplier_site_id
            ,supp_supplier_name
            ,supp_parent_supplier_id
            ,supp_parent_supplier_name
            ,supp_status
            ,supp_class_group
            ,supp_brand_mindset
            ,supp_brand_type
            ,supp_brand
            ,supp_priceband
            ,supp_bi_flg
            ,supp_grp_parent_id
            ,supp_grp_standard_id
            ,supp_grp_brand_id
            ,supp_ninebox
            ,supp_lifestyle
            ,supp_direct_ship_ind
            ,class_group_id
            ,class_group_name
            ,dpt_department_id
            ,dpt_gmm_id
            ,dpt_gmm_desc
            ,dpt_dmm_id
            ,dpt_dmm_desc
            ,dpt_buyer_id
            ,dpt_buyer_desc
            ,dpt_sr_planner_id
            ,dpt_sr_planner_desc
            ,dpt_planner_id
            ,dpt_planner_desc
            ,dpt_dir_id
            ,dpt_dir_desc
            ,dpt_vp_id
            ,dpt_vp_desc
            ,dpt_svp_id
            ,dpt_svp_desc
            ,dpt_evp_id
            ,dpt_evp_desc
            ,dpt_marketplace_indicator
            ,dpt_memo_dept_indicator
            ,dpt_royalty_pct
            ,sty_s5_adopted
            ,sty_vpn_id_non_plm
            )
SELECT final_style_id as product
            ,null as sty_vpn
            ,null as sty_supplier_number
            ,null as sty_supplier_name
            ,b.sty_size_range
            ,sty_style_type
            --,b.ccstylecreatedate
            ,null as ccstylecreatedate  --Inherting ccstylecreatedate from similar style will restrict the user from editing the style id and desc; so we set it to null until it is created in client host system
            ,b.sty_style_status
            ,null as supp_supplier_site_id
            ,null as supp_supplier_name
            ,null as supp_parent_supplier_id
            ,null as supp_parent_supplier_name
            ,null as supp_status
            ,null as supp_class_group
            ,null as supp_brand_mindset
            ,null as supp_brand_type
            ,null as supp_brand
            ,null as supp_priceband
            ,null as supp_bi_flg
            ,null as supp_grp_parent_id
            ,null as supp_grp_standard_id
            ,null as supp_grp_brand_id
            ,null as supp_ninebox
            ,null as supp_lifestyle
            ,null as supp_direct_ship_ind
            ,b.class_group_id
            ,b.class_group_name
            ,b.dpt_department_id
            ,b.dpt_gmm_id
            ,b.dpt_gmm_desc
            ,b.dpt_dmm_id
            ,b.dpt_dmm_desc
            ,b.dpt_buyer_id
            ,b.dpt_buyer_desc
            ,b.dpt_sr_planner_id
            ,b.dpt_sr_planner_desc
            ,b.dpt_planner_id
            ,b.dpt_planner_desc
            ,b.dpt_dir_id
            ,b.dpt_dir_desc
            ,b.dpt_vp_id
            ,b.dpt_vp_desc
            ,b.dpt_svp_id
            ,b.dpt_svp_desc
            ,b.dpt_evp_id
            ,b.dpt_evp_desc
            ,b.dpt_marketplace_indicator
            ,b.dpt_memo_dept_indicator
            ,b.dpt_royalty_pct
            ,''Y''
            ,b.sty_vpn_id_non_plm
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name from '||table_cart_master_temp||') a, blk_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
';

/*
s26_X := '
Update blk_ma_styleattributes b
set pim_size_run_id = sty_size_run_id, pim_size_run_name = sty_size_run_name, sty_is_locked = ''Y'', sty_s5_adopted = ''Y''
from (select distinct final_style_id, style_type, incoming_style_id  from '||table_cart_master_temp||') a
where a.incoming_style_id=b.product
and a.style_type=''existing''
';
*/


-- STYLECOLOR ATTRIBUTES

s27 := '
delete from blk_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



s28 := '
INSERT INTO blk_ma_stylecolorattributes
        (product
        ,cc_initial_launch_month
        ,cccolor
        ,cc_diff_type
        ,cc_color_desc
        ,cc_colorfamily_code
        ,cccolorfamily
        ,cc_merch_color_name
        ,cc_vpn
        ,cc_vpn_color
        ,cc_first_rec_week
        ,cc_first_inv_week
        ,cc_first_sale_week
        ,cc_first_md_week
        ,cc_last_md_week
        ,cc_msrp
        ,cc_current_retail
        ,ccstylecolorcreatedate
        ,cc_dropship_indicator
        ,cc_replenishemnt_indicator
        ,cc_selling_season
        ,cc_selling_year
        ,cc_segment_buy
        ,cc_silhouette
        ,cc_subcategory
        ,cc_program_name
        ,cc_print_vs_solid
        ,cc_sleeve_length
        ,cc_fashion_vs_basic
        ,cc_top_length
        ,cc_denim_rise
        ,cc_bottom_fit
        ,cc_dress_length
        ,cc_neckline
        ,cc_inseam
        ,cc_lounge_vs_sleep
        ,cc_bottom_silo
        ,cc_robe
        ,cc_print_type
        ,cc_fit_solution
        ,cc_d_cup_available
        ,cc_occasion
        ,cc_categories
        ,cc_cut_fit
        ,cc_construction
        ,cc_bridal_registry
        ,cc_levi_fits
        ,cc_graphic_type
        ,cc_classification
        ,cc_young_contemporary
        ,cc_short_inseam
        ,cc_denim_trends
        ,cc_collegiate
        ,cc_set
        ,cc_material
        ,cc_configuration
        ,cc_bedding_accessories
        ,cc_fabric_description
        ,cc_black_friday_ind
        ,cc_superbuy_ind
        ,cc_aa_ind
        ,cc_coastal_ind
        ,cc_lodge_ind
        ,cc_white_dinnerware_ind
        ,cc_customer_need
        ,cc_fashion_jewelry
        ,cc_material_color
        ,cc_material_type
        ,cc_jewelry_presentation
        ,cc_necklaces
        ,cc_texture_pattern
        ,cc_high_value_status
        ,cc_fine_jewelry_metal
        ,cc_stone
        ,cc_bridal
        ,cc_metal_type
        ,cc_chain_type
        ,cc_bracelets
        ,cc_ears
        ,cc_ring
        ,cc_dial_color
        ,cc_watch
        ,cc_dtw_fine_jewelry
        ,cc_gold_mkt_fine_jewelry
        ,cc_grams_fine_jewelry
        ,cc_silver_mkt_fine_jewelry
        ,cc_silver_grams
        ,cc_ctw_fine_jewelry
        ,cc_shoe_type
        ,cc_shaft_height
        ,cc_outsole
        ,cc_closure
        ,cc_toe_type
        ,cc_sole_type
        ,cc_toe_character
        ,cc_heel_type
        ,cc_heel_height
        ,cc_fabric_type
        ,cc_width
        ,cc_tech_features
        ,cc_skechers_division
        ,cc_level_of_presentation
        ,cc_fragrance_scents
        ,cc_total_makeup
        ,cc_makeup_total_face
        ,cc_total_fragrance
        ,cc_makeup_total_lip
        ,cc_total_skincare
        ,cc_makeup_total_eye
        ,cc_skincare_total_face
        ,cc_styclr_status
        ,cc_skulist_id
        ,cc_skulist_desc
        ,total_brand_name
        ,division_name
        ,group_name
        ,department_name
        ,class_name
        ,subclass_name
        ,cc_s5_adopted
        ,cc_nrf_color_code_non_plm
        ,cc_nrf_color_desc_non_plm
        ,isassortment
        ,cccolorid
        )
SELECT final_stylecolor_id as product
        ,b.cc_initial_launch_month
        ,a.cccolor
        ,b.cc_diff_type
        ,b.cc_color_desc
        ,b.cc_colorfamily_code
        ,a.cccolorfamily
        ,null as cc_merch_color_name
        ,null as cc_vpn
        ,null as cc_vpn_color
        ,null as cc_first_rec_week
        ,null as cc_first_inv_week
        ,null as cc_first_sale_week
        ,null as cc_first_md_week
        ,null as cc_last_md_week
        ,b.cc_msrp
        ,b.cc_msrp -- set cc_current_retail = msrp for new items
        --,b.ccstylecolorcreatedate
        ,null as ccstylecolorcreatedate   --Inherting ccstylecolorcreatedate from similar stylecolor will restrict the user from removing the stylecolor; so we set it to null until it is created in client host system
        ,b.cc_dropship_indicator
        ,b.cc_replenishemnt_indicator
        ,b.cc_selling_season
        ,b.cc_selling_year
        ,b.cc_segment_buy
        ,b.cc_silhouette
        ,b.cc_subcategory
        ,b.cc_program_name
        ,b.cc_print_vs_solid
        ,b.cc_sleeve_length
        ,b.cc_fashion_vs_basic
        ,b.cc_top_length
        ,b.cc_denim_rise
        ,b.cc_bottom_fit
        ,b.cc_dress_length
        ,b.cc_neckline
        ,b.cc_inseam
        ,b.cc_lounge_vs_sleep
        ,b.cc_bottom_silo
        ,b.cc_robe
        ,b.cc_print_type
        ,b.cc_fit_solution
        ,b.cc_d_cup_available
        ,b.cc_occasion
        ,b.cc_categories
        ,b.cc_cut_fit
        ,b.cc_construction
        ,b.cc_bridal_registry
        ,b.cc_levi_fits
        ,b.cc_graphic_type
        ,b.cc_classification
        ,b.cc_young_contemporary
        ,b.cc_short_inseam
        ,b.cc_denim_trends
        ,b.cc_collegiate
        ,b.cc_set
        ,b.cc_material
        ,b.cc_configuration
        ,b.cc_bedding_accessories
        ,b.cc_fabric_description
        ,b.cc_black_friday_ind
        ,b.cc_superbuy_ind
        ,b.cc_aa_ind
        ,b.cc_coastal_ind
        ,b.cc_lodge_ind
        ,b.cc_white_dinnerware_ind
        ,b.cc_customer_need
        ,b.cc_fashion_jewelry
        ,b.cc_material_color
        ,b.cc_material_type
        ,b.cc_jewelry_presentation
        ,b.cc_necklaces
        ,b.cc_texture_pattern
        ,b.cc_high_value_status
        ,b.cc_fine_jewelry_metal
        ,b.cc_stone
        ,b.cc_bridal
        ,b.cc_metal_type
        ,b.cc_chain_type
        ,b.cc_bracelets
        ,b.cc_ears
        ,b.cc_ring
        ,b.cc_dial_color
        ,b.cc_watch
        ,b.cc_dtw_fine_jewelry
        ,b.cc_gold_mkt_fine_jewelry
        ,b.cc_grams_fine_jewelry
        ,b.cc_silver_mkt_fine_jewelry
        ,b.cc_silver_grams
        ,b.cc_ctw_fine_jewelry
        ,b.cc_shoe_type
        ,b.cc_shaft_height
        ,b.cc_outsole
        ,b.cc_closure
        ,b.cc_toe_type
        ,b.cc_sole_type
        ,b.cc_toe_character
        ,b.cc_heel_type
        ,b.cc_heel_height
        ,b.cc_fabric_type
        ,b.cc_width
        ,b.cc_tech_features
        ,b.cc_skechers_division
        ,b.cc_level_of_presentation
        ,b.cc_fragrance_scents
        ,b.cc_total_makeup
        ,b.cc_makeup_total_face
        ,b.cc_total_fragrance
        ,b.cc_makeup_total_lip
        ,b.cc_total_skincare
        ,b.cc_makeup_total_eye
        ,b.cc_skincare_total_face
        ,b.cc_styclr_status
        ,b.cc_skulist_id
        ,b.cc_skulist_desc
        ,b.total_brand_name
        ,b.division_name
        ,b.group_name
        ,b.department_name
        ,b.class_name
        ,b.subclass_name
        ,''Y''
        ,b.cc_nrf_color_code_non_plm
        ,b.cc_nrf_color_desc_non_plm
        ,''true''
        ,a.cccolorid
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, cccolorid  from '||table_cart_master_temp||') a, blk_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
';



s28_X := '
Update blk_ma_stylecolorattributes b
set isassortment = ''true'', cc_is_locked = ''Y'', cc_s5_adopted = ''Y''
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily,cccolorid  from '||table_cart_master_temp||') a
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
';

s28_Y := '
Update blk_ma_stylecolorattributes b
set cc_vpn = sty_vpn
from 
(
        select distinct final_style_id, final_stylecolor_id, y.sty_vpn
                                        from '||table_cart_master_temp||' x
                                        join blk_ma_styleattributes y
                                        on x.final_style_id = y.product
                                        where x.style_type = ''existing''
) a
where a.final_stylecolor_id=b.product
';


-- IMAGE ATTRIBUTES START

s29 := 'drop table if exists '||table_ma_imgattr||'';

s29_1 := '
create table '||table_spec_img||' as
select
 distinct si.product, si.img, sa.product as style_id
from blk_specimages si
 inner join
blk_ma_styleattributes sa
 on sa.product = si.product
where sa.product in (select final_style_id from '||table_cart_master_temp||' where jsessionid in (select jsid from '||table_input_t1||'));
';

s30 := '
create table '||table_ma_imgattr||' as
select
    c.jsessionid
  , c.final_stylecolor_id as product
  , b.img as orig_image
  , c.img as cart_image
  , d.img as spec_image
FROM
  (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, img from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')) c
 LEFT JOIN
  (select distinct product, img from blk_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, style_id from '||table_spec_img||') d
on
d.style_id = c.final_style_id;

'
;


s31 := '
delete from blk_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;

s32 := '
insert into blk_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES

s33 := '
delete from blk_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';



s34 := '
insert into blk_ma_sizeattributes
    (product,
    parent_id,
    size_member_id,
    sizeattribute,
    source_member_id,
    source_member_name,
    sku_dropship_indicator,
    sku_replenishment_flag,
    sku_extended_size,
    sku_status,
    isvalid
    )
SELECT
    distinct final_stylecolorsize_id,
    final_stylecolor_id,
    size_member_id,
    size_name,
    source_member_id,
    source_member_name,
    sku_dropship_indicator,
    sku_replenishment_flag,
    sku_extended_size,
    sku_status,
    isvalid

FROM
    '||table_cart_stylecolorsize||'
WHERE stylecolor_type = ''similar''
';


PERFORM get_default_params(''||$1||'',''||$2||'',''||$3||'',''||$4||'',''||$5||'');

-- STYLECOLOR CHANNEL ATTRIBUTES

s35 := '
create table '||table_default_cart_params||' as
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
  , a.ccrcptint as default_ccrcptint
  , a.ccordermultiple as default_ccordermultiple
  , a.ccordpolicy as default_ccordpolicy
  , a.slsrnk
  , a.planned_sell_down_week
from (select distinct * from cart_params) a, blk_ma_dptflrsetattributes c, '||table_input_t1||' b
where a.jsessionid = b.jsid
and a.scope_product = b.scope_product
and a.scope_location = b.scope_location
and a.scope_start = b.scope_start
and a.scope_product = c.product
and a.scope_floorset = c.time
'
;


s36 := '
create  table '||table_temp_sclr_chnl_attr||' as
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

  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  , coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , cc_validsizes_store
  , cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , cc_existingwac
  , cc_systemcost
  , cc_landed_cost -- needs to go into cc_target_cost
  , a.slsrnk
  , cc_imupct
  , null::real as cc_return_u_pct
  , cc_plan_cost
  , cc_target_cost
  , a.planned_sell_down_week
FROM
'||table_default_cart_params||' a, blk_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||' where style_type = ''similar'') c
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location
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

  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  , coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , cc_validsizes_store
  , cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , cc_existingwac
  , cc_systemcost
  , cc_landed_cost
  , a.slsrnk
  , cc_imupct
  , null::real as cc_return_u_pct
  , cc_plan_cost
  , cc_target_cost
  , a.planned_sell_down_week
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id, style_type from '||table_cart_master_temp||' where style_type = ''existing'') b,
blk_ma_styleattributes c, 
--blk_ma_stylecolorattributes d,
blk_ma_stylecolorchannelattributes e 
--(select array_agg(target_value) as validsizes, lookup_value as sty_size_run_name from blk_l_dependencylookup where lookup_id = ''size_range'' group by lookup_value) e
where a.jsessionid=b.jsessionid 
and b.final_style_id = c.product 
--and b.final_stylecolor_id = d.product 
and b.incoming_stylecolor_id = e.product
and a.scope_location = e.location
--and c.sty_size_range = e.sty_size_run_name
'
;



s37 := '
delete from blk_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into blk_ma_stylecolorchannelattributes (
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
, cc_ordpolicy
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
, cc_existingwac
, cc_systemcost
, cc_landed_cost
, slsrnk
, cc_return_u_pct
, cc_plan_cost
, cc_target_cost
, planned_sell_down_week
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
, cc_ordpolicy
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
, cc_existingwac
, cc_systemcost
, cc_landed_cost
, slsrnk
, cc_return_u_pct
, cc_plan_cost
, cc_target_cost
, planned_sell_down_week
FROM
 '||table_temp_sclr_chnl_attr||'
 ';




-- ASSORTMENT MODEL

s51 := '
update blk_ma_stylecolorchannelattributes a
set
  cc_discount_pct = default_discount
--, ccmdstrategy = default_md
, plan_current = v_plan_current
from (select id, ancestor3, default_discount, /*default_md,*/ v_plan_current from blk_h_prodstd a, default_disc_md b, (select value as v_plan_current from blk_serviceparams where id=''plan_current'') c  where a.ancestor3=b.department) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
and a.product=b.id
';

-- When adding a color to an exsting style, we will take the max of various attributes and cost for the parent style and apply them to the newly added stylecolor
s51_1 := '
update blk_ma_stylecolorchannelattributes a
set
  ccrangecode = rangecode
 ,cc_validsizes_store = cc_validsizes_store_existing
 ,cc_validsizes_ecom = cc_validsizes_ecom_existing
 ,ccticketpricechannel = cast(coalesce(cc_current_retail::real, .01) as real)
 ,cc_ordpolicy = cc_ordpolicy_existing
 ,cc_ordermultiple = cc_ordermultiple_existing
 ,cc_existingwac = cast(coalesce(cc_existingwac_existing::real,0.0) as real)
 ,cc_systemcost = cast(coalesce(cc_systemcost_existing::real,0.0) as real)
 ,cc_plan_cost = cast(coalesce(cc_plan_cost_existing::real,0.0) as real)
 ,cc_landed_cost = cast(coalesce(cc_landed_cost_existing::real,0.0) as real)
 ,cc_target_cost = cast(coalesce(cc_target_cost_existing::real,0.0) as real)
 --,cc_imupct = coalesce(round((((cc_current_retail::real-coalesce(cc_actual_cost,cc_estimated_cost)::real)/cc_current_retail::real)::numeric), 2)::real,0.0)::real
from 
(
  select x.sty_size_range || '' - '' || y.ancestor2 as rangecode, a.cc_validsizes_store_existing, a.cc_validsizes_ecom_existing, style_type, cc_current_retail, a.cc_ordpolicy_existing, a.cc_ordermultiple_existing, a.cc_existingwac_existing, 
        a.cc_systemcost_existing, a.cc_plan_cost_existing,a.cc_landed_cost_existing, a.cc_target_cost_existing
  from 
    blk_ma_styleattributes x, 
    blk_h_prodstd y, 
    blk_ma_stylecolorattributes d,
    (
      select distinct final_stylecolor_id, final_style_id, style_type 
      from  '||table_cart_master_temp||' 
      where jsessionid in (select jsid from  '||table_input_t1||') and style_type = ''existing''
    ) z,
    (
      select a.ancestor0, max(b.cc_validsizes_store) as cc_validsizes_store_existing, max(b.cc_validsizes_ecom) as cc_validsizes_ecom_existing, max(b.cc_ordpolicy) as cc_ordpolicy_existing, 
             max(b.cc_ordermultiple) as cc_ordermultiple_existing, max(b.cc_existingwac) as cc_existingwac_existing, max(b.cc_systemcost) as cc_systemcost_existing, max(b.cc_plan_cost) as cc_plan_cost_existing, 
             max(b.cc_landed_cost) as cc_landed_cost_existing, max(b.cc_target_cost) as cc_target_cost_existing
      from blk_h_prodstd a
      join blk_ma_stylecolorchannelattributes b
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



s39 := '
    create table '||table_temp_assort||' AS
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(str_grade as text[]) as str_grade
        , cast(str_segmentation as text[]) as str_segmentation
        , cast(str_sub_segmentation as text[]) as str_sub_segmentation
        , cast(str_aa_ind as text[]) as str_aa_ind
        , cast(str_hisp_ind as text[]) as str_hisp_ind
        , cast(str_lifestyle_01 as text[]) as str_lifestyle_01
        , cast(str_lifestyle_02 as text[]) as str_lifestyle_02
        , cast(str_lifestyle_03 as text[]) as str_lifestyle_03
        , cast(str_lifestyle_04 as text[]) as str_lifestyle_04
        , cast(str_climate as text[]) as str_climate
        , cast(str_state as text[]) as str_state       
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , store_count
        , d.cc_msrp as a_msrp
        , d.cc_msrp as a_current_retail
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c,
    blk_ma_stylecolorattributes d
    where a.jsessionid=c.jsessionid
    and a.jsessionid = b.jsid
    and a.scope_product = b.scope_product
    and a.scope_location = b.scope_location
    and a.scope_start = b.scope_start
    and c.final_stylecolor_id = d.product
    '
    ;



s40 := '
delete from blk_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';



s41 := '

    insert into blk_a_assortment (
          product
        , location
        , "time"
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , a_msrp
        , a_current_retail)
    SELECT
          product
        , location
        , "time"
        , str_grade
        , str_segmentation
        , str_sub_segmentation
        , str_aa_ind
        , str_hisp_ind
        , str_lifestyle_01
        , str_lifestyle_02
        , str_lifestyle_03
        , str_lifestyle_04
        , str_climate
        , str_state
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , store_count
        , style
        , a_msrp
        , a_current_retail
    FROM
       '||table_temp_assort||'
';

s41_1 := '
update blk_ma_stylecolorattributes a
set
  cc_initial_launch_month = floorset
from (select min(time) as floorset from '||table_temp_assort||') b
where a.product in (select distinct final_stylecolor_id from '||table_cart_master_temp||')
';



RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

s42 := '
create table '||table_final_list||' AS
select distinct a.product, a.location
from
(select distinct product,location  from blk_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from blk_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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


s100 := 'CREATE table '||tst_df_temp||' AS
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
          FROM blk_ma_stylecolorchannelattributes AS a
          , blk_d_time AS b
          WHERE (id >= COALESCE(relaunchweek,dbt_wk)) AND (id <= exitdate) AND product in (select product from '||table_temp_sclr_chnl_attr||')
          ORDER BY
              product ASC,
              id ASC
          ';

s101 := 'CREATE table '||tst_md_seq||' AS
          SELECT
              *,
              row_number() OVER (PARTITION BY product ORDER BY time ASC) AS seq
          FROM '||tst_df_temp||'
          WHERE price_status = ''MD''
          ';

s102 := 'CREATE table '||tst_df||' AS
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

s103 := 'CREATE table '||tst_df_with_style||' AS
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
              FROM blk_h_prodstd
              WHERE id IN
              (
                  SELECT product
                  FROM '||tst_df||'
              )
          ) AS b
          WHERE a.product = b.id
          ';


s104 := 'CREATE table '||tst_md_tktp_md||' as
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
            (select a.* from '||tst_df_with_style||' a, blk_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.cc_current_retail::real, curp=cc_current_retail::real
          from blk_ma_stylecolorattributes b
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
          from blk_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff
          from blk_p_itemprice b
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

S_PRE_110_1 := 'CREATE table '||table_xt_flag||' AS
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, blk_d_time b, blk_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from blk_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from blk_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from blk_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from blk_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from blk_ma_weekattributes b where a.time=b.time';



s111 := 'CREATE table '||table_xt||' AS
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
              FROM (select * from blk_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM blk_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM blk_ma_dptflrsetattributes AS a
              , blk_d_time AS b
              WHERE (b.id >= a.ap_start) AND (b.id <= a.ap_end)
          ) AS y
          WHERE (x.department = y.department) AND (x.floorset = y.floorset)
        ) z
        ';
/*
s112 := 'CREATE table '||table_yt||' AS
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
s113 := 'CREATE table '||table_zt_pre||' AS
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
          WHERE time >= (select value from blk_serviceparams where id=''plan_current'')
          AND time <= (select value from blk_serviceparams where id=''plan_end'')
        ';

s113_1 := 'CREATE table '||table_zt_flow_flag||'
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

s113_2 := 'CREATE table '||table_zt||'
           AS
           select a.*, flow_flag from '||table_zt_pre||' a, '||table_zt_flow_flag||' b
           WHERE a.product=b.product and a.selling_channel=b.selling_channel and a.time=b.time
           ';


s114 := 'delete from blk_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into blk_an_price_storecount_info
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


RAISE NOTICE 'INPUT:%', 'START:'|| now();
RAISE NOTICE 's1:%', s1;
RAISE NOTICE 's2:%', s2;
RAISE NOTICE 's3:%', s3;
RAISE NOTICE 's4_1:%', s4_1;
RAISE NOTICE 's5:%', s5;
RAISE NOTICE 's6:%', s6;
RAISE NOTICE 's7:%', s7;


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
RAISE NOTICE 's21_x: %', s21_x;
RAISE NOTICE 's22: %', s22;
RAISE NOTICE 's23: %', s23;
RAISE NOTICE 's24: %', s24;
RAISE NOTICE 's25: %', s25;
RAISE NOTICE 's26: %', s26;
RAISE NOTICE 's26_X: %', s26_X;
RAISE NOTICE 's27: %', s27;
RAISE NOTICE 's28: %', s28;
RAISE NOTICE 's28_X: %', s28_X;
RAISE NOTICE 's28_Y: %', s28_Y;
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
RAISE NOTICE 's41_1: %', s41_1;

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


-- s110_6 :=  'drop table if exists tst_md_tktp_md';
-- s110_7 :=  'create table tst_md_tktp_md as select * from '||tst_md_tktp_md||'';
-- s110_8 :=  'drop table if exists table_zt';
-- s110_9 :=  'create table table_zt as select * from '||table_zt||'';
-- insert into trigger_test_delete_me values ('s0:', clock_timestamp());
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
EXECUTE s21_x;
-- insert into trigger_test_delete_me values ('s21_x:', clock_timestamp());
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
--EXECUTE s26_X;
-- insert into trigger_test_delete_me values ('s26_X:', clock_timestamp());
EXECUTE s27;
-- insert into trigger_test_delete_me values ('s27:', clock_timestamp());
EXECUTE s28;
-- insert into trigger_test_delete_me values ('s28:', clock_timestamp());
EXECUTE s28_X;
-- insert into trigger_test_delete_me values ('s28_X:', clock_timestamp());
EXECUTE s28_Y;
-- insert into trigger_test_delete_me values ('s28_Y:', clock_timestamp());
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
EXECUTE s51_1;
-- insert into trigger_test_delete_me values ('s51_1:', clock_timestamp());
EXECUTE s39;
-- insert into trigger_test_delete_me values ('s39:', clock_timestamp());
EXECUTE s40;
-- insert into trigger_test_delete_me values ('s40:', clock_timestamp());
EXECUTE s41;
-- insert into trigger_test_delete_me values ('s41:', clock_timestamp());
EXECUTE s41_1;
-- insert into trigger_test_delete_me values ('s41_1:', clock_timestamp());
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


ALTER FUNCTION public.test_2(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2156 (class 1255 OID 129294824)
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
-- TOC entry 2188 (class 1255 OID 134254642)
-- Name: trigger_img_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_img_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

 begin
  -- Scenario: design image comes through, but user has selcted hold_img
  -- Result:   the img_held will stay as-is
  IF (NEW.img <> OLD.img AND NEW.img NOT LIKE '%scene7%' AND OLD.hold_img = 'YES')
  THEN 
    update blk_ma_imgattributes
    set 
          img_from_etl = NEW.img
        , img = coalesce(img_held, NEW.img)
    where product = NEW.product
    ;
  END IF
  ;

  -- Scenario: hold_img not selected and image changes
  -- Result: - img_from_etl updated to whatever the old image was
  --         - img is set to the new image
  IF (NEW.img <> OLD.img AND NEW.img NOT LIKE '%scene7%' AND (OLD.hold_img is null OR OLD.hold_img = ''))
  THEN 
    -- New image will overwrite previous image
    update blk_ma_imgattributes
    set 
          img_from_etl = OLD.img
        , img = NEW.img
    where product = NEW.product
    ;
  END IF
  ;

  -- ECOM image comes through and will override everything
  -- User would be able to override this during the day, but once batch runs the ECOM image will replace it
  IF (NEW.img <> OLD.img AND NEW.img LIKE '%scene7%' AND OLD.hold_img = 'YES')
  THEN 
    update blk_ma_imgattributes
    set 
          hold_img = null
        , img_held = null  
        , img = NEW.img
        , img_from_etl = NEW.img
    where product = NEW.product
    ;
  END IF
  ;

  RETURN NEW;
  END;
  $$;


ALTER FUNCTION public.trigger_img_update() OWNER TO psql;

--
-- TOC entry 2184 (class 1255 OID 134254641)
-- Name: trigger_set_held_img(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_held_img() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

 -- If user chooses to hold the image, then set img_held value to whatever is set in the img column
 -- img will be set to null TEMPORARILY (will get set further down in code)
  IF ((OLD.hold_img = '' OR OLD.hold_img is null) AND NEW.hold_img = 'YES')
  THEN
    UPDATE blk_ma_imgattributes 
    SET 
          img_held = img
        , img = null
    WHERE product = NEW.product
    ;
  END IF
  ; 

 -- If user chooses to NOT hold the image, then set img_held null
 -- Again, img will be set to null TEMPORARILY
  IF (OLD.hold_img = 'YES' AND (NEW.hold_img = '' OR NEW.hold_img is null))
  THEN
    UPDATE blk_ma_imgattributes 
    SET 
          img_held = null
        , img = null  
    WHERE product = NEW.product
    ;
  END IF
  ;

  -- Regardless of hold_img being true/false, update img to first non-null of img_held and img_from_etl
    -- If img_held flips from YES to blank then img_from_etl will be used to set img
  UPDATE blk_ma_imgattributes
  SET
      img = COALESCE(img_held, img_from_etl)
  WHERE product = NEW.product
  ;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_held_img() OWNER TO psql;

--
-- TOC entry 2157 (class 1255 OID 129294825)
-- Name: trigger_set_indx_l_dependency(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_l_dependency() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.index is null)
then
 select max(index) into maxIndx from blk_l_dependencylookup;
 new.index = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_l_dependency() OWNER TO psql;

--
-- TOC entry 2158 (class 1255 OID 129294826)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from blk_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 2159 (class 1255 OID 129294827)
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
 END IF; 
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 2160 (class 1255 OID 129294828)
-- Name: trigger_set_size_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_size_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare curSizeId integer;
BEGIN
IF (NEW.size_member_id is null or new.size_member_id = '99999')
then
    select size_id into curSizeId from size_ids si where si.size_name = new.sizeattribute;
    new.size_member_id = curSizeId;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_size_id() OWNER TO psql;

--
-- TOC entry 2161 (class 1255 OID 129294829)
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
-- TOC entry 2162 (class 1255 OID 129294830)
-- Name: trigger_set_timestamp_pinchpo(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_timestamp_pinchpo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  update blk_p_pinchpo set updated_at = NOW()::timestamp(0)
  where po_id = NEW.po_id and product = NEW.product and location = NEW.location and time = NEW.time;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp_pinchpo() OWNER TO psql;

--
-- TOC entry 2163 (class 1255 OID 129294831)
-- Name: trigger_update_cost(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_update_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_target_cost real;
BEGIN

  update blk_ma_stylecolorchannelattributes
  set 
     cc_plan_cost   = NEW.cc_target_cost
    ,cc_landed_cost = NEW.cc_target_cost
    ,cc_systemcost  = NEW.cc_target_cost
    ,cc_existingwac = NEW.cc_target_cost
  where product = NEW.product
  ;

  select cc_target_cost 
  into v_target_cost
  from blk_ma_stylecolorchannelattributes where product = NEW.product;

  update blk_ma_stylecolorchannelattributes 
  set cc_imupct = coalesce(round(((NEW.ccticketpricechannel - v_target_cost) / NEW.ccticketpricechannel)::numeric, 2),0.0)
  where product = NEW.product;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_update_cost() OWNER TO psql;

--
-- TOC entry 2164 (class 1255 OID 129294832)
-- Name: undo_upload_ata(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.undo_upload_ata(v_uid text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

v_template_id  text;
v__txid text;
input_uid text;

BEGIN

delete from shadow_addtoassortment a where a.__uid=v_uid;
delete from staging_addtoassortment a where a.__uid=v_uid;
-- delete from upload_statistics a where a.__uid=input_uid;

RAISE NOTICE 'UNDO SUCCESSFUL';

RETURN;
END;
$$;


ALTER FUNCTION public.undo_upload_ata(v_uid text) OWNER TO psql;

--
-- TOC entry 2107 (class 1255 OID 129294833)
-- Name: unlock_style(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.unlock_style() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (NEW.cc_prepublish is false or NEW.cc_prepublish = 1::boolean) and (old.cc_prepublish is true or old.cc_prepublish = 0::boolean) and OLD.cc_is_locked is not null and OLD.ccstylecolorcreatedate is null then
	update blk_ma_styleattributes 
	set sty_is_locked = null,
      ccstylecreatedate = null -- Set create date super far in the future so that we know it's a temp lock
	where product = (select distinct ancestor0 from blk_h_prodstd where id = NEW.product)
  and sty_is_locked is not null
  and ccstylecreatedate = '3000-01-01';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.unlock_style() OWNER TO psql;

--
-- TOC entry 2108 (class 1255 OID 129294834)
-- Name: unlock_stylecolor(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.unlock_stylecolor() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (NEW.cc_prepublish = 'false' or NEW.cc_prepublish = '0' or NEW.cc_prepublish is null) and (OLD.cc_is_locked = 'true' or OLD.cc_is_locked = '1' or OLD.cc_is_locked is not null) and OLD.ccstylecolorcreatedate = '3000-01-01' then
	
  update blk_ma_stylecolorattributes
	set cc_is_locked = null,
      ccstylecolorcreatedate = null
	where product = NEW.product
  and cc_is_locked is not null
  and ccstylecolorcreatedate = '3000-01-01';

  -- Only unlock the style if all the stylecolors under it are not locked. If any stylecolors under the style are still locked then the style will remain locked
  update blk_ma_styleattributes
  set sty_is_locked = null,
      ccstylecreatedate = null
  where product = (select distinct ancestor0 from blk_h_prodstd where id = NEW.product)
  and sty_is_locked is not null
  and ccstylecreatedate = '3000-01-01'
  and product not in
  (
    select distinct style
    from
    (
    select sty.product as style, sty_is_locked, ccstylecreatedate, styclr.product as stylecolor, cc_is_locked, ccstylecolorcreatedate, cc_prepublish
    from blk_ma_styleattributes sty
    join blk_h_prodstd prd
    on sty.product = prd.ancestor0
    join blk_ma_stylecolorattributes styclr
    on styclr.product = prd.id
    where sty.product = (select distinct ancestor0 from blk_h_prodstd where id = NEW.product)
    and sty.sty_is_locked is not null
    and sty.ccstylecreatedate = '3000-01-01'
    and styclr.ccstylecolorcreatedate is not null
    ) style_unlock_check
  );

  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.unlock_stylecolor() OWNER TO psql;

--
-- TOC entry 2109 (class 1255 OID 129294835)
-- Name: update_cc_vpn(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_vpn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_cc_vpn text;
  v_index text;
  v_cc_vpn_color text;
  v_cc_vpn_color_desc text;
  v_style_type text;
  v_sty_vpn_buy_period text;
  v_cc_vpn_buy_period text;
  v_count integer;
BEGIN

select cc_vpn into v_cc_vpn from blk_ma_stylecolorattributes where product = NEW.product;
select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from blk_l_dependencylookup;
select distinct color_cd into v_cc_vpn_color from blk_specstyle_attr_week where color_cd || ': ' || color_descr = NEW.cc_vpn_color_display;
select distinct color_descr into v_cc_vpn_color_desc from blk_specstyle_attr_week where color_cd || ': ' || color_descr = NEW.cc_vpn_color_display;
select distinct sty_style_type into v_style_type from blk_ma_styleattributes where product in (select distinct ancestor0 from blk_h_prodstd where id = new.product);
select distinct sty_vpn_buy_period into v_sty_vpn_buy_period from blk_ma_styleattributes where product in (select distinct ancestor0 from blk_h_prodstd where id = new.product);
select distinct cc_vpn_buy_period into v_cc_vpn_buy_period from blk_ma_stylecolorattributes where product = new.product;

select count(*) 
into v_count
from blk_ma_stylecolorattributes 
where product <> NEW.product 
and cc_vpn_color_display = NEW.cc_vpn_color_display 
and cc_vpn_buy_period = NEW.cc_vpn_buy_period 
and NEW.cc_vpn_color_display is not null 
and NEW.cc_vpn_color_display <> '';

if v_style_type = 'PLM' then

  if v_count > 0 then 

    NEW.cc_vpn_color_display := OLD.cc_vpn_color_display;

    -- Set vpn back to the old value
    update blk_ma_stylecolorattributes 
    set cc_vpn_color_display = OLD.cc_vpn_color_display
    where product = NEW.product
    ;

  end if;

  if OLD.cc_vpn_color_display is not null and OLD.cc_vpn_color_display <> '' and v_count = 0
  then

    -- Insert color back into dependencylookup but only if it is not already assigned to another stylecolor (in the case of caching issue)
    insert into blk_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
    SELECT 'cc_vpn_buy_period', OLD.cc_vpn_buy_period, 'cc_vpn_color_display', OLD.cc_vpn_color_display, v_index
    from blk_ma_stylecolorattributes
    where product = NEW.product
    and (OLD.cc_vpn_buy_period, OLD.cc_vpn_color_display) not in (select lookup_value, target_value from blk_l_dependencylookup where lookup_id = 'cc_vpn_buy_period' and target_id = 'cc_vpn_color_display')
    and (OLD.cc_vpn_buy_period, OLD.cc_vpn_color_display) not in (select cc_vpn_buy_period, cc_vpn_color_display from blk_ma_stylecolorattributes where cc_vpn_color_display is not null and cc_vpn_color_display <> '' and PRODUCT <> NEW.product)
    ;

  end if;

  if NEW.cc_vpn_color_display is not null and NEW.cc_vpn_color_display <> '' and v_count = 0
  then
    
    delete from blk_l_dependencylookup 
    where lookup_id = 'cc_vpn_buy_period' and lookup_value = v_cc_vpn_buy_period 
      and target_id = 'cc_vpn_color_display' and target_value = NEW.cc_vpn_color_display;

	  update blk_ma_stylecolorattributes
	  set cc_vpn_color = v_cc_vpn_color
	  where product = NEW.product 
	  and cc_vpn_color_display = NEW.cc_vpn_color_display;
	
	  update blk_ma_stylecolorattributes
	  set cc_vpn_color_desc = v_cc_vpn_color_desc
	  where product = NEW.product 
	  and cc_vpn_color_display = NEW.cc_vpn_color_display;
	
	  -- Set cccolor; this should call another trigger to execute update_color_change
	  update blk_ma_stylecolorattributes
	  set cccolor = (select attributekey || ' ' || attributevalue from blk_v_memberbasedvalidvalues where attributeid = 'cccolorid' and attributekey = v_cc_vpn_color)
	  where product = NEW.product
	  ;
 
  end if;

  if (NEW.cc_vpn_color_display is null or NEW.cc_vpn_color_display = '')
  then
    update blk_ma_stylecolorattributes
    set cc_vpn_color = null
    where product = NEW.product;

    update blk_ma_stylecolorattributes
    set cc_vpn_color_desc = null
    where product = NEW.product;

    delete from blk_ma_stylecolorweekattributes where product = NEW.product;

   end if;

end if;  
  
  return NEW;
END;
$$;


ALTER FUNCTION public.update_cc_vpn() OWNER TO psql;

--
-- TOC entry 2110 (class 1255 OID 129294836)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

  v_style_description blk_d_product.description%type;
  v_style_name blk_d_product.name%type;

BEGIN

  select name, description into v_style_name, v_style_description 
  from blk_d_product where id = (select ancestor0 from blk_h_prodstd where id = NEW.product);

  select attributekey, attributevalue 
  into NEW.cccolorid, NEW.cc_color_desc
  from blk_v_memberbasedvalidvalues
  where attributeid = 'cccolorid' and attributekey = substr(NEW.cccolor, 1, (position(' ' in NEW.cccolor)) - 1);
 
     select target_value into NEW.cccolorfamily
    from blk_l_dependencylookup 
    where lookup_id = 'cccolor' and target_id = 'cccolorfamily' and lookup_value = NEW.cccolor;

    select target_value into NEW.cc_colorfamily_code
    from blk_l_dependencylookup 
    where lookup_id = 'cccolor' and target_id = 'cc_colorfamily_code' and lookup_value = NEW.cccolor;

  if NEW.cccolor is not null and NEW.cccolor <> '' then
    
  	update blk_ma_stylecolorattributes
  	set cccolorid = NEW.cccolorid
  	   ,cc_color_desc = NEW.cc_color_desc
  	   ,cc_colorfamily_code = NEW.cc_colorfamily_code
  	   ,cccolorfamily = new.cccolorfamily
  	where product = new.product;
  
    update blk_d_product 
    set description = v_style_description || ' ' || NEW.cc_color_desc,
        name = v_style_name || '.' || substring(NEW.cccolorid from '[^ ]+')
    where id = NEW.product;

  end if;
 
 if NEW.cccolor is null or NEW.cccolor = '' then
 	update blk_d_product 
    set description = v_style_description || ' No Color',
    name = v_style_name || '.NoColor'
    where id = NEW.product;

   update blk_ma_stylecolorattributes 
   set cccolorfamily = null
   	   ,cc_colorfamily_code = null
   	   ,cccolorid = null
   	   ,cc_color_desc = null
   where product = new.product;
 
 end if;
   
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 2111 (class 1255 OID 129294837)
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
 from blk_p_itemprice 
 where product=NEW.product and location=NEW.location and time=NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
 from blk_l_priceeventlookup 
 where product=NEW.department and location=NEW.location and ccpriceevent=NEW.event;

select cc_discount_pct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
 from blk_ma_stylecolorchannelattributes 
 where product=NEW.product and location=NEW.location;

select cc_msrp::real into v_ticketprice 
 from blk_ma_stylecolorattributes 
 where product =NEW.product;

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
update blk_p_itemprice a set eff_aur=final_eff_aur where product=NEW.product and location=NEW.location and time=NEW.time;

-- update blk_an_price_storecount_info set expressed_aur=final_eff_aur where product=NEW.product and channel=NEW.location and time=NEW.time
--   ;
-- 
-- update blk_an_price_storecount_info a
--   set v_A=b.v_A
-- FROM
--   (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A from blk_an_price_storecount_info a
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time) b
-- WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
-- ;
-- 
--   update blk_an_price_storecount_info a
--     set v_B=b.v_B
--   FROM
--     (select product, time, seq, addoff, corpaddoff
--       , case when seq=0 then
--           (case when final_eff_aur > 0 then final_eff_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
--        else curp end as v_B
--        from blk_an_price_storecount_info a 
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--     ) b
--   WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--   ;
-- 
-- update blk_an_price_storecount_info set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)
--   WHERE product=NEW.product and channel=NEW.location and time=NEW.time;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 2114 (class 1255 OID 129294838)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN


  if NEW.name <> OLD.name or NEW.description <> OLD.description then
    update blk_d_product x
    set description = NEW.description || ' ' || y.cc_color_desc,
        name = NEW.name || '.' || y.cccolorid
    from (select a.id, b.cccolorid, b.cc_color_desc from blk_h_prodstd a, blk_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
    where x.id = y.id;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 2115 (class 1255 OID 129294839)
-- Name: update_name_description_style(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description_style() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  if NEW.description <> OLD.description then
    update blk_d_product x
    set description = NEW.description
    from
    (
    	select distinct b.ancestor0
    	from blk_d_product a
		join blk_h_prodstd b
		on a.id = b.id
		where b.id = NEW.id
	) y
    where x.id = y.ancestor0;

	update blk_d_product x
    set description = sty_desc || ' ' || y.cc_color_desc
	from
	(
		select a.id, c.description as sty_desc, b.cccolorid, b.cc_color_desc
		from blk_h_prodstd a
		join blk_ma_stylecolorattributes b
		on a.id = b.product
		join blk_d_product c
		on a.ancestor0 = c.id
		where a.ancestor0 IN (select distinct ancestor0 from blk_h_prodstd where id = NEW.id)
	) y
    where x.id = y.id;


  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description_style() OWNER TO psql;

--
-- TOC entry 2116 (class 1255 OID 129294840)
-- Name: update_of_cc_vpn_buy_period(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_of_cc_vpn_buy_period() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  update blk_ma_stylecolorattributes
  set cc_vpn_buy_period = cc_vpn || '_' || NEW.cc_buy_period_descr,
      cc_vpn_color = null,
      cc_vpn_color_desc = null, 
      cc_vpn_color_display = null
  where product = NEW.product
  ;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_of_cc_vpn_buy_period() OWNER TO psql;

--
-- TOC entry 2117 (class 1255 OID 129294841)
-- Name: update_pim_style_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pim_style_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_subclass text;
  v_index text;
BEGIN

  select ancestor0 into v_subclass from blk_h_prodstd where id = NEW.product;
  select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from blk_l_dependencylookup;

  if OLD.pim_style_id <> NEW.pim_style_id
  then
    update blk_ma_stylecolorattributes set pim_stylecolor_id = null 
    where product in (select id from blk_h_prodstd where ancestor0 = NEW.product);

    if OLD.pim_style_id is not null 
    then
      insert into blk_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
      values('subclass', v_subclass, 'pim_style_id', OLD.pim_style_id, v_index);
    end if;

    if NEW.pim_style_id is not null
    then
      delete from blk_l_dependencylookup 
      where lookup_id = 'subclass' and lookup_value = v_subclass 
        and target_id = 'pim_style_id' and target_value = NEW.pim_style_id;

      select a.erp_style_id,a.sty_dept,a.sty_typ,a.sty_subtyp_1,a.sty_style_description,a.sty_vendor_id,a.sty_vendor_name,a.sty_brand_id,a.sty_brand_name,a.sty_source,a.sty_length_height,a.sty_neckline,a.sty_end_use,a.sty_knit_woven,a.sty_development_path,a.sty_product_type,a.sty_fabric_material,a.ccstylecreatedate,a.sty_closure,a.sty_hem_finish,a.sty_waist_rise,a.sty_size_run_name,a.sty_size_run_id
      into NEW.erp_style_id,NEW.sty_dept,NEW.sty_typ,NEW.sty_subtyp_1,NEW.sty_style_description,NEW.sty_vendor_id,NEW.sty_vendor_name,NEW.sty_brand_id,NEW.sty_brand_name,NEW.sty_source,NEW.sty_length_height,NEW.sty_neckline,NEW.sty_end_use,NEW.sty_knit_woven,NEW.sty_development_path,NEW.sty_product_type,NEW.sty_fabric_material,NEW.ccstylecreatedate,NEW.sty_closure,NEW.sty_hem_finish,NEW.sty_waist_rise,NEW.pim_size_run_name,NEW.pim_size_run_id
      from blk_ma_styleattributes a
      where a.product = NEW.pim_style_id;
    end if;
  end if;

  if NEW.sty_size_run_name = NEW.pim_size_run_name and NEW.erp_style_id is not null
  then
      NEW.sty_is_locked = 'Y';
  else
      NEW.sty_is_locked = null;
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_pim_style_id() OWNER TO psql;

--
-- TOC entry 2165 (class 1255 OID 129294842)
-- Name: update_pim_stylecolor_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pim_stylecolor_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_sty_size_run_name text;
  v_pim_size_run_name text;
BEGIN

  select sty_size_run_name, pim_size_run_name
    into v_sty_size_run_name, v_pim_size_run_name
  from blk_ma_styleattributes a, blk_h_prodstd b
  where a.product = b.ancestor0 and b.id = NEW.product;

  if OLD.pim_stylecolor_id <> NEW.pim_stylecolor_id and NEW.pim_stylecolor_id is not null
  then
      select a.erp_stylecolor_id,a.ccstylecolorcreatedate,a.cc_marketing,a.cc_floorset,a.cc_pim_status,a.cc_pim_first_available_date,a.cc_pim_discontinue_date,a.cc_first_inv_date,a.cc_last_rec_date,a.cc_weighted_rec_date,a.cc_first_md_date,a.cc_last_md_date,a.cc_pricing_tier,a.cc_image_url,a.cc_description,a.cc_c_mh_ss,a.cc_exclusive,a.cc_print_pattern,a.cc_denim_wash,a.cccolor,a.cccolorfamily,a.cc_color_code,a.cc_msrp,a.cc_current_price,a.cc_estimated_cost,a.cc_actual_cost,a.cc_style_group,a.cc_rtv,a.cc_fulfillment,a.cc_cc_plan,a.cc_flow
      into NEW.erp_stylecolor_id,NEW.ccstylecolorcreatedate,NEW.cc_marketing,NEW.cc_floorset,NEW.cc_pim_status,NEW.cc_pim_first_available_date,NEW.cc_pim_discontinue_date,NEW.cc_first_inv_date,NEW.cc_last_rec_date,NEW.cc_weighted_rec_date,NEW.cc_first_md_date,NEW.cc_last_md_date,NEW.cc_pricing_tier,NEW.cc_image_url,NEW.cc_description,NEW.cc_c_mh_ss,NEW.cc_exclusive,NEW.cc_print_pattern,NEW.cc_denim_wash,NEW.cccolor,NEW.cccolorfamily,NEW.cc_color_code,NEW.cc_msrp,NEW.cc_current_price,NEW.cc_estimated_cost,NEW.cc_actual_cost,NEW.cc_style_group,NEW.cc_rtv,NEW.cc_fulfillment,NEW.cc_cc_plan,NEW.cc_flow
      from blk_ma_stylecolorattributes a
      where a.product = NEW.pim_stylecolor_id;
  end if;

  if NEW.erp_stylecolor_id is not null and v_sty_size_run_name = v_pim_size_run_name
  then
      NEW.cc_is_locked = 'Y';
  else
      NEW.cc_is_locked = null;
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_pim_stylecolor_id() OWNER TO psql;

--
-- TOC entry 2166 (class 1255 OID 129294843)
-- Name: update_pinchpo_name_ecom(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pinchpo_name_ecom() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
v_uuid_temp text;
v_uuid text;

s1 text;
s1_x text;
s2 text;
s2_update text;
s3 text;
s3_update text;
s4 text;
s5 text;
s6 text;
s6_x text;
s7 text;
s7_x text;
s7_y text;
s8 text;
s9 text;
table_tmp_po_name_records text;
table_tmp_po_name_records_1 text;
table_tmp_po_name_records_2 text;
table_tmp_po_name_records_prefinal text;
table_tmp_po_name_records_final text;
table_tmp_po_name_records_prefinal_max text;

v_pinch_user_po_plan_name_ecom text;
v_po_id text;
v_product text;
v_location text;
v_time text;
v_pinch_id text;
v_max_groups integer;

BEGIN


EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_tmp_po_name_records := 'tmp_po_name_records'||v_uuid;
table_tmp_po_name_records_1 := 'tmp_po_name_records_1'||v_uuid;
table_tmp_po_name_records_2 := 'tmp_po_name_records_2'||v_uuid;
table_tmp_po_name_records_prefinal := 'tmp_po_name_records_prefinal'||v_uuid;
table_tmp_po_name_records_final := 'tmp_po_name_records_final'||v_uuid;
table_tmp_po_name_records_prefinal_max := 'tmp_po_name_records_prefinal_max'||v_uuid;

v_pinch_user_po_plan_name_ecom := NEW.pinch_user_po_plan_name_ecom;
v_po_id := NEW.po_id;
v_product := NEW.product;
v_location := NEW.location;
v_time := NEW.time;
v_pinch_id := NEW.pinch_id;
RAISE NOTICE 'OUTSIDE v_pinch_user_po_plan_name_ecom %', v_pinch_user_po_plan_name_ecom;
RAISE NOTICE 'OUTSIDE NEW.pinch_user_po_plan_name_ecom %', NEW.pinch_user_po_plan_name_ecom;
RAISE NOTICE 'OUTSIDE OLD.pinch_user_po_plan_name_ecom %', OLD.pinch_user_po_plan_name_ecom;

  /* Requirements
  1. When style colors have different PO Plan name.
  2. When style colors are having different Supplier Site even though it has same PO Plan name.
  3. For BI (Belk international), each style (inclusive of it’s colors) will be on a separate PO even if
     multiple styles have same PO Plan name.
  4. If NBD (Not Before Date) & NAD (Not After Date) is different with in a style’s colors or a
     group of styles/colors that have the same PO Plan name.
  5. If both BI & Domestic style colors are part of same PO Plan name.
  */


  -- Find if there are any products other than the current Stylecolor with same PO Name as this one
  -- Find if there are any other products with same PO name which belong to a different Style than this one and belong to Belk International - Using supp_bi_flg: Mark v_bi_error_count 
  -- Find If NAD and NBD are different. If yes change the PO Name.
  -- For NAD and NBD there can be 2 cases
  --       1. NAD and NBD are blank in Postgres. It is possible they have never been edited and that row was never written in PG. For this NAD and NBD will need to be found using column time
  --       2. NAD and NBD are pulled from Postgres
  -- Find count of v_supplier_error_count for all products with same PO Plan name: If count > 1 means there are diffent products with different Supplier. Need to change the PO Plan name in that case

--if coalesce(NEW.pinch_user_po_plan_name_ecom, '') <> coalesce(OLD.pinch_user_po_plan_name_ecom, '') then

   if NEW.pinch_user_po_plan_name_ecom is null or NEW.pinch_user_po_plan_name_ecom = '' then
     s8 := 'update blk_p_pinchpo set pinch_publish_po_plan_name_ecom = null
     where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || '''
     '
     ;

    RAISE NOTICE 'INSIDE s8 %', s8;

     EXECUTE s8;
     RETURN NEW;
   end if;

  RAISE NOTICE 'INSIDE OLD.pinch_user_po_plan_name_ecom %', OLD.pinch_user_po_plan_name_ecom;

  s1 := 'create temporary table ' || table_tmp_po_name_records || ' as
  select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
  from blk_p_pinchpo a, blk_h_prodstd b, blk_ma_styleattributes c where a.product = b.id and b.ancestor0 = c.product and pinch_user_po_plan_name_ecom = ''' || v_pinch_user_po_plan_name_ecom || '''';

  RAISE NOTICE 'INSIDE s1 %', s1;
  
  EXECUTE s1;

  --s1_x := 'insert into blk_po_name_records select * from ' || table_tmp_po_name_records;
  --EXECUTE s1_x;
  
  s2 := 'update ' || table_tmp_po_name_records || ' a
  set pinch_nbd = b.min_nbd
  from (
        select a.time, min(c2.date_id) as min_nbd, min(b2.date_id) min_nad 
        from (select distinct time from ' || table_tmp_po_name_records || ' where pinch_nbd is null or pinch_nbd = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx - 52
          and c.indx = a1.indx - 60
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nbd is null or pinch_nbd = ''''
  ';

   RAISE NOTICE 'INSIDE s2 %', s2;

  EXECUTE s2;


  s2_update := 'update blk_p_pinchpo a
  set pinch_nbd = b.pinch_nbd
  from ' || table_tmp_po_name_records || ' b
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and (a.pinch_nbd is null or a.pinch_id = '''')
  '
  ;
  
  RAISE NOTICE 'INSIDE s2_update %', s2_update;
  
  EXECUTE s2_update;

  
  s3 := 'update ' || table_tmp_po_name_records || ' a
  set pinch_nad = b.min_nad
  from (
        select a.time, min(c2.date_id) as min_nbd, min(b2.date_id) min_nad 
        from (select distinct time from ' || table_tmp_po_name_records || ' where pinch_nad is null or pinch_nad = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx - 52
          and c.indx = a1.indx - 60
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nad is null or pinch_nad = ''''
  ';

  RAISE NOTICE 'INSIDE s3 %', s3;

  EXECUTE s3;


  s3_update := 'update blk_p_pinchpo a
  set pinch_nad = b.pinch_nad
  from ' || table_tmp_po_name_records || ' b
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and (a.pinch_nad is null or a.pinch_nad = '''')
  '
  ;
  
  RAISE NOTICE 'INSIDE s3_update %', s3_update;
  
  EXECUTE s3_update;

  
  s4 := 'create temporary table ' || table_tmp_po_name_records_1 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, a.style, supp_bi_flg, supp_supplier_site_id, 
        rnk_style
   from ' || table_tmp_po_name_records || ' a
   join (select style, row_number() over() as rnk_style from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style) b on a.style = b.style
   where supp_bi_flg = ''Y''
  ),
  step2 as
  (select a.*, rnk_style_supp
   from step1 a
   join (select style, supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd
   from step2 a
   join (select style, supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step4 as
  (select a.*, rnk_style_supp_nbd_nad
   from step3 a
   join (select style, supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step4
  ';

  RAISE NOTICE 'INSIDE s4 %', s4;

  EXECUTE s4;


  s5 := 'create temporary table ' || table_tmp_po_name_records_2 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, style, supp_bi_flg, a.supp_supplier_site_id, 1 as rnk_style,
        rnk_style_supp
   from ' || table_tmp_po_name_records || ' a
   join (select supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id) b on a.supp_supplier_site_id = b.supp_supplier_site_id
   where supp_bi_flg = ''N''
  ),
  step2 as
  (select a.*, rnk_style_supp_nbd
   from step1 a
   join (select supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd_nad
   from step2 a
   join (select supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step3
  ';

  RAISE NOTICE 'INSIDE s5 %', s5;

  EXECUTE s5;

  s6 := 'create temporary table ' || table_tmp_po_name_records_prefinal || ' as
  select * from ' || table_tmp_po_name_records_1 || '
  union all
  select * from ' || table_tmp_po_name_records_2;

  RAISE NOTICE 'INSIDE s6 %', s6;

  EXECUTE s6;

  --s6_x := 'insert into blk_po_name_records_prefinal select * from ' || table_tmp_po_name_records_prefinal;
  --EXECUTE s6_x;

  s7 := 'create temporary table ' || table_tmp_po_name_records_final || ' as
  with t as
  (select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_ecom, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
         case when a.supp_bi_flg = ''Y'' then a.pinch_user_po_plan_name_ecom || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id || '':'' || a.style
         else a.pinch_user_po_plan_name_ecom || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id 
         end as new_pinch_publish_po_plan_name_ecom,
         b.pinch_publish_po_plan_name_ecom as exiting_pinch_publish_po_plan_name_ecom
  from ' || table_tmp_po_name_records_prefinal || ' a, blk_p_pinchpo b where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  )
  select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_ecom, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
      a.new_pinch_publish_po_plan_name_ecom as pinch_publish_po_plan_name_ecom
      from (select * from t) as a
  --from (select * from t where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || ''') as a
  ';

  RAISE NOTICE 's7 %', s7;

  EXECUTE s7;

  --s7_x := 'insert into blk_po_name_records_final select * from ' || table_tmp_po_name_records_final;
  --EXECUTE s7_x;

  s7_y := 'create temporary table ' || table_tmp_po_name_records_prefinal_max || ' as
  select product, po_id, supp_supplier_site_id, pinch_nbd, pinch_nad, rnk_style_supp_nbd_nad, case when rnk_style_supp_nbd_nad = 1 then ''YES'' else ''NO'' end as use_user_po_plan_name 
  from ' || table_tmp_po_name_records_prefinal
  ;

  RAISE NOTICE 'INSIDE s7_y %', s7_y;

  EXECUTE s7_y;

  s8 := 'update blk_p_pinchpo a
  --set pinch_publish_po_plan_name_ecom = case when c.max_groups > 1 then b.pinch_publish_po_plan_name_ecom else ''' || NEW.pinch_user_po_plan_name_ecom || ''' end
  set pinch_publish_po_plan_name_ecom = case when c.use_user_po_plan_name = ''NO'' then b.pinch_publish_po_plan_name_ecom else ''' || NEW.pinch_user_po_plan_name_ecom || ''' end
  from ' || table_tmp_po_name_records_final || ' b, ' || table_tmp_po_name_records_prefinal_max || ' c
  where a.po_id = c.po_id and a.product = c.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and a.pinch_nbd = c.pinch_nbd and a.pinch_nad = c.pinch_nad
  and a.product = b.product and a.po_id = b.po_id
  '
  ;

  RAISE NOTICE 'INSIDE s8 %', s8;
  
  EXECUTE s8;

  --s9 := 'insert into sync_pg_ch select ''blk_p_pinchpo'', product, location, time, pinch_id from ' || table_tmp_po_name_records_final || ' a where not exists (select 1 from sync_pg_ch b where a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id)';

  --EXECUTE s9;

  
--end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pinchpo_name_ecom() OWNER TO psql;

--
-- TOC entry 2167 (class 1255 OID 129294845)
-- Name: update_pinchpo_name_empty(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pinchpo_name_empty() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
 
  if NEW.pinch_user_po_plan_name_store = '' then 
    update blk_p_pinchpo
    set 
    	pinch_user_po_plan_name_store = null
       ,pinch_publish_po_plan_name_store = null
    where product = NEW.product 
    and po_id = NEW.po_id
    and location = NEW.location
    and time = NEW.time
    and pinch_id = NEW.pinch_id
    ;
  end if;

  if NEW.pinch_user_po_plan_name_ecom = '' then 
    update blk_p_pinchpo
    set 
    	pinch_user_po_plan_name_ecom = null
       ,pinch_publish_po_plan_name_ecom = null
    where product = NEW.product 
    and po_id = NEW.po_id
    and location = NEW.location
    and time = NEW.time
    and pinch_id = NEW.pinch_id
    ;
  end if;
 
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pinchpo_name_empty() OWNER TO psql;

--
-- TOC entry 2168 (class 1255 OID 129294846)
-- Name: update_pinchpo_name_nad_nbd(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pinchpo_name_nad_nbd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_uuid_temp text;
v_uuid text;

s1 text;
s1_x text;
s2 text;
s3 text;
s4 text;
s5 text;
s6 text;
s7 text;
s7_x text;
s7_y text;
s8 text;
s9 text;
table_tmp_po_name_records_store text;
table_tmp_po_name_records_store_1 text;
table_tmp_po_name_records_store_2 text;
table_tmp_po_name_records_store_prefinal text;
table_tmp_po_name_records_store_final text;
table_tmp_po_name_records_store_prefinal_max text;
table_tmp_po_name_records_ecom text;
table_tmp_po_name_records_ecom_1 text;
table_tmp_po_name_records_ecom_2 text;
table_tmp_po_name_records_ecom_prefinal text;
table_tmp_po_name_records_ecom_final text;
table_tmp_po_name_records_ecom_prefinal_max text;

v_pinch_user_po_plan_name_store text;
v_pinch_user_po_plan_name_ecom text;
v_po_id text;
v_product text;
v_location text;
v_time text;
v_pinch_id text;
BEGIN
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_tmp_po_name_records_store := 'tmp_po_name_records_store'||v_uuid;
table_tmp_po_name_records_store_1 := 'tmp_po_name_records_store_1'||v_uuid;
table_tmp_po_name_records_store_2 := 'tmp_po_name_records_store_2'||v_uuid;
table_tmp_po_name_records_store_prefinal := 'tmp_po_name_records_store_prefinal'||v_uuid;
table_tmp_po_name_records_store_final := 'tmp_po_name_records_store_final'||v_uuid;
table_tmp_po_name_records_store_prefinal_max := 'tmp_po_name_records_store_prefinal_max'||v_uuid;

table_tmp_po_name_records_ecom          := 'tmp_po_name_records_ecom'||v_uuid;
table_tmp_po_name_records_ecom_1        := 'tmp_po_name_records_ecom_1'||v_uuid;
table_tmp_po_name_records_ecom_2        := 'tmp_po_name_records_ecom_2'||v_uuid;
table_tmp_po_name_records_ecom_prefinal := 'tmp_po_name_records_ecom_prefinal'||v_uuid;
table_tmp_po_name_records_ecom_final    := 'tmp_po_name_records_ecom_final'||v_uuid;
table_tmp_po_name_records_ecom_prefinal_max := 'tmp_po_name_records_ecom_prefinal_max'||v_uuid;

v_pinch_user_po_plan_name_store := NEW.pinch_user_po_plan_name_store;
v_pinch_user_po_plan_name_ecom := NEW.pinch_user_po_plan_name_ecom;
v_po_id := NEW.po_id;
v_product := NEW.product;
v_location := NEW.location;
v_time := NEW.time;
v_pinch_id := NEW.pinch_id;


if coalesce(NEW.pinch_nad, '') <> coalesce(OLD.pinch_nad, '') or coalesce(NEW.pinch_nbd, '') <> coalesce(OLD.pinch_nbd, '') then

  s1 := 'create temporary table ' || table_tmp_po_name_records_store || ' as
  select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
  from blk_p_pinchpo a, blk_h_prodstd b, blk_ma_styleattributes c where a.product = b.id and b.ancestor0 = c.product 
  and pinch_user_po_plan_name_store in (select pinch_user_po_plan_name_store from blk_p_pinchpo 
  where po_id = ''' || v_po_id || ''' 
  and product =  ''' || v_product || ''' 
  and location = ''' || v_location || ''' 
  and time = ''' || v_time || ''' 
  and pinch_id = ''' || v_pinch_id || '''
  )
  ';

  --RAISE NOTICE 'INSIDE s1 %', s1;
  
  EXECUTE s1;

  --s1_x := 'insert into blk_po_name_records select * from ' || table_tmp_po_name_records_store;

  --EXECUTE s1_x;
  
  s2 := 'update ' || table_tmp_po_name_records_store || ' a
  set pinch_nbd = b.min_nbd
  from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
        from (select distinct time from ' || table_tmp_po_name_records_store || ' where pinch_nbd is null or pinch_nbd = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx + 4
          and c.indx = a1.indx - 4
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nbd is null or pinch_nbd = ''''
  ';

  --RAISE NOTICE 'INSIDE s2 %', s2;

  EXECUTE s2;
  
  s3 := 'update ' || table_tmp_po_name_records_store || ' a
  set pinch_nad = b.min_nad
  from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
        from (select distinct time from ' || table_tmp_po_name_records_store || ' where pinch_nad is null or pinch_nad = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx + 4
          and c.indx = a1.indx - 4
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nad is null or pinch_nad = ''''
  ';

  --RAISE NOTICE 'INSIDE s3 %', s3;

  EXECUTE s3;
  
  s4 := 'create temporary table ' || table_tmp_po_name_records_store_1 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, a.style, supp_bi_flg, supp_supplier_site_id, 
        rnk_style
   from ' || table_tmp_po_name_records_store || ' a
   join (select style, row_number() over() as rnk_style from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''Y'' group by style) b on a.style = b.style
   where supp_bi_flg = ''Y''
  ),
  step2 as
  (select a.*, rnk_style_supp
   from step1 a
   join (select style, supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd
   from step2 a
   join (select style, supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step4 as
  (select a.*, rnk_style_supp_nbd_nad
   from step3 a
   join (select style, supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step4
  ';

  --RAISE NOTICE 'INSIDE s4 %', s4;

  EXECUTE s4;


  s5 := 'create temporary table ' || table_tmp_po_name_records_store_2 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, style, supp_bi_flg, a.supp_supplier_site_id, 1 as rnk_style,
        rnk_style_supp
   from ' || table_tmp_po_name_records_store || ' a
   join (select supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id) b on a.supp_supplier_site_id = b.supp_supplier_site_id
   where supp_bi_flg = ''N''
  ),
  step2 as
  (select a.*, rnk_style_supp_nbd
   from step1 a
   join (select supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd_nad
   from step2 a
   join (select supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records_store || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step3
  ';

   --RAISE NOTICE 'INSIDE s5 %', s5;


  EXECUTE s5;

  s6 := 'create temporary table ' || table_tmp_po_name_records_store_prefinal || ' as
  select * from ' || table_tmp_po_name_records_store_1 || '
  union all
  select * from ' || table_tmp_po_name_records_store_2;

  --RAISE NOTICE 'INSIDE s6 %', s6;

  EXECUTE s6;

  s7 := 'create temporary table ' || table_tmp_po_name_records_store_final || ' as
  with t as
  (select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_store, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
         case when a.supp_bi_flg = ''Y'' then a.pinch_user_po_plan_name_store || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id || '':'' || a.style
         else a.pinch_user_po_plan_name_store || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id 
         end as new_pinch_publish_po_plan_name_store,
         b.pinch_publish_po_plan_name_store as exiting_pinch_publish_po_plan_name_store
  from ' || table_tmp_po_name_records_store_prefinal || ' a, blk_p_pinchpo b where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  )
  select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_store, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
      a.new_pinch_publish_po_plan_name_store as pinch_publish_po_plan_name_store
  from (select * from t where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || ''') as a
  ';

  --RAISE NOTICE 'INSIDE s7 %', s7;

  EXECUTE s7;

  --s7_x := 'insert into blk_po_name_records_final select * from ' || table_tmp_po_name_records_store_final;
  --EXECUTE s7_x;

  s7_y := 'create temporary table ' || table_tmp_po_name_records_store_prefinal_max || ' as
  select max(rnk_style_supp_nbd_nad) as max_groups from ' || table_tmp_po_name_records_store_prefinal
  ;

  --RAISE NOTICE 'INSIDE s7_y %', s7_y;

  EXECUTE s7_y;

  if NEW.pinch_user_po_plan_name_store is not null and NEW.pinch_user_po_plan_name_store <> '' then

  s8 := 'update blk_p_pinchpo a
  set pinch_publish_po_plan_name_store = case when c.max_groups > 1 then b.pinch_publish_po_plan_name_store else ''' || NEW.pinch_user_po_plan_name_store || ''' end
  from ' || table_tmp_po_name_records_store_final || ' b, ' || table_tmp_po_name_records_store_prefinal_max || ' c
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  '
  ;

  --RAISE NOTICE 'INSIDE s8 %', s8;

  EXECUTE s8;

  end if;

  --s9 := 'insert into sync_pg_ch select ''blk_p_pinchpo'', product, location, time, pinch_id from ' || table_tmp_po_name_records_store_final || ' a where not exists (select 1 from sync_pg_ch b where a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id)';

  --EXECUTE s9;


  s1 := 'create temporary table ' || table_tmp_po_name_records_ecom || ' as
  select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
  from blk_p_pinchpo a, blk_h_prodstd b, blk_ma_styleattributes c where a.product = b.id and b.ancestor0 = c.product 
  and pinch_user_po_plan_name_ecom in (select pinch_user_po_plan_name_ecom from blk_p_pinchpo 
  where po_id = ''' || v_po_id || ''' 
  and product =  ''' || v_product || ''' 
  and location = ''' || v_location || ''' 
  and time = ''' || v_time || ''' 
  and pinch_id = ''' || v_pinch_id || '''
  )
  ';

  --RAISE NOTICE 'INSIDE s1 %', s1;
  
  EXECUTE s1;

  --s1_x := 'insert into blk_po_name_records select * from ' || table_tmp_po_name_records_ecom;

  --EXECUTE s1_x;
  
  s2 := 'update ' || table_tmp_po_name_records_ecom || ' a
  set pinch_nbd = b.min_nbd
  from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
        from (select distinct time from ' || table_tmp_po_name_records_ecom || ' where pinch_nbd is null or pinch_nbd = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx + 4
          and c.indx = a1.indx - 4
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nbd is null or pinch_nbd = ''''
  ';

  --RAISE NOTICE 'INSIDE s2 %', s2;

  EXECUTE s2;
  
  s3 := 'update ' || table_tmp_po_name_records_ecom || ' a
  set pinch_nad = b.min_nad
  from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
        from (select distinct time from ' || table_tmp_po_name_records_ecom || ' where pinch_nad is null or pinch_nad = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx + 4
          and c.indx = a1.indx - 4
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nad is null or pinch_nad = ''''
  ';

  --RAISE NOTICE 'INSIDE s3 %', s3;

  EXECUTE s3;
  
  s4 := 'create temporary table ' || table_tmp_po_name_records_ecom_1 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, a.style, supp_bi_flg, supp_supplier_site_id, 
        rnk_style
   from ' || table_tmp_po_name_records_ecom || ' a
   join (select style, row_number() over() as rnk_style from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''Y'' group by style) b on a.style = b.style
   where supp_bi_flg = ''Y''
  ),
  step2 as
  (select a.*, rnk_style_supp
   from step1 a
   join (select style, supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd
   from step2 a
   join (select style, supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step4 as
  (select a.*, rnk_style_supp_nbd_nad
   from step3 a
   join (select style, supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step4
  ';

  --RAISE NOTICE 'INSIDE s4 %', s4;

  EXECUTE s4;


  s5 := 'create temporary table ' || table_tmp_po_name_records_ecom_2 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, style, supp_bi_flg, a.supp_supplier_site_id, 1 as rnk_style,
        rnk_style_supp
   from ' || table_tmp_po_name_records_ecom || ' a
   join (select supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id) b on a.supp_supplier_site_id = b.supp_supplier_site_id
   where supp_bi_flg = ''N''
  ),
  step2 as
  (select a.*, rnk_style_supp_nbd
   from step1 a
   join (select supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd_nad
   from step2 a
   join (select supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records_ecom || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step3
  ';

  --RAISE NOTICE 'INSIDE s5 %', s5;

  EXECUTE s5;

  s6 := 'create temporary table ' || table_tmp_po_name_records_ecom_prefinal || ' as
  select * from ' || table_tmp_po_name_records_ecom_1 || '
  union all
  select * from ' || table_tmp_po_name_records_ecom_2;

  --RAISE NOTICE 'INSIDE s6 %', s6;

  EXECUTE s6;

  s7 := 'create temporary table ' || table_tmp_po_name_records_ecom_final || ' as
  with t as
  (select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_ecom, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
         case when a.supp_bi_flg = ''Y'' then a.pinch_user_po_plan_name_ecom || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id || '':'' || a.style
         else a.pinch_user_po_plan_name_ecom || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id 
         end as new_pinch_publish_po_plan_name_ecom,
         b.pinch_publish_po_plan_name_ecom as exiting_pinch_publish_po_plan_name_ecom
  from ' || table_tmp_po_name_records_ecom_prefinal || ' a, blk_p_pinchpo b where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  )
  select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_ecom, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
      a.new_pinch_publish_po_plan_name_ecom as pinch_publish_po_plan_name_ecom
  from (select * from t where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || ''') as a
  ';

  --RAISE NOTICE 'INSIDE s7 %', s7;

  EXECUTE s7;

  --s7_x := 'insert into blk_po_name_records_final select * from ' || table_tmp_po_name_records_ecom_final;
  --EXECUTE s7_x;

  s7_y := 'create temporary table ' || table_tmp_po_name_records_ecom_prefinal_max || ' as
  select max(rnk_style_supp_nbd_nad) as max_groups from ' || table_tmp_po_name_records_ecom_prefinal
  ;

  --RAISE NOTICE 'INSIDE s7_y %', s7_y;

  EXECUTE s7_y;

  --RAISE NOTICE 'NEW.pinch_user_po_plan_name_ecom %', NEW.pinch_user_po_plan_name_ecom;

  if NEW.pinch_user_po_plan_name_ecom is not null and NEW.pinch_user_po_plan_name_ecom <> '' then

  s8 := 'update blk_p_pinchpo a
  set pinch_publish_po_plan_name_ecom = case when c.max_groups > 1 then b.pinch_publish_po_plan_name_ecom else ''' || NEW.pinch_user_po_plan_name_ecom || ''' end
  from ' || table_tmp_po_name_records_ecom_final || ' b, ' || table_tmp_po_name_records_ecom_prefinal_max || ' c
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  '
  ;

  --RAISE NOTICE 'INSIDE s8 %', s8;

  EXECUTE s8;

  end if;


  --s9 := 'insert into sync_pg_ch select ''blk_p_pinchpo'', product, location, time, pinch_id from ' || table_tmp_po_name_records_ecom_final || ' a where not exists (select 1 from sync_pg_ch b where a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id)';

  --EXECUTE s9;
  
end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pinchpo_name_nad_nbd() OWNER TO psql;

--
-- TOC entry 2169 (class 1255 OID 129294848)
-- Name: update_pinchpo_name_store(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pinchpo_name_store() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
v_uuid_temp text;
v_uuid text;

s1 text;
s1_x text;
s2 text;
s2_update text;
s3 text;
s3_update text;
s4 text;
s5 text;
s6 text;
s6_x text;
s7 text;
s7_x text;
s7_y text;
s8 text;
s9 text;
table_tmp_po_name_records text;
table_tmp_po_name_records_1 text;
table_tmp_po_name_records_2 text;
table_tmp_po_name_records_prefinal text;
table_tmp_po_name_records_final text;
table_tmp_po_name_records_prefinal_max text;

v_pinch_user_po_plan_name_store text;
v_po_id text;
v_product text;
v_location text;
v_time text;
v_pinch_id text;
v_max_groups integer;

BEGIN


EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_tmp_po_name_records := 'tmp_po_name_records'||v_uuid;
table_tmp_po_name_records_1 := 'tmp_po_name_records_1'||v_uuid;
table_tmp_po_name_records_2 := 'tmp_po_name_records_2'||v_uuid;
table_tmp_po_name_records_prefinal := 'tmp_po_name_records_prefinal'||v_uuid;
table_tmp_po_name_records_final := 'tmp_po_name_records_final'||v_uuid;
table_tmp_po_name_records_prefinal_max := 'tmp_po_name_records_prefinal_max'||v_uuid;

v_pinch_user_po_plan_name_store := NEW.pinch_user_po_plan_name_store;
v_po_id := NEW.po_id;
v_product := NEW.product;
v_location := NEW.location;
v_time := NEW.time;
v_pinch_id := NEW.pinch_id;
RAISE NOTICE 'OUTSIDE v_pinch_user_po_plan_name_store %', v_pinch_user_po_plan_name_store;
RAISE NOTICE 'OUTSIDE NEW.pinch_user_po_plan_name_store %', NEW.pinch_user_po_plan_name_store;
RAISE NOTICE 'OUTSIDE OLD.pinch_user_po_plan_name_store %', OLD.pinch_user_po_plan_name_store;

  /* Requirements
  1. When style colors have different PO Plan name.
  2. When style colors are having different Supplier Site even though it has same PO Plan name.
  3. For BI (Belk international), each style (inclusive of it’s colors) will be on a separate PO even if
     multiple styles have same PO Plan name.
  4. If NBD (Not Before Date) & NAD (Not After Date) is different with in a style’s colors or a
     group of styles/colors that have the same PO Plan name.
  5. If both BI & Domestic style colors are part of same PO Plan name.
  */


  -- Find if there are any products other than the current Stylecolor with same PO Name as this one
  -- Find if there are any other products with same PO name which belong to a different Style than this one and belong to Belk International - Using supp_bi_flg: Mark v_bi_error_count 
  -- Find If NAD and NBD are different. If yes change the PO Name.
  -- For NAD and NBD there can be 2 cases
  --       1. NAD and NBD are blank in Postgres. It is possible they have never been edited and that row was never written in PG. For this NAD and NBD will need to be found using column time
  --       2. NAD and NBD are pulled from Postgres
  -- Find count of v_supplier_error_count for all products with same PO Plan name: If count > 1 means there are diffent products with different Supplier. Need to change the PO Plan name in that case

--if coalesce(NEW.pinch_user_po_plan_name_store, '') <> coalesce(OLD.pinch_user_po_plan_name_store, '') then

   if NEW.pinch_user_po_plan_name_store is null or NEW.pinch_user_po_plan_name_store = '' then
     s8 := 'update blk_p_pinchpo set pinch_publish_po_plan_name_store = null
     where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || '''
     '
     ;

    RAISE NOTICE 'INSIDE s8 %', s8;

     EXECUTE s8;
     RETURN NEW;
   end if;

  --RAISE NOTICE 'INSIDE OLD.pinch_user_po_plan_name_store %', OLD.pinch_user_po_plan_name_store;

  s1 := 'create temporary table ' || table_tmp_po_name_records || ' as
  select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
  from blk_p_pinchpo a, blk_h_prodstd b, blk_ma_styleattributes c where a.product = b.id and b.ancestor0 = c.product and pinch_user_po_plan_name_store = ''' || v_pinch_user_po_plan_name_store || '''';

  RAISE NOTICE 'INSIDE s1 %', s1;
  
  EXECUTE s1;

  --s1_x := 'insert into blk_po_name_records select * from ' || table_tmp_po_name_records;
  --EXECUTE s1_x;
  
  s2 := 'update ' || table_tmp_po_name_records || ' a
  set pinch_nbd = b.min_nbd
  from (
        select a.time, min(c2.date_id) as min_nbd, min(b2.date_id) min_nad 
        from (select distinct time from ' || table_tmp_po_name_records || ' where pinch_nbd is null or pinch_nbd = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx - 52
          and c.indx = a1.indx - 60
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nbd is null or pinch_nbd = ''''
  ';

   RAISE NOTICE 'INSIDE s2 %', s2;

  EXECUTE s2;


  s2_update := 'update blk_p_pinchpo a
  set pinch_nbd = b.pinch_nbd
  from ' || table_tmp_po_name_records || ' b
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and (a.pinch_nbd is null or a.pinch_id = '''')
  '
  ;
  
  RAISE NOTICE 'INSIDE s2_update %', s2_update;
  
  EXECUTE s2_update;

  
  s3 := 'update ' || table_tmp_po_name_records || ' a
  set pinch_nad = b.min_nad
  from (
        select a.time, min(c2.date_id) as min_nbd, min(b2.date_id) min_nad 
        from (select distinct time from ' || table_tmp_po_name_records || ' where pinch_nad is null or pinch_nad = '''') a,
             blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
        where a1.id = a.time and b.indx = a1.indx - 52
          and c.indx = a1.indx - 60
          and b.id = b2.week_id
          and c.id = c2.week_id
        group by a.time
       ) b
  where a.time = b.time
  and pinch_nad is null or pinch_nad = ''''
  ';

  RAISE NOTICE 'INSIDE s3 %', s3;

  EXECUTE s3;


  s3_update := 'update blk_p_pinchpo a
  set pinch_nad = b.pinch_nad
  from ' || table_tmp_po_name_records || ' b
  where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and (a.pinch_nad is null or a.pinch_nad = '''')
  '
  ;
  
  RAISE NOTICE 'INSIDE s3_update %', s3_update;
  
  EXECUTE s3_update;

  
  s4 := 'create temporary table ' || table_tmp_po_name_records_1 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, a.style, supp_bi_flg, supp_supplier_site_id, 
        rnk_style
   from ' || table_tmp_po_name_records || ' a
   join (select style, row_number() over() as rnk_style from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style) b on a.style = b.style
   where supp_bi_flg = ''Y''
  ),
  step2 as
  (select a.*, rnk_style_supp
   from step1 a
   join (select style, supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd
   from step2 a
   join (select style, supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step4 as
  (select a.*, rnk_style_supp_nbd_nad
   from step3 a
   join (select style, supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''Y'' group by style, supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.style = b.style and a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step4
  ';

  RAISE NOTICE 'INSIDE s4 %', s4;

  EXECUTE s4;


  s5 := 'create temporary table ' || table_tmp_po_name_records_2 || ' as
  with 
  step1 as
  (select po_id, product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, style, supp_bi_flg, a.supp_supplier_site_id, 1 as rnk_style,
        rnk_style_supp
   from ' || table_tmp_po_name_records || ' a
   join (select supp_supplier_site_id, row_number() over() as rnk_style_supp from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id) b on a.supp_supplier_site_id = b.supp_supplier_site_id
   where supp_bi_flg = ''N''
  ),
  step2 as
  (select a.*, rnk_style_supp_nbd
   from step1 a
   join (select supp_supplier_site_id, pinch_nbd, row_number() over() as rnk_style_supp_nbd from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd
  ),
  step3 as
  (select a.*, rnk_style_supp_nbd_nad
   from step2 a
   join (select supp_supplier_site_id, pinch_nbd, pinch_nad, row_number() over() as rnk_style_supp_nbd_nad from ' || table_tmp_po_name_records || ' where supp_bi_flg = ''N'' group by supp_supplier_site_id, pinch_nbd, pinch_nad) b on a.supp_supplier_site_id = b.supp_supplier_site_id and a.pinch_nbd = b.pinch_nbd and a.pinch_nad = b.pinch_nad
  )
  select * from step3
  ';

  RAISE NOTICE 'INSIDE s5 %', s5;

  EXECUTE s5;

  s6 := 'create temporary table ' || table_tmp_po_name_records_prefinal || ' as
  select * from ' || table_tmp_po_name_records_1 || '
  union all
  select * from ' || table_tmp_po_name_records_2;

  RAISE NOTICE 'INSIDE s6 %', s6;

  EXECUTE s6;

  --s6_x := 'insert into blk_po_name_records_prefinal select * from ' || table_tmp_po_name_records_prefinal;
  --EXECUTE s6_x;

  s7 := 'create temporary table ' || table_tmp_po_name_records_final || ' as
  with t as
  (select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_store, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
         case when a.supp_bi_flg = ''Y'' then a.pinch_user_po_plan_name_store || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id || '':'' || a.style
         else a.pinch_user_po_plan_name_store || '':'' || a.supp_bi_flg || '':'' || a.pinch_nad || '':'' || a.pinch_nbd || '':'' || a.supp_supplier_site_id 
         end as new_pinch_publish_po_plan_name_store,
         b.pinch_publish_po_plan_name_store as exiting_pinch_publish_po_plan_name_store
  from ' || table_tmp_po_name_records_prefinal || ' a, blk_p_pinchpo b where a.po_id = b.po_id and a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  )
  select a.po_id, a.product, a.location, a.time, a.pinch_id, a.pinch_nbd, a.pinch_nad, a.pinch_user_po_plan_name_store, a.style, a.supp_bi_flg, a.supp_supplier_site_id,
      a.new_pinch_publish_po_plan_name_store as pinch_publish_po_plan_name_store
      from (select * from t) as a
  --from (select * from t where po_id = ''' || v_po_id || ''' and product =  ''' || v_product || ''' and location = ''' || v_location || ''' and time = ''' || v_time || ''' and pinch_id = ''' || v_pinch_id || ''') as a
  ';

  RAISE NOTICE 's7 %', s7;

  EXECUTE s7;

  --s7_x := 'insert into blk_po_name_records_final select * from ' || table_tmp_po_name_records_final;
  --EXECUTE s7_x;

  s7_y := 'create temporary table ' || table_tmp_po_name_records_prefinal_max || ' as
  select product, po_id, supp_supplier_site_id, pinch_nbd, pinch_nad, rnk_style_supp_nbd_nad, case when rnk_style_supp_nbd_nad = 1 then ''YES'' else ''NO'' end as use_user_po_plan_name 
  from ' || table_tmp_po_name_records_prefinal
  ;

  RAISE NOTICE 'INSIDE s7_y %', s7_y;

  EXECUTE s7_y;

  s8 := 'update blk_p_pinchpo a
  set pinch_publish_po_plan_name_store = case when c.use_user_po_plan_name = ''NO'' then b.pinch_publish_po_plan_name_store else ''' || NEW.pinch_user_po_plan_name_store || ''' end
  from ' || table_tmp_po_name_records_final || ' b, ' || table_tmp_po_name_records_prefinal_max || ' c
  where a.po_id = c.po_id and a.product = c.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id
  and a.pinch_nbd = c.pinch_nbd and a.pinch_nad = c.pinch_nad
  and a.product = b.product and a.po_id = b.po_id
  '
  ;

  RAISE NOTICE 'INSIDE s8 %', s8;
  
  EXECUTE s8;

  --s9 := 'insert into sync_pg_ch select ''blk_p_pinchpo'', product, location, time, pinch_id from ' || table_tmp_po_name_records_final || ' a where not exists (select 1 from sync_pg_ch b where a.product = b.product and a.location = b.location and a.time = b.time and a.pinch_id = b.pinch_id)';

  --EXECUTE s9;

  
--end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pinchpo_name_store() OWNER TO psql;

--
-- TOC entry 2170 (class 1255 OID 129294850)
-- Name: update_pinchpo_published(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pinchpo_published() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_published_by text;
BEGIN
  if NEW.is_published = 1 and (OLD.is_published is null or NEW.is_published <> OLD.is_published) then
    NEW.published_at = NOW()::timestamp(0)- interval '4 hours';
    select email into NEW.published_by from user_metadata where uid = NEW.updated_by;
    NEW.spo_status_store := 'PUBLISHED';
    NEW.po_status_store := 'PUBLISHED';
    insert into blk_p_dc_adj(product, location, time, dc_publish, published_at, updated_by)
    values(NEW.product, NEW.location, NEW.time, NEW.is_published, NOW()::timestamp(0) - interval '4 hours', NEW.updated_by)
    on conflict (product, location, time)
    do update set dc_publish = NEW.is_published, published_at = NOW()::timestamp(0) - interval '4 hours', updated_by = NEW.updated_by;

    --if (OLD.pinch_publish_po_plan_name_store is null or OLD.pinch_publish_po_plan_name_store = '') and (OLD.pinch_publish_po_plan_name_ecom is null or OLD.pinch_publish_po_plan_name_ecom = '') then
    --  NEW.pinch_publish_po_plan_name_store := NEW.po_id || ':' || coalesce(NEW.pinch_id, 'original');
    --end if;
  elsif NEW.is_published = 0 and NEW.is_published <> OLD.is_published then
    select email into NEW.published_by from user_metadata where uid = NEW.updated_by;
    --NEW.spo_status_store := 'PLANNED';
    --NEW.po_status_store := 'PLANNED';
    insert into blk_p_dc_adj(product, location, time, dc_publish, published_at, updated_by)
    values(NEW.product, NEW.location, NEW.time, NEW.is_published, NOW()::timestamp(0) - interval '4 hours', NEW.updated_by)
    on conflict (product, location, time)
    do update set dc_publish = NEW.is_published, published_at = NOW()::timestamp(0) - interval '4 hours', updated_by = NEW.updated_by;
  end if;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_pinchpo_published() OWNER TO psql;

--
-- TOC entry 2171 (class 1255 OID 129294851)
-- Name: update_plm_sty_vpn(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_plm_sty_vpn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dept text;
  v_index text;
  v_supp_id text;
  v_count integer;
  v_sty_name text;
  v_sty_desc text;
  v_vpn_desc text;
BEGIN

  select ancestor2 into v_dept from blk_h_prodstd where id = NEW.product;
  select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from blk_l_dependencylookup;

  select distinct supplier_site
  into v_supp_id
  from blk_specstyle_attr_week 
  where vpn_id = new.sty_vpn
  ;

  select count(*) into v_count
  from blk_ma_styleattributes where product <> NEW.product and sty_vpn = NEW.sty_vpn and NEW.sty_vpn is not null and NEW.sty_vpn <> '';

  select name 
  into v_sty_name
  from blk_d_product where id = NEW.product;

  select description 
  into v_sty_desc
  from blk_d_product where id = NEW.product;

  select max(vpn_desc)
  into v_vpn_desc
  from blk_specstyle_attr_week
  where vpn_id = new.sty_vpn
  and department = v_dept
  group by vpn_id
  limit 1;

  if v_count > 0 then 

    NEW.sty_vpn := OLD.sty_vpn;
    
    -- Set vpn back to the old value
    update blk_ma_styleattributes 
    set sty_vpn = OLD.sty_vpn, 
        sty_vpn_final = OLD.sty_vpn
    where product =  NEW.product;
   
    -- Set cc_vpn back to old value and null out colors
    update blk_ma_stylecolorattributes
    set cc_vpn = OLD.sty_vpn,
        cc_vpn_color = null,
        cc_vpn_color_desc = null, 
        cc_vpn_color_display = null,
        cc_vpn_buy_period = null
    where product in (select id from blk_h_prodstd where ancestor0 = NEW.product);  
   
  else 

      update blk_ma_stylecolorattributes
      set cc_vpn = NEW.sty_vpn,
          cc_vpn_color = null,
          cc_vpn_color_desc = null, 
          cc_vpn_color_display = null,
          cc_vpn_buy_period = NEW.sty_vpn || '_' || cc_buy_period_descr
      where product in (select id from blk_h_prodstd where ancestor0 = NEW.product); 
     
      delete from blk_ma_stylecolorweekattributes where product in (select id from blk_h_prodstd where ancestor0 = NEW.product);
  
    if OLD.sty_vpn is not null and OLD.sty_vpn <> ''
    then

      insert into blk_l_dependencylookup(lookup_id, lookup_value, target_id, target_value)
      select 'sty_dpt_buy_period', OLD.sty_dpt_buy_period, 'sty_vpn', OLD.sty_vpn
      from blk_ma_styleattributes
      where product = NEW.product
      and (OLD.sty_dpt_buy_period, OLD.sty_vpn) not in (select lookup_value, target_value from blk_l_dependencylookup where lookup_id = 'sty_dpt_buy_period' and target_id = 'sty_vpn')
      and OLD.sty_vpn not in (select sty_vpn from blk_ma_styleattributes where STY_VPN is not null and STY_VPN <> '' and PRODUCT <> NEW.product)
      union
      select distinct 'sty_dpt_buy_period', department || '_' || buy_period_descr, 'sty_vpn', vpn_id
      from blk_specstyle_attr_week 
      where (department || '_' || buy_period_descr, vpn_id) not in (select lookup_value, target_value from blk_l_dependencylookup where lookup_id = 'sty_dpt_buy_period' and target_id = 'sty_vpn')
      and not exists (select 1 from blk_ma_styleattributes b where vpn_id = sty_vpn)
      and plm_style_status <> 'DROPPED'
      ;

    end if;
 
    if NEW.sty_vpn is not null and NEW.sty_vpn <> ''
    then

      -- Once vpn is assigned delete vpns for all buy periods so that the same vpn cannot be assigned to another style
      delete from blk_l_dependencylookup 
      where lookup_id = 'sty_dpt_buy_period'
        and target_id = 'sty_vpn' and target_value = NEW.sty_vpn;       

      if NEW.sty_style_type = 'PLM' then
        update blk_ma_styleattributes set sty_vpn_final = NEW.sty_vpn where product = NEW.product;
      end if;
    end if;
   
    -- Update supplier info based on the VPN  
    update blk_ma_styleattributes set supp_supplier_site_id = v_supp_id, sty_supplier_number =  v_supp_id where product = NEW.product;

    -- Set sty_vpn_buy_period which will pare down the list of available plm colors based on the valid buy periods of the vpn
    update blk_ma_styleattributes set sty_vpn_buy_period = NEW.sty_vpn || '_' || sty_buy_period_descr where product =  NEW.product;


  end if;

 
   if OLD.sty_vpn is null OR OLD.sty_vpn = ''
   then
        
      -- Before updating the Style ID and Desc in d_product, add the old ID and Desc to styleattributes. If the VPN is set back to null then we'll update d_product with the old ID and Desc
      update blk_ma_styleattributes
      set sty_style_name = (select name from blk_d_product where id = NEW.product)
          ,sty_style_description = (select description from blk_d_product where id = NEW.product)
      where product = NEW.product;
   
      update blk_d_product
      set name = NEW.sty_vpn
         ,description = v_vpn_desc
      where id = NEW.product;  

      -- Update stylecolors with same name and description
      update blk_d_product a
      set name = NEW.sty_vpn || '.' || b.cccolorid
         ,description = v_vpn_desc || ' ' || b.cc_color_desc
      from
      (
        select product, cccolorid, cc_color_desc
        from blk_ma_stylecolorattributes 
        where product in (select id from blk_h_prodstd where ancestor0 = NEW.product)
      ) b
      where a.id = b.product
      ;

   end if;
  
  
   if NEW.sty_vpn is null OR NEW.sty_vpn = ''
   then

      -- If the VPN is null then replace the Style ID and Desc with the old values found in styleattributes
      update blk_d_product
      set name = COALESCE((select sty_style_name from blk_ma_styleattributes where product = NEW.product), v_sty_name)
         ,description = COALESCE((select sty_style_description from blk_ma_styleattributes where product = NEW.product), v_sty_desc)
      where id = NEW.product;  

      -- Update stylecolors with same name and description
      update blk_d_product a
      set name = COALESCE(NEW.sty_vpn || '.' || b.cccolorid, v_sty_name || '.' || b.cccolorid)
         ,description = COALESCE(v_vpn_desc || ' ' || b.cc_color_desc, v_sty_desc || ' ' || b.cc_color_desc)
      from
      (
        select product, cccolorid, cc_color_desc
        from blk_ma_stylecolorattributes 
        where product in (select id from blk_h_prodstd where ancestor0 = NEW.product)
      ) b
      where a.id = b.product
      ;

      -- Blank out sty_vpn_buy_period
      update blk_ma_styleattributes 
        set sty_vpn_buy_period = '',
            sty_vpn_final = '' 
        where product = NEW.product;

   end if;
  
  
   if NEW.sty_vpn is not null and  NEW.sty_vpn <> ''
   then
        
      -- If user changes from one VPN to another then just update blk_d_product
      update blk_d_product
      set name = NEW.sty_vpn
         ,description = v_vpn_desc          
      where id = NEW.product;  

      -- Update stylecolors with same name and description
      update blk_d_product a
      set name = NEW.sty_vpn || '.' || b.cccolorid
         ,description = v_vpn_desc || ' ' || b.cc_color_desc
      from
      (
        select product, cccolorid, cc_color_desc
          from blk_ma_stylecolorattributes 
          where product in (select id from blk_h_prodstd where ancestor0 = NEW.product)
      ) b
      where a.id = b.product
      ;

   end if;


  return NEW;
END;
$$;


ALTER FUNCTION public.update_plm_sty_vpn() OWNER TO psql;

--
-- TOC entry 2172 (class 1255 OID 129294853)
-- Name: update_styleattributes_supp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_styleattributes_supp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_supplier_error_count_store integer;
v_supplier_error_count_ecom integer;
v_uuid_temp text;
v_uuid text;

s1 text;
s1_x text;
s2 text;
s3 text;
s4 text;
s5 text;
s6 text;
s7 text;
s7_x text;
s7_y text;
s8 text;
s9 text;
table_tmp_po_name_records_store text;
table_tmp_po_name_records_store_1 text;
table_tmp_po_name_records_store_2 text;
table_tmp_po_name_records_store_prefinal text;
table_tmp_po_name_records_store_final text;
table_tmp_po_name_records_store_prefinal_max text;
table_tmp_po_name_records_ecom text;
table_tmp_po_name_records_ecom_1 text;
table_tmp_po_name_records_ecom_2 text;
table_tmp_po_name_records_ecom_prefinal text;
table_tmp_po_name_records_ecom_final text;
table_tmp_po_name_records_ecom_prefinal_max text;

v_pinch_user_po_plan_name_store text;
v_pinch_user_po_plan_name_ecom text;
v_po_id text;
v_product text;
v_location text;
v_time text;
v_pinch_id text;
BEGIN
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_tmp_po_name_records_store := 'tmp_po_name_records_store'||v_uuid;
table_tmp_po_name_records_store_1 := 'tmp_po_name_records_store_1'||v_uuid;
table_tmp_po_name_records_store_2 := 'tmp_po_name_records_store_2'||v_uuid;
table_tmp_po_name_records_store_prefinal := 'tmp_po_name_records_store_prefinal'||v_uuid;
table_tmp_po_name_records_store_final := 'tmp_po_name_records_store_final'||v_uuid;
table_tmp_po_name_records_store_prefinal_max := 'tmp_po_name_records_store_prefinal_max'||v_uuid;

table_tmp_po_name_records_ecom          := 'tmp_po_name_records_ecom'||v_uuid;
table_tmp_po_name_records_ecom_1        := 'tmp_po_name_records_ecom_1'||v_uuid;
table_tmp_po_name_records_ecom_2        := 'tmp_po_name_records_ecom_2'||v_uuid;
table_tmp_po_name_records_ecom_prefinal := 'tmp_po_name_records_ecom_prefinal'||v_uuid;
table_tmp_po_name_records_ecom_final    := 'tmp_po_name_records_ecom_final'||v_uuid;
table_tmp_po_name_records_ecom_prefinal_max := 'tmp_po_name_records_ecom_prefinal_max'||v_uuid;
v_product := NEW.product;

  if (NEW.supp_supplier_site_id <> OLD.supp_supplier_site_id  or (OLD.supp_supplier_site_id is null and NEW.supp_supplier_site_id is not null)) then

    update blk_ma_styleattributes set supp_bi_flg = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_bi_flg' and product = NEW.product;
    update blk_ma_styleattributes set supp_brand = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_brand' and product = NEW.product;
    update blk_ma_styleattributes set supp_brand_mindset = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_brand_mindset' and product = NEW.product;
    update blk_ma_styleattributes set supp_brand_type = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_brand_type' and product = NEW.product;
    update blk_ma_styleattributes set supp_class_group = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_class_group' and product = NEW.product;
    update blk_ma_styleattributes set supp_direct_ship_ind = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_direct_ship_ind' and product = NEW.product;
    update blk_ma_styleattributes set supp_grp_brand_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_grp_brand_id' and product = NEW.product;
    update blk_ma_styleattributes set supp_grp_parent_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_grp_parent_id' and product = NEW.product;
    update blk_ma_styleattributes set supp_grp_standard_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_grp_standard_id' and product = NEW.product;
    update blk_ma_styleattributes set supp_lifestyle = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_lifestyle' and product = NEW.product;
    update blk_ma_styleattributes set supp_ninebox = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_ninebox' and product = NEW.product;
    update blk_ma_styleattributes set supp_parent_supplier_id = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_parent_supplier_id' and product = NEW.product;
    update blk_ma_styleattributes set supp_parent_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_parent_supplier_name' and product = NEW.product;
    update blk_ma_styleattributes set supp_priceband = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_priceband' and product = NEW.product;
    update blk_ma_styleattributes set supp_status = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_status' and product = NEW.product;
    update blk_ma_styleattributes set supp_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_supplier_name' and product = NEW.product;
    update blk_ma_styleattributes set sty_supplier_name = b.target_value from blk_l_dependencylookup b where supp_supplier_site_id = b.lookup_value and b.lookup_value = NEW.supp_supplier_site_id and b.target_id = 'supp_supplier_name' and product = NEW.product;
    update blk_ma_styleattributes set sty_supplier_number = NEW.supp_supplier_site_id where product = NEW.product;

    select count(*)
      into v_supplier_error_count_store
    from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
    where a.product = c.id and c.ancestor0 = b.product and b.product <> NEW.product and b.supp_supplier_site_id <> NEW.supp_supplier_site_id
    and a.pinch_publish_po_plan_name_store in (select distinct a1.pinch_publish_po_plan_name_store
                                            from blk_p_pinchpo a1, blk_ma_styleattributes b1, blk_h_prodstd c1
                                            where a1.product = c1.id and c1.ancestor0 = b1.product and b1.product = NEW.product
                                           )
    ;

    s1 := 'create temporary table ' || table_tmp_po_name_records_store || ' as
    select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_store, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
    from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
    where a.product = c.id and c.ancestor0 = b.product and b.product = ''' || v_product || '''
    '
    ;

    
    EXECUTE s1;

    s2 := 'update ' || table_tmp_po_name_records_store || ' a
    set pinch_nbd = b.min_nbd
    from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
          from (select distinct time from ' || table_tmp_po_name_records_store || ' where pinch_nbd is null or pinch_nbd = '''') a,
               blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
          where a1.id = a.time and b.indx = a1.indx + 4
            and c.indx = a1.indx - 4
            and b.id = b2.week_id
            and c.id = c2.week_id
          group by a.time
         ) b
    where a.time = b.time
    and pinch_nbd is null or pinch_nbd = ''''
    ';
  
    EXECUTE s2;
    
    s3 := 'update ' || table_tmp_po_name_records_store || ' a
    set pinch_nad = b.min_nad
    from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
          from (select distinct time from ' || table_tmp_po_name_records_store || ' where pinch_nad is null or pinch_nad = '''') a,
               blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
          where a1.id = a.time and b.indx = a1.indx + 4
            and c.indx = a1.indx - 4
            and b.id = b2.week_id
            and c.id = c2.week_id
          group by a.time
         ) b
    where a.time = b.time
    and pinch_nad is null or pinch_nad = ''''
    ';
  
    EXECUTE s3;

    select count(*)
      into v_supplier_error_count_ecom
    from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
    where a.product = c.id and c.ancestor0 = b.product and b.product <> NEW.product and b.supp_supplier_site_id <> NEW.supp_supplier_site_id
    and a.pinch_publish_po_plan_name_ecom in (select distinct a1.pinch_publish_po_plan_name_ecom
                                            from blk_p_pinchpo a1, blk_ma_styleattributes b1, blk_h_prodstd c1
                                            where a1.product = c1.id and c1.ancestor0 = b1.product and b1.product = NEW.product
                                           )
    ;

    s1 := 'create temporary table ' || table_tmp_po_name_records_ecom || ' as
    select po_id, a.product, location, time, pinch_id, pinch_nbd, pinch_nad, pinch_user_po_plan_name_ecom, ancestor0 as style, supp_bi_flg, supp_supplier_site_id
    from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
    where a.product = c.id and c.ancestor0 = b.product and b.product = ''' || v_product || '''
    '
    ;
    

    EXECUTE s1;

    s2 := 'update ' || table_tmp_po_name_records_ecom || ' a
    set pinch_nbd = b.min_nbd
    from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
          from (select distinct time from ' || table_tmp_po_name_records_ecom || ' where pinch_nbd is null or pinch_nbd = '''') a,
               blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
          where a1.id = a.time and b.indx = a1.indx + 4
            and c.indx = a1.indx - 4
            and b.id = b2.week_id
            and c.id = c2.week_id
          group by a.time
         ) b
    where a.time = b.time
    and pinch_nbd is null or pinch_nbd = ''''
    ';
  
    EXECUTE s2;
    
    s3 := 'update ' || table_tmp_po_name_records_ecom || ' a
    set pinch_nad = b.min_nad
    from (select a.time, min(b2.date_id) min_nad, min(c2.date_id) as min_nbd
          from (select distinct time from ' || table_tmp_po_name_records_ecom || ' where pinch_nad is null or pinch_nad = '''') a,
               blk_d_time a1, blk_d_time b, blk_d_time c, blk_time_hier b2, blk_time_hier c2
          where a1.id = a.time and b.indx = a1.indx + 4
            and c.indx = a1.indx - 4
            and b.id = b2.week_id
            and c.id = c2.week_id
          group by a.time
         ) b
    where a.time = b.time
    and pinch_nad is null or pinch_nad = ''''
    ';
  
    EXECUTE s3;


    if v_supplier_error_count_store > 0 then

        s4 := 'update blk_p_pinchpo x 
        set pinch_publish_po_plan_name_store = case 
                                               when y.supp_bi_flg = ''Y'' then x.pinch_user_po_plan_name_store || '':'' || y.supp_bi_flg || '':'' || y.pinch_nad || '':'' || y.pinch_nbd || '':'' || y.supp_supplier_site_id || '':'' || a.style
                                               else x.pinch_user_po_plan_name_store || '':'' || y.supp_bi_flg || '':'' || y.pinch_nad || '':'' || y.pinch_nbd || '':'' || y.supp_supplier_site_id  
                                               end
        from  ' || table_tmp_po_name_records_store || ' y
        where (x.product, x.time, x.location, x.pinch_id) in
         (select distinct a.product, a.time, a.location, a.pinch_id
          from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
          where a.product = c.id and c.ancestor0 = b.product and b.product = ''' || NEW.product || '''
         )
         and x.product = y.product and x.time = y.time and x.location = y.location and x.pinch_id = y.pinch_id
         ';
         EXECUTE s4;
    end if;

    if v_supplier_error_count_ecom > 0 then

        s4 := 'update blk_p_pinchpo x 
        set pinch_publish_po_plan_name_ecom = case 
                                               when y.supp_bi_flg = ''Y'' then x.pinch_user_po_plan_name_ecom || '':'' || y.supp_bi_flg || '':'' || y.pinch_nad || '':'' || y.pinch_nbd || '':'' || y.supp_supplier_site_id || '':'' || a.style
                                               else x.pinch_user_po_plan_name_ecom || '':'' || y.supp_bi_flg || '':'' || y.pinch_nad || '':'' || y.pinch_nbd || '':'' || y.supp_supplier_site_id  
                                               end
        from  ' || table_tmp_po_name_records_ecom || ' y
        where (x.product, x.time, x.location, x.pinch_id) in
         (select distinct a.product, a.time, a.location, a.pinch_id
          from blk_p_pinchpo a, blk_ma_styleattributes b, blk_h_prodstd c
          where a.product = c.id and c.ancestor0 = b.product and b.product = ''' || NEW.product || '''
         )
         and x.product = y.product and x.time = y.time and x.location = y.location and x.pinch_id = y.pinch_id
         ';
         EXECUTE s4;
    end if;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_styleattributes_supp() OWNER TO psql;

--
-- TOC entry 2173 (class 1255 OID 129294855)
-- Name: update_stylecolorattributes_cc_vpn(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorattributes_cc_vpn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
  if (NEW.sty_vpn <> OLD.sty_vpn  or ((OLD.sty_vpn is null or OLD.sty_vpn = '') and (NEW.sty_vpn is not null or NEW.sty_vpn <> ''))) then
  
    update blk_ma_stylecolorattributes
    set cc_vpn = NEW.sty_vpn,
        cc_vpn_color = null
    where product in (select id from blk_h_prodstd where ancestor0 = NEW.product); 

    delete from blk_ma_stylecolorweekattributes where product in (select id from blk_h_prodstd where ancestor0 = NEW.product);

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorattributes_cc_vpn() OWNER TO psql;

--
-- TOC entry 2174 (class 1255 OID 129294856)
-- Name: update_stylecolorattributes_cc_vpn_for_non_plm(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorattributes_cc_vpn_for_non_plm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  if (NEW.sty_vpn_id_non_plm <> OLD.sty_vpn_id_non_plm  or ((OLD.sty_vpn_id_non_plm is null or OLD.sty_vpn_id_non_plm = '') and (NEW.sty_vpn_id_non_plm is not null or NEW.sty_vpn_id_non_plm <> ''))) then
  
    update blk_ma_stylecolorattributes
    set cc_vpn = NEW.sty_vpn_id_non_plm,
        cc_vpn_color = null
    where product in (select id from blk_h_prodstd where ancestor0 = NEW.product); 

    if NEW.sty_vpn_id_non_plm is not null
    then
      if NEW.sty_style_type = 'NON-PLM' then

        update blk_ma_styleattributes
        set sty_vpn_final = NEW.sty_vpn_id_non_plm
        where product = NEW.product;

      end if;
    end if;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorattributes_cc_vpn_for_non_plm() OWNER TO psql;

--
-- TOC entry 2118 (class 1255 OID 129294857)
-- Name: update_stylecolorchannelattributes_ccrangecode(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorchannelattributes_ccrangecode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

s0 text;
s1 text;

v_uuid_temp text;
v_uuid text;

table_temp_sub_exists text;
table_temp_sub_not_exists text;

v_style text;
v_new_ccrangecode text;
v_old_sty_size_run_name text;
v_new_sty_size_run_name text;


BEGIN

-- this part is specific to style attribute sty_size_run_name changing
-- need to make another rendition of this for class changing

if NEW.sty_size_run_name <> OLD.sty_size_run_name and OLD.sty_is_locked is null then

  select id into v_style from blk_d_product where levelid='style' and id=NEW.product;
  select  OLD.sty_size_run_name into v_old_sty_size_run_name;

  select NEW.sty_size_run_name into v_new_sty_size_run_name;
  
  select NEW.sty_size_run_name||' - '||ancestor1 into v_new_ccrangecode
  from
      blk_h_prodstd
  where
      id=v_style
  limit 1;

  
  EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
  EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
  
  table_temp_sub_exists:= 'table_temp_sub_exists'||v_uuid;
  table_temp_sub_not_exists:= 'table_temp_sub_not_exists'||v_uuid;
  
  -- update ccsizerange based on updated express_size_range and or class info
  
  s0 := 'create temporary table '||table_temp_sub_exists||' as
      select a.product, a.ccrangecode as old_ccrangecode, '''||v_new_ccrangecode||''' new_ccrangecode
      from blk_ma_stylecolorchannelattributes a
      where product in (select id from blk_h_prodstd where ancestor0='''||v_style||''')
      ';
  -- RAISE NOTICE 'S0:%', 'START:'|| s0;
  
  
  s1 := 'UPDATE blk_ma_stylecolorchannelattributes a
  set ccrangecode=b.new_ccrangecode
     ,cc_validsizes_store=c.validsizes
     ,cc_validsizes_ecom=c.validsizes
  from '||table_temp_sub_exists||' b, (select array_agg(target_value) as validsizes, lookup_value as sty_size_run_name from blk_l_dependencylookup where lookup_value = '''||v_new_sty_size_run_name||''' and lookup_id = ''size_range'' group by lookup_value) c
  where a.product=b.product
  and b.new_ccrangecode is not null
  and a.product in (select product from '||table_temp_sub_exists||' where new_ccrangecode is not null)
  ';

  
  -- RAISE NOTICE 'S1:%', 'START:'|| s1;
  
  
  EXECUTE s0;
  EXECUTE s1;

ELSE

  update blk_ma_styleattributes set sty_size_run_name = OLD.sty_size_run_name where product = NEW.product;

end if;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_stylecolorchannelattributes_ccrangecode() OWNER TO psql;

--
-- TOC entry 2112 (class 1255 OID 129294858)
-- Name: update_stylecolorweekattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorweekattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
 v_hq_id text;
begin

DELETE FROM blk_ma_stylecolorweekattributes WHERE product = NEW.product;

select MIN(HQ_ID)
into v_hq_id
from blk_specstyle_attr_week
where vpn_id = new.cc_vpn
and color_cd = new.cc_vpn_color
;

insert into blk_ma_stylecolorweekattributes
select styclr.product, atw.week_id as time, 'MASTER_DC' as location, styclr.cc_vpn, styclr.cc_vpn_color, hq_id,
  atw.vpn_desc, atw.color_descr as cc_vpn_color_desc, atw.group_id, atw.department,
  atw.buy_period_id, atw.buy_period_descr, atw.plm_color_status, atw.plm_style_status, atw.size_codes, atw.size_description, atw.season as buy_period_season,
  atw.cost as plm_cost, atw.bi_vendor, atw.style_min, atw.style_max, atw.size_range, atw.pack_size_units, atw.color_way_desc,
  atw.cad_name, atw.image_url, atw.hq_lookup_key, current_date as eventdate, 1 as version_id,  date_trunc('sec'::text, current_timestamp)::timestamp as created_at, 'system' as created_by,
 date_trunc('sec'::text, current_timestamp)::timestamp as updated_at, 'system' as updated_by, 0 as record_state
from blk_ma_stylecolorattributes styclr
join BLK_SPECSTYLE_ATTR_WEEK atw
on atw.vpn_id = new.cc_vpn
and atw.color_cd = new.cc_vpn_color
and atw.hq_id = v_hq_id
where styclr.product = new.product
;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorweekattributes() OWNER TO psql;

--
-- TOC entry 2113 (class 1255 OID 129294859)
-- Name: update_stylecolorweekattributes_null_hq(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorweekattributes_null_hq() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare

begin

if exists (select from blk_ma_stylecolorweekattributes where product = new.product) THEN

update blk_ma_stylecolorweekattributes
set 
	VPN_DESC = NULL,
	CC_VPN_COLOR_DESC = NULL,
	PLM_COLOR_STATUS  = NULL,
	PLM_STYLE_STATUS  = NULL,
	SIZE_CODES  = NULL,
	SIZE_DESCRIPTION  = NULL,
	BUY_PERIOD_SEASON  = NULL,
	PLM_COST  = NULL,
	BI_VENDOR  = NULL,
	STYLE_MIN  = NULL,
	STYLE_MAX  = NULL,
	SIZE_RANGE  = NULL,
	PACK_SIZE_UNITS  = NULL,
	COLOR_WAY_DESC = NULL,
	CAD_NAME  = NULL,
	IMAGE_URL = NULL,
	EVENTDATE = CURRENT_DATE, 
	updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP)::TIMESTAMP 
where product = NEW.product
;


end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorweekattributes_null_hq() OWNER TO psql;

--
-- TOC entry 2175 (class 1255 OID 129294860)
-- Name: update_stylecolorweekattributes_post_hq(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolorweekattributes_post_hq() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare

begin

update blk_ma_stylecolorweekattributes DST
set
  	HQ_ID = src.HQ_ID,
	VPN_DESC = src.VPN_DESC,
	CC_VPN_COLOR_DESC = src.COLOR_DESCR,
	PLM_COLOR_STATUS  = src.PLM_COLOR_STATUS ,
	PLM_STYLE_STATUS  = src.PLM_STYLE_STATUS ,
	SIZE_CODES  = src.SIZE_CODES ,
	SIZE_DESCRIPTION  = src.SIZE_DESCRIPTION ,
	BUY_PERIOD_SEASON  = src.SEASON ,
	PLM_COST  = src.COST ,
	BI_VENDOR  = src.BI_VENDOR ,
	STYLE_MIN  = src.STYLE_MIN ,
	STYLE_MAX  = src.STYLE_MAX ,
	SIZE_RANGE  = src.SIZE_RANGE ,
	PACK_SIZE_UNITS  = src.PACK_SIZE_UNITS ,
	COLOR_WAY_DESC = src.COLOR_WAY_DESC,
	CAD_NAME  = src.CAD_NAME ,
	IMAGE_URL = src.IMAGE_URL,
	EVENTDATE = CURRENT_DATE,
	updated_at = date_trunc('sec'::text, CURRENT_TIMESTAMP)::TIMESTAMP
from BLK_SPECSTYLE_ATTR_WEEK src
where src.hq_id = NEW.hq_id
and dst.cc_vpn = src.vpn_id
and dst.cc_vpn_color = src.color_cd
and dst.buy_period_id = src.buy_period_id
and dst.time = src.week_id
and dst.department = src.department
and dst.product = NEW.product
and dst.time = NEW.time
;


update blk_ma_stylecolorchannelattributes a
set
     cc_target_cost = plm_cost
    ,cc_plan_cost = plm_cost
    ,cc_landed_cost = plm_cost
    ,cc_systemcost = plm_cost
    ,cc_existingwac = plm_cost
    ,cc_imupct = round((1 - (plm_cost / ccticketpricechannel))::numeric,2)
from
(
     select distinct PRODUCT, plm_cost::real as plm_cost
     from blk_ma_stylecolorweekattributes
     where product = NEW.product
) b
where a.product = b.product
and a.product = NEW.product
and a.ccticketpricechannel is not null and a.ccticketpricechannel <> '0'
;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stylecolorweekattributes_post_hq() OWNER TO psql;

--
-- TOC entry 2176 (class 1255 OID 129294861)
-- Name: update_ticket_price(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ticket_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
  if NEW.cc_msrp <> OLD.cc_msrp or OLD.cc_msrp is null then
    update blk_ma_stylecolorchannelattributes
    set ccticketpricechannel = cast(NEW.cc_msrp as real)
    where product = NEW.product;

    update blk_a_assortment
    set a_msrp = cast(NEW.cc_msrp as real)
    where product = NEW.product;

    -- For placeholders only, set current_retail = msrp
    update blk_ma_stylecolorattributes
    set cc_current_retail = cast(NEW.cc_msrp as real)
    where product = NEW.product
    and (ccstylecolorcreatedate is null or ccstylecolorcreatedate = '');

  end if;

  if NEW.cc_current_retail <> OLD.cc_current_retail or OLD.cc_current_retail is null then
    update blk_a_assortment
    set a_current_retail = cast(NEW.cc_current_retail as real)
    where product = NEW.product;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_ticket_price() OWNER TO psql;

--
-- TOC entry 2177 (class 1255 OID 129294862)
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
    select b.product,b.location,a.indx,a.time from blk_ma_dptflrsetattributes a, cart_params_temp b,
    (select value as plan_current from blk_serviceparams where id='plan_current') c,
    (select value as plan_end from blk_serviceparams where id='plan_end') d
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
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, indx, str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, c.indx,str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or
    from temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||min(indx) from temp_old group by scope_product, scope_location)
    and c.indx < a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, indx, str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, c.indx,str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or
    from temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||max(indx) from temp_old group by scope_product, scope_location)
    and c.indx > a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, indx, str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, ssg,flnrange,isfunded, c.indx, str_grade_or,str_segmentation_or,str_sub_segmentation_or,str_aa_ind_or,str_hisp_ind_or,str_lifestyle_01_or,str_lifestyle_02_or,str_lifestyle_03_or,str_lifestyle_04_or,str_climate_or,str_state_or
    from temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and c.indx = a.indx ;

    drop table temp_new;
    drop table temp_old;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_trigger_cartparams_ranging() OWNER TO psql;

--
-- TOC entry 2178 (class 1255 OID 129294863)
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

v_relaunch_irw_indx int;
v_relaunch_dbtwk_indx int;
v_relaunch_mdstart_indx int;
v_relaunch_exitdate_indx int;
v_relaunch_initrcptwk text;
v_relaunch_last_rcpt_wk_indx int;

BEGIN
v_dbtwk_indx := (select indx from blk_d_time where id = ''||NEW.dbt_wk||'');
v_mdstart_indx := (select indx  from blk_d_time where id = ''||NEW.erlstmkdnwk||'');
v_exitdate_indx := (select indx  from blk_d_time where id = ''||NEW.exitdate||'');
v_irw_indx := v_dbtwk_indx - 0; --Changed in January 2025 per Belka and S5 agreement
v_initrcptwk := (select id from blk_d_time where indx= v_irw_indx);
v_lastdcorder_indx := v_mdstart_indx - 6;
v_lastdcorder := (select id from blk_d_time where indx= v_lastdcorder_indx);


if (NEW.dbt_wk != OLD.dbt_wk AND OLD.dbt_wk = OLD.act_dbt_wk and new.dbt_wk < new.erlstmkdnwk and old.dbt_wk >= old.plan_current) then

    UPDATE blk_ma_stylecolorchannelattributes
    SET act_dbt_wk = NEW.dbt_wk
    WHERE
    product = NEW.product
    and location = NEW.location;

end if;

if (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate AND (old.dbt_wk > old.plan_current OR old.exitdate > old.plan_current) AND new.exitdate > new.erlstmkdnwk)
then
  update blk_ma_stylecolorchannelattributes
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


v_relaunch_dbtwk_indx := (select indx from blk_d_time where id = ''||NEW.relaunch_dbt_wk||'');
v_relaunch_irw_indx := v_relaunch_dbtwk_indx - 0;
v_relaunch_mdstart_indx := (select indx  from blk_d_time where id = ''||NEW.relaunch_erlstmkdnwk||'');
v_relaunch_exitdate_indx := (select indx  from blk_d_time where id = ''||NEW.relaunch_exitdate||'');
v_relaunch_initrcptwk := (select id from blk_d_time where indx= v_relaunch_irw_indx);
v_relaunch_last_rcpt_wk_indx := (select indx  from blk_d_time where id = ''||NEW.relaunch_last_rcpt_wk||'');

if 
(
	new.relaunch_dbt_wk < new.relaunch_erlstmkdnwk 
	AND new.relaunch_erlstmkdnwk < new.relaunch_exitdate 
	AND 
	(
		old.relaunch_dbt_wk > old.plan_current OR old.relaunch_exitdate > old.plan_current
	) 
	AND new.relaunch_exitdate > new.relaunch_erlstmkdnwk
)
then
  update blk_ma_stylecolorchannelattributes
  set
  relaunch_initrcptwk_indx = v_relaunch_irw_indx,
  relaunch_dbt_wk_indx = v_relaunch_dbtwk_indx,
  relaunch_erlstmkdnwk_indx = v_relaunch_mdstart_indx,
  relaunch_exitdate_indx = v_relaunch_exitdate_indx,
  relaunch_too = v_relaunch_mdstart_indx - v_relaunch_dbtwk_indx,
  relaunch_mkdnwks = v_relaunch_exitdate_indx - v_relaunch_mdstart_indx,
  relaunch_initrcptwk = v_relaunch_initrcptwk,
  relaunch_last_rcpt_wk_indx = v_relaunch_last_rcpt_wk_indx
  WHERE
  product = NEW.product
  and location = NEW.location;

end if;



RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

--
-- TOC entry 2182 (class 1255 OID 134214660)
-- Name: updatescname_if_style_changed(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.updatescname_if_style_changed() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    DROP TABLE IF EXISTS sc_w_changed_styles;
    CREATE TEMPORARY TABLE sc_w_changed_styles AS
    SELECT
        dpsc.id as stylecolor_id,
        dps.name || '.' || sca.cccolorid as stylecolor_name,
        dps.description || ' ' || sca.cc_color_desc as stylecolor_description
    FROM blk_d_product dpsc
    INNER JOIN blk_h_prodstd hps
        ON hps.id = dpsc.id
    INNER JOIN blk_ma_stylecolorattributes sca
        ON sca.product = dpsc.id
    INNER JOIN blk_d_product dps
        ON hps.ancestor0 = dps.id
    WHERE 
        dpsc.levelid = 'stylecolor'
        AND dpsc.id = NEW.id;

    UPDATE blk_d_product dp SET
        name = stylecolor_name,
        description = stylecolor_description
    FROM sc_w_changed_styles scwcs
    WHERE dp.id = scwcs.stylecolor_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.updatescname_if_style_changed() OWNER TO psql;

--
-- TOC entry 2179 (class 1255 OID 129294864)
-- Name: validate_relaunch_is_valid(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_relaunch_is_valid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Case A: Prevent setting relaunch_is_valid = TRUE when relaunch_dbt_wk is NULL.
    IF NEW.relaunch_is_valid = TRUE
       AND (OLD.relaunch_is_valid IS DISTINCT FROM TRUE)  -- transitioning to TRUE
       AND NEW.relaunch_dbt_wk IS NULL
    THEN
        NEW.relaunch_is_valid := FALSE;
    END IF;

    -- Case B: If relaunch_is_valid is changed from TRUE to FALSE,
    -- then clear the related columns.
    IF (OLD.relaunch_is_valid = TRUE)
       AND (NEW.relaunch_is_valid = FALSE)
    THEN
        NEW.relaunch_dbt_wk              := NULL;
        NEW.relaunch_erlstmkdnwk         := NULL;
        NEW.relaunch_exitdate            := NULL;
        NEW.relaunch_initrcptwk          := NULL;
        NEW.relaunch_too                 := NULL;
        NEW.relaunch_mkdnwks             := NULL;
        NEW.relaunch_last_rcpt_wk        := NULL;
        NEW.relaunch_planned_sell_down_week := NULL;
        NEW.relaunch_cc_cluster_group    := NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_relaunch_is_valid() OWNER TO psql;

--
-- TOC entry 2180 (class 1255 OID 129294865)
-- Name: validate_transform_uploads_ata(text, text, text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_transform_uploads_ata(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) RETURNS record
    LANGUAGE plpgsql
    AS $_$
DECLARE

v_template_id  text;

BEGIN 

--delete from staging_addtoassortment a where __txid = v__txid and __uid = v__uid and style_id is null and color_id is null;

update staging_addtoassortment a
set row_indx = b.rowindx
from (select x.*, row_number() over () as rowindx from staging_addtoassortment x where __txid = v__txid and style_id is not null and color_id is not null) b
where a.__txid = v__txid and a.style_id = b.style_id and a.color_id = b.color_id
and a.style_id is not null and a.color_id is not null;

update staging_addtoassortment a
set row_indx = 0
where a.__txid = v__txid
and (a.style_id is null or a.color_id is null);

-- SUP-4003 Depricate old Code. Software does not allow bad data to come in now. This is not needed.
--update staging_addtoassortment
--set style_id = case when style_id ~ '^[0-9]+\.?[0-9]*[Ee][0-9]+$' then ROUND(style_id::numeric)::bigint::text when style_id ~ '^[0-9]+\.?[0-9]$' then regexp_replace(style_id, '\..*$', '') else style_id end,
--color_id = case when color_id ~ '^[0-9]+\.?[0-9]$' then regexp_replace(color_id, '\..*$', '') else color_id end
--where __txid = v__txid and row_indx <> 0;

DROP TABLE IF EXISTS temp_staging_addtoassortment_unique_val
;

CREATE TEMPORARY TABLE temp_staging_addtoassortment_unique_val on commit drop
as 
select 
-- SUP-4003 Depricate old Code. Software does not allow bad data to come in now. This is not needed.
--case when style_id ~ '^[0-9]+\.?[0-9]*[Ee][0-9]+$' then ROUND(style_id::numeric)::bigint::text when style_id ~ '^[0-9]+\.?[0-9]$' then regexp_replace(style_id, '\..*$', '') else style_id end as style_id,
style_id,
style_description,
regexp_replace(department, '\..*$', '') department,
dept_name,
regexp_replace(class, '\..*$', '') class,
class_name,
-- SUP-4003 Depricate old Code. Software does not allow bad data to come in now. This is not needed.
--case when supplier_site_id ~ '^[0-9]+\.?[0-9]*[Ee][0-9]+$' then ROUND(supplier_site_id::numeric)::bigint::text when supplier_site_id ~ '^[0-9]+\.?[0-9]$' then regexp_replace(supplier_site_id, '\..*$', '') else supplier_site_id end as supplier_site_id,
supplier_site_id,
supplier_site_name,
style_type,
vpn_id_non_plm,
regexp_replace(color_id, '\..*$', '') color_id,
merch_color_name,
original_price,
target_cost,
debut_week,
markdown_week,
exit_week,
sales_rating,
pres_min,
pres_min_weeks,
receipt_interval,
store_min_multiple,
service_level,
dropship_indicator,
replenishment_indicator,
program_name,
segment_buy,
silhouette,
subcategory,
selling_season,
selling_year,
aa_indicator,
bottom_fit,
categories,
classification,
collegiate,
cut_fit,
denim_trends,
fabric_desc,
fashion_vs_basic,
graphic_type,
levi_fits,
print_type,
print_vs_solid,
short_inseam,
sleeve_length,
superbuy_ind,
young_contemporary,
bottom_silo,
d_cup_avail,
denim_rise,
dress_length,
fit_solution,
inseam,
lounge_vs_sleep,
neckline,
occasion,
robe,
top_length,
cc_set,
construction,
fashion_jewelry,
jewelry_presentation,
material_color,
material_type,
necklaces,
texture_pattern,
fragrance_scents,
level_of_presentation,
makeup_total_eye,
makeup_total_face,
makeup_total_lip,
skincare_total_face,
total_fragrance,
total_makeup,
total_skincare,
bracelets,
bridal,
chain_type,
ctw_fine_jewelry,
dial_color,
dtw_fine_dewelry,
ears,
fine_jewelry_metal,
gold_mkt_fine_jewelry,
grams_fine_jewelry,
high_value_status,
metal_type,
ring,
silver_grams,
silver_mkt_fine_jewelry,
stone,
watch,
bedding_acc,
bridal_registry,
coastal_ind,
cc_configuration,
custom_need,
material,
white_dinnerware_ind,
closure,
heel_height,
heel_type,
outsole,
shaft_height,
shoe_type,
sketchers_div,
sole_type,
tech_features,
toe_character,
toe_type,
width, 
__status,
__txid,
__uid,
__timestamp,
__error_msg,
row_indx,
row_number() over (partition by style_id, color_id order by color_id) rn 
from staging_addtoassortment a
where a.__txid=v__txid
and style_id is not null and color_id is not null
;

CREATE INDEX temp_staging_addtoassortment_indx ON temp_staging_addtoassortment_unique_val (style_id, color_id);



-- --------------------------------------
-- PART 1
-- Product Validation
-- --------------------------------------

DROP TABLE IF EXISTS temp_prod_val_reject;
CREATE TEMPORARY TABLE temp_prod_val_reject 
(row_indx int, rn int, __txid text, style_id text, color_id text, err_msg text) on commit drop;


--
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Cannot recreate an existing StyleColor' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and style_id || '.' || color_id in (select name from blk_d_product where levelid='stylecolor')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, style_id, color_id, 'style_id cannot be blank' err_msg 
from staging_addtoassortment 
where __txid=v__txid
and style_id is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, style_id, color_id, 'style_id can only contain Alphanumeric characters and underscores without spaces' err_msg 
from staging_addtoassortment 
where __txid=v__txid
and style_id !~ '^[A-Za-z0-9_.]+$'
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'style_description cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and style_description is null
-- and rn=1
;

-- SUP-4254 description cannot contain non-printable characters
INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'style_description has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(style_description, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when style_description ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and style_description ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Same style_id cannot have more than one style_description' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and style_id in (select distinct style_id from (select distinct style_id, count(distinct style_description) from temp_staging_addtoassortment_unique_val where __txid=v__txid group by style_id having count(distinct style_description) > 1)x)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'department cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and department is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'class cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and class is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, 0 as rn, __txid, style_id, color_id, 'color_id cannot be blank' err_msg 
from staging_addtoassortment 
where __txid=v__txid
and color_id is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'style_type cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and style_type is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'original_price cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and original_price is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'target_cost cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and target_cost is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'debut_week cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and debut_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'markdown_week cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and markdown_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'exit_week cannot be blank' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and exit_week is null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Lifecycle not in plan horizon' err_msg 
from temp_staging_addtoassortment_unique_val a, 
(select value as plan_current from blk_serviceparams where id = 'plan_current') b,
(select value as plan_end from blk_serviceparams where id = 'plan_end') c
where __txid=v__txid
and debut_week is not null and UPPER(debut_week) in (select id from blk_d_time where levelid='week')
and markdown_week is not null and UPPER(markdown_week) in (select id from blk_d_time where levelid='week')
and exit_week is not null and UPPER(exit_week) in (select id from blk_d_time where levelid='week')
and
(
  debut_week < plan_current or debut_week > plan_end or
  markdown_week < plan_current or markdown_week > plan_end or
  exit_week < plan_current or exit_week > plan_end
)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid Department' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and 'DP-' || department not in (select id from blk_d_product where levelid='department')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid Class' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and 'CL-' || class not in (select id from blk_d_product where levelid='class')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid Department and Class combo' err_msg 
from temp_staging_addtoassortment_unique_val a, blk_h_prodstd b
where __txid=v__txid
and 'CL-' || class in (select id from blk_d_product where levelid='class')
and 'DP-' || department in (select id from blk_d_product where levelid='department')
and 'CL-' || class = b.id and 'DP-' || department <> ancestor0
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid STYLE_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and style_type is not null and style_type not in ('PLM', 'NON-PLM')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'vpn_id_non_plm cannot have a value for PLM style' err_msg
from temp_staging_addtoassortment_unique_val
where __txid=v__txid
and style_type is not null and style_type = 'PLM'
and vpn_id_non_plm is not null
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Same style_id cannot have more than one vpn_id_non_plm' err_msg
from temp_staging_addtoassortment_unique_val
where __txid=v__txid
and style_id in (select distinct style_id from (select distinct style_id, count(distinct vpn_id_non_plm) from temp_staging_addtoassortment_unique_val where __txid=v__txid and style_type = 'NON-PLM' and vpn_id_non_plm is not null group by style_id having count(distinct vpn_id_non_plm) > 1)x)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Same style_id cannot have more than one supplier_site_id' err_msg
from temp_staging_addtoassortment_unique_val
where __txid=v__txid
and style_id in (select distinct style_id from (select distinct style_id, count(distinct supplier_site_id) from temp_staging_addtoassortment_unique_val where __txid=v__txid group by style_id having count(distinct supplier_site_id) > 1)x)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Same style_id cannot have more than one class' err_msg
from temp_staging_addtoassortment_unique_val
where __txid=v__txid
and style_id in (select distinct style_id from (select distinct style_id, count(distinct class) from temp_staging_addtoassortment_unique_val where __txid=v__txid group by style_id having count(distinct class) > 1)x)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Same style_id cannot have more than one department' err_msg
from temp_staging_addtoassortment_unique_val
where __txid=v__txid
and style_id in (select distinct style_id from (select distinct style_id, count(distinct department) from temp_staging_addtoassortment_unique_val where __txid=v__txid group by style_id having count(distinct department) > 1)x)
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SUPPLIER_SITE_ID' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and ('DP-' || department, supplier_site_id) not in 
(select distinct lookup_value, target_value from blk_l_dependencylookup where lookup_id = 'department' and target_id = 'supp_supplier_site_id')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid COLOR_ID' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (color_id) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cccolorid')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid DROPSHIP_INDICATOR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (dropship_indicator) not in ('Y', 'N')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid REPLENISHMENT_INDICATOR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (replenishment_indicator) not in ('Y', 'N')
-- and rn=1
;


INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Clusters not approved for this Department and Quarter' err_msg 
from temp_staging_addtoassortment_unique_val a, blk_h_timestd b
where __txid=v__txid and a.debut_week = b.id
and ('DP-' || department, ancestor1) not in (select product, time from blk_p_approvedclusters where clustering_status = 1)
-- and rn=1
;


INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SEGMENT_BUY' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (segment_buy) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_segment_buy')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SILHOUETTE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (silhouette) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_silhouette')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SUBCATEGORY' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (subcategory) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_subcategory')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SELLING_SEASON' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (selling_season) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_selling_season')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SELLING_YEAR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (selling_year) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_selling_year')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid AA_INDICATOR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (AA_INDICATOR) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_aa_ind')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BOTTOM_FIT' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BOTTOM_FIT) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bottom_fit')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CATEGORIES' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CATEGORIES) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_categories')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CLASSIFICATION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CLASSIFICATION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_classification')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid COLLEGIATE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (COLLEGIATE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_collegiate')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CUT_FIT' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CUT_FIT) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_cut_fit')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid DENIM_TRENDS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (DENIM_TRENDS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_denim_trends')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FABRIC_DESC' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FABRIC_DESC) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fabric_description')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FASHION_VS_BASIC' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FASHION_VS_BASIC) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fashion_vs_basic')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid GRAPHIC_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (GRAPHIC_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_graphic_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid LEVI_FITS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (LEVI_FITS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_levi_fits')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid PRINT_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (PRINT_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_print_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid PRINT_VS_SOLID' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (PRINT_VS_SOLID) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_print_vs_solid')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SHORT_INSEAM' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SHORT_INSEAM) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_short_inseam')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SLEEVE_LENGTH' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SLEEVE_LENGTH) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_sleeve_length')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SUPERBUY_IND' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SUPERBUY_IND) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_superbuy_ind')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid YOUNG_CONTEMPORARY' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (YOUNG_CONTEMPORARY) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_young_contemporary')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BOTTOM_SILO' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BOTTOM_SILO) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bottom_silo')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid D_CUP_AVAIL' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (D_CUP_AVAIL) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_d_cup_available')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid DENIM_RISE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (DENIM_RISE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_denim_rise')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid DRESS_LENGTH' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (DRESS_LENGTH) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_dress_length')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FIT_SOLUTION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FIT_SOLUTION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fit_solution')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid INSEAM' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (INSEAM) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_inseam')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid LOUNGE_VS_SLEEP' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (LOUNGE_VS_SLEEP) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_lounge_vs_sleep')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid NECKLINE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (NECKLINE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_neckline')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid OCCASION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (OCCASION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_occasion')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid ROBE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (ROBE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_robe')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOP_LENGTH' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOP_LENGTH) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_top_length')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SET' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (cc_set) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_set')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CONSTRUCTION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CONSTRUCTION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_construction')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FASHION_JEWELRY' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FASHION_JEWELRY) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fashion_jewelry')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid JEWELRY_PRESENTATION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (JEWELRY_PRESENTATION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_jewelry_presentation')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MATERIAL_COLOR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MATERIAL_COLOR) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_material_color')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MATERIAL_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MATERIAL_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_material_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid NECKLACES' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (NECKLACES) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_necklaces')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TEXTURE_PATTERN' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TEXTURE_PATTERN) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_texture_pattern')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FRAGRANCE_SCENTS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FRAGRANCE_SCENTS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fragrance_scents')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid LEVEL_OF_PRESENTATION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (LEVEL_OF_PRESENTATION) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_level_of_presentation')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MAKEUP_TOTAL_EYE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MAKEUP_TOTAL_EYE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_makeup_total_eye')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MAKEUP_TOTAL_FACE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MAKEUP_TOTAL_FACE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_makeup_total_face')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MAKEUP_TOTAL_LIP' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MAKEUP_TOTAL_LIP) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_makeup_total_lip')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SKINCARE_TOTAL_FACE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SKINCARE_TOTAL_FACE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_skincare_total_face')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOTAL_FRAGRANCE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOTAL_FRAGRANCE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_total_fragrance')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOTAL_MAKEUP' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOTAL_MAKEUP) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_total_makeup')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOTAL_SKINCARE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOTAL_SKINCARE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_total_skincare')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BRACELETS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BRACELETS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bracelets')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BRIDAL' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BRIDAL) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bridal')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CHAIN_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CHAIN_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_chain_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid DIAL_COLOR' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (DIAL_COLOR) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_dial_color')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid EARS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (EARS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_ears')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid FINE_JEWELRY_METAL' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (FINE_JEWELRY_METAL) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_fine_jewelry_metal')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid HIGH_VALUE_STATUS' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (HIGH_VALUE_STATUS) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_high_value_status')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid METAL_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (METAL_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_metal_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid RING' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (RING) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_ring')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid STONE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (STONE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_stone')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid WATCH' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (WATCH) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_watch')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BEDDING_ACC' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BEDDING_ACC) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bedding_accessories')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid BRIDAL_REGISTRY' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (BRIDAL_REGISTRY) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_bridal_registry')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid COASTAL_IND' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (COASTAL_IND) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_coastal_ind')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CONFIGURATION' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (cc_configuration) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_configuration')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CUSTOM_NEED' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CUSTOM_NEED) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_customer_need')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid MATERIAL' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (MATERIAL) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_material')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid WHITE_DINNERWARE_IND' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (WHITE_DINNERWARE_IND) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_white_dinnerware_ind')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid CLOSURE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (CLOSURE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_closure')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid HEEL_HEIGHT' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (HEEL_HEIGHT) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_heel_height')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid HEEL_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (HEEL_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_heel_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid OUTSOLE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (OUTSOLE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_outsole')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SHAFT_HEIGHT' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SHAFT_HEIGHT) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_shaft_height')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SHOE_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SHOE_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_shoe_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SKETCHERS_DIV' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SKETCHERS_DIV) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_skechers_division')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid SOLE_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (SOLE_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_sole_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TECH_FEATURES' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TECH_FEATURES) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_tech_features')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOE_CHARACTER' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOE_CHARACTER) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_toe_character')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid TOE_TYPE' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (TOE_TYPE) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_toe_type')
-- and rn=1
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id, 'Invalid WIDTH' err_msg 
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and (WIDTH) not in 
(select distinct attributekey from blk_v_memberbasedvalidvalues where attributeid = 'cc_width')
-- and rn=1
;

-- SUP-4254 - Only allow alphanumeric characters, spaces, underscores, and hyphens

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'vpn_id_non_plm has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(vpn_id_non_plm, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when vpn_id_non_plm ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and vpn_id_non_plm ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'merch_color_name has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(merch_color_name, '[^a-zA-Z0-9 _/-]', 'g'))[1] as err_msg,
    case when merch_color_name ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and merch_color_name ~ '[^a-zA-Z0-9 _/-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'program_name has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(program_name, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when program_name ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and program_name ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'ctw_fine_jewelry has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(ctw_fine_jewelry, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when ctw_fine_jewelry ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and ctw_fine_jewelry ~ '[^a-zA-Z0-9 _-]'
) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'dtw_fine_dewelry has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(dtw_fine_dewelry, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when dtw_fine_dewelry ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and dtw_fine_dewelry ~ '[^a-zA-Z0-9 _-]'
) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'gold_mkt_fine_jewelry has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(gold_mkt_fine_jewelry, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when gold_mkt_fine_jewelry ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and gold_mkt_fine_jewelry ~ '[^a-zA-Z0-9 _-]'
) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'grams_fine_jewelry has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(grams_fine_jewelry, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when grams_fine_jewelry ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and grams_fine_jewelry ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'silver_grams has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(silver_grams, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when silver_grams ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and silver_grams ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;

INSERT INTO temp_prod_val_reject
select row_indx, rn, __txid, style_id, color_id,
    'silver_mkt_fine_jewelry has invalid characters ' || array_to_string(array_agg(DISTINCT err_msg), ' ') || carriage_return AS err_msg
from 
(
	select row_indx, rn, __txid, style_id, color_id, 
    (regexp_matches(silver_mkt_fine_jewelry, '[^a-zA-Z0-9 _-]', 'g'))[1] as err_msg,
    case when silver_mkt_fine_jewelry ~ E'\\r|\\n' then ' carriage return' else '' end as carriage_return
	from temp_staging_addtoassortment_unique_val 
	where __txid=v__txid
	and silver_mkt_fine_jewelry ~ '[^a-zA-Z0-9 _-]'

) sub
GROUP BY row_indx, rn, __txid, style_id, color_id, carriage_return
;


-- --------------------------------------
-- PART 2
-- LIFECYCLE VALIDATION
-- --------------------------------------


DROP TABLE IF EXISTS temp_time_val;
CREATE TEMPORARY TABLE temp_time_val 
(
row_indx int, rn int, __txid text, style_id text, color_id text,
debut_week text,
markdown_week text,
exit_week text,
md_before_dbt int,
exit_before_dbt int,
exit_before_md int,
lifecycle_issue int
) on commit drop;

DROP TABLE IF EXISTS temp_time_val_reject;
CREATE TEMPORARY TABLE temp_time_val_reject
(
row_indx int, rn int, __txid text, style_id text, color_id text,
debut_week text,
markdown_week text,
exit_week text,
md_before_dbt int,
exit_before_dbt int,
exit_before_md int,
lifecycle_issue int
) on commit drop;

INSERT INTO temp_time_val
select 
row_indx
, rn
, __txid
, style_id
, color_id 
, UPPER(debut_week) as debut_week
, UPPER(markdown_week) as markdown_week
, UPPER(exit_week) as exit_week
, CASE WHEN (UPPER(markdown_week) < UPPER(debut_week)) THEN 1 else 0 END as md_before_dbt
, CASE WHEN (UPPER(exit_week) < UPPER(debut_week)) THEN 1 else 0 END as exit_before_dbt
, CASE WHEN (UPPER(exit_week) <= UPPER(markdown_week)) THEN 1 else 0 END as exit_before_md
, CASE WHEN (UPPER(markdown_week) < UPPER(debut_week)) OR (UPPER(exit_week) <= UPPER(markdown_week)) THEN 1 else 0 END as lifecycle_issue
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and UPPER(debut_week) in (select id from blk_d_time where levelid='week')
and UPPER(markdown_week) in (select id from blk_d_time where levelid='week')
and UPPER(exit_week) in (select id from blk_d_time where levelid='week')
;


INSERT INTO temp_time_val_reject
select 
row_indx
, rn
, __txid
, style_id
, color_id
, debut_week
, markdown_week
, exit_week
, CASE WHEN (UPPER(markdown_week) < UPPER(debut_week)) THEN 1 else 0 END as md_before_dbt
, CASE WHEN (UPPER(exit_week) < UPPER(debut_week)) THEN 1 else 0 END as exit_before_dbt
, CASE WHEN (UPPER(exit_week) <= UPPER(markdown_week)) THEN 1 else 0 END as exit_before_md
, CASE WHEN (UPPER(markdown_week) < UPPER(debut_week)) OR (UPPER(exit_week) <= UPPER(markdown_week)) THEN 1 else 0 END as lifecycle_issue
from temp_staging_addtoassortment_unique_val 
where __txid=v__txid
and 
(
   debut_week is null or UPPER(debut_week) not in (select id from blk_d_time where levelid='week')
OR markdown_week is null or UPPER(markdown_week) not in (select id from blk_d_time where levelid='week')
OR exit_week is null or UPPER(exit_week) not in (select id from blk_d_time where levelid='week')
)
;




-- --------------------------------------
-- PART 3
-- PARAM DATA VALIDATION
-- --------------------------------------




DROP TABLE IF EXISTS temp_all_datatype_val_reject;
CREATE TEMPORARY TABLE temp_all_datatype_val_reject  on commit drop
AS 
SELECT row_indx, rn, style_id, color_id, err_msg
FROM 
(
select row_indx, rn, style_id, color_id, sales_rating, 'Invalid: sales_rating' as err_msg from temp_staging_addtoassortment_unique_val where sales_rating is not null and cast(sales_rating as real)::text not in (select attributekey from blk_v_memberbasedvalidvalues where attributeid = 'slsrnk')
union all
select row_indx, rn, style_id, color_id, original_price, 'Invalid: original_price' as err_msg from temp_staging_addtoassortment_unique_val where original_price is null or ( original_price is not null and not (regexp_replace(original_price,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, style_id, color_id, target_cost, 'Invalid: target_cost' as err_msg from temp_staging_addtoassortment_unique_val where target_cost is null or ( target_cost is not null and not (regexp_replace(target_cost,'\$', '') ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
union all
select row_indx, rn, style_id, color_id, pres_min, 'Invalid: pres_min' as err_msg from temp_staging_addtoassortment_unique_val where ( pres_min is not null and not (pres_min ~* '^\d+$'))
union all
select row_indx, rn, style_id, color_id, pres_min_weeks, 'Invalid: pres_min_weeks' as err_msg from temp_staging_addtoassortment_unique_val where ( pres_min_weeks is not null and not (pres_min_weeks ~* '^\d+$'))
union all
select row_indx, rn, style_id, color_id, receipt_interval, 'Invalid: receipt_interval' as err_msg from temp_staging_addtoassortment_unique_val where ( receipt_interval is not null and not (receipt_interval ~* '^\d+$'))
union all
select row_indx, rn, style_id, color_id, store_min_multiple, 'Invalid: store_min_multiple' as err_msg from temp_staging_addtoassortment_unique_val where ( store_min_multiple is not null and not (store_min_multiple ~* '^\d+$'))
union all
select row_indx, rn, style_id, color_id, service_level, 'Invalid: service_level' as err_msg from temp_staging_addtoassortment_unique_val where ( service_level is not null and not (service_level ~* '^(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?$'))
) x
;


-- --------------------------------------
-- Combine Everything
-- --------------------------------------


create temporary table temp_consolidated_time_val_reject on commit drop
AS 
select row_indx, rn, style_id, color_id, err_msg
from 
(
select row_indx, rn, style_id, color_id, debut_week, 'Invalid Debut Week' as err_msg from temp_time_val_reject where debut_week is null or UPPER(debut_week) not in (select id from blk_d_time where levelid='week')
UNION ALL 
select row_indx, rn, style_id, color_id, markdown_week, 'Invalid MD Week' as err_msg from temp_time_val_reject where markdown_week is null or UPPER(markdown_week) not in (select id from blk_d_time where levelid='week')
UNION ALL 
select row_indx, rn, style_id, color_id, exit_week, 'Invalid Exit Week' as err_msg from temp_time_val_reject where exit_week is null or UPPER(exit_week) not in (select id from blk_d_time where levelid='week')
UNION ALL 
select row_indx, rn, style_id, color_id, exit_week, 'MD Before Debut' as err_msg from temp_time_val where md_before_dbt=1
UNION ALL 
select row_indx, rn, style_id, color_id, exit_week, 'Exit Before Debut' as err_msg from temp_time_val where exit_before_dbt=1
UNION ALL 
select row_indx, rn, style_id, color_id, exit_week, 'Exit Before or Same as MD' as err_msg from temp_time_val where exit_before_md=1
)x;

create temporary table temp_product_val_reject on commit drop
AS 
select row_indx, rn, style_id, color_id, err_msg
from 
temp_prod_val_reject
;

create temporary table temp_final_all_reject on commit drop
AS 
select row_indx, rn, style_id, color_id, ARRAY_AGG(err_msg) from 
(
    select distinct row_indx, rn, style_id, color_id, err_msg from 
    (
        select row_indx, rn, style_id, color_id, err_msg from temp_all_datatype_val_reject
        UNION ALL 
        select row_indx, rn, style_id, color_id, err_msg from temp_consolidated_time_val_reject
        UNION ALL 
        select row_indx, rn, style_id, color_id, err_msg from temp_prod_val_reject
    ) x 
) y group by row_indx, rn, style_id, color_id
;

DROP TABLE IF EXISTS temp_final_good_kids;
CREATE TEMPORARY TABLE temp_final_good_kids 
(
style_id                        text,
style_description               text,
department                      text,
dept_name                       text,
class                           text,
class_name                      text,
supplier_site_id                text,
supplier_site_name              text,
style_type                      text,
vpn_id_non_plm                  text,
color_id                        text,
merch_color_name                text,
original_price                  text,
target_cost                     text,
debut_week                      text,
markdown_week                   text,
exit_week                       text,
sales_rating                    text,
pres_min                        text,
pres_min_weeks                  text,
receipt_interval                text,
store_min_multiple              text,
service_level                   text,
dropship_indicator              text,
replenishment_indicator         text,
program_name                    text,
segment_buy                     text,
silhouette                      text,
subcategory                     text,
selling_season                  text,
selling_year                    text,
aa_indicator                    text,
bottom_fit                      text,
categories                      text,
classification                  text,
collegiate                      text,
cut_fit                         text,
denim_trends                    text,
fabric_desc                     text,
fashion_vs_basic                text,
graphic_type                    text,
levi_fits                       text,
print_type                      text,
print_vs_solid                  text,
short_inseam                    text,
sleeve_length                   text,
superbuy_ind                    text,
young_contemporary              text,
bottom_silo                     text,
d_cup_avail                     text,
denim_rise                      text,
dress_length                    text,
fit_solution                    text,
inseam                          text,
lounge_vs_sleep                 text,
neckline                        text,
occasion                        text,
robe                            text,
top_length                      text,
cc_set                          text,
construction                    text,
fashion_jewelry                 text,
jewelry_presentation            text,
material_color                  text,
material_type                   text,
necklaces                       text,
texture_pattern                 text,
fragrance_scents                text,
level_of_presentation           text,
makeup_total_eye                text,
makeup_total_face               text,
makeup_total_lip                text,
skincare_total_face             text,
total_fragrance                 text,
total_makeup                    text,
total_skincare                  text,
bracelets                       text,
bridal                          text,
chain_type                      text,
ctw_fine_jewelry                text,
dial_color                      text,
dtw_fine_dewelry                text,
ears                            text,
fine_jewelry_metal              text,
gold_mkt_fine_jewelry           text,
grams_fine_jewelry              text,
high_value_status               text,
metal_type                      text,
ring                            text,
silver_grams                    text,
silver_mkt_fine_jewelry         text,
stone                           text,
watch                           text,
bedding_acc                     text,
bridal_registry                 text,
coastal_ind                     text,
cc_configuration                text,
custom_need                     text,
material                        text,
white_dinnerware_ind            text,
closure                         text,
heel_height                     text,
heel_type                       text,
outsole                         text,
shaft_height                    text,
shoe_type                       text,
sketchers_div                   text,
sole_type                       text,
tech_features                   text,
toe_character                   text,
toe_type                        text,
width                           text
, __status text
, __txid text
, __uid text
, __timestamp timestamp without time zone
, rn integer
, row_indx integer
) on commit drop;

insert into temp_final_good_kids
select 
style_id,
style_description,
department,
dept_name,
class,
class_name,
supplier_site_id,
supplier_site_name,
style_type,
vpn_id_non_plm,
color_id,
merch_color_name,
original_price,
target_cost,
debut_week,
markdown_week,
exit_week,
sales_rating,
pres_min,
pres_min_weeks,
receipt_interval,
store_min_multiple,
service_level,
dropship_indicator,
replenishment_indicator,
program_name,
segment_buy,
silhouette,
subcategory,
selling_season,
selling_year,
aa_indicator,
bottom_fit,
categories,
classification,
collegiate,
cut_fit,
denim_trends,
fabric_desc,
fashion_vs_basic,
graphic_type,
levi_fits,
print_type,
print_vs_solid,
short_inseam,
sleeve_length,
superbuy_ind,
young_contemporary,
bottom_silo,
d_cup_avail,
denim_rise,
dress_length,
fit_solution,
inseam,
lounge_vs_sleep,
neckline,
occasion,
robe,
top_length,
cc_set,
construction,
fashion_jewelry,
jewelry_presentation,
material_color,
material_type,
necklaces,
texture_pattern,
fragrance_scents,
level_of_presentation,
makeup_total_eye,
makeup_total_face,
makeup_total_lip,
skincare_total_face,
total_fragrance,
total_makeup,
total_skincare,
bracelets,
bridal,
chain_type,
ctw_fine_jewelry,
dial_color,
dtw_fine_dewelry,
ears,
fine_jewelry_metal,
gold_mkt_fine_jewelry,
grams_fine_jewelry,
high_value_status,
metal_type,
ring,
silver_grams,
silver_mkt_fine_jewelry,
stone,
watch,
bedding_acc,
bridal_registry,
coastal_ind,
cc_configuration,
custom_need,
material,
white_dinnerware_ind,
closure,
heel_height,
heel_type,
outsole,
shaft_height,
shoe_type,
sketchers_div,
sole_type,
tech_features,
toe_character,
toe_type,
width
, __status::text
, __txid::text
, __uid::text
, __timestamp
, ROW_NUMBER() OVER (PARTITION BY style_id, color_id) as rn
, row_indx
FROM 
    temp_staging_addtoassortment_unique_val 
where 
    (row_indx) not in (select row_indx from temp_final_all_reject)
;

create temporary table temp_final_final_all_reject on commit drop
AS 
select row_indx, rn, style_id, color_id, ARRAY_AGG(err_msg) as error_msg from 
(
    select distinct row_indx, rn, style_id, color_id, err_msg from 
    (
        select row_indx, rn, style_id, color_id, err_msg from temp_all_datatype_val_reject
        UNION ALL 
        select row_indx, rn, style_id, color_id, err_msg from temp_consolidated_time_val_reject
        UNION ALL 
        select row_indx, rn, style_id, color_id, err_msg from temp_prod_val_reject
        UNION ALL 
        select row_indx, rn, style_id, color_id, 'Duplicate Record' as err_msg from temp_final_good_kids where rn > 1
    ) x 
) y group by row_indx, rn, style_id, color_id
;


insert into shadow_addtoassortment
(
    style_id,
    style_description,
    department,
    dept_name,
    class,
    class_name,
    supplier_site_id,
    supplier_site_name,
    style_type,
    vpn_id_non_plm,
    color_id,
    merch_color_name,
    original_price,
    target_cost,
    debut_week,
    markdown_week,
    exit_week,
    sales_rating,
    pres_min,
    pres_min_weeks,
    receipt_interval,
    store_min_multiple,
    service_level,
    dropship_indicator,
    replenishment_indicator,
    program_name,
    segment_buy,
    silhouette,
    subcategory,
    selling_season,
    selling_year,
    aa_indicator,
    bottom_fit,
    categories,
    classification,
    collegiate,
    cut_fit,
    denim_trends,
    fabric_desc,
    fashion_vs_basic,
    graphic_type,
    levi_fits,
    print_type,
    print_vs_solid,
    short_inseam,
    sleeve_length,
    superbuy_ind,
    young_contemporary,
    bottom_silo,
    d_cup_avail,
    denim_rise,
    dress_length,
    fit_solution,
    inseam,
    lounge_vs_sleep,
    neckline,
    occasion,
    robe,
    top_length,
    cc_set,
    construction,
    fashion_jewelry,
    jewelry_presentation,
    material_color,
    material_type,
    necklaces,
    texture_pattern,
    fragrance_scents,
    level_of_presentation,
    makeup_total_eye,
    makeup_total_face,
    makeup_total_lip,
    skincare_total_face,
    total_fragrance,
    total_makeup,
    total_skincare,
    bracelets,
    bridal,
    chain_type,
    ctw_fine_jewelry,
    dial_color,
    dtw_fine_dewelry,
    ears,
    fine_jewelry_metal,
    gold_mkt_fine_jewelry,
    grams_fine_jewelry,
    high_value_status,
    metal_type,
    ring,
    silver_grams,
    silver_mkt_fine_jewelry,
    stone,
    watch,
    bedding_acc,
    bridal_registry,
    coastal_ind,
    cc_configuration,
    custom_need,
    material,
    white_dinnerware_ind,
    closure,
    heel_height,
    heel_type,
    outsole,
    shaft_height,
    shoe_type,
    sketchers_div,
    sole_type,
    tech_features,
    toe_character,
    toe_type,
    width,
    __status,
    __txid,
    __uid,
    __timestamp,
    row_indx
)
SELECT 
    style_id,
    style_description,
    department,
    dept_name,
    class,
    class_name,
    supplier_site_id,
    supplier_site_name,
    style_type,
    vpn_id_non_plm,
    color_id,
    merch_color_name,
    original_price,
    target_cost,
    debut_week,
    markdown_week,
    exit_week,
    sales_rating,
    pres_min,
    pres_min_weeks,
    receipt_interval,
    store_min_multiple,
    service_level,
    dropship_indicator,
    replenishment_indicator,
    program_name,
    segment_buy,
    silhouette,
    subcategory,
    selling_season,
    selling_year,
    aa_indicator,
    bottom_fit,
    categories,
    classification,
    collegiate,
    cut_fit,
    denim_trends,
    fabric_desc,
    fashion_vs_basic,
    graphic_type,
    levi_fits,
    print_type,
    print_vs_solid,
    short_inseam,
    sleeve_length,
    superbuy_ind,
    young_contemporary,
    bottom_silo,
    d_cup_avail,
    denim_rise,
    dress_length,
    fit_solution,
    inseam,
    lounge_vs_sleep,
    neckline,
    occasion,
    robe,
    top_length,
    cc_set,
    construction,
    fashion_jewelry,
    jewelry_presentation,
    material_color,
    material_type,
    necklaces,
    texture_pattern,
    fragrance_scents,
    level_of_presentation,
    makeup_total_eye,
    makeup_total_face,
    makeup_total_lip,
    skincare_total_face,
    total_fragrance,
    total_makeup,
    total_skincare,
    bracelets,
    bridal,
    chain_type,
    ctw_fine_jewelry,
    dial_color,
    dtw_fine_dewelry,
    ears,
    fine_jewelry_metal,
    gold_mkt_fine_jewelry,
    grams_fine_jewelry,
    high_value_status,
    metal_type,
    ring,
    silver_grams,
    silver_mkt_fine_jewelry,
    stone,
    watch,
    bedding_acc,
    bridal_registry,
    coastal_ind,
    cc_configuration,
    custom_need,
    material,
    white_dinnerware_ind,
    closure,
    heel_height,
    heel_type,
    outsole,
    shaft_height,
    shoe_type,
    sketchers_div,
    sole_type,
    tech_features,
    toe_character,
    toe_type,
    width,
    'pending_final_move',
    __txid,
    __uid,
    __timestamp,
    row_indx
from temp_final_good_kids
where rn=1
;


update staging_addtoassortment a
set __status = 'Validated' from shadow_addtoassortment b where a.row_indx=b.row_indx and a.style_id=b.style_id and a.color_id=b.color_id;

update staging_addtoassortment a
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
from staging_addtoassortment 
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
select row_indx as rowid, (style_id || color_id || __status || __error_msg) as message, *
from staging_addtoassortment where __status='Rejected' and __txid=v__txid;


RETURN;
END;
$_$;


ALTER FUNCTION public.validate_transform_uploads_ata(v__uid text, v__txid text, authorized_members text[], OUT stats refcursor, OUT messages refcursor) OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 1717 (class 1259 OID 129294867)
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
-- TOC entry 1718 (class 1259 OID 129294875)
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
-- TOC entry 1719 (class 1259 OID 129294882)
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
    error text,
    instance_id text
);


ALTER TABLE public.allocation_plan_queue OWNER TO psql;

--
-- TOC entry 1720 (class 1259 OID 129294889)
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
-- TOC entry 1721 (class 1259 OID 129294897)
-- Name: arc_bulkupload_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[],
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_a_assortment OWNER TO psql;

--
-- TOC entry 1722 (class 1259 OID 129294903)
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
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_d_product OWNER TO psql;

--
-- TOC entry 1723 (class 1259 OID 129294909)
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
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_h_prodstd OWNER TO psql;

--
-- TOC entry 1724 (class 1259 OID 129294915)
-- Name: arc_bulkupload_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_sizeattributes (
    product text,
    parent_id text,
    size_member_id text,
    sizeattribute text,
    source_member_id text,
    source_member_name text,
    sku_dropship_indicator text,
    sku_replenishment_flag text,
    sku_extended_size text,
    sku_status text,
    isvalid integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1725 (class 1259 OID 129294921)
-- Name: arc_bulkupload_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_styleattributes (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1726 (class 1259 OID 129294927)
-- Name: arc_bulkupload_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_stylecolorattributes (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1727 (class 1259 OID 129294933)
-- Name: arc_bulkupload_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.arc_bulkupload_ma_stylecolorchannelattributes (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.arc_bulkupload_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1728 (class 1259 OID 129294939)
-- Name: archives_addtoassortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_addtoassortment (
    style_id text,
    style_description text,
    department text,
    dept_name text,
    class text,
    class_name text,
    supplier_site_id text,
    supplier_site_name text,
    style_type text,
    vpn_id_non_plm text,
    color_id text,
    merch_color_name text,
    original_price text,
    target_cost text,
    debut_week text,
    markdown_week text,
    exit_week text,
    sales_rating text,
    pres_min text,
    pres_min_weeks text,
    receipt_interval text,
    store_min_multiple text,
    service_level text,
    dropship_indicator text,
    replenishment_indicator text,
    program_name text,
    segment_buy text,
    silhouette text,
    subcategory text,
    selling_season text,
    selling_year text,
    aa_indicator text,
    bottom_fit text,
    categories text,
    classification text,
    collegiate text,
    cut_fit text,
    denim_trends text,
    fabric_desc text,
    fashion_vs_basic text,
    graphic_type text,
    levi_fits text,
    print_type text,
    print_vs_solid text,
    short_inseam text,
    sleeve_length text,
    superbuy_ind text,
    young_contemporary text,
    bottom_silo text,
    d_cup_avail text,
    denim_rise text,
    dress_length text,
    fit_solution text,
    inseam text,
    lounge_vs_sleep text,
    neckline text,
    occasion text,
    robe text,
    top_length text,
    cc_set text,
    construction text,
    fashion_jewelry text,
    jewelry_presentation text,
    material_color text,
    material_type text,
    necklaces text,
    texture_pattern text,
    fragrance_scents text,
    level_of_presentation text,
    makeup_total_eye text,
    makeup_total_face text,
    makeup_total_lip text,
    skincare_total_face text,
    total_fragrance text,
    total_makeup text,
    total_skincare text,
    bracelets text,
    bridal text,
    chain_type text,
    ctw_fine_jewelry text,
    dial_color text,
    dtw_fine_dewelry text,
    ears text,
    fine_jewelry_metal text,
    gold_mkt_fine_jewelry text,
    grams_fine_jewelry text,
    high_value_status text,
    metal_type text,
    ring text,
    silver_grams text,
    silver_mkt_fine_jewelry text,
    stone text,
    watch text,
    bedding_acc text,
    bridal_registry text,
    coastal_ind text,
    cc_configuration text,
    custom_need text,
    material text,
    white_dinnerware_ind text,
    closure text,
    heel_height text,
    heel_type text,
    outsole text,
    shaft_height text,
    shoe_type text,
    sketchers_div text,
    sole_type text,
    tech_features text,
    toe_character text,
    toe_type text,
    width text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_addtoassortment OWNER TO psql;

--
-- TOC entry 1729 (class 1259 OID 129294945)
-- Name: archives_addtoassortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.archives_addtoassortment_bk (
    style_id text,
    style_description text,
    department text,
    dept_name text,
    class text,
    class_name text,
    supplier_site_id text,
    supplier_site_name text,
    style_type text,
    color_id text,
    original_price text,
    target_cost text,
    debut_week text,
    markdown_week text,
    exit_week text,
    sales_rating text,
    pres_min text,
    pres_min_weeks text,
    receipt_interval text,
    store_min_multiple text,
    service_level text,
    dropship_indicator text,
    replenishment_indicator text,
    program_name text,
    segment_buy text,
    silhouette text,
    subcategory text,
    selling_season text,
    selling_year text,
    aa_indicator text,
    bottom_fit text,
    categories text,
    classification text,
    collegiate text,
    cut_fit text,
    denim_trends text,
    fabric_desc text,
    fashion_vs_basic text,
    graphic_type text,
    levi_fits text,
    print_type text,
    print_vs_solid text,
    short_inseam text,
    sleeve_length text,
    superbuy_ind text,
    young_contemporary text,
    bottom_silo text,
    d_cup_avail text,
    denim_rise text,
    dress_length text,
    fit_solution text,
    inseam text,
    lounge_vs_sleep text,
    neckline text,
    occasion text,
    robe text,
    top_length text,
    cc_set text,
    construction text,
    fashion_jewelry text,
    jewelry_presentation text,
    material_color text,
    material_type text,
    necklaces text,
    texture_pattern text,
    fragrance_scents text,
    level_of_presentation text,
    makeup_total_eye text,
    makeup_total_face text,
    makeup_total_lip text,
    skincare_total_face text,
    total_fragrance text,
    total_makeup text,
    total_skincare text,
    bracelets text,
    bridal text,
    chain_type text,
    ctw_fine_jewelry text,
    dial_color text,
    dtw_fine_dewelry text,
    ears text,
    fine_jewelry_metal text,
    gold_mkt_fine_jewelry text,
    grams_fine_jewelry text,
    high_value_status text,
    metal_type text,
    ring text,
    silver_grams text,
    silver_mkt_fine_jewelry text,
    stone text,
    watch text,
    bedding_acc text,
    bridal_registry text,
    coastal_ind text,
    cc_configuration text,
    custom_need text,
    material text,
    white_dinnerware_ind text,
    closure text,
    heel_height text,
    heel_type text,
    outsole text,
    shaft_height text,
    shoe_type text,
    sketchers_div text,
    sole_type text,
    tech_features text,
    toe_character text,
    toe_type text,
    width text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone,
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.archives_addtoassortment_bk OWNER TO psql;

--
-- TOC entry 1730 (class 1259 OID 129294950)
-- Name: assort_period_from_dpt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.assort_period_from_dpt (
    department text NOT NULL,
    "time" text NOT NULL,
    floorset text
);


ALTER TABLE public.assort_period_from_dpt OWNER TO psql;

--
-- TOC entry 1731 (class 1259 OID 129294955)
-- Name: belk_p_pinchpo; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.belk_p_pinchpo (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    pinch_id text NOT NULL,
    nad text,
    nbd text,
    pinch_po_qty integer,
    pinch_validsizes text[],
    pinched_stores text[],
    created_at timestamp without time zone DEFAULT now(),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT now(),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.belk_p_pinchpo OWNER TO psql;

--
-- TOC entry 1732 (class 1259 OID 129294965)
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
-- TOC entry 1733 (class 1259 OID 129294970)
-- Name: blk_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[] DEFAULT '{NONE}'::text[],
    str_segmentation_or text[] DEFAULT '{NONE}'::text[],
    str_sub_segmentation_or text[] DEFAULT '{NONE}'::text[],
    str_aa_ind_or text[] DEFAULT '{NONE}'::text[],
    str_hisp_ind_or text[] DEFAULT '{NONE}'::text[],
    str_lifestyle_01_or text[] DEFAULT '{NONE}'::text[],
    str_lifestyle_02_or text[] DEFAULT '{NONE}'::text[],
    str_lifestyle_03_or text[] DEFAULT '{NONE}'::text[],
    str_lifestyle_04_or text[] DEFAULT '{NONE}'::text[],
    str_climate_or text[] DEFAULT '{NONE}'::text[],
    str_state_or text[] DEFAULT '{NONE}'::text[]
);


ALTER TABLE public.blk_a_assortment OWNER TO psql;

--
-- TOC entry 1734 (class 1259 OID 129294997)
-- Name: blk_a_assortment_20250213; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_20250213 (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.blk_a_assortment_20250213 OWNER TO psql;

--
-- TOC entry 1735 (class 1259 OID 129295002)
-- Name: blk_a_assortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_bk (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    record_state smallint
);


ALTER TABLE public.blk_a_assortment_bk OWNER TO psql;

--
-- TOC entry 1736 (class 1259 OID 129295007)
-- Name: blk_a_assortment_bkp_aug19_2024; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_bkp_aug19_2024 (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.blk_a_assortment_bkp_aug19_2024 OWNER TO psql;

--
-- TOC entry 1737 (class 1259 OID 129295012)
-- Name: blk_a_assortment_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_storecount (
    product text,
    "time" text,
    location text,
    str_grade text,
    str_segmentation text,
    str_sub_segmentation text,
    str_aa_ind text,
    str_hisp_ind text,
    str_lifestyle_01 text,
    str_lifestyle_02 text,
    str_lifestyle_03 text,
    str_lifestyle_04 text,
    str_climate text,
    ssg text,
    department_id text,
    store_count integer
);


ALTER TABLE public.blk_a_assortment_storecount OWNER TO psql;

--
-- TOC entry 1738 (class 1259 OID 129295017)
-- Name: blk_a_assortment_storecount_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_storecount_bk (
    product text,
    "time" text,
    location text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    ssg text[],
    department text,
    store_count integer
);


ALTER TABLE public.blk_a_assortment_storecount_bk OWNER TO psql;

--
-- TOC entry 1739 (class 1259 OID 129295022)
-- Name: blk_a_assortment_sup_2747; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_a_assortment_sup_2747 (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.blk_a_assortment_sup_2747 OWNER TO psql;

--
-- TOC entry 1740 (class 1259 OID 129295027)
-- Name: blk_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_an_price_storecount_info (
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


ALTER TABLE public.blk_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 1741 (class 1259 OID 129295032)
-- Name: blk_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_authorization (
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


ALTER TABLE public.blk_authorization OWNER TO psql;

--
-- TOC entry 1742 (class 1259 OID 129295044)
-- Name: blk_c_conversion_file; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_file (
    floorset_name text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ccticketpricechannel real,
    merchant_cost real,
    cc_discount_pct real,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    auto_rollforward boolean,
    planned_sell_down_week text,
    ccmdstrategy text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    cc_presmin integer,
    cc_presmin_weeks integer,
    slsrnk real,
    rcptint integer,
    cc_orderpolicy integer,
    cc_order_multiple integer,
    cc_lead_time integer,
    cc_service_level real
);


ALTER TABLE public.blk_c_conversion_file OWNER TO psql;

--
-- TOC entry 1743 (class 1259 OID 129295049)
-- Name: blk_c_conversion_file_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_file_cm (
    floorset_name text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ccticketpricechannel real,
    merchant_cost real,
    cc_discount_pct real,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    auto_rollforward boolean,
    planned_sell_down_week text,
    ccmdstrategy text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    cc_presmin integer,
    cc_presmin_weeks integer,
    slsrnk real,
    rcptint integer,
    cc_orderpolicy integer,
    cc_order_multiple integer,
    cc_lead_time integer,
    cc_service_level real
);


ALTER TABLE public.blk_c_conversion_file_cm OWNER TO psql;

--
-- TOC entry 1744 (class 1259 OID 129295054)
-- Name: blk_c_conversion_file_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_file_lifecycle (
    floorset_name text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ccticketpricechannel real,
    merchant_cost real,
    cc_discount_pct real,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    auto_rollforward boolean,
    planned_sell_down_week text,
    ccmdstrategy text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    cc_presmin integer,
    cc_presmin_weeks integer,
    slsrnk real,
    rcptint integer,
    cc_orderpolicy integer,
    cc_order_multiple integer,
    cc_lead_time integer,
    cc_service_level real,
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


ALTER TABLE public.blk_c_conversion_file_lifecycle OWNER TO psql;

--
-- TOC entry 1745 (class 1259 OID 129295059)
-- Name: blk_c_conversion_file_lifecycle2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_file_lifecycle2 (
    floorset_name text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ccticketpricechannel real,
    merchant_cost real,
    cc_discount_pct real,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    auto_rollforward boolean,
    planned_sell_down_week text,
    ccmdstrategy text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    cc_presmin integer,
    cc_presmin_weeks integer,
    slsrnk real,
    rcptint integer,
    cc_orderpolicy integer,
    cc_order_multiple integer,
    cc_lead_time integer,
    cc_service_level real,
    initrcptwk text,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    last_md_week text,
    derived_exitdate text
);


ALTER TABLE public.blk_c_conversion_file_lifecycle2 OWNER TO psql;

--
-- TOC entry 1746 (class 1259 OID 129295064)
-- Name: blk_c_conversion_file_old; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_file_old (
    floorset_name text,
    department_id text,
    class_id text,
    subclass_id text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ccticketpricechannel real,
    merchant_cost real,
    cc_discount_pct real,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    auto_rollforward boolean,
    planned_sell_down_week text,
    ccmdstrategy text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    cc_presmin integer,
    cc_presmin_weeks integer,
    slsrnk real,
    rcptint integer,
    cc_orderpolicy integer,
    cc_order_multiple integer,
    cc_lead_time integer,
    cc_service_level real
);


ALTER TABLE public.blk_c_conversion_file_old OWNER TO psql;

--
-- TOC entry 1747 (class 1259 OID 129295069)
-- Name: blk_c_conversion_history_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_history_lifecycle (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[],
    aur real,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    style text,
    subclass text,
    class text,
    department text,
    sty_size_run_name text
);


ALTER TABLE public.blk_c_conversion_history_lifecycle OWNER TO psql;

--
-- TOC entry 1748 (class 1259 OID 129295074)
-- Name: blk_c_conversion_history_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_history_stylecolorchannelattributes (
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
    slsrnk integer,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_orderpolicy integer,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
    cc_store_min_multiple integer,
    planned_sell_down_week text,
    cc_selected_clusters text[],
    cc_cluster_group text
);


ALTER TABLE public.blk_c_conversion_history_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1749 (class 1259 OID 129295079)
-- Name: blk_c_conversion_history_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_history_validsizes (
    product text,
    valid_sizes text
);


ALTER TABLE public.blk_c_conversion_history_validsizes OWNER TO psql;

--
-- TOC entry 1750 (class 1259 OID 129295084)
-- Name: blk_c_conversion_missing_in_an_store_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_conversion_missing_in_an_store_master (
    department text,
    class text,
    subclass text,
    style text,
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


ALTER TABLE public.blk_c_conversion_missing_in_an_store_master OWNER TO psql;

--
-- TOC entry 1751 (class 1259 OID 129295089)
-- Name: blk_c_cutover_prep_history; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_c_cutover_prep_history (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[],
    aur real
);


ALTER TABLE public.blk_c_cutover_prep_history OWNER TO psql;

--
-- TOC entry 1752 (class 1259 OID 129295094)
-- Name: blk_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_prodstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_h_prodstd OWNER TO psql;

--
-- TOC entry 1753 (class 1259 OID 129295105)
-- Name: blk_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes (
    product text NOT NULL,
    location text NOT NULL,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real DEFAULT 3,
    ccticketpricechannel real DEFAULT '0.01'::real,
    ccticketpricechannel_override real,
    validsizes text[] DEFAULT ARRAY[]::text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text DEFAULT 'Not Available'::text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real DEFAULT 0.0,
    cc_imupct real DEFAULT 0.0,
    cc_existingwac real DEFAULT 0.0,
    cc_systemcost real DEFAULT 0.0,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text DEFAULT 'No'::text,
    lifecycle_applied text,
    cc_return_u_pct real,
    auto_rollforward boolean DEFAULT false,
    irr_mode text DEFAULT 'Normal'::text,
    plan_current text,
    lock_agg_edit text,
    cc_lead_time integer,
    cc_service_level real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean DEFAULT false,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1754 (class 1259 OID 129295129)
-- Name: blk_p_approvedclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_approvedclusters (
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


ALTER TABLE public.blk_p_approvedclusters OWNER TO psql;

--
-- TOC entry 1755 (class 1259 OID 129295141)
-- Name: blk_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_serviceparams (
    id text,
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


ALTER TABLE public.blk_serviceparams OWNER TO psql;

--
-- TOC entry 1756 (class 1259 OID 129295153)
-- Name: blk_clustering_needs_attention; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_clustering_needs_attention AS
 SELECT aa.plannable_dept,
    aa.plannable_time,
    aa.current_cluster_dept,
    aa.current_cluster_time,
    aa.clustering_status,
    aa.cluster_issue
   FROM ( WITH plannable AS (
                 SELECT DISTINCT b.ancestor3 AS plannable_dept,
                    c."time" AS plannable_time
                   FROM ((blk_ma_stylecolorchannelattributes a
                     JOIN blk_h_prodstd b ON ((a.product = b.id)))
                     JOIN ( SELECT DISTINCT blk_p_approvedclusters."time"
                           FROM blk_p_approvedclusters) c ON ((1 = 1)))
                  WHERE (((array_length(a.cc_validsizes_store, 1) IS NOT NULL) OR (array_length(a.cc_validsizes_ecom, 1) IS NOT NULL)) AND (a.record_state = 0) AND (a.exitdate > ( SELECT blk_serviceparams.value
                           FROM blk_serviceparams
                          WHERE (blk_serviceparams.id = 'plan_current'::text))))
                ), current_clusters AS (
                 SELECT DISTINCT blk_p_approvedclusters.product AS current_cluster_dept,
                    blk_p_approvedclusters."time" AS current_cluster_time,
                        CASE
                            WHEN (blk_p_approvedclusters.clustering_status = '1'::real) THEN 'APPROVED'::text
                            ELSE 'NOT APPROVED'::text
                        END AS clustering_status
                   FROM blk_p_approvedclusters
                )
         SELECT x.plannable_dept,
            x.plannable_time,
            y.current_cluster_dept,
            y.current_cluster_time,
            y.clustering_status,
                CASE
                    WHEN (y.current_cluster_time IS NULL) THEN 'CLUSTER IS MISSING'::text
                    WHEN (y.clustering_status = 'NOT APPROVED'::text) THEN 'CLUSTER NOT APPROVED'::text
                    ELSE NULL::text
                END AS cluster_issue
           FROM (plannable x
             LEFT JOIN current_clusters y ON (((x.plannable_dept = y.current_cluster_dept) AND (x.plannable_time = y.current_cluster_time))))) aa
  WHERE (aa.cluster_issue IS NOT NULL)
  ORDER BY aa.plannable_dept, aa.plannable_time;


ALTER VIEW public.blk_clustering_needs_attention OWNER TO psql;

--
-- TOC entry 1757 (class 1259 OID 129295158)
-- Name: blk_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_corpdisc (
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
    record_state smallint DEFAULT 0,
    prodlife text DEFAULT 'FP'::text
);


ALTER TABLE public.blk_corpdisc OWNER TO psql;

--
-- TOC entry 1758 (class 1259 OID 129295173)
-- Name: blk_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_corpdisc_backup (
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
    record_state smallint,
    prodlife text
);


ALTER TABLE public.blk_corpdisc_backup OWNER TO psql;

--
-- TOC entry 1759 (class 1259 OID 129295178)
-- Name: blk_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_cluster (
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


ALTER TABLE public.blk_d_cluster OWNER TO psql;

--
-- TOC entry 1760 (class 1259 OID 129295190)
-- Name: blk_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_location (
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


ALTER TABLE public.blk_d_location OWNER TO psql;

--
-- TOC entry 1761 (class 1259 OID 129295202)
-- Name: blk_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_prodlife (
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


ALTER TABLE public.blk_d_prodlife OWNER TO psql;

--
-- TOC entry 1762 (class 1259 OID 129295214)
-- Name: blk_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_product (
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


ALTER TABLE public.blk_d_product OWNER TO psql;

--
-- TOC entry 1763 (class 1259 OID 129295226)
-- Name: blk_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_time (
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


ALTER TABLE public.blk_d_time OWNER TO psql;

--
-- TOC entry 1764 (class 1259 OID 129295238)
-- Name: blk_d_time_20250107; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_d_time_20250107 (
    id text,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_d_time_20250107 OWNER TO psql;

--
-- TOC entry 1765 (class 1259 OID 129295243)
-- Name: blk_departmentattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_departmentattributes (
    department text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text
);


ALTER TABLE public.blk_departmentattributes OWNER TO psql;

--
-- TOC entry 1766 (class 1259 OID 129295248)
-- Name: blk_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_designimages (
    product text,
    img text
);


ALTER TABLE public.blk_designimages OWNER TO psql;

--
-- TOC entry 1767 (class 1259 OID 129295253)
-- Name: blk_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_eohdata_stylecolor (
    product text,
    channel text,
    eohu real
);


ALTER TABLE public.blk_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 1768 (class 1259 OID 129295258)
-- Name: blk_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_h_clusterstd OWNER TO psql;

--
-- TOC entry 1769 (class 1259 OID 129295270)
-- Name: blk_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_h_locdc OWNER TO psql;

--
-- TOC entry 1770 (class 1259 OID 129295282)
-- Name: blk_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_locdcstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    ancestor0 text
);


ALTER TABLE public.blk_h_locdcstd OWNER TO psql;

--
-- TOC entry 1771 (class 1259 OID 129295294)
-- Name: blk_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_locstd (
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


ALTER TABLE public.blk_h_locstd OWNER TO psql;

--
-- TOC entry 1772 (class 1259 OID 129295305)
-- Name: blk_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_h_prodlifestd OWNER TO psql;

--
-- TOC entry 1773 (class 1259 OID 129295317)
-- Name: blk_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_timeflrset (
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


ALTER TABLE public.blk_h_timeflrset OWNER TO psql;

--
-- TOC entry 1774 (class 1259 OID 129295329)
-- Name: blk_h_timeflrset_20250107; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_timeflrset_20250107 (
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


ALTER TABLE public.blk_h_timeflrset_20250107 OWNER TO psql;

--
-- TOC entry 1775 (class 1259 OID 129295334)
-- Name: blk_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_h_timestd (
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


ALTER TABLE public.blk_h_timestd OWNER TO psql;

--
-- TOC entry 1776 (class 1259 OID 129295346)
-- Name: blk_id_missing_in_qa; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_id_missing_in_qa (
    product text
);


ALTER TABLE public.blk_id_missing_in_qa OWNER TO psql;

--
-- TOC entry 1777 (class 1259 OID 129295351)
-- Name: blk_in_intrady_item_creation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_in_intrady_item_creation (
    s5_style_id text,
    s5_stylecolor_id text,
    s5_sku_id text,
    orin_style_id text,
    orin_stylecolor_id text,
    orin_sku_id text,
    size_member_id text,
    size_member_name text,
    source_member_id text,
    source_member_name text,
    file_name text,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.blk_in_intrady_item_creation OWNER TO psql;

--
-- TOC entry 1778 (class 1259 OID 129295357)
-- Name: blk_in_intrady_item_creation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_in_intrady_item_creation_archive (
    s5_style_id text,
    s5_stylecolor_id text,
    s5_sku_id text,
    orin_style_id text,
    orin_stylecolor_id text,
    orin_sku_id text,
    size_member_id text,
    size_member_name text,
    source_member_id text,
    source_member_name text,
    file_name text,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    archive_date timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.blk_in_intrady_item_creation_archive OWNER TO psql;

--
-- TOC entry 1779 (class 1259 OID 129295364)
-- Name: blk_in_item_po_status; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_in_item_po_status (
    s5_style_id text,
    s5_stylecolor_id text,
    api_req_type text,
    ndc_week text,
    style_color_status text,
    style_color_status_msg text,
    spo_status text,
    spo_status_msg text,
    import_id text,
    po_status text,
    po_status_msg text,
    po_number text,
    po_plan_name text,
    file_name text,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.blk_in_item_po_status OWNER TO psql;

--
-- TOC entry 1780 (class 1259 OID 129295370)
-- Name: blk_in_item_po_status_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_in_item_po_status_archive (
    s5_style_id text,
    s5_stylecolor_id text,
    api_req_type text,
    ndc_week text,
    style_color_status text,
    style_color_status_msg text,
    spo_status text,
    spo_status_msg text,
    import_id text,
    po_status text,
    po_status_msg text,
    po_number text,
    po_plan_name text,
    file_name text,
    created_at timestamp without time zone,
    archive_date timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.blk_in_item_po_status_archive OWNER TO psql;

--
-- TOC entry 1781 (class 1259 OID 129295376)
-- Name: blk_intrday_style_sync; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_intrday_style_sync (
    product text
);


ALTER TABLE public.blk_intrday_style_sync OWNER TO psql;

--
-- TOC entry 1782 (class 1259 OID 129295381)
-- Name: blk_intrday_style_sync_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_intrday_style_sync_test (
    product text
);


ALTER TABLE public.blk_intrday_style_sync_test OWNER TO psql;

--
-- TOC entry 1783 (class 1259 OID 129295386)
-- Name: blk_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_dclookup (
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


ALTER TABLE public.blk_l_dclookup OWNER TO psql;

--
-- TOC entry 1784 (class 1259 OID 129295398)
-- Name: blk_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_dependencylookup (
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


ALTER TABLE public.blk_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1785 (class 1259 OID 129295412)
-- Name: blk_l_dependencylookup_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_dependencylookup_intraday (
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


ALTER TABLE public.blk_l_dependencylookup_intraday OWNER TO psql;

--
-- TOC entry 1786 (class 1259 OID 129295417)
-- Name: blk_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_priceeventlookup (
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


ALTER TABLE public.blk_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 1787 (class 1259 OID 129295431)
-- Name: blk_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_ssglookup (
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


ALTER TABLE public.blk_l_ssglookup OWNER TO psql;

--
-- TOC entry 1788 (class 1259 OID 129295445)
-- Name: blk_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_storedclookup (
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


ALTER TABLE public.blk_l_storedclookup OWNER TO psql;

--
-- TOC entry 1789 (class 1259 OID 129295457)
-- Name: blk_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_storelookup (
    "time" text NOT NULL,
    product text NOT NULL,
    id text DEFAULT ''::text NOT NULL,
    value text NOT NULL,
    stores text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_l_storelookup OWNER TO psql;

--
-- TOC entry 1790 (class 1259 OID 129295470)
-- Name: blk_l_storelookup_old; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_l_storelookup_old (
    "time" text NOT NULL,
    product text NOT NULL,
    id text DEFAULT ''::text NOT NULL,
    value text NOT NULL,
    stores text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_l_storelookup_old OWNER TO psql;

--
-- TOC entry 1791 (class 1259 OID 129295483)
-- Name: blk_location_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_location_attributes (
    id text,
    name text,
    description text,
    levelid text,
    latitude text,
    longitude text
);


ALTER TABLE public.blk_location_attributes OWNER TO psql;

--
-- TOC entry 1792 (class 1259 OID 129295488)
-- Name: blk_ma_areaattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_areaattributes (
    indx integer,
    location text,
    area_latitude text,
    area_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_areaattributes OWNER TO psql;

--
-- TOC entry 1793 (class 1259 OID 129295500)
-- Name: blk_ma_bannerattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_bannerattributes (
    indx integer,
    location text,
    banner_latitude text,
    banner_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_bannerattributes OWNER TO psql;

--
-- TOC entry 1794 (class 1259 OID 129295512)
-- Name: blk_ma_departmentquarter_attributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes (
    product text NOT NULL,
    "time" text NOT NULL,
    dq_clustering_level text DEFAULT 'Class'::text,
    dq_include_vendors boolean DEFAULT false,
    dq_enum_vendors_cutoff boolean DEFAULT true,
    dq_clustering_prefix text DEFAULT 'TIER'::text,
    dq_num_clusters text DEFAULT '13'::text,
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
    dq_metric_1 text DEFAULT 'Total Shp $'::text,
    dq_metric_2 text DEFAULT 'Total Shp U'::text,
    dq_start_week text,
    dq_end_week text
);


ALTER TABLE public.blk_ma_departmentquarter_attributes OWNER TO psql;

--
-- TOC entry 1795 (class 1259 OID 129295532)
-- Name: blk_ma_departmentquarter_attributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_bkp (
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


ALTER TABLE public.blk_ma_departmentquarter_attributes_bkp OWNER TO psql;

--
-- TOC entry 1796 (class 1259 OID 129295537)
-- Name: blk_ma_departmentquarter_attributes_bkp_oct072024; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_bkp_oct072024 (
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


ALTER TABLE public.blk_ma_departmentquarter_attributes_bkp_oct072024 OWNER TO psql;

--
-- TOC entry 1797 (class 1259 OID 129295542)
-- Name: blk_ma_departmentquarter_attributes_from_ch; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_from_ch (
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
    dq_metric_2 text,
    dq_start_week text,
    dq_end_week text
);


ALTER TABLE public.blk_ma_departmentquarter_attributes_from_ch OWNER TO psql;

--
-- TOC entry 1798 (class 1259 OID 129295547)
-- Name: blk_ma_departmentquarter_attributes_pre_05082026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_pre_05082026 (
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
    dq_metric_2 text,
    dq_start_week text,
    dq_end_week text
);


ALTER TABLE public.blk_ma_departmentquarter_attributes_pre_05082026 OWNER TO psql;

--
-- TOC entry 1799 (class 1259 OID 129295552)
-- Name: blk_ma_departmentquarter_attributes_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_temp (
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


ALTER TABLE public.blk_ma_departmentquarter_attributes_temp OWNER TO psql;

--
-- TOC entry 1800 (class 1259 OID 129295557)
-- Name: blk_ma_departmentquarter_attributes_temp2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_departmentquarter_attributes_temp2 (
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


ALTER TABLE public.blk_ma_departmentquarter_attributes_temp2 OWNER TO psql;

--
-- TOC entry 1801 (class 1259 OID 129295562)
-- Name: blk_ma_districtattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_districtattributes (
    indx integer,
    location text,
    district_latitude text,
    district_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_districtattributes OWNER TO psql;

--
-- TOC entry 1802 (class 1259 OID 129295574)
-- Name: blk_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes (
    indx integer NOT NULL,
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1803 (class 1259 OID 129295586)
-- Name: blk_ma_dptflrsetattributes_20240926; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_20240926 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_20240926 OWNER TO psql;

--
-- TOC entry 1804 (class 1259 OID 129295591)
-- Name: blk_ma_dptflrsetattributes_20241031; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_20241031 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_20241031 OWNER TO psql;

--
-- TOC entry 1805 (class 1259 OID 129295596)
-- Name: blk_ma_dptflrsetattributes_20250107; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_20250107 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_20250107 OWNER TO psql;

--
-- TOC entry 1806 (class 1259 OID 129295601)
-- Name: blk_ma_dptflrsetattributes_20250221; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_20250221 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_20250221 OWNER TO psql;

--
-- TOC entry 1807 (class 1259 OID 129295606)
-- Name: blk_ma_dptflrsetattributes_20260306; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_20260306 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_20260306 OWNER TO psql;

--
-- TOC entry 1808 (class 1259 OID 129295611)
-- Name: blk_ma_dptflrsetattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_bk (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too text,
    default_mkdnwks text,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin text,
    default_presmin_weeks text,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text,
    default_str_grade text,
    default_str_segmentation text,
    default_str_sub_segmentation text,
    default_str_aa_ind text,
    default_str_hisp_ind text,
    default_str_lifestyle_01 text,
    default_str_lifestyle_02 text,
    default_str_lifestyle_03 text,
    default_str_lifestyle_04 text,
    default_str_climate text,
    default_str_state text,
    default_ssg text,
    default_flnrange text,
    default_discountpct text,
    default_imupct text,
    default_service_level text,
    default_lead_time text,
    floorset_uda text,
    ly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_ma_dptflrsetattributes_bk OWNER TO psql;

--
-- TOC entry 1809 (class 1259 OID 129295616)
-- Name: blk_ma_dptflrsetattributes_bkp_03262025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_dptflrsetattributes_bkp_03262025 (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.blk_ma_dptflrsetattributes_bkp_03262025 OWNER TO psql;

--
-- TOC entry 1810 (class 1259 OID 129295621)
-- Name: blk_ma_dptflrsetattributes_view_verification; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_ma_dptflrsetattributes_view_verification AS
 SELECT a.product AS department,
    b.id AS "time",
    a."time" AS floorset
   FROM blk_ma_dptflrsetattributes a,
    blk_d_time b
  WHERE ((b.id >= a.rcptstart) AND (b.id <= a.rcptend) AND (a.rcptend >= ( SELECT blk_serviceparams.value
           FROM blk_serviceparams
          WHERE (blk_serviceparams.id = 'plan_current'::text))));


ALTER VIEW public.blk_ma_dptflrsetattributes_view_verification OWNER TO psql;

--
-- TOC entry 1811 (class 1259 OID 129295626)
-- Name: blk_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_imgattributes (
    indx integer,
    product text NOT NULL,
    img text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    hold_img text,
    img_held text,
    img_from_etl text
);


ALTER TABLE public.blk_ma_imgattributes OWNER TO psql;

--
-- TOC entry 2062 (class 1259 OID 139565893)
-- Name: blk_ma_imgattributes_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_imgattributes_archive (
    indx integer,
    product text,
    img text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    hold_img text,
    img_held text,
    img_from_etl text,
    archive_date timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP)
);


ALTER TABLE public.blk_ma_imgattributes_archive OWNER TO psql;

--
-- TOC entry 2059 (class 1259 OID 134254502)
-- Name: blk_ma_imgattributes_archive_sup_4523; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_imgattributes_archive_sup_4523 (
    indx integer,
    product text,
    img text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    archive_date timestamp without time zone
);


ALTER TABLE public.blk_ma_imgattributes_archive_sup_4523 OWNER TO psql;

--
-- TOC entry 1812 (class 1259 OID 129295644)
-- Name: blk_ma_imgattributes_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_imgattributes_new (
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


ALTER TABLE public.blk_ma_imgattributes_new OWNER TO psql;

--
-- TOC entry 2058 (class 1259 OID 134254431)
-- Name: blk_ma_imgattributes_sup_4523; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_imgattributes_sup_4523 (
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


ALTER TABLE public.blk_ma_imgattributes_sup_4523 OWNER TO psql;

--
-- TOC entry 1813 (class 1259 OID 129295649)
-- Name: blk_ma_regionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_regionattributes (
    indx integer,
    location text,
    region_latitude text,
    region_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_regionattributes OWNER TO psql;

--
-- TOC entry 1814 (class 1259 OID 129295661)
-- Name: blk_ma_sellingchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_sellingchannelattributes (
    indx integer,
    location text,
    sellch_latitude text,
    sellch_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_sellingchannelattributes OWNER TO psql;

--
-- TOC entry 1815 (class 1259 OID 129295673)
-- Name: blk_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_sizeattributes (
    product text NOT NULL,
    parent_id text,
    size_member_id text,
    sizeattribute text,
    source_member_id text,
    source_member_name text,
    sku_dropship_indicator text,
    sku_replenishment_flag text,
    sku_extended_size text,
    sku_status text,
    isvalid integer DEFAULT 1 NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1816 (class 1259 OID 129295686)
-- Name: blk_ma_sizeattributes_issue_20260306; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_sizeattributes_issue_20260306 (
    product text,
    parent_id text,
    size_member_id text,
    sizeattribute text,
    source_member_id text,
    source_member_name text,
    sku_dropship_indicator text,
    sku_replenishment_flag text,
    sku_extended_size text,
    sku_status text,
    isvalid integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_ma_sizeattributes_issue_20260306 OWNER TO psql;

--
-- TOC entry 1817 (class 1259 OID 129295691)
-- Name: blk_ma_sizeattributes_sup3701_20260206; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_sizeattributes_sup3701_20260206 (
    product text,
    parent_id text,
    size_member_id text,
    sizeattribute text,
    source_member_id text,
    source_member_name text,
    sku_dropship_indicator text,
    sku_replenishment_flag text,
    sku_extended_size text,
    sku_status text,
    isvalid integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_ma_sizeattributes_sup3701_20260206 OWNER TO psql;

--
-- TOC entry 1818 (class 1259 OID 129295696)
-- Name: blk_ma_stateattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stateattributes (
    indx integer,
    location text,
    state_latitude text,
    state_longitude text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_ma_stateattributes OWNER TO psql;

--
-- TOC entry 1819 (class 1259 OID 129295708)
-- Name: blk_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_storeattributes (
    location text NOT NULL,
    strname text,
    str_grade text,
    str_dc_type text,
    str_segmentation text,
    str_sub_segmentation text,
    str_aa_ind text,
    str_hisp_ind text,
    str_sq_ft text,
    str_density text,
    str_lifestyle_01 text,
    str_lifestyle_02 text,
    str_lifestyle_03 text,
    str_lifestyle_04 text,
    str_climate text,
    str_open_sell text,
    str_store_status text,
    str_area text,
    str_region text,
    str_district text,
    str_shop_doors text,
    str_address text,
    str_city text,
    str_state text,
    str_latitude text,
    str_longitude text,
    str_store_format text,
    str_loc_attr_1 text,
    str_loc_attr_2 text,
    str_loc_attr_3 text,
    str_loc_attr_4 text,
    str_loc_attr_5 text,
    str_loc_attr_6 text,
    str_loc_attr_7 text,
    str_loc_attr_8 text,
    str_loc_attr_9 text,
    str_loc_attr_10 text,
    str_loc_attr_11 text,
    str_loc_attr_12 text,
    str_loc_attr_13 text,
    str_loc_attr_14 text,
    str_loc_attr_15 text,
    str_loc_attr_16 text,
    district_name text,
    district_desc text,
    region_name text,
    region_desc text,
    area_name text,
    area_desc text,
    selling_channel_name text,
    selling_channel_desc text,
    banner_name text,
    banner_desc text,
    channel_name text,
    channel_desc text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    loc_band_group text DEFAULT 'Undefined'::text,
    loc_pareto_group text DEFAULT 'Undefined'::text
);


ALTER TABLE public.blk_ma_storeattributes OWNER TO psql;

--
-- TOC entry 1820 (class 1259 OID 129295722)
-- Name: blk_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_storeattributes_lat_long (
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


ALTER TABLE public.blk_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 1821 (class 1259 OID 129295734)
-- Name: blk_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_styleattributes (
    product text NOT NULL,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real
);


ALTER TABLE public.blk_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1822 (class 1259 OID 129295746)
-- Name: blk_ma_styleattributes_20241005; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_styleattributes_20241005 (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text
);


ALTER TABLE public.blk_ma_styleattributes_20241005 OWNER TO psql;

--
-- TOC entry 1823 (class 1259 OID 129295751)
-- Name: blk_ma_styleattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_styleattributes_bk (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text
);


ALTER TABLE public.blk_ma_styleattributes_bk OWNER TO psql;

--
-- TOC entry 1824 (class 1259 OID 129295756)
-- Name: blk_ma_styleattributes_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_styleattributes_cm (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text
);


ALTER TABLE public.blk_ma_styleattributes_cm OWNER TO psql;

--
-- TOC entry 1825 (class 1259 OID 129295761)
-- Name: blk_ma_styleattributes_sup3322; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_styleattributes_sup3322 (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text
);


ALTER TABLE public.blk_ma_styleattributes_sup3322 OWNER TO psql;

--
-- TOC entry 1826 (class 1259 OID 129295766)
-- Name: blk_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes (
    product text NOT NULL,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean DEFAULT (0)::boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean DEFAULT (1)::boolean,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real
);


ALTER TABLE public.blk_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1827 (class 1259 OID 129295780)
-- Name: blk_ma_stylecolorattributes_20241031; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes_20241031 (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text
);


ALTER TABLE public.blk_ma_stylecolorattributes_20241031 OWNER TO psql;

--
-- TOC entry 1828 (class 1259 OID 129295785)
-- Name: blk_ma_stylecolorattributes_20241204; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes_20241204 (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean
);


ALTER TABLE public.blk_ma_stylecolorattributes_20241204 OWNER TO psql;

--
-- TOC entry 1829 (class 1259 OID 129295790)
-- Name: blk_ma_stylecolorattributes_20241205; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes_20241205 (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean
);


ALTER TABLE public.blk_ma_stylecolorattributes_20241205 OWNER TO psql;

--
-- TOC entry 1830 (class 1259 OID 129295795)
-- Name: blk_ma_stylecolorattributes_20260205; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes_20260205 (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real
);


ALTER TABLE public.blk_ma_stylecolorattributes_20260205 OWNER TO psql;

--
-- TOC entry 1831 (class 1259 OID 129295800)
-- Name: blk_ma_stylecolorattributes_sup3322; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorattributes_sup3322 (
    product text,
    cc_initial_launch_month text,
    cccolor text,
    cc_diff_type text,
    cc_color_desc text,
    cc_colorfamily_code text,
    cccolorfamily text,
    cc_merch_color_name text,
    cc_vpn text,
    cc_vpn_color text,
    cc_first_rec_week text,
    cc_first_inv_week text,
    cc_first_sale_week text,
    cc_first_md_week text,
    cc_last_md_week text,
    cc_msrp real,
    cc_current_retail real,
    ccstylecolorcreatedate text,
    cc_dropship_indicator text,
    cc_replenishemnt_indicator text,
    cc_selling_season text,
    cc_selling_year text,
    cc_segment_buy text,
    cc_silhouette text,
    cc_subcategory text,
    cc_program_name text,
    cc_print_vs_solid text,
    cc_sleeve_length text,
    cc_fashion_vs_basic text,
    cc_top_length text,
    cc_denim_rise text,
    cc_bottom_fit text,
    cc_dress_length text,
    cc_neckline text,
    cc_inseam text,
    cc_lounge_vs_sleep text,
    cc_bottom_silo text,
    cc_robe text,
    cc_print_type text,
    cc_fit_solution text,
    cc_d_cup_available text,
    cc_occasion text,
    cc_categories text,
    cc_cut_fit text,
    cc_construction text,
    cc_bridal_registry text,
    cc_levi_fits text,
    cc_graphic_type text,
    cc_classification text,
    cc_young_contemporary text,
    cc_short_inseam text,
    cc_denim_trends text,
    cc_collegiate text,
    cc_set text,
    cc_material text,
    cc_configuration text,
    cc_bedding_accessories text,
    cc_fabric_description text,
    cc_black_friday_ind text,
    cc_superbuy_ind text,
    cc_aa_ind text,
    cc_coastal_ind text,
    cc_lodge_ind text,
    cc_white_dinnerware_ind text,
    cc_customer_need text,
    cc_fashion_jewelry text,
    cc_material_color text,
    cc_material_type text,
    cc_jewelry_presentation text,
    cc_necklaces text,
    cc_texture_pattern text,
    cc_high_value_status text,
    cc_fine_jewelry_metal text,
    cc_stone text,
    cc_bridal text,
    cc_metal_type text,
    cc_chain_type text,
    cc_bracelets text,
    cc_ears text,
    cc_ring text,
    cc_dial_color text,
    cc_watch text,
    cc_dtw_fine_jewelry text,
    cc_gold_mkt_fine_jewelry text,
    cc_grams_fine_jewelry text,
    cc_silver_mkt_fine_jewelry text,
    cc_silver_grams text,
    cc_ctw_fine_jewelry text,
    cc_shoe_type text,
    cc_shaft_height text,
    cc_outsole text,
    cc_closure text,
    cc_toe_type text,
    cc_sole_type text,
    cc_toe_character text,
    cc_heel_type text,
    cc_heel_height text,
    cc_fabric_type text,
    cc_width text,
    cc_tech_features text,
    cc_skechers_division text,
    cc_level_of_presentation text,
    cc_fragrance_scents text,
    cc_total_makeup text,
    cc_makeup_total_face text,
    cc_total_fragrance text,
    cc_makeup_total_lip text,
    cc_total_skincare text,
    cc_makeup_total_eye text,
    cc_skincare_total_face text,
    cc_styclr_status text,
    cc_skulist_id text,
    cc_skulist_desc text,
    total_brand_name text,
    division_name text,
    group_name text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortment text,
    merch_comments text,
    plan_comments text,
    cc_is_locked text,
    cc_s5_adopted text,
    cc_prepublish boolean,
    cc_prepublished_at timestamp without time zone,
    cc_nrf_color_code_non_plm text,
    cc_nrf_color_desc_non_plm text,
    cc_set_flag text,
    cc_price_exception text,
    cc_last_published_by text,
    cc_last_published_on timestamp without time zone,
    cc_s5_stylecolor_status text,
    cc_s5_stylecolor_status_msg text,
    supp_brand_95 text,
    cc_vpn_color_desc text,
    cc_vpn_color_display text,
    cccolorid text,
    cc_orin_stylecolor text,
    cc_cost real,
    cc_buy_period_descr text,
    cc_vpn_buy_period text,
    cc_floorset text,
    cc_use_sys_floorset boolean
);


ALTER TABLE public.blk_ma_stylecolorattributes_sup3322 OWNER TO psql;

--
-- TOC entry 1832 (class 1259 OID 129295805)
-- Name: blk_ma_stylecolorchannelattributes_20241107; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_20241107 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_20241107 OWNER TO psql;

--
-- TOC entry 1833 (class 1259 OID 129295810)
-- Name: blk_ma_stylecolorchannelattributes_20241108; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_20241108 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_20241108 OWNER TO psql;

--
-- TOC entry 1834 (class 1259 OID 129295815)
-- Name: blk_ma_stylecolorchannelattributes_20250213; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_20250213 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_20250213 OWNER TO psql;

--
-- TOC entry 1835 (class 1259 OID 129295820)
-- Name: blk_ma_stylecolorchannelattributes_20260203; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_20260203 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_20260203 OWNER TO psql;

--
-- TOC entry 1836 (class 1259 OID 129295825)
-- Name: blk_ma_stylecolorchannelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_bk (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    planned_sell_down_week text
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_bk OWNER TO psql;

--
-- TOC entry 1837 (class 1259 OID 129295831)
-- Name: blk_ma_stylecolorchannelattributes_bkp_05032026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_bkp_05032026 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_bkp_05032026 OWNER TO psql;

--
-- TOC entry 1838 (class 1259 OID 129295841)
-- Name: blk_ma_stylecolorchannelattributes_from_ch; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_from_ch (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel text,
    ccticketpricechannel_override text,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_store_min_multiple text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct text,
    cc_imupct text,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps text,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct text,
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
    record_state smallint
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_from_ch OWNER TO psql;

--
-- TOC entry 1839 (class 1259 OID 129295846)
-- Name: blk_ma_stylecolorchannelattributes_not_in_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_not_in_d_product (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_not_in_d_product OWNER TO psql;

--
-- TOC entry 1840 (class 1259 OID 129295854)
-- Name: blk_ma_stylecolorchannelattributes_sup3322; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorchannelattributes_sup3322 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean
);


ALTER TABLE public.blk_ma_stylecolorchannelattributes_sup3322 OWNER TO psql;

--
-- TOC entry 1841 (class 1259 OID 129295859)
-- Name: blk_ma_stylecolorweekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorweekattributes (
    product text NOT NULL,
    "time" text NOT NULL,
    location text DEFAULT 'MASTER_DC'::text NOT NULL,
    cc_vpn text NOT NULL,
    cc_vpn_color text NOT NULL,
    hq_id text NOT NULL,
    vpn_desc text,
    cc_vpn_color_desc text,
    division text,
    department text NOT NULL,
    buy_period_id text NOT NULL,
    buy_period_descr text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    buy_period_season text,
    plm_cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text NOT NULL,
    eventdate date,
    version_id integer,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state integer
);


ALTER TABLE public.blk_ma_stylecolorweekattributes OWNER TO psql;

--
-- TOC entry 1842 (class 1259 OID 129295865)
-- Name: blk_ma_stylecolorweekattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorweekattributes_bk (
    product text,
    "time" text,
    location text,
    cc_vpn text,
    cc_vpn_color text,
    hq_id text,
    vpn_desc text,
    cc_vpn_color_desc text,
    group_id text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    buy_period_season text,
    plm_cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id integer,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state integer
);


ALTER TABLE public.blk_ma_stylecolorweekattributes_bk OWNER TO psql;

--
-- TOC entry 1843 (class 1259 OID 129295870)
-- Name: blk_ma_stylecolorweekattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorweekattributes_intraday (
    product text,
    "time" text,
    location text,
    cc_vpn text,
    cc_vpn_color text,
    hq_id text,
    vpn_desc text,
    cc_vpn_color_desc text,
    division text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    buy_period_season text,
    plm_cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id integer,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state integer
);


ALTER TABLE public.blk_ma_stylecolorweekattributes_intraday OWNER TO psql;

--
-- TOC entry 1844 (class 1259 OID 129295875)
-- Name: blk_ma_stylecolorweekattributes_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_stylecolorweekattributes_temp (
    product text,
    "time" text,
    location text,
    cc_vpn text,
    cc_vpn_color text,
    hq_id text,
    vpn_desc text,
    cc_vpn_color_desc text,
    group_id text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    buy_period_season text,
    plm_cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id integer,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state integer
);


ALTER TABLE public.blk_ma_stylecolorweekattributes_temp OWNER TO psql;

--
-- TOC entry 1845 (class 1259 OID 129295880)
-- Name: blk_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_weekattributes (
    "time" text NOT NULL,
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


ALTER TABLE public.blk_ma_weekattributes OWNER TO psql;

--
-- TOC entry 1846 (class 1259 OID 129295892)
-- Name: blk_ma_weekattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_ma_weekattributes_bk (
    "time" text,
    start_date text,
    end_date text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_ma_weekattributes_bk OWNER TO psql;

--
-- TOC entry 1847 (class 1259 OID 129295897)
-- Name: blk_missing_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_missing_prodstd (
    product text,
    id text
);


ALTER TABLE public.blk_missing_prodstd OWNER TO psql;

--
-- TOC entry 1848 (class 1259 OID 129295902)
-- Name: blk_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_channeloverride (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    weekadjaps real DEFAULT 0.0,
    weekadjaps_ecom real DEFAULT 0.0,
    weekadjslsu real DEFAULT 0.0,
    weekadjslsu_ecom real DEFAULT 0.0,
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


ALTER TABLE public.blk_p_channeloverride OWNER TO psql;

--
-- TOC entry 1849 (class 1259 OID 129295919)
-- Name: blk_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_dc_adj (
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
    sourcing_comments text,
    design_comments text
);


ALTER TABLE public.blk_p_dc_adj OWNER TO psql;

--
-- TOC entry 1850 (class 1259 OID 129295931)
-- Name: blk_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_dc_adj_size (
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
    dc_last_pub_ecom timestamp without time zone
);


ALTER TABLE public.blk_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 1851 (class 1259 OID 129295938)
-- Name: blk_p_dept_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_dept_store_attr_plan (
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


ALTER TABLE public.blk_p_dept_store_attr_plan OWNER TO psql;

--
-- TOC entry 1852 (class 1259 OID 129295950)
-- Name: blk_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_itemprice (
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
    excl_discount_pct real
);


ALTER TABLE public.blk_p_itemprice OWNER TO psql;

--
-- TOC entry 1853 (class 1259 OID 129295962)
-- Name: blk_p_like_dept; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_like_dept (
    product text NOT NULL,
    location text NOT NULL,
    like_dp_department text,
    like_dp_valid_from text,
    like_dp_valid_to text,
    dp_approval_status real,
    dp_perf_factor real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying DEFAULT 'system'::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying DEFAULT 'system'::character varying,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_like_dept OWNER TO psql;

--
-- TOC entry 1854 (class 1259 OID 129295974)
-- Name: blk_p_like_dept_class; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_like_dept_class (
    product text NOT NULL,
    location text NOT NULL,
    like_dc_department text,
    like_dc_class text,
    like_dc_valid_from text,
    like_dc_valid_to text,
    dc_approval_status real,
    dc_perf_factor real,
    like_class_t52w_shp_r real,
    ly_like_class_t52w_shp_r real,
    dpt_name text,
    cls_name text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying DEFAULT 'system'::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying DEFAULT 'system'::character varying,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_like_dept_class OWNER TO psql;

--
-- TOC entry 1855 (class 1259 OID 129295986)
-- Name: blk_p_like_dept_class_vendor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_like_dept_class_vendor (
    product text NOT NULL,
    location text NOT NULL,
    supp_brand text NOT NULL,
    like_dv_department text,
    like_dv_class text,
    like_dv_supp_brand text,
    like_dv_valid_from text,
    like_dv_valid_to text,
    dv_approval_status real,
    dv_perf_factor real,
    dv_like_class_t52w_shp_r real,
    ly_dv_like_class_t52w_shp_r real,
    dv_dpt_name text,
    dv_cls_name text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying DEFAULT 'system'::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying DEFAULT 'system'::character varying,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_like_dept_class_vendor OWNER TO psql;

--
-- TOC entry 1856 (class 1259 OID 129295998)
-- Name: blk_p_pinchpo; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_pinchpo (
    po_id text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    pinch_id text NOT NULL,
    pinched_stores text[],
    pinch_delivery_month text,
    pinch_floor_location text,
    pinch_otb_month text,
    pinch_nbd text,
    pinch_nad text,
    pinch_validsizes_store text[],
    pinch_validsizes_ecom text[],
    pinch_allocation_comments text,
    pinch_assortment_comments text,
    pinch_user_po_plan_name_store text,
    pinch_user_po_plan_name_ecom text,
    pinch_publish_po_plan_name_store text,
    pinch_publish_po_plan_name_ecom text,
    pinch_fold_code text,
    pinch_promo_code text,
    pinch_group_style text,
    pinch_subgroup_style text,
    pinch_master_style text,
    pinch_po_qty integer,
    is_published real,
    published_by text,
    published_at timestamp without time zone,
    spo_status_store text,
    spo_status_msg_store text,
    import_id_store text,
    po_status_store text,
    po_status_msg_store text,
    po_number_store text,
    created_at timestamp without time zone DEFAULT now(),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT now(),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    spo_status_ecom text,
    spo_status_msg_ecom text,
    import_id_ecom text,
    po_status_ecom text,
    po_status_msg_ecom text,
    po_number_ecom text
);


ALTER TABLE public.blk_p_pinchpo OWNER TO psql;

--
-- TOC entry 1857 (class 1259 OID 129296008)
-- Name: blk_p_pinchpo_20260720; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_pinchpo_20260720 (
    po_id text,
    product text,
    location text,
    "time" text,
    pinch_id text,
    pinched_stores text[],
    pinch_delivery_month text,
    pinch_floor_location text,
    pinch_otb_month text,
    pinch_nbd text,
    pinch_nad text,
    pinch_validsizes_store text[],
    pinch_validsizes_ecom text[],
    pinch_allocation_comments text,
    pinch_assortment_comments text,
    pinch_user_po_plan_name_store text,
    pinch_user_po_plan_name_ecom text,
    pinch_publish_po_plan_name_store text,
    pinch_publish_po_plan_name_ecom text,
    pinch_fold_code text,
    pinch_promo_code text,
    pinch_group_style text,
    pinch_subgroup_style text,
    pinch_master_style text,
    pinch_po_qty integer,
    is_published real,
    published_by text,
    published_at timestamp without time zone,
    spo_status_store text,
    spo_status_msg_store text,
    import_id_store text,
    po_status_store text,
    po_status_msg_store text,
    po_number_store text,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    spo_status_ecom text,
    spo_status_msg_ecom text,
    import_id_ecom text,
    po_status_ecom text,
    po_status_msg_ecom text,
    po_number_ecom text
);


ALTER TABLE public.blk_p_pinchpo_20260720 OWNER TO psql;

--
-- TOC entry 2056 (class 1259 OID 134214730)
-- Name: blk_p_preassortment_status; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_preassortment_status (
    product text NOT NULL,
    is_preasst smallint DEFAULT 1,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_preassortment_status OWNER TO psql;

--
-- TOC entry 2060 (class 1259 OID 135470369)
-- Name: blk_p_preassortment_stylesheet; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_preassortment_stylesheet (
    product text NOT NULL,
    preasst_uuid text NOT NULL,
    preasst_class text,
    preasst_style_name text,
    preasst_color_count integer,
    preasst_user_id text,
    preasst_force_update text,
    preasst_supplier text,
    preasst_styletype text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_preassortment_stylesheet OWNER TO psql;

--
-- TOC entry 1858 (class 1259 OID 129296013)
-- Name: blk_p_quick_pre_assortment_sheet; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_quick_pre_assortment_sheet (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    qs_stylecolor text NOT NULL,
    qs_class text,
    qs_style text,
    qs_color text,
    qs_dbt_wk text,
    qs_ranged_clust text,
    qs_cluster_group text,
    qs_color_exc text,
    qs_vendor text,
    qs_status text DEFAULT 'SANDBOX'::text,
    qs_pssr_rank double precision,
    qs_too double precision,
    qs_pres_min double precision,
    qs_cl_1 double precision,
    qs_cl_2 double precision,
    qs_cl_3 double precision,
    qs_cl_4 double precision,
    qs_cl_5 double precision,
    qs_cl_6 double precision,
    qs_cl_7 double precision,
    qs_cl_8 double precision,
    qs_cl_9 double precision,
    qs_cl_10 double precision,
    qs_cl_11 double precision,
    qs_cl_12 double precision,
    qs_cl_13 double precision,
    qs_str_count double precision,
    qs_msrp double precision,
    qs_cost double precision,
    qs_imu_pct double precision,
    qs_rcpt_u double precision,
    qs_rcpt_r double precision,
    qs_rcpt_c double precision,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_quick_pre_assortment_sheet OWNER TO psql;

--
-- TOC entry 1859 (class 1259 OID 129296026)
-- Name: blk_p_reassigncluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_reassigncluster (
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


ALTER TABLE public.blk_p_reassigncluster OWNER TO psql;

--
-- TOC entry 1860 (class 1259 OID 129296038)
-- Name: blk_p_receditclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_receditclusters (
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
    cl_07 real,
    cl_08 real,
    cl_09 real,
    cl_10 real,
    cl_11 real,
    cl_12 real,
    cl_13 real,
    cl_14 real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_receditclusters OWNER TO psql;

--
-- TOC entry 1861 (class 1259 OID 129296050)
-- Name: blk_p_receditstores; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_receditstores (
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


ALTER TABLE public.blk_p_receditstores OWNER TO psql;

--
-- TOC entry 1862 (class 1259 OID 129296062)
-- Name: blk_p_specstyleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_specstyleattributes (
    sty_spec_hq_id text NOT NULL,
    sty_spec_vpn_id text NOT NULL,
    sty_spec_vndr_style_descr text,
    sty_spec_buy_period_id text NOT NULL,
    sty_spec_buy_period_descr text,
    sty_spec_supplier_site text,
    sty_spec_supplier_desc text,
    sty_spec_plm_style_status text,
    sty_spec_season text,
    sty_spec_bi_vendor text,
    division text,
    product text NOT NULL,
    location text NOT NULL,
    sty_spec_class text,
    sty_spec_promo_code text,
    sty_spec_fold_code text,
    sty_spec_retail_price real,
    sty_spec_imu real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_specstyleattributes OWNER TO psql;

--
-- TOC entry 1863 (class 1259 OID 129296074)
-- Name: blk_p_store_attr_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_store_attr_plan (
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


ALTER TABLE public.blk_p_store_attr_plan OWNER TO psql;

--
-- TOC entry 1864 (class 1259 OID 129296086)
-- Name: blk_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_strategy_params (
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
    apply_targets_to_plan integer DEFAULT 0,
    cluster_group_selected_type text DEFAULT 'Department'::text,
    quarter text
);


ALTER TABLE public.blk_p_strategy_params OWNER TO psql;

--
-- TOC entry 1865 (class 1259 OID 129296101)
-- Name: blk_p_strategy_params_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_strategy_params_bkp (
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
    record_state smallint
);


ALTER TABLE public.blk_p_strategy_params_bkp OWNER TO psql;

--
-- TOC entry 1866 (class 1259 OID 129296106)
-- Name: blk_p_strategy_params_bkp_03142026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_strategy_params_bkp_03142026 (
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
    apply_targets_to_plan integer,
    cluster_group_selected_type text,
    quarter text
);


ALTER TABLE public.blk_p_strategy_params_bkp_03142026 OWNER TO psql;

--
-- TOC entry 1867 (class 1259 OID 129296111)
-- Name: blk_p_strategy_params_pre_05082026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_strategy_params_pre_05082026 (
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
    apply_targets_to_plan integer,
    cluster_group_selected_type text,
    quarter text
);


ALTER TABLE public.blk_p_strategy_params_pre_05082026 OWNER TO psql;

--
-- TOC entry 1868 (class 1259 OID 129296116)
-- Name: blk_p_stylecolor_extra_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_stylecolor_extra_params (
    product text NOT NULL,
    reset_inv_for_relaunch real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying DEFAULT 'system'::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying DEFAULT 'system'::character varying,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_p_stylecolor_extra_params OWNER TO psql;

--
-- TOC entry 1869 (class 1259 OID 129296128)
-- Name: blk_p_target_include_exclude; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_p_target_include_exclude (
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


ALTER TABLE public.blk_p_target_include_exclude OWNER TO psql;

--
-- TOC entry 1870 (class 1259 OID 129296140)
-- Name: blk_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_pg_batch_validation (
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


ALTER TABLE public.blk_pg_batch_validation OWNER TO psql;

--
-- TOC entry 1871 (class 1259 OID 129296146)
-- Name: blk_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_pg_batch_validation_archive (
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


ALTER TABLE public.blk_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 1872 (class 1259 OID 129296152)
-- Name: blk_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_pg_batch_validation_failure (
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


ALTER TABLE public.blk_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 1873 (class 1259 OID 129296158)
-- Name: blk_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_pg_batch_validation_previous (
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


ALTER TABLE public.blk_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 2057 (class 1259 OID 134214766)
-- Name: blk_phantom_pivot_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_phantom_pivot_tbl (
    session_id text NOT NULL
);


ALTER TABLE public.blk_phantom_pivot_tbl OWNER TO psql;

--
-- TOC entry 1874 (class 1259 OID 129296164)
-- Name: blk_plan_ignore; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_plan_ignore (
    product text,
    styclr_open_10 text
);


ALTER TABLE public.blk_plan_ignore OWNER TO psql;

--
-- TOC entry 1875 (class 1259 OID 129296169)
-- Name: blk_plan_queue_item_list; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_plan_queue_item_list (
    member_id text,
    client_id text
);


ALTER TABLE public.blk_plan_queue_item_list OWNER TO psql;

--
-- TOC entry 1876 (class 1259 OID 129296174)
-- Name: blk_plan_these_cloned_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_plan_these_cloned_style_stylecolors (
    style text NOT NULL,
    stylecolor text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    picked_for_planning integer
);


ALTER TABLE public.blk_plan_these_cloned_style_stylecolors OWNER TO psql;

--
-- TOC entry 1877 (class 1259 OID 129296179)
-- Name: blk_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_roledimension (
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


ALTER TABLE public.blk_roledimension OWNER TO psql;

--
-- TOC entry 1878 (class 1259 OID 129296191)
-- Name: blk_rollforward_insert_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_rollforward_insert_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    "current_date" date,
    version_id bigint,
    created_at timestamp with time zone,
    created_by text,
    updated_at timestamp with time zone,
    updated_by text,
    record_state smallint,
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.blk_rollforward_insert_a_assortment OWNER TO psql;

--
-- TOC entry 1879 (class 1259 OID 129296196)
-- Name: blk_rollforward_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_rollforward_items (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.blk_rollforward_items OWNER TO psql;

--
-- TOC entry 1880 (class 1259 OID 129296201)
-- Name: blk_rollforward_max_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_rollforward_max_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.blk_rollforward_max_a_assortment OWNER TO psql;

--
-- TOC entry 1881 (class 1259 OID 129296206)
-- Name: blk_rollforward_missing_floorset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_rollforward_missing_floorset (
    product text,
    "time" text
);


ALTER TABLE public.blk_rollforward_missing_floorset OWNER TO psql;

--
-- TOC entry 1882 (class 1259 OID 129296211)
-- Name: blk_rollforward_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_rollforward_time (
    product text,
    location text,
    indx integer,
    "time" text
);


ALTER TABLE public.blk_rollforward_time OWNER TO psql;

--
-- TOC entry 1883 (class 1259 OID 129296216)
-- Name: blk_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_servicedefn (
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


ALTER TABLE public.blk_servicedefn OWNER TO psql;

--
-- TOC entry 1884 (class 1259 OID 129296228)
-- Name: blk_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.blk_sizinglookup OWNER TO psql;

--
-- TOC entry 1885 (class 1259 OID 129296233)
-- Name: blk_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.blk_specimages OWNER TO psql;

--
-- TOC entry 1886 (class 1259 OID 129296238)
-- Name: blk_specstyle_attr_buy_period; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_buy_period (
    hq_id text,
    vpn_id text,
    vndr_style_descr text,
    buy_period_id character varying(200),
    buy_period_descr text,
    supplier_site text,
    supplier_desc text,
    plm_style_status text,
    season text,
    bi_vendor text,
    division text,
    product text,
    location text,
    sty_spec_class text,
    sty_spec_promo_code text,
    sty_spec_fold_code text,
    sty_spec_retail_price text,
    sty_spec_imu real,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_specstyle_attr_buy_period OWNER TO psql;

--
-- TOC entry 1887 (class 1259 OID 129296250)
-- Name: blk_specstyle_attr_buy_period_bk_20260330; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_buy_period_bk_20260330 (
    hq_id text,
    vpn_id text,
    vndr_style_descr text,
    buy_period_id character varying(200),
    buy_period_descr text,
    supplier_site text,
    supplier_desc text,
    plm_style_status text,
    season text,
    bi_vendor text,
    division text,
    product text,
    location text,
    sty_spec_class text,
    sty_spec_promo_code text,
    sty_spec_fold_code text,
    sty_spec_retail_price text,
    sty_spec_imu real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_specstyle_attr_buy_period_bk_20260330 OWNER TO psql;

--
-- TOC entry 1888 (class 1259 OID 129296255)
-- Name: blk_specstyle_attr_buy_period_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_buy_period_intraday (
    hq_id text,
    vpn_id text,
    vndr_style_descr text,
    buy_period_id character varying(200),
    buy_period_descr text,
    supplier_site text,
    supplier_desc text,
    plm_style_status text,
    season text,
    bi_vendor text,
    division text,
    product text,
    location text,
    sty_spec_class text,
    sty_spec_promo_code text,
    sty_spec_fold_code text,
    sty_spec_retail_price text,
    sty_spec_imu real,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_specstyle_attr_buy_period_intraday OWNER TO psql;

--
-- TOC entry 1889 (class 1259 OID 129296260)
-- Name: blk_specstyle_attr_week; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_week (
    hq_id text,
    vpn_id text,
    vpn_desc text,
    color_cd text,
    color_descr text,
    division text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    week_id text,
    supplier_site text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    season text,
    cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.blk_specstyle_attr_week OWNER TO psql;

--
-- TOC entry 1890 (class 1259 OID 129296272)
-- Name: blk_specstyle_attr_week_bk_20260330; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_week_bk_20260330 (
    hq_id text,
    vpn_id text,
    vpn_desc text,
    color_cd text,
    color_descr text,
    division text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    week_id text,
    supplier_site text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    season text,
    cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_specstyle_attr_week_bk_20260330 OWNER TO psql;

--
-- TOC entry 1891 (class 1259 OID 129296277)
-- Name: blk_specstyle_attr_week_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_specstyle_attr_week_intraday (
    hq_id text,
    vpn_id text,
    vpn_desc text,
    color_cd text,
    color_descr text,
    division text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    week_id text,
    supplier_site text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    season text,
    cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_specstyle_attr_week_intraday OWNER TO psql;

--
-- TOC entry 1892 (class 1259 OID 129296282)
-- Name: blk_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_store_hier_attr AS
 SELECT a.location,
    a.strname,
    a.str_grade AS str_cluster,
    a.str_dc_type,
    a.str_segmentation,
    a.str_sub_segmentation,
    a.str_aa_ind,
    a.str_hisp_ind,
    a.str_sq_ft,
    a.str_density,
    a.str_lifestyle_01,
    a.str_lifestyle_02,
    a.str_lifestyle_03,
    a.str_lifestyle_04,
    a.str_climate,
    a.str_open_sell,
    a.str_store_status,
    a.str_area,
    a.str_region,
    a.str_district,
    a.str_shop_doors,
    a.str_address,
    a.str_city,
    a.str_state,
    a.str_latitude,
    a.str_longitude,
    a.str_store_format,
    a.str_loc_attr_1,
    a.str_loc_attr_2,
    a.str_loc_attr_3,
    a.str_loc_attr_4,
    a.str_loc_attr_5,
    a.str_loc_attr_6,
    a.str_loc_attr_7,
    a.str_loc_attr_8,
    a.str_loc_attr_9,
    a.str_loc_attr_10,
    a.str_loc_attr_11,
    a.str_loc_attr_12,
    a.str_loc_attr_13,
    a.str_loc_attr_14,
    a.str_loc_attr_15,
    a.str_loc_attr_16,
    a.location AS store,
    NULL::text AS district,
    a.district_name,
    a.district_desc,
    NULL::text AS region,
    a.region_name,
    a.region_desc,
    NULL::text AS area,
    a.area_name,
    a.area_desc,
    b.ancestor0 AS selling_channel,
    a.selling_channel_name,
    a.selling_channel_desc,
    b.ancestor1 AS banner,
    a.banner_name,
    a.banner_desc,
    b.ancestor2 AS channel,
    a.channel_name,
    a.channel_desc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state
   FROM (blk_ma_storeattributes a
     LEFT JOIN blk_h_locstd b ON ((a.location = b.id)))
  ORDER BY a.location;


ALTER VIEW public.blk_store_hier_attr OWNER TO psql;

--
-- TOC entry 1893 (class 1259 OID 129296287)
-- Name: blk_style_clone_flat_map_temp_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_style_clone_flat_map_temp_archive (
    from_id text NOT NULL,
    to_id text NOT NULL,
    levelid text NOT NULL,
    session_id text NOT NULL,
    clone_ordinal text NOT NULL,
    to_name text,
    to_desc text,
    cccolor text,
    cccolorfamily text,
    eventdate timestamp(0) without time zone,
    version_id text NOT NULL,
    created_at timestamp(0) without time zone,
    created_by text NOT NULL,
    updated_at timestamp(0) without time zone,
    updated_by text NOT NULL
);


ALTER TABLE public.blk_style_clone_flat_map_temp_archive OWNER TO psql;

--
-- TOC entry 1894 (class 1259 OID 129296292)
-- Name: blk_style_clone_stylecolor_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_style_clone_stylecolor_size (
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


ALTER TABLE public.blk_style_clone_stylecolor_size OWNER TO psql;

--
-- TOC entry 1895 (class 1259 OID 129296297)
-- Name: blk_style_clone_stylecolor_size_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_style_clone_stylecolor_size_archive (
    from_style text,
    to_new_style text,
    from_stylecolor text,
    to_new_stylecolor text,
    from_stylecolorsize text,
    to_new_stylecolorsize text,
    session_id text,
    picked_for_planning text,
    clone_ordinal text,
    to_new_style_name text,
    to_new_style_desc text,
    to_new_stylecolor_name text,
    to_new_stylecolor_desc text,
    eventdate timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    created_by text,
    updated_at timestamp(0) without time zone,
    updated_by text
);


ALTER TABLE public.blk_style_clone_stylecolor_size_archive OWNER TO psql;

--
-- TOC entry 1896 (class 1259 OID 129296302)
-- Name: blk_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_stylecolor_hier_attr AS
 SELECT a.product,
    a.cc_initial_launch_month,
    a.cccolor,
    a.cc_diff_type,
    a.cc_color_desc,
    a.cc_colorfamily_code,
    a.cccolorfamily,
    a.cc_merch_color_name,
    a.cc_vpn,
    a.cc_vpn_color,
    a.cc_first_rec_week,
    a.cc_first_inv_week,
    a.cc_first_sale_week,
    a.cc_first_md_week,
    a.cc_last_md_week,
    a.cc_msrp,
    a.cc_current_retail,
    a.ccstylecolorcreatedate,
    a.cc_dropship_indicator,
    a.cc_replenishemnt_indicator,
    a.cc_selling_season,
    a.cc_selling_year,
    a.cc_segment_buy,
    a.cc_silhouette,
    a.cc_subcategory,
    a.cc_program_name,
    a.cc_print_vs_solid,
    a.cc_sleeve_length,
    a.cc_fashion_vs_basic,
    a.cc_top_length,
    a.cc_denim_rise,
    a.cc_bottom_fit,
    a.cc_dress_length,
    a.cc_neckline,
    a.cc_inseam,
    a.cc_lounge_vs_sleep,
    a.cc_bottom_silo,
    a.cc_robe,
    a.cc_print_type,
    a.cc_fit_solution,
    a.cc_d_cup_available,
    a.cc_occasion,
    a.cc_categories,
    a.cc_cut_fit,
    a.cc_construction,
    a.cc_bridal_registry,
    a.cc_levi_fits,
    a.cc_graphic_type,
    a.cc_classification,
    a.cc_young_contemporary,
    a.cc_short_inseam,
    a.cc_denim_trends,
    a.cc_collegiate,
    a.cc_set,
    a.cc_material,
    a.cc_configuration,
    a.cc_bedding_accessories,
    a.cc_fabric_description,
    a.cc_black_friday_ind,
    a.cc_superbuy_ind,
    a.cc_aa_ind,
    a.cc_coastal_ind,
    a.cc_lodge_ind,
    a.cc_white_dinnerware_ind,
    a.cc_customer_need,
    a.cc_fashion_jewelry,
    a.cc_material_color,
    a.cc_material_type,
    a.cc_jewelry_presentation,
    a.cc_necklaces,
    a.cc_texture_pattern,
    a.cc_high_value_status,
    a.cc_fine_jewelry_metal,
    a.cc_stone,
    a.cc_bridal,
    a.cc_metal_type,
    a.cc_chain_type,
    a.cc_bracelets,
    a.cc_ears,
    a.cc_ring,
    a.cc_dial_color,
    a.cc_watch,
    a.cc_dtw_fine_jewelry,
    a.cc_gold_mkt_fine_jewelry,
    a.cc_grams_fine_jewelry,
    a.cc_silver_mkt_fine_jewelry,
    a.cc_silver_grams,
    a.cc_ctw_fine_jewelry,
    a.cc_shoe_type,
    a.cc_shaft_height,
    a.cc_outsole,
    a.cc_closure,
    a.cc_toe_type,
    a.cc_sole_type,
    a.cc_toe_character,
    a.cc_heel_type,
    a.cc_heel_height,
    a.cc_fabric_type,
    a.cc_width,
    a.cc_tech_features,
    a.cc_skechers_division,
    a.cc_level_of_presentation,
    a.cc_fragrance_scents,
    a.cc_total_makeup,
    a.cc_makeup_total_face,
    a.cc_total_fragrance,
    a.cc_makeup_total_lip,
    a.cc_total_skincare,
    a.cc_makeup_total_eye,
    a.cc_skincare_total_face,
    a.cc_styclr_status,
    a.cc_skulist_id,
    a.cc_skulist_desc,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    date_trunc('second'::text, a.cc_prepublished_at) AS cc_prepublished_at,
    a.cc_nrf_color_code_non_plm,
    a.cc_nrf_color_desc_non_plm,
    a.cc_set_flag,
    a.cc_price_exception,
    a.cc_last_published_by,
    a.cc_last_published_on,
    a.cc_s5_stylecolor_status,
    a.cc_s5_stylecolor_status_msg,
    a.cc_vpn_color_desc,
    a.cc_vpn_color_display,
    c.sty_vpn,
    c.sty_supplier_number,
    c.sty_supplier_name,
    c.sty_size_range,
    c.sty_style_type,
    c.ccstylecreatedate,
    c.sty_style_status,
    c.supp_supplier_site_id,
    c.supp_supplier_name,
    c.supp_parent_supplier_id,
    c.supp_parent_supplier_name,
    c.supp_status,
    c.supp_class_group,
    c.supp_brand_mindset,
    c.supp_brand_type,
    c.supp_brand,
    c.supp_priceband,
    c.supp_bi_flg,
    c.supp_grp_parent_id,
    c.supp_grp_standard_id,
    c.supp_grp_brand_id,
    c.supp_ninebox,
    c.supp_lifestyle,
    c.supp_direct_ship_ind,
    c.class_group_id,
    c.class_group_name,
    c.dpt_department_id,
    c.dpt_gmm_id,
    c.dpt_gmm_desc,
    c.dpt_dmm_id,
    c.dpt_dmm_desc,
    c.dpt_buyer_id,
    c.dpt_buyer_desc,
    c.dpt_sr_planner_id,
    c.dpt_sr_planner_desc,
    c.dpt_planner_id,
    c.dpt_planner_desc,
    c.dpt_dir_id,
    c.dpt_dir_desc,
    c.dpt_vp_id,
    c.dpt_vp_desc,
    c.dpt_svp_id,
    c.dpt_svp_desc,
    c.dpt_evp_id,
    c.dpt_evp_desc,
    c.dpt_marketplace_indicator,
    c.dpt_memo_dept_indicator,
    c.dpt_royalty_pct,
    c.sty_is_locked,
    c.sty_s5_adopted,
    c.sty_vpn_id_non_plm,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_id,
    b.ancestor5 AS division,
    b.ancestor6 AS total_brand,
    d.name AS stylecolor_name,
    d.description AS stylecolor_desc,
    e.name AS style_name,
    e.description AS style_desc,
    f.name AS subclass_name,
    f.description AS subclass_desc,
    g.name AS class_name,
    g.description AS class_desc,
    h.name AS department_name,
    h.description AS department_desc,
    i.name AS group_name,
    i.description AS group_desc,
    j.name AS division_name,
    j.description AS division_desc,
    k.name AS total_brand_name,
    k.description AS total_brand_desc,
    '0'::text AS ispublishable,
    '0'::text AS isprepublishable,
    a.eventdate,
    a.version_id,
    (date_trunc('second'::text, a.created_at))::timestamp(0) without time zone AS created_at,
    a.created_by,
    (GREATEST(date_trunc('second'::text, a.updated_at), date_trunc('second'::text, c.updated_at)))::timestamp(0) without time zone AS updated_at,
    a.updated_by,
    a.record_state,
    c.sty_vpn_final,
    a.cccolorid,
    a.cc_orin_stylecolor,
    c.sty_orin_style,
    c.sty_style_name,
    c.sty_style_description,
    c.sty_buy_period_descr,
    c.sty_dpt_buy_period,
    c.sty_vpn_buy_period,
    a.cc_cost,
    a.cc_buy_period_descr,
    a.cc_vpn_buy_period,
    a.cc_floorset,
        CASE
            WHEN (a.cc_use_sys_floorset = true) THEN 1
            ELSE 0
        END AS cc_use_sys_floorset,
    c.sty_num_clones_s5,
    c.sty_num_times_cloned_s5,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5
   FROM ((((((((((blk_ma_stylecolorattributes a
     JOIN blk_h_prodstd b ON ((a.product = b.id)))
     JOIN blk_ma_styleattributes c ON ((b.ancestor0 = c.product)))
     JOIN blk_d_product d ON (((a.product = d.id) AND (d.levelid = 'stylecolor'::text))))
     JOIN blk_d_product e ON (((b.ancestor0 = e.id) AND (e.levelid = 'style'::text))))
     JOIN blk_d_product f ON (((b.ancestor1 = f.id) AND (f.levelid = 'subclass'::text))))
     JOIN blk_d_product g ON (((b.ancestor2 = g.id) AND (g.levelid = 'class'::text))))
     JOIN blk_d_product h ON (((b.ancestor3 = h.id) AND (h.levelid = 'department'::text))))
     JOIN blk_d_product i ON (((b.ancestor4 = i.id) AND (i.levelid = 'group_id'::text))))
     JOIN blk_d_product j ON (((b.ancestor5 = j.id) AND (j.levelid = 'division'::text))))
     JOIN blk_d_product k ON (((b.ancestor6 = k.id) AND (k.levelid = 'total_brand'::text))));


ALTER VIEW public.blk_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 1897 (class 1259 OID 129296307)
-- Name: blk_stylecolor_hier_attr_cyclic; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_stylecolor_hier_attr_cyclic AS
 SELECT a.product,
    a.cc_initial_launch_month,
    a.cccolor,
    a.cc_diff_type,
    a.cc_color_desc,
    a.cc_colorfamily_code,
    a.cccolorfamily,
    a.cc_merch_color_name,
    a.cc_vpn,
    a.cc_vpn_color,
    a.cc_first_rec_week,
    a.cc_first_inv_week,
    a.cc_first_sale_week,
    a.cc_first_md_week,
    a.cc_last_md_week,
    a.cc_msrp,
    a.cc_current_retail,
    a.ccstylecolorcreatedate,
    a.cc_dropship_indicator,
    a.cc_replenishemnt_indicator,
    a.cc_selling_season,
    a.cc_selling_year,
    a.cc_segment_buy,
    a.cc_silhouette,
    a.cc_subcategory,
    a.cc_program_name,
    a.cc_print_vs_solid,
    a.cc_sleeve_length,
    a.cc_fashion_vs_basic,
    a.cc_top_length,
    a.cc_denim_rise,
    a.cc_bottom_fit,
    a.cc_dress_length,
    a.cc_neckline,
    a.cc_inseam,
    a.cc_lounge_vs_sleep,
    a.cc_bottom_silo,
    a.cc_robe,
    a.cc_print_type,
    a.cc_fit_solution,
    a.cc_d_cup_available,
    a.cc_occasion,
    a.cc_categories,
    a.cc_cut_fit,
    a.cc_construction,
    a.cc_bridal_registry,
    a.cc_levi_fits,
    a.cc_graphic_type,
    a.cc_classification,
    a.cc_young_contemporary,
    a.cc_short_inseam,
    a.cc_denim_trends,
    a.cc_collegiate,
    a.cc_set,
    a.cc_material,
    a.cc_configuration,
    a.cc_bedding_accessories,
    a.cc_fabric_description,
    a.cc_black_friday_ind,
    a.cc_superbuy_ind,
    a.cc_aa_ind,
    a.cc_coastal_ind,
    a.cc_lodge_ind,
    a.cc_white_dinnerware_ind,
    a.cc_customer_need,
    a.cc_fashion_jewelry,
    a.cc_material_color,
    a.cc_material_type,
    a.cc_jewelry_presentation,
    a.cc_necklaces,
    a.cc_texture_pattern,
    a.cc_high_value_status,
    a.cc_fine_jewelry_metal,
    a.cc_stone,
    a.cc_bridal,
    a.cc_metal_type,
    a.cc_chain_type,
    a.cc_bracelets,
    a.cc_ears,
    a.cc_ring,
    a.cc_dial_color,
    a.cc_watch,
    a.cc_dtw_fine_jewelry,
    a.cc_gold_mkt_fine_jewelry,
    a.cc_grams_fine_jewelry,
    a.cc_silver_mkt_fine_jewelry,
    a.cc_silver_grams,
    a.cc_ctw_fine_jewelry,
    a.cc_shoe_type,
    a.cc_shaft_height,
    a.cc_outsole,
    a.cc_closure,
    a.cc_toe_type,
    a.cc_sole_type,
    a.cc_toe_character,
    a.cc_heel_type,
    a.cc_heel_height,
    a.cc_fabric_type,
    a.cc_width,
    a.cc_tech_features,
    a.cc_skechers_division,
    a.cc_level_of_presentation,
    a.cc_fragrance_scents,
    a.cc_total_makeup,
    a.cc_makeup_total_face,
    a.cc_total_fragrance,
    a.cc_makeup_total_lip,
    a.cc_total_skincare,
    a.cc_makeup_total_eye,
    a.cc_skincare_total_face,
    a.cc_styclr_status,
    a.cc_skulist_id,
    a.cc_skulist_desc,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    date_trunc('second'::text, a.cc_prepublished_at) AS cc_prepublished_at,
    a.cc_nrf_color_code_non_plm,
    a.cc_nrf_color_desc_non_plm,
    a.cc_set_flag,
    a.cc_price_exception,
    a.cc_last_published_by,
    a.cc_last_published_on,
    a.cc_s5_stylecolor_status,
    a.cc_s5_stylecolor_status_msg,
    a.cc_vpn_color_desc,
    a.cc_vpn_color_display,
    c.sty_vpn,
    c.sty_supplier_number,
    c.sty_supplier_name,
    c.sty_size_range,
    c.sty_style_type,
    c.ccstylecreatedate,
    c.sty_style_status,
    c.supp_supplier_site_id,
    c.supp_supplier_name,
    c.supp_parent_supplier_id,
    c.supp_parent_supplier_name,
    c.supp_status,
    c.supp_class_group,
    c.supp_brand_mindset,
    c.supp_brand_type,
    c.supp_brand,
    c.supp_priceband,
    c.supp_bi_flg,
    c.supp_grp_parent_id,
    c.supp_grp_standard_id,
    c.supp_grp_brand_id,
    c.supp_ninebox,
    c.supp_lifestyle,
    c.supp_direct_ship_ind,
    c.class_group_id,
    c.class_group_name,
    c.dpt_department_id,
    c.dpt_gmm_id,
    c.dpt_gmm_desc,
    c.dpt_dmm_id,
    c.dpt_dmm_desc,
    c.dpt_buyer_id,
    c.dpt_buyer_desc,
    c.dpt_sr_planner_id,
    c.dpt_sr_planner_desc,
    c.dpt_planner_id,
    c.dpt_planner_desc,
    c.dpt_dir_id,
    c.dpt_dir_desc,
    c.dpt_vp_id,
    c.dpt_vp_desc,
    c.dpt_svp_id,
    c.dpt_svp_desc,
    c.dpt_evp_id,
    c.dpt_evp_desc,
    c.dpt_marketplace_indicator,
    c.dpt_memo_dept_indicator,
    c.dpt_royalty_pct,
    c.sty_is_locked,
    c.sty_s5_adopted,
    c.sty_vpn_id_non_plm,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_id,
    b.ancestor5 AS division,
    b.ancestor6 AS total_brand,
    d.stylecolor_name,
    d.stylecolor_desc,
    e.style_name,
    e.style_desc,
    f.subclass_name,
    f.subclass_desc,
    g.class_name,
    g.class_desc,
    h.department_name,
    h.department_desc,
    i.group_name,
    i.group_desc,
    j.division_name,
    j.division_desc,
    k.total_brand_name,
    k.total_brand_desc,
    '0'::text AS ispublishable,
    '0'::text AS isprepublishable,
    a.eventdate,
    a.version_id,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    (GREATEST(date_trunc('second'::text, a.updated_at), date_trunc('second'::text, c.updated_at)))::timestamp(0) without time zone AS updated_at,
    a.updated_by,
    a.record_state,
    c.sty_vpn_final,
    a.cccolorid,
    a.cc_orin_stylecolor,
    c.sty_orin_style,
    c.sty_style_name,
    c.sty_style_description,
    c.sty_buy_period_descr,
    c.sty_dpt_buy_period,
    c.sty_vpn_buy_period,
    a.cc_cost,
    a.cc_buy_period_descr,
    a.cc_vpn_buy_period,
    a.cc_floorset,
        CASE
            WHEN (a.cc_use_sys_floorset = true) THEN 1
            ELSE 0
        END AS cc_use_sys_floorset,
    c.sty_num_clones_s5,
    c.sty_num_times_cloned_s5,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5
   FROM ( SELECT blk_ma_stylecolorattributes.product,
            blk_ma_stylecolorattributes.cc_initial_launch_month,
            blk_ma_stylecolorattributes.cccolor,
            blk_ma_stylecolorattributes.cc_diff_type,
            blk_ma_stylecolorattributes.cc_color_desc,
            blk_ma_stylecolorattributes.cc_colorfamily_code,
            blk_ma_stylecolorattributes.cccolorfamily,
            blk_ma_stylecolorattributes.cc_merch_color_name,
            blk_ma_stylecolorattributes.cc_vpn,
            blk_ma_stylecolorattributes.cc_vpn_color,
            blk_ma_stylecolorattributes.cc_first_rec_week,
            blk_ma_stylecolorattributes.cc_first_inv_week,
            blk_ma_stylecolorattributes.cc_first_sale_week,
            blk_ma_stylecolorattributes.cc_first_md_week,
            blk_ma_stylecolorattributes.cc_last_md_week,
            blk_ma_stylecolorattributes.cc_msrp,
            blk_ma_stylecolorattributes.cc_current_retail,
            blk_ma_stylecolorattributes.ccstylecolorcreatedate,
            blk_ma_stylecolorattributes.cc_dropship_indicator,
            blk_ma_stylecolorattributes.cc_replenishemnt_indicator,
            blk_ma_stylecolorattributes.cc_selling_season,
            blk_ma_stylecolorattributes.cc_selling_year,
            blk_ma_stylecolorattributes.cc_segment_buy,
            blk_ma_stylecolorattributes.cc_silhouette,
            blk_ma_stylecolorattributes.cc_subcategory,
            blk_ma_stylecolorattributes.cc_program_name,
            blk_ma_stylecolorattributes.cc_print_vs_solid,
            blk_ma_stylecolorattributes.cc_sleeve_length,
            blk_ma_stylecolorattributes.cc_fashion_vs_basic,
            blk_ma_stylecolorattributes.cc_top_length,
            blk_ma_stylecolorattributes.cc_denim_rise,
            blk_ma_stylecolorattributes.cc_bottom_fit,
            blk_ma_stylecolorattributes.cc_dress_length,
            blk_ma_stylecolorattributes.cc_neckline,
            blk_ma_stylecolorattributes.cc_inseam,
            blk_ma_stylecolorattributes.cc_lounge_vs_sleep,
            blk_ma_stylecolorattributes.cc_bottom_silo,
            blk_ma_stylecolorattributes.cc_robe,
            blk_ma_stylecolorattributes.cc_print_type,
            blk_ma_stylecolorattributes.cc_fit_solution,
            blk_ma_stylecolorattributes.cc_d_cup_available,
            blk_ma_stylecolorattributes.cc_occasion,
            blk_ma_stylecolorattributes.cc_categories,
            blk_ma_stylecolorattributes.cc_cut_fit,
            blk_ma_stylecolorattributes.cc_construction,
            blk_ma_stylecolorattributes.cc_bridal_registry,
            blk_ma_stylecolorattributes.cc_levi_fits,
            blk_ma_stylecolorattributes.cc_graphic_type,
            blk_ma_stylecolorattributes.cc_classification,
            blk_ma_stylecolorattributes.cc_young_contemporary,
            blk_ma_stylecolorattributes.cc_short_inseam,
            blk_ma_stylecolorattributes.cc_denim_trends,
            blk_ma_stylecolorattributes.cc_collegiate,
            blk_ma_stylecolorattributes.cc_set,
            blk_ma_stylecolorattributes.cc_material,
            blk_ma_stylecolorattributes.cc_configuration,
            blk_ma_stylecolorattributes.cc_bedding_accessories,
            blk_ma_stylecolorattributes.cc_fabric_description,
            blk_ma_stylecolorattributes.cc_black_friday_ind,
            blk_ma_stylecolorattributes.cc_superbuy_ind,
            blk_ma_stylecolorattributes.cc_aa_ind,
            blk_ma_stylecolorattributes.cc_coastal_ind,
            blk_ma_stylecolorattributes.cc_lodge_ind,
            blk_ma_stylecolorattributes.cc_white_dinnerware_ind,
            blk_ma_stylecolorattributes.cc_customer_need,
            blk_ma_stylecolorattributes.cc_fashion_jewelry,
            blk_ma_stylecolorattributes.cc_material_color,
            blk_ma_stylecolorattributes.cc_material_type,
            blk_ma_stylecolorattributes.cc_jewelry_presentation,
            blk_ma_stylecolorattributes.cc_necklaces,
            blk_ma_stylecolorattributes.cc_texture_pattern,
            blk_ma_stylecolorattributes.cc_high_value_status,
            blk_ma_stylecolorattributes.cc_fine_jewelry_metal,
            blk_ma_stylecolorattributes.cc_stone,
            blk_ma_stylecolorattributes.cc_bridal,
            blk_ma_stylecolorattributes.cc_metal_type,
            blk_ma_stylecolorattributes.cc_chain_type,
            blk_ma_stylecolorattributes.cc_bracelets,
            blk_ma_stylecolorattributes.cc_ears,
            blk_ma_stylecolorattributes.cc_ring,
            blk_ma_stylecolorattributes.cc_dial_color,
            blk_ma_stylecolorattributes.cc_watch,
            blk_ma_stylecolorattributes.cc_dtw_fine_jewelry,
            blk_ma_stylecolorattributes.cc_gold_mkt_fine_jewelry,
            blk_ma_stylecolorattributes.cc_grams_fine_jewelry,
            blk_ma_stylecolorattributes.cc_silver_mkt_fine_jewelry,
            blk_ma_stylecolorattributes.cc_silver_grams,
            blk_ma_stylecolorattributes.cc_ctw_fine_jewelry,
            blk_ma_stylecolorattributes.cc_shoe_type,
            blk_ma_stylecolorattributes.cc_shaft_height,
            blk_ma_stylecolorattributes.cc_outsole,
            blk_ma_stylecolorattributes.cc_closure,
            blk_ma_stylecolorattributes.cc_toe_type,
            blk_ma_stylecolorattributes.cc_sole_type,
            blk_ma_stylecolorattributes.cc_toe_character,
            blk_ma_stylecolorattributes.cc_heel_type,
            blk_ma_stylecolorattributes.cc_heel_height,
            blk_ma_stylecolorattributes.cc_fabric_type,
            blk_ma_stylecolorattributes.cc_width,
            blk_ma_stylecolorattributes.cc_tech_features,
            blk_ma_stylecolorattributes.cc_skechers_division,
            blk_ma_stylecolorattributes.cc_level_of_presentation,
            blk_ma_stylecolorattributes.cc_fragrance_scents,
            blk_ma_stylecolorattributes.cc_total_makeup,
            blk_ma_stylecolorattributes.cc_makeup_total_face,
            blk_ma_stylecolorattributes.cc_total_fragrance,
            blk_ma_stylecolorattributes.cc_makeup_total_lip,
            blk_ma_stylecolorattributes.cc_total_skincare,
            blk_ma_stylecolorattributes.cc_makeup_total_eye,
            blk_ma_stylecolorattributes.cc_skincare_total_face,
            blk_ma_stylecolorattributes.cc_styclr_status,
            blk_ma_stylecolorattributes.cc_skulist_id,
            blk_ma_stylecolorattributes.cc_skulist_desc,
            blk_ma_stylecolorattributes.total_brand_name,
            blk_ma_stylecolorattributes.division_name,
            blk_ma_stylecolorattributes.group_name,
            blk_ma_stylecolorattributes.department_name,
            blk_ma_stylecolorattributes.class_name,
            blk_ma_stylecolorattributes.subclass_name,
            blk_ma_stylecolorattributes.eventdate,
            blk_ma_stylecolorattributes.version_id,
            blk_ma_stylecolorattributes.created_at,
            blk_ma_stylecolorattributes.created_by,
            blk_ma_stylecolorattributes.updated_at,
            blk_ma_stylecolorattributes.updated_by,
            blk_ma_stylecolorattributes.record_state,
            blk_ma_stylecolorattributes.isassortment,
            blk_ma_stylecolorattributes.merch_comments,
            blk_ma_stylecolorattributes.plan_comments,
            blk_ma_stylecolorattributes.cc_is_locked,
            blk_ma_stylecolorattributes.cc_s5_adopted,
            blk_ma_stylecolorattributes.cc_prepublish,
            blk_ma_stylecolorattributes.cc_prepublished_at,
            blk_ma_stylecolorattributes.cc_nrf_color_code_non_plm,
            blk_ma_stylecolorattributes.cc_nrf_color_desc_non_plm,
            blk_ma_stylecolorattributes.cc_set_flag,
            blk_ma_stylecolorattributes.cc_price_exception,
            blk_ma_stylecolorattributes.cc_last_published_by,
            blk_ma_stylecolorattributes.cc_last_published_on,
            blk_ma_stylecolorattributes.cc_s5_stylecolor_status,
            blk_ma_stylecolorattributes.cc_s5_stylecolor_status_msg,
            blk_ma_stylecolorattributes.supp_brand_95,
            blk_ma_stylecolorattributes.cc_vpn_color_desc,
            blk_ma_stylecolorattributes.cc_vpn_color_display,
            blk_ma_stylecolorattributes.cccolorid,
            blk_ma_stylecolorattributes.cc_orin_stylecolor,
            blk_ma_stylecolorattributes.cc_cost,
            blk_ma_stylecolorattributes.cc_buy_period_descr,
            blk_ma_stylecolorattributes.cc_vpn_buy_period,
            blk_ma_stylecolorattributes.cc_floorset,
            blk_ma_stylecolorattributes.cc_use_sys_floorset,
            blk_ma_stylecolorattributes.cc_num_clones_s5,
            blk_ma_stylecolorattributes.cc_num_times_cloned_s5
           FROM blk_ma_stylecolorattributes
          WHERE (blk_ma_stylecolorattributes.product IN ( SELECT blk_in_item_po_status.s5_stylecolor_id
                   FROM blk_in_item_po_status
                  WHERE (blk_in_item_po_status.api_req_type = 'ITEM_CREATION'::text)))) a,
    blk_h_prodstd b,
    blk_ma_styleattributes c,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS stylecolor_name,
            blk_d_product.description AS stylecolor_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS style_name,
            blk_d_product.description AS style_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'style'::text)) e,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS subclass_name,
            blk_d_product.description AS subclass_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'subclass'::text)) f,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS class_name,
            blk_d_product.description AS class_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'class'::text)) g,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS department_name,
            blk_d_product.description AS department_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'department'::text)) h,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS group_name,
            blk_d_product.description AS group_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'group_id'::text)) i,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS division_name,
            blk_d_product.description AS division_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'division'::text)) j,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS total_brand_name,
            blk_d_product.description AS total_brand_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'total_brand'::text)) k
  WHERE ((a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = f.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id) AND (b.ancestor4 = i.id) AND (b.ancestor5 = j.id) AND (b.ancestor6 = k.id));


ALTER VIEW public.blk_stylecolor_hier_attr_cyclic OWNER TO psql;

--
-- TOC entry 1898 (class 1259 OID 129296312)
-- Name: tmp_blk_ma_styleattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_blk_ma_styleattributes_intraday (
    product text,
    sty_vpn text,
    sty_supplier_number text,
    sty_supplier_name text,
    sty_size_range text,
    sty_style_type text,
    ccstylecreatedate text,
    sty_style_status text,
    supp_supplier_site_id text,
    supp_supplier_name text,
    supp_parent_supplier_id text,
    supp_parent_supplier_name text,
    supp_status text,
    supp_class_group text,
    supp_brand_mindset text,
    supp_brand_type text,
    supp_brand text,
    supp_priceband text,
    supp_bi_flg text,
    supp_grp_parent_id text,
    supp_grp_standard_id text,
    supp_grp_brand_id text,
    supp_ninebox text,
    supp_lifestyle text,
    supp_direct_ship_ind text,
    class_group_id text,
    class_group_name text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text,
    sty_is_locked text,
    sty_s5_adopted text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_vpn_id_non_plm text,
    sty_vpn_final text,
    sty_orin_style text,
    sty_style_name text,
    sty_style_description text,
    sty_buy_period_descr text,
    sty_dpt_buy_period text,
    sty_vpn_buy_period text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real
);


ALTER TABLE public.tmp_blk_ma_styleattributes_intraday OWNER TO psql;

--
-- TOC entry 1899 (class 1259 OID 129296317)
-- Name: blk_stylecolor_hier_attr_intraday; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.blk_stylecolor_hier_attr_intraday AS
 SELECT a.product,
    a.cc_initial_launch_month,
    a.cccolor,
    a.cc_diff_type,
    a.cc_color_desc,
    a.cc_colorfamily_code,
    a.cccolorfamily,
    a.cc_merch_color_name,
    a.cc_vpn,
    a.cc_vpn_color,
    a.cc_first_rec_week,
    a.cc_first_inv_week,
    a.cc_first_sale_week,
    a.cc_first_md_week,
    a.cc_last_md_week,
    a.cc_msrp,
    a.cc_current_retail,
    a.ccstylecolorcreatedate,
    a.cc_dropship_indicator,
    a.cc_replenishemnt_indicator,
    a.cc_selling_season,
    a.cc_selling_year,
    a.cc_segment_buy,
    a.cc_silhouette,
    a.cc_subcategory,
    a.cc_program_name,
    a.cc_print_vs_solid,
    a.cc_sleeve_length,
    a.cc_fashion_vs_basic,
    a.cc_top_length,
    a.cc_denim_rise,
    a.cc_bottom_fit,
    a.cc_dress_length,
    a.cc_neckline,
    a.cc_inseam,
    a.cc_lounge_vs_sleep,
    a.cc_bottom_silo,
    a.cc_robe,
    a.cc_print_type,
    a.cc_fit_solution,
    a.cc_d_cup_available,
    a.cc_occasion,
    a.cc_categories,
    a.cc_cut_fit,
    a.cc_construction,
    a.cc_bridal_registry,
    a.cc_levi_fits,
    a.cc_graphic_type,
    a.cc_classification,
    a.cc_young_contemporary,
    a.cc_short_inseam,
    a.cc_denim_trends,
    a.cc_collegiate,
    a.cc_set,
    a.cc_material,
    a.cc_configuration,
    a.cc_bedding_accessories,
    a.cc_fabric_description,
    a.cc_black_friday_ind,
    a.cc_superbuy_ind,
    a.cc_aa_ind,
    a.cc_coastal_ind,
    a.cc_lodge_ind,
    a.cc_white_dinnerware_ind,
    a.cc_customer_need,
    a.cc_fashion_jewelry,
    a.cc_material_color,
    a.cc_material_type,
    a.cc_jewelry_presentation,
    a.cc_necklaces,
    a.cc_texture_pattern,
    a.cc_high_value_status,
    a.cc_fine_jewelry_metal,
    a.cc_stone,
    a.cc_bridal,
    a.cc_metal_type,
    a.cc_chain_type,
    a.cc_bracelets,
    a.cc_ears,
    a.cc_ring,
    a.cc_dial_color,
    a.cc_watch,
    a.cc_dtw_fine_jewelry,
    a.cc_gold_mkt_fine_jewelry,
    a.cc_grams_fine_jewelry,
    a.cc_silver_mkt_fine_jewelry,
    a.cc_silver_grams,
    a.cc_ctw_fine_jewelry,
    a.cc_shoe_type,
    a.cc_shaft_height,
    a.cc_outsole,
    a.cc_closure,
    a.cc_toe_type,
    a.cc_sole_type,
    a.cc_toe_character,
    a.cc_heel_type,
    a.cc_heel_height,
    a.cc_fabric_type,
    a.cc_width,
    a.cc_tech_features,
    a.cc_skechers_division,
    a.cc_level_of_presentation,
    a.cc_fragrance_scents,
    a.cc_total_makeup,
    a.cc_makeup_total_face,
    a.cc_total_fragrance,
    a.cc_makeup_total_lip,
    a.cc_total_skincare,
    a.cc_makeup_total_eye,
    a.cc_skincare_total_face,
    a.cc_styclr_status,
    a.cc_skulist_id,
    a.cc_skulist_desc,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    date_trunc('second'::text, a.cc_prepublished_at) AS cc_prepublished_at,
    a.cc_nrf_color_code_non_plm,
    a.cc_nrf_color_desc_non_plm,
    a.cc_set_flag,
    a.cc_price_exception,
    a.cc_last_published_by,
    a.cc_last_published_on,
    a.cc_s5_stylecolor_status,
    a.cc_s5_stylecolor_status_msg,
    a.cc_vpn_color_desc,
    a.cc_vpn_color_display,
    c.sty_vpn,
    c.sty_supplier_number,
    c.sty_supplier_name,
    c.sty_size_range,
    c.sty_style_type,
    c.ccstylecreatedate,
    c.sty_style_status,
    c.supp_supplier_site_id,
    c.supp_supplier_name,
    c.supp_parent_supplier_id,
    c.supp_parent_supplier_name,
    c.supp_status,
    c.supp_class_group,
    c.supp_brand_mindset,
    c.supp_brand_type,
    c.supp_brand,
    c.supp_priceband,
    c.supp_bi_flg,
    c.supp_grp_parent_id,
    c.supp_grp_standard_id,
    c.supp_grp_brand_id,
    c.supp_ninebox,
    c.supp_lifestyle,
    c.supp_direct_ship_ind,
    c.class_group_id,
    c.class_group_name,
    c.dpt_department_id,
    c.dpt_gmm_id,
    c.dpt_gmm_desc,
    c.dpt_dmm_id,
    c.dpt_dmm_desc,
    c.dpt_buyer_id,
    c.dpt_buyer_desc,
    c.dpt_sr_planner_id,
    c.dpt_sr_planner_desc,
    c.dpt_planner_id,
    c.dpt_planner_desc,
    c.dpt_dir_id,
    c.dpt_dir_desc,
    c.dpt_vp_id,
    c.dpt_vp_desc,
    c.dpt_svp_id,
    c.dpt_svp_desc,
    c.dpt_evp_id,
    c.dpt_evp_desc,
    c.dpt_marketplace_indicator,
    c.dpt_memo_dept_indicator,
    c.dpt_royalty_pct,
    c.sty_is_locked,
    c.sty_s5_adopted,
    c.sty_vpn_id_non_plm,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_id,
    b.ancestor5 AS division,
    b.ancestor6 AS total_brand,
    d.stylecolor_name,
    d.stylecolor_desc,
    e.style_name,
    e.style_desc,
    f.subclass_name,
    f.subclass_desc,
    g.class_name,
    g.class_desc,
    h.department_name,
    h.department_desc,
    i.group_name,
    i.group_desc,
    j.division_name,
    j.division_desc,
    k.total_brand_name,
    k.total_brand_desc,
    '0'::text AS ispublishable,
    '0'::text AS isprepublishable,
    a.eventdate,
    a.version_id,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    (GREATEST(date_trunc('second'::text, a.updated_at), date_trunc('second'::text, c.updated_at)))::timestamp(0) without time zone AS updated_at,
    a.updated_by,
    a.record_state,
    c.sty_vpn_final,
    a.cccolorid,
    a.cc_orin_stylecolor,
    c.sty_orin_style,
    c.sty_style_name,
    c.sty_style_description,
    c.sty_buy_period_descr,
    c.sty_dpt_buy_period,
    c.sty_vpn_buy_period,
    a.cc_cost,
    a.cc_buy_period_descr,
    a.cc_vpn_buy_period,
    a.cc_floorset,
        CASE
            WHEN (a.cc_use_sys_floorset = true) THEN 1
            ELSE 0
        END AS cc_use_sys_floorset,
    c.sty_num_clones_s5,
    c.sty_num_times_cloned_s5,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5
   FROM blk_ma_stylecolorattributes a,
    blk_h_prodstd b,
    tmp_blk_ma_styleattributes_intraday c,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS stylecolor_name,
            blk_d_product.description AS stylecolor_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS style_name,
            blk_d_product.description AS style_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'style'::text)) e,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS subclass_name,
            blk_d_product.description AS subclass_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'subclass'::text)) f,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS class_name,
            blk_d_product.description AS class_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'class'::text)) g,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS department_name,
            blk_d_product.description AS department_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'department'::text)) h,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS group_name,
            blk_d_product.description AS group_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'group_id'::text)) i,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS division_name,
            blk_d_product.description AS division_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'division'::text)) j,
    ( SELECT blk_d_product.id,
            blk_d_product.name AS total_brand_name,
            blk_d_product.description AS total_brand_desc
           FROM blk_d_product
          WHERE (blk_d_product.levelid = 'total_brand'::text)) k
  WHERE ((a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = f.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id) AND (b.ancestor4 = i.id) AND (b.ancestor5 = j.id) AND (b.ancestor6 = k.id));


ALTER VIEW public.blk_stylecolor_hier_attr_intraday OWNER TO psql;

--
-- TOC entry 1900 (class 1259 OID 129296322)
-- Name: blk_stylecolor_missing_in_qa; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_stylecolor_missing_in_qa (
    product text
);


ALTER TABLE public.blk_stylecolor_missing_in_qa OWNER TO psql;

--
-- TOC entry 1901 (class 1259 OID 129296327)
-- Name: blk_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_swatches (
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


ALTER TABLE public.blk_swatches OWNER TO psql;

--
-- TOC entry 1902 (class 1259 OID 129296339)
-- Name: blk_swatches_pre_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_swatches_pre_existing (
    attributeid text,
    validvalue text,
    datastr text,
    strtype text,
    type text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.blk_swatches_pre_existing OWNER TO psql;

--
-- TOC entry 1903 (class 1259 OID 129296344)
-- Name: blk_temp_autoapprovedclusters; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_temp_autoapprovedclusters (
    product text,
    "time" text,
    cluster_id text,
    clustering_status real
);


ALTER TABLE public.blk_temp_autoapprovedclusters OWNER TO psql;

--
-- TOC entry 1904 (class 1259 OID 129296349)
-- Name: blk_time_hier; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_time_hier (
    date_id text,
    week_id text,
    month_id text,
    quarter_id text,
    season_id text,
    year_id text
);


ALTER TABLE public.blk_time_hier OWNER TO psql;

--
-- TOC entry 1905 (class 1259 OID 129296354)
-- Name: blk_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_v_memberbasedvalidvalues (
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


ALTER TABLE public.blk_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1906 (class 1259 OID 129296366)
-- Name: blk_v_memberbasedvalidvalues_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.blk_v_memberbasedvalidvalues_bk (
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


ALTER TABLE public.blk_v_memberbasedvalidvalues_bk OWNER TO psql;

--
-- TOC entry 1907 (class 1259 OID 129296371)
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
-- TOC entry 1908 (class 1259 OID 129296376)
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
-- TOC entry 1909 (class 1259 OID 129296381)
-- Name: bulk_import_run_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_run_params (
    run_id integer NOT NULL,
    param text NOT NULL,
    str_value text
);


ALTER TABLE public.bulk_import_run_params OWNER TO psql;

--
-- TOC entry 1910 (class 1259 OID 129296386)
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
-- TOC entry 1911 (class 1259 OID 129296387)
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
-- TOC entry 1912 (class 1259 OID 129296394)
-- Name: cart_master_04112025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_04112025 (
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
    job_priority integer
);


ALTER TABLE public.cart_master_04112025 OWNER TO psql;

--
-- TOC entry 1913 (class 1259 OID 129296399)
-- Name: cart_master_20250404; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_20250404 (
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
    job_priority integer
);


ALTER TABLE public.cart_master_20250404 OWNER TO psql;

--
-- TOC entry 1914 (class 1259 OID 129296404)
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
-- TOC entry 1915 (class 1259 OID 129296411)
-- Name: cart_master_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_temp (
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
    job_priority integer
);


ALTER TABLE public.cart_master_temp OWNER TO psql;

--
-- TOC entry 1916 (class 1259 OID 129296416)
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
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk real,
    planned_sell_down_week text,
    cc_cluster_group text,
    cc_service_level real
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 1917 (class 1259 OID 129296421)
-- Name: cart_params_04112025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params_04112025 (
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
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk real,
    planned_sell_down_week text,
    cc_cluster_group text,
    cc_service_level real
);


ALTER TABLE public.cart_params_04112025 OWNER TO psql;

--
-- TOC entry 1918 (class 1259 OID 129296426)
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
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk real,
    planned_sell_down_week text,
    cc_cluster_group text,
    cc_service_level real
);


ALTER TABLE public.cart_params_archive OWNER TO psql;

--
-- TOC entry 1919 (class 1259 OID 129296431)
-- Name: cart_params_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params_cm (
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
    ccrcptint integer,
    ccordermultiple integer,
    ccordpolicy text,
    slsrnk real,
    planned_sell_down_week text,
    cc_cluster_group text,
    cc_service_level real
);


ALTER TABLE public.cart_params_cm OWNER TO psql;

--
-- TOC entry 1920 (class 1259 OID 129296436)
-- Name: cart_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_queue (
    cart_id text NOT NULL,
    user_id text NOT NULL,
    scope_id uuid NOT NULL,
    state queue_state NOT NULL,
    error_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    instance_id text
);


ALTER TABLE public.cart_queue OWNER TO psql;

--
-- TOC entry 1921 (class 1259 OID 129296443)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 1922 (class 1259 OID 129296448)
-- Name: cart_ranging_04112025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_04112025 (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.cart_ranging_04112025 OWNER TO psql;

--
-- TOC entry 1923 (class 1259 OID 129296453)
-- Name: cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.cart_ranging_archive OWNER TO psql;

--
-- TOC entry 1924 (class 1259 OID 129296458)
-- Name: cart_ranging_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_temp (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging_temp OWNER TO psql;

--
-- TOC entry 1925 (class 1259 OID 129296463)
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
-- TOC entry 1926 (class 1259 OID 129296468)
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
-- TOC entry 1927 (class 1259 OID 129296471)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 1928 (class 1259 OID 129296476)
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
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text[],
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text
);


ALTER TABLE public.default_cart_params OWNER TO psql;

--
-- TOC entry 1929 (class 1259 OID 129296481)
-- Name: default_cart_params_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_cart_params_cm (
    jsessionid text,
    scope_product text,
    scope_location text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    slsrnk real,
    cc_cluster_group text,
    default_service_level real
);


ALTER TABLE public.default_cart_params_cm OWNER TO psql;

--
-- TOC entry 1930 (class 1259 OID 129296486)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    department text,
    class text,
    supplier_site_id text,
    default_discount numeric(16,4)
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 1931 (class 1259 OID 129296491)
-- Name: delete_me; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me (
    user_id text,
    session_id text,
    table_name text,
    approx_create_time timestamp with time zone
);


ALTER TABLE public.delete_me OWNER TO psql;

--
-- TOC entry 1932 (class 1259 OID 129296496)
-- Name: deleteme_blk_departmentattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_departmentattributes (
    department text,
    dpt_department_id text,
    dpt_gmm_id text,
    dpt_gmm_desc text,
    dpt_dmm_id text,
    dpt_dmm_desc text,
    dpt_buyer_id text,
    dpt_buyer_desc text,
    dpt_sr_planner_id text,
    dpt_sr_planner_desc text,
    dpt_planner_id text,
    dpt_planner_desc text,
    dpt_dir_id text,
    dpt_dir_desc text,
    dpt_vp_id text,
    dpt_vp_desc text,
    dpt_svp_id text,
    dpt_svp_desc text,
    dpt_evp_id text,
    dpt_evp_desc text,
    dpt_marketplace_indicator text,
    dpt_memo_dept_indicator text,
    dpt_royalty_pct text
);


ALTER TABLE public.deleteme_blk_departmentattributes OWNER TO psql;

--
-- TOC entry 1933 (class 1259 OID 129296501)
-- Name: deleteme_blk_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_l_dependencylookup (
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


ALTER TABLE public.deleteme_blk_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1934 (class 1259 OID 129296506)
-- Name: deleteme_blk_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_ma_dptflrsetattributes (
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
    too integer,
    markdown_week text,
    exit_week text,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    planned_sell_down_week text,
    default_initrcptwk text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_last_inv_wk text,
    default_lstfpwk text,
    default_last_rcpt_wk text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_ccmdstrategy text,
    default_presmin integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_ccordermultiple integer,
    default_ccordpolicy text,
    default_str_grade text[],
    default_str_segmentation text[],
    default_str_sub_segmentation text[],
    default_str_aa_ind text[],
    default_str_hisp_ind text[],
    default_str_lifestyle_01 text[],
    default_str_lifestyle_02 text[],
    default_str_lifestyle_03 text[],
    default_str_lifestyle_04 text[],
    default_str_climate text[],
    default_str_state text[],
    default_ssg text[],
    default_flnrange text[],
    default_discountpct real,
    default_imupct real,
    default_service_level real,
    default_lead_time integer,
    floorset_uda text,
    ly_floorset_uda text,
    lly_floorset_uda text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    default_str_grade_or text[],
    default_str_segmentation_or text[],
    default_str_sub_segmentation_or text[],
    default_str_aa_ind_or text[],
    default_str_hisp_ind_or text[],
    default_str_lifestyle_01_or text[],
    default_str_lifestyle_02_or text[],
    default_str_lifestyle_03_or text[],
    default_str_lifestyle_04_or text[],
    default_str_climate_or text[],
    default_str_state_or text[]
);


ALTER TABLE public.deleteme_blk_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1935 (class 1259 OID 129296511)
-- Name: deleteme_blk_ma_stylecolorchannelattributes_sup_3905; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_ma_stylecolorchannelattributes_sup_3905 (
    product text,
    record_state smallint,
    exitdate text,
    plan_current text
);


ALTER TABLE public.deleteme_blk_ma_stylecolorchannelattributes_sup_3905 OWNER TO psql;

--
-- TOC entry 1936 (class 1259 OID 129296516)
-- Name: deleteme_blk_ma_stylecolorweekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_ma_stylecolorweekattributes (
    product text,
    "time" text,
    location text,
    cc_vpn text,
    cc_vpn_color text,
    hq_id text,
    vpn_desc text,
    cc_vpn_color_desc text,
    division text,
    department text,
    buy_period_id text,
    buy_period_descr text,
    plm_color_status text,
    plm_style_status text,
    size_codes text,
    size_description text,
    buy_period_season text,
    plm_cost text,
    bi_vendor text,
    style_min text,
    style_max text,
    size_range text,
    pack_size_units text,
    color_way_desc text,
    cad_name text,
    image_url text,
    hq_lookup_key text,
    eventdate date,
    version_id integer,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state integer
);


ALTER TABLE public.deleteme_blk_ma_stylecolorweekattributes OWNER TO psql;

--
-- TOC entry 1937 (class 1259 OID 129296521)
-- Name: deleteme_blk_p_pinchpo; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_blk_p_pinchpo (
    po_id text,
    product text,
    location text,
    "time" text,
    pinch_id text,
    pinched_stores text[],
    pinch_delivery_month text,
    pinch_floor_location text,
    pinch_otb_month text,
    pinch_nbd text,
    pinch_nad text,
    pinch_validsizes_store text[],
    pinch_validsizes_ecom text[],
    pinch_allocation_comments text,
    pinch_assortment_comments text,
    pinch_user_po_plan_name_store text,
    pinch_user_po_plan_name_ecom text,
    pinch_publish_po_plan_name_store text,
    pinch_publish_po_plan_name_ecom text,
    pinch_fold_code text,
    pinch_promo_code text,
    pinch_group_style text,
    pinch_subgroup_style text,
    pinch_master_style text,
    pinch_po_qty integer,
    is_published real,
    published_by text,
    published_at timestamp without time zone,
    spo_status_store text,
    spo_status_msg_store text,
    import_id_store text,
    po_status_store text,
    po_status_msg_store text,
    po_number_store text,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    spo_status_ecom text,
    spo_status_msg_ecom text,
    import_id_ecom text,
    po_status_ecom text,
    po_status_msg_ecom text,
    po_number_ecom text
);


ALTER TABLE public.deleteme_blk_p_pinchpo OWNER TO psql;

--
-- TOC entry 1938 (class 1259 OID 129296526)
-- Name: deleteme_cccolor_id_desc_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_cccolor_id_desc_mapping (
    cccolorid text,
    cccolordesc text
);


ALTER TABLE public.deleteme_cccolor_id_desc_mapping OWNER TO psql;

--
-- TOC entry 1939 (class 1259 OID 129296531)
-- Name: deleteme_missing_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_validsizes (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.deleteme_missing_validsizes OWNER TO psql;

--
-- TOC entry 1940 (class 1259 OID 129296536)
-- Name: deleteme_missing_validsizes_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_validsizes_2 (
    product text,
    location text,
    dbt_wk text,
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
    mdstart_indx integer,
    lastdcorder_indx integer,
    exitdate_indx integer,
    slsrnk real,
    ccticketpricechannel real,
    ccticketpricechannel_override real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_ordpolicy text,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct real,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    ssnprf text,
    adjaps real,
    relaunchweek text,
    cc_plan_cost real,
    cc_landed_cost real,
    cc_target_cost real,
    cc_flrset text,
    cc_season text,
    inseason_adjaps real,
    smoothing_strategy text,
    in_season_flag text,
    lifecycle_applied text,
    cc_return_u_pct real,
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
    cc_cluster_group_or text[],
    cc_selected_clusters_or text,
    relaunch_dbt_wk text,
    relaunch_dbt_wk_indx integer,
    relaunch_erlstmkdnwk text,
    relaunch_erlstmkdnwk_indx integer,
    relaunch_exitdate text,
    relaunch_exitdate_indx integer,
    relaunch_initrcptwk text,
    relaunch_initrcptwk_indx integer,
    relaunch_too smallint,
    relaunch_mkdnwks smallint,
    relaunch_last_rcpt_wk text,
    relaunch_last_rcpt_wk_indx integer,
    relaunch_planned_sell_down_week text,
    relaunch_planned_sell_down_week_indx integer,
    relaunch_cc_cluster_group text,
    relaunch_is_valid boolean,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.deleteme_missing_validsizes_2 OWNER TO psql;

--
-- TOC entry 1941 (class 1259 OID 129296541)
-- Name: deleteme_placeholder_removes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_placeholder_removes (
    product text
);


ALTER TABLE public.deleteme_placeholder_removes OWNER TO psql;

--
-- TOC entry 1942 (class 1259 OID 129296546)
-- Name: deleteme_plan_queue_fails; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_plan_queue_fails (
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


ALTER TABLE public.deleteme_plan_queue_fails OWNER TO psql;

--
-- TOC entry 1943 (class 1259 OID 129296551)
-- Name: deleteme_replan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_replan (
    product text,
    comments text
);


ALTER TABLE public.deleteme_replan OWNER TO psql;

--
-- TOC entry 1944 (class 1259 OID 129296558)
-- Name: deleteme_temp_upload_ata_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_temp_upload_ata_d_product (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.deleteme_temp_upload_ata_d_product OWNER TO psql;

--
-- TOC entry 1945 (class 1259 OID 129296564)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 1946 (class 1259 OID 129296569)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 1947 (class 1259 OID 129296574)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 1948 (class 1259 OID 129296579)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 1949 (class 1259 OID 129296584)
-- Name: dept_plan_items_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_temp OWNER TO psql;

--
-- TOC entry 1950 (class 1259 OID 129296589)
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
-- TOC entry 1951 (class 1259 OID 129296596)
-- Name: dup_sizes_20260604; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dup_sizes_20260604 (
    parent_id text,
    sizeattribute text,
    sku_count bigint,
    sku_length_count bigint
);


ALTER TABLE public.dup_sizes_20260604 OWNER TO psql;

--
-- TOC entry 1952 (class 1259 OID 129296601)
-- Name: dup_sizes_originate_in_s5_sup4006; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dup_sizes_originate_in_s5_sup4006 (
    parent_id text,
    sizeattribute text,
    id_length bigint
);


ALTER TABLE public.dup_sizes_originate_in_s5_sup4006 OWNER TO psql;

--
-- TOC entry 1953 (class 1259 OID 129296606)
-- Name: dup_sizes_sku_level_20260604_sup4006; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dup_sizes_sku_level_20260604_sup4006 (
    product text,
    parent_id text,
    size_member_id text,
    sizeattribute text,
    source_member_id text,
    source_member_name text,
    sku_dropship_indicator text,
    sku_replenishment_flag text,
    sku_extended_size text,
    sku_status text,
    isvalid integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.dup_sizes_sku_level_20260604_sup4006 OWNER TO psql;

--
-- TOC entry 1954 (class 1259 OID 129296611)
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
-- TOC entry 1955 (class 1259 OID 129296616)
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
-- TOC entry 1956 (class 1259 OID 129296621)
-- Name: input_t1_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.input_t1_1 (
    jsid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text
);


ALTER TABLE public.input_t1_1 OWNER TO psql;

--
-- TOC entry 1957 (class 1259 OID 129296626)
-- Name: input_t1_52579ed7_3c73_45e0_8049_8c1b93c6a919; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.input_t1_52579ed7_3c73_45e0_8049_8c1b93c6a919 (
    jsid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text
);


ALTER TABLE public.input_t1_52579ed7_3c73_45e0_8049_8c1b93c6a919 OWNER TO psql;

--
-- TOC entry 1958 (class 1259 OID 129296631)
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
-- TOC entry 1959 (class 1259 OID 129296636)
-- Name: new_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.new_table (
    id integer NOT NULL,
    column1 character varying(50),
    column2 integer,
    column3 date
);


ALTER TABLE public.new_table OWNER TO psql;

--
-- TOC entry 1960 (class 1259 OID 129296639)
-- Name: new_table_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.new_table_2 (
    id integer NOT NULL,
    column1 character varying(50),
    column2 integer,
    column3 date
);


ALTER TABLE public.new_table_2 OWNER TO psql;

--
-- TOC entry 1961 (class 1259 OID 129296642)
-- Name: new_table_2_id_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.new_table_2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.new_table_2_id_seq OWNER TO psql;

--
-- TOC entry 8072 (class 0 OID 0)
-- Dependencies: 1961
-- Name: new_table_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: psql
--

ALTER SEQUENCE public.new_table_2_id_seq OWNED BY public.new_table_2.id;


--
-- TOC entry 1962 (class 1259 OID 129296643)
-- Name: new_table_id_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.new_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.new_table_id_seq OWNER TO psql;

--
-- TOC entry 8073 (class 0 OID 0)
-- Dependencies: 1962
-- Name: new_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: psql
--

ALTER SEQUENCE public.new_table_id_seq OWNED BY public.new_table.id;


--
-- TOC entry 1963 (class 1259 OID 129296644)
-- Name: nicole_slack_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.nicole_slack_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
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
    a_msrp real,
    a_current_retail real,
    a_current_retail_override real,
    str_grade_or text[],
    str_segmentation_or text[],
    str_sub_segmentation_or text[],
    str_aa_ind_or text[],
    str_hisp_ind_or text[],
    str_lifestyle_01_or text[],
    str_lifestyle_02_or text[],
    str_lifestyle_03_or text[],
    str_lifestyle_04_or text[],
    str_climate_or text[],
    str_state_or text[]
);


ALTER TABLE public.nicole_slack_a_assortment OWNER TO psql;

--
-- TOC entry 1964 (class 1259 OID 129296649)
-- Name: perf_assortperiod_week; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT blk_ma_dptflrsetattributes.product,
            blk_ma_dptflrsetattributes."time",
            blk_ma_dptflrsetattributes.ap_start,
            blk_ma_dptflrsetattributes.ap_end
           FROM blk_ma_dptflrsetattributes) a,
    blk_d_time b
  WHERE ((b.levelid = ('week'::character varying(4))::text) AND (b.id >= a.ap_start) AND (b.id <= a.ap_end));


ALTER VIEW public.perf_assortperiod_week OWNER TO psql;

--
-- TOC entry 1965 (class 1259 OID 129296654)
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
-- TOC entry 1966 (class 1259 OID 129296659)
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
-- TOC entry 1967 (class 1259 OID 129296665)
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
-- TOC entry 1968 (class 1259 OID 129296671)
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
    priority integer DEFAULT 1 NOT NULL,
    instance_id text
);


ALTER TABLE public.plan_queue OWNER TO psql;

--
-- TOC entry 1969 (class 1259 OID 129296680)
-- Name: plan_queue_04112025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_04112025 (
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


ALTER TABLE public.plan_queue_04112025 OWNER TO psql;

--
-- TOC entry 2061 (class 1259 OID 138854871)
-- Name: plan_queue_bkp2809; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_bkp2809 (
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


ALTER TABLE public.plan_queue_bkp2809 OWNER TO psql;

--
-- TOC entry 1970 (class 1259 OID 129296685)
-- Name: plan_queue_bkp_05032026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_bkp_05032026 (
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


ALTER TABLE public.plan_queue_bkp_05032026 OWNER TO psql;

--
-- TOC entry 1971 (class 1259 OID 129296690)
-- Name: plan_queue_delete_me_jun24_24; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_delete_me_jun24_24 (
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


ALTER TABLE public.plan_queue_delete_me_jun24_24 OWNER TO psql;

--
-- TOC entry 1972 (class 1259 OID 129296695)
-- Name: plan_queue_fail_20241117; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_fail_20241117 (
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


ALTER TABLE public.plan_queue_fail_20241117 OWNER TO psql;

--
-- TOC entry 1973 (class 1259 OID 129296700)
-- Name: plan_queue_fail_20250409; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_fail_20250409 (
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


ALTER TABLE public.plan_queue_fail_20250409 OWNER TO psql;

--
-- TOC entry 1974 (class 1259 OID 129296705)
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
-- TOC entry 1975 (class 1259 OID 129296710)
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
    priority integer
);


ALTER TABLE public.plan_queue_last_run OWNER TO psql;

--
-- TOC entry 1976 (class 1259 OID 129296715)
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
-- TOC entry 1977 (class 1259 OID 129296719)
-- Name: prev_blk_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.prev_blk_p_strategy_params (
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
    record_state smallint
);


ALTER TABLE public.prev_blk_p_strategy_params OWNER TO psql;

--
-- TOC entry 1978 (class 1259 OID 129296724)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 1979 (class 1259 OID 129296729)
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
-- TOC entry 1980 (class 1259 OID 129296734)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 1981 (class 1259 OID 129296739)
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
-- TOC entry 1982 (class 1259 OID 129296748)
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
-- TOC entry 1983 (class 1259 OID 129296749)
-- Name: seq_banner; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_banner
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_banner OWNER TO psql;

--
-- TOC entry 1984 (class 1259 OID 129296750)
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
-- TOC entry 1985 (class 1259 OID 129296751)
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
-- TOC entry 1986 (class 1259 OID 129296752)
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
-- TOC entry 1987 (class 1259 OID 129296753)
-- Name: seq_state; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.seq_state
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_state OWNER TO psql;

--
-- TOC entry 1988 (class 1259 OID 129296754)
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
-- TOC entry 1989 (class 1259 OID 129296755)
-- Name: shadow_addtoassortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.shadow_addtoassortment (
    style_id text NOT NULL,
    style_description text,
    department text,
    dept_name text,
    class text,
    class_name text,
    supplier_site_id text,
    supplier_site_name text,
    style_type text,
    vpn_id_non_plm text,
    color_id text NOT NULL,
    merch_color_name text,
    original_price text,
    target_cost text,
    debut_week text,
    markdown_week text,
    exit_week text,
    sales_rating text,
    pres_min text,
    pres_min_weeks text,
    receipt_interval text,
    store_min_multiple text,
    service_level text,
    dropship_indicator text,
    replenishment_indicator text,
    program_name text,
    segment_buy text,
    silhouette text,
    subcategory text,
    selling_season text,
    selling_year text,
    aa_indicator text,
    bottom_fit text,
    categories text,
    classification text,
    collegiate text,
    cut_fit text,
    denim_trends text,
    fabric_desc text,
    fashion_vs_basic text,
    graphic_type text,
    levi_fits text,
    print_type text,
    print_vs_solid text,
    short_inseam text,
    sleeve_length text,
    superbuy_ind text,
    young_contemporary text,
    bottom_silo text,
    d_cup_avail text,
    denim_rise text,
    dress_length text,
    fit_solution text,
    inseam text,
    lounge_vs_sleep text,
    neckline text,
    occasion text,
    robe text,
    top_length text,
    cc_set text,
    construction text,
    fashion_jewelry text,
    jewelry_presentation text,
    material_color text,
    material_type text,
    necklaces text,
    texture_pattern text,
    fragrance_scents text,
    level_of_presentation text,
    makeup_total_eye text,
    makeup_total_face text,
    makeup_total_lip text,
    skincare_total_face text,
    total_fragrance text,
    total_makeup text,
    total_skincare text,
    bracelets text,
    bridal text,
    chain_type text,
    ctw_fine_jewelry text,
    dial_color text,
    dtw_fine_dewelry text,
    ears text,
    fine_jewelry_metal text,
    gold_mkt_fine_jewelry text,
    grams_fine_jewelry text,
    high_value_status text,
    metal_type text,
    ring text,
    silver_grams text,
    silver_mkt_fine_jewelry text,
    stone text,
    watch text,
    bedding_acc text,
    bridal_registry text,
    coastal_ind text,
    cc_configuration text,
    custom_need text,
    material text,
    white_dinnerware_ind text,
    closure text,
    heel_height text,
    heel_type text,
    outsole text,
    shaft_height text,
    shoe_type text,
    sketchers_div text,
    sole_type text,
    tech_features text,
    toe_character text,
    toe_type text,
    width text,
    __status text,
    __txid text NOT NULL,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.shadow_addtoassortment OWNER TO psql;

--
-- TOC entry 1990 (class 1259 OID 129296761)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 1991 (class 1259 OID 129296766)
-- Name: staging_addtoassortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_addtoassortment (
    style_id text,
    style_description text,
    department text,
    dept_name text,
    class text,
    class_name text,
    supplier_site_id text,
    supplier_site_name text,
    style_type text,
    vpn_id_non_plm text,
    color_id text,
    merch_color_name text,
    original_price text,
    target_cost text,
    debut_week text,
    markdown_week text,
    exit_week text,
    sales_rating text,
    pres_min text,
    pres_min_weeks text,
    receipt_interval text,
    store_min_multiple text,
    service_level text,
    dropship_indicator text,
    replenishment_indicator text,
    program_name text,
    segment_buy text,
    silhouette text,
    subcategory text,
    selling_season text,
    selling_year text,
    aa_indicator text,
    bottom_fit text,
    categories text,
    classification text,
    collegiate text,
    cut_fit text,
    denim_trends text,
    fabric_desc text,
    fashion_vs_basic text,
    graphic_type text,
    levi_fits text,
    print_type text,
    print_vs_solid text,
    short_inseam text,
    sleeve_length text,
    superbuy_ind text,
    young_contemporary text,
    bottom_silo text,
    d_cup_avail text,
    denim_rise text,
    dress_length text,
    fit_solution text,
    inseam text,
    lounge_vs_sleep text,
    neckline text,
    occasion text,
    robe text,
    top_length text,
    cc_set text,
    construction text,
    fashion_jewelry text,
    jewelry_presentation text,
    material_color text,
    material_type text,
    necklaces text,
    texture_pattern text,
    fragrance_scents text,
    level_of_presentation text,
    makeup_total_eye text,
    makeup_total_face text,
    makeup_total_lip text,
    skincare_total_face text,
    total_fragrance text,
    total_makeup text,
    total_skincare text,
    bracelets text,
    bridal text,
    chain_type text,
    ctw_fine_jewelry text,
    dial_color text,
    dtw_fine_dewelry text,
    ears text,
    fine_jewelry_metal text,
    gold_mkt_fine_jewelry text,
    grams_fine_jewelry text,
    high_value_status text,
    metal_type text,
    ring text,
    silver_grams text,
    silver_mkt_fine_jewelry text,
    stone text,
    watch text,
    bedding_acc text,
    bridal_registry text,
    coastal_ind text,
    cc_configuration text,
    custom_need text,
    material text,
    white_dinnerware_ind text,
    closure text,
    heel_height text,
    heel_type text,
    outsole text,
    shaft_height text,
    shoe_type text,
    sketchers_div text,
    sole_type text,
    tech_features text,
    toe_character text,
    toe_type text,
    width text,
    __status text,
    __txid text,
    __uid text,
    __timestamp timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    __error_msg text[],
    row_indx integer
);


ALTER TABLE public.staging_addtoassortment OWNER TO psql;

--
-- TOC entry 1992 (class 1259 OID 129296772)
-- Name: staging_addtoassortment_prod_val; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_addtoassortment_prod_val (
    upload_tx_id text NOT NULL,
    style_id text NOT NULL,
    color_id text NOT NULL
);


ALTER TABLE public.staging_addtoassortment_prod_val OWNER TO psql;

--
-- TOC entry 1993 (class 1259 OID 129296777)
-- Name: staging_addtoassortment_prod_val_reject; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.staging_addtoassortment_prod_val_reject (
    upload_tx_id text NOT NULL,
    style_id text NOT NULL,
    color_id text NOT NULL
);


ALTER TABLE public.staging_addtoassortment_prod_val_reject OWNER TO psql;

--
-- TOC entry 1994 (class 1259 OID 129296782)
-- Name: static_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.static_v_memberbasedvalidvalues (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text
);


ALTER TABLE public.static_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1995 (class 1259 OID 129296787)
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
-- TOC entry 1996 (class 1259 OID 129296788)
-- Name: sync_pg_ch; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_pg_ch (
    pg_table_name text,
    product text,
    location text,
    "time" text,
    pinch_id text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    synched_at timestamp without time zone
);


ALTER TABLE public.sync_pg_ch OWNER TO psql;

--
-- TOC entry 1997 (class 1259 OID 129296794)
-- Name: sync_pg_ch_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_pg_ch_archive (
    pg_table_name text,
    product text,
    location text,
    "time" text,
    pinch_id text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    synched_at timestamp without time zone
);


ALTER TABLE public.sync_pg_ch_archive OWNER TO psql;

--
-- TOC entry 1998 (class 1259 OID 129296800)
-- Name: sync_pg_ch_intermediate; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_pg_ch_intermediate (
    pg_table_name text,
    product text,
    location text,
    "time" text,
    pinch_id text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    synched_at timestamp without time zone
);


ALTER TABLE public.sync_pg_ch_intermediate OWNER TO psql;

--
-- TOC entry 1999 (class 1259 OID 129296806)
-- Name: table_cart_master_temp_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.table_cart_master_temp_cm (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cccolorid text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text
);


ALTER TABLE public.table_cart_master_temp_cm OWNER TO psql;

--
-- TOC entry 2000 (class 1259 OID 129296811)
-- Name: table_cart_master_temp_sup2611; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.table_cart_master_temp_sup2611 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cccolorid text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text
);


ALTER TABLE public.table_cart_master_temp_sup2611 OWNER TO psql;

--
-- TOC entry 2001 (class 1259 OID 129296816)
-- Name: table_input_1_sup2611; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.table_input_1_sup2611 (
    jsid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text
);


ALTER TABLE public.table_input_1_sup2611 OWNER TO psql;

--
-- TOC entry 2002 (class 1259 OID 129296821)
-- Name: table_input_t1_cm; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.table_input_t1_cm (
    jsid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text
);


ALTER TABLE public.table_input_t1_cm OWNER TO psql;

--
-- TOC entry 2003 (class 1259 OID 129296826)
-- Name: table_temp_assort_sup2611; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.table_temp_assort_sup2611 (
    product text,
    location text,
    "time" text,
    str_grade text[],
    str_segmentation text[],
    str_sub_segmentation text[],
    str_aa_ind text[],
    str_hisp_ind text[],
    str_lifestyle_01 text[],
    str_lifestyle_02 text[],
    str_lifestyle_03 text[],
    str_lifestyle_04 text[],
    str_climate text[],
    str_state text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    style text,
    store_count integer,
    a_msrp real,
    a_current_retail real
);


ALTER TABLE public.table_temp_assort_sup2611 OWNER TO psql;

--
-- TOC entry 2004 (class 1259 OID 129296831)
-- Name: temp1_blk_c_week1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_blk_c_week1 (
    week text,
    week_minus_1 text
);


ALTER TABLE public.temp1_blk_c_week1 OWNER TO psql;

--
-- TOC entry 2005 (class 1259 OID 129296836)
-- Name: temp1_blk_c_week4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_blk_c_week4 (
    week text,
    week_minus_4 text
);


ALTER TABLE public.temp1_blk_c_week4 OWNER TO psql;

--
-- TOC entry 2006 (class 1259 OID 129296841)
-- Name: temp1_blk_c_week5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_blk_c_week5 (
    week text,
    week_plus_4 text
);


ALTER TABLE public.temp1_blk_c_week5 OWNER TO psql;

--
-- TOC entry 2007 (class 1259 OID 129296846)
-- Name: temp_blk_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_blk_corpdisc (
    department text,
    product text,
    location text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.temp_blk_corpdisc OWNER TO psql;

--
-- TOC entry 2008 (class 1259 OID 129296851)
-- Name: temp_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_corpdisc (
    department text,
    product text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.temp_corpdisc OWNER TO psql;

--
-- TOC entry 2009 (class 1259 OID 129296856)
-- Name: tmp1_blk_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp1_blk_l_dependencylookup (
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


ALTER TABLE public.tmp1_blk_l_dependencylookup OWNER TO psql;

--
-- TOC entry 2010 (class 1259 OID 129296861)
-- Name: tmp_blk_l_dependencylookup_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_blk_l_dependencylookup_jr (
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


ALTER TABLE public.tmp_blk_l_dependencylookup_jr OWNER TO psql;

--
-- TOC entry 2011 (class 1259 OID 129296866)
-- Name: tmp_blk_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_blk_v_memberbasedvalidvalues (
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


ALTER TABLE public.tmp_blk_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 2012 (class 1259 OID 129296871)
-- Name: tmpjr_blk_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmpjr_blk_l_dependencylookup (
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


ALTER TABLE public.tmpjr_blk_l_dependencylookup OWNER TO psql;

--
-- TOC entry 2013 (class 1259 OID 129296876)
-- Name: trigger_test_delete_me; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.trigger_test_delete_me (
    stat text,
    ts timestamp without time zone
);


ALTER TABLE public.trigger_test_delete_me OWNER TO psql;

--
-- TOC entry 2014 (class 1259 OID 129296881)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 2015 (class 1259 OID 129296886)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 2016 (class 1259 OID 129296891)
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
-- TOC entry 2017 (class 1259 OID 129296899)
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
-- TOC entry 2018 (class 1259 OID 129296904)
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
-- TOC entry 2019 (class 1259 OID 129296910)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 2020 (class 1259 OID 129296915)
-- Name: user_metadata_get_api; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata_get_api (
    uid text,
    email text
);


ALTER TABLE public.user_metadata_get_api OWNER TO psql;

--
-- TOC entry 2021 (class 1259 OID 129296920)
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
-- TOC entry 2022 (class 1259 OID 129296932)
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
-- TOC entry 2023 (class 1259 OID 129296940)
-- Name: v_ispublishable; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_ispublishable (
    ispublishable text
);


ALTER TABLE public.v_ispublishable OWNER TO psql;

--
-- TOC entry 2024 (class 1259 OID 129296945)
-- Name: v_supp_id; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_supp_id (
    supplier_site text
);


ALTER TABLE public.v_supp_id OWNER TO psql;

--
-- TOC entry 2025 (class 1259 OID 129296950)
-- Name: xt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.xt (
    clock_timestamp timestamp with time zone
);


ALTER TABLE public.xt OWNER TO psql;

--
-- TOC entry 2026 (class 1259 OID 129296953)
-- Name: xt_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.xt_2 (
    "time" text
);


ALTER TABLE public.xt_2 OWNER TO psql;

--
-- TOC entry 2027 (class 1259 OID 129296958)
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
-- TOC entry 2028 (class 1259 OID 129296963)
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
    calc_base_metric_for_store_count double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.actuals_wide OWNER TO psql;

--
-- TOC entry 2029 (class 1259 OID 129296968)
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
-- TOC entry 2030 (class 1259 OID 129296973)
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
-- TOC entry 2031 (class 1259 OID 129296978)
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
-- TOC entry 2032 (class 1259 OID 129296982)
-- Name: product_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.product_denorm AS
 SELECT productroot.id AS productroot,
    division.id AS division,
    department.id AS department,
    class.id AS class,
    subclass.id AS subclass
   FROM ((((( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'subclass'::text))) subclass
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = subclass.id) AND (hierarchies.hierarchy = 'prodstd'::text))) class ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) productroot ON (true));


ALTER VIEW target_setting.product_denorm OWNER TO psql;

--
-- TOC entry 2033 (class 1259 OID 129296987)
-- Name: time_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.time_denorm AS
 SELECT timeroot.id AS timeroot,
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
          WHERE ((hierarchies.id = fiscal_year.id) AND (hierarchies.hierarchy = 'timestd'::text))) timeroot ON (true));


ALTER VIEW target_setting.time_denorm OWNER TO psql;

--
-- TOC entry 2034 (class 1259 OID 129296992)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: target_setting; Owner: psql
--

CREATE MATERIALIZED VIEW target_setting.actuals_wide_denorm AS
 SELECT DISTINCT ON (wide."time", wide.product, wide.location) "time".floorset_uda AS time_floorset_uda,
    "time".quarter AS time_quarter,
    product.subclass AS product_subclass,
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
    wide.calc_base_metric_for_store_count,
    wide.dilute_ratio
   FROM (((target_setting.actuals_wide wide
     JOIN ( SELECT time_denorm.floorset_uda,
            time_denorm.quarter
           FROM target_setting.time_denorm) "time" ON (("time".floorset_uda = wide."time")))
     JOIN ( SELECT product_denorm.subclass,
            product_denorm.department
           FROM target_setting.product_denorm) product ON ((product.subclass = wide.product)))
     JOIN ( SELECT location_denorm.grade,
            location_denorm.channel
           FROM target_setting.location_denorm) location ON ((location.grade = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW target_setting.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 2035 (class 1259 OID 129296999)
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
-- TOC entry 2036 (class 1259 OID 129297005)
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
-- TOC entry 2037 (class 1259 OID 129297011)
-- Name: dimensions_bkp; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.dimensions_bkp (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE target_setting.dimensions_bkp OWNER TO psql;

--
-- TOC entry 2038 (class 1259 OID 129297016)
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
-- TOC entry 2039 (class 1259 OID 129297021)
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
-- TOC entry 2040 (class 1259 OID 129297026)
-- Name: pev_tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.pev_tyly (
    ty text,
    ly text
);


ALTER TABLE target_setting.pev_tyly OWNER TO psql;

--
-- TOC entry 2041 (class 1259 OID 129297031)
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
-- TOC entry 2042 (class 1259 OID 129297040)
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
-- TOC entry 2043 (class 1259 OID 129297046)
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
    calc_base_metric_for_store_count double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.plan_data_wide OWNER TO psql;

--
-- TOC entry 2044 (class 1259 OID 129297051)
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
    calc_base_metric_for_store_count double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 2045 (class 1259 OID 129297056)
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
-- TOC entry 2046 (class 1259 OID 129297057)
-- Name: plan_init_status; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE target_setting.plan_init_status OWNER TO psql;

--
-- TOC entry 2047 (class 1259 OID 129297060)
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
-- TOC entry 2048 (class 1259 OID 129297069)
-- Name: prev_dimensions; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.prev_dimensions (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE target_setting.prev_dimensions OWNER TO psql;

--
-- TOC entry 2049 (class 1259 OID 129297074)
-- Name: prev_hierarchies; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.prev_hierarchies (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE target_setting.prev_hierarchies OWNER TO psql;

--
-- TOC entry 2050 (class 1259 OID 129297079)
-- Name: prev_tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.prev_tyly (
    ty text,
    ly text
);


ALTER TABLE target_setting.prev_tyly OWNER TO psql;

--
-- TOC entry 2051 (class 1259 OID 129297084)
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
    calc_base_metric_for_store_count double precision,
    dilute_ratio double precision
);


ALTER TABLE target_setting.sys_gen_wide OWNER TO psql;

--
-- TOC entry 2052 (class 1259 OID 129297089)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: target_setting; Owner: psql
--

CREATE MATERIALIZED VIEW target_setting.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".floorset_uda AS time_floorset_uda,
    "time".quarter AS time_quarter,
    product.subclass AS product_subclass,
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
    wide.calc_base_metric_for_store_count,
    wide.dilute_ratio
   FROM (((target_setting.sys_gen_wide wide
     JOIN ( SELECT time_denorm.floorset_uda,
            time_denorm.quarter
           FROM target_setting.time_denorm) "time" ON (("time".floorset_uda = wide."time")))
     JOIN ( SELECT product_denorm.subclass,
            product_denorm.department
           FROM target_setting.product_denorm) product ON ((product.subclass = wide.product)))
     JOIN ( SELECT location_denorm.grade,
            location_denorm.channel
           FROM target_setting.location_denorm) location ON ((location.grade = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW target_setting.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 2053 (class 1259 OID 129297096)
-- Name: tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE target_setting.tyly OWNER TO psql;

--
-- TOC entry 2054 (class 1259 OID 129297101)
-- Name: user_kv_store; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE target_setting.user_kv_store OWNER TO psql;

--
-- TOC entry 2055 (class 1259 OID 129297106)
-- Name: view_target_plan_wide; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.view_target_plan_wide AS
 WITH latest_plans AS (
         SELECT t.id,
            t.product,
            t.version,
            t."time"
           FROM ( SELECT plans.id,
                    plans.product,
                    plans."time",
                    plans.version,
                    plans.created_at,
                    row_number() OVER (PARTITION BY plans.product, plans."time" ORDER BY plans.version DESC) AS rn
                   FROM target_setting.plans
                  WHERE (plans.version = ANY (ARRAY['op'::text, 'rp'::text]))) t
          WHERE (t.rn = 1)
        )
 SELECT d.product,
    d.product AS tgt_product,
    d."time" AS tgt_time,
    d.location AS final_cluster,
    d.strcntwk,
    d.gross_sales_u,
    d.gross_sales_tktp,
    d.gross_sales_r,
    d.funded_cc_count,
    d.rec_u,
    d.rec_r,
    d.rec_c,
    d.receipt_start_boh_u,
    d.sales_start_boh_u,
    d.ref_receipt_start_sls_u,
    d.weekcount,
    lp.product AS department,
    lp."time" AS superset
   FROM (target_setting.plan_data_wide d
     JOIN latest_plans lp ON ((d.id = lp.id)))
  WHERE ((d.product IN ( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE (dimensions.dimension = 'product'::text))) AND (d.location IN ( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE (dimensions.dimension = 'location'::text))) AND (d."time" IN ( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE (dimensions.dimension = 'time'::text))));


ALTER VIEW target_setting.view_target_plan_wide OWNER TO psql;

--
-- TOC entry 7559 (class 2604 OID 129297111)
-- Name: new_table id; Type: DEFAULT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.new_table ALTER COLUMN id SET DEFAULT nextval('new_table_id_seq'::regclass);


--
-- TOC entry 7560 (class 2604 OID 129297112)
-- Name: new_table_2 id; Type: DEFAULT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.new_table_2 ALTER COLUMN id SET DEFAULT nextval('new_table_2_id_seq'::regclass);


--
-- TOC entry 7620 (class 2606 OID 133976226)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 7618 (class 2606 OID 133976228)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 7622 (class 2606 OID 133976230)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7624 (class 2606 OID 133976232)
-- Name: assort_period_from_dpt assort_period_from_dpt_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.assort_period_from_dpt
    ADD CONSTRAINT assort_period_from_dpt_pkey PRIMARY KEY (department, "time");


--
-- TOC entry 7628 (class 2606 OID 133976234)
-- Name: blk_a_assortment blk_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_a_assortment
    ADD CONSTRAINT blk_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 7630 (class 2606 OID 133976278)
-- Name: blk_an_price_storecount_info blk_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_an_price_storecount_info
    ADD CONSTRAINT blk_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 7632 (class 2606 OID 133976283)
-- Name: blk_authorization blk_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_authorization
    ADD CONSTRAINT blk_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 7650 (class 2606 OID 133976285)
-- Name: blk_d_cluster blk_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_d_cluster
    ADD CONSTRAINT blk_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 7652 (class 2606 OID 133976287)
-- Name: blk_d_location blk_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_d_location
    ADD CONSTRAINT blk_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 7654 (class 2606 OID 133976289)
-- Name: blk_d_prodlife blk_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_d_prodlife
    ADD CONSTRAINT blk_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 7656 (class 2606 OID 133976291)
-- Name: blk_d_product blk_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_d_product
    ADD CONSTRAINT blk_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 7660 (class 2606 OID 133976428)
-- Name: blk_d_time blk_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_d_time
    ADD CONSTRAINT blk_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 7663 (class 2606 OID 133976430)
-- Name: blk_h_clusterstd blk_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_clusterstd
    ADD CONSTRAINT blk_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7665 (class 2606 OID 133976432)
-- Name: blk_h_locdc blk_h_locdc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_locdc
    ADD CONSTRAINT blk_h_locdc_pkey PRIMARY KEY (id);


--
-- TOC entry 7667 (class 2606 OID 133976434)
-- Name: blk_h_locdcstd blk_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_locdcstd
    ADD CONSTRAINT blk_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7669 (class 2606 OID 133976436)
-- Name: blk_h_locstd blk_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_locstd
    ADD CONSTRAINT blk_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7674 (class 2606 OID 133976438)
-- Name: blk_h_prodlifestd blk_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_prodlifestd
    ADD CONSTRAINT blk_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 7634 (class 2606 OID 133976440)
-- Name: blk_h_prodstd blk_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_prodstd
    ADD CONSTRAINT blk_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7676 (class 2606 OID 133976577)
-- Name: blk_h_timeflrset blk_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_timeflrset
    ADD CONSTRAINT blk_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 7678 (class 2606 OID 133976579)
-- Name: blk_h_timestd blk_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_h_timestd
    ADD CONSTRAINT blk_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 7648 (class 2606 OID 133976581)
-- Name: blk_corpdisc blk_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_corpdisc
    ADD CONSTRAINT blk_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time");


--
-- TOC entry 7680 (class 2606 OID 133976592)
-- Name: blk_l_dclookup blk_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_dclookup
    ADD CONSTRAINT blk_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 7683 (class 2606 OID 133976594)
-- Name: blk_l_priceeventlookup blk_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_priceeventlookup
    ADD CONSTRAINT blk_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 7751 (class 2606 OID 133976596)
-- Name: blk_sizinglookup blk_l_sizinglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_sizinglookup
    ADD CONSTRAINT blk_l_sizinglookup_pkey UNIQUE (sizerange, size, strselling_channel);


--
-- TOC entry 7685 (class 2606 OID 133976598)
-- Name: blk_l_ssglookup blk_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_ssglookup
    ADD CONSTRAINT blk_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 7687 (class 2606 OID 133976600)
-- Name: blk_l_storedclookup blk_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_storedclookup
    ADD CONSTRAINT blk_l_storedclookup_pkey PRIMARY KEY (store, dc, priority);


--
-- TOC entry 7689 (class 2606 OID 133976605)
-- Name: blk_l_storelookup blk_l_storelookup_new_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_storelookup
    ADD CONSTRAINT blk_l_storelookup_new_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 7691 (class 2606 OID 133977015)
-- Name: blk_l_storelookup_old blk_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_l_storelookup_old
    ADD CONSTRAINT blk_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 7693 (class 2606 OID 133977347)
-- Name: blk_ma_departmentquarter_attributes blk_ma_departmentquarter_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_departmentquarter_attributes
    ADD CONSTRAINT blk_ma_departmentquarter_attributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 7695 (class 2606 OID 133977349)
-- Name: blk_ma_dptflrsetattributes blk_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_dptflrsetattributes
    ADD CONSTRAINT blk_ma_dptflrsetattributes_pkey PRIMARY KEY (indx);


--
-- TOC entry 7697 (class 2606 OID 133977357)
-- Name: blk_ma_imgattributes blk_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_imgattributes
    ADD CONSTRAINT blk_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7700 (class 2606 OID 133977380)
-- Name: blk_ma_sizeattributes blk_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_sizeattributes
    ADD CONSTRAINT blk_ma_sizeattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7702 (class 2606 OID 133977486)
-- Name: blk_ma_storeattributes blk_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_storeattributes
    ADD CONSTRAINT blk_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 7704 (class 2606 OID 133977494)
-- Name: blk_ma_styleattributes blk_ma_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_styleattributes
    ADD CONSTRAINT blk_ma_styleattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7706 (class 2606 OID 133977523)
-- Name: blk_ma_stylecolorattributes blk_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_stylecolorattributes
    ADD CONSTRAINT blk_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7644 (class 2606 OID 133977576)
-- Name: blk_ma_stylecolorchannelattributes blk_ma_stylecolorchannelattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_stylecolorchannelattributes
    ADD CONSTRAINT blk_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7708 (class 2606 OID 133977605)
-- Name: blk_ma_stylecolorweekattributes blk_ma_stylecolorweekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_stylecolorweekattributes
    ADD CONSTRAINT blk_ma_stylecolorweekattributes_pkey PRIMARY KEY (hq_id, product, "time", location, cc_vpn, cc_vpn_color, department, buy_period_id);


--
-- TOC entry 7710 (class 2606 OID 133977610)
-- Name: blk_ma_weekattributes blk_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_ma_weekattributes
    ADD CONSTRAINT blk_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 7646 (class 2606 OID 133977612)
-- Name: blk_p_approvedclusters blk_p_approvedclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_approvedclusters
    ADD CONSTRAINT blk_p_approvedclusters_pkey PRIMARY KEY (product, "time", cluster_id);


--
-- TOC entry 7712 (class 2606 OID 133977614)
-- Name: blk_p_channeloverride blk_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_channeloverride
    ADD CONSTRAINT blk_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 7714 (class 2606 OID 133977616)
-- Name: blk_p_dc_adj blk_p_dc_adj_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_dc_adj
    ADD CONSTRAINT blk_p_dc_adj_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7716 (class 2606 OID 133977639)
-- Name: blk_p_dc_adj_size blk_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_dc_adj_size
    ADD CONSTRAINT blk_p_dc_adj_size_pk UNIQUE (product, location, "time");


--
-- TOC entry 7718 (class 2606 OID 133977641)
-- Name: blk_p_dept_store_attr_plan blk_p_dept_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_dept_store_attr_plan
    ADD CONSTRAINT blk_p_dept_store_attr_plan_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7720 (class 2606 OID 133977643)
-- Name: blk_p_itemprice blk_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_itemprice
    ADD CONSTRAINT blk_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7724 (class 2606 OID 133977645)
-- Name: blk_p_like_dept_class blk_p_like_dept_class_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_like_dept_class
    ADD CONSTRAINT blk_p_like_dept_class_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7726 (class 2606 OID 133977647)
-- Name: blk_p_like_dept_class_vendor blk_p_like_dept_class_vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_like_dept_class_vendor
    ADD CONSTRAINT blk_p_like_dept_class_vendor_pkey PRIMARY KEY (product, location, supp_brand);


--
-- TOC entry 7722 (class 2606 OID 133977649)
-- Name: blk_p_like_dept blk_p_like_dept_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_like_dept
    ADD CONSTRAINT blk_p_like_dept_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7728 (class 2606 OID 133977651)
-- Name: blk_p_pinchpo blk_p_pinchpo_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_pinchpo
    ADD CONSTRAINT blk_p_pinchpo_pkey PRIMARY KEY (po_id, product, location, "time", pinch_id);


--
-- TOC entry 7819 (class 2606 OID 134214756)
-- Name: blk_p_preassortment_status blk_p_preassortment_status_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_preassortment_status
    ADD CONSTRAINT blk_p_preassortment_status_pkey PRIMARY KEY (product);


--
-- TOC entry 7823 (class 2606 OID 135471647)
-- Name: blk_p_preassortment_stylesheet blk_p_preassortment_stylesheet_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_preassortment_stylesheet
    ADD CONSTRAINT blk_p_preassortment_stylesheet_pkey PRIMARY KEY (product, preasst_uuid);


--
-- TOC entry 7730 (class 2606 OID 133977653)
-- Name: blk_p_quick_pre_assortment_sheet blk_p_quick_pre_assortment_sheet_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_quick_pre_assortment_sheet
    ADD CONSTRAINT blk_p_quick_pre_assortment_sheet_pkey PRIMARY KEY (product, location, "time", qs_stylecolor);


--
-- TOC entry 7732 (class 2606 OID 133977655)
-- Name: blk_p_reassigncluster blk_p_reassigncluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_reassigncluster
    ADD CONSTRAINT blk_p_reassigncluster_pkey PRIMARY KEY (product, location, "time", store_cluster_id);


--
-- TOC entry 7734 (class 2606 OID 133977663)
-- Name: blk_p_receditclusters blk_p_receditclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_receditclusters
    ADD CONSTRAINT blk_p_receditclusters_pkey PRIMARY KEY (product, "time", po_id_for_clusters);


--
-- TOC entry 7736 (class 2606 OID 133977665)
-- Name: blk_p_receditstores blk_p_receditstores_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_receditstores
    ADD CONSTRAINT blk_p_receditstores_pkey PRIMARY KEY (product, location, "time", po_id_for_stores);


--
-- TOC entry 7738 (class 2606 OID 133977667)
-- Name: blk_p_specstyleattributes blk_p_specstyleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_specstyleattributes
    ADD CONSTRAINT blk_p_specstyleattributes_pkey PRIMARY KEY (sty_spec_hq_id, sty_spec_vpn_id, sty_spec_buy_period_id, product, location);


--
-- TOC entry 7740 (class 2606 OID 133977669)
-- Name: blk_p_store_attr_plan blk_p_store_attr_plan_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_store_attr_plan
    ADD CONSTRAINT blk_p_store_attr_plan_pkey PRIMARY KEY (location);


--
-- TOC entry 7744 (class 2606 OID 133977671)
-- Name: blk_p_stylecolor_extra_params blk_p_stylecolor_extra_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_stylecolor_extra_params
    ADD CONSTRAINT blk_p_stylecolor_extra_params_pkey PRIMARY KEY (product);


--
-- TOC entry 7746 (class 2606 OID 133977673)
-- Name: blk_p_target_include_exclude blk_p_target_include_exclude_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_target_include_exclude
    ADD CONSTRAINT blk_p_target_include_exclude_pkey PRIMARY KEY (product, "time", ly_lly_key);


--
-- TOC entry 7821 (class 2606 OID 134214772)
-- Name: blk_phantom_pivot_tbl blk_phantom_pivot_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_phantom_pivot_tbl
    ADD CONSTRAINT blk_phantom_pivot_tbl_pkey PRIMARY KEY (session_id);


--
-- TOC entry 7749 (class 2606 OID 133977675)
-- Name: blk_roledimension blk_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_roledimension
    ADD CONSTRAINT blk_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 7753 (class 2606 OID 133977677)
-- Name: blk_specimages blk_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_specimages
    ADD CONSTRAINT blk_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 7756 (class 2606 OID 133977679)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 7758 (class 2606 OID 133977681)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 7760 (class 2606 OID 133977683)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 7762 (class 2606 OID 133977685)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 7769 (class 2606 OID 133977687)
-- Name: new_table_2 new_table_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.new_table_2
    ADD CONSTRAINT new_table_2_pkey PRIMARY KEY (id);


--
-- TOC entry 7767 (class 2606 OID 133977689)
-- Name: new_table new_table_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.new_table
    ADD CONSTRAINT new_table_pkey PRIMARY KEY (id);


--
-- TOC entry 7626 (class 2606 OID 133977691)
-- Name: belk_p_pinchpo pinchpo_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.belk_p_pinchpo
    ADD CONSTRAINT pinchpo_pkey PRIMARY KEY (product, location, "time", pinch_id);


--
-- TOC entry 7771 (class 2606 OID 133977693)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 7773 (class 2606 OID 133977695)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7775 (class 2606 OID 133977697)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 7777 (class 2606 OID 133977699)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 7779 (class 2606 OID 133977704)
-- Name: shadow_addtoassortment shadow_addtoassortment_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.shadow_addtoassortment
    ADD CONSTRAINT shadow_addtoassortment_pkey PRIMARY KEY (style_id, color_id, __txid);


--
-- TOC entry 7781 (class 2606 OID 133977706)
-- Name: staging_addtoassortment_prod_val staging_addtoassortment_prod_val_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_addtoassortment_prod_val
    ADD CONSTRAINT staging_addtoassortment_prod_val_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7783 (class 2606 OID 133977708)
-- Name: staging_addtoassortment_prod_val_reject staging_addtoassortment_prod_val_reject_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.staging_addtoassortment_prod_val_reject
    ADD CONSTRAINT staging_addtoassortment_prod_val_reject_pkey PRIMARY KEY (upload_tx_id);


--
-- TOC entry 7742 (class 2606 OID 133977710)
-- Name: blk_p_strategy_params strategy_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.blk_p_strategy_params
    ADD CONSTRAINT strategy_params_pkey PRIMARY KEY (product, location, floorset_uda);


--
-- TOC entry 7764 (class 2606 OID 133977712)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 7786 (class 2606 OID 133977714)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 7788 (class 2606 OID 133977716)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 7790 (class 2606 OID 133977718)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 7792 (class 2606 OID 133977720)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 7803 (class 2606 OID 133977722)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 7795 (class 2606 OID 133977724)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 7797 (class 2606 OID 133977726)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 7799 (class 2606 OID 133977728)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 7805 (class 2606 OID 133977730)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 7808 (class 2606 OID 133977732)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 7810 (class 2606 OID 133977734)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 7812 (class 2606 OID 133977736)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 7815 (class 2606 OID 133977738)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 7817 (class 2606 OID 133977740)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 7661 (class 1259 OID 133977741)
-- Name: blk_eohdata_stylecolor_product_channel_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX blk_eohdata_stylecolor_product_channel_idx ON public.blk_eohdata_stylecolor USING btree (product, channel);


--
-- TOC entry 7670 (class 1259 OID 133977742)
-- Name: blk_locstd_ances0_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_locstd_ances0_str_indx ON public.blk_h_locstd USING btree (ancestor0);


--
-- TOC entry 7671 (class 1259 OID 133977743)
-- Name: blk_locstd_ances1_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_locstd_ances1_str_indx ON public.blk_h_locstd USING btree (ancestor1);


--
-- TOC entry 7672 (class 1259 OID 133977744)
-- Name: blk_locstd_ances2_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_locstd_ances2_str_indx ON public.blk_h_locstd USING btree (ancestor2);


--
-- TOC entry 7698 (class 1259 OID 133977745)
-- Name: blk_ma_sizeattributes_parent_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_ma_sizeattributes_parent_id_idx ON public.blk_ma_sizeattributes USING btree (parent_id);


--
-- TOC entry 7747 (class 1259 OID 133977821)
-- Name: blk_plan_these_cloned_style_stylecolors_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_plan_these_cloned_style_stylecolors_session_id_idx ON public.blk_plan_these_cloned_style_stylecolors USING btree (session_id);


--
-- TOC entry 7635 (class 1259 OID 133977822)
-- Name: blk_prodstd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances0_indx ON public.blk_h_prodstd USING btree (ancestor0);


--
-- TOC entry 7636 (class 1259 OID 133977934)
-- Name: blk_prodstd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances1_indx ON public.blk_h_prodstd USING btree (ancestor1);


--
-- TOC entry 7637 (class 1259 OID 133978019)
-- Name: blk_prodstd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances2_indx ON public.blk_h_prodstd USING btree (ancestor2);


--
-- TOC entry 7638 (class 1259 OID 133978086)
-- Name: blk_prodstd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances3_indx ON public.blk_h_prodstd USING btree (ancestor3);


--
-- TOC entry 7639 (class 1259 OID 133978153)
-- Name: blk_prodstd_ances4_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances4_indx ON public.blk_h_prodstd USING btree (ancestor4);


--
-- TOC entry 7640 (class 1259 OID 133978220)
-- Name: blk_prodstd_ances5_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances5_indx ON public.blk_h_prodstd USING btree (ancestor5);


--
-- TOC entry 7641 (class 1259 OID 133978269)
-- Name: blk_prodstd_ances6_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances6_indx ON public.blk_h_prodstd USING btree (ancestor6);


--
-- TOC entry 7642 (class 1259 OID 133978329)
-- Name: blk_prodstd_ances7_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_prodstd_ances7_indx ON public.blk_h_prodstd USING btree (ancestor7);


--
-- TOC entry 7657 (class 1259 OID 133978372)
-- Name: blk_product_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_product_levelid_indx ON public.blk_d_product USING btree (levelid);


--
-- TOC entry 7658 (class 1259 OID 133978427)
-- Name: blk_product_name_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_product_name_indx ON public.blk_d_product USING btree (name);


--
-- TOC entry 7754 (class 1259 OID 133978554)
-- Name: blk_style_clone_stylecolor_size_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX blk_style_clone_stylecolor_size_session_id_idx ON public.blk_style_clone_stylecolor_size USING btree (session_id);


--
-- TOC entry 7681 (class 1259 OID 133978555)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.blk_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 7765 (class 1259 OID 133978589)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 7784 (class 1259 OID 133978590)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 7800 (class 1259 OID 133978591)
-- Name: actuals_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_denorm_target_setting ON target_setting.actuals_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 7801 (class 1259 OID 133978592)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON target_setting.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 7793 (class 1259 OID 133978593)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON target_setting.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 7806 (class 1259 OID 133978594)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON target_setting.plan_data_wide USING hash (id);


--
-- TOC entry 7813 (class 1259 OID 133978802)
-- Name: sys_gen_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_target_setting ON target_setting.sys_gen_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 7845 (class 2620 OID 133978803)
-- Name: blk_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION store_eligibility_trigger();


--
-- TOC entry 7846 (class 2620 OID 133978804)
-- Name: blk_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.dbt_wk >= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.dbt_wk < old.plan_current))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 7847 (class 2620 OID 133978805)
-- Name: blk_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.exitdate < old.plan_current)))) OR ((new.relaunchweek IS NOT NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (new.exitdate < old.plan_current))) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION exit_trigger_on_update_validity_check();


--
-- TOC entry 7844 (class 2620 OID 134214661)
-- Name: blk_h_prodstd h_prod_updatescname; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER h_prod_updatescname AFTER UPDATE OF ancestor0 ON public.blk_h_prodstd FOR EACH ROW EXECUTE FUNCTION updatescname_if_style_changed();


--
-- TOC entry 7862 (class 2620 OID 139566260)
-- Name: blk_ma_imgattributes img_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER img_update AFTER UPDATE OF img ON public.blk_ma_imgattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION trigger_img_update();


--
-- TOC entry 7894 (class 2620 OID 133978806)
-- Name: blk_p_pinchpo ispublished_pinchpo; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ispublished_pinchpo BEFORE UPDATE OF is_published ON public.blk_p_pinchpo FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_pinchpo_published();


--
-- TOC entry 7848 (class 2620 OID 133978807)
-- Name: blk_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.erlstmkdnwk <= new.dbt_wk) OR ((old.cloned_at IS NULL) AND (old.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)) OR ((new.relaunchweek IS NOT NULL) AND ((new.erlstmkdnwk <= new.relaunchweek) OR ((old.cloned_at IS NULL) AND (new.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION md_trigger_on_update_validity_check();


--
-- TOC entry 7908 (class 2620 OID 133978808)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION notify_pivot_execution_change();


--
-- TOC entry 7909 (class 2620 OID 133978809)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION notify_plan_queue_change();


--
-- TOC entry 7910 (class 2620 OID 133978810)
-- Name: plan_queue plan_queue_remove_dups; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER plan_queue_remove_dups AFTER INSERT ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION remove_dup();

ALTER TABLE public.plan_queue DISABLE TRIGGER plan_queue_remove_dups;


--
-- TOC entry 7895 (class 2620 OID 133978811)
-- Name: blk_p_pinchpo poname_pinchpo_ecom; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER poname_pinchpo_ecom AFTER INSERT OR UPDATE OF pinch_user_po_plan_name_ecom ON public.blk_p_pinchpo FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_pinchpo_name_ecom();


--
-- TOC entry 7896 (class 2620 OID 133978812)
-- Name: blk_p_pinchpo poname_pinchpo_empty; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER poname_pinchpo_empty AFTER INSERT OR UPDATE OF pinch_user_po_plan_name_ecom, pinch_user_po_plan_name_store ON public.blk_p_pinchpo FOR EACH ROW WHEN ((((new.pinch_user_po_plan_name_ecom = ''::text) OR (new.pinch_user_po_plan_name_store = ''::text)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION update_pinchpo_name_empty();


--
-- TOC entry 7897 (class 2620 OID 133978813)
-- Name: blk_p_pinchpo poname_pinchpo_nad_nbd; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER poname_pinchpo_nad_nbd AFTER UPDATE OF pinch_nad, pinch_nbd ON public.blk_p_pinchpo FOR EACH ROW WHEN ((((old.pinch_publish_po_plan_name_store IS NOT NULL) OR (old.pinch_publish_po_plan_name_ecom IS NOT NULL)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION update_pinchpo_name_nad_nbd();


--
-- TOC entry 7898 (class 2620 OID 133978814)
-- Name: blk_p_pinchpo poname_pinchpo_store; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER poname_pinchpo_store AFTER INSERT OR UPDATE OF pinch_user_po_plan_name_store ON public.blk_p_pinchpo FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_pinchpo_name_store();


--
-- TOC entry 7863 (class 2620 OID 139566259)
-- Name: blk_ma_imgattributes set_held_img; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_held_img AFTER UPDATE OF hold_img ON public.blk_ma_imgattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION trigger_set_held_img();


--
-- TOC entry 7861 (class 2620 OID 133978815)
-- Name: blk_l_dependencylookup set_l_dependency_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_l_dependency_indx BEFORE INSERT ON public.blk_l_dependencylookup FOR EACH ROW EXECUTE FUNCTION trigger_set_indx_l_dependency();

ALTER TABLE public.blk_l_dependencylookup DISABLE TRIGGER set_l_dependency_indx;


--
-- TOC entry 7906 (class 2620 OID 133978816)
-- Name: blk_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.blk_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION trigger_set_indx_valid_values();


--
-- TOC entry 7864 (class 2620 OID 133978817)
-- Name: blk_ma_sizeattributes set_size_id; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_size_id BEFORE INSERT ON public.blk_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_size_id();


--
-- TOC entry 7840 (class 2620 OID 133978818)
-- Name: blk_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.blk_a_assortment FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7888 (class 2620 OID 133978819)
-- Name: blk_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.blk_p_channeloverride FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7889 (class 2620 OID 133978820)
-- Name: blk_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.blk_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7891 (class 2620 OID 133978821)
-- Name: blk_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.blk_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7890 (class 2620 OID 133978822)
-- Name: blk_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.blk_p_dc_adj FOR EACH ROW EXECUTE FUNCTION trigger_set_publish_timestamp();


--
-- TOC entry 7899 (class 2620 OID 133978823)
-- Name: blk_p_pinchpo set_timestamp_pinchpo; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_pinchpo AFTER INSERT OR UPDATE ON public.blk_p_pinchpo FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION trigger_set_timestamp_pinchpo();


--
-- TOC entry 7865 (class 2620 OID 133978824)
-- Name: blk_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.blk_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7902 (class 2620 OID 133978825)
-- Name: blk_p_specstyleattributes set_timestamp_specstyleattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_specstyleattributes BEFORE UPDATE ON public.blk_p_specstyleattributes FOR EACH ROW WHEN ((new.updated_by <> 'system'::text)) EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7866 (class 2620 OID 133978826)
-- Name: blk_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.blk_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7849 (class 2620 OID 133978827)
-- Name: blk_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7874 (class 2620 OID 133978828)
-- Name: blk_ma_stylecolorattributes set_timestamp_stylecolorattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_stylecolorattr BEFORE UPDATE ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION trigger_set_timestamp();


--
-- TOC entry 7850 (class 2620 OID 133978829)
-- Name: blk_ma_stylecolorchannelattributes tr_set_relaunch_is_valid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER tr_set_relaunch_is_valid BEFORE UPDATE OF relaunch_dbt_wk ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION set_relaunch_is_valid_if_not_null();


--
-- TOC entry 7851 (class 2620 OID 133978830)
-- Name: blk_ma_stylecolorchannelattributes tr_validate_relaunch_is_valid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER tr_validate_relaunch_is_valid BEFORE UPDATE OF relaunch_is_valid ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION validate_relaunch_is_valid();


--
-- TOC entry 7901 (class 2620 OID 133978831)
-- Name: blk_p_quick_pre_assortment_sheet trg_blk_p_quick_pre_assortment_sheet_qs_status; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_blk_p_quick_pre_assortment_sheet_qs_status BEFORE UPDATE ON public.blk_p_quick_pre_assortment_sheet FOR EACH ROW EXECUTE FUNCTION set_qs_status_to_in_use_on_update();


--
-- TOC entry 7903 (class 2620 OID 133978832)
-- Name: blk_p_strategy_params trg_blk_p_strategy_params_sync; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_blk_p_strategy_params_sync AFTER UPDATE OF rec_magnitude, apply_targets_to_plan, cluster_group_selected_type ON public.blk_p_strategy_params FOR EACH ROW EXECUTE FUNCTION blk_p_strategy_params_sync();


--
-- TOC entry 7875 (class 2620 OID 133978833)
-- Name: blk_ma_stylecolorattributes trg_lock_stylecolor; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_lock_stylecolor AFTER UPDATE OF cc_prepublish ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN ((((new.cc_prepublish IS TRUE) OR (new.cc_prepublish = (1)::boolean)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION lock_stylecolor();


--
-- TOC entry 7904 (class 2620 OID 133978834)
-- Name: blk_p_strategy_params trg_p_strategy_params_set_apply_targets; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_p_strategy_params_set_apply_targets BEFORE INSERT OR UPDATE ON public.blk_p_strategy_params FOR EACH ROW EXECUTE FUNCTION trg_set_apply_targets_to_plan();


--
-- TOC entry 7900 (class 2620 OID 133978835)
-- Name: blk_p_pinchpo trg_remove_pinched_store; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_remove_pinched_store AFTER INSERT ON public.blk_p_pinchpo FOR EACH ROW WHEN (((length(new.pinch_id) = 36) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION remove_pinched_store();


--
-- TOC entry 7867 (class 2620 OID 133978836)
-- Name: blk_ma_styleattributes trg_set_sty_dpt_buy_period; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_set_sty_dpt_buy_period AFTER UPDATE OF sty_buy_period_descr ON public.blk_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION set_sty_dpt_buy_period();


--
-- TOC entry 7841 (class 2620 OID 133978837)
-- Name: blk_a_assortment trg_to_update_source_of_ranging_edit; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_to_update_source_of_ranging_edit AFTER UPDATE OF plan_type ON public.blk_a_assortment FOR EACH ROW WHEN (((new.plan_type = 'ranging'::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION reset_plan_type_to_plan();


--
-- TOC entry 7876 (class 2620 OID 133978838)
-- Name: blk_ma_stylecolorattributes trg_unlock_stylecolor; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_unlock_stylecolor AFTER UPDATE OF cc_prepublish ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN ((((new.cc_prepublish = false) OR (new.cc_prepublish = (0)::boolean) OR (new.cc_prepublish IS NULL)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION unlock_stylecolor();


--
-- TOC entry 7842 (class 2620 OID 133978839)
-- Name: blk_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF str_grade, str_segmentation, str_sub_segmentation, str_aa_ind, str_hisp_ind, str_lifestyle_01, str_lifestyle_02, str_lifestyle_03, str_lifestyle_04, str_climate, str_state, str_grade_or, str_segmentation_or, str_sub_segmentation_or, str_aa_ind_or, str_hisp_ind_or, str_lifestyle_01_or, str_lifestyle_02_or, str_lifestyle_03_or, str_lifestyle_04_or, str_climate_or, str_state_or, ssg ON public.blk_a_assortment FOR EACH ROW WHEN (((new.plan_type <> 'ranging'::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION propagate_assortment_to_floorsets();


--
-- TOC entry 7877 (class 2620 OID 133978840)
-- Name: blk_ma_stylecolorattributes trg_upd_cc_prepublish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_cc_prepublish BEFORE UPDATE OF cc_prepublish ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION set_prepublished_at();


--
-- TOC entry 7878 (class 2620 OID 133978841)
-- Name: blk_ma_stylecolorattributes trg_update_of_cc_vpn_buy_period; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_of_cc_vpn_buy_period AFTER UPDATE OF cc_buy_period_descr ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_of_cc_vpn_buy_period();


--
-- TOC entry 7905 (class 2620 OID 133978842)
-- Name: blk_p_stylecolor_extra_params trg_validate_reset_inv_for_relaunch; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_validate_reset_inv_for_relaunch BEFORE INSERT OR UPDATE ON public.blk_p_stylecolor_extra_params FOR EACH ROW EXECUTE FUNCTION fn_validate_reset_inv_for_relaunch();


--
-- TOC entry 7879 (class 2620 OID 139169510)
-- Name: blk_ma_stylecolorattributes trig_cc_createdate_revert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_cc_createdate_revert BEFORE UPDATE OF cc_aa_ind ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN (((old.ccstylecolorcreatedate IS NOT NULL) AND (old.ccstylecolorcreatedate <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION revert_non_editable_columns();


--
-- TOC entry 7880 (class 2620 OID 133978843)
-- Name: blk_ma_stylecolorattributes trig_insert_stylecolorweekattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_insert_stylecolorweekattributes AFTER UPDATE OF cc_vpn_color ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN ((((old.cc_vpn_color IS NULL) OR (old.cc_vpn_color = ''::text)) AND (new.cc_vpn_color IS NOT NULL))) EXECUTE FUNCTION insert_stylecolorweekattributes();


--
-- TOC entry 7843 (class 2620 OID 133978844)
-- Name: blk_a_assortment trig_override_ticket_price; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_override_ticket_price AFTER UPDATE OF a_current_retail_override ON public.blk_a_assortment FOR EACH ROW EXECUTE FUNCTION override_ticket_price();


--
-- TOC entry 7868 (class 2620 OID 133978845)
-- Name: blk_ma_styleattributes trig_remove_supp_attr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_remove_supp_attr AFTER UPDATE OF supp_supplier_site_id ON public.blk_ma_styleattributes FOR EACH ROW WHEN (((new.supp_supplier_site_id IS NULL) OR (new.supp_supplier_site_id = ''::text))) EXECUTE FUNCTION remove_styleattributes_supp();


--
-- TOC entry 7881 (class 2620 OID 133978846)
-- Name: blk_ma_stylecolorattributes trig_set_design_img; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_set_design_img AFTER UPDATE OF cc_vpn ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION set_design_img();


--
-- TOC entry 7882 (class 2620 OID 133978847)
-- Name: blk_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER INSERT OR UPDATE OF cccolor ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION update_color_change();


--
-- TOC entry 7883 (class 2620 OID 133978848)
-- Name: blk_ma_stylecolorattributes trig_upd_on_ticketprice; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_ticketprice AFTER UPDATE OF cc_msrp, cc_current_retail ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION update_ticket_price();


--
-- TOC entry 7884 (class 2620 OID 133978849)
-- Name: blk_ma_stylecolorattributes trig_update_cc_vpn_color; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_cc_vpn_color AFTER UPDATE OF cc_vpn_color_display ON public.blk_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION update_cc_vpn();


--
-- TOC entry 7869 (class 2620 OID 133978850)
-- Name: blk_ma_styleattributes trig_update_plm_sty_vpn; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_plm_sty_vpn AFTER UPDATE OF sty_vpn ON public.blk_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION update_plm_sty_vpn();


--
-- TOC entry 7870 (class 2620 OID 133978851)
-- Name: blk_ma_styleattributes trig_update_sty_vpn; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_sty_vpn AFTER UPDATE OF sty_vpn ON public.blk_ma_styleattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_stylecolorattributes_cc_vpn();

ALTER TABLE public.blk_ma_styleattributes DISABLE TRIGGER trig_update_sty_vpn;


--
-- TOC entry 7871 (class 2620 OID 133978852)
-- Name: blk_ma_styleattributes trig_update_sty_vpn_non_plm; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_sty_vpn_non_plm AFTER UPDATE OF sty_vpn_id_non_plm ON public.blk_ma_styleattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_stylecolorattributes_cc_vpn_for_non_plm();


--
-- TOC entry 7885 (class 2620 OID 133978853)
-- Name: blk_ma_stylecolorattributes trig_update_stylecolorweekattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_stylecolorweekattributes AFTER UPDATE OF cc_vpn_color ON public.blk_ma_stylecolorattributes FOR EACH ROW WHEN (((new.cc_vpn_color <> old.cc_vpn_color) AND (new.cc_vpn = old.cc_vpn))) EXECUTE FUNCTION update_stylecolorweekattributes();


--
-- TOC entry 7886 (class 2620 OID 133978854)
-- Name: blk_ma_stylecolorweekattributes trig_update_stylecolorweekattributes_null_hq; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_stylecolorweekattributes_null_hq AFTER UPDATE OF hq_id ON public.blk_ma_stylecolorweekattributes FOR EACH ROW WHEN ((((old.hq_id IS NOT NULL) OR (old.hq_id <> ''::text)) AND ((new.hq_id IS NULL) OR (new.hq_id = ''::text)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION update_stylecolorweekattributes_null_hq();


--
-- TOC entry 7887 (class 2620 OID 133978855)
-- Name: blk_ma_stylecolorweekattributes trig_update_stylecolorweekattributes_post_hq; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_stylecolorweekattributes_post_hq AFTER UPDATE OF hq_id ON public.blk_ma_stylecolorweekattributes FOR EACH ROW WHEN (((old.hq_id <> new.hq_id) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION update_stylecolorweekattributes_post_hq();


--
-- TOC entry 7872 (class 2620 OID 133978856)
-- Name: blk_ma_styleattributes trig_update_supp_attr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_update_supp_attr AFTER UPDATE OF supp_supplier_site_id ON public.blk_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION update_styleattributes_supp();


--
-- TOC entry 7852 (class 2620 OID 133978857)
-- Name: blk_ma_stylecolorchannelattributes trigger_auto_rollforward_true; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_auto_rollforward_true AFTER UPDATE OF auto_rollforward ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((new.auto_rollforward = true)) EXECUTE FUNCTION auto_rollforward_true();


--
-- TOC entry 7907 (class 2620 OID 133978858)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION update_trigger_cartparams_ranging();


--
-- TOC entry 7853 (class 2620 OID 133978859)
-- Name: blk_ma_stylecolorchannelattributes trigger_cost; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cost AFTER UPDATE OF cc_target_cost ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION trigger_update_cost();


--
-- TOC entry 7892 (class 2620 OID 133978860)
-- Name: blk_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.blk_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION update_eff_aur();


--
-- TOC entry 7854 (class 2620 OID 133978861)
-- Name: blk_ma_stylecolorchannelattributes trigger_for_time_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx AFTER INSERT OR UPDATE OF dbt_wk, erlstmkdnwk, exitdate, relaunchweek, relaunch_dbt_wk, relaunch_erlstmkdnwk, relaunch_exitdate ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION update_week_indxes();


--
-- TOC entry 7855 (class 2620 OID 133978862)
-- Name: blk_ma_stylecolorchannelattributes trigger_for_time_indx_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_update AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION update_week_indxes();


--
-- TOC entry 7893 (class 2620 OID 133978863)
-- Name: blk_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.blk_p_itemprice FOR EACH ROW EXECUTE FUNCTION itemprice_fetchdepartment();


--
-- TOC entry 7856 (class 2620 OID 133978864)
-- Name: blk_ma_stylecolorchannelattributes trigger_lifecycle_blank_null; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_blank_null BEFORE UPDATE OF dbt_wk, erlstmkdnwk, exitdate ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.dbt_wk IS NULL) OR (new.dbt_wk = ''::text) OR (new.erlstmkdnwk IS NULL) OR (new.erlstmkdnwk = ''::text) OR (new.exitdate IS NULL) OR (new.exitdate = ''::text))) EXECUTE FUNCTION lifecycle_blank_null();


--
-- TOC entry 7857 (class 2620 OID 133978865)
-- Name: blk_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION lifecycle_plan_update();


--
-- TOC entry 7859 (class 2620 OID 133978866)
-- Name: blk_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.blk_d_product FOR EACH ROW WHEN ((new.levelid = 'style'::text)) EXECUTE FUNCTION update_name_description();


--
-- TOC entry 7860 (class 2620 OID 133978867)
-- Name: blk_d_product trigger_upd_name_description_style; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description_style AFTER UPDATE OF description ON public.blk_d_product FOR EACH ROW WHEN (((new.levelid = 'stylecolor'::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION update_name_description_style();


--
-- TOC entry 7858 (class 2620 OID 133978868)
-- Name: blk_ma_stylecolorchannelattributes update_assortment_model_based_on_lifecycle; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_assortment_model_based_on_lifecycle AFTER UPDATE OF dbt_wk, exitdate, relaunch_exitdate, relaunch_dbt_wk ON public.blk_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((new.dbt_wk < new.erlstmkdnwk) AND (new.erlstmkdnwk <= new.exitdate) AND ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current)) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION store_eligibility_trigger();


--
-- TOC entry 7873 (class 2620 OID 133978869)
-- Name: blk_ma_styleattributes update_ccrangecode; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccrangecode AFTER UPDATE OF sty_size_range ON public.blk_ma_styleattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION update_stylecolorchannelattributes_ccrangecode();


--
-- TOC entry 7826 (class 2606 OID 133978870)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7827 (class 2606 OID 133978875)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7829 (class 2606 OID 133978880)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 7824 (class 2606 OID 133978885)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES agent_conversations(conversation_id);


--
-- TOC entry 7825 (class 2606 OID 133978890)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES allocation_plan_queue(jobid);


--
-- TOC entry 7832 (class 2606 OID 133978895)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7833 (class 2606 OID 133978900)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7828 (class 2606 OID 133978905)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 7831 (class 2606 OID 133978910)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 7830 (class 2606 OID 133978915)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES user_metadata(uid);


--
-- TOC entry 7834 (class 2606 OID 133978920)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7835 (class 2606 OID 133978925)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7838 (class 2606 OID 133978930)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7836 (class 2606 OID 133978935)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES target_setting.plans(id) ON DELETE CASCADE;


--
-- TOC entry 7837 (class 2606 OID 133978940)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES target_setting.plans(id);


--
-- TOC entry 7839 (class 2606 OID 133978945)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 8069 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:06:38 IST

--
-- PostgreSQL database dump complete
--

\unrestrict jkbIu7qjySpJCqS2qsTLAtXUDnAl6fYwHk6Vt2qzuZAbppS2Iep7VopHlL47jHQ

