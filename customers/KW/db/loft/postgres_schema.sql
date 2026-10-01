-- ENV: QA | DB: loft | dumped: 2026-10-01 15:06 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict GjUMwbqW8sum6M6IloyEs1cVP35h8HfFP7KwKnLhm78IeouuCc77ak3cNoFbkJ4

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:06:55 IST

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
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 1109 (class 2615 OID 67697728)
-- Name: target_setting; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA target_setting;


ALTER SCHEMA target_setting OWNER TO psql;

--
-- TOC entry 2 (class 3079 OID 4697137)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 8097 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 3035 (class 1247 OID 68983516)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 2692 (class 1247 OID 67697730)
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
-- TOC entry 2695 (class 1247 OID 67697742)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 2698 (class 1247 OID 67697748)
-- Name: approval; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE target_setting.approval OWNER TO psql;

--
-- TOC entry 2701 (class 1247 OID 67697754)
-- Name: permission; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE target_setting.permission OWNER TO psql;

--
-- TOC entry 2704 (class 1247 OID 67697762)
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
-- TOC entry 2016 (class 1255 OID 67697777)
-- Name: add_size_concepts_to_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.add_size_concepts_to_assortment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    s1 text;
    v_uuid_temp text;
    v_uuid text;
    table_tmp_size_concepts text;
    v_size_concepts_in_assortment text[];
BEGIN

    RAISE NOTICE 'Inside add_size_concepts_to_assortment';
    update loft_ma_stylecolorchannelattributes
    set record_state = 0
    where product in (    
        select product 
        from loft_stylecolor_hier_attr 
        where cc_missy_related_stylecolor = new.product
        and sty_size_type in (
                select unnest(cc_size_concepts_in_assortment) as size_concept
        from loft_ma_stylecolorattributes 
        where product = new.product)
    );

    -- Generate UUID and use it to create a temporary table name
    EXECUTE '(select uuid_generate_v4()::text)' INTO v_uuid_temp;
    EXECUTE '(select replace(''' || v_uuid_temp || ''', ''-'', ''_'')::text)' INTO v_uuid;

    table_tmp_size_concepts := 'tmp_size_concepts_' || v_uuid;

    -- Create the temporary table dynamically
    s1 := 'CREATE TEMPORARY TABLE ' || table_tmp_size_concepts || ' AS
           SELECT a.product as product, c.product as style, a.cc_missy_related_stylecolor
           FROM loft_stylecolor_hier_attr a
           JOIN loft_h_prodstd b ON a.product = b.id
           JOIN loft_ma_styleattributes c ON b.ancestor0 = c.product
           WHERE cc_missy_related_stylecolor = ''' || NEW.product || ''' 
           AND a.sty_size_type IN (
                SELECT unnest(cc_size_concepts_in_assortment) AS size_concept
           FROM loft_ma_stylecolorattributes 
           WHERE product = ''' || NEW.product || ''')
           ';
    
    -- Execute the dynamic query to create the temporary table
    EXECUTE s1;

    -- Debug: Show what the SQL query looks like
    RAISE NOTICE 'SQL to create table: %', s1;
    RAISE NOTICE 'new.product: %', NEW.product;

    -- Insert into loft_a_assortment using the temporary table
    EXECUTE 'INSERT INTO loft_a_assortment
    SELECT 
        tmp.product,
        "location",
        "time",
        tmp.style,
        str_climate,
        str_grade,
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
        record_state
    FROM ' || table_tmp_size_concepts || ' tmp
    JOIN loft_a_assortment b ON tmp.cc_missy_related_stylecolor=b.product 
    WHERE NOT EXISTS (
        SELECT 1
        FROM loft_a_assortment a
        WHERE a.product = tmp.product
    )';

    -- Debug: Show the SQL for insert
    RAISE NOTICE 'SQL for Insert: %', 'INSERT INTO loft_a_assortment ...';

    -- Add the newly added item to the plan_queue immediately
    INSERT INTO plan_queue (product, location, initiator, initiated_at, updated_at)
    SELECT DISTINCT
           a.product,
           a.location,
           NEW.updated_by AS initiator,
           NOW() AS initiated_at,
           NOW() AS updated_at
    FROM loft_ma_stylecolorchannelattributes a
    WHERE a.record_state = 0
      AND a.missy_related_stylecolor = NEW.product
      AND a.product != NEW.product;


    select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from loft_ma_stylecolorattributes a, loft_ma_stylecolorchannelattributes b, loft_h_prodstd c, loft_ma_styleattributes d, loft_d_product e 
                            where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
                            and cc_missy_related_stylecolor = NEW.product
                           ) x where product <> NEW.product and record_state = 0
                      ) into v_size_concepts_in_assortment;
    
    RAISE NOTICE 'v_size_concepts_in_assortment: %', v_size_concepts_in_assortment;

    update loft_ma_stylecolorattributes
    set cc_size_concepts_in_assortment = array_cc_size_concepts_in_assortment
    from (select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from loft_ma_stylecolorattributes a, loft_ma_stylecolorchannelattributes b, loft_h_prodstd c, loft_ma_styleattributes d, loft_d_product e 
                            where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
                            and cc_missy_related_stylecolor = NEW.product
                           ) x where product <> NEW.product and record_state = 0
                      ) as array_cc_size_concepts_in_assortment
          ) y
    where product = NEW.product
    ;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_size_concepts_to_assortment() OWNER TO psql;

--
-- TOC entry 2082 (class 1255 OID 67697778)
-- Name: add_to_assortment(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
DECLARE

s1 text;
s2 text;
s2_dprod text;
s2_1 text;
s3 text;
s3_1 text;
s3_2 text;
s4_1 text;
s4_0_1 text;
s4_0_2 text;
s4_2 text;
s4_2_0_0 text;
s4_2_0 text;
s4_2_1 text;
s4_2_2 text;
s4_2_3 text;
s4_2_4 text;
s4_2_5 text;
s4_3 text;
s4_4 text;
s4_5 text;
s5 text;
s5_1 text;
s5_1_1 text;
s5_2 text;
s5_3 text;
s6 text;
s7 text;
s7_01 text;
s7_1 text;
s7_1_1 text;
s7_1_2 text;
s7_2 text;
s8 text;
s9 text;
s9_1 text;
s10 text;
s11 text;
s11_1 text;
s12 text;
s13 text;
s13_1 text;
s14 text;
s15 text;
s15_1 text;
s15_2 text;
s16 text;
s17 text;
s17_1 text;
s17_2 text;
s18 text;
s19 text;
s19_1 text;
s20 text;
s21 text;
s21_1 text;
s22 text;
s23 text;
s24 text;
s25 text;
s26 text;
s26_1 text;
s26_2 text;
s26_3 text;
s26_4 text;
s26_5 text;
s26_6 text;
s26_7 text;
s26_X text;
s27 text;
s28 text;
s28_1 text;
s28_2 text;
s28_3 text;
s29 text;
s29_1 text;
s30 text;
s31 text;
s32 text;
s33 text;
s34 text;
s34_1 text;
s35 text;
s36 text;
s36_1 text;
s36_2 text;
s36_3 text;
s37 text;
s38 text;
s39 text;
s39_1 text;
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

sjrtest_1 text;
sjrtest_2 text;
sjrtest_step1 text;
sjrtest_step2 text;
sjrtest_step3 text;
sjrtest_step4 text;
sjrtest_ddl1 text;
sjrtest_ddl2 text;
sjrtest_ddl3 text;

BEGIN

--RETURN NULL;
-- ============================================================================
-- STEP 1: Generate a unique suffix (UUID) for temp tables for this session
-- ============================================================================
EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

-- ============================================================================
-- STEP 2: Define unique temp table names using the generated UUID
-- These tables will be created and used only within this session.
-- ============================================================================
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

-- ============================================================================
-- Additional temporary tables used in downstream logic
-- ============================================================================
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


-- ============================================================================
-- STEP 3: Create input_t1 table with session + scope inputs
-- This will be referenced throughout to filter the current session's data
-- ============================================================================
s1 := 'create temporary table '||table_input_t1||' as select '''||$1||''' as jsid,'''||$2||''' as scope_product,'''||$3||''' as scope_location ,'''||$4||''' as scope_start,'''||$5||''' as scope_floorset
    ';

-- delete from debug_stats_ts where stat_id='s1';


-- ============================================================================
-- STEP 4: Create cart_master_temp table
-- Pulls unprocessed rows from cart_master for this session and scope
-- Assigns nulls to final style/color IDs for processing later
-- ============================================================================
s2 := '
    create unlogged table '||table_cart_master_temp||' as
    select
    distinct
    cart_master.jsessionid
    ,  style_sequence
    ,  cart_master.style_id as incoming_style_id
    ,  cart_master.style_id as master_incoming_style_id
    ,  style_name
    ,  style_description
    ,  style_type
    ,  cccolor
    ,  stylecolor_id as incoming_stylecolor_id
    ,  stylecolor_id as master_incoming_stylecolor_id
    ,  stylecolor_type
    ,  stylecolor_name
    ,  stylecolor_description
    ,  null::text final_style_id
    ,  null::text final_stylecolor_id
    ,  null::text cccolorfamily
    ,  null::text cc_color_type
    ,  initiator
    ,  img
    ,  job_priority
    ,  null::text class_id
    ,  null::text subclass_id
    ,  null::text class_name
    ,  null::text subclass_name
    ,  sty_size_type::text sty_size_type
    ,  ''master''::text as sc_type
    from cart_master
    INNER JOIN (
            SELECT distinct sty_size_type, style_id
            FROM cart_params
            INNER JOIN cart_master ON cart_master.jsessionid = cart_params.jsessionid
            WHERE cart_master.style_type <> ''existing''
              AND cart_params.jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')

            UNION

            SELECT distinct sty_size_type, style_id
            FROM loft_ma_styleattributes
            INNER JOIN (
                SELECT style_type, style_id
                FROM cart_master
                WHERE jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')
                  AND style_type = ''existing''
            ) cart_master_type
            on style_id = product
    ) x
    on x.style_id = cart_master.style_id
    where
    cart_master.jsessionid in (select jsid from '||table_input_t1||')
    and isProcessed=0
    '
    ;

sjrtest_ddl1  := 'create table if not exists deleteme_table_cart_master_temp_jr as select *, ''''::text as step, clock_timestamp() as captured_at from ' || table_cart_master_temp || ' where 1=0';
sjrtest_step1 := 'insert into deleteme_table_cart_master_temp_jr select *, ''step1'', clock_timestamp() from ' || table_cart_master_temp;


-- ============================================================================
-- STEP 4B (SUP-3879): overwrite the frontend-supplied style name/description
-- with the authoritative values from loft_d_product, matched on style id.
-- ============================================================================
s2_dprod := '
    update '||table_cart_master_temp||' a
    set style_name        = d.name
      , style_description = d.description
    from loft_d_product d
    where 
    a.style_type=''existing''
    and
    a.stylecolor_type=''similar''
    and
    d.id = a.incoming_style_id
      and a.jsessionid in (select jsid from '||table_input_t1||')
    
    '
    ;


-- ============================================================================
-- STEP 5: Append cart_master rows with size concept mappings
-- Adds 'sc_type' for each related size type based on the size concept lookup
-- Used for processing alternate size types (e.g., Petite, Plus)
-- ============================================================================
-- ============================================================================
-- Modified on July 22nd 2025 by Robert Kebert to pull sty_size_type from cart params insteaad of loft_l_size_concept_lookups
-- ============================================================================
s2_1 := '
    insert into '||table_cart_master_temp||'
    select
    distinct
    jsessionid
    ,  style_sequence
    ,  cart_master.style_id as incoming_style_id
    ,  cart_master.style_id as master_incoming_style_id
    ,  case when style_type = ''existing'' and stylecolor_type=''similar'' then d_prod.name else cart_master.style_name end as style_name 
    ,  case when style_type = ''existing'' and stylecolor_type=''similar'' then d_prod.description else cart_master.style_description end as style_description 
    ,  style_type
    ,  cccolor
    ,  stylecolor_id as incoming_stylecolor_id
    ,  stylecolor_id as master_incoming_stylecolor_id
    ,  stylecolor_type
    ,  stylecolor_name
    ,  stylecolor_description
    ,  null::text final_style_id
    ,  null::text final_stylecolor_id
    ,  null::text cccolorfamily
    ,  null::text cc_color_type
    ,  initiator
    ,  img
    ,  job_priority
    ,  null::text class_id
    ,  null::text subclass_id
    ,  null::text class_name
    ,  null::text subclass_name
    ,  size_types::text as sty_size_type
    ,  size_types::text as sc_type
    from cart_master
    INNER JOIN (
        SELECT DISTINCT
            department,
            master_style_size_type,
            related_size_type AS size_types,
            styles_with_id.style_id
        FROM loft_l_size_concept_lookups
        INNER JOIN (
            SELECT distinct sty_size_type, style_id
            FROM cart_params
            INNER JOIN cart_master ON cart_master.jsessionid = cart_params.jsessionid
            WHERE cart_master.style_type <> ''existing''
              AND cart_params.jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')

            UNION

            SELECT distinct sty_size_type, style_id
            FROM loft_ma_styleattributes
            INNER JOIN (
                SELECT style_type, style_id
                FROM cart_master
                WHERE jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')
                  AND style_type = ''existing''
            ) cart_master_type
            on style_id = product
        ) styles_with_id
        on loft_l_size_concept_lookups.master_style_size_type = sty_size_type
        WHERE department IN (
            SELECT scope_product FROM ' || table_input_t1 || '
        )
    ) x
    on x.style_id = cart_master.style_id
    LEFT OUTER JOIN loft_d_product as d_prod on cart_master.style_id=d_prod.id 
    WHERE jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')
      AND isProcessed = 0
    '
    ;

sjrtest_step2 := 'insert into deleteme_table_cart_master_temp_jr select *, ''step2'', clock_timestamp() from ' || table_cart_master_temp;


-- ============================================================================
-- STEP 6: Create cart_style table for master size types
-- Generates final_style_id (UUID for 'similar' types, else incoming)
-- Preserves incoming/master relationship and type
-- ============================================================================
s3 := '
    create temporary table '||table_cart_style||' as
    select jsessionid
    , style_sequence
    , case when style_type = ''similar'' then uuid_generate_v4()::text else incoming_style_id end AS final_style_id
    , incoming_style_id
    , master_incoming_style_id
    , style_type
    , style_name  as displayed_style_name
    , style_description  as displayed_style_description
    , sc_type
    from
    (
    select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description, sc_type, master_incoming_style_id from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||')
      and sc_type = ''master''
    ) x
    ';


-- ============================================================================
-- STEP 7: Insert cart_style entries for alternate size types
-- Appends size type to name/description to differentiate variations
-- ============================================================================
s3_1 := '
    insert into '||table_cart_style||'
    select distinct x.jsessionid
    , x.style_sequence
    , NULL AS final_style_id
    , x.incoming_style_id
    , x.master_incoming_style_id
    , x.style_type
    , x.style_name || ''_'' || x.sc_type as displayed_style_name
    , x.style_description || ''_'' || x.sc_type as displayed_style_description
    , x.sc_type
    from
    (
    select distinct jsessionid, style_sequence, style_type, incoming_style_id, style_name, style_description, sc_type, master_incoming_style_id from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||')
      and sc_type != ''master''
    ) x
    ';


-- ============================================================================
-- STEP 8: Update final_style_id for alternate sizes
-- Appends size type to master style ID (for 'similar' styles)
-- ============================================================================
s3_2 := '
    update '||table_cart_style||' a
    set final_style_id = b.final_style_id || a.sc_type
    from (select style_sequence, final_style_id from '||table_cart_style||' where sc_type = ''master'') b
    where a.style_sequence = b.style_sequence
      and a.sc_type != ''master''
      and style_type = ''similar''
    ';


-- ============================================================================
-- STEP 9A: For 'existing' styles, update with mapped final style ID
-- Uses loft_ma_styleattributes and loft_d_product as the source
-- ============================================================================
-- ============================================================================
-- NOT Modified on July 22nd 2025 by Robert Kebert despite making chnages to sty_size_type, could lead to defect. 
-- ============================================================================
s4_0_1:= '
    update '||table_cart_style||' a
    set final_style_id = product
       ,displayed_style_name = c.name
       ,displayed_style_description = c.description
    from loft_ma_styleattributes b,
         loft_d_product c
    where b.sty_missy_related_style = a.master_incoming_style_id
     and b.sty_size_type = a.sc_type
      and b.product = c.id
      and style_type = ''existing''
'
;


-- ============================================================================
-- STEP 9B: For unmatched 'existing' alternate styles, generate new final ID
-- ============================================================================
s4_0_2:= '
    update '||table_cart_style||' a
    set final_style_id = uuid_generate_v4()::text
       ,displayed_style_name = master_incoming_style_id || '' '' || sc_type
       ,displayed_style_description =  REPLACE(displayed_style_description,''MISSY'',UPPER(sc_type))
    where sc_type != ''master''
      --and final_style_id = master_incoming_style_id
      and style_type = ''existing''
      and final_style_id is null
'
;



-- ============================================================================
-- STEP 10: Sync final style ID, name, description back to cart_master_temp
-- ============================================================================
s4_1 := '
    Update '||table_cart_master_temp||' a
    set final_style_id = b.final_style_id
       ,style_name = displayed_style_name
       ,style_description = displayed_style_description
    from '||table_cart_style||' b
    where
    a.incoming_style_id=b.incoming_style_id
    and a.style_type=b.style_type
    and a.sc_type=b.sc_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    ';




-- ============================================================================
-- STEP 11: Populate sty_size_type for master styles
-- ============================================================================
-- ============================================================================
-- Modified on July 22nd 2025 by Robert Kebert to update Style_Size_Type from cart_params
-- ============================================================================

s4_2 := '
    Update '||table_cart_master_temp||' a
    set sty_size_type = p.sty_size_type
    from cart_params p, '||table_input_t1||' b
    where
    a.jsessionid = b.jsid
    and p.jsessionid = b.jsid
    and a.incoming_style_id = p.product
    and a.sc_type = ''master''
    ';



s4_2_0_0 := '
    Update '||table_cart_master_temp||' a
    set class_id = b.ancestor1,
        subclass_id = b.ancestor0
    from loft_h_prodstd b
    where
    b.id = a.incoming_style_id
    and a.sc_type = ''master''
    ';



s4_2_0 := '
    Update '||table_cart_master_temp||' a
    set class_id = c.class,
        subclass_id = c.subclass
    from cart_params p, '||table_input_t1||' b, (select id as style, ancestor0 as subclass, ancestor1 as class from loft_h_prodstd where id in (select id from loft_d_product where levelid = ''style'')) c
    where
    p.jsessionid = b.jsid
    and c.style = a.final_style_id
    and p.scope_product = b.scope_product
    and p.scope_location = b.scope_location
    and p.scope_start = b.scope_start
    and a.style_type = ''existing''
    --and a.stylecolor_type = ''similar''
    and a.sc_type = ''master''
    ';

-- ============================================================================
-- NOT Modified on July 22nd 2025 by Robert Kebert despite making chnages to sty_size_type, could lead to defect. 
-- ============================================================================

s4_2_1 := '
    Update '||table_cart_master_temp||' a
    set class_id = c.related_size_class,
        subclass_id = c.related_size_subclass
    from (select * from '||table_cart_master_temp||' where sc_type = ''master'') b
    ,(select distinct master_style_size_type, related_size_type, master_style_subclass, related_size_subclass, master_style_class, related_size_class from loft_l_size_concept_lookups where related_size_subclass is not null ) c
    where replace(a.final_style_id,a.sc_type,'''')=b.final_style_id
      and b.subclass_id = c.master_style_subclass
      and b.class_id = c.master_style_class
      and b.sty_size_type = c.master_style_size_type
      and a.sc_type = c.related_size_type
      and a.sc_type != ''master''
    ';

s4_2_4 := '
    Update '||table_cart_master_temp||' a
    set class_id = c.class,
        subclass_id = c.subclass
    from cart_params p, '||table_input_t1||' b, (select id as style, ancestor0 as subclass, ancestor1 as class from loft_h_prodstd where id in (select id from loft_d_product where levelid = ''style'')) c
    where
    p.jsessionid = b.jsid
    and c.style = a.final_style_id
    and p.scope_product = b.scope_product
    and p.scope_location = b.scope_location
    and p.scope_start = b.scope_start
    and a.style_type = ''existing''
    --and a.stylecolor_type = ''similar''
    and a.sc_type != ''master''
    ';

-- ============================================================================
-- NOT Modified on July 22nd 2025 by Robert Kebert despite making chnages to sty_size_type, could lead to defect. 
-- ============================================================================

s4_2_5 := '
    Update '||table_cart_master_temp||' a
    set class_id = related_size_class,
        subclass_id = related_size_subclass
    from (select distinct master_style_class, master_style_subclass, master_style_size_type, related_size_type, related_size_class, related_size_subclass from loft_l_size_concept_lookups x, '||table_cart_master_temp||' y where x.master_style_class = y.class_id and x.master_style_subclass = y.subclass_id and y.sc_type = ''master'' and master_style_size_type = sty_size_type) c
    where a.style_type = ''existing''
    and a.class_id is null
    and a.sc_type != ''master''
    and sty_size_type = related_size_type
    ';

sjrtest_ddl2  := 'create table if not exists deleteme_table_cart_style_jr as select *, clock_timestamp() as captured_at from ' || table_cart_style || ' where 1=0';
sjrtest_1     := 'insert into deleteme_table_cart_style_jr select *, clock_timestamp() from ' || table_cart_style;
sjrtest_step3 := 'insert into deleteme_table_cart_master_temp_jr select *, ''step3'', clock_timestamp() from ' || table_cart_master_temp;

s4_2_2 := '
    delete from '||table_cart_master_temp||' where class_id is null
    ';



s4_2_3 := '
    delete from '||table_cart_style||' where final_style_id not in (select final_style_id from '||table_cart_master_temp||')
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from loft_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from loft_d_product b
    where
    b.id = a.subclass_id
    ';



s4_5 := '
    delete from '||table_cart_master_temp||'
    where class_name is null and sc_type != ''master''
    ';




-- ============================================================================
-- STEP 12: Create cart_stylecolor for master size types
-- Assigns final_stylecolor_id (UUID if 'similar')
-- Builds name/description based on type
-- ============================================================================
s5 := '
    create temporary table '||table_cart_stylecolor||' as
    select jsessionid
    , style_sequence
    , case when stylecolor_type = ''similar'' then uuid_generate_v4()::text else incoming_stylecolor_id end AS final_stylecolor_id
    , incoming_stylecolor_id
    , master_incoming_stylecolor_id
    , stylecolor_type
    , case when stylecolor_type = ''similar'' then style_name||'':''||cccolor else stylecolor_name end as displayed_stylecolor_name
    , case when stylecolor_type = ''similar'' then style_description ||'':''||cccolor else stylecolor_description end as displayed_stylecolor_description
    , incoming_style_id
    , style_type
    , cccolor
    , sc_type
    , final_style_id
    , style_name
    , style_description
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor,
    case when strpos(cccolor, '' '') > 0 then (SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1)) else cccolor end
    as color_id
    , style_name, style_description, stylecolor_name, stylecolor_description, master_incoming_stylecolor_id, sc_type
    from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||') and sc_type = ''master''
    ) x
    '
    ;




-- ============================================================================
-- STEP 13: Insert stylecolors for alternate size types
-- Follows similar logic, adding variations for size type
-- ============================================================================
s5_1 := '
    insert into '||table_cart_stylecolor||'
    select x.jsessionid
    , x.style_sequence
    , NULL AS final_stylecolor_id
    , x.incoming_stylecolor_id
    , x.master_incoming_stylecolor_id
    , x.stylecolor_type
    , case when x.stylecolor_type = ''similar'' then x.style_name || '':''||x.cccolor else x.stylecolor_name end as displayed_stylecolor_name
    , case when x.stylecolor_type = ''similar'' then x.style_description ||'':''||x.cccolor else x.stylecolor_description end as displayed_stylecolor_description
    , x.incoming_style_id
    , x.style_type
    , x.cccolor
    , x.sc_type
    , x.final_style_id
    , x.style_name
    , x.style_description
    from
    (
    select distinct jsessionid,style_sequence, incoming_style_id,final_style_id, style_type,incoming_stylecolor_id, stylecolor_type, cccolor,
    case when strpos(cccolor, '' '') > 0 then (SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1)) else cccolor end
    as color_id
    , style_name, style_description, stylecolor_name, stylecolor_description, master_incoming_stylecolor_id, sc_type
    from '||table_cart_master_temp||'
    where jsessionid in (select jsid from '||table_input_t1||') and sc_type != ''master''
    ) x
    '
;


-- ============================================================================
-- STEP 14: Set final_stylecolor_id for alternate 'similar' types
-- Joins back to master to generate derived ID
-- ============================================================================
s5_1_1:= '
    update '||table_cart_stylecolor||' a
    set final_stylecolor_id = b.final_stylecolor_id || a.sc_type
    from (select style_sequence,sc_type,cccolor,final_stylecolor_id from '||table_cart_stylecolor||' where sc_type = ''master'') b
    where a.stylecolor_type = ''similar''
    and a.final_stylecolor_id is null
    and a.style_sequence = b.style_sequence and a.cccolor = b.cccolor
    '
    ;


-- ============================================================================
-- STEP 15: For 'existing' stylecolors, map from related attributes
-- ============================================================================
-- ============================================================================
-- NOT Modified on July 22nd 2025 by Robert Kebert despite making chnages to sty_size_type, could lead to defect. 
-- ============================================================================

s5_2 := '
    update '||table_cart_stylecolor||' a
    set final_stylecolor_id = sc.product
       ,displayed_stylecolor_name = sc.product
       ,displayed_stylecolor_description = sc.cc_stylecolor_description
    from loft_ma_stylecolorattributes sc, loft_h_prodstd h, loft_ma_styleattributes s
    where sc.product = h.id
      and h.ancestor0 = s.product
      and sc.cc_missy_related_stylecolor = a.master_incoming_stylecolor_id
      and s.sty_size_type = a.sc_type
      and stylecolor_type = ''existing''
      and sc_type != ''master''
'
;


-- ============================================================================
-- STEP 16: For unmatched existing alternates, generate UUID-based IDs
-- ============================================================================
s5_3 := '
update '||table_cart_stylecolor||' a
    set final_stylecolor_id = uuid_generate_v4()::text
       ,displayed_stylecolor_name = style_name || ''-'' || substr(cccolor, 1, position('' '' in cccolor) - 1)
       ,displayed_stylecolor_description = style_description || '':'' || cccolor
    where sc_type != ''master''
      and final_stylecolor_id is null
      and stylecolor_type = ''existing''
'
;



-- ============================================================================
-- STEP 17: Update cart_master_temp with final stylecolor data
-- ============================================================================
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
    and a.sc_type=b.sc_type
    and a.jsessionid=b.jsessionid
    and a.style_sequence=b.style_sequence
    and a.jsessionid in (select jsid from '||table_input_t1||')
    '
    ;

sjrtest_ddl3  := 'create table if not exists deleteme_table_cart_stylecolor_jr as select *, clock_timestamp() as captured_at from ' || table_cart_stylecolor || ' where 1=0';
sjrtest_2     := 'insert into deleteme_table_cart_stylecolor_jr select *, clock_timestamp() from ' || table_cart_stylecolor;
sjrtest_step4 := 'insert into deleteme_table_cart_master_temp_jr select *, ''step4'', clock_timestamp() from ' || table_cart_master_temp;


-- ============================================================================
-- STEP 18: Create cart_stylecolorsize table for master size types
-- Assign final IDs (UUID for 'similar')
-- ============================================================================
s7 := '
    CREATE temporary TABLE '||table_cart_stylecolorsize||' AS
    SELECT
           uuid_generate_v4()::text AS final_stylecolorsize_id
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
                 , b.target_value as sizeattribute
                 , a.jsessionid
                 , a.style_type
                 , a.stylecolor_type
                 , a.final_style_id
                 , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                , loft_ma_styleattributes s
                , loft_l_dependencylookup b
          WHERE  a.master_incoming_style_id = s.product
             and LEFT(s.sty_size_range,3) = LEFT(b.lookup_value,3)
             and a.sc_type = ''master''
             and stylecolor_type=''similar''
             and lookup_id=''size_range''
          )x
          '
          ;

s7_01 := '
    insert into '||table_cart_stylecolorsize||'
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
                 , loft_ma_sizeattributes b
          WHERE  a.incoming_stylecolor_id = b.parent_id
             and a.sc_type = ''master''
             and stylecolor_type=''existing''
          )x
          '
          ;




-- ============================================================================
-- STEP 19: Insert stylecolorsizes for alternate size types (similar)
-- Based on size concept lookups and mapping to related subclasses
-- ============================================================================
s7_1 := '
    insert into '||table_cart_stylecolorsize||'
    SELECT DISTINCT
           null as final_stylecolorsize_id
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
                 , b.target_value as sizeattribute
                 , a.jsessionid
                 , a.style_type
                 , a.stylecolor_type
                 , a.final_style_id
                 , a.final_stylecolor_id
          FROM   '||table_cart_master_temp||' a
                , loft_ma_styleattributes s
                , loft_l_dependencylookup b
                , loft_l_size_concept_lookups l
          WHERE  a.master_incoming_style_id = s.product
             and LEFT(s.sty_size_range,3) = LEFT(l.master_style_size_range_id,3)
             and l.related_size_subclass = a.subclass_id
             and LEFT(l.related_size_size_range_id,3) = LEFT(b.lookup_value,3)
             and a.sc_type != ''master''
             and stylecolor_type=''similar''
             and lookup_id=''size_range''
          )x
          '
          ;


-- ============================================================================
-- STEP 20: Add existing stylecolorsizes from loft_ma_sizeattributes
-- ============================================================================
s7_1_1:= '
insert into '||table_cart_stylecolorsize||'
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
            , loft_ma_sizeattributes b
    WHERE  a.final_stylecolor_id = b.parent_id
    and a.sc_type != ''master''
    and a.style_type = ''existing''
    )x
';


-- ============================================================================
-- STEP 21: Add remaining existing sizes that were missed above
-- Ensures all relevant alternate sizes are included
-- ============================================================================
s7_1_2:= '
    insert into '||table_cart_stylecolorsize||'
    SELECT DISTINCT
    null as final_stylecolorsize_id
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
        , a.jsessionid
        , a.style_type
        , a.stylecolor_type
        , a.final_style_id
        , a.final_stylecolor_id
    FROM   '||table_cart_master_temp||' a
        , loft_ma_styleattributes s
        , loft_ma_sizeattributes b
        , loft_l_size_concept_lookups l
    WHERE  a.master_incoming_style_id = s.product
    and LEFT(s.sty_size_range,3) = LEFT(l.master_style_size_range_id,3)
    and l.related_size_subclass = a.subclass_id
    and LEFT(l.related_size_size_range_id,3) = LEFT(b.size_range,3)
    and a.sc_type != ''master''
    and stylecolor_type=''existing''
    and final_stylecolor_id not in (select final_stylecolor_id from '||table_cart_stylecolorsize||' )
    )x
'
;


-- ============================================================================
-- STEP 22: Assign UUIDs to any remaining null final_stylecolorsize_id
-- ============================================================================
s7_2 := '
    update '||table_cart_stylecolorsize||'
    set final_stylecolorsize_id = uuid_generate_v4()::text
    where final_stylecolorsize_id is null;
    '
    ;




-- ============================================================================
-- STEP 23: Clean up old similar style entries from loft_d_product
-- ============================================================================
s8 := 'delete from loft_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';



-- ============================================================================
-- STEP 24: Insert new similar styles into loft_d_product
-- ============================================================================
s9 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_style_id AS id
       , COALESCE(displayed_style_name, ''S5-'' || nextval(''style_sequence'') || ''-'' || displayed_style_name) AS NAME
       , COALESCE(displayed_style_description, ''S5-'' || nextval(''style_sequence'') ||''-'' || displayed_style_description) AS description
       , ''style'' AS levelid
    FROM   '||table_cart_style||'
    WHERE style_type=''similar''
    ';



-- ============================================================================
-- STEP 25: Insert existing styles not already in loft_d_product
-- ============================================================================
s9_1 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_style_id AS id
       , COALESCE(displayed_style_name, ''S5-'' || nextval(''style_sequence'') || ''-'' || displayed_style_name) AS NAME
       , COALESCE(displayed_style_description, ''S5-'' || nextval(''style_sequence'') ||''-'' || displayed_style_description) AS description
       , ''style'' AS levelid
    FROM   '||table_cart_style||'
    WHERE style_type=''existing''
      and final_style_id not in (select id from loft_d_product where levelid = ''style'')
    ';





-- ============================================================================
-- STEP 26: Clean up old similar stylecolor entries from loft_d_product
-- ============================================================================
s10 := '
delete from loft_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



-- ============================================================================
-- STEP 27: Insert new similar stylecolors into loft_d_product
-- ============================================================================
s11 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_stylecolor_id              AS id
           , displayed_stylecolor_name        AS NAME
           , displayed_stylecolor_description AS description
           , ''stylecolor''             AS levelid
    FROM '||table_cart_stylecolor||'
    WHERE stylecolor_type=''similar''
    '
    ;



-- ============================================================================
-- STEP 28: Insert existing stylecolors if missing from loft_d_product
-- ============================================================================
s11_1 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_stylecolor_id              AS id
           , displayed_stylecolor_name        AS NAME
           , displayed_stylecolor_description AS description
           , ''stylecolor''             AS levelid
    FROM '||table_cart_stylecolor||'
    WHERE stylecolor_type=''existing''
      and final_stylecolor_id not in (select id from loft_d_product where levelid = ''stylecolor'')
    '
    ;





-- ============================================================================
-- STEP 29: Insert new similar stylecolorsizes into loft_d_product
-- ============================================================================
s13 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_stylecolorsize_id            AS id
           , size_name        AS NAME
           , size_description AS description
           , ''stylecolorsize'' AS levelid
    FROM   '||table_cart_stylecolorsize||'
    WHERE stylecolor_type=''similar''
    '
    ;



-- ============================================================================
-- STEP 30: Insert existing stylecolorsizes if not already in loft_d_product
-- ============================================================================
s13_1 := '
    INSERT INTO loft_d_product
            (id
             , NAME
             , description
             , levelid)
    SELECT distinct final_stylecolorsize_id            AS id
           , size_name        AS NAME
           , size_description AS description
           , ''stylecolorsize'' AS levelid
    FROM   '||table_cart_stylecolorsize||'
    WHERE stylecolor_type=''existing''
      and final_stylecolorsize_id not in (select id from loft_d_product where levelid = ''stylecolorsize'')
    '
    ;



-- CREATING HIERARCHY


-- ============================================================================
-- STEP 31: Delete existing similar style entries from product hierarchy
-- ============================================================================
s14 := '
delete from loft_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



-- ============================================================================
-- STEP 32: Insert master size type similar styles into loft_h_prodstd
-- Copies full hierarchy from source style
-- ============================================================================
s15 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||' a,
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 from loft_h_prodstd) b
WHERE style_type=''similar''
and a.incoming_style_id = b.id
and a.sc_type = ''master''
'
;


-- ============================================================================
-- STEP 33: Insert alternate size type similar styles into hierarchy
-- Using class-level match to infer ancestor chain
-- ============================================================================
s15_1 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||' a,
(select distinct ancestor1, ancestor2, ancestor3, ancestor4, ancestor5 from loft_h_prodstd) b
WHERE style_type=''similar''
and a.class_id = b.ancestor1
and a.sc_type != ''master''
'
;


-- ============================================================================
-- STEP 34: Insert 'existing' alternate styles if missing from hierarchy
-- ============================================================================
s15_2 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor2
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||' a,
(select distinct ancestor1, ancestor2, ancestor3, ancestor4, ancestor5 from loft_h_prodstd) b
WHERE style_type=''existing''
and a.class_id = b.ancestor1
and a.sc_type != ''master''
and final_style_id not in (select id from loft_h_prodstd)
'
;

s16 := '
delete from loft_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_stylecolor_id
                , final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||'   a,
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 from loft_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
and a.sc_type = ''master''
'
;

s17_1 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_stylecolor_id
                , final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||'   a,
(select distinct ancestor2, ancestor3, ancestor4 , ancestor5 from loft_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.class_id = b.ancestor2
and a.sc_type != ''master''
'
;

s17_2 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_stylecolor_id
                , final_style_id
                , a.subclass_id
                , a.class_id
                , ancestor3
                , ancestor4
                , ancestor5
FROM   '||table_cart_master_temp||'   a,
(select distinct ancestor2, ancestor3, ancestor4 , ancestor5 from loft_h_prodstd) b
WHERE stylecolor_type=''existing''
and a.class_id = b.ancestor2
and a.sc_type != ''master''
and final_stylecolor_id not in (select id from loft_h_prodstd)
'
;



s18 := '
delete from loft_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_stylecolorsize_id
                , final_stylecolor_id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
FROM    '||table_cart_stylecolorsize||'  a,
loft_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s19_1 := '
INSERT INTO loft_h_prodstd
            (id
             , ancestor0
             , ancestor1
             , ancestor2
             , ancestor3
             , ancestor4
             , ancestor5)
SELECT DISTINCT
                  final_stylecolorsize_id
                , final_stylecolor_id
                , ancestor0
                , ancestor1
                , ancestor2
                , ancestor3
                , ancestor4
FROM    '||table_cart_stylecolorsize||'  a,
loft_h_prodstd b
WHERE stylecolor_type=''existing''
and a.final_stylecolor_id = b.id
and a.final_stylecolorsize_id not in (select id from loft_h_prodstd)
'
;


-- ============================================================================
-- STEP 35: Clean up old style attribute records for similar styles
-- ============================================================================
s20 := '
delete from loft_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily


-- ============================================================================
-- STEP 36: Update color family from dependency lookup
-- ============================================================================
s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from loft_l_dependencylookup b where b.lookup_id = ''colorname'' and b.target_id=''colorfamily'' and lookup_value=a.cccolor
';


-- ============================================================================
-- STEP 37: Update color type from dependency lookup
-- ============================================================================
s21_1 := '
update '||table_cart_master_temp||' a set cc_color_type = b.target_value from loft_l_dependencylookup b where b.lookup_id = ''colorname'' and b.target_id=''colortype'' and lookup_value=a.cccolor
';


-- ============================================================================
-- STEP 38: Delete old 'patternedtostyle' dependency mappings
-- ============================================================================
s22 := '
delete from loft_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


-- ============================================================================
-- STEP 39: Delete old 'patternedtostylecolor' dependency mappings
-- ============================================================================
s23 := '
delete from loft_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';







-- ============================================================================
-- STEP 40: Insert new 'patternedtostyle' mappings
-- ============================================================================
s24 := '
insert into loft_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- ============================================================================
-- STEP 41: Insert new 'patternedtostylecolor' mappings
-- ============================================================================
s25 := '
insert into loft_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- STYLE ATTRIBUTES


-- ============================================================================
-- STEP 42: Insert style attributes for master size types
-- ============================================================================
S26 := '
INSERT INTO loft_ma_styleattributes
            (product
            ,sty_end_use
            ,sty_pyramid_lens
            ,sty_silhouette
            ,sty_missy_petite_nonapparel
            ,sty_size_type
            ,sty_size_range
            ,sty_missy_related_style
            )
SELECT final_style_id as product
            ,b.sty_end_use
            ,b.sty_pyramid_lens
            ,b.sty_silhouette
            ,b.sty_missy_petite_nonapparel
            ,a.sty_size_type
            ,b.sty_size_range
            ,final_style_id as sty_missy_related_style
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type, sty_size_type from '||table_cart_master_temp||') a, loft_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
and a.sc_type=''master''
';




-- ============================================================================
-- STEP 43: Insert style attributes for alternate similar size types
-- ============================================================================
S26_1 := '
INSERT INTO loft_ma_styleattributes
            (product
            ,sty_end_use
            ,sty_pyramid_lens
            ,sty_silhouette
            ,sty_third_party
            ,sty_sleeve_length
            ,sty_type
            ,sty_neckline
            ,sty_merch_group
            ,sty_fabric_profile
            ,sty_fit
            ,sty_hemline_detail
            ,sty_material
            ,sty_mfp_program_id
            ,sty_shape
            ,sty_program_id
            ,sty_length
            ,sty_placement
            ,sty_texture
            ,sty_gauge
            ,sty_accessory_measurements
            ,sty_finish
            ,sty_adhoc
            ,sty_retail_ticket_type
            ,sty_size_type
            ,sty_size_range
            ,sty_missy_related_style
            )
SELECT final_style_id as product
            ,b.sty_end_use
            ,b.sty_pyramid_lens
            ,b.sty_silhouette
            ,b.sty_third_party
            ,b.sty_sleeve_length
            ,b.sty_type
            ,b.sty_neckline
            ,b.sty_merch_group
            ,b.sty_fabric_profile
            ,b.sty_fit
            ,b.sty_hemline_detail
            ,b.sty_material
            ,b.sty_mfp_program_id
            ,b.sty_shape
            ,b.sty_program_id
            ,b.sty_length
            ,b.sty_placement
            ,b.sty_texture
            ,b.sty_gauge
            ,b.sty_accessory_measurements
            ,b.sty_finish
            ,b.sty_adhoc
            ,b.sty_retail_ticket_type
            ,a.sc_type as sty_size_type
            ,l.related_size_size_range_id as sty_size_range
            ,REPLACE(final_style_id,sc_type,'''') as sty_missy_related_style
from (select distinct final_style_id, style_type, incoming_style_id, master_incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type from '||table_cart_master_temp||') a, loft_ma_styleattributes b, loft_l_size_concept_lookups l
where REPLACE(final_style_id,sc_type,'''')=b.product
and a.style_type=''similar''
and a.sc_type!=''master''
and UPPER(b.sty_size_range) = UPPER(l.master_style_size_range_id)
and l.related_size_subclass = a.subclass_id
and l.related_size_type = a.sc_type
';



-- ============================================================================
-- STEP 44: Insert attributes for alternate existing size types
-- ============================================================================
S26_2 := '
INSERT INTO loft_ma_styleattributes
            (product
            ,sty_end_use
            ,sty_pyramid_lens
            ,sty_silhouette
            ,sty_third_party
            ,sty_sleeve_length
            ,sty_type
            ,sty_neckline
            ,sty_merch_group
            ,sty_fabric_profile
            ,sty_fit
            ,sty_hemline_detail
            ,sty_material
            ,sty_mfp_program_id
            ,sty_shape
            ,sty_program_id
            ,sty_length
            ,sty_placement
            ,sty_texture
            ,sty_gauge
            ,sty_accessory_measurements
            ,sty_finish
            ,sty_adhoc
            ,sty_retail_ticket_type
            ,sty_size_type
            ,sty_size_range
            ,sty_missy_related_style
            )
SELECT final_style_id as product
            ,b.sty_end_use
            ,b.sty_pyramid_lens
            ,b.sty_silhouette
            ,b.sty_third_party
            ,b.sty_sleeve_length
            ,b.sty_type
            ,b.sty_neckline
            ,b.sty_merch_group
            ,b.sty_fabric_profile
            ,b.sty_fit
            ,b.sty_hemline_detail
            ,b.sty_material
            ,b.sty_mfp_program_id
            ,b.sty_shape
            ,b.sty_program_id
            ,b.sty_length
            ,b.sty_placement
            ,b.sty_texture
            ,b.sty_gauge
            ,b.sty_accessory_measurements
            ,b.sty_finish
            ,b.sty_adhoc
            ,b.sty_retail_ticket_type
            ,a.sc_type as sty_size_type
            ,l.related_size_size_range_id as sty_size_range
            ,master_incoming_style_id as sty_missy_related_style
from (select distinct final_style_id, style_type, incoming_style_id, master_incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type from '||table_cart_master_temp||') a, loft_ma_styleattributes b, loft_l_size_concept_lookups l
where incoming_style_id=b.product
and a.style_type=''existing''
and final_style_id not in (select product from loft_ma_styleattributes)
and a.sc_type!=''master''
and UPPER(b.sty_size_range) = UPPER(l.master_style_size_range_id)
and l.related_size_subclass = a.subclass_id
and a.sc_type = l.related_size_type
';


-- ============================================================================
-- STEP 45: Aggregate alternate size types into size concept arrays
-- ============================================================================
s26_3 := '
update loft_ma_styleattributes a
set sty_size_concepts = size_concepts
from (select sty_missy_related_style, array_agg(product) as size_concepts from loft_ma_styleattributes where sty_missy_related_style != product and sty_missy_related_style in (select final_style_id from '||table_cart_master_temp||' where sc_type = ''master'') group by sty_missy_related_style) b
where a.product = b.sty_missy_related_style
';


-- ============================================================================
-- STEP 46: Update merch group from dependency lookup
-- ============================================================================
s26_4 := '
update loft_ma_styleattributes
set sty_merch_group = a.sty_merch_group
from (select target_value as sty_merch_group, lookup_value as class from loft_l_dependencylookup where target_id = ''MerchDeptGroup'' and lookup_id = ''class'') a
    ,(select distinct final_style_id, class_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.class_id = a.class
';


-- ============================================================================
-- STEP 47: Update retail ticket type based on subclass mapping
-- ============================================================================
s26_5 := '
update loft_ma_styleattributes
set sty_retail_ticket_type = a.sty_retail_ticket_type
from (select target_value as sty_retail_ticket_type, lookup_value as subclass from loft_l_dependencylookup where target_id = ''retail_ticket_type'' and lookup_id = ''subclass'' and (lookup_value,index) in (select lookup_value as subclass, max(index) as index from loft_l_dependencylookup where target_id = ''retail_ticket_type'' group by lookup_value)) a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.subclass_id = a.subclass
';


-- ============================================================================
-- STEP 48: Update style name and description composite field
-- ============================================================================
s26_6 := '
update loft_ma_styleattributes
set sty_stylenumber_name = a.name || '', '' || a.description
from loft_d_product a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = a.id and a.id = b.final_style_id
';

--SUP-1882 Main Label Default Attribute
s26_7 := '
update loft_ma_styleattributes
set sty_main_label = a.sty_main_label
from (select target_value as sty_main_label, lookup_value as subclass from loft_l_dependencylookup where target_id = ''main_label_default'' and lookup_id = ''subclass'' and (lookup_value,index) in (select lookup_value as subclass, max(index) as index from loft_l_dependencylookup where target_id = ''main_label_default'' group by lookup_value)) a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.subclass_id = a.subclass
';

-- STYLECOLOR ATTRIBUTES


-- ============================================================================
-- STEP 49: Clean up old stylecolor attributes
-- ============================================================================
s27 := '
delete from loft_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';




-- ============================================================================
-- STEP 50: Insert stylecolor attributes for master similar styles
-- ============================================================================
s28 := '
INSERT INTO loft_ma_stylecolorattributes
        (product
         ,cccolor
         ,cc_color_name
         ,cccolorfamily
         ,cc_color_type
         ,cc_price_band
         ,cc_good_better_best
         ,cc_ppns
         ,department_name
         ,class_name
         ,subclass_name
         ,cc_missy_related_stylecolor
        )
SELECT final_stylecolor_id as product
         ,a.cccolor
         ,a.cccolor as cc_color_name
         ,a.cccolorfamily
         ,a.cc_color_type as cc_color_type
         ,b.cc_price_band
         ,b.cc_good_better_best
         ,b.cc_ppns
         ,b.department_name
         ,b.class_name
         ,b.subclass_name
         ,final_stylecolor_id as cc_missy_related_stylecolor
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type  from '||table_cart_master_temp||') a, loft_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
and a.sc_type=''master''
';





-- ============================================================================
-- STEP 51: Insert extended stylecolor attributes for alternate similar types
-- ============================================================================
s28_1 := '
INSERT INTO loft_ma_stylecolorattributes
        (product
         ,cc_fabric_description
         ,cccolor
         ,cc_color_name
         ,cccolorfamily
         ,cc_color_type
         ,cc_ppns
         ,cc_print_pattern_type
         ,cc_novelty_details
         ,cc_print_description
         ,cc_matchbacks
         ,cc_free_one
         ,cc_free_two
         ,cc_free_three
         ,cc_known
         ,cc_collection
         ,cc_preview
         ,cc_marketing_flag
         ,cc_promotion_flag
         ,cc_table
         ,cc_internet_tall_style
         ,cc_price_band
         ,cc_good_better_best
         ,cc_lifecycle
         ,cc_primary_selling
         ,cc_climate_product
         ,cc_online_exclusive_flag
         ,department_name
         ,class_name
         ,subclass_name
         ,cc_missy_related_stylecolor
        )
SELECT final_stylecolor_id as product
         ,b.cc_fabric_description
         ,a.cccolor
         ,a.cccolor as cc_color_name
         ,a.cccolorfamily
         ,a.cc_color_type as cc_color_type
         ,b.cc_ppns
         ,b.cc_print_pattern_type
         ,b.cc_novelty_details
         ,b.cc_print_description
         ,b.cc_matchbacks
         ,b.cc_free_one
         ,b.cc_free_two
         ,b.cc_free_three
         ,b.cc_known
         ,b.cc_collection
         ,b.cc_preview
         ,b.cc_marketing_flag
         ,b.cc_promotion_flag
         ,b.cc_table
         ,b.cc_internet_tall_style
         ,b.cc_price_band
         ,b.cc_good_better_best
         ,b.cc_lifecycle
         ,b.cc_primary_selling
         ,b.cc_climate_product
         ,b.cc_online_exclusive_flag
         ,b.department_name
         ,a.class_name
         ,a.subclass_name
         ,REPLACE(final_stylecolor_id,sc_type,'''') as cc_missy_related_stylecolor
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, master_incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type, subclass_name, class_name  from '||table_cart_master_temp||') a, loft_ma_stylecolorattributes b
where REPLACE(final_stylecolor_id,sc_type,'''') = b.product
and a.stylecolor_type=''similar''
and a.sc_type!=''master''
';





-- ============================================================================
-- STEP 52: Insert attributes for alternate existing stylecolors
-- ============================================================================
s28_2 := '
INSERT INTO loft_ma_stylecolorattributes
        (product
         ,cc_fabric_description
         ,cccolor
         ,cc_color_name
         ,cccolorfamily
         ,cc_color_type
         ,cc_ppns
         ,cc_print_pattern_type
         ,cc_novelty_details
         ,cc_print_description
         ,cc_matchbacks
         ,cc_free_one
         ,cc_free_two
         ,cc_free_three
         ,cc_known
         ,cc_collection
         ,cc_preview
         ,cc_marketing_flag
         ,cc_promotion_flag
         ,cc_table
         ,cc_internet_tall_style
         ,cc_price_band
         ,cc_good_better_best
         ,cc_lifecycle
         ,cc_primary_selling
         ,cc_climate_product
         ,cc_online_exclusive_flag
         ,department_name
         ,class_name
         ,subclass_name
         ,cc_missy_related_stylecolor
        )
SELECT final_stylecolor_id as product
         ,b.cc_fabric_description
         ,a.cccolor
         ,a.cccolor as cc_color_name
         ,a.cccolorfamily
         ,a.cc_color_type as cc_color_type
         ,b.cc_ppns
         ,b.cc_print_pattern_type
         ,b.cc_novelty_details
         ,b.cc_print_description
         ,b.cc_matchbacks
         ,b.cc_free_one
         ,b.cc_free_two
         ,b.cc_free_three
         ,b.cc_known
         ,b.cc_collection
         ,b.cc_preview
         ,b.cc_marketing_flag
         ,b.cc_promotion_flag
         ,b.cc_table
         ,b.cc_internet_tall_style
         ,b.cc_price_band
         ,b.cc_good_better_best
         ,b.cc_lifecycle
         ,b.cc_primary_selling
         ,b.cc_climate_product
         ,b.cc_online_exclusive_flag
         ,b.department_name
         ,a.class_name
         ,a.subclass_name
         ,master_incoming_stylecolor_id as cc_missy_related_stylecolor
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, master_incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type, class_name, subclass_name  from '||table_cart_master_temp||') a, loft_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
and final_stylecolor_id not in (select product from loft_ma_stylecolorattributes)
and a.sc_type!=''master''
';



-- ============================================================================
-- STEP 53: Update composite name/description for stylecolors
-- ============================================================================
s28_3 := '
update loft_ma_stylecolorattributes
set cc_stylecolornumber_name = a.name || '', '' || a.description
from loft_d_product a
    ,(select distinct final_stylecolor_id from '||table_cart_master_temp||') b
where product = a.id and a.id = b.final_stylecolor_id
';


-- IMAGE ATTRIBUTES START


-- ============================================================================
-- STEP 54: Drop image attribute staging table (if exists)
-- ============================================================================
s29 := 'drop table if exists '||table_ma_imgattr||'';


-- ============================================================================
-- STEP 55: Create temp table for spec image matching
-- ============================================================================
s29_1 := '
create temporary table '||table_spec_img||' as
select
 distinct si.product, si.img, sa.product as style_id
from loft_specimages si
 inner join
loft_ma_styleattributes sa
 on sa.sty_specstyleid = si.product
where sa.product in (select final_style_id from '||table_cart_master_temp||' where jsessionid in (select jsid from '||table_input_t1||'));
';


-- ============================================================================
-- STEP 56: Create image attribute table (combining source and cart images)
-- ============================================================================
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
  (select distinct product, img from loft_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
ON
b.product=c.incoming_stylecolor_id
  LEFT JOIN
  (select distinct product, img, style_id from '||table_spec_img||') d
on
d.style_id = c.final_style_id;
'
;






-- ============================================================================
-- STEP 57: Delete existing image attributes for updated stylecolors
-- ============================================================================
s31 := '
delete from loft_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;


-- ============================================================================
-- STEP 58: Insert new image attributes (prioritize: cart > orig > spec)
-- ============================================================================
s32 := '
insert into loft_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES


-- ============================================================================
-- STEP 59: Clean up old size attributes
-- ============================================================================
s33 := '
delete from loft_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';




-- ============================================================================
-- STEP 60: Insert size attributes for similar styles
-- ============================================================================
s34 := '
insert into loft_ma_sizeattributes
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


-- ============================================================================
-- STEP 61: Insert size attributes for existing styles if missing
-- ============================================================================
s34_1 := '
insert into loft_ma_sizeattributes
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
WHERE stylecolor_type = ''existing''
  and final_stylecolorsize_id not in (select product from loft_ma_sizeattributes)
';


PERFORM get_default_params(''||$1||'',''||$2||'',''||$3||'',''||$4||'',''||$5||'');

-- STYLECOLOR CHANNEL ATTRIBUTES


-- ============================================================================
-- STEP 62: Create default_cart_params using current session and scope
-- ============================================================================
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
  , a.planned_lof_week as default_planned_selldn_wk
  , a.slsrnk_store
  , a.slsrnk_ecom
  , default_retpct_str
  , default_retpct_ecomm
  , default_retpct_cross
  , default_discount
  	, default_discount_ecom -- 07.24.2025
  , sty_size_range
  , class
from (select distinct * from cart_params) a, loft_ma_dptflrsetattributes c, '||table_input_t1||' b
where a.jsessionid = b.jsid
and a.scope_product = b.scope_product
and a.scope_location = b.scope_location
and a.scope_start = b.scope_start
and a.scope_product = c.product
and a.scope_floorset = c.time
'
;



-- ============================================================================
-- STEP 63: Create temp channel attribute table for master similar stylecolors
-- Includes pricing, rank, return rate, size constraints, etc.
-- ============================================================================
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
  , default_planned_selldn_wk as plannedselldnwk
  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  --, coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , g.sty_size_range || '' - '' || c.class_id as ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , f.validsizes_store as cc_validsizes_store, f.arr_all_sizes_for_mins as arr_all_sizes_for_mins, f.sizemin_store as sizemin_store, f.sizemin_ecom as sizemin_ecom -- NEW ADD 08.10.2025
  , f.validsizes_ecom as cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , ccticketpricechannel
  , cc_existingwac
  , cc_systemcost
  , cc_plan_cost -- needs to go into cc_target_cost
  -- modified by CA on 12162024 for Actual Ranks START
  -- , b.slsrnk_store
  -- , b.slsrnk_ecom
  , b.act_slsrnk_store as slsrnk_store
  , b.act_slsrnk_ecom as  slsrnk_ecom
  -- modified by CA on 12162024 for Actual Ranks END
  , cc_imupct
  , a.default_retpct_str as cc_return_u_pct_store
  , a.default_retpct_ecomm as cc_return_u_pct_ecom
  , a.default_retpct_cross as cc_return_u_pct_cross
  , a.default_discount as cc_discount_pct
  , a.default_discount_ecom as cc_discount_pct_ecom -- 07.24.2025
  , final_stylecolor_id as missy_related_stylecolor
FROM
'||table_default_cart_params||' a, loft_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id from '||table_cart_master_temp||' where style_type = ''similar'' and sc_type = ''master'') c, (select class,size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from loft_l_size_range_validsize_defaults) f,
 (select product,sty_size_range from loft_ma_styleattributes where product in (select final_style_id from '||table_cart_master_temp||')) g
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location
and g.product = c.final_style_id
and UPPER(g.sty_size_range) = UPPER(f.sty_size_range)
and c.class_id = f.class
';



-- ============================================================================
-- STEP 64: Add alternate similar stylecolors to temp channel attributes
-- ============================================================================
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
  , default_planned_selldn_wk as plannedselldnwk
  , coalesce(ccmdstrategy, default_ccmdstrategy) ccmdstrategy
  --, coalesce(cc_ordpolicy, default_ccordpolicy) cc_ordpolicy
  , e.sty_size_range || '' - '' || c.class_id as ccrangecode
  , case when (ssnprf is null or ssnprf ='''') then ''class_default'' else ssnprf end
  , f.validsizes_store as cc_validsizes_store, f.arr_all_sizes_for_mins as arr_all_sizes_for_mins, f.sizemin_store as sizemin_store, f.sizemin_ecom as sizemin_ecom -- NEW ADD 08.10.2025
  , f.validsizes_ecom as cc_validsizes_ecom
  , d.default_size_min::int as cc_presmin
  , d.default_size_min_weeks::int as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , ccticketpricechannel
  , cc_existingwac
  , cc_systemcost
  , cc_plan_cost -- needs to go into cc_target_cost
  -- modified by CA on 12162024 for Actual Ranks START
  -- , b.slsrnk_store
  -- , b.slsrnk_ecom
  , b.act_slsrnk_store as slsrnk_store
  , b.act_slsrnk_ecom as  slsrnk_ecom
  -- modified by CA on 12162024 for Actual Ranks END
  , cc_imupct
  , d.default_return_rate_stores::real as cc_return_u_pct_store
  , d.default_return_rate_ecom::real as cc_return_u_pct_ecom
  , d.cross_channel_return_rate::real as cc_return_u_pct_cross
  , default_discount as cc_discount_pct
  , default_discount_ecom as cc_discount_pct_ecom -- 07.24.2025
  , REPLACE(final_stylecolor_id, sc_type, '''') as missy_related_stylecolor
FROM
'||table_default_cart_params||' a, loft_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||' where style_type = ''similar'' and sc_type != ''master'') c,
loft_ata_size_concept_defaults d,
loft_ma_styleattributes e,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from loft_l_size_range_validsize_defaults) f
where b.product=c.incoming_stylecolor_id and a.jsessionid=c.jsessionid and a.scope_location=b.location
and a.scope_product = d.department
and UPPER(c.sc_type) = UPPER(d.size_type)
and e.product = c.final_style_id
and UPPER(e.sty_size_range) = UPPER(f.sty_size_range)
and c.class_id = f.class
';



-- ============================================================================
-- STEP 65: Add master existing stylecolors to channel attributes
-- ============================================================================
s36_2 := '
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
  , default_planned_selldn_wk as plannedselldnwk
  , default_ccmdstrategy as ccmdstrategy
  --, default_ccordpolicy as cc_ordpolicy
  , c.sty_size_range || '' - '' || class_id as ccrangecode
  , ''class_default'' ssnprf
  , e.validsizes_store as cc_validsizes_store, e.arr_all_sizes_for_mins as arr_all_sizes_for_mins, e.sizemin_store as sizemin_store, e.sizemin_ecom as sizemin_ecom -- NEW ADD 08.10.2025
  , e.validsizes_ecom as cc_validsizes_ecom
  , default_presmin as cc_presmin
  , default_presmin_weeks as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , default_ccordermultiple cc_ordermultiple
  , d.ccticketpricechannel::real as ccticketpricechannel
  , d.cc_existingwac::real as cc_existingwac
  , d.cc_systemcost::real as cc_systemcost
  , d.cc_plan_cost::real as cc_plan_cost
  -- modified by CA on 12162024 for Actual Ranks START
  -- , d.slsrnk_store
  -- , d.slsrnk_ecom
  , d.act_slsrnk_store as slsrnk_store
  , d.act_slsrnk_ecom as  slsrnk_ecom
  -- modified by CA on 12162024 for Actual Ranks END
  , d.cc_imupct::real as cc_imupct
  , a.default_retpct_str as cc_return_u_pct_store
  , a.default_retpct_ecomm as cc_return_u_pct_ecom
  , a.default_retpct_cross as cc_return_u_pct_cross
  , default_discount as cc_discount_pct
  , default_discount_ecom as cc_discount_pct_ecom -- 07.24.2025

  , REPLACE(final_stylecolor_id, sc_type, '''') as missy_related_stylecolor
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, class_id, final_stylecolor_id, incoming_stylecolor_id, final_style_id, style_type, sc_type from '||table_cart_master_temp||' where style_type = ''existing'' and sc_type = ''master'') b,
loft_ma_styleattributes c,
loft_ma_stylecolorchannelattributes d,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from loft_l_size_range_validsize_defaults) e
where a.jsessionid=b.jsessionid
  and b.final_style_id = c.product
  and b.incoming_stylecolor_id = d.product
  and UPPER(c.sty_size_range) = UPPER(e.sty_size_range)
  and b.class_id = e.class
'
;



-- ============================================================================
-- STEP 66: Add alternate existing stylecolors to channel attributes
-- ============================================================================
s36_3 := '
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
  , default_planned_selldn_wk as plannedselldnwk
  , default_ccmdstrategy as ccmdstrategy
  --, default_ccordpolicy as cc_ordpolicy
  , c.sty_size_range || '' - '' || class_id as ccrangecode
  , ''class_default'' ssnprf
  , e.validsizes_store as cc_validsizes_store, e.arr_all_sizes_for_mins as arr_all_sizes_for_mins, e.sizemin_store as sizemin_store, e.sizemin_ecom as sizemin_ecom -- NEW ADD 08.10.2025

  , e.validsizes_ecom as cc_validsizes_ecom
  , f.default_size_min::int as cc_presmin
  , f.default_size_min_weeks::int as cc_presmin_weeks
  , default_ccrcptint as cc_rcptint
  , coalesce(cc_ordermultiple::int,default_ccordermultiple::int) cc_ordermultiple
  , ccticketpricechannel
  , cc_existingwac
  , cc_systemcost
  , cc_plan_cost -- needs to go into cc_target_cost
  -- modified by CA on 12162024 for Actual Ranks START
  -- , d.slsrnk_store
  -- , d.slsrnk_ecom
  , d.act_slsrnk_store as slsrnk_store
  , d.act_slsrnk_ecom as  slsrnk_ecom
  -- modified by CA on 12162024 for Actual Ranks END
  , cc_imupct
  , f.default_return_rate_stores::real as cc_return_u_pct_store
  , f.default_return_rate_ecom::real as cc_return_u_pct_ecom
  , f.cross_channel_return_rate::real as cc_return_u_pct_cross
  , default_discount as cc_discount_pct
  , default_discount_ecom as cc_discount_pct_ecom --  07.24.2025
  , g.cc_missy_related_stylecolor as missy_related_stylecolor
FROM
'||table_default_cart_params||' a, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, style_type, sc_type, master_incoming_stylecolor_id, class_id from '||table_cart_master_temp||' where style_type = ''existing'' and sc_type != ''master'') b,
loft_ma_styleattributes c,
(select * from loft_ma_stylecolorchannelattributes) d,
(select * from loft_ma_stylecolorattributes) g,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from loft_l_size_range_validsize_defaults) e, loft_ata_size_concept_defaults f
where a.jsessionid=b.jsessionid
  and b.final_style_id = c.product
  and b.master_incoming_stylecolor_id = d.product
  and UPPER(c.sty_size_range) = UPPER(e.sty_size_range)
  and UPPER(b.sc_type) = UPPER(f.size_type)
  and b.class_id = e.class
  and a.scope_product = f.department
  and g.product = final_stylecolor_id;
'
;



s37 := '
delete from loft_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into loft_ma_stylecolorchannelattributes (
  product
, missy_related_stylecolor
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
, plannedselldnwk
, ccmdstrategy
--, cc_ordpolicy
, ccrangecode
, ssnprf
, validsizes
, cc_validsizes_store, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom -- NEW ADD 08.10.2025
, cc_validsizes_ecom
, cc_presmin
, cc_presmin_weeks
, cc_rcptint
, cc_ordermultiple
, ccticketpricechannel
, cc_existingwac
, cc_systemcost
, cc_plan_cost
, slsrnk_store
, slsrnk_ecom
, cc_return_u_pct_store
, cc_return_u_pct_ecom
, cc_return_u_pct_cross
, cc_discount_pct
, cc_discount_pct_ecom -- 07.24.2025
, record_state
)
select
  product
, missy_related_stylecolor
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
, plannedselldnwk
, ccmdstrategy
--, cc_ordpolicy
, ccrangecode
, ssnprf
, ''{}''::text[]
, cc_validsizes_store, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom -- NEW ADD 08.10.2025
, cc_validsizes_ecom
, cc_presmin
, cc_presmin_weeks
, cc_rcptint
, cc_ordermultiple
, ccticketpricechannel
, cc_existingwac
, cc_systemcost
, cc_plan_cost
, slsrnk_store
, slsrnk_ecom
, cc_return_u_pct_store
, cc_return_u_pct_ecom
, cc_return_u_pct_cross
, cc_discount_pct
, cc_discount_pct_ecom -- 07.24.2025
, CASE WHEN missy_related_stylecolor = product then 0 ELSE 1 END as record_state
FROM
 '||table_temp_sclr_chnl_attr||'
 ';




-- ASSORTMENT MODEL

s51 := '
update loft_ma_stylecolorchannelattributes a
set
  plan_current = v_plan_current
from (select value as v_plan_current from loft_serviceparams where id=''plan_current'') c
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

s51_1 := '
update loft_ma_stylecolorchannelattributes a
set
  ccrangecode = rangecode
from (select x.sty_size_range || '' - '' || y.ancestor2 as rangecode, style_type, final_stylecolor_id
      from loft_ma_styleattributes x, loft_h_prodstd y,
           (select distinct final_stylecolor_id, final_style_id, style_type from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')) z
      where x.product = z.final_style_id and y.id = z.final_stylecolor_id
     ) b
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
  and a.product = b.final_stylecolor_id
';



s39 := '
    create temporary table '||table_temp_assort||' AS
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(case when cardinality(str_climate)= 0 then ''{N,Y}'' else str_climate end as text[]) as str_climate
        , cast(str_grade as text[]) as str_grade
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        -- SUP-1715: with an SSG, grade/climate are blank, so get_store_count returns 0; take the count from the SSG lookup
        , case when coalesce(cardinality(cast(ssg as text[])),0) > 0
               then coalesce((select cardinality(l.stores)
                              from loft_l_ssglookup l
                              where l.ssg_id = array_to_string(cast(ssg as text[]), '','')
                                and l.product = a.scope_product), 0)
               else get_store_count(d.slsstart, a.str_climate, a.str_grade, c.class_id)
          end as store_count
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||') c
    ,loft_ma_dptflrsetattributes d
    where a.jsessionid=c.jsessionid
  and a.jsessionid = b.jsid
  and a.scope_product = b.scope_product
  and a.scope_location = b.scope_location
  and a.scope_start = b.scope_start
  and c.sc_type = ''master''
  and a.scope_floorset = d.time and a.scope_product = d.product
    '
    ;



s39_1 := '
    insert into '||table_temp_assort||'
    SELECT
        final_stylecolor_id as product
        , a.scope_location as location
        , a.scope_floorset as "time"
        , cast(case when d.default_climate = ''ALL'' then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else d.default_climate end as text[]) as str_climate
        , cast(case when d.default_tier = ''ALL'' then ''{NA,1,2,3,4,5,ECOM}'' else d.default_tier end as text[]) as str_grade
        , cast(case when d.default_ssg = ''NULL'' then ''{}'' else d.default_ssg end as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , get_store_count(e.slsstart, cast(case when d.default_climate = ''ALL'' then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else d.default_climate end as text[]), cast(case when d.default_tier = ''ALL'' then ''{NA,1,2,3,4,5,ECOM}'' else d.default_tier end as text[]), c.class_id) as store_count
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||') c, loft_ata_size_concept_defaults d
    ,loft_ma_dptflrsetattributes e
    where a.jsessionid=c.jsessionid
  and a.jsessionid = b.jsid
  and a.scope_product = b.scope_product
  and a.scope_location = b.scope_location
  and a.scope_start = b.scope_start
  and a.scope_product = d.department
  and UPPER(c.sc_type) = UPPER(d.size_type)
  and a.scope_floorset = e.time and a.scope_product = e.product
    '
    ;



s40 := '
delete from loft_a_assortment a where plan_type=''plan'' and exists (select 1 from '||table_temp_assort||' b where a.product = b.product and a.location = b.location)
';



s41 := '
    insert into loft_a_assortment (
          product
        , location
        , "time"
        , str_climate
        , str_grade
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
        , str_climate
        , str_grade
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
(select distinct product,location  from loft_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||' where sc_type = ''master'')) a,
(select distinct product,location  from loft_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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
              cc_discount_pct_ecom, -- 07.24.2025
              in_season_flag,
              id AS time,
              case when id < erlstmkdnwk then ''FP'' else ''MD'' end as price_status
          FROM loft_ma_stylecolorchannelattributes AS a
          , loft_d_time AS b
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
                  cc_discount_pct_ecom, -- 07.24.2025
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
                  cc_discount_pct_ecom, -- 07.24.2025
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
              FROM loft_h_prodstd
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
            , 0::real selling_price_ecom -- 07.24.2025
            , 0::real v_A
            , 0::real v_B
            , null::text weekdate

            , 0::real corpaddoff_ecom
            , 0::real corpexcl_ecom
            , 0::real addoff_ecom
            , 0::real v_A_ecom
            , 0::real v_B_ecom
            FROM
            (select a.* from '||tst_df_with_style||' a, loft_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.ccticketpricechannel::real, curp=ccticketpricechannel::real
          from loft_ma_stylecolorchannelattributes b
          where a.product = b.product
          ';

s105 := 'update '||tst_md_tktp_md||' a
            set md_disc=b.md_disc, curp=ccticketprice * (1 - b.md_disc)
          from md_strategy b
          where a.seq=b.seq and a.ccmdstrategy=b.mdstrategy
          and a.seq > 0
          ';

s106 := 'update '||tst_md_tktp_md||' a
            set corpaddoff=b.corpaddoff, corpexcl=b.corpexcl, corpaddoff_ecom = b.corpaddoff_ecom, corpexcl_ecom = b.corpexcl_ecom
          from loft_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff, addoff_ecom=b.addoff_ecom
          from loft_p_itemprice b
          where a.product=b.product and a.time=b.time
        ';

s108 := 'update '||tst_md_tktp_md||' a
            set v_A=b.v_A, v_A_ecom=b.v_A_ecom
          FROM
            (select product, time, seq, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl,0)) else curp end as v_A, case when seq=0 then ccticketprice * (1-COALESCE(corpexcl_ecom,0)) else curp end as v_A_ecom  from '||tst_md_tktp_md||') b
          WHERE a.product=b.product and a.time=b.time
          ';

s109 := 'update '||tst_md_tktp_md||' a
            set v_B=b.v_B, v_B_ecom=b.v_B_ecom
          FROM
            (select product, time, seq, addoff, corpaddoff
              , case when seq=0 then
                  (case when expressed_aur > 0 then expressed_aur else ccticketprice end) * (1 - coalesce(addoff,0)) * (1 - coalesce(corpaddoff,0))
               else curp end as v_B
               , case when seq=0 then
                  (case when expressed_aur > 0 then expressed_aur else ccticketprice end) * (1 - coalesce(addoff_ecom,0)) * (1 - coalesce(corpaddoff_ecom,0))
               else curp end as v_B_ecom
               from '||tst_md_tktp_md||'
            ) b
          WHERE a.product=b.product and a.time=b.time
          ';

S_PRE_110_1 := 'CREATE TEMPORARY TABLE '||table_xt_flag||' AS
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, loft_d_time b, loft_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2), selling_price_ecom=(least(v_A_ecom,v_B_ecom) * (1 - cc_discount_pct_ecom))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from loft_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from loft_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from loft_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from loft_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from loft_ma_weekattributes b where a.time=b.time';



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
              FROM (select * from loft_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM loft_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM loft_ma_dptflrsetattributes AS a
              , loft_d_time AS b
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
                  b.selling_price_ecom, -- 07.24.2025
                  b.expressed_aur,
                  b.corpexcl,
                  b.addoff,
                  b.corpaddoff,
                  b.v_A,
                  b.v_B,
                  b.cc_discount_pct,
 				  -- 07.24.2025
                  b.corpexcl_ecom,
                  b.addoff_ecom,
                  b.corpaddoff_ecom,
                  b.v_A_ecom,
                  b.v_B_ecom,
                  b.cc_discount_pct_ecom
              FROM '||table_xt||' AS a
              , '||tst_md_tktp_md||' AS b
              WHERE (a.product = b.product) AND (a.id = b.time)
          ) AS x
          WHERE time >= (select value from loft_serviceparams where id=''plan_current'')
          AND time <= (select value from loft_serviceparams where id=''plan_end'')
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


s114 := 'delete from loft_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into loft_an_price_storecount_info
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
		  -- 07.24.2025 Mod
		  , corpexcl_ecom
		  , addoff_ecom
		  , corpaddoff_ecom
		  , v_A_ecom
		  , v_B_ecom
		  , cc_discount_pct_ecom
		  , selling_price_ecom
          from
          '||table_zt||'
          ';
/*
RAISE NOTICE 'INPUT:%', 'START:'|| now();
RAISE NOTICE 's1:%', s1;
RAISE NOTICE 's2:%', s2;
RAISE NOTICE 's2_1:%', s2_1;
RAISE NOTICE 's3:%', s3;
RAISE NOTICE 's4_0_1:%', s4_0_1;
RAISE NOTICE 's4_0_2:%', s4_0_2;
RAISE NOTICE 's4_1:%', s4_1;
RAISE NOTICE 's4_2_1:%', s4_2_1; 
RAISE NOTICE 's5:%', s5;
RAISE NOTICE 's5_1:%', s5_1;
RAISE NOTICE 's5_1_1:%', s5_1_1;
RAISE NOTICE 's5_2:%', s5_2;
RAISE NOTICE 's5_3:%', s5_3;
RAISE NOTICE 's6:%', s6;
RAISE NOTICE 's7:%', s7;
RAISE NOTICE 's7_01:%', s7_01;
RAISE NOTICE 's7_1:%', s7_1;
--RAISE NOTICE 's7_1_1:%', s7_1_1;
--RAISE NOTICE 's7_1_2:%', s7_1_2;
RAISE NOTICE 's7_2:%', s7_2;


RAISE NOTICE 'Start Member Create:%', 'START:'|| now();

RAISE NOTICE 's8:%', s8;
RAISE NOTICE 's9: %', s9;
RAISE NOTICE 's9_1: %', s9_1;
RAISE NOTICE 's10: %', s10;
RAISE NOTICE 's11: %', s11;
RAISE NOTICE 's11_1: %', s11_1;
RAISE NOTICE 's12: %', s12;
RAISE NOTICE 's13: %', s13;
RAISE NOTICE 's13_1: %', s13_1;
RAISE NOTICE 's14: %', s14;
RAISE NOTICE 's15: %', s15;
RAISE NOTICE 's15_1:%', s15_1;
RAISE NOTICE 's15_2:%', s15_2;
RAISE NOTICE 's16: %', s16;
RAISE NOTICE 's17: %', s17;
RAISE NOTICE 's17_1:%', s17_1;
RAISE NOTICE 's17_2:%', s17_2;
RAISE NOTICE 's18: %', s18;
RAISE NOTICE 's19: %', s19;
RAISE NOTICE 's19_1: %', s19_1;
RAISE NOTICE 'Start Attribute Create:%', 'START:'|| now();
RAISE NOTICE 's20: %', s20;
RAISE NOTICE 's21: %', s21;
RAISE NOTICE 's21_1:%', s21_1;
RAISE NOTICE 's22: %', s22;
RAISE NOTICE 's23: %', s23;
RAISE NOTICE 's24: %', s24;
RAISE NOTICE 's25: %', s25;
RAISE NOTICE 's26: %', s26;
RAISE NOTICE 's26_1: %', s26_1;
RAISE NOTICE 's26_2: %', s26_2;
RAISE NOTICE 's26_3: %', s26_3;
RAISE NOTICE 's26_4: %', s26_4;
RAISE NOTICE 's26_5: %', s26_5;
RAISE NOTICE 's26_6: %', s26_6;
RAISE NOTICE 's26_7: %', s26_7;
RAISE NOTICE 's27: %', s27;
RAISE NOTICE 's28: %', s28;
RAISE NOTICE 's28_1: %', s28_1;
RAISE NOTICE 's28_2: %', s28_2;
RAISE NOTICE 's28_3: %', s28_3;
RAISE NOTICE 's29: %', s29;
RAISE NOTICE 's29_1: %', s29_1;
RAISE NOTICE 's30: %', s30;
RAISE NOTICE 's31: %', s31;
RAISE NOTICE 's32: %', s32;
RAISE NOTICE 's33: %', s33;
RAISE NOTICE 's34: %', s34;
RAISE NOTICE 's34_1: %', s34_1;
RAISE NOTICE 'Start Channel Attribute:%', 'START:'|| now();
RAISE NOTICE 's35: %', s35;
RAISE NOTICE 's36: %', s36;
RAISE NOTICE 's36_1: %', s36_1;
RAISE NOTICE 's36_2: %', s36_2;
RAISE NOTICE 's36_3: %', s36_3;
RAISE NOTICE 's37: %', s37;
RAISE NOTICE 's38: %', s38;

RAISE NOTICE 'Start Assortment Model:%', 'START:'|| now();
--RAISE NOTICE 's51: %', s51;
--RAISE NOTICE 's51_1: %', s51_1;
RAISE NOTICE 's39: %', s39;
RAISE NOTICE 's39_1: %', s39_1;
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
RAISE NOTICE 's100 :%', s100 ;
RAISE NOTICE 's101 :%', s101 ;
RAISE NOTICE 's102 :%', s102 ;
RAISE NOTICE 's103 :%', s103 ;
RAISE NOTICE 's104 :%', s104 ;
RAISE NOTICE 's104_a :%', s104_a ;
RAISE NOTICE 's105 :%', s105 ;
RAISE NOTICE 's106 :%', s106 ;
RAISE NOTICE 's107 :%', s107 ;
RAISE NOTICE 's108 :%', s108 ;
RAISE NOTICE 's109 :%', s109 ;
RAISE NOTICE 's_pre_110_1:%', s_pre_110_1;
RAISE NOTICE 's110 :%', s110 ;
RAISE NOTICE 's110_1:%', s110_1;
RAISE NOTICE 's110_2:%', s110_2;
RAISE NOTICE 's110_3:%', s110_3;
RAISE NOTICE 's110_4:%', s110_4;
RAISE NOTICE 's110_5:%', s110_5;
RAISE NOTICE 's111 :%', s111 ;
RAISE NOTICE '--s112 :%', --s112 ;
RAISE NOTICE 's113 :%', s113 ;
RAISE NOTICE 's113_1 :%', s113_1 ;
RAISE NOTICE 's113_2 :%', s113_2 ;
RAISE NOTICE 's114 :%', s114 ;
RAISE NOTICE 's115 :%', s115 ;
*/
-- s110_6 :=  'drop table if exists tst_md_tktp_md';
-- s110_7 :=  'create table tst_md_tktp_md as select * from '||tst_md_tktp_md||'';
-- s110_8 :=  'drop table if exists table_zt';
-- s110_9 :=  'create table table_zt as select * from '||table_zt||'';
-- insert into trigger_test_delete_me values ('s0:', clock_timestamp());
EXECUTE s1;
EXECUTE 'create table if not exists deleteme_input_t1_jr as select *, ''''::text as step, clock_timestamp() as captured_at from '||table_input_t1||' where 1=0';
EXECUTE 'insert into deleteme_input_t1_jr select *, ''after_s1'', clock_timestamp() from '||table_input_t1;
-- insert into trigger_test_delete_me values ('s1:', clock_timestamp());
-- RAISE NOTICE 's1 :%', clock_timestamp() ;
EXECUTE s2;
EXECUTE 'create table if not exists deleteme_table_cart_master_temp_jr as select *, ''''::text as step, clock_timestamp() as captured_at from '||table_cart_master_temp||' where 1=0';
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s2'', clock_timestamp() from '||table_cart_master_temp;
EXECUTE s2_dprod;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s2_dprod'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's2 :%', clock_timestamp() ;
EXECUTE s2_1;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s2_1'', clock_timestamp() from '||table_cart_master_temp;
-- insert into trigger_test_delete_me values ('s2:', clock_timestamp());
-- RAISE NOTICE 's2_1 :%', clock_timestamp() ;
EXECUTE s3;
EXECUTE 'create table if not exists deleteme_table_cart_style_jr as select *, ''''::text as step, clock_timestamp() as captured_at from '||table_cart_style||' where 1=0';
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s3'', clock_timestamp() from '||table_cart_style;
-- insert into trigger_test_delete_me values ('s3:', clock_timestamp());
-- RAISE NOTICE 's3 :%', clock_timestamp() ;
EXECUTE s3_1;
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s3_1'', clock_timestamp() from '||table_cart_style;
-- insert into trigger_test_delete_me values ('s3_1:', clock_timestamp());
-- RAISE NOTICE 's3_1 :%', clock_timestamp() ;
EXECUTE s3_2;
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s3_2'', clock_timestamp() from '||table_cart_style;
-- insert into trigger_test_delete_me values ('s3_2:', clock_timestamp());
-- RAISE NOTICE 's3_2 :%', clock_timestamp() ;
EXECUTE s4_0_1;
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s4_0_1'', clock_timestamp() from '||table_cart_style;
-- RAISE NOTICE 's4_0_1 :%', clock_timestamp() ;
EXECUTE s4_0_2;
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s4_0_2'', clock_timestamp() from '||table_cart_style;
-- RAISE NOTICE 's4_0_2 :%', clock_timestamp() ;
EXECUTE s4_1;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_1'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_1 :%', clock_timestamp() ;
-- ============================================================================
-- Modified on July 22nd 2025 by Robert Kebert to comment out section. Style_Size_Type should be coming from the cart_params
-- ============================================================================
/*
EXECUTE s4_2;
*/
EXECUTE s4_2_0_0;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_0_0'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_0_0 :%', clock_timestamp() ;
EXECUTE s4_2_0;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_0'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_0 :%', clock_timestamp() ;
EXECUTE s4_2_1;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_1'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_1 :%', clock_timestamp() ;
EXECUTE s4_2_4;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_4'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_4 :%', clock_timestamp() ;
EXECUTE s4_2_5;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_5'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_5 :%', clock_timestamp() ;
EXECUTE s4_2_2;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_2_2'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_2_2 :%', clock_timestamp() ;
EXECUTE s4_2_3;
EXECUTE 'insert into deleteme_table_cart_style_jr select *, ''after_s4_2_3'', clock_timestamp() from '||table_cart_style;
-- RAISE NOTICE 's4_2_3 :%', clock_timestamp() ;
EXECUTE s4_3;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_3'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_3 :%', clock_timestamp() ;
EXECUTE s4_4;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_4'', clock_timestamp() from '||table_cart_master_temp;
---- RAISE NOTICE 's4_4 :%', clock_timestamp() ;
EXECUTE s4_5;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s4_5'', clock_timestamp() from '||table_cart_master_temp;
-- RAISE NOTICE 's4_5 :%', clock_timestamp() ;
-- insert into trigger_test_delete_me values ('s4_1:', clock_timestamp());
EXECUTE s5;
EXECUTE 'create table if not exists deleteme_table_cart_stylecolor_jr as select *, ''''::text as step, clock_timestamp() as captured_at from '||table_cart_stylecolor||' where 1=0';
EXECUTE 'insert into deleteme_table_cart_stylecolor_jr select *, ''after_s5'', clock_timestamp() from '||table_cart_stylecolor;
-- insert into trigger_test_delete_me values ('s5:', clock_timestamp());
-- RAISE NOTICE 's5 :%', clock_timestamp() ;
EXECUTE s5_1;
EXECUTE 'insert into deleteme_table_cart_stylecolor_jr select *, ''after_s5_1'', clock_timestamp() from '||table_cart_stylecolor;
-- insert into trigger_test_delete_me values ('s5_1:', clock_timestamp());
-- RAISE NOTICE 's5_1 :%', clock_timestamp() ;
EXECUTE s5_1_1;
EXECUTE 'insert into deleteme_table_cart_stylecolor_jr select *, ''after_s5_1_1'', clock_timestamp() from '||table_cart_stylecolor;
-- insert into trigger_test_delete_me values ('s5_1_1:', clock_timestamp());
-- RAISE NOTICE 's5_1_1 :%', clock_timestamp() ;
EXECUTE s5_2;
EXECUTE 'insert into deleteme_table_cart_stylecolor_jr select *, ''after_s5_2'', clock_timestamp() from '||table_cart_stylecolor;
-- insert into trigger_test_delete_me values ('s5_2:', clock_timestamp());
-- RAISE NOTICE 's5_2 :%', clock_timestamp() ;
EXECUTE s5_3;
EXECUTE 'insert into deleteme_table_cart_stylecolor_jr select *, ''after_s5_3'', clock_timestamp() from '||table_cart_stylecolor;
-- insert into trigger_test_delete_me values ('s5_3:', clock_timestamp());
-- RAISE NOTICE 's5_3 :%', clock_timestamp() ;
EXECUTE s6;
EXECUTE 'insert into deleteme_table_cart_master_temp_jr select *, ''after_s6'', clock_timestamp() from '||table_cart_master_temp;
-- insert into trigger_test_delete_me values ('s6:', clock_timestamp());
-- RAISE NOTICE 's6 :%', clock_timestamp() ;
EXECUTE s7;
EXECUTE 'create table if not exists deleteme_table_cart_stylecolorsize_jr as select *, ''''::text as step, clock_timestamp() as captured_at from '||table_cart_stylecolorsize||' where 1=0';
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7:', clock_timestamp());
-- RAISE NOTICE 's7 :%', clock_timestamp() ;
EXECUTE s7_01;
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7_01'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7_01:', clock_timestamp());
-- RAISE NOTICE 's7_01 :%', clock_timestamp() ;
EXECUTE s7_1;
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7_1'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1 :%', clock_timestamp() ;
EXECUTE s7_1_1;
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7_1_1'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1_1 :%', clock_timestamp() ;
EXECUTE s7_1_2;
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7_1_2'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1_2 :%', clock_timestamp() ;
EXECUTE s7_2;
EXECUTE 'insert into deleteme_table_cart_stylecolorsize_jr select *, ''after_s7_2'', clock_timestamp() from '||table_cart_stylecolorsize;
-- insert into trigger_test_delete_me values ('s7_2:', clock_timestamp());
-- RAISE NOTICE 's7_2 :%', clock_timestamp() ;
EXECUTE s8;
EXECUTE 'create table if not exists deleteme_loft_d_product_jr as select *, ''''::text as step, clock_timestamp() as captured_at from loft_d_product where 1=0';
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s8'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s8:', clock_timestamp());
-- RAISE NOTICE 's8 :%', clock_timestamp() ;
EXECUTE s9;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s9'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s9:', clock_timestamp());
-- RAISE NOTICE 's9 :%', clock_timestamp() ;
EXECUTE s9_1;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s9_1'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s9:', clock_timestamp());
-- RAISE NOTICE 's9_1 :%', clock_timestamp() ;
EXECUTE s10;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s10'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s10:', clock_timestamp());
-- RAISE NOTICE 's10 :%', clock_timestamp() ;
EXECUTE s11;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s11'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s11:', clock_timestamp());
-- RAISE NOTICE 's11 :%', clock_timestamp() ;
EXECUTE s11_1;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s11_1'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s11_1:', clock_timestamp());
-- RAISE NOTICE 's11_1 :%', clock_timestamp() ;
EXECUTE s13;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s13'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s13:', clock_timestamp());
-- RAISE NOTICE 's13 :%', clock_timestamp() ;
EXECUTE s13_1;
EXECUTE 'insert into deleteme_loft_d_product_jr select p.*, ''after_s13_1'', clock_timestamp() from loft_d_product p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s13_1:', clock_timestamp());
-- RAISE NOTICE 's13_1 :%', clock_timestamp() ;
EXECUTE s14;
EXECUTE 'create table if not exists deleteme_loft_h_prodstd_jr as select *, ''''::text as step, clock_timestamp() as captured_at from loft_h_prodstd where 1=0';
EXECUTE 'insert into deleteme_loft_h_prodstd_jr select p.*, ''after_s14'', clock_timestamp() from loft_h_prodstd p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s14:', clock_timestamp());
-- RAISE NOTICE 's14 :%', clock_timestamp() ;
EXECUTE s15;
EXECUTE 'insert into deleteme_loft_h_prodstd_jr select p.*, ''after_s15'', clock_timestamp() from loft_h_prodstd p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s15:', clock_timestamp());
-- RAISE NOTICE 's15 :%', clock_timestamp() ;
EXECUTE s15_1;
EXECUTE 'insert into deleteme_loft_h_prodstd_jr select p.*, ''after_s15_1'', clock_timestamp() from loft_h_prodstd p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s15_1:', clock_timestamp());
-- RAISE NOTICE 's15_1 :%', clock_timestamp() ;
EXECUTE s15_2;
EXECUTE 'insert into deleteme_loft_h_prodstd_jr select p.*, ''after_s15_2'', clock_timestamp() from loft_h_prodstd p where p.id in (select final_style_id from '||table_cart_style||' union select final_stylecolor_id from '||table_cart_stylecolor||' union select final_stylecolorsize_id from '||table_cart_stylecolorsize||')';
-- insert into trigger_test_delete_me values ('s15_2:', clock_timestamp());
-- RAISE NOTICE 's15_2 :%', clock_timestamp() ;
EXECUTE s16;
-- insert into trigger_test_delete_me values ('s16:', clock_timestamp());
-- RAISE NOTICE 's16 :%', clock_timestamp() ;
EXECUTE s17;
-- insert into trigger_test_delete_me values ('s17:', clock_timestamp());
-- RAISE NOTICE 's17 :%', clock_timestamp() ;
EXECUTE s17_1;
-- insert into trigger_test_delete_me values ('s17_1:', clock_timestamp());
-- RAISE NOTICE 's17_1 :%', clock_timestamp() ;
EXECUTE s17_2;
-- insert into trigger_test_delete_me values ('s17_2:', clock_timestamp());
-- RAISE NOTICE 's17_2 :%', clock_timestamp() ;
EXECUTE s19;
-- insert into trigger_test_delete_me values ('s19:', clock_timestamp());
-- RAISE NOTICE 's19 :%', clock_timestamp() ;
EXECUTE s19_1;
-- insert into trigger_test_delete_me values ('s19_1:', clock_timestamp());
-- RAISE NOTICE 's19_1 :%', clock_timestamp() ;
EXECUTE s20;
-- insert into trigger_test_delete_me values ('s20:', clock_timestamp());
-- RAISE NOTICE 's20 :%', clock_timestamp() ;
EXECUTE s21;
-- insert into trigger_test_delete_me values ('s21:', clock_timestamp());
-- RAISE NOTICE 's21 :%', clock_timestamp() ;
EXECUTE s21_1;
-- insert into trigger_test_delete_me values ('s21_1:', clock_timestamp());
-- RAISE NOTICE 's21_1 :%', clock_timestamp() ;
EXECUTE s22;
-- insert into trigger_test_delete_me values ('s22:', clock_timestamp());
-- RAISE NOTICE 's22 :%', clock_timestamp() ;
EXECUTE s23;
-- insert into trigger_test_delete_me values ('s23:', clock_timestamp());
-- RAISE NOTICE 's23 :%', clock_timestamp() ;
EXECUTE s24;
-- insert into trigger_test_delete_me values ('s24:', clock_timestamp());
-- RAISE NOTICE 's24 :%', clock_timestamp() ;
EXECUTE s25;
-- insert into trigger_test_delete_me values ('s25:', clock_timestamp());
-- RAISE NOTICE 's25 :%', clock_timestamp() ;
EXECUTE s26;
-- insert into trigger_test_delete_me values ('s26:', clock_timestamp());
-- RAISE NOTICE 's26 :%', clock_timestamp() ;
EXECUTE s26_1;
-- insert into trigger_test_delete_me values ('s26_1:', clock_timestamp());
-- RAISE NOTICE 's26_1 :%', clock_timestamp() ;
EXECUTE s26_2;
-- insert into trigger_test_delete_me values ('s26_2:', clock_timestamp());
-- RAISE NOTICE 's26_2 :%', clock_timestamp() ;
EXECUTE s26_3;
-- insert into trigger_test_delete_me values ('s26_3:', clock_timestamp());
-- RAISE NOTICE 's26_3 :%', clock_timestamp() ;
EXECUTE s26_4;
-- insert into trigger_test_delete_me values ('s26_4:', clock_timestamp());
-- RAISE NOTICE 's26_4 :%', clock_timestamp() ;
EXECUTE s26_5;
-- insert into trigger_test_delete_me values ('s26_5:', clock_timestamp());
-- RAISE NOTICE 's26_5 :%', clock_timestamp() ;
EXECUTE s26_6;
-- insert into trigger_test_delete_me values ('s26_6:', clock_timestamp());
-- RAISE NOTICE 's26_6 :%', clock_timestamp() ;
EXECUTE s26_7;
-- insert into trigger_test_delete_me values ('s26_7:', clock_timestamp());
-- RAISE NOTICE 's26_7 :%', clock_timestamp() ;
EXECUTE s27;
-- insert into trigger_test_delete_me values ('s27:', clock_timestamp());
-- RAISE NOTICE 's27 :%', clock_timestamp() ;
EXECUTE s28;
-- insert into trigger_test_delete_me values ('s28:', clock_timestamp());
-- RAISE NOTICE 's28 :%', clock_timestamp() ;
EXECUTE s28_1;
-- insert into trigger_test_delete_me values ('s28_1:', clock_timestamp());
-- RAISE NOTICE 's28_1 :%', clock_timestamp() ;
EXECUTE s28_2;
-- insert into trigger_test_delete_me values ('s28_2:', clock_timestamp());
-- RAISE NOTICE 's28_2 :%', clock_timestamp() ;
EXECUTE s28_3;
-- insert into trigger_test_delete_me values ('s28_3:', clock_timestamp());
-- RAISE NOTICE 's28_3 :%', clock_timestamp() ;
EXECUTE s29;
-- insert into trigger_test_delete_me values ('s29:', clock_timestamp());
-- RAISE NOTICE 's29 :%', clock_timestamp() ;
EXECUTE s29_1;
-- insert into trigger_test_delete_me values ('s29_1:', clock_timestamp());
-- RAISE NOTICE 's29_1 :%', clock_timestamp() ;
EXECUTE s30;
-- insert into trigger_test_delete_me values ('s30:', clock_timestamp());
-- RAISE NOTICE 's30 :%', clock_timestamp() ;
EXECUTE s31;
-- insert into trigger_test_delete_me values ('s31:', clock_timestamp());
-- RAISE NOTICE 's31 :%', clock_timestamp() ;
EXECUTE s32;
-- insert into trigger_test_delete_me values ('s32:', clock_timestamp());
-- RAISE NOTICE 's32 :%', clock_timestamp() ;
EXECUTE s33;
-- insert into trigger_test_delete_me values ('s33:', clock_timestamp());
-- RAISE NOTICE 's33 :%', clock_timestamp() ;
EXECUTE s34;
-- insert into trigger_test_delete_me values ('s34:', clock_timestamp());
-- RAISE NOTICE 's34 :%', clock_timestamp() ;
EXECUTE s34_1;
-- insert into trigger_test_delete_me values ('s34_1:', clock_timestamp());
-- RAISE NOTICE 's34_1 :%', clock_timestamp() ;
EXECUTE s35;
-- insert into trigger_test_delete_me values ('s35:', clock_timestamp());
-- RAISE NOTICE 's35 :%', clock_timestamp() ;
EXECUTE s36;
-- insert into trigger_test_delete_me values ('s36:', clock_timestamp());
-- RAISE NOTICE 's36 :%', clock_timestamp() ;
EXECUTE s36_1;
-- insert into trigger_test_delete_me values ('s36_1:', clock_timestamp());
-- RAISE NOTICE 's36_1 :%', clock_timestamp() ;
EXECUTE s36_2;
-- insert into trigger_test_delete_me values ('s36_2:', clock_timestamp());
-- RAISE NOTICE 's36_2 :%', clock_timestamp() ;
EXECUTE s36_3;
-- insert into trigger_test_delete_me values ('s36_3:', clock_timestamp());
-- RAISE NOTICE 's36_3 :%', clock_timestamp() ;
EXECUTE s37;
-- insert into trigger_test_delete_me values ('s37:', clock_timestamp());
-- RAISE NOTICE 's37 :%', clock_timestamp() ;
EXECUTE s38;
-- insert into trigger_test_delete_me values ('s38:', clock_timestamp());
-- RAISE NOTICE 's38 :%', clock_timestamp() ;
EXECUTE s51;
-- insert into trigger_test_delete_me values ('s51:', clock_timestamp());
-- RAISE NOTICE 's51 :%', clock_timestamp() ;
--EXECUTE s51_1;
-- insert into trigger_test_delete_me values ('s51_1:', clock_timestamp());
-- RAISE NOTICE 's51_1 :%', clock_timestamp() ;
EXECUTE s39;
-- insert into trigger_test_delete_me values ('s39:', clock_timestamp());
-- RAISE NOTICE 's39 :%', clock_timestamp() ;
EXECUTE s39_1;
-- insert into trigger_test_delete_me values ('s39_1:', clock_timestamp());
-- RAISE NOTICE 's39_1 :%', clock_timestamp() ;
EXECUTE s40;
-- insert into trigger_test_delete_me values ('s40:', clock_timestamp());
-- RAISE NOTICE 's40 :%', clock_timestamp() ;
EXECUTE s41;
-- insert into trigger_test_delete_me values ('s41:', clock_timestamp());
-- RAISE NOTICE 's41 :%', clock_timestamp() ;
--EXECUTE s41_1;
-- insert into trigger_test_delete_me values ('s41_1:', clock_timestamp());
EXECUTE s42;
-- insert into trigger_test_delete_me values ('s42:', clock_timestamp());
-- RAISE NOTICE 's42 :%', clock_timestamp() ;
EXECUTE s43;
-- insert into trigger_test_delete_me values ('s43:', clock_timestamp());
-- RAISE NOTICE 's43 :%', clock_timestamp() ;
EXECUTE s44;
-- insert into trigger_test_delete_me values ('s44:', clock_timestamp());
-- RAISE NOTICE 's44 :%', clock_timestamp() ;
EXECUTE s45;
-- insert into trigger_test_delete_me values ('s45:', clock_timestamp());
-- RAISE NOTICE 's45 :%', clock_timestamp() ;
EXECUTE s46;
-- insert into trigger_test_delete_me values ('s46:', clock_timestamp());
-- RAISE NOTICE 's46 :%', clock_timestamp() ;
EXECUTE s47;
-- insert into trigger_test_delete_me values ('s47:', clock_timestamp());
-- RAISE NOTICE 's47 :%', clock_timestamp() ;
EXECUTE s48;
-- insert into trigger_test_delete_me values ('s48:', clock_timestamp());
-- RAISE NOTICE 's48 :%', clock_timestamp() ;
EXECUTE s49;
-- insert into trigger_test_delete_me values ('s49:', clock_timestamp());
-- RAISE NOTICE 's49 :%', clock_timestamp() ;
EXECUTE s50;
-- insert into trigger_test_delete_me values ('s50:', clock_timestamp());
-- RAISE NOTICE 's50 :%', clock_timestamp() ;
EXECUTE s100 ;
-- insert into trigger_test_delete_me values ('s100:', clock_timestamp());
-- RAISE NOTICE 's100 :%', clock_timestamp() ;
EXECUTE s101 ;
-- insert into trigger_test_delete_me values ('s101:', clock_timestamp());
---- RAISE NOTICE 's101 :%', clock_timestamp() ;
EXECUTE s102 ;
-- insert into trigger_test_delete_me values ('s102:', clock_timestamp());
---- RAISE NOTICE 's102 :%', clock_timestamp() ;
EXECUTE s103 ;
-- insert into trigger_test_delete_me values ('s103:', clock_timestamp());
---- RAISE NOTICE 's103 :%', clock_timestamp() ;
EXECUTE s104 ;
-- insert into trigger_test_delete_me values ('s104:', clock_timestamp());
---- RAISE NOTICE 's104 :%', clock_timestamp() ;
EXECUTE s104_a ;
-- insert into trigger_test_delete_me values ('s104_a:', clock_timestamp());
---- RAISE NOTICE 's104_a :%', clock_timestamp() ;
EXECUTE s105 ;
-- insert into trigger_test_delete_me values ('s105:', clock_timestamp());
---- RAISE NOTICE 's105 :%', clock_timestamp() ;
EXECUTE s106 ;
-- insert into trigger_test_delete_me values ('s106:', clock_timestamp());
---- RAISE NOTICE 's106 :%', clock_timestamp() ;
EXECUTE s107 ;
-- insert into trigger_test_delete_me values ('s107:', clock_timestamp());
---- RAISE NOTICE 's107 :%', clock_timestamp() ;
EXECUTE s108 ;
-- insert into trigger_test_delete_me values ('s108:', clock_timestamp());
---- RAISE NOTICE 's108 :%', clock_timestamp() ;
EXECUTE s109 ;
-- insert into trigger_test_delete_me values ('s109:', clock_timestamp());
---- RAISE NOTICE 's109 :%', clock_timestamp() ;
EXECUTE s_pre_110_1;
-- insert into trigger_test_delete_me values ('s_pre_110_1:', clock_timestamp());
---- RAISE NOTICE 's_pre_110_1 :%', clock_timestamp() ;
EXECUTE s110 ;
-- insert into trigger_test_delete_me values ('s110:', clock_timestamp());
---- RAISE NOTICE 's110 :%', clock_timestamp() ;
EXECUTE s110_1;
-- insert into trigger_test_delete_me values ('s110_1:', clock_timestamp());
---- RAISE NOTICE 's110_1 :%', clock_timestamp() ;
EXECUTE s110_2;
-- insert into trigger_test_delete_me values ('s110_2:', clock_timestamp());
---- RAISE NOTICE 's110_2 :%', clock_timestamp() ;
EXECUTE s110_3;
-- insert into trigger_test_delete_me values ('s110_3:', clock_timestamp());
---- RAISE NOTICE 's110_3 :%', clock_timestamp() ;
EXECUTE s110_4;
-- insert into trigger_test_delete_me values ('s110_4:', clock_timestamp());
---- RAISE NOTICE 's110_4 :%', clock_timestamp() ;
EXECUTE s110_5;
-- insert into trigger_test_delete_me values ('s110_5:', clock_timestamp());
---- RAISE NOTICE 's110_5 :%', clock_timestamp() ;
EXECUTE s111 ;
-- insert into trigger_test_delete_me values ('s111:', clock_timestamp());
---- RAISE NOTICE 's111 :%', clock_timestamp() ;
--EXECUTE s112 ;
-- insert into trigger_test_delete_me values ('s112:', clock_timestamp());
EXECUTE s113 ;
-- insert into trigger_test_delete_me values ('s113:', clock_timestamp());
---- RAISE NOTICE 's113 :%', clock_timestamp() ;
EXECUTE s113_1 ;
-- insert into trigger_test_delete_me values ('s113_1:', clock_timestamp());
---- RAISE NOTICE 's113_1 :%', clock_timestamp() ;
EXECUTE s113_2 ;
-- insert into trigger_test_delete_me values ('s113_2:', clock_timestamp());
---- RAISE NOTICE 's113_2 :%', clock_timestamp() ;
EXECUTE s114 ;
-- insert into trigger_test_delete_me values ('s114:', clock_timestamp());
-- RAISE NOTICE 's114 :%', clock_timestamp() ;
EXECUTE s115 ;
-- insert into trigger_test_delete_me values ('s115:', clock_timestamp());
-- RAISE NOTICE 's115 :%', clock_timestamp() ;

OPEN added_prods FOR EXECUTE s43_1;

RAISE NOTICE 'Marked Cart as isProcessed:%', 'START:'|| now();


 RETURN added_prods;

END;
$_$;


ALTER FUNCTION public.add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2017 (class 1255 OID 67697780)
-- Name: after_add_to_assortment(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN

 RETURN;

END;
$$;


ALTER FUNCTION public.after_add_to_assortment(input_jsessionid text, scope_product text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2018 (class 1255 OID 67697781)
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
      (select slsstart from loft_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strclimate)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','),
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM loft_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 2019 (class 1255 OID 67697782)
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
  scWeekCount_pub = (select COUNT(*) from loft_p_dc_adj 
   where product = stylecolorId 
   and location = (select dc from loft_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from loft_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from loft_p_dc_adj_size
   where product in (select id from loft_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from loft_l_dclookup where channel = channelId)
   and (dc_onorder > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 2020 (class 1255 OID 67697783)
-- Name: cc_channel_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_channel_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    loft_ma_stylecolorchannelattributes
  SET
     dbt_wk = NEW.dbt_wk
   , relaunchweek = NEW.relaunchweek
   , erlstmkdnwk = NEW.erlstmkdnwk
   , exitdate = NEW.exitdate
   , initrcptwk = NEW.initrcptwk
   , last_inv_wk = NEW.last_inv_wk
   , lstfpwk = NEW.lstfpwk
   , last_rcpt_wk = NEW.last_rcpt_wk
   , act_initrcptwk = NEW.act_initrcptwk
   , act_dbt_wk = NEW.act_dbt_wk
   , plannedselldnwk = NEW.plannedselldnwk

   -- , ccmdstrategy = NEW.ccmdstrategy
   -- , cc_ordermultiple = NEW.cc_ordermultiple
   -- , cc_ordermin = NEW.cc_ordermin
   -- , cc_discount_pct = NEW.cc_discount_pct
   -- , cc_discount_pct_ecom = NEW.cc_discount_pct_ecom
   -- , auto_rollforward = NEW.auto_rollforward
   -- , ccticketpricechannel = NEW.ccticketpricechannel
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
  ;

/*    
  UPDATE 
    loft_ma_stylecolorchannelattributes sc
  SET
     slsrnk_store = NEW.slsrnk_store
    ,slsrnk_ecom = NEW.slsrnk_ecom
    ,cc_plan_cost = NEW.cc_plan_cost
  WHERE
    missy_related_stylecolor = NEW.product
    and sc.product != NEW.product
    and record_state = 1
  ;

*/

  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
    and record_state = 0
    and product not in (select product from plan_queue where completed is null);


    drop table if exists temp_non_missy_stylecolors;
    create temporary table temp_non_missy_stylecolors as 
    select product from loft_ma_stylecolorchannelattributes where product != NEW.product and missy_related_stylecolor = NEW.product;



    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from loft_ma_dptflrsetattributes a, loft_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from loft_h_prodstd where id=NEW.product)
    and b.product != NEW.product and b.missy_related_stylecolor = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from loft_a_assortment a, loft_ma_dptflrsetattributes b, temp_non_missy_stylecolors c, loft_h_prodstd d
    where c.product = d.id and b.product = d.ancestor3
    and a.product= c.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from loft_a_assortment where product in (select product from temp_non_missy_stylecolors) and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update loft_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from loft_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from loft_a_assortment a 
          join (select c.time,slsstart,slsend from loft_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product in (select product from temp_non_missy_stylecolors)) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where loft_a_assortment.time=filtered.time and loft_a_assortment.product=filtered.product;

  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cc_channel_copy_master_attributes() OWNER TO psql;

--
-- TOC entry 2021 (class 1255 OID 67697784)
-- Name: cc_channel_copy_master_attributes_without_lifecycle(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    loft_ma_stylecolorchannelattributes
  SET
   --   dbt_wk = NEW.dbt_wk
   -- , relaunchweek = NEW.relaunchweek
   -- , erlstmkdnwk = NEW.erlstmkdnwk
   -- , exitdate = NEW.exitdate
   -- , initrcptwk = NEW.initrcptwk
   -- , last_inv_wk = NEW.last_inv_wk
   -- , lstfpwk = NEW.lstfpwk
   -- , last_rcpt_wk = NEW.last_rcpt_wk
   -- , act_initrcptwk = NEW.act_initrcptwk
   -- , act_dbt_wk = NEW.act_dbt_wk
   -- , plannedselldnwk = NEW.plannedselldnwk

     ccmdstrategy = NEW.ccmdstrategy
   , cc_ordermultiple = NEW.cc_ordermultiple
   , cc_ordermin = NEW.cc_ordermin
   , cc_discount_pct = NEW.cc_discount_pct
   , cc_discount_pct_ecom = NEW.cc_discount_pct_ecom
   , auto_rollforward = NEW.auto_rollforward
   , ccticketpricechannel = NEW.ccticketpricechannel
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
  ;

   
  UPDATE 
    loft_ma_stylecolorchannelattributes sc
  SET
     slsrnk_store = NEW.slsrnk_store
    ,slsrnk_ecom = NEW.slsrnk_ecom
    ,cc_plan_cost = NEW.cc_plan_cost
  WHERE
    missy_related_stylecolor = NEW.product
    and sc.product != NEW.product
    and record_state = 1
  ;

  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
    and record_state = 0
    and product not in (select product from plan_queue where completed is null);

/*

    drop table if exists temp_non_missy_stylecolors;
    create temporary table temp_non_missy_stylecolors as 
    select product from loft_ma_stylecolorchannelattributes where product != NEW.product and missy_related_stylecolor = NEW.product;



    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from loft_ma_dptflrsetattributes a, loft_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from loft_h_prodstd where id=NEW.product)
    and b.product != NEW.product and b.missy_related_stylecolor = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from loft_a_assortment a, loft_ma_dptflrsetattributes b, temp_non_missy_stylecolors c, loft_h_prodstd d
    where c.product = d.id and b.product = d.ancestor3
    and a.product= c.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from loft_a_assortment where product in (select product from temp_non_missy_stylecolors) and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update loft_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from loft_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from loft_a_assortment a 
          join (select c.time,slsstart,slsend from loft_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product in (select product from temp_non_missy_stylecolors)) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where loft_a_assortment.time=filtered.time and loft_a_assortment.product=filtered.product;
*/
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle() OWNER TO psql;

--
-- TOC entry 2022 (class 1255 OID 67697785)
-- Name: cc_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    loft_ma_stylecolorattributes
  SET
     cc_color_name = NEW.cc_color_name
    ,cc_ppns = NEW.cc_ppns
    ,cc_novelty_details = NEW.cc_novelty_details
    ,cc_print_description = NEW.cc_print_description
    ,cc_matchbacks = NEW.cc_matchbacks
    ,cc_free_one = NEW.cc_free_one
    ,cc_free_two = NEW.cc_free_two
    ,cc_free_three = NEW.cc_free_three
    ,cc_known = NEW.cc_known
    ,cc_collection = NEW.cc_collection
    ,cc_preview = NEW.cc_preview
    ,cc_marketing_flag = NEW.cc_marketing_flag
    ,cc_promotion_flag = NEW.cc_promotion_flag
    ,cc_table = NEW.cc_table
    ,cc_internet_tall_style = NEW.cc_internet_tall_style
    ,cc_price_band = NEW.cc_price_band
    ,cc_good_better_best = NEW.cc_good_better_best
    ,cc_lifecycle = NEW.cc_lifecycle
    ,cc_fabric_description = NEW.cc_fabric_description
    ,cc_print_pattern_type = NEW.cc_print_pattern_type
  WHERE
    cc_missy_related_stylecolor = NEW.product
    and product != NEW.product
  ;
    
  UPDATE 
    loft_ma_stylecolorattributes sc
  SET
     cc_climate_product = NEW.cc_climate_product
    ,cc_primary_selling = NEW.cc_primary_selling
    ,cc_online_exclusive_flag = NEW.cc_online_exclusive_flag
    ,cc_delivery_month = NEW.cc_delivery_month
    ,cc_delivery_name = NEW.cc_delivery_name
    ,cc_storeset = NEW.cc_storeset
    ,cc_season = NEW.cc_season
  FROM loft_ma_stylecolorchannelattributes a
  WHERE
    cc_missy_related_stylecolor = NEW.product
    and sc.product = a.product
    and sc.product != NEW.product
    and a.record_state = 1
  ;

  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
    and record_state = 0
    and product not in (select product from plan_queue where completed is null);
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cc_copy_master_attributes() OWNER TO psql;

--
-- TOC entry 2023 (class 1255 OID 67697786)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          UPDATE loft_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2024 (class 1255 OID 67697787)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from loft_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 2025 (class 1255 OID 67697788)
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
-- TOC entry 2026 (class 1255 OID 67697789)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE loft_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2027 (class 1255 OID 67697790)
-- Name: fetch_store_count(text, text, text[], text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
 DECLARE
  sls_start     text;
  dept_var      text;
 BEGIN

 select ancestor3 into dept_var
 from loft_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from loft_ma_dptflrsetattributes a
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
            loft_l_storelookup
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
            loft_l_storelookup
          WHERE
            time = sls_start
            AND product = dept_var
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as gr
    ) as gr USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.fetch_store_count(productid text, floorsetid text, str_grade text[], str_climate text[]) OWNER TO psql;

--
-- TOC entry 2028 (class 1255 OID 67697791)
-- Name: fn_sync_is_approved(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.fn_sync_is_approved() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only act when the value actually changes, and avoid recursion
  IF TG_OP = 'UPDATE'
     -- AND NEW.is_analytics_approved IS DISTINCT FROM OLD.is_analytics_approved
    AND pg_trigger_depth() < 2
  THEN
    UPDATE public.loft_p_subclass_channel_floorset_pssr_infomap t
       SET is_analytics_approved = NEW.is_analytics_approved,
           updated_at = date_trunc('sec', CURRENT_TIMESTAMP),
           updated_by = COALESCE(current_user::text, 'system')
     WHERE t.product = NEW.product
       AND t."time" = NEW."time"
       AND t.location = NEW.location;
       -- Update only rows that actually need a change
       -- AND t.is_analytics_approved IS DISTINCT FROM NEW.is_analytics_approved;
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_sync_is_approved() OWNER TO psql;

--
-- TOC entry 2029 (class 1255 OID 67697792)
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
          , planned_lof_week
          , too
          , mkdnwks
          , erlstmkdnwk
          , exitdate
          , ccmdstrategy
          , presmin
          , retpct_str
          , retpct_ecomm
          , retpct_cross
          , presmin_weeks
          , ccrcptint
          , ccordermultiple
          , slsrnk_store
          , slsrnk_ecom
          , sty_size_type
          , sty_size_range
          , class
        )
        SELECT distinct
            '''||$1||''','''||$2||''','''||$3||''','''||$4||''','''||$5||'''
          , initialrcptwk
          , default_dbt_wk
          , default_planned_lof_wk
          , default_too
          , default_mkdnwks
          , default_erlstmkdnwk
          , default_exitdate
          , default_ccmdstrategy
          , default_size_min
          , default_retpct_str
          , default_retpct_ecomm
          , default_retpct_cross
          , default_presmin_weeks
          , default_ccrcptint
          , default_ccordermultiple
          , 3
          , 3
          , b.sty_size_type
          , c.master_style_size_range_id
          , d.name
        FROM 
          loft_ma_dptflrsetattributes, (select ''MISSY'' as sty_size_type from loft_v_memberbasedvalidvalues where attributeid = ''sty_size_type'' limit 1) b, (select master_style_size_range_id, master_style_class as class from loft_l_size_concept_lookups where department = '''||$2||''' order by master_style_class asc limit 1) c, (select id, name from loft_d_product where id in (select id from loft_h_prodstd where ancestor0 = '''||$2||''')) d
        WHERE 
          product = '''||$2||'''
          and time = '''||$5||'''
          and d.id = c.class
          ';
  delete_s3 := ' 
     delete from cart_ranging where jsessionid = '''||$1||''' and scope_product='''||$2||''' 
     and scope_start = '''||$4||''' and scope_floorset = '''||$5||'''  
             ';
  insert_s4 := '
  insert into cart_ranging 
(jsessionid,scope_product,scope_location,scope_start,scope_floorset
   ,str_climate,str_grade,ssg,flnrange,isfunded, indx, store_count)
select 
  '''||$1||''',product,'''||$3||''','''||$4||''',time, 
    case when cardinality(default_strclimate) = 0 then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else  default_strclimate end as default_strclimate
  , case when cardinality(default_grade) = 0 then ''{NA,1,2,3,4,5,ECOM}'' else  default_grade end as default_grade
  , default_ssg
  , default_flnrange
  , isfunded
  , indx
        , store_count
  FROM (
  select product, time,default_strclimate,default_grade,default_ssg,default_flnrange
   ,1 as isfunded, a.indx, get_store_count('''||$4||''', case when cardinality(default_strclimate) = 0 then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else default_strclimate end, case when cardinality(default_grade) = 0 then ''{NA,1,2,3,4,5,ECOM}'' else  default_grade end, product) as store_count
  FROM loft_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from loft_serviceparams where id=''plan_current'') c,
   (select value as plan_end from loft_serviceparams where id=''plan_end'') d
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
 RETURN;
END;
$_$;


ALTER FUNCTION public.get_default_params(input_jsessionid text, scope_department text, scope_location text, scope_start text, scope_floorset text) OWNER TO psql;

--
-- TOC entry 2030 (class 1255 OID 67697793)
-- Name: get_store_count(text, text[], text[], text); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.get_store_count(week text, str_climate text[], str_grade text[], productval text) RETURNS integer
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
            loft_l_storelookup
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
            loft_l_storelookup
          WHERE
            time = week
            AND product = productVal
            AND id = 'str_grade'
            AND value = ANY( str_grade )
        ) as gr
    ) as gr USING (store)
  )
 );
 END;
$$;


ALTER FUNCTION public.get_store_count(week text, str_climate text[], str_grade text[], productval text) OWNER TO psql;

--
-- TOC entry 2031 (class 1255 OID 67697794)
-- Name: insert_stylecolorfloorsetattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.insert_stylecolorfloorsetattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
v_count integer;
BEGIN
  --RAISE NOTICE 'inside insert_stylecolorfloorsetattributes :%', clock_timestamp() ;
  select count(*) into v_count from loft_ma_stylecolorfloorsetattributes where product = NEW.product and time = NEW.time;
  IF v_count = 0
  THEN
      INSERT INTO loft_ma_stylecolorfloorsetattributes (product,time)
      VALUES (NEW.product, NEW.time);
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.insert_stylecolorfloorsetattributes() OWNER TO psql;

--
-- TOC entry 2032 (class 1255 OID 67697795)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from loft_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 2033 (class 1255 OID 67697796)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

update loft_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update loft_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from loft_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 2034 (class 1255 OID 67697797)
-- Name: loft_no_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.loft_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

DROP TABLE IF EXISTS loft_style_clone_flat_map_temp;
DROP TABLE IF EXISTS loft_style_clone_flat_map_temp_size_concept;    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE loft_style_clone_flat_map_temp AS
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND to_new_style = clone_new_master_style
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO loft_d_product (
            id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
        )
        SELECT DISTINCT 
            to_id,
            null as client_id,
            CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END,
            CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END,
            a.levelid,
            indx,       
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_d_product b
        WHERE a.from_id = b.id
        ON CONFLICT (id) DO NOTHING
        ;

/*
    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

*/
    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
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
    
        INSERT INTO loft_ma_styleattributes (
            product,
            style_description,
            sty_article_description,
            sty_coordination_article,
            sty_end_use,
            sty_fabric_profile,
            sty_fit,
            sty_hemline_detail,
            sty_length,
            sty_merch_category,
            sty_merch_group,
            sty_merchandise_dept,
            sty_mfp_program_id,
            sty_missy_petite_nonapparel,
            sty_missy_related_style,
            sty_neckline,
            sty_pyramid_lens,
            sty_shape,
            sty_silhouette,
            sty_size_range,
            sty_size_type,
            sty_sleeve_length,
            ccstylecreatedate,
            sty_third_party,
            sty_type,
            sty_vendor_style_description,
            sty_fabric_description,
            sty_accessory_measurements,
            sty_adhoc,
            sty_finish,
            sty_gauge,
            sty_placement,
            sty_program_id,
            sty_texture,
            sty_tech_design_garment_content,
            sty_tech_design_stretch_level,
            sty_tech_design_closure,
            sty_tech_design_fit_block,
            sty_tech_design_fit_intent,
            sty_tech_design_leg_shape,
            sty_tech_design_length,
            sty_tech_design_placement,
            sty_tech_design_rise,
            sty_tech_design_type,
            sty_bellyband,
            sty_boxed_packaging,
            sty_fit_description,
            sty_hangtag_1,
            sty_hangtag_2,
            sty_jewelry_cards,
            sty_joker_matchbook,
            sty_main_label,
            sty_retail_ticket_type,
            sty_size_sticker,
            sty_stylenumber_name,
            sty_size_concepts,
            sty_size_concept_types,
            sty_specstyleid,
            sty_missy_related_style_bbr,
            sty_size_range_bbr,
            sty_size_type_bbr,
            sty_price_bands,
            sty_good_better_best,
            sty_material,
            sty_primary_material_bbr,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            sty_fabric_description_free_text,
            sty_num_clones_s5,
            sty_num_times_cloned_s5
        )
        SELECT
            to_id,
            style_description,
            sty_article_description,
            sty_coordination_article,
            sty_end_use,
            sty_fabric_profile,
            sty_fit,
            sty_hemline_detail,
            sty_length,
            sty_merch_category,
            sty_merch_group,
            sty_merchandise_dept,
            sty_mfp_program_id,
            sty_missy_petite_nonapparel,
            to_id as sty_missy_related_style,
            sty_neckline,
            sty_pyramid_lens,
            sty_shape,
            sty_silhouette,
            sty_size_range,
            sty_size_type,
            sty_sleeve_length,
            null as ccstylecreatedate,
            sty_third_party,
            sty_type,
            sty_vendor_style_description,
            sty_fabric_description,
            sty_accessory_measurements,
            sty_adhoc,
            sty_finish,
            sty_gauge,
            sty_placement,
            sty_program_id,
            sty_texture,
            sty_tech_design_garment_content,
            sty_tech_design_stretch_level,
            sty_tech_design_closure,
            sty_tech_design_fit_block,
            sty_tech_design_fit_intent,
            sty_tech_design_leg_shape,
            sty_tech_design_length,
            sty_tech_design_placement,
            sty_tech_design_rise,
            sty_tech_design_type,
            sty_bellyband,
            sty_boxed_packaging,
            sty_fit_description,
            sty_hangtag_1,
            sty_hangtag_2,
            sty_jewelry_cards,
            sty_joker_matchbook,
            sty_main_label,
            sty_retail_ticket_type,
            sty_size_sticker,
            sty_stylenumber_name,
            null as sty_size_concepts,
            null as sty_size_concept_types,
            null as sty_specstyleid,
            null as sty_missy_related_style_bbr,
            sty_size_range_bbr,
            sty_size_type_bbr,
            sty_price_bands,
            sty_good_better_best,
            sty_material,
            sty_primary_material_bbr,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            null as sty_fabric_description_free_text,
            null as sty_num_clones_s5,
            null as sty_num_times_cloned_s5
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
*/   
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_ma_stylecolorattributes (
            product,
            cc_stylecolor_description,
            cccolor,
            cc_color_id,
            cc_color_name,
            cccolorfamily,
            cc_color_type,
            cc_climate_product,
            cc_collection,
            cc_delivery_name,
            cc_fabric_description,
            cc_good_better_best,
            cc_internet_tall_style,
            cc_known,
            cc_lifecycle,
            cc_marketing_flag,
            cc_matchbacks,
            cc_novelty_details,
            cc_novelty,
            cc_online_exclusive_flag,
            cc_opus,
            cc_preview,
            cc_ppns,
            cc_price_band,
            cc_primary_selling,
            cc_print_description,
            cc_print_pattern_type,
            cc_promotion_flag,
            cc_season,
            cc_storeset,
            cc_table,
            ccstylecolorcreatedate,
            cc_delivery_month,
            cc_stylecolornumber_name,
            department_name,
            class_name,
            subclass_name,
            cc_specstyle_cccolor,
            cc_specstylecolorid,
            plan_comments,
            merch_comments,
            cc_free_one,
            cc_free_two,
            cc_free_three,
            cc_brand_concept,
            cc_ecom_exclusives,
            isassortment,
            cc_missy_related_stylecolor,
            cc_size_concepts_in_assortment,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            cc_floorset,
            cc_use_sys_floorset,
            cc_storeset_period,
            cc_num_clones_s5,
            cc_num_times_cloned_s5
        )
        SELECT
            to_id,
            cc_stylecolor_description,
            a.cccolor,
            'ZZZTBD' as cc_color_id,
            'ZZZTBD' as cc_color_name,
            a.cccolorfamily,
            cc_color_type,
            cc_climate_product,
            cc_collection,
            cc_delivery_name,
            cc_fabric_description,
            cc_good_better_best,
            cc_internet_tall_style,
            cc_known,
            cc_lifecycle,
            cc_marketing_flag,
            cc_matchbacks,
            cc_novelty_details,
            cc_novelty,
            cc_online_exclusive_flag,
            cc_opus,
            cc_preview,
            cc_ppns,
            cc_price_band,
            cc_primary_selling,
            cc_print_description,
            cc_print_pattern_type,
            cc_promotion_flag,
            cc_season,
            cc_storeset,
            cc_table,
            null as ccstylecolorcreatedate,
            cc_delivery_month,
            cc_stylecolornumber_name,
            department_name,
            class_name,
            subclass_name,
            null as cc_specstyle_cccolor,
            null as cc_specstylecolorid,
            null as plan_comments,
            null as merch_comments,
            cc_free_one,
            cc_free_two,
            cc_free_three,
            cc_brand_concept,
            cc_ecom_exclusives,
            isassortment,
            to_id as cc_missy_related_stylecolor,
            '{}' as cc_size_concepts_in_assortment,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            cc_floorset,
            cc_use_sys_floorset,
            cc_storeset_period,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_ma_sizeattributes (
            product,
            parent_id,
            size_id,
            sizeattribute,
            ticket_size,
            size_desc,
            size_range,
            sku_create_date,
            original_price,
            current_price,
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
            size_id,
            sizeattribute,
            ticket_size,
            size_desc,
            size_range,
            null as sku_create_date,
            original_price,
            current_price,
            isvalid,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_ma_stylecolorchannelattributes (
            product,
            missy_related_stylecolor,
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
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            ccticketpricechannel_override_txt,
            act_slsrnk_store,
            act_slsrnk_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            cc_discount_pct_ecom,
            sclr_presmin_stores,
            sclr_presmin_ecom,
            arr_all_sizes_for_mins,
            sizemin_store,
            sizemin_ecom,
            cloned_at
        )
        SELECT
            to_id,
            missy_related_stylecolor,
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            1 as record_state,
            ccticketpricechannel_override_txt,
            act_slsrnk_store,
            act_slsrnk_ecom,
            null as cc_first_publish_date,
            null as cc_first_publish_snapshot_op,
            cc_discount_pct_ecom,
            sclr_presmin_stores,
            sclr_presmin_ecom,
            arr_all_sizes_for_mins,
            sizemin_store,
            sizemin_ecom,
            date_trunc('second', now()) as cloned_at         
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_ma_imgattributes (
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_p_itemprice (
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
            addoff_ecom
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            addoff_ecom
        FROM loft_style_clone_flat_map_temp a,
             loft_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_p_channeloverride (
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
            comments,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            testpo,
            floorsetpo
        FROM loft_style_clone_flat_map_temp a,
             loft_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_a_assortment (
            product,
            location,
            time,
            style,
            str_climate,
            str_grade,
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
            record_state
        )
        SELECT
            to_id,
            location,
            time,
            style,
            str_climate,
            str_grade,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_p_dc_adj (
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
            dc_sc_finrev_ecom,
            dc_adjcost_ecom,
            fc_dc_finalqty_u_store,
            fc_dc_finalqty_r_store,
            fc_dc_finalqty_c_store,
            fc_dc_finalqty_u_ecom,
            fc_dc_finalqty_r_ecom,
            fc_dc_finalqty_c_ecom,
            lastpub_dc_finalqty_u_store,
            lastpub_dc_finalqty_r_store,
            lastpub_dc_finalqty_c_store,
            lastpub_dc_finalqty_u_ecom,
            lastpub_dc_finalqty_r_ecom,
            lastpub_dc_finalqty_c_ecom,
            lastpub_published_at,
            lastpub_published_user
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,
            null as is_locked,
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as po_indicator_ecom,
            null as po_shipmode_ecom,
            null as air_trigger_ecom,
            null as cut_ecom,
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
            dc_sc_finrev_ecom,
            dc_adjcost_ecom,
            fc_dc_finalqty_u_store,
            fc_dc_finalqty_r_store,
            fc_dc_finalqty_c_store,
            fc_dc_finalqty_u_ecom,
            fc_dc_finalqty_r_ecom,
            fc_dc_finalqty_c_ecom,
            null as lastpub_dc_finalqty_u_store,
            null as lastpub_dc_finalqty_r_store,
            null as lastpub_dc_finalqty_c_store,
            null as lastpub_dc_finalqty_u_ecom,
            null as lastpub_dc_finalqty_r_ecom,
            null as lastpub_dc_finalqty_c_ecom,
            null as lastpub_published_at,
            null as lastpub_published_user
        FROM loft_style_clone_flat_map_temp a,
             loft_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO loft_p_dc_adj_size (
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
            dc_adjcost_ecom
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            null as dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom,
            dc_adjcost_ecom
        FROM loft_style_clone_stylecolor_size a,
             loft_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO loft_an_price_storecount_info (
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
            flow_flag,
            corpexcl_ecom,
            addoff_ecom,
            corpaddoff_ecom,
            v_a_ecom,
            v_b_ecom,
            cc_discount_pct_ecom,
            selling_price_ecom
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
            flow_flag,
            corpexcl_ecom,
            addoff_ecom,
            corpaddoff_ecom,
            v_a_ecom,
            v_b_ecom,
            cc_discount_pct_ecom,
            selling_price_ecom
        FROM loft_style_clone_flat_map_temp a,
             loft_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
/*
        INSERT INTO loft_l_dependencylookup (
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
        FROM loft_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';
*/

        INSERT INTO loft_l_dependencylookup (
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
        FROM loft_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';

    --------------------------------------------------------------------
    -- SIZE CONCEPT CLONING SECTION
    -- This section creates clones for related size types (PETITE, TALL,
    -- CURVY_PETITE, CURVY_TALL) based on the master style's existing
    --------------------------------------------------------------------

    --------------------------------------------------------------------
    -- Build temp table for size concept mapping
    -- This maps existing size concept relationships from source styles
    -- to create new size concept styles for cloned masters
    --------------------------------------------------------------------

     CREATE TEMPORARY TABLE loft_style_clone_flat_map_temp_size_concept AS
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
            , clone_new_master_style
            , '' as clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND to_new_style <> clone_new_master_style
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
            , clone_new_master_style
            , clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
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
            , '' as clone_new_master_style
            , '' as clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;

    --------------------------------------------------------------------
    -- d_product insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_d_product (
        id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
    )
    SELECT DISTINCT
        to_id,
        null as client_id,
        CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END,
        CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END,
        a.levelid,
        indx,
        now()::date as eventdate,
        version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        record_state
    FROM loft_style_clone_flat_map_temp_size_concept a,
         loft_d_product b
    WHERE a.from_id = b.id
    ON CONFLICT (id) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert for size concepts
    -- Sets sty_missy_related_style to point to the NEW master style
    -- Uses related size_range and size_type from lookup table
    --------------------------------------------------------------------
    /*
    INSERT INTO loft_ma_styleattributes (
        product,
        style_description,
        sty_article_description,
        sty_coordination_article,
        sty_end_use,
        sty_fabric_profile,
        sty_fit,
        sty_hemline_detail,
        sty_length,
        sty_merch_category,
        sty_merch_group,
        sty_merchandise_dept,
        sty_mfp_program_id,
        sty_missy_petite_nonapparel,
        sty_missy_related_style,
        sty_neckline,
        sty_pyramid_lens,
        sty_shape,
        sty_silhouette,
        sty_size_range,
        sty_size_type,
        sty_sleeve_length,
        ccstylecreatedate,
        sty_third_party,
        sty_type,
        sty_vendor_style_description,
        sty_fabric_description,
        sty_accessory_measurements,
        sty_adhoc,
        sty_finish,
        sty_gauge,
        sty_placement,
        sty_program_id,
        sty_texture,
        sty_tech_design_garment_content,
        sty_tech_design_stretch_level,
        sty_tech_design_closure,
        sty_tech_design_fit_block,
        sty_tech_design_fit_intent,
        sty_tech_design_leg_shape,
        sty_tech_design_length,
        sty_tech_design_placement,
        sty_tech_design_rise,
        sty_tech_design_type,
        sty_bellyband,
        sty_boxed_packaging,
        sty_fit_description,
        sty_hangtag_1,
        sty_hangtag_2,
        sty_jewelry_cards,
        sty_joker_matchbook,
        sty_main_label,
        sty_retail_ticket_type,
        sty_size_sticker,
        sty_stylenumber_name,
        sty_size_concepts,
        sty_size_concept_types,
        sty_specstyleid,
        sty_missy_related_style_bbr,
        sty_size_range_bbr,
        sty_size_type_bbr,
        sty_price_bands,
        sty_good_better_best,
        sty_material,
        sty_primary_material_bbr,
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        sty_fabric_description_free_text,
        sty_num_clones_s5,
        sty_num_times_cloned_s5
    )
    SELECT
        a.to_id,
        b.style_description,
        b.sty_article_description,
        b.sty_coordination_article,
        b.sty_end_use,
        b.sty_fabric_profile,
        b.sty_fit,
        b.sty_hemline_detail,
        b.sty_length,
        b.sty_merch_category,
        b.sty_merch_group,
        b.sty_merchandise_dept,
        b.sty_mfp_program_id,
        b.sty_missy_petite_nonapparel,
        -- sty_missy_related_style points to the NEW master style (not the old one)
        a.clone_new_master_style as sty_missy_related_style,
        b.sty_neckline,
        b.sty_pyramid_lens,
        b.sty_shape,
        b.sty_silhouette,
        -- Use the related size range from lookup, or keep original if not found
        b.sty_size_range as sty_size_range,
        -- Use the related size type
        b.sty_size_type as sty_size_type,
        b.sty_sleeve_length,
        null as ccstylecreatedate,
        b.sty_third_party,
        b.sty_type,
        b.sty_vendor_style_description,
        b.sty_fabric_description,
        b.sty_accessory_measurements,
        b.sty_adhoc,
        b.sty_finish,
        b.sty_gauge,
        b.sty_placement,
        b.sty_program_id,
        b.sty_texture,
        b.sty_tech_design_garment_content,
        b.sty_tech_design_stretch_level,
        b.sty_tech_design_closure,
        b.sty_tech_design_fit_block,
        b.sty_tech_design_fit_intent,
        b.sty_tech_design_leg_shape,
        b.sty_tech_design_length,
        b.sty_tech_design_placement,
        b.sty_tech_design_rise,
        b.sty_tech_design_type,
        b.sty_bellyband,
        b.sty_boxed_packaging,
        b.sty_fit_description,
        b.sty_hangtag_1,
        b.sty_hangtag_2,
        b.sty_jewelry_cards,
        b.sty_joker_matchbook,
        b.sty_main_label,
        b.sty_retail_ticket_type,
        b.sty_size_sticker,
        b.sty_stylenumber_name,
        '{}' as sty_size_concepts,
        '{}' as sty_size_concept_types,
        null as sty_specstyleid,
        null as sty_missy_related_style_bbr,
        b.sty_size_range_bbr,
        b.sty_size_type_bbr,
        b.sty_price_bands,
        b.sty_good_better_best,
        b.sty_material,
        b.sty_primary_material_bbr,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --setting the record state to 1 so the size concept is not in assortment
        1 as record_state,
        null as sty_fabric_description_free_text,
        null as sty_num_clones_s5,
        null as sty_num_times_cloned_s5
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_styleattributes b ON a.from_id = b.product
    WHERE a.levelid = 'style'
    ON CONFLICT (product) DO NOTHING;

*/
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert for size concepts
    -- cc_missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO loft_ma_stylecolorattributes (
        product,
        cc_stylecolor_description,
        cccolor,
        cc_color_id,
        cc_color_name,
        cccolorfamily,
        cc_color_type,
        cc_climate_product,
        cc_collection,
        cc_delivery_name,
        cc_fabric_description,
        cc_good_better_best,
        cc_internet_tall_style,
        cc_known,
        cc_lifecycle,
        cc_marketing_flag,
        cc_matchbacks,
        cc_novelty_details,
        cc_novelty,
        cc_online_exclusive_flag,
        cc_opus,
        cc_preview,
        cc_ppns,
        cc_price_band,
        cc_primary_selling,
        cc_print_description,
        cc_print_pattern_type,
        cc_promotion_flag,
        cc_season,
        cc_storeset,
        cc_table,
        ccstylecolorcreatedate,
        cc_delivery_month,
        cc_stylecolornumber_name,
        department_name,
        class_name,
        subclass_name,
        cc_specstyle_cccolor,
        cc_specstylecolorid,
        plan_comments,
        merch_comments,
        cc_free_one,
        cc_free_two,
        cc_free_three,
        cc_brand_concept,
        cc_ecom_exclusives,
        isassortment,
        cc_missy_related_stylecolor,
        cc_size_concepts_in_assortment,
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        cc_floorset,
        cc_use_sys_floorset,
        cc_storeset_period,
        cc_num_clones_s5,
        cc_num_times_cloned_s5
    )
    SELECT
        a.to_id,
        /*These might need to be modified to hold the values from the a record since we might want to inherit the values from the cloning screen, unsure */
        b.cc_stylecolor_description,
        b.cccolor,
        b.cc_color_id,
        b.cc_color_name,
        b.cccolorfamily,
        b.cc_color_type,
        b.cc_climate_product,
        b.cc_collection,
        b.cc_delivery_name,
        b.cc_fabric_description,
        b.cc_good_better_best,
        b.cc_internet_tall_style,
        b.cc_known,
        b.cc_lifecycle,
        b.cc_marketing_flag,
        b.cc_matchbacks,
        b.cc_novelty_details,
        b.cc_novelty,
        b.cc_online_exclusive_flag,
        b.cc_opus,
        b.cc_preview,
        b.cc_ppns,
        b.cc_price_band,
        b.cc_primary_selling,
        b.cc_print_description,
        b.cc_print_pattern_type,
        b.cc_promotion_flag,
        b.cc_season,
        b.cc_storeset,
        b.cc_table,
        null as ccstylecolorcreatedate,
        b.cc_delivery_month,
        b.cc_stylecolornumber_name,
        b.department_name,
        b.class_name,
        b.subclass_name,
        null as cc_specstyle_cccolor,
        null as cc_specstylecolorid,
        null as plan_comments,
        null as merch_comments,
        b.cc_free_one,
        b.cc_free_two,
        b.cc_free_three,
        b.cc_brand_concept,
        b.cc_ecom_exclusives,
        b.isassortment,
        -- cc_missy_related_stylecolor points to the NEW master stylecolor
        a.clone_new_master_stylecolor as cc_missy_related_stylecolor,
        '{}' as cc_size_concepts_in_assortment,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 so the item is not in assortment 
        1 as record_state,
        b.cc_floorset,
        b.cc_use_sys_floorset,
        b.cc_storeset_period,
        null as cc_num_clones_s5,
        null as cc_num_times_cloned_s5
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_stylecolorattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert for size concepts
    -- Uses related size_range from lookup table
    --------------------------------------------------------------------

/*
    INSERT INTO loft_ma_sizeattributes (
        product,
        parent_id,
        size_id,
        sizeattribute,
        ticket_size,
        size_desc,
        size_range,
        sku_create_date,
        original_price,
        current_price,
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
        a.to_id,
        -- parent_id should be the new stylecolor
        (SELECT sc.to_id
         FROM loft_style_clone_flat_map_temp_size_concept sc
         WHERE sc.levelid = 'stylecolor'
           AND sc.related_size_type = a.related_size_type
           AND sc.session_id = a.session_id
           AND sc.clone_ordinal = a.clone_ordinal
         LIMIT 1) as parent_id,
        b.size_id,
        b.sizeattribute,
        b.ticket_size,
        b.size_desc,
        -- Use related size_range from lookup if available
        b.size_range as size_range,
        null as sku_create_date,
        b.original_price,
        b.current_price,
        b.isvalid,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        b.record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_sizeattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product) DO NOTHING;
    */


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert for size concepts
    -- missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO loft_ma_stylecolorchannelattributes (
        product,
        missy_related_stylecolor,
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
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        ccticketpricechannel_override_txt,
        act_slsrnk_store,
        act_slsrnk_ecom,
        cc_first_publish_date,
        cc_first_publish_snapshot_op,
        cc_discount_pct_ecom,
        sclr_presmin_stores,
        sclr_presmin_ecom,
        arr_all_sizes_for_mins,
        sizemin_store,
        sizemin_ecom,
        cloned_at
    )
    SELECT
        a.to_id,
        -- missy_related_stylecolor points to the NEW cloned master stylecolor, so we take our generated id and remove PETITE/TALL to get the cloned master stylecolor
        a.clone_new_master_stylecolor as cc_missy_related_stylecolor,
        b.location,
        b.dbt_wk,
        b.relaunchweek,
        b.erlstmkdnwk,
        b.exitdate,
        b.initrcptwk,
        b.too,
        b.mkdnwks,
        b.last_inv_wk,
        b.lstfpwk,
        b.last_rcpt_wk,
        b.lastdcorder,
        b.act_initrcptwk,
        b.act_dbt_wk,
        b.irw_indx,
        b.dbtwk_indx,
        b.relaunchwk_indx,
        b.mdstart_indx,
        b.lastdcorder_indx,
        b.exitdate_indx,
        b.preview_wks,
        b.preview_qty,
        b.plannedselldnwk,
        b.ccmdstrategy,
        b.slsrnk_store,
        b.slsrnk_ecom,
        b.validsizes,
        b.cc_validsizes_store,
        b.cc_validsizes_ecom,
        b.ccrangecode,
        b.cc_presmin,
        b.cc_presmin_weeks,
        b.cc_rcptint,
        b.cc_return_u_pct_store,
        b.cc_return_u_pct_ecom,
        b.cc_return_u_pct_cross,
        b.cc_ordermultiple,
        b.cc_ordermin,
        b.cc_buy_aps_letter,
        b.ccticketpricechannel,
        b.ccticketpricechannel_override,
        b.cc_imupct,
        b.cc_discount_pct,
        b.cc_existingwac,
        b.cc_systemcost,
        b.cc_plan_cost,
        b.ssnprf,
        b.adjaps_store,
        b.adjaps_ecom,
        b.smoothing_strategy,
        b.in_season_flag,
        b.auto_rollforward,
        b.irr_mode,
        b.plan_current,
        b.lock_agg_edit,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.ccticketpricechannel_override_txt,
        b.act_slsrnk_store,
        b.act_slsrnk_ecom,
        null as cc_first_publish_date,
        null as cc_first_publish_snapshot_op,
        b.cc_discount_pct_ecom,
        b.sclr_presmin_stores,
        b.sclr_presmin_ecom,
        b.arr_all_sizes_for_mins,
        b.sizemin_store,
        b.sizemin_ecom,
        date_trunc('second', now()) as cloned_at
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_stylecolorchannelattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location) DO NOTHING;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_ma_imgattributes (
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
        b.indx,
        a.to_id,
        b.img,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_imgattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- ITEMPRICE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_itemprice (
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
        addoff_ecom
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        b.addoff,
        b.eo,
        b.eff_aur,
        b.department,
        b.event,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.addoff_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_itemprice b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_channeloverride (
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
        a.to_id,
        b.location,
        b.time,
        b.weekadjaps,
        b.weekadjaps_ecom,
        b.weekadjslsu,
        b.weekadjslsu_ecom,
        b.comments,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.testpo,
        b.floorsetpo
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_channeloverride b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- ASSORTMENT insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_a_assortment (
        product,
        location,
        time,
        style,
        str_climate,
        str_grade,
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
        record_state
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        b.style,
        b.str_climate,
        b.str_grade,
        b.ssg,
        b.flnrange,
        b.plan_type,
        b.isfunded,
        b.store_count,
        b.propagate_ranging,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_a_assortment b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_dc_adj (
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
        dc_sc_finrev_ecom,
        dc_adjcost_ecom,
        fc_dc_finalqty_u_store,
        fc_dc_finalqty_r_store,
        fc_dc_finalqty_c_store,
        fc_dc_finalqty_u_ecom,
        fc_dc_finalqty_r_ecom,
        fc_dc_finalqty_c_ecom,
        lastpub_dc_finalqty_u_store,
        lastpub_dc_finalqty_r_store,
        lastpub_dc_finalqty_c_store,
        lastpub_dc_finalqty_u_ecom,
        lastpub_dc_finalqty_r_ecom,
        lastpub_dc_finalqty_c_ecom,
        lastpub_published_at,
        lastpub_published_user
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        null as dc_publish,
        b.is_locked,
        b.dc_uservrp,
        b.dc_lockedqty,
        b.dc_useradj,
        b.dc_onorder,
        b.dc_finrev,
        b.dc_validwk,
        b.dc_finalqty,
        b.dc_adjcost,
        b.const_y_n,
        b.sbkt,
        b.dc_isedited,
        b.dc_syscost,
        b.dc_lndcst,
        b.dc_sysvrp,
        b.dc_sc_useradj,
        b.dc_sc_finrev,
        b.po_indicator,
        b.po_shipmode,
        b.air_trigger,
        b.cut,
        null as published_at,
        null as is_prepublished,
        null as prepublished_at,
        null as last_prepublished,
        null as po_arr,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.dc_useradj_ecom,
        b.dc_onorder_ecom,
        b.dc_finrev_ecom,
        null as dc_publish_ecom,
        null as po_indicator_ecom,
        null as po_shipmode_ecom,
        null as air_trigger_ecom,
        null as cut_ecom,
        null as published_at_ecom,
        null as is_prepublished_ecom,
        null as prepublished_at_ecom,
        null as last_prepublished_ecom,
        b.reason_code,
        b.reason_code_ecom,
        b.pack_ind_flag,
        b.pack_ind_flag_ecom,
        b.show_in_pack,
        b.show_in_pack_ecom,
        b.dc_sc_finrev_ecom,
        b.dc_adjcost_ecom,
        b.fc_dc_finalqty_u_store,
        b.fc_dc_finalqty_r_store,
        b.fc_dc_finalqty_c_store,
        b.fc_dc_finalqty_u_ecom,
        b.fc_dc_finalqty_r_ecom,
        b.fc_dc_finalqty_c_ecom,
        null as lastpub_dc_finalqty_u_store,
        null as lastpub_dc_finalqty_r_store,
        null as lastpub_dc_finalqty_c_store,
        null as lastpub_dc_finalqty_u_ecom,
        null as lastpub_dc_finalqty_r_ecom,
        null as lastpub_dc_finalqty_c_ecom,
        null as lastpub_published_at,
        null as lastpub_published_user
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_dc_adj b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_dc_adj_size (
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
        dc_adjcost_ecom
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        null as dc_publish,
        b.is_locked,
        b.dc_uservrp,
        b.dc_lockedqty,
        b.dc_useradj,
        null as dc_onorder,
        b.dc_finrev,
        b.dc_validwk,
        b.dc_finalqty,
        b.dc_adjcost,
        b.const_y_n,
        b.sbkt,
        b.dc_scadj,
        b.dc_ttluseradj,
        b.dc_scfinrev,
        b.dc_ttlfinrev,
        b.dc_isedited,
        null as dc_onorder_v,
        null as dc_onorder_c,
        b.current_week,
        null as dc_last_pub_u,
        null as dc_last_pub,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.dc_useradj_ecom,
        null as dc_onorder_ecom,
        null as dc_onorder_v_ecom,
        null as dc_onorder_c_ecom,
        null as dc_finrev_ecom,
        null as dc_publish_ecom,
        null as dc_last_pub_u_ecom,
        null as dc_last_pub_ecom,
        b.dc_adjcost_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_dc_adj_size b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_an_price_storecount_info (
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
        flow_flag,
        corpexcl_ecom,
        addoff_ecom,
        corpaddoff_ecom,
        v_a_ecom,
        v_b_ecom,
        cc_discount_pct_ecom,
        selling_price_ecom
    )
    SELECT
        a.to_id,
        b.channel,
        b.time,
        b.selling_channel,
        b.isfunded,
        b.store_count,
        b.in_season_flag,
        b.dbt_wk_date,
        b.last_rcpt_wk_date,
        b.erlstmkdnwk_date,
        b.exitdate_date,
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
        b.v_a,
        b.v_b,
        b.ccdiscountpct,
        b.flow_flag,
        b.corpexcl_ecom,
        b.addoff_ecom,
        b.corpaddoff_ecom,
        b.v_a_ecom,
        b.v_b_ecom,
        b.cc_discount_pct_ecom,
        b.selling_price_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_an_price_storecount_info b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING;


/*
I am unsure if this code needs to be run in any way, but it is something that was similar in add to assortment
    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_l_dependencylookup (
        lookup_id,
        lookup_value,
        target_id,
        target_value
    )
    SELECT DISTINCT
        'style'    AS lookup_id,
        new_master_style_id    AS lookup_value,
        'patternedtostyle' AS target_id,
        to_id      AS target_value
    FROM loft_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'style';


    INSERT INTO loft_l_dependencylookup (
        lookup_id,
        lookup_value,
        target_id,
        target_value
    )
    SELECT DISTINCT
        'stylecolor' AS lookup_id,
        -- lookup_value should points to the NEW cloned master stylecolor, so we take our generated id and remove PETITE/TALL to get the cloned master stylecolor
        replace(a.to_id,Concat('_',a.related_size_type),'') AS lookup_value,
        'patternedtostylecolor' AS target_id,
        to_id        AS target_value
    FROM loft_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'stylecolor';

    --Untested
    --------------------------------------------------------------------
    -- Update master style's sty_size_concepts array with new related styles
    --------------------------------------------------------------------
    UPDATE loft_ma_styleattributes master
    SET sty_size_concepts = (
        SELECT array_agg(DISTINCT sc.to_id)
        FROM loft_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    ),
    sty_size_concept_types = (
        SELECT array_agg(DISTINCT sc.related_size_type)
        FROM loft_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    )
    WHERE product IN (
        SELECT DISTINCT new_master_style_id
        FROM loft_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'style'
    );

*/
-- DROP THE TEMPORARY TABLES
DROP TABLE IF EXISTS loft_style_clone_flat_map_temp;
DROP TABLE IF EXISTS loft_style_clone_flat_map_temp_size_concept;

END;
$$;


ALTER PROCEDURE public.loft_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2035 (class 1255 OID 67697799)
-- Name: loft_plan_these_cloned_style_stylecolors_proc(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.loft_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text)
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
    FROM loft_plan_these_cloned_style_stylecolors
    WHERE updated_by = v_pivot_user_id
      AND picked_for_planning = 0
    ;

    UPDATE
        loft_style_clone_stylecolor_size
    SET 
        picked_for_planning = 1 
    WHERE 
        (to_new_stylecolor, session_id) IN (SELECT stylecolor, session_id FROM tmp_selected)
        AND updated_by = v_pivot_user_id
    ;
    /*
    --We need to run these because any edits to colors or lifecycle parameters only modify the master styles and not the size concepts with software
    --This is custom Knitwell code
    --Update the exitdate of the size concept equal to the exit date 
    Update loft_ma_stylecolorchannelattributes size_concept
    set exitdate = (
        Select exitdate
        FROM loft_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM loft_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM loft_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'stylecolor'
    );

    Update loft_ma_stylecolorchannelattributes size_concept
    set erlstmkdnwk = (
        Select erlstmkdnwk
        FROM loft_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM loft_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM loft_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'stylecolor'
    );

    Update loft_ma_stylecolorchannelattributes size_concept
    set dbt_wk = (
        Select dbt_wk
        FROM loft_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM loft_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM loft_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'stylecolor'
    );

    */


    -- ----------------------------------
    -- MARK FOR DELETION UNUSED PRODUCTS 
    -- ----------------------------------


    CREATE TEMPORARY TABLE all_un_used_products
    AS  
    SELECT 
        DISTINCT to_new_style AS product, 'style' AS levelid 
    FROM 
        loft_style_clone_stylecolor_size s
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
        loft_style_clone_stylecolor_size s
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
        loft_style_clone_stylecolor_size s
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
    DELETE FROM loft_style_clone_stylecolor_size a 
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
    delete from loft_d_product where id in (select distinct product from all_un_used_products);

    delete from loft_h_prodstd where id in (select distinct product from all_un_used_products);
   
    delete from loft_a_assortment where product in (select distinct product from all_un_used_products);

    delete from loft_ma_styleattributes where product in (select distinct product from all_un_used_products);

    delete from loft_ma_stylecolorattributes where product in (select distinct product from all_un_used_products);

    delete from loft_ma_sizeattributes where product in (select distinct product from all_un_used_products);

    delete from loft_ma_imgattributes where product in (select distinct product from all_un_used_products);

    delete from loft_p_dc_adj where product in (select distinct product from all_un_used_products);

    delete from loft_p_dc_adj_size where product in (select distinct product from all_un_used_products);

    delete from loft_p_itemprice where product in (select distinct product from all_un_used_products);

    delete from loft_p_channeloverride where product in (select distinct product from all_un_used_products);

    delete from loft_an_price_storecount_info where product in (select distinct product from all_un_used_products);
    */


    -- --------------------------------------------------------------------------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW, SIMULATING REMOVE FROM ASSORTMENT, LIKELY DATA EXISTS IN CLICKHOUSE
    -- --------------------------------------------------------------------------------------------------------
    DELETE FROM loft_a_assortment 
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products);

    UPDATE loft_ma_stylecolorchannelattributes
    SET record_state = 1
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products WHERE levelid = 'stylecolor')
    ;

    UPDATE loft_ma_stylecolorchannelattributes
    SET record_state = 0
    WHERE product IN (select distinct stylecolor from tmp_selected)
    ;

    ------------------------------------
    -- INSERT IN PLAN QUEUE FOR PLANNING
    ------------------------------------

    INSERT INTO plan_queue (product, location, initiator, initiated_at, queued)
    SELECT 
        DISTINCT stylecolor, 'GP-L' AS location, v_pivot_user_id, now(), now()
    FROM 
        tmp_selected
    ;


    ------------------------------------
    -- UPDATE picked_for_planning FLAG
    -- ------------------------------------
    UPDATE 
        loft_plan_these_cloned_style_stylecolors 
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


ALTER PROCEDURE public.loft_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2036 (class 1255 OID 67697801)
-- Name: loft_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.loft_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE loft_style_clone_flat_map_temp AS
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND to_new_style = clone_new_master_style
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
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
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO loft_d_product (
            id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
        )
        SELECT DISTINCT
            to_id,
            null as client_id,
            CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END,
            CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END,
            a.levelid,
            indx,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_d_product b
        WHERE a.from_id = b.id
        ON CONFLICT (id) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------

        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------

        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------

        INSERT INTO loft_h_prodstd (
            id,
            ancestor0,
            ancestor1,
            ancestor2,
            ancestor3,
            ancestor4,
            ancestor5,
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
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------

INSERT INTO loft_ma_styleattributes (
            product,
            style_description,
            sty_article_description,
            sty_coordination_article,
            sty_end_use,
            sty_fabric_profile,
            sty_fit,
            sty_hemline_detail,
            sty_length,
            sty_merch_category,
            sty_merch_group,
            sty_merchandise_dept,
            sty_mfp_program_id,
            sty_missy_petite_nonapparel,
            sty_missy_related_style,
            sty_neckline,
            sty_pyramid_lens,
            sty_shape,
            sty_silhouette,
            sty_size_range,
            sty_size_type,
            sty_sleeve_length,
            ccstylecreatedate,
            sty_third_party,
            sty_type,
            sty_vendor_style_description,
            sty_fabric_description,
            sty_accessory_measurements,
            sty_adhoc,
            sty_finish,
            sty_gauge,
            sty_placement,
            sty_program_id,
            sty_texture,
            sty_tech_design_garment_content,
            sty_tech_design_stretch_level,
            sty_tech_design_closure,
            sty_tech_design_fit_block,
            sty_tech_design_fit_intent,
            sty_tech_design_leg_shape,
            sty_tech_design_length,
            sty_tech_design_placement,
            sty_tech_design_rise,
            sty_tech_design_type,
            sty_bellyband,
            sty_boxed_packaging,
            sty_fit_description,
            sty_hangtag_1,
            sty_hangtag_2,
            sty_jewelry_cards,
            sty_joker_matchbook,
            sty_main_label,
            sty_retail_ticket_type,
            sty_size_sticker,
            sty_stylenumber_name,
            sty_size_concepts,
            sty_size_concept_types,
            sty_specstyleid,
            sty_missy_related_style_bbr,
            sty_size_range_bbr,
            sty_size_type_bbr,
            sty_price_bands,
            sty_good_better_best,
            sty_material,
            sty_primary_material_bbr,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            sty_fabric_description_free_text,
            sty_num_clones_s5,
            sty_num_times_cloned_s5
        )
        SELECT
            to_id,
            style_description,
            sty_article_description,
            sty_coordination_article,
            sty_end_use,
            sty_fabric_profile,
            sty_fit,
            sty_hemline_detail,
            sty_length,
            sty_merch_category,
            sty_merch_group,
            sty_merchandise_dept,
            sty_mfp_program_id,
            sty_missy_petite_nonapparel,
            to_id as sty_missy_related_style,
            sty_neckline,
            sty_pyramid_lens,
            sty_shape,
            sty_silhouette,
            sty_size_range,
            sty_size_type,
            sty_sleeve_length,
            null as ccstylecreatedate,
            sty_third_party,
            sty_type,
            sty_vendor_style_description,
            sty_fabric_description,
            sty_accessory_measurements,
            sty_adhoc,
            sty_finish,
            sty_gauge,
            sty_placement,
            sty_program_id,
            sty_texture,
            sty_tech_design_garment_content,
            sty_tech_design_stretch_level,
            sty_tech_design_closure,
            sty_tech_design_fit_block,
            sty_tech_design_fit_intent,
            sty_tech_design_leg_shape,
            sty_tech_design_length,
            sty_tech_design_placement,
            sty_tech_design_rise,
            sty_tech_design_type,
            sty_bellyband,
            sty_boxed_packaging,
            sty_fit_description,
            sty_hangtag_1,
            sty_hangtag_2,
            sty_jewelry_cards,
            sty_joker_matchbook,
            sty_main_label,
            sty_retail_ticket_type,
            sty_size_sticker,
            sty_stylenumber_name,
            null as sty_size_concepts,
            null as sty_size_concept_types,
            null as sty_specstyleid,
            null as sty_missy_related_style_bbr,
            sty_size_range_bbr,
            sty_size_type_bbr,
            sty_price_bands,
            sty_good_better_best,
            sty_material,
            sty_primary_material_bbr,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            sty_fabric_description_free_text,
            null as sty_num_clones_s5,
            null as sty_num_times_cloned_s5
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------

 INSERT INTO loft_ma_stylecolorattributes (
            product,
            cc_stylecolor_description,
            cccolor,
            cc_color_id,
            cc_color_name,
            cccolorfamily,
            cc_color_type,
            cc_climate_product,
            cc_collection,
            cc_delivery_name,
            cc_fabric_description,
            cc_good_better_best,
            cc_internet_tall_style,
            cc_known,
            cc_lifecycle,
            cc_marketing_flag,
            cc_matchbacks,
            cc_novelty_details,
            cc_novelty,
            cc_online_exclusive_flag,
            cc_opus,
            cc_preview,
            cc_ppns,
            cc_price_band,
            cc_primary_selling,
            cc_print_description,
            cc_print_pattern_type,
            cc_promotion_flag,
            cc_season,
            cc_storeset,
            cc_table,
            ccstylecolorcreatedate,
            cc_delivery_month,
            cc_stylecolornumber_name,
            department_name,
            class_name,
            subclass_name,
            cc_specstyle_cccolor,
            cc_specstylecolorid,
            plan_comments,
            merch_comments,
            cc_free_one,
            cc_free_two,
            cc_free_three,
            cc_brand_concept,
            cc_ecom_exclusives,
            isassortment,
            cc_missy_related_stylecolor,
            cc_size_concepts_in_assortment,
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            cc_floorset,
            cc_use_sys_floorset,
            cc_storeset_period,
            cc_num_clones_s5,
            cc_num_times_cloned_s5
        )
        SELECT
            to_id,
            cc_stylecolor_description,
            a.cccolor,
            'ZZZTBD' as cc_color_id,
            'ZZZTBD' as cc_color_name,
            a.cccolorfamily,
            cc_color_type,
            cc_climate_product,
            cc_collection,
            cc_delivery_name,
            cc_fabric_description,
            cc_good_better_best,
            cc_internet_tall_style,
            cc_known,
            cc_lifecycle,
            cc_marketing_flag,
            cc_matchbacks,
            cc_novelty_details,
            cc_novelty,
            cc_online_exclusive_flag,
            cc_opus,
            cc_preview,
            cc_ppns,
            cc_price_band,
            cc_primary_selling,
            cc_print_description,
            cc_print_pattern_type,
            cc_promotion_flag,
            cc_season,
            cc_storeset,
            cc_table,
            null as ccstylecolorcreatedate,
            cc_delivery_month,
            cc_stylecolornumber_name,
            department_name,
            class_name,
            subclass_name,
            null as cc_specstyle_cccolor,
            null as cc_specstylecolorid,
            null as plan_comments,
            null as merch_comments,
            cc_free_one,
            cc_free_two,
            cc_free_three,
            cc_brand_concept,
            cc_ecom_exclusives,
            isassortment,
            to_id as cc_missy_related_stylecolor,
            '{}' as cc_size_concepts_in_assortment,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            cc_floorset,
            cc_use_sys_floorset,
            cc_storeset_period,
            null as cc_num_clones_s5,
            null as cc_num_times_cloned_s5
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------

        INSERT INTO loft_ma_sizeattributes (
            product,
            parent_id,
            size_id,
            sizeattribute,
            ticket_size,
            size_desc,
            size_range,
            sku_create_date,
            original_price,
            current_price,
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
            size_id,
            sizeattribute,
            ticket_size,
            size_desc,
            size_range,
            null as sku_create_date,
            original_price,
            current_price,
            isvalid,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_stylecolor_size a,
             loft_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------

          INSERT INTO loft_ma_stylecolorchannelattributes (
            product,
            missy_related_stylecolor,
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
            eventdate,
            version_id,
            created_at,
            created_by,
            updated_at,
            updated_by,
            record_state,
            ccticketpricechannel_override_txt,
            act_slsrnk_store,
            act_slsrnk_ecom,
            cc_first_publish_date,
            cc_first_publish_snapshot_op,
            cc_discount_pct_ecom,
            sclr_presmin_stores,
            sclr_presmin_ecom,
            arr_all_sizes_for_mins,
            sizemin_store,
            sizemin_ecom,
            cloned_at
        )
        SELECT
            to_id,
            missy_related_stylecolor,
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            1 as record_state,
            ccticketpricechannel_override_txt,
            act_slsrnk_store,
            act_slsrnk_ecom,
            null as cc_first_publish_date,
            null as cc_first_publish_snapshot_op,
            cc_discount_pct_ecom,
            sclr_presmin_stores,
            sclr_presmin_ecom,
            arr_all_sizes_for_mins,
            sizemin_store,
            sizemin_ecom,
            date_trunc('second', now()) as cloned_at
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------

        INSERT INTO loft_ma_imgattributes (
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------

        INSERT INTO loft_p_itemprice (
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
            addoff_ecom
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            addoff_ecom
        FROM loft_style_clone_flat_map_temp a,
             loft_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------

        INSERT INTO loft_p_channeloverride (
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
            comments,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            testpo,
            floorsetpo
        FROM loft_style_clone_flat_map_temp a,
             loft_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------

        INSERT INTO loft_a_assortment (
            product,
            location,
            time,
            style,
            str_climate,
            str_grade,
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
            record_state
        )
        SELECT
            to_id,
            location,
            time,
            style,
            str_climate,
            str_grade,
            ssg,
            flnrange,
            plan_type,
            isfunded,
            store_count,
            propagate_ranging,
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state
        FROM loft_style_clone_flat_map_temp a,
             loft_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------

        INSERT INTO loft_p_dc_adj (
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
            dc_sc_finrev_ecom,
            dc_adjcost_ecom,
            fc_dc_finalqty_u_store,
            fc_dc_finalqty_r_store,
            fc_dc_finalqty_c_store,
            fc_dc_finalqty_u_ecom,
            fc_dc_finalqty_r_ecom,
            fc_dc_finalqty_c_ecom,
            lastpub_dc_finalqty_u_store,
            lastpub_dc_finalqty_r_store,
            lastpub_dc_finalqty_c_store,
            lastpub_dc_finalqty_u_ecom,
            lastpub_dc_finalqty_r_ecom,
            lastpub_dc_finalqty_c_ecom,
            lastpub_published_at,
            lastpub_published_user
        )
        SELECT
            to_id,
            location,
            time,
            null as dc_publish,
            null as is_locked,
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            dc_useradj_ecom,
            dc_onorder_ecom,
            dc_finrev_ecom,
            null as dc_publish_ecom,
            null as po_indicator_ecom,
            null as po_shipmode_ecom,
            null as air_trigger_ecom,
            null as cut_ecom,
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
            dc_sc_finrev_ecom,
            dc_adjcost_ecom,
            fc_dc_finalqty_u_store,
            fc_dc_finalqty_r_store,
            fc_dc_finalqty_c_store,
            fc_dc_finalqty_u_ecom,
            fc_dc_finalqty_r_ecom,
            fc_dc_finalqty_c_ecom,
            null as lastpub_dc_finalqty_u_store,
            null as lastpub_dc_finalqty_r_store,
            null as lastpub_dc_finalqty_c_store,
            null as lastpub_dc_finalqty_u_ecom,
            null as lastpub_dc_finalqty_r_ecom,
            null as lastpub_dc_finalqty_c_ecom,
            null as lastpub_published_at,
            null as lastpub_published_user
        FROM loft_style_clone_flat_map_temp a,
             loft_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------

        INSERT INTO loft_p_dc_adj_size (
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
            dc_adjcost_ecom
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
            now()::date as eventdate,
            version_id,
            date_trunc('second', now()) as created_at,
            v_pivot_user_id as created_by,
            date_trunc('second', now()) as updated_at,
            v_pivot_user_id as updated_by,
            record_state,
            dc_useradj_ecom,
            null as dc_onorder_ecom,
            null as dc_onorder_v_ecom,
            null as dc_onorder_c_ecom,
            null as dc_finrev_ecom,
            null as dc_publish_ecom,
            null as dc_last_pub_u_ecom,
            null as dc_last_pub_ecom,
            dc_adjcost_ecom
        FROM loft_style_clone_stylecolor_size a,
             loft_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO loft_an_price_storecount_info (
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
            flow_flag,
            corpexcl_ecom,
            addoff_ecom,
            corpaddoff_ecom,
            v_a_ecom,
            v_b_ecom,
            cc_discount_pct_ecom,
            selling_price_ecom
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
            flow_flag,
            corpexcl_ecom,
            addoff_ecom,
            corpaddoff_ecom,
            v_a_ecom,
            v_b_ecom,
            cc_discount_pct_ecom,
            selling_price_ecom
        FROM loft_style_clone_flat_map_temp a,
             loft_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;



    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO loft_l_dependencylookup (
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
        FROM loft_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';


        INSERT INTO loft_l_dependencylookup (
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
        FROM loft_style_clone_flat_map_temp a
        WHERE a.levelid = 'stylecolor';

    --------------------------------------------------------------------
    -- SIZE CONCEPT CLONING SECTION
    -- This section creates clones for related size types (PETITE, TALL,
    -- CURVY_PETITE, CURVY_TALL) based on the master style's existing
    --------------------------------------------------------------------

    --------------------------------------------------------------------
    -- Build temp table for size concept mapping
    -- This maps existing size concept relationships from source styles
    -- to create new size concept styles for cloned masters
    --------------------------------------------------------------------

     CREATE TEMPORARY TABLE loft_style_clone_flat_map_temp_size_concept AS
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
            , clone_new_master_style
            , '' as clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_style IS NOT NULL AND from_style <> ''
          AND to_new_style <> clone_new_master_style
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
            , clone_new_master_style
            , clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolor IS NOT NULL AND from_stylecolor <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
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
            , '' as clone_new_master_style
            , '' as clone_new_master_stylecolor
        FROM loft_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;

    --------------------------------------------------------------------
    -- d_product insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_d_product (
        id,client_id,name,description,levelid,indx,eventdate,version_id,created_at,created_by,updated_at,updated_by,record_state
    )
    SELECT DISTINCT
        to_id,
        null as client_id,
        CASE WHEN a.levelid='stylecolorsize' THEN name ELSE to_name END,
        CASE WHEN a.levelid='stylecolorsize' THEN description ELSE to_desc END,
        a.levelid,
        indx,
        now()::date as eventdate,
        version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        record_state
    FROM loft_style_clone_flat_map_temp_size_concept a,
         loft_d_product b
    WHERE a.from_id = b.id
    ON CONFLICT (id) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert for size concepts
    -- Sets sty_missy_related_style to point to the NEW master style
    -- Uses related size_range and size_type from lookup table
    --------------------------------------------------------------------
    INSERT INTO loft_ma_styleattributes (
        product,
        style_description,
        sty_article_description,
        sty_coordination_article,
        sty_end_use,
        sty_fabric_profile,
        sty_fit,
        sty_hemline_detail,
        sty_length,
        sty_merch_category,
        sty_merch_group,
        sty_merchandise_dept,
        sty_mfp_program_id,
        sty_missy_petite_nonapparel,
        sty_missy_related_style,
        sty_neckline,
        sty_pyramid_lens,
        sty_shape,
        sty_silhouette,
        sty_size_range,
        sty_size_type,
        sty_sleeve_length,
        ccstylecreatedate,
        sty_third_party,
        sty_type,
        sty_vendor_style_description,
        sty_fabric_description,
        sty_accessory_measurements,
        sty_adhoc,
        sty_finish,
        sty_gauge,
        sty_placement,
        sty_program_id,
        sty_texture,
        sty_tech_design_garment_content,
        sty_tech_design_stretch_level,
        sty_tech_design_closure,
        sty_tech_design_fit_block,
        sty_tech_design_fit_intent,
        sty_tech_design_leg_shape,
        sty_tech_design_length,
        sty_tech_design_placement,
        sty_tech_design_rise,
        sty_tech_design_type,
        sty_bellyband,
        sty_boxed_packaging,
        sty_fit_description,
        sty_hangtag_1,
        sty_hangtag_2,
        sty_jewelry_cards,
        sty_joker_matchbook,
        sty_main_label,
        sty_retail_ticket_type,
        sty_size_sticker,
        sty_stylenumber_name,
        sty_size_concepts,
        sty_size_concept_types,
        sty_specstyleid,
        sty_missy_related_style_bbr,
        sty_size_range_bbr,
        sty_size_type_bbr,
        sty_price_bands,
        sty_good_better_best,
        sty_material,
        sty_primary_material_bbr,
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        sty_fabric_description_free_text,
        sty_num_clones_s5,
        sty_num_times_cloned_s5
    )
    SELECT
        a.to_id,
        b.style_description,
        b.sty_article_description,
        b.sty_coordination_article,
        b.sty_end_use,
        b.sty_fabric_profile,
        b.sty_fit,
        b.sty_hemline_detail,
        b.sty_length,
        b.sty_merch_category,
        b.sty_merch_group,
        b.sty_merchandise_dept,
        b.sty_mfp_program_id,
        b.sty_missy_petite_nonapparel,
        -- sty_missy_related_style points to the NEW master style (not the old one)
        a.clone_new_master_style as sty_missy_related_style,
        b.sty_neckline,
        b.sty_pyramid_lens,
        b.sty_shape,
        b.sty_silhouette,
        -- Use the related size range from lookup, or keep original if not found
        b.sty_size_range as sty_size_range,
        -- Use the related size type
        b.sty_size_type as sty_size_type,
        b.sty_sleeve_length,
        null as ccstylecreatedate,
        b.sty_third_party,
        b.sty_type,
        b.sty_vendor_style_description,
        b.sty_fabric_description,
        b.sty_accessory_measurements,
        b.sty_adhoc,
        b.sty_finish,
        b.sty_gauge,
        b.sty_placement,
        b.sty_program_id,
        b.sty_texture,
        b.sty_tech_design_garment_content,
        b.sty_tech_design_stretch_level,
        b.sty_tech_design_closure,
        b.sty_tech_design_fit_block,
        b.sty_tech_design_fit_intent,
        b.sty_tech_design_leg_shape,
        b.sty_tech_design_length,
        b.sty_tech_design_placement,
        b.sty_tech_design_rise,
        b.sty_tech_design_type,
        b.sty_bellyband,
        b.sty_boxed_packaging,
        b.sty_fit_description,
        b.sty_hangtag_1,
        b.sty_hangtag_2,
        b.sty_jewelry_cards,
        b.sty_joker_matchbook,
        b.sty_main_label,
        b.sty_retail_ticket_type,
        b.sty_size_sticker,
        b.sty_stylenumber_name,
        '{}' as sty_size_concepts,
        '{}' as sty_size_concept_types,
        null as sty_specstyleid,
        null as sty_missy_related_style_bbr,
        b.sty_size_range_bbr,
        b.sty_size_type_bbr,
        b.sty_price_bands,
        b.sty_good_better_best,
        b.sty_material,
        b.sty_primary_material_bbr,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --setting the record state to 1 so the size concept is not in assortment
        1 as record_state,
        sty_fabric_description_free_text,
        null as sty_num_clones_s5,
        null as sty_num_times_cloned_s5
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_styleattributes b ON a.from_id = b.product
    WHERE a.levelid = 'style'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert for size concepts
    -- cc_missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO loft_ma_stylecolorattributes (
        product,
        cc_stylecolor_description,
        cccolor,
        cc_color_id,
        cc_color_name,
        cccolorfamily,
        cc_color_type,
        cc_climate_product,
        cc_collection,
        cc_delivery_name,
        cc_fabric_description,
        cc_good_better_best,
        cc_internet_tall_style,
        cc_known,
        cc_lifecycle,
        cc_marketing_flag,
        cc_matchbacks,
        cc_novelty_details,
        cc_novelty,
        cc_online_exclusive_flag,
        cc_opus,
        cc_preview,
        cc_ppns,
        cc_price_band,
        cc_primary_selling,
        cc_print_description,
        cc_print_pattern_type,
        cc_promotion_flag,
        cc_season,
        cc_storeset,
        cc_table,
        ccstylecolorcreatedate,
        cc_delivery_month,
        cc_stylecolornumber_name,
        department_name,
        class_name,
        subclass_name,
        cc_specstyle_cccolor,
        cc_specstylecolorid,
        plan_comments,
        merch_comments,
        cc_free_one,
        cc_free_two,
        cc_free_three,
        cc_brand_concept,
        cc_ecom_exclusives,
        isassortment,
        cc_missy_related_stylecolor,
        cc_size_concepts_in_assortment,
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        cc_floorset,
        cc_use_sys_floorset,
        cc_storeset_period,
        cc_num_clones_s5,
        cc_num_times_cloned_s5
    )
    SELECT
        a.to_id,
        /*These might need to be modified to hold the values from the a record since we might want to inherit the values from the cloning screen, unsure */
        b.cc_stylecolor_description,
        b.cccolor,
        b.cc_color_id,
        b.cc_color_name,
        b.cccolorfamily,
        b.cc_color_type,
        b.cc_climate_product,
        b.cc_collection,
        b.cc_delivery_name,
        b.cc_fabric_description,
        b.cc_good_better_best,
        b.cc_internet_tall_style,
        b.cc_known,
        b.cc_lifecycle,
        b.cc_marketing_flag,
        b.cc_matchbacks,
        b.cc_novelty_details,
        b.cc_novelty,
        b.cc_online_exclusive_flag,
        b.cc_opus,
        b.cc_preview,
        b.cc_ppns,
        b.cc_price_band,
        b.cc_primary_selling,
        b.cc_print_description,
        b.cc_print_pattern_type,
        b.cc_promotion_flag,
        b.cc_season,
        b.cc_storeset,
        b.cc_table,
        null as ccstylecolorcreatedate,
        b.cc_delivery_month,
        b.cc_stylecolornumber_name,
        b.department_name,
        b.class_name,
        b.subclass_name,
        null as cc_specstyle_cccolor,
        null as cc_specstylecolorid,
        null as plan_comments,
        null as merch_comments,
        b.cc_free_one,
        b.cc_free_two,
        b.cc_free_three,
        b.cc_brand_concept,
        b.cc_ecom_exclusives,
        b.isassortment,
        -- cc_missy_related_stylecolor points to the NEW master stylecolor
        a.clone_new_master_stylecolor as cc_missy_related_stylecolor,
        '{}' as cc_size_concepts_in_assortment,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 so the item is not in assortment 
        1 as record_state,
        b.cc_floorset,
        b.cc_use_sys_floorset,
        b.cc_storeset_period,
        null as cc_num_clones_s5,
        null as cc_num_times_cloned_s5
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_stylecolorattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert for size concepts
    -- Uses related size_range from lookup table
    --------------------------------------------------------------------

/*
    INSERT INTO loft_ma_sizeattributes (
        product,
        parent_id,
        size_id,
        sizeattribute,
        ticket_size,
        size_desc,
        size_range,
        sku_create_date,
        original_price,
        current_price,
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
        a.to_id,
        -- parent_id should be the new stylecolor
        (SELECT sc.to_id
         FROM loft_style_clone_flat_map_temp_size_concept sc
         WHERE sc.levelid = 'stylecolor'
           AND sc.related_size_type = a.related_size_type
           AND sc.session_id = a.session_id
           AND sc.clone_ordinal = a.clone_ordinal
         LIMIT 1) as parent_id,
        b.size_id,
        b.sizeattribute,
        b.ticket_size,
        b.size_desc,
        -- Use related size_range from lookup if available
        b.size_range as size_range,
        null as sku_create_date,
        b.original_price,
        b.current_price,
        b.isvalid,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        b.record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_sizeattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product) DO NOTHING;
    */


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert for size concepts
    -- missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO loft_ma_stylecolorchannelattributes (
        product,
        missy_related_stylecolor,
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
        eventdate,
        version_id,
        created_at,
        created_by,
        updated_at,
        updated_by,
        record_state,
        ccticketpricechannel_override_txt,
        act_slsrnk_store,
        act_slsrnk_ecom,
        cc_first_publish_date,
        cc_first_publish_snapshot_op,
        cc_discount_pct_ecom,
        sclr_presmin_stores,
        sclr_presmin_ecom,
        arr_all_sizes_for_mins,
        sizemin_store,
        sizemin_ecom,
        cloned_at
    )
    SELECT
        a.to_id,
        -- missy_related_stylecolor points to the NEW cloned master stylecolor, so we take our generated id and remove PETITE/TALL to get the cloned master stylecolor
        a.clone_new_master_stylecolor as cc_missy_related_stylecolor,
        b.location,
        b.dbt_wk,
        b.relaunchweek,
        b.erlstmkdnwk,
        b.exitdate,
        b.initrcptwk,
        b.too,
        b.mkdnwks,
        b.last_inv_wk,
        b.lstfpwk,
        b.last_rcpt_wk,
        b.lastdcorder,
        b.act_initrcptwk,
        b.act_dbt_wk,
        b.irw_indx,
        b.dbtwk_indx,
        b.relaunchwk_indx,
        b.mdstart_indx,
        b.lastdcorder_indx,
        b.exitdate_indx,
        b.preview_wks,
        b.preview_qty,
        b.plannedselldnwk,
        b.ccmdstrategy,
        b.slsrnk_store,
        b.slsrnk_ecom,
        b.validsizes,
        b.cc_validsizes_store,
        b.cc_validsizes_ecom,
        b.ccrangecode,
        b.cc_presmin,
        b.cc_presmin_weeks,
        b.cc_rcptint,
        b.cc_return_u_pct_store,
        b.cc_return_u_pct_ecom,
        b.cc_return_u_pct_cross,
        b.cc_ordermultiple,
        b.cc_ordermin,
        b.cc_buy_aps_letter,
        b.ccticketpricechannel,
        b.ccticketpricechannel_override,
        b.cc_imupct,
        b.cc_discount_pct,
        b.cc_existingwac,
        b.cc_systemcost,
        b.cc_plan_cost,
        b.ssnprf,
        b.adjaps_store,
        b.adjaps_ecom,
        b.smoothing_strategy,
        b.in_season_flag,
        b.auto_rollforward,
        b.irr_mode,
        b.plan_current,
        b.lock_agg_edit,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.ccticketpricechannel_override_txt,
        b.act_slsrnk_store,
        b.act_slsrnk_ecom,
        null as cc_first_publish_date,
        null as cc_first_publish_snapshot_op,
        b.cc_discount_pct_ecom,
        b.sclr_presmin_stores,
        b.sclr_presmin_ecom,
        b.arr_all_sizes_for_mins,
        b.sizemin_store,
        b.sizemin_ecom,
        date_trunc('second', now()) as cloned_at
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_stylecolorchannelattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location) DO NOTHING;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_ma_imgattributes (
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
        b.indx,
        a.to_id,
        b.img,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_ma_imgattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- ITEMPRICE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_itemprice (
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
        addoff_ecom
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        b.addoff,
        b.eo,
        b.eff_aur,
        b.department,
        b.event,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.addoff_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_itemprice b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_channeloverride (
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
        a.to_id,
        b.location,
        b.time,
        b.weekadjaps,
        b.weekadjaps_ecom,
        b.weekadjslsu,
        b.weekadjslsu_ecom,
        b.comments,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.testpo,
        b.floorsetpo
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_channeloverride b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- ASSORTMENT insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_a_assortment (
        product,
        location,
        time,
        style,
        str_climate,
        str_grade,
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
        record_state
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        b.style,
        b.str_climate,
        b.str_grade,
        b.ssg,
        b.flnrange,
        b.plan_type,
        b.isfunded,
        b.store_count,
        b.propagate_ranging,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_a_assortment b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_dc_adj (
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
        dc_sc_finrev_ecom,
        dc_adjcost_ecom,
        fc_dc_finalqty_u_store,
        fc_dc_finalqty_r_store,
        fc_dc_finalqty_c_store,
        fc_dc_finalqty_u_ecom,
        fc_dc_finalqty_r_ecom,
        fc_dc_finalqty_c_ecom,
        lastpub_dc_finalqty_u_store,
        lastpub_dc_finalqty_r_store,
        lastpub_dc_finalqty_c_store,
        lastpub_dc_finalqty_u_ecom,
        lastpub_dc_finalqty_r_ecom,
        lastpub_dc_finalqty_c_ecom,
        lastpub_published_at,
        lastpub_published_user
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        null as dc_publish,
        b.is_locked,
        b.dc_uservrp,
        b.dc_lockedqty,
        b.dc_useradj,
        b.dc_onorder,
        b.dc_finrev,
        b.dc_validwk,
        b.dc_finalqty,
        b.dc_adjcost,
        b.const_y_n,
        b.sbkt,
        b.dc_isedited,
        b.dc_syscost,
        b.dc_lndcst,
        b.dc_sysvrp,
        b.dc_sc_useradj,
        b.dc_sc_finrev,
        b.po_indicator,
        b.po_shipmode,
        b.air_trigger,
        b.cut,
        null as published_at,
        null as is_prepublished,
        null as prepublished_at,
        null as last_prepublished,
        null as po_arr,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.dc_useradj_ecom,
        b.dc_onorder_ecom,
        b.dc_finrev_ecom,
        null as dc_publish_ecom,
        null as po_indicator_ecom,
        null as po_shipmode_ecom,
        null as air_trigger_ecom,
        null as cut_ecom,
        null as published_at_ecom,
        null as is_prepublished_ecom,
        null as prepublished_at_ecom,
        null as last_prepublished_ecom,
        b.reason_code,
        b.reason_code_ecom,
        b.pack_ind_flag,
        b.pack_ind_flag_ecom,
        b.show_in_pack,
        b.show_in_pack_ecom,
        b.dc_sc_finrev_ecom,
        b.dc_adjcost_ecom,
        b.fc_dc_finalqty_u_store,
        b.fc_dc_finalqty_r_store,
        b.fc_dc_finalqty_c_store,
        b.fc_dc_finalqty_u_ecom,
        b.fc_dc_finalqty_r_ecom,
        b.fc_dc_finalqty_c_ecom,
        null as lastpub_dc_finalqty_u_store,
        null as lastpub_dc_finalqty_r_store,
        null as lastpub_dc_finalqty_c_store,
        null as lastpub_dc_finalqty_u_ecom,
        null as lastpub_dc_finalqty_r_ecom,
        null as lastpub_dc_finalqty_c_ecom,
        null as lastpub_published_at,
        null as lastpub_published_user
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_dc_adj b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_p_dc_adj_size (
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
        dc_adjcost_ecom
    )
    SELECT
        a.to_id,
        b.location,
        b.time,
        null as dc_publish,
        b.is_locked,
        b.dc_uservrp,
        b.dc_lockedqty,
        b.dc_useradj,
        null as dc_onorder,
        b.dc_finrev,
        b.dc_validwk,
        b.dc_finalqty,
        b.dc_adjcost,
        b.const_y_n,
        b.sbkt,
        b.dc_scadj,
        b.dc_ttluseradj,
        b.dc_scfinrev,
        b.dc_ttlfinrev,
        b.dc_isedited,
        null as dc_onorder_v,
        null as dc_onorder_c,
        b.current_week,
        null as dc_last_pub_u,
        null as dc_last_pub,
        now()::date as eventdate,
        b.version_id,
        date_trunc('second', now()) as created_at,
        v_pivot_user_id as created_by,
        date_trunc('second', now()) as updated_at,
        v_pivot_user_id as updated_by,
        --Setting the record state to 1 as we do not want the item in assortment
        1 as record_state,
        b.dc_useradj_ecom,
        null as dc_onorder_ecom,
        null as dc_onorder_v_ecom,
        null as dc_onorder_c_ecom,
        null as dc_finrev_ecom,
        null as dc_publish_ecom,
        null as dc_last_pub_u_ecom,
        null as dc_last_pub_ecom,
        b.dc_adjcost_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_p_dc_adj_size b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_an_price_storecount_info (
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
        flow_flag,
        corpexcl_ecom,
        addoff_ecom,
        corpaddoff_ecom,
        v_a_ecom,
        v_b_ecom,
        cc_discount_pct_ecom,
        selling_price_ecom
    )
    SELECT
        a.to_id,
        b.channel,
        b.time,
        b.selling_channel,
        b.isfunded,
        b.store_count,
        b.in_season_flag,
        b.dbt_wk_date,
        b.last_rcpt_wk_date,
        b.erlstmkdnwk_date,
        b.exitdate_date,
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
        b.v_a,
        b.v_b,
        b.ccdiscountpct,
        b.flow_flag,
        b.corpexcl_ecom,
        b.addoff_ecom,
        b.corpaddoff_ecom,
        b.v_a_ecom,
        b.v_b_ecom,
        b.cc_discount_pct_ecom,
        b.selling_price_ecom
    FROM loft_style_clone_flat_map_temp_size_concept a
    INNER JOIN loft_an_price_storecount_info b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING;


/*
I am unsure if this code needs to be run in any way, but it is something that was similar in add to assortment
    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts for size concepts
    --------------------------------------------------------------------
    INSERT INTO loft_l_dependencylookup (
        lookup_id,
        lookup_value,
        target_id,
        target_value
    )
    SELECT DISTINCT
        'style'    AS lookup_id,
        new_master_style_id    AS lookup_value,
        'patternedtostyle' AS target_id,
        to_id      AS target_value
    FROM loft_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'style';


    INSERT INTO loft_l_dependencylookup (
        lookup_id,
        lookup_value,
        target_id,
        target_value
    )
    SELECT DISTINCT
        'stylecolor' AS lookup_id,
        -- lookup_value should points to the NEW cloned master stylecolor, so we take our generated id and remove PETITE/TALL to get the cloned master stylecolor
        replace(a.to_id,Concat('_',a.related_size_type),'') AS lookup_value,
        'patternedtostylecolor' AS target_id,
        to_id        AS target_value
    FROM loft_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'stylecolor';

    --Untested
    --------------------------------------------------------------------
    -- Update master style's sty_size_concepts array with new related styles
    --------------------------------------------------------------------
    UPDATE loft_ma_styleattributes master
    SET sty_size_concepts = (
        SELECT array_agg(DISTINCT sc.to_id)
        FROM loft_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    ),
    sty_size_concept_types = (
        SELECT array_agg(DISTINCT sc.related_size_type)
        FROM loft_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    )
    WHERE product IN (
        SELECT DISTINCT new_master_style_id
        FROM loft_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'style'
    );

*/
-- DROP THE TEMPORARY TABLES
DROP TABLE IF EXISTS loft_style_clone_flat_map_temp;
DROP TABLE IF EXISTS loft_style_clone_flat_map_temp_size_concept;

END;
$$;


ALTER PROCEDURE public.loft_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2037 (class 1255 OID 67697803)
-- Name: loft_style_clone_stylecolor_size_proc_dummy(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.loft_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text)
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


ALTER PROCEDURE public.loft_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 2038 (class 1255 OID 67697804)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE loft_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 2039 (class 1255 OID 67697805)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 2040 (class 1255 OID 67697806)
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
-- TOC entry 2041 (class 1255 OID 67697807)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM loft_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 2084 (class 1255 OID 67697808)
-- Name: propagate_assortment_to_floorsets(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.propagate_assortment_to_floorsets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
sls_start     text;
dept_var      text;
class_var     text;
BEGIN

  select ancestor2, ancestor3 into class_var, dept_var
  from loft_h_prodstd where id = NEW.product;

  select a.slsstart into sls_start
  from loft_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;

------------------
-- Start                --
-- USER ACTIONS --
------------------

  -- User currently has as ssg assigned but then assigns a grade or climate then blank out ssg
  if (cardinality(OLD.SSG) > 0 or OLD.SSG is not null)
    and ((cardinality(OLD.str_grade) = 0 or cardinality(OLD.str_grade) is null or cardinality(OLD.str_climate) = 0) or cardinality(OLD.str_climate) is null)
    and (cardinality(NEW.str_grade) > 0 or cardinality(NEW.str_climate) > 0)
  then
      NEW.SSG := '{}'::text[];
  end if;

  -- User deselects all grades while also not assigning an ssg then revert to all grades
  if (cardinality(NEW.str_grade) = 0 or cardinality(NEW.str_grade) is null) and (cardinality(NEW.ssg) = 0 or cardinality(NEW.ssg) is null) then
        select array_agg(attributevalue) into NEW.str_grade from loft_v_memberbasedvalidvalues where attributeid = 'str_grade';
  end if;

  -- User deselects all climates while also not assigning an ssg then revert to all climates
  if (cardinality(NEW.str_climate) = 0 or cardinality(NEW.str_climate) is null) and (cardinality(NEW.ssg) = 0 or cardinality(NEW.ssg) is null) then
        select array_agg(attributevalue) into NEW.str_climate from loft_v_memberbasedvalidvalues where attributeid = 'str_climate';
  end if;

  -- User assigns ssg then blank out grade and climate
  if (cardinality(OLD.SSG) = 0 or OLD.SSG is null) and (cardinality(OLD.str_grade) > 0 or cardinality(OLD.str_climate) > 0) and cardinality(NEW.ssg) > 0 then
    NEW.str_grade     :=  '{}'::text[];
    NEW.str_climate     :=  '{}'::text[];
  end if;

------------------
-- End                  --
-- USER ACTIONS --
------------------

  if cardinality(NEW.SSG) = 0 or NEW.SSG is null
   then
      NEW.store_count := get_store_count(
                                           sls_start
                                          ,NEW.str_climate
                                          ,NEW.str_grade
                                          ,class_var
                                        );
     NEW.SSG = '{}'::text[];
  else
      select cardinality(stores) into NEW.store_count
      from loft_l_ssglookup
      where ssg_id = array_to_string(NEW.SSG, ',')
        and product = dept_var;

      -- SUP-1715: SELECT INTO with no match yields NULL
      if NEW.store_count is null then
          NEW.store_count := 0;
      end if;
  end if;

  update loft_a_assortment a
  set str_grade = NEW.str_grade
     ,str_climate = NEW.str_climate
     ,ssg = NEW.ssg
     ,store_count = NEW.store_count
  from (select id, indx from loft_d_time where levelid = 'floorset') d
  where product = NEW.product
    and location = NEW.location
    and d.id = NEW.time
    and a.time in (select id from loft_d_time where levelid = 'floorset' and indx >= d.indx)
  ;

  update loft_a_assortment a
  set store_count = get_store_count(z.slsstart, a.str_climate, a.str_grade, y.ancestor2)
  from (select id, indx from loft_d_time where levelid = 'floorset') d, loft_h_prodstd y, loft_ma_dptflrsetattributes z
  where a.product = NEW.product
    and a.location = NEW.location
    and d.id = NEW.time
    and a.product = y.id and y.ancestor3 = z.product and a.time = z.time
    and a.time in (select id from loft_d_time where levelid = 'floorset' and indx >= d.indx)
    and coalesce(cardinality(a.ssg),0) = 0   -- SUP-1715: do not recompute SSG rows from blank grade/climate
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 2042 (class 1255 OID 67697809)
-- Name: remove_product_from_queue(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_product_from_queue() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_recordstate smallint;
BEGIN
  
    select record_state into v_recordstate
    from loft_ma_stylecolorchannelattributes 
    where product=NEW.product;

    if (COALESCE(v_recordstate,1) != 0 )
    THEN 
      RETURN OLD;
    ELSE
        RETURN NEW;
    end if;

END;
$$;


ALTER FUNCTION public.remove_product_from_queue() OWNER TO psql;

--
-- TOC entry 2043 (class 1255 OID 67697810)
-- Name: remove_size_concepts_from_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_size_concepts_from_assortment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_isassort smallint;
BEGIN

      RAISE NOTICE 'Inside remove_size_concepts_from_assortment';
RAISE NOTICE 'cardinality(NEW.cc_size_concepts_in_assortment): %', cardinality(NEW.cc_size_concepts_in_assortment);
    if (cardinality(NEW.cc_size_concepts_in_assortment) = 0)
    THEN
      RAISE NOTICE 'Inside If';
      update loft_ma_stylecolorchannelattributes
      set record_state = 1
      where product in (    
          select product 
          from loft_stylecolor_hier_attr 
          where cc_missy_related_stylecolor = new.product
            and product != new.product
    );
    end if;

    --select count(*) into v_isassort
    --from (select * 
    --      from loft_ma_stylecolorchannelattributes 
    --      where record_state = 0 and product in (select product ||  unnest(old.cc_size_concepts_in_assortment) from loft_ma_stylecolorattributes where product = NEW.product)
    --) x;
    --
    --RAISE NOTICE 'count: %', v_isassort;
    --if v_isassort > 0
    --then
    --    RETURN OLD;
    --end if;

    select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from loft_ma_stylecolorattributes a, loft_ma_stylecolorchannelattributes b, loft_h_prodstd c, loft_ma_styleattributes d, loft_d_product e 
                            where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
                            and cc_missy_related_stylecolor = NEW.product
                           ) x where product <> NEW.product and record_state = 0
                      ) into NEW.cc_size_concepts_in_assortment;

    RETURN NEW;

END;
$$;


ALTER FUNCTION public.remove_size_concepts_from_assortment() OWNER TO psql;

--
-- TOC entry 2044 (class 1255 OID 67697811)
-- Name: reset_plan_type_to_plan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.reset_plan_type_to_plan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  update 
    loft_a_assortment set plan_type='plan' 
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
-- TOC entry 2045 (class 1255 OID 67697812)
-- Name: set_prepublished_at(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.set_prepublished_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NEW.cc_prepublish is true and OLD.cc_prepublished_at is null then
    NEW.cc_prepublished_at = NOW()::timestamp(0);
  END IF;
  IF NEW.cc_prepublish is not true then
    NEW.cc_prepublish = null;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_prepublished_at() OWNER TO psql;

--
-- TOC entry 2046 (class 1255 OID 67697813)
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
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from loft_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';
EXECUTE s1;
s2 := '
  update loft_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';
EXECUTE s2;
s3 := '
  update loft_ma_sizeattributes a
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
-- TOC entry 2047 (class 1255 OID 67697814)
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
  v_sty_size_range text;
  
    
BEGIN

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;

table_temp_rangecode_master:= 'table_temp_rangecode_master'||v_uuid;

v_product=NEW.product;
v_location=NEW.location;
v_ccrangecode=NEW.ccrangecode;

select sty_size_range into v_sty_size_range
from
    loft_stylecolor_hier_attr
where
    product=v_product
limit 1;

s0 := 'drop table if exists '||table_temp_rangecode_master||' 
  ';

s1 := 'create temporary table '||table_temp_rangecode_master||' as 
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location
  , lookup_value as ccrangecode,target_value as master_size_attr, uuid_generate_v4()::text as memberid, 0::int as member_exists from loft_l_dependencylookup 
  where 
  lookup_id=''size_range''
  and lookup_value= '''||v_sty_size_range||'''
    ';

s2 := '
  update '||table_temp_rangecode_master||' a set memberid = b.product, member_exists=1 from loft_ma_sizeattributes b 
  where a.product=b.parent_id and a.master_size_attr=b.sizeattribute
  ';
  s3 := '
  update loft_ma_sizeattributes set isvalid=0 where parent_id='''||v_product||'''
  ';

s4 := '
  delete from loft_ma_sizeattributes where product in (select memberid from '||table_temp_rangecode_master||')
  ';
 
s5 := ' 
  insert into loft_ma_sizeattributes (product, sizeattribute, parent_id, isvalid)
  select memberid, master_size_attr, product, 1 as isvalid from '||table_temp_rangecode_master||' 
  ';

s6 := '
  delete from loft_d_product where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0)
    ';
  
s6x := '
  insert into loft_d_product (id, name, description, levelid) select memberid, product||''-''||master_size_attr, product||''-''||master_size_attr, ''stylecolorsize'' 
  from  '||table_temp_rangecode_master||' 
  where member_exists=0
  ';

s7 := '
  delete from loft_h_prodstd where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0);
  insert into loft_h_prodstd 
  (id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,version_id,created_at,created_by,updated_at,updated_by,record_state) 
  select 
  memberid,id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,version_id,created_at,created_by,updated_at,updated_by,record_state
  from loft_h_prodstd a, (select memberid,product from  '||table_temp_rangecode_master||'  where member_exists=0) b
  where a.id=b.product
    ';


s8 := '
  update loft_p_dc_adj_size a
  set dc_useradj=null
  where product in (select product from loft_ma_sizeattributes where isvalid = 0 and parent_id='''||v_product||''')
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
 
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sizerangecode_validsizes_members() OWNER TO psql;

--
-- TOC entry 2048 (class 1255 OID 67697815)
-- Name: skip_update_styleattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.skip_update_styleattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_count integer;
BEGIN
    select count(*) into v_count
    from loft_ma_styleattributes where product <> NEW.product and sty_specstyleid = NEW.sty_specstyleid and coalesce(NEW.sty_specstyleid, '') <> '';

    IF v_count > 0 THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.skip_update_styleattributes() OWNER TO psql;

--
-- TOC entry 2049 (class 1255 OID 67697816)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from loft_ma_dptflrsetattributes a, loft_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from loft_h_prodstd where id=NEW.product)
    and b.product = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from loft_a_assortment a, loft_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from loft_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from loft_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into loft_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update loft_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from loft_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from loft_a_assortment a 
          join (select c.time,slsstart,slsend from loft_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where loft_a_assortment.time=filtered.time and loft_a_assortment.product=filtered.product;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 2078 (class 1255 OID 67697817)
-- Name: sty_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sty_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    loft_ma_styleattributes
  SET
     sty_mfp_program_id = NEW.sty_mfp_program_id
    ,sty_pyramid_lens = NEW.sty_pyramid_lens
    ,sty_end_use = NEW.sty_end_use
    ,sty_silhouette = NEW.sty_silhouette
    ,sty_program_id = NEW.sty_program_id
    ,sty_shape = NEW.sty_shape
    ,sty_length = NEW.sty_length
    ,sty_placement = NEW.sty_placement
    ,sty_neckline = NEW.sty_neckline
    ,sty_sleeve_length = NEW.sty_sleeve_length
    ,sty_fit = NEW.sty_fit
    ,sty_type = NEW.sty_type
    ,sty_hemline_detail = NEW.sty_hemline_detail
    ,sty_texture = NEW.sty_texture
    ,sty_gauge = NEW.sty_gauge
    ,sty_material = NEW.sty_material
    ,sty_fabric_profile = NEW.sty_fabric_profile
    ,sty_accessory_measurements = NEW.sty_accessory_measurements
    ,sty_third_party = NEW.sty_third_party
    ,sty_adhoc = NEW.sty_adhoc
    ,sty_finish = NEW.sty_finish
    ,sty_coordination_article = NEW.sty_coordination_article
    ,sty_fabric_description_free_text = NEW.sty_fabric_description_free_text
    ,sty_fabric_description = NEW.sty_fabric_description
  WHERE
    sty_missy_related_style = NEW.product
  ;

  -- SUP-3892 Queue Size Concepts to Plan Queue
  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a,
  loft_h_prodstd b,
  loft_ma_styleattributes c
  WHERE
    a.product = b.id and b.ancestor0 = c.product
    and sty_missy_related_style = NEW.product and c.product <> sty_missy_related_style
    and a.record_state = 0
    and a.product not in (select product from plan_queue where completed is null);
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sty_copy_master_attributes() OWNER TO psql;

--
-- TOC entry 2050 (class 1255 OID 67697818)
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
-- TOC entry 2051 (class 1255 OID 67697819)
-- Name: trigger_set_cp_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_cp_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dc_publish real; 
BEGIN
  select dc_publish into v_dc_publish from loft_p_dc_adj where product = NEW.product and time = NEW.time and location = NEW.location;

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
-- TOC entry 2052 (class 1255 OID 67697820)
-- Name: trigger_set_dcadjcost_ecom(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_dcadjcost_ecom() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

update loft_p_dc_adj
set dc_adjcost_ecom = NEW.dc_adjcost
where product = NEW.product
and time = NEW.time
;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_dcadjcost_ecom() OWNER TO psql;

--
-- TOC entry 2053 (class 1255 OID 67697821)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from loft_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 2055 (class 1255 OID 67697822)
-- Name: trigger_set_pack_ind_flag(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_pack_ind_flag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_irw text;
    v_act_irw text;
    v_min_irw text;
BEGIN

select initrcptwk into v_irw
from loft_ma_stylecolorchannelattributes where product = NEW.product
;

--select min(time) into v_act_irw
--from loft_p_dc_adj
--where product = NEW.product and dc_useradj is not null;
--
--IF v_irw < v_act_irw
--THEN
--  SELECT v_irw into v_min_irw;
--ELSE
--  SELECT v_act_irw into v_min_irw;
--END IF;

IF NEW.time != v_irw
THEN

  NEW.reason_code := '';
  NEW.reason_code_ecom := '';
  NEW.pack_ind_flag := '';

ELSE

  NEW.reason_code := COALESCE(NEW.reason_code,'Initial');
  NEW.reason_code_ecom := COALESCE(NEW.reason_code_ecom,'Initial');
  NEW.pack_ind_flag := COALESCE(NEW.pack_ind_flag,'TRUE');

END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_pack_ind_flag() OWNER TO psql;

--
-- TOC entry 2056 (class 1255 OID 67697823)
-- Name: trigger_set_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_cc_first_publish_date timestamp without time zone;
BEGIN
 IF NEW.dc_publish = 1 
 THEN


  NEW.lastpub_published_at = date_trunc('sec'::text, CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York');
  NEW.lastpub_published_user = COALESCE((select email from user_metadata where uid = NEW.updated_by), NEW.updated_by);

   NEW.created_at = NOW()::timestamp(0);
   NEW.published_at = NOW()::timestamp(0);

   NEW.dc_publish_ecom = 1;
   NEW.published_at_ecom = NOW()::timestamp(0);

   insert into sync_outbound_dataqueue (product,time,publish_type)
   select NEW.product, NEW.time, 'RDY4PO' as publish_type
   ;

   select cc_first_publish_date into v_cc_first_publish_date from loft_ma_stylecolorchannelattributes where product = NEW.product;

   if v_cc_first_publish_date is null then
       update loft_ma_stylecolorchannelattributes 
       set cc_first_publish_date = coalesce(cc_first_publish_date, NOW()::timestamp(0)),
           cc_first_publish_snapshot_op = coalesce(cc_first_publish_snapshot_op, 1)
       where product = NEW.product;

       insert into sync_outbound_dataqueue (product,time,publish_type)
       select NEW.product, NEW.time, 'OP_SNAPSHOT' as publish_type
       ;
   end if;

 END IF; 

 IF NEW.dc_publish = 0
 THEN
   NEW.dc_publish_ecom = 0;
 END IF;

 RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_publish_timestamp() OWNER TO psql;

--
-- TOC entry 2057 (class 1255 OID 67697824)
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
-- TOC entry 2058 (class 1255 OID 67697825)
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
-- TOC entry 2059 (class 1255 OID 67697826)
-- Name: unlink_cc_size_concept_in_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.unlink_cc_size_concept_in_assortment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_sty_size_type text;
    v_sty_specstyleid text;
    v_hasbeenpublished int;
    v_remainingcc int;
BEGIN
  
  IF (NEW.record_state=1 and OLD.record_state=0)
  THEN

      update loft_ma_stylecolorattributes
      SET cc_size_concepts_in_assortment='{}'::text[]
      WHERE product = new.product;
  
      select sty_specstyleid into v_sty_specstyleid
      from loft_ma_styleattributes
      where product = (select ancestor0 from loft_h_prodstd where id = NEW.product)
      ;

      select count(*) into v_hasbeenpublished
      from loft_ma_stylecolorfloorsetattributes a
      where a.product = NEW.product
        and (fc_published_specstyleid = v_sty_specstyleid OR ir_published_specstyleid = v_sty_specstyleid)
      ;

      select count(*) into v_remainingcc
      from loft_ma_stylecolorchannelattributes a
      where product in (select id from loft_h_prodstd where ancestor0 in (select ancestor0 from loft_h_prodstd where id = NEW.product))
        and product != NEW.product
        and record_state = 0;

      IF (v_hasbeenpublished > 0 and v_remainingcc = 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select ancestor0 as product, 'NA' as time, 'DEL1' as publish_type 
          from loft_h_prodstd 
          where id = NEW.product;
      END IF;

      INSERT INTO sync_stylecolorchannel (product)
      SELECT NEW.product;

  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.unlink_cc_size_concept_in_assortment() OWNER TO psql;

--
-- TOC entry 2060 (class 1255 OID 67697827)
-- Name: upd_array_order(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.upd_array_order() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
v_str_grade_reorder _text;
v_str_climate_reorder _text;

BEGIN

--RAISE NOTICE 'product:%', NEW.product;
--RAISE NOTICE 'time:%', NEW.time;

select array_agg(str_grade order by str_grade)
into v_str_grade_reorder
from (select unnest(NEW.str_grade) as str_grade) x
;

select array_agg(str_climate order by str_climate)
into v_str_climate_reorder
from (select unnest(NEW.str_climate) as str_climate) x
;

--RAISE NOTICE 'v_str_grade_reorder:%', v_str_grade_reorder;
--RAISE NOTICE 'v_str_climate_reorder:%', v_str_climate_reorder;

update loft_a_assortment
set str_grade = v_str_grade_reorder,
str_climate = v_str_climate_reorder
where product = NEW.product
and time = NEW.time
;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.upd_array_order() OWNER TO psql;

--
-- TOC entry 2081 (class 1255 OID 85203465)
-- Name: update_cc_current_price(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_current_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
  UPDATE loft_ma_stylecolorattributes sc
  SET cc_current_price = sub.max_price::text
  FROM (
    SELECT parent_id AS product,
           MAX(current_price::numeric) AS max_price
    FROM loft_ma_sizeattributes
    WHERE current_price IS NOT NULL
      AND current_price ~ '^[0-9]+(\.[0-9]+)?$'
      AND current_price::numeric > 0
    GROUP BY parent_id
  ) sub
  WHERE sc.product = sub.product
    AND (sc.cc_current_price IS DISTINCT FROM sub.max_price::text);
  RETURN NULL;
END;
$_$;


ALTER FUNCTION public.update_cc_current_price() OWNER TO psql;

--
-- TOC entry 2061 (class 1255 OID 67697828)
-- Name: update_cc_floorset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_floorset() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      IF NEW.cc_delivery_name LIKE '20%' THEN
          NEW.cc_floorset := SUBSTRING(NEW.cc_delivery_name FROM 1 FOR 5) || INITCAP(SUBSTRING(NEW.cc_delivery_name FROM 6 FOR 3));
      ELSE
          NEW.cc_floorset := NEW.cc_delivery_name;
      END IF;
      RETURN NEW;
  END;
  $$;


ALTER FUNCTION public.update_cc_floorset() OWNER TO psql;

--
-- TOC entry 2062 (class 1255 OID 67697829)
-- Name: update_cc_season(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_season() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  if COALESCE(NEW.cc_storeset,'') != COALESCE(OLD.cc_storeset,'') THEN

    update loft_ma_stylecolorattributes a
    set cc_season = (select target_value from loft_l_dependencylookup 
                    where lookup_id = 'storeset' and target_id = 'season' and lookup_value = NEW.cc_storeset
                    ),
        cc_storeset_period = (select target_value from loft_l_dependencylookup 
                    where lookup_id = 'storeset' and target_id = 'storeset_period' and lookup_value = NEW.cc_storeset
                    )
    where product = NEW.product;
  
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_cc_season() OWNER TO psql;

--
-- TOC entry 2063 (class 1255 OID 67697830)
-- Name: update_cc_size_concept_in_assortment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_size_concept_in_assortment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_sty_size_type text;
    v_sty_specstyleid text;
    v_hasbeenpublished int;
    v_remainingcc int;
    v_missy_related_style text;
    v_missy_related_stylecolor text;
    v_parent_sty_specstyleid text;
    v_parent_cc_specstyle_cccolor text;
    v_remove_size_concept text;
    s1 text;
    s2 text;
    v_nonremovable_cc int;
BEGIN
  
  --RAISE NOTICE 'Inside update_cc_size_concept_in_assortment';
  --RAISE NOTICE 'NEW.record_state: %', NEW.record_state;
  --RAISE NOTICE 'NEW.product: %', NEW.product;
  --RAISE NOTICE 'OLD.record_state: %', OLD.record_state;

  select count(*) into v_nonremovable_cc from
    (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment, can_remove_from_assortment(a.product, b.location) is_removable
     from loft_ma_stylecolorattributes a, loft_ma_stylecolorchannelattributes b, loft_h_prodstd c, loft_ma_styleattributes d, loft_d_product e 
     where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
     and cc_missy_related_stylecolor = NEW.product
    ) x where is_removable is false;

  select sty_size_type
  into v_remove_size_concept
  FROM loft_ma_stylecolorattributes a
  JOIN loft_h_prodstd b ON a.product = b.id
  JOIN loft_ma_styleattributes c ON b.ancestor0 = c.product
  WHERE a.product = new.product
  ;

  select sty_specstyleid into v_sty_specstyleid
  from loft_ma_styleattributes
  where product = (select ancestor0 from loft_h_prodstd where id = NEW.product)
  ;
  

  IF (NEW.record_state=1 and OLD.record_state=0)
  THEN

      -- Code to check/remove Size concepts from assortment if MISSY/CURVY_MISSY is being removed
      IF v_remove_size_concept in ('MISSY', 'CURVY_MISSY') and v_nonremovable_cc > 0 THEN
         update loft_ma_stylecolorchannelattributes set record_state = 0 where product = NEW.product;

         RETURN NEW;

      ELSIF v_remove_size_concept in ('MISSY', 'CURVY_MISSY') and v_nonremovable_cc = 0 THEN

          update loft_ma_stylecolorchannelattributes set record_state = 1
          where product in (select product from loft_ma_stylecolorattributes where cc_missy_related_stylecolor = NEW.product and product <> NEW.product)
          ;

          -- JR added 20250312 to free up spec style color SUP-2125
          update loft_ma_stylecolorattributes set cc_specstyle_cccolor = null
          where cc_missy_related_stylecolor = NEW.product
          ;

          update loft_ma_stylecolorattributes
          set cc_size_concepts_in_assortment = '{}'::text[] 
          where product = NEW.product;

          INSERT INTO sync_stylecolorchannel (product)
          SELECT product from loft_ma_stylecolorattributes where cc_missy_related_stylecolor = NEW.product and product <> NEW.product;

      ELSE
    
          RAISE NOTICE 'v_remove_size_concept: %', v_remove_size_concept;
          
    
          update loft_ma_stylecolorattributes
          set cc_size_concepts_in_assortment = array_remove(cc_size_concepts_in_assortment, v_remove_size_concept) 
          where product = (select cc_missy_related_stylecolor from loft_ma_stylecolorattributes where product = new.product)
          ;

          -- JR added 20250312 to free up spec style color SUP-2125
          update loft_ma_stylecolorattributes set cc_specstyle_cccolor = null where product = NEW.product;

      END If;

    
      select count(*) into v_hasbeenpublished
      from loft_ma_stylecolorfloorsetattributes a
      where a.product = NEW.product
        and (fc_published_specstyleid = v_sty_specstyleid OR ir_published_specstyleid = v_sty_specstyleid)
      ;
    
      select count(*) into v_remainingcc
      from loft_ma_stylecolorchannelattributes a
      where product in (select id from loft_h_prodstd where ancestor0 in (select ancestor0 from loft_h_prodstd where id = NEW.product))
        and product != NEW.product
        and record_state = 0;
    
      IF (v_hasbeenpublished > 0 and v_remainingcc = 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select ancestor0 as product, 'NA' as time, 'DEL1' as publish_type 
          from loft_h_prodstd 
          where id = NEW.product;
      END IF;
    
      INSERT INTO sync_stylecolorchannel (product)
      SELECT NEW.product;

      -- JR added 20250312 to free up spec styles SUP-2125
      -- When Stylecolor being removed from Assortment is the last Stylecolor in the Style to be removed from assortment, even the Spec Style should be disassociated
      update loft_ma_styleattributes set sty_specstyleid = null where product in
      (select style from (
           select style, sum(in_assortment_count) as in_assortment_count, sum(not_in_assortment_count) as not_in_assortment_count 
           from(
                select a.ancestor0 style, count(distinct c.product) in_assortment_count, 0 as not_in_assortment_count 
                from loft_h_prodstd a, loft_h_prodstd b, loft_ma_stylecolorchannelattributes c 
                where a.ancestor0 = b.ancestor0 and b.id = c.product and a.id = NEW.product and c.record_state = 0 group by a.ancestor0
                union all
                select a.ancestor0 style, 0 as in_assortment_count, count(distinct c.product) as not_in_assortment_count 
                from loft_h_prodstd a, loft_h_prodstd b, loft_ma_stylecolorchannelattributes c 
                where a.ancestor0 = b.ancestor0 and b.id = c.product and a.id = NEW.product and c.record_state = 1 group by a.ancestor0
           ) x
           group by style
       ) y
       where in_assortment_count = 0
      );

  END IF;

  IF (NEW.record_state=0 and OLD.record_state=1)
  THEN
      RAISE NOTICE 'Inside second If';
      
      select b.sty_specstyleid into v_parent_sty_specstyleid
      from loft_ma_styleattributes a, loft_ma_styleattributes b 
      where a.product in (select ancestor0 from loft_h_prodstd where id = NEW.product)
      and a.sty_missy_related_style = b.product;

      update loft_ma_styleattributes a
      set sty_specstyleid = l.target_value
      from loft_l_dependencylookup l, loft_h_prodstd b
      where a.product = b.ancestor0 and b.id = NEW.product
        and l.target_id = a.sty_size_type
      and l.lookup_value = v_parent_sty_specstyleid
        and l.lookup_id = 'master_specstyle_id'
      ;

      select b.cc_specstyle_cccolor into v_parent_cc_specstyle_cccolor
      from loft_ma_stylecolorattributes a, loft_ma_stylecolorattributes b 
where a.product = NEW.product
      and a.cc_missy_related_stylecolor = b.product;

      update loft_ma_stylecolorattributes a
      set cc_specstyle_cccolor = v_parent_cc_specstyle_cccolor
      from loft_h_prodstd h, loft_ma_styleattributes s
      where a.product = h.id
        and h.ancestor0 = s.product
        and a.product = NEW.product
        and COALESCE(cc_specstyle_cccolor,'') != COALESCE(v_parent_cc_specstyle_cccolor, '')
        and (COALESCE(v_parent_cc_specstyle_cccolor, ''),s.sty_specstyleid) in (select target_value, lookup_value from loft_l_dependencylookup where lookup_id = 'sty_specstyleid' and target_id = 'cc_specstylecolorid');


  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_cc_size_concept_in_assortment() OWNER TO psql;

--
-- TOC entry 2064 (class 1255 OID 67697832)
-- Name: update_cc_use_sys_floorset(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_use_sys_floorset() RETURNS trigger
    LANGUAGE plpgsql
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
-- TOC entry 2054 (class 1255 OID 67697833)
-- Name: update_ccticketpricechannel_ovr(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ccticketpricechannel_ovr() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN

  update loft_ma_stylecolorchannelattributes
  set ccticketpricechannel_override = CASE WHEN NEW.ccticketpricechannel_override_txt = '' then NULL else REPLACE(NEW.ccticketpricechannel_override_txt,'$','')::real end,
      ccticketpricechannel_override_txt = CASE WHEN NEW.ccticketpricechannel_override_txt != '' THEN '$' || NEW.ccticketpricechannel_override_txt ELSE '' end
  where product = NEW.product and location = NEW.location;


  RETURN NEW;

END;
$_$;


ALTER FUNCTION public.update_ccticketpricechannel_ovr() OWNER TO psql;

--
-- TOC entry 2077 (class 1255 OID 67697834)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

  v_style_description loft_d_product.description%type;
  v_style_name loft_d_product.name%type;

BEGIN

  select name, description into v_style_name, v_style_description 
  from loft_d_product where id = (select ancestor0 from loft_h_prodstd where id = NEW.product);

  if coalesce(NEW.cc_color_name, '') <> coalesce(OLD.cc_color_name, '') then
    update loft_d_product 
    set description = v_style_description || ':' || NEW.cc_color_name,
        name = v_style_name || ':' || NEW.cc_color_name
    where id = NEW.product;

    update loft_ma_stylecolorattributes a
    set cccolorfamily = (select target_value from loft_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'colorfamily' and lookup_value = NEW.cc_color_name
                        )
       ,cccolor = (select target_value from loft_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'cccolor' and lookup_value = NEW.cc_color_name
                        )
       ,cc_color_type = (select target_value from loft_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'colortype' and lookup_value = NEW.cc_color_name
                        )
       ,cc_print_description = (select target_value from loft_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'printdescription' and lookup_value = NEW.cc_color_name
                        )
       -- SUP-3758 commented out
       --,cc_print_pattern_type = (select target_value from loft_l_dependencylookup 
       --                  where lookup_id = 'colorname' and target_id = 'printpattern' and lookup_value = NEW.cc_color_name
       --                 )
    where product = NEW.product;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 2066 (class 1255 OID 67697835)
-- Name: update_ecom_onorder_ovr(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ecom_onorder_ovr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stylecolor text;
BEGIN

  select ancestor0 into v_stylecolor from loft_h_prodstd where id = NEW.product;

  update loft_p_dc_adj
  set dc_sc_finrev_ecom = a.dc_sc_finrev_ecom
  from (select sum(COALESCE(dc_finrev_ecom,0)) as dc_sc_finrev_ecom
        from loft_p_dc_adj_size
        where product in (select id from loft_h_prodstd where ancestor0 = v_stylecolor)
          and time = NEW.time
        ) a
  where product = v_stylecolor
    and time = NEW.time;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_ecom_onorder_ovr() OWNER TO psql;

--
-- TOC entry 2080 (class 1255 OID 67697836)
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

select cast(addoff as real), cast(event as text), cast(eo as real) into v_addoff, v_event, v_eo
from loft_p_itemprice 
where product = NEW.product
and location = NEW.location 
and time = NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
from loft_l_priceeventlookup 
where product = NEW.department 
and location = NEW.location 
and ccpriceevent = NEW.event;

select cc_discount_pct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
from loft_ma_stylecolorchannelattributes 
where product = NEW.product 
and location = NEW.location;

EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
table_input_t1 := 'input_t1'||v_uuid;
s1 := 'drop table if exists '||table_input_t1||'';
EXECUTE s1;

s2 := 'create temporary table '||table_input_t1||' as select * from pricing_table where 1=2';
EXECUTE s2;

IF v_cccurp > 0 
THEN 
	v_cccurp := v_cccurp;
ELSE 
	v_cccurp := v_ticketprice;
END IF;

IF v_expression is not null 
THEN
	s3 :=  'insert into '||table_input_t1||' (t_expression,v_cccurp) values('''||v_expression||''', '||v_cccurp||')';
	EXECUTE s3;
	execute 'select '||v_expression||' from '||table_input_t1||'' into v_val;
	fep := coalesce(v_eo,v_val,v_cccurp);
ELSE 
	fep := coalesce(v_eo,v_cccurp);
END IF;

s4 := 'select '||fep||'';
EXECUTE s4 into final_eff_aur;

update loft_p_itemprice a 
set eff_aur = final_eff_aur 
where product = NEW.product
and location = NEW.location 
and time = NEW.time;

--Insert related cc record; if it already exists then update the related cc to match the missy cc
insert into loft_p_itemprice 
select b.product, a.location, a.time, a.addoff, a.eo, a.eff_aur, a.department, a.event, a.eventdate, a.version_id, a.created_at, a.created_by, a.updated_at, a.updated_by, a.record_state, a.addoff_ecom
from loft_p_itemprice a
join loft_ma_stylecolorattributes b
on a.product = b.cc_missy_related_stylecolor
join loft_ma_stylecolorchannelattributes c
on b.product = c.product
where a.product = NEW.product
and b.product <> NEW.product
on conflict (product, location, time)
do update set
addoff 		  =  EXCLUDED.addoff
,eo 		  =  EXCLUDED.eo
,eff_aur 	  =  EXCLUDED.eff_aur
,event 		  =  EXCLUDED.event
,addoff_ecom  =  EXCLUDED.addoff_ecom
;

-- SUP-3892 Queue Size Concepts to Plan Queue
insert into plan_queue (product, location, initiator, initiated_at, updated_at)
select distinct
       a.product
      ,a.location
      ,new.updated_by as initiator
      ,now() as initiated_at
      ,now() as updated_at
from loft_ma_stylecolorchannelattributes a
WHERE
  missy_related_stylecolor = NEW.product
  and product != NEW.product
  and record_state = 0
  and product not in (select product from plan_queue where completed is null);

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 2067 (class 1255 OID 67697837)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  if NEW.levelid = 'style'::text then
    if NEW.name <> OLD.name or NEW.description <> OLD.description then
      update loft_d_product x
      set description = NEW.description || ':' || y.cccolor,
          name = NEW.name || ':' || y.cccolor
      from (select a.id, b.cccolor from loft_h_prodstd a, loft_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
      where x.id = y.id;
  
      update loft_d_product x
      set description = NEW.description || '_' || y.sty_size_type
         ,name = NEW.name || '_' || y.sty_size_type
      from (select product as id, sty_size_type from loft_ma_styleattributes where product != sty_missy_related_style and sty_missy_related_style = NEW.id and COALESCE(sty_specstyleid,'') = '') y
      where x.id = y.id;

      update loft_ma_styleattributes set sty_stylenumber_name = NEW.name || ', ' || NEW.description
      where product = NEW.id;

      update loft_ma_styleattributes set sty_stylenumber_name = NEW.name || '_' || sty_size_type || ', ' || NEW.description || '_' || sty_size_type
      where product != sty_missy_related_style and sty_missy_related_style = NEW.id and COALESCE(sty_specstyleid,'') = '';
  
    end if;
  end if;

  if NEW.levelid = 'stylecolor'::text then
    if NEW.name <> OLD.name or NEW.description <> OLD.description then
      update loft_ma_stylecolorattributes set cc_stylecolornumber_name = NEW.name || ', ' || NEW.description
      where product = NEW.id;
    end if;
  end if;



  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 2068 (class 1255 OID 67697838)
-- Name: update_p_dc_adj_size_publish(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_p_dc_adj_size_publish() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

 DROP TABLE IF EXISTS skuIds;

 CREATE TEMPORARY TABLE IF NOT EXISTS skuIds AS
 SELECT product
 FROM loft_ma_sizeattributes
 WHERE parent_id = NEW.product
 ;

 UPDATE loft_p_dc_adj_size
 SET 
	dc_publish = NEW.dc_publish
	, dc_publish_ecom = NEW.dc_publish_ecom
	, lastpub_published_at = NEW.lastpub_published_at
	, lastpub_published_user = NEW.lastpub_published_user
 WHERE product in (SELECT product FROM skuIds)
 AND time = NEW.time
 ;

 RETURN NEW;

 DROP TABLE IF EXISTS skuIds;

END;
$$;


ALTER FUNCTION public.update_p_dc_adj_size_publish() OWNER TO psql;

--
-- TOC entry 2069 (class 1255 OID 67697839)
-- Name: update_pim_style_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_pim_style_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_subclass text;
  v_index text;
BEGIN

  select ancestor0 into v_subclass from loft_h_prodstd where id = NEW.product;
  select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from loft_l_dependencylookup;

  if OLD.pim_style_id <> NEW.pim_style_id
  then
    update loft_ma_stylecolorattributes set pim_stylecolor_id = null 
    where product in (select id from loft_h_prodstd where ancestor0 = NEW.product);

    if OLD.pim_style_id is not null 
    then
      insert into loft_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
      values('subclass', v_subclass, 'pim_style_id', OLD.pim_style_id, v_index);
    end if;

    if NEW.pim_style_id is not null
    then
      delete from loft_l_dependencylookup 
      where lookup_id = 'subclass' and lookup_value = v_subclass 
        and target_id = 'pim_style_id' and target_value = NEW.pim_style_id;

      select a.erp_style_id,a.sty_dept,a.sty_typ,a.sty_subtyp_1,a.sty_style_description,a.sty_vendor_id,a.sty_vendor_name,a.sty_brand_id,a.sty_brand_name,a.sty_source,a.sty_length_height,a.sty_neckline,a.sty_end_use,a.sty_knit_woven,a.sty_development_path,a.sty_product_type,a.sty_fabric_material,a.ccstylecreatedate,a.sty_closure,a.sty_hem_finish,a.sty_waist_rise,a.sty_size_run_name,a.sty_size_run_id
      into NEW.erp_style_id,NEW.sty_dept,NEW.sty_typ,NEW.sty_subtyp_1,NEW.sty_style_description,NEW.sty_vendor_id,NEW.sty_vendor_name,NEW.sty_brand_id,NEW.sty_brand_name,NEW.sty_source,NEW.sty_length_height,NEW.sty_neckline,NEW.sty_end_use,NEW.sty_knit_woven,NEW.sty_development_path,NEW.sty_product_type,NEW.sty_fabric_material,NEW.ccstylecreatedate,NEW.sty_closure,NEW.sty_hem_finish,NEW.sty_waist_rise,NEW.pim_size_run_name,NEW.pim_size_run_id
      from loft_ma_styleattributes a
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
-- TOC entry 2070 (class 1255 OID 67697840)
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
  from loft_ma_styleattributes a, loft_h_prodstd b
  where a.product = b.ancestor0 and b.id = NEW.product;

  if OLD.pim_stylecolor_id <> NEW.pim_stylecolor_id and NEW.pim_stylecolor_id is not null
  then
      select a.erp_stylecolor_id,a.ccstylecolorcreatedate,a.cc_marketing,a.cc_floorset,a.cc_pim_status,a.cc_pim_first_available_date,a.cc_pim_discontinue_date,a.cc_first_inv_date,a.cc_last_rec_date,a.cc_weighted_rec_date,a.cc_first_md_date,a.cc_last_md_date,a.cc_pricing_tier,a.cc_image_url,a.cc_description,a.cc_c_mh_ss,a.cc_exclusive,a.cc_print_pattern,a.cc_denim_wash,a.cccolor,a.cccolorfamily,a.cc_color_code,a.cc_msrp,a.cc_current_price,a.cc_estimated_cost,a.cc_actual_cost,a.cc_style_group,a.cc_rtv,a.cc_fulfillment,a.cc_cc_plan,a.cc_flow
      into NEW.erp_stylecolor_id,NEW.ccstylecolorcreatedate,NEW.cc_marketing,NEW.cc_floorset,NEW.cc_pim_status,NEW.cc_pim_first_available_date,NEW.cc_pim_discontinue_date,NEW.cc_first_inv_date,NEW.cc_last_rec_date,NEW.cc_weighted_rec_date,NEW.cc_first_md_date,NEW.cc_last_md_date,NEW.cc_pricing_tier,NEW.cc_image_url,NEW.cc_description,NEW.cc_c_mh_ss,NEW.cc_exclusive,NEW.cc_print_pattern,NEW.cc_denim_wash,NEW.cccolor,NEW.cccolorfamily,NEW.cc_color_code,NEW.cc_msrp,NEW.cc_current_price,NEW.cc_estimated_cost,NEW.cc_actual_cost,NEW.cc_style_group,NEW.cc_rtv,NEW.cc_fulfillment,NEW.cc_cc_plan,NEW.cc_flow
      from loft_ma_stylecolorattributes a
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
-- TOC entry 2071 (class 1255 OID 67697841)
-- Name: update_price_bands(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_price_bands() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_style text;
BEGIN
  
  IF (COALESCE(NEW.ccticketpricechannel_override,0) !=0) AND (NEW.ccticketpricechannel_override != OLD.ccticketpricechannel_override)
  THEN
        select ancestor0 into v_style
        from loft_h_prodstd where id = NEW.product
        ;
      
        update loft_ma_stylecolorattributes 
        set cc_price_band = tp.price_band
        from (select lookup_value as ticketprice, target_value as price_band from loft_l_dependencylookup where target_id = 'sty_price_bands') tp
        where tp.ticketprice::real = NEW.ccticketpricechannel_override::real
          and product = NEW.product
        ;

        update loft_ma_styleattributes
        set sty_price_bands = tp.price_band
        from (select max(scc.ccticketpricechannel_override::real) as ticketprice 
        from loft_ma_stylecolorchannelattributes scc
        where product in (select id from loft_h_prodstd where ancestor0 = v_style)) scc
        ,(select lookup_value as ticketprice, target_value as price_band from loft_l_dependencylookup where target_id = 'sty_price_bands') tp
        where scc.ticketprice::real = tp.ticketprice::real
          and product = v_style
        ;
          
  END IF;
  
  IF (COALESCE(NEW.ccticketpricechannel,0) !=0) AND (NEW.ccticketpricechannel != OLD.ccticketpricechannel)
  THEN
        select ancestor0 into v_style
        from loft_h_prodstd where id = NEW.product
        ;
      
        update loft_ma_stylecolorattributes 
        set cc_price_band = tp.price_band
        from (select lookup_value as ticketprice, target_value as price_band from loft_l_dependencylookup where target_id = 'sty_price_bands') tp
        where tp.ticketprice::real = NEW.ccticketpricechannel::real
          and product = NEW.product
        ;

        update loft_ma_styleattributes
        set sty_price_bands = tp.price_band
        from (select max(scc.ccticketpricechannel::real) as ticketprice 
        from loft_ma_stylecolorchannelattributes scc
        where product in (select id from loft_h_prodstd where ancestor0 = v_style)) scc
        ,(select lookup_value as ticketprice, target_value as price_band from loft_l_dependencylookup where target_id = 'sty_price_bands') tp
        where scc.ticketprice::real = tp.ticketprice::real
          and product = v_style
        ;
          
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_price_bands() OWNER TO psql;

--
-- TOC entry 2072 (class 1255 OID 67697842)
-- Name: update_publish_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_publish_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  
  if (NEW.is_attr_published = 'true' AND COALESCE(OLD.is_attr_published,'false') != 'true')
  THEN
      NEW.attr_published_at = date_trunc('sec'::text, CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York');
      NEW.attr_published_user = COALESCE((select email from user_metadata where uid = NEW.updated_by), NEW.updated_by);
  
      insert into sync_outbound_dataqueue (product,time,publish_type)
      select NEW.product, NEW.time, 'ATTR' as publish_type;
  
  END IF;
  
  if (NEW.is_fc_published = 'true' AND COALESCE(OLD.is_fc_published,'false') != 'true')
  THEN
      NEW.fc_published_at = date_trunc('sec'::text, CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York');
      NEW.fc_published_user = COALESCE((select email from user_metadata where uid = NEW.updated_by), NEW.updated_by);
      NEW.fc_published_specstyleid = (select sty_specstyleid from loft_stylecolor_hier_attr where product = NEW.product);
      NEW.fc_published_specstylecolorid = (select cc_specstylecolorid from loft_ma_stylecolorattributes where product = NEW.product);
  
      insert into sync_outbound_dataqueue (product,time,publish_type)
      select NEW.product, NEW.time, 'FC' as publish_type;
  
  END IF;
  
  if (NEW.is_ir_published = 'true' AND COALESCE(OLD.is_ir_published,'false') != 'true')
  THEN
      NEW.ir_published_at = date_trunc('sec'::text, CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York');
      NEW.ir_published_user = COALESCE((select email from user_metadata where uid = NEW.updated_by), NEW.updated_by);
      NEW.ir_published_specstyleid = (select sty_specstyleid from loft_stylecolor_hier_attr where product = NEW.product);
      NEW.ir_published_specstylecolorid = (select cc_specstylecolorid from loft_ma_stylecolorattributes where product = NEW.product);
  
      insert into sync_outbound_dataqueue (product,time,publish_type)
      select NEW.product, NEW.time, 'IR' as publish_type;
  
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_publish_attributes() OWNER TO psql;

--
-- TOC entry 2073 (class 1255 OID 67697843)
-- Name: update_specstyle_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_specstyle_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_class text;
  v_index text;
  specImg text;
  v_hasbeenpublished int;
  v_count integer;
BEGIN

  select count(*) into v_count
  from loft_ma_styleattributes where product <> NEW.product and sty_specstyleid = NEW.sty_specstyleid and coalesce(NEW.sty_specstyleid, '') <> '';
  
  if v_count > 0 then 
    --RAISE NOTICE 'Inside revert logic';
    update loft_ma_styleattributes set sty_specstyleid = OLD.sty_specstyleid where product = NEW.product;
  else
    select ancestor1 into v_class from loft_h_prodstd where id = NEW.product;
    select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from loft_l_dependencylookup;
  
    if COALESCE(OLD.sty_specstyleid,'0') <> COALESCE(NEW.sty_specstyleid,'0')
    then
      RAISE NOTICE 'Inside 1: ';
      update loft_ma_stylecolorattributes set cc_specstyle_cccolor = ''
      where product in (select id from loft_h_prodstd where ancestor0 = NEW.product);
  
      if (OLD.sty_specstyleid is not null and (OLD.sty_specstyleid not in (select bbr_style from bbr_status_check) OR OLD.sty_specstyleid in (select bbr_style from bbr_status_check where bbr_style is not null and validseasons > 0)))
      then
        insert into loft_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
        values('class', v_class, 'sty_specstyleid', OLD.sty_specstyleid, v_index);
      end if;
  
      if NEW.sty_specstyleid is not null
      then
        delete from loft_l_dependencylookup 
        where lookup_id = 'class' and lookup_value = v_class 
          and target_id = 'sty_specstyleid' and target_value = NEW.sty_specstyleid;
  
        update loft_ma_styleattributes a
        set sty_missy_related_style_bbr = (select target_value from loft_l_dependencylookup 
                                           where lookup_id = 'bbr_style_id' and target_id = 'sty_missy_related_style_bbr' and lookup_value = NEW.sty_specstyleid
                                          )
            ,sty_size_range_bbr = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_size_range_bbr' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_size_type_bbr = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_size_type_bbr' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_garment_content = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_garment_content' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_stretch_level = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_stretch_level' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_closure = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_closure' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_fit_block = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_fit_block' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_fit_intent = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_fit_intent' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_leg_shape = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_leg_shape' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_length = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_length' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_placement = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_placement' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_rise = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_rise' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_type = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_type' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_primary_material_bbr = (select target_value from loft_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_material' and lookup_value = NEW.sty_specstyleid
                                  ) 
        where product = NEW.product;
  
        update loft_ma_styleattributes a
        set sty_specstyleid = l.target_value
        from loft_l_dependencylookup l
        where a.product != NEW.product
          and a.sty_missy_related_style = NEW.product
          and l.target_id = a.sty_size_type
          and l.lookup_value = NEW.sty_specstyleid
        ;
  
        select img into specImg from loft_specimages where left(product,6) = new.sty_specstyleid limit 1;
        if (specImg is not null)
        then
        -- backup previous version of images before overwriting
                insert into loft_ma_imgattributes_archive SELECT *, now() from loft_ma_imgattributes where product in (select id from loft_h_prodstd where ancestor0=NEW.product);
                update loft_ma_imgattributes set img = specImg where product in (select id from loft_h_prodstd where ancestor0=NEW.product);
        end if;
  
        if COALESCE(OLD.sty_specstyleid,'') = ''
        then
  
          update loft_ma_styleattributes
          set style_description = (select description from loft_d_product where id = NEW.product)
            ,sty_vendor_style_description = (select name from loft_d_product where id = NEW.product)
          where product = NEW.product;
        
        end if;
  
        update loft_d_product
        set name = NEW.sty_specstyleid
           ,description = (select target_value from loft_l_dependencylookup 
                            where lookup_id = 'bbr_style_id' and target_id = 'bbr_style_desc' and lookup_value = NEW.sty_specstyleid
                          )
        where id = NEW.product;  
        
      end if;
    end if;
  
    if COALESCE(NEW.sty_specstyleid,'') = ''
    then
      RAISE NOTICE 'Inside 2: ';
      update loft_ma_stylecolorattributes
      set cc_specstyle_cccolor = ''
      where product in (select id from loft_h_prodstd where ancestor0=NEW.product);
  
      update loft_ma_styleattributes a
      set sty_missy_related_style_bbr = null
          ,sty_size_range_bbr = null
          ,sty_size_type_bbr = null
      where product = NEW.product;
  
      update loft_ma_styleattributes a
      set sty_specstyleid = null
      where product != NEW.product
        and sty_missy_related_style = NEW.product;
  
      update loft_d_product
      set name = (select sty_vendor_style_description from loft_ma_styleattributes where product = NEW.product)
         ,description = (select style_description from loft_ma_styleattributes where product = NEW.product)
      where id = NEW.product   
      ;
  
      insert into loft_ma_imgattributes_archive SELECT *, now() from loft_ma_imgattributes where product in (select id from loft_h_prodstd where ancestor0=NEW.product);
  
      update loft_ma_imgattributes a
      set img = b.img
      from (select product, img, sync_date, ROW_NUMBER() OVER (PARTITION BY product ORDER BY sync_date desc) AS rank from loft_ma_imgattributes_archive) b
      where b.product = a.product
      and a.product  in (select id from loft_h_prodstd where ancestor0=NEW.product)
        and b.rank = 2
      ;
  
      select count(*) into v_hasbeenpublished
      from loft_ma_stylecolorfloorsetattributes a
      where a.product in (select id from loft_h_prodstd where ancestor0 = NEW.product)
        and (fc_published_specstyleid = OLD.sty_specstyleid OR ir_published_specstyleid = OLD.sty_specstyleid)
      ;
  
      IF (v_hasbeenpublished > 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select NEW.product, 'NA', 'DEL2' as publish_type;
      END IF;
  
    end if;
  -- SUP-3892 Queue Size Concepts to Plan Queue
  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a,
  loft_h_prodstd b,
  loft_ma_styleattributes c
  WHERE
    a.product = b.id and b.ancestor0 = c.product
    and sty_missy_related_style = NEW.product and c.product <> sty_missy_related_style
    and a.record_state = 0
    and a.product not in (select product from plan_queue where completed is null);
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_specstyle_id() OWNER TO psql;

--
-- TOC entry 2079 (class 1255 OID 67697845)
-- Name: update_specstylecolor_id(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_specstylecolor_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_specstyleid text;
  v_index text;
  v_count integer;
BEGIN
  select sty_specstyleid into v_specstyleid from (select sty_specstyleid from loft_ma_styleattributes where product = (select ancestor0 from loft_h_prodstd where id = NEW.product)) x;

  select count(*) into v_count
  from loft_ma_stylecolorattributes
  where product <> NEW.product
  and cc_specstylecolorid = (v_specstyleid || '-' || LEFT(NEW.cc_specstyle_cccolor,6)) and coalesce(NEW.cc_specstyle_cccolor, '') <> '';

  if v_count > 0 then 
    --RAISE NOTICE 'Inside revert logic';
    update loft_ma_stylecolorattributes set cc_specstyle_cccolor = OLD.cc_specstyle_cccolor where product = NEW.product;
  else
    select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from loft_l_dependencylookup;
  
    if COALESCE(OLD.cc_specstyle_cccolor,'') <> COALESCE(NEW.cc_specstyle_cccolor,'')
    then
  
      if (COALESCE(OLD.cc_specstyle_cccolor, '') <> '' and (v_specstyleid || '-' ||LEFT(OLD.cc_specstyle_cccolor,6) not in (select bbr_stylecolor from bbr_status_check) OR v_specstyleid || '-' ||LEFT(OLD.cc_specstyle_cccolor,6) in (select bbr_stylecolor from bbr_status_check where validseasons > 0)))
      then
        insert into loft_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
        values('sty_specstyleid', v_specstyleid, 'cc_specstylecolorid', OLD.cc_specstyle_cccolor, v_index);
      end if;
  
      if COALESCE(NEW.cc_specstyle_cccolor,'') <> ''
      then
        delete from loft_l_dependencylookup 
        where lookup_id = 'sty_specstyleid' and lookup_value = v_specstyleid 
          and target_id = 'cc_specstylecolorid' and target_value = NEW.cc_specstyle_cccolor;
  
        update loft_ma_stylecolorattributes a
        set cc_specstylecolorid = (v_specstyleid || '-' || LEFT(NEW.cc_specstyle_cccolor,6))
           ,cc_color_name = NEW.cc_specstyle_cccolor
        where product = NEW.product;
  
        update loft_ma_stylecolorattributes a
        set cc_specstyle_cccolor = NEW.cc_specstyle_cccolor
        from loft_h_prodstd h, loft_ma_styleattributes s
        where a.product = h.id
          and h.ancestor0 = s.product
          and a.product != NEW.product
          and a.cc_missy_related_stylecolor = NEW.product
          and COALESCE(cc_specstyle_cccolor,'') != NEW.cc_specstyle_cccolor
          and (NEW.cc_specstyle_cccolor,s.sty_specstyleid) in (select target_value, lookup_value from loft_l_dependencylookup where lookup_id = 'sty_specstyleid' and target_id = 'cc_specstylecolorid');
        
      end if;
    end if;
  
    if COALESCE(NEW.cc_specstyle_cccolor,'') = ''
    then
      update loft_ma_stylecolorattributes a
      set cc_specstylecolorid = ''
      where product = NEW.product;
  
      update loft_ma_stylecolorattributes a
      set cc_specstylecolorid = ''
         ,cc_specstyle_cccolor = ''
      where a.product != NEW.product
        and a.cc_missy_related_stylecolor = NEW.product
      ;
      
    end if;

    -- SUP-3892 Queue Size Concepts to Plan Queue
    insert into plan_queue (product, location, initiator, initiated_at, updated_at)
    select distinct
           a.product
          ,a.location
          ,new.updated_by as initiator
          ,now() as initiated_at
          ,now() as updated_at
    from loft_ma_stylecolorchannelattributes a
    WHERE
      missy_related_stylecolor = NEW.product
      and product != NEW.product
      and record_state = 0
      and product not in (select product from plan_queue where completed is null);
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_specstylecolor_id() OWNER TO psql;

--
-- TOC entry 2083 (class 1255 OID 67697846)
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
v_old_sty_size_range text;
v_new_sty_size_range text;

BEGIN

if NEW.sty_size_range <> OLD.sty_size_range then

  select id into v_style from loft_d_product where levelid='style' and id=NEW.product;
  select  OLD.sty_size_range into v_old_sty_size_range;

  select NEW.sty_size_range into v_new_sty_size_range;
  
  select NEW.sty_size_range||' - '||ancestor1 into v_new_ccrangecode
  from
      loft_h_prodstd
  where
      id=v_style
  limit 1;


  IF NEW.sty_missy_related_style = NEW.product
  THEN
    update loft_ma_styleattributes s
    set sty_size_range = l.related_size_size_range_id
    from (select id as style, ancestor1 as class from loft_h_prodstd) h
        ,(select * from loft_ma_styleattributes) s2
        ,(select distinct related_size_class, related_size_size_range_id, master_style_size_range_id from loft_l_size_concept_lookups) l
    where s.sty_missy_related_style = v_style
    and s.sty_missy_related_style != s.product
    and h.style = s.product
    and s2.product = s.sty_missy_related_style
    and l.related_size_class = h.class
    and l.master_style_size_range_id = s2.sty_size_range
    ;

  END IF;

  
  EXECUTE '(select uuid_generate_v4()::text)' into v_uuid_temp;
  EXECUTE '(select replace('''||v_uuid_temp||''',''-'',''_'')::text)' into v_uuid;
  
  table_temp_sub_exists:= 'table_temp_sub_exists'||v_uuid;
  table_temp_sub_not_exists:= 'table_temp_sub_not_exists'||v_uuid;
  
  s0 := 'create temporary table '||table_temp_sub_exists||' as
      select a.product, a.ccrangecode as old_ccrangecode, '''||v_new_ccrangecode||''' new_ccrangecode, validsizes_store, validsizes_ecom, f.arr_all_sizes_for_mins, f.sizemin_store, f.sizemin_ecom
      from loft_ma_stylecolorchannelattributes a, 
           (select id, ancestor0 as style, ancestor2 as class from loft_h_prodstd where ancestor0='''||v_style||''') h, 
           (select class,size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from loft_l_size_range_validsize_defaults) f
      where a.product = h.id and h.class = f.class and f.sty_size_range = '''||v_new_sty_size_range||'''
      ';
  
  
  s1 := 'UPDATE loft_ma_stylecolorchannelattributes a
  set ccrangecode=b.new_ccrangecode
     ,cc_validsizes_store=b.validsizes_store
     ,cc_validsizes_ecom=b.validsizes_ecom
     ,arr_all_sizes_for_mins=b.arr_all_sizes_for_mins
     ,sizemin_store=b.sizemin_store
     ,sizemin_ecom=b.sizemin_ecom
  from '||table_temp_sub_exists||' b
  where a.product=b.product
  and b.new_ccrangecode is not null
  and a.product in (select product from '||table_temp_sub_exists||' where new_ccrangecode is not null)
  ';

  
  EXECUTE s0;
  EXECUTE s1;

  -- SUP-3892 Queue Size Concepts to Plan Queue
  insert into plan_queue (product, location, initiator, initiated_at, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a,
  loft_h_prodstd b,
  loft_ma_styleattributes c
  WHERE
    a.product = b.id and b.ancestor0 = c.product
    and sty_missy_related_style = NEW.product and c.product <> sty_missy_related_style
    and a.record_state = 0
    and a.product not in (select product from plan_queue where completed is null);

end if;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_stylecolorchannelattributes_ccrangecode() OWNER TO psql;

--
-- TOC entry 2076 (class 1255 OID 67697847)
-- Name: update_subclass(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_subclass() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  update loft_h_prodstd
  set ancestor0 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from loft_l_size_concept_lookups a, (select * from loft_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where id = x.product
  ;

  update loft_h_prodstd
  set ancestor1 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from loft_l_size_concept_lookups a, (select * from loft_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where ancestor0 = x.product
  ;

  update loft_h_prodstd
  set ancestor2 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from loft_l_size_concept_lookups a, (select * from loft_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where ancestor1 = x.product
  ;

  -- SUP-3892 Queue Size Concepts to Plan Queue
  insert into plan_queue (product, location, initiator, initiated_at, queued, updated_at)
  select distinct
         a.product
        ,a.location
        ,new.updated_by as initiator
        ,now() as initiated_at
        ,now() as queued
        ,now() as updated_at
  from loft_ma_stylecolorchannelattributes a,
  loft_h_prodstd b,
  loft_ma_styleattributes c
  WHERE
    a.product = b.id and b.ancestor0 = c.product
    and sty_missy_related_style = NEW.id and c.product <> sty_missy_related_style
    and a.record_state = 0
    and a.product not in (select product from plan_queue where completed is null);

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_subclass() OWNER TO psql;

--
-- TOC entry 2065 (class 1255 OID 67697848)
-- Name: update_subclass_name(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_subclass_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  update loft_ma_stylecolorattributes
  set subclass_name = d.name
  from loft_d_product d
  where d.id = NEW.ancestor1
    and product = NEW.id 
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_subclass_name() OWNER TO psql;

--
-- TOC entry 2074 (class 1255 OID 67697849)
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
    select b.product,b.location,a.indx,a.time from loft_ma_dptflrsetattributes a, cart_params_temp b, 
    (select value as plan_current from loft_serviceparams where id='plan_current') c,
    (select value as plan_end from loft_serviceparams where id='plan_end') d
    where 
    a.product=b.product
    and b.product = NEW.scope_product
    and b.location = NEW.scope_location
    and slsstart <= least(plan_end,exitdate) and slsend > greatest(dbt_wk,plan_current)
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
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_climate,str_grade,ssg,flnrange,isfunded,store_count, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_climate,str_grade,ssg,flnrange,isfunded,store_count, c.indx from 
    temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||min(indx) from temp_old group by scope_product, scope_location)
    and c.indx < a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_climate,str_grade,ssg,flnrange,isfunded,store_count, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_climate,str_grade,ssg,flnrange,isfunded,store_count, c.indx from 
    temp_old a, temp_new c
    where a.scope_product=c.product and a.scope_location=c.location
    and a.scope_product||a.scope_location||a.indx in (select scope_product||scope_location||max(indx) from temp_old group by scope_product, scope_location)
    and c.indx > a.indx ;

    insert into cart_ranging
    (jsessionid,scope_product,scope_location,scope_start,scope_floorset,str_climate,str_grade,ssg,flnrange,isfunded,store_count, indx)
    select a.jsessionid,scope_product,scope_location,scope_start,c.time,str_climate,str_grade,ssg,flnrange,isfunded,store_count, c.indx from 
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
-- TOC entry 2075 (class 1255 OID 67697850)
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
BEGIN
--v_irw_indx := (select indx from loft_d_time where id =''||NEW.initrcptwk||'');
v_dbtwk_indx := (select indx from loft_d_time where id = ''||NEW.dbt_wk||'');
v_relaunchwk_indx := (select indx from loft_d_time where id = ''||NEW.relaunchweek||'');
v_mdstart_indx := (select indx  from loft_d_time where id = ''||NEW.erlstmkdnwk||'');
--v_lastdcorder_indx := (select indx from loft_d_time where id =''||NEW.lastdcorder||'');
v_exitdate_indx := (select indx  from loft_d_time where id = ''||NEW.exitdate||'');

v_irw_indx := v_dbtwk_indx - 2;
v_initrcptwk := (select id from loft_d_time where indx= v_irw_indx);
v_lastdcorder_indx := v_mdstart_indx - 6;
v_lastdcorder := (select id from loft_d_time where indx= v_lastdcorder_indx);


if (NEW.dbt_wk != OLD.dbt_wk AND OLD.dbt_wk = OLD.act_dbt_wk and new.dbt_wk < new.erlstmkdnwk and old.dbt_wk >= old.plan_current) then
    
    UPDATE loft_ma_stylecolorchannelattributes
    SET act_dbt_wk = NEW.dbt_wk
    WHERE
    product = NEW.product
    and location = NEW.location;

end if;

  --RAISE NOTICE 'Test here 1';

if (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate AND (old.dbt_wk > old.plan_current OR old.exitdate > old.plan_current) AND new.exitdate > new.erlstmkdnwk)
then
  --RAISE NOTICE 'Test here 2';
  update loft_ma_stylecolorchannelattributes
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

  update loft_ma_stylecolorchannelattributes
  set
  plannedselldnwk = NEW.erlstmkdnwk
  where 
  product = NEW.product
  and location = NEW.location
  and plannedselldnwk = OLD.erlstmkdnwk
  ;

end if;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_week_indxes() OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 1821 (class 1259 OID 68983505)
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
-- TOC entry 1822 (class 1259 OID 68983521)
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
-- TOC entry 1561 (class 1259 OID 67697851)
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
-- TOC entry 1562 (class 1259 OID 67697858)
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
-- TOC entry 1988 (class 1259 OID 139694138)
-- Name: bbr_status_check; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bbr_status_check (
    bbr_stylecolor character varying,
    bbr_style text,
    validseasons integer
);


ALTER TABLE public.bbr_status_check OWNER TO psql;

--
-- TOC entry 1563 (class 1259 OID 67697871)
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
-- TOC entry 1564 (class 1259 OID 67697876)
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
-- TOC entry 1565 (class 1259 OID 67697881)
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
-- TOC entry 1566 (class 1259 OID 67697886)
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
-- TOC entry 1567 (class 1259 OID 67697891)
-- Name: bulk_import_run_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_run_params (
    run_id integer NOT NULL,
    param text NOT NULL,
    str_value text
);


ALTER TABLE public.bulk_import_run_params OWNER TO psql;

--
-- TOC entry 1568 (class 1259 OID 67697896)
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
-- TOC entry 1569 (class 1259 OID 67697897)
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
-- TOC entry 1570 (class 1259 OID 67697904)
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
-- TOC entry 1571 (class 1259 OID 67697911)
-- Name: cart_master_bk20240905; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master_bk20240905 (
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


ALTER TABLE public.cart_master_bk20240905 OWNER TO psql;

--
-- TOC entry 1968 (class 1259 OID 136908564)
-- Name: cart_master_temp012391c3_fdca_40ca_b895_45b444f00af9; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp012391c3_fdca_40ca_b895_45b444f00af9 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp012391c3_fdca_40ca_b895_45b444f00af9 OWNER TO psql;

--
-- TOC entry 1895 (class 1259 OID 126597116)
-- Name: cart_master_temp0434a7e3_42bc_49ba_9be3_641eb8bb164e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp0434a7e3_42bc_49ba_9be3_641eb8bb164e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp0434a7e3_42bc_49ba_9be3_641eb8bb164e OWNER TO psql;

--
-- TOC entry 1905 (class 1259 OID 126614263)
-- Name: cart_master_temp05de25ce_419c_47ad_a40e_4f7f4dc6b7fd; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp05de25ce_419c_47ad_a40e_4f7f4dc6b7fd (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp05de25ce_419c_47ad_a40e_4f7f4dc6b7fd OWNER TO psql;

--
-- TOC entry 1932 (class 1259 OID 127775905)
-- Name: cart_master_temp0630f552_9870_4977_aebe_e3356deb1db8; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp0630f552_9870_4977_aebe_e3356deb1db8 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp0630f552_9870_4977_aebe_e3356deb1db8 OWNER TO psql;

--
-- TOC entry 1953 (class 1259 OID 134829073)
-- Name: cart_master_temp0b291c81_8405_4ae9_a226_9320366bf327; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp0b291c81_8405_4ae9_a226_9320366bf327 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp0b291c81_8405_4ae9_a226_9320366bf327 OWNER TO psql;

--
-- TOC entry 1967 (class 1259 OID 136816841)
-- Name: cart_master_temp0e473af9_7bf8_4a0a_b97e_91d8eb17d166; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp0e473af9_7bf8_4a0a_b97e_91d8eb17d166 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp0e473af9_7bf8_4a0a_b97e_91d8eb17d166 OWNER TO psql;

--
-- TOC entry 1912 (class 1259 OID 126651824)
-- Name: cart_master_temp0eacf442_3950_451e_9a1c_b2be9eb909eb; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp0eacf442_3950_451e_9a1c_b2be9eb909eb (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp0eacf442_3950_451e_9a1c_b2be9eb909eb OWNER TO psql;

--
-- TOC entry 1942 (class 1259 OID 128460902)
-- Name: cart_master_temp102e27b4_36cc_4d7c_b920_56e3b859aa04; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp102e27b4_36cc_4d7c_b920_56e3b859aa04 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp102e27b4_36cc_4d7c_b920_56e3b859aa04 OWNER TO psql;

--
-- TOC entry 1944 (class 1259 OID 128638515)
-- Name: cart_master_temp13c79711_d337_41f2_96f5_708d5d00c4ea; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp13c79711_d337_41f2_96f5_708d5d00c4ea (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp13c79711_d337_41f2_96f5_708d5d00c4ea OWNER TO psql;

--
-- TOC entry 1920 (class 1259 OID 127689013)
-- Name: cart_master_temp14d6bfe1_2956_454c_a562_50f8f6fe923b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp14d6bfe1_2956_454c_a562_50f8f6fe923b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp14d6bfe1_2956_454c_a562_50f8f6fe923b OWNER TO psql;

--
-- TOC entry 1936 (class 1259 OID 127973327)
-- Name: cart_master_temp1a7f4686_c221_450d_8094_c2be1cdf6642; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp1a7f4686_c221_450d_8094_c2be1cdf6642 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp1a7f4686_c221_450d_8094_c2be1cdf6642 OWNER TO psql;

--
-- TOC entry 1946 (class 1259 OID 134187401)
-- Name: cart_master_temp20f01f1b_6b85_4eb8_a3bf_cf911cb35047; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp20f01f1b_6b85_4eb8_a3bf_cf911cb35047 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp20f01f1b_6b85_4eb8_a3bf_cf911cb35047 OWNER TO psql;

--
-- TOC entry 1896 (class 1259 OID 126597648)
-- Name: cart_master_temp226b0a32_bf55_4aca_8d1e_7f8689fe28be; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp226b0a32_bf55_4aca_8d1e_7f8689fe28be (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp226b0a32_bf55_4aca_8d1e_7f8689fe28be OWNER TO psql;

--
-- TOC entry 1929 (class 1259 OID 127752632)
-- Name: cart_master_temp25354757_64b2_4f2c_aca4_8df3aec3a0be; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp25354757_64b2_4f2c_aca4_8df3aec3a0be (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp25354757_64b2_4f2c_aca4_8df3aec3a0be OWNER TO psql;

--
-- TOC entry 1876 (class 1259 OID 126299954)
-- Name: cart_master_temp265206b3_b635_479e_bb62_9bca76d9f544; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp265206b3_b635_479e_bb62_9bca76d9f544 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp265206b3_b635_479e_bb62_9bca76d9f544 OWNER TO psql;

--
-- TOC entry 1959 (class 1259 OID 135954079)
-- Name: cart_master_temp2baee5e8_b065_4eb3_a8ea_0d0584ee79fa; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp2baee5e8_b065_4eb3_a8ea_0d0584ee79fa (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp2baee5e8_b065_4eb3_a8ea_0d0584ee79fa OWNER TO psql;

--
-- TOC entry 1890 (class 1259 OID 126394467)
-- Name: cart_master_temp2bd2bd82_f21b_40c0_a115_195401a3d571; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp2bd2bd82_f21b_40c0_a115_195401a3d571 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp2bd2bd82_f21b_40c0_a115_195401a3d571 OWNER TO psql;

--
-- TOC entry 1847 (class 1259 OID 125880897)
-- Name: cart_master_temp2ce55afd_3a14_499b_a37c_719514b98e28; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp2ce55afd_3a14_499b_a37c_719514b98e28 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp2ce55afd_3a14_499b_a37c_719514b98e28 OWNER TO psql;

--
-- TOC entry 1897 (class 1259 OID 126597911)
-- Name: cart_master_temp2ef4543c_4330_4746_94d4_744347a7e86b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp2ef4543c_4330_4746_94d4_744347a7e86b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp2ef4543c_4330_4746_94d4_744347a7e86b OWNER TO psql;

--
-- TOC entry 1900 (class 1259 OID 126604302)
-- Name: cart_master_temp30824baf_3a2f_4d2f_adc1_7457026ce1a4; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp30824baf_3a2f_4d2f_adc1_7457026ce1a4 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp30824baf_3a2f_4d2f_adc1_7457026ce1a4 OWNER TO psql;

--
-- TOC entry 1937 (class 1259 OID 127973753)
-- Name: cart_master_temp31e87039_a6db_43bf_9310_c792213aec88; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp31e87039_a6db_43bf_9310_c792213aec88 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp31e87039_a6db_43bf_9310_c792213aec88 OWNER TO psql;

--
-- TOC entry 1848 (class 1259 OID 125881871)
-- Name: cart_master_temp3215bf9f_10dc_42ab_9823_b0280834688a; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp3215bf9f_10dc_42ab_9823_b0280834688a (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp3215bf9f_10dc_42ab_9823_b0280834688a OWNER TO psql;

--
-- TOC entry 1935 (class 1259 OID 127970193)
-- Name: cart_master_temp341346d5_1030_47c6_8dd1_a3b1fe423316; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp341346d5_1030_47c6_8dd1_a3b1fe423316 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp341346d5_1030_47c6_8dd1_a3b1fe423316 OWNER TO psql;

--
-- TOC entry 1868 (class 1259 OID 126027026)
-- Name: cart_master_temp34136bae_0fb8_4c12_be4b_992a0b08dcb6; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp34136bae_0fb8_4c12_be4b_992a0b08dcb6 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp34136bae_0fb8_4c12_be4b_992a0b08dcb6 OWNER TO psql;

--
-- TOC entry 1913 (class 1259 OID 126654494)
-- Name: cart_master_temp34d03c38_0b42_47e6_bd48_6bf3680d84e8; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp34d03c38_0b42_47e6_bd48_6bf3680d84e8 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp34d03c38_0b42_47e6_bd48_6bf3680d84e8 OWNER TO psql;

--
-- TOC entry 1891 (class 1259 OID 126394941)
-- Name: cart_master_temp35767862_b808_4bac_8b8c_23926cd54b73; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp35767862_b808_4bac_8b8c_23926cd54b73 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp35767862_b808_4bac_8b8c_23926cd54b73 OWNER TO psql;

--
-- TOC entry 1964 (class 1259 OID 136813596)
-- Name: cart_master_temp35f79046_5b20_4a28_9ecf_709e60d73ba9; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp35f79046_5b20_4a28_9ecf_709e60d73ba9 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp35f79046_5b20_4a28_9ecf_709e60d73ba9 OWNER TO psql;

--
-- TOC entry 1984 (class 1259 OID 139520749)
-- Name: cart_master_temp37889c8c_b5b1_4183_842e_60cea1a169ab; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp37889c8c_b5b1_4183_842e_60cea1a169ab (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp37889c8c_b5b1_4183_842e_60cea1a169ab OWNER TO psql;

--
-- TOC entry 1854 (class 1259 OID 125981135)
-- Name: cart_master_temp392ab785_e73b_43c5_bb34_13c90bc5e7e0; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp392ab785_e73b_43c5_bb34_13c90bc5e7e0 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp392ab785_e73b_43c5_bb34_13c90bc5e7e0 OWNER TO psql;

--
-- TOC entry 1978 (class 1259 OID 138813480)
-- Name: cart_master_temp39828e3b_ee08_4dcb_bba5_a68b27c4b206; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp39828e3b_ee08_4dcb_bba5_a68b27c4b206 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp39828e3b_ee08_4dcb_bba5_a68b27c4b206 OWNER TO psql;

--
-- TOC entry 1872 (class 1259 OID 126034942)
-- Name: cart_master_temp3d77fec7_20e9_4be4_84bc_e3f38dda0824; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp3d77fec7_20e9_4be4_84bc_e3f38dda0824 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp3d77fec7_20e9_4be4_84bc_e3f38dda0824 OWNER TO psql;

--
-- TOC entry 1981 (class 1259 OID 138932827)
-- Name: cart_master_temp40883f8d_461c_4c04_aea4_ef4550f638c5; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp40883f8d_461c_4c04_aea4_ef4550f638c5 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp40883f8d_461c_4c04_aea4_ef4550f638c5 OWNER TO psql;

--
-- TOC entry 1955 (class 1259 OID 135679467)
-- Name: cart_master_temp40a65195_db41_431c_bcb4_54534c48cb28; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp40a65195_db41_431c_bcb4_54534c48cb28 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp40a65195_db41_431c_bcb4_54534c48cb28 OWNER TO psql;

--
-- TOC entry 1954 (class 1259 OID 135656224)
-- Name: cart_master_temp412643dc_ea0d_4dfb_a334_9acbd29cd71b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp412643dc_ea0d_4dfb_a334_9acbd29cd71b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp412643dc_ea0d_4dfb_a334_9acbd29cd71b OWNER TO psql;

--
-- TOC entry 1869 (class 1259 OID 126032702)
-- Name: cart_master_temp474e1f52_4fec_4a7d_804d_10352fc26772; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp474e1f52_4fec_4a7d_804d_10352fc26772 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp474e1f52_4fec_4a7d_804d_10352fc26772 OWNER TO psql;

--
-- TOC entry 1883 (class 1259 OID 126334739)
-- Name: cart_master_temp48cc78db_cfd1_44f7_b03e_b0ecfb043248; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp48cc78db_cfd1_44f7_b03e_b0ecfb043248 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp48cc78db_cfd1_44f7_b03e_b0ecfb043248 OWNER TO psql;

--
-- TOC entry 1962 (class 1259 OID 135957760)
-- Name: cart_master_temp4df1bcc3_c36b_46da_893d_d8524f10585e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp4df1bcc3_c36b_46da_893d_d8524f10585e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp4df1bcc3_c36b_46da_893d_d8524f10585e OWNER TO psql;

--
-- TOC entry 1909 (class 1259 OID 126634969)
-- Name: cart_master_temp4f317c72_09f1_4748_9219_07d5bbe2cde1; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp4f317c72_09f1_4748_9219_07d5bbe2cde1 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp4f317c72_09f1_4748_9219_07d5bbe2cde1 OWNER TO psql;

--
-- TOC entry 1877 (class 1259 OID 126304291)
-- Name: cart_master_temp4f504916_26cb_4747_be41_d3df8360d8cb; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp4f504916_26cb_4747_be41_d3df8360d8cb (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp4f504916_26cb_4747_be41_d3df8360d8cb OWNER TO psql;

--
-- TOC entry 1963 (class 1259 OID 135960307)
-- Name: cart_master_temp50189cb4_87e2_4d07_8a62_1db323e42983; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp50189cb4_87e2_4d07_8a62_1db323e42983 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp50189cb4_87e2_4d07_8a62_1db323e42983 OWNER TO psql;

--
-- TOC entry 1878 (class 1259 OID 126306171)
-- Name: cart_master_temp51612649_0ec6_4890_b5f5_114c30f67c8c; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp51612649_0ec6_4890_b5f5_114c30f67c8c (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp51612649_0ec6_4890_b5f5_114c30f67c8c OWNER TO psql;

--
-- TOC entry 1947 (class 1259 OID 134361718)
-- Name: cart_master_temp5dd43b3f_7b3a_493f_9e2b_b209b3816cb1; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp5dd43b3f_7b3a_493f_9e2b_b209b3816cb1 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp5dd43b3f_7b3a_493f_9e2b_b209b3816cb1 OWNER TO psql;

--
-- TOC entry 1857 (class 1259 OID 126008147)
-- Name: cart_master_temp5ed7f099_a8e5_4397_bf86_4e9581422a9b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp5ed7f099_a8e5_4397_bf86_4e9581422a9b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp5ed7f099_a8e5_4397_bf86_4e9581422a9b OWNER TO psql;

--
-- TOC entry 1958 (class 1259 OID 135762578)
-- Name: cart_master_temp612aa348_9fd9_4770_9271_0d5f952afa8e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp612aa348_9fd9_4770_9271_0d5f952afa8e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp612aa348_9fd9_4770_9271_0d5f952afa8e OWNER TO psql;

--
-- TOC entry 1910 (class 1259 OID 126649396)
-- Name: cart_master_temp63ab7cce_c34b_4b32_9e65_36eaf67dd886; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp63ab7cce_c34b_4b32_9e65_36eaf67dd886 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp63ab7cce_c34b_4b32_9e65_36eaf67dd886 OWNER TO psql;

--
-- TOC entry 1957 (class 1259 OID 135760769)
-- Name: cart_master_temp65bf4b50_ef8c_4dc4_9f4e_185a44d7b01d; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp65bf4b50_ef8c_4dc4_9f4e_185a44d7b01d (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp65bf4b50_ef8c_4dc4_9f4e_185a44d7b01d OWNER TO psql;

--
-- TOC entry 1866 (class 1259 OID 126025155)
-- Name: cart_master_temp66d148a0_4b5f_4bfe_990e_71713e0b5a21; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp66d148a0_4b5f_4bfe_990e_71713e0b5a21 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp66d148a0_4b5f_4bfe_990e_71713e0b5a21 OWNER TO psql;

--
-- TOC entry 1873 (class 1259 OID 126046752)
-- Name: cart_master_temp6bdecd2f_15f1_4ead_9597_78cd7819e2a1; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp6bdecd2f_15f1_4ead_9597_78cd7819e2a1 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp6bdecd2f_15f1_4ead_9597_78cd7819e2a1 OWNER TO psql;

--
-- TOC entry 1898 (class 1259 OID 126600667)
-- Name: cart_master_temp6cce81c8_f35d_4579_971e_7024b2dc0646; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp6cce81c8_f35d_4579_971e_7024b2dc0646 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp6cce81c8_f35d_4579_971e_7024b2dc0646 OWNER TO psql;

--
-- TOC entry 1919 (class 1259 OID 127475561)
-- Name: cart_master_temp6d55155e_8e14_45c9_bbf0_c12ce3a1acf5; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp6d55155e_8e14_45c9_bbf0_c12ce3a1acf5 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp6d55155e_8e14_45c9_bbf0_c12ce3a1acf5 OWNER TO psql;

--
-- TOC entry 1939 (class 1259 OID 128096323)
-- Name: cart_master_temp6dc57c95_c788_43c1_b4a4_c27e75aa1b74; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp6dc57c95_c788_43c1_b4a4_c27e75aa1b74 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp6dc57c95_c788_43c1_b4a4_c27e75aa1b74 OWNER TO psql;

--
-- TOC entry 1943 (class 1259 OID 128637962)
-- Name: cart_master_temp7310f384_f72b_4513_b0d8_d5f090a2b88a; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp7310f384_f72b_4513_b0d8_d5f090a2b88a (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp7310f384_f72b_4513_b0d8_d5f090a2b88a OWNER TO psql;

--
-- TOC entry 1940 (class 1259 OID 128097011)
-- Name: cart_master_temp756c1630_640f_41ae_9c76_fcd144b1d9d2; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp756c1630_640f_41ae_9c76_fcd144b1d9d2 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp756c1630_640f_41ae_9c76_fcd144b1d9d2 OWNER TO psql;

--
-- TOC entry 1849 (class 1259 OID 125978753)
-- Name: cart_master_temp759f22d5_46e6_4cf8_9d4d_f427142d1a54; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp759f22d5_46e6_4cf8_9d4d_f427142d1a54 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp759f22d5_46e6_4cf8_9d4d_f427142d1a54 OWNER TO psql;

--
-- TOC entry 1901 (class 1259 OID 126605026)
-- Name: cart_master_temp766ee8dd_bcf6_4227_9496_4bf92cec37d5; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp766ee8dd_bcf6_4227_9496_4bf92cec37d5 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp766ee8dd_bcf6_4227_9496_4bf92cec37d5 OWNER TO psql;

--
-- TOC entry 1917 (class 1259 OID 127445422)
-- Name: cart_master_temp7722f7fb_78b8_4a47_9a7e_68308a60d05f; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp7722f7fb_78b8_4a47_9a7e_68308a60d05f (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp7722f7fb_78b8_4a47_9a7e_68308a60d05f OWNER TO psql;

--
-- TOC entry 1908 (class 1259 OID 126618513)
-- Name: cart_master_temp77d581f6_f0bb_4c43_bcb2_5fd406aff6f9; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp77d581f6_f0bb_4c43_bcb2_5fd406aff6f9 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp77d581f6_f0bb_4c43_bcb2_5fd406aff6f9 OWNER TO psql;

--
-- TOC entry 1933 (class 1259 OID 127780001)
-- Name: cart_master_temp7abd7636_caba_4216_9817_2dde01a84724; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp7abd7636_caba_4216_9817_2dde01a84724 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp7abd7636_caba_4216_9817_2dde01a84724 OWNER TO psql;

--
-- TOC entry 1931 (class 1259 OID 127774249)
-- Name: cart_master_temp7bbcd250_9ee6_4ccd_ac86_a77567cce4cf; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp7bbcd250_9ee6_4ccd_ac86_a77567cce4cf (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp7bbcd250_9ee6_4ccd_ac86_a77567cce4cf OWNER TO psql;

--
-- TOC entry 1938 (class 1259 OID 128071072)
-- Name: cart_master_temp7f42a462_a9b6_4ba4_88f7_22a839e59582; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp7f42a462_a9b6_4ba4_88f7_22a839e59582 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp7f42a462_a9b6_4ba4_88f7_22a839e59582 OWNER TO psql;

--
-- TOC entry 1934 (class 1259 OID 127967076)
-- Name: cart_master_temp8056ef65_fee8_4d77_bf6a_1ba763ff08ea; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8056ef65_fee8_4d77_bf6a_1ba763ff08ea (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8056ef65_fee8_4d77_bf6a_1ba763ff08ea OWNER TO psql;

--
-- TOC entry 1893 (class 1259 OID 126456322)
-- Name: cart_master_temp807b94f4_c2cd_415f_be58_b4244e940a9a; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp807b94f4_c2cd_415f_be58_b4244e940a9a (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp807b94f4_c2cd_415f_be58_b4244e940a9a OWNER TO psql;

--
-- TOC entry 1952 (class 1259 OID 134828635)
-- Name: cart_master_temp82b070bc_a1ad_4153_89b8_5d3c96976e3f; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp82b070bc_a1ad_4153_89b8_5d3c96976e3f (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp82b070bc_a1ad_4153_89b8_5d3c96976e3f OWNER TO psql;

--
-- TOC entry 1899 (class 1259 OID 126601145)
-- Name: cart_master_temp8498bce4_bd95_4240_acad_1a375200f275; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8498bce4_bd95_4240_acad_1a375200f275 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8498bce4_bd95_4240_acad_1a375200f275 OWNER TO psql;

--
-- TOC entry 1961 (class 1259 OID 135957208)
-- Name: cart_master_temp8587145d_0a5a_49c5_8cf3_3317d5c71161; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8587145d_0a5a_49c5_8cf3_3317d5c71161 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8587145d_0a5a_49c5_8cf3_3317d5c71161 OWNER TO psql;

--
-- TOC entry 1980 (class 1259 OID 138817792)
-- Name: cart_master_temp88a58d80_6a75_4ab8_977a_2719c80cabd7; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp88a58d80_6a75_4ab8_977a_2719c80cabd7 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp88a58d80_6a75_4ab8_977a_2719c80cabd7 OWNER TO psql;

--
-- TOC entry 1903 (class 1259 OID 126609612)
-- Name: cart_master_temp8b2b829a_0496_4fc4_9db3_b6517ff68823; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8b2b829a_0496_4fc4_9db3_b6517ff68823 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8b2b829a_0496_4fc4_9db3_b6517ff68823 OWNER TO psql;

--
-- TOC entry 1914 (class 1259 OID 126654917)
-- Name: cart_master_temp8c100401_2892_4237_b3a5_954f5d4e2197; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8c100401_2892_4237_b3a5_954f5d4e2197 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8c100401_2892_4237_b3a5_954f5d4e2197 OWNER TO psql;

--
-- TOC entry 1859 (class 1259 OID 126011198)
-- Name: cart_master_temp8f423e89_2347_4e0d_8894_9fc180ee82d5; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp8f423e89_2347_4e0d_8894_9fc180ee82d5 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp8f423e89_2347_4e0d_8894_9fc180ee82d5 OWNER TO psql;

--
-- TOC entry 1861 (class 1259 OID 126017267)
-- Name: cart_master_temp940ff39b_c4e8_4f57_985b_369d096e0194; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp940ff39b_c4e8_4f57_985b_369d096e0194 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp940ff39b_c4e8_4f57_985b_369d096e0194 OWNER TO psql;

--
-- TOC entry 1948 (class 1259 OID 134826698)
-- Name: cart_master_temp96469c30_9980_4809_9a68_eb4dff1fb76e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp96469c30_9980_4809_9a68_eb4dff1fb76e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp96469c30_9980_4809_9a68_eb4dff1fb76e OWNER TO psql;

--
-- TOC entry 1979 (class 1259 OID 138814362)
-- Name: cart_master_temp9b0baec1_8674_4ab0_9586_87782fe6b9ed; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp9b0baec1_8674_4ab0_9586_87782fe6b9ed (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp9b0baec1_8674_4ab0_9586_87782fe6b9ed OWNER TO psql;

--
-- TOC entry 1907 (class 1259 OID 126618123)
-- Name: cart_master_temp9d68e5d9_1428_4453_8b8b_16f3e16529da; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_temp9d68e5d9_1428_4453_8b8b_16f3e16529da (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_temp9d68e5d9_1428_4453_8b8b_16f3e16529da OWNER TO psql;

--
-- TOC entry 1949 (class 1259 OID 134827244)
-- Name: cart_master_tempa029e8f6_0206_4578_a1f2_7956397949ac; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa029e8f6_0206_4578_a1f2_7956397949ac (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa029e8f6_0206_4578_a1f2_7956397949ac OWNER TO psql;

--
-- TOC entry 1858 (class 1259 OID 126008641)
-- Name: cart_master_tempa0553465_056c_4583_887e_e125e9ff6a33; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa0553465_056c_4583_887e_e125e9ff6a33 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa0553465_056c_4583_887e_e125e9ff6a33 OWNER TO psql;

--
-- TOC entry 1969 (class 1259 OID 137142435)
-- Name: cart_master_tempa28580ca_3c27_4fa4_a98c_768a6289d268; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa28580ca_3c27_4fa4_a98c_768a6289d268 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa28580ca_3c27_4fa4_a98c_768a6289d268 OWNER TO psql;

--
-- TOC entry 1930 (class 1259 OID 127757999)
-- Name: cart_master_tempa641177c_6a78_4b3f_a44f_b54abeba5ce4; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa641177c_6a78_4b3f_a44f_b54abeba5ce4 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa641177c_6a78_4b3f_a44f_b54abeba5ce4 OWNER TO psql;

--
-- TOC entry 1945 (class 1259 OID 134180219)
-- Name: cart_master_tempa74344c3_08a2_4309_85f7_c859585c094d; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa74344c3_08a2_4309_85f7_c859585c094d (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa74344c3_08a2_4309_85f7_c859585c094d OWNER TO psql;

--
-- TOC entry 1965 (class 1259 OID 136814759)
-- Name: cart_master_tempa76cb441_fde4_4feb_bfc5_8c6c8eed4cbe; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempa76cb441_fde4_4feb_bfc5_8c6c8eed4cbe (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempa76cb441_fde4_4feb_bfc5_8c6c8eed4cbe OWNER TO psql;

--
-- TOC entry 1922 (class 1259 OID 127750597)
-- Name: cart_master_tempadbce635_1048_4032_b446_60a2f81a36c8; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempadbce635_1048_4032_b446_60a2f81a36c8 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempadbce635_1048_4032_b446_60a2f81a36c8 OWNER TO psql;

--
-- TOC entry 1966 (class 1259 OID 136815423)
-- Name: cart_master_tempaec53c7c_1e7e_4451_8552_dcb6e6db7c99; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempaec53c7c_1e7e_4451_8552_dcb6e6db7c99 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempaec53c7c_1e7e_4451_8552_dcb6e6db7c99 OWNER TO psql;

--
-- TOC entry 1851 (class 1259 OID 125979708)
-- Name: cart_master_tempb022b83c_36bd_459f_a5ea_c749b82744fd; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempb022b83c_36bd_459f_a5ea_c749b82744fd (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempb022b83c_36bd_459f_a5ea_c749b82744fd OWNER TO psql;

--
-- TOC entry 1871 (class 1259 OID 126034325)
-- Name: cart_master_tempb0e0298d_d7fc_4157_9d05_daa9e4371f0b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempb0e0298d_d7fc_4157_9d05_daa9e4371f0b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempb0e0298d_d7fc_4157_9d05_daa9e4371f0b OWNER TO psql;

--
-- TOC entry 1882 (class 1259 OID 126328453)
-- Name: cart_master_tempb34a98aa_75bd_47c8_8c6c_52889f4378a9; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempb34a98aa_75bd_47c8_8c6c_52889f4378a9 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempb34a98aa_75bd_47c8_8c6c_52889f4378a9 OWNER TO psql;

--
-- TOC entry 1951 (class 1259 OID 134828308)
-- Name: cart_master_tempb37f73bb_8021_4de9_82a9_7920307eaa18; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempb37f73bb_8021_4de9_82a9_7920307eaa18 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempb37f73bb_8021_4de9_82a9_7920307eaa18 OWNER TO psql;

--
-- TOC entry 1879 (class 1259 OID 126320239)
-- Name: cart_master_tempb742ef5e_184c_4fb0_aa40_eb70a8ae7334; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempb742ef5e_184c_4fb0_aa40_eb70a8ae7334 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempb742ef5e_184c_4fb0_aa40_eb70a8ae7334 OWNER TO psql;

--
-- TOC entry 1915 (class 1259 OID 126656177)
-- Name: cart_master_tempbb92457b_e1d6_48ff_af72_07bab3619d01; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempbb92457b_e1d6_48ff_af72_07bab3619d01 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempbb92457b_e1d6_48ff_af72_07bab3619d01 OWNER TO psql;

--
-- TOC entry 1867 (class 1259 OID 126026525)
-- Name: cart_master_tempbd4d76a6_27a3_47fe_af72_ab8bd0a4337d; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempbd4d76a6_27a3_47fe_af72_ab8bd0a4337d (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempbd4d76a6_27a3_47fe_af72_ab8bd0a4337d OWNER TO psql;

--
-- TOC entry 1856 (class 1259 OID 125989029)
-- Name: cart_master_tempc1f476ea_d64d_4cc3_b192_630917a7bcf8; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempc1f476ea_d64d_4cc3_b192_630917a7bcf8 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempc1f476ea_d64d_4cc3_b192_630917a7bcf8 OWNER TO psql;

--
-- TOC entry 1870 (class 1259 OID 126033569)
-- Name: cart_master_tempc26585d8_40a9_421e_96ee_20c5449e39c3; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempc26585d8_40a9_421e_96ee_20c5449e39c3 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempc26585d8_40a9_421e_96ee_20c5449e39c3 OWNER TO psql;

--
-- TOC entry 1852 (class 1259 OID 125980023)
-- Name: cart_master_tempcaa33ac6_cfe1_4936_8deb_d35fb9379388; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempcaa33ac6_cfe1_4936_8deb_d35fb9379388 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempcaa33ac6_cfe1_4936_8deb_d35fb9379388 OWNER TO psql;

--
-- TOC entry 1982 (class 1259 OID 139222180)
-- Name: cart_master_tempcc803304_a98d_47e9_9a3b_f027d63e5261; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempcc803304_a98d_47e9_9a3b_f027d63e5261 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempcc803304_a98d_47e9_9a3b_f027d63e5261 OWNER TO psql;

--
-- TOC entry 1941 (class 1259 OID 128460310)
-- Name: cart_master_tempcea8baee_6a96_44c1_ba2f_3e4e2f2653fd; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempcea8baee_6a96_44c1_ba2f_3e4e2f2653fd (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempcea8baee_6a96_44c1_ba2f_3e4e2f2653fd OWNER TO psql;

--
-- TOC entry 1906 (class 1259 OID 126616977)
-- Name: cart_master_tempcf28cc20_8ed6_41d2_b562_9f7ef7c67ab6; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempcf28cc20_8ed6_41d2_b562_9f7ef7c67ab6 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempcf28cc20_8ed6_41d2_b562_9f7ef7c67ab6 OWNER TO psql;

--
-- TOC entry 1904 (class 1259 OID 126613177)
-- Name: cart_master_tempd19cf14e_ad86_44da_806a_31adc1dfdaee; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempd19cf14e_ad86_44da_806a_31adc1dfdaee (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempd19cf14e_ad86_44da_806a_31adc1dfdaee OWNER TO psql;

--
-- TOC entry 1889 (class 1259 OID 126393700)
-- Name: cart_master_tempd4d1b76d_0265_446b_9502_98a80ba79048; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempd4d1b76d_0265_446b_9502_98a80ba79048 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempd4d1b76d_0265_446b_9502_98a80ba79048 OWNER TO psql;

--
-- TOC entry 1956 (class 1259 OID 135681988)
-- Name: cart_master_tempd9f0d2db_a0b4_43c8_ae0d_6efa7de10af9; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempd9f0d2db_a0b4_43c8_ae0d_6efa7de10af9 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempd9f0d2db_a0b4_43c8_ae0d_6efa7de10af9 OWNER TO psql;

--
-- TOC entry 1902 (class 1259 OID 126605743)
-- Name: cart_master_tempda636c0d_92ac_4105_9677_6ae5c8b19d6c; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempda636c0d_92ac_4105_9677_6ae5c8b19d6c (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempda636c0d_92ac_4105_9677_6ae5c8b19d6c OWNER TO psql;

--
-- TOC entry 1874 (class 1259 OID 126047711)
-- Name: cart_master_tempdb1f1383_2a66_4212_9b63_e717e64f5a45; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempdb1f1383_2a66_4212_9b63_e717e64f5a45 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempdb1f1383_2a66_4212_9b63_e717e64f5a45 OWNER TO psql;

--
-- TOC entry 1875 (class 1259 OID 126053807)
-- Name: cart_master_tempde5511ea_131b_406e_80cf_66c9a891eb8e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempde5511ea_131b_406e_80cf_66c9a891eb8e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempde5511ea_131b_406e_80cf_66c9a891eb8e OWNER TO psql;

--
-- TOC entry 1862 (class 1259 OID 126018890)
-- Name: cart_master_tempe508263b_1dd1_4ead_bfeb_6b21eeed9511; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe508263b_1dd1_4ead_bfeb_6b21eeed9511 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe508263b_1dd1_4ead_bfeb_6b21eeed9511 OWNER TO psql;

--
-- TOC entry 1855 (class 1259 OID 125988517)
-- Name: cart_master_tempe60846fc_5f85_4c5c_bd2f_f7cb9d01bd3e; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe60846fc_5f85_4c5c_bd2f_f7cb9d01bd3e (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe60846fc_5f85_4c5c_bd2f_f7cb9d01bd3e OWNER TO psql;

--
-- TOC entry 1863 (class 1259 OID 126019543)
-- Name: cart_master_tempe62696dc_2f27_415e_be9f_496a9fa75929; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe62696dc_2f27_415e_be9f_496a9fa75929 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe62696dc_2f27_415e_be9f_496a9fa75929 OWNER TO psql;

--
-- TOC entry 1865 (class 1259 OID 126024422)
-- Name: cart_master_tempe64aaf72_4df2_414f_8880_bd667e75b020; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe64aaf72_4df2_414f_8880_bd667e75b020 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe64aaf72_4df2_414f_8880_bd667e75b020 OWNER TO psql;

--
-- TOC entry 1894 (class 1259 OID 126457033)
-- Name: cart_master_tempe786ce4f_b765_4619_9ecd_606ef6112146; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe786ce4f_b765_4619_9ecd_606ef6112146 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe786ce4f_b765_4619_9ecd_606ef6112146 OWNER TO psql;

--
-- TOC entry 1960 (class 1259 OID 135956418)
-- Name: cart_master_tempe86a2121_23b6_424d_a04d_101b7a7872db; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe86a2121_23b6_424d_a04d_101b7a7872db (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe86a2121_23b6_424d_a04d_101b7a7872db OWNER TO psql;

--
-- TOC entry 1853 (class 1259 OID 125980637)
-- Name: cart_master_tempe8be48b5_c0f6_477f_8ece_d698aca8e292; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempe8be48b5_c0f6_477f_8ece_d698aca8e292 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempe8be48b5_c0f6_477f_8ece_d698aca8e292 OWNER TO psql;

--
-- TOC entry 1977 (class 1259 OID 138056339)
-- Name: cart_master_tempee36cfec_3c68_49e0_979c_1e2e4bbb4fd8; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempee36cfec_3c68_49e0_979c_1e2e4bbb4fd8 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempee36cfec_3c68_49e0_979c_1e2e4bbb4fd8 OWNER TO psql;

--
-- TOC entry 1864 (class 1259 OID 126022105)
-- Name: cart_master_tempefc446ab_90a1_429d_9c59_1061ecabf5d5; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempefc446ab_90a1_429d_9c59_1061ecabf5d5 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempefc446ab_90a1_429d_9c59_1061ecabf5d5 OWNER TO psql;

--
-- TOC entry 1880 (class 1259 OID 126320652)
-- Name: cart_master_tempf3e8c318_41ec_4d5a_ba13_541a60cce404; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempf3e8c318_41ec_4d5a_ba13_541a60cce404 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempf3e8c318_41ec_4d5a_ba13_541a60cce404 OWNER TO psql;

--
-- TOC entry 1860 (class 1259 OID 126011992)
-- Name: cart_master_tempf4b2ea86_5fce_45ba_a1cb_521cc29fec90; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempf4b2ea86_5fce_45ba_a1cb_521cc29fec90 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempf4b2ea86_5fce_45ba_a1cb_521cc29fec90 OWNER TO psql;

--
-- TOC entry 1950 (class 1259 OID 134827639)
-- Name: cart_master_tempf5547bdd_a272_4adb_ae53_9c02ae6d23b6; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempf5547bdd_a272_4adb_ae53_9c02ae6d23b6 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempf5547bdd_a272_4adb_ae53_9c02ae6d23b6 OWNER TO psql;

--
-- TOC entry 1850 (class 1259 OID 125979374)
-- Name: cart_master_tempf84ed157_98d6_42bd_a0bc_0b09472fbcba; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempf84ed157_98d6_42bd_a0bc_0b09472fbcba (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempf84ed157_98d6_42bd_a0bc_0b09472fbcba OWNER TO psql;

--
-- TOC entry 1911 (class 1259 OID 126649858)
-- Name: cart_master_tempf924fc7b_c7dd_4cc6_bdf8_57bf146af06b; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempf924fc7b_c7dd_4cc6_bdf8_57bf146af06b (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempf924fc7b_c7dd_4cc6_bdf8_57bf146af06b OWNER TO psql;

--
-- TOC entry 1881 (class 1259 OID 126325896)
-- Name: cart_master_tempfaa057ae_7123_4f39_9a5e_085b11c49911; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempfaa057ae_7123_4f39_9a5e_085b11c49911 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempfaa057ae_7123_4f39_9a5e_085b11c49911 OWNER TO psql;

--
-- TOC entry 1918 (class 1259 OID 127464805)
-- Name: cart_master_tempfde598ea_11e6_4d50_b6d0_0127bb697665; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempfde598ea_11e6_4d50_b6d0_0127bb697665 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempfde598ea_11e6_4d50_b6d0_0127bb697665 OWNER TO psql;

--
-- TOC entry 1916 (class 1259 OID 126667594)
-- Name: cart_master_tempff420944_4e96_4ce1_9de9_b5761dba4d30; Type: TABLE; Schema: public; Owner: psql
--

CREATE UNLOGGED TABLE public.cart_master_tempff420944_4e96_4ce1_9de9_b5761dba4d30 (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.cart_master_tempff420944_4e96_4ce1_9de9_b5761dba4d30 OWNER TO psql;

--
-- TOC entry 1572 (class 1259 OID 67697916)
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
    planned_lof_week text,
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
    retpct_str integer,
    retpct_ecomm integer,
    retpct_cross integer,
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
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 1573 (class 1259 OID 67697922)
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
    planned_lof_week text,
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
    retpct_str integer,
    retpct_ecomm integer,
    retpct_cross integer,
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
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text
);


ALTER TABLE public.cart_params_archive OWNER TO psql;

--
-- TOC entry 1574 (class 1259 OID 67697928)
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
-- TOC entry 1575 (class 1259 OID 67697935)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_climate text[],
    str_grade text[],
    ssg text[],
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 1576 (class 1259 OID 67697940)
-- Name: cart_ranging_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging_archive (
    jsessionid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    str_climate text,
    str_grade text[],
    ssg text,
    flnrange text,
    isfunded integer,
    indx integer,
    store_count integer
);


ALTER TABLE public.cart_ranging_archive OWNER TO psql;

--
-- TOC entry 1577 (class 1259 OID 67697945)
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
-- TOC entry 1578 (class 1259 OID 67697950)
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
-- TOC entry 1579 (class 1259 OID 67697953)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 1580 (class 1259 OID 67697958)
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
-- TOC entry 1581 (class 1259 OID 67697963)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    class text,
    default_discount numeric(16,4),
    default_md text
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 1582 (class 1259 OID 67697968)
-- Name: delete_me_plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_plan_queue (
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


ALTER TABLE public.delete_me_plan_queue OWNER TO psql;

--
-- TOC entry 1583 (class 1259 OID 67697973)
-- Name: delete_me_test_corrected_sca_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_corrected_sca_validsizes (
    stylecolor text,
    cc_validsizes_store text[]
);


ALTER TABLE public.delete_me_test_corrected_sca_validsizes OWNER TO psql;

--
-- TOC entry 1584 (class 1259 OID 67697978)
-- Name: delete_me_test_corrected_sca_validsizes_ecom; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_corrected_sca_validsizes_ecom (
    product text,
    string_agg text
);


ALTER TABLE public.delete_me_test_corrected_sca_validsizes_ecom OWNER TO psql;

--
-- TOC entry 1585 (class 1259 OID 67697983)
-- Name: delete_me_test_sca_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_sca_validsizes (
    product text,
    ccrangecode text,
    cc_validsizes_store text,
    cc_validsizes_ecom text,
    stylecolorsize_store text,
    stylecolorsize_ecom text
);


ALTER TABLE public.delete_me_test_sca_validsizes OWNER TO psql;

--
-- TOC entry 1586 (class 1259 OID 67697988)
-- Name: delete_me_test_sca_validsizes_ecom; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_sca_validsizes_ecom (
    product text,
    ccrangecode text,
    cc_validsizes_ecom text,
    from_sizeattr_cc_validsizes_ecom text
);


ALTER TABLE public.delete_me_test_sca_validsizes_ecom OWNER TO psql;

--
-- TOC entry 1587 (class 1259 OID 67697993)
-- Name: delete_me_test_sca_validsizes_store; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_sca_validsizes_store (
    product text,
    ccrangecode text,
    cc_validsizes_store text,
    from_sizeattr_cc_validsizes_store text
);


ALTER TABLE public.delete_me_test_sca_validsizes_store OWNER TO psql;

--
-- TOC entry 1588 (class 1259 OID 67697998)
-- Name: delete_me_test_sizeattr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_sizeattr (
    stylecolor text,
    stylecolorsize text,
    sizeattribute text
);


ALTER TABLE public.delete_me_test_sizeattr OWNER TO psql;

--
-- TOC entry 1589 (class 1259 OID 67698003)
-- Name: deletem_missing_cccolor_20250415; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deletem_missing_cccolor_20250415 (
    product text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_specstylecolorid text,
    cc_specstyle_cccolor text
);


ALTER TABLE public.deletem_missing_cccolor_20250415 OWNER TO psql;

--
-- TOC entry 1590 (class 1259 OID 67698008)
-- Name: deleteme_8f4c6f5b_61fa_485d_8d16_14725e0b82fbpetite; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_8f4c6f5b_61fa_485d_8d16_14725e0b82fbpetite (
    product text,
    parent_id text,
    size_id text,
    sizeattribute text,
    ticket_size text,
    size_desc text,
    size_range text,
    sku_create_date text,
    original_price text,
    current_price text,
    isvalid integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.deleteme_8f4c6f5b_61fa_485d_8d16_14725e0b82fbpetite OWNER TO psql;

--
-- TOC entry 1591 (class 1259 OID 67698013)
-- Name: deleteme_bad_str_grade; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_bad_str_grade (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.deleteme_bad_str_grade OWNER TO psql;

--
-- TOC entry 1592 (class 1259 OID 67698018)
-- Name: deleteme_failed_items_20250401; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_failed_items_20250401 (
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


ALTER TABLE public.deleteme_failed_items_20250401 OWNER TO psql;

--
-- TOC entry 1593 (class 1259 OID 67698023)
-- Name: deleteme_fix_ccrangecode; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_ccrangecode (
    ancestor3 text,
    ancestor2 text,
    id text,
    name text,
    record_state smallint,
    sty_size_range text,
    ccrangecode text,
    created_at timestamp without time zone
);


ALTER TABLE public.deleteme_fix_ccrangecode OWNER TO psql;

--
-- TOC entry 1594 (class 1259 OID 67698028)
-- Name: deleteme_fix_null_specstylecolorid; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstylecolorid (
    product text,
    cccolor text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    ccstylecolorcreatedate text,
    name text
);


ALTER TABLE public.deleteme_fix_null_specstylecolorid OWNER TO psql;

--
-- TOC entry 1595 (class 1259 OID 67698033)
-- Name: deleteme_fix_null_specstylecolorid_kwgitems; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstylecolorid_kwgitems (
    product text,
    cccolor text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    ccstylecolorcreatedate text,
    name text
);


ALTER TABLE public.deleteme_fix_null_specstylecolorid_kwgitems OWNER TO psql;

--
-- TOC entry 1596 (class 1259 OID 67698038)
-- Name: deleteme_fix_null_specstylecolorid_placeholders; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstylecolorid_placeholders (
    product text,
    cccolor text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    ccstylecolorcreatedate text,
    name text
);


ALTER TABLE public.deleteme_fix_null_specstylecolorid_placeholders OWNER TO psql;

--
-- TOC entry 1597 (class 1259 OID 67698043)
-- Name: deleteme_fix_null_specstyleid; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstyleid (
    product text,
    name text,
    sty_specstyleid text
);


ALTER TABLE public.deleteme_fix_null_specstyleid OWNER TO psql;

--
-- TOC entry 1598 (class 1259 OID 67698048)
-- Name: deleteme_fix_null_specstyleid_kwgitems; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstyleid_kwgitems (
    product text,
    name text,
    sty_specstyleid text,
    sty_missy_related_style_bbr text
);


ALTER TABLE public.deleteme_fix_null_specstyleid_kwgitems OWNER TO psql;

--
-- TOC entry 1599 (class 1259 OID 67698053)
-- Name: deleteme_fix_null_specstyleid_placeholders; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstyleid_placeholders (
    product text,
    name text,
    sty_specstyleid text,
    sty_missy_related_style_bbr text
);


ALTER TABLE public.deleteme_fix_null_specstyleid_placeholders OWNER TO psql;

--
-- TOC entry 1600 (class 1259 OID 67698058)
-- Name: deleteme_fix_null_specstyleid_placeholders_stillmissing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstyleid_placeholders_stillmissing (
    product text,
    sty_specstyleid text,
    name text,
    sty_missy_related_style_bbr text
);


ALTER TABLE public.deleteme_fix_null_specstyleid_placeholders_stillmissing OWNER TO psql;

--
-- TOC entry 1601 (class 1259 OID 67698063)
-- Name: deleteme_fix_size_ranges_20250402; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_size_ranges_20250402 (
    product text,
    sty_size_range text,
    ccrangecode text,
    new_sty_size_range text
);


ALTER TABLE public.deleteme_fix_size_ranges_20250402 OWNER TO psql;

--
-- TOC entry 1921 (class 1259 OID 127750592)
-- Name: deleteme_input_t1_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_input_t1_jr (
    jsid text,
    scope_product text,
    scope_location text,
    scope_start text,
    scope_floorset text,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_input_t1_jr OWNER TO psql;

--
-- TOC entry 1602 (class 1259 OID 67698068)
-- Name: deleteme_loft_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.deleteme_loft_a_assortment OWNER TO psql;

--
-- TOC entry 1603 (class 1259 OID 67698073)
-- Name: deleteme_loft_d_product_20250609; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_d_product_20250609 (
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


ALTER TABLE public.deleteme_loft_d_product_20250609 OWNER TO psql;

--
-- TOC entry 1927 (class 1259 OID 127750637)
-- Name: deleteme_loft_d_product_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_d_product_jr (
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
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_loft_d_product_jr OWNER TO psql;

--
-- TOC entry 1604 (class 1259 OID 67698078)
-- Name: deleteme_loft_fix_size_concept_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_fix_size_concept_specstyles (
    style text,
    name text,
    sty_specstyleid text,
    stylecolor text,
    cc_specstylecolorid text,
    cc_specstyle_cccolor text,
    record_state smallint,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    sty_size_type text,
    missy_specstyleid text,
    new_specstyle text
);


ALTER TABLE public.deleteme_loft_fix_size_concept_specstyles OWNER TO psql;

--
-- TOC entry 1605 (class 1259 OID 67698083)
-- Name: deleteme_loft_fix_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_fix_validsizes (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    valid_sizes text
);


ALTER TABLE public.deleteme_loft_fix_validsizes OWNER TO psql;

--
-- TOC entry 1606 (class 1259 OID 67698088)
-- Name: deleteme_loft_fix_validsizes_ecom; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_fix_validsizes_ecom (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    new_cc_validsizes_ecom text
);


ALTER TABLE public.deleteme_loft_fix_validsizes_ecom OWNER TO psql;

--
-- TOC entry 1607 (class 1259 OID 67698093)
-- Name: deleteme_loft_fix_validsizes_store; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_fix_validsizes_store (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    new_cc_validsizes_store text
);


ALTER TABLE public.deleteme_loft_fix_validsizes_store OWNER TO psql;

--
-- TOC entry 1928 (class 1259 OID 127750642)
-- Name: deleteme_loft_h_prodstd_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_h_prodstd_jr (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_loft_h_prodstd_jr OWNER TO psql;

--
-- TOC entry 1608 (class 1259 OID 67698098)
-- Name: deleteme_loft_ma_stylecolorattributes_20250502; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_ma_stylecolorattributes_20250502 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.deleteme_loft_ma_stylecolorattributes_20250502 OWNER TO psql;

--
-- TOC entry 1609 (class 1259 OID 67698103)
-- Name: deleteme_loft_ma_stylecolorattributes_20250601; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_ma_stylecolorattributes_20250601 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.deleteme_loft_ma_stylecolorattributes_20250601 OWNER TO psql;

--
-- TOC entry 1610 (class 1259 OID 67698108)
-- Name: deleteme_loft_remove_specstyles_from_nonassortment_take2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_loft_remove_specstyles_from_nonassortment_take2 (
    style text,
    style_id text,
    stylecolor text,
    product text,
    record_state smallint,
    sty_specstyleid text,
    cc_specstylecolorid text,
    cc_specstyle_cccolor text,
    ccs_in_assortment_count integer,
    ccs_not_in_assortment_count integer
);


ALTER TABLE public.deleteme_loft_remove_specstyles_from_nonassortment_take2 OWNER TO psql;

--
-- TOC entry 1611 (class 1259 OID 67698113)
-- Name: deleteme_missing_cc_stylecolornumber_name; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_cc_stylecolornumber_name (
    product text,
    name text,
    description text,
    cc_stylecolornumber_name text
);


ALTER TABLE public.deleteme_missing_cc_stylecolornumber_name OWNER TO psql;

--
-- TOC entry 1612 (class 1259 OID 67698118)
-- Name: deleteme_missing_floorsetsforpublish; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_floorsetsforpublish (
    product text,
    "time" text
);


ALTER TABLE public.deleteme_missing_floorsetsforpublish OWNER TO psql;

--
-- TOC entry 1613 (class 1259 OID 67698123)
-- Name: deleteme_missing_sty_stylenumber_name; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_sty_stylenumber_name (
    product text,
    name text,
    description text,
    sty_stylenumber_name text
);


ALTER TABLE public.deleteme_missing_sty_stylenumber_name OWNER TO psql;

--
-- TOC entry 1993 (class 1259 OID 139698376)
-- Name: deleteme_new_size_concepts_in_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_new_size_concepts_in_assortment (
    product text,
    name text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    cc_size_concepts_in_assortment text[],
    new_size_concepts_in_assortment text[]
);


ALTER TABLE public.deleteme_new_size_concepts_in_assortment OWNER TO psql;

--
-- TOC entry 1992 (class 1259 OID 139698362)
-- Name: deleteme_new_size_concepts_in_assortment_step1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_new_size_concepts_in_assortment_step1 (
    product text,
    name text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    cc_size_concepts_in_assortment text[]
);


ALTER TABLE public.deleteme_new_size_concepts_in_assortment_step1 OWNER TO psql;

--
-- TOC entry 1994 (class 1259 OID 139698381)
-- Name: deleteme_new_size_concepts_in_assortment_step2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_new_size_concepts_in_assortment_step2 (
    product text,
    sty_size_type text,
    new_size_concepts_in_assortment text[]
);


ALTER TABLE public.deleteme_new_size_concepts_in_assortment_step2 OWNER TO psql;

--
-- TOC entry 1614 (class 1259 OID 67698143)
-- Name: deleteme_plan_queue_20250402; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_plan_queue_20250402 (
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


ALTER TABLE public.deleteme_plan_queue_20250402 OWNER TO psql;

--
-- TOC entry 1615 (class 1259 OID 67698148)
-- Name: deleteme_replan_sku_20250715; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_replan_sku_20250715 (
    brand_identifier text,
    sku_id text,
    product text
);


ALTER TABLE public.deleteme_replan_sku_20250715 OWNER TO psql;

--
-- TOC entry 1923 (class 1259 OID 127750602)
-- Name: deleteme_table_cart_master_temp_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_table_cart_master_temp_jr (
    jsessionid text,
    style_sequence text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_name text,
    style_description text,
    style_type text,
    cccolor text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    stylecolor_name text,
    stylecolor_description text,
    final_style_id text,
    final_stylecolor_id text,
    cccolorfamily text,
    cc_color_type text,
    initiator text,
    img text,
    job_priority integer,
    class_id text,
    subclass_id text,
    class_name text,
    subclass_name text,
    sty_size_type text,
    sc_type text,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_table_cart_master_temp_jr OWNER TO psql;

--
-- TOC entry 1924 (class 1259 OID 127750612)
-- Name: deleteme_table_cart_style_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_table_cart_style_jr (
    jsessionid text,
    style_sequence text,
    final_style_id text,
    incoming_style_id text,
    master_incoming_style_id text,
    style_type text,
    displayed_style_name text,
    displayed_style_description text,
    sc_type text,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_table_cart_style_jr OWNER TO psql;

--
-- TOC entry 1925 (class 1259 OID 127750622)
-- Name: deleteme_table_cart_stylecolor_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_table_cart_stylecolor_jr (
    jsessionid text,
    style_sequence text,
    final_stylecolor_id text,
    incoming_stylecolor_id text,
    master_incoming_stylecolor_id text,
    stylecolor_type text,
    displayed_stylecolor_name text,
    displayed_stylecolor_description text,
    incoming_style_id text,
    style_type text,
    cccolor text,
    sc_type text,
    final_style_id text,
    style_name text,
    style_description text,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_table_cart_stylecolor_jr OWNER TO psql;

--
-- TOC entry 1926 (class 1259 OID 127750632)
-- Name: deleteme_table_cart_stylecolorsize_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_table_cart_stylecolorsize_jr (
    final_stylecolorsize_id text,
    size_name text,
    size_description text,
    incoming_stylecolor_id text,
    incoming_style_id text,
    final_style_id text,
    final_stylecolor_id text,
    stylecolor_type text,
    jsessionid text,
    step text,
    captured_at timestamp with time zone
);


ALTER TABLE public.deleteme_table_cart_stylecolorsize_jr OWNER TO psql;

--
-- TOC entry 1616 (class 1259 OID 67698153)
-- Name: deleteme_validsizes_604; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_validsizes_604 (
    sty_size_range text,
    validsize text,
    store_ecom text
);


ALTER TABLE public.deleteme_validsizes_604 OWNER TO psql;

--
-- TOC entry 1617 (class 1259 OID 67698158)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 1618 (class 1259 OID 67698163)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 1619 (class 1259 OID 67698168)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 1828 (class 1259 OID 90589148)
-- Name: dept_plan_items_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_backup (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_backup OWNER TO psql;

--
-- TOC entry 1620 (class 1259 OID 67698173)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 1983 (class 1259 OID 139499482)
-- Name: dept_plan_items_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_temp OWNER TO psql;

--
-- TOC entry 1621 (class 1259 OID 67698183)
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
-- TOC entry 1622 (class 1259 OID 67698190)
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
-- TOC entry 1623 (class 1259 OID 67698195)
-- Name: failed_items_20250316; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_items_20250316 (
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


ALTER TABLE public.failed_items_20250316 OWNER TO psql;

--
-- TOC entry 1624 (class 1259 OID 67698200)
-- Name: failed_items_20250406; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_items_20250406 (
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


ALTER TABLE public.failed_items_20250406 OWNER TO psql;

--
-- TOC entry 1625 (class 1259 OID 67698205)
-- Name: failed_items_20250511; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_items_20250511 (
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


ALTER TABLE public.failed_items_20250511 OWNER TO psql;

--
-- TOC entry 1626 (class 1259 OID 67698210)
-- Name: failed_items_ca_12142025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.failed_items_ca_12142025 (
    product text,
    location text,
    initiator text
);


ALTER TABLE public.failed_items_ca_12142025 OWNER TO psql;

--
-- TOC entry 1627 (class 1259 OID 67698215)
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
-- TOC entry 1971 (class 1259 OID 137926351)
-- Name: fix_missyrelatedcc_loft_ata_missing_items_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.fix_missyrelatedcc_loft_ata_missing_items_existing (
    style text,
    product text,
    style_name text,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    cccolor text
);


ALTER TABLE public.fix_missyrelatedcc_loft_ata_missing_items_existing OWNER TO psql;

--
-- TOC entry 1972 (class 1259 OID 137926422)
-- Name: fix_missyrelatedsty_loft_ata_missing_items_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.fix_missyrelatedsty_loft_ata_missing_items_existing (
    product text,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    new_sty_missy_related_style text
);


ALTER TABLE public.fix_missyrelatedsty_loft_ata_missing_items_existing OWNER TO psql;

--
-- TOC entry 1973 (class 1259 OID 137926445)
-- Name: fix_wrongmissyrelatedsty_loft_ata_missing_items_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.fix_wrongmissyrelatedsty_loft_ata_missing_items_existing (
    product text,
    style text,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    ancestor0 text
);


ALTER TABLE public.fix_wrongmissyrelatedsty_loft_ata_missing_items_existing OWNER TO psql;

--
-- TOC entry 1628 (class 1259 OID 67698220)
-- Name: kw_c_conversion_file; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.kw_c_conversion_file (
    brand text,
    storeset text,
    division text,
    department text,
    class text,
    related_missy_style_id text,
    size_type text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ticket_price text,
    cost text,
    default_discount_percent real,
    debut_week text,
    md_week text,
    exit_week text,
    auto_roll_forward boolean,
    planned_sell_down_week text,
    md_strategy text,
    store_tier text[],
    store_climate text[],
    ssg text[],
    size_range text,
    size_range_store text[],
    size_range_ecom text[],
    size_min integer,
    size_min_weeks integer,
    pre_season_rating_stores integer,
    pre_season_rating_ecom integer,
    receipt_interval integer,
    return_rate_stores real,
    return_rate_ecom real,
    cross_channel_return_rate real,
    order_min_qty integer,
    order_multiple integer,
    can_ticket real,
    selling_channel text,
    cc_missy_related_stylecolor text
);


ALTER TABLE public.kw_c_conversion_file OWNER TO psql;

--
-- TOC entry 1629 (class 1259 OID 67698225)
-- Name: loft_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    style text,
    str_climate text[],
    str_grade text[],
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
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_a_assortment OWNER TO psql;

--
-- TOC entry 1630 (class 1259 OID 67698241)
-- Name: loft_a_assortment_20250909; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_20250909 (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_a_assortment_20250909 OWNER TO psql;

--
-- TOC entry 1829 (class 1259 OID 91869356)
-- Name: loft_a_assortment_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_backup (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_a_assortment_backup OWNER TO psql;

--
-- TOC entry 1823 (class 1259 OID 75158653)
-- Name: loft_a_assortment_backup_20260227; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_backup_20260227 (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_a_assortment_backup_20260227 OWNER TO psql;

--
-- TOC entry 1631 (class 1259 OID 67698246)
-- Name: loft_a_assortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_bk (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_a_assortment_bk OWNER TO psql;

--
-- TOC entry 1632 (class 1259 OID 67698251)
-- Name: loft_a_assortment_history_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_history_storecount (
    product text,
    "time" text,
    location text,
    str_grade text[],
    str_climate text[],
    ssg text[],
    department text,
    store_count integer
);


ALTER TABLE public.loft_a_assortment_history_storecount OWNER TO psql;

--
-- TOC entry 1824 (class 1259 OID 75161090)
-- Name: loft_a_assortment_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_storecount (
    product text,
    "time" text,
    location text,
    str_grade text[],
    str_climate text[],
    ssg text[],
    old_store_count integer,
    department text,
    class_id text,
    store_count integer
);


ALTER TABLE public.loft_a_assortment_storecount OWNER TO psql;

--
-- TOC entry 1633 (class 1259 OID 67698261)
-- Name: loft_a_assortment_sup3000; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_a_assortment_sup3000 (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_a_assortment_sup3000 OWNER TO psql;

--
-- TOC entry 1634 (class 1259 OID 67698266)
-- Name: loft_act; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_act (
    product text,
    act_slsrnk_store real,
    act_slsrnk_ecom real
);


ALTER TABLE public.loft_act OWNER TO psql;

--
-- TOC entry 1635 (class 1259 OID 67698271)
-- Name: loft_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_an_price_storecount_info (
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
    flow_flag text,
    selling_price_ecom real,
    corpexcl_ecom real,
    addoff_ecom real,
    corpaddoff_ecom real,
    v_a_ecom real,
    v_b_ecom real,
    cc_discount_pct_ecom real
);


ALTER TABLE public.loft_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 1974 (class 1259 OID 137926489)
-- Name: loft_ata_missing_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items (
    product text,
    style text,
    department text,
    class text,
    subclass text,
    stylecolor_name text,
    stylecolor_desc text,
    style_name text,
    style_desc text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_missy_related_stylecolor text,
    master_sty_size_type text,
    cc_size_concepts_in_assortment text[],
    master_sty_size_range text,
    final_style_id text,
    final_style_name text,
    final_style_desc text,
    final_stylecolor_id text,
    final_stylecolor_name text,
    final_stylecolor_desc text,
    final_cccolor text,
    final_cc_color_id text,
    final_cc_color_name text,
    final_cccolorfamily text,
    final_cc_color_type text,
    final_class_id text,
    final_subclass_id text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.loft_ata_missing_items OWNER TO psql;

--
-- TOC entry 1636 (class 1259 OID 67698281)
-- Name: loft_ata_missing_items_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer
);


ALTER TABLE public.loft_ata_missing_items_assortment OWNER TO psql;

--
-- TOC entry 1637 (class 1259 OID 67698286)
-- Name: loft_ata_missing_items_assortment_test2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_assortment_test2 (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer
);


ALTER TABLE public.loft_ata_missing_items_assortment_test2 OWNER TO psql;

--
-- TOC entry 1976 (class 1259 OID 137927288)
-- Name: loft_ata_missing_items_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_d_product (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.loft_ata_missing_items_d_product OWNER TO psql;

--
-- TOC entry 1970 (class 1259 OID 137925936)
-- Name: loft_ata_missing_items_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_existing (
    product text,
    style text,
    subclass text,
    class text,
    department text,
    stylecolor_name text,
    stylecolor_desc text,
    style_name text,
    style_desc text,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    cc_size_concepts_in_assortment text[],
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text
);


ALTER TABLE public.loft_ata_missing_items_existing OWNER TO psql;

--
-- TOC entry 1638 (class 1259 OID 67698301)
-- Name: loft_ata_missing_items_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_h_prodstd (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text
);


ALTER TABLE public.loft_ata_missing_items_h_prodstd OWNER TO psql;

--
-- TOC entry 1639 (class 1259 OID 67698306)
-- Name: loft_ata_missing_items_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_imgattributes (
    product text,
    img text
);


ALTER TABLE public.loft_ata_missing_items_imgattributes OWNER TO psql;

--
-- TOC entry 1640 (class 1259 OID 67698311)
-- Name: loft_ata_missing_items_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_sizeattributes (
    product text,
    sizeattribute text,
    parent_id text
);


ALTER TABLE public.loft_ata_missing_items_sizeattributes OWNER TO psql;

--
-- TOC entry 1641 (class 1259 OID 67698316)
-- Name: loft_ata_missing_items_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_styleattributes (
    product text,
    sty_end_use text,
    sty_pyramid_lens text,
    sty_silhouette text,
    sty_third_party text,
    sty_sleeve_length text,
    sty_type text,
    sty_neckline text,
    sty_merch_group text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_material text,
    sty_mfp_program_id text,
    sty_shape text,
    sty_program_id text,
    sty_length text,
    sty_placement text,
    sty_texture text,
    sty_gauge text,
    sty_accessory_measurements text,
    sty_finish text,
    sty_adhoc text,
    sty_retail_ticket_type text,
    sty_size_type text,
    sty_size_range text,
    sty_missy_related_style text
);


ALTER TABLE public.loft_ata_missing_items_styleattributes OWNER TO psql;

--
-- TOC entry 1642 (class 1259 OID 67698321)
-- Name: loft_ata_missing_items_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_stylecolorattributes (
    product text,
    cc_fabric_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_ppns text,
    cc_print_pattern_type text,
    cc_novelty_details text,
    cc_print_description text,
    cc_matchbacks text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_known text,
    cc_collection text,
    cc_preview text,
    cc_marketing_flag text,
    cc_promotion_flag text,
    cc_table text,
    cc_internet_tall_style text,
    cc_price_band text,
    cc_good_better_best text,
    cc_lifecycle text,
    cc_primary_selling text,
    cc_climate_product text,
    cc_online_exclusive_flag text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_missy_related_stylecolor text
);


ALTER TABLE public.loft_ata_missing_items_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1643 (class 1259 OID 67698326)
-- Name: loft_ata_missing_items_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_stylecolorchannelattributes (
    product text,
    missy_related_stylecolor text,
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
    record_state integer
);


ALTER TABLE public.loft_ata_missing_items_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1644 (class 1259 OID 67698331)
-- Name: loft_ata_missing_items_stylecolorchannelattributes_test2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_stylecolorchannelattributes_test2 (
    product text,
    missy_related_stylecolor text,
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
    record_state integer
);


ALTER TABLE public.loft_ata_missing_items_stylecolorchannelattributes_test2 OWNER TO psql;

--
-- TOC entry 1645 (class 1259 OID 67698336)
-- Name: loft_ata_missing_items_stylecolorsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_stylecolorsizes (
    final_stylecolorsize_id text,
    size_name text,
    size_description text,
    final_style_id text,
    final_stylecolor_id text
);


ALTER TABLE public.loft_ata_missing_items_stylecolorsizes OWNER TO psql;

--
-- TOC entry 1975 (class 1259 OID 137927029)
-- Name: loft_ata_missing_items_styles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_styles (
    final_style_id text,
    sty_size_type text,
    sty_missy_related_style text,
    final_style_name text,
    final_style_desc text,
    sc_type text
);


ALTER TABLE public.loft_ata_missing_items_styles OWNER TO psql;

--
-- TOC entry 1646 (class 1259 OID 67698346)
-- Name: loft_ata_missing_items_take2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2 (
    product text,
    style text,
    department text,
    class text,
    subclass text,
    stylecolor_name text,
    stylecolor_desc text,
    style_name text,
    style_desc text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_missy_related_stylecolor text,
    master_sty_size_type text,
    cc_size_concepts_in_assortment text[],
    final_style_id text,
    final_style_name text,
    final_style_desc text,
    final_stylecolor_id text,
    final_stylecolor_name text,
    final_stylecolor_desc text,
    final_cccolor text,
    final_cc_color_id text,
    final_cc_color_name text,
    final_cccolorfamily text,
    final_cc_color_type text,
    final_class_id text,
    final_subclass_id text,
    sty_size_type text,
    sc_type text
);


ALTER TABLE public.loft_ata_missing_items_take2 OWNER TO psql;

--
-- TOC entry 1647 (class 1259 OID 67698351)
-- Name: loft_ata_missing_items_take2_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer
);


ALTER TABLE public.loft_ata_missing_items_take2_assortment OWNER TO psql;

--
-- TOC entry 1648 (class 1259 OID 67698356)
-- Name: loft_ata_missing_items_take2_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_d_product (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.loft_ata_missing_items_take2_d_product OWNER TO psql;

--
-- TOC entry 1649 (class 1259 OID 67698361)
-- Name: loft_ata_missing_items_take2_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_existing (
    product text,
    style text,
    subclass text,
    class text,
    department text,
    stylecolor_name text,
    stylecolor_desc text,
    style_name text,
    style_desc text,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    record_state smallint,
    sty_size_type text,
    cc_size_concepts_in_assortment text[],
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text
);


ALTER TABLE public.loft_ata_missing_items_take2_existing OWNER TO psql;

--
-- TOC entry 1650 (class 1259 OID 67698366)
-- Name: loft_ata_missing_items_take2_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_h_prodstd (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text
);


ALTER TABLE public.loft_ata_missing_items_take2_h_prodstd OWNER TO psql;

--
-- TOC entry 1651 (class 1259 OID 67698371)
-- Name: loft_ata_missing_items_take2_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_imgattributes (
    product text,
    img text
);


ALTER TABLE public.loft_ata_missing_items_take2_imgattributes OWNER TO psql;

--
-- TOC entry 1652 (class 1259 OID 67698376)
-- Name: loft_ata_missing_items_take2_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_sizeattributes (
    product text,
    sizeattribute text,
    parent_id text
);


ALTER TABLE public.loft_ata_missing_items_take2_sizeattributes OWNER TO psql;

--
-- TOC entry 1653 (class 1259 OID 67698381)
-- Name: loft_ata_missing_items_take2_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_styleattributes (
    product text,
    sty_end_use text,
    sty_pyramid_lens text,
    sty_silhouette text,
    sty_third_party text,
    sty_sleeve_length text,
    sty_type text,
    sty_neckline text,
    sty_merch_group text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_material text,
    sty_mfp_program_id text,
    sty_shape text,
    sty_program_id text,
    sty_length text,
    sty_placement text,
    sty_texture text,
    sty_gauge text,
    sty_accessory_measurements text,
    sty_finish text,
    sty_adhoc text,
    sty_retail_ticket_type text,
    sty_size_type text,
    sty_size_range text,
    sty_missy_related_style text
);


ALTER TABLE public.loft_ata_missing_items_take2_styleattributes OWNER TO psql;

--
-- TOC entry 1654 (class 1259 OID 67698386)
-- Name: loft_ata_missing_items_take2_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_stylecolorattributes (
    product text,
    cc_fabric_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_ppns text,
    cc_print_pattern_type text,
    cc_novelty_details text,
    cc_print_description text,
    cc_matchbacks text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_known text,
    cc_collection text,
    cc_preview text,
    cc_marketing_flag text,
    cc_promotion_flag text,
    cc_table text,
    cc_internet_tall_style text,
    cc_price_band text,
    cc_good_better_best text,
    cc_lifecycle text,
    cc_primary_selling text,
    cc_climate_product text,
    cc_online_exclusive_flag text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_missy_related_stylecolor text
);


ALTER TABLE public.loft_ata_missing_items_take2_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1655 (class 1259 OID 67698391)
-- Name: loft_ata_missing_items_take2_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_stylecolorchannelattributes (
    product text,
    missy_related_stylecolor text,
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
    record_state integer
);


ALTER TABLE public.loft_ata_missing_items_take2_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1656 (class 1259 OID 67698396)
-- Name: loft_ata_missing_items_take2_stylecolorsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_stylecolorsizes (
    final_stylecolorsize_id text,
    size_name text,
    size_description text,
    final_style_id text,
    final_stylecolor_id text
);


ALTER TABLE public.loft_ata_missing_items_take2_stylecolorsizes OWNER TO psql;

--
-- TOC entry 1657 (class 1259 OID 67698401)
-- Name: loft_ata_missing_items_take2_styles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_styles (
    final_style_id text,
    sty_size_type text,
    sty_missy_related_style text,
    final_style_name text,
    final_style_desc text,
    sc_type text
);


ALTER TABLE public.loft_ata_missing_items_take2_styles OWNER TO psql;

--
-- TOC entry 1658 (class 1259 OID 67698406)
-- Name: loft_ata_missing_items_take2_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_take2_validsizes (
    class text,
    size_range text,
    size_range_description text,
    sizeattribute text
);


ALTER TABLE public.loft_ata_missing_items_take2_validsizes OWNER TO psql;

--
-- TOC entry 1659 (class 1259 OID 67698411)
-- Name: loft_ata_missing_items_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_missing_items_validsizes (
    class text,
    size_range text,
    size_range_description text,
    sizeattribute text
);


ALTER TABLE public.loft_ata_missing_items_validsizes OWNER TO psql;

--
-- TOC entry 1660 (class 1259 OID 67698416)
-- Name: loft_ata_size_concept_defaults; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_size_concept_defaults (
    department text,
    department_name text,
    size_type text,
    default_tier text,
    default_climate text,
    default_selling_channel text,
    default_ssg text,
    default_pssr_stores text,
    default_pssr_ecom text,
    default_size_min text,
    default_size_min_weeks text,
    default_return_rate_stores text,
    default_return_rate_ecom text,
    cross_channel_return_rate text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ata_size_concept_defaults OWNER TO psql;

--
-- TOC entry 1661 (class 1259 OID 67698428)
-- Name: loft_ata_size_concept_defaults_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ata_size_concept_defaults_bk (
    department text,
    department_name text,
    size_type text,
    default_tier text,
    default_climate text,
    default_selling_channel text,
    default_ssg text,
    default_pssr_stores text,
    default_pssr_ecom text,
    default_size_min text,
    default_size_min_weeks text,
    default_return_rate_stores text,
    default_return_rate_ecom text,
    cross_channel_return_rate text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ata_size_concept_defaults_bk OWNER TO psql;

--
-- TOC entry 1662 (class 1259 OID 67698433)
-- Name: loft_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_authorization (
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


ALTER TABLE public.loft_authorization OWNER TO psql;

--
-- TOC entry 1663 (class 1259 OID 67698445)
-- Name: loft_c_conversion_file_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_conversion_file_lifecycle (
    brand text,
    storeset text,
    division text,
    department text,
    class text,
    related_missy_style_id text,
    size_type text,
    style_id text,
    style_color_id text,
    style_color_description text,
    ticket_price text,
    cost text,
    default_discount_percent real,
    debut_week text,
    md_week text,
    exit_week text,
    auto_roll_forward boolean,
    planned_sell_down_week text,
    md_strategy text,
    store_tier text[],
    store_climate text[],
    ssg text[],
    size_range text,
    size_range_store text[],
    size_range_ecom text[],
    size_min integer,
    size_min_weeks integer,
    pre_season_rating_stores integer,
    pre_season_rating_ecom integer,
    receipt_interval integer,
    return_rate_stores real,
    return_rate_ecom real,
    cross_channel_return_rate real,
    order_min_qty integer,
    order_multiple integer,
    can_ticket real,
    selling_channel text,
    cc_missy_related_stylecolor text,
    initrcptwk text,
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text
);


ALTER TABLE public.loft_c_conversion_file_lifecycle OWNER TO psql;

--
-- TOC entry 1664 (class 1259 OID 67698450)
-- Name: loft_c_conversion_history_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_conversion_history_lifecycle (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[],
    last_inv_wk text,
    lstfpwk text,
    last_rcpt_wk text,
    lastdcorder text,
    style text,
    subclass text,
    class text,
    department text,
    sty_size_range text,
    currentprice text
);


ALTER TABLE public.loft_c_conversion_history_lifecycle OWNER TO psql;

--
-- TOC entry 1665 (class 1259 OID 67698455)
-- Name: loft_c_conversion_history_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_conversion_history_stylecolorchannelattributes (
    product text,
    missy_related_stylecolor text,
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
    slsrnk_store integer,
    slsrnk_ecom integer,
    ccticketpricechannel real,
    validsizes text[],
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    ccrangecode text,
    ccmdstrategy text,
    cc_presmin_weeks integer,
    cc_presmin integer,
    cc_rcptint integer,
    cc_ordermultiple integer,
    cc_discount_pct numeric,
    cc_imupct real,
    cc_existingwac real,
    cc_systemcost real,
    cc_plan_cost real,
    irr_mode text,
    plan_current text
);


ALTER TABLE public.loft_c_conversion_history_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1666 (class 1259 OID 67698460)
-- Name: loft_c_conversion_history_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_conversion_history_ticketprice (
    currentprice text,
    parent_id text
);


ALTER TABLE public.loft_c_conversion_history_ticketprice OWNER TO psql;

--
-- TOC entry 1667 (class 1259 OID 67698465)
-- Name: loft_c_conversion_history_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_conversion_history_validsizes (
    product text,
    valid_sizes text
);


ALTER TABLE public.loft_c_conversion_history_validsizes OWNER TO psql;

--
-- TOC entry 1668 (class 1259 OID 67698473)
-- Name: loft_c_cutover_prep_history; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_c_cutover_prep_history (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[]
);


ALTER TABLE public.loft_c_cutover_prep_history OWNER TO psql;

--
-- TOC entry 1669 (class 1259 OID 67698478)
-- Name: loft_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_corpdisc (
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
    corpaddoff_ecom real DEFAULT 0,
    corpexcl_ecom real DEFAULT 0
);


ALTER TABLE public.loft_corpdisc OWNER TO psql;

--
-- TOC entry 1885 (class 1259 OID 126388262)
-- Name: loft_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_corpdisc_backup (
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
    corpexcl_ecom real
);


ALTER TABLE public.loft_corpdisc_backup OWNER TO psql;

--
-- TOC entry 1670 (class 1259 OID 67698499)
-- Name: loft_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_cluster (
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


ALTER TABLE public.loft_d_cluster OWNER TO psql;

--
-- TOC entry 1671 (class 1259 OID 67698511)
-- Name: loft_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_location (
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


ALTER TABLE public.loft_d_location OWNER TO psql;

--
-- TOC entry 1672 (class 1259 OID 67698523)
-- Name: loft_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_prodlife (
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


ALTER TABLE public.loft_d_prodlife OWNER TO psql;

--
-- TOC entry 1673 (class 1259 OID 67698535)
-- Name: loft_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_product (
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


ALTER TABLE public.loft_d_product OWNER TO psql;

--
-- TOC entry 1674 (class 1259 OID 67698547)
-- Name: loft_d_product_duplicates_20250521; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_product_duplicates_20250521 (
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


ALTER TABLE public.loft_d_product_duplicates_20250521 OWNER TO psql;

--
-- TOC entry 1675 (class 1259 OID 67698552)
-- Name: loft_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_d_time (
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


ALTER TABLE public.loft_d_time OWNER TO psql;

--
-- TOC entry 1676 (class 1259 OID 67698564)
-- Name: loft_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_designimages (
    product text,
    img text
);


ALTER TABLE public.loft_designimages OWNER TO psql;

--
-- TOC entry 1677 (class 1259 OID 67698569)
-- Name: loft_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_eohdata_stylecolor (
    product text,
    channel text,
    eohu real
);


ALTER TABLE public.loft_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 1678 (class 1259 OID 67698574)
-- Name: loft_failed_items_20250303; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_failed_items_20250303 (
    product text
);


ALTER TABLE public.loft_failed_items_20250303 OWNER TO psql;

--
-- TOC entry 1991 (class 1259 OID 139698351)
-- Name: loft_fix_null_cccolorfamily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_fix_null_cccolorfamily (
    product text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text
);


ALTER TABLE public.loft_fix_null_cccolorfamily OWNER TO psql;

--
-- TOC entry 1989 (class 1259 OID 139698329)
-- Name: loft_fix_size_concept_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_fix_size_concept_specstyles (
    style text,
    name text,
    sty_specstyleid text,
    stylecolor text,
    cc_specstylecolorid text,
    cc_specstyle_cccolor text,
    record_state smallint,
    sty_missy_related_style text,
    cc_missy_related_stylecolor text,
    sty_size_type text,
    missy_specstyleid text,
    missy_specstyle_cccolor text,
    new_specstyle text
);


ALTER TABLE public.loft_fix_size_concept_specstyles OWNER TO psql;

--
-- TOC entry 1990 (class 1259 OID 139698334)
-- Name: loft_fix_specstylecolorid; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_fix_specstylecolorid (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real
);


ALTER TABLE public.loft_fix_specstylecolorid OWNER TO psql;

--
-- TOC entry 1679 (class 1259 OID 67698594)
-- Name: loft_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_timeflrset (
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


ALTER TABLE public.loft_h_timeflrset OWNER TO psql;

--
-- TOC entry 1680 (class 1259 OID 67698606)
-- Name: loft_for_tgt_flrset_hier; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.loft_for_tgt_flrset_hier AS
 SELECT a.id,
    a.indx,
    b.ancestor0 AS superset,
    b.ancestor1 AS fiscal_year,
    (now())::timestamp(0) without time zone AS updated_at
   FROM public.loft_d_time a,
    public.loft_h_timeflrset b
  WHERE ((a.levelid = 'floorset'::text) AND (a.id = b.id));


ALTER VIEW public.loft_for_tgt_flrset_hier OWNER TO psql;

--
-- TOC entry 1681 (class 1259 OID 67698610)
-- Name: loft_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_clusterstd OWNER TO psql;

--
-- TOC entry 1682 (class 1259 OID 67698622)
-- Name: loft_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_locdc OWNER TO psql;

--
-- TOC entry 1683 (class 1259 OID 67698634)
-- Name: loft_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_locdcstd (
    id text NOT NULL,
    ancestor0 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_locdcstd OWNER TO psql;

--
-- TOC entry 1684 (class 1259 OID 67698645)
-- Name: loft_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    ancestor7 text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_locstd OWNER TO psql;

--
-- TOC entry 1685 (class 1259 OID 67698657)
-- Name: loft_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_prodlifestd OWNER TO psql;

--
-- TOC entry 1686 (class 1259 OID 67698669)
-- Name: loft_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_prodstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_h_prodstd OWNER TO psql;

--
-- TOC entry 1687 (class 1259 OID 67698680)
-- Name: loft_h_timeflrset_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_timeflrset_bkp (
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


ALTER TABLE public.loft_h_timeflrset_bkp OWNER TO psql;

--
-- TOC entry 1688 (class 1259 OID 67698685)
-- Name: loft_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_h_timestd (
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


ALTER TABLE public.loft_h_timestd OWNER TO psql;

--
-- TOC entry 1689 (class 1259 OID 67698697)
-- Name: loft_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_dclookup (
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


ALTER TABLE public.loft_l_dclookup OWNER TO psql;

--
-- TOC entry 1690 (class 1259 OID 67698709)
-- Name: loft_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_dependencylookup (
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


ALTER TABLE public.loft_l_dependencylookup OWNER TO psql;

--
-- TOC entry 1691 (class 1259 OID 67698723)
-- Name: loft_l_dependencylookup_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_dependencylookup_bk (
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


ALTER TABLE public.loft_l_dependencylookup_bk OWNER TO psql;

--
-- TOC entry 1692 (class 1259 OID 67698728)
-- Name: loft_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_priceeventlookup (
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


ALTER TABLE public.loft_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 1693 (class 1259 OID 67698742)
-- Name: loft_l_size_concept_lookups; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_size_concept_lookups (
    department text,
    department_name text,
    master_style_size_type text,
    master_style_class text,
    master_style_class_name text,
    master_style_subclass text,
    master_style_subclass_name text,
    master_style_size_range_id text,
    related_size_type text,
    related_size_class text,
    related_size_class_name text,
    related_size_subclass text,
    related_size_subclass_name text,
    related_size_size_range_id text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_l_size_concept_lookups OWNER TO psql;

--
-- TOC entry 1694 (class 1259 OID 67698754)
-- Name: loft_l_size_concept_lookups_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_size_concept_lookups_bk (
    department text,
    department_name text,
    master_style_size_type text,
    master_style_class text,
    master_style_class_name text,
    master_style_subclass text,
    master_style_subclass_name text,
    master_style_size_range_id text,
    related_size_type text,
    related_size_class text,
    related_size_class_name text,
    related_size_subclass text,
    related_size_subclass_name text,
    related_size_size_range_id text,
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_l_size_concept_lookups_bk OWNER TO psql;

--
-- TOC entry 1884 (class 1259 OID 126388194)
-- Name: loft_l_size_range_validsize_defaults; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_size_range_validsize_defaults (
    class text NOT NULL,
    size_range text NOT NULL,
    size_range_description text NOT NULL,
    validsizes_store text[],
    validsizes_ecom text[],
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_l_size_range_validsize_defaults OWNER TO psql;

--
-- TOC entry 1695 (class 1259 OID 67698771)
-- Name: loft_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_ssglookup (
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


ALTER TABLE public.loft_l_ssglookup OWNER TO psql;

--
-- TOC entry 1696 (class 1259 OID 67698785)
-- Name: loft_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_storelookup (
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


ALTER TABLE public.loft_l_storelookup OWNER TO psql;

--
-- TOC entry 1697 (class 1259 OID 67698799)
-- Name: loft_l_storelookup_grades_unnested; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_storelookup_grades_unnested (
    "time" text,
    product text,
    id text,
    value text,
    unnest text
);


ALTER TABLE public.loft_l_storelookup_grades_unnested OWNER TO psql;

--
-- TOC entry 1698 (class 1259 OID 67698804)
-- Name: loft_l_stylecolor_season_cost; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_l_stylecolor_season_cost (
    bbr_stycol_id character varying(500),
    design_season_id character varying(500),
    elc character varying(500),
    stylecolor_status character varying(500),
    indx integer,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by character varying(20),
    updated_at timestamp without time zone,
    updated_by character varying(20),
    record_state integer
);


ALTER TABLE public.loft_l_stylecolor_season_cost OWNER TO psql;

--
-- TOC entry 1699 (class 1259 OID 67698809)
-- Name: loft_ma_districtattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_districtattributes (
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


ALTER TABLE public.loft_ma_districtattributes OWNER TO psql;

--
-- TOC entry 1700 (class 1259 OID 67698821)
-- Name: loft_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_dptflrsetattributes (
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
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks integer,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_planned_lof_wk text,
    default_size_min integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_retpct_str real,
    default_retpct_ecomm real,
    default_retpct_cross real,
    default_grade text[] DEFAULT '{}'::text[],
    default_strclimate text[] DEFAULT '{}'::text[],
    default_ssg text[] DEFAULT '{}'::text[],
    default_pssr_stores integer,
    default_pssr_ecom integer,
    default_ccordermultiple integer,
    default_ccmdstrategy character varying(200),
    floorset_attribute character varying(200),
    default_discount real,
    ly_floorset_attribute character varying(200),
    lly_floorset_attribute character varying(200),
    design_season_id character varying(200),
    design_season_name character varying(200),
    default_flnrange text[] DEFAULT '{}'::text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    default_discount_ecom real
);


ALTER TABLE public.loft_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 1701 (class 1259 OID 67698837)
-- Name: loft_ma_dptflrsetattributes_bk20240516; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_dptflrsetattributes_bk20240516 (
    indx integer,
    product text,
    "time" text,
    floorset_name text,
    initialrcptwk text,
    rcptstart text,
    rcptend text,
    slsstart text,
    slsend text,
    too integer,
    lyrcptstart text,
    lyrcptend text,
    lyslsstart text,
    lyslsend text,
    ap_start text,
    ap_end text,
    default_dbt_wk text,
    default_too integer,
    default_mkdnwks text,
    default_erlstmkdnwk text,
    default_exitdate text,
    default_planned_lof_wk text,
    default_size_min integer,
    default_presmin_weeks integer,
    default_ccrcptint integer,
    default_retpct_str real,
    default_retpct_ecomm real,
    default_retpct_cross real,
    default_ccordermultiple integer,
    default_ccmdstrategy character varying(200),
    floorset_attribute character varying(200),
    default_discount real,
    ly_floorset_attribute character varying(200),
    lly_floorset_attribute character varying(200),
    default_grade text[],
    default_strclimate text[],
    default_ssg text[],
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_dptflrsetattributes_bk20240516 OWNER TO psql;

--
-- TOC entry 1702 (class 1259 OID 67698842)
-- Name: loft_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_imgattributes (
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


ALTER TABLE public.loft_ma_imgattributes OWNER TO psql;

--
-- TOC entry 1703 (class 1259 OID 67698854)
-- Name: loft_ma_imgattributes_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_imgattributes_archive (
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


ALTER TABLE public.loft_ma_imgattributes_archive OWNER TO psql;

--
-- TOC entry 1704 (class 1259 OID 67698867)
-- Name: loft_ma_regionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_regionattributes (
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


ALTER TABLE public.loft_ma_regionattributes OWNER TO psql;

--
-- TOC entry 1705 (class 1259 OID 67698879)
-- Name: loft_ma_sellingchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_sellingchannelattributes (
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


ALTER TABLE public.loft_ma_sellingchannelattributes OWNER TO psql;

--
-- TOC entry 1706 (class 1259 OID 67698891)
-- Name: loft_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_sizeattributes (
    product text NOT NULL,
    parent_id text,
    size_id text,
    sizeattribute text,
    ticket_size text,
    size_desc text,
    size_range text,
    sku_create_date text,
    original_price text,
    current_price text,
    isvalid integer DEFAULT 1 NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 1707 (class 1259 OID 67698904)
-- Name: loft_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_storeattributes (
    location text NOT NULL,
    strname text,
    str_climate text,
    str_storedistrict_nbr text,
    str_storeregion_nbr text,
    str_subregion text,
    str_tier text,
    str_brand text,
    str_city text,
    str_state text,
    str_salessqft text,
    str_totalsqft text,
    str_opendate text,
    str_closingdate text,
    str_dcflag text,
    str_latitude text,
    str_longitude text,
    str_location text,
    str_secondarylocation text,
    str_rov text,
    str_storepriority text,
    str_volume text,
    str_country text,
    str_postalcode text,
    str_curbside text,
    str_bopis text,
    str_tempclosed text,
    str_reopeningdate text,
    str_remodeldatefrom text,
    str_remodeldateto text,
    str_storeremainopen text,
    str_status text,
    str_primary_dc text,
    str_selling_channel text,
    str_grade text,
    account_name text,
    account_desc text,
    district_name text,
    district_desc text,
    region_name text,
    region_desc text,
    sub_channel_name text,
    sub_channel_desc text,
    selling_channel_name text,
    selling_channel_desc text,
    channel_name text,
    channel_desc text,
    brand_name text,
    brand_desc text,
    total_location_name text,
    total_location_desc text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ma_storeattributes OWNER TO psql;

--
-- TOC entry 1708 (class 1259 OID 67698916)
-- Name: loft_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_storeattributes_lat_long (
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


ALTER TABLE public.loft_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 1709 (class 1259 OID 67698928)
-- Name: loft_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes (
    product text NOT NULL,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    sty_accessory_measurements text,
    sty_adhoc text,
    sty_finish text,
    sty_gauge text,
    sty_placement text,
    sty_program_id text,
    sty_texture text,
    sty_tech_design_garment_content text,
    sty_tech_design_stretch_level text,
    sty_tech_design_closure text,
    sty_tech_design_fit_block text,
    sty_tech_design_fit_intent text,
    sty_tech_design_leg_shape text,
    sty_tech_design_length text,
    sty_tech_design_placement text,
    sty_tech_design_rise text,
    sty_tech_design_type text,
    sty_bellyband text,
    sty_boxed_packaging text,
    sty_fit_description text,
    sty_hangtag_1 text,
    sty_hangtag_2 text,
    sty_jewelry_cards text,
    sty_joker_matchbook text,
    sty_main_label text,
    sty_retail_ticket_type text,
    sty_size_sticker text,
    sty_stylenumber_name text,
    sty_size_concepts text[] DEFAULT '{}'::text[],
    sty_size_concept_types text[] DEFAULT '{}'::text[],
    sty_specstyleid text,
    sty_missy_related_style_bbr text,
    sty_size_range_bbr text,
    sty_size_type_bbr text,
    sty_price_bands text,
    sty_good_better_best text,
    sty_material text,
    sty_primary_material_bbr text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    sty_fabric_description_free_text text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real
);


ALTER TABLE public.loft_ma_styleattributes OWNER TO psql;

--
-- TOC entry 1710 (class 1259 OID 67698942)
-- Name: loft_ma_styleattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_20251010 (
    product text,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    sty_accessory_measurements text,
    sty_adhoc text,
    sty_finish text,
    sty_gauge text,
    sty_placement text,
    sty_program_id text,
    sty_texture text,
    sty_tech_design_garment_content text,
    sty_tech_design_stretch_level text,
    sty_tech_design_closure text,
    sty_tech_design_fit_block text,
    sty_tech_design_fit_intent text,
    sty_tech_design_leg_shape text,
    sty_tech_design_length text,
    sty_tech_design_placement text,
    sty_tech_design_rise text,
    sty_tech_design_type text,
    sty_bellyband text,
    sty_boxed_packaging text,
    sty_fit_description text,
    sty_hangtag_1 text,
    sty_hangtag_2 text,
    sty_jewelry_cards text,
    sty_joker_matchbook text,
    sty_main_label text,
    sty_retail_ticket_type text,
    sty_size_sticker text,
    sty_stylenumber_name text,
    sty_size_concepts text[],
    sty_size_concept_types text[],
    sty_specstyleid text,
    sty_missy_related_style_bbr text,
    sty_size_range_bbr text,
    sty_size_type_bbr text,
    sty_price_bands text,
    sty_good_better_best text,
    sty_material text,
    sty_primary_material_bbr text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_fabric_description_free_text text
);


ALTER TABLE public.loft_ma_styleattributes_20251010 OWNER TO psql;

--
-- TOC entry 1711 (class 1259 OID 67698947)
-- Name: loft_ma_styleattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_bk (
    product text,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    sty_accessory_measurements text,
    sty_adhoc text,
    sty_finish text,
    sty_gauge text,
    sty_placement text,
    sty_program_id text,
    sty_texture text,
    sty_tech_design_garment_content text,
    sty_tech_design_stretch_level text,
    sty_tech_design_closure text,
    sty_tech_design_fit_block text,
    sty_tech_design_fit_intent text,
    sty_tech_design_leg_shape text,
    sty_tech_design_length text,
    sty_tech_design_placement text,
    sty_tech_design_rise text,
    sty_tech_design_type text,
    sty_bellyband text,
    sty_boxed_packaging text,
    sty_fit_description text,
    sty_hangtag_1 text,
    sty_hangtag_2 text,
    sty_jewelry_cards text,
    sty_joker_matchbook text,
    sty_main_label text,
    sty_retail_ticket_type text,
    sty_size_sticker text,
    sty_stylenumber_name text,
    sty_size_concepts text[],
    sty_size_concept_types text[],
    sty_specstyleid text,
    sty_missy_related_style_bbr text,
    sty_size_range_bbr text,
    sty_size_type_bbr text,
    sty_price_bands text,
    sty_good_better_best text,
    sty_material text,
    sty_primary_material_bbr text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_styleattributes_bk OWNER TO psql;

--
-- TOC entry 1712 (class 1259 OID 67698952)
-- Name: loft_ma_styleattributes_bk20240415; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_bk20240415 (
    product text,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_styleattributes_bk20240415 OWNER TO psql;

--
-- TOC entry 1713 (class 1259 OID 67698957)
-- Name: loft_ma_styleattributes_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_existing (
    product character varying(500) NOT NULL,
    style_description character varying(500),
    sty_article_description character varying(500),
    sty_coordination_article character varying(500),
    sty_end_use character varying(500),
    sty_fabric_profile character varying(500),
    sty_fit character varying(500),
    sty_hemline_detail character varying(500),
    sty_length character varying(500),
    sty_merch_category character varying(500),
    sty_merch_group character varying(500),
    sty_merchandise_dept character varying(500),
    sty_mfp_program_id character varying(500),
    sty_missy_petite_nonapparel character varying(500),
    sty_missy_related_style character varying(500),
    sty_neckline character varying(500),
    sty_pyramid_lens character varying(500),
    sty_shape character varying(500),
    sty_silhouette character varying(500),
    sty_size_range character varying(500),
    sty_size_type character varying(500),
    sty_sleeve_length character varying(500),
    ccstylecreatedate character varying(500),
    sty_third_party character varying(500),
    sty_type character varying(500),
    sty_vendor_style_description character varying(500),
    sty_fabric_description character varying(500),
    sty_accessory_measurements character varying(500),
    sty_adhoc character varying(500),
    sty_finish character varying(500),
    sty_gauge character varying(500),
    sty_placement character varying(500),
    sty_program_id character varying(500),
    sty_texture character varying(500),
    sty_tech_design_garment_content character varying(500),
    sty_tech_design_stretch_level character varying(500),
    sty_tech_design_closure character varying(500),
    sty_tech_design_fit_block character varying(500),
    sty_tech_design_fit_intent character varying(500),
    sty_tech_design_leg_shape character varying(500),
    sty_tech_design_length character varying(500),
    sty_tech_design_placement character varying(500),
    sty_tech_design_rise character varying(500),
    sty_tech_design_type character varying(500),
    sty_bellyband character varying(500),
    sty_boxed_packaging character varying(500),
    sty_fit_description character varying(500),
    sty_hangtag_1 character varying(500),
    sty_hangtag_2 character varying(500),
    sty_jewelry_cards character varying(500),
    sty_joker_matchbook character varying(500),
    sty_main_label character varying(500),
    sty_retail_ticket_type character varying(500),
    sty_size_sticker character varying(500),
    sty_stylenumber_name character varying(500),
    sty_size_concepts character varying(500),
    sty_size_concept_types character varying(500),
    sty_specstyleid character varying(500),
    sty_missy_related_style_bbr character varying(500),
    sty_size_range_bbr character varying(500),
    sty_size_type_bbr character varying(500),
    sty_price_bands character varying(500),
    sty_good_better_best character varying(500),
    sty_material character varying(500),
    sty_primary_material_bbr character varying(500),
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc(('sec'::character varying(500))::text, CURRENT_TIMESTAMP),
    created_by character varying(500) DEFAULT 'system'::character varying(500),
    updated_at timestamp without time zone DEFAULT date_trunc(('sec'::character varying(500))::text, CURRENT_TIMESTAMP),
    updated_by character varying(500) DEFAULT 'system'::character varying(500),
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ma_styleattributes_existing OWNER TO psql;

--
-- TOC entry 1839 (class 1259 OID 96472873)
-- Name: loft_ma_styleattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_intraday (
    product text,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    sty_accessory_measurements text,
    sty_adhoc text,
    sty_finish text,
    sty_gauge text,
    sty_placement text,
    sty_program_id text,
    sty_texture text,
    sty_tech_design_garment_content text,
    sty_tech_design_stretch_level text,
    sty_tech_design_closure text,
    sty_tech_design_fit_block text,
    sty_tech_design_fit_intent text,
    sty_tech_design_leg_shape text,
    sty_tech_design_length text,
    sty_tech_design_placement text,
    sty_tech_design_rise text,
    sty_tech_design_type text,
    sty_bellyband text,
    sty_boxed_packaging text,
    sty_fit_description text,
    sty_hangtag_1 text,
    sty_hangtag_2 text,
    sty_jewelry_cards text,
    sty_joker_matchbook text,
    sty_main_label text,
    sty_retail_ticket_type text,
    sty_size_sticker text,
    sty_stylenumber_name text,
    sty_size_concepts text[],
    sty_size_concept_types text[],
    sty_specstyleid text,
    sty_missy_related_style_bbr text,
    sty_size_range_bbr text,
    sty_size_type_bbr text,
    sty_price_bands text,
    sty_good_better_best text,
    sty_material text,
    sty_primary_material_bbr text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    sty_fabric_description_free_text text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real
);


ALTER TABLE public.loft_ma_styleattributes_intraday OWNER TO psql;

--
-- TOC entry 1714 (class 1259 OID 67698974)
-- Name: loft_ma_styleattributes_test_jr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_styleattributes_test_jr (
    product text,
    style_description text,
    sty_article_description text,
    sty_coordination_article text,
    sty_end_use text,
    sty_fabric_profile text,
    sty_fit text,
    sty_hemline_detail text,
    sty_length text,
    sty_merch_category text,
    sty_merch_group text,
    sty_merchandise_dept text,
    sty_mfp_program_id text,
    sty_missy_petite_nonapparel text,
    sty_missy_related_style text,
    sty_neckline text,
    sty_pyramid_lens text,
    sty_shape text,
    sty_silhouette text,
    sty_size_range text,
    sty_size_type text,
    sty_sleeve_length text,
    ccstylecreatedate text,
    sty_third_party text,
    sty_type text,
    sty_vendor_style_description text,
    sty_fabric_description text,
    sty_accessory_measurements text,
    sty_adhoc text,
    sty_finish text,
    sty_gauge text,
    sty_placement text,
    sty_program_id text,
    sty_texture text,
    sty_tech_design_garment_content text,
    sty_tech_design_stretch_level text,
    sty_tech_design_closure text,
    sty_tech_design_fit_block text,
    sty_tech_design_fit_intent text,
    sty_tech_design_leg_shape text,
    sty_tech_design_length text,
    sty_tech_design_placement text,
    sty_tech_design_rise text,
    sty_tech_design_type text,
    sty_bellyband text,
    sty_boxed_packaging text,
    sty_fit_description text,
    sty_hangtag_1 text,
    sty_hangtag_2 text,
    sty_jewelry_cards text,
    sty_joker_matchbook text,
    sty_main_label text,
    sty_retail_ticket_type text,
    sty_size_sticker text,
    sty_stylenumber_name text,
    sty_size_concepts text[],
    sty_size_concept_types text[],
    sty_specstyleid text,
    sty_missy_related_style_bbr text,
    sty_size_range_bbr text,
    sty_size_type_bbr text,
    sty_price_bands text,
    sty_good_better_best text,
    sty_material text,
    sty_primary_material_bbr text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_styleattributes_test_jr OWNER TO psql;

--
-- TOC entry 1715 (class 1259 OID 67698979)
-- Name: loft_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes (
    product text NOT NULL,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[] DEFAULT '{}'::text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    cc_floorset text,
    cc_use_sys_floorset boolean DEFAULT true,
    cc_storeset_period text,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real
);


ALTER TABLE public.loft_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 1716 (class 1259 OID 67698993)
-- Name: loft_ma_stylecolorattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_20251010 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.loft_ma_stylecolorattributes_20251010 OWNER TO psql;

--
-- TOC entry 1717 (class 1259 OID 67698998)
-- Name: loft_ma_stylecolorattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bk (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_stylecolorattributes_bk OWNER TO psql;

--
-- TOC entry 1718 (class 1259 OID 67699003)
-- Name: loft_ma_stylecolorattributes_bk20240415; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bk20240415 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    department_name text,
    class_name text,
    subclass_name text,
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_stylecolorattributes_bk20240415 OWNER TO psql;

--
-- TOC entry 1719 (class 1259 OID 67699008)
-- Name: loft_ma_stylecolorattributes_bk_20240205; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bk_20240205 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.loft_ma_stylecolorattributes_bk_20240205 OWNER TO psql;

--
-- TOC entry 1720 (class 1259 OID 67699016)
-- Name: loft_ma_stylecolorattributes_bk_20240306; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bk_20240306 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.loft_ma_stylecolorattributes_bk_20240306 OWNER TO psql;

--
-- TOC entry 1721 (class 1259 OID 67699021)
-- Name: loft_ma_stylecolorattributes_bk_20250216; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bk_20250216 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text
);


ALTER TABLE public.loft_ma_stylecolorattributes_bk_20250216 OWNER TO psql;

--
-- TOC entry 1826 (class 1259 OID 85203455)
-- Name: loft_ma_stylecolorattributes_bkp_sup3782; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_bkp_sup3782 (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real,
    cc_current_price text
);


ALTER TABLE public.loft_ma_stylecolorattributes_bkp_sup3782 OWNER TO psql;

--
-- TOC entry 1722 (class 1259 OID 67699031)
-- Name: loft_ma_stylecolorattributes_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_existing (
    product character varying(500) NOT NULL,
    cc_stylecolor_description character varying(500),
    cccolor character varying(500),
    cc_color_id character varying(500),
    cc_color_name character varying(500),
    cccolorfamily character varying(500),
    cc_color_type character varying(500),
    cc_climate_product character varying(500),
    cc_collection character varying(500),
    cc_delivery_name character varying(500),
    cc_fabric_description character varying(500),
    cc_good_better_best character varying(500),
    cc_internet_tall_style character varying(500),
    cc_known character varying(500),
    cc_lifecycle character varying(500),
    cc_marketing_flag character varying(500),
    cc_matchbacks character varying(500),
    cc_novelty_details character varying(500),
    cc_novelty character varying(500),
    cc_online_exclusive_flag character varying(500),
    cc_opus character varying(500),
    cc_preview character varying(500),
    cc_ppns character varying(500),
    cc_price_band character varying(500),
    cc_primary_selling character varying(500),
    cc_print_description character varying(500),
    cc_print_pattern_type character varying(500),
    cc_promotion_flag character varying(500),
    cc_season character varying(500),
    cc_storeset character varying(500),
    cc_table character varying(500),
    ccstylecolorcreatedate character varying(500),
    cc_delivery_month character varying(500),
    cc_stylecolornumber_name character varying(500),
    department_name character varying(500),
    class_name character varying(500),
    subclass_name character varying(500),
    cc_specstyle_cccolor character varying(500),
    cc_specstylecolorid character varying(500),
    plan_comments character varying(500),
    merch_comments character varying(500),
    cc_free_one character varying(500),
    cc_free_two character varying(500),
    cc_free_three character varying(500),
    cc_brand_concept character varying(500),
    cc_ecom_exclusives character varying(500),
    isassortment character varying(500),
    cc_missy_related_stylecolor character varying(500),
    cc_size_concepts_in_assortment character varying(500),
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc(('sec'::character varying(500))::text, CURRENT_TIMESTAMP),
    created_by character varying(500) DEFAULT 'system'::character varying(500),
    updated_at timestamp without time zone DEFAULT date_trunc(('sec'::character varying(500))::text, CURRENT_TIMESTAMP),
    updated_by character varying(500) DEFAULT 'system'::character varying(500),
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ma_stylecolorattributes_existing OWNER TO psql;

--
-- TOC entry 1838 (class 1259 OID 96472868)
-- Name: loft_ma_stylecolorattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorattributes_intraday (
    product text,
    cc_stylecolor_description text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_climate_product text,
    cc_collection text,
    cc_delivery_name text,
    cc_fabric_description text,
    cc_good_better_best text,
    cc_internet_tall_style text,
    cc_known text,
    cc_lifecycle text,
    cc_marketing_flag text,
    cc_matchbacks text,
    cc_novelty_details text,
    cc_novelty text,
    cc_online_exclusive_flag text,
    cc_opus text,
    cc_preview text,
    cc_ppns text,
    cc_price_band text,
    cc_primary_selling text,
    cc_print_description text,
    cc_print_pattern_type text,
    cc_promotion_flag text,
    cc_season text,
    cc_storeset text,
    cc_table text,
    ccstylecolorcreatedate text,
    cc_delivery_month text,
    cc_stylecolornumber_name text,
    department_name text,
    class_name text,
    subclass_name text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text,
    plan_comments text,
    merch_comments text,
    cc_free_one text,
    cc_free_two text,
    cc_free_three text,
    cc_brand_concept text,
    cc_ecom_exclusives text,
    isassortment text,
    cc_missy_related_stylecolor text,
    cc_size_concepts_in_assortment text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    cc_floorset text,
    cc_use_sys_floorset boolean,
    cc_storeset_period text,
    cc_num_clones_s5 real,
    cc_num_times_cloned_s5 real
);


ALTER TABLE public.loft_ma_stylecolorattributes_intraday OWNER TO psql;

--
-- TOC entry 1723 (class 1259 OID 67699048)
-- Name: loft_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorchannelattributes (
    product text NOT NULL,
    missy_related_stylecolor text,
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
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    ccticketpricechannel_override_txt text,
    act_slsrnk_store real DEFAULT 3,
    act_slsrnk_ecom real DEFAULT 3,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    cc_discount_pct_ecom real DEFAULT 0,
    sclr_presmin_stores integer,
    sclr_presmin_ecom integer,
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    raw_aps_store real,
    raw_aps_ecom real,
    act_aps_mult_adj_store real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text DEFAULT 'Copy Rating'::text,
    cloned_at timestamp(0) without time zone,
    cc_service_level real DEFAULT 0.85,
    cc_service_level_ecom real DEFAULT 0.99
);


ALTER TABLE public.loft_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1724 (class 1259 OID 67699078)
-- Name: loft_ma_stylecolorchannelattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorchannelattributes_20251010 (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccticketpricechannel_override_txt text,
    act_slsrnk_store real,
    act_slsrnk_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    cc_discount_pct_ecom real,
    sclr_presmin_stores integer,
    sclr_presmin_ecom integer,
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    raw_aps_store real,
    raw_aps_ecom real,
    act_aps_mult_adj_store real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text
);


ALTER TABLE public.loft_ma_stylecolorchannelattributes_20251010 OWNER TO psql;

--
-- TOC entry 1830 (class 1259 OID 91869592)
-- Name: loft_ma_stylecolorchannelattributes_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorchannelattributes_backup (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccticketpricechannel_override_txt text,
    act_slsrnk_store real,
    act_slsrnk_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    cc_discount_pct_ecom real,
    sclr_presmin_stores integer,
    sclr_presmin_ecom integer,
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    raw_aps_store real,
    raw_aps_ecom real,
    act_aps_mult_adj_store real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    cloned_at timestamp(0) without time zone
);


ALTER TABLE public.loft_ma_stylecolorchannelattributes_backup OWNER TO psql;

--
-- TOC entry 1725 (class 1259 OID 67699083)
-- Name: loft_ma_stylecolorchannelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorchannelattributes_bk (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccticketpricechannel_override_txt text,
    act_slsrnk_store real,
    act_slsrnk_ecom real
);


ALTER TABLE public.loft_ma_stylecolorchannelattributes_bk OWNER TO psql;

--
-- TOC entry 1726 (class 1259 OID 67699088)
-- Name: loft_ma_stylecolorchannelattributes_bk20240520; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorchannelattributes_bk20240520 (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_ma_stylecolorchannelattributes_bk20240520 OWNER TO psql;

--
-- TOC entry 1727 (class 1259 OID 67699093)
-- Name: loft_ma_stylecolorfloorsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_stylecolorfloorsetattributes (
    product text NOT NULL,
    "time" text NOT NULL,
    is_attr_published text,
    attr_published_at timestamp(0) without time zone,
    attr_published_user text,
    is_fc_published text,
    fc_published_at timestamp(0) without time zone,
    fc_published_user text,
    fc_published_specstyleid text,
    fc_published_specstylecolorid text,
    is_ir_published text,
    ir_published_at timestamp(0) without time zone,
    ir_published_user text,
    ir_published_specstyleid text,
    ir_published_specstylecolorid text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    is_sclr_flrset_locked text,
    fc_flrset_dc_finalqty_u_store real,
    fc_flrset_dc_finalqty_r_store real,
    fc_flrset_dc_finalqty_c_store real,
    fc_flrset_dc_finalqty_u_ecom real,
    fc_flrset_dc_finalqty_r_ecom real,
    fc_flrset_dc_finalqty_c_ecom real
);


ALTER TABLE public.loft_ma_stylecolorfloorsetattributes OWNER TO psql;

--
-- TOC entry 1728 (class 1259 OID 67699106)
-- Name: loft_ma_subclassattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_subclassattributes (
    indx integer,
    product text NOT NULL,
    conceptstyleid text,
    conceptstylecolorid text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_ma_subclassattributes OWNER TO psql;

--
-- TOC entry 1729 (class 1259 OID 67699120)
-- Name: loft_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_ma_weekattributes (
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


ALTER TABLE public.loft_ma_weekattributes OWNER TO psql;

--
-- TOC entry 1730 (class 1259 OID 67699132)
-- Name: loft_p_casepack; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_casepack (
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


ALTER TABLE public.loft_p_casepack OWNER TO psql;

--
-- TOC entry 1731 (class 1259 OID 67699144)
-- Name: loft_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_channeloverride (
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
    floorsetpo text
);


ALTER TABLE public.loft_p_channeloverride OWNER TO psql;

--
-- TOC entry 1732 (class 1259 OID 67699157)
-- Name: loft_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_dc_adj (
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
    pack_ind_flag text,
    pack_ind_flag_ecom text,
    show_in_pack text,
    show_in_pack_ecom text,
    dc_sc_finrev_ecom real,
    dc_adjcost_ecom real,
    fc_dc_finalqty_u_store real,
    fc_dc_finalqty_r_store real,
    fc_dc_finalqty_c_store real,
    fc_dc_finalqty_u_ecom real,
    fc_dc_finalqty_r_ecom real,
    fc_dc_finalqty_c_ecom real,
    lastpub_dc_finalqty_u_store real,
    lastpub_dc_finalqty_r_store real,
    lastpub_dc_finalqty_c_store real,
    lastpub_dc_finalqty_u_ecom real,
    lastpub_dc_finalqty_r_ecom real,
    lastpub_dc_finalqty_c_ecom real,
    lastpub_published_at timestamp without time zone,
    lastpub_published_user text
);


ALTER TABLE public.loft_p_dc_adj OWNER TO psql;

--
-- TOC entry 1733 (class 1259 OID 67699169)
-- Name: loft_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_dc_adj_size (
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
    dc_adjcost_ecom real,
    fc_dc_finalqty_u_store real,
    fc_dc_finalqty_r_store real,
    fc_dc_finalqty_c_store real,
    fc_dc_finalqty_u_ecom real,
    fc_dc_finalqty_r_ecom real,
    fc_dc_finalqty_c_ecom real,
    lastpub_dc_finalqty_u_store real,
    lastpub_dc_finalqty_r_store real,
    lastpub_dc_finalqty_c_store real,
    lastpub_dc_finalqty_u_ecom real,
    lastpub_dc_finalqty_r_ecom real,
    lastpub_dc_finalqty_c_ecom real,
    lastpub_published_at timestamp without time zone,
    lastpub_published_user text
);


ALTER TABLE public.loft_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 1734 (class 1259 OID 67699176)
-- Name: loft_p_dc_adj_size_sup3389; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_dc_adj_size_sup3389 (
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
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
    dc_adjcost_ecom real
);


ALTER TABLE public.loft_p_dc_adj_size_sup3389 OWNER TO psql;

--
-- TOC entry 1735 (class 1259 OID 67699181)
-- Name: loft_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_itemprice (
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
    addoff_ecom real
);


ALTER TABLE public.loft_p_itemprice OWNER TO psql;

--
-- TOC entry 1736 (class 1259 OID 67699193)
-- Name: loft_p_sizemin_by_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_sizemin_by_size (
    product text NOT NULL,
    size_min_override_store integer,
    size_min_override_ecom integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_p_sizemin_by_size OWNER TO psql;

--
-- TOC entry 1737 (class 1259 OID 67699205)
-- Name: loft_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_strategy_params (
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
    apply_targets_to_plan integer DEFAULT 0
);


ALTER TABLE public.loft_p_strategy_params OWNER TO psql;

--
-- TOC entry 1892 (class 1259 OID 126398741)
-- Name: loft_p_strategy_params_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_strategy_params_bkp (
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


ALTER TABLE public.loft_p_strategy_params_bkp OWNER TO psql;

--
-- TOC entry 1738 (class 1259 OID 67699224)
-- Name: loft_p_stylecolor_selling_channel_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_stylecolor_selling_channel_alloc_params (
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
    sclr_def_alloc_sizeattr_for_size_min text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_p_stylecolor_selling_channel_alloc_params OWNER TO psql;

--
-- TOC entry 1739 (class 1259 OID 67699237)
-- Name: loft_p_stylecolor_store_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_stylecolor_store_alloc_params (
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
    sclr_loc_fringe_flag real DEFAULT 1,
    sclr_loc_alloc_sizeattr_for_size_min text[],
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.loft_p_stylecolor_store_alloc_params OWNER TO psql;

--
-- TOC entry 1740 (class 1259 OID 67699250)
-- Name: loft_p_subclass_channel_floorset_pssr_infomap; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_subclass_channel_floorset_pssr_infomap (
    product text NOT NULL,
    "time" text NOT NULL,
    location text NOT NULL,
    pssr_key text NOT NULL,
    pssr_rank_aps_override real,
    base_aps_override real,
    pssr_rank_fp_st_override real,
    is_analytics_locked integer,
    is_analytics_approved integer,
    allow_latest_analytics integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0,
    use_targets integer
);


ALTER TABLE public.loft_p_subclass_channel_floorset_pssr_infomap OWNER TO psql;

--
-- TOC entry 1741 (class 1259 OID 67699262)
-- Name: loft_p_target_include_exclude; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_p_target_include_exclude (
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


ALTER TABLE public.loft_p_target_include_exclude OWNER TO psql;

--
-- TOC entry 1742 (class 1259 OID 67699274)
-- Name: loft_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_pg_batch_validation (
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


ALTER TABLE public.loft_pg_batch_validation OWNER TO psql;

--
-- TOC entry 1743 (class 1259 OID 67699280)
-- Name: loft_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_pg_batch_validation_archive (
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


ALTER TABLE public.loft_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 1744 (class 1259 OID 67699286)
-- Name: loft_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_pg_batch_validation_failure (
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


ALTER TABLE public.loft_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 1745 (class 1259 OID 67699292)
-- Name: loft_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_pg_batch_validation_previous (
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


ALTER TABLE public.loft_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 1746 (class 1259 OID 67699298)
-- Name: loft_plan_these_cloned_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_plan_these_cloned_style_stylecolors (
    style text NOT NULL,
    stylecolor text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    picked_for_planning integer
);


ALTER TABLE public.loft_plan_these_cloned_style_stylecolors OWNER TO psql;

--
-- TOC entry 1747 (class 1259 OID 67699303)
-- Name: loft_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_roledimension (
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


ALTER TABLE public.loft_roledimension OWNER TO psql;

--
-- TOC entry 1846 (class 1259 OID 124345336)
-- Name: loft_rollforward_insert_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_rollforward_insert_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
    ssg text[],
    flnrange text[],
    plan_type text,
    isfunded integer,
    store_count integer,
    propagate_ranging integer,
    eventdate date,
    version_id bigint,
    created_at timestamp with time zone,
    created_by text,
    updated_at timestamp with time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.loft_rollforward_insert_a_assortment OWNER TO psql;

--
-- TOC entry 1842 (class 1259 OID 124345177)
-- Name: loft_rollforward_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_rollforward_items (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccticketpricechannel_override_txt text,
    act_slsrnk_store real,
    act_slsrnk_ecom real,
    cc_first_publish_date timestamp without time zone,
    cc_first_publish_snapshot_op integer,
    cc_discount_pct_ecom real,
    sclr_presmin_stores integer,
    sclr_presmin_ecom integer,
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    raw_aps_store real,
    raw_aps_ecom real,
    act_aps_mult_adj_store real,
    act_aps_mult_adj_ecom real,
    use_act_aps_or_act_rank text,
    cloned_at timestamp(0) without time zone,
    cc_service_level real,
    cc_service_level_ecom real
);


ALTER TABLE public.loft_rollforward_items OWNER TO psql;

--
-- TOC entry 1845 (class 1259 OID 124345261)
-- Name: loft_rollforward_max_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_rollforward_max_a_assortment (
    product text,
    location text,
    "time" text,
    style text,
    str_climate text[],
    str_grade text[],
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


ALTER TABLE public.loft_rollforward_max_a_assortment OWNER TO psql;

--
-- TOC entry 1844 (class 1259 OID 124345256)
-- Name: loft_rollforward_missing_floorset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_rollforward_missing_floorset (
    product text,
    location text,
    "time" text
);


ALTER TABLE public.loft_rollforward_missing_floorset OWNER TO psql;

--
-- TOC entry 1843 (class 1259 OID 124345182)
-- Name: loft_rollforward_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_rollforward_time (
    product text,
    location text,
    indx integer,
    "time" text
);


ALTER TABLE public.loft_rollforward_time OWNER TO psql;

--
-- TOC entry 1748 (class 1259 OID 67699315)
-- Name: loft_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_servicedefn (
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


ALTER TABLE public.loft_servicedefn OWNER TO psql;

--
-- TOC entry 1749 (class 1259 OID 67699327)
-- Name: loft_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_serviceparams (
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


ALTER TABLE public.loft_serviceparams OWNER TO psql;

--
-- TOC entry 1750 (class 1259 OID 67699339)
-- Name: loft_sizemin_cleanup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_sizemin_cleanup (
    class text,
    size_range text,
    size_range_description text,
    validsizes_store text[],
    validsizes_ecom text[],
    arr_all_sizes_for_mins text[],
    sizemin_store text[],
    sizemin_ecom text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint,
    ccrangecode text
);


ALTER TABLE public.loft_sizemin_cleanup OWNER TO psql;

--
-- TOC entry 1751 (class 1259 OID 67699344)
-- Name: loft_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.loft_specimages OWNER TO psql;

--
-- TOC entry 1986 (class 1259 OID 139694128)
-- Name: loft_specimages_tmp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_specimages_tmp (
    product text,
    img text
);


ALTER TABLE public.loft_specimages_tmp OWNER TO psql;

--
-- TOC entry 1752 (class 1259 OID 67699354)
-- Name: loft_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.loft_store_hier_attr AS
 SELECT a.location,
    a.strname,
    a.str_climate,
    a.str_storedistrict_nbr,
    a.str_storeregion_nbr,
    a.str_subregion,
    a.str_tier,
    a.str_brand,
    a.str_city,
    a.str_state,
    a.str_salessqft,
    a.str_totalsqft,
    a.str_opendate,
    a.str_closingdate,
    a.str_dcflag,
    a.str_latitude,
    a.str_longitude,
    a.str_location,
    a.str_secondarylocation,
    a.str_rov,
    a.str_storepriority,
    a.str_volume,
    a.str_country,
    a.str_postalcode,
    a.str_curbside,
    a.str_bopis,
    a.str_tempclosed,
    a.str_reopeningdate,
    a.str_remodeldatefrom,
    a.str_remodeldateto,
    a.str_storeremainopen,
    a.str_status,
    a.str_primary_dc,
    a.str_selling_channel,
    a.str_grade,
    a.location AS store,
    b.ancestor0 AS account,
    a.account_name,
    a.account_desc,
    b.ancestor1 AS district,
    a.district_name,
    a.district_desc,
    b.ancestor2 AS region,
    a.region_name,
    a.region_desc,
    b.ancestor3 AS sub_channel,
    a.sub_channel_name,
    a.sub_channel_desc,
    b.ancestor4 AS selling_channel,
    a.selling_channel_name,
    a.selling_channel_desc,
    b.ancestor5 AS channel,
    a.channel_name,
    a.channel_desc,
    b.ancestor6 AS brand,
    a.brand_name,
    a.brand_desc,
    b.ancestor7 AS total_location,
    a.total_location_name,
    a.total_location_desc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state
   FROM (public.loft_ma_storeattributes a
     LEFT JOIN public.loft_h_locstd b ON ((a.location = b.id)))
  ORDER BY a.location;


ALTER VIEW public.loft_store_hier_attr OWNER TO psql;

--
-- TOC entry 1753 (class 1259 OID 67699359)
-- Name: loft_style_clone_stylecolor_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_style_clone_stylecolor_size (
    from_style text,
    to_new_style text NOT NULL,
    from_stylecolor text NOT NULL,
    to_new_stylecolor text NOT NULL,
    from_stylecolorsize text NOT NULL,
    to_new_stylecolorsize text NOT NULL,
    clone_new_master_style text NOT NULL,
    clone_new_master_stylecolor text NOT NULL,
    updated_by text NOT NULL,
    session_id text NOT NULL,
    picked_for_planning integer,
    clone_ordinal integer,
    to_new_style_name text,
    to_new_style_desc text,
    to_new_stylecolor_name text,
    to_new_stylecolor_desc text
);


ALTER TABLE public.loft_style_clone_stylecolor_size OWNER TO psql;

--
-- TOC entry 1827 (class 1259 OID 89377599)
-- Name: loft_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.loft_stylecolor_hier_attr AS
 SELECT a.product,
    a.cc_stylecolor_description,
    a.cccolor,
    a.cc_color_id,
    a.cc_color_name,
    a.cccolorfamily,
    a.cc_color_type,
    a.cc_climate_product,
    a.cc_collection,
    a.cc_delivery_name,
    a.cc_fabric_description,
    a.cc_good_better_best,
    a.cc_internet_tall_style,
    a.cc_known,
    a.cc_lifecycle,
    a.cc_marketing_flag,
    a.cc_matchbacks,
    a.cc_novelty_details,
    a.cc_novelty,
    a.cc_online_exclusive_flag,
    a.cc_opus,
    a.cc_preview,
    a.cc_ppns,
    a.cc_price_band,
    a.cc_primary_selling,
    a.cc_print_description,
    a.cc_print_pattern_type,
    a.cc_promotion_flag,
    a.cc_season,
    a.cc_storeset,
    a.cc_table,
    a.ccstylecolorcreatedate,
    a.cc_delivery_month,
    a.cc_stylecolornumber_name,
    a.cc_specstyle_cccolor,
    a.cc_specstylecolorid,
    a.plan_comments,
    a.merch_comments,
    a.cc_free_one,
    a.cc_free_two,
    a.cc_free_three,
    a.cc_brand_concept,
    a.cc_ecom_exclusives,
    a.isassortment,
    a.cc_missy_related_stylecolor,
    a.cc_size_concepts_in_assortment,
    c.style_description,
    c.sty_article_description,
    c.sty_coordination_article,
    c.sty_end_use,
    c.sty_fabric_profile,
    c.sty_fit,
    c.sty_hemline_detail,
    c.sty_length,
    c.sty_merch_category,
    c.sty_merch_group,
    c.sty_merchandise_dept,
    c.sty_mfp_program_id,
    c.sty_missy_petite_nonapparel,
    c.sty_missy_related_style,
    c.sty_neckline,
    c.sty_pyramid_lens,
    c.sty_shape,
    c.sty_silhouette,
    c.sty_size_range,
    c.sty_size_type,
    c.sty_sleeve_length,
    c.ccstylecreatedate,
    c.sty_third_party,
    c.sty_type,
    c.sty_vendor_style_description,
    c.sty_fabric_description,
    c.sty_accessory_measurements,
    c.sty_finish,
    c.sty_adhoc,
    c.sty_gauge,
    c.sty_placement,
    c.sty_program_id,
    c.sty_texture,
    c.sty_tech_design_garment_content,
    c.sty_tech_design_stretch_level,
    c.sty_tech_design_closure,
    c.sty_tech_design_fit_block,
    c.sty_tech_design_fit_intent,
    c.sty_tech_design_leg_shape,
    c.sty_tech_design_length,
    c.sty_tech_design_placement,
    c.sty_tech_design_rise,
    c.sty_tech_design_type,
    c.sty_bellyband,
    c.sty_boxed_packaging,
    c.sty_fit_description,
    c.sty_hangtag_1,
    c.sty_hangtag_2,
    c.sty_jewelry_cards,
    c.sty_joker_matchbook,
    c.sty_main_label,
    c.sty_retail_ticket_type,
    c.sty_size_sticker,
    c.sty_stylenumber_name,
    c.sty_size_concepts,
    c.sty_size_concept_types,
    c.sty_specstyleid,
    c.sty_missy_related_style_bbr,
    c.sty_size_range_bbr,
    c.sty_size_type_bbr,
    c.sty_price_bands,
    c.sty_good_better_best,
    c.sty_material,
    c.sty_primary_material_bbr,
    b.id AS stylecolor,
    b.ancestor0 AS style,
    b.ancestor1 AS subclass,
    b.ancestor2 AS class,
    b.ancestor3 AS department,
    b.ancestor4 AS total_product,
    d.stylecolor_name,
    d.stylecolor_desc,
    e.style_name,
    e.style_desc,
    g.subclass_name,
    g.subclass_desc,
    h.class_name,
    h.class_desc,
    i.department_name,
    i.department_desc,
    j.total_product_name,
    j.total_product_desc,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    GREATEST(a.updated_at, c.updated_at) AS updated_at,
    a.updated_by,
    a.record_state,
    a.cc_floorset,
        CASE
            WHEN (a.cc_use_sys_floorset = false) THEN 0
            ELSE 1
        END AS cc_use_sys_floorset,
    a.cc_storeset_period,
    c.sty_fabric_description_free_text,
    c.sty_num_clones_s5,
    c.sty_num_times_cloned_s5,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5
   FROM public.loft_ma_stylecolorattributes a,
    public.loft_h_prodstd b,
    public.loft_ma_styleattributes c,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS stylecolor_name,
            loft_d_product.description AS stylecolor_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS style_name,
            loft_d_product.description AS style_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'style'::text)) e,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS subclass_name,
            loft_d_product.description AS subclass_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'subclass'::text)) g,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS class_name,
            loft_d_product.description AS class_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'class'::text)) h,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS department_name,
            loft_d_product.description AS department_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'department'::text)) i,
    ( SELECT loft_d_product.id,
            loft_d_product.name AS total_product_name,
            loft_d_product.description AS total_product_desc
           FROM public.loft_d_product
          WHERE (loft_d_product.levelid = 'total_product'::text)) j
  WHERE ((a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = g.id) AND (b.ancestor2 = h.id) AND (b.ancestor3 = i.id) AND (b.ancestor4 = j.id))
  ORDER BY b.id;


ALTER VIEW public.loft_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 1825 (class 1259 OID 77100326)
-- Name: loft_stylecolor_sizeconcepts; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.loft_stylecolor_sizeconcepts AS
 SELECT a.product AS stylecolor,
    d.product AS style,
    a.cc_missy_related_stylecolor,
    d.sty_missy_related_style,
    d.sty_size_type,
    b.product AS stylecolorsize
   FROM public.loft_ma_stylecolorattributes a,
    public.loft_ma_sizeattributes b,
    public.loft_h_prodstd c,
    public.loft_ma_styleattributes d
  WHERE ((a.product = c.id) AND (c.ancestor0 = d.product) AND (a.product = b.parent_id));


ALTER VIEW public.loft_stylecolor_sizeconcepts OWNER TO psql;

--
-- TOC entry 1754 (class 1259 OID 67699369)
-- Name: loft_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_swatches (
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


ALTER TABLE public.loft_swatches OWNER TO psql;

--
-- TOC entry 1755 (class 1259 OID 67699381)
-- Name: loft_temp_size_range_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_temp_size_range_mapping (
    prefix text,
    full_size_range text
);


ALTER TABLE public.loft_temp_size_range_mapping OWNER TO psql;

--
-- TOC entry 1756 (class 1259 OID 67699386)
-- Name: loft_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_v_memberbasedvalidvalues (
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


ALTER TABLE public.loft_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1757 (class 1259 OID 67699398)
-- Name: loft_v_memberbasedvalidvalues_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.loft_v_memberbasedvalidvalues_bk (
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


ALTER TABLE public.loft_v_memberbasedvalidvalues_bk OWNER TO psql;

--
-- TOC entry 1758 (class 1259 OID 67699403)
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
-- TOC entry 1888 (class 1259 OID 126388309)
-- Name: modified_loft_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.modified_loft_h_timeflrset (
    id text,
    ancestor0 character varying(200),
    ancestor1 text
);


ALTER TABLE public.modified_loft_h_timeflrset OWNER TO psql;

--
-- TOC entry 1759 (class 1259 OID 67699413)
-- Name: nonassort_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.nonassort_specstyles (
    assortmentcount bigint,
    sty_specstyleid text,
    style text
);


ALTER TABLE public.nonassort_specstyles OWNER TO psql;

--
-- TOC entry 1760 (class 1259 OID 67699418)
-- Name: old_loft_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.old_loft_ma_stylecolorchannelattributes (
    product text,
    missy_related_stylecolor text,
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
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.old_loft_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 1761 (class 1259 OID 67699423)
-- Name: perf_assortperiod_week; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT loft_ma_dptflrsetattributes.product,
            loft_ma_dptflrsetattributes."time",
            loft_ma_dptflrsetattributes.ap_start,
            loft_ma_dptflrsetattributes.ap_end
           FROM public.loft_ma_dptflrsetattributes) a,
    public.loft_d_time b
  WHERE ((b.levelid = ('week'::character varying(4))::text) AND (b.id >= a.ap_start) AND (b.id <= a.ap_end));


ALTER VIEW public.perf_assortperiod_week OWNER TO psql;

--
-- TOC entry 1762 (class 1259 OID 67699428)
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
-- TOC entry 1763 (class 1259 OID 67699433)
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
-- TOC entry 1764 (class 1259 OID 67699439)
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
-- TOC entry 1765 (class 1259 OID 67699445)
-- Name: plan_failed_12142025; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_failed_12142025 (
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


ALTER TABLE public.plan_failed_12142025 OWNER TO psql;

--
-- TOC entry 1766 (class 1259 OID 67699450)
-- Name: plan_failed_12142025_v2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_failed_12142025_v2 (
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


ALTER TABLE public.plan_failed_12142025_v2 OWNER TO psql;

--
-- TOC entry 1767 (class 1259 OID 67699455)
-- Name: plan_failures_20240828; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_failures_20240828 (
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


ALTER TABLE public.plan_failures_20240828 OWNER TO psql;

--
-- TOC entry 1768 (class 1259 OID 67699460)
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
-- TOC entry 1769 (class 1259 OID 67699469)
-- Name: plan_queue_failes_20250701; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_queue_failes_20250701 (
    product text,
    error text
);


ALTER TABLE public.plan_queue_failes_20250701 OWNER TO psql;

--
-- TOC entry 1770 (class 1259 OID 67699474)
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
-- TOC entry 1841 (class 1259 OID 123629210)
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
-- TOC entry 1771 (class 1259 OID 67699484)
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
-- TOC entry 1772 (class 1259 OID 67699488)
-- Name: plan_these_20240918; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.plan_these_20240918 (
    product text
);


ALTER TABLE public.plan_these_20240918 OWNER TO psql;

--
-- TOC entry 1773 (class 1259 OID 67699493)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 1987 (class 1259 OID 139694133)
-- Name: replannable_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.replannable_products (
    member_id text
);


ALTER TABLE public.replannable_products OWNER TO psql;

--
-- TOC entry 1774 (class 1259 OID 67699503)
-- Name: restoring_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.restoring_specstyles (
    product text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text
);


ALTER TABLE public.restoring_specstyles OWNER TO psql;

--
-- TOC entry 1775 (class 1259 OID 67699508)
-- Name: s5_analytics_inseason_sls_rnk_transposed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_analytics_inseason_sls_rnk_transposed (
    stylecolor text,
    act_slsrnk_store real,
    act_slsrnk_ecom real,
    act_aps_store numeric,
    act_aps_ecom numeric,
    act_aps_mult_adj_store numeric,
    act_aps_mult_adj_ecom numeric
);


ALTER TABLE public.s5_analytics_inseason_sls_rnk_transposed OWNER TO psql;

--
-- TOC entry 1776 (class 1259 OID 67699513)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 1777 (class 1259 OID 67699518)
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
-- TOC entry 1778 (class 1259 OID 67699527)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 1779 (class 1259 OID 67699532)
-- Name: sizetestfix; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sizetestfix (
    notrim text,
    corrected text
);


ALTER TABLE public.sizetestfix OWNER TO psql;

--
-- TOC entry 1780 (class 1259 OID 67699537)
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
-- TOC entry 1781 (class 1259 OID 67699538)
-- Name: sup_2984_ma_sizeattributes_bad_sizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sup_2984_ma_sizeattributes_bad_sizes (
    product text,
    parent_id text,
    size_id text,
    sizeattribute text,
    sku_create_date text,
    size_range text,
    isvalid integer,
    eventdate date,
    delete_or_not text
);


ALTER TABLE public.sup_2984_ma_sizeattributes_bad_sizes OWNER TO psql;

--
-- TOC entry 1840 (class 1259 OID 118293475)
-- Name: sync_dataqueue_deletes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_dataqueue_deletes (
    product text,
    "time" text,
    publish_type text
);


ALTER TABLE public.sync_dataqueue_deletes OWNER TO psql;

--
-- TOC entry 1782 (class 1259 OID 67699548)
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
-- TOC entry 1783 (class 1259 OID 67699555)
-- Name: sync_outbound_dataqueue_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_dataqueue_bk (
    product text,
    "time" text,
    publish_type text,
    eventdate date,
    updated_at timestamp without time zone
);


ALTER TABLE public.sync_outbound_dataqueue_bk OWNER TO psql;

--
-- TOC entry 1784 (class 1259 OID 67699560)
-- Name: sync_outbound_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_delta (
    sync_start timestamp without time zone,
    sync_end timestamp without time zone
);


ALTER TABLE public.sync_outbound_delta OWNER TO psql;

--
-- TOC entry 1785 (class 1259 OID 67699563)
-- Name: sync_reset_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_reset_specstyles (
    product text
);


ALTER TABLE public.sync_reset_specstyles OWNER TO psql;

--
-- TOC entry 1786 (class 1259 OID 67699568)
-- Name: sync_stylecolorchannel; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_stylecolorchannel (
    product text
);


ALTER TABLE public.sync_stylecolorchannel OWNER TO psql;

--
-- TOC entry 1787 (class 1259 OID 67699573)
-- Name: temp1_loft_c_week1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_loft_c_week1 (
    week text,
    week_minus_1 text
);


ALTER TABLE public.temp1_loft_c_week1 OWNER TO psql;

--
-- TOC entry 1788 (class 1259 OID 67699578)
-- Name: temp1_loft_c_week2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_loft_c_week2 (
    week text,
    week_minus_2 text
);


ALTER TABLE public.temp1_loft_c_week2 OWNER TO psql;

--
-- TOC entry 1789 (class 1259 OID 67699583)
-- Name: temp1_loft_c_week6; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_loft_c_week6 (
    week text,
    week_minus_6 text
);


ALTER TABLE public.temp1_loft_c_week6 OWNER TO psql;

--
-- TOC entry 1886 (class 1259 OID 126388267)
-- Name: temp_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_corpdisc (
    brand text NOT NULL,
    product text NOT NULL,
    prodlife text NOT NULL,
    "time" text NOT NULL,
    corpaddoff real DEFAULT 0.0,
    corpexcl real DEFAULT 0.0,
    corpaddoff_ecom real DEFAULT 0.0,
    corpexcl_ecom real DEFAULT 0.0,
    comments text
);


ALTER TABLE public.temp_corpdisc OWNER TO psql;

--
-- TOC entry 1887 (class 1259 OID 126388276)
-- Name: temp_loft_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_loft_corpdisc (
    department text,
    product text,
    location text,
    "time" text,
    prodlife text,
    corpaddoff real,
    corpexcl real,
    corpaddoff_ecom real,
    corpexcl_ecom real
);


ALTER TABLE public.temp_loft_corpdisc OWNER TO psql;

--
-- TOC entry 1790 (class 1259 OID 67699602)
-- Name: temp_loft_corpdisc_jrtest; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_loft_corpdisc_jrtest (
    department text,
    product text,
    location text,
    "time" text,
    prodlife text,
    corpaddoff real,
    corpexcl real
);


ALTER TABLE public.temp_loft_corpdisc_jrtest OWNER TO psql;

--
-- TOC entry 1985 (class 1259 OID 139693928)
-- Name: tmp_loft_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_loft_v_memberbasedvalidvalues (
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


ALTER TABLE public.tmp_loft_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 1791 (class 1259 OID 67699612)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 1792 (class 1259 OID 67699617)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 1793 (class 1259 OID 67699622)
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
-- TOC entry 1794 (class 1259 OID 67699632)
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
-- TOC entry 1795 (class 1259 OID 67699638)
-- Name: unnested_sca; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.unnested_sca AS
 SELECT loft_ma_stylecolorchannelattributes.product,
    loft_ma_stylecolorchannelattributes.ccrangecode,
    unnest(loft_ma_stylecolorchannelattributes.cc_validsizes_store) AS cc_validsizes_store,
    unnest(loft_ma_stylecolorchannelattributes.cc_validsizes_ecom) AS cc_validsizes_ecom
   FROM public.loft_ma_stylecolorchannelattributes;


ALTER VIEW public.unnested_sca OWNER TO psql;

--
-- TOC entry 1796 (class 1259 OID 67699642)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 1797 (class 1259 OID 67699647)
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
-- TOC entry 1798 (class 1259 OID 67699659)
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
-- TOC entry 1799 (class 1259 OID 67699667)
-- Name: v_hasbeenpublished; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.v_hasbeenpublished (
    count bigint
);


ALTER TABLE public.v_hasbeenpublished OWNER TO psql;

--
-- TOC entry 1800 (class 1259 OID 67699670)
-- Name: xt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.xt (
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


ALTER TABLE public.xt OWNER TO psql;

--
-- TOC entry 1801 (class 1259 OID 67699675)
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
-- TOC entry 1802 (class 1259 OID 67699680)
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
    weekcount double precision NOT NULL
);


ALTER TABLE target_setting.actuals_wide OWNER TO psql;

--
-- TOC entry 1803 (class 1259 OID 67699685)
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
-- TOC entry 1804 (class 1259 OID 67699690)
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
-- TOC entry 1835 (class 1259 OID 92376013)
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
-- TOC entry 1834 (class 1259 OID 92376008)
-- Name: product_denorm; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.product_denorm AS
 SELECT prodrootlevel.id AS prodrootlevel,
    division.id AS division,
    department.id AS department,
    class.id AS class,
    class_subclass.id AS class_subclass,
    subclass.id AS subclass
   FROM (((((( SELECT dimensions.id
           FROM target_setting.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'subclass'::text))) subclass
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = subclass.id) AND (hierarchies.hierarchy = 'prodstd'::text))) class_subclass ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM target_setting.hierarchies
          WHERE ((hierarchies.id = class_subclass.id) AND (hierarchies.hierarchy = 'prodstd'::text))) class ON (true))
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
-- TOC entry 1833 (class 1259 OID 92376003)
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
-- TOC entry 1836 (class 1259 OID 92376017)
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
    wide.weekcount
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
-- TOC entry 1805 (class 1259 OID 67699716)
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
-- TOC entry 1806 (class 1259 OID 67699722)
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
-- TOC entry 1807 (class 1259 OID 67699728)
-- Name: dimensions_done_prev; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.dimensions_done_prev (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE target_setting.dimensions_done_prev OWNER TO psql;

--
-- TOC entry 1808 (class 1259 OID 67699733)
-- Name: hierarchies_done_prev; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.hierarchies_done_prev (
    dimension text,
    hierarchy text,
    id text,
    ancestor text
);


ALTER TABLE target_setting.hierarchies_done_prev OWNER TO psql;

--
-- TOC entry 1809 (class 1259 OID 67699738)
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
-- TOC entry 1810 (class 1259 OID 67699743)
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
-- TOC entry 1831 (class 1259 OID 92375989)
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
-- TOC entry 1811 (class 1259 OID 67699748)
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
-- TOC entry 1812 (class 1259 OID 67699757)
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
    weekcount double precision NOT NULL
);


ALTER TABLE target_setting.plan_data_wide OWNER TO psql;

--
-- TOC entry 1832 (class 1259 OID 92375998)
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
    weekcount double precision NOT NULL
);


ALTER TABLE target_setting.plan_data_wide_archives OWNER TO psql;

--
-- TOC entry 1813 (class 1259 OID 67699762)
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
-- TOC entry 1814 (class 1259 OID 67699763)
-- Name: plan_init_status; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE target_setting.plan_init_status OWNER TO psql;

--
-- TOC entry 1815 (class 1259 OID 67699766)
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
-- TOC entry 1816 (class 1259 OID 67699775)
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
    weekcount double precision
);


ALTER TABLE target_setting.sys_gen_wide OWNER TO psql;

--
-- TOC entry 1837 (class 1259 OID 92376024)
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
    wide.weekcount
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
-- TOC entry 1817 (class 1259 OID 67699787)
-- Name: tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE target_setting.tyly OWNER TO psql;

--
-- TOC entry 1818 (class 1259 OID 67699792)
-- Name: tyly_done_prev; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly_done_prev (
    ty text,
    ly text
);


ALTER TABLE target_setting.tyly_done_prev OWNER TO psql;

--
-- TOC entry 1819 (class 1259 OID 67699797)
-- Name: user_kv_store; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE target_setting.user_kv_store OWNER TO psql;

--
-- TOC entry 1820 (class 1259 OID 67699802)
-- Name: view_target_plan_wide; Type: VIEW; Schema: target_setting; Owner: psql
--

CREATE VIEW target_setting.view_target_plan_wide AS
 WITH latest_plans AS (
         SELECT t.id,
            t.product,
            t."time"
           FROM ( SELECT plans.id,
                    plans.product,
                    plans."time",
                    plans.version,
                    plans.created_at,
                    row_number() OVER (PARTITION BY plans.version, plans."time" ORDER BY plans.created_at DESC) AS rn
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
    d.receipt_start_boh_u,
    d.sales_start_boh_u,
    d.ref_receipt_start_sls_u,
    d.weekcount,
    lp.product AS department,
    lp."time" AS superset
   FROM (target_setting.plan_data_wide d
     JOIN latest_plans lp ON ((d.id = lp.id)))
  WHERE ((d."time" !~~* '%Carryovers'::text) AND (d."time" !~~* '%Futures'::text) AND (d."time" !~~* '%Balance'::text));


ALTER VIEW target_setting.view_target_plan_wide OWNER TO psql;

--
-- TOC entry 7855 (class 2606 OID 68983529)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 7853 (class 2606 OID 68983514)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 7698 (class 2606 OID 67744142)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7700 (class 2606 OID 67744147)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 7702 (class 2606 OID 67744152)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 7704 (class 2606 OID 67744154)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 7706 (class 2606 OID 67744156)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 7711 (class 2606 OID 67744158)
-- Name: loft_a_assortment loft_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_a_assortment
    ADD CONSTRAINT loft_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 7713 (class 2606 OID 67744163)
-- Name: loft_an_price_storecount_info loft_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_an_price_storecount_info
    ADD CONSTRAINT loft_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 7715 (class 2606 OID 67744170)
-- Name: loft_authorization loft_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_authorization
    ADD CONSTRAINT loft_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 7719 (class 2606 OID 67744172)
-- Name: loft_d_cluster loft_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_d_cluster
    ADD CONSTRAINT loft_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 7721 (class 2606 OID 67744174)
-- Name: loft_d_location loft_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_d_location
    ADD CONSTRAINT loft_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 7723 (class 2606 OID 67744176)
-- Name: loft_d_prodlife loft_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_d_prodlife
    ADD CONSTRAINT loft_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 7725 (class 2606 OID 67744178)
-- Name: loft_d_product loft_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_d_product
    ADD CONSTRAINT loft_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 7728 (class 2606 OID 67744200)
-- Name: loft_d_time loft_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_d_time
    ADD CONSTRAINT loft_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 7733 (class 2606 OID 67744202)
-- Name: loft_h_clusterstd loft_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_clusterstd
    ADD CONSTRAINT loft_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7735 (class 2606 OID 67744204)
-- Name: loft_h_locdc loft_h_locdc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_locdc
    ADD CONSTRAINT loft_h_locdc_pkey PRIMARY KEY (id);


--
-- TOC entry 7737 (class 2606 OID 67744206)
-- Name: loft_h_locdcstd loft_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_locdcstd
    ADD CONSTRAINT loft_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7739 (class 2606 OID 67744208)
-- Name: loft_h_locstd loft_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_locstd
    ADD CONSTRAINT loft_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7741 (class 2606 OID 67744210)
-- Name: loft_h_prodlifestd loft_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_prodlifestd
    ADD CONSTRAINT loft_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 7743 (class 2606 OID 67744212)
-- Name: loft_h_prodstd loft_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_prodstd
    ADD CONSTRAINT loft_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 7731 (class 2606 OID 67744226)
-- Name: loft_h_timeflrset loft_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_timeflrset
    ADD CONSTRAINT loft_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 7755 (class 2606 OID 67744228)
-- Name: loft_h_timestd loft_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_h_timestd
    ADD CONSTRAINT loft_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 7717 (class 2606 OID 67744230)
-- Name: loft_corpdisc loft_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_corpdisc
    ADD CONSTRAINT loft_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time", prodlife);


--
-- TOC entry 7757 (class 2606 OID 67744232)
-- Name: loft_l_dclookup loft_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_l_dclookup
    ADD CONSTRAINT loft_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 7760 (class 2606 OID 67744234)
-- Name: loft_l_priceeventlookup loft_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_l_priceeventlookup
    ADD CONSTRAINT loft_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 7762 (class 2606 OID 67744236)
-- Name: loft_l_ssglookup loft_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_l_ssglookup
    ADD CONSTRAINT loft_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 7764 (class 2606 OID 67744238)
-- Name: loft_l_storelookup loft_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_l_storelookup
    ADD CONSTRAINT loft_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 7766 (class 2606 OID 67744240)
-- Name: loft_ma_dptflrsetattributes loft_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_dptflrsetattributes
    ADD CONSTRAINT loft_ma_dptflrsetattributes_pkey PRIMARY KEY (indx);


--
-- TOC entry 7768 (class 2606 OID 67744242)
-- Name: loft_ma_imgattributes loft_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_imgattributes
    ADD CONSTRAINT loft_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7770 (class 2606 OID 67744247)
-- Name: loft_ma_sizeattributes loft_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_sizeattributes
    ADD CONSTRAINT loft_ma_sizeattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7772 (class 2606 OID 67744261)
-- Name: loft_ma_storeattributes loft_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_storeattributes
    ADD CONSTRAINT loft_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 7774 (class 2606 OID 67744263)
-- Name: loft_ma_styleattributes loft_ma_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_styleattributes
    ADD CONSTRAINT loft_ma_styleattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7776 (class 2606 OID 67744265)
-- Name: loft_ma_stylecolorattributes loft_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_stylecolorattributes
    ADD CONSTRAINT loft_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7778 (class 2606 OID 67744267)
-- Name: loft_ma_stylecolorchannelattributes loft_ma_stylecolorchannelattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_stylecolorchannelattributes
    ADD CONSTRAINT loft_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7780 (class 2606 OID 67744269)
-- Name: loft_ma_stylecolorfloorsetattributes loft_ma_stylecolorfloorsetattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_stylecolorfloorsetattributes
    ADD CONSTRAINT loft_ma_stylecolorfloorsetattributes_2_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 7782 (class 2606 OID 67744272)
-- Name: loft_ma_subclassattributes loft_ma_subclassattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_subclassattributes
    ADD CONSTRAINT loft_ma_subclassattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 7784 (class 2606 OID 67744274)
-- Name: loft_ma_weekattributes loft_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_ma_weekattributes
    ADD CONSTRAINT loft_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 7786 (class 2606 OID 67744276)
-- Name: loft_p_casepack loft_p_casepack_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_casepack
    ADD CONSTRAINT loft_p_casepack_pkey PRIMARY KEY (product, location, "time", case_pack_id);


--
-- TOC entry 7788 (class 2606 OID 67744278)
-- Name: loft_p_channeloverride loft_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_channeloverride
    ADD CONSTRAINT loft_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 7790 (class 2606 OID 67744280)
-- Name: loft_p_dc_adj loft_p_dc_adj_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_dc_adj
    ADD CONSTRAINT loft_p_dc_adj_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7792 (class 2606 OID 81312579)
-- Name: loft_p_dc_adj_size loft_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_dc_adj_size
    ADD CONSTRAINT loft_p_dc_adj_size_pk PRIMARY KEY (product, location, "time");


--
-- TOC entry 7794 (class 2606 OID 67744287)
-- Name: loft_p_itemprice loft_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_itemprice
    ADD CONSTRAINT loft_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 7796 (class 2606 OID 67744289)
-- Name: loft_p_sizemin_by_size loft_p_sizemin_by_size_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_sizemin_by_size
    ADD CONSTRAINT loft_p_sizemin_by_size_pkey PRIMARY KEY (product);


--
-- TOC entry 7800 (class 2606 OID 67744291)
-- Name: loft_p_stylecolor_selling_channel_alloc_params loft_p_stylecolor_selling_channel_alloc_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_stylecolor_selling_channel_alloc_params
    ADD CONSTRAINT loft_p_stylecolor_selling_channel_alloc_params_pkey PRIMARY KEY (product, location);


--
-- TOC entry 7802 (class 2606 OID 67744293)
-- Name: loft_p_stylecolor_store_alloc_params loft_p_stylecolor_store_alloc_params_okey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_stylecolor_store_alloc_params
    ADD CONSTRAINT loft_p_stylecolor_store_alloc_params_okey PRIMARY KEY (product, location);


--
-- TOC entry 7804 (class 2606 OID 67744295)
-- Name: loft_p_subclass_channel_floorset_pssr_infomap loft_p_subclass_channel_floorset_pssr_infomap_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_subclass_channel_floorset_pssr_infomap
    ADD CONSTRAINT loft_p_subclass_channel_floorset_pssr_infomap_pkey PRIMARY KEY (product, "time", location, pssr_key);


--
-- TOC entry 7806 (class 2606 OID 67744297)
-- Name: loft_p_target_include_exclude loft_p_target_include_exclude_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_target_include_exclude
    ADD CONSTRAINT loft_p_target_include_exclude_pkey PRIMARY KEY (product, "time", ly_lly_key);


--
-- TOC entry 7809 (class 2606 OID 67744299)
-- Name: loft_roledimension loft_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_roledimension
    ADD CONSTRAINT loft_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 7860 (class 2606 OID 126388207)
-- Name: loft_l_size_range_validsize_defaults loft_size_range_validsize_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_l_size_range_validsize_defaults
    ADD CONSTRAINT loft_size_range_validsize_defaults_pkey PRIMARY KEY (class, size_range);


--
-- TOC entry 7811 (class 2606 OID 67744303)
-- Name: loft_specimages loft_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_specimages
    ADD CONSTRAINT loft_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 7814 (class 2606 OID 67744305)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 7816 (class 2606 OID 67744307)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 7818 (class 2606 OID 67744309)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 7820 (class 2606 OID 67744311)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 7798 (class 2606 OID 67744313)
-- Name: loft_p_strategy_params strategy_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.loft_p_strategy_params
    ADD CONSTRAINT strategy_params_pkey PRIMARY KEY (product, location, floorset_uda);


--
-- TOC entry 7708 (class 2606 OID 67744315)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 7823 (class 2606 OID 67744317)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 7825 (class 2606 OID 67744319)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 7827 (class 2606 OID 67744321)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 7829 (class 2606 OID 67744323)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 7838 (class 2606 OID 67744325)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 7832 (class 2606 OID 67744327)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 7834 (class 2606 OID 67744329)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 7836 (class 2606 OID 67744331)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 7840 (class 2606 OID 67744333)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 7843 (class 2606 OID 67744335)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 7845 (class 2606 OID 67744337)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 7847 (class 2606 OID 67744339)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 7849 (class 2606 OID 67744341)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 7851 (class 2606 OID 67744343)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 7758 (class 1259 OID 67744344)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.loft_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 7729 (class 1259 OID 67744348)
-- Name: loft_eohdata_stylecolor_product_channel_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX loft_eohdata_stylecolor_product_channel_idx ON public.loft_eohdata_stylecolor USING btree (product, channel);


--
-- TOC entry 7744 (class 1259 OID 67744349)
-- Name: loft_locstd_ances0_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_locstd_ances0_str_indx ON public.loft_h_prodstd USING btree (ancestor0);


--
-- TOC entry 7745 (class 1259 OID 67744356)
-- Name: loft_locstd_ances1_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_locstd_ances1_str_indx ON public.loft_h_prodstd USING btree (ancestor1);


--
-- TOC entry 7746 (class 1259 OID 67744371)
-- Name: loft_locstd_ances2_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_locstd_ances2_str_indx ON public.loft_h_prodstd USING btree (ancestor2);


--
-- TOC entry 7747 (class 1259 OID 67744372)
-- Name: loft_locstd_ances3_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_locstd_ances3_str_indx ON public.loft_h_prodstd USING btree (ancestor3);


--
-- TOC entry 7807 (class 1259 OID 67744382)
-- Name: loft_plan_these_cloned_style_stylecolors_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_plan_these_cloned_style_stylecolors_session_id_idx ON public.loft_plan_these_cloned_style_stylecolors USING btree (session_id);


--
-- TOC entry 7748 (class 1259 OID 67744383)
-- Name: loft_prodstd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances0_indx ON public.loft_h_prodstd USING btree (ancestor0);


--
-- TOC entry 7749 (class 1259 OID 67744404)
-- Name: loft_prodstd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances1_indx ON public.loft_h_prodstd USING btree (ancestor1);


--
-- TOC entry 7750 (class 1259 OID 67744415)
-- Name: loft_prodstd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances2_indx ON public.loft_h_prodstd USING btree (ancestor2);


--
-- TOC entry 7751 (class 1259 OID 67744416)
-- Name: loft_prodstd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances3_indx ON public.loft_h_prodstd USING btree (ancestor3);


--
-- TOC entry 7752 (class 1259 OID 67744419)
-- Name: loft_prodstd_ances4_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances4_indx ON public.loft_h_prodstd USING btree (ancestor4);


--
-- TOC entry 7753 (class 1259 OID 67744434)
-- Name: loft_prodstd_ances5_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_prodstd_ances5_indx ON public.loft_h_prodstd USING btree (ancestor5);


--
-- TOC entry 7726 (class 1259 OID 67744444)
-- Name: loft_product_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_product_levelid_indx ON public.loft_d_product USING btree (levelid);


--
-- TOC entry 7812 (class 1259 OID 67744447)
-- Name: loft_style_clone_stylecolor_size_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX loft_style_clone_stylecolor_size_session_id_idx ON public.loft_style_clone_stylecolor_size USING btree (session_id);


--
-- TOC entry 7709 (class 1259 OID 67744448)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 7821 (class 1259 OID 67744449)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 7856 (class 1259 OID 92376031)
-- Name: actuals_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_denorm_target_setting ON target_setting.actuals_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 7857 (class 1259 OID 92376033)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON target_setting.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 7830 (class 1259 OID 67744451)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON target_setting.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 7841 (class 1259 OID 67744452)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON target_setting.plan_data_wide USING hash (id);


--
-- TOC entry 7858 (class 1259 OID 92376032)
-- Name: sys_gen_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_target_setting ON target_setting.sys_gen_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 7904 (class 2620 OID 67744454)
-- Name: loft_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.store_eligibility_trigger();


--
-- TOC entry 7895 (class 2620 OID 67744455)
-- Name: loft_ma_stylecolorattributes cc_add_size_concept_to_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_add_size_concept_to_assortment AFTER UPDATE OF cc_size_concepts_in_assortment ON public.loft_ma_stylecolorattributes FOR EACH ROW WHEN (((cardinality(new.cc_size_concepts_in_assortment) > cardinality(old.cc_size_concepts_in_assortment)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.add_size_concepts_to_assortment();


--
-- TOC entry 7896 (class 2620 OID 67744456)
-- Name: loft_ma_stylecolorattributes cc_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_copy_master_attributes AFTER UPDATE OF cc_color_name, cc_ppns, cc_novelty_details, cc_print_description, cc_matchbacks, cc_free_one, cc_free_two, cc_free_three, cc_known, cc_collection, cc_preview, cc_marketing_flag, cc_promotion_flag, cc_table, cc_internet_tall_style, cc_price_band, cc_good_better_best, cc_lifecycle, cc_fabric_description, cc_primary_selling, cc_online_exclusive_flag, cc_delivery_month, cc_delivery_name, cc_storeset, cc_season, cc_print_pattern_type ON public.loft_ma_stylecolorattributes FOR EACH ROW WHEN ((new.cc_missy_related_stylecolor = new.product)) EXECUTE FUNCTION public.cc_copy_master_attributes();


--
-- TOC entry 7897 (class 2620 OID 67744457)
-- Name: loft_ma_stylecolorattributes cc_remove_size_concept_from_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_remove_size_concept_from_assortment BEFORE UPDATE OF cc_size_concepts_in_assortment ON public.loft_ma_stylecolorattributes FOR EACH ROW WHEN (((cardinality(new.cc_size_concepts_in_assortment) < cardinality(old.cc_size_concepts_in_assortment)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.remove_size_concepts_from_assortment();


--
-- TOC entry 7905 (class 2620 OID 67744458)
-- Name: loft_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.dbt_wk >= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.dbt_wk < old.plan_current))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 7936 (class 2620 OID 67744459)
-- Name: plan_queue delete_duplicate_invalids_on_plan_queue; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER delete_duplicate_invalids_on_plan_queue AFTER INSERT ON public.plan_queue FOR EACH ROW EXECUTE FUNCTION public.delete_duplicate_invalids();


--
-- TOC entry 7906 (class 2620 OID 67744460)
-- Name: loft_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.exitdate < old.plan_current)))) OR ((new.relaunchweek IS NOT NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (new.exitdate < old.plan_current))) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();


--
-- TOC entry 7907 (class 2620 OID 67744461)
-- Name: loft_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.erlstmkdnwk <= new.dbt_wk) OR ((old.cloned_at IS NULL) AND (old.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)) OR ((new.relaunchweek IS NOT NULL) AND ((new.erlstmkdnwk <= new.relaunchweek) OR ((old.cloned_at IS NULL) AND (new.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION public.md_trigger_on_update_validity_check();


--
-- TOC entry 7935 (class 2620 OID 67744462)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 7937 (class 2620 OID 67744463)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 7938 (class 2620 OID 67744464)
-- Name: plan_queue remove_product_from_queue; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER remove_product_from_queue BEFORE INSERT ON public.plan_queue FOR EACH ROW EXECUTE FUNCTION public.remove_product_from_queue();


--
-- TOC entry 7922 (class 2620 OID 67744465)
-- Name: loft_p_dc_adj set_dc_adjcost_ecom; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_dc_adjcost_ecom AFTER UPDATE OF dc_adjcost ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_dcadjcost_ecom();


--
-- TOC entry 7934 (class 2620 OID 67744466)
-- Name: loft_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.loft_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION public.trigger_set_indx_valid_values();


--
-- TOC entry 7923 (class 2620 OID 67744467)
-- Name: loft_p_dc_adj set_pack_ind_flag; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_pack_ind_flag BEFORE INSERT OR UPDATE ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_pack_ind_flag();

ALTER TABLE public.loft_p_dc_adj DISABLE TRIGGER set_pack_ind_flag;


--
-- TOC entry 7887 (class 2620 OID 67744468)
-- Name: loft_ma_sizeattributes set_size_id; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_size_id BEFORE INSERT ON public.loft_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_size_id();

ALTER TABLE public.loft_ma_sizeattributes DISABLE TRIGGER set_size_id;


--
-- TOC entry 7878 (class 2620 OID 67744469)
-- Name: loft_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.loft_a_assortment FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7919 (class 2620 OID 67744470)
-- Name: loft_p_casepack set_timestamp_cp_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish BEFORE UPDATE OF po_status ON public.loft_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 7920 (class 2620 OID 67744471)
-- Name: loft_p_casepack set_timestamp_cp_publish_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish_ins BEFORE INSERT ON public.loft_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 7886 (class 2620 OID 67744472)
-- Name: loft_ma_imgattributes set_timestamp_imgattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_imgattributes BEFORE UPDATE ON public.loft_ma_imgattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7921 (class 2620 OID 67744473)
-- Name: loft_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.loft_p_channeloverride FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7924 (class 2620 OID 67744474)
-- Name: loft_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7928 (class 2620 OID 67744475)
-- Name: loft_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.loft_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7925 (class 2620 OID 67744476)
-- Name: loft_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 7926 (class 2620 OID 67744477)
-- Name: loft_p_dc_adj set_timestamp_p_dc_publish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj_ins BEFORE INSERT ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 7888 (class 2620 OID 67744478)
-- Name: loft_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.loft_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7890 (class 2620 OID 67744479)
-- Name: loft_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.loft_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7908 (class 2620 OID 67744480)
-- Name: loft_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7898 (class 2620 OID 67744481)
-- Name: loft_ma_stylecolorattributes set_timestamp_stylecolorattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_stylecolorattr BEFORE UPDATE ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 7891 (class 2620 OID 67744482)
-- Name: loft_ma_styleattributes sty_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER sty_copy_master_attributes AFTER UPDATE OF sty_mfp_program_id, sty_pyramid_lens, sty_end_use, sty_silhouette, sty_program_id, sty_shape, sty_length, sty_placement, sty_neckline, sty_sleeve_length, sty_fit, sty_type, sty_hemline_detail, sty_texture, sty_gauge, sty_material, sty_fabric_profile, sty_accessory_measurements, sty_third_party, sty_adhoc, sty_finish, sty_coordination_article, sty_fabric_description_free_text, sty_fabric_description ON public.loft_ma_styleattributes FOR EACH ROW WHEN (((old.sty_missy_related_style <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.sty_copy_master_attributes();


--
-- TOC entry 7932 (class 2620 OID 67744483)
-- Name: loft_p_strategy_params trg_p_strategy_params_set_apply_targets; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_p_strategy_params_set_apply_targets BEFORE INSERT OR UPDATE ON public.loft_p_strategy_params FOR EACH ROW EXECUTE FUNCTION public.trg_set_apply_targets_to_plan();


--
-- TOC entry 7892 (class 2620 OID 67744484)
-- Name: loft_ma_styleattributes trg_skip_update_styleattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_skip_update_styleattributes BEFORE UPDATE ON public.loft_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.skip_update_styleattributes();


--
-- TOC entry 7933 (class 2620 OID 67744485)
-- Name: loft_p_subclass_channel_floorset_pssr_infomap trg_sync_is_approved; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_sync_is_approved AFTER UPDATE OF is_analytics_approved ON public.loft_p_subclass_channel_floorset_pssr_infomap FOR EACH ROW EXECUTE FUNCTION public.fn_sync_is_approved();


--
-- TOC entry 7879 (class 2620 OID 67744486)
-- Name: loft_a_assortment trg_to_update_source_of_ranging_edit; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_to_update_source_of_ranging_edit AFTER UPDATE OF plan_type ON public.loft_a_assortment FOR EACH ROW WHEN (((new.plan_type = 'ranging'::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.reset_plan_type_to_plan();


--
-- TOC entry 7880 (class 2620 OID 67744487)
-- Name: loft_a_assortment trg_upd_array_order; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_array_order AFTER UPDATE OF str_grade, str_climate ON public.loft_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.upd_array_order();


--
-- TOC entry 7881 (class 2620 OID 67744488)
-- Name: loft_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF str_climate, str_grade, ssg ON public.loft_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.propagate_assortment_to_floorsets();


--
-- TOC entry 7899 (class 2620 OID 67744489)
-- Name: loft_ma_stylecolorattributes trg_upd_season; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_season AFTER UPDATE OF cc_storeset ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_season();


--
-- TOC entry 7900 (class 2620 OID 67744490)
-- Name: loft_ma_stylecolorattributes trg_upd_specstylecolorid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_specstylecolorid AFTER UPDATE OF cc_specstyle_cccolor ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_specstylecolor_id();


--
-- TOC entry 7893 (class 2620 OID 67744491)
-- Name: loft_ma_styleattributes trg_upd_specstyleid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_specstyleid AFTER UPDATE OF sty_specstyleid ON public.loft_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_specstyle_id();


--
-- TOC entry 7884 (class 2620 OID 67744492)
-- Name: loft_h_prodstd trg_upd_subclass; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_subclass AFTER UPDATE OF ancestor0 ON public.loft_h_prodstd FOR EACH ROW WHEN (((new.ancestor3 IS NOT NULL) AND (new.ancestor4 IS NULL))) EXECUTE FUNCTION public.update_subclass();


--
-- TOC entry 7885 (class 2620 OID 67744493)
-- Name: loft_h_prodstd trg_upd_subclass_name; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_subclass_name AFTER UPDATE OF ancestor1 ON public.loft_h_prodstd FOR EACH ROW WHEN (((new.ancestor4 IS NOT NULL) AND (new.ancestor5 IS NULL))) EXECUTE FUNCTION public.update_subclass_name();


--
-- TOC entry 7889 (class 2620 OID 85203466)
-- Name: loft_ma_sizeattributes trg_update_cc_current_price; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_cc_current_price AFTER INSERT OR DELETE OR UPDATE ON public.loft_ma_sizeattributes FOR EACH STATEMENT EXECUTE FUNCTION public.update_cc_current_price();

ALTER TABLE public.loft_ma_sizeattributes DISABLE TRIGGER trg_update_cc_current_price;


--
-- TOC entry 7909 (class 2620 OID 67744494)
-- Name: loft_ma_stylecolorchannelattributes trg_update_cctktprc_override; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_cctktprc_override AFTER UPDATE OF ccticketpricechannel_override_txt ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.update_ccticketpricechannel_ovr();


--
-- TOC entry 7910 (class 2620 OID 67744495)
-- Name: loft_ma_stylecolorchannelattributes trig_cc_channel_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_cc_channel_copy_master_attributes AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate, initrcptwk, last_inv_wk, lstfpwk, last_rcpt_wk, act_initrcptwk, act_dbt_wk, plannedselldnwk ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(old.missy_related_stylecolor, ''::text) <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.cc_channel_copy_master_attributes();


--
-- TOC entry 7911 (class 2620 OID 67744496)
-- Name: loft_ma_stylecolorchannelattributes trig_cc_channel_copy_master_attributes_without_lifecycle; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_cc_channel_copy_master_attributes_without_lifecycle AFTER UPDATE OF ccmdstrategy, cc_ordermultiple, cc_ordermin, cc_discount_pct, cc_discount_pct_ecom, auto_rollforward, ccticketpricechannel, slsrnk_store, slsrnk_ecom, cc_plan_cost ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(old.missy_related_stylecolor, ''::text) <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle();


--
-- TOC entry 7901 (class 2620 OID 67744497)
-- Name: loft_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER UPDATE OF cc_color_name ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_color_change();


--
-- TOC entry 7877 (class 2620 OID 67744498)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_ranging();


--
-- TOC entry 7930 (class 2620 OID 67744499)
-- Name: loft_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.loft_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.update_eff_aur();


--
-- TOC entry 7912 (class 2620 OID 67744500)
-- Name: loft_ma_stylecolorchannelattributes trigger_for_time_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx AFTER INSERT OR UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 7913 (class 2620 OID 67744501)
-- Name: loft_ma_stylecolorchannelattributes trigger_for_time_indx_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_update AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 7931 (class 2620 OID 67744502)
-- Name: loft_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.loft_p_itemprice FOR EACH ROW EXECUTE FUNCTION public.itemprice_fetchdepartment();


--
-- TOC entry 7914 (class 2620 OID 67744503)
-- Name: loft_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.lifecycle_plan_update();


--
-- TOC entry 7915 (class 2620 OID 67744504)
-- Name: loft_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_validsizes_members();


--
-- TOC entry 7883 (class 2620 OID 67744505)
-- Name: loft_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.loft_d_product FOR EACH ROW EXECUTE FUNCTION public.update_name_description();


--
-- TOC entry 7902 (class 2620 OID 67744506)
-- Name: loft_ma_stylecolorattributes trigger_update_cc_floorset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_cc_floorset AFTER INSERT OR UPDATE OF cc_delivery_name ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_floorset();


--
-- TOC entry 7903 (class 2620 OID 67744507)
-- Name: loft_ma_stylecolorattributes trigger_update_cc_use_sys_floorset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_cc_use_sys_floorset BEFORE UPDATE OF cc_floorset ON public.loft_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_use_sys_floorset();


--
-- TOC entry 7918 (class 2620 OID 67744508)
-- Name: loft_ma_stylecolorfloorsetattributes trigger_update_publish_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_publish_attributes BEFORE UPDATE OF is_attr_published, is_fc_published, is_ir_published ON public.loft_ma_stylecolorfloorsetattributes FOR EACH ROW EXECUTE FUNCTION public.update_publish_attributes();


--
-- TOC entry 7882 (class 2620 OID 67744509)
-- Name: loft_a_assortment triggger_insert_scflrsetattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER triggger_insert_scflrsetattr AFTER INSERT ON public.loft_a_assortment FOR EACH ROW EXECUTE FUNCTION public.insert_stylecolorfloorsetattributes();


--
-- TOC entry 7894 (class 2620 OID 67744510)
-- Name: loft_ma_styleattributes update_ccrangecode; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccrangecode AFTER UPDATE OF sty_size_range ON public.loft_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_stylecolorchannelattributes_ccrangecode();


--
-- TOC entry 7929 (class 2620 OID 67744511)
-- Name: loft_p_dc_adj_size update_ecom_onorder_ovr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ecom_onorder_ovr AFTER INSERT OR UPDATE OF dc_finrev_ecom ON public.loft_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.update_ecom_onorder_ovr();


--
-- TOC entry 7927 (class 2620 OID 67744512)
-- Name: loft_p_dc_adj update_p_dc_adj_size_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_p_dc_adj_size_publish AFTER UPDATE OF dc_publish ON public.loft_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.update_p_dc_adj_size_publish();


--
-- TOC entry 7916 (class 2620 OID 67744513)
-- Name: loft_ma_stylecolorchannelattributes update_price_band; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_price_band AFTER INSERT OR UPDATE OF ccticketpricechannel, ccticketpricechannel_override ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_price_bands();


--
-- TOC entry 7917 (class 2620 OID 67744514)
-- Name: loft_ma_stylecolorchannelattributes update_size_concepts; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_size_concepts AFTER UPDATE OF record_state ON public.loft_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.update_cc_size_concept_in_assortment();


--
-- TOC entry 7862 (class 2606 OID 67744515)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 7863 (class 2606 OID 67744520)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 7865 (class 2606 OID 67744525)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 7876 (class 2606 OID 68983530)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.agent_conversations(conversation_id);


--
-- TOC entry 7861 (class 2606 OID 67744530)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES public.allocation_plan_queue(jobid);


--
-- TOC entry 7868 (class 2606 OID 67744535)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7869 (class 2606 OID 67744540)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 7864 (class 2606 OID 67744545)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 7867 (class 2606 OID 67744550)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 7866 (class 2606 OID 67744555)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.user_metadata(uid);


--
-- TOC entry 7870 (class 2606 OID 67744560)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7871 (class 2606 OID 67744565)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7874 (class 2606 OID 67744570)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 7872 (class 2606 OID 67744575)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES target_setting.plans(id) ON DELETE CASCADE;


--
-- TOC entry 7873 (class 2606 OID 67744580)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES target_setting.plans(id);


--
-- TOC entry 7875 (class 2606 OID 67744585)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 8096 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:08:07 IST

--
-- PostgreSQL database dump complete
--

\unrestrict GjUMwbqW8sum6M6IloyEs1cVP35h8HfFP7KwKnLhm78IeouuCc77ak3cNoFbkJ4

