-- ENV: QA | DB: exp | dumped: 2026-10-01 15:05 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict rWBXdM2p9ueIbFiqnmzTcEUBxbRM2WYX4hcReGiySxQEtHshB3Dfd6pjLmT2O7Z

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:05:45 IST

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
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 2 (class 3079 OID 34476490)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 8386 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 3581 (class 1247 OID 81992440)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 3584 (class 1247 OID 81992448)
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
-- TOC entry 3587 (class 1247 OID 81992460)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 1647 (class 1255 OID 81992465)
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
 s40 text;
 s41 text;
 s42 text;
 s43 text;
 s43_1 text;
 added_prods refcursor;
 s44 text;
 s45 text;
 s46 text;
 s47 text;
 s48 text;
 s49 text;
 s50 text;
 s51 text;

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


 s43_1 := 'select final_stylecolor_id product from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||') and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')';

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
 -- EXECUTE s1;

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
     ,  null::text powerdriver_id
     ,  null::text class_name
     ,  null::text powerdriver_name
     from cart_master
     where
     jsessionid in (select jsid from '||table_input_t1||')
     and isProcessed=0
     '
     ;


 -- EXECUTE s2;

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

 -- EXECUTE s3;

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

 -- EXECUTE s4_1;

 s4_2 := '
     Update '||table_cart_master_temp||' a
     set class_id = b.ancestor1,
         powerdriver_id = b.ancestor0
     from public.exp01_h_prodstd b
     where
     b.id = a.incoming_style_id
     ';

 -- EXECUTE s4_2;

 s4_3 := '
     Update '||table_cart_master_temp||' a
     set class_name = b.name
     from public.exp01_d_product b
     where
     b.id = a.class_id
     ';

 -- EXECUTE s4_3;

 s4_4 := '
     Update '||table_cart_master_temp||' a
     set powerdriver_name = b.name
     from public.exp01_d_product b
     where
     b.id = a.powerdriver_id
     ';

 -- EXECUTE s4_4;

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

 -- EXECUTE s5;

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

 -- EXECUTE s6;

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
                  , exp01_ma_sizeattributes b
           WHERE  a.incoming_stylecolor_id = b.parent_id
           )x
           '
           ;

 -- EXECUTE s7;

 RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

 s8 := 'delete from exp01_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';
 -- EXECUTE s8;

 s9 := '
     INSERT INTO exp01_d_product
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


 -- EXECUTE s9;

 s10 := '
 delete from exp01_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';
 -- EXECUTE s10;

 s11 := '
     INSERT INTO exp01_d_product
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


 -- EXECUTE s11;

 s12 := '
 delete from exp01_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 s13 := '
     INSERT INTO exp01_d_product
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


 -- EXECUTE s13;
 -- CREATING HIERARCHY

 s14 := '
 delete from exp01_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';
 -- EXECUTE s14;

 s15 := '
 INSERT INTO exp01_h_prodstd
             (id
              , ancestor0
              , ancestor1
              , ancestor2
              , ancestor3
              , ancestor4
              , ancestor5
              , ancestor6
              , ancestor7
              , ancestor8)
 SELECT DISTINCT
                   final_style_id
                 , ancestor0
                 , ancestor1
                 , ancestor2
                 , ancestor3
                 , ancestor4
                 , ancestor5
                 , ancestor6
                 , ancestor7
                 , ancestor8
 FROM   '||table_cart_master_temp||' a,
 (select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
 WHERE style_type=''similar''
 and a.incoming_style_id = b.id
 '
 ;

 -- EXECUTE s15;

 s16 := '
 delete from exp01_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 -- EXECUTE s16;

 s17 := '
 INSERT INTO exp01_h_prodstd
             (id
              , ancestor0
              , ancestor1
              , ancestor2
              , ancestor3
              , ancestor4
              , ancestor5
              , ancestor6
              , ancestor7
              , ancestor8)
 SELECT DISTINCT
                   final_stylecolor_id
                 , final_style_id
                 , ancestor1
                 , ancestor2
                 , ancestor3
                 , ancestor4
                 , ancestor5
                 , ancestor6
                 , ancestor7
                 , ancestor8
 FROM   '||table_cart_master_temp||'   a,
 (select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
 WHERE stylecolor_type=''similar''
 and a.incoming_stylecolor_id = b.id
 '
 ;

 -- EXECUTE s17;

 s18 := '
 delete from exp01_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 s19 := '
 INSERT INTO exp01_h_prodstd
             (id
              , ancestor0
              , ancestor1
              , ancestor2
              , ancestor3
              , ancestor4
              , ancestor5
              , ancestor6
              , ancestor7
              , ancestor8)
 SELECT DISTINCT
                   final_stylecolorsize_id
                 , final_stylecolor_id
                 , ancestor0
                 , ancestor1
                 , ancestor2
                 , ancestor3
                 , ancestor4
                 , ancestor5
                 , ancestor6
                 , ancestor7
 FROM    '||table_cart_stylecolorsize||'  a,
 exp01_h_prodstd b
 WHERE stylecolor_type=''similar''
 and a.final_stylecolor_id = b.id
 '
 ;

 -- EXECUTE s19;

 RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();

 s20 := '
 delete from exp01_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 -- updating cccolor and cccolorfamily

 s21 := '
 update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from exp01_l_dependencylookup b where b.target_id = ''cccolorfamily'' and b.lookup_id=''cccolor'' and lookup_value=a.cccolor
 ';

 s22 := '
 delete from exp01_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 s23 := '
 delete from exp01_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 -- EXECUTE s20;
 -- EXECUTE s21;
 -- EXECUTE s22;
 -- EXECUTE s23;

 s24 := '
 insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
 select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
 from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
 ';
 -- EXECUTE s24;

 s25 := '
 insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
 select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
 from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
 ';

 -- EXECUTE s25;

 -- STYLE ATTRIBUTES

 S26 := '
 INSERT INTO exp01_ma_styleattributes
             (product
              , ccfit
              , cclegshape
              , cclegskirtdresslength
              , ccneckline
              , ccsleevelength
              , ccsilhouette
              --, ccproductdetail
              --, ccfashiontier
              --, cctested
              , cclifestyle
              , ccrise
              --, ccgraphictheme
              --, ccdevelopmentpath
              --, ccstylegroup
              --, ccsuits
              --, ccfabric
              , ccgender
              , cchangingnonhanging
              , cctopbottom
              --, ccseason
              --, ccmarketingimage
              --, cchazmat
              , ccgoh
              , ccdresses
              --, ccfibertype
              , cctickettype
              , ccpricingtier
              , ccrangecode
              --, ccdenimwash
              , ccprintpattern
              , cclicense
              , ccticketprice
              , ccsubclassid
              , ccsubclassname
              , style_insight
              , ccclassname
              , ccpowerdrivername
              , ccdepartmentname
              , isstyleremovable
              , ccsizerange
              , express_size_range)
 SELECT final_style_id as product
              , b.ccfit
              , b.cclegshape
              , b.cclegskirtdresslength
              , b.ccneckline
              , b.ccsleevelength
              , b.ccsilhouette
              --, b.ccproductdetail
              --, b.ccfashiontier
              --, b.cctested
              , b.cclifestyle
              , b.ccrise
              --, b.ccgraphictheme
              --, b.ccdevelopmentpath
              --, b.ccstylegroup
              --, b.ccsuits
              --, b.ccfabric
              , b.ccgender
              , b.cchangingnonhanging
              , b.cctopbottom
              --, b.ccseason
              --, b.ccmarketingimage
              --, b.cchazmat
              , b.ccgoh
              , b.ccdresses
              --, b.ccfibertype
              , b.cctickettype
              , b.ccpricingtier
              , b.ccrangecode
              --, b.ccdenimwash
              , b.ccprintpattern
              , b.cclicense
              , b.ccticketprice
              , b.ccsubclassid
              , b.ccsubclassname
              , b.style_insight
              , CONCAT(class_id,'' '',class_name) as ccclassname
              , CONCAT(powerdriver_id,'' '',powerdriver_name) as ccpowerdrivername
              , b.ccdepartmentname
              , ''true''
              , b.ccsizerange
              , b.express_size_range
 from (select distinct final_style_id, style_type, incoming_style_id, class_id, powerdriver_id, class_name, powerdriver_name from '||table_cart_master_temp||') a, exp01_ma_styleattributes b
 where a.incoming_style_id=b.product
 and a.style_type=''similar''
 ';

 -- EXECUTE s26;

 -- STYLECOLOR ATTRIBUTES

 s27 := '
 delete from exp01_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

 -- EXECUTE s27;

 s28 := '
 INSERT INTO exp01_ma_stylecolorattributes
         (product
        --, ccfloorset
        --, ccstoretier
        --, ccmarkdownflag
        --, ccprintid
        --, ccmos
        --, ccrecall
        --, ccunavailable
        , cccolorid
        , cccolor
        , cccolorfamily
        --, cccurp
        --, ccinsight
        , ccactslsrnk
        -- , ccspecstylestyleclr
        , ishistory
        , isassortment
        , isdesign
        , isforecastable
        , inqueue
        , islocked
        , isremovable
        --, cccin
        , ccfashiontier
        )
 SELECT final_stylecolor_id as product
        --, b.ccfloorset
        --, b.ccstoretier
        --, b.ccmarkdownflag
        --, b.ccprintid
        --, b.ccmos
        --, b.ccrecall
        --, b.ccunavailable
        , a.cccolorid
        , a.cccolor
        , a.cccolorfamily
        --, b.cccurp
        --, b.ccinsight
        , b.ccactslsrnk
     -- , b.ccspecstylestyleclr
        , ''false''
        , ''true''
        , ''false''
        , ''false''
        , ''false''
        , ''false''
        , ''true''
        --, b.cccin
        , b.ccfashiontier
 from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid  from '||table_cart_master_temp||') a, exp01_ma_stylecolorattributes b
 where a.incoming_stylecolor_id=b.product
 and a.stylecolor_type=''similar''
 ';

 -- EXECUTE s28;

 s28_1 := '
 update exp01_ma_stylecolorattributes x set cccin = y.target_value
 from (select incoming_stylecolor_id, target_value from (select distinct incoming_stylecolor_id, cccolor from '||table_cart_master_temp||') a, exp01_l_dependencylookup b where b.target_id = ''cccin'' and b.lookup_id=''cccolor'' and lookup_value=a.cccolor) y
 where y.incoming_stylecolor_id=x.product
 ';

 -- EXECUTE s28_1;

 s28_X := '
 Update exp01_ma_stylecolorattributes b
 set isassortment = ''true''
 from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid  from '||table_cart_master_temp||') a
 where a.incoming_stylecolor_id=b.product
 and a.stylecolor_type=''existing''
 ';

 -- EXECUTE s28_X;

 -- IMAGE ATTRIBUTES START

 s29 := 'drop table if exists '||table_ma_imgattr||'';

 s29_1 := '
 create temporary table '||table_spec_img||' as
 select
  distinct si.product, si.img, sa.product as style_id
 from exp01_specimages si
  inner join
 exp01_ma_styleattributes sa
  on sa.ccspecstylestyle = si.product
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
   (select distinct product, img from exp01_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
 ON
 b.product=c.incoming_stylecolor_id
   LEFT JOIN
   (select distinct product, img, style_id from '||table_spec_img||') d
 on
 d.style_id = c.final_style_id;

 '
 ;

 -- EXECUTE s29;
 -- EXECUTE s29_1;
 -- EXECUTE s30;

 s31 := '
 delete from exp01_ma_imgattributes where product in (
     select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
 )
 '
 ;

 s32 := '
 insert into exp01_ma_imgattributes (product, img)
 select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
 ';

 -- EXECUTE s31;
 -- EXECUTE s32;

 -- IMAGE ATTRIBUTES END

 -- SIZE ATTRIBUTES

 s33 := '
 delete from exp01_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
 ';

 -- EXECUTE s33;

 s34 := '
 insert into exp01_ma_sizeattributes
     (product,
     sizeattribute,
     parent_id
     )
 SELECT
     distinct final_stylecolorsize_id,
     size_name,
     final_stylecolor_id
 FROM
     '||table_cart_stylecolorsize||'
 WHERE stylecolor_type = ''similar''
 ';

 -- EXECUTE s34;

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

 -- EXECUTE s35;
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
   , coalesce(ccordpolicy, default_ccordpolicy) ccordpolicy
   , ccrangecode
   , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
   , validsizes
   , default_presmin as presmin
   , default_presmin_weeks as presmin_weeks
   , default_ccrcptint::int as ccrcptint
   , coalesce(ccordermultiple::int,default_ccordermultiple::int) ccordermultiple
   , ccexistingwac
   , ccsystemcost
   , b.slsrnk

 FROM
 '||table_default_cart_params||' a, exp01_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c
 where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location
 ';

 -- EXECUTE s36;

 s37 := '
 delete from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
 ';

 -- EXECUTE s37;

 s38 := '
 INSERT  into exp01_ma_stylecolorchannelattributes (
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
 , ccordpolicy
 , ccrangecode
 , ssnprf
 , validsizes
 , presmin
 , presmin_weeks
 , ccrcptint
 , ccordermultiple
 , ccexistingwac
 , ccsystemcost
 , slsrnk
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
 , ccordpolicy
 , ccrangecode
 , ssnprf
 , validsizes
 , presmin
 , presmin_weeks
 , ccrcptint
 , ccordermultiple
 , ccexistingwac
 , ccsystemcost
 , slsrnk
 FROM
  '||table_temp_sclr_chnl_attr||'
  ';

 -- EXECUTE s38;

 RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

 -- ASSORTMENT MODEL

 s51 := '
 update exp01_ma_stylecolorchannelattributes a
 set
   ccdiscountpct = default_discount
 , ccmdstrategy = default_md
 , plan_current = v_plan_current
 from (select id, ancestor3, default_discount, default_md, v_plan_current from exp01_h_prodstd a, default_disc_md b, (select value as v_plan_current from exp01_serviceparams where id=''plan_current'') c  where a.ancestor3=b.department) b
 where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
 and a.product=b.id
 ';

 -- EXECUTE s51;

 s39 := '
     create temporary table '||table_temp_assort||' AS
     SELECT
         final_stylecolor_id as product
         , a.scope_location as location
         , a.scope_floorset as "time"
         , cast(strmenscapacity as text[]) as strmenscapacity
         , cast(strwomenscapacity as text[]) as strwomenscapacity
         , cast(strcorpvoltier as text[]) as strcorpvoltier
         , cast(strclimate as text[]) as strclimate
         , cast(grade as text[]) as grade
         , cast(ssg as text[]) as ssg
         , cast(flnrange as text[]) as flnrange
         , ''plan'' as plan_type
         , isfunded
         , final_style_id as style
         , store_count
     FROM
     (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c
     where a.jsessionid=c.jsessionid
   and a.jsessionid = b.jsid
   and a.scope_product = b.scope_product
   and a.scope_location = b.scope_location
   and a.scope_start = b.scope_start
     '
     ;

 -- EXECUTE s39;

 s40 := '
 delete from exp01_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
 ';

 -- EXECUTE s40;

 s41 := '

     insert into exp01_a_assortment (
           product
         , location
         , "time"
         , strmenscapacity
         , strwomenscapacity
         , strcorpvoltier
         , strclimate
         , grade
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
         , strmenscapacity
         , strwomenscapacity
         , strcorpvoltier
         , strclimate
         , grade
         , ssg
         , flnrange
         , plan_type
         , isfunded
         , store_count
   , style
     FROM
        '||table_temp_assort||'
 ';

 -- EXECUTE s41;

 RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();

 s42 := '
 create temporary table '||table_final_list||' AS
 select distinct a.product, a.location
 from
 (select distinct product,location  from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
 (select distinct product,location  from exp01_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
 where
 a.product=b.product
 and a.location=b.location
 ';

 -- EXECUTE s42;

 s43 := '
 insert into plan_queue (product, location, initiator, initiated_at)
 select final_stylecolor_id, '''||$3||''', initiator :: uuid, now() from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
 and (final_stylecolor_id, '''||$3||''') in (select product, location from '||table_final_list||')
 ';

 -- EXECUTE s43;

 s44 := 'update cart_master set isProcessed=1 where jsessionid in (select jsid from  '||table_input_t1||')';

 s45 := 'insert into cart_master_archive select * from cart_master  where jsessionid in (select jsid from  '||table_input_t1||')';
 s46 := 'insert into cart_params_archive select * from cart_params  where jsessionid in (select jsid from  '||table_input_t1||')';
 s47 := 'insert into cart_ranging_archive select * from cart_ranging  where jsessionid in (select jsid from  '||table_input_t1||')';

 s48 := 'delete from cart_master where jsessionid in (select jsid from  '||table_input_t1||')';
 s49 := 'delete from cart_params where jsessionid in (select jsid from  '||table_input_t1||')';
 s50 := 'delete from cart_ranging where jsessionid in (select jsid from  '||table_input_t1||')';

 -- EXECUTE s44;
 -- EXECUTE s45;
 -- EXECUTE s46;
 -- EXECUTE s47;
 -- EXECUTE s48;
 -- EXECUTE s49;
 -- EXECUTE s50;

 insert into debug_stats_ts values ('s1',s1,now());


 s100 := 'CREATE TEMPORARY TABLE '||tst_df_temp||' AS
           SELECT
               product,
               COALESCE(relaunchweek,dbt_wk) as dbt_wk,
               last_rcpt_wk,
               erlstmkdnwk,
               exitdate,
               ccmdstrategy,
               ccdiscountpct,
               in_season_flag,
               id AS time,
               case when id < erlstmkdnwk then ''FP'' else ''MD'' end as price_status
           FROM exp01_ma_stylecolorchannelattributes AS a
           , exp01_d_time AS b
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
                   ccdiscountpct,
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
                   ccdiscountpct,
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
               FROM exp01_h_prodstd
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
             , 0::real as md_disc
             , 0::real corpaddoff
             , 0::real corpexcl
             , 0::real addoff
             , null::real expressed_aur
             , ccticketprice::real curp
             , 0::real selling_price
             , 0::real v_A
             , 0::real v_B
             , null::text weekdate
             FROM
             (select a.*, ccticketprice from '||tst_df_with_style||' a, exp01_ma_styleattributes b where a.style=b.product) x
             ';

 s105 := 'update '||tst_md_tktp_md||' a
             set md_disc=b.md_disc, curp=ccticketprice * (1 - b.md_disc)
           from md_strategy b
           where a.seq=b.seq and a.ccmdstrategy=b.mdstrategy
           and a.seq > 0
           ';

 s106 := 'update '||tst_md_tktp_md||' a
             set corpaddoff=b.corpaddoff, corpexcl=b.corpexcl
           from exp01_corpdisc b
           where a.subclass=b.product and a.time=b.time
           ';

 s107 := 'update '||tst_md_tktp_md||' a
             set expressed_aur=b.eff_aur, addoff=b.addoff
           from exp01_p_itemprice b
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
               select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, exp01_d_time b, exp01_d_time c
               where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
               ';


 s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)';
 s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from exp01_ma_weekattributes b where a.dbt_wk=b.time';
 s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from exp01_ma_weekattributes b where a.last_rcpt_wk=b.time';
 s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from exp01_ma_weekattributes b where a.erlstmkdnwk=b.time';
 s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from exp01_ma_weekattributes b where a.exitdate=b.time';
 s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from exp01_ma_weekattributes b where a.time=b.time';



 s111 := 'CREATE TEMPORARY TABLE '||table_xt||' AS
         select *,
           case when location=''GP-01'' then
             case when ''ECOM''=ANY(grade) then ''CH-02'' else null END
           ELSE null end as ch02,

           case when location=''GP-01'' then
             case when ''ECOM''!=ANY(grade) then ''CH-01'' else null END
           else null end as ch01,

           case when location=''GP-03'' then ''CH-03'' else null end as ch03
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
                   grade,
                   isfunded,
                   ancestor3 AS department
               FROM (select * from exp01_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
               ,
               (
                   SELECT
                       id,
                       ancestor3
                   FROM exp01_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
               FROM exp01_ma_dptflrsetattributes AS a
               , exp01_d_time AS b
               WHERE (b.id >= a.ap_start) AND (b.id <= a.ap_end)
           ) AS y
           WHERE (x.department = y.department) AND (x.floorset = y.floorset)
         ) z
         ';

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

 s113 := 'CREATE TEMPORARY TABLE '||table_zt_pre||' AS
           SELECT *
           FROM
           (
               SELECT
                   a.product,
                   a.location AS channel,
                   a.time,
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
                   b.ccdiscountpct
               FROM '||table_yt||' AS a
               , '||tst_md_tktp_md||' AS b
               WHERE (a.product = b.product) AND (a.time = b.time)
           ) AS x
           WHERE time >= (select value from exp01_serviceparams where id=''plan_current'')
           AND time <= (select value from exp01_serviceparams where id=''plan_end'')
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


 s114 := 'delete from exp01_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
 s115 := 'insert into exp01_an_price_storecount_info
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
             , ccdiscountpct
             , flow_flag
           from
           '||table_zt||'
           ';



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
 EXECUTE s27;
 -- insert into trigger_test_delete_me values ('s27:', clock_timestamp());
 EXECUTE s28;
 -- insert into trigger_test_delete_me values ('s28:', clock_timestamp());
 EXECUTE s28_1;
 -- insert into trigger_test_delete_me values ('s28_1:', clock_timestamp());
 EXECUTE s28_X;
 -- insert into trigger_test_delete_me values ('s28_X:', clock_timestamp());
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
 EXECUTE s37;
 -- insert into trigger_test_delete_me values ('s37:', clock_timestamp());
 EXECUTE s38;
 -- insert into trigger_test_delete_me values ('s38:', clock_timestamp());
 EXECUTE s51;
 -- insert into trigger_test_delete_me values ('s51:', clock_timestamp());
 EXECUTE s39;
 -- insert into trigger_test_delete_me values ('s39:', clock_timestamp());
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
 EXECUTE s112 ;
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


 RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();

 OPEN added_prods FOR EXECUTE s43_1;
 RETURN added_prods;
 END;
 $_$;


ALTER FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 1648 (class 1255 OID 81992467)
-- Name: add_to_assortment_2(text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.add_to_assortment_2(input_jsessionid text, scope_department text, scope_location text, scope_start text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

    drop table if exists t1;
    create table t1 as select ''||$1||'' as jsid;

    drop table if exists cart_master_temp;
    create table cart_master_temp as 
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
    , initiator
    from cart_master 
    where 
    jsessionid in (select jsid from t1)
    and isProcessed=0
    ;

    --select * from cart_master_temp;

    drop table if exists chetan_cart_style;
    create  table chetan_cart_style as
    select jsessionid
    , case when style_type = 'similar' then uuid_generate_v4()::text else incoming_style_id end AS final_style_id
    , incoming_style_id
    , style_type
    , style_name  as displayed_style_name
    , style_description  as displayed_style_description
    from 
    (
    select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description from cart_master_temp 
    where jsessionid in (select jsid from t1)
    ) x;

    --select uuid_in(md5(random()::text || clock_timestamp()::text)::cstring)

    Update cart_master_temp a 
    set final_style_id = b.final_style_id 
    from chetan_cart_style b 
    where 
    a.incoming_style_id=b.incoming_style_id 
    and a.style_type=b.style_type
    and a.jsessionid=b.jsessionid 
    and a.jsessionid in (select jsid from t1);

    drop table if exists chetan_cart_stylecolor;
    create  table chetan_cart_stylecolor as
    select jsessionid
    , case when stylecolor_type = 'similar' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = 'similar' then style_name||'-'||color_id else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = 'similar' then style_description ||' '||cccolor else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    from 
    (
    select distinct jsessionid, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as color_id
    , style_name, style_description, stylecolor_name, stylecolor_description 
    from cart_master_temp
    where jsessionid in (select jsid from t1)
    ) x;

    Update cart_master_temp a set 
    final_stylecolor_id = b.final_stylecolor_id
    , stylecolor_name = displayed_stylecolor_name
    , stylecolor_description = displayed_stylecolor_description 
    from chetan_cart_stylecolor b 
    where 
    a.incoming_stylecolor_id=b.incoming_stylecolor_id 
    and a.cccolor=b.cccolor 
    and a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.stylecolor_type=b.stylecolor_type
    and a.jsessionid=b.jsessionid 
    and a.jsessionid in (select jsid from t1);

    drop table if exists chetan_cart_stylecolorsize;
    CREATE TABLE chetan_cart_stylecolorsize AS 
    SELECT 
           case when stylecolor_type='similar' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id 
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
          FROM   cart_master_temp a 
                 , exp01_ma_sizeattributes b 
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x; 

RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

delete from exp01_d_product where id in (select final_style_id from chetan_cart_style WHERE style_type='similar' and jsessionid in (select jsid from t1));
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_style_id AS id 
       , COALESCE(displayed_style_name, 'S5-' || nextval('style_sequence') || '-' || displayed_style_name) AS NAME 
       , COALESCE(displayed_style_description, 'S5-' || nextval('style_sequence') || '-' || displayed_style_description) AS description 
       , 'style' AS levelid 
    FROM   chetan_cart_style
    WHERE style_type='similar'; 

delete from exp01_d_product where id in (select distinct final_stylecolor_id from chetan_cart_stylecolor WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));  
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_stylecolor_id              AS id 
           , displayed_stylecolor_name        AS NAME 
           , displayed_stylecolor_description AS description 
           , 'stylecolor'             AS levelid 
    FROM   chetan_cart_stylecolor 
    WHERE stylecolor_type='similar';    

delete from exp01_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_stylecolorsize_id            AS id 
           , size_name        AS NAME 
           , size_description AS description 
           , 'stylecolorsize'           AS levelid 
    FROM   chetan_cart_stylecolorsize
    WHERE stylecolor_type='similar';

-- CREATING HIERARCHY

delete from exp01_h_prodstd where id in (select distinct final_style_id from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_style_id 
                , ancestor0 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE style_type='similar'
and a.incoming_style_id = b.id; 

delete from exp01_h_prodstd where id in (select distinct final_stylecolor_id from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1));
INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolor_id
                , final_style_id 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp  a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE stylecolor_type='similar'
and a.incoming_stylecolor_id = b.id; 

delete from exp01_h_prodstd where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize where stylecolor_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolorsize_id 
                , final_stylecolor_id
                , ancestor0
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
FROM   chetan_cart_stylecolorsize a, 
exp01_h_prodstd b
WHERE stylecolor_type='similar'
and a.final_stylecolor_id = b.id; 

RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();

delete from exp01_ma_styleattributes where product in (select distinct final_style_id from cart_master_temp WHERE style_type = 'similar' and jsessionid in (select jsid from t1));

-- updating cccolor and cccolorfamily

update cart_master_temp a set cccolorfamily = b.target_value from exp01_l_dependencylookup b where b.lookup_id='cccolor' and lookup_value=a.cccolor;

delete from exp01_l_dependencylookup where target_id='patternedtostyle' and target_value in (select distinct final_style_id from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1));
delete from exp01_l_dependencylookup where target_id='patternedtostylecolor' and target_value in (select distinct final_stylecolor_id from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1));

insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct 'style' as lookup_id, incoming_style_id as lookup_value, 'patternedtostyle' target_id, final_style_id as target_value 
from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1);

insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct 'stylecolor' as lookup_id, incoming_stylecolor_id as lookup_value, 'patternedtostylecolor' target_id, final_stylecolor_id as target_value 
from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1);

-- STYLE ATTRIBUTES
INSERT INTO exp01_ma_styleattributes 
            (product 
             , ccfit 
             , cclegshape 
             , cclegskirtdresslength 
             , ccneckline 
             , ccsleevelength 
             , ccsilhouette 
             , ccproductdetail 
             --, ccfashiontier 
             , cctested 
             , cclifestyle 
             , ccrise 
             , ccgraphictheme 
             , ccdevelopmentpath 
             , ccstylegroup 
             , ccsuits 
             , ccfabric 
             , ccgender 
             , cchangingnonhanging 
             , cctopbottom 
             , ccseason 
             , ccmarketingimage 
             , cchazmat 
             , ccgoh 
             , ccdresses 
             , ccfibertype 
             , cctickettype 
             , ccpricingtier 
             , ccrangecode 
             , ccdenimwash 
             , ccprintpattern 
             , cclicense 
             , ccticketprice 
             , ccsubclassid 
             , ccsubclassname 
             , ccstylecreatedate 
             , ccspecstylestyle 
             , style_insight 
             , ccclassname 
             , ccpowerdrivername 
             , ccdepartmentname 
             , isstyleremovable) 
SELECT final_style_id as product
             , b.ccfit 
             , b.cclegshape 
             , b.cclegskirtdresslength 
             , b.ccneckline 
             , b.ccsleevelength 
             , b.ccsilhouette 
             , b.ccproductdetail 
             --, b.ccfashiontier 
             , b.cctested 
             , b.cclifestyle 
             , b.ccrise 
             , b.ccgraphictheme 
             , b.ccdevelopmentpath 
             , b.ccstylegroup 
             , b.ccsuits 
             , b.ccfabric 
             , b.ccgender 
             , b.cchangingnonhanging 
             , b.cctopbottom 
             , b.ccseason 
             , b.ccmarketingimage 
             , b.cchazmat 
             , b.ccgoh 
             , b.ccdresses 
             , b.ccfibertype 
             , b.cctickettype 
             , b.ccpricingtier 
             , b.ccrangecode 
             , b.ccdenimwash 
             , b.ccprintpattern 
             , b.cclicense 
             , b.ccticketprice 
             , b.ccsubclassid 
             , b.ccsubclassname 
             , b.ccstylecreatedate 
             , b.ccspecstylestyle 
             , b.style_insight 
             , b.ccclassname 
             , b.ccpowerdrivername 
             , b.ccdepartmentname
             , 'true'
from (select distinct final_style_id, style_type, incoming_style_id from cart_master_temp) a, exp01_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type='similar';

-- STYLECOLOR ATTRIBUTES

delete from exp01_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from cart_master_temp WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));
select * from exp01_ma_stylecolorattributes ems  limit 1;
INSERT INTO exp01_ma_stylecolorattributes 
        (product 
       , ccfloorset 
       , ccstoretier 
       , ccmarkdownflag 
       , ccprintid 
       , ccmos 
       , ccrecall 
       , ccunavailable 
       , cccolorid 
       , cccolor 
       , cccolorfamily 
       , cccurp 
       , ccspecstylestyleclr 
       , ccstylecolorcreatedate 
       , ccinsight 
       , ccactslsrnk
       , ccfashiontier
       , ishistory 
       , isassortment 
       , isdesign 
       , isforecastable 
       , inqueue 
       , islocked 
       , isremovable ) 
SELECT final_stylecolor_id as product
       , b.ccfloorset 
       , b.ccstoretier 
       , b.ccmarkdownflag 
       , b.ccprintid 
       , b.ccmos 
       , b.ccrecall 
       , b.ccunavailable 
       , a.cccolorid 
       , a.cccolor 
       , a.cccolorfamily 
       , b.cccurp 
       , b.ccspecstylestyleclr 
       , b.ccstylecolorcreatedate 
       , b.ccinsight 
       , b.ccactslsrnk
       , b.ccfashiontier
       , 'false' 
       , 'true'
       , 'false'
       , 'false'
       , 'false'
       , 'false' 
       , 'true'
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as cccolorid  from cart_master_temp) a, exp01_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type='similar';

-- SIZE ATTRIBUTES
delete from exp01_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));
insert into exp01_ma_sizeattributes
    (product,
    sizeattribute,
    parent_id
    )
SELECT 
    distinct final_stylecolorsize_id,
    size_name,
    final_stylecolor_id
FROM
    chetan_cart_stylecolorsize
WHERE stylecolor_type = 'similar';

RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();

-- STYLECOLOR CHANNEL ATTRIBUTES

drop table if exists default_cart_prams;
create table default_cart_prams as 
select 
  ''||$1||''  as jsessionid
  , scope_product
  , scope_location
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
from cart_params 
where jsessionid=''||$1||''
and scope_product=''||$2||''
and scope_location=''||$3||''
and scope_start=''||$4||''
;

drop table if exists temp_exp01_ma_stylecolorchannelattributes;
create table temp_exp01_ma_stylecolorchannelattributes as 
select 
     ''||$1||'' as jsessionid 
  ,  final_stylecolor_id as product
  , ''||$3||'' as location

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
  , coalesce(ccordpolicy, default_ccordpolicy) ccordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='') then 'class_default' else ssnprf end
  , validsizes
  , coalesce(presmin, default_presmin) presmin
  , coalesce(presmin_weeks, default_presmin_weeks) presmin_weeks
  , coalesce(ccrcptint::int,default_ccrcptint::int) ccrcptint
  , coalesce(ccordermultiple::int,default_ccordermultiple::int) ccordermultiple

--  , strmenscapacity
--  , strwomenscapacity
--  , strcorpvoltier
--  , strclimate
--  , grade
--  , ssg
--  , flnrange 
--  , 'plan' as plan_type
--  , final_style_id as style
FROM 
default_cart_prams a, exp01_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from cart_master_temp) c
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid;

delete from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'');

INSERT  into exp01_ma_stylecolorchannelattributes (
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple)
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple 
FROM 
temp_exp01_ma_stylecolorchannelattributes;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

-- ASSORTMENT MODEL
delete from exp01_a_assortment where (product, location) in (select product,location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'') and plan_type='plan';

    insert into exp01_a_assortment (
          product
        , location
        , "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , plan_type
        , isfunded
        , style )
    SELECT 
        final_stylecolor_id as product
        , scope_location as location
        , scope_floorset as "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , 'plan' as plan_type
        , isfunded
        , final_style_id as style
    FROM 
    default_cart_prams a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from cart_master_temp) c
    where a.jsessionid=c.jsessionid 
    ;


RAISE NOTICE 'ENd Assortment Model:%', 'START:'|| now();

insert into plan_queue (jsessionid, tenantid, product, location, status, initiator, initiated_at)
select jsessionid, 'exp01', final_stylecolor_id, ''||$3||'', 'queued', initiator, now() from cart_master_temp where jsessionid=''||$1||'';

update cart_master set isProcessed=1 where jsessionid=''||$1||'';

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();

 RETURN;
END;
$_$;


ALTER FUNCTION public.add_to_assortment_2(input_jsessionid text, scope_department text, scope_location text, scope_start text) OWNER TO psql;

--
-- TOC entry 1650 (class 1255 OID 81992469)
-- Name: add_to_assortment_temp(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.add_to_assortment_temp(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE

s1 text;
s2 text;
s3 text;
s4 text;
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
s29 text;
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
s40 text;
s41 text;
s42 text;
s43 text;
s44 text;
s45 text;
s46 text;
s47 text;
s48 text;
s49 text;

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
table_ma_imgattr := 'table_ma_imgattr'||v_uuid;
table_temp_assort := 'table_temp_assort'||v_uuid;


s1 := 'create temporary table '||table_input_t1||' as select '''||$1||''' as jsid,'''||$2||''' as scope_product,'''||$3||''' as scope_location ,'''||$4||''' as scope_start,'''||$5||''' as scope_floorset 
    ';
EXECUTE s1;

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

s4 := '
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




EXECUTE s4;

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
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor, ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) as color_id
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
                 , exp01_ma_sizeattributes b 
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x
          '
          ; 



EXECUTE s7;

RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

s8 := 'delete from exp01_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';
EXECUTE s8;

s9 := '
    INSERT INTO exp01_d_product 
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


   
EXECUTE s9;

s10 := '
delete from exp01_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';
EXECUTE s10;

s11 := '
    INSERT INTO exp01_d_product 
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


   
EXECUTE s11;

s12 := '
delete from exp01_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s13 := '
    INSERT INTO exp01_d_product 
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


   
EXECUTE s13;
-- CREATING HIERARCHY

s14 := '
delete from exp01_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';
EXECUTE s14;


s15 := '
INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_style_id 
                , ancestor0 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   '||table_cart_master_temp||' a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
'
; 


EXECUTE s15;

s16 := '
delete from exp01_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

EXECUTE s16;

s17 := '
INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolor_id
                , final_style_id 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   '||table_cart_master_temp||'   a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
'
; 


EXECUTE s17;

s18 := '
delete from exp01_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolorsize_id 
                , final_stylecolor_id
                , ancestor0
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
FROM    '||table_cart_stylecolorsize||'  a, 
exp01_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
; 


EXECUTE s19;


RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();

s20 := '
delete from exp01_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily

s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from exp01_l_dependencylookup b where b.lookup_id=''cccolor'' and lookup_value=a.cccolor
';


s22 := '
delete from exp01_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s23 := '
delete from exp01_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

EXECUTE s20;
EXECUTE s21;
EXECUTE s22;
EXECUTE s23;


s24 := '
insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value 
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';
EXECUTE s24;

s25 := '
insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value 
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';

EXECUTE s25;

-- STYLE ATTRIBUTES

S26 := '
INSERT INTO exp01_ma_styleattributes 
            (product 
             , ccfit 
             , cclegshape 
             , cclegskirtdresslength 
             , ccneckline 
             , ccsleevelength 
             , ccsilhouette 
             , ccproductdetail 
             , ccfashiontier 
             , cctested 
             , cclifestyle 
             , ccrise 
             , ccgraphictheme 
             , ccdevelopmentpath 
             , ccstylegroup 
             , ccsuits 
             , ccfabric 
             , ccgender 
             , cchangingnonhanging 
             , cctopbottom 
             , ccseason 
             , ccmarketingimage 
             , cchazmat 
             , ccgoh 
             , ccdresses 
             , ccfibertype 
             , cctickettype 
             , ccpricingtier 
             , ccrangecode 
             , ccdenimwash 
             , ccprintpattern 
             , cclicense 
             , ccticketprice 
             , ccsubclassid 
             , ccsubclassname 
             , ccstylecreatedate 
             , ccspecstylestyle 
             , style_insight 
             , ccclassname 
             , ccpowerdrivername 
             , ccdepartmentname 
             , isstyleremovable) 
SELECT final_style_id as product
             , b.ccfit 
             , b.cclegshape 
             , b.cclegskirtdresslength 
             , b.ccneckline 
             , b.ccsleevelength 
             , b.ccsilhouette 
             , b.ccproductdetail 
             , b.ccfashiontier 
             , b.cctested 
             , b.cclifestyle 
             , b.ccrise 
             , b.ccgraphictheme 
             , b.ccdevelopmentpath 
             , b.ccstylegroup 
             , b.ccsuits 
             , b.ccfabric 
             , b.ccgender 
             , b.cchangingnonhanging 
             , b.cctopbottom 
             , b.ccseason 
             , b.ccmarketingimage 
             , b.cchazmat 
             , b.ccgoh 
             , b.ccdresses 
             , b.ccfibertype 
             , b.cctickettype 
             , b.ccpricingtier 
             , b.ccrangecode 
             , b.ccdenimwash 
             , b.ccprintpattern 
             , b.cclicense 
             , b.ccticketprice 
             , b.ccsubclassid 
             , b.ccsubclassname 
             , b.ccstylecreatedate 
             , b.ccspecstylestyle 
             , b.style_insight 
             , b.ccclassname 
             , b.ccpowerdrivername 
             , b.ccdepartmentname
             , ''true''
from (select distinct final_style_id, style_type, incoming_style_id from '||table_cart_master_temp||') a, exp01_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
';

EXECUTE s26;

-- STYLECOLOR ATTRIBUTES

s27 := '
delete from exp01_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

EXECUTE s27;

s28 := '
INSERT INTO exp01_ma_stylecolorattributes 
        (product 
       , ccfloorset 
       , ccstoretier 
       , ccmarkdownflag 
       , ccprintid 
       , ccmos 
       , ccrecall 
       , ccunavailable 
       , cccolorid 
       , cccolor 
       , cccolorfamily 
       , cccurp 
       , ccspecstylestyleclr 
       , ccstylecolorcreatedate 
       , ccinsight 
       , ccactslsrnk 
       , ishistory 
       , isassortment 
       , isdesign 
       , isforecastable 
       , inqueue 
       , islocked 
       , isremovable ) 
SELECT final_stylecolor_id as product
       , b.ccfloorset 
       , b.ccstoretier 
       , b.ccmarkdownflag 
       , b.ccprintid 
       , b.ccmos 
       , b.ccrecall 
       , b.ccunavailable 
       , a.cccolorid 
       , a.cccolor 
       , a.cccolorfamily 
       , b.cccurp 
       , b.ccspecstylestyleclr 
       , b.ccstylecolorcreatedate 
       , b.ccinsight 
       , b.ccactslsrnk 
       , ''false'' 
       , ''true''
       , ''false''
       , ''false''
       , ''false''
       , ''false'' 
       , ''true''
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) as cccolorid  from '||table_cart_master_temp||') a, exp01_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
';

EXECUTE s28;


-- IMAGE ATTRIBUTES START

s29 := 'drop table if exists '||table_ma_imgattr||'';

s30 := '
create temporary table '||table_ma_imgattr||' as
select 
    c.jsessionid 
  , final_stylecolor_id as product
  , b.img as orig_image
  , c.img as cart_image
FROM
  (select distinct product, img from exp01_ma_imgattributes) b, 
  (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, img from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')) c
where 
b.product=c.incoming_stylecolor_id
'
;

EXECUTE s29;
EXECUTE s30;


s31 := '
delete from exp01_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;

s32 := '
insert into exp01_ma_imgattributes (product, img) 
select product, coalesce(cart_image,orig_image) from '||table_ma_imgattr||'
';   

EXECUTE s31;
EXECUTE s32;
                                                                                                                                        
-- IMAGE ATTRIBUTES END


-- SIZE ATTRIBUTES

s33 := '
delete from exp01_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';

EXECUTE s33;

s34 := '
insert into exp01_ma_sizeattributes
    (product,
    sizeattribute,
    parent_id
    )
SELECT 
    distinct final_stylecolorsize_id,
    size_name,
    final_stylecolor_id
FROM
    '||table_cart_stylecolorsize||'
WHERE stylecolor_type = ''similar''
';

EXECUTE s34;

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
from cart_params a, t1 b 
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
  , default_too as too
  , default_mkdnwks as mkdnwks
  , default_last_inv_wk as last_inv_wk
  , default_lstfpwk as lstfpwk
  , default_last_rcpt_wk as last_rcpt_wk
  , default_erlstmkdnwk as erlstmkdnwk
  , default_exitdate as exitdate
  
  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  , coalesce(ccordpolicy, default_ccordpolicy) ccordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , validsizes
  , coalesce(presmin, default_presmin) presmin
  , coalesce(presmin_weeks, default_presmin_weeks) presmin_weeks
  , coalesce(ccrcptint::int,default_ccrcptint::int) ccrcptint
  , coalesce(ccordermultiple::int,default_ccordermultiple::int) ccordermultiple
  , ccexistingwac
  , ccsystemcost

FROM 
'||table_default_cart_params||' a, exp01_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid
';


EXECUTE s36;


s37 := '
delete from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

EXECUTE s37;

s38 := '
INSERT  into exp01_ma_stylecolorchannelattributes (
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple
, ccexistingwac
, ccsystemcost
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple 
, ccexistingwac
, ccsystemcost
FROM 
 '||table_temp_sclr_chnl_attr||' 
 ';
 
EXECUTE s38;


RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

-- ASSORTMENT MODEL

s39 := '
    create temporary table '||table_temp_assort||' AS
    SELECT 
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(strmenscapacity as text[]) as strmenscapacity
        , cast(strwomenscapacity as text[]) as strwomenscapacity
        , cast(strcorpvoltier as text[]) as strcorpvoltier
        , cast(strclimate as text[]) as strclimate
        , cast(grade as text[]) as grade
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
    FROM 
    cart_ranging a, t1 b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from '||table_cart_master_temp||') c
    where a.jsessionid=c.jsessionid 
  and a.jsessionid = b.jsid
  and a.scope_product = b.scope_product
  and a.scope_location = b.scope_location
  and a.scope_start = b.scope_start
    '
    ;

EXECUTE s39;

s40 := '
delete from exp01_a_assortment where (product, location) in (select product,location from '||table_temp_assort||') and plan_type=''plan''
';

EXECUTE s40;

s41 := '

    insert into exp01_a_assortment (
          product
        , location
        , "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , plan_type
        , isfunded)
    SELECT 
          product
        , location
        , "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , plan_type
        , isfunded
    FROM 
       '||table_temp_assort||'
';

EXECUTE s41;

RAISE NOTICE 'END Assortment Model:%', 'START:'|| now();




s42 := '
select distinct a.product, a.location
from 
(select distinct product,location  from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||')) a,
(select distinct product,location  from exp01_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
where 
a.product=b.product
and a.location=b.location
';

EXECUTE s42;
               
s43 := '               
insert into plan_queue (jsessionid, tenantid, product, location, status, initiator, initiated_at)
select jsessionid, ''exp01'', final_stylecolor_id, '''||$3||''', ''staged'', initiator, now() from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
and (final_stylecolor_id, '''||$3||''') in (select product, location from final_list)
';

EXECUTE s43;

s44 := 'update cart_master set isProcessed=1 where jsessionid in (select jsid from  '||table_input_t1||')';

EXECUTE s44;

insert into debug_stats_ts values ('s1',s1,now());
insert into debug_stats_ts values ('s2',s2,now());
insert into debug_stats_ts values ('s3',s3,now());
insert into debug_stats_ts values ('s4',s4,now());
insert into debug_stats_ts values ('s5',s5,now());
insert into debug_stats_ts values ('s6',s6,now());
insert into debug_stats_ts values ('s7',s7,now());
insert into debug_stats_ts values ('s8',s8,now());
insert into debug_stats_ts values ('s9',s9,now());
insert into debug_stats_ts values ('s10',s10,now());
insert into debug_stats_ts values ('s11',s11,now());
insert into debug_stats_ts values ('s12',s12,now());
insert into debug_stats_ts values ('s13',s13,now());
insert into debug_stats_ts values ('s14',s14,now());
insert into debug_stats_ts values ('s15',s15,now());
insert into debug_stats_ts values ('s16',s16,now());
insert into debug_stats_ts values ('s17',s17,now());
insert into debug_stats_ts values ('s18',s18,now());
insert into debug_stats_ts values ('s19',s19,now());
insert into debug_stats_ts values ('s20',s20,now());
insert into debug_stats_ts values ('s21',s21,now());
insert into debug_stats_ts values ('s22',s22,now());
insert into debug_stats_ts values ('s23',s23,now());
insert into debug_stats_ts values ('s24',s24,now());
insert into debug_stats_ts values ('s25',s25,now());
insert into debug_stats_ts values ('s26',s26,now());
insert into debug_stats_ts values ('s27',s27,now());
insert into debug_stats_ts values ('s28',s28,now());
insert into debug_stats_ts values ('s29',s29,now());
insert into debug_stats_ts values ('s30',s30,now());
insert into debug_stats_ts values ('s31',s31,now());
insert into debug_stats_ts values ('s32',s32,now());
insert into debug_stats_ts values ('s33',s33,now());
insert into debug_stats_ts values ('s34',s34,now());
insert into debug_stats_ts values ('s35',s35,now());
insert into debug_stats_ts values ('s36',s36,now());
insert into debug_stats_ts values ('s37',s37,now());
insert into debug_stats_ts values ('s38',s38,now());
insert into debug_stats_ts values ('s39',s39,now());
insert into debug_stats_ts values ('s41',s41,now());
insert into debug_stats_ts values ('s42',s42,now());
insert into debug_stats_ts values ('s43',s43,now());
insert into debug_stats_ts values ('s44',s44,now());


RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();

 RETURN;
END;
$_$;


ALTER FUNCTION public.add_to_assortment_temp(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 1665 (class 1255 OID 81992471)
-- Name: assortment_blank_checks(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.assortment_blank_checks() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    is_grade int;
    is_strclimate int;
    is_strmenscapacity int;
    is_strwomenscapacity int;
    is_ssg int;
    
    v_product text;
    v_location text;
    v_time text;
    
    update_grade text;
    update_strclimate text;
    update_strmenscapacity text;
    update_strwomenscapacity text;

BEGIN

    v_product := NEW.product;
    v_location := NEW.location;
    v_time := NEW.time;
    
    EXECUTE '(select case when grade=''{}'' or grade=''{""}'' then 1 else 0 end from exp01_a_assortment where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan'' and ssg = ''{""}'')' into is_grade;
    EXECUTE '(select case when strclimate=''{}'' or strclimate=''{""}'' then 1 else 0 end from exp01_a_assortment where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan'' and ssg = ''{""}'')' into is_strclimate;
    EXECUTE '(select case when strmenscapacity=''{}'' or strmenscapacity=''{""}'' then 1 else 0 end from exp01_a_assortment where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan'' and ssg = ''{""}'')' into is_strmenscapacity;
    EXECUTE '(select case when strwomenscapacity=''{}'' or strwomenscapacity=''{""}'' then 1 else 0 end from exp01_a_assortment where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan'' and ssg = ''{""}'')' into is_strwomenscapacity;
  
  update_grade := 'update exp01_a_assortment set grade=''{A}'' where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan''';
  update_strclimate := 'update exp01_a_assortment set strclimate=''{COLD}'' where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan''';
  update_strmenscapacity := 'update exp01_a_assortment set strmenscapacity=''{AVERAGE}'' where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan''';
  update_strwomenscapacity := 'update exp01_a_assortment set strwomenscapacity=''{AVERAGE}'' where product='''||v_product||''' and location='''||v_location||''' and time='''||v_time||''' and plan_type=''plan''';
  
  
  IF  is_grade = 1
  THEN
  EXECUTE update_grade;
  END IF;
  
  IF  is_strclimate = 1
  THEN
  EXECUTE update_strclimate;
  END IF;
  
  IF  is_strmenscapacity = 1
  THEN
  EXECUTE update_strmenscapacity;
  END IF;
  
  IF  is_strwomenscapacity = 1
  THEN
  EXECUTE update_strwomenscapacity;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.assortment_blank_checks() OWNER TO psql;

--
-- TOC entry 1666 (class 1255 OID 81992472)
-- Name: blank_stylecolorid(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.blank_stylecolorid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  Update cart_master a set stylecolor_id=b.conceptstylecolorid
  from exp01_ma_subclassattributes b
  where a.style_id=b.conceptstyleid
  and (a.stylecolor_id is null or a.stylecolor_id ='');
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.blank_stylecolorid() OWNER TO psql;

--
-- TOC entry 1667 (class 1255 OID 81992473)
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
      (select slsstart from public.exp01_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strmenscapacity)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strwomenscapacity)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strclimate)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','),
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM exp01_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 1668 (class 1255 OID 81992474)
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
  scWeekCount_pub = (select COUNT(*) from exp01_p_dc_adj 
   where product = stylecolorId 
   and location = (select dc from exp01_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from exp01_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from exp01_p_dc_adj_size
   where product in (select id from exp01_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from exp01_l_dclookup where channel = channelId)
   and (dc_onorder > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 1669 (class 1255 OID 81992475)
-- Name: copy_inserted_cart_master(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.copy_inserted_cart_master() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  INSERT into cart_master_mark
  SELECT (NEW).*;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.copy_inserted_cart_master() OWNER TO psql;

--
-- TOC entry 1670 (class 1255 OID 81992476)
-- Name: copy_inserted_cart_params(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.copy_inserted_cart_params() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  INSERT into cart_params_mark
  SELECT (NEW).*;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.copy_inserted_cart_params() OWNER TO psql;

--
-- TOC entry 1671 (class 1255 OID 81992477)
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
-- TOC entry 1672 (class 1255 OID 81992478)
-- Name: create_hidden_ccsizerange_mod(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.create_hidden_ccsizerange_mod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

v_ccrangecode text;
v_validsizes text[];

s0 text;
s1 text;
s2 text;
s3 text;
s4 text;
s5 text;
s3_exists text;
s6 text;

v_uuid_temp text;
v_uuid text;

table_temp_sub_exists text;
table_temp_sub_not_exists text;

v_style text;
v_old_ccsizerange text;
v_new_ccsizerange text;
exists_count int;
v_old_express_size_range text;

BEGIN

-- this part is specific to style attribute express_size_range changing
-- need to make another rendition of this for class changing

if NEW.express_size_range <> OLD.express_size_range and OLD.ccstylecreatedate is null then

  select id into v_style from exp01_d_product where levelid='style' and id=NEW.product;
  select  OLD.express_size_range into v_old_express_size_range;
  
  select NEW.express_size_range||'-'||ancestor1 into v_new_ccsizerange
  from
      exp01_h_prodstd
  where
      id=v_style
  limit 1;
  
  select ccsizerange into v_old_ccsizerange from exp01_ma_styleattributes where product=v_style limit 1;
  
  
  EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
  EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
  
  table_temp_sub_exists:= 'table_temp_sub_exists'||v_uuid;
  table_temp_sub_not_exists:= 'table_temp_sub_not_exists'||v_uuid;
  
  -- update ccsizerange based on updated express_size_range and or class info
  
  
  s0 := 'create temporary table '||table_temp_sub_exists||' as
      select a.product, a.ccrangecode as old_profile_id, b.sub_size_range as old_sub_size_range, '''||v_old_ccsizerange||''' as   old_size_range_class, '''||v_new_ccsizerange||''' new_size_range_class
      , null::text as new_sub_size_range, null::text as new_profile_id
      from exp01_ma_stylecolorchannelattributes a, (select distinct size_range_class, sub_size_range, profile_id from   s5_profile_master where size_range_class='''||v_old_ccsizerange||''') b
      where product in (select id from exp01_h_prodstd where ancestor0='''||v_style||''')
      and a.ccrangecode=b.profile_id
      ';
  -- RAISE NOTICE 'S0:%', 'START:'|| s0;
  
  s1 := 'update '||table_temp_sub_exists||' a
      set new_sub_size_range = b.sub_size_range
      , new_profile_id = b.profile_id
      from (select distinct size_range_class, sub_size_range, profile_id from s5_profile_master where   size_range_class='''||v_new_ccsizerange||''') b
      where
          a.new_size_range_class=b.size_range_class
      and a.old_sub_size_range=b.sub_size_range
      ';
  
  -- RAISE NOTICE 'S1:%', 'START:'|| s1;
  
  s2 := 'update '||table_temp_sub_exists||' a
      set new_sub_size_range = b.sub_size_range
      , new_profile_id = b.profile_id
      from s5_profile_master_max_default b
      where
          a.new_size_range_class=b.size_range_class
      and (a.new_profile_id is null or a.new_sub_size_range is null)
      ';
  -- RAISE NOTICE 'S2:%', 'START:'|| s2;
  
  
  
  s3_exists := 'select count(*) from '||table_temp_sub_exists||' where  new_profile_id is not null
  ';
  
  -- RAISE NOTICE 'S3:%', 'START:'|| s3_exists;
  
  
  s4 := 'update exp01_ma_styleattributes x set ccsizerange = '''||v_new_ccsizerange||''' where product = '''||v_style||'''
  ';
  
  -- RAISE NOTICE 'S4:%', 'START:'|| s4;
  
  s5 := 'UPDATE exp01_ma_stylecolorchannelattributes a
  set ccrangecode=b.new_profile_id
  from '||table_temp_sub_exists||' b
  where a.product=b.product
  and b.new_profile_id is not null
  and a.product in (select product from '||table_temp_sub_exists||' where new_profile_id is not null)
  ';
  
  -- RAISE NOTICE 'S5:%', 'START:'|| s5;
  
  
  s6 := 'update exp01_ma_styleattributes x set express_size_range = '''||v_old_express_size_range||''' where product =   '''||v_style||'''
  ';
  -- RAISE NOTICE 'S6:%', 'START:'|| s6;
  
  EXECUTE s0;
  EXECUTE s1;
  EXECUTE s2;
  
  EXECUTE s3_exists into exists_count;
  
  -- RAISE NOTICE 'S3_EXISTS:%', 'START:'|| exists_count;
  
  if
      exists_count >= 1
  THEN
      EXECUTE s4;
      EXECUTE s5;
  ELSE
      EXECUTE s6;
  END IF;

ELSE

  update exp01_ma_styleattributes set express_size_range = OLD.express_size_range where product = NEW.product;

end if;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.create_hidden_ccsizerange_mod() OWNER TO psql;

--
-- TOC entry 1673 (class 1255 OID 81992479)
-- Name: create_hidden_class_ccsizerange_mod(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.create_hidden_class_ccsizerange_mod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

v_ccrangecode text;
v_validsizes text[];

s0 text;
s1 text;
s2 text;
s2_x text;
s3 text;
s4 text;
s5 text;
s3_exists text;
s6 text;

v_uuid_temp text;
v_uuid text;

table_temp_sub_exists text;
table_temp_sub_not_exists text;

v_style text;
v_old_ccsizerange text;
v_new_ccsizerange text;
exists_count int;
v_old_express_size_range text;

BEGIN

-- this part is specific to style attribute express_size_range changing
-- need to make another rendition of this for class changing

select id into v_style from exp01_d_product where levelid='style' and id=NEW.id;
select  express_size_range into v_old_express_size_range from exp01_ma_styleattributes where product=v_style limit 1 ;

select express_size_range||'-'||NEW.ancestor1 into v_new_ccsizerange
from
    exp01_ma_styleattributes a,
    exp01_h_prodstd b
where
    id=v_style
and a.product = b.id
limit 1;

select ccsizerange into v_old_ccsizerange from exp01_ma_styleattributes where product=v_style limit 1;


EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_temp_sub_exists:= 'table_temp_sub_exists'||v_uuid;
table_temp_sub_not_exists:= 'table_temp_sub_not_exists'||v_uuid;

-- update ccsizerange based on updated express_size_range and or class info


s0 := 'create temporary table '||table_temp_sub_exists||' as
    select a.product, a.ccrangecode as old_profile_id, b.sub_size_range as old_sub_size_range, '''||v_old_ccsizerange||''' as old_size_range_class, '''||v_new_ccsizerange||''' new_size_range_class
    , null::text as new_sub_size_range, null::text as new_profile_id
    from exp01_ma_stylecolorchannelattributes a, (select distinct size_range_class, sub_size_range, profile_id from s5_profile_master where size_range_class='''||v_old_ccsizerange||''') b
    where product in (select id from exp01_h_prodstd where ancestor0='''||v_style||''')
    and a.ccrangecode=b.profile_id
    ';
-- RAISE NOTICE 'S0:%', 'START:'|| s0;

s1 := 'update '||table_temp_sub_exists||' a
    set new_sub_size_range = b.sub_size_range
    , new_profile_id = b.profile_id
    from (select distinct size_range_class, sub_size_range, profile_id from s5_profile_master where size_range_class='''||v_new_ccsizerange||''') b
    where
        a.new_size_range_class=b.size_range_class
    and a.old_sub_size_range=b.sub_size_range
    ';

-- RAISE NOTICE 'S1:%', 'START:'|| s1;

s2 := 'update '||table_temp_sub_exists||' a
    set new_sub_size_range = b.sub_size_range
    , new_profile_id = b.profile_id
    from s5_profile_master_max_default b
    where
        a.new_size_range_class=b.size_range_class
    and (a.new_profile_id is null or a.new_sub_size_range is null)
    ';
-- RAISE NOTICE 'S2:%', 'START:'|| s2;

s2_x := 'update '||table_temp_sub_exists||' a
    set
      new_sub_size_range = b.sub_size_range
    , new_profile_id = b.profile_id
    , new_size_range_class = b.size_range_class
    from (select x.* from
                (select *, substring(size_range_class,length(size_range_class)-6,length(size_range_class))  as class from s5_profile_master_max_default) x
                , '||table_temp_sub_exists||' y
             where
                x.class =substring(y.new_size_range_class,length(y.new_size_range_class)-6,length(y.new_size_range_class))
                limit 1
        ) b
    where
        (a.new_profile_id is null or a.new_sub_size_range is null)
    ';
-- RAISE NOTICE 'S2:%', 'START:'|| s2_x;


s3_exists := 'select count(*) from '||table_temp_sub_exists||' where  new_profile_id is not null
';

-- RAISE NOTICE 'S3:%', 'START:'|| s3_exists;


s4 := 'update exp01_ma_styleattributes a set ccsizerange = b.new_size_range_class
      , express_size_range= substring(b.new_size_range_class,1, length(b.new_size_range_class)-8)
      FROM (select * from '||table_temp_sub_exists||'  limit 1) b
      where a.product = '''||v_style||'''
';

-- RAISE NOTICE 'S4:%', 'START:'|| s4;

s5 := 'UPDATE exp01_ma_stylecolorchannelattributes a
set ccrangecode=b.new_profile_id
from '||table_temp_sub_exists||' b
where a.product=b.product
and b.new_profile_id is not null
and a.product in (select product from '||table_temp_sub_exists||' where new_profile_id is not null)
';

-- RAISE NOTICE 'S5:%', 'START:'|| s5;


s6 := 'update exp01_ma_styleattributes x set express_size_range = '''||v_old_express_size_range||''' where product = '''||v_style||'''
';
-- RAISE NOTICE 'S6:%', 'START:'|| s6;

EXECUTE s0;
EXECUTE s1;
EXECUTE s2;
EXECUTE s2_x;

EXECUTE s3_exists into exists_count;

-- RAISE NOTICE 'S3_EXISTS:%', 'START:'|| exists_count;

if
    exists_count >= 1
THEN
    EXECUTE s4;
    EXECUTE s5;
END IF;


RETURN NEW;

END;
$$;


ALTER FUNCTION public.create_hidden_class_ccsizerange_mod() OWNER TO psql;

--
-- TOC entry 1674 (class 1255 OID 81992480)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN

              UPDATE exp01_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
              WHERE product=NEW.product
              ;
    RETURN NEW;
    END;
    $$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1646 (class 1255 OID 81992481)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from exp01_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 1675 (class 1255 OID 81992482)
-- Name: efo_lookup(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.efo_lookup() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
tr_image_attr text;
tr_efo_rtl_tktprc text;
tr_efo_rtl_wac text;
tr_efo_rtl_imu text;
act_productid text;
BEGIN

select id into act_productid from exp01_d_product where name = NEW.retail_stylecolor_efo limit 1;

select img into tr_image_attr from exp01_ma_imgattributes where product=act_productid limit 1;

select ccticketprice::text into tr_efo_rtl_tktprc from exp01_ma_styleattributes where product in (select ancestor0 from exp01_h_prodstd where id=act_productid);

select ccexistingwac::text, ccimupct::text into tr_efo_rtl_wac,tr_efo_rtl_imu from exp01_ma_stylecolorchannelattributes where product=act_productid and location='GP-01' limit 1;

EXECUTE 'delete from exp01_ma_imgattributes where product=$1;'
USING NEW.product;

EXECUTE 'insert into exp01_ma_imgattributes (product, img) values ($1,$2);'
USING NEW.product,tr_image_attr;

EXECUTE 'UPDATE exp01_ma_stylecolorattributes set efo_rtl_tktprc=$1::text,efo_rtl_wac=$2::text,efo_rtl_imu=$3::text where product = $4;'
USING tr_efo_rtl_tktprc,tr_efo_rtl_wac, tr_efo_rtl_imu, NEW.product;


RETURN NEW;

END;
$_$;


ALTER FUNCTION public.efo_lookup() OWNER TO psql;

--
-- TOC entry 1676 (class 1255 OID 81992483)
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
-- TOC entry 1677 (class 1255 OID 81992484)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE exp01_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1678 (class 1255 OID 81992485)
-- Name: fetch_store_count(text, text, text[], text[], text[], text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text, strmenscapacity text[], strwomenscapacity text[], strclimate text[], grade text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE                                                                                                                                                                                                                                                                              
  sls_start     text;                                                                                                                                                       
  dept_var      text;
BEGIN
 select ancestor3 into dept_var                                                                                                                                             
 from exp01_h_prodstd where id = productId;                                                                                                                                    
                                                                                                                                                                            
 select a.slsstart into sls_start          
 from exp01_ma_dptflrsetattributes a          
 where time = floorsetId and product = dept_var;

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
                public.exp01_l_storelookup
              WHERE
                time = sls_start
                AND product = dept_var
                AND id = 'strmenscapacity'
                AND value=ANY( strmenscapacity )
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
                public.exp01_l_storelookup
              WHERE
                time = sls_start
                AND product = dept_var
                AND id = 'strclimate'
                AND value = ANY( strclimate )
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
              public.exp01_l_storelookup
            WHERE
              time = sls_start
              AND product = dept_var
              AND id = 'strwomenscapacity'
              AND value = ANY( strwomenscapacity )
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
            public.exp01_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'grade'
            AND value = ANY( grade )
        ) as gr
    ) as gr USING (store)
  )
 );

 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text, strmenscapacity text[], strwomenscapacity text[], strclimate text[], grade text[]) OWNER TO psql;

--
-- TOC entry 1679 (class 1255 OID 81992486)
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
-- TOC entry 1680 (class 1255 OID 81992487)
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
from exp01_ma_dptflrsetattributes b
where b.product = NEW.scope_product
--and a.location = NEW.scope_location
and b.time = NEW.scope_floorset;

/*
update cart_params a set initrcptwk = greatest(initrcptwk, b.value) from (select value from exp01_serviceparams where id='plan_current') b
where a.product=NEW.scope_product;
update cart_params a set dbt_wk = greatest(dbt_wk, b.value) from (select value from exp01_serviceparams where id='plan_current') b
where a.product=NEW.scope_product;
*/

delete from cart_ranging b  
where 
b.scope_product = NEW.scope_product
and b.scope_location = NEW.scope_location
and b.scope_floorset = NEW.scope_floorset;

insert into cart_ranging 
(jsessionid,scope_product,scope_location,scope_start,scope_floorset
 ,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded)
select 
NEW.jsessionid,product,NEW.scope_location,NEW.scope_start,time, 
default_strmenscapacity,default_strwomenscapacity,default_strcorpvoltier,default_strclimate,default_grade,default_ssg,default_flnrange,isfunded
FROM (
select product, time, default_strmenscapacity,default_strwomenscapacity,default_strcorpvoltier,default_strclimate,default_grade,default_ssg,default_flnrange
	,1 as isfunded
FROM exp01_ma_dptflrsetattributes
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
-- TOC entry 1681 (class 1255 OID 81992488)
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
          exp01_ma_dptflrsetattributes 
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
		 ,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, indx, store_count)
		select 
		'''||$1||''',product,'''||$3||''','''||$4||''',time, 
		  default_strmenscapacity
		, default_strwomenscapacity
		, default_strcorpvoltier
		, default_strclimate
		, default_grade
		, default_ssg
		, default_flnrange
		, isfunded
		, indx
        , store_count
		FROM (
		select product, time, default_strmenscapacity,default_strwomenscapacity,default_strcorpvoltier,default_strclimate,default_grade,default_ssg,default_flnrange
			,1 as isfunded, a.indx, a.default_store_count as store_count
		FROM exp01_ma_dptflrsetattributes a, cart_params b,
			(select value as plan_current from exp01_serviceparams where id=''plan_current'') c,
			(select value as plan_end from exp01_serviceparams where id=''plan_end'') d
		where 
		b.jsessionid = '''||$1||'''
		and b.scope_product = '''||$2||'''
		and b.scope_location = '''||$3||'''
		and a.product = b.scope_product
	    and a.ap_start <= least(d.plan_end,b.exitdate) and a.ap_end > greatest(b.dbt_wk,c.plan_current)
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
-- TOC entry 1682 (class 1255 OID 81992489)
-- Name: get_store_count(text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, productval text) RETURNS integer
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
                public.exp01_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strmenscapacity'
                AND value in ('N/A', 'SMALL', 'AVERAGE', 'LARGE', 'ECOMM')
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
                public.exp01_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strclimate'
                AND value in ('TEMPERATE', 'COLD', 'HOT', 'N/A', 'ECOMM', 'BEACH')
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
              public.exp01_l_storelookup
            WHERE
              time = week
              AND product = productVal
              AND id = 'strwomenscapacity'
              AND value in ('N/A', 'SMALL', 'AVERAGE', 'LARGE', 'ECOMM')
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
            public.exp01_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'grade'
            AND value in ('A', 'B', 'C', 'ECOM', 'NA')
        ) as gr
    ) as gr USING (store)
  )
 );

 END;
$$;


ALTER FUNCTION public.get_store_count(week text, productval text) OWNER TO psql;

--
-- TOC entry 1683 (class 1255 OID 81992490)
-- Name: get_store_count(text, text[], text[], text[], text[], text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, strmenscapacity text[], strwomenscapacity text[], strclimate text[], grade text[], productval text) RETURNS integer
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
                public.exp01_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strmenscapacity'
                AND value=ANY( strmenscapacity )
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
                public.exp01_l_storelookup
              WHERE
                time = week
                AND product = productVal
                AND id = 'strclimate'
                AND value = ANY( strclimate )
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
              public.exp01_l_storelookup
            WHERE
              time = week
              AND product = productVal
              AND id = 'strwomenscapacity'
              AND value = ANY( strwomenscapacity )
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
            public.exp01_l_storelookup
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


ALTER FUNCTION public.get_store_count(week text, strmenscapacity text[], strwomenscapacity text[], strclimate text[], grade text[], productval text) OWNER TO psql;

--
-- TOC entry 1684 (class 1255 OID 81992491)
-- Name: hasbeenpatterned_afterdelete(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.hasbeenpatterned_afterdelete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE S int;
BEGIN

drop  table if exists temp_delete_style;
drop  table if exists temp_delete_stylecolor;

create table temp_delete_style as select case when cnt > 0 then 1 else 0 END as cnt from (select count(*) cnt from exp01_l_dependencylookup 
where lookup_id='style' and target_id='patternedtostyle' and lookup_value=OLD.lookup_value) b;

create table temp_delete_stylecolor as select case when cnt > 0 then 1 else 0 END as cnt from (select count(*) cnt from exp01_l_dependencylookup 
where lookup_id='stylecolor' and target_id='patternedtostylecolor' and lookup_value=OLD.lookup_value) b;

UPDATE exp01_ma_styleattributes a set hasbeenpatternedafterstyle = cnt from temp_delete_style where product=OLD.lookup_value;
UPDATE exp01_ma_stylecolorattributes a set hasbeenpatternedafter = cnt from temp_delete_stylecolor where product=OLD.lookup_value;

--drop table temp_delete_style;
--drop table temp_delete_stylecolor;


 RETURN NEW;
END;
$$;


ALTER FUNCTION public.hasbeenpatterned_afterdelete() OWNER TO psql;

--
-- TOC entry 1685 (class 1255 OID 81992492)
-- Name: hasbeenpatterned_afterinsert(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.hasbeenpatterned_afterinsert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

drop  table if exists temp_new_style;
drop  table if exists temp_new_stylecolor;

create temporary table temp_new_style as (select lookup_value, count(target_value) count from exp01_l_dependencylookup 
where lookup_id='style' and target_id='patternedtostyle' and lookup_value=NEW.lookup_value group by lookup_value);

create temporary table temp_new_stylecolor as (select lookup_value, count(target_value) count from exp01_l_dependencylookup 
where lookup_id='stylecolor' and target_id='patternedtostylecolor' and lookup_value=NEW.lookup_value group by lookup_value);

UPDATE exp01_ma_styleattributes a set hasbeenpatternedafterstyle = 1 from temp_new_style b where b.count > 0 and a.product=b.lookup_value;
UPDATE exp01_ma_stylecolorattributes a set hasbeenpatternedafter = 1 from temp_new_stylecolor b where b.count > 0 and a.product=b.lookup_value;

drop table temp_new_style;
drop table temp_new_stylecolor;


 RETURN NEW;
END;
$$;


ALTER FUNCTION public.hasbeenpatterned_afterinsert() OWNER TO psql;

--
-- TOC entry 1686 (class 1255 OID 81992493)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from exp01_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 1687 (class 1255 OID 81992494)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

update exp01_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update exp01_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from exp01_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 1688 (class 1255 OID 81992495)
-- Name: log_last_name_changes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.log_last_name_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF NEW.last_name <> OLD.last_name THEN
 INSERT INTO employee_audits(employee_id,last_name,changed_on)
 VALUES(OLD.id,OLD.last_name,now());
 END IF;
 
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_last_name_changes() OWNER TO psql;

--
-- TOC entry 1689 (class 1255 OID 81992496)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE exp01_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 1690 (class 1255 OID 81992497)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN EXECUTE 'NOTIFY pivot_execution_change'; RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 1691 (class 1255 OID 81992498)
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
-- TOC entry 1692 (class 1255 OID 81992499)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$ BEGIN RETURN QUERY
            SELECT scca.product, scca.location FROM exp01_ma_stylecolorchannelattributes scca
            INNER JOIN UNNEST(products) arg ON scca.product=arg WHERE scca.record_state=0; END
            $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 1693 (class 1255 OID 81992500)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
sls_start     text;
dept_var      text;
BEGIN
  select ancestor3 into dept_var
  from exp01_h_prodstd where id = NEW.product;
  select a.slsstart into sls_start 
  from exp01_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;
  if NEW.SSG is null or cardinality(NEW.SSG) = 0 then 
  
      NEW.store_count := get_store_count(
                                           sls_start
                                          ,NEW.strmenscapacity
                                          ,NEW.strwomenscapacity
                                          ,NEW.strclimate
                                          ,NEW.grade
                                          ,dept_var
                                        );
  else 
      select cardinality(stores) into NEW.store_count
      from exp01_l_ssglookup 
      where ssg_id = array_to_string(NEW.SSG, ',')
        and product = dept_var;
  end if;
  update exp01_a_assortment a
  set grade = NEW.grade
     ,strmenscapacity = NEW.strmenscapacity
     ,strwomenscapacity = NEW.strwomenscapacity
     ,strcorpvoltier = NEW.strcorpvoltier
     ,strclimate = NEW.strclimate
     ,ssg = NEW.ssg
     ,store_count = NEW.store_count
  where product = NEW.product
    and location = NEW.location
    and time >= NEW.time
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 1694 (class 1255 OID 81992501)
-- Name: select_remove_doublequotes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.select_remove_doublequotes() RETURNS TABLE(product text)
    LANGUAGE plpgsql
    AS $$
  declare stylecolnames TEXT[];
  declare stylecolorcolnames TEXT[];
  declare colnames TEXT[];
  col CHARACTER VARYING;
  col2 character varying;
begin
 -- Get column names in array by table
stylecolnames := ARRAY(SELECT 
      attname            AS col
 FROM   pg_attribute
 WHERE  attrelid = 'exp01_ma_styleattributes'::regclass  -- table name, optionally schema-qualified
 AND    attnum > 0
 AND    NOT attisdropped
 and  cast(atttypid::regtype AS VARCHAR)='text'
 ORDER  BY attnum);

 -- First finds where column is not empty string
 -- Then finds columns where replacing empty space and " will result in empty string
 
 foreach col in array stylecolnames LOOP
  return query execute format('select product from exp01_ma_styleattributes where %s != '''' AND REPLACE(REPLACE(%s, ''"'', ''''), '' '', '''') = ''''', col, col, col);
 end loop;
end
$$;


ALTER FUNCTION public.select_remove_doublequotes() OWNER TO psql;

--
-- TOC entry 1695 (class 1255 OID 81992502)
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
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from exp01_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';
EXECUTE s1;

s2 := '
  update exp01_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';

EXECUTE s2;

s3 := '
  update exp01_ma_sizeattributes a
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
-- TOC entry 1696 (class 1255 OID 81992503)
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
  , lookup_value as ccrangecode,target_value as master_size_attr, uuid_generate_v4()::text as memberid, 0::int as member_exists from exp01_l_dependencylookup 
  where 
  lookup_id=''ccrangecode''
  and lookup_value= '''||v_ccrangecode||'''
    ';

s2 := '
  update '||table_temp_rangecode_master||' a set memberid = b.product, member_exists=1 from exp01_ma_sizeattributes b 
  where a.product=b.parent_id and a.master_size_attr=b.sizeattribute
  ';

s3 := '
  update exp01_ma_sizeattributes set isvalid=0 where parent_id='''||v_product||'''
  ';

s4 := '
  delete from exp01_ma_sizeattributes where product in (select memberid from '||table_temp_rangecode_master||')
  ';
 
s5 := ' 
  insert into exp01_ma_sizeattributes (product, sizeattribute, parent_id, isvalid)
  select memberid, master_size_attr, product, 1 as isvalid from '||table_temp_rangecode_master||' 
  ';

s6 := '
  delete from exp01_d_product where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0)
  ';
  
s6x := '
  insert into exp01_d_product (id, name, description, levelid) select memberid, product||''-''||master_size_attr, product||''-''||master_size_attr, ''stylecolorsize'' 
  from  '||table_temp_rangecode_master||' 
  where member_exists=0
  ';

s7 := '
  delete from exp01_h_prodstd where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0);
  insert into exp01_h_prodstd 
  (id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,ancestor8,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state) 
  select 
  memberid,id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,ancestor6,ancestor7,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
  from exp01_h_prodstd a, (select memberid,product from  '||table_temp_rangecode_master||'  where member_exists=0) b
  where a.id=b.product
  ';

s8 := '
  update exp01_ma_stylecolorchannelattributes a
  set validsizes=b.validsizes
  from (select product, location, array_agg(master_size_attr) as validsizes from  '||table_temp_rangecode_master||'  group by product, location) b
  where a.product=b.product and a.location=b.location
  ';

s9 := '
  update exp01_p_dc_adj_size a
  set dc_useradj=null
  where product in (select product from exp01_ma_sizeattributes where isvalid = 0 and parent_id='''||v_product||''')
  ';
/*
RAISE NOTICE 'INPUT:%', 'START:'|| s0;
RAISE NOTICE 'INPUT:%', 'START:'|| s1;
RAISE NOTICE 'INPUT:%', 'START:'|| s2;
RAISE NOTICE 'INPUT:%', 'START:'|| s3;
RAISE NOTICE 'INPUT:%', 'START:'|| s4;
RAISE NOTICE 'INPUT:%', 'START:'|| s5;
RAISE NOTICE 'INPUT:%', 'START:'|| s6;
RAISE NOTICE 'INPUT:%', 'START:'|| s7;
RAISE NOTICE 'INPUT:%', 'START:'|| s8;
RAISE NOTICE 'INPUT:%', 'START:'|| s9;
*/
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
-- TOC entry 1697 (class 1255 OID 81992504)
-- Name: store_eligibility_triger_chetan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_triger_chetan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    drop table if exists temp_new;
    drop table if exists temp_old;

    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from exp01_ma_dptflrsetattributes a, exp01_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from exp01_h_prodstd where id=NEW.product)
    and b.product = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;

    create temporary table temp_old as 
    select a.product,a.location,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count 
    from exp01_a_assortment a, exp01_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from exp01_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;

    delete from exp01_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
    
        insert into exp01_a_assortment 
        (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx ;

        insert into exp01_a_assortment 
        (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx order by c.indx ;
        
        insert into exp01_a_assortment 
        (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx ;

    drop table temp_new;
    drop table temp_old;

    -- Make first floorset funded
    update exp01_a_assortment 
    set isfunded = 1 
    from
        (select d.time, c.product, c.dbt_wk, d.ap_start, d.ap_end  from exp01_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.ap_start,b.ap_end from exp01_a_assortment a 
          join (select c.time,ap_start,ap_end from exp01_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.ap_start 
    and c.dbt_wk <= d.ap_end) filtered 
    where exp01_a_assortment.time=filtered.time and exp01_a_assortment.product=filtered.product;

 RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_triger_chetan() OWNER TO psql;

--
-- TOC entry 1698 (class 1255 OID 81992505)
-- Name: sync_ccsizerange_dependent_lookup(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sync_ccsizerange_dependent_lookup() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
ccrangecode text;
validsizes text[];
BEGIN

SELECT target_value INTO ccrangecode FROM exp01_l_dependencylookup WHERE lookup_id='ccsizerange' AND lookup_value=NEW.ccsizerange LIMIT 1;
SELECT ARRAY(SELECT target_value::text FROM exp01_l_dependencylookup WHERE target_id='validsizes' AND lookup_id='ccrangecode' AND lookup_value="ccrangecode")::text[] INTO validsizes;

EXECUTE 'UPDATE exp01_ma_stylecolorchannelattributes SET ccrangecode=$1, validsizes=$2 WHERE product in (SELECT id FROM exp01_h_prodstd WHERE ancestor0=$3);'
USING ccrangecode, validsizes, NEW.product;

RETURN NEW;

END;
$_$;


ALTER FUNCTION public.sync_ccsizerange_dependent_lookup() OWNER TO psql;

--
-- TOC entry 1699 (class 1255 OID 81992506)
-- Name: test1(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.test1(input_jsessionid text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tname text;
s1 text;
s2 text;

BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

SELECT 'cart_master_temp_' || $1 into tname;
RAISE NOTICE 'INPUT:%', 'START:'|| tname;

    drop table if exists t1;
    create  table t1 as select ''||$1||'' as jsid;

    s1 ='drop table if exists '||tname||' ';
    s2 = 'create  table '||tname||' as 
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
    , initiator
    from cart_master 
    where 
    jsessionid in (select jsid from t1)
    and isProcessed=1
	'
    ;
	EXECUTE s1;
	EXECUTE s2;
/*
    --select * from cart_master_temp;

    drop table if exists chetan_cart_style;
    create  table chetan_cart_style as
    select jsessionid
    , case when style_type = 'similar' then uuid_generate_v4()::text else incoming_style_id end AS final_style_id
    , incoming_style_id
    , style_type
    , style_name  as displayed_style_name
    , style_description  as displayed_style_description
    from 
    (
    select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description from cart_master_temp 
    where jsessionid in (select jsid from t1)
    ) x;

    --select uuid_in(md5(random()::text || clock_timestamp()::text)::cstring)

    Update cart_master_temp a 
    set final_style_id = b.final_style_id 
    from chetan_cart_style b 
    where 
    a.incoming_style_id=b.incoming_style_id 
    and a.style_type=b.style_type
    and a.jsessionid=b.jsessionid 
    and a.jsessionid in (select jsid from t1);

    drop table if exists chetan_cart_stylecolor;
    create  table chetan_cart_stylecolor as
    select jsessionid
    , case when stylecolor_type = 'similar' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = 'similar' then style_name||'-'||color_id else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = 'similar' then style_description ||' '||cccolor else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    from 
    (
    select distinct jsessionid, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as color_id
    , style_name, style_description, stylecolor_name, stylecolor_description 
    from cart_master_temp
    where jsessionid in (select jsid from t1)
    ) x;

    Update cart_master_temp a set 
    final_stylecolor_id = b.final_stylecolor_id
    , stylecolor_name = displayed_stylecolor_name
    , stylecolor_description = displayed_stylecolor_description 
    from chetan_cart_stylecolor b 
    where 
    a.incoming_stylecolor_id=b.incoming_stylecolor_id 
    and a.cccolor=b.cccolor 
    and a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.stylecolor_type=b.stylecolor_type
    and a.jsessionid=b.jsessionid 
    and a.jsessionid in (select jsid from t1);

    drop table if exists chetan_cart_stylecolorsize;
    CREATE TABLE chetan_cart_stylecolorsize AS 
    SELECT 
           case when stylecolor_type='similar' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id 
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
          FROM   cart_master_temp a 
                 , exp01_ma_sizeattributes b 
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x; 

RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

delete from exp01_d_product where id in (select final_style_id from chetan_cart_style WHERE style_type='similar' and jsessionid in (select jsid from t1));
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_style_id AS id 
       , COALESCE(displayed_style_name, 'S5-' || nextval('style_sequence') || '-' || displayed_style_name) AS NAME 
       , COALESCE(displayed_style_description, 'S5-' || nextval('style_sequence') || '-' || displayed_style_description) AS description 
       , 'style' AS levelid 
    FROM   chetan_cart_style
    WHERE style_type='similar'; 

delete from exp01_d_product where id in (select distinct final_stylecolor_id from chetan_cart_stylecolor WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));  
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_stylecolor_id              AS id 
           , displayed_stylecolor_name        AS NAME 
           , displayed_stylecolor_description AS description 
           , 'stylecolor'             AS levelid 
    FROM   chetan_cart_stylecolor 
    WHERE stylecolor_type='similar';    

delete from exp01_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));
    INSERT INTO exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
    SELECT final_stylecolorsize_id            AS id 
           , size_name        AS NAME 
           , size_description AS description 
           , 'stylecolorsize'           AS levelid 
    FROM   chetan_cart_stylecolorsize
    WHERE stylecolor_type='similar';

-- CREATING HIERARCHY

delete from exp01_h_prodstd where id in (select distinct final_style_id from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_style_id 
                , ancestor0 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE style_type='similar'
and a.incoming_style_id = b.id; 

delete from exp01_h_prodstd where id in (select distinct final_stylecolor_id from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1));
INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolor_id
                , final_style_id 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp  a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from exp01_h_prodstd) b
WHERE stylecolor_type='similar'
and a.incoming_stylecolor_id = b.id; 

delete from exp01_h_prodstd where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize where stylecolor_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolorsize_id 
                , final_stylecolor_id
                , ancestor0
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
FROM   chetan_cart_stylecolorsize a, 
exp01_h_prodstd b
WHERE stylecolor_type='similar'
and a.final_stylecolor_id = b.id; 

RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();

delete from exp01_ma_styleattributes where product in (select distinct final_style_id from cart_master_temp WHERE style_type = 'similar' and jsessionid in (select jsid from t1));

-- updating cccolor and cccolorfamily

update cart_master_temp a set cccolorfamily = b.target_value from exp01_l_dependencylookup b where b.lookup_id='cccolor' and lookup_value=a.cccolor;

delete from exp01_l_dependencylookup where target_id='patternedtostyle' and target_value in (select distinct final_style_id from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1));
delete from exp01_l_dependencylookup where target_id='patternedtostylecolor' and target_value in (select distinct final_stylecolor_id from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1));

insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct 'style' as lookup_id, incoming_style_id as lookup_value, 'patternedtostyle' target_id, final_style_id as target_value 
from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1);

insert into exp01_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct 'stylecolor' as lookup_id, incoming_stylecolor_id as lookup_value, 'patternedtostylecolor' target_id, final_stylecolor_id as target_value 
from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1);

-- STYLE ATTRIBUTES
INSERT INTO exp01_ma_styleattributes 
            (product 
             , ccfit 
             , cclegshape 
             , cclegskirtdresslength 
             , ccneckline 
             , ccsleevelength 
             , ccsilhouette 
             , ccproductdetail 
             , ccfashiontier 
             , cctested 
             , cclifestyle 
             , ccrise 
             , ccgraphictheme 
             , ccdevelopmentpath 
             , ccstylegroup 
             , ccsuits 
             , ccfabric 
             , ccgender 
             , cchangingnonhanging 
             , cctopbottom 
             , ccseason 
             , ccmarketingimage 
             , cchazmat 
             , ccgoh 
             , ccdresses 
             , ccfibertype 
             , cctickettype 
             , ccpricingtier 
             , ccrangecode 
             , ccdenimwash 
             , ccprintpattern 
             , cclicense 
             , ccticketprice 
             , ccsubclassid 
             , ccsubclassname 
             , ccstylecreatedate 
             , ccspecstylestyle 
             , style_insight 
             , ccclassname 
             , ccpowerdrivername 
             , ccdepartmentname 
             , isstyleremovable) 
SELECT final_style_id as product
             , b.ccfit 
             , b.cclegshape 
             , b.cclegskirtdresslength 
             , b.ccneckline 
             , b.ccsleevelength 
             , b.ccsilhouette 
             , b.ccproductdetail 
             , b.ccfashiontier 
             , b.cctested 
             , b.cclifestyle 
             , b.ccrise 
             , b.ccgraphictheme 
             , b.ccdevelopmentpath 
             , b.ccstylegroup 
             , b.ccsuits 
             , b.ccfabric 
             , b.ccgender 
             , b.cchangingnonhanging 
             , b.cctopbottom 
             , b.ccseason 
             , b.ccmarketingimage 
             , b.cchazmat 
             , b.ccgoh 
             , b.ccdresses 
             , b.ccfibertype 
             , b.cctickettype 
             , b.ccpricingtier 
             , b.ccrangecode 
             , b.ccdenimwash 
             , b.ccprintpattern 
             , b.cclicense 
             , b.ccticketprice 
             , b.ccsubclassid 
             , b.ccsubclassname 
             , b.ccstylecreatedate 
             , b.ccspecstylestyle 
             , b.style_insight 
             , b.ccclassname 
             , b.ccpowerdrivername 
             , b.ccdepartmentname
             , 'true'
from (select distinct final_style_id, style_type, incoming_style_id from cart_master_temp) a, exp01_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type='similar';

-- STYLECOLOR ATTRIBUTES

delete from exp01_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from cart_master_temp WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));

INSERT INTO exp01_ma_stylecolorattributes 
        (product 
       , ccfloorset 
       , ccstoretier 
       , ccmarkdownflag 
       , ccprintid 
       , ccmos 
       , ccrecall 
       , ccunavailable 
       , cccolorid 
       , cccolor 
       , cccolorfamily 
       , cccurp 
       , ccspecstylestyleclr 
       , ccstylecolorcreatedate 
       , ccinsight 
       , ccactslsrnk 
       , ishistory 
       , isassortment 
       , isdesign 
       , isforecastable 
       , inqueue 
       , islocked 
       , isremovable ) 
SELECT final_stylecolor_id as product
       , b.ccfloorset 
       , b.ccstoretier 
       , b.ccmarkdownflag 
       , b.ccprintid 
       , b.ccmos 
       , b.ccrecall 
       , b.ccunavailable 
       , a.cccolorid 
       , a.cccolor 
       , a.cccolorfamily 
       , b.cccurp 
       , b.ccspecstylestyleclr 
       , b.ccstylecolorcreatedate 
       , b.ccinsight 
       , b.ccactslsrnk 
       , 'false' 
       , 'true'
       , 'false'
       , 'false'
       , 'false'
       , 'false' 
       , 'true'
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor,cccolorfamily, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as cccolorid  from cart_master_temp) a, exp01_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type='similar';

-- SIZE ATTRIBUTES
delete from exp01_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));
insert into exp01_ma_sizeattributes
    (product,
    sizeattribute,
    parent_id
    )
SELECT 
    distinct final_stylecolorsize_id,
    size_name,
    final_stylecolor_id
FROM
    chetan_cart_stylecolorsize
WHERE stylecolor_type = 'similar';

RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();

-- STYLECOLOR CHANNEL ATTRIBUTES

drop table if exists default_cart_prams;
create table default_cart_prams as 
select 
  ''||$1||''  as jsessionid
  , default_initrcptwk as default_initrcptwk
  , default_dbt_wk as default_dbt_wk
  , default_too as default_too
  , default_mkdnwks as default_mkdnwks
  , default_last_inv_wk as default_last_inv_wk
  , default_lstfpwk as default_lstfpwk
  , default_last_rcpt_wk as default_last_rcpt_wk
  , default_erlstmkdnwk as default_erlstmkdnwk
  , default_exitdate as default_exitdate
  
  , default_strmenscapacity as strmenscapacity
  , default_strwomenscapacity as strwomenscapacity
  , default_strcorpvoltier as strcorpvoltier
  , default_strclimate as strclimate
  , default_grade as grade
  , default_ssg as ssg
  , default_flnrange as flnrange 

  , default_ccmdstrategy as default_ccmdstrategy
  , default_presmin as default_presmin
  , default_presmin_weeks as default_presmin_weeks
  , default_ccrcptint as default_ccrcptint
  , default_ccordermultiple as default_ccordermultiple
  , default_ccordpolicy as default_ccordpolicy
from exp01_ma_dptflrsetattributes 
where time||'-'||product in (select time||'-'||product from exp01_ma_dptflrsetattributes where product=''||$2||'' and slsstart >= ''||$4||'' order by slsstart limit 1)
;

drop table if exists temp_exp01_ma_stylecolorchannelattributes;
create table temp_exp01_ma_stylecolorchannelattributes as 
select 
     ''||$1||'' as jsessionid 
  ,  final_stylecolor_id as product
  , ''||$3||'' as location

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
  , coalesce(ccordpolicy, default_ccordpolicy) ccordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='') then 'class_default' else ssnprf end
  , validsizes
  , coalesce(presmin, default_presmin) presmin
  , coalesce(presmin_weeks, default_presmin_weeks) presmin_weeks
  , coalesce(ccrcptint::int,default_ccrcptint::int) ccrcptint
  , coalesce(ccordermultiple::int,default_ccordermultiple::int) ccordermultiple

  , strmenscapacity
  , strwomenscapacity
  , strcorpvoltier
  , strclimate
  , grade
  , ssg
  , flnrange 
  , 'plan' as plan_type
  , final_style_id as style
FROM 
default_cart_prams a, exp01_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from cart_master_temp) c
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid;

delete from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'');

INSERT  into exp01_ma_stylecolorchannelattributes (
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple)
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple 
FROM 
temp_exp01_ma_stylecolorchannelattributes;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

-- ASSORTMENT MODEL
delete from exp01_a_assortment where (product, location) in (select product,location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'') and plan_type='plan';

    insert into exp01_a_assortment (
          product
        , location
        , "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , plan_type
        , style )
    SELECT 
        product
        , location
        , "time"
        , strmenscapacity
        , strwomenscapacity
        , strcorpvoltier
        , strclimate
        , grade
        , ssg
        , flnrange
        , plan_type
        , style
    FROM 
    (select time from exp01_ma_dptflrsetattributes a,  (select default_dbt_wk, default_exitdate from default_cart_prams) b  
    where ap_end > b.default_dbt_wk and ap_start < b.default_exitdate and product = ''||$2||'') a, temp_exp01_ma_stylecolorchannelattributes b;

RAISE NOTICE 'ENd Assortment Model:%', 'START:'|| now();

insert into plan_queue (jsessionid, tenantid, product, location, status, initiator, initiated_at)
select jsessionid, 'exp01', final_stylecolor_id, 'GP-01', 'queued', initiator, now() from cart_master_temp where jsessionid=''||$1||'';

update cart_master set isProcessed=1 where jsessionid=''||$1||'';

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();
*/
 RETURN;
END;
$_$;


ALTER FUNCTION public.test1(input_jsessionid text) OWNER TO psql;

--
-- TOC entry 1700 (class 1255 OID 81992508)
-- Name: test2(text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.test2(input_jsessionid text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tname text;
s1 text;
s2 text;

BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

SELECT 'cart_master_temp_' || $1 into tname;
RAISE NOTICE 'INPUT:%', 'START:'|| tname;

    drop table if exists t1;
    create  table t1 as select ''||$1||'' as jsid;

    insert into cart_master_temp_95F359DB572D0CFF1B2CB7A08A6CE556 
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
    , initiator
    from cart_master 
    where 
    jsessionid in (''||$1||'')
    and isProcessed=1
    ;
	--EXECUTE s1;
	--EXECUTE s2;
 RETURN;
END;
$_$;


ALTER FUNCTION public.test2(input_jsessionid text) OWNER TO psql;

--
-- TOC entry 1701 (class 1255 OID 81992509)
-- Name: testing_cart_chetan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.testing_cart_chetan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	drop table if exists cart_master_temp;
	create temporary table cart_master_temp as 
	select *, null::text final_style_id,  null::text final_stylecolor_id from cart_master;

	--select * from cart_master_temp;

	drop table if exists chetan_cart_style;
	create temporary table chetan_cart_style as
	select jsessionid, case when style_type = 'similar' then uuid_generate_v4()::text else style_id end AS final_style_id, style_id as incoming_style_id, style_type, style_name as displayed_style_name, style_description as displayed_style_description from 
	(
	select distinct jsessionid, style_type, style_id, style_name, style_description from cart_master_temp 
	where jsessionid=NEW.jsessionid
	) x;

	--select uuid_in(md5(random()::text || clock_timestamp()::text)::cstring)

	Update cart_master_temp a set final_style_id = b.final_style_id from chetan_cart_style b where a.style_id=b.incoming_style_id;

	drop table if exists chetan_cart_stylecolor;
	create temporary table chetan_cart_stylecolor as
	select jsessionid, case when stylecolor_type = 'similar' then uuid_generate_v4()::text else stylecolor_id end AS final_stylecolor_id, stylecolor_id as incoming_stylecolor_id, stylecolor_type, 
	style_name||'-'||color_id as displayed_stylecolor_name, style_description ||' '||cccolor as displayed_stylecolor_description from 
	(
	select distinct jsessionid, final_style_id, stylecolor_id, stylecolor_type, cccolor, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as color_id, style_name, style_description from cart_master_temp
	) x;


 RETURN NEW;
END;
$$;


ALTER FUNCTION public.testing_cart_chetan() OWNER TO psql;

--
-- TOC entry 1702 (class 1255 OID 81992510)
-- Name: testing_cart_chetan(text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.testing_cart_chetan(input_jsessionid text, scope_department text, scope_location text, scope_start text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
RAISE NOTICE 'INPUT:%', 'START:'|| now();

	drop table if exists t1;
	create  table t1 as select ''||$1||'' as jsid;

	drop table if exists cart_master_temp;
	create  table cart_master_temp as 
	select 
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
	,  null::text final_stylecolor_id from cart_master 
	where 
	jsessionid in (select jsid from t1)
	;

	--select * from cart_master_temp;

	drop table if exists chetan_cart_style;
	create  table chetan_cart_style as
	select jsessionid
	, case when style_type = 'similar' then uuid_generate_v4()::text else incoming_style_id end AS final_style_id
	, incoming_style_id
	, style_type
	, style_name  as displayed_style_name
	, style_description  as displayed_style_description
	from 
	(
	select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description from cart_master_temp 
	where jsessionid in (select jsid from t1)
	) x;

	--select uuid_in(md5(random()::text || clock_timestamp()::text)::cstring)

	Update cart_master_temp a 
	set final_style_id = b.final_style_id 
	from chetan_cart_style b 
	where 
	a.incoming_style_id=b.incoming_style_id 
	and a.style_type=b.style_type
	and a.jsessionid=b.jsessionid 
	and a.jsessionid in (select jsid from t1);

	drop table if exists chetan_cart_stylecolor;
	create  table chetan_cart_stylecolor as
	select jsessionid
	, case when stylecolor_type = 'similar' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
	, incoming_stylecolor_id
	, stylecolor_type
	, case when stylecolor_type = 'similar' then style_name||'-'||color_id else stylecolor_name end as displayed_stylecolor_name
	, case when stylecolor_type = 'similar' then style_description ||' '||cccolor else stylecolor_description end as displayed_stylecolor_description
	, incoming_style_id
	, style_type
	from 
	(
	select distinct jsessionid, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor, ( SUBSTR(cccolor, 1, strpos(cccolor, ' ') - 1) ) as color_id
	, style_name, style_description, stylecolor_name, stylecolor_description 
	from cart_master_temp
	where jsessionid in (select jsid from t1)
	) x;

	Update cart_master_temp a set 
	final_stylecolor_id = b.final_stylecolor_id
	, stylecolor_name = displayed_stylecolor_name
	, stylecolor_description = displayed_stylecolor_description 
	from chetan_cart_stylecolor b 
	where 
	a.incoming_stylecolor_id=b.incoming_stylecolor_id 
	and a.incoming_style_id=b.incoming_style_id
	and a.style_type=b.style_type
	and a.stylecolor_type=b.stylecolor_type
	and a.jsessionid=b.jsessionid 
	and a.jsessionid in (select jsid from t1);

	drop table if exists chetan_cart_stylecolorsize;
	CREATE TABLE chetan_cart_stylecolorsize AS 
	SELECT 
           case when stylecolor_type='similar' then uuid_generate_v4()::text else stylecolorsize_id end AS final_stylecolorsize_id 
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
          FROM   cart_master_temp a 
                 , chetan_exp01_ma_sizeattributes b 
          WHERE  a.incoming_stylecolor_id = b.parent_id
          )x; 

RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

delete from chetan_exp01_d_product where id in (select final_style_id from chetan_cart_style WHERE style_type='similar' and jsessionid in (select jsid from t1));
	INSERT INTO chetan_exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
	SELECT final_style_id AS id 
       , COALESCE(displayed_style_name, 'S5-' || nextval('style_sequence') || '-' || displayed_style_name) AS NAME 
       , COALESCE(displayed_style_description, 'S5-' || nextval('style_sequence') || '-' || displayed_style_description) AS description 
       , 'style' AS levelid 
	FROM   chetan_cart_style
	WHERE style_type='similar'; 


delete from chetan_exp01_d_product where id in (select distinct final_stylecolor_id from chetan_cart_stylecolor WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));	
	INSERT INTO chetan_exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
	SELECT final_stylecolor_id              AS id 
	       , displayed_stylecolor_name        AS NAME 
	       , displayed_stylecolor_description AS description 
	       , 'stylecolor'             AS levelid 
	FROM   chetan_cart_stylecolor 
	WHERE stylecolor_type='similar';	

delete from chetan_exp01_d_product where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type='similar' and jsessionid in (select jsid from t1));
	INSERT INTO chetan_exp01_d_product 
            (id 
             , NAME 
             , description 
             , levelid) 
	SELECT final_stylecolorsize_id            AS id 
	       , size_name        AS NAME 
	       , size_description AS description 
	       , 'stylecolorsize'           AS levelid 
	FROM   chetan_cart_stylecolorsize
	WHERE stylecolor_type='similar';


-- CREATING HIERARCHY

delete from chetan_exp01_h_prodstd where id in (select distinct final_style_id from cart_master_temp where style_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO chetan_exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_style_id 
                , ancestor0 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from chetan_exp01_h_prodstd) b
WHERE style_type='similar'
and a.incoming_style_id = b.id; 

delete from chetan_exp01_h_prodstd where id in (select distinct final_stylecolor_id from cart_master_temp where stylecolor_type='similar' and jsessionid in (select jsid from t1));
INSERT INTO chetan_exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolor_id
                , final_style_id 
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   cart_master_temp  a, 
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 , ancestor6, ancestor7, ancestor8 from chetan_exp01_h_prodstd) b
WHERE stylecolor_type='similar'
and a.incoming_stylecolor_id = b.id; 


delete from chetan_exp01_h_prodstd where id in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize where stylecolor_type='similar' and jsessionid in (select jsid from t1));

INSERT INTO chetan_exp01_h_prodstd 
            (id 
             , ancestor0 
             , ancestor1 
             , ancestor2 
             , ancestor3 
             , ancestor4 
             , ancestor5 
             , ancestor6
             , ancestor7
             , ancestor8) 
SELECT DISTINCT 
                  final_stylecolorsize_id 
                , ancestor0
                , ancestor1 
                , ancestor2 
                , ancestor3 
                , ancestor4 
                , ancestor5 
                , ancestor6 
                , ancestor7 
                , ancestor8
FROM   chetan_cart_stylecolorsize a, 
chetan_exp01_h_prodstd b
WHERE stylecolor_type='similar'
and a.final_stylecolor_id = b.id; 


RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();

delete from chetan_exp01_ma_styleattributes where product in (select distinct final_style_id from cart_master_temp WHERE style_type = 'similar' and jsessionid in (select jsid from t1));


-- STYLE ATTRIBUTES
INSERT INTO chetan_exp01_ma_styleattributes 
            (product 
             , ccfit 
             , cclegshape 
             , cclegskirtdresslength 
             , ccneckline 
             , ccsleevelength 
             , ccsilhouette 
             , ccproductdetail 
             , ccfashiontier 
             , cctested 
             , cclifestyle 
             , ccrise 
             , ccgraphictheme 
             , ccdevelopmentpath 
             , ccstylegroup 
             , ccsuits 
             , ccfabric 
             , ccgender 
             , cchangingnonhanging 
             , cctopbottom 
             , ccseason 
             , ccmarketingimage 
             , cchazmat 
             , ccgoh 
             , ccdresses 
             , ccfibertype 
             , cctickettype 
             , ccpricingtier 
             , ccrangecode 
             , ccdenimwash 
             , ccprintpattern 
             , cclicense 
             , ccticketprice 
             , ccsubclassid 
             , ccsubclassname 
             , ccstylecreatedate 
             , ccspecstylestyle 
             , style_insight 
             , ccclassname 
             , ccpowerdrivername 
             , ccdepartmentname 
             , isstyleremovable) 
SELECT final_style_id as product
             , b.ccfit 
             , b.cclegshape 
             , b.cclegskirtdresslength 
             , b.ccneckline 
             , b.ccsleevelength 
             , b.ccsilhouette 
             , b.ccproductdetail 
             , b.ccfashiontier 
             , b.cctested 
             , b.cclifestyle 
             , b.ccrise 
             , b.ccgraphictheme 
             , b.ccdevelopmentpath 
             , b.ccstylegroup 
             , b.ccsuits 
             , b.ccfabric 
             , b.ccgender 
             , b.cchangingnonhanging 
             , b.cctopbottom 
             , b.ccseason 
             , b.ccmarketingimage 
             , b.cchazmat 
             , b.ccgoh 
             , b.ccdresses 
             , b.ccfibertype 
             , b.cctickettype 
             , b.ccpricingtier 
             , b.ccrangecode 
             , b.ccdenimwash 
             , b.ccprintpattern 
             , b.cclicense 
             , b.ccticketprice 
             , b.ccsubclassid 
             , b.ccsubclassname 
             , b.ccstylecreatedate 
             , b.ccspecstylestyle 
             , b.style_insight 
             , b.ccclassname 
             , b.ccpowerdrivername 
             , b.ccdepartmentname
             , 'true'
from (select distinct final_style_id, style_type, incoming_style_id from cart_master_temp) a, chetan_exp01_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type='similar';


-- STYLECOLOR ATTRIBUTES

delete from chetan_exp01_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from cart_master_temp WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));

INSERT INTO chetan_exp01_ma_stylecolorattributes 
        (product 
       , ccfloorset 
       , ccstoretier 
       , ccmarkdownflag 
       , ccprintid 
       , ccmos 
       , ccrecall 
       , ccunavailable 
       , cccolorid 
       , cccolor 
       , cccolorfamily 
       , cccurp 
       , ccspecstylestyleclr 
       , ccstylecolorcreatedate 
       , ccinsight 
       , ccactslsrnk 
       , ishistory 
       , isassortment 
       , isdesign 
       , isforecastable 
       , inqueue 
       , islocked 
       , isremovable ) 
SELECT final_stylecolor_id as product
       , b.ccfloorset 
       , b.ccstoretier 
       , b.ccmarkdownflag 
       , b.ccprintid 
       , b.ccmos 
       , b.ccrecall 
       , b.ccunavailable 
       , b.cccolorid 
       , b.cccolor 
       , b.cccolorfamily 
       , b.cccurp 
       , b.ccspecstylestyleclr 
       , b.ccstylecolorcreatedate 
       , b.ccinsight 
       , b.ccactslsrnk 
       , 'false' 
       , 'true'
       , 'false'
       , 'false'
       , 'false'
       , 'false' 
       , 'true'
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id from cart_master_temp) a, chetan_exp01_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type='similar';


-- SIZE ATTRIBUTES
delete from chetan_exp01_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from chetan_cart_stylecolorsize WHERE stylecolor_type = 'similar' and jsessionid in (select jsid from t1));
insert into chetan_exp01_ma_sizeattributes
    (product,
    sizeattribute,
    parent_id
    )
SELECT 
    distinct final_stylecolorsize_id,
    size_name,
    final_stylecolor_id
FROM
    chetan_cart_stylecolorsize
WHERE stylecolor_type = 'similar';

RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();

-- STYLECOLOR CHANNEL ATTRIBUTES

drop table if exists default_cart_prams;
create table default_cart_prams as 
select 
  ''||$1||''  as jsessionid
  , default_initrcptwk as initrcptwk
  , default_dbt_wk as dbt_wk
  , default_too as too
  , default_mkdnwks as mkdnwks
  , default_last_inv_wk as last_inv_wk
  , default_lstfpwk as lstfpwk
  , default_last_rcpt_wk as last_rcpt_wk
  , default_erlstmkdnwk as erlstmkdnwk
  , default_exitdate as exitdate
  
  , default_strmenscapacity as strmenscapacity
  , default_strwomenscapacity as strwomenscapacity
  , default_strcorpvoltier as strcorpvoltier
  , default_strclimate as strclimate
  , default_grade as grade
  , default_ssg as ssg
  , default_flnrange as flnrange 

  , default_ccmdstrategy as default_ccmdstrategy
  , default_presmin as default_presmin
  , default_presmin_weeks as default_presmin_weeks
  , default_ccrcptint as default_ccrcptint
  , default_ccordermultiple as default_ccordermultiple
  , default_ccordpolicy as default_ccordpolicy
from exp01_ma_dptflrsetattributes 
where time||'-'||product in (select time||'-'||product from exp01_ma_dptflrsetattributes where product=''||$2||'' and slsstart >= ''||$4||'' order by slsstart limit 1)
;



drop table if exists temp_exp01_ma_stylecolorchannelattributes;
create table temp_exp01_ma_stylecolorchannelattributes as 
select 
     ''||$1||'' as jsessionid 
  ,  final_stylecolor_id as product
  , ''||$3||'' as location

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
  , coalesce(ccordpolicy, default_ccordpolicy) ccordpolicy
  , ccrangecode
  , case when (ssnprf is null or ssnprf ='') then 'class_default' else ssnprf end
  , validsizes
  , coalesce(presmin, default_presmin) presmin
  , coalesce(presmin_weeks, default_presmin_weeks) presmin_weeks
  , coalesce(ccrcptint::int,default_ccrcptint::int) ccrcptint
  , coalesce(ccordermultiple::int,default_ccordermultiple::int) ccordermultiple

  , strmenscapacity
  , strwomenscapacity
  , strcorpvoltier
  , strclimate
  , grade
  , ssg
  , flnrange 
  , 'plan' as plan_type
  , final_style_id as style
FROM 
default_cart_params a, exp01_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id from cart_master_temp) c
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid;

delete from exp01_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'');


INSERT  into exp01_ma_stylecolorchannelattributes (
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple)
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
, ccordpolicy
, ccrangecode
, ssnprf
, validsizes
, presmin
, presmin_weeks
, ccrcptint
, ccordermultiple 
FROM 
temp_exp01_ma_stylecolorchannelattributes;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();

-- ASSORTMENT MODEL
delete from exp01_a_assortment where (product, location) in (select product,location from temp_exp01_ma_stylecolorchannelattributes where jsessionid = ''||$1||'') and plan_type='plan';

	insert into exp01_a_assortment (
		  product
		, location
		, "time"
		, strmenscapacity
		, strwomenscapacity
		, strcorpvoltier
		, strclimate
		, grade
		, ssg
		, flnrange
		, plan_type
		, style )
	SELECT 
		product
		, location
		, "time"
		, strmenscapacity
		, strwomenscapacity
		, strcorpvoltier
		, strclimate
		, grade
		, ssg
		, flnrange
		, plan_type
		, style
	FROM 
	(select time from exp01_ma_dptflrsetattributes a, (select dbt_wk, exitdate from default_cart_prams) b  
	where ap_end > dbt_wk and ap_start < exitdate and product = ''||$2||'') a, temp_exp01_ma_stylecolorchannelattributes b;

RAISE NOTICE 'ENd Assortment Model:%', 'START:'|| now();

 RETURN;
END;
$_$;


ALTER FUNCTION public.testing_cart_chetan(input_jsessionid text, scope_department text, scope_location text, scope_start text) OWNER TO psql;

--
-- TOC entry 1703 (class 1255 OID 81992512)
-- Name: testing_triger_chetan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.testing_triger_chetan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	drop table if exists temp_new;
	drop table if exists temp_old;

	create temporary table temp_new as 
	select b.product,b.location,a.indx,a.time from exp01_ma_dptflrsetattributes_2 a, exp01_ma_stylecolorchannelattributes b, 
	(select value as plan_current from exp01_serviceparams_2 where id='plan_current') c,
	(select value as plan_end from exp01_serviceparams_2 where id='plan_end') d
	where 
	a.product in (select ancestor3 from exp01_h_prodstd_2 where id=OLD.product)
	and b.product = OLD.product
	and b.location = OLD.location
	and rcptstart <= least(plan_end,exitdate) and rcptend > greatest(initrcptwk,plan_current)
	order by indx;

	create temporary table temp_old as 
	select a.product,a.location,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style,indx
	from exp01_a_assortment a, exp01_ma_dptflrsetattributes_2 b
	where b.product in (select ancestor3 from exp01_h_prodstd_2 where id=OLD.product)
	and a.product= OLD.product
	and a.location= OLD.location
	and a.time=b.time;

		delete from exp01_a_assortment where product = OLD.product and location = OLD.location and plan_type='plan';
/*		
drop table if exists test_x;
create table test_x as
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
		and c.indx < a.indx ;

drop table if exists test_y;
create table test_y as
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
		and c.indx < a.indx ;
		
drop table if exists test_z;
create table test_z as
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
		and c.indx < a.indx ;

*/		
		insert into exp01_a_assortment (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style)
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
		and c.indx < a.indx ;

		insert into exp01_a_assortment (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style)
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
		and c.indx > a.indx order by c.indx ;
		
		insert into exp01_a_assortment (product,location,time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style)
		select a.product,a.location,c.time,strmenscapacity, strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,plan_type, style from 
		temp_old a, 
		temp_new c
		where a.product=c.product and a.location=c.location
		and c.indx = a.indx ;

	drop table temp_new;
	drop table temp_old;


 RETURN NEW;
END;
$$;


ALTER FUNCTION public.testing_triger_chetan() OWNER TO psql;

--
-- TOC entry 1704 (class 1255 OID 81992513)
-- Name: trigger_img_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_img_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

 begin
  -- Scenario: design image comes through, but user has selcted hold_img
  -- Result:   the img_held will stay as-is
  IF (NEW.img <> OLD.img AND NEW.img NOT LIKE 'https://images.express.com/%' AND OLD.hold_img = 'YES') 
  THEN 
    update exp01_ma_imgattributes
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
  IF (NEW.img <> OLD.img AND NEW.img NOT LIKE 'https://images.express.com/%' AND (OLD.hold_img is null OR OLD.hold_img = ''))
  THEN 
    -- New image will overwrite previous image
    update exp01_ma_imgattributes
    set 
          img_from_etl = OLD.img
        , img = NEW.img
    where product = NEW.product
    ;
  END IF
  ;

  -- ECOM image comes through and will override everYthing
  -- User would be able to override this during the week, but once weekend batch runs the ECOM image will replace it
  IF (NEW.img <> OLD.img AND NEW.img LIKE 'https://images.express.com/%' AND OLD.hold_img = 'YES')
  THEN 
    update exp01_ma_imgattributes
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
-- TOC entry 1651 (class 1255 OID 81992514)
-- Name: trigger_set_ccspecstylestyleclr(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_ccspecstylestyleclr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
       declare
               specImg text;
       begin
      update  exp01_ma_stylecolorattributes set ccspecstylestyleclr = NEW.ccspecstylestyle where product in (select id from exp01_h_prodstd where ancestor0=NEW.product);

      update exp01_ma_styleattributes a set size_range_lookup = b.target_value from (select target_value from exp01_l_dependencylookup where target_id='size_range_lookup' and lookup_id='ccspecstylestyle' and lookup_value=NEW.ccspecstylestyle limit 1) b where a.product=NEW.product;

      update exp01_ma_styleattributes a set fabric_lookup = b.target_value from (select target_value from exp01_l_dependencylookup where target_id='fabric_lookup' and lookup_id='ccspecstylestyle' and lookup_value=NEW.ccspecstylestyle limit 1) b where a.product=NEW.product;

      IF (NEW.ccspecstylestyle is not null)
       THEN
               if (old.ccspecstylestyle is null or new.ccspecstylestyle != old.ccspecstylestyle)
              then
                      select img into specImg from exp01_specimages where product = new.ccspecstylestyle;
                      if (specImg is not null)
                      then
                      -- backup previous version of images before overwriting
                              insert into exp01_ma_imgattributes_archives SELECT *, now() from exp01_ma_imgattributes where product in (select id from exp01_h_prodstd where ancestor0=NEW.product);
                              update exp01_ma_imgattributes set img = specImg where product in (select id from exp01_h_prodstd where ancestor0=NEW.product);
                      end if;
              end if;
      END IF;

      IF (NEW.ccspecstylestyle is null OR NEW.ccspecstylestyle='')
      THEN
        update exp01_ma_styleattributes a set size_range_lookup = '' where product=NEW.product;
        update exp01_ma_styleattributes a set fabric_lookup = '' where  a.product=NEW.product;
      END IF;

      RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.trigger_set_ccspecstylestyleclr() OWNER TO psql;

--
-- TOC entry 1705 (class 1255 OID 81992515)
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
    UPDATE exp01_ma_imgattributes 
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
    UPDATE exp01_ma_imgattributes 
    SET 
          img_held = null
        , img = null  
    WHERE product = NEW.product
    ;
  END IF
  ;

  -- Regardless of hold_img being true/false, update img to first non-null of img_held and img_from_etl
  UPDATE exp01_ma_imgattributes
  SET
      img = COALESCE(img_held, img_from_etl)
  WHERE product = NEW.product
  ;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_held_img() OWNER TO psql;

--
-- TOC entry 1706 (class 1255 OID 81992516)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from exp01_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 1707 (class 1255 OID 81992517)
-- Name: trigger_set_is_publishable(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_is_publishable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

IF (NEW.ccspecstylestyleclr is not null and NEW.ccplmcolor is not null)
THEN
  update  exp01_ma_stylecolorattributes set ispublishable = '1' where product=NEW.product and  ccspecstylestyleclr is not null;

ELSEIF (NEW.ccspecstylestyleclr is null OR NEW.ccplmcolor is null OR NEW.ccspecstylestyleclr ='' OR NEW.ccplmcolor ='')
THEN
  update  exp01_ma_stylecolorattributes set ispublishable = '0' where product=NEW.product;

END IF;
    RETURN NEW;
END;

$$;


ALTER FUNCTION public.trigger_set_is_publishable() OWNER TO psql;

--
-- TOC entry 1708 (class 1255 OID 81992518)
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

        INSERT INTO sync_outbound_dataqueue (product, time, publish_type) 
        SELECT NEW.product, COALESCE(scca.dbt_wk, ''), 'OP_SNAPSHOT' 
			from exp01_ma_stylecolorchannelattributes scca where product = NEW.product
		LIMIT 1;

        update exp01_ma_stylecolorchannelattributes 
        set
            cc_first_publish_date = coalesce(cc_first_publish_date, NOW()::timestamp(0)),
            cc_first_publish_snapshot_op = coalesce(cc_first_publish_snapshot_op, 1)
        where product = NEW.product;

        END IF;                                  
        RETURN NEW;                              
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 1709 (class 1255 OID 81992519)
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
-- TOC entry 1649 (class 1255 OID 81992520)
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
-- TOC entry 1652 (class 1255 OID 81992521)
-- Name: trigger_update_cc_flrset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_update_cc_flrset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN   UPDATE exp01_ma_stylecolorchannelattributes scca   set cc_flrset = NEW.ccfloorset   where scca.product = NEW.product   AND NOT EXISTS (  select scca.cc_flrset  INTERSECT  select NEW.ccfloorset   );   INSERT INTO trigger_trial (product, floorset, triggered) VALUES (NEW.product, NEW.ccfloorset, NOW());   RETURN NEW; END; $$;


ALTER FUNCTION public.trigger_update_cc_flrset() OWNER TO psql;

--
-- TOC entry 1653 (class 1255 OID 81992522)
-- Name: trigger_update_ccfloorset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_update_ccfloorset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN   UPDATE exp01_ma_stylecolorattributes sca   set ccfloorset = NEW.cc_flrset   where sca.product = NEW.product   and NOT EXISTS (  select sca.ccfloorset  INTERSECT  select NEW.cc_flrset   );    INSERT INTO trigger_trial (product, floorset, triggered) VALUES (NEW.product, NEW.cc_flrset, NOW());     RETURN NEW; END; $$;


ALTER FUNCTION public.trigger_update_ccfloorset() OWNER TO psql;

--
-- TOC entry 1716 (class 1255 OID 81992523)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_style_description exp01_d_product.description%type;
  v_style_name exp01_d_product.name%type;
BEGIN
  select name, description into v_style_name, v_style_description
  from exp01_d_product where id = (select ancestor0 from exp01_h_prodstd where id = NEW.product);

  if NEW.cccolor IS DISTINCT FROM OLD.cccolor then
    update exp01_d_product
    set description = v_style_description || '-' || NEW.cccolor,
        name = v_style_name || '-' || substring(NEW.cccolor from '[^ ]+')
    where id = NEW.product;

    update exp01_ma_stylecolorattributes a
    set cccolorfamily = (select target_value from exp01_l_dependencylookup
                         where lookup_id = 'cccolor' and target_id = 'cccolorfamily' and lookup_value = NEW.cccolor
                        ),
        cccolorid = substring(NEW.cccolor from '[^ ]+'),
        cccin = (select target_value from exp01_l_dependencylookup
                  where lookup_id = 'cccolor' and target_id = 'cccin' and lookup_value = NEW.cccolor
                )
    where product = NEW.product;
  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 1710 (class 1255 OID 81992524)
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
 from exp01_p_itemprice
 where product=NEW.product and location=NEW.location and time=NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression
 from exp01_l_priceeventlookup
 where product=NEW.department and location=NEW.location and ccpriceevent=NEW.event;

select ccdiscountpct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
 from exp01_ma_stylecolorchannelattributes
 where product=NEW.product and location=NEW.location;

select ccticketprice::real into v_ticketprice
 from exp01_ma_styleattributes
 where product in (select ancestor0 from exp01_h_prodstd where id=NEW.product);

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
update exp01_p_itemprice a set eff_aur=final_eff_aur where product=NEW.product and location=NEW.location and time=NEW.time
  ;


-- update exp01_an_price_storecount_info set expressed_aur=final_eff_aur where product=NEW.product and channel=NEW.location and time=NEW.time
--   ;
-- 
-- update exp01_an_price_storecount_info a
--   set v_A=b.v_A
-- FROM
--   (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A from exp01_an_price_storecount_info a
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time) b
-- WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
-- ;
-- 
--   update exp01_an_price_storecount_info a
--     set v_B=b.v_B
--   FROM
--     (select product, time, seq, addoff, corpaddoff
--       , case when seq=0 then
--           (case when final_eff_aur > 0 then final_eff_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
--        else curp end as v_B
--        from exp01_an_price_storecount_info a 
--        WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--     ) b
--   WHERE a.product=NEW.product and a.channel=NEW.location and a.time=NEW.time
--   ;
-- 
-- update exp01_an_price_storecount_info set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)
--   WHERE product=NEW.product and channel=NEW.location and time=NEW.time;
RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 1711 (class 1255 OID 81992525)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN


  if NEW.name <> OLD.name or NEW.description <> OLD.description then
    update exp01_d_product x
    set description = NEW.description || ' ' || y.cccolor,
        name = NEW.name || '-' || y.cccolorid
    from (select a.id, b.cccolor, b.cccolorid from exp01_h_prodstd a, exp01_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
    where x.id = y.id;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 1712 (class 1255 OID 81992526)
-- Name: update_pricing_store_info(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pricing_store_info() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

v_uuid_temp text;
v_uuid text;
s100 text;
s101 text;
s102 text;
s103 text;
s104 text;
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

s110_6 text;
s110_7 text;
s110_8 text;
s110_9 text;

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
RAISE NOTICE 'product:%', NEW.product ;

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;


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



s100 := 'CREATE TEMPORARY TABLE '||tst_df_temp||' AS
          SELECT
              product,
              COALESCE(relaunchweek,dbt_wk) as dbt_wk,
              last_rcpt_wk,
              erlstmkdnwk,
              exitdate,
              ccmdstrategy,
              ccdiscountpct,
              in_season_flag,
              id AS time,
              case when id < erlstmkdnwk then ''FP'' else ''MD'' end as price_status
          FROM exp01_ma_stylecolorchannelattributes AS a
          , exp01_d_time AS b
          WHERE (id >= COALESCE(relaunchweek,dbt_wk)) AND (id <= exitdate) AND product in ('''||NEW.PRODUCT||''')
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
                  ccdiscountpct,
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
                  ccdiscountpct,
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
              FROM exp01_h_prodstd
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
            , 0::real as md_disc
            , 0::real corpaddoff
            , 0::real corpexcl
            , 0::real addoff
            , null::real expressed_aur
            , ccticketprice::real curp
            , 0::real selling_price
            , 0::real v_A
            , 0::real v_B
            , null::text weekdate
            FROM
            (select a.*, ccticketprice from '||tst_df_with_style||' a, exp01_ma_styleattributes b where a.style=b.product) x
            ';

s105 := 'update '||tst_md_tktp_md||' a
            set md_disc=b.md_disc, curp=ccticketprice * (1 - b.md_disc)
          from md_strategy b
          where a.seq=b.seq and a.ccmdstrategy=b.mdstrategy
          and a.seq > 0
          ';

s106 := 'update '||tst_md_tktp_md||' a
            set corpaddoff=b.corpaddoff, corpexcl=b.corpexcl
          from exp01_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff
          from exp01_p_itemprice b
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
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, exp01_d_time b, exp01_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - ccdiscountpct))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from exp01_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from exp01_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from exp01_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from exp01_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from exp01_ma_weekattributes b where a.time=b.time';



s111 := 'CREATE TEMPORARY TABLE '||table_xt||' AS
        select *,
          case when location=''GP-01'' then
            case when ''ECOM''=ANY(grade) then ''CH-02'' else null END
          ELSE null end as ch02,

          case when location=''GP-01'' then
            case when ''ECOM''!=ANY(grade) then ''CH-01'' else null END
          else null end as ch01,

          case when location=''GP-03'' then ''CH-03'' else null end as ch03
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
                  grade,
                  isfunded,
                  ancestor3 AS department
              FROM (select * from exp01_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM exp01_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM exp01_ma_dptflrsetattributes AS a
              , exp01_d_time AS b
              WHERE (b.id >= a.ap_start) AND (b.id <= a.ap_end)
          ) AS y
          WHERE (x.department = y.department) AND (x.floorset = y.floorset)
        ) z
        ';

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

s113 := 'CREATE TEMPORARY TABLE '||table_zt_pre||' AS
          SELECT *
          FROM
          (
              SELECT
                  a.product,
                  a.location AS channel,
                  a.time,
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
                  b.ccdiscountpct
              FROM '||table_yt||' AS a
              , '||tst_md_tktp_md||' AS b
              WHERE (a.product = b.product) AND (a.time = b.time)
          ) AS x
          WHERE time >= (select value from exp01_serviceparams where id=''plan_current'')
          AND time <= (select value from exp01_serviceparams where id=''plan_end'')
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


s114 := 'delete from exp01_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into exp01_an_price_storecount_info
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
            , ccdiscountpct
            , flow_flag
          from
          '||table_zt||'
          ';


-- s110_6 :=  'drop table if exists tst_md_tktp_md';
-- s110_7 :=  'create table tst_md_tktp_md as select * from '||tst_md_tktp_md||'';
-- s110_8 :=  'drop table if exists table_zt';
-- s110_9 :=  'create table table_zt as select * from '||table_zt||'';

-- insert into trigger_test_delete_me values ('s0:', clock_timestamp());
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
EXECUTE s112 ;
-- insert into trigger_test_delete_me values ('s112:', clock_timestamp());
EXECUTE s113 ;
EXECUTE s113_1 ;
EXECUTE s113_2 ;

-- insert into trigger_test_delete_me values ('s113:', clock_timestamp());
EXECUTE s114 ;
-- insert into trigger_test_delete_me values ('s114:', clock_timestamp());
EXECUTE s115 ;
-- insert into trigger_test_delete_me values ('s115:', clock_timestamp());

-- EXECUTE s110_6;
-- EXECUTE s110_7;
-- EXECUTE s110_8;
-- EXECUTE s110_9;


RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_pricing_store_info() OWNER TO psql;

--
-- TOC entry 1713 (class 1255 OID 81992528)
-- Name: update_stylecolor_ticketprice(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_stylecolor_ticketprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN


update exp01_ma_stylecolorchannelattributes a set ccticketpricechannel=x.ccticketprice from
(
select stylecolor, ccticketprice from
    (select id as stylecolor, ancestor0 as style from exp01_h_prodstd where ancestor0=NEW.product)a,
    (select product as style, ccticketprice from exp01_ma_styleattributes where product=NEW.product) b
where a.style=b.style
) x
where a.product=x.stylecolor
;

update exp01_p_itemprice set updated_at=now()::timestamp(0)
where product in (select id as stylecolor from exp01_h_prodstd where ancestor0=NEW.product)
;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_stylecolor_ticketprice() OWNER TO psql;

--
-- TOC entry 1714 (class 1255 OID 81992529)
-- Name: update_triger_cartparams_ranging(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_triger_cartparams_ranging() RETURNS trigger
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
	select b.product,b.location,a.indx,a.time from exp01_ma_dptflrsetattributes a, cart_params_temp b, 
	(select value as plan_current from exp01_serviceparams where id='plan_current') c,
	(select value as plan_end from exp01_serviceparams where id='plan_end') d
	where 
	a.product=b.product
	and b.product = NEW.scope_product
	and b.location = NEW.scope_location
	and ap_start <= least(plan_end,exitdate) and ap_end > greatest(dbt_wk,plan_current)
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
	(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, indx)
	select a.jsessionid,scope_product,scope_location,scope_start,c.time,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, c.indx from 
	temp_old a, temp_new c
	where a.scope_product=c.product and a.scope_location=c.location
	and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||min(indx) from temp_old group by scope_product, scope_location)
	and c.indx < a.indx ;


	insert into cart_ranging
	(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, indx)
	select a.jsessionid,scope_product,scope_location,scope_start,c.time,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, c.indx from 
	temp_old a, temp_new c
	where a.scope_product=c.product and a.scope_location=c.location
	and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||max(indx) from temp_old group by scope_product, scope_location)
	and c.indx > a.indx ;

	insert into cart_ranging
	(jsessionid,scope_product,scope_location,scope_start,scope_floorset,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, indx)
	select a.jsessionid,scope_product,scope_location,scope_start,c.time,strmenscapacity,strwomenscapacity,strcorpvoltier,strclimate,grade,ssg,flnrange,isfunded, c.indx from 
	temp_old a, temp_new c
	where a.scope_product=c.product and a.scope_location=c.location
	and c.indx = a.indx ;


	drop table temp_new;
	drop table temp_old;

 RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_triger_cartparams_ranging() OWNER TO psql;

--
-- TOC entry 1715 (class 1255 OID 81992530)
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
  v_lastdcorder text;
  v_too int;
  v_mdweeks int;
  v_initrcptwk text;

  BEGIN


  -- v_irw_indx := (select indx from exp01_d_time where id =''||NEW.initrcptwk||'');
  v_dbtwk_indx := (select indx from exp01_d_time where id = COALESCE(''||NEW.relaunchweek||'',''||NEW.dbt_wk||''));
  v_mdstart_indx := (select indx  from exp01_d_time where id = ''||NEW.erlstmkdnwk||'');
  -- v_lastdcorder_indx := (select indx from exp01_d_time where id =''||NEW.lastdcorder||'');
  v_exitdate_indx := (select indx  from exp01_d_time where id = ''||NEW.exitdate||'');

  v_irw_indx := v_dbtwk_indx - 3;
  v_initrcptwk := (select id from exp01_d_time where indx= v_irw_indx);
  v_too := v_mdstart_indx - v_dbtwk_indx;
  v_lastdcorder_indx := v_mdstart_indx - 6;
  v_lastdcorder := (select id from exp01_d_time where indx= v_lastdcorder_indx);
  v_mdweeks := v_exitdate_indx - v_mdstart_indx;


  update exp01_ma_stylecolorchannelattributes
  set
  initrcptwk = v_initrcptwk,
  irw_indx = v_irw_indx,
  dbtwk_indx = v_dbtwk_indx,
  mdstart_indx = v_mdstart_indx,
  last_rcpt_wk = v_lastdcorder,
  -- lastdcorder_indx = v_lastdcorder_indx,
  exitdate_indx = v_exitdate_indx,
  too = v_too,
  mkdnwks = v_mdweeks
  WHERE
  product = NEW.product
  and location = NEW.location;

  RETURN NEW;
  END;
  $$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 1066 (class 1259 OID 81992531)
-- Name: a_assortment_test_03272026; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.a_assortment_test_03272026 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.a_assortment_test_03272026 OWNER TO psql;

--
-- TOC entry 1067 (class 1259 OID 81992536)
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
-- TOC entry 1068 (class 1259 OID 81992544)
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
-- TOC entry 1069 (class 1259 OID 81992551)
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
    error text
);


ALTER TABLE public.allocation_plan_queue OWNER TO psql;

--
-- TOC entry 1070 (class 1259 OID 81992558)
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
-- TOC entry 1071 (class 1259 OID 81992566)
-- Name: alpha; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.alpha (
    "char" text
);


ALTER TABLE public.alpha OWNER TO psql;

--
-- TOC entry 1072 (class 1259 OID 81992571)
-- Name: exp01_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_an_price_storecount_info (
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


ALTER TABLE public.exp01_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 1073 (class 1259 OID 81992576)
-- Name: exp01_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product (
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


ALTER TABLE public.exp01_d_product OWNER TO psql;

--
-- TOC entry 1074 (class 1259 OID 81992588)
-- Name: exp01_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd (
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


ALTER TABLE public.exp01_h_prodstd OWNER TO psql;

--
-- TOC entry 1075 (class 1259 OID 81992600)
-- Name: exp01_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes (
    indx integer,
    product text NOT NULL,
    ccfit text DEFAULT 'Undefined'::text,
    cclegshape text DEFAULT 'Undefined'::text,
    cclegskirtdresslength text DEFAULT 'Undefined'::text,
    ccneckline text DEFAULT 'Undefined'::text,
    ccsleevelength text DEFAULT 'Undefined'::text,
    ccsilhouette text DEFAULT 'Undefined'::text,
    ccproductdetail text DEFAULT 'Undefined'::text,
    cctested text DEFAULT 'Undefined'::text,
    cclifestyle text DEFAULT 'Undefined'::text,
    ccrise text DEFAULT 'Undefined'::text,
    ccgraphictheme text DEFAULT 'Undefined'::text,
    ccdevelopmentpath text DEFAULT 'Undefined'::text,
    ccstylegroup text DEFAULT 'Undefined'::text,
    ccsuits text DEFAULT 'Undefined'::text,
    ccfabric text DEFAULT 'Undefined'::text,
    ccgender text DEFAULT 'Undefined'::text,
    cchangingnonhanging text DEFAULT 'Undefined'::text,
    cctopbottom text DEFAULT 'Undefined'::text,
    ccseason text DEFAULT 'Undefined'::text,
    ccmarketingimage text DEFAULT 'Undefined'::text,
    cchazmat text DEFAULT 'Undefined'::text,
    ccgoh text DEFAULT 'Undefined'::text,
    ccdresses text DEFAULT 'Undefined'::text,
    ccfibertype text DEFAULT 'Undefined'::text,
    cctickettype text DEFAULT 'Undefined'::text,
    ccpricingtier text DEFAULT 'Undefined'::text,
    ccrangecode text DEFAULT 'Undefined'::text,
    ccdenimwash text DEFAULT 'Undefined'::text,
    ccprintpattern text DEFAULT 'Undefined'::text,
    cclicense text DEFAULT 'Undefined'::text,
    ccticketprice double precision,
    ccsubclassid text DEFAULT 'Undefined'::text,
    ccsubclassname text DEFAULT 'Undefined'::text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text DEFAULT 'Undefined'::text,
    ccpowerdrivername text DEFAULT 'Undefined'::text,
    ccdepartmentname text DEFAULT 'Undefined'::text,
    isstyleremovable text DEFAULT 'true'::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    isassortmentstyle text DEFAULT 0,
    hasbeenpatternedafterstyle text DEFAULT 0,
    islockedstyle text DEFAULT 0,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text,
    express_size_range text
);


ALTER TABLE public.exp01_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1076 (class 1259 OID 81992651)
-- Name: exp01_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes (
    indx integer,
    product text NOT NULL,
    ccfloorset text DEFAULT 'Undefined'::text,
    ccstoretier text DEFAULT 'Undefined'::text,
    ccmarkdownflag text DEFAULT 'Undefined'::text,
    ccprintid text DEFAULT 'Undefined'::text,
    ccmos text DEFAULT 'Undefined'::text,
    ccrecall text DEFAULT 'Undefined'::text,
    ccunavailable text DEFAULT 'Undefined'::text,
    cccolorid text DEFAULT 'Undefined'::text,
    cccolor text DEFAULT 'Undefined'::text,
    cccolorfamily text DEFAULT 'Undefined'::text,
    cccurp double precision,
    ccspecstylestyleclr text DEFAULT 'Undefined'::text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text DEFAULT 'DEFAULT PROFILE'::text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    ispublishable text DEFAULT 0,
    hasbeenpatternedafter text DEFAULT 0,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    ccmannequinlooks text DEFAULT 'Undefined'::text,
    ccfashiontier text DEFAULT 'Undefined'::text,
    ccedit text DEFAULT 'Undefined'::text
);


ALTER TABLE public.exp01_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1077 (class 1259 OID 81992680)
-- Name: exp01_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes (
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
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real DEFAULT 0.0,
    cccurppricechannel real DEFAULT 0.0,
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
    auto_rollforward boolean DEFAULT false,
    irr_mode text DEFAULT 'Normal'::text,
    plan_current text,
    lock_agg_edit text DEFAULT ''::text,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1078 (class 1259 OID 81992703)
-- Name: exp01_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_stylecolor_hier_attr AS
 SELECT a.product,
    scca.cc_flrset AS ccfloorset,
    a.ccstoretier,
    a.ccmarkdownflag,
    a.ccprintid,
    a.ccmos,
    a.ccrecall,
    a.ccunavailable,
    a.cccolorid,
    a.cccolor,
    a.cccolorfamily,
    a.cccurp,
    c.ccspecstylestyle AS ccspecstylestyleclr,
    a.ccstylecolorcreatedate,
    a.ccinsight,
    a.ccactslsrnk,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_prd,
    b.ancestor5 AS top_bottom,
    b.ancestor6 AS gender,
    b.ancestor7 AS division,
    c.ccfit,
    c.cclegshape,
    c.cclegskirtdresslength,
    c.ccneckline,
    c.ccsleevelength,
    c.ccsilhouette,
        CASE
            WHEN (c.ccproductdetail IS NULL) THEN '{}'::text
            ELSE c.ccproductdetail
        END AS ccproductdetail,
    a.ccfashiontier,
    c.cctested,
    c.cclifestyle,
    c.ccrise,
    c.ccgraphictheme,
    c.ccdevelopmentpath,
    c.ccstylegroup,
    c.ccsuits,
    c.ccfabric,
    c.ccgender,
    c.cchangingnonhanging,
    c.cctopbottom,
    c.ccseason,
    c.ccmarketingimage,
    c.cchazmat,
    c.ccgoh,
    c.ccdresses,
    c.ccfibertype,
    c.cctickettype,
    c.ccpricingtier,
    "substring"(c.ccsizerange, 1, (length(c.ccsizerange) - length('-CL-0170'::text))) AS ccrangecode,
    c.ccdenimwash,
    c.ccprintpattern,
    c.cclicense,
    c.ccticketprice,
    c.ccsubclassid,
    c.ccsubclassname,
    c.ccstylecreatedate,
    c.ccspecstylestyle,
    c.style_insight,
    g.ccclassname,
    gpd.ccpowerdrivername,
    h.ccdepartmentname,
    c.isstyleremovable,
    c.ccsubclassid AS clssubclassid,
    c.ccsubclassname AS clssubclassname,
    c.ccsubclassname AS clssubclassdesc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    GREATEST(a.updated_at, c.updated_at, scca.updated_at) AS updated_at,
    a.updated_by,
    a.record_state,
    c.ccsizerange,
    d.id_name AS ccname,
    d.id_description AS ccdesc,
    e.style_name,
    e.style_description AS style_desc,
    a.ccplmcolor,
        CASE
            WHEN ((((((((((((((COALESCE(length(btrim("substring"(c.ccspecstylestyle, 1, 1))), 0) + COALESCE(length(btrim("substring"(a.ccplmcolor, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_name, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_description, 1, 1))), 0)) + COALESCE(length(btrim("substring"(scca.cc_flrset, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccstoretier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccgender, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cchangingnonhanging, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cctopbottom, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccseason, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccpricingtier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccfashiontier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(d.id_name, 1, 1))), 0)) = 13) AND (NOT ((upper((ARRAY[c.ccspecstylestyle, a.ccplmcolor, e.style_name, e.style_description, scca.cc_flrset, a.ccstoretier, c.ccgender, c.cchangingnonhanging, c.cctopbottom, c.ccseason, c.ccpricingtier, a.ccfashiontier, d.id_name])::text))::text[] @> ARRAY['UNDEFINED'::text]))) THEN '1'::text
            ELSE '0'::text
        END AS ispublishable,
    c.fabric_lookup,
    a.efo_rtl_tktprc,
    a.efo_rtl_wac,
    a.efo_rtl_imu,
    a.retail_stylecolor_efo,
    a.ccefo_rtl_tktprc,
    a.merch_comments,
    a.plan_comments,
    a.ccmannequinlooks,
    a.ccedit
   FROM public.exp01_ma_stylecolorattributes a,
    public.exp01_h_prodstd b,
    public.exp01_ma_styleattributes c,
    public.exp01_ma_stylecolorchannelattributes scca,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS id_name,
            exp01_d_product.description AS id_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS style_name,
            exp01_d_product.description AS style_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'style'::text)) e,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccpowerdrivername,
            exp01_d_product.description AS ccpowerdriverdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'subclass'::text)) gpd,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccclassname,
            exp01_d_product.description AS ccclassdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'class'::text)) g,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccdepartmentname,
            exp01_d_product.description AS ccdepartmentdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'department'::text)) h
  WHERE ((scca.product = a.product) AND (a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = gpd.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id))
  ORDER BY b.id;


ALTER VIEW public.exp01_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 1079 (class 1259 OID 81992708)
-- Name: analytics_product_fcst_input; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.analytics_product_fcst_input AS
 SELECT a.product,
    a.channel,
    a.selling_channel,
    a.store_count,
    a.in_season_flag,
    a.flow_flag,
    a.weekdate,
    a.price_status,
    a.ccticketprice AS original_ticketprice,
    a.selling_price,
    b.class,
    b.subclass,
    b.department,
    b.style,
    b.ccdenimwash,
    b.cccolor,
    b.ccfabric,
    b.cclegskirtdresslength,
    b.ccfashiontier,
    b.ccgraphictheme,
    b.ccrise,
    b.cclegshape,
    b.ccpricingtier,
    b.cclifestyle,
    b.ccsleevelength,
    b.cchangingnonhanging,
    b.ccsilhouette,
    b.ccdresses,
    b.ccprintpattern,
    b.ccneckline,
    b.ccfit,
    b.cctopbottom,
    b.ccseason,
    b.cccolorfamily,
    b.sizerange,
    b.num_sizes
   FROM public.exp01_an_price_storecount_info a,
    ( SELECT x.product,
            x.class,
            x.subclass,
            x.department,
            x.style,
            x.ccdenimwash,
            x.cccolor,
            x.ccfabric,
            x.cclegskirtdresslength,
            x.ccfashiontier,
            x.ccgraphictheme,
            x.ccrise,
            x.cclegshape,
            x.ccpricingtier,
            x.cclifestyle,
            x.ccsleevelength,
            x.cchangingnonhanging,
            x.ccsilhouette,
            x.ccdresses,
            x.ccprintpattern,
            x.ccneckline,
            x.ccfit,
            x.cctopbottom,
            x.ccseason,
            x.cccolorfamily,
            "substring"(x.ccsizerange, 1, (length(x.ccsizerange) - 8)) AS sizerange,
            y.num_sizes
           FROM public.exp01_stylecolor_hier_attr x,
            ( SELECT exp01_ma_stylecolorchannelattributes.product,
                    array_length(exp01_ma_stylecolorchannelattributes.validsizes, 1) AS num_sizes
                   FROM public.exp01_ma_stylecolorchannelattributes
                  WHERE (exp01_ma_stylecolorchannelattributes.record_state = 0)) y
          WHERE (x.product = y.product)) b
  WHERE (a.product = b.product);


ALTER VIEW public.analytics_product_fcst_input OWNER TO psql;

--
-- TOC entry 1080 (class 1259 OID 81992713)
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
-- TOC entry 1081 (class 1259 OID 81992718)
-- Name: ca_delete; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ca_delete (
    product text,
    ccname text,
    class text,
    ccsizerange text,
    ccrangecode text
);


ALTER TABLE public.ca_delete OWNER TO psql;

--
-- TOC entry 1082 (class 1259 OID 81992723)
-- Name: ca_stylecolor_rank_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ca_stylecolor_rank_prep (
    product text,
    location text,
    fp_aps real,
    fp_slsu real,
    class text,
    department text,
    ccactrnk integer
);


ALTER TABLE public.ca_stylecolor_rank_prep OWNER TO psql;

--
-- TOC entry 1083 (class 1259 OID 81992728)
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
-- TOC entry 1084 (class 1259 OID 81992735)
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
-- TOC entry 1085 (class 1259 OID 81992742)
-- Name: cart_master_mark; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_mark (
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


ALTER TABLE public.cart_master_mark OWNER TO psql;

--
-- TOC entry 1086 (class 1259 OID 81992747)
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
-- TOC entry 1087 (class 1259 OID 81992752)
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
-- TOC entry 1088 (class 1259 OID 81992757)
-- Name: cart_params_mark; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params_mark (
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


ALTER TABLE public.cart_params_mark OWNER TO psql;

--
-- TOC entry 1089 (class 1259 OID 81992762)
-- Name: cart_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_queue (
    cart_id text NOT NULL,
    user_id text NOT NULL,
    scope_id uuid NOT NULL,
    state public.queue_state NOT NULL,
    error_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cart_queue OWNER TO psql;

--
-- TOC entry 1090 (class 1259 OID 81992769)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    strmenscapacity text,
    strwomenscapacity text,
    strcorpvoltier text,
    strclimate text,
    grade text,
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 1091 (class 1259 OID 81992774)
-- Name: cart_ranging_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_2 (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    strmenscapacity text,
    strwomenscapacity text,
    strcorpvoltier text,
    strclimate text,
    grade text,
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging_2 OWNER TO psql;

--
-- TOC entry 1092 (class 1259 OID 81992779)
-- Name: cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    strmenscapacity text,
    strwomenscapacity text,
    strcorpvoltier text,
    strclimate text,
    grade text,
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging_archive OWNER TO psql;

--
-- TOC entry 1093 (class 1259 OID 81992784)
-- Name: change_size_range; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.change_size_range (
    dept text,
    style_id text,
    style_desc text,
    style_color_id text,
    s5_stylecolor_member_id text,
    current_size_range text,
    new_size_range text,
    current_sub_size_range text,
    new_sub_size_range text
);


ALTER TABLE public.change_size_range OWNER TO psql;

--
-- TOC entry 1094 (class 1259 OID 81992789)
-- Name: change_size_range_class_dept; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.change_size_range_class_dept (
    dept text,
    style_id text,
    style_desc text,
    style_color_id text,
    s5_stylecolor_member_id text,
    current_size_range text,
    new_size_range text,
    current_sub_size_range text,
    new_sub_size_range text,
    s5_style_id text,
    class text,
    department text,
    old_profile_id text,
    new_profile_id text
);


ALTER TABLE public.change_size_range_class_dept OWNER TO psql;

--
-- TOC entry 1095 (class 1259 OID 81992794)
-- Name: channeloverride644e6396b4ab4d109fa624eebd25df78; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.channeloverride644e6396b4ab4d109fa624eebd25df78 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    weekadjslsu real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.channeloverride644e6396b4ab4d109fa624eebd25df78 OWNER TO psql;

--
-- TOC entry 1096 (class 1259 OID 81992799)
-- Name: class_sales_rank; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.class_sales_rank (
    class text,
    rank integer,
    class_avg real,
    rank_mult real
);


ALTER TABLE public.class_sales_rank OWNER TO psql;

--
-- TOC entry 1097 (class 1259 OID 81992804)
-- Name: classattrs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.classattrs (
    membertie text,
    attributeid text,
    attributevalue text
);


ALTER TABLE public.classattrs OWNER TO psql;

--
-- TOC entry 1098 (class 1259 OID 81992809)
-- Name: cm_temp_exp01_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cm_temp_exp01_ma_stylecolorchannelattributes (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer
);


ALTER TABLE public.cm_temp_exp01_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1099 (class 1259 OID 81992814)
-- Name: completed_plan_05172025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.completed_plan_05172025 (
    product text
);


ALTER TABLE public.completed_plan_05172025 OWNER TO psql;

--
-- TOC entry 1612 (class 1259 OID 84910203)
-- Name: concept_sizerange_sizeattr_final; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.concept_sizerange_sizeattr_final (
    subclass text,
    style text,
    stylecolor text,
    size_range text,
    ccrangecode text,
    size_desc text,
    sizemember text,
    dept_channel text
);


ALTER TABLE public.concept_sizerange_sizeattr_final OWNER TO psql;

--
-- TOC entry 1611 (class 1259 OID 84910198)
-- Name: concept_sizerange_sizeattr_final_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.concept_sizerange_sizeattr_final_new (
    subclass text,
    style text,
    stylecolor text,
    size_range text,
    ccrangecode character varying(200),
    size_desc text,
    sizemember text
);


ALTER TABLE public.concept_sizerange_sizeattr_final_new OWNER TO psql;

--
-- TOC entry 1100 (class 1259 OID 81992829)
-- Name: corpdisc_from_express; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.corpdisc_from_express (
    product text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.corpdisc_from_express OWNER TO psql;

--
-- TOC entry 1101 (class 1259 OID 81992834)
-- Name: corpdisc_from_express_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.corpdisc_from_express_bk (
    product text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.corpdisc_from_express_bk OWNER TO psql;

--
-- TOC entry 1102 (class 1259 OID 81992839)
-- Name: corpdisc_from_express_dept; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.corpdisc_from_express_dept (
    product text,
    "time" text,
    corpaddoff real,
    corpexcl real,
    location text
);


ALTER TABLE public.corpdisc_from_express_dept OWNER TO psql;

--
-- TOC entry 1103 (class 1259 OID 81992844)
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
-- TOC entry 1104 (class 1259 OID 81992849)
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
-- TOC entry 1105 (class 1259 OID 81992852)
-- Name: dc_adj321c639d83db4409959d5293d2d95e5c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj321c639d83db4409959d5293d2d95e5c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_adjcost real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj321c639d83db4409959d5293d2d95e5c OWNER TO psql;

--
-- TOC entry 1106 (class 1259 OID 81992857)
-- Name: dc_adj66dcb67b5f2b4ab0af678c36c17dc90b; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj66dcb67b5f2b4ab0af678c36c17dc90b (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_adjcost real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj66dcb67b5f2b4ab0af678c36c17dc90b OWNER TO psql;

--
-- TOC entry 1107 (class 1259 OID 81992862)
-- Name: dc_adj98c083772fd642f09c8e4cc296c978e8; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj98c083772fd642f09c8e4cc296c978e8 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_adjcost real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj98c083772fd642f09c8e4cc296c978e8 OWNER TO psql;

--
-- TOC entry 1108 (class 1259 OID 81992870)
-- Name: dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45 OWNER TO psql;

--
-- TOC entry 1109 (class 1259 OID 81992875)
-- Name: dc_adj_size07de34aef7a1432d9d8a6dac1028132b; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size07de34aef7a1432d9d8a6dac1028132b (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size07de34aef7a1432d9d8a6dac1028132b OWNER TO psql;

--
-- TOC entry 1110 (class 1259 OID 81992880)
-- Name: dc_adj_size0c6c316c9aec45298fc486be3ef947d9; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size0c6c316c9aec45298fc486be3ef947d9 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size0c6c316c9aec45298fc486be3ef947d9 OWNER TO psql;

--
-- TOC entry 1111 (class 1259 OID 81992885)
-- Name: dc_adj_size0ca0aa8b3250447295102282ef4b2e43; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size0ca0aa8b3250447295102282ef4b2e43 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size0ca0aa8b3250447295102282ef4b2e43 OWNER TO psql;

--
-- TOC entry 1112 (class 1259 OID 81992890)
-- Name: dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e OWNER TO psql;

--
-- TOC entry 1113 (class 1259 OID 81992895)
-- Name: dc_adj_size137bdb391de644be85fcf505352b63e7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size137bdb391de644be85fcf505352b63e7 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size137bdb391de644be85fcf505352b63e7 OWNER TO psql;

--
-- TOC entry 1114 (class 1259 OID 81992900)
-- Name: dc_adj_size13944857eb554426a606f6936a956933; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size13944857eb554426a606f6936a956933 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size13944857eb554426a606f6936a956933 OWNER TO psql;

--
-- TOC entry 1115 (class 1259 OID 81992905)
-- Name: dc_adj_size14ad7e4c26d548e89282339d7bf11ab1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size14ad7e4c26d548e89282339d7bf11ab1 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size14ad7e4c26d548e89282339d7bf11ab1 OWNER TO psql;

--
-- TOC entry 1116 (class 1259 OID 81992910)
-- Name: dc_adj_size157379abb39649e9bb09934eb7eed498; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size157379abb39649e9bb09934eb7eed498 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size157379abb39649e9bb09934eb7eed498 OWNER TO psql;

--
-- TOC entry 1117 (class 1259 OID 81992915)
-- Name: dc_adj_size1674e90817914a67afe549455602f8d0; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size1674e90817914a67afe549455602f8d0 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size1674e90817914a67afe549455602f8d0 OWNER TO psql;

--
-- TOC entry 1118 (class 1259 OID 81992923)
-- Name: dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc OWNER TO psql;

--
-- TOC entry 1119 (class 1259 OID 81992928)
-- Name: dc_adj_size19fbcaf770a24634a6efd1dd570c0d54; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size19fbcaf770a24634a6efd1dd570c0d54 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size19fbcaf770a24634a6efd1dd570c0d54 OWNER TO psql;

--
-- TOC entry 1120 (class 1259 OID 81992933)
-- Name: dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944 OWNER TO psql;

--
-- TOC entry 1121 (class 1259 OID 81992938)
-- Name: dc_adj_size1ef4e19c81544ea38166540ae857c62d; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size1ef4e19c81544ea38166540ae857c62d (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size1ef4e19c81544ea38166540ae857c62d OWNER TO psql;

--
-- TOC entry 1122 (class 1259 OID 81992943)
-- Name: dc_adj_size204e060b0f524b39aa04c2eb93dbd940; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size204e060b0f524b39aa04c2eb93dbd940 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size204e060b0f524b39aa04c2eb93dbd940 OWNER TO psql;

--
-- TOC entry 1123 (class 1259 OID 81992948)
-- Name: dc_adj_size2233d768367948689761ddfbdfe0bf3b; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size2233d768367948689761ddfbdfe0bf3b (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size2233d768367948689761ddfbdfe0bf3b OWNER TO psql;

--
-- TOC entry 1124 (class 1259 OID 81992953)
-- Name: dc_adj_size28d13e6837d44c4f887a3f9ee837b492; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size28d13e6837d44c4f887a3f9ee837b492 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size28d13e6837d44c4f887a3f9ee837b492 OWNER TO psql;

--
-- TOC entry 1125 (class 1259 OID 81992958)
-- Name: dc_adj_size2931a7e1f8a44d49946b932c218e65ae; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size2931a7e1f8a44d49946b932c218e65ae (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size2931a7e1f8a44d49946b932c218e65ae OWNER TO psql;

--
-- TOC entry 1126 (class 1259 OID 81992963)
-- Name: dc_adj_size34e759aa169f43c4bb4da96bd59dc21c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size34e759aa169f43c4bb4da96bd59dc21c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size34e759aa169f43c4bb4da96bd59dc21c OWNER TO psql;

--
-- TOC entry 1127 (class 1259 OID 81992968)
-- Name: dc_adj_size36e615305c684352bc63b15d2b6dc55b; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size36e615305c684352bc63b15d2b6dc55b (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size36e615305c684352bc63b15d2b6dc55b OWNER TO psql;

--
-- TOC entry 1128 (class 1259 OID 81992973)
-- Name: dc_adj_size4253c193bdf542b1970a092020d50bf4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size4253c193bdf542b1970a092020d50bf4 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size4253c193bdf542b1970a092020d50bf4 OWNER TO psql;

--
-- TOC entry 1129 (class 1259 OID 81992978)
-- Name: dc_adj_size438a72d08e944bceafda56c870ff7bb5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size438a72d08e944bceafda56c870ff7bb5 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size438a72d08e944bceafda56c870ff7bb5 OWNER TO psql;

--
-- TOC entry 1130 (class 1259 OID 81992983)
-- Name: dc_adj_size44779378fad94650bba976c2b80c80d4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size44779378fad94650bba976c2b80c80d4 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size44779378fad94650bba976c2b80c80d4 OWNER TO psql;

--
-- TOC entry 1131 (class 1259 OID 81992988)
-- Name: dc_adj_size4692e4dc29dc44598d36963d7e9eba33; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size4692e4dc29dc44598d36963d7e9eba33 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size4692e4dc29dc44598d36963d7e9eba33 OWNER TO psql;

--
-- TOC entry 1132 (class 1259 OID 81992993)
-- Name: dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7 OWNER TO psql;

--
-- TOC entry 1133 (class 1259 OID 81992998)
-- Name: dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a OWNER TO psql;

--
-- TOC entry 1134 (class 1259 OID 81993003)
-- Name: dc_adj_size52fde98e607141379a9e0afb43a716da; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size52fde98e607141379a9e0afb43a716da (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size52fde98e607141379a9e0afb43a716da OWNER TO psql;

--
-- TOC entry 1135 (class 1259 OID 81993008)
-- Name: dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1 OWNER TO psql;

--
-- TOC entry 1136 (class 1259 OID 81993014)
-- Name: dc_adj_size543b19042b744d18ad152028a66f1da3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size543b19042b744d18ad152028a66f1da3 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size543b19042b744d18ad152028a66f1da3 OWNER TO psql;

--
-- TOC entry 1137 (class 1259 OID 81993021)
-- Name: dc_adj_size588cd271ad9c458e837baf520c9a2153; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size588cd271ad9c458e837baf520c9a2153 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size588cd271ad9c458e837baf520c9a2153 OWNER TO psql;

--
-- TOC entry 1138 (class 1259 OID 81993026)
-- Name: dc_adj_size59c696b2de93477b8c21199e318c045c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size59c696b2de93477b8c21199e318c045c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size59c696b2de93477b8c21199e318c045c OWNER TO psql;

--
-- TOC entry 1139 (class 1259 OID 81993031)
-- Name: dc_adj_size5bfff380613c4b46b7d9809e22f87c04; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size5bfff380613c4b46b7d9809e22f87c04 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size5bfff380613c4b46b7d9809e22f87c04 OWNER TO psql;

--
-- TOC entry 1140 (class 1259 OID 81993036)
-- Name: dc_adj_size6143f44900144595b180688364c6ad19; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6143f44900144595b180688364c6ad19 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6143f44900144595b180688364c6ad19 OWNER TO psql;

--
-- TOC entry 1141 (class 1259 OID 81993041)
-- Name: dc_adj_size6302d2a2a71c47e683546207506d9e7c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6302d2a2a71c47e683546207506d9e7c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6302d2a2a71c47e683546207506d9e7c OWNER TO psql;

--
-- TOC entry 1142 (class 1259 OID 81993046)
-- Name: dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3 OWNER TO psql;

--
-- TOC entry 1143 (class 1259 OID 81993051)
-- Name: dc_adj_size68707eea9b8743b0a31810410c0bc006; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size68707eea9b8743b0a31810410c0bc006 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size68707eea9b8743b0a31810410c0bc006 OWNER TO psql;

--
-- TOC entry 1144 (class 1259 OID 81993056)
-- Name: dc_adj_size69614dcc21234acfb141ca4ba1d412f4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size69614dcc21234acfb141ca4ba1d412f4 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size69614dcc21234acfb141ca4ba1d412f4 OWNER TO psql;

--
-- TOC entry 1145 (class 1259 OID 81993061)
-- Name: dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2 OWNER TO psql;

--
-- TOC entry 1146 (class 1259 OID 81993066)
-- Name: dc_adj_size6d144af9787840cab3b007f65dcae9e0; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6d144af9787840cab3b007f65dcae9e0 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6d144af9787840cab3b007f65dcae9e0 OWNER TO psql;

--
-- TOC entry 1147 (class 1259 OID 81993071)
-- Name: dc_adj_size6eec8fa878e34df78e491631144654f8; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6eec8fa878e34df78e491631144654f8 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6eec8fa878e34df78e491631144654f8 OWNER TO psql;

--
-- TOC entry 1148 (class 1259 OID 81993076)
-- Name: dc_adj_size6ef1f61eac0c41f29f636d250f74dae3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size6ef1f61eac0c41f29f636d250f74dae3 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size6ef1f61eac0c41f29f636d250f74dae3 OWNER TO psql;

--
-- TOC entry 1149 (class 1259 OID 81993081)
-- Name: dc_adj_size700d93d701334210959d367fe6b5f2d4; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size700d93d701334210959d367fe6b5f2d4 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size700d93d701334210959d367fe6b5f2d4 OWNER TO psql;

--
-- TOC entry 1150 (class 1259 OID 81993086)
-- Name: dc_adj_size723dcde017c94f7db8cd6cf7f280b877; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size723dcde017c94f7db8cd6cf7f280b877 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size723dcde017c94f7db8cd6cf7f280b877 OWNER TO psql;

--
-- TOC entry 1151 (class 1259 OID 81993091)
-- Name: dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c OWNER TO psql;

--
-- TOC entry 1152 (class 1259 OID 81993096)
-- Name: dc_adj_size73bb47b305214bd79beb3babb3870be7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size73bb47b305214bd79beb3babb3870be7 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size73bb47b305214bd79beb3babb3870be7 OWNER TO psql;

--
-- TOC entry 1153 (class 1259 OID 81993101)
-- Name: dc_adj_size773e8db596c64322a82224f6e2d4333e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size773e8db596c64322a82224f6e2d4333e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size773e8db596c64322a82224f6e2d4333e OWNER TO psql;

--
-- TOC entry 1154 (class 1259 OID 81993106)
-- Name: dc_adj_size7f60ac10902f4ff78c4f57e9025b9213; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size7f60ac10902f4ff78c4f57e9025b9213 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size7f60ac10902f4ff78c4f57e9025b9213 OWNER TO psql;

--
-- TOC entry 1155 (class 1259 OID 81993111)
-- Name: dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca OWNER TO psql;

--
-- TOC entry 1156 (class 1259 OID 81993116)
-- Name: dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb OWNER TO psql;

--
-- TOC entry 1157 (class 1259 OID 81993121)
-- Name: dc_adj_size8cdfa294dae54854bd4a8ea08929065d; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8cdfa294dae54854bd4a8ea08929065d (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8cdfa294dae54854bd4a8ea08929065d OWNER TO psql;

--
-- TOC entry 1158 (class 1259 OID 81993126)
-- Name: dc_adj_size8d9897fe1fc447c785138a533405da59; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8d9897fe1fc447c785138a533405da59 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8d9897fe1fc447c785138a533405da59 OWNER TO psql;

--
-- TOC entry 1159 (class 1259 OID 81993131)
-- Name: dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed OWNER TO psql;

--
-- TOC entry 1160 (class 1259 OID 81993136)
-- Name: dc_adj_size8f460389057d4196859db30b087dafd5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size8f460389057d4196859db30b087dafd5 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size8f460389057d4196859db30b087dafd5 OWNER TO psql;

--
-- TOC entry 1161 (class 1259 OID 81993141)
-- Name: dc_adj_size911241a0c4724da2a4456f2f504811b1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size911241a0c4724da2a4456f2f504811b1 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size911241a0c4724da2a4456f2f504811b1 OWNER TO psql;

--
-- TOC entry 1162 (class 1259 OID 81993146)
-- Name: dc_adj_size929245c90aeb4334a320dde54b8fa73a; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size929245c90aeb4334a320dde54b8fa73a (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size929245c90aeb4334a320dde54b8fa73a OWNER TO psql;

--
-- TOC entry 1163 (class 1259 OID 81993151)
-- Name: dc_adj_size9341086b285a40fa9b2e85f5cdbc5888; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size9341086b285a40fa9b2e85f5cdbc5888 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size9341086b285a40fa9b2e85f5cdbc5888 OWNER TO psql;

--
-- TOC entry 1164 (class 1259 OID 81993156)
-- Name: dc_adj_size9888ba377895498c8e28f43f83f4e5bb; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size9888ba377895498c8e28f43f83f4e5bb (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size9888ba377895498c8e28f43f83f4e5bb OWNER TO psql;

--
-- TOC entry 1165 (class 1259 OID 81993161)
-- Name: dc_adj_size9a045c455433495c8e1ad3e887d1e907; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size9a045c455433495c8e1ad3e887d1e907 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size9a045c455433495c8e1ad3e887d1e907 OWNER TO psql;

--
-- TOC entry 1166 (class 1259 OID 81993166)
-- Name: dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e OWNER TO psql;

--
-- TOC entry 1167 (class 1259 OID 81993171)
-- Name: dc_adj_size9f6eecb92b7849558ef8fe8191221753; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_size9f6eecb92b7849558ef8fe8191221753 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_size9f6eecb92b7849558ef8fe8191221753 OWNER TO psql;

--
-- TOC entry 1168 (class 1259 OID 81993176)
-- Name: dc_adj_sizea298cb26a1b548f198df14ba53aebd42; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizea298cb26a1b548f198df14ba53aebd42 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizea298cb26a1b548f198df14ba53aebd42 OWNER TO psql;

--
-- TOC entry 1169 (class 1259 OID 81993181)
-- Name: dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad OWNER TO psql;

--
-- TOC entry 1170 (class 1259 OID 81993186)
-- Name: dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc OWNER TO psql;

--
-- TOC entry 1171 (class 1259 OID 81993191)
-- Name: dc_adj_sizea543141f96454e2095a0b908946653cc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizea543141f96454e2095a0b908946653cc (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizea543141f96454e2095a0b908946653cc OWNER TO psql;

--
-- TOC entry 1172 (class 1259 OID 81993196)
-- Name: dc_adj_sizead40aae39b0748cea785d382a5117a8b; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizead40aae39b0748cea785d382a5117a8b (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizead40aae39b0748cea785d382a5117a8b OWNER TO psql;

--
-- TOC entry 1173 (class 1259 OID 81993201)
-- Name: dc_adj_sizead43bcf2cbab4417839176bf6962010a; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizead43bcf2cbab4417839176bf6962010a (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizead43bcf2cbab4417839176bf6962010a OWNER TO psql;

--
-- TOC entry 1174 (class 1259 OID 81993206)
-- Name: dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f OWNER TO psql;

--
-- TOC entry 1175 (class 1259 OID 81993211)
-- Name: dc_adj_sizeb1d422c910574984943028a9662590d2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeb1d422c910574984943028a9662590d2 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeb1d422c910574984943028a9662590d2 OWNER TO psql;

--
-- TOC entry 1176 (class 1259 OID 81993216)
-- Name: dc_adj_sizeb25086e7fd25468fa7da37d929c5c815; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeb25086e7fd25468fa7da37d929c5c815 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeb25086e7fd25468fa7da37d929c5c815 OWNER TO psql;

--
-- TOC entry 1177 (class 1259 OID 81993221)
-- Name: dc_adj_sizec39477b9192e473489dde68b37860350; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizec39477b9192e473489dde68b37860350 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizec39477b9192e473489dde68b37860350 OWNER TO psql;

--
-- TOC entry 1178 (class 1259 OID 81993226)
-- Name: dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0 OWNER TO psql;

--
-- TOC entry 1179 (class 1259 OID 81993231)
-- Name: dc_adj_sizecc7af7b4e245441596713ac213bcda08; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizecc7af7b4e245441596713ac213bcda08 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizecc7af7b4e245441596713ac213bcda08 OWNER TO psql;

--
-- TOC entry 1180 (class 1259 OID 81993236)
-- Name: dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44 OWNER TO psql;

--
-- TOC entry 1181 (class 1259 OID 81993241)
-- Name: dc_adj_sized17ddb384b9f41758ea8f53aa49b4342; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sized17ddb384b9f41758ea8f53aa49b4342 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sized17ddb384b9f41758ea8f53aa49b4342 OWNER TO psql;

--
-- TOC entry 1182 (class 1259 OID 81993246)
-- Name: dc_adj_sized3baad3607a4442fa42001b4bc00a6e5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sized3baad3607a4442fa42001b4bc00a6e5 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sized3baad3607a4442fa42001b4bc00a6e5 OWNER TO psql;

--
-- TOC entry 1183 (class 1259 OID 81993251)
-- Name: dc_adj_sized56c4d590f5048b78a066f1d86f18bf1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sized56c4d590f5048b78a066f1d86f18bf1 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sized56c4d590f5048b78a066f1d86f18bf1 OWNER TO psql;

--
-- TOC entry 1184 (class 1259 OID 81993256)
-- Name: dc_adj_sized5e9899884a247e99fb3b48492c87ef3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sized5e9899884a247e99fb3b48492c87ef3 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sized5e9899884a247e99fb3b48492c87ef3 OWNER TO psql;

--
-- TOC entry 1185 (class 1259 OID 81993261)
-- Name: dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd OWNER TO psql;

--
-- TOC entry 1186 (class 1259 OID 81993266)
-- Name: dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f OWNER TO psql;

--
-- TOC entry 1187 (class 1259 OID 81993271)
-- Name: dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101 OWNER TO psql;

--
-- TOC entry 1188 (class 1259 OID 81993276)
-- Name: dc_adj_sizee2c098b576814d58be3819220be1457c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee2c098b576814d58be3819220be1457c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee2c098b576814d58be3819220be1457c OWNER TO psql;

--
-- TOC entry 1189 (class 1259 OID 81993281)
-- Name: dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba OWNER TO psql;

--
-- TOC entry 1190 (class 1259 OID 81993286)
-- Name: dc_adj_sizee77b1474b7db43b3864631db09c05252; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee77b1474b7db43b3864631db09c05252 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee77b1474b7db43b3864631db09c05252 OWNER TO psql;

--
-- TOC entry 1191 (class 1259 OID 81993291)
-- Name: dc_adj_sizee945bb16681046228e65e7f10c0cab7e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizee945bb16681046228e65e7f10c0cab7e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizee945bb16681046228e65e7f10c0cab7e OWNER TO psql;

--
-- TOC entry 1192 (class 1259 OID 81993296)
-- Name: dc_adj_sizeea59a18eba104b85b14ccf729fc9190e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeea59a18eba104b85b14ccf729fc9190e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeea59a18eba104b85b14ccf729fc9190e OWNER TO psql;

--
-- TOC entry 1193 (class 1259 OID 81993301)
-- Name: dc_adj_sizeea71e7f68da849e39437de793209347c; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeea71e7f68da849e39437de793209347c (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeea71e7f68da849e39437de793209347c OWNER TO psql;

--
-- TOC entry 1194 (class 1259 OID 81993306)
-- Name: dc_adj_sizeec1acad72e68451aafa1739f6803942a; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeec1acad72e68451aafa1739f6803942a (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeec1acad72e68451aafa1739f6803942a OWNER TO psql;

--
-- TOC entry 1195 (class 1259 OID 81993312)
-- Name: dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7 OWNER TO psql;

--
-- TOC entry 1196 (class 1259 OID 81993317)
-- Name: dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e OWNER TO psql;

--
-- TOC entry 1197 (class 1259 OID 81993322)
-- Name: dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb OWNER TO psql;

--
-- TOC entry 1198 (class 1259 OID 81993327)
-- Name: dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1 OWNER TO psql;

--
-- TOC entry 1199 (class 1259 OID 81993332)
-- Name: dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621 OWNER TO psql;

--
-- TOC entry 1200 (class 1259 OID 81993337)
-- Name: dc_adj_sizef6e5478bc7634bd49e59e4d936430d46; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef6e5478bc7634bd49e59e4d936430d46 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef6e5478bc7634bd49e59e4d936430d46 OWNER TO psql;

--
-- TOC entry 1201 (class 1259 OID 81993342)
-- Name: dc_adj_sizef7c76930a2d54975b094fd3682f7fa69; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizef7c76930a2d54975b094fd3682f7fa69 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizef7c76930a2d54975b094fd3682f7fa69 OWNER TO psql;

--
-- TOC entry 1202 (class 1259 OID 81993347)
-- Name: dc_adj_sizefbbe83db721d444e99b575388c227fdb; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizefbbe83db721d444e99b575388c227fdb (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizefbbe83db721d444e99b575388c227fdb OWNER TO psql;

--
-- TOC entry 1203 (class 1259 OID 81993352)
-- Name: dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_finrev double precision,
    dc_isedited double precision,
    dc_useradj double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec OWNER TO psql;

--
-- TOC entry 1204 (class 1259 OID 81993357)
-- Name: dc_adjb01742a33d504f43a94defbcdde9c654; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adjb01742a33d504f43a94defbcdde9c654 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_adjcost real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adjb01742a33d504f43a94defbcdde9c654 OWNER TO psql;

--
-- TOC entry 1205 (class 1259 OID 81993362)
-- Name: dc_adje6917d8095224a8487abf97d29d7fbf0; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dc_adje6917d8095224a8487abf97d29d7fbf0 (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    dc_adjcost real,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.dc_adje6917d8095224a8487abf97d29d7fbf0 OWNER TO psql;

--
-- TOC entry 1206 (class 1259 OID 81993367)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 1207 (class 1259 OID 81993372)
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
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
    grade text[],
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
-- TOC entry 1208 (class 1259 OID 81993377)
-- Name: default_cart_prams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_cart_prams (
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
    default_ccrcptint text,
    default_ccordermultiple text,
    default_ccordpolicy text
);


ALTER TABLE public.default_cart_prams OWNER TO psql;

--
-- TOC entry 1209 (class 1259 OID 81993382)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    department character varying(200),
    default_discount numeric(16,4),
    default_md character varying(200)
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 1210 (class 1259 OID 81993385)
-- Name: default_disc_md_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md_archives (
    department character varying(200),
    default_discount numeric(16,4),
    default_md character varying(200),
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.default_disc_md_archives OWNER TO psql;

--
-- TOC entry 1211 (class 1259 OID 81993388)
-- Name: default_profile; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_profile (
    size_class text,
    profile_id text
);


ALTER TABLE public.default_profile OWNER TO psql;

--
-- TOC entry 1212 (class 1259 OID 81993393)
-- Name: delete_me_inseason_flag; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_inseason_flag (
    product text
);


ALTER TABLE public.delete_me_inseason_flag OWNER TO psql;

--
-- TOC entry 1213 (class 1259 OID 81993398)
-- Name: delete_me_replan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_replan (
    product text
);


ALTER TABLE public.delete_me_replan OWNER TO psql;

--
-- TOC entry 1214 (class 1259 OID 81993403)
-- Name: delete_plan_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_plan_products (
    product text
);


ALTER TABLE public.delete_plan_products OWNER TO psql;

--
-- TOC entry 1215 (class 1259 OID 81993408)
-- Name: delete_sub_size_range; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_sub_size_range (
    dept text,
    class_id text,
    size_range text,
    sub_size_range text,
    size_id text,
    size_desc text,
    size_eligibility text
);


ALTER TABLE public.delete_sub_size_range OWNER TO psql;

--
-- TOC entry 1216 (class 1259 OID 81993413)
-- Name: deleteme_channeloverride_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_channeloverride_tbl (
    product text,
    location text,
    "time" text,
    floorsetpo text
);


ALTER TABLE public.deleteme_channeloverride_tbl OWNER TO psql;

--
-- TOC entry 1217 (class 1259 OID 81993418)
-- Name: deleteme_dept_plan_items_20231204; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_dept_plan_items_20231204 (
    product text,
    location text,
    department text
);


ALTER TABLE public.deleteme_dept_plan_items_20231204 OWNER TO psql;

--
-- TOC entry 1218 (class 1259 OID 81993423)
-- Name: deleteme_exp01_p_dc_adj_20240801; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_exp01_p_dc_adj_20240801 (
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
    po_id text
);


ALTER TABLE public.deleteme_exp01_p_dc_adj_20240801 OWNER TO psql;

--
-- TOC entry 1219 (class 1259 OID 81993428)
-- Name: deleteme_exp01_p_dc_adj_size_20240801; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_exp01_p_dc_adj_size_20240801 (
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
    record_state smallint
);


ALTER TABLE public.deleteme_exp01_p_dc_adj_size_20240801 OWNER TO psql;

--
-- TOC entry 1220 (class 1259 OID 81993433)
-- Name: deleteme_missing_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_a_assortment (
    product text,
    name text,
    description text,
    max_floorset text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text
);


ALTER TABLE public.deleteme_missing_a_assortment OWNER TO psql;

--
-- TOC entry 1221 (class 1259 OID 81993438)
-- Name: deleteme_plan_queue_fails_20260208; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_plan_queue_fails_20260208 (
    jobid uuid,
    product text,
    location text,
    initiator text,
    initiated_at timestamp with time zone,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone
);


ALTER TABLE public.deleteme_plan_queue_fails_20260208 OWNER TO psql;

--
-- TOC entry 1222 (class 1259 OID 81993443)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 1223 (class 1259 OID 81993449)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 1224 (class 1259 OID 81993456)
-- Name: dept_plan_items_03282021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_03282021 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_03282021 OWNER TO psql;

--
-- TOC entry 1225 (class 1259 OID 81993461)
-- Name: dept_plan_items_08282022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_08282022 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_08282022 OWNER TO psql;

--
-- TOC entry 1226 (class 1259 OID 81993466)
-- Name: dept_plan_items_0906; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_0906 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_0906 OWNER TO psql;

--
-- TOC entry 1227 (class 1259 OID 81993471)
-- Name: dept_plan_items_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_1 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_1 OWNER TO psql;

--
-- TOC entry 1228 (class 1259 OID 81993476)
-- Name: dept_plan_items_11142021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_11142021 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_11142021 OWNER TO psql;

--
-- TOC entry 1229 (class 1259 OID 81993481)
-- Name: dept_plan_items_12052021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_12052021 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_12052021 OWNER TO psql;

--
-- TOC entry 1230 (class 1259 OID 81993486)
-- Name: dept_plan_items_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_2 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_2 OWNER TO psql;

--
-- TOC entry 1231 (class 1259 OID 81993491)
-- Name: dept_plan_items_20230428; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_20230428 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_20230428 OWNER TO psql;

--
-- TOC entry 1232 (class 1259 OID 81993496)
-- Name: dept_plan_items_20230517; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_20230517 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_20230517 OWNER TO psql;

--
-- TOC entry 1631 (class 1259 OID 84966264)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 1233 (class 1259 OID 81993506)
-- Name: dept_plan_items_adhoc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_adhoc (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_adhoc OWNER TO psql;

--
-- TOC entry 1629 (class 1259 OID 84966178)
-- Name: dept_plan_items_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_archives (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_archives OWNER TO psql;

--
-- TOC entry 1234 (class 1259 OID 81993516)
-- Name: dept_plan_items_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_backup (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_backup OWNER TO psql;

--
-- TOC entry 1235 (class 1259 OID 81993521)
-- Name: dept_plan_items_backup_08142022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_backup_08142022 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_backup_08142022 OWNER TO psql;

--
-- TOC entry 1236 (class 1259 OID 81993526)
-- Name: dept_plan_items_backup_2022_w01; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_backup_2022_w01 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_backup_2022_w01 OWNER TO psql;

--
-- TOC entry 1237 (class 1259 OID 81993531)
-- Name: dept_plan_items_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_bk (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_bk OWNER TO psql;

--
-- TOC entry 1238 (class 1259 OID 81993536)
-- Name: dept_plan_items_bk_20220122; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_bk_20220122 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_bk_20220122 OWNER TO psql;

--
-- TOC entry 1239 (class 1259 OID 81993541)
-- Name: dept_plan_items_conv; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_conv (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_conv OWNER TO psql;

--
-- TOC entry 1240 (class 1259 OID 81993546)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 1241 (class 1259 OID 81993551)
-- Name: dept_plan_items_daily_1016; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily_1016 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily_1016 OWNER TO psql;

--
-- TOC entry 1242 (class 1259 OID 81993556)
-- Name: dept_plan_items_failed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_failed (
    product text
);


ALTER TABLE public.dept_plan_items_failed OWNER TO psql;

--
-- TOC entry 1243 (class 1259 OID 81993561)
-- Name: dept_plan_items_feb20_2022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_feb20_2022 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_feb20_2022 OWNER TO psql;

--
-- TOC entry 1244 (class 1259 OID 81993566)
-- Name: dept_plan_items_feb20_2022_rerun; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_feb20_2022_rerun (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_feb20_2022_rerun OWNER TO psql;

--
-- TOC entry 1245 (class 1259 OID 81993571)
-- Name: dept_plan_items_feb20_2022_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_feb20_2022_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_feb20_2022_temp OWNER TO psql;

--
-- TOC entry 1628 (class 1259 OID 84966131)
-- Name: dept_plan_items_new16; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_new16 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_new16 OWNER TO psql;

--
-- TOC entry 1246 (class 1259 OID 81993581)
-- Name: dept_plan_items_orig_10172021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_orig_10172021 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_orig_10172021 OWNER TO psql;

--
-- TOC entry 1247 (class 1259 OID 81993586)
-- Name: dept_plan_items_pre_stop_05162021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_pre_stop_05162021 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_pre_stop_05162021 OWNER TO psql;

--
-- TOC entry 1248 (class 1259 OID 81993591)
-- Name: dept_plan_items_test_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_test_1 (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_test_1 OWNER TO psql;

--
-- TOC entry 1249 (class 1259 OID 81993596)
-- Name: dept_plan_items_weekly_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_weekly_backup (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_weekly_backup OWNER TO psql;

--
-- TOC entry 1250 (class 1259 OID 81993601)
-- Name: dept_unplanned_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_unplanned_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_unplanned_items OWNER TO psql;

--
-- TOC entry 1251 (class 1259 OID 81993606)
-- Name: deptattrs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deptattrs (
    membertie text,
    attributeid text,
    attributevalue text
);


ALTER TABLE public.deptattrs OWNER TO psql;

--
-- TOC entry 1252 (class 1259 OID 81993611)
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
-- TOC entry 1253 (class 1259 OID 81993618)
-- Name: duped_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.duped_products (
    product text
);


ALTER TABLE public.duped_products OWNER TO psql;

--
-- TOC entry 1254 (class 1259 OID 81993623)
-- Name: duplicate_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.duplicate_time (
    id text,
    indx integer
);


ALTER TABLE public.duplicate_time OWNER TO psql;

--
-- TOC entry 1255 (class 1259 OID 81993628)
-- Name: employee_audits; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.employee_audits (
    employee_id integer NOT NULL,
    last_name character varying(40) NOT NULL,
    changed_on timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.employee_audits OWNER TO psql;

--
-- TOC entry 1256 (class 1259 OID 81993631)
-- Name: employees; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    first_name character varying(40) NOT NULL,
    last_name character varying(40) NOT NULL
);


ALTER TABLE public.employees OWNER TO psql;

--
-- TOC entry 1257 (class 1259 OID 81993634)
-- Name: empty_pd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.empty_pd (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text,
    express_size_range text
);


ALTER TABLE public.empty_pd OWNER TO psql;

--
-- TOC entry 1258 (class 1259 OID 81993639)
-- Name: error_logging_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.error_logging_table (
    tupletimestamp timestamp with time zone,
    targettable character varying,
    dmltype character(1),
    errmessage character varying,
    sqlerrcode character(5),
    label character varying,
    key bigint,
    rawdata bytea
);


ALTER TABLE public.error_logging_table OWNER TO psql;

--
-- TOC entry 1259 (class 1259 OID 81993645)
-- Name: existing_wac; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.existing_wac (
    product text,
    channel text,
    gafsu integer,
    gafsc double precision,
    ccexistingwac real
);


ALTER TABLE public.existing_wac OWNER TO psql;

--
-- TOC entry 1260 (class 1259 OID 81993650)
-- Name: exp01_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer DEFAULT 0
);


ALTER TABLE public.exp01_a_assortment OWNER TO psql;

--
-- TOC entry 1261 (class 1259 OID 81993665)
-- Name: exp01_a_assortment_0726; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_0726 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_0726 OWNER TO psql;

--
-- TOC entry 1262 (class 1259 OID 81993670)
-- Name: exp01_a_assortment_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_2 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_2 OWNER TO psql;

--
-- TOC entry 1263 (class 1259 OID 81993675)
-- Name: exp01_a_assortment_3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_3 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_3 OWNER TO psql;

--
-- TOC entry 1264 (class 1259 OID 81993680)
-- Name: exp01_a_assortment_archive_02162020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_archive_02162020 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_archive_02162020 OWNER TO psql;

--
-- TOC entry 1265 (class 1259 OID 81993685)
-- Name: exp01_a_assortment_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_archives (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_a_assortment_archives OWNER TO psql;

--
-- TOC entry 1266 (class 1259 OID 81993690)
-- Name: exp01_a_assortment_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_backup (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_backup OWNER TO psql;

--
-- TOC entry 1267 (class 1259 OID 81993695)
-- Name: exp01_a_assortment_bak_07152020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_bak_07152020 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_bak_07152020 OWNER TO psql;

--
-- TOC entry 1268 (class 1259 OID 81993700)
-- Name: exp01_a_assortment_bk20240903; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_bk20240903 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_bk20240903 OWNER TO psql;

--
-- TOC entry 1606 (class 1259 OID 84364747)
-- Name: exp01_a_assortment_bk_sup3893; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_bk_sup3893 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_bk_sup3893 OWNER TO psql;

--
-- TOC entry 1269 (class 1259 OID 81993705)
-- Name: exp01_a_assortment_bkp_08292021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_bkp_08292021 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_bkp_08292021 OWNER TO psql;

--
-- TOC entry 1270 (class 1259 OID 81993710)
-- Name: exp01_a_assortment_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_dp5 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_dp5 OWNER TO psql;

--
-- TOC entry 1271 (class 1259 OID 81993715)
-- Name: exp01_a_assortment_from_ch; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_from_ch (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_from_ch OWNER TO psql;

--
-- TOC entry 1272 (class 1259 OID 81993720)
-- Name: exp01_a_assortment_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_new (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_new OWNER TO psql;

--
-- TOC entry 1273 (class 1259 OID 81993725)
-- Name: exp01_a_assortment_pre_0202; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_pre_0202 (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_pre_0202 OWNER TO psql;

--
-- TOC entry 1274 (class 1259 OID 81993730)
-- Name: exp01_a_assortment_pre_resort_tropical; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_pre_resort_tropical (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_pre_resort_tropical OWNER TO psql;

--
-- TOC entry 1275 (class 1259 OID 81993735)
-- Name: exp01_a_assortment_ssgbackup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_ssgbackup (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_ssgbackup OWNER TO psql;

--
-- TOC entry 1276 (class 1259 OID 81993740)
-- Name: exp01_a_assortment_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_temp OWNER TO psql;

--
-- TOC entry 1277 (class 1259 OID 81993745)
-- Name: exp01_a_assortment_temp_flrsetadj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp_flrsetadj (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_temp_flrsetadj OWNER TO psql;

--
-- TOC entry 1278 (class 1259 OID 81993750)
-- Name: exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    "time" text,
    ap_start text,
    ap_end text
);


ALTER TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend OWNER TO psql;

--
-- TOC entry 1279 (class 1259 OID 81993755)
-- Name: exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_fina; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_fina (
    product text,
    "time" text
);


ALTER TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_fina OWNER TO psql;

--
-- TOC entry 1280 (class 1259 OID 81993760)
-- Name: exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_last; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_last (
    product text,
    "time" text
);


ALTER TABLE public.exp01_a_assortment_temp_flrsetadj_corr_dbt_exit_apstartend_last OWNER TO psql;

--
-- TOC entry 1281 (class 1259 OID 81993765)
-- Name: exp01_a_assortment_temp_flrsetadj_corr_repeat_corr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_temp_flrsetadj_corr_repeat_corr (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_temp_flrsetadj_corr_repeat_corr OWNER TO psql;

--
-- TOC entry 1282 (class 1259 OID 81993770)
-- Name: exp01_a_assortment_updated; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_a_assortment_updated (
    product text,
    location text,
    "time" text,
    strmenscapacity text[],
    strwomenscapacity text[],
    strcorpvoltier text[],
    strclimate text[],
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
    store_count integer
);


ALTER TABLE public.exp01_a_assortment_updated OWNER TO psql;

--
-- TOC entry 1283 (class 1259 OID 81993775)
-- Name: exp01_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_authorization (
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


ALTER TABLE public.exp01_authorization OWNER TO psql;

--
-- TOC entry 1284 (class 1259 OID 81993787)
-- Name: exp01_authorization_0802; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_authorization_0802 (
    tenantid text,
    roleid text,
    authid text,
    access text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_authorization_0802 OWNER TO psql;

--
-- TOC entry 1285 (class 1259 OID 81993792)
-- Name: exp01_authorization_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_authorization_temp (
    tenantid text,
    roleid text,
    authid text,
    access text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_authorization_temp OWNER TO psql;

--
-- TOC entry 1286 (class 1259 OID 81993797)
-- Name: exp01_bod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_bod (
    tolocation text NOT NULL,
    product text NOT NULL,
    fromlocation text NOT NULL,
    leadtime smallint DEFAULT 0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_bod OWNER TO psql;

--
-- TOC entry 1287 (class 1259 OID 81993810)
-- Name: exp01_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc (
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


ALTER TABLE public.exp01_corpdisc OWNER TO psql;

--
-- TOC entry 1288 (class 1259 OID 81993824)
-- Name: exp01_corpdisc20240830; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc20240830 (
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


ALTER TABLE public.exp01_corpdisc20240830 OWNER TO psql;

--
-- TOC entry 1289 (class 1259 OID 81993829)
-- Name: exp01_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc_backup (
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


ALTER TABLE public.exp01_corpdisc_backup OWNER TO psql;

--
-- TOC entry 1290 (class 1259 OID 81993834)
-- Name: exp01_corpdisc_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc_bk (
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


ALTER TABLE public.exp01_corpdisc_bk OWNER TO psql;

--
-- TOC entry 1291 (class 1259 OID 81993839)
-- Name: exp01_corpdisc_old; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc_old (
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


ALTER TABLE public.exp01_corpdisc_old OWNER TO psql;

--
-- TOC entry 1292 (class 1259 OID 81993844)
-- Name: exp01_corpdisc_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_corpdisc_temp (
    department text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.exp01_corpdisc_temp OWNER TO psql;

--
-- TOC entry 1293 (class 1259 OID 81993849)
-- Name: exp01_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_cluster (
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


ALTER TABLE public.exp01_d_cluster OWNER TO psql;

--
-- TOC entry 1294 (class 1259 OID 81993861)
-- Name: exp01_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_location (
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


ALTER TABLE public.exp01_d_location OWNER TO psql;

--
-- TOC entry 1295 (class 1259 OID 81993873)
-- Name: exp01_d_location_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_location_archives (
    id text,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_d_location_archives OWNER TO psql;

--
-- TOC entry 1296 (class 1259 OID 81993878)
-- Name: exp01_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_prodlife (
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


ALTER TABLE public.exp01_d_prodlife OWNER TO psql;

--
-- TOC entry 1297 (class 1259 OID 81993890)
-- Name: exp01_d_product_20260312; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_20260312 (
    id text,
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


ALTER TABLE public.exp01_d_product_20260312 OWNER TO psql;

--
-- TOC entry 1298 (class 1259 OID 81993895)
-- Name: exp01_d_product_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives (
    id text,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_d_product_archives OWNER TO psql;

--
-- TOC entry 1299 (class 1259 OID 81993900)
-- Name: exp01_d_product_archives_0219_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives_0219_0220 (
    id text,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_d_product_archives_0219_0220 OWNER TO psql;

--
-- TOC entry 1300 (class 1259 OID 81993905)
-- Name: exp01_d_product_archives_0219_0220_update; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives_0219_0220_update (
    id text,
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
    sync_date timestamp(0) without time zone,
    row_num bigint
);


ALTER TABLE public.exp01_d_product_archives_0219_0220_update OWNER TO psql;

--
-- TOC entry 1301 (class 1259 OID 81993910)
-- Name: exp01_d_product_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives_0220 (
    id text,
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


ALTER TABLE public.exp01_d_product_archives_0220 OWNER TO psql;

--
-- TOC entry 1302 (class 1259 OID 81993915)
-- Name: exp01_d_product_archives_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives_new (
    id text NOT NULL,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_d_product_archives_new OWNER TO psql;

--
-- TOC entry 1303 (class 1259 OID 81993920)
-- Name: exp01_d_product_archives_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_archives_temp (
    id text,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_d_product_archives_temp OWNER TO psql;

--
-- TOC entry 1304 (class 1259 OID 81993925)
-- Name: exp01_d_product_before_sizeconversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_before_sizeconversion (
    id text,
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


ALTER TABLE public.exp01_d_product_before_sizeconversion OWNER TO psql;

--
-- TOC entry 1305 (class 1259 OID 81993930)
-- Name: exp01_d_product_before_sizeconversion_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_before_sizeconversion_backup (
    id text,
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


ALTER TABLE public.exp01_d_product_before_sizeconversion_backup OWNER TO psql;

--
-- TOC entry 1306 (class 1259 OID 81993935)
-- Name: exp01_d_product_concept; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_concept (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.exp01_d_product_concept OWNER TO psql;

--
-- TOC entry 1307 (class 1259 OID 81993940)
-- Name: exp01_d_product_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_dp5 (
    id text,
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


ALTER TABLE public.exp01_d_product_dp5 OWNER TO psql;

--
-- TOC entry 1308 (class 1259 OID 81993945)
-- Name: exp01_d_product_jun182021_4sizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_jun182021_4sizes (
    id text,
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


ALTER TABLE public.exp01_d_product_jun182021_4sizes OWNER TO psql;

--
-- TOC entry 1309 (class 1259 OID 81993950)
-- Name: exp01_d_product_x; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_product_x (
    id text,
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


ALTER TABLE public.exp01_d_product_x OWNER TO psql;

--
-- TOC entry 1310 (class 1259 OID 81993955)
-- Name: exp01_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time (
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


ALTER TABLE public.exp01_d_time OWNER TO psql;

--
-- TOC entry 1311 (class 1259 OID 81993967)
-- Name: exp01_d_time20240830; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time20240830 (
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


ALTER TABLE public.exp01_d_time20240830 OWNER TO psql;

--
-- TOC entry 1312 (class 1259 OID 81993972)
-- Name: exp01_d_time_02022020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_02022020 (
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


ALTER TABLE public.exp01_d_time_02022020 OWNER TO psql;

--
-- TOC entry 1313 (class 1259 OID 81993977)
-- Name: exp01_d_time_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_archives (
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


ALTER TABLE public.exp01_d_time_archives OWNER TO psql;

--
-- TOC entry 1620 (class 1259 OID 84913388)
-- Name: exp01_d_time_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_backup (
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


ALTER TABLE public.exp01_d_time_backup OWNER TO psql;

--
-- TOC entry 1314 (class 1259 OID 81993987)
-- Name: exp01_d_time_backup_01102022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_backup_01102022 (
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


ALTER TABLE public.exp01_d_time_backup_01102022 OWNER TO psql;

--
-- TOC entry 1315 (class 1259 OID 81993992)
-- Name: exp01_d_time_backup_01102022_modified; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_backup_01102022_modified (
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


ALTER TABLE public.exp01_d_time_backup_01102022_modified OWNER TO psql;

--
-- TOC entry 1316 (class 1259 OID 81993997)
-- Name: exp01_d_time_before_mod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_before_mod (
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


ALTER TABLE public.exp01_d_time_before_mod OWNER TO psql;

--
-- TOC entry 1317 (class 1259 OID 81994002)
-- Name: exp01_d_time_bk20231027; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_bk20231027 (
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


ALTER TABLE public.exp01_d_time_bk20231027 OWNER TO psql;

--
-- TOC entry 1318 (class 1259 OID 81994007)
-- Name: exp01_d_time_bk20231029; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_bk20231029 (
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


ALTER TABLE public.exp01_d_time_bk20231029 OWNER TO psql;

--
-- TOC entry 1319 (class 1259 OID 81994012)
-- Name: exp01_d_time_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_bkp (
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


ALTER TABLE public.exp01_d_time_bkp OWNER TO psql;

--
-- TOC entry 1320 (class 1259 OID 81994024)
-- Name: exp01_d_time_mod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_mod (
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


ALTER TABLE public.exp01_d_time_mod OWNER TO psql;

--
-- TOC entry 1321 (class 1259 OID 81994029)
-- Name: exp01_d_time_pre_0202; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_pre_0202 (
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


ALTER TABLE public.exp01_d_time_pre_0202 OWNER TO psql;

--
-- TOC entry 1623 (class 1259 OID 84913403)
-- Name: exp01_d_time_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_d_time_temp (
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


ALTER TABLE public.exp01_d_time_temp OWNER TO psql;

--
-- TOC entry 1322 (class 1259 OID 81994039)
-- Name: exp01_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_designimages (
    product text,
    img text
);


ALTER TABLE public.exp01_designimages OWNER TO psql;

--
-- TOC entry 1635 (class 1259 OID 136839481)
-- Name: exp01_designimages_tmp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_designimages_tmp (
    product text,
    img text
);


ALTER TABLE public.exp01_designimages_tmp OWNER TO psql;

--
-- TOC entry 1323 (class 1259 OID 81994049)
-- Name: exp01_eohdata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_eohdata (
    product text NOT NULL,
    location text NOT NULL,
    eohu integer DEFAULT 0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_eohdata OWNER TO psql;

--
-- TOC entry 1324 (class 1259 OID 81994062)
-- Name: exp01_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_eohdata_stylecolor (
    product text,
    channel text,
    eohu real
);


ALTER TABLE public.exp01_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 1325 (class 1259 OID 81994067)
-- Name: exp01_eohdata_stylecolor_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_eohdata_stylecolor_archives (
    product text,
    channel text,
    eohu real,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_eohdata_stylecolor_archives OWNER TO psql;

--
-- TOC entry 1326 (class 1259 OID 81994075)
-- Name: exp01_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_h_clusterstd OWNER TO psql;

--
-- TOC entry 1327 (class 1259 OID 81994087)
-- Name: exp01_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_locdcstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_h_locdcstd OWNER TO psql;

--
-- TOC entry 1328 (class 1259 OID 81994099)
-- Name: exp01_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_h_locstd OWNER TO psql;

--
-- TOC entry 1329 (class 1259 OID 81994111)
-- Name: exp01_h_locstd_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_locstd_archives (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_h_locstd_archives OWNER TO psql;

--
-- TOC entry 1330 (class 1259 OID 81994116)
-- Name: exp01_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_h_prodlifestd OWNER TO psql;

--
-- TOC entry 1331 (class 1259 OID 81994128)
-- Name: exp01_h_prodstd_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_archives (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_h_prodstd_archives OWNER TO psql;

--
-- TOC entry 1332 (class 1259 OID 81994133)
-- Name: exp01_h_prodstd_archives_0219_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_archives_0219_0220 (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_h_prodstd_archives_0219_0220 OWNER TO psql;

--
-- TOC entry 1333 (class 1259 OID 81994138)
-- Name: exp01_h_prodstd_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_archives_0220 (
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


ALTER TABLE public.exp01_h_prodstd_archives_0220 OWNER TO psql;

--
-- TOC entry 1334 (class 1259 OID 81994143)
-- Name: exp01_h_prodstd_before_fix_11082020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_before_fix_11082020 (
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


ALTER TABLE public.exp01_h_prodstd_before_fix_11082020 OWNER TO psql;

--
-- TOC entry 1335 (class 1259 OID 81994148)
-- Name: exp01_h_prodstd_before_sizeconversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_before_sizeconversion (
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


ALTER TABLE public.exp01_h_prodstd_before_sizeconversion OWNER TO psql;

--
-- TOC entry 1336 (class 1259 OID 81994153)
-- Name: exp01_h_prodstd_before_sizeconversion_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_before_sizeconversion_backup (
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


ALTER TABLE public.exp01_h_prodstd_before_sizeconversion_backup OWNER TO psql;

--
-- TOC entry 1337 (class 1259 OID 81994158)
-- Name: exp01_h_prodstd_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_dp5 (
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


ALTER TABLE public.exp01_h_prodstd_dp5 OWNER TO psql;

--
-- TOC entry 1338 (class 1259 OID 81994163)
-- Name: exp01_h_prodstd_fixed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_fixed (
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


ALTER TABLE public.exp01_h_prodstd_fixed OWNER TO psql;

--
-- TOC entry 1339 (class 1259 OID 81994168)
-- Name: exp01_h_prodstd_jun182021_4sizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_prodstd_jun182021_4sizes (
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


ALTER TABLE public.exp01_h_prodstd_jun182021_4sizes OWNER TO psql;

--
-- TOC entry 1340 (class 1259 OID 81994173)
-- Name: exp01_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset (
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


ALTER TABLE public.exp01_h_timeflrset OWNER TO psql;

--
-- TOC entry 1341 (class 1259 OID 81994185)
-- Name: exp01_h_timeflrset20240830; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset20240830 (
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


ALTER TABLE public.exp01_h_timeflrset20240830 OWNER TO psql;

--
-- TOC entry 1342 (class 1259 OID 81994190)
-- Name: exp01_h_timeflrset_02022020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_02022020 (
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


ALTER TABLE public.exp01_h_timeflrset_02022020 OWNER TO psql;

--
-- TOC entry 1343 (class 1259 OID 81994195)
-- Name: exp01_h_timeflrset_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_archives (
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


ALTER TABLE public.exp01_h_timeflrset_archives OWNER TO psql;

--
-- TOC entry 1621 (class 1259 OID 84913393)
-- Name: exp01_h_timeflrset_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_backup (
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


ALTER TABLE public.exp01_h_timeflrset_backup OWNER TO psql;

--
-- TOC entry 1344 (class 1259 OID 81994205)
-- Name: exp01_h_timeflrset_backup_01102022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_backup_01102022 (
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


ALTER TABLE public.exp01_h_timeflrset_backup_01102022 OWNER TO psql;

--
-- TOC entry 1345 (class 1259 OID 81994210)
-- Name: exp01_h_timeflrset_backup_01102022_modified; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_backup_01102022_modified (
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


ALTER TABLE public.exp01_h_timeflrset_backup_01102022_modified OWNER TO psql;

--
-- TOC entry 1346 (class 1259 OID 81994215)
-- Name: exp01_h_timeflrset_before_mod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_before_mod (
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


ALTER TABLE public.exp01_h_timeflrset_before_mod OWNER TO psql;

--
-- TOC entry 1347 (class 1259 OID 81994220)
-- Name: exp01_h_timeflrset_bk20231027; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_bk20231027 (
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


ALTER TABLE public.exp01_h_timeflrset_bk20231027 OWNER TO psql;

--
-- TOC entry 1348 (class 1259 OID 81994225)
-- Name: exp01_h_timeflrset_bk20231029; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_bk20231029 (
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


ALTER TABLE public.exp01_h_timeflrset_bk20231029 OWNER TO psql;

--
-- TOC entry 1349 (class 1259 OID 81994230)
-- Name: exp01_h_timeflrset_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_bkp (
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


ALTER TABLE public.exp01_h_timeflrset_bkp OWNER TO psql;

--
-- TOC entry 1350 (class 1259 OID 81994242)
-- Name: exp01_h_timeflrset_mod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_mod (
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


ALTER TABLE public.exp01_h_timeflrset_mod OWNER TO psql;

--
-- TOC entry 1351 (class 1259 OID 81994247)
-- Name: exp01_h_timeflrset_pre_0202; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_pre_0202 (
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


ALTER TABLE public.exp01_h_timeflrset_pre_0202 OWNER TO psql;

--
-- TOC entry 1624 (class 1259 OID 84913408)
-- Name: exp01_h_timeflrset_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timeflrset_temp (
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


ALTER TABLE public.exp01_h_timeflrset_temp OWNER TO psql;

--
-- TOC entry 1352 (class 1259 OID 81994257)
-- Name: exp01_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timestd (
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


ALTER TABLE public.exp01_h_timestd OWNER TO psql;

--
-- TOC entry 1353 (class 1259 OID 81994269)
-- Name: exp01_h_timestd_02022020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timestd_02022020 (
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


ALTER TABLE public.exp01_h_timestd_02022020 OWNER TO psql;

--
-- TOC entry 1354 (class 1259 OID 81994274)
-- Name: exp01_h_timestd_bkp_12152024; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timestd_bkp_12152024 (
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


ALTER TABLE public.exp01_h_timestd_bkp_12152024 OWNER TO psql;

--
-- TOC entry 1355 (class 1259 OID 81994279)
-- Name: exp01_h_timestd_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timestd_new (
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


ALTER TABLE public.exp01_h_timestd_new OWNER TO psql;

--
-- TOC entry 1356 (class 1259 OID 81994284)
-- Name: exp01_h_timestd_pre_0202; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_h_timestd_pre_0202 (
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


ALTER TABLE public.exp01_h_timestd_pre_0202 OWNER TO psql;

--
-- TOC entry 1357 (class 1259 OID 81994289)
-- Name: exp01_l_apsindexlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_apsindexlookup (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    apsindex real DEFAULT 0.0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_apsindexlookup OWNER TO psql;

--
-- TOC entry 1358 (class 1259 OID 81994302)
-- Name: exp01_l_baseapslookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_baseapslookup (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    baseaps real DEFAULT 0.0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_baseapslookup OWNER TO psql;

--
-- TOC entry 1359 (class 1259 OID 81994315)
-- Name: exp01_l_ccranklookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_ccranklookup (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    slsrank smallint DEFAULT 0 NOT NULL,
    factor real DEFAULT 0.0,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_ccranklookup OWNER TO psql;

--
-- TOC entry 1360 (class 1259 OID 81994329)
-- Name: exp01_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_dclookup (
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


ALTER TABLE public.exp01_l_dclookup OWNER TO psql;

--
-- TOC entry 1361 (class 1259 OID 81994341)
-- Name: exp01_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_dependencylookup (
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


ALTER TABLE public.exp01_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1362 (class 1259 OID 81994355)
-- Name: exp01_l_dependencylookup_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_dependencylookup_archives (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_l_dependencylookup_archives OWNER TO psql;

--
-- TOC entry 1363 (class 1259 OID 81994360)
-- Name: exp01_l_dependencylookup_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_dependencylookup_existing (
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


ALTER TABLE public.exp01_l_dependencylookup_existing OWNER TO psql;

--
-- TOC entry 1364 (class 1259 OID 81994365)
-- Name: exp01_l_floorsetlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_floorsetlookup (
    product text NOT NULL,
    "time" text NOT NULL,
    initrcptwk text NOT NULL,
    too integer DEFAULT 1,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_floorsetlookup OWNER TO psql;

--
-- TOC entry 1365 (class 1259 OID 81994378)
-- Name: exp01_l_gradelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_gradelookup (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    grade text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_gradelookup OWNER TO psql;

--
-- TOC entry 1366 (class 1259 OID 81994390)
-- Name: exp01_l_lifecyclelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_lifecyclelookup (
    product text NOT NULL,
    weeks smallint NOT NULL,
    id text,
    name text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_lifecyclelookup OWNER TO psql;

--
-- TOC entry 1367 (class 1259 OID 81994402)
-- Name: exp01_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_priceeventlookup (
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


ALTER TABLE public.exp01_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 1368 (class 1259 OID 81994416)
-- Name: exp01_l_promodesclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_promodesclookup (
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


ALTER TABLE public.exp01_l_promodesclookup OWNER TO psql;

--
-- TOC entry 1369 (class 1259 OID 81994429)
-- Name: exp01_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_ssglookup (
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


ALTER TABLE public.exp01_l_ssglookup OWNER TO psql;

--
-- TOC entry 1370 (class 1259 OID 81994443)
-- Name: exp01_l_ssglookup_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_ssglookup_archives (
    product text,
    location text,
    ssg_id text,
    ssg_name text,
    stores text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_l_ssglookup_archives OWNER TO psql;

--
-- TOC entry 1371 (class 1259 OID 81994448)
-- Name: exp01_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_storedclookup (
    store text NOT NULL,
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


ALTER TABLE public.exp01_l_storedclookup OWNER TO psql;

--
-- TOC entry 1372 (class 1259 OID 81994460)
-- Name: exp01_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_storelookup (
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


ALTER TABLE public.exp01_l_storelookup OWNER TO psql;

--
-- TOC entry 1373 (class 1259 OID 81994474)
-- Name: exp01_l_storelookup_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_storelookup_archives (
    "time" text,
    product text,
    id text,
    value text,
    stores text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_l_storelookup_archives OWNER TO psql;

--
-- TOC entry 1374 (class 1259 OID 81994479)
-- Name: exp01_l_weeklookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_l_weeklookup (
    "time" text NOT NULL,
    ly text NOT NULL,
    lly text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_l_weeklookup OWNER TO psql;

--
-- TOC entry 1375 (class 1259 OID 81994491)
-- Name: exp01_ma_classattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_classattributes (
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


ALTER TABLE public.exp01_ma_classattributes OWNER TO psql;

--
-- TOC entry 1376 (class 1259 OID 81994503)
-- Name: exp01_ma_districtattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_districtattributes (
    indx integer NOT NULL,
    location text NOT NULL,
    districtlatitude double precision,
    districtlongitude double precision,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_ma_districtattributes OWNER TO psql;

--
-- TOC entry 1377 (class 1259 OID 81994515)
-- Name: exp01_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1378 (class 1259 OID 81994520)
-- Name: exp01_ma_dptflrsetattributes_01172020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_01172020 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_01172020 OWNER TO psql;

--
-- TOC entry 1379 (class 1259 OID 81994525)
-- Name: exp01_ma_dptflrsetattributes_02022020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_02022020 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_02022020 OWNER TO psql;

--
-- TOC entry 1380 (class 1259 OID 81994530)
-- Name: exp01_ma_dptflrsetattributes_040321; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_040321 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_040321 OWNER TO psql;

--
-- TOC entry 1381 (class 1259 OID 81994535)
-- Name: exp01_ma_dptflrsetattributes_20240830; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_20240830 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_20240830 OWNER TO psql;

--
-- TOC entry 1382 (class 1259 OID 81994540)
-- Name: exp01_ma_dptflrsetattributes_old; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_old (
    indx integer,
    product text NOT NULL,
    "time" text NOT NULL,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text DEFAULT ''::text,
    lyslsstart text DEFAULT ''::text,
    too integer,
    ap_start text DEFAULT ''::text,
    ap_end text DEFAULT ''::text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    default_discountpct real DEFAULT 0.0,
    default_imupct real DEFAULT 0.0,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_old OWNER TO psql;

--
-- TOC entry 1383 (class 1259 OID 81994553)
-- Name: exp01_ma_dptflrsetattributes_view; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_ma_dptflrsetattributes_view AS
 SELECT exp01_ma_dptflrsetattributes_old.product,
    exp01_ma_dptflrsetattributes_old."time",
    exp01_ma_dptflrsetattributes_old.rcptstart,
    exp01_ma_dptflrsetattributes_old.rcptend,
    exp01_ma_dptflrsetattributes_old.ap_start,
    exp01_ma_dptflrsetattributes_old.ap_end
   FROM public.exp01_ma_dptflrsetattributes_old;


ALTER VIEW public.exp01_ma_dptflrsetattributes_view OWNER TO psql;

--
-- TOC entry 1384 (class 1259 OID 81994557)
-- Name: exp01_ma_dptflrsetattributes_ap_time_view; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_ma_dptflrsetattributes_ap_time_view AS
 SELECT a.product,
    a."time",
    a.rcptstart,
    a.rcptend,
    a.ap_start,
    a.ap_end,
    b.id AS ap_weeks,
    row_number() OVER (PARTITION BY a.product, a."time" ORDER BY b.id) AS ap_indx
   FROM public.exp01_ma_dptflrsetattributes_view a,
    public.exp01_d_time b
  WHERE ((b.id >= a.ap_start) AND (b.id <= a.ap_end) AND (b.levelid = 'week'::text))
  ORDER BY b.id;


ALTER VIEW public.exp01_ma_dptflrsetattributes_ap_time_view OWNER TO psql;

--
-- TOC entry 1385 (class 1259 OID 81994561)
-- Name: exp01_ma_dptflrsetattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_archives (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer,
    sync_time timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_archives OWNER TO psql;

--
-- TOC entry 1386 (class 1259 OID 81994566)
-- Name: exp01_ma_dptflrsetattributes_bk20231027; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_bk20231027 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_bk20231027 OWNER TO psql;

--
-- TOC entry 1387 (class 1259 OID 81994571)
-- Name: exp01_ma_dptflrsetattributes_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_existing (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_existing OWNER TO psql;

--
-- TOC entry 1388 (class 1259 OID 81994576)
-- Name: exp01_ma_dptflrsetattributes_jun172020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_jun172020 (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_jun172020 OWNER TO psql;

--
-- TOC entry 1389 (class 1259 OID 81994581)
-- Name: exp01_ma_dptflrsetattributes_rcpt_time_view; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_ma_dptflrsetattributes_rcpt_time_view AS
 SELECT a.product,
    a."time",
    a.rcptstart,
    a.rcptend,
    a.ap_start,
    a.ap_end,
    b.id AS rcpt_weeks,
    row_number() OVER (PARTITION BY a.product, a."time" ORDER BY b.id) AS rcpt_indx
   FROM public.exp01_ma_dptflrsetattributes_view a,
    public.exp01_d_time b
  WHERE ((b.id >= a.rcptstart) AND (b.id <= a.rcptend) AND (b.levelid = 'week'::text))
  ORDER BY b.id;


ALTER VIEW public.exp01_ma_dptflrsetattributes_rcpt_time_view OWNER TO psql;

--
-- TOC entry 1390 (class 1259 OID 81994585)
-- Name: exp01_ma_dptflrsetattributes_rcpt_ap_time_view; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_ma_dptflrsetattributes_rcpt_ap_time_view AS
 SELECT a.product,
    a."time",
    a.rcptstart,
    a.rcptend,
    a.ap_start,
    a.ap_end,
    a.rcpt_weeks,
    a.rcpt_indx,
    b.ap_weeks
   FROM public.exp01_ma_dptflrsetattributes_rcpt_time_view a,
    public.exp01_ma_dptflrsetattributes_ap_time_view b
  WHERE ((a.product = b.product) AND (a."time" = b."time") AND (a.rcpt_indx = b.ap_indx));


ALTER VIEW public.exp01_ma_dptflrsetattributes_rcpt_ap_time_view OWNER TO psql;

--
-- TOC entry 1391 (class 1259 OID 81994589)
-- Name: exp01_ma_dptflrsetattributes_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_dptflrsetattributes_storecount (
    product text,
    "time" text,
    default_store_count integer
);


ALTER TABLE public.exp01_ma_dptflrsetattributes_storecount OWNER TO psql;

--
-- TOC entry 1392 (class 1259 OID 81994594)
-- Name: exp01_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes (
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


ALTER TABLE public.exp01_ma_imgattributes OWNER TO psql;

--
-- TOC entry 1393 (class 1259 OID 81994606)
-- Name: exp01_ma_imgattributes_02182020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_02182020 (
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


ALTER TABLE public.exp01_ma_imgattributes_02182020 OWNER TO psql;

--
-- TOC entry 1394 (class 1259 OID 81994611)
-- Name: exp01_ma_imgattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_archives (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_imgattributes_archives OWNER TO psql;

--
-- TOC entry 1395 (class 1259 OID 81994616)
-- Name: exp01_ma_imgattributes_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_archives_0220 (
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


ALTER TABLE public.exp01_ma_imgattributes_archives_0220 OWNER TO psql;

--
-- TOC entry 1396 (class 1259 OID 81994621)
-- Name: exp01_ma_imgattributes_archives_sup_1077; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_archives_sup_1077 (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_imgattributes_archives_sup_1077 OWNER TO psql;

--
-- TOC entry 1397 (class 1259 OID 81994626)
-- Name: exp01_ma_imgattributes_bk20231030; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_bk20231030 (
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


ALTER TABLE public.exp01_ma_imgattributes_bk20231030 OWNER TO psql;

--
-- TOC entry 1633 (class 1259 OID 136812727)
-- Name: exp01_ma_imgattributes_bkp_20260918; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_bkp_20260918 (
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
    img_from_etl text
);


ALTER TABLE public.exp01_ma_imgattributes_bkp_20260918 OWNER TO psql;

--
-- TOC entry 1632 (class 1259 OID 106107363)
-- Name: exp01_ma_imgattributes_bkp_expimg; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_bkp_expimg (
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
    img_from_etl text
);


ALTER TABLE public.exp01_ma_imgattributes_bkp_expimg OWNER TO psql;

--
-- TOC entry 1398 (class 1259 OID 81994631)
-- Name: exp01_ma_imgattributes_hs_prod; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_hs_prod (
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


ALTER TABLE public.exp01_ma_imgattributes_hs_prod OWNER TO psql;

--
-- TOC entry 1399 (class 1259 OID 81994643)
-- Name: exp01_ma_imgattributes_sup_1077; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_sup_1077 (
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


ALTER TABLE public.exp01_ma_imgattributes_sup_1077 OWNER TO psql;

--
-- TOC entry 1400 (class 1259 OID 81994648)
-- Name: exp01_ma_imgattributes_sup_1077_20240421; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_imgattributes_sup_1077_20240421 (
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
    img_from_etl text
);


ALTER TABLE public.exp01_ma_imgattributes_sup_1077_20240421 OWNER TO psql;

--
-- TOC entry 1401 (class 1259 OID 81994653)
-- Name: exp01_ma_regionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_regionattributes (
    indx integer NOT NULL,
    location text NOT NULL,
    regionlatitude double precision,
    regionlongitude double precision,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_ma_regionattributes OWNER TO psql;

--
-- TOC entry 1402 (class 1259 OID 81994665)
-- Name: exp01_ma_regionattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_regionattributes_archives (
    indx integer,
    location text,
    regionlatitude double precision,
    regionlongitude double precision,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_ma_regionattributes_archives OWNER TO psql;

--
-- TOC entry 1403 (class 1259 OID 81994670)
-- Name: exp01_ma_sizeaattributes_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeaattributes_dp5 (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeaattributes_dp5 OWNER TO psql;

--
-- TOC entry 1404 (class 1259 OID 81994675)
-- Name: exp01_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes (
    product text NOT NULL,
    sizeattribute text NOT NULL,
    parent_id text,
    isvalid integer DEFAULT 1,
    size_name text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    size_id text DEFAULT '99999'::text
);


ALTER TABLE public.exp01_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1405 (class 1259 OID 81994683)
-- Name: exp01_ma_sizeattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_archives (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_sizeattributes_archives OWNER TO psql;

--
-- TOC entry 1406 (class 1259 OID 81994688)
-- Name: exp01_ma_sizeattributes_archives_0219_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_archives_0219_0220 (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_sizeattributes_archives_0219_0220 OWNER TO psql;

--
-- TOC entry 1407 (class 1259 OID 81994693)
-- Name: exp01_ma_sizeattributes_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_archives_0220 (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_archives_0220 OWNER TO psql;

--
-- TOC entry 1408 (class 1259 OID 81994698)
-- Name: exp01_ma_sizeattributes_before_sizeconversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_before_sizeconversion (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_before_sizeconversion OWNER TO psql;

--
-- TOC entry 1409 (class 1259 OID 81994703)
-- Name: exp01_ma_sizeattributes_before_sizeconversion_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_before_sizeconversion_backup (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_before_sizeconversion_backup OWNER TO psql;

--
-- TOC entry 1410 (class 1259 OID 81994708)
-- Name: exp01_ma_sizeattributes_conv; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_conv (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_conv OWNER TO psql;

--
-- TOC entry 1411 (class 1259 OID 81994713)
-- Name: exp01_ma_sizeattributes_jun182021_4sizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_jun182021_4sizes (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_jun182021_4sizes OWNER TO psql;

--
-- TOC entry 1412 (class 1259 OID 81994718)
-- Name: exp01_ma_sizeattributes_new_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_new_2 (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_new_2 OWNER TO psql;

--
-- TOC entry 1413 (class 1259 OID 81994723)
-- Name: exp01_ma_sizeattributes_tx; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_sizeattributes_tx (
    product text,
    sizeattribute text,
    parent_id text,
    isvalid integer,
    size_name text,
    updated_at timestamp without time zone,
    size_id text
);


ALTER TABLE public.exp01_ma_sizeattributes_tx OWNER TO psql;

--
-- TOC entry 1414 (class 1259 OID 81994728)
-- Name: exp01_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_storeattributes (
    indx integer,
    location text NOT NULL,
    strname text DEFAULT 'Undefined'::text,
    strdcorstr text DEFAULT 'Undefined'::text,
    strdefaultwh text DEFAULT 'Undefined'::text,
    strclosedate text DEFAULT 'Undefined'::text,
    strremodeldate text DEFAULT 'Undefined'::text,
    strttotalsqft integer,
    strsellingsqft integer,
    strmenssqft integer,
    strstockholdingind text DEFAULT 'Undefined'::text,
    strnonsellingind text DEFAULT 'Undefined'::text,
    strgolivedate text DEFAULT 'Undefined'::text,
    strshoptypecode text DEFAULT 'Undefined'::text,
    strtype text DEFAULT 'Undefined'::text,
    strautorcv text DEFAULT 'Undefined'::text,
    strremerchind text DEFAULT 'Undefined'::text,
    strtimezone text DEFAULT 'Undefined'::text,
    sstrgeozone text DEFAULT 'Undefined'::text,
    straddress text DEFAULT 'Undefined'::text,
    strcity text DEFAULT 'Undefined'::text,
    strstate text DEFAULT 'Undefined'::text,
    strlatitude double precision,
    strlongitude double precision,
    strformat text DEFAULT 'Undefined'::text,
    strwomenssqft integer,
    strclimate text DEFAULT 'Undefined'::text,
    strmenscapacity text DEFAULT 'Undefined'::text,
    strwomenscapacity text DEFAULT 'Undefined'::text,
    strcorpvoltier text DEFAULT 'Undefined'::text,
    strdistrict text DEFAULT 'Undefined'::text,
    strregion text DEFAULT 'Undefined'::text,
    strarea text DEFAULT 'Undefined'::text,
    strselling_channel text DEFAULT 'Undefined'::text,
    strchannel text DEFAULT 'Undefined'::text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_ma_storeattributes OWNER TO psql;

--
-- TOC entry 1415 (class 1259 OID 81994767)
-- Name: exp01_ma_storeattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_storeattributes_archives (
    indx integer,
    location text,
    strname text,
    strdcorstr text,
    strdefaultwh text,
    strclosedate text,
    strremodeldate text,
    strttotalsqft integer,
    strsellingsqft integer,
    strmenssqft integer,
    strstockholdingind text,
    strnonsellingind text,
    strgolivedate text,
    strshoptypecode text,
    strtype text,
    strautorcv text,
    strremerchind text,
    strtimezone text,
    sstrgeozone text,
    straddress text,
    strcity text,
    strstate text,
    strlatitude double precision,
    strlongitude double precision,
    strformat text,
    strwomenssqft integer,
    strclimate text,
    strmenscapacity text,
    strwomenscapacity text,
    strcorpvoltier text,
    strdistrict text,
    strregion text,
    strarea text,
    strselling_channel text,
    strchannel text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_storeattributes_archives OWNER TO psql;

--
-- TOC entry 1416 (class 1259 OID 81994772)
-- Name: exp01_ma_styleaattributes_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleaattributes_dp5 (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text
);


ALTER TABLE public.exp01_ma_styleaattributes_dp5 OWNER TO psql;

--
-- TOC entry 1417 (class 1259 OID 81994777)
-- Name: exp01_ma_styleattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes_archives (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text,
    express_size_range text,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_styleattributes_archives OWNER TO psql;

--
-- TOC entry 1418 (class 1259 OID 81994782)
-- Name: exp01_ma_styleattributes_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes_archives_0220 (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text
);


ALTER TABLE public.exp01_ma_styleattributes_archives_0220 OWNER TO psql;

--
-- TOC entry 1419 (class 1259 OID 81994787)
-- Name: exp01_ma_styleattributes_backup_11052020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes_backup_11052020 (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text
);


ALTER TABLE public.exp01_ma_styleattributes_backup_11052020 OWNER TO psql;

--
-- TOC entry 1420 (class 1259 OID 81994792)
-- Name: exp01_ma_styleattributes_backup_11142021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes_backup_11142021 (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text,
    express_size_range text
);


ALTER TABLE public.exp01_ma_styleattributes_backup_11142021 OWNER TO psql;

--
-- TOC entry 1421 (class 1259 OID 81994797)
-- Name: exp01_ma_styleattributes_change_sizerange; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_styleattributes_change_sizerange (
    indx integer,
    product text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    isassortmentstyle text,
    hasbeenpatternedafterstyle text,
    islockedstyle text,
    size_range_lookup text,
    fabric_lookup text,
    ccsizerange text,
    ccsubclassdesc text
);


ALTER TABLE public.exp01_ma_styleattributes_change_sizerange OWNER TO psql;

--
-- TOC entry 1422 (class 1259 OID 81994802)
-- Name: exp01_ma_stylecolorattributes_20211226; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_20211226 (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    ccmannequinlooks text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_20211226 OWNER TO psql;

--
-- TOC entry 1423 (class 1259 OID 81994807)
-- Name: exp01_ma_stylecolorattributes_20211226_load; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_20211226_load (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    ccmannequinlooks text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_20211226_load OWNER TO psql;

--
-- TOC entry 1424 (class 1259 OID 81994812)
-- Name: exp01_ma_stylecolorattributes_20211226_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_20211226_test (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    ccmannequinlooks text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_20211226_test OWNER TO psql;

--
-- TOC entry 1425 (class 1259 OID 81994817)
-- Name: exp01_ma_stylecolorattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_archives (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    sync_date timestamp(0) without time zone,
    ccmannequinlooks text DEFAULT 'Undefined'::text,
    ccfashiontier text DEFAULT 'Undefined'::text,
    ccedit text DEFAULT 'Undefined'::text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_archives OWNER TO psql;

--
-- TOC entry 1426 (class 1259 OID 81994825)
-- Name: exp01_ma_stylecolorattributes_archives_0219_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_archives_0219_0220 (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_stylecolorattributes_archives_0219_0220 OWNER TO psql;

--
-- TOC entry 1427 (class 1259 OID 81994830)
-- Name: exp01_ma_stylecolorattributes_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_archives_0220 (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_archives_0220 OWNER TO psql;

--
-- TOC entry 1428 (class 1259 OID 81994835)
-- Name: exp01_ma_stylecolorattributes_backup_11052020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_backup_11052020 (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_backup_11052020 OWNER TO psql;

--
-- TOC entry 1429 (class 1259 OID 81994840)
-- Name: exp01_ma_stylecolorattributes_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_dp5 (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_dp5 OWNER TO psql;

--
-- TOC entry 1430 (class 1259 OID 81994845)
-- Name: exp01_ma_stylecolorattributes_wrongspecstyle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorattributes_wrongspecstyle (
    indx integer,
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ispublishable text,
    hasbeenpatternedafter text,
    merch_comments text,
    plan_comments text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    ccsizerange text,
    ccplmcolor text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    ccmarketingimage_sclr text,
    cccin text
);


ALTER TABLE public.exp01_ma_stylecolorattributes_wrongspecstyle OWNER TO psql;

--
-- TOC entry 1431 (class 1259 OID 81994850)
-- Name: exp01_ma_stylecolorchannelattributes_01242021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_01242021 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_01242021 OWNER TO psql;

--
-- TOC entry 1432 (class 1259 OID 81994855)
-- Name: exp01_ma_stylecolorchannelattributes_05132023; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_05132023 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_05132023 OWNER TO psql;

--
-- TOC entry 1433 (class 1259 OID 81994860)
-- Name: exp01_ma_stylecolorchannelattributes_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_2 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_2 OWNER TO psql;

--
-- TOC entry 1434 (class 1259 OID 81994865)
-- Name: exp01_ma_stylecolorchannelattributes_3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_3 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_3 OWNER TO psql;

--
-- TOC entry 1435 (class 1259 OID 81994870)
-- Name: exp01_ma_stylecolorchannelattributes_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_archives (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_archives OWNER TO psql;

--
-- TOC entry 1436 (class 1259 OID 81994875)
-- Name: exp01_ma_stylecolorchannelattributes_archives_0219_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_archives_0219_0220 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_archives_0219_0220 OWNER TO psql;

--
-- TOC entry 1437 (class 1259 OID 81994880)
-- Name: exp01_ma_stylecolorchannelattributes_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_archives_0220 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_archives_0220 OWNER TO psql;

--
-- TOC entry 1438 (class 1259 OID 81994885)
-- Name: exp01_ma_stylecolorchannelattributes_bak_07152020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_bak_07152020 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_bak_07152020 OWNER TO psql;

--
-- TOC entry 1439 (class 1259 OID 81994890)
-- Name: exp01_ma_stylecolorchannelattributes_before_sizeconversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_before_sizeconversion (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_before_sizeconversion OWNER TO psql;

--
-- TOC entry 1440 (class 1259 OID 81994895)
-- Name: exp01_ma_stylecolorchannelattributes_before_sizeconversion_back; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_before_sizeconversion_back (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_before_sizeconversion_back OWNER TO psql;

--
-- TOC entry 1441 (class 1259 OID 81994900)
-- Name: exp01_ma_stylecolorchannelattributes_bk20240903; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_bk20240903 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_bk20240903 OWNER TO psql;

--
-- TOC entry 1442 (class 1259 OID 81994905)
-- Name: exp01_ma_stylecolorchannelattributes_change_sizerange; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_change_sizerange (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_change_sizerange OWNER TO psql;

--
-- TOC entry 1443 (class 1259 OID 81994910)
-- Name: exp01_ma_stylecolorchannelattributes_dp5; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_dp5 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_dp5 OWNER TO psql;

--
-- TOC entry 1444 (class 1259 OID 81994915)
-- Name: exp01_ma_stylecolorchannelattributes_hs_abridged; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_hs_abridged (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_hs_abridged OWNER TO psql;

--
-- TOC entry 1445 (class 1259 OID 81994920)
-- Name: exp01_ma_stylecolorchannelattributes_hs_modified; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_hs_modified (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_hs_modified OWNER TO psql;

--
-- TOC entry 1446 (class 1259 OID 81994925)
-- Name: exp01_ma_stylecolorchannelattributes_mod3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_mod3 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_mod3 OWNER TO psql;

--
-- TOC entry 1447 (class 1259 OID 81994930)
-- Name: exp01_ma_stylecolorchannelattributes_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_new (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_new OWNER TO psql;

--
-- TOC entry 1448 (class 1259 OID 81994935)
-- Name: exp01_ma_stylecolorchannelattributes_pre_june142020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_pre_june142020 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_pre_june142020 OWNER TO psql;

--
-- TOC entry 1449 (class 1259 OID 81994940)
-- Name: exp01_ma_stylecolorchannelattributes_testjr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_testjr (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    auto_rollforward boolean,
    irr_mode text,
    plan_current text
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_testjr OWNER TO psql;

--
-- TOC entry 1450 (class 1259 OID 81994945)
-- Name: exp01_ma_stylecolorchannelattributes_updated; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_stylecolorchannelattributes_updated (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    cc_target_cost real
);


ALTER TABLE public.exp01_ma_stylecolorchannelattributes_updated OWNER TO psql;

--
-- TOC entry 1451 (class 1259 OID 81994950)
-- Name: exp01_ma_styleproddetailattributes; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_ma_styleproddetailattributes AS
 SELECT b.product,
    b.ccproddetail,
    b.eventdate,
    b.version_id,
    b.created_at,
    b.created_by,
    b.updated_at,
    b.updated_by,
    b.record_state
   FROM ( SELECT a.product,
            unnest(string_to_array(a.ccproddetail, ','::text)) AS ccproddetail,
            a.eventdate,
            a.version_id,
            a.created_at,
            a.created_by,
            a.updated_at,
            a.updated_by,
            a.record_state
           FROM ( SELECT exp01_ma_styleattributes.product,
                    regexp_replace(exp01_ma_styleattributes.ccproductdetail, '[\{\}]'::text, ''::text, 'g'::text) AS ccproddetail,
                    exp01_ma_styleattributes.eventdate,
                    exp01_ma_styleattributes.version_id,
                    exp01_ma_styleattributes.created_at,
                    exp01_ma_styleattributes.created_by,
                    exp01_ma_styleattributes.updated_at,
                    exp01_ma_styleattributes.updated_by,
                    exp01_ma_styleattributes.record_state
                   FROM public.exp01_ma_styleattributes
                  WHERE (exp01_ma_styleattributes.ccproductdetail IS NOT NULL)) a) b;


ALTER VIEW public.exp01_ma_styleproddetailattributes OWNER TO psql;

--
-- TOC entry 1452 (class 1259 OID 81994955)
-- Name: exp01_ma_subclassattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_subclassattributes (
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


ALTER TABLE public.exp01_ma_subclassattributes OWNER TO psql;

--
-- TOC entry 1453 (class 1259 OID 81994967)
-- Name: exp01_ma_subclassattributes_all_subs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_subclassattributes_all_subs (
    indx integer,
    product text,
    conceptstyleid text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    conceptstylecolorid text
);


ALTER TABLE public.exp01_ma_subclassattributes_all_subs OWNER TO psql;

--
-- TOC entry 1454 (class 1259 OID 81994972)
-- Name: exp01_ma_subclassattributes_channel; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_subclassattributes_channel (
    indx integer,
    product text,
    conceptstyleid text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    conceptstylecolorid text,
    channel text
);


ALTER TABLE public.exp01_ma_subclassattributes_channel OWNER TO psql;

--
-- TOC entry 1455 (class 1259 OID 81994977)
-- Name: exp01_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_weekattributes (
    "time" text NOT NULL,
    start_date text DEFAULT ''::text,
    end_date text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_ma_weekattributes OWNER TO psql;

--
-- TOC entry 1622 (class 1259 OID 84913398)
-- Name: exp01_ma_weekattributes_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_weekattributes_backup (
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


ALTER TABLE public.exp01_ma_weekattributes_backup OWNER TO psql;

--
-- TOC entry 1625 (class 1259 OID 84913413)
-- Name: exp01_ma_weekattributes_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_ma_weekattributes_temp (
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


ALTER TABLE public.exp01_ma_weekattributes_temp OWNER TO psql;

--
-- TOC entry 1456 (class 1259 OID 81995000)
-- Name: exp01_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_channeloverride (
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
    floorsetpo text,
    ec_str_po text
);


ALTER TABLE public.exp01_p_channeloverride OWNER TO psql;

--
-- TOC entry 1457 (class 1259 OID 81995015)
-- Name: exp01_p_channeloverride_20240318; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_channeloverride_20240318 (
    product text,
    location text,
    "time" text,
    weekadjaps real,
    weekadjslsu real,
    comments text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    testpo text,
    floorsetpo text
);


ALTER TABLE public.exp01_p_channeloverride_20240318 OWNER TO psql;

--
-- TOC entry 1458 (class 1259 OID 81995021)
-- Name: exp01_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj (
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
    po_id text
);


ALTER TABLE public.exp01_p_dc_adj OWNER TO psql;

--
-- TOC entry 1459 (class 1259 OID 81995035)
-- Name: exp01_p_dc_adj_05152021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_05152021 (
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
    published_at timestamp(0) without time zone
);


ALTER TABLE public.exp01_p_dc_adj_05152021 OWNER TO psql;

--
-- TOC entry 1460 (class 1259 OID 81995040)
-- Name: exp01_p_dc_adj_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_archives (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_p_dc_adj_archives OWNER TO psql;

--
-- TOC entry 1461 (class 1259 OID 81995045)
-- Name: exp01_p_dc_adj_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_archives_0220 (
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
    published_at timestamp(0) without time zone
);


ALTER TABLE public.exp01_p_dc_adj_archives_0220 OWNER TO psql;

--
-- TOC entry 1462 (class 1259 OID 81995050)
-- Name: exp01_p_dc_adj_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_bk (
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
    po_id text
);


ALTER TABLE public.exp01_p_dc_adj_bk OWNER TO psql;

--
-- TOC entry 1463 (class 1259 OID 81995055)
-- Name: exp01_p_dc_adj_pg_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_pg_size (
    member_id character varying(200),
    week_id character varying(200),
    on_order_r real,
    on_order_u real,
    on_order_c real,
    adj_cost real,
    channel text
);


ALTER TABLE public.exp01_p_dc_adj_pg_size OWNER TO psql;

--
-- TOC entry 1464 (class 1259 OID 81995060)
-- Name: exp01_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_size (
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
    record_state smallint
);


ALTER TABLE public.exp01_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 1465 (class 1259 OID 81995067)
-- Name: exp01_p_dc_adj_size_05152021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_size_05152021 (
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
    record_state smallint
);


ALTER TABLE public.exp01_p_dc_adj_size_05152021 OWNER TO psql;

--
-- TOC entry 1466 (class 1259 OID 81995072)
-- Name: exp01_p_dc_adj_size_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_size_archives (
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
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_p_dc_adj_size_archives OWNER TO psql;

--
-- TOC entry 1467 (class 1259 OID 81995077)
-- Name: exp01_p_dc_adj_size_archives_0220; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_size_archives_0220 (
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
    record_state smallint
);


ALTER TABLE public.exp01_p_dc_adj_size_archives_0220 OWNER TO psql;

--
-- TOC entry 1468 (class 1259 OID 81995082)
-- Name: exp01_p_dc_adj_size_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_size_bk (
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
    record_state smallint
);


ALTER TABLE public.exp01_p_dc_adj_size_bk OWNER TO psql;

--
-- TOC entry 1469 (class 1259 OID 81995087)
-- Name: exp01_p_dc_adj_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_dc_adj_stylecolor (
    stylecolor text,
    week_id text,
    on_order_r real,
    on_order_u real,
    on_order_c real,
    adj_cost real,
    channel text
);


ALTER TABLE public.exp01_p_dc_adj_stylecolor OWNER TO psql;

--
-- TOC entry 1470 (class 1259 OID 81995092)
-- Name: exp01_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_p_itemprice (
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


ALTER TABLE public.exp01_p_itemprice OWNER TO psql;

--
-- TOC entry 1471 (class 1259 OID 81995104)
-- Name: exp01_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_pg_batch_validation (
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


ALTER TABLE public.exp01_pg_batch_validation OWNER TO psql;

--
-- TOC entry 1472 (class 1259 OID 81995110)
-- Name: exp01_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_pg_batch_validation_archive (
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


ALTER TABLE public.exp01_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 1473 (class 1259 OID 81995116)
-- Name: exp01_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_pg_batch_validation_failure (
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


ALTER TABLE public.exp01_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 1474 (class 1259 OID 81995122)
-- Name: exp01_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_pg_batch_validation_previous (
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


ALTER TABLE public.exp01_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 1475 (class 1259 OID 81995128)
-- Name: exp01_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_roledimension (
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


ALTER TABLE public.exp01_roledimension OWNER TO psql;

--
-- TOC entry 1476 (class 1259 OID 81995140)
-- Name: exp01_roledimension_0802; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_roledimension_0802 (
    tenantid text,
    roleid text,
    dimensionid text,
    levelids text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_roledimension_0802 OWNER TO psql;

--
-- TOC entry 1477 (class 1259 OID 81995145)
-- Name: exp01_roledimension_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_roledimension_temp (
    tenantid text,
    roleid text,
    dimensionid text,
    levelids text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_roledimension_temp OWNER TO psql;

--
-- TOC entry 1478 (class 1259 OID 81995150)
-- Name: exp01_s5replannablestyleclr_inbound; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_s5replannablestyleclr_inbound (
    member_id text
);


ALTER TABLE public.exp01_s5replannablestyleclr_inbound OWNER TO psql;

--
-- TOC entry 1479 (class 1259 OID 81995155)
-- Name: exp01_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_servicedefn (
    service text NOT NULL,
    authlevels text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_servicedefn OWNER TO psql;

--
-- TOC entry 1480 (class 1259 OID 81995167)
-- Name: exp01_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_serviceparams (
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


ALTER TABLE public.exp01_serviceparams OWNER TO psql;

--
-- TOC entry 1481 (class 1259 OID 81995179)
-- Name: exp01_serviceparams_02162020; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_serviceparams_02162020 (
    id text,
    type text,
    value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_serviceparams_02162020 OWNER TO psql;

--
-- TOC entry 1482 (class 1259 OID 81995184)
-- Name: exp01_serviceparams_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_serviceparams_archives (
    id text,
    type text,
    value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_serviceparams_archives OWNER TO psql;

--
-- TOC entry 1483 (class 1259 OID 81995189)
-- Name: exp01_serviceparams_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_serviceparams_bkp (
    id text,
    type text,
    value text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.exp01_serviceparams_bkp OWNER TO psql;

--
-- TOC entry 1484 (class 1259 OID 81995194)
-- Name: exp01_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.exp01_sizinglookup OWNER TO psql;

--
-- TOC entry 8387 (class 0 OID 0)
-- Dependencies: 1484
-- Name: TABLE exp01_sizinglookup; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.exp01_sizinglookup IS 'Sizing profiles table';


--
-- TOC entry 8388 (class 0 OID 0)
-- Dependencies: 1484
-- Name: COLUMN exp01_sizinglookup.nsp; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.exp01_sizinglookup.nsp IS 'Nominal sale percentage';


--
-- TOC entry 8389 (class 0 OID 0)
-- Dependencies: 1484
-- Name: COLUMN exp01_sizinglookup.multiplier; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON COLUMN public.exp01_sizinglookup.multiplier IS 'Multiplier used to normalize';


--
-- TOC entry 1485 (class 1259 OID 81995199)
-- Name: exp01_sizinglookup_0730; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup_0730 (
    sizerange text,
    size text,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.exp01_sizinglookup_0730 OWNER TO psql;

--
-- TOC entry 1486 (class 1259 OID 81995204)
-- Name: exp01_sizinglookup_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup_backup (
    sizerange text,
    size text,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.exp01_sizinglookup_backup OWNER TO psql;

--
-- TOC entry 1487 (class 1259 OID 81995209)
-- Name: exp01_sizinglookup_backup_10022021; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup_backup_10022021 (
    sizerange text,
    size text,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.exp01_sizinglookup_backup_10022021 OWNER TO psql;

--
-- TOC entry 1488 (class 1259 OID 81995214)
-- Name: exp01_sizinglookup_bak0710; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup_bak0710 (
    sizerange text,
    size text,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.exp01_sizinglookup_bak0710 OWNER TO psql;

--
-- TOC entry 1489 (class 1259 OID 81995219)
-- Name: exp01_sizinglookup_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_sizinglookup_prep (
    sizerange text,
    size text,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text,
    indx bigint
);


ALTER TABLE public.exp01_sizinglookup_prep OWNER TO psql;

--
-- TOC entry 1490 (class 1259 OID 81995224)
-- Name: exp01_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.exp01_specimages OWNER TO psql;

--
-- TOC entry 1634 (class 1259 OID 136839476)
-- Name: exp01_specimages_tmp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_specimages_tmp (
    product text,
    img text
);


ALTER TABLE public.exp01_specimages_tmp OWNER TO psql;

--
-- TOC entry 1491 (class 1259 OID 81995234)
-- Name: exp01_specimages_tmp_bak0712; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_specimages_tmp_bak0712 (
    product text,
    img text
);


ALTER TABLE public.exp01_specimages_tmp_bak0712 OWNER TO psql;

--
-- TOC entry 1492 (class 1259 OID 81995239)
-- Name: exp01_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_store_hier_attr AS
 SELECT a.location,
    a.strname,
    a.strdcorstr,
    a.strdefaultwh,
    a.strclosedate,
    a.strremodeldate,
    a.strttotalsqft,
    a.strsellingsqft,
    a.strmenssqft,
    a.strstockholdingind,
    a.strnonsellingind,
    a.strgolivedate,
    a.strshoptypecode,
    a.strtype,
    a.strautorcv,
    a.strremerchind,
    a.strtimezone,
    a.sstrgeozone,
    a.straddress,
    a.strcity,
    a.strstate,
    a.strlatitude,
    a.strlongitude,
    a.strformat,
    a.strwomenssqft,
    a.strclimate,
    a.strmenscapacity,
    a.strwomenscapacity,
    a.strcorpvoltier,
    b.ancestor0 AS district,
    b.ancestor1 AS region,
    b.ancestor2 AS area,
    b.ancestor3 AS selling_channel,
    b.ancestor4 AS channel,
    CURRENT_DATE AS eventdate,
    1 AS version_id,
    date_trunc('sec'::text, CURRENT_TIMESTAMP) AS created_at,
    'system'::text AS created_by,
    date_trunc('sec'::text, CURRENT_TIMESTAMP) AS updated_at,
    'system'::text AS updated_by,
    0 AS record_state
   FROM public.exp01_ma_storeattributes a,
    public.exp01_h_locstd b
  WHERE (a.location = b.id)
  ORDER BY a.location;


ALTER VIEW public.exp01_store_hier_attr OWNER TO psql;

--
-- TOC entry 1493 (class 1259 OID 81995244)
-- Name: exp01_stylecolor_hier_attr_20220916; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_stylecolor_hier_attr_20220916 (
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    stylecolor text,
    style text,
    subclass text,
    class text,
    department text,
    group_prd text,
    top_bottom text,
    gender text,
    division text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    clssubclassid text,
    clssubclassname text,
    clssubclassdesc text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccsizerange text,
    ccname text,
    ccdesc text,
    style_name text,
    style_desc text,
    ccplmcolor text,
    ispublishable text,
    fabric_lookup text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    merch_comments text,
    plan_comments text,
    ccmannequinlooks text
);


ALTER TABLE public.exp01_stylecolor_hier_attr_20220916 OWNER TO psql;

--
-- TOC entry 1494 (class 1259 OID 81995249)
-- Name: exp01_stylecolor_hier_attr_hs; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_stylecolor_hier_attr_hs AS
 SELECT a.product,
    a.ccfloorset,
    a.ccstoretier,
    a.ccmarkdownflag,
    a.ccprintid,
    a.ccmos,
    a.ccrecall,
    a.ccunavailable,
    a.cccolorid,
    a.cccolor,
    a.cccolorfamily,
    a.cccurp,
    a.ccspecstylestyleclr,
    a.ccstylecolorcreatedate,
    a.ccinsight,
    a.ccactslsrnk,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_prd,
    b.ancestor5 AS top_bottom,
    b.ancestor6 AS gender,
    b.ancestor7 AS division,
    c.ccfit,
    c.cclegshape,
    c.cclegskirtdresslength,
    c.ccneckline,
    c.ccsleevelength,
    c.ccsilhouette,
    c.ccproductdetail,
    a.ccfashiontier,
    c.cctested,
    c.cclifestyle,
    c.ccrise,
    c.ccgraphictheme,
    c.ccdevelopmentpath,
    c.ccstylegroup,
    c.ccsuits,
    c.ccfabric,
    c.ccgender,
    c.cchangingnonhanging,
    c.cctopbottom,
    c.ccseason,
    c.ccmarketingimage,
    c.cchazmat,
    c.ccgoh,
    c.ccdresses,
    c.ccfibertype,
    c.cctickettype,
    c.ccpricingtier,
    c.ccrangecode,
    c.ccdenimwash,
    c.ccprintpattern,
    c.cclicense,
    c.ccticketprice,
    c.ccsubclassid,
    c.ccsubclassname,
    c.ccstylecreatedate,
    c.ccspecstylestyle,
    c.style_insight,
    g.ccclassname,
    c.ccpowerdrivername,
    h.ccdepartmentname,
    c.isstyleremovable,
    c.ccsubclassid AS clssubclassid,
    c.ccsubclassname AS clssubclassname,
    c.ccsubclassname AS clssubclassdesc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state,
    c.ccsizerange,
    d.id_name AS ccname,
    d.id_description AS ccdesc,
    e.style_name,
    e.style_description AS style_desc,
    a.ccplmcolor,
        CASE
            WHEN ((((((((((((COALESCE(length(btrim("substring"(a.ccspecstylestyleclr, 1, 1))), 0) + COALESCE(length(btrim("substring"(a.ccplmcolor, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_name, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_description, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccstoretier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccgender, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cchangingnonhanging, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cctopbottom, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccseason, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccpricingtier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccfashiontier, 1, 1))), 0)) = 12) AND (NOT ((upper((ARRAY[a.ccspecstylestyleclr, a.ccplmcolor, e.style_name, e.style_description, a.ccstoretier, c.ccgender, c.cchangingnonhanging, c.cctopbottom, c.ccseason, c.ccpricingtier, a.ccfashiontier])::text))::text[] @> ARRAY['UNDEFINED'::text]))) THEN '1'::text
            ELSE '0'::text
        END AS ispublishable,
    c.fabric_lookup,
    a.efo_rtl_tktprc,
    a.efo_rtl_wac,
    a.efo_rtl_imu,
    a.retail_stylecolor_efo,
    a.ccefo_rtl_tktprc,
    a.merch_comments,
    a.plan_comments
   FROM public.exp01_ma_stylecolorattributes a,
    public.exp01_h_prodstd b,
    public.exp01_ma_styleattributes c,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS id_name,
            exp01_d_product.description AS id_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS style_name,
            exp01_d_product.description AS style_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'style'::text)) e,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccclassname,
            exp01_d_product.description AS ccclassdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'class'::text)) g,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccdepartmentname,
            exp01_d_product.description AS ccdepartmentdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'department'::text)) h
  WHERE ((a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id))
  ORDER BY b.id;


ALTER VIEW public.exp01_stylecolor_hier_attr_hs OWNER TO psql;

--
-- TOC entry 1495 (class 1259 OID 81995254)
-- Name: exp01_stylecolor_hier_attr_mod; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_stylecolor_hier_attr_mod AS
 SELECT a.product,
    scca.cc_flrset AS ccfloorset,
    a.ccstoretier,
    a.ccmarkdownflag,
    a.ccprintid,
    a.ccmos,
    a.ccrecall,
    a.ccunavailable,
    a.cccolorid,
    a.cccolor,
    a.cccolorfamily,
    a.cccurp,
    a.ccspecstylestyleclr,
    a.ccstylecolorcreatedate,
    a.ccinsight,
    a.ccactslsrnk,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_prd,
    b.ancestor5 AS top_bottom,
    b.ancestor6 AS gender,
    b.ancestor7 AS division,
    c.ccfit,
    c.cclegshape,
    c.cclegskirtdresslength,
    c.ccneckline,
    c.ccsleevelength,
    c.ccsilhouette,
    c.ccproductdetail,
    a.ccfashiontier,
    c.cctested,
    c.cclifestyle,
    c.ccrise,
    c.ccgraphictheme,
    c.ccdevelopmentpath,
    c.ccstylegroup,
    c.ccsuits,
    c.ccfabric,
    c.ccgender,
    c.cchangingnonhanging,
    c.cctopbottom,
    c.ccseason,
    c.ccmarketingimage,
    c.cchazmat,
    c.ccgoh,
    c.ccdresses,
    c.ccfibertype,
    c.cctickettype,
    c.ccpricingtier,
    c.ccrangecode,
    c.ccdenimwash,
    c.ccprintpattern,
    c.cclicense,
    c.ccticketprice,
    c.ccsubclassid,
    c.ccsubclassname,
    c.ccstylecreatedate,
    c.ccspecstylestyle,
    c.style_insight,
    g.ccclassname,
    c.ccpowerdrivername,
    h.ccdepartmentname,
    c.isstyleremovable,
    c.ccsubclassid AS clssubclassid,
    c.ccsubclassname AS clssubclassname,
    c.ccsubclassname AS clssubclassdesc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state,
    c.ccsizerange,
    d.id_name AS ccname,
    d.id_description AS ccdesc,
    e.style_name,
    e.style_description AS style_desc,
    a.ccplmcolor,
        CASE
            WHEN (((((((((((((COALESCE(length(btrim("substring"(a.ccspecstylestyleclr, 1, 1))), 0) + COALESCE(length(btrim("substring"(a.ccplmcolor, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_name, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_description, 1, 1))), 0)) + COALESCE(length(btrim("substring"(scca.cc_flrset, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccstoretier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccgender, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cchangingnonhanging, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cctopbottom, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccseason, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccpricingtier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccfashiontier, 1, 1))), 0)) = 12) AND (NOT ((upper((ARRAY[a.ccspecstylestyleclr, a.ccplmcolor, e.style_name, e.style_description, scca.cc_flrset, a.ccstoretier, c.ccgender, c.cchangingnonhanging, c.cctopbottom, c.ccseason, c.ccpricingtier, a.ccfashiontier])::text))::text[] @> ARRAY['UNDEFINED'::text]))) THEN '1'::text
            ELSE '0'::text
        END AS ispublishable
   FROM public.exp01_ma_stylecolorattributes a,
    public.exp01_h_prodstd b,
    public.exp01_ma_styleattributes c,
    public.exp01_ma_stylecolorchannelattributes scca,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS id_name,
            exp01_d_product.description AS id_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS style_name,
            exp01_d_product.description AS style_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'style'::text)) e,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccclassname,
            exp01_d_product.description AS ccclassdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'class'::text)) g,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccdepartmentname,
            exp01_d_product.description AS ccdepartmentdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'department'::text)) h
  WHERE ((scca.product = a.product) AND (a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id))
  ORDER BY b.id;


ALTER VIEW public.exp01_stylecolor_hier_attr_mod OWNER TO psql;

--
-- TOC entry 1630 (class 1259 OID 84966207)
-- Name: exp01_stylecolor_hier_attr_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_stylecolor_hier_attr_products (
    product text,
    ccticketprice double precision
);


ALTER TABLE public.exp01_stylecolor_hier_attr_products OWNER TO psql;

--
-- TOC entry 1496 (class 1259 OID 81995264)
-- Name: exp01_stylecolor_hier_attr_testing; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.exp01_stylecolor_hier_attr_testing AS
 SELECT a.product,
    scca.cc_flrset AS ccfloorset,
    a.ccstoretier,
    a.ccmarkdownflag,
    a.ccprintid,
    a.ccmos,
    a.ccrecall,
    a.ccunavailable,
    a.cccolorid,
    a.cccolor,
    a.cccolorfamily,
    a.cccurp,
    c.ccspecstylestyle AS ccspecstylestyleclr,
    a.ccstylecolorcreatedate,
    a.ccinsight,
    a.ccactslsrnk,
    a.ishistory,
    a.isassortment,
    a.isdesign,
    a.isforecastable,
    a.inqueue,
    a.islocked,
    a.isremovable,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS group_prd,
    b.ancestor5 AS top_bottom,
    b.ancestor6 AS gender,
    b.ancestor7 AS division,
    c.ccfit,
    c.cclegshape,
    c.cclegskirtdresslength,
    c.ccneckline,
    c.ccsleevelength,
    c.ccsilhouette,
        CASE
            WHEN (c.ccproductdetail IS NULL) THEN '{}'::text
            ELSE c.ccproductdetail
        END AS ccproductdetail,
    a.ccfashiontier,
    c.cctested,
    c.cclifestyle,
    c.ccrise,
    c.ccgraphictheme,
    c.ccdevelopmentpath,
    c.ccstylegroup,
    c.ccsuits,
    c.ccfabric,
    c.ccgender,
    c.cchangingnonhanging,
    c.cctopbottom,
    c.ccseason,
    c.ccmarketingimage,
    c.cchazmat,
    c.ccgoh,
    c.ccdresses,
    c.ccfibertype,
    c.cctickettype,
    c.ccpricingtier,
    "substring"(c.ccsizerange, 1, (length(c.ccsizerange) - length('-CL-0170'::text))) AS ccrangecode,
    c.ccdenimwash,
    c.ccprintpattern,
    c.cclicense,
    c.ccticketprice,
    c.ccsubclassid,
    c.ccsubclassname,
    c.ccstylecreatedate,
    c.ccspecstylestyle,
    c.style_insight,
    g.ccclassname,
    gpd.ccpowerdrivername,
    h.ccdepartmentname,
    c.isstyleremovable,
    c.ccsubclassid AS clssubclassid,
    c.ccsubclassname AS clssubclassname,
    c.ccsubclassname AS clssubclassdesc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    GREATEST(a.updated_at, c.updated_at, scca.updated_at) AS updated_at,
    a.updated_by,
    a.record_state,
    c.ccsizerange,
    d.id_name AS ccname,
    d.id_description AS ccdesc,
    e.style_name,
    e.style_description AS style_desc,
    a.ccplmcolor,
        CASE
            WHEN (((((((((((((COALESCE(length(btrim("substring"(c.ccspecstylestyle, 1, 1))), 0) + COALESCE(length(btrim("substring"(a.ccplmcolor, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_name, 1, 1))), 0)) + COALESCE(length(btrim("substring"(e.style_description, 1, 1))), 0)) + COALESCE(length(btrim("substring"(scca.cc_flrset, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccstoretier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccgender, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cchangingnonhanging, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.cctopbottom, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccseason, 1, 1))), 0)) + COALESCE(length(btrim("substring"(c.ccpricingtier, 1, 1))), 0)) + COALESCE(length(btrim("substring"(a.ccfashiontier, 1, 1))), 0)) = 12) AND (NOT ((upper((ARRAY[c.ccspecstylestyle, a.ccplmcolor, e.style_name, e.style_description, scca.cc_flrset, a.ccstoretier, c.ccgender, c.cchangingnonhanging, c.cctopbottom, c.ccseason, c.ccpricingtier, a.ccfashiontier])::text))::text[] @> ARRAY['UNDEFINED'::text]))) THEN '1'::text
            ELSE '0'::text
        END AS ispublishable,
    c.fabric_lookup,
    a.efo_rtl_tktprc,
    a.efo_rtl_wac,
    a.efo_rtl_imu,
    a.retail_stylecolor_efo,
    a.ccefo_rtl_tktprc,
    a.merch_comments,
    a.plan_comments,
    a.ccmannequinlooks,
    a.ccedit
   FROM public.exp01_ma_stylecolorattributes a,
    public.exp01_h_prodstd b,
    public.exp01_ma_styleattributes c,
    public.exp01_ma_stylecolorchannelattributes scca,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS id_name,
            exp01_d_product.description AS id_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS style_name,
            exp01_d_product.description AS style_description
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'style'::text)) e,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccpowerdrivername,
            exp01_d_product.description AS ccpowerdriverdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'subclass'::text)) gpd,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccclassname,
            exp01_d_product.description AS ccclassdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'class'::text)) g,
    ( SELECT exp01_d_product.id,
            exp01_d_product.name AS ccdepartmentname,
            exp01_d_product.description AS ccdepartmentdesc
           FROM public.exp01_d_product
          WHERE (exp01_d_product.levelid = 'department'::text)) h
  WHERE ((scca.product = a.product) AND (a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = gpd.id) AND (b.ancestor2 = g.id) AND (b.ancestor3 = h.id))
  ORDER BY b.id;


ALTER VIEW public.exp01_stylecolor_hier_attr_testing OWNER TO psql;

--
-- TOC entry 1497 (class 1259 OID 81995269)
-- Name: exp01_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_swatches (
    attributeid text,
    validvalue text NOT NULL,
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


ALTER TABLE public.exp01_swatches OWNER TO psql;

--
-- TOC entry 1498 (class 1259 OID 81995281)
-- Name: exp01_swatches_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_swatches_archives (
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
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_swatches_archives OWNER TO psql;

--
-- TOC entry 1499 (class 1259 OID 81995286)
-- Name: exp01_targetsetting; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_targetsetting (
    id text NOT NULL,
    version text NOT NULL,
    type text NOT NULL,
    data jsonb,
    scope_hash text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_targetsetting OWNER TO psql;

--
-- TOC entry 1500 (class 1259 OID 81995298)
-- Name: exp01_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues (
    attributeid text,
    membertie text DEFAULT ''::text,
    attributekey text,
    attributevalue text,
    indx integer NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.exp01_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1501 (class 1259 OID 81995311)
-- Name: exp01_v_memberbasedvalidvalues_archives; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_archives (
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
    record_state smallint,
    sync_date timestamp(0) without time zone
);


ALTER TABLE public.exp01_v_memberbasedvalidvalues_archives OWNER TO psql;

--
-- TOC entry 1502 (class 1259 OID 81995316)
-- Name: exp01_v_memberbasedvalidvalues_before_dedup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_before_dedup (
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


ALTER TABLE public.exp01_v_memberbasedvalidvalues_before_dedup OWNER TO psql;

--
-- TOC entry 1503 (class 1259 OID 81995321)
-- Name: exp01_v_memberbasedvalidvalues_bk_20220819; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_bk_20220819 (
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


ALTER TABLE public.exp01_v_memberbasedvalidvalues_bk_20220819 OWNER TO psql;

--
-- TOC entry 1504 (class 1259 OID 81995326)
-- Name: exp01_v_memberbasedvalidvalues_dedup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_dedup (
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


ALTER TABLE public.exp01_v_memberbasedvalidvalues_dedup OWNER TO psql;

--
-- TOC entry 1505 (class 1259 OID 81995331)
-- Name: exp01_v_memberbasedvalidvalues_grade; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_grade (
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


ALTER TABLE public.exp01_v_memberbasedvalidvalues_grade OWNER TO psql;

--
-- TOC entry 1506 (class 1259 OID 81995336)
-- Name: exp01_v_memberbasedvalidvalues_grade_final_indx; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.exp01_v_memberbasedvalidvalues_grade_final_indx (
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


ALTER TABLE public.exp01_v_memberbasedvalidvalues_grade_final_indx OWNER TO psql;

--
-- TOC entry 1507 (class 1259 OID 81995341)
-- Name: failed_list; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_list (
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


ALTER TABLE public.failed_list OWNER TO psql;

--
-- TOC entry 1508 (class 1259 OID 81995346)
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
-- TOC entry 1509 (class 1259 OID 81995351)
-- Name: favorites_backup_20260311; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.favorites_backup_20260311 (
    key text,
    user_id text,
    module text,
    favorite_name text,
    version integer,
    json_blob json,
    active boolean
);


ALTER TABLE public.favorites_backup_20260311 OWNER TO psql;

--
-- TOC entry 1510 (class 1259 OID 81995356)
-- Name: favorites_backup_20260313; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.favorites_backup_20260313 (
    key text,
    user_id text,
    module text,
    favorite_name text,
    version integer,
    json_blob json,
    active boolean
);


ALTER TABLE public.favorites_backup_20260313 OWNER TO psql;

--
-- TOC entry 1511 (class 1259 OID 81995361)
-- Name: final_list; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.final_list (
    product text,
    location text
);


ALTER TABLE public.final_list OWNER TO psql;

--
-- TOC entry 1512 (class 1259 OID 81995366)
-- Name: flrsetfix; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.flrsetfix (
    old text,
    new text
);


ALTER TABLE public.flrsetfix OWNER TO psql;

--
-- TOC entry 1513 (class 1259 OID 81995371)
-- Name: frank_test_20230411; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.frank_test_20230411 (
    product text,
    ccplmcolor text,
    ccspecstylestyleclr text
);


ALTER TABLE public.frank_test_20230411 OWNER TO psql;

--
-- TOC entry 1514 (class 1259 OID 81995376)
-- Name: frank_test_incorrectplmcolor_20230411; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.frank_test_incorrectplmcolor_20230411 (
    product text
);


ALTER TABLE public.frank_test_incorrectplmcolor_20230411 OWNER TO psql;

--
-- TOC entry 1515 (class 1259 OID 81995381)
-- Name: frank_test_lookup_20230411; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.frank_test_lookup_20230411 (
    cccspecstylestyleclr text,
    ccplmcolor text
);


ALTER TABLE public.frank_test_lookup_20230411 OWNER TO psql;

--
-- TOC entry 1516 (class 1259 OID 81995386)
-- Name: is_forecastable_check_feb20_2022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.is_forecastable_check_feb20_2022 (
    product text,
    location text,
    isforecasted real,
    clean_aps real,
    bypass_multiplier real,
    plan_active real,
    fp_range real
);


ALTER TABLE public.is_forecastable_check_feb20_2022 OWNER TO psql;

--
-- TOC entry 1517 (class 1259 OID 81995391)
-- Name: mark_prod_mia; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.mark_prod_mia (
    product text
);


ALTER TABLE public.mark_prod_mia OWNER TO psql;

--
-- TOC entry 1518 (class 1259 OID 81995396)
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
-- TOC entry 1519 (class 1259 OID 81995401)
-- Name: missed_items_2_delete_me; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missed_items_2_delete_me (
    product text
);


ALTER TABLE public.missed_items_2_delete_me OWNER TO psql;

--
-- TOC entry 1520 (class 1259 OID 81995406)
-- Name: missed_items_delete_me; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missed_items_delete_me (
    product text
);


ALTER TABLE public.missed_items_delete_me OWNER TO psql;

--
-- TOC entry 1521 (class 1259 OID 81995411)
-- Name: missed_plan; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missed_plan (
    product text
);


ALTER TABLE public.missed_plan OWNER TO psql;

--
-- TOC entry 1522 (class 1259 OID 81995416)
-- Name: missing_am_correction; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missing_am_correction (
    product text,
    dbt_wk text,
    exitdate text,
    record_state smallint
);


ALTER TABLE public.missing_am_correction OWNER TO psql;

--
-- TOC entry 1626 (class 1259 OID 84913421)
-- Name: missing_record_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missing_record_stylecolorchannelattributes (
    product text,
    max_floorset text,
    ap_end text,
    exitdate text,
    erlstmkdnwk text
);


ALTER TABLE public.missing_record_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1523 (class 1259 OID 81995426)
-- Name: new_exp01_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.new_exp01_ma_dptflrsetattributes (
    indx integer,
    product text,
    "time" text,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    ap_start text,
    ap_end text,
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
    default_strmenscapacity text[],
    default_strwomenscapacity text[],
    default_strcorpvoltier text[],
    default_strclimate text[],
    default_grade text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    default_discountpct real,
    default_imupct real,
    floorset_year text,
    floorset_month text,
    floorset_uda text,
    floorset_set_week text,
    default_store_count integer
);


ALTER TABLE public.new_exp01_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1524 (class 1259 OID 81995431)
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
-- TOC entry 1525 (class 1259 OID 81995436)
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
-- TOC entry 1526 (class 1259 OID 81995442)
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
-- TOC entry 1527 (class 1259 OID 81995448)
-- Name: plan_failures; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_failures (
    product text,
    status text
);


ALTER TABLE public.plan_failures OWNER TO psql;

--
-- TOC entry 1528 (class 1259 OID 81995453)
-- Name: plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_items (
    product text,
    location text,
    dbt_wk text,
    md_week text,
    exit_week text
);


ALTER TABLE public.plan_items OWNER TO psql;

--
-- TOC entry 1529 (class 1259 OID 81995458)
-- Name: plan_items_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_items_conversion (
    stylecolor_id character varying(100),
    dept_id character varying(100),
    location character varying(100)
);


ALTER TABLE public.plan_items_conversion OWNER TO psql;

--
-- TOC entry 1530 (class 1259 OID 81995461)
-- Name: plan_queu_20260305; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queu_20260305 (
    jobid uuid,
    product text,
    location text,
    initiator text,
    initiated_at timestamp with time zone,
    queued timestamp with time zone,
    processing timestamp with time zone,
    completed timestamp with time zone,
    error text,
    updated_at timestamp with time zone
);


ALTER TABLE public.plan_queu_20260305 OWNER TO psql;

--
-- TOC entry 1531 (class 1259 OID 81995466)
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
    priority integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.plan_queue OWNER TO psql;

--
-- TOC entry 1532 (class 1259 OID 81995475)
-- Name: plan_queue_08282022; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_08282022 (
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


ALTER TABLE public.plan_queue_08282022 OWNER TO psql;

--
-- TOC entry 1533 (class 1259 OID 81995480)
-- Name: plan_queue_20230517; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_20230517 (
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


ALTER TABLE public.plan_queue_20230517 OWNER TO psql;

--
-- TOC entry 1534 (class 1259 OID 81995485)
-- Name: plan_queue_ca; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_ca (
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


ALTER TABLE public.plan_queue_ca OWNER TO psql;

--
-- TOC entry 1605 (class 1259 OID 84364742)
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
-- TOC entry 1535 (class 1259 OID 81995495)
-- Name: plan_queue_fails_20250223; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_fails_20250223 (
    product text
);


ALTER TABLE public.plan_queue_fails_20250223 OWNER TO psql;

--
-- TOC entry 1536 (class 1259 OID 81995500)
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
-- TOC entry 1537 (class 1259 OID 81995505)
-- Name: plan_queue_jr_20230501; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_jr_20230501 (
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


ALTER TABLE public.plan_queue_jr_20230501 OWNER TO psql;

--
-- TOC entry 1627 (class 1259 OID 84963838)
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
-- TOC entry 1538 (class 1259 OID 81995510)
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
-- TOC entry 1539 (class 1259 OID 81995515)
-- Name: plan_queue_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_temp (
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


ALTER TABLE public.plan_queue_temp OWNER TO psql;

--
-- TOC entry 1540 (class 1259 OID 81995520)
-- Name: plan_queue_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_test (
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


ALTER TABLE public.plan_queue_test OWNER TO psql;

--
-- TOC entry 1541 (class 1259 OID 81995525)
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
-- TOC entry 1542 (class 1259 OID 81995529)
-- Name: planned_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.planned_items (
    stylecolor character varying(100)
);


ALTER TABLE public.planned_items OWNER TO psql;

--
-- TOC entry 1543 (class 1259 OID 81995532)
-- Name: please_delete; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.please_delete (
    name text,
    ancestor3 text
);


ALTER TABLE public.please_delete OWNER TO psql;

--
-- TOC entry 1544 (class 1259 OID 81995537)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 1545 (class 1259 OID 81995542)
-- Name: replan_dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.replan_dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.replan_dept_plan_items OWNER TO psql;

--
-- TOC entry 1546 (class 1259 OID 81995547)
-- Name: replan_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.replan_products (
    product text
);


ALTER TABLE public.replan_products OWNER TO psql;

--
-- TOC entry 1547 (class 1259 OID 81995552)
-- Name: role; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.role (
    tenantid text NOT NULL,
    id text NOT NULL,
    description text DEFAULT ''::text,
    name text DEFAULT ''::text,
    service text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.role OWNER TO psql;

--
-- TOC entry 1548 (class 1259 OID 81995566)
-- Name: role_0802; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.role_0802 (
    tenantid text,
    id text,
    description text,
    name text,
    service text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.role_0802 OWNER TO psql;

--
-- TOC entry 1549 (class 1259 OID 81995571)
-- Name: role_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.role_temp (
    tenantid text,
    id text,
    description text,
    name text,
    service text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.role_temp OWNER TO psql;

--
-- TOC entry 1607 (class 1259 OID 84907540)
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
-- TOC entry 1618 (class 1259 OID 84913358)
-- Name: s5_profile_master_max_default; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_default (
    size_range_class text,
    sub_size_range text,
    profile_id text
);


ALTER TABLE public.s5_profile_master_max_default OWNER TO psql;

--
-- TOC entry 1613 (class 1259 OID 84913315)
-- Name: s5_profile_master_max_temp_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_temp_1 (
    size_range_class text,
    sub_size_range text,
    profile_id text,
    cnt bigint,
    prof_seq bigint
);


ALTER TABLE public.s5_profile_master_max_temp_1 OWNER TO psql;

--
-- TOC entry 1614 (class 1259 OID 84913338)
-- Name: s5_profile_master_max_temp_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_temp_2 (
    size_range_class text,
    sub_size_range text,
    total_count numeric
);


ALTER TABLE public.s5_profile_master_max_temp_2 OWNER TO psql;

--
-- TOC entry 1615 (class 1259 OID 84913343)
-- Name: s5_profile_master_max_temp_3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_temp_3 (
    size_range_class text,
    sub_size_range text,
    total_count numeric,
    rn bigint,
    profile_id text
);


ALTER TABLE public.s5_profile_master_max_temp_3 OWNER TO psql;

--
-- TOC entry 1616 (class 1259 OID 84913348)
-- Name: s5_profile_master_max_temp_x_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_temp_x_1 (
    size_range_class text,
    sub_size_range text,
    profile_id text,
    rn bigint
);


ALTER TABLE public.s5_profile_master_max_temp_x_1 OWNER TO psql;

--
-- TOC entry 1617 (class 1259 OID 84913353)
-- Name: s5_profile_master_max_temp_x_2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_profile_master_max_temp_x_2 (
    size_range_class text,
    sub_size_range text,
    profile_id text,
    rn bigint
);


ALTER TABLE public.s5_profile_master_max_temp_x_2 OWNER TO psql;

--
-- TOC entry 1550 (class 1259 OID 81995611)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 8390 (class 0 OID 0)
-- Dependencies: 1550
-- Name: TABLE s5_tunableparams; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.s5_tunableparams IS 'add table for tuning paras';


--
-- TOC entry 1551 (class 1259 OID 81995616)
-- Name: sca_12032023; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sca_12032023 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    presmin_weeks integer,
    presmin integer,
    ccrcptint integer,
    ccordermultiple integer,
    ccticketpricechannel real,
    cccurppricechannel real,
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
    auto_rollforward boolean,
    irr_mode text,
    plan_current text,
    lock_agg_edit text
);


ALTER TABLE public.sca_12032023 OWNER TO psql;

--
-- TOC entry 1552 (class 1259 OID 81995621)
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
-- TOC entry 1608 (class 1259 OID 84907545)
-- Name: size_defaults_from_express; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_defaults_from_express (
    size_range text,
    sub_size_range text,
    department text
);


ALTER TABLE public.size_defaults_from_express OWNER TO psql;

--
-- TOC entry 1610 (class 1259 OID 84910193)
-- Name: size_defaults_from_express_s5mods_new; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_defaults_from_express_s5mods_new (
    subclass text,
    class text,
    department text,
    size_range text,
    sub_size_range text,
    ccrangecode character varying(200)
);


ALTER TABLE public.size_defaults_from_express_s5mods_new OWNER TO psql;

--
-- TOC entry 1553 (class 1259 OID 81995640)
-- Name: size_defaults_from_express_s5mods_new2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_defaults_from_express_s5mods_new2 (
    subclass text,
    class text,
    department text,
    size_range text,
    sub_size_range text,
    ccrangecode character varying(200)
);


ALTER TABLE public.size_defaults_from_express_s5mods_new2 OWNER TO psql;

--
-- TOC entry 1554 (class 1259 OID 81995645)
-- Name: size_defaults_from_express_s5mods_new3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_defaults_from_express_s5mods_new3 (
    subclass text,
    class text,
    department text,
    size_range text,
    sub_size_range text,
    ccrangecode character varying(200)
);


ALTER TABLE public.size_defaults_from_express_s5mods_new3 OWNER TO psql;

--
-- TOC entry 1609 (class 1259 OID 84909950)
-- Name: size_id_desc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_id_desc (
    size_id text,
    sizeattribute text
);


ALTER TABLE public.size_id_desc OWNER TO psql;

--
-- TOC entry 1555 (class 1259 OID 81995655)
-- Name: size_id_express_sorting; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_id_express_sorting (
    size_id text,
    sizeattribute text,
    size_number integer,
    row_number bigint,
    alpha_id text
);


ALTER TABLE public.size_id_express_sorting OWNER TO psql;

--
-- TOC entry 1556 (class 1259 OID 81995660)
-- Name: size_id_sorting; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_id_sorting (
    alpha_id text,
    row_number bigint
);


ALTER TABLE public.size_id_sorting OWNER TO psql;

--
-- TOC entry 1557 (class 1259 OID 81995665)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_naem text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 1558 (class 1259 OID 81995670)
-- Name: sizerange_changed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sizerange_changed (
    sync_date timestamp(0) without time zone,
    product text,
    ccsizerange text
);


ALTER TABLE public.sizerange_changed OWNER TO psql;

--
-- TOC entry 1559 (class 1259 OID 81995675)
-- Name: strategic_plan_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.strategic_plan_prep (
    time_indx text,
    product text,
    location text,
    prodlife text,
    sls_r_23 real,
    sls_r_24 real,
    sls_r_25 real,
    sls_r_26 real,
    sls_r_27 real,
    sls_c_23 real,
    sls_c_24 real,
    sls_c_25 real,
    sls_u_23 real,
    sls_u_24 real,
    sls_u_25 real,
    turn_div_23 real,
    turn_div_24 real,
    turn_div_25 real
);


ALTER TABLE public.strategic_plan_prep OWNER TO psql;

--
-- TOC entry 1560 (class 1259 OID 81995680)
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
-- TOC entry 1561 (class 1259 OID 81995681)
-- Name: styleattrs; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.styleattrs (
    style text,
    ccpowerdrivername text,
    ccspecstylestyle text
);


ALTER TABLE public.styleattrs OWNER TO psql;

--
-- TOC entry 1562 (class 1259 OID 81995686)
-- Name: stylecolor_size_predict_attrs; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.stylecolor_size_predict_attrs AS
 WITH channel_to_selling AS (
         SELECT loc.id AS channel,
            h.id AS selling_channel
           FROM (public.exp01_d_location loc
             JOIN public.exp01_h_locstd h ON ((loc.id = h.ancestor0)))
        )
 SELECT scha.product,
    scha.ccfloorset,
    scha.ccstoretier,
    scha.ccmarkdownflag,
    scha.ccprintid,
    scha.ccmos,
    scha.ccrecall,
    scha.ccunavailable,
    scha.cccolorid,
    scha.cccolor,
    scha.cccolorfamily,
    scha.cccurp,
    scha.ccspecstylestyleclr,
    scha.ccstylecolorcreatedate,
    scha.ccinsight,
    scha.ccactslsrnk,
    scha.ishistory,
    scha.isassortment,
    scha.isdesign,
    scha.isforecastable,
    scha.inqueue,
    scha.islocked,
    scha.isremovable,
    scha.stylecolor,
    scha.style,
    scha.subclass,
    scha.class,
    scha.department,
    scha.group_prd,
    scha.top_bottom,
    scha.gender,
    scha.division,
    scha.ccfit,
    scha.cclegshape,
    scha.cclegskirtdresslength,
    scha.ccneckline,
    scha.ccsleevelength,
    scha.ccsilhouette,
    scha.ccproductdetail,
    scha.ccfashiontier,
    scha.cctested,
    scha.cclifestyle,
    scha.ccrise,
    scha.ccgraphictheme,
    scha.ccdevelopmentpath,
    scha.ccstylegroup,
    scha.ccsuits,
    scha.ccfabric,
    scha.ccgender,
    scha.cchangingnonhanging,
    scha.cctopbottom,
    scha.ccseason,
    scha.ccmarketingimage,
    scha.cchazmat,
    scha.ccgoh,
    scha.ccdresses,
    scha.ccfibertype,
    scha.cctickettype,
    scha.ccpricingtier,
    scha.ccrangecode,
    scha.ccdenimwash,
    scha.ccprintpattern,
    scha.cclicense,
    scha.ccticketprice,
    scha.ccsubclassid,
    scha.ccsubclassname,
    scha.ccstylecreatedate,
    scha.ccspecstylestyle,
    scha.style_insight,
    scha.ccclassname,
    scha.ccpowerdrivername,
    scha.ccdepartmentname,
    scha.isstyleremovable,
    scha.clssubclassid,
    scha.clssubclassname,
    scha.clssubclassdesc,
    scha.eventdate,
    scha.version_id,
    scha.created_at,
    scha.created_by,
    scha.updated_at,
    scha.updated_by,
    scha.record_state,
    scha.ccsizerange,
    scha.ccname,
    scha.ccdesc,
    scha.style_name,
    scha.style_desc,
    scha.ccplmcolor,
    scha.ispublishable,
    scha.fabric_lookup,
    scha.efo_rtl_tktprc,
    scha.efo_rtl_wac,
    scha.efo_rtl_imu,
    scha.retail_stylecolor_efo,
    scha.ccefo_rtl_tktprc,
    scha.merch_comments,
    scha.plan_comments,
    scha.ccmannequinlooks,
    scha.ccedit,
    split_part(scha.ccsizerange, '-'::text, 1) AS sizerange,
    chan.selling_channel
   FROM ((public.exp01_stylecolor_hier_attr scha
     JOIN public.exp01_ma_stylecolorchannelattributes scca ON ((scha.product = scca.product)))
     JOIN channel_to_selling chan ON ((scca.location = chan.channel)));


ALTER VIEW public.stylecolor_size_predict_attrs OWNER TO psql;

--
-- TOC entry 1563 (class 1259 OID 81995691)
-- Name: styleparents; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.styleparents (
    style text,
    class text,
    department text
);


ALTER TABLE public.styleparents OWNER TO psql;

--
-- TOC entry 1564 (class 1259 OID 81995696)
-- Name: subsizerange_changed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.subsizerange_changed (
    product text,
    sync_date timestamp(0) without time zone,
    ccrangecode text
);


ALTER TABLE public.subsizerange_changed OWNER TO psql;

--
-- TOC entry 1565 (class 1259 OID 81995701)
-- Name: sync_outbound_dataqueue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue (
    product character varying(255),
    "time" character varying(50),
    publish_type character varying(50),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sync_outbound_dataqueue OWNER TO psql;

--
-- TOC entry 1566 (class 1259 OID 81995705)
-- Name: targetsetting; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.targetsetting (
    id character varying(100) NOT NULL,
    version character varying(5) NOT NULL,
    type character varying(100) NOT NULL,
    data jsonb,
    scope_hash character varying(100) NOT NULL
);


ALTER TABLE public.targetsetting OWNER TO psql;

--
-- TOC entry 1567 (class 1259 OID 81995710)
-- Name: temp1_img; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_img (
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


ALTER TABLE public.temp1_img OWNER TO psql;

--
-- TOC entry 1568 (class 1259 OID 81995715)
-- Name: temp1_img_1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_img_1 (
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


ALTER TABLE public.temp1_img_1 OWNER TO psql;

--
-- TOC entry 1569 (class 1259 OID 81995720)
-- Name: temp_already_planned; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_already_planned (
    product text
);


ALTER TABLE public.temp_already_planned OWNER TO psql;

--
-- TOC entry 1570 (class 1259 OID 81995725)
-- Name: temp_already_planned_set2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_already_planned_set2 (
    product text
);


ALTER TABLE public.temp_already_planned_set2 OWNER TO psql;

--
-- TOC entry 1571 (class 1259 OID 81995730)
-- Name: temp_already_planned_set3; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_already_planned_set3 (
    product text
);


ALTER TABLE public.temp_already_planned_set3 OWNER TO psql;

--
-- TOC entry 1572 (class 1259 OID 81995735)
-- Name: temp_eff_aur_prep; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_eff_aur_prep (
    product text,
    channel text,
    "time" text,
    prodlife text,
    slsr real,
    slsu real,
    eff_aur real
);


ALTER TABLE public.temp_eff_aur_prep OWNER TO psql;

--
-- TOC entry 1619 (class 1259 OID 84913379)
-- Name: temp_exp01_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_exp01_corpdisc (
    department text,
    product text,
    location text,
    "time" text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.temp_exp01_corpdisc OWNER TO psql;

--
-- TOC entry 1573 (class 1259 OID 81995745)
-- Name: temp_missing_record_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_missing_record_stylecolorchannelattributes (
    product text,
    max_floorset text,
    ap_end text,
    exitdate text,
    erlstmkdnwk text
);


ALTER TABLE public.temp_missing_record_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1574 (class 1259 OID 81995750)
-- Name: temp_one_time_fcst_input; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_one_time_fcst_input (
    product text,
    location text
);


ALTER TABLE public.temp_one_time_fcst_input OWNER TO psql;

--
-- TOC entry 1575 (class 1259 OID 81995755)
-- Name: temp_plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_plan_queue (
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


ALTER TABLE public.temp_plan_queue OWNER TO psql;

--
-- TOC entry 1576 (class 1259 OID 81995760)
-- Name: temp_x; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_x (
    product text,
    location text,
    department text
);


ALTER TABLE public.temp_x OWNER TO psql;

--
-- TOC entry 1577 (class 1259 OID 81995765)
-- Name: test_temp_rangecode_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.test_temp_rangecode_master (
    product text,
    location text,
    ccrangecode text,
    master_size_attr text,
    member_id text,
    member_exists integer
);


ALTER TABLE public.test_temp_rangecode_master OWNER TO psql;

--
-- TOC entry 1578 (class 1259 OID 81995770)
-- Name: test_temp_rangecode_master_x; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.test_temp_rangecode_master_x (
    product text,
    location text,
    ccrangecode text,
    master_size_attr text,
    member_id text,
    member_exists integer
);


ALTER TABLE public.test_temp_rangecode_master_x OWNER TO psql;

--
-- TOC entry 1579 (class 1259 OID 81995775)
-- Name: tmp_fix_exitdate; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_fix_exitdate (
    product text,
    name text,
    location text,
    erlstmkdnwk text,
    exitdate text,
    new_exitdate text
);


ALTER TABLE public.tmp_fix_exitdate OWNER TO psql;

--
-- TOC entry 1580 (class 1259 OID 81995780)
-- Name: tr_efo_rtl_tktprc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tr_efo_rtl_tktprc (
    ccticketprice text
);


ALTER TABLE public.tr_efo_rtl_tktprc OWNER TO psql;

--
-- TOC entry 1581 (class 1259 OID 81995785)
-- Name: trial_run_for_rz; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.trial_run_for_rz (
    product text,
    ccfloorset text,
    ccstoretier text,
    ccmarkdownflag text,
    ccprintid text,
    ccmos text,
    ccrecall text,
    ccunavailable text,
    cccolorid text,
    cccolor text,
    cccolorfamily text,
    cccurp double precision,
    ccspecstylestyleclr text,
    ccstylecolorcreatedate text,
    ccinsight double precision,
    ccactslsrnk text,
    ishistory text,
    isassortment text,
    isdesign text,
    isforecastable text,
    inqueue text,
    islocked text,
    isremovable text,
    stylecolor text,
    style text,
    subclass text,
    class text,
    department text,
    group_prd text,
    top_bottom text,
    gender text,
    division text,
    ccfit text,
    cclegshape text,
    cclegskirtdresslength text,
    ccneckline text,
    ccsleevelength text,
    ccsilhouette text,
    ccproductdetail text,
    ccfashiontier text,
    cctested text,
    cclifestyle text,
    ccrise text,
    ccgraphictheme text,
    ccdevelopmentpath text,
    ccstylegroup text,
    ccsuits text,
    ccfabric text,
    ccgender text,
    cchangingnonhanging text,
    cctopbottom text,
    ccseason text,
    ccmarketingimage text,
    cchazmat text,
    ccgoh text,
    ccdresses text,
    ccfibertype text,
    cctickettype text,
    ccpricingtier text,
    ccrangecode text,
    ccdenimwash text,
    ccprintpattern text,
    cclicense text,
    ccticketprice double precision,
    ccsubclassid text,
    ccsubclassname text,
    ccstylecreatedate text,
    ccspecstylestyle text,
    style_insight double precision,
    ccclassname text,
    ccpowerdrivername text,
    ccdepartmentname text,
    isstyleremovable text,
    clssubclassid text,
    clssubclassname text,
    clssubclassdesc text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccsizerange text,
    ccname text,
    ccdesc text,
    style_name text,
    style_desc text,
    ccplmcolor text,
    ispublishable text,
    fabric_lookup text,
    efo_rtl_tktprc text,
    efo_rtl_wac text,
    efo_rtl_imu text,
    retail_stylecolor_efo text,
    ccefo_rtl_tktprc text,
    merch_comments text,
    plan_comments text,
    ccmannequinlooks text,
    ccedit text,
    sizerange text,
    selling_channel text
);


ALTER TABLE public.trial_run_for_rz OWNER TO psql;

--
-- TOC entry 1582 (class 1259 OID 81995790)
-- Name: trigger_trial; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.trigger_trial (
    product text,
    floorset text,
    triggered timestamp with time zone
);


ALTER TABLE public.trigger_trial OWNER TO psql;

--
-- TOC entry 1583 (class 1259 OID 81995795)
-- Name: trimmed_products_channel; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.trimmed_products_channel (
    product text,
    channel text
);


ALTER TABLE public.trimmed_products_channel OWNER TO psql;

--
-- TOC entry 1584 (class 1259 OID 81995800)
-- Name: trimmed_products; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.trimmed_products AS
 SELECT DISTINCT trimmed_products_channel.product
   FROM public.trimmed_products_channel;


ALTER VIEW public.trimmed_products OWNER TO psql;

--
-- TOC entry 1585 (class 1259 OID 81995804)
-- Name: tx; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tx (
    id text
);


ALTER TABLE public.tx OWNER TO psql;

--
-- TOC entry 1586 (class 1259 OID 81995809)
-- Name: tx1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tx1 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    ancestor8 text
);


ALTER TABLE public.tx1 OWNER TO psql;

--
-- TOC entry 1587 (class 1259 OID 81995814)
-- Name: tx_drop; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tx_drop (
    product text,
    parent_id text
);


ALTER TABLE public.tx_drop OWNER TO psql;

--
-- TOC entry 1588 (class 1259 OID 81995819)
-- Name: ty; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.ty (
    erlst_md text,
    last_rcpt text,
    erlst_md_indx integer,
    last_rcpt_indx integer
);


ALTER TABLE public.ty OWNER TO psql;

--
-- TOC entry 1589 (class 1259 OID 81995824)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 1590 (class 1259 OID 81995829)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 1591 (class 1259 OID 81995834)
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
-- TOC entry 1592 (class 1259 OID 81995842)
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
-- TOC entry 1593 (class 1259 OID 81995847)
-- Name: unplanned_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.unplanned_items (
    product text
);


ALTER TABLE public.unplanned_items OWNER TO psql;

--
-- TOC entry 1594 (class 1259 OID 81995852)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 1595 (class 1259 OID 81995857)
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
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    profile_group text
);


ALTER TABLE public.user_tbl OWNER TO psql;

--
-- TOC entry 1596 (class 1259 OID 81995872)
-- Name: user_tbl_0802; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl_0802 (
    tenantid text,
    id text,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.user_tbl_0802 OWNER TO psql;

--
-- TOC entry 1597 (class 1259 OID 81995877)
-- Name: user_tbl_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl_backup (
    tenantid text,
    id text,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.user_tbl_backup OWNER TO psql;

--
-- TOC entry 1598 (class 1259 OID 81995882)
-- Name: user_tbl_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl_temp (
    tenantid text,
    id text,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.user_tbl_temp OWNER TO psql;

--
-- TOC entry 1599 (class 1259 OID 81995887)
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
-- TOC entry 8391 (class 0 OID 0)
-- Dependencies: 1599
-- Name: TABLE user_worklist; Type: COMMENT; Schema: public; Owner: psql
--

COMMENT ON TABLE public.user_worklist IS 'Table used to store a user''s active worklist of products.';


--
-- TOC entry 1600 (class 1259 OID 81995895)
-- Name: v_newtime_indx; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_newtime_indx (
    "?column?" integer
);


ALTER TABLE public.v_newtime_indx OWNER TO psql;

--
-- TOC entry 1601 (class 1259 OID 81995898)
-- Name: v_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_ticketprice (
    ccticketprice real
);


ALTER TABLE public.v_ticketprice OWNER TO psql;

--
-- TOC entry 1602 (class 1259 OID 81995901)
-- Name: valid_styles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.valid_styles (
    style text
);


ALTER TABLE public.valid_styles OWNER TO psql;

--
-- TOC entry 1603 (class 1259 OID 81995906)
-- Name: xts_delete; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.xts_delete (
    id text,
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


ALTER TABLE public.xts_delete OWNER TO psql;

--
-- TOC entry 1604 (class 1259 OID 81995911)
-- Name: yt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.yt (
    product text
);


ALTER TABLE public.yt OWNER TO psql;

--
-- TOC entry 7795 (class 2606 OID 81997632)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 7793 (class 2606 OID 81997634)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 7797 (class 2606 OID 81997636)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7815 (class 2606 OID 81997638)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 7817 (class 2606 OID 81997640)
-- Name: channeloverride644e6396b4ab4d109fa624eebd25df78 channeloverride644e6396b4ab4d109fa624eebd25df78_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.channeloverride644e6396b4ab4d109fa624eebd25df78
    ADD CONSTRAINT channeloverride644e6396b4ab4d109fa624eebd25df78_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7819 (class 2606 OID 81997642)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 7821 (class 2606 OID 81997644)
-- Name: dc_adj321c639d83db4409959d5293d2d95e5c dc_adj321c639d83db4409959d5293d2d95e5c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj321c639d83db4409959d5293d2d95e5c
    ADD CONSTRAINT dc_adj321c639d83db4409959d5293d2d95e5c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7823 (class 2606 OID 81997646)
-- Name: dc_adj66dcb67b5f2b4ab0af678c36c17dc90b dc_adj66dcb67b5f2b4ab0af678c36c17dc90b_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj66dcb67b5f2b4ab0af678c36c17dc90b
    ADD CONSTRAINT dc_adj66dcb67b5f2b4ab0af678c36c17dc90b_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7825 (class 2606 OID 81997648)
-- Name: dc_adj98c083772fd642f09c8e4cc296c978e8 dc_adj98c083772fd642f09c8e4cc296c978e8_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj98c083772fd642f09c8e4cc296c978e8
    ADD CONSTRAINT dc_adj98c083772fd642f09c8e4cc296c978e8_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7827 (class 2606 OID 81997650)
-- Name: dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45 dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45
    ADD CONSTRAINT dc_adj_size0377f35da2c041e8aed2fcb7dd14ea45_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7829 (class 2606 OID 81997652)
-- Name: dc_adj_size07de34aef7a1432d9d8a6dac1028132b dc_adj_size07de34aef7a1432d9d8a6dac1028132b_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size07de34aef7a1432d9d8a6dac1028132b
    ADD CONSTRAINT dc_adj_size07de34aef7a1432d9d8a6dac1028132b_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7831 (class 2606 OID 81997654)
-- Name: dc_adj_size0c6c316c9aec45298fc486be3ef947d9 dc_adj_size0c6c316c9aec45298fc486be3ef947d9_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size0c6c316c9aec45298fc486be3ef947d9
    ADD CONSTRAINT dc_adj_size0c6c316c9aec45298fc486be3ef947d9_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7833 (class 2606 OID 81997656)
-- Name: dc_adj_size0ca0aa8b3250447295102282ef4b2e43 dc_adj_size0ca0aa8b3250447295102282ef4b2e43_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size0ca0aa8b3250447295102282ef4b2e43
    ADD CONSTRAINT dc_adj_size0ca0aa8b3250447295102282ef4b2e43_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7835 (class 2606 OID 81997658)
-- Name: dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e
    ADD CONSTRAINT dc_adj_size0d6f4a38dc7f438b8a071a5c62dbe21e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7837 (class 2606 OID 81997660)
-- Name: dc_adj_size137bdb391de644be85fcf505352b63e7 dc_adj_size137bdb391de644be85fcf505352b63e7_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size137bdb391de644be85fcf505352b63e7
    ADD CONSTRAINT dc_adj_size137bdb391de644be85fcf505352b63e7_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7839 (class 2606 OID 81997662)
-- Name: dc_adj_size13944857eb554426a606f6936a956933 dc_adj_size13944857eb554426a606f6936a956933_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size13944857eb554426a606f6936a956933
    ADD CONSTRAINT dc_adj_size13944857eb554426a606f6936a956933_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7841 (class 2606 OID 81997664)
-- Name: dc_adj_size14ad7e4c26d548e89282339d7bf11ab1 dc_adj_size14ad7e4c26d548e89282339d7bf11ab1_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size14ad7e4c26d548e89282339d7bf11ab1
    ADD CONSTRAINT dc_adj_size14ad7e4c26d548e89282339d7bf11ab1_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7843 (class 2606 OID 81997666)
-- Name: dc_adj_size157379abb39649e9bb09934eb7eed498 dc_adj_size157379abb39649e9bb09934eb7eed498_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size157379abb39649e9bb09934eb7eed498
    ADD CONSTRAINT dc_adj_size157379abb39649e9bb09934eb7eed498_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7845 (class 2606 OID 81997668)
-- Name: dc_adj_size1674e90817914a67afe549455602f8d0 dc_adj_size1674e90817914a67afe549455602f8d0_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size1674e90817914a67afe549455602f8d0
    ADD CONSTRAINT dc_adj_size1674e90817914a67afe549455602f8d0_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7847 (class 2606 OID 81997670)
-- Name: dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc
    ADD CONSTRAINT dc_adj_size1688492c3c184ddeae1d8fd7d5ce2acc_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7849 (class 2606 OID 81997672)
-- Name: dc_adj_size19fbcaf770a24634a6efd1dd570c0d54 dc_adj_size19fbcaf770a24634a6efd1dd570c0d54_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size19fbcaf770a24634a6efd1dd570c0d54
    ADD CONSTRAINT dc_adj_size19fbcaf770a24634a6efd1dd570c0d54_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7851 (class 2606 OID 81997674)
-- Name: dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944 dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944
    ADD CONSTRAINT dc_adj_size1a44bc53c4f14cfc88c0b5cc96276944_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7853 (class 2606 OID 81997676)
-- Name: dc_adj_size1ef4e19c81544ea38166540ae857c62d dc_adj_size1ef4e19c81544ea38166540ae857c62d_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size1ef4e19c81544ea38166540ae857c62d
    ADD CONSTRAINT dc_adj_size1ef4e19c81544ea38166540ae857c62d_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7855 (class 2606 OID 81997678)
-- Name: dc_adj_size204e060b0f524b39aa04c2eb93dbd940 dc_adj_size204e060b0f524b39aa04c2eb93dbd940_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size204e060b0f524b39aa04c2eb93dbd940
    ADD CONSTRAINT dc_adj_size204e060b0f524b39aa04c2eb93dbd940_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7857 (class 2606 OID 81997680)
-- Name: dc_adj_size2233d768367948689761ddfbdfe0bf3b dc_adj_size2233d768367948689761ddfbdfe0bf3b_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size2233d768367948689761ddfbdfe0bf3b
    ADD CONSTRAINT dc_adj_size2233d768367948689761ddfbdfe0bf3b_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7859 (class 2606 OID 81997682)
-- Name: dc_adj_size28d13e6837d44c4f887a3f9ee837b492 dc_adj_size28d13e6837d44c4f887a3f9ee837b492_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size28d13e6837d44c4f887a3f9ee837b492
    ADD CONSTRAINT dc_adj_size28d13e6837d44c4f887a3f9ee837b492_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7861 (class 2606 OID 81997684)
-- Name: dc_adj_size2931a7e1f8a44d49946b932c218e65ae dc_adj_size2931a7e1f8a44d49946b932c218e65ae_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size2931a7e1f8a44d49946b932c218e65ae
    ADD CONSTRAINT dc_adj_size2931a7e1f8a44d49946b932c218e65ae_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7863 (class 2606 OID 81997686)
-- Name: dc_adj_size34e759aa169f43c4bb4da96bd59dc21c dc_adj_size34e759aa169f43c4bb4da96bd59dc21c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size34e759aa169f43c4bb4da96bd59dc21c
    ADD CONSTRAINT dc_adj_size34e759aa169f43c4bb4da96bd59dc21c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7865 (class 2606 OID 81997688)
-- Name: dc_adj_size36e615305c684352bc63b15d2b6dc55b dc_adj_size36e615305c684352bc63b15d2b6dc55b_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size36e615305c684352bc63b15d2b6dc55b
    ADD CONSTRAINT dc_adj_size36e615305c684352bc63b15d2b6dc55b_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7867 (class 2606 OID 81997690)
-- Name: dc_adj_size4253c193bdf542b1970a092020d50bf4 dc_adj_size4253c193bdf542b1970a092020d50bf4_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size4253c193bdf542b1970a092020d50bf4
    ADD CONSTRAINT dc_adj_size4253c193bdf542b1970a092020d50bf4_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7869 (class 2606 OID 81997692)
-- Name: dc_adj_size438a72d08e944bceafda56c870ff7bb5 dc_adj_size438a72d08e944bceafda56c870ff7bb5_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size438a72d08e944bceafda56c870ff7bb5
    ADD CONSTRAINT dc_adj_size438a72d08e944bceafda56c870ff7bb5_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7871 (class 2606 OID 81997694)
-- Name: dc_adj_size44779378fad94650bba976c2b80c80d4 dc_adj_size44779378fad94650bba976c2b80c80d4_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size44779378fad94650bba976c2b80c80d4
    ADD CONSTRAINT dc_adj_size44779378fad94650bba976c2b80c80d4_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7873 (class 2606 OID 81997696)
-- Name: dc_adj_size4692e4dc29dc44598d36963d7e9eba33 dc_adj_size4692e4dc29dc44598d36963d7e9eba33_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size4692e4dc29dc44598d36963d7e9eba33
    ADD CONSTRAINT dc_adj_size4692e4dc29dc44598d36963d7e9eba33_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7875 (class 2606 OID 81997698)
-- Name: dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7 dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7
    ADD CONSTRAINT dc_adj_size4bf4ac80371b4aa6aaba4b56931a96d7_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7877 (class 2606 OID 81997700)
-- Name: dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a
    ADD CONSTRAINT dc_adj_size4e91ac56d2fd4d4f928b4b64a646b79a_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7879 (class 2606 OID 81997702)
-- Name: dc_adj_size52fde98e607141379a9e0afb43a716da dc_adj_size52fde98e607141379a9e0afb43a716da_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size52fde98e607141379a9e0afb43a716da
    ADD CONSTRAINT dc_adj_size52fde98e607141379a9e0afb43a716da_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7881 (class 2606 OID 81997704)
-- Name: dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1 dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1
    ADD CONSTRAINT dc_adj_size53cfb6f4481f4a62bf4d8772a85e3ac1_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7883 (class 2606 OID 81997706)
-- Name: dc_adj_size543b19042b744d18ad152028a66f1da3 dc_adj_size543b19042b744d18ad152028a66f1da3_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size543b19042b744d18ad152028a66f1da3
    ADD CONSTRAINT dc_adj_size543b19042b744d18ad152028a66f1da3_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7885 (class 2606 OID 81997708)
-- Name: dc_adj_size588cd271ad9c458e837baf520c9a2153 dc_adj_size588cd271ad9c458e837baf520c9a2153_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size588cd271ad9c458e837baf520c9a2153
    ADD CONSTRAINT dc_adj_size588cd271ad9c458e837baf520c9a2153_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7887 (class 2606 OID 81997710)
-- Name: dc_adj_size59c696b2de93477b8c21199e318c045c dc_adj_size59c696b2de93477b8c21199e318c045c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size59c696b2de93477b8c21199e318c045c
    ADD CONSTRAINT dc_adj_size59c696b2de93477b8c21199e318c045c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7889 (class 2606 OID 81997712)
-- Name: dc_adj_size5bfff380613c4b46b7d9809e22f87c04 dc_adj_size5bfff380613c4b46b7d9809e22f87c04_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size5bfff380613c4b46b7d9809e22f87c04
    ADD CONSTRAINT dc_adj_size5bfff380613c4b46b7d9809e22f87c04_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7891 (class 2606 OID 81997714)
-- Name: dc_adj_size6143f44900144595b180688364c6ad19 dc_adj_size6143f44900144595b180688364c6ad19_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6143f44900144595b180688364c6ad19
    ADD CONSTRAINT dc_adj_size6143f44900144595b180688364c6ad19_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7893 (class 2606 OID 81997716)
-- Name: dc_adj_size6302d2a2a71c47e683546207506d9e7c dc_adj_size6302d2a2a71c47e683546207506d9e7c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6302d2a2a71c47e683546207506d9e7c
    ADD CONSTRAINT dc_adj_size6302d2a2a71c47e683546207506d9e7c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7895 (class 2606 OID 81997718)
-- Name: dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3 dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3
    ADD CONSTRAINT dc_adj_size64c9378f41ba43e392fcc9c2b5723ec3_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7897 (class 2606 OID 81997720)
-- Name: dc_adj_size68707eea9b8743b0a31810410c0bc006 dc_adj_size68707eea9b8743b0a31810410c0bc006_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size68707eea9b8743b0a31810410c0bc006
    ADD CONSTRAINT dc_adj_size68707eea9b8743b0a31810410c0bc006_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7899 (class 2606 OID 81997722)
-- Name: dc_adj_size69614dcc21234acfb141ca4ba1d412f4 dc_adj_size69614dcc21234acfb141ca4ba1d412f4_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size69614dcc21234acfb141ca4ba1d412f4
    ADD CONSTRAINT dc_adj_size69614dcc21234acfb141ca4ba1d412f4_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7901 (class 2606 OID 81997724)
-- Name: dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2 dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2
    ADD CONSTRAINT dc_adj_size6cb57f89bdcf4d5ba05e5f7664a832d2_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7903 (class 2606 OID 81997726)
-- Name: dc_adj_size6d144af9787840cab3b007f65dcae9e0 dc_adj_size6d144af9787840cab3b007f65dcae9e0_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6d144af9787840cab3b007f65dcae9e0
    ADD CONSTRAINT dc_adj_size6d144af9787840cab3b007f65dcae9e0_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7905 (class 2606 OID 81997728)
-- Name: dc_adj_size6eec8fa878e34df78e491631144654f8 dc_adj_size6eec8fa878e34df78e491631144654f8_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6eec8fa878e34df78e491631144654f8
    ADD CONSTRAINT dc_adj_size6eec8fa878e34df78e491631144654f8_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7907 (class 2606 OID 81997730)
-- Name: dc_adj_size6ef1f61eac0c41f29f636d250f74dae3 dc_adj_size6ef1f61eac0c41f29f636d250f74dae3_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size6ef1f61eac0c41f29f636d250f74dae3
    ADD CONSTRAINT dc_adj_size6ef1f61eac0c41f29f636d250f74dae3_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7909 (class 2606 OID 81997733)
-- Name: dc_adj_size700d93d701334210959d367fe6b5f2d4 dc_adj_size700d93d701334210959d367fe6b5f2d4_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size700d93d701334210959d367fe6b5f2d4
    ADD CONSTRAINT dc_adj_size700d93d701334210959d367fe6b5f2d4_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7911 (class 2606 OID 81997737)
-- Name: dc_adj_size723dcde017c94f7db8cd6cf7f280b877 dc_adj_size723dcde017c94f7db8cd6cf7f280b877_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size723dcde017c94f7db8cd6cf7f280b877
    ADD CONSTRAINT dc_adj_size723dcde017c94f7db8cd6cf7f280b877_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7913 (class 2606 OID 81997739)
-- Name: dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c
    ADD CONSTRAINT dc_adj_size72d28bee6cdc49c0b9786b9859b1ad8c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7915 (class 2606 OID 81997741)
-- Name: dc_adj_size73bb47b305214bd79beb3babb3870be7 dc_adj_size73bb47b305214bd79beb3babb3870be7_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size73bb47b305214bd79beb3babb3870be7
    ADD CONSTRAINT dc_adj_size73bb47b305214bd79beb3babb3870be7_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7917 (class 2606 OID 81997743)
-- Name: dc_adj_size773e8db596c64322a82224f6e2d4333e dc_adj_size773e8db596c64322a82224f6e2d4333e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size773e8db596c64322a82224f6e2d4333e
    ADD CONSTRAINT dc_adj_size773e8db596c64322a82224f6e2d4333e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7919 (class 2606 OID 81997745)
-- Name: dc_adj_size7f60ac10902f4ff78c4f57e9025b9213 dc_adj_size7f60ac10902f4ff78c4f57e9025b9213_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size7f60ac10902f4ff78c4f57e9025b9213
    ADD CONSTRAINT dc_adj_size7f60ac10902f4ff78c4f57e9025b9213_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7921 (class 2606 OID 81997747)
-- Name: dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca
    ADD CONSTRAINT dc_adj_size8b2c99e98e8d4505b5676b0d4b3bd3ca_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7923 (class 2606 OID 81997749)
-- Name: dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb
    ADD CONSTRAINT dc_adj_size8ccbd5a865e94260baf63d4d2054c8bb_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7925 (class 2606 OID 81997751)
-- Name: dc_adj_size8cdfa294dae54854bd4a8ea08929065d dc_adj_size8cdfa294dae54854bd4a8ea08929065d_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8cdfa294dae54854bd4a8ea08929065d
    ADD CONSTRAINT dc_adj_size8cdfa294dae54854bd4a8ea08929065d_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7927 (class 2606 OID 81997753)
-- Name: dc_adj_size8d9897fe1fc447c785138a533405da59 dc_adj_size8d9897fe1fc447c785138a533405da59_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8d9897fe1fc447c785138a533405da59
    ADD CONSTRAINT dc_adj_size8d9897fe1fc447c785138a533405da59_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7929 (class 2606 OID 81997755)
-- Name: dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed
    ADD CONSTRAINT dc_adj_size8ecdb43501894fa9bd08dd3f417a87ed_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7931 (class 2606 OID 81997757)
-- Name: dc_adj_size8f460389057d4196859db30b087dafd5 dc_adj_size8f460389057d4196859db30b087dafd5_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size8f460389057d4196859db30b087dafd5
    ADD CONSTRAINT dc_adj_size8f460389057d4196859db30b087dafd5_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7933 (class 2606 OID 81997759)
-- Name: dc_adj_size911241a0c4724da2a4456f2f504811b1 dc_adj_size911241a0c4724da2a4456f2f504811b1_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size911241a0c4724da2a4456f2f504811b1
    ADD CONSTRAINT dc_adj_size911241a0c4724da2a4456f2f504811b1_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7935 (class 2606 OID 81997761)
-- Name: dc_adj_size929245c90aeb4334a320dde54b8fa73a dc_adj_size929245c90aeb4334a320dde54b8fa73a_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size929245c90aeb4334a320dde54b8fa73a
    ADD CONSTRAINT dc_adj_size929245c90aeb4334a320dde54b8fa73a_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7937 (class 2606 OID 81997763)
-- Name: dc_adj_size9341086b285a40fa9b2e85f5cdbc5888 dc_adj_size9341086b285a40fa9b2e85f5cdbc5888_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size9341086b285a40fa9b2e85f5cdbc5888
    ADD CONSTRAINT dc_adj_size9341086b285a40fa9b2e85f5cdbc5888_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7939 (class 2606 OID 81997765)
-- Name: dc_adj_size9888ba377895498c8e28f43f83f4e5bb dc_adj_size9888ba377895498c8e28f43f83f4e5bb_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size9888ba377895498c8e28f43f83f4e5bb
    ADD CONSTRAINT dc_adj_size9888ba377895498c8e28f43f83f4e5bb_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7941 (class 2606 OID 81997767)
-- Name: dc_adj_size9a045c455433495c8e1ad3e887d1e907 dc_adj_size9a045c455433495c8e1ad3e887d1e907_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size9a045c455433495c8e1ad3e887d1e907
    ADD CONSTRAINT dc_adj_size9a045c455433495c8e1ad3e887d1e907_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7943 (class 2606 OID 81997769)
-- Name: dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e
    ADD CONSTRAINT dc_adj_size9e5ac9eef9ad48848de506158e8c3e1e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7945 (class 2606 OID 81997771)
-- Name: dc_adj_size9f6eecb92b7849558ef8fe8191221753 dc_adj_size9f6eecb92b7849558ef8fe8191221753_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_size9f6eecb92b7849558ef8fe8191221753
    ADD CONSTRAINT dc_adj_size9f6eecb92b7849558ef8fe8191221753_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7947 (class 2606 OID 81997773)
-- Name: dc_adj_sizea298cb26a1b548f198df14ba53aebd42 dc_adj_sizea298cb26a1b548f198df14ba53aebd42_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizea298cb26a1b548f198df14ba53aebd42
    ADD CONSTRAINT dc_adj_sizea298cb26a1b548f198df14ba53aebd42_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7949 (class 2606 OID 81997775)
-- Name: dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad
    ADD CONSTRAINT dc_adj_sizea30c1a1502124abe9585ae8a4ff4d8ad_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7951 (class 2606 OID 81997777)
-- Name: dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc
    ADD CONSTRAINT dc_adj_sizea53f186922bb4ec8a1d0766506c7dcfc_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7953 (class 2606 OID 81997779)
-- Name: dc_adj_sizea543141f96454e2095a0b908946653cc dc_adj_sizea543141f96454e2095a0b908946653cc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizea543141f96454e2095a0b908946653cc
    ADD CONSTRAINT dc_adj_sizea543141f96454e2095a0b908946653cc_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7955 (class 2606 OID 81997781)
-- Name: dc_adj_sizead40aae39b0748cea785d382a5117a8b dc_adj_sizead40aae39b0748cea785d382a5117a8b_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizead40aae39b0748cea785d382a5117a8b
    ADD CONSTRAINT dc_adj_sizead40aae39b0748cea785d382a5117a8b_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7957 (class 2606 OID 81997783)
-- Name: dc_adj_sizead43bcf2cbab4417839176bf6962010a dc_adj_sizead43bcf2cbab4417839176bf6962010a_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizead43bcf2cbab4417839176bf6962010a
    ADD CONSTRAINT dc_adj_sizead43bcf2cbab4417839176bf6962010a_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7959 (class 2606 OID 81997785)
-- Name: dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f
    ADD CONSTRAINT dc_adj_sizeb1a10a3fdb3a4db4a21b2a7b61cff97f_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7961 (class 2606 OID 81997787)
-- Name: dc_adj_sizeb1d422c910574984943028a9662590d2 dc_adj_sizeb1d422c910574984943028a9662590d2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeb1d422c910574984943028a9662590d2
    ADD CONSTRAINT dc_adj_sizeb1d422c910574984943028a9662590d2_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7963 (class 2606 OID 81997789)
-- Name: dc_adj_sizeb25086e7fd25468fa7da37d929c5c815 dc_adj_sizeb25086e7fd25468fa7da37d929c5c815_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeb25086e7fd25468fa7da37d929c5c815
    ADD CONSTRAINT dc_adj_sizeb25086e7fd25468fa7da37d929c5c815_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7965 (class 2606 OID 81997791)
-- Name: dc_adj_sizec39477b9192e473489dde68b37860350 dc_adj_sizec39477b9192e473489dde68b37860350_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizec39477b9192e473489dde68b37860350
    ADD CONSTRAINT dc_adj_sizec39477b9192e473489dde68b37860350_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7967 (class 2606 OID 81997793)
-- Name: dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0 dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0
    ADD CONSTRAINT dc_adj_sizecaf93bf9ae1c422c937b0e1887d836a0_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7969 (class 2606 OID 81997795)
-- Name: dc_adj_sizecc7af7b4e245441596713ac213bcda08 dc_adj_sizecc7af7b4e245441596713ac213bcda08_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizecc7af7b4e245441596713ac213bcda08
    ADD CONSTRAINT dc_adj_sizecc7af7b4e245441596713ac213bcda08_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7971 (class 2606 OID 81997797)
-- Name: dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44 dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44
    ADD CONSTRAINT dc_adj_sizecf08f34c38bf49ca86cd3f8914101a44_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7973 (class 2606 OID 81997799)
-- Name: dc_adj_sized17ddb384b9f41758ea8f53aa49b4342 dc_adj_sized17ddb384b9f41758ea8f53aa49b4342_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sized17ddb384b9f41758ea8f53aa49b4342
    ADD CONSTRAINT dc_adj_sized17ddb384b9f41758ea8f53aa49b4342_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7975 (class 2606 OID 81997801)
-- Name: dc_adj_sized3baad3607a4442fa42001b4bc00a6e5 dc_adj_sized3baad3607a4442fa42001b4bc00a6e5_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sized3baad3607a4442fa42001b4bc00a6e5
    ADD CONSTRAINT dc_adj_sized3baad3607a4442fa42001b4bc00a6e5_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7977 (class 2606 OID 81997803)
-- Name: dc_adj_sized56c4d590f5048b78a066f1d86f18bf1 dc_adj_sized56c4d590f5048b78a066f1d86f18bf1_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sized56c4d590f5048b78a066f1d86f18bf1
    ADD CONSTRAINT dc_adj_sized56c4d590f5048b78a066f1d86f18bf1_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7979 (class 2606 OID 81997805)
-- Name: dc_adj_sized5e9899884a247e99fb3b48492c87ef3 dc_adj_sized5e9899884a247e99fb3b48492c87ef3_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sized5e9899884a247e99fb3b48492c87ef3
    ADD CONSTRAINT dc_adj_sized5e9899884a247e99fb3b48492c87ef3_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7981 (class 2606 OID 81997807)
-- Name: dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd
    ADD CONSTRAINT dc_adj_sizedb9f9eeb10ab49a5bbfec8fea4589ccd_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7983 (class 2606 OID 81997809)
-- Name: dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f
    ADD CONSTRAINT dc_adj_sizee24d4723d2364a1ebddcea1ba87b978f_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7985 (class 2606 OID 81997811)
-- Name: dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101 dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101
    ADD CONSTRAINT dc_adj_sizee2a6462a9ae242f9a7ce72baee5c2101_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7987 (class 2606 OID 81997813)
-- Name: dc_adj_sizee2c098b576814d58be3819220be1457c dc_adj_sizee2c098b576814d58be3819220be1457c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee2c098b576814d58be3819220be1457c
    ADD CONSTRAINT dc_adj_sizee2c098b576814d58be3819220be1457c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7989 (class 2606 OID 81997815)
-- Name: dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba
    ADD CONSTRAINT dc_adj_sizee5e244a7dc1240c3af53448e2e2d1dba_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7991 (class 2606 OID 81997817)
-- Name: dc_adj_sizee77b1474b7db43b3864631db09c05252 dc_adj_sizee77b1474b7db43b3864631db09c05252_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee77b1474b7db43b3864631db09c05252
    ADD CONSTRAINT dc_adj_sizee77b1474b7db43b3864631db09c05252_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7993 (class 2606 OID 81997819)
-- Name: dc_adj_sizee945bb16681046228e65e7f10c0cab7e dc_adj_sizee945bb16681046228e65e7f10c0cab7e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizee945bb16681046228e65e7f10c0cab7e
    ADD CONSTRAINT dc_adj_sizee945bb16681046228e65e7f10c0cab7e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7995 (class 2606 OID 81997821)
-- Name: dc_adj_sizeea59a18eba104b85b14ccf729fc9190e dc_adj_sizeea59a18eba104b85b14ccf729fc9190e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeea59a18eba104b85b14ccf729fc9190e
    ADD CONSTRAINT dc_adj_sizeea59a18eba104b85b14ccf729fc9190e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7997 (class 2606 OID 81997823)
-- Name: dc_adj_sizeea71e7f68da849e39437de793209347c dc_adj_sizeea71e7f68da849e39437de793209347c_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeea71e7f68da849e39437de793209347c
    ADD CONSTRAINT dc_adj_sizeea71e7f68da849e39437de793209347c_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7999 (class 2606 OID 81997825)
-- Name: dc_adj_sizeec1acad72e68451aafa1739f6803942a dc_adj_sizeec1acad72e68451aafa1739f6803942a_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeec1acad72e68451aafa1739f6803942a
    ADD CONSTRAINT dc_adj_sizeec1acad72e68451aafa1739f6803942a_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8001 (class 2606 OID 81997827)
-- Name: dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7 dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7
    ADD CONSTRAINT dc_adj_sizeee79c241ae1a4be3b42d8be92493d7a7_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8003 (class 2606 OID 81997829)
-- Name: dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e
    ADD CONSTRAINT dc_adj_sizef1e8d231b38a4ca4b4ed8812b02ada9e_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8005 (class 2606 OID 81997831)
-- Name: dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb
    ADD CONSTRAINT dc_adj_sizef2227616322d44ffbc6b2e6d8f3e92bb_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8007 (class 2606 OID 81997833)
-- Name: dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1 dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1
    ADD CONSTRAINT dc_adj_sizef2ae21b3d32042afbc99cac040c8baf1_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8009 (class 2606 OID 81997835)
-- Name: dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621 dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621
    ADD CONSTRAINT dc_adj_sizef3e4889f12b04c5dbed00c18e7bc7621_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8011 (class 2606 OID 81997837)
-- Name: dc_adj_sizef6e5478bc7634bd49e59e4d936430d46 dc_adj_sizef6e5478bc7634bd49e59e4d936430d46_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef6e5478bc7634bd49e59e4d936430d46
    ADD CONSTRAINT dc_adj_sizef6e5478bc7634bd49e59e4d936430d46_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8013 (class 2606 OID 81997839)
-- Name: dc_adj_sizef7c76930a2d54975b094fd3682f7fa69 dc_adj_sizef7c76930a2d54975b094fd3682f7fa69_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizef7c76930a2d54975b094fd3682f7fa69
    ADD CONSTRAINT dc_adj_sizef7c76930a2d54975b094fd3682f7fa69_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8015 (class 2606 OID 81997841)
-- Name: dc_adj_sizefbbe83db721d444e99b575388c227fdb dc_adj_sizefbbe83db721d444e99b575388c227fdb_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizefbbe83db721d444e99b575388c227fdb
    ADD CONSTRAINT dc_adj_sizefbbe83db721d444e99b575388c227fdb_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8017 (class 2606 OID 81997843)
-- Name: dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec
    ADD CONSTRAINT dc_adj_sizefd884ddb5f3b4b9aad496106671c29ec_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8019 (class 2606 OID 81997845)
-- Name: dc_adjb01742a33d504f43a94defbcdde9c654 dc_adjb01742a33d504f43a94defbcdde9c654_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adjb01742a33d504f43a94defbcdde9c654
    ADD CONSTRAINT dc_adjb01742a33d504f43a94defbcdde9c654_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8021 (class 2606 OID 81997847)
-- Name: dc_adje6917d8095224a8487abf97d29d7fbf0 dc_adje6917d8095224a8487abf97d29d7fbf0_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dc_adje6917d8095224a8487abf97d29d7fbf0
    ADD CONSTRAINT dc_adje6917d8095224a8487abf97d29d7fbf0_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8023 (class 2606 OID 81997849)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 8025 (class 2606 OID 81997851)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- TOC entry 8027 (class 2606 OID 81997853)
-- Name: exp01_a_assortment exp01_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_a_assortment
    ADD CONSTRAINT exp01_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 7799 (class 2606 OID 81997858)
-- Name: exp01_an_price_storecount_info exp01_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_an_price_storecount_info
    ADD CONSTRAINT exp01_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 8029 (class 2606 OID 81997899)
-- Name: exp01_authorization exp01_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_authorization
    ADD CONSTRAINT exp01_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 8031 (class 2606 OID 81997901)
-- Name: exp01_bod exp01_bod_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_bod
    ADD CONSTRAINT exp01_bod_pkey PRIMARY KEY (tolocation, product, fromlocation);


--
-- TOC entry 8033 (class 2606 OID 81997903)
-- Name: exp01_corpdisc exp01_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_corpdisc
    ADD CONSTRAINT exp01_corpdisc_pkey PRIMARY KEY (department, product, location, "time");


--
-- TOC entry 8035 (class 2606 OID 81997905)
-- Name: exp01_d_cluster exp01_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_cluster
    ADD CONSTRAINT exp01_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 8037 (class 2606 OID 81997907)
-- Name: exp01_d_location exp01_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_location
    ADD CONSTRAINT exp01_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 8039 (class 2606 OID 81997909)
-- Name: exp01_d_prodlife exp01_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_prodlife
    ADD CONSTRAINT exp01_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 8042 (class 2606 OID 81997911)
-- Name: exp01_d_product_archives_new exp01_d_product_archives_new_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_product_archives_new
    ADD CONSTRAINT exp01_d_product_archives_new_pkey PRIMARY KEY (id);


--
-- TOC entry 7801 (class 2606 OID 81997916)
-- Name: exp01_d_product exp01_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_product
    ADD CONSTRAINT exp01_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 8045 (class 2606 OID 81997945)
-- Name: exp01_d_time exp01_d_time2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_time
    ADD CONSTRAINT exp01_d_time2_pkey PRIMARY KEY (id);


--
-- TOC entry 8047 (class 2606 OID 81997947)
-- Name: exp01_d_time_bkp exp01_d_time_bkp_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_d_time_bkp
    ADD CONSTRAINT exp01_d_time_bkp_pkey PRIMARY KEY (id);


--
-- TOC entry 8049 (class 2606 OID 81997949)
-- Name: exp01_eohdata exp01_eohdata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_eohdata
    ADD CONSTRAINT exp01_eohdata_pkey PRIMARY KEY (product, location);


--
-- TOC entry 8052 (class 2606 OID 81997951)
-- Name: exp01_h_clusterstd exp01_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_clusterstd
    ADD CONSTRAINT exp01_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 8054 (class 2606 OID 81997953)
-- Name: exp01_h_locdcstd exp01_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_locdcstd
    ADD CONSTRAINT exp01_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 8060 (class 2606 OID 81997955)
-- Name: exp01_h_locstd exp01_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_locstd
    ADD CONSTRAINT exp01_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 8062 (class 2606 OID 81997957)
-- Name: exp01_h_prodlifestd exp01_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_prodlifestd
    ADD CONSTRAINT exp01_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 7807 (class 2606 OID 81997962)
-- Name: exp01_h_prodstd exp01_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_prodstd
    ADD CONSTRAINT exp01_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 8066 (class 2606 OID 81997987)
-- Name: exp01_h_timeflrset_bkp exp01_h_timeflrset_bkp_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_timeflrset_bkp
    ADD CONSTRAINT exp01_h_timeflrset_bkp_pkey PRIMARY KEY (id);


--
-- TOC entry 8064 (class 2606 OID 81997989)
-- Name: exp01_h_timeflrset exp01_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_timeflrset
    ADD CONSTRAINT exp01_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 8068 (class 2606 OID 81997991)
-- Name: exp01_h_timestd exp01_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_h_timestd
    ADD CONSTRAINT exp01_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 8070 (class 2606 OID 81997993)
-- Name: exp01_l_apsindexlookup exp01_l_apsindexlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_apsindexlookup
    ADD CONSTRAINT exp01_l_apsindexlookup_pkey PRIMARY KEY ("time", product, location);


--
-- TOC entry 8072 (class 2606 OID 81997998)
-- Name: exp01_l_baseapslookup exp01_l_baseapslookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_baseapslookup
    ADD CONSTRAINT exp01_l_baseapslookup_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8074 (class 2606 OID 81998000)
-- Name: exp01_l_ccranklookup exp01_l_ccranklookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_ccranklookup
    ADD CONSTRAINT exp01_l_ccranklookup_pkey PRIMARY KEY (product, location, "time", slsrank);


--
-- TOC entry 8076 (class 2606 OID 81998002)
-- Name: exp01_l_dclookup exp01_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_dclookup
    ADD CONSTRAINT exp01_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 8079 (class 2606 OID 81998004)
-- Name: exp01_l_floorsetlookup exp01_l_floorsetlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_floorsetlookup
    ADD CONSTRAINT exp01_l_floorsetlookup_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 8081 (class 2606 OID 81998006)
-- Name: exp01_l_gradelookup exp01_l_gradelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_gradelookup
    ADD CONSTRAINT exp01_l_gradelookup_pkey PRIMARY KEY ("time", product, location);


--
-- TOC entry 8083 (class 2606 OID 81998008)
-- Name: exp01_l_lifecyclelookup exp01_l_lifecyclelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_lifecyclelookup
    ADD CONSTRAINT exp01_l_lifecyclelookup_pkey PRIMARY KEY (product, weeks);


--
-- TOC entry 8085 (class 2606 OID 81998010)
-- Name: exp01_l_priceeventlookup exp01_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_priceeventlookup
    ADD CONSTRAINT exp01_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 8087 (class 2606 OID 81998012)
-- Name: exp01_l_promodesclookup exp01_l_promodesclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_promodesclookup
    ADD CONSTRAINT exp01_l_promodesclookup_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8089 (class 2606 OID 81998014)
-- Name: exp01_l_ssglookup exp01_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_ssglookup
    ADD CONSTRAINT exp01_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 8091 (class 2606 OID 81998016)
-- Name: exp01_l_storedclookup exp01_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_storedclookup
    ADD CONSTRAINT exp01_l_storedclookup_pkey PRIMARY KEY (store, channel);


--
-- TOC entry 8093 (class 2606 OID 81998018)
-- Name: exp01_l_storelookup exp01_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_storelookup
    ADD CONSTRAINT exp01_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 8095 (class 2606 OID 81998023)
-- Name: exp01_l_weeklookup exp01_l_weeklookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_l_weeklookup
    ADD CONSTRAINT exp01_l_weeklookup_pkey PRIMARY KEY ("time");


--
-- TOC entry 8097 (class 2606 OID 81998025)
-- Name: exp01_ma_classattributes exp01_ma_classattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_classattributes
    ADD CONSTRAINT exp01_ma_classattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 8099 (class 2606 OID 81998027)
-- Name: exp01_ma_districtattributes exp01_ma_districtattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_districtattributes
    ADD CONSTRAINT exp01_ma_districtattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 8101 (class 2606 OID 81998029)
-- Name: exp01_ma_dptflrsetattributes_old exp01_ma_dptflrsetattributes_new_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_dptflrsetattributes_old
    ADD CONSTRAINT exp01_ma_dptflrsetattributes_new_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 8105 (class 2606 OID 81998031)
-- Name: exp01_ma_imgattributes_hs_prod exp01_ma_imgattributes_hs_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_imgattributes_hs_prod
    ADD CONSTRAINT exp01_ma_imgattributes_hs_prod_pkey PRIMARY KEY (product);


--
-- TOC entry 8103 (class 2606 OID 81998033)
-- Name: exp01_ma_imgattributes exp01_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_imgattributes
    ADD CONSTRAINT exp01_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 8107 (class 2606 OID 81998038)
-- Name: exp01_ma_regionattributes exp01_ma_regionattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_regionattributes
    ADD CONSTRAINT exp01_ma_regionattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 8109 (class 2606 OID 81998040)
-- Name: exp01_ma_sizeattributes exp01_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_sizeattributes
    ADD CONSTRAINT exp01_ma_sizeattributes_pkey PRIMARY KEY (product, sizeattribute);


--
-- TOC entry 8112 (class 2606 OID 81998078)
-- Name: exp01_ma_storeattributes exp01_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_storeattributes
    ADD CONSTRAINT exp01_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 7809 (class 2606 OID 81998080)
-- Name: exp01_ma_styleattributes exp01_ma_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_styleattributes
    ADD CONSTRAINT exp01_ma_styleattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7811 (class 2606 OID 81998082)
-- Name: exp01_ma_stylecolorattributes exp01_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_stylecolorattributes
    ADD CONSTRAINT exp01_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7813 (class 2606 OID 81998087)
-- Name: exp01_ma_stylecolorchannelattributes exp01_ma_stylecolorchannelattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_stylecolorchannelattributes
    ADD CONSTRAINT exp01_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location);


--
-- TOC entry 8114 (class 2606 OID 81998092)
-- Name: exp01_ma_subclassattributes exp01_ma_subclassattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_subclassattributes
    ADD CONSTRAINT exp01_ma_subclassattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 8116 (class 2606 OID 81998094)
-- Name: exp01_ma_weekattributes exp01_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_ma_weekattributes
    ADD CONSTRAINT exp01_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 8118 (class 2606 OID 81998096)
-- Name: exp01_p_channeloverride exp01_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_p_channeloverride
    ADD CONSTRAINT exp01_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 8120 (class 2606 OID 81998104)
-- Name: exp01_p_dc_adj exp01_p_dc_adj_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_p_dc_adj
    ADD CONSTRAINT exp01_p_dc_adj_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8122 (class 2606 OID 81998118)
-- Name: exp01_p_dc_adj_size exp01_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_p_dc_adj_size
    ADD CONSTRAINT exp01_p_dc_adj_size_pk UNIQUE (product, location, "time");


--
-- TOC entry 8124 (class 2606 OID 81998165)
-- Name: exp01_p_itemprice exp01_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_p_itemprice
    ADD CONSTRAINT exp01_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 8126 (class 2606 OID 81998206)
-- Name: exp01_roledimension exp01_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_roledimension
    ADD CONSTRAINT exp01_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 8128 (class 2606 OID 81998208)
-- Name: exp01_servicedefn exp01_servicedefn_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_servicedefn
    ADD CONSTRAINT exp01_servicedefn_pkey PRIMARY KEY (service);


--
-- TOC entry 8130 (class 2606 OID 81998210)
-- Name: exp01_serviceparams exp01_serviceparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_serviceparams
    ADD CONSTRAINT exp01_serviceparams_pkey PRIMARY KEY (id);


--
-- TOC entry 8132 (class 2606 OID 81998212)
-- Name: exp01_sizinglookup exp01_sizinglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_sizinglookup
    ADD CONSTRAINT exp01_sizinglookup_pkey UNIQUE (sizerange, size, strselling_channel);


--
-- TOC entry 8134 (class 2606 OID 81998214)
-- Name: exp01_specimages exp01_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_specimages
    ADD CONSTRAINT exp01_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 8136 (class 2606 OID 81998219)
-- Name: exp01_swatches exp01_swatches_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_swatches
    ADD CONSTRAINT exp01_swatches_pkey PRIMARY KEY (validvalue);


--
-- TOC entry 8138 (class 2606 OID 81998221)
-- Name: exp01_targetsetting exp01_targetsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_targetsetting
    ADD CONSTRAINT exp01_targetsetting_pkey PRIMARY KEY (id, version, type, scope_hash);


--
-- TOC entry 8140 (class 2606 OID 81998223)
-- Name: exp01_v_memberbasedvalidvalues exp01_v_memberbasedvalidvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.exp01_v_memberbasedvalidvalues
    ADD CONSTRAINT exp01_v_memberbasedvalidvalues_pkey PRIMARY KEY (indx);


--
-- TOC entry 8146 (class 2606 OID 81998225)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 8151 (class 2606 OID 81998227)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 8153 (class 2606 OID 81998229)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 8155 (class 2606 OID 81998231)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 8157 (class 2606 OID 81998233)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 8159 (class 2606 OID 81998235)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 8161 (class 2606 OID 81998237)
-- Name: targetsetting targetsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.targetsetting
    ADD CONSTRAINT targetsetting_pkey PRIMARY KEY (id, version, type, scope_hash);


--
-- TOC entry 8148 (class 2606 OID 81998239)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 8164 (class 2606 OID 81998241)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 8166 (class 2606 OID 81998243)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 8168 (class 2606 OID 81998245)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 8170 (class 2606 OID 81998247)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 7802 (class 1259 OID 81998248)
-- Name: ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances0_indx ON public.exp01_h_prodstd USING btree (ancestor0);


--
-- TOC entry 8055 (class 1259 OID 81998276)
-- Name: ances0_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances0_str_indx ON public.exp01_h_locstd USING btree (ancestor0);


--
-- TOC entry 7803 (class 1259 OID 81998277)
-- Name: ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances1_indx ON public.exp01_h_prodstd USING btree (ancestor1);


--
-- TOC entry 8056 (class 1259 OID 81998284)
-- Name: ances1_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances1_str_indx ON public.exp01_h_locstd USING btree (ancestor1);


--
-- TOC entry 7804 (class 1259 OID 81998285)
-- Name: ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances2_indx ON public.exp01_h_prodstd USING btree (ancestor2);


--
-- TOC entry 8057 (class 1259 OID 81998304)
-- Name: ances2_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances2_str_indx ON public.exp01_h_locstd USING btree (ancestor2);


--
-- TOC entry 7805 (class 1259 OID 81998305)
-- Name: ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances3_indx ON public.exp01_h_prodstd USING btree (ancestor3);


--
-- TOC entry 8058 (class 1259 OID 81998316)
-- Name: ances3_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ances3_str_indx ON public.exp01_h_locstd USING btree (ancestor3);


--
-- TOC entry 8040 (class 1259 OID 81998317)
-- Name: exp01_d_product_archives_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX exp01_d_product_archives_id_idx ON public.exp01_d_product_archives USING btree (id);


--
-- TOC entry 8043 (class 1259 OID 81998318)
-- Name: exp01_d_product_archives_temp_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX exp01_d_product_archives_temp_id_idx ON public.exp01_d_product_archives_temp USING btree (id);


--
-- TOC entry 8050 (class 1259 OID 81998319)
-- Name: exp01_eohdata_stylecolor_product_channel_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX exp01_eohdata_stylecolor_product_channel_idx ON public.exp01_eohdata_stylecolor USING btree (product, channel);


--
-- TOC entry 8077 (class 1259 OID 81998320)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.exp01_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 8141 (class 1259 OID 81998324)
-- Name: mbvv_attributeid; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX mbvv_attributeid ON public.exp01_v_memberbasedvalidvalues USING btree (attributeid);


--
-- TOC entry 8142 (class 1259 OID 81998325)
-- Name: mbvv_attributekey; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX mbvv_attributekey ON public.exp01_v_memberbasedvalidvalues USING btree (attributekey);


--
-- TOC entry 8143 (class 1259 OID 81998334)
-- Name: mvv_membertie; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX mvv_membertie ON public.exp01_v_memberbasedvalidvalues USING btree (membertie, attributeid);


--
-- TOC entry 8144 (class 1259 OID 81998338)
-- Name: mvv_membertiekey; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX mvv_membertiekey ON public.exp01_v_memberbasedvalidvalues USING btree (membertie, attributeid, attributekey);


--
-- TOC entry 8110 (class 1259 OID 81998346)
-- Name: sizeattr_parent_key; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX sizeattr_parent_key ON public.exp01_ma_sizeattributes USING btree (parent_id);


--
-- TOC entry 8149 (class 1259 OID 81998369)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 8162 (class 1259 OID 81998370)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 8194 (class 2620 OID 81998371)
-- Name: exp01_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current)) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.store_eligibility_triger_chetan();


--
-- TOC entry 8212 (class 2620 OID 81998372)
-- Name: exp01_l_dependencylookup ca_2_trigger_on_delete; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_2_trigger_on_delete AFTER DELETE ON public.exp01_l_dependencylookup FOR EACH ROW EXECUTE FUNCTION public.hasbeenpatterned_afterdelete();

ALTER TABLE public.exp01_l_dependencylookup DISABLE TRIGGER ca_2_trigger_on_delete;


--
-- TOC entry 8213 (class 2620 OID 81998373)
-- Name: exp01_l_dependencylookup ca_2_trigger_on_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_2_trigger_on_insert AFTER INSERT ON public.exp01_l_dependencylookup FOR EACH ROW EXECUTE FUNCTION public.hasbeenpatterned_afterinsert();

ALTER TABLE public.exp01_l_dependencylookup DISABLE TRIGGER ca_2_trigger_on_insert;


--
-- TOC entry 8207 (class 2620 OID 81998374)
-- Name: cart_ranging calc_store_count; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER calc_store_count BEFORE INSERT OR UPDATE ON public.cart_ranging FOR EACH ROW EXECUTE FUNCTION public.calc_store_count_ranging();


--
-- TOC entry 8195 (class 2620 OID 81998375)
-- Name: exp01_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.dbt_wk >= new.erlstmkdnwk) OR (old.dbt_wk < old.plan_current)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 8189 (class 2620 OID 81998376)
-- Name: exp01_ma_stylecolorattributes efo_lookup; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER efo_lookup AFTER UPDATE OF retail_stylecolor_efo ON public.exp01_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.efo_lookup();


--
-- TOC entry 8196 (class 2620 OID 81998377)
-- Name: exp01_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.exitdate <= new.erlstmkdnwk) OR (old.exitdate < old.plan_current)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();


--
-- TOC entry 8214 (class 2620 OID 81998378)
-- Name: exp01_ma_imgattributes img_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER img_update AFTER UPDATE OF img ON public.exp01_ma_imgattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.trigger_img_update();


--
-- TOC entry 8208 (class 2620 OID 81998379)
-- Name: employees last_name_changes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER last_name_changes BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.log_last_name_changes();


--
-- TOC entry 8197 (class 2620 OID 81998380)
-- Name: exp01_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((((new.relaunchweek IS NULL) AND ((new.erlstmkdnwk <= new.dbt_wk) OR (old.erlstmkdnwk < old.plan_current) OR (new.exitdate <= new.erlstmkdnwk))) OR ((new.relaunchweek IS NOT NULL) AND ((new.erlstmkdnwk <= new.relaunchweek) OR (new.erlstmkdnwk < old.plan_current) OR (new.exitdate <= new.erlstmkdnwk)))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.md_trigger_on_update_validity_check();


--
-- TOC entry 8198 (class 2620 OID 81998381)
-- Name: exp01_ma_stylecolorchannelattributes on_cc_flrset_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_cc_flrset_update AFTER UPDATE OF cc_flrset ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_update_ccfloorset();


--
-- TOC entry 8190 (class 2620 OID 81998382)
-- Name: exp01_ma_stylecolorattributes on_ccfloorset_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_ccfloorset_update AFTER UPDATE OF ccfloorset ON public.exp01_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_update_cc_flrset();


--
-- TOC entry 8225 (class 2620 OID 81998383)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 8226 (class 2620 OID 81998384)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 8183 (class 2620 OID 81998385)
-- Name: exp01_ma_styleattributes set_ccspecstylestyleclr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_ccspecstylestyleclr AFTER UPDATE OF ccspecstylestyle ON public.exp01_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_ccspecstylestyleclr();


--
-- TOC entry 8215 (class 2620 OID 81998386)
-- Name: exp01_ma_imgattributes set_held_img; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_held_img AFTER UPDATE OF hold_img ON public.exp01_ma_imgattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.trigger_set_held_img();


--
-- TOC entry 8191 (class 2620 OID 81998387)
-- Name: exp01_ma_stylecolorattributes set_is_publishable; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_is_publishable AFTER UPDATE OF ccspecstylestyleclr, ccplmcolor ON public.exp01_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_is_publishable();


--
-- TOC entry 8224 (class 2620 OID 81998388)
-- Name: exp01_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.exp01_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION public.trigger_set_indx_valid_values();


--
-- TOC entry 8216 (class 2620 OID 81998389)
-- Name: exp01_ma_sizeattributes set_size_id; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_size_id BEFORE INSERT ON public.exp01_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_size_id();


--
-- TOC entry 8192 (class 2620 OID 81998390)
-- Name: exp01_ma_stylecolorattributes set_timestamp; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON public.exp01_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8209 (class 2620 OID 81998391)
-- Name: exp01_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.exp01_a_assortment FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8218 (class 2620 OID 81998392)
-- Name: exp01_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.exp01_p_channeloverride FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8219 (class 2620 OID 81998393)
-- Name: exp01_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.exp01_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8221 (class 2620 OID 81998394)
-- Name: exp01_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.exp01_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8220 (class 2620 OID 81998395)
-- Name: exp01_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.exp01_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 8217 (class 2620 OID 81998396)
-- Name: exp01_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.exp01_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8184 (class 2620 OID 81998397)
-- Name: exp01_ma_styleattributes set_timestamp_style; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_style BEFORE UPDATE ON public.exp01_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8185 (class 2620 OID 81998398)
-- Name: exp01_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.exp01_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();

ALTER TABLE public.exp01_ma_styleattributes DISABLE TRIGGER set_timestamp_styleattr;


--
-- TOC entry 8199 (class 2620 OID 81998399)
-- Name: exp01_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 8186 (class 2620 OID 81998400)
-- Name: exp01_ma_styleattributes sync_stylecolor_subsizerange; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER sync_stylecolor_subsizerange AFTER UPDATE OF ccsizerange ON public.exp01_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.sync_ccsizerange_dependent_lookup();

ALTER TABLE public.exp01_ma_styleattributes DISABLE TRIGGER sync_stylecolor_subsizerange;


--
-- TOC entry 8210 (class 2620 OID 81998401)
-- Name: exp01_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF strmenscapacity, strwomenscapacity, strcorpvoltier, strclimate, grade, ssg ON public.exp01_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.propagate_assortment_to_floorsets();


--
-- TOC entry 8193 (class 2620 OID 81998402)
-- Name: exp01_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER UPDATE OF cccolor ON public.exp01_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_color_change();


--
-- TOC entry 8206 (class 2620 OID 81998403)
-- Name: cart_params triger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER triger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_triger_cartparams_ranging();


--
-- TOC entry 8211 (class 2620 OID 81998404)
-- Name: exp01_a_assortment trigger_assortment_blank_checks; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_assortment_blank_checks AFTER INSERT OR UPDATE ON public.exp01_a_assortment FOR EACH ROW EXECUTE FUNCTION public.assortment_blank_checks();


--
-- TOC entry 8222 (class 2620 OID 81998405)
-- Name: exp01_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.exp01_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.update_eff_aur();


--
-- TOC entry 8200 (class 2620 OID 81998406)
-- Name: exp01_ma_stylecolorchannelattributes trigger_for_time_indx_insert; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_insert AFTER INSERT ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 8201 (class 2620 OID 81998407)
-- Name: exp01_ma_stylecolorchannelattributes trigger_for_time_indx_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_update AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current)) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 8223 (class 2620 OID 81998408)
-- Name: exp01_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.exp01_p_itemprice FOR EACH ROW EXECUTE FUNCTION public.itemprice_fetchdepartment();


--
-- TOC entry 8202 (class 2620 OID 81998409)
-- Name: exp01_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.lifecycle_plan_update();


--
-- TOC entry 8203 (class 2620 OID 81998410)
-- Name: exp01_ma_stylecolorchannelattributes trigger_sizerangecode_isvalid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_isvalid AFTER UPDATE OF validsizes ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_isvalid();


--
-- TOC entry 8204 (class 2620 OID 81998411)
-- Name: exp01_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_validsizes_members();


--
-- TOC entry 8181 (class 2620 OID 81998412)
-- Name: exp01_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.exp01_d_product FOR EACH ROW WHEN ((new.levelid = 'style'::text)) EXECUTE FUNCTION public.update_name_description();


--
-- TOC entry 8187 (class 2620 OID 81998413)
-- Name: exp01_ma_styleattributes update_ccsizerange; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccsizerange AFTER UPDATE OF express_size_range ON public.exp01_ma_styleattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.create_hidden_ccsizerange_mod();


--
-- TOC entry 8182 (class 2620 OID 81998414)
-- Name: exp01_h_prodstd update_ccsizerange_after_class_change_ancestor1; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccsizerange_after_class_change_ancestor1 AFTER UPDATE OF ancestor1 ON public.exp01_h_prodstd FOR EACH ROW WHEN (((new.ancestor1 ~~ 'CL-%'::text) AND (new.ancestor1 IS DISTINCT FROM old.ancestor1))) EXECUTE FUNCTION public.create_hidden_class_ccsizerange_mod();


--
-- TOC entry 8205 (class 2620 OID 81998415)
-- Name: exp01_ma_stylecolorchannelattributes update_pricing_store_trig; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_pricing_store_trig AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.exp01_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current)) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.update_pricing_store_info();

ALTER TABLE public.exp01_ma_stylecolorchannelattributes DISABLE TRIGGER update_pricing_store_trig;


--
-- TOC entry 8188 (class 2620 OID 81998416)
-- Name: exp01_ma_styleattributes update_tktp_across; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_tktp_across AFTER UPDATE OF ccticketprice ON public.exp01_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_stylecolor_ticketprice();


--
-- TOC entry 8173 (class 2606 OID 81998417)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 8174 (class 2606 OID 81998422)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 8176 (class 2606 OID 81998427)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 8171 (class 2606 OID 81998432)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.agent_conversations(conversation_id);


--
-- TOC entry 8172 (class 2606 OID 81998437)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES public.allocation_plan_queue(jobid);


--
-- TOC entry 8179 (class 2606 OID 81998442)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 8180 (class 2606 OID 81998452)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 8175 (class 2606 OID 81998457)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 8178 (class 2606 OID 81998462)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 8177 (class 2606 OID 81998467)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.user_metadata(uid);


--
-- TOC entry 8385 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:07:00 IST

--
-- PostgreSQL database dump complete
--

\unrestrict rWBXdM2p9ueIbFiqnmzTcEUBxbRM2WYX4hcReGiySxQEtHshB3Dfd6pjLmT2O7Z

