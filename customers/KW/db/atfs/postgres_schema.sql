-- ENV: QA | DB: atfs | dumped: 2026-10-01 15:04 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict YSkr1RtUy66zekoplwj7YeiK8ZIO8m4ZBgKCH7HZUZwHre0w3V9KMNDHDN8gse3

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:04:41 IST

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
-- TOC entry 217 (class 2615 OID 81940038)
-- Name: target_setting; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA target_setting;


ALTER SCHEMA target_setting OWNER TO psql;

--
-- TOC entry 2 (class 3079 OID 29332)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 6496 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1548 (class 1247 OID 82000195)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 1601 (class 1247 OID 81940040)
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
-- TOC entry 1604 (class 1247 OID 81940052)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 1607 (class 1247 OID 81940058)
-- Name: approval; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE target_setting.approval OWNER TO psql;

--
-- TOC entry 1610 (class 1247 OID 81940064)
-- Name: permission; Type: TYPE; Schema: target_setting; Owner: psql
--

CREATE TYPE target_setting.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE target_setting.permission OWNER TO psql;

--
-- TOC entry 1613 (class 1247 OID 81940072)
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
-- TOC entry 877 (class 1255 OID 81940087)
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
    update atfs_ma_stylecolorchannelattributes
    set record_state = 0
    where product in (    
        select product 
        from atfs_stylecolor_hier_attr 
        where cc_missy_related_stylecolor = new.product
        and sty_size_type in (
                select unnest(cc_size_concepts_in_assortment) as size_concept
        from atfs_ma_stylecolorattributes 
        where product = new.product)
    );

    -- Generate UUID and use it to create a temporary table name
    EXECUTE '(select uuid_generate_v4()::text)' INTO v_uuid_temp;
    EXECUTE '(select replace(''' || v_uuid_temp || ''', ''-'', ''_'')::text)' INTO v_uuid;

    table_tmp_size_concepts := 'tmp_size_concepts_' || v_uuid;

    -- Create the temporary table dynamically
    s1 := 'CREATE TEMPORARY TABLE ' || table_tmp_size_concepts || ' AS
           SELECT a.product as product, c.product as style, a.cc_missy_related_stylecolor
           FROM atfs_stylecolor_hier_attr a
           JOIN atfs_h_prodstd b ON a.product = b.id
           JOIN atfs_ma_styleattributes c ON b.ancestor0 = c.product
           WHERE cc_missy_related_stylecolor = ''' || NEW.product || ''' 
           AND a.sty_size_type IN (
                SELECT unnest(cc_size_concepts_in_assortment) AS size_concept
           FROM atfs_ma_stylecolorattributes 
           WHERE product = ''' || NEW.product || ''')
           ';
    
    -- Execute the dynamic query to create the temporary table
    EXECUTE s1;

    -- Debug: Show what the SQL query looks like
    RAISE NOTICE 'SQL to create table: %', s1;
    RAISE NOTICE 'new.product: %', NEW.product;

    -- Insert into atfs_a_assortment using the temporary table
    EXECUTE 'INSERT INTO atfs_a_assortment
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
    JOIN atfs_a_assortment b ON tmp.cc_missy_related_stylecolor=b.product 
    WHERE NOT EXISTS (
        SELECT 1
        FROM atfs_a_assortment a
        WHERE a.product = tmp.product
    )';

    -- Debug: Show the SQL for insert
    RAISE NOTICE 'SQL for Insert: %', 'INSERT INTO atfs_a_assortment ...';

    -- Add the newly added item to the plan_queue immediately
    INSERT INTO plan_queue (product, location, initiator, initiated_at, updated_at)
    SELECT DISTINCT
           a.product,
           a.location,
           NEW.updated_by AS initiator,
           NOW() AS initiated_at,
           NOW() AS updated_at
    FROM atfs_ma_stylecolorchannelattributes a
    WHERE a.record_state = 0
      AND a.missy_related_stylecolor = NEW.product
      AND a.product != NEW.product;


    select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from atfs_ma_stylecolorattributes a, atfs_ma_stylecolorchannelattributes b, atfs_h_prodstd c, atfs_ma_styleattributes d, atfs_d_product e 
                            where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
                            and cc_missy_related_stylecolor = NEW.product
                           ) x where product <> NEW.product and record_state = 0
                      ) into v_size_concepts_in_assortment;
    
    RAISE NOTICE 'v_size_concepts_in_assortment: %', v_size_concepts_in_assortment;

    update atfs_ma_stylecolorattributes
    set cc_size_concepts_in_assortment = array_cc_size_concepts_in_assortment
    from (select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from atfs_ma_stylecolorattributes a, atfs_ma_stylecolorchannelattributes b, atfs_h_prodstd c, atfs_ma_styleattributes d, atfs_d_product e 
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
-- TOC entry 942 (class 1255 OID 81940088)
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

--sjrtest_1 text;
--sjrtest_2 text;
--sjrtest_step1 text;
--sjrtest_step2 text;
--sjrtest_step3 text;
--sjrtest_step4 text;

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
    create temporary table '||table_cart_master_temp||' as
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
            FROM atfs_ma_styleattributes
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

--sjrtest_step1:= 'insert into deleteme_table_cart_master_temp_jr select *, ''step1'' from ' || table_cart_master_temp;
s2_dprod := '
    update '||table_cart_master_temp||' a
    set style_name        = d.name
      , style_description = d.description
    from atfs_d_product d
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
-- Modified on July 22nd 2025 by Robert Kebert to pull sty_size_type from cart params insteaad of atfs_l_size_concept_lookups
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
        FROM atfs_l_size_concept_lookups
        INNER JOIN (
            SELECT distinct sty_size_type, style_id
            FROM cart_params
            INNER JOIN cart_master ON cart_master.jsessionid = cart_params.jsessionid
            WHERE cart_master.style_type <> ''existing''
              AND cart_params.jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')

            UNION

            SELECT distinct sty_size_type, style_id
            FROM atfs_ma_styleattributes
            INNER JOIN (
                SELECT style_type, style_id
                FROM cart_master
                WHERE jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')
                  AND style_type = ''existing''
            ) cart_master_type
            on style_id = product
        ) styles_with_id
        on atfs_l_size_concept_lookups.master_style_size_type = sty_size_type
        WHERE department IN (
            SELECT scope_product FROM ' || table_input_t1 || '
        )
    ) x
    on x.style_id = cart_master.style_id
    LEFT OUTER JOIN atfs_d_product as d_prod on cart_master.style_id=d_prod.id 
    WHERE jsessionid IN (SELECT jsid FROM ' || table_input_t1 || ')
      AND isProcessed = 0
    '
    ;

--sjrtest_step2:= 'insert into deleteme_table_cart_master_temp_jr select *, ''step2'' from ' || table_cart_master_temp;


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
-- Uses atfs_ma_styleattributes and atfs_d_product as the source
-- ============================================================================
-- ============================================================================
-- NOT Modified on July 22nd 2025 by Robert Kebert despite making chnages to sty_size_type, could lead to defect. 
-- ============================================================================
s4_0_1:= '
    update '||table_cart_style||' a
    set final_style_id = product
       ,displayed_style_name = c.name
       ,displayed_style_description = c.description
    from atfs_ma_styleattributes b,
         atfs_d_product c
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
    from atfs_h_prodstd b
    where
    b.id = a.incoming_style_id
    and a.sc_type = ''master''
    ';



s4_2_0 := '
    Update '||table_cart_master_temp||' a
    set class_id = c.class,
        subclass_id = c.subclass
    from cart_params p, '||table_input_t1||' b, (select id as style, ancestor0 as subclass, ancestor1 as class from atfs_h_prodstd where id in (select id from atfs_d_product where levelid = ''style'')) c
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
    ,(select distinct master_style_size_type, related_size_type, master_style_subclass, related_size_subclass, master_style_class, related_size_class from atfs_l_size_concept_lookups where related_size_subclass is not null ) c
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
    from cart_params p, '||table_input_t1||' b, (select id as style, ancestor0 as subclass, ancestor1 as class from atfs_h_prodstd where id in (select id from atfs_d_product where levelid = ''style'')) c
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
    from (select distinct master_style_class, master_style_subclass, master_style_size_type, related_size_type, related_size_class, related_size_subclass from atfs_l_size_concept_lookups x, '||table_cart_master_temp||' y where x.master_style_class = y.class_id and x.master_style_subclass = y.subclass_id and y.sc_type = ''master'' and master_style_size_type = sty_size_type) c
    where a.style_type = ''existing''
    and a.class_id is null
    and a.sc_type != ''master''
    and sty_size_type = related_size_type
    ';

--sjrtest_1:= 'insert into deleteme_table_cart_style_jr select * from ' || table_cart_style;
--sjrtest_step3:= 'insert into deleteme_table_cart_master_temp_jr select *, ''step3'' from ' || table_cart_master_temp;

s4_2_2 := '
    delete from '||table_cart_master_temp||' where class_id is null
    ';



s4_2_3 := '
    delete from '||table_cart_style||' where final_style_id not in (select final_style_id from '||table_cart_master_temp||')
    ';



s4_3 := '
    Update '||table_cart_master_temp||' a
    set class_name = b.name
    from atfs_d_product b
    where
    b.id = a.class_id
    ';



s4_4 := '
    Update '||table_cart_master_temp||' a
    set subclass_name = b.name
    from atfs_d_product b
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
    from atfs_ma_stylecolorattributes sc, atfs_h_prodstd h, atfs_ma_styleattributes s
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

--sjrtest_2:= 'insert into deleteme_table_cart_stylecolor_jr select * from ' || table_cart_stylecolor;
--sjrtest_step4:= 'insert into deleteme_table_cart_master_temp_jr select *, ''step4'' from ' || table_cart_master_temp;


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
                , atfs_ma_styleattributes s
                , atfs_l_dependencylookup b
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
                 , atfs_ma_sizeattributes b
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
                , atfs_ma_styleattributes s
                , atfs_l_dependencylookup b
                , atfs_l_size_concept_lookups l
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
-- STEP 20: Add existing stylecolorsizes from atfs_ma_sizeattributes
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
            , atfs_ma_sizeattributes b
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
        , atfs_ma_styleattributes s
        , atfs_ma_sizeattributes b
        , atfs_l_size_concept_lookups l
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
-- STEP 23: Clean up old similar style entries from atfs_d_product
-- ============================================================================
s8 := 'delete from atfs_d_product where id in (select final_style_id from '||table_cart_style||' WHERE style_type=''similar'' and jsessionid in (select jsid from '||table_input_t1||'))';



-- ============================================================================
-- STEP 24: Insert new similar styles into atfs_d_product
-- ============================================================================
s9 := '
    INSERT INTO atfs_d_product
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
-- STEP 25: Insert existing styles not already in atfs_d_product
-- ============================================================================
s9_1 := '
    INSERT INTO atfs_d_product
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
      and final_style_id not in (select id from atfs_d_product where levelid = ''style'')
    ';





-- ============================================================================
-- STEP 26: Clean up old similar stylecolor entries from atfs_d_product
-- ============================================================================
s10 := '
delete from atfs_d_product where id in (select distinct final_stylecolor_id from '||table_cart_stylecolor||' WHERE stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



-- ============================================================================
-- STEP 27: Insert new similar stylecolors into atfs_d_product
-- ============================================================================
s11 := '
    INSERT INTO atfs_d_product
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
-- STEP 28: Insert existing stylecolors if missing from atfs_d_product
-- ============================================================================
s11_1 := '
    INSERT INTO atfs_d_product
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
      and final_stylecolor_id not in (select id from atfs_d_product where levelid = ''stylecolor'')
    '
    ;





-- ============================================================================
-- STEP 29: Insert new similar stylecolorsizes into atfs_d_product
-- ============================================================================
s13 := '
    INSERT INTO atfs_d_product
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
-- STEP 30: Insert existing stylecolorsizes if not already in atfs_d_product
-- ============================================================================
s13_1 := '
    INSERT INTO atfs_d_product
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
      and final_stylecolorsize_id not in (select id from atfs_d_product where levelid = ''stylecolorsize'')
    '
    ;



-- CREATING HIERARCHY


-- ============================================================================
-- STEP 31: Delete existing similar style entries from product hierarchy
-- ============================================================================
s14 := '
delete from atfs_h_prodstd where id in (select distinct final_style_id from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';



-- ============================================================================
-- STEP 32: Insert master size type similar styles into atfs_h_prodstd
-- Copies full hierarchy from source style
-- ============================================================================
s15 := '
INSERT INTO atfs_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 from atfs_h_prodstd) b
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
INSERT INTO atfs_h_prodstd
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
(select distinct ancestor1, ancestor2, ancestor3, ancestor4, ancestor5 from atfs_h_prodstd) b
WHERE style_type=''similar''
and a.class_id = b.ancestor1
and a.sc_type != ''master''
'
;


-- ============================================================================
-- STEP 34: Insert 'existing' alternate styles if missing from hierarchy
-- ============================================================================
s15_2 := '
INSERT INTO atfs_h_prodstd
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
(select distinct ancestor1, ancestor2, ancestor3, ancestor4, ancestor5 from atfs_h_prodstd) b
WHERE style_type=''existing''
and a.class_id = b.ancestor1
and a.sc_type != ''master''
and final_style_id not in (select id from atfs_h_prodstd)
'
;

s16 := '
delete from atfs_h_prodstd where id in (select distinct final_stylecolor_id from '||table_cart_master_temp||'  where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s17 := '
INSERT INTO atfs_h_prodstd
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
(select id, ancestor0, ancestor1, ancestor2, ancestor3, ancestor4 , ancestor5 from atfs_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.incoming_stylecolor_id = b.id
and a.sc_type = ''master''
'
;

s17_1 := '
INSERT INTO atfs_h_prodstd
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
(select distinct ancestor2, ancestor3, ancestor4 , ancestor5 from atfs_h_prodstd) b
WHERE stylecolor_type=''similar''
and a.class_id = b.ancestor2
and a.sc_type != ''master''
'
;

s17_2 := '
INSERT INTO atfs_h_prodstd
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
(select distinct ancestor2, ancestor3, ancestor4 , ancestor5 from atfs_h_prodstd) b
WHERE stylecolor_type=''existing''
and a.class_id = b.ancestor2
and a.sc_type != ''master''
and final_stylecolor_id not in (select id from atfs_h_prodstd)
'
;



s18 := '
delete from atfs_h_prodstd where id in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

s19 := '
INSERT INTO atfs_h_prodstd
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
atfs_h_prodstd b
WHERE stylecolor_type=''similar''
and a.final_stylecolor_id = b.id
'
;

s19_1 := '
INSERT INTO atfs_h_prodstd
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
atfs_h_prodstd b
WHERE stylecolor_type=''existing''
and a.final_stylecolor_id = b.id
and a.final_stylecolorsize_id not in (select id from atfs_h_prodstd)
'
;


-- ============================================================================
-- STEP 35: Clean up old style attribute records for similar styles
-- ============================================================================
s20 := '
delete from atfs_ma_styleattributes where product in (select distinct final_style_id from '||table_cart_master_temp||' WHERE style_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';

-- updating cccolor and cccolorfamily


-- ============================================================================
-- STEP 36: Update color family from dependency lookup
-- ============================================================================
s21 := '
update '||table_cart_master_temp||' a set cccolorfamily = b.target_value from atfs_l_dependencylookup b where b.lookup_id = ''colorname'' and b.target_id=''colorfamily'' and lookup_value=a.cccolor
';


-- ============================================================================
-- STEP 37: Update color type from dependency lookup
-- ============================================================================
s21_1 := '
update '||table_cart_master_temp||' a set cc_color_type = b.target_value from atfs_l_dependencylookup b where b.lookup_id = ''colorname'' and b.target_id=''colortype'' and lookup_value=a.cccolor
';


-- ============================================================================
-- STEP 38: Delete old 'patternedtostyle' dependency mappings
-- ============================================================================
s22 := '
delete from atfs_l_dependencylookup where target_id=''patternedtostyle'' and target_value in (select distinct final_style_id from  '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';


-- ============================================================================
-- STEP 39: Delete old 'patternedtostylecolor' dependency mappings
-- ============================================================================
s23 := '
delete from atfs_l_dependencylookup where target_id=''patternedtostylecolor'' and target_value in (select distinct final_stylecolor_id from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';







-- ============================================================================
-- STEP 40: Insert new 'patternedtostyle' mappings
-- ============================================================================
s24 := '
insert into atfs_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''style'' as lookup_id, incoming_style_id as lookup_value, ''patternedtostyle'' target_id, final_style_id as target_value
from '||table_cart_master_temp||' where style_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- ============================================================================
-- STEP 41: Insert new 'patternedtostylecolor' mappings
-- ============================================================================
s25 := '
insert into atfs_l_dependencylookup (lookup_id,lookup_value,target_id,target_value)
select distinct ''stylecolor'' as lookup_id, incoming_stylecolor_id as lookup_value, ''patternedtostylecolor'' target_id, final_stylecolor_id as target_value
from '||table_cart_master_temp||' where stylecolor_type=''similar'' and jsessionid in (select jsid from  '||table_input_t1||')
';



-- STYLE ATTRIBUTES


-- ============================================================================
-- STEP 42: Insert style attributes for master size types
-- ============================================================================
S26 := '
INSERT INTO atfs_ma_styleattributes
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
from (select distinct final_style_id, style_type, incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type, sty_size_type from '||table_cart_master_temp||') a, atfs_ma_styleattributes b
where a.incoming_style_id=b.product
and a.style_type=''similar''
and a.sc_type=''master''
';




-- ============================================================================
-- STEP 43: Insert style attributes for alternate similar size types
-- ============================================================================
S26_1 := '
INSERT INTO atfs_ma_styleattributes
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
from (select distinct final_style_id, style_type, incoming_style_id, master_incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type from '||table_cart_master_temp||') a, atfs_ma_styleattributes b, atfs_l_size_concept_lookups l
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
INSERT INTO atfs_ma_styleattributes
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
from (select distinct final_style_id, style_type, incoming_style_id, master_incoming_style_id, class_id, subclass_id, class_name, subclass_name, sc_type from '||table_cart_master_temp||') a, atfs_ma_styleattributes b, atfs_l_size_concept_lookups l
where incoming_style_id=b.product
and a.style_type=''existing''
and final_style_id not in (select product from atfs_ma_styleattributes)
and a.sc_type!=''master''
and UPPER(b.sty_size_range) = UPPER(l.master_style_size_range_id)
and l.related_size_subclass = a.subclass_id
and a.sc_type = l.related_size_type
';


-- ============================================================================
-- STEP 45: Aggregate alternate size types into size concept arrays
-- ============================================================================
s26_3 := '
update atfs_ma_styleattributes a
set sty_size_concepts = size_concepts
from (select sty_missy_related_style, array_agg(product) as size_concepts from atfs_ma_styleattributes where sty_missy_related_style != product and sty_missy_related_style in (select final_style_id from '||table_cart_master_temp||' where sc_type = ''master'') group by sty_missy_related_style) b
where a.product = b.sty_missy_related_style
';


-- ============================================================================
-- STEP 46: Update merch group from dependency lookup
-- ============================================================================
s26_4 := '
update atfs_ma_styleattributes
set sty_merch_group = a.sty_merch_group
from (select target_value as sty_merch_group, lookup_value as class from atfs_l_dependencylookup where target_id = ''MerchDeptGroup'' and lookup_id = ''class'') a
    ,(select distinct final_style_id, class_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.class_id = a.class
';


-- ============================================================================
-- STEP 47: Update retail ticket type based on subclass mapping
-- ============================================================================
s26_5 := '
update atfs_ma_styleattributes
set sty_retail_ticket_type = a.sty_retail_ticket_type
from (select target_value as sty_retail_ticket_type, lookup_value as subclass from atfs_l_dependencylookup where target_id = ''retail_ticket_type'' and lookup_id = ''subclass'' and (lookup_value,index) in (select lookup_value as subclass, max(index) as index from atfs_l_dependencylookup where target_id = ''retail_ticket_type'' group by lookup_value)) a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.subclass_id = a.subclass
';


-- ============================================================================
-- STEP 48: Update style name and description composite field
-- ============================================================================
s26_6 := '
update atfs_ma_styleattributes
set sty_stylenumber_name = a.name || '', '' || a.description
from atfs_d_product a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = a.id and a.id = b.final_style_id
';

--SUP-1882 Main Label Default Attribute
s26_7 := '
update atfs_ma_styleattributes
set sty_main_label = a.sty_main_label
from (select target_value as sty_main_label, lookup_value as subclass from atfs_l_dependencylookup where target_id = ''main_label_default'' and lookup_id = ''subclass'' and (lookup_value,index) in (select lookup_value as subclass, max(index) as index from atfs_l_dependencylookup where target_id = ''main_label_default'' group by lookup_value)) a
    ,(select distinct final_style_id, subclass_id from '||table_cart_master_temp||') b
where product = b.final_style_id
  and b.subclass_id = a.subclass
';

-- STYLECOLOR ATTRIBUTES


-- ============================================================================
-- STEP 49: Clean up old stylecolor attributes
-- ============================================================================
s27 := '
delete from atfs_ma_stylecolorattributes where product in (select distinct final_stylecolor_id from '||table_cart_master_temp||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))';




-- ============================================================================
-- STEP 50: Insert stylecolor attributes for master similar styles
-- ============================================================================
s28 := '
INSERT INTO atfs_ma_stylecolorattributes
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
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type  from '||table_cart_master_temp||') a, atfs_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''similar''
and a.sc_type=''master''
';





-- ============================================================================
-- STEP 51: Insert extended stylecolor attributes for alternate similar types
-- ============================================================================
s28_1 := '
INSERT INTO atfs_ma_stylecolorattributes
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
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, master_incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type, subclass_name, class_name  from '||table_cart_master_temp||') a, atfs_ma_stylecolorattributes b
where REPLACE(final_stylecolor_id,sc_type,'''') = b.product
and a.stylecolor_type=''similar''
and a.sc_type!=''master''
';





-- ============================================================================
-- STEP 52: Insert attributes for alternate existing stylecolors
-- ============================================================================
s28_2 := '
INSERT INTO atfs_ma_stylecolorattributes
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
from (select distinct final_stylecolor_id, stylecolor_type, incoming_stylecolor_id, master_incoming_stylecolor_id, cccolor, cc_color_type, cccolorfamily, case when strpos(cccolor, '' '') > 0 then ( SUBSTR(cccolor, 1, strpos(cccolor, '' '') - 1) ) else cccolor end as cccolorid, sc_type, class_name, subclass_name  from '||table_cart_master_temp||') a, atfs_ma_stylecolorattributes b
where a.incoming_stylecolor_id=b.product
and a.stylecolor_type=''existing''
and final_stylecolor_id not in (select product from atfs_ma_stylecolorattributes)
and a.sc_type!=''master''
';



-- ============================================================================
-- STEP 53: Update composite name/description for stylecolors
-- ============================================================================
s28_3 := '
update atfs_ma_stylecolorattributes
set cc_stylecolornumber_name = a.name || '', '' || a.description
from atfs_d_product a
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
from atfs_specimages si
 inner join
atfs_ma_styleattributes sa
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
  (select distinct product, img from atfs_ma_imgattributes where product in (select distinct incoming_stylecolor_id from '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||'))) b
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
delete from atfs_ma_imgattributes where product in (
    select distinct final_stylecolor_id from  '||table_cart_master_temp||' where jsessionid in (select jsid from  '||table_input_t1||')
)
'
;


-- ============================================================================
-- STEP 58: Insert new image attributes (prioritize: cart > orig > spec)
-- ============================================================================
s32 := '
insert into atfs_ma_imgattributes (product, img)
select product, coalesce(cart_image,orig_image,spec_image) from '||table_ma_imgattr||'
';




-- IMAGE ATTRIBUTES END

-- SIZE ATTRIBUTES


-- ============================================================================
-- STEP 59: Clean up old size attributes
-- ============================================================================
s33 := '
delete from atfs_ma_sizeattributes where product in (select distinct final_stylecolorsize_id from '||table_cart_stylecolorsize||' WHERE stylecolor_type = ''similar'' and jsessionid in (select jsid from  '||table_input_t1||'))
';




-- ============================================================================
-- STEP 60: Insert size attributes for similar styles
-- ============================================================================
s34 := '
insert into atfs_ma_sizeattributes
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
insert into atfs_ma_sizeattributes
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
  and final_stylecolorsize_id not in (select product from atfs_ma_sizeattributes)
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
from (select distinct * from cart_params) a, atfs_ma_dptflrsetattributes c, '||table_input_t1||' b
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
'||table_default_cart_params||' a, atfs_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, class_id from '||table_cart_master_temp||' where style_type = ''similar'' and sc_type = ''master'') c, (select class,size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from atfs_l_size_range_validsize_defaults) f,
 (select product,sty_size_range from atfs_ma_styleattributes where product in (select final_style_id from '||table_cart_master_temp||')) g
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
'||table_default_cart_params||' a, atfs_ma_stylecolorchannelattributes b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||' where style_type = ''similar'' and sc_type != ''master'') c,
atfs_ata_size_concept_defaults d,
atfs_ma_styleattributes e,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from atfs_l_size_range_validsize_defaults) f
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
atfs_ma_styleattributes c,
atfs_ma_stylecolorchannelattributes d,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from atfs_l_size_range_validsize_defaults) e
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
atfs_ma_styleattributes c,
(select * from atfs_ma_stylecolorchannelattributes) d,
(select * from atfs_ma_stylecolorattributes) g,
(select class, size_range_description as sty_size_range, validsizes_store, validsizes_ecom, arr_all_sizes_for_mins, sizemin_store, sizemin_ecom from atfs_l_size_range_validsize_defaults) e, atfs_ata_size_concept_defaults f
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
delete from atfs_ma_stylecolorchannelattributes where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';



s38 := '
INSERT  into atfs_ma_stylecolorchannelattributes (
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
update atfs_ma_stylecolorchannelattributes a
set
  plan_current = v_plan_current
from (select value as v_plan_current from atfs_serviceparams where id=''plan_current'') c
where (product, location) in (select distinct product, location from '||table_temp_sclr_chnl_attr||' where  jsessionid in (select jsid from  '||table_input_t1||'))
';

s51_1 := '
update atfs_ma_stylecolorchannelattributes a
set
  ccrangecode = rangecode
from (select x.sty_size_range || '' - '' || y.ancestor2 as rangecode, style_type, final_stylecolor_id
      from atfs_ma_styleattributes x, atfs_h_prodstd y,
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
        , cast(case when coalesce(cardinality(cast(ssg as text[])),0) > 0 then ''{}'' when cardinality(str_climate)= 0 then ''{N,Y}'' else str_climate end as text[]) as str_climate
        , cast(case when coalesce(cardinality(cast(ssg as text[])),0) > 0 then ''{}'' else str_grade end as text[]) as str_grade
        , cast(ssg as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , case when coalesce(cardinality(cast(ssg as text[])),0) > 0
               then coalesce((select cardinality(l.stores)
                              from atfs_l_ssglookup l
                              where l.ssg_id = array_to_string(cast(ssg as text[]), '','')
                                and l.product = a.scope_product), 0)
               else get_store_count(d.slsstart, a.str_climate, a.str_grade, c.class_id)
          end as store_count
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||') c
    ,atfs_ma_dptflrsetattributes d
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
        , cast(case when d.default_ssg is not null and d.default_ssg <> ''NULL'' then ''{}'' when d.default_climate = ''ALL'' then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else d.default_climate end as text[]) as str_climate
        , cast(case when d.default_ssg is not null and d.default_ssg <> ''NULL'' then ''{}'' when d.default_tier = ''ALL'' then ''{NA,1,2,3,4,5,ECOM}'' else d.default_tier end as text[]) as str_grade
        , cast(case when d.default_ssg = ''NULL'' then ''{}'' else d.default_ssg end as text[]) as ssg
        , cast(flnrange as text[]) as flnrange
        , ''plan'' as plan_type
        , isfunded
        , final_style_id as style
        , case when d.default_ssg is not null and d.default_ssg <> ''NULL''
               then coalesce((select cardinality(l.stores)
                              from atfs_l_ssglookup l
                              where l.ssg_id = array_to_string(cast(d.default_ssg as text[]), '','')
                                and l.product = a.scope_product), 0)
               else get_store_count(e.slsstart, cast(case when d.default_climate = ''ALL'' then ''{COLD,NEUTRAL,HOT,WARM,TROPICAL}'' else d.default_climate end as text[]), cast(case when d.default_tier = ''ALL'' then ''{NA,1,2,3,4,5,ECOM}'' else d.default_tier end as text[]), c.class_id)
          end as store_count
    FROM
    (select distinct * from cart_ranging) a, '||table_input_t1||' b, (select distinct jsessionid, final_stylecolor_id, incoming_stylecolor_id, final_style_id, sc_type, class_id from '||table_cart_master_temp||') c, atfs_ata_size_concept_defaults d
    ,atfs_ma_dptflrsetattributes e
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
delete from atfs_a_assortment a where plan_type=''plan'' and exists (select 1 from '||table_temp_assort||' b where a.product = b.product and a.location = b.location)
';



s41 := '
    insert into atfs_a_assortment (
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
(select distinct product,location  from atfs_ma_stylecolorchannelattributes where (product, location) in (select distinct final_stylecolor_id,'''||$3||''' as prod_loc from '||table_cart_master_temp||' where sc_type = ''master'')) a,
(select distinct product,location  from atfs_a_assortment where (product, location) in (select distinct final_stylecolor_id, '''||$3||''' as prod_loc from '||table_cart_master_temp||')) b
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
          FROM atfs_ma_stylecolorchannelattributes AS a
          , atfs_d_time AS b
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
              FROM atfs_h_prodstd
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
            (select a.* from '||tst_df_with_style||' a, atfs_ma_styleattributes b where a.style=b.product) x
            ';

s104_a := 'update '||tst_md_tktp_md||' a
            set ccticketprice=b.ccticketpricechannel::real, curp=ccticketpricechannel::real
          from atfs_ma_stylecolorchannelattributes b
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
          from atfs_corpdisc b
          where a.subclass=b.product and a.time=b.time
          ';

s107 := 'update '||tst_md_tktp_md||' a
            set expressed_aur=b.eff_aur, addoff=b.addoff, addoff_ecom=b.addoff_ecom
          from atfs_p_itemprice b
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
              select product, dbt_wk, last_rcpt_wk, b.indx as dbt_wk_indx, c.indx as last_rcpt_wk_indx from ( select distinct product, dbt_wk, last_rcpt_wk from '||tst_md_tktp_md||' ) a, atfs_d_time b, atfs_d_time c
              where a.dbt_wk=b.id and a.last_rcpt_wk=c.id
              ';


s110   := 'update '||tst_md_tktp_md||'    set selling_price=(least(v_A,v_B) * (1 - cc_discount_pct))::NUMERIC(16,2), selling_price_ecom=(least(v_A_ecom,v_B_ecom) * (1 - cc_discount_pct_ecom))::NUMERIC(16,2)';
s110_1 := 'update '||tst_md_tktp_md||'  a set dbt_wk=b.start_date from atfs_ma_weekattributes b where a.dbt_wk=b.time';
s110_2 := 'update '||tst_md_tktp_md||'  a set last_rcpt_wk=b.start_date from atfs_ma_weekattributes b where a.last_rcpt_wk=b.time';
s110_3 := 'update '||tst_md_tktp_md||'  a set erlstmkdnwk=b.start_date from atfs_ma_weekattributes b where a.erlstmkdnwk=b.time';
s110_4 := 'update '||tst_md_tktp_md||'  a set exitdate=b.start_date from atfs_ma_weekattributes b where a.exitdate=b.time';
s110_5 := 'update '||tst_md_tktp_md||'  a set weekdate=b.start_date from atfs_ma_weekattributes b where a.time=b.time';



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
              FROM (select * from atfs_a_assortment where product in (select product from '||tst_md_tktp_md||')) AS a
              ,
              (
                  SELECT
                      id,
                      ancestor3
                  FROM atfs_h_prodstd where id in (select product from '||tst_md_tktp_md||')
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
              FROM atfs_ma_dptflrsetattributes AS a
              , atfs_d_time AS b
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
          WHERE time >= (select value from atfs_serviceparams where id=''plan_current'')
          AND time <= (select value from atfs_serviceparams where id=''plan_end'')
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


s114 := 'delete from atfs_an_price_storecount_info where (product,channel) in (select product, channel from '||table_zt||')';
s115 := 'insert into atfs_an_price_storecount_info
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
-- insert into trigger_test_delete_me values ('s1:', clock_timestamp());
-- RAISE NOTICE 's1 :%', clock_timestamp() ;
EXECUTE s2;
--EXECUTE sjrtest_step1;
-- RAISE NOTICE 's2 :%', clock_timestamp() ;
EXECUTE s2_dprod;
EXECUTE s2_1;
--EXECUTE sjrtest_step2;
-- insert into trigger_test_delete_me values ('s2:', clock_timestamp());
-- RAISE NOTICE 's2_1 :%', clock_timestamp() ;
EXECUTE s3;
-- insert into trigger_test_delete_me values ('s3:', clock_timestamp());
-- RAISE NOTICE 's3 :%', clock_timestamp() ;
EXECUTE s3_1;
-- insert into trigger_test_delete_me values ('s3_1:', clock_timestamp());
-- RAISE NOTICE 's3_1 :%', clock_timestamp() ;
EXECUTE s3_2;
-- insert into trigger_test_delete_me values ('s3_2:', clock_timestamp());
-- RAISE NOTICE 's3_2 :%', clock_timestamp() ;
EXECUTE s4_0_1;
-- RAISE NOTICE 's4_0_1 :%', clock_timestamp() ;
EXECUTE s4_0_2;
-- RAISE NOTICE 's4_0_2 :%', clock_timestamp() ;
EXECUTE s4_1;
-- RAISE NOTICE 's4_1 :%', clock_timestamp() ;
-- ============================================================================
-- Modified on July 22nd 2025 by Robert Kebert to comment out section. Style_Size_Type should be coming from the cart_params
-- ============================================================================
/*
EXECUTE s4_2;
*/
EXECUTE s4_2_0_0;
-- RAISE NOTICE 's4_2_0_0 :%', clock_timestamp() ;
EXECUTE s4_2_0;
-- RAISE NOTICE 's4_2_0 :%', clock_timestamp() ;
EXECUTE s4_2_1;
-- RAISE NOTICE 's4_2_1 :%', clock_timestamp() ;
EXECUTE s4_2_4;
-- RAISE NOTICE 's4_2_4 :%', clock_timestamp() ;
EXECUTE s4_2_5;
-- RAISE NOTICE 's4_2_5 :%', clock_timestamp() ;
EXECUTE s4_2_2;
-- RAISE NOTICE 's4_2_2 :%', clock_timestamp() ;
EXECUTE s4_2_3;
-- RAISE NOTICE 's4_2_3 :%', clock_timestamp() ;
--EXECUTE sjrtest_1;
--EXECUTE sjrtest_step3;
EXECUTE s4_3;
-- RAISE NOTICE 's4_3 :%', clock_timestamp() ;
EXECUTE s4_4;
---- RAISE NOTICE 's4_4 :%', clock_timestamp() ;
EXECUTE s4_5;
-- RAISE NOTICE 's4_5 :%', clock_timestamp() ;
-- insert into trigger_test_delete_me values ('s4_1:', clock_timestamp());
EXECUTE s5;
-- insert into trigger_test_delete_me values ('s5:', clock_timestamp());
-- RAISE NOTICE 's5 :%', clock_timestamp() ;
EXECUTE s5_1;
-- insert into trigger_test_delete_me values ('s5_1:', clock_timestamp());
-- RAISE NOTICE 's5_1 :%', clock_timestamp() ;
EXECUTE s5_1_1;
-- insert into trigger_test_delete_me values ('s5_1_1:', clock_timestamp());
-- RAISE NOTICE 's5_1_1 :%', clock_timestamp() ;
EXECUTE s5_2;
-- insert into trigger_test_delete_me values ('s5_2:', clock_timestamp());
-- RAISE NOTICE 's5_2 :%', clock_timestamp() ;
EXECUTE s5_3;
-- insert into trigger_test_delete_me values ('s5_3:', clock_timestamp());
-- RAISE NOTICE 's5_3 :%', clock_timestamp() ;
EXECUTE s6;
-- insert into trigger_test_delete_me values ('s6:', clock_timestamp());
-- RAISE NOTICE 's6 :%', clock_timestamp() ;
--EXECUTE sjrtest_2;
--EXECUTE sjrtest_step4;
EXECUTE s7;
-- insert into trigger_test_delete_me values ('s7:', clock_timestamp());
-- RAISE NOTICE 's7 :%', clock_timestamp() ;
EXECUTE s7_01;
-- insert into trigger_test_delete_me values ('s7_01:', clock_timestamp());
-- RAISE NOTICE 's7_01 :%', clock_timestamp() ;
EXECUTE s7_1;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1 :%', clock_timestamp() ;
EXECUTE s7_1_1;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1_1 :%', clock_timestamp() ;
EXECUTE s7_1_2;
-- insert into trigger_test_delete_me values ('s7_1:', clock_timestamp());
-- RAISE NOTICE 's7_1_2 :%', clock_timestamp() ;
EXECUTE s7_2;
-- insert into trigger_test_delete_me values ('s7_2:', clock_timestamp());
-- RAISE NOTICE 's7_2 :%', clock_timestamp() ;
EXECUTE s8;
-- insert into trigger_test_delete_me values ('s8:', clock_timestamp());
-- RAISE NOTICE 's8 :%', clock_timestamp() ;
EXECUTE s9;
-- insert into trigger_test_delete_me values ('s9:', clock_timestamp());
-- RAISE NOTICE 's9 :%', clock_timestamp() ;
EXECUTE s9_1;
-- insert into trigger_test_delete_me values ('s9:', clock_timestamp());
-- RAISE NOTICE 's9_1 :%', clock_timestamp() ;
EXECUTE s10;
-- insert into trigger_test_delete_me values ('s10:', clock_timestamp());
-- RAISE NOTICE 's10 :%', clock_timestamp() ;
EXECUTE s11;
-- insert into trigger_test_delete_me values ('s11:', clock_timestamp());
-- RAISE NOTICE 's11 :%', clock_timestamp() ;
EXECUTE s11_1;
-- insert into trigger_test_delete_me values ('s11_1:', clock_timestamp());
-- RAISE NOTICE 's11_1 :%', clock_timestamp() ;
EXECUTE s13;
-- insert into trigger_test_delete_me values ('s13:', clock_timestamp());
-- RAISE NOTICE 's13 :%', clock_timestamp() ;
EXECUTE s13_1;
-- insert into trigger_test_delete_me values ('s13_1:', clock_timestamp());
-- RAISE NOTICE 's13_1 :%', clock_timestamp() ;
EXECUTE s14;
-- insert into trigger_test_delete_me values ('s14:', clock_timestamp());
-- RAISE NOTICE 's14 :%', clock_timestamp() ;
EXECUTE s15;
-- insert into trigger_test_delete_me values ('s15:', clock_timestamp());
-- RAISE NOTICE 's15 :%', clock_timestamp() ;
EXECUTE s15_1;
-- insert into trigger_test_delete_me values ('s15_1:', clock_timestamp());
-- RAISE NOTICE 's15_1 :%', clock_timestamp() ;
EXECUTE s15_2;
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
-- TOC entry 878 (class 1255 OID 81940090)
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
-- TOC entry 879 (class 1255 OID 81940091)
-- Name: atfs_no_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.atfs_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp;
DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp_size_concept;    

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE atfs_style_clone_flat_map_temp AS
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO atfs_d_product (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_d_product b
        WHERE a.from_id = b.id
        ON CONFLICT (id) DO NOTHING
        ;

/*
    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;

*/
    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
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
    
        INSERT INTO atfs_ma_styleattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;
    
*/   
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_ma_stylecolorattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_ma_sizeattributes (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_ma_stylecolorchannelattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;
    
    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_ma_imgattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_p_itemprice (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_p_channeloverride (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_a_assortment (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_p_dc_adj (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------
    
        INSERT INTO atfs_p_dc_adj_size (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;
    
    
    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO atfs_an_price_storecount_info (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
/*
        INSERT INTO atfs_l_dependencylookup (
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
        FROM atfs_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';
*/

        INSERT INTO atfs_l_dependencylookup (
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
        FROM atfs_style_clone_flat_map_temp a
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

     CREATE TEMPORARY TABLE atfs_style_clone_flat_map_temp_size_concept AS
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;

    --------------------------------------------------------------------
    -- d_product insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_d_product (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a,
         atfs_d_product b
    WHERE a.from_id = b.id
    ON CONFLICT (id) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert for size concepts
    -- Sets sty_missy_related_style to point to the NEW master style
    -- Uses related size_range and size_type from lookup table
    --------------------------------------------------------------------
    /*
    INSERT INTO atfs_ma_styleattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_styleattributes b ON a.from_id = b.product
    WHERE a.levelid = 'style'
    ON CONFLICT (product) DO NOTHING;

*/
    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert for size concepts
    -- cc_missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_stylecolorattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_stylecolorattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert for size concepts
    -- Uses related size_range from lookup table
    --------------------------------------------------------------------

/*
    INSERT INTO atfs_ma_sizeattributes (
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
         FROM atfs_style_clone_flat_map_temp_size_concept sc
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_sizeattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product) DO NOTHING;
    */


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert for size concepts
    -- missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_stylecolorchannelattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_stylecolorchannelattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location) DO NOTHING;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_imgattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_imgattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- ITEMPRICE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_itemprice (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_itemprice b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_channeloverride (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_channeloverride b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- ASSORTMENT insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_a_assortment (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_a_assortment b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_dc_adj (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_dc_adj b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_dc_adj_size (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_dc_adj_size b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_an_price_storecount_info (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_an_price_storecount_info b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING;


/*
I am unsure if this code needs to be run in any way, but it is something that was similar in add to assortment
    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_l_dependencylookup (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'style';


    INSERT INTO atfs_l_dependencylookup (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'stylecolor';

    --Untested
    --------------------------------------------------------------------
    -- Update master style's sty_size_concepts array with new related styles
    --------------------------------------------------------------------
    UPDATE atfs_ma_styleattributes master
    SET sty_size_concepts = (
        SELECT array_agg(DISTINCT sc.to_id)
        FROM atfs_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    ),
    sty_size_concept_types = (
        SELECT array_agg(DISTINCT sc.related_size_type)
        FROM atfs_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    )
    WHERE product IN (
        SELECT DISTINCT new_master_style_id
        FROM atfs_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'style'
    );

*/
-- DROP THE TEMPORARY TABLES
DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp;
DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp_size_concept;

END;
$$;


ALTER PROCEDURE public.atfs_no_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 880 (class 1255 OID 81940093)
-- Name: atfs_plan_these_cloned_style_stylecolors_proc(text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.atfs_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text)
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
    FROM atfs_plan_these_cloned_style_stylecolors
    WHERE updated_by = v_pivot_user_id
      AND picked_for_planning = 0
    ;

    UPDATE
        atfs_style_clone_stylecolor_size
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
    Update atfs_ma_stylecolorchannelattributes size_concept
    set exitdate = (
        Select exitdate
        FROM atfs_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM atfs_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM atfs_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'stylecolor'
    );

    Update atfs_ma_stylecolorchannelattributes size_concept
    set erlstmkdnwk = (
        Select erlstmkdnwk
        FROM atfs_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM atfs_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM atfs_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'stylecolor'
    );

    Update atfs_ma_stylecolorchannelattributes size_concept
    set dbt_wk = (
        Select dbt_wk
        FROM atfs_ma_stylecolorchannelattributes
        where product in (
            SELECT DISTINCT to_id
            FROM atfs_style_clone_flat_map_temp
            WHERE levelid = 'stylecolor'
        )
    )
    where size_concept.product in (
        SELECT DISTINCT to_id
        FROM atfs_style_clone_flat_map_temp_size_concept
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
        atfs_style_clone_stylecolor_size s
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
        atfs_style_clone_stylecolor_size s
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
        atfs_style_clone_stylecolor_size s
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
    DELETE FROM atfs_style_clone_stylecolor_size a 
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
    delete from atfs_d_product where id in (select distinct product from all_un_used_products);

    delete from atfs_h_prodstd where id in (select distinct product from all_un_used_products);
   
    delete from atfs_a_assortment where product in (select distinct product from all_un_used_products);

    delete from atfs_ma_styleattributes where product in (select distinct product from all_un_used_products);

    delete from atfs_ma_stylecolorattributes where product in (select distinct product from all_un_used_products);

    delete from atfs_ma_sizeattributes where product in (select distinct product from all_un_used_products);

    delete from atfs_ma_imgattributes where product in (select distinct product from all_un_used_products);

    delete from atfs_p_dc_adj where product in (select distinct product from all_un_used_products);

    delete from atfs_p_dc_adj_size where product in (select distinct product from all_un_used_products);

    delete from atfs_p_itemprice where product in (select distinct product from all_un_used_products);

    delete from atfs_p_channeloverride where product in (select distinct product from all_un_used_products);

    delete from atfs_an_price_storecount_info where product in (select distinct product from all_un_used_products);
    */


    -- --------------------------------------------------------------------------------------------------------
    -- CLEAN UP BYPASSING DELETES FOR NOW, SIMULATING REMOVE FROM ASSORTMENT, LIKELY DATA EXISTS IN CLICKHOUSE
    -- --------------------------------------------------------------------------------------------------------
    DELETE FROM atfs_a_assortment 
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products);

    UPDATE atfs_ma_stylecolorchannelattributes
    SET record_state = 1
    WHERE product IN (SELECT DISTINCT product FROM all_un_used_products WHERE levelid = 'stylecolor')
    ;

    UPDATE atfs_ma_stylecolorchannelattributes
    SET record_state = 0
    WHERE product IN (select distinct stylecolor from tmp_selected)
    ;

    ------------------------------------
    -- INSERT IN PLAN QUEUE FOR PLANNING
    ------------------------------------

    INSERT INTO plan_queue (product, location, initiator, initiated_at, queued)
    SELECT 
        DISTINCT stylecolor, 'GP-F' AS location, v_pivot_user_id, now(), now()
    FROM 
        tmp_selected
    ;


    ------------------------------------
    -- UPDATE picked_for_planning FLAG
    -- ------------------------------------
    UPDATE 
        atfs_plan_these_cloned_style_stylecolors 
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


ALTER PROCEDURE public.atfs_plan_these_cloned_style_stylecolors_proc(IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 881 (class 1255 OID 81940095)
-- Name: atfs_style_clone_stylecolor_size_proc(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.atfs_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_session_id    TEXT := p_session_id;
    v_pivot_user_id TEXT := p_pivot_user_id;
BEGIN

    --------------------------------------------------------------------
    -- Build temp flat_map for this session
    --------------------------------------------------------------------
    CREATE TEMPORARY TABLE atfs_style_clone_flat_map_temp AS
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor = clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;


    --------------------------------------------------------------------
    -- d_product insert
    --------------------------------------------------------------------
        INSERT INTO atfs_d_product (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_d_product b
        WHERE a.from_id = b.id
        ON CONFLICT (id) DO NOTHING
        ;


    --------------------------------------------------------------------
    -- STYLE insert
    --------------------------------------------------------------------

        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
        WHERE a.from_style = b.id
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLOR insert
    --------------------------------------------------------------------

        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
        WHERE a.from_stylecolor = b.id
          AND from_style = b.ancestor0
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORSIZE insert
    --------------------------------------------------------------------

        INSERT INTO atfs_h_prodstd (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_h_prodstd b
        WHERE a.from_stylecolorsize = b.id
          AND a.from_stylecolor = b.ancestor0
          AND from_style = b.ancestor1
          AND a.session_id = v_session_id
            ON CONFLICT (id) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert
    --------------------------------------------------------------------

INSERT INTO atfs_ma_styleattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_styleattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'style'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert
    --------------------------------------------------------------------

 INSERT INTO atfs_ma_stylecolorattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_stylecolorattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert
    --------------------------------------------------------------------

        INSERT INTO atfs_ma_sizeattributes (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_ma_sizeattributes b
        WHERE a.from_stylecolorsize = b.product
          AND a.from_stylecolor = b.parent_id
          AND a.session_id = v_session_id
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert
    --------------------------------------------------------------------

          INSERT INTO atfs_ma_stylecolorchannelattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_stylecolorchannelattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location) DO NOTHING
    ;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert
    --------------------------------------------------------------------

        INSERT INTO atfs_ma_imgattributes (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_ma_imgattributes b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- ITEMPRICE insert
    --------------------------------------------------------------------

        INSERT INTO atfs_p_itemprice (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_itemprice b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert
    --------------------------------------------------------------------

        INSERT INTO atfs_p_channeloverride (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_channeloverride b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, time) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- ASSORTMENT insert
    --------------------------------------------------------------------

        INSERT INTO atfs_a_assortment (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_a_assortment b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", location, plan_type) DO NOTHING
    ;


    --------------------------------------------------------------------
    -- DC_ADJ insert
    --------------------------------------------------------------------

        INSERT INTO atfs_p_dc_adj (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_p_dc_adj b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, location, "time") DO NOTHING
    ;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert
    --------------------------------------------------------------------

        INSERT INTO atfs_p_dc_adj_size (
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
        FROM atfs_style_clone_stylecolor_size a,
             atfs_p_dc_adj_size b
        WHERE a.from_stylecolorsize = b.product
          AND a.session_id = v_session_id
            ON CONFLICT (product, location, "time") DO NOTHING
    ;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert
    --------------------------------------------------------------------
    INSERT INTO atfs_an_price_storecount_info (
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
        FROM atfs_style_clone_flat_map_temp a,
             atfs_an_price_storecount_info b
        WHERE a.from_id = b.product
          AND a.levelid = 'stylecolor'
            ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING
        ;



    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts
    --------------------------------------------------------------------
        INSERT INTO atfs_l_dependencylookup (
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
        FROM atfs_style_clone_flat_map_temp a
        WHERE a.levelid = 'style';


        INSERT INTO atfs_l_dependencylookup (
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
        FROM atfs_style_clone_flat_map_temp a
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

     CREATE TEMPORARY TABLE atfs_style_clone_flat_map_temp_size_concept AS
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
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
        FROM atfs_style_clone_stylecolor_size
        WHERE from_stylecolorsize IS NOT NULL AND from_stylecolorsize <> ''
          AND to_new_stylecolor <> clone_new_master_stylecolor
          AND session_id = v_session_id
    ) x;

    --------------------------------------------------------------------
    -- d_product insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_d_product (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a,
         atfs_d_product b
    WHERE a.from_id = b.id
    ON CONFLICT (id) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLEATTRIBUTES insert for size concepts
    -- Sets sty_missy_related_style to point to the NEW master style
    -- Uses related size_range and size_type from lookup table
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_styleattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_styleattributes b ON a.from_id = b.product
    WHERE a.levelid = 'style'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- STYLECOLORATTRIBUTES insert for size concepts
    -- cc_missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_stylecolorattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_stylecolorattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- SIZEATTRIBUTES insert for size concepts
    -- Uses related size_range from lookup table
    --------------------------------------------------------------------

/*
    INSERT INTO atfs_ma_sizeattributes (
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
         FROM atfs_style_clone_flat_map_temp_size_concept sc
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_sizeattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product) DO NOTHING;
    */


    --------------------------------------------------------------------
    -- STYLECOLORCHANNELATTRIBUTES insert for size concepts
    -- missy_related_stylecolor points to the NEW master stylecolor
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_stylecolorchannelattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_stylecolorchannelattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location) DO NOTHING;

    --------------------------------------------------------------------
    -- IMGATTRIBUTES insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_ma_imgattributes (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_ma_imgattributes b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product) DO NOTHING;


    --------------------------------------------------------------------
    -- ITEMPRICE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_itemprice (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_itemprice b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- CHANNELOVERRIDE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_channeloverride (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_channeloverride b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, time) DO NOTHING;


    --------------------------------------------------------------------
    -- ASSORTMENT insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_a_assortment (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_a_assortment b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", location, plan_type) DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_dc_adj (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_dc_adj b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- DC_ADJ_SIZE insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_p_dc_adj_size (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_p_dc_adj_size b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolorsize'
    ON CONFLICT (product, location, "time") DO NOTHING;


    --------------------------------------------------------------------
    -- AN_PRICE_STORECOUNT_INFO insert for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_an_price_storecount_info (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    INNER JOIN atfs_an_price_storecount_info b ON a.from_id = b.product
    WHERE a.levelid = 'stylecolor'
    ON CONFLICT (product, "time", channel, selling_channel) DO NOTHING;


/*
I am unsure if this code needs to be run in any way, but it is something that was similar in add to assortment
    --------------------------------------------------------------------
    -- DEPENDENCYLOOKUP inserts for size concepts
    --------------------------------------------------------------------
    INSERT INTO atfs_l_dependencylookup (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'style';


    INSERT INTO atfs_l_dependencylookup (
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
    FROM atfs_style_clone_flat_map_temp_size_concept a
    WHERE a.levelid = 'stylecolor';

    --Untested
    --------------------------------------------------------------------
    -- Update master style's sty_size_concepts array with new related styles
    --------------------------------------------------------------------
    UPDATE atfs_ma_styleattributes master
    SET sty_size_concepts = (
        SELECT array_agg(DISTINCT sc.to_id)
        FROM atfs_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    ),
    sty_size_concept_types = (
        SELECT array_agg(DISTINCT sc.related_size_type)
        FROM atfs_style_clone_flat_map_temp_size_concept sc
        WHERE sc.levelid = 'style'
          AND sc.new_master_style_id = master.product
    )
    WHERE product IN (
        SELECT DISTINCT new_master_style_id
        FROM atfs_style_clone_flat_map_temp_size_concept
        WHERE levelid = 'style'
    );

*/
-- DROP THE TEMPORARY TABLES
DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp;
DROP TABLE IF EXISTS atfs_style_clone_flat_map_temp_size_concept;

END;
$$;


ALTER PROCEDURE public.atfs_style_clone_stylecolor_size_proc(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 882 (class 1255 OID 81940097)
-- Name: atfs_style_clone_stylecolor_size_proc_dummy(text, text); Type: PROCEDURE; Schema: public; Owner: psql
--

CREATE PROCEDURE public.atfs_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text)
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


ALTER PROCEDURE public.atfs_style_clone_stylecolor_size_proc_dummy(IN p_session_id text, IN p_pivot_user_id text) OWNER TO psql;

--
-- TOC entry 883 (class 1255 OID 81940098)
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
      (select slsstart from atfs_ma_dptflrsetattributes where time=new.scope_floorset and product=new.scope_product), 
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.strclimate)), ','),
      string_to_array(TRIM( BOTH '{' FROM TRIM(BOTH '}' FROM new.grade)), ','),
      new.scope_product);
  else
   raise notice 'Received edit with an ssg.';
    new.store_count := (select array_length(stores, 1) FROM atfs_l_ssglookup
      WHERE ssg_id =ANY(ssg_array) AND product = new.scope_product AND location = new.scope_location);
  END IF;
 RETURN new;
END;
$$;


ALTER FUNCTION public.calc_store_count_ranging() OWNER TO psql;

--
-- TOC entry 884 (class 1255 OID 81940099)
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
  scWeekCount_pub = (select COUNT(*) from atfs_p_dc_adj 
   where product = stylecolorId 
   and location = (select dc from atfs_l_dclookup where channel = channelId)
   and (dc_publish > 0));
  scWeekCount_eoh = (select COUNT(*) from atfs_eohdata_stylecolor 
   where product = stylecolorId 
   and channel = channelId
   and (eohu > 0));
  scWeekCount = scWeekCount_pub + scWeekCount_eoh;
  sizeWeekCount = (select COUNT(*) from atfs_p_dc_adj_size
   where product in (select id from atfs_h_prodstd where ancestor0 = stylecolorId)
   and location = (select dc from atfs_l_dclookup where channel = channelId)
   and (dc_onorder > 0));
  return scWeekCount <= 0 and sizeWeekCount <= 0;
 END;
$$;


ALTER FUNCTION public.can_remove_from_assortment(stylecolorid text, channelid text) OWNER TO psql;

--
-- TOC entry 885 (class 1255 OID 81940100)
-- Name: cc_channel_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_channel_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    atfs_ma_stylecolorchannelattributes
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
    atfs_ma_stylecolorchannelattributes sc
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
  from atfs_ma_stylecolorchannelattributes a
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
    and record_state = 0
    and product not in (select product from plan_queue where completed is null);


    drop table if exists temp_non_missy_stylecolors;
    create temporary table temp_non_missy_stylecolors as 
    select product from atfs_ma_stylecolorchannelattributes where product != NEW.product and missy_related_stylecolor = NEW.product;



    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from atfs_ma_dptflrsetattributes a, atfs_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from atfs_h_prodstd where id=NEW.product)
    and b.product != NEW.product and b.missy_related_stylecolor = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from atfs_a_assortment a, atfs_ma_dptflrsetattributes b, temp_non_missy_stylecolors c, atfs_h_prodstd d
    where c.product = d.id and b.product = d.ancestor3
    and a.product= c.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from atfs_a_assortment where product in (select product from temp_non_missy_stylecolors) and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update atfs_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from atfs_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from atfs_a_assortment a 
          join (select c.time,slsstart,slsend from atfs_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product in (select product from temp_non_missy_stylecolors)) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where atfs_a_assortment.time=filtered.time and atfs_a_assortment.product=filtered.product;

  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cc_channel_copy_master_attributes() OWNER TO psql;

--
-- TOC entry 887 (class 1255 OID 81940101)
-- Name: cc_channel_copy_master_attributes_without_lifecycle(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    atfs_ma_stylecolorchannelattributes
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
    atfs_ma_stylecolorchannelattributes sc
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
  from atfs_ma_stylecolorchannelattributes a
  WHERE
    missy_related_stylecolor = NEW.product
    and product != NEW.product
    and record_state = 0
    and product not in (select product from plan_queue where completed is null);

/*

    drop table if exists temp_non_missy_stylecolors;
    create temporary table temp_non_missy_stylecolors as 
    select product from atfs_ma_stylecolorchannelattributes where product != NEW.product and missy_related_stylecolor = NEW.product;



    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from atfs_ma_dptflrsetattributes a, atfs_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from atfs_h_prodstd where id=NEW.product)
    and b.product != NEW.product and b.missy_related_stylecolor = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from atfs_a_assortment a, atfs_ma_dptflrsetattributes b, temp_non_missy_stylecolors c, atfs_h_prodstd d
    where c.product = d.id and b.product = d.ancestor3
    and a.product= c.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from atfs_a_assortment where product in (select product from temp_non_missy_stylecolors) and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update atfs_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from atfs_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from atfs_a_assortment a 
          join (select c.time,slsstart,slsend from atfs_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product in (select product from temp_non_missy_stylecolors)) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where atfs_a_assortment.time=filtered.time and atfs_a_assortment.product=filtered.product;
*/
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle() OWNER TO psql;

--
-- TOC entry 888 (class 1255 OID 81940102)
-- Name: cc_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.cc_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    atfs_ma_stylecolorattributes
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
    atfs_ma_stylecolorattributes sc
  SET
     cc_climate_product = NEW.cc_climate_product
    ,cc_primary_selling = NEW.cc_primary_selling
    ,cc_online_exclusive_flag = NEW.cc_online_exclusive_flag
    ,cc_delivery_month = NEW.cc_delivery_month
    ,cc_delivery_name = NEW.cc_delivery_name
    ,cc_storeset = NEW.cc_storeset
    ,cc_season = NEW.cc_season
  FROM atfs_ma_stylecolorchannelattributes a
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
  from atfs_ma_stylecolorchannelattributes a
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
-- TOC entry 889 (class 1255 OID 81940103)
-- Name: dbt_after_md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.dbt_after_md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          UPDATE atfs_ma_stylecolorchannelattributes a set dbt_wk = OLD.dbt_wk
          WHERE product=NEW.product
          ;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.dbt_after_md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 890 (class 1255 OID 81940104)
-- Name: delete_duplicate_invalids(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.delete_duplicate_invalids() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM plan_queue WHERE (product,location) in (select product,location from atfs_ma_stylecolorchannelattributes where product = NEW.product
    and location = NEW.location and record_state=1);
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.delete_duplicate_invalids() OWNER TO psql;

--
-- TOC entry 891 (class 1255 OID 81940105)
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
-- TOC entry 892 (class 1255 OID 81940106)
-- Name: exit_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.exit_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE atfs_ma_stylecolorchannelattributes a set exitdate = OLD.exitdate
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.exit_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 893 (class 1255 OID 81940107)
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
 from atfs_h_prodstd where id = productId;

 select a.slsstart into sls_start
 from atfs_ma_dptflrsetattributes a
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
            atfs_l_storelookup
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
            atfs_l_storelookup
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
-- TOC entry 894 (class 1255 OID 81940108)
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
    UPDATE public.atfs_p_subclass_channel_floorset_pssr_infomap t
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
-- TOC entry 898 (class 1255 OID 81940109)
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
          -- CA MOD 12.07.2025
          , use_act_aps_or_act_rank
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
          -- CA MOD 12.07.2025
          , ''Copy Rating''                 -- use_act_aps_or_act_rank

        FROM
          atfs_ma_dptflrsetattributes, (select ''MISSY'' as sty_size_type from atfs_v_memberbasedvalidvalues where attributeid = ''sty_size_type'' limit 1) b, (select master_style_size_range_id, master_style_class as class from atfs_l_size_concept_lookups where department = '''||$2||''' order by master_style_class asc limit 1) c, (select id, name from atfs_d_product where id in (select id from atfs_h_prodstd where ancestor0 = '''||$2||''')) d
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
  FROM atfs_ma_dptflrsetattributes a, cart_params b,
   (select value as plan_current from atfs_serviceparams where id=''plan_current'') c,
   (select value as plan_end from atfs_serviceparams where id=''plan_end'') d
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
-- TOC entry 899 (class 1255 OID 81940110)
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
            atfs_l_storelookup
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
            atfs_l_storelookup
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
-- TOC entry 900 (class 1255 OID 81940111)
-- Name: insert_stylecolorfloorsetattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.insert_stylecolorfloorsetattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
v_count integer;
BEGIN
  --RAISE NOTICE 'inside insert_stylecolorfloorsetattributes :%', clock_timestamp() ;
  select count(*) into v_count from atfs_ma_stylecolorfloorsetattributes where product = NEW.product and time = NEW.time;
  IF v_count = 0
  THEN
      INSERT INTO atfs_ma_stylecolorfloorsetattributes (product,time)
      VALUES (NEW.product, NEW.time);
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.insert_stylecolorfloorsetattributes() OWNER TO psql;

--
-- TOC entry 901 (class 1255 OID 81940112)
-- Name: itemprice_fetchdepartment(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.itemprice_fetchdepartment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department text;
BEGIN
    select ancestor3 into department from atfs_h_prodstd where id = NEW.product;
    NEW.department = department;
    return NEW;
END;
$$;


ALTER FUNCTION public.itemprice_fetchdepartment() OWNER TO psql;

--
-- TOC entry 902 (class 1255 OID 81940113)
-- Name: lifecycle_plan_update(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.lifecycle_plan_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

update atfs_p_dc_adj
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product = NEW.product
and time >= NEW.erlstmkdnwk;

update atfs_p_dc_adj_size
set
  dc_uservrp = null,
  dc_useradj = null
WHERE
product in (select id from atfs_h_prodstd where ancestor0 = NEW.product)
and time >= NEW.erlstmkdnwk;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.lifecycle_plan_update() OWNER TO psql;

--
-- TOC entry 903 (class 1255 OID 81940114)
-- Name: md_trigger_on_update_validity_check(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.md_trigger_on_update_validity_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE atfs_ma_stylecolorchannelattributes a set erlstmkdnwk = OLD.erlstmkdnwk
  WHERE product=NEW.product
  ;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.md_trigger_on_update_validity_check() OWNER TO psql;

--
-- TOC entry 904 (class 1255 OID 81940115)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 905 (class 1255 OID 81940116)
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
-- TOC entry 906 (class 1255 OID 81940117)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM atfs_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

--
-- TOC entry 943 (class 1255 OID 81940118)
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
  from atfs_h_prodstd where id = NEW.product;

  select a.slsstart into sls_start 
  from atfs_ma_dptflrsetattributes a
  where time = NEW.time and product = dept_var;

------------------
-- Start		--
-- USER ACTIONS --
------------------

  -- User currently has as ssg assigned but then assigns a grade or climate then blank out ssg
  if cardinality(OLD.SSG) > 0
    and (cardinality(NEW.str_grade) > 0 or cardinality(NEW.str_climate) > 0)
    and (NEW.str_grade IS DISTINCT FROM OLD.str_grade or NEW.str_climate IS DISTINCT FROM OLD.str_climate)
  then
      NEW.SSG := '{}'::text[];
  end if;

  -- User deselects all grades while also not assigning an ssg then revert to all grades
  if (cardinality(NEW.str_grade) = 0 or cardinality(NEW.str_grade) is null) and (cardinality(NEW.ssg) = 0 or cardinality(NEW.ssg) is null) then 
	  select array_agg(attributevalue) into NEW.str_grade from atfs_v_memberbasedvalidvalues where attributeid = 'str_grade';
  end if;

  -- User deselects all climates while also not assigning an ssg then revert to all climates
  if (cardinality(NEW.str_climate) = 0 or cardinality(NEW.str_climate) is null) and (cardinality(NEW.ssg) = 0 or cardinality(NEW.ssg) is null) then 
	  select array_agg(attributevalue) into NEW.str_climate from atfs_v_memberbasedvalidvalues where attributeid = 'str_climate';
  end if;

  -- User assigns ssg then blank out grade and climate
  if (cardinality(OLD.SSG) = 0 or OLD.SSG is null) and (cardinality(OLD.str_grade) > 0 or cardinality(OLD.str_climate) > 0) and cardinality(NEW.ssg) > 0 then
    NEW.str_grade     :=  '{}'::text[];
    NEW.str_climate	:=  '{}'::text[];
  end if;

------------------
-- End			--
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
      from atfs_l_ssglookup 
      where ssg_id = array_to_string(NEW.SSG, ',')
        and product = dept_var;

      if NEW.store_count is null then
          raise warning 'propagate_assortment_to_floorsets: no ssg lookup for ssg=% dept=% product=% time=%',
                        NEW.SSG, dept_var, NEW.product, NEW.time;
          NEW.store_count := 0;
      end if;
  end if;

  update atfs_a_assortment a
  set str_grade = NEW.str_grade
     ,str_climate = NEW.str_climate
     ,ssg = NEW.ssg
     ,store_count = NEW.store_count
  from (select id, indx from atfs_d_time where levelid = 'floorset') d
  where product = NEW.product
    and location = NEW.location
    and d.id = NEW.time
    and a.time in (select id from atfs_d_time where levelid = 'floorset' and indx >= d.indx)
  ;

  update atfs_a_assortment a
  set store_count = get_store_count(z.slsstart, a.str_climate, a.str_grade, y.ancestor2)
  from (select id, indx from atfs_d_time where levelid = 'floorset') d, atfs_h_prodstd y, atfs_ma_dptflrsetattributes z
  where a.product = NEW.product
    and a.location = NEW.location
    and d.id = NEW.time
    and a.product = y.id and y.ancestor3 = z.product and a.time = z.time
    and a.time in (select id from atfs_d_time where levelid = 'floorset' and indx >= d.indx)
    and coalesce(cardinality(a.ssg),0) = 0
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.propagate_assortment_to_floorsets() OWNER TO psql;

--
-- TOC entry 907 (class 1255 OID 81940119)
-- Name: remove_product_from_queue(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.remove_product_from_queue() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_recordstate smallint;
BEGIN
  
    select record_state into v_recordstate
    from atfs_ma_stylecolorchannelattributes 
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
-- TOC entry 909 (class 1255 OID 81940120)
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
      update atfs_ma_stylecolorchannelattributes
      set record_state = 1
      where product in (    
          select product 
          from atfs_stylecolor_hier_attr 
          where cc_missy_related_stylecolor = new.product
            and product != new.product
    );
    end if;

    --select count(*) into v_isassort
    --from (select * 
    --      from atfs_ma_stylecolorchannelattributes 
    --      where record_state = 0 and product in (select product ||  unnest(old.cc_size_concepts_in_assortment) from atfs_ma_stylecolorattributes where product = NEW.product)
    --) x;
    --
    --RAISE NOTICE 'count: %', v_isassort;
    --if v_isassort > 0
    --then
    --    RETURN OLD;
    --end if;

    select array(select distinct sty_size_type from 
                           (select a.product, e.name, cc_missy_related_stylecolor, b.record_state, sty_size_type, cc_size_concepts_in_assortment 
                            from atfs_ma_stylecolorattributes a, atfs_ma_stylecolorchannelattributes b, atfs_h_prodstd c, atfs_ma_styleattributes d, atfs_d_product e 
                            where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
                            and cc_missy_related_stylecolor = NEW.product
                           ) x where product <> NEW.product and record_state = 0
                      ) into NEW.cc_size_concepts_in_assortment;

    RETURN NEW;

END;
$$;


ALTER FUNCTION public.remove_size_concepts_from_assortment() OWNER TO psql;

--
-- TOC entry 910 (class 1255 OID 81940121)
-- Name: reset_plan_type_to_plan(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.reset_plan_type_to_plan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

  update 
    atfs_a_assortment set plan_type='plan' 
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
-- TOC entry 911 (class 1255 OID 81940122)
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
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location, unnest(validsizes) validsizes, 1 as isvalid from atfs_ma_stylecolorchannelattributes
  where 
  product= '''||v_product||'''
  and location= '''||v_location||'''
    ';
EXECUTE s1;
s2 := '
  update atfs_ma_sizeattributes 
  set isvalid=0
  where parent_id='''||v_product||'''
  ';
EXECUTE s2;
s3 := '
  update atfs_ma_sizeattributes a
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
-- TOC entry 912 (class 1255 OID 81940123)
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
    atfs_stylecolor_hier_attr
where
    product=v_product
limit 1;

s0 := 'drop table if exists '||table_temp_rangecode_master||' 
  ';

s1 := 'create temporary table '||table_temp_rangecode_master||' as 
  select distinct '''||v_product||''' as product,  '''||v_location||''' as location
  , lookup_value as ccrangecode,target_value as master_size_attr, uuid_generate_v4()::text as memberid, 0::int as member_exists from atfs_l_dependencylookup 
  where 
  lookup_id=''size_range''
  and lookup_value= '''||v_sty_size_range||'''
    ';

s2 := '
  update '||table_temp_rangecode_master||' a set memberid = b.product, member_exists=1 from atfs_ma_sizeattributes b 
  where a.product=b.parent_id and a.master_size_attr=b.sizeattribute
  ';
  s3 := '
  update atfs_ma_sizeattributes set isvalid=0 where parent_id='''||v_product||'''
  ';

s4 := '
  delete from atfs_ma_sizeattributes where product in (select memberid from '||table_temp_rangecode_master||')
  ';
 
s5 := ' 
  insert into atfs_ma_sizeattributes (product, sizeattribute, parent_id, isvalid)
  select memberid, master_size_attr, product, 1 as isvalid from '||table_temp_rangecode_master||' 
  ';

s6 := '
  delete from atfs_d_product where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0)
    ';
  
s6x := '
  insert into atfs_d_product (id, name, description, levelid) select memberid, product||''-''||master_size_attr, product||''-''||master_size_attr, ''stylecolorsize'' 
  from  '||table_temp_rangecode_master||' 
  where member_exists=0
  ';

s7 := '
  delete from atfs_h_prodstd where id in (select memberid from '||table_temp_rangecode_master||' where member_exists=0);
  insert into atfs_h_prodstd 
  (id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,ancestor5,version_id,created_at,created_by,updated_at,updated_by,record_state) 
  select 
  memberid,id,ancestor0,ancestor1,ancestor2,ancestor3,ancestor4,version_id,created_at,created_by,updated_at,updated_by,record_state
  from atfs_h_prodstd a, (select memberid,product from  '||table_temp_rangecode_master||'  where member_exists=0) b
  where a.id=b.product
    ';


s8 := '
  update atfs_p_dc_adj_size a
  set dc_useradj=null
  where product in (select product from atfs_ma_sizeattributes where isvalid = 0 and parent_id='''||v_product||''')
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
-- TOC entry 913 (class 1255 OID 81940124)
-- Name: skip_update_styleattributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.skip_update_styleattributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_count integer;
BEGIN
    select count(*) into v_count
    from atfs_ma_styleattributes where product <> NEW.product and sty_specstyleid = NEW.sty_specstyleid and coalesce(NEW.sty_specstyleid, '') <> '';

    IF v_count > 0 THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.skip_update_styleattributes() OWNER TO psql;

--
-- TOC entry 914 (class 1255 OID 81940125)
-- Name: store_eligibility_trigger(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.store_eligibility_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    drop table if exists temp_new;
    drop table if exists temp_old;
    create temporary table temp_new as 
    select b.product,b.location,a.indx,a.time from atfs_ma_dptflrsetattributes a, atfs_ma_stylecolorchannelattributes b
    where 
    a.product in (select ancestor3 from atfs_h_prodstd where id=NEW.product)
    and b.product = NEW.product
    and b.location = NEW.location
    and slsstart <= NEW.exitdate and slsend >= NEW.dbt_wk
    order by indx;
    create temporary table temp_old as 
    select a.product,a.location,str_climate,str_grade,ssg,flnrange,plan_type, style,indx, isfunded, store_count
    from atfs_a_assortment a, atfs_ma_dptflrsetattributes b
    where b.product in (select ancestor3 from atfs_h_prodstd where id=NEW.product)
    and a.product= NEW.product
    and a.location= NEW.location
    and a.time=b.time;
    delete from atfs_a_assortment where product = NEW.product and location = NEW.location and plan_type='plan' and EXISTS (select 1 from temp_new) ;
        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||min(indx) from temp_old group by product, location)
        and c.indx < a.indx;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and a.product||a.location||a.indx in (select product||location||max(indx) from temp_old group by product, location)
        and c.indx > a.indx  
        order by c.indx ;

        insert into atfs_a_assortment 
        (product,location,time,str_climate,str_grade,ssg,flnrange,plan_type, style, isfunded, store_count)
        select a.product,a.location,c.time,str_climate,str_grade,ssg,flnrange,plan_type, style,isfunded, store_count from 
        temp_old a, 
        temp_new c
        where a.product=c.product and a.location=c.location
        and c.indx = a.indx;

    drop table temp_new;
    drop table temp_old;
    -- Make first floorset funded
    update atfs_a_assortment 
    set isfunded = 1 
    from 
        (select d.time, c.product, c.dbt_wk, d.slsstart, d.slsend  from atfs_ma_stylecolorchannelattributes as c 
          join (select distinct a.time, a.product, b.slsstart,b.slsend from atfs_a_assortment a 
          join (select c.time,slsstart,slsend from atfs_ma_dptflrsetattributes c) as b 
        on (a.time=b.time) where a.product=new.product) as d 
    on (c.product=d.product) 
    where c.dbt_wk >= d.slsstart 
    and c.dbt_wk <= d.slsend) filtered 
    where atfs_a_assortment.time=filtered.time and atfs_a_assortment.product=filtered.product;
 RETURN NEW;
END;
$$;


ALTER FUNCTION public.store_eligibility_trigger() OWNER TO psql;

--
-- TOC entry 915 (class 1255 OID 81940126)
-- Name: sty_copy_master_attributes(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.sty_copy_master_attributes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  UPDATE 
    atfs_ma_styleattributes
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
    
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sty_copy_master_attributes() OWNER TO psql;

--
-- TOC entry 886 (class 1255 OID 81940127)
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
-- TOC entry 895 (class 1255 OID 81940128)
-- Name: trigger_set_cp_publish_timestamp(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_cp_publish_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_dc_publish real; 
BEGIN
  select dc_publish into v_dc_publish from atfs_p_dc_adj where product = NEW.product and time = NEW.time and location = NEW.location;

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
-- TOC entry 896 (class 1255 OID 81940129)
-- Name: trigger_set_dcadjcost_ecom(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_dcadjcost_ecom() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

update atfs_p_dc_adj
set dc_adjcost_ecom = NEW.dc_adjcost
where product = NEW.product
and time = NEW.time
;

RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_dcadjcost_ecom() OWNER TO psql;

--
-- TOC entry 897 (class 1255 OID 81940130)
-- Name: trigger_set_indx_valid_values(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.trigger_set_indx_valid_values() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare maxIndx integer;
BEGIN
IF (NEW.indx is null)
then
 select max(indx) into maxIndx from atfs_v_memberbasedvalidvalues;
 new.indx = maxIndx + 1;
END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_indx_valid_values() OWNER TO psql;

--
-- TOC entry 916 (class 1255 OID 81940131)
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
from atfs_ma_stylecolorchannelattributes where product = NEW.product
;

--select min(time) into v_act_irw
--from atfs_p_dc_adj
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
-- TOC entry 917 (class 1255 OID 81940132)
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

   select cc_first_publish_date into v_cc_first_publish_date from atfs_ma_stylecolorchannelattributes where product = NEW.product;

   if v_cc_first_publish_date is null then
       update atfs_ma_stylecolorchannelattributes 
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
-- TOC entry 918 (class 1255 OID 81940133)
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
-- TOC entry 919 (class 1255 OID 81940134)
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
-- TOC entry 920 (class 1255 OID 81940135)
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
      select sty_size_type into v_sty_size_type 
      from atfs_ma_styleattributes a, (select id, ancestor0 from atfs_h_prodstd where id=NEW.product) b
      where a.product = b.ancestor0
      ;

      update atfs_ma_stylecolorattributes
      SET cc_size_concepts_in_assortment=ARRAY_REMOVE(cc_size_concepts_in_assortment,v_sty_size_type)
      WHERE product = cc_missy_related_stylecolor
        and cc_missy_related_stylecolor = (select cc_missy_related_stylecolor from atfs_ma_stylecolorattributes where product = NEW.product);
  
      select sty_specstyleid into v_sty_specstyleid
      from atfs_ma_styleattributes
      where product = (select ancestor0 from atfs_h_prodstd where id = NEW.product)
      ;

      select count(*) into v_hasbeenpublished
      from atfs_ma_stylecolorfloorsetattributes a
      where a.product = NEW.product
        and (fc_published_specstyleid = v_sty_specstyleid OR ir_published_specstyleid = v_sty_specstyleid)
      ;

      select count(*) into v_remainingcc
      from atfs_ma_stylecolorchannelattributes a
      where product in (select id from atfs_h_prodstd where ancestor0 in (select ancestor0 from atfs_h_prodstd where id = NEW.product))
        and product != NEW.product
        and record_state = 0;

      IF (v_hasbeenpublished > 0 and v_remainingcc = 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select ancestor0 as product, 'NA' as time, 'DEL1' as publish_type 
          from atfs_h_prodstd 
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
-- TOC entry 921 (class 1255 OID 81940136)
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

update atfs_a_assortment
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
-- TOC entry 922 (class 1255 OID 81940137)
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
-- TOC entry 923 (class 1255 OID 81940138)
-- Name: update_cc_season(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_cc_season() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  if COALESCE(NEW.cc_storeset,'') != COALESCE(OLD.cc_storeset,'') THEN

    update atfs_ma_stylecolorattributes a
    set cc_season = (select target_value from atfs_l_dependencylookup 
                    where lookup_id = 'storeset' and target_id = 'season' and lookup_value = NEW.cc_storeset
                    ),
        cc_storeset_period = (select target_value from atfs_l_dependencylookup 
                    where lookup_id = 'storeset' and target_id = 'storeset_period' and lookup_value = NEW.cc_storeset
                    )
    where product = NEW.product;
  
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_cc_season() OWNER TO psql;

--
-- TOC entry 924 (class 1255 OID 81940139)
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
     from atfs_ma_stylecolorattributes a, atfs_ma_stylecolorchannelattributes b, atfs_h_prodstd c, atfs_ma_styleattributes d, atfs_d_product e 
     where a.product = e.id and a.product = c.id and c.ancestor0 = d.product and a.product = b.product 
     and cc_missy_related_stylecolor = NEW.product
    ) x where is_removable is false;

  select sty_size_type
  into v_remove_size_concept
  FROM atfs_ma_stylecolorattributes a
  JOIN atfs_h_prodstd b ON a.product = b.id
  JOIN atfs_ma_styleattributes c ON b.ancestor0 = c.product
  WHERE a.product = new.product
  ;

  select sty_specstyleid into v_sty_specstyleid
  from atfs_ma_styleattributes
  where product = (select ancestor0 from atfs_h_prodstd where id = NEW.product)
  ;
  

  IF (NEW.record_state=1 and OLD.record_state=0)
  THEN

      -- Code to check/remove Size concepts from assortment if MISSY/CURVY_MISSY is being removed
      IF v_remove_size_concept in ('MISSY', 'CURVY_MISSY') and v_nonremovable_cc > 0 THEN
         update atfs_ma_stylecolorchannelattributes set record_state = 0 where product = NEW.product;

         RETURN NEW;

      ELSIF v_remove_size_concept in ('MISSY', 'CURVY_MISSY') and v_nonremovable_cc = 0 THEN

          update atfs_ma_stylecolorchannelattributes set record_state = 1
          where product in (select product from atfs_ma_stylecolorattributes where cc_missy_related_stylecolor = NEW.product and product <> NEW.product)
          ;

          -- JR added 20250312 to free up spec style color SUP-2125
          update atfs_ma_stylecolorattributes set cc_specstyle_cccolor = null
          where cc_missy_related_stylecolor = NEW.product
          ;

          update atfs_ma_stylecolorattributes
          set cc_size_concepts_in_assortment = '{}'::text[] 
          where product = NEW.product;

          INSERT INTO sync_stylecolorchannel (product)
          SELECT product from atfs_ma_stylecolorattributes where cc_missy_related_stylecolor = NEW.product and product <> NEW.product;

      ELSE
    
          RAISE NOTICE 'v_remove_size_concept: %', v_remove_size_concept;
          
    
          update atfs_ma_stylecolorattributes
          set cc_size_concepts_in_assortment = array_remove(cc_size_concepts_in_assortment, v_remove_size_concept) 
          where product = (select cc_missy_related_stylecolor from atfs_ma_stylecolorattributes where product = new.product)
          ;

          -- JR added 20250312 to free up spec style color SUP-2125
          update atfs_ma_stylecolorattributes set cc_specstyle_cccolor = null where product = NEW.product;

      END If;

    
      select count(*) into v_hasbeenpublished
      from atfs_ma_stylecolorfloorsetattributes a
      where a.product = NEW.product
        and (fc_published_specstyleid = v_sty_specstyleid OR ir_published_specstyleid = v_sty_specstyleid)
      ;
    
      select count(*) into v_remainingcc
      from atfs_ma_stylecolorchannelattributes a
      where product in (select id from atfs_h_prodstd where ancestor0 in (select ancestor0 from atfs_h_prodstd where id = NEW.product))
        and product != NEW.product
        and record_state = 0;
    
      IF (v_hasbeenpublished > 0 and v_remainingcc = 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select ancestor0 as product, 'NA' as time, 'DEL1' as publish_type 
          from atfs_h_prodstd 
          where id = NEW.product;
      END IF;
    
      INSERT INTO sync_stylecolorchannel (product)
      SELECT NEW.product;

      -- JR added 20250312 to free up spec styles SUP-2125
      -- When Stylecolor being removed from Assortment is the last Stylecolor in the Style to be removed from assortment, even the Spec Style should be disassociated
      update atfs_ma_styleattributes set sty_specstyleid = null where product in
      (select style from (
           select style, sum(in_assortment_count) as in_assortment_count, sum(not_in_assortment_count) as not_in_assortment_count 
           from(
                select a.ancestor0 style, count(distinct c.product) in_assortment_count, 0 as not_in_assortment_count 
                from atfs_h_prodstd a, atfs_h_prodstd b, atfs_ma_stylecolorchannelattributes c 
                where a.ancestor0 = b.ancestor0 and b.id = c.product and a.id = NEW.product and c.record_state = 0 group by a.ancestor0
                union all
                select a.ancestor0 style, 0 as in_assortment_count, count(distinct c.product) as not_in_assortment_count 
                from atfs_h_prodstd a, atfs_h_prodstd b, atfs_ma_stylecolorchannelattributes c 
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
      from atfs_ma_styleattributes a, atfs_ma_styleattributes b 
      where a.product in (select ancestor0 from atfs_h_prodstd where id = NEW.product)
      and a.sty_missy_related_style = b.product;

      update atfs_ma_styleattributes a
      set sty_specstyleid = l.target_value
      from atfs_l_dependencylookup l, atfs_h_prodstd b
      where a.product = b.ancestor0 and b.id = NEW.product
        and l.target_id = a.sty_size_type
      and l.lookup_value = v_parent_sty_specstyleid
        and l.lookup_id = 'master_specstyle_id'
      ;

      select b.cc_specstyle_cccolor into v_parent_cc_specstyle_cccolor
      from atfs_ma_stylecolorattributes a, atfs_ma_stylecolorattributes b 
where a.product = NEW.product
      and a.cc_missy_related_stylecolor = b.product;

      update atfs_ma_stylecolorattributes a
      set cc_specstyle_cccolor = v_parent_cc_specstyle_cccolor
      from atfs_h_prodstd h, atfs_ma_styleattributes s
      where a.product = h.id
        and h.ancestor0 = s.product
        and a.product = NEW.product
        and COALESCE(cc_specstyle_cccolor,'') != COALESCE(v_parent_cc_specstyle_cccolor, '')
        and (COALESCE(v_parent_cc_specstyle_cccolor, ''),s.sty_specstyleid) in (select target_value, lookup_value from atfs_l_dependencylookup where lookup_id = 'sty_specstyleid' and target_id = 'cc_specstylecolorid');


  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_cc_size_concept_in_assortment() OWNER TO psql;

--
-- TOC entry 925 (class 1255 OID 81940141)
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
-- TOC entry 908 (class 1255 OID 81940142)
-- Name: update_ccticketpricechannel_ovr(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ccticketpricechannel_ovr() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN

  update atfs_ma_stylecolorchannelattributes
  set ccticketpricechannel_override = CASE WHEN NEW.ccticketpricechannel_override_txt = '' then NULL else REPLACE(NEW.ccticketpricechannel_override_txt,'$','')::real end,
      ccticketpricechannel_override_txt = CASE WHEN NEW.ccticketpricechannel_override_txt != '' THEN '$' || NEW.ccticketpricechannel_override_txt ELSE '' end
  where product = NEW.product and location = NEW.location;


  RETURN NEW;

END;
$_$;


ALTER FUNCTION public.update_ccticketpricechannel_ovr() OWNER TO psql;

--
-- TOC entry 926 (class 1255 OID 81940143)
-- Name: update_color_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_color_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

  v_style_description atfs_d_product.description%type;
  v_style_name atfs_d_product.name%type;

BEGIN

  select name, description into v_style_name, v_style_description 
  from atfs_d_product where id = (select ancestor0 from atfs_h_prodstd where id = NEW.product);

  if coalesce(NEW.cc_color_name, '') <> coalesce(OLD.cc_color_name, '') then
    update atfs_d_product 
    set description = v_style_description || ':' || NEW.cc_color_name,
        name = v_style_name || ':' || NEW.cc_color_name
    where id = NEW.product;

    update atfs_ma_stylecolorattributes a
    set cccolorfamily = (select target_value from atfs_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'colorfamily' and lookup_value = NEW.cc_color_name
                        )
       ,cccolor = (select target_value from atfs_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'cccolor' and lookup_value = NEW.cc_color_name
                        )
       ,cc_color_type = (select target_value from atfs_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'colortype' and lookup_value = NEW.cc_color_name
                        )
       ,cc_print_description = (select target_value from atfs_l_dependencylookup 
                         where lookup_id = 'colorname' and target_id = 'printdescription' and lookup_value = NEW.cc_color_name
                        )
       -- SUP-3758 commented out
       --,cc_print_pattern_type = (select target_value from atfs_l_dependencylookup 
       --                  where lookup_id = 'colorname' and target_id = 'printpattern' and lookup_value = NEW.cc_color_name
       --                 )
    where product = NEW.product;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_color_change() OWNER TO psql;

--
-- TOC entry 927 (class 1255 OID 81940144)
-- Name: update_ecom_onorder_ovr(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ecom_onorder_ovr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_stylecolor text;
BEGIN

  select ancestor0 into v_stylecolor from atfs_h_prodstd where id = NEW.product;

  update atfs_p_dc_adj
  set dc_sc_finrev_ecom = a.dc_sc_finrev_ecom
  from (select sum(COALESCE(dc_finrev_ecom,0)) as dc_sc_finrev_ecom
        from atfs_p_dc_adj_size
        where product in (select id from atfs_h_prodstd where ancestor0 = v_stylecolor)
          and time = NEW.time
        ) a
  where product = v_stylecolor
    and time = NEW.time;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_ecom_onorder_ovr() OWNER TO psql;

--
-- TOC entry 928 (class 1255 OID 81940145)
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
from atfs_p_itemprice 
where product = NEW.product
and location = NEW.location 
and time = NEW.time;

select ccpriceevent, replace(expression,'cccurp','v_cccurp') into v_ccpriceevent, v_expression 
from atfs_l_priceeventlookup 
where product = NEW.department 
and location = NEW.location 
and ccpriceevent = NEW.event;

select cc_discount_pct::real, ccticketpricechannel::real into v_ccdiscount, v_cccurp
from atfs_ma_stylecolorchannelattributes 
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

update atfs_p_itemprice a 
set eff_aur = final_eff_aur 
where product = NEW.product
and location = NEW.location 
and time = NEW.time;

--Insert related cc record; if it already exists then update the related cc to match the missy cc
insert into atfs_p_itemprice 
select b.product, a.location, a.time, a.addoff, a.eo, a.eff_aur, a.department, a.event, a.eventdate, a.version_id, a.created_at, a.created_by, a.updated_at, a.updated_by, a.record_state, a.addoff_ecom
from atfs_p_itemprice a
join atfs_ma_stylecolorattributes b
on a.product = b.cc_missy_related_stylecolor
join atfs_ma_stylecolorchannelattributes c
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

RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_eff_aur() OWNER TO psql;

--
-- TOC entry 929 (class 1255 OID 81940146)
-- Name: update_name_description(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_name_description() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

  if NEW.levelid = 'style'::text then
    if NEW.name <> OLD.name or NEW.description <> OLD.description then
      update atfs_d_product x
      set description = NEW.description || ':' || y.cccolor,
          name = NEW.name || ':' || y.cccolor
      from (select a.id, b.cccolor from atfs_h_prodstd a, atfs_ma_stylecolorattributes b where a.id = b.product and a.ancestor0 = NEW.id) y
      where x.id = y.id;
  
      update atfs_d_product x
      set description = NEW.description || '_' || y.sty_size_type
         ,name = NEW.name || '_' || y.sty_size_type
      from (select product as id, sty_size_type from atfs_ma_styleattributes where product != sty_missy_related_style and sty_missy_related_style = NEW.id and COALESCE(sty_specstyleid,'') = '') y
      where x.id = y.id;

      update atfs_ma_styleattributes set sty_stylenumber_name = NEW.name || ', ' || NEW.description
      where product = NEW.id;

      update atfs_ma_styleattributes set sty_stylenumber_name = NEW.name || '_' || sty_size_type || ', ' || NEW.description || '_' || sty_size_type
      where product != sty_missy_related_style and sty_missy_related_style = NEW.id and COALESCE(sty_specstyleid,'') = '';
  
    end if;
  end if;

  if NEW.levelid = 'stylecolor'::text then
    if NEW.name <> OLD.name or NEW.description <> OLD.description then
      update atfs_ma_stylecolorattributes set cc_stylecolornumber_name = NEW.name || ', ' || NEW.description
      where product = NEW.id;
    end if;
  end if;



  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_name_description() OWNER TO psql;

--
-- TOC entry 930 (class 1255 OID 81940147)
-- Name: update_p_dc_adj_size_publish(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_p_dc_adj_size_publish() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

 DROP TABLE IF EXISTS skuIds;

 CREATE TEMPORARY TABLE IF NOT EXISTS skuIds AS
 SELECT product
 FROM atfs_ma_sizeattributes
 WHERE parent_id = NEW.product
 ;

 UPDATE atfs_p_dc_adj_size
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
-- TOC entry 931 (class 1255 OID 81940148)
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
        from atfs_h_prodstd where id = NEW.product
        ;
      
        update atfs_ma_stylecolorattributes 
        set cc_price_band = tp.price_band
        from (select lookup_value as ticketprice, target_value as price_band from atfs_l_dependencylookup where target_id = 'sty_price_bands') tp
        where tp.ticketprice::real = NEW.ccticketpricechannel_override::real
          and product = NEW.product
        ;

        update atfs_ma_styleattributes
        set sty_price_bands = tp.price_band
        from (select max(scc.ccticketpricechannel_override::real) as ticketprice 
        from atfs_ma_stylecolorchannelattributes scc
        where product in (select id from atfs_h_prodstd where ancestor0 = v_style)) scc
        ,(select lookup_value as ticketprice, target_value as price_band from atfs_l_dependencylookup where target_id = 'sty_price_bands') tp
        where scc.ticketprice::real = tp.ticketprice::real
          and product = v_style
        ;
          
  END IF;
  
  IF (COALESCE(NEW.ccticketpricechannel,0) !=0) AND (NEW.ccticketpricechannel != OLD.ccticketpricechannel)
  THEN
        select ancestor0 into v_style
        from atfs_h_prodstd where id = NEW.product
        ;
      
        update atfs_ma_stylecolorattributes 
        set cc_price_band = tp.price_band
        from (select lookup_value as ticketprice, target_value as price_band from atfs_l_dependencylookup where target_id = 'sty_price_bands') tp
        where tp.ticketprice::real = NEW.ccticketpricechannel::real
          and product = NEW.product
        ;

        update atfs_ma_styleattributes
        set sty_price_bands = tp.price_band
        from (select max(scc.ccticketpricechannel::real) as ticketprice 
        from atfs_ma_stylecolorchannelattributes scc
        where product in (select id from atfs_h_prodstd where ancestor0 = v_style)) scc
        ,(select lookup_value as ticketprice, target_value as price_band from atfs_l_dependencylookup where target_id = 'sty_price_bands') tp
        where scc.ticketprice::real = tp.ticketprice::real
          and product = v_style
        ;
          
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_price_bands() OWNER TO psql;

--
-- TOC entry 932 (class 1255 OID 81940149)
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
      NEW.fc_published_specstyleid = (select sty_specstyleid from atfs_stylecolor_hier_attr where product = NEW.product);
      NEW.fc_published_specstylecolorid = (select cc_specstylecolorid from atfs_ma_stylecolorattributes where product = NEW.product);
  
      insert into sync_outbound_dataqueue (product,time,publish_type)
      select NEW.product, NEW.time, 'FC' as publish_type;
  
  END IF;
  
  if (NEW.is_ir_published = 'true' AND COALESCE(OLD.is_ir_published,'false') != 'true')
  THEN
      NEW.ir_published_at = date_trunc('sec'::text, CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York');
      NEW.ir_published_user = COALESCE((select email from user_metadata where uid = NEW.updated_by), NEW.updated_by);
      NEW.ir_published_specstyleid = (select sty_specstyleid from atfs_stylecolor_hier_attr where product = NEW.product);
      NEW.ir_published_specstylecolorid = (select cc_specstylecolorid from atfs_ma_stylecolorattributes where product = NEW.product);
  
      insert into sync_outbound_dataqueue (product,time,publish_type)
      select NEW.product, NEW.time, 'IR' as publish_type;
  
  END IF;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_publish_attributes() OWNER TO psql;

--
-- TOC entry 933 (class 1255 OID 81940150)
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
  from atfs_ma_styleattributes where product <> NEW.product and sty_specstyleid = NEW.sty_specstyleid and coalesce(NEW.sty_specstyleid, '') <> '';
  
  if v_count > 0 then 
    --RAISE NOTICE 'Inside revert logic';
    update atfs_ma_styleattributes set sty_specstyleid = OLD.sty_specstyleid where product = NEW.product;
  else
    select ancestor1 into v_class from atfs_h_prodstd where id = NEW.product;
    select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from atfs_l_dependencylookup;
  
    if COALESCE(OLD.sty_specstyleid,'0') <> COALESCE(NEW.sty_specstyleid,'0')
    then
      RAISE NOTICE 'Inside 1: ';
      update atfs_ma_stylecolorattributes set cc_specstyle_cccolor = ''
      where product in (select id from atfs_h_prodstd where ancestor0 = NEW.product);
  
      if (OLD.sty_specstyleid is not null and (OLD.sty_specstyleid not in (select bbr_style from bbr_status_check) OR OLD.sty_specstyleid in (select bbr_style from bbr_status_check where bbr_style is not null and validseasons > 0)))
      then
        insert into atfs_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
        values('class', v_class, 'sty_specstyleid', OLD.sty_specstyleid, v_index);
      end if;
  
      if NEW.sty_specstyleid is not null
      then
        delete from atfs_l_dependencylookup 
        where lookup_id = 'class' and lookup_value = v_class 
          and target_id = 'sty_specstyleid' and target_value = NEW.sty_specstyleid;
  
        update atfs_ma_styleattributes a
        set sty_missy_related_style_bbr = (select target_value from atfs_l_dependencylookup 
                                           where lookup_id = 'bbr_style_id' and target_id = 'sty_missy_related_style_bbr' and lookup_value = NEW.sty_specstyleid
                                          )
            ,sty_size_range_bbr = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_size_range_bbr' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_size_type_bbr = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_size_type_bbr' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_garment_content = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_garment_content' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_stretch_level = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_stretch_level' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_closure = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_closure' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_fit_block = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_fit_block' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_fit_intent = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_fit_intent' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_leg_shape = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_leg_shape' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_length = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_length' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_placement = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_placement' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_rise = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_rise' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_tech_design_type = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_tech_design_type' and lookup_value = NEW.sty_specstyleid
                                  ) 
            ,sty_primary_material_bbr = (select target_value from atfs_l_dependencylookup 
                                    where lookup_id = 'bbr_style_id' and target_id = 'sty_material' and lookup_value = NEW.sty_specstyleid
                                  ) 
        where product = NEW.product;
  
        update atfs_ma_styleattributes a
        set sty_specstyleid = l.target_value
        from atfs_l_dependencylookup l
        where a.product != NEW.product
          and a.sty_missy_related_style = NEW.product
          and l.target_id = a.sty_size_type
          and l.lookup_value = NEW.sty_specstyleid
        ;
  
        select img into specImg from atfs_specimages where left(product,6) = new.sty_specstyleid limit 1;
        if (specImg is not null)
        then
        -- backup previous version of images before overwriting
                insert into atfs_ma_imgattributes_archive SELECT *, now() from atfs_ma_imgattributes where product in (select id from atfs_h_prodstd where ancestor0=NEW.product);
                update atfs_ma_imgattributes set img = specImg where product in (select id from atfs_h_prodstd where ancestor0=NEW.product);
        end if;
  
        if COALESCE(OLD.sty_specstyleid,'') = ''
        then
  
          update atfs_ma_styleattributes
          set style_description = (select description from atfs_d_product where id = NEW.product)
            ,sty_vendor_style_description = (select name from atfs_d_product where id = NEW.product)
          where product = NEW.product;
        
        end if;
  
        update atfs_d_product
        set name = NEW.sty_specstyleid
           ,description = (select target_value from atfs_l_dependencylookup 
                            where lookup_id = 'bbr_style_id' and target_id = 'bbr_style_desc' and lookup_value = NEW.sty_specstyleid
                          )
        where id = NEW.product;  
        
      end if;
    end if;
  
    if COALESCE(NEW.sty_specstyleid,'') = ''
    then
      RAISE NOTICE 'Inside 2: ';
      update atfs_ma_stylecolorattributes
      set cc_specstyle_cccolor = ''
      where product in (select id from atfs_h_prodstd where ancestor0=NEW.product);
  
      update atfs_ma_styleattributes a
      set sty_missy_related_style_bbr = null
          ,sty_size_range_bbr = null
          ,sty_size_type_bbr = null
      where product = NEW.product;
  
      update atfs_ma_styleattributes a
      set sty_specstyleid = null
      where product != NEW.product
        and sty_missy_related_style = NEW.product;
  
      update atfs_d_product
      set name = (select sty_vendor_style_description from atfs_ma_styleattributes where product = NEW.product)
         ,description = (select style_description from atfs_ma_styleattributes where product = NEW.product)
      where id = NEW.product   
      ;
  
      insert into atfs_ma_imgattributes_archive SELECT *, now() from atfs_ma_imgattributes where product in (select id from atfs_h_prodstd where ancestor0=NEW.product);
  
      update atfs_ma_imgattributes a
      set img = b.img
      from (select product, img, sync_date, ROW_NUMBER() OVER (PARTITION BY product ORDER BY sync_date desc) AS rank from atfs_ma_imgattributes_archive) b
      where b.product = a.product
      and a.product  in (select id from atfs_h_prodstd where ancestor0=NEW.product)
        and b.rank = 2
      ;
  
      select count(*) into v_hasbeenpublished
      from atfs_ma_stylecolorfloorsetattributes a
      where a.product in (select id from atfs_h_prodstd where ancestor0 = NEW.product)
        and (fc_published_specstyleid = OLD.sty_specstyleid OR ir_published_specstyleid = OLD.sty_specstyleid)
      ;
  
      IF (v_hasbeenpublished > 0)
      THEN
          insert into sync_outbound_dataqueue (product,time,publish_type)
          select NEW.product, 'NA', 'DEL2' as publish_type;
      END IF;
  
    end if;
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_specstyle_id() OWNER TO psql;

--
-- TOC entry 934 (class 1255 OID 81940152)
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
  select sty_specstyleid into v_specstyleid from (select sty_specstyleid from atfs_ma_styleattributes where product = (select ancestor0 from atfs_h_prodstd where id = NEW.product)) x;

  select count(*) into v_count
  from atfs_ma_stylecolorattributes
  where product <> NEW.product
  and cc_specstylecolorid = (v_specstyleid || '-' || LEFT(NEW.cc_specstyle_cccolor,6)) and coalesce(NEW.cc_specstyle_cccolor, '') <> '';

  if v_count > 0 then 
    --RAISE NOTICE 'Inside revert logic';
    update atfs_ma_stylecolorattributes set cc_specstyle_cccolor = OLD.cc_specstyle_cccolor where product = NEW.product;
  else
    select CAST((max(CAST(index AS integer)) + 1) AS text) into v_index from atfs_l_dependencylookup;
  
    if COALESCE(OLD.cc_specstyle_cccolor,'') <> COALESCE(NEW.cc_specstyle_cccolor,'')
    then
  
      if (COALESCE(OLD.cc_specstyle_cccolor, '') <> '' and (v_specstyleid || '-' ||LEFT(OLD.cc_specstyle_cccolor,6) not in (select bbr_stylecolor from bbr_status_check) OR v_specstyleid || '-' ||LEFT(OLD.cc_specstyle_cccolor,6) in (select bbr_stylecolor from bbr_status_check where validseasons > 0)))
      then
        insert into atfs_l_dependencylookup(lookup_id, lookup_value, target_id, target_value, index)
        values('sty_specstyleid', v_specstyleid, 'cc_specstylecolorid', OLD.cc_specstyle_cccolor, v_index);
      end if;
  
      if COALESCE(NEW.cc_specstyle_cccolor,'') <> ''
      then
        delete from atfs_l_dependencylookup 
        where lookup_id = 'sty_specstyleid' and lookup_value = v_specstyleid 
          and target_id = 'cc_specstylecolorid' and target_value = NEW.cc_specstyle_cccolor;
  
        update atfs_ma_stylecolorattributes a
        set cc_specstylecolorid = (v_specstyleid || '-' || LEFT(NEW.cc_specstyle_cccolor,6))
           ,cc_color_name = NEW.cc_specstyle_cccolor
        where product = NEW.product;
  
        update atfs_ma_stylecolorattributes a
        set cc_specstyle_cccolor = NEW.cc_specstyle_cccolor
        from atfs_h_prodstd h, atfs_ma_styleattributes s
        where a.product = h.id
          and h.ancestor0 = s.product
          and a.product != NEW.product
          and a.cc_missy_related_stylecolor = NEW.product
          and COALESCE(cc_specstyle_cccolor,'') != NEW.cc_specstyle_cccolor
          and (NEW.cc_specstyle_cccolor,s.sty_specstyleid) in (select target_value, lookup_value from atfs_l_dependencylookup where lookup_id = 'sty_specstyleid' and target_id = 'cc_specstylecolorid');
        
      end if;
    end if;
  
    if COALESCE(NEW.cc_specstyle_cccolor,'') = ''
    then
      update atfs_ma_stylecolorattributes a
      set cc_specstylecolorid = ''
      where product = NEW.product;
  
      update atfs_ma_stylecolorattributes a
      set cc_specstylecolorid = ''
         ,cc_specstyle_cccolor = ''
      where a.product != NEW.product
        and a.cc_missy_related_stylecolor = NEW.product
      ;
      
    end if;
  end if;

  return NEW;
END;
$$;


ALTER FUNCTION public.update_specstylecolor_id() OWNER TO psql;

--
-- TOC entry 935 (class 1255 OID 81940153)
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

-- this part is specific to style attribute sty_size_range changing
-- need to make another rendition of this for class changing

if NEW.sty_size_range <> OLD.sty_size_range then

  select id into v_style from atfs_d_product where levelid='style' and id=NEW.product;
  select  OLD.sty_size_range into v_old_sty_size_range;

  select NEW.sty_size_range into v_new_sty_size_range;
  
  select NEW.sty_size_range||' - '||ancestor1 into v_new_ccrangecode
  from
      atfs_h_prodstd
  where
      id=v_style
  limit 1;


  IF NEW.sty_missy_related_style = NEW.product
  THEN
    -- update size concept size ranges
    update atfs_ma_styleattributes s
    set sty_size_range = l.related_size_size_range_id
    from (select id as style, ancestor1 as class from atfs_h_prodstd) h
        ,(select * from atfs_ma_styleattributes) s2
        ,(select distinct related_size_class, related_size_size_range_id, master_style_size_range_id from atfs_l_size_concept_lookups) l
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
  
  -- update ccsizerange based on updated express_size_range and or class info
  
  s0 := 'create temporary table '||table_temp_sub_exists||' as
      select a.product, a.ccrangecode as old_ccrangecode, '''||v_new_ccrangecode||''' new_ccrangecode, validsizes_store, validsizes_ecom
      from atfs_ma_stylecolorchannelattributes a, 
           (select id, ancestor0 as style, ancestor2 as class from atfs_h_prodstd where ancestor0='''||v_style||''') h, 
           (select class,size_range_description as sty_size_range, validsizes_store, validsizes_ecom from atfs_l_size_range_validsize_defaults) f
      where a.product = h.id and h.class = f.class and f.sty_size_range = '''||v_new_sty_size_range||'''
      ';
  -- RAISE NOTICE 'S0:%', 'START:'|| s0;
  
  
  s1 := 'UPDATE atfs_ma_stylecolorchannelattributes a
  set ccrangecode=b.new_ccrangecode
     ,cc_validsizes_store=b.validsizes_store
     ,cc_validsizes_ecom=b.validsizes_ecom
  from '||table_temp_sub_exists||' b
  where a.product=b.product
  and b.new_ccrangecode is not null
  and a.product in (select product from '||table_temp_sub_exists||' where new_ccrangecode is not null)
  ';

  
  -- RAISE NOTICE 'S1:%', 'START:'|| s1;
  
  
  EXECUTE s0;
  EXECUTE s1;

end if;

RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_stylecolorchannelattributes_ccrangecode() OWNER TO psql;

--
-- TOC entry 936 (class 1255 OID 81940154)
-- Name: update_subclass(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_subclass() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  update atfs_h_prodstd
  set ancestor0 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from atfs_l_size_concept_lookups a, (select * from atfs_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where id = x.product
  ;

  update atfs_h_prodstd
  set ancestor1 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from atfs_l_size_concept_lookups a, (select * from atfs_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where ancestor0 = x.product
  ;

  update atfs_h_prodstd
  set ancestor2 = related_size_subclass
  from (
  select b.product, b.sty_size_type, related_size_subclass, related_size_class
  from atfs_l_size_concept_lookups a, (select * from atfs_ma_styleattributes where product != NEW.id and sty_missy_related_style = NEW.id) b
  where department = NEW.ancestor2
    and master_style_subclass = NEW.ancestor0
    and related_size_type = b.sty_size_type
    and related_size_size_range_id = b.sty_size_range
  ) x
  where ancestor1 = x.product
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_subclass() OWNER TO psql;

--
-- TOC entry 937 (class 1255 OID 81940155)
-- Name: update_subclass_name(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_subclass_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

  update atfs_ma_stylecolorattributes
  set subclass_name = d.name
  from atfs_d_product d
  where d.id = NEW.ancestor1
    and product = NEW.id 
  ;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.update_subclass_name() OWNER TO psql;

--
-- TOC entry 938 (class 1255 OID 81940156)
-- Name: update_ticket_price(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.update_ticket_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
  if NEW.cc_msrp <> OLD.cc_msrp then
    update atfs_ma_stylecolorchannelattributes
    set ccticketpricechannel = cast(NEW.cc_msrp as real)
    where product = NEW.product;

  end if;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_ticket_price() OWNER TO psql;

--
-- TOC entry 939 (class 1255 OID 81940157)
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
    select b.product,b.location,a.indx,a.time from atfs_ma_dptflrsetattributes a, cart_params_temp b, 
    (select value as plan_current from atfs_serviceparams where id='plan_current') c,
    (select value as plan_end from atfs_serviceparams where id='plan_end') d
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
-- TOC entry 940 (class 1255 OID 81940158)
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
--v_irw_indx := (select indx from atfs_d_time where id =''||NEW.initrcptwk||'');
v_dbtwk_indx := (select indx from atfs_d_time where id = ''||NEW.dbt_wk||'');
v_relaunchwk_indx := (select indx from atfs_d_time where id = ''||NEW.relaunchweek||'');
v_mdstart_indx := (select indx  from atfs_d_time where id = ''||NEW.erlstmkdnwk||'');
--v_lastdcorder_indx := (select indx from atfs_d_time where id =''||NEW.lastdcorder||'');
v_exitdate_indx := (select indx  from atfs_d_time where id = ''||NEW.exitdate||'');

v_irw_indx := v_dbtwk_indx - 3;
v_initrcptwk := (select id from atfs_d_time where indx= v_irw_indx);
v_lastdcorder_indx := v_mdstart_indx - 6;
v_lastdcorder := (select id from atfs_d_time where indx= v_lastdcorder_indx);


if (NEW.dbt_wk != OLD.dbt_wk AND OLD.dbt_wk = OLD.act_dbt_wk and new.dbt_wk < new.erlstmkdnwk and old.dbt_wk >= old.plan_current) then
    
    UPDATE atfs_ma_stylecolorchannelattributes
    SET act_dbt_wk = NEW.dbt_wk
    WHERE
    product = NEW.product
    and location = NEW.location;

end if;

  --RAISE NOTICE 'Test here 1';

if (new.dbt_wk < new.erlstmkdnwk AND new.erlstmkdnwk < new.exitdate AND (old.dbt_wk > old.plan_current OR old.exitdate > old.plan_current) AND new.exitdate > new.erlstmkdnwk)
then
  --RAISE NOTICE 'Test here 2';
  update atfs_ma_stylecolorchannelattributes
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

  update atfs_ma_stylecolorchannelattributes
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

--
-- TOC entry 941 (class 1255 OID 81940159)
-- Name: validate_size_concept_addition(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.validate_size_concept_addition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_sty_size_type text;
    v_subclass text;
    v_invalid_count int;
    v_scca_attr_state int;
BEGIN

    select sty_size_type, subclass into v_sty_size_type, v_subclass
    from atfs_stylecolor_hier_attr where product = NEW.product;

    select count(*) into v_invalid_count from (
    select * from (
    select unnest(NEW.cc_size_concepts_in_assortment) as size_types, subclass, sty_size_type
    from atfs_stylecolor_hier_attr a
    where product = NEW.product
    ) x 
    where size_types not in (select distinct related_size_type from atfs_l_size_concept_lookups where master_style_subclass = v_subclass and master_style_size_type = v_sty_size_type)
    ) z;

    if (v_invalid_count > 0)
    THEN
      RETURN OLD;
    end if;

  RETURN NEW;

END;
$$;


ALTER FUNCTION public.validate_size_concept_addition() OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 819 (class 1259 OID 82000184)
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
-- TOC entry 820 (class 1259 OID 82000199)
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
-- TOC entry 581 (class 1259 OID 81940160)
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
-- TOC entry 582 (class 1259 OID 81940167)
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
-- TOC entry 583 (class 1259 OID 81940175)
-- Name: assort_period_from_dpt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.assort_period_from_dpt (
    department text NOT NULL,
    "time" text NOT NULL,
    floorset text
);


ALTER TABLE public.assort_period_from_dpt OWNER TO psql;

--
-- TOC entry 584 (class 1259 OID 81940180)
-- Name: atfs_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment (
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


ALTER TABLE public.atfs_a_assortment OWNER TO psql;

--
-- TOC entry 585 (class 1259 OID 81940196)
-- Name: atfs_a_assortment_20250909; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment_20250909 (
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


ALTER TABLE public.atfs_a_assortment_20250909 OWNER TO psql;

--
-- TOC entry 586 (class 1259 OID 81940201)
-- Name: atfs_a_assortment_backup_strcnt; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment_backup_strcnt (
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


ALTER TABLE public.atfs_a_assortment_backup_strcnt OWNER TO psql;

--
-- TOC entry 587 (class 1259 OID 81940206)
-- Name: atfs_a_assortment_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment_bk (
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


ALTER TABLE public.atfs_a_assortment_bk OWNER TO psql;

--
-- TOC entry 588 (class 1259 OID 81940211)
-- Name: atfs_a_assortment_history_storecount; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment_history_storecount (
    product text,
    "time" text,
    location text,
    str_grade text[],
    str_climate text[],
    ssg text[],
    department text,
    store_count integer
);


ALTER TABLE public.atfs_a_assortment_history_storecount OWNER TO psql;

--
-- TOC entry 589 (class 1259 OID 81940216)
-- Name: atfs_a_assortment_sup3000; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_a_assortment_sup3000 (
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


ALTER TABLE public.atfs_a_assortment_sup3000 OWNER TO psql;

--
-- TOC entry 590 (class 1259 OID 81940221)
-- Name: atfs_act; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_act (
    product text,
    act_slsrnk_store real,
    act_slsrnk_ecom real
);


ALTER TABLE public.atfs_act OWNER TO psql;

--
-- TOC entry 591 (class 1259 OID 81940226)
-- Name: atfs_an_price_storecount_info; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_an_price_storecount_info (
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


ALTER TABLE public.atfs_an_price_storecount_info OWNER TO psql;

--
-- TOC entry 592 (class 1259 OID 81940231)
-- Name: atfs_ata_missing_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items (
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


ALTER TABLE public.atfs_ata_missing_items OWNER TO psql;

--
-- TOC entry 593 (class 1259 OID 81940236)
-- Name: atfs_ata_missing_items_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_assortment (
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


ALTER TABLE public.atfs_ata_missing_items_assortment OWNER TO psql;

--
-- TOC entry 594 (class 1259 OID 81940241)
-- Name: atfs_ata_missing_items_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_d_product (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.atfs_ata_missing_items_d_product OWNER TO psql;

--
-- TOC entry 595 (class 1259 OID 81940246)
-- Name: atfs_ata_missing_items_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_existing (
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


ALTER TABLE public.atfs_ata_missing_items_existing OWNER TO psql;

--
-- TOC entry 596 (class 1259 OID 81940251)
-- Name: atfs_ata_missing_items_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_h_prodstd (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text
);


ALTER TABLE public.atfs_ata_missing_items_h_prodstd OWNER TO psql;

--
-- TOC entry 597 (class 1259 OID 81940256)
-- Name: atfs_ata_missing_items_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_imgattributes (
    product text,
    img text
);


ALTER TABLE public.atfs_ata_missing_items_imgattributes OWNER TO psql;

--
-- TOC entry 598 (class 1259 OID 81940261)
-- Name: atfs_ata_missing_items_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_sizeattributes (
    product text,
    sizeattribute text,
    parent_id text
);


ALTER TABLE public.atfs_ata_missing_items_sizeattributes OWNER TO psql;

--
-- TOC entry 599 (class 1259 OID 81940266)
-- Name: atfs_ata_missing_items_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_styleattributes (
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


ALTER TABLE public.atfs_ata_missing_items_styleattributes OWNER TO psql;

--
-- TOC entry 600 (class 1259 OID 81940271)
-- Name: atfs_ata_missing_items_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_stylecolorattributes (
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


ALTER TABLE public.atfs_ata_missing_items_stylecolorattributes OWNER TO psql;

--
-- TOC entry 601 (class 1259 OID 81940276)
-- Name: atfs_ata_missing_items_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_stylecolorchannelattributes (
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


ALTER TABLE public.atfs_ata_missing_items_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 602 (class 1259 OID 81940281)
-- Name: atfs_ata_missing_items_stylecolorsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_stylecolorsizes (
    final_stylecolorsize_id text,
    size_name text,
    size_description text,
    final_style_id text,
    final_stylecolor_id text
);


ALTER TABLE public.atfs_ata_missing_items_stylecolorsizes OWNER TO psql;

--
-- TOC entry 603 (class 1259 OID 81940286)
-- Name: atfs_ata_missing_items_styles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_styles (
    final_style_id text,
    sty_size_type text,
    sty_missy_related_style text,
    final_style_name text,
    final_style_desc text,
    sc_type text
);


ALTER TABLE public.atfs_ata_missing_items_styles OWNER TO psql;

--
-- TOC entry 604 (class 1259 OID 81940291)
-- Name: atfs_ata_missing_items_take2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2 (
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


ALTER TABLE public.atfs_ata_missing_items_take2 OWNER TO psql;

--
-- TOC entry 605 (class 1259 OID 81940296)
-- Name: atfs_ata_missing_items_take2_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_assortment (
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


ALTER TABLE public.atfs_ata_missing_items_take2_assortment OWNER TO psql;

--
-- TOC entry 606 (class 1259 OID 81940301)
-- Name: atfs_ata_missing_items_take2_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_d_product (
    id text,
    name text,
    description text,
    levelid text
);


ALTER TABLE public.atfs_ata_missing_items_take2_d_product OWNER TO psql;

--
-- TOC entry 607 (class 1259 OID 81940306)
-- Name: atfs_ata_missing_items_take2_existing; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_existing (
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


ALTER TABLE public.atfs_ata_missing_items_take2_existing OWNER TO psql;

--
-- TOC entry 608 (class 1259 OID 81940311)
-- Name: atfs_ata_missing_items_take2_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_h_prodstd (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text
);


ALTER TABLE public.atfs_ata_missing_items_take2_h_prodstd OWNER TO psql;

--
-- TOC entry 609 (class 1259 OID 81940316)
-- Name: atfs_ata_missing_items_take2_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_imgattributes (
    product text,
    img text
);


ALTER TABLE public.atfs_ata_missing_items_take2_imgattributes OWNER TO psql;

--
-- TOC entry 610 (class 1259 OID 81940321)
-- Name: atfs_ata_missing_items_take2_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_sizeattributes (
    product text,
    sizeattribute text,
    parent_id text
);


ALTER TABLE public.atfs_ata_missing_items_take2_sizeattributes OWNER TO psql;

--
-- TOC entry 611 (class 1259 OID 81940326)
-- Name: atfs_ata_missing_items_take2_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_styleattributes (
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


ALTER TABLE public.atfs_ata_missing_items_take2_styleattributes OWNER TO psql;

--
-- TOC entry 612 (class 1259 OID 81940331)
-- Name: atfs_ata_missing_items_take2_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_stylecolorattributes (
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


ALTER TABLE public.atfs_ata_missing_items_take2_stylecolorattributes OWNER TO psql;

--
-- TOC entry 613 (class 1259 OID 81940336)
-- Name: atfs_ata_missing_items_take2_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_stylecolorchannelattributes (
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


ALTER TABLE public.atfs_ata_missing_items_take2_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 614 (class 1259 OID 81940341)
-- Name: atfs_ata_missing_items_take2_stylecolorsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_stylecolorsizes (
    final_stylecolorsize_id text,
    size_name text,
    size_description text,
    final_style_id text,
    final_stylecolor_id text
);


ALTER TABLE public.atfs_ata_missing_items_take2_stylecolorsizes OWNER TO psql;

--
-- TOC entry 615 (class 1259 OID 81940346)
-- Name: atfs_ata_missing_items_take2_styles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_styles (
    final_style_id text,
    sty_size_type text,
    sty_missy_related_style text,
    final_style_name text,
    final_style_desc text,
    sc_type text
);


ALTER TABLE public.atfs_ata_missing_items_take2_styles OWNER TO psql;

--
-- TOC entry 616 (class 1259 OID 81940351)
-- Name: atfs_ata_missing_items_take2_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_take2_validsizes (
    class text,
    size_range text,
    size_range_description text,
    sizeattribute text
);


ALTER TABLE public.atfs_ata_missing_items_take2_validsizes OWNER TO psql;

--
-- TOC entry 617 (class 1259 OID 81940359)
-- Name: atfs_ata_missing_items_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_missing_items_validsizes (
    class text,
    size_range text,
    size_range_description text,
    sizeattribute text
);


ALTER TABLE public.atfs_ata_missing_items_validsizes OWNER TO psql;

--
-- TOC entry 618 (class 1259 OID 81940364)
-- Name: atfs_ata_size_concept_defaults; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_size_concept_defaults (
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


ALTER TABLE public.atfs_ata_size_concept_defaults OWNER TO psql;

--
-- TOC entry 619 (class 1259 OID 81940376)
-- Name: atfs_ata_size_concept_defaults_20250217; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ata_size_concept_defaults_20250217 (
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


ALTER TABLE public.atfs_ata_size_concept_defaults_20250217 OWNER TO psql;

--
-- TOC entry 620 (class 1259 OID 81940381)
-- Name: atfs_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_authorization (
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


ALTER TABLE public.atfs_authorization OWNER TO psql;

--
-- TOC entry 621 (class 1259 OID 81940393)
-- Name: atfs_c_conversion_file_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_conversion_file_lifecycle (
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


ALTER TABLE public.atfs_c_conversion_file_lifecycle OWNER TO psql;

--
-- TOC entry 622 (class 1259 OID 81940398)
-- Name: atfs_c_conversion_history_lifecycle; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_conversion_history_lifecycle (
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


ALTER TABLE public.atfs_c_conversion_history_lifecycle OWNER TO psql;

--
-- TOC entry 623 (class 1259 OID 81940403)
-- Name: atfs_c_conversion_history_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_conversion_history_stylecolorchannelattributes (
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


ALTER TABLE public.atfs_c_conversion_history_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 624 (class 1259 OID 81940408)
-- Name: atfs_c_conversion_history_ticketprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_conversion_history_ticketprice (
    currentprice text,
    parent_id text
);


ALTER TABLE public.atfs_c_conversion_history_ticketprice OWNER TO psql;

--
-- TOC entry 625 (class 1259 OID 81940413)
-- Name: atfs_c_conversion_history_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_conversion_history_validsizes (
    product text,
    valid_sizes text
);


ALTER TABLE public.atfs_c_conversion_history_validsizes OWNER TO psql;

--
-- TOC entry 626 (class 1259 OID 81940418)
-- Name: atfs_c_cutover_prep_history; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_c_cutover_prep_history (
    product text,
    dbt_wk text,
    erlstmkdnwk text,
    exitdate text,
    initrcptwk text,
    wac real,
    validsizes text[]
);


ALTER TABLE public.atfs_c_cutover_prep_history OWNER TO psql;

--
-- TOC entry 627 (class 1259 OID 81940423)
-- Name: atfs_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_corpdisc (
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


ALTER TABLE public.atfs_corpdisc OWNER TO psql;

--
-- TOC entry 834 (class 1259 OID 105337418)
-- Name: atfs_corpdisc_backup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_corpdisc_backup (
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


ALTER TABLE public.atfs_corpdisc_backup OWNER TO psql;

--
-- TOC entry 628 (class 1259 OID 81940444)
-- Name: atfs_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_cluster (
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


ALTER TABLE public.atfs_d_cluster OWNER TO psql;

--
-- TOC entry 629 (class 1259 OID 81940456)
-- Name: atfs_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_location (
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


ALTER TABLE public.atfs_d_location OWNER TO psql;

--
-- TOC entry 630 (class 1259 OID 81940468)
-- Name: atfs_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_prodlife (
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


ALTER TABLE public.atfs_d_prodlife OWNER TO psql;

--
-- TOC entry 631 (class 1259 OID 81940480)
-- Name: atfs_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_product (
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


ALTER TABLE public.atfs_d_product OWNER TO psql;

--
-- TOC entry 632 (class 1259 OID 81940492)
-- Name: atfs_d_product_duplicates_20250521; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_product_duplicates_20250521 (
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


ALTER TABLE public.atfs_d_product_duplicates_20250521 OWNER TO psql;

--
-- TOC entry 633 (class 1259 OID 81940497)
-- Name: atfs_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_d_time (
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


ALTER TABLE public.atfs_d_time OWNER TO psql;

--
-- TOC entry 634 (class 1259 OID 81940509)
-- Name: atfs_designimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_designimages (
    product text,
    img text
);


ALTER TABLE public.atfs_designimages OWNER TO psql;

--
-- TOC entry 635 (class 1259 OID 81940514)
-- Name: atfs_eohdata_stylecolor; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_eohdata_stylecolor (
    product text,
    channel text,
    eohu real
);


ALTER TABLE public.atfs_eohdata_stylecolor OWNER TO psql;

--
-- TOC entry 839 (class 1259 OID 105337626)
-- Name: atfs_fix_null_cccolorfamily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_fix_null_cccolorfamily (
    product text,
    cccolor text,
    cc_color_id text,
    cc_color_name text,
    cccolorfamily text,
    cc_color_type text,
    cc_specstyle_cccolor text,
    cc_specstylecolorid text
);


ALTER TABLE public.atfs_fix_null_cccolorfamily OWNER TO psql;

--
-- TOC entry 837 (class 1259 OID 105337556)
-- Name: atfs_fix_size_concept_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_fix_size_concept_specstyles (
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


ALTER TABLE public.atfs_fix_size_concept_specstyles OWNER TO psql;

--
-- TOC entry 838 (class 1259 OID 105337573)
-- Name: atfs_fix_specstylecolorid; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_fix_specstylecolorid (
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


ALTER TABLE public.atfs_fix_specstylecolorid OWNER TO psql;

--
-- TOC entry 636 (class 1259 OID 81940534)
-- Name: atfs_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_timeflrset (
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


ALTER TABLE public.atfs_h_timeflrset OWNER TO psql;

--
-- TOC entry 637 (class 1259 OID 81940546)
-- Name: atfs_for_tgt_flrset_hier; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.atfs_for_tgt_flrset_hier AS
 SELECT a.id,
    a.indx,
    b.ancestor0 AS superset,
    b.ancestor1 AS fiscal_year,
    (now())::timestamp(0) without time zone AS updated_at
   FROM public.atfs_d_time a,
    public.atfs_h_timeflrset b
  WHERE ((a.levelid = 'floorset'::text) AND (a.id = b.id));


ALTER VIEW public.atfs_for_tgt_flrset_hier OWNER TO psql;

--
-- TOC entry 638 (class 1259 OID 81940550)
-- Name: atfs_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.atfs_h_clusterstd OWNER TO psql;

--
-- TOC entry 639 (class 1259 OID 81940565)
-- Name: atfs_h_locdc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_locdc (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.atfs_h_locdc OWNER TO psql;

--
-- TOC entry 640 (class 1259 OID 81940577)
-- Name: atfs_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_locdcstd (
    id text NOT NULL,
    ancestor0 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.atfs_h_locdcstd OWNER TO psql;

--
-- TOC entry 641 (class 1259 OID 81940588)
-- Name: atfs_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_locstd (
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


ALTER TABLE public.atfs_h_locstd OWNER TO psql;

--
-- TOC entry 642 (class 1259 OID 81940600)
-- Name: atfs_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.atfs_h_prodlifestd OWNER TO psql;

--
-- TOC entry 643 (class 1259 OID 81940612)
-- Name: atfs_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_prodstd (
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


ALTER TABLE public.atfs_h_prodstd OWNER TO psql;

--
-- TOC entry 644 (class 1259 OID 81940623)
-- Name: atfs_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_h_timestd (
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


ALTER TABLE public.atfs_h_timestd OWNER TO psql;

--
-- TOC entry 645 (class 1259 OID 81940635)
-- Name: atfs_l_dclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_dclookup (
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


ALTER TABLE public.atfs_l_dclookup OWNER TO psql;

--
-- TOC entry 646 (class 1259 OID 81940647)
-- Name: atfs_l_dependencylookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_dependencylookup (
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


ALTER TABLE public.atfs_l_dependencylookup OWNER TO psql;

--
-- TOC entry 647 (class 1259 OID 81940661)
-- Name: atfs_l_dependencylookup_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_dependencylookup_bk (
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


ALTER TABLE public.atfs_l_dependencylookup_bk OWNER TO psql;

--
-- TOC entry 648 (class 1259 OID 81940666)
-- Name: atfs_l_priceeventlookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_priceeventlookup (
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


ALTER TABLE public.atfs_l_priceeventlookup OWNER TO psql;

--
-- TOC entry 649 (class 1259 OID 81940680)
-- Name: atfs_l_size_concept_lookups; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_size_concept_lookups (
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


ALTER TABLE public.atfs_l_size_concept_lookups OWNER TO psql;

--
-- TOC entry 832 (class 1259 OID 105337331)
-- Name: atfs_l_size_range_validsize_defaults; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_size_range_validsize_defaults (
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


ALTER TABLE public.atfs_l_size_range_validsize_defaults OWNER TO psql;

--
-- TOC entry 650 (class 1259 OID 81940704)
-- Name: atfs_l_ssglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_ssglookup (
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


ALTER TABLE public.atfs_l_ssglookup OWNER TO psql;

--
-- TOC entry 651 (class 1259 OID 81940718)
-- Name: atfs_l_storedclookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_storedclookup (
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


ALTER TABLE public.atfs_l_storedclookup OWNER TO psql;

--
-- TOC entry 652 (class 1259 OID 81940730)
-- Name: atfs_l_storelookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_storelookup (
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


ALTER TABLE public.atfs_l_storelookup OWNER TO psql;

--
-- TOC entry 824 (class 1259 OID 88898428)
-- Name: atfs_l_storelookup_bkup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_storelookup_bkup (
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


ALTER TABLE public.atfs_l_storelookup_bkup OWNER TO psql;

--
-- TOC entry 653 (class 1259 OID 81940744)
-- Name: atfs_l_stylecolor_season_cost; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_l_stylecolor_season_cost (
    bbr_stycol_id text,
    design_season_id text,
    elc real,
    stylecolor_status text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.atfs_l_stylecolor_season_cost OWNER TO psql;

--
-- TOC entry 654 (class 1259 OID 81940756)
-- Name: atfs_ma_districtattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_districtattributes (
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


ALTER TABLE public.atfs_ma_districtattributes OWNER TO psql;

--
-- TOC entry 655 (class 1259 OID 81940768)
-- Name: atfs_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_dptflrsetattributes (
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


ALTER TABLE public.atfs_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 656 (class 1259 OID 81940784)
-- Name: atfs_ma_dptflrsetattributes_20250217; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_dptflrsetattributes_20250217 (
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
    default_grade text[],
    default_strclimate text[],
    default_ssg text[],
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
    default_flnrange text[],
    eventdate date,
    version_id bigint,
    created_at timestamp without time zone,
    created_by text,
    updated_at timestamp without time zone,
    updated_by text,
    record_state smallint
);


ALTER TABLE public.atfs_ma_dptflrsetattributes_20250217 OWNER TO psql;

--
-- TOC entry 657 (class 1259 OID 81940789)
-- Name: atfs_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_imgattributes (
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


ALTER TABLE public.atfs_ma_imgattributes OWNER TO psql;

--
-- TOC entry 658 (class 1259 OID 81940801)
-- Name: atfs_ma_imgattributes_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_imgattributes_archive (
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


ALTER TABLE public.atfs_ma_imgattributes_archive OWNER TO psql;

--
-- TOC entry 659 (class 1259 OID 81940814)
-- Name: atfs_ma_imgattributes_backup_20251209; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_imgattributes_backup_20251209 (
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


ALTER TABLE public.atfs_ma_imgattributes_backup_20251209 OWNER TO psql;

--
-- TOC entry 660 (class 1259 OID 81940819)
-- Name: atfs_ma_imgattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_imgattributes_bk (
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


ALTER TABLE public.atfs_ma_imgattributes_bk OWNER TO psql;

--
-- TOC entry 661 (class 1259 OID 81940824)
-- Name: atfs_ma_regionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_regionattributes (
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


ALTER TABLE public.atfs_ma_regionattributes OWNER TO psql;

--
-- TOC entry 662 (class 1259 OID 81940836)
-- Name: atfs_ma_sellingchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_sellingchannelattributes (
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


ALTER TABLE public.atfs_ma_sellingchannelattributes OWNER TO psql;

--
-- TOC entry 663 (class 1259 OID 81940848)
-- Name: atfs_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_sizeattributes (
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


ALTER TABLE public.atfs_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 664 (class 1259 OID 81940861)
-- Name: atfs_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_storeattributes (
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


ALTER TABLE public.atfs_ma_storeattributes OWNER TO psql;

--
-- TOC entry 665 (class 1259 OID 81940873)
-- Name: atfs_ma_storeattributes_lat_long; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_storeattributes_lat_long (
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


ALTER TABLE public.atfs_ma_storeattributes_lat_long OWNER TO psql;

--
-- TOC entry 666 (class 1259 OID 81940885)
-- Name: atfs_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_styleattributes (
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


ALTER TABLE public.atfs_ma_styleattributes OWNER TO psql;

--
-- TOC entry 667 (class 1259 OID 81940899)
-- Name: atfs_ma_styleattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_styleattributes_20251010 (
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


ALTER TABLE public.atfs_ma_styleattributes_20251010 OWNER TO psql;

--
-- TOC entry 668 (class 1259 OID 81940904)
-- Name: atfs_ma_styleattributes_bk20240415; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_styleattributes_bk20240415 (
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


ALTER TABLE public.atfs_ma_styleattributes_bk20240415 OWNER TO psql;

--
-- TOC entry 825 (class 1259 OID 89044227)
-- Name: atfs_ma_styleattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_styleattributes_intraday (
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


ALTER TABLE public.atfs_ma_styleattributes_intraday OWNER TO psql;

--
-- TOC entry 669 (class 1259 OID 81940914)
-- Name: atfs_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes (
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


ALTER TABLE public.atfs_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 670 (class 1259 OID 81940928)
-- Name: atfs_ma_stylecolorattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_20251010 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_20251010 OWNER TO psql;

--
-- TOC entry 671 (class 1259 OID 81940933)
-- Name: atfs_ma_stylecolorattributes_backup_2025_11_11; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_backup_2025_11_11 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_backup_2025_11_11 OWNER TO psql;

--
-- TOC entry 672 (class 1259 OID 81940938)
-- Name: atfs_ma_stylecolorattributes_bk20240415; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_bk20240415 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_bk20240415 OWNER TO psql;

--
-- TOC entry 673 (class 1259 OID 81940943)
-- Name: atfs_ma_stylecolorattributes_bk_20240205; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_bk_20240205 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_bk_20240205 OWNER TO psql;

--
-- TOC entry 674 (class 1259 OID 81940948)
-- Name: atfs_ma_stylecolorattributes_bk_20240306; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_bk_20240306 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_bk_20240306 OWNER TO psql;

--
-- TOC entry 675 (class 1259 OID 81940953)
-- Name: atfs_ma_stylecolorattributes_bk_20250216; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_bk_20250216 (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_bk_20250216 OWNER TO psql;

--
-- TOC entry 676 (class 1259 OID 81940958)
-- Name: atfs_ma_stylecolorattributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_bkp (
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
    cc_use_sys_floorset boolean
);


ALTER TABLE public.atfs_ma_stylecolorattributes_bkp OWNER TO psql;

--
-- TOC entry 826 (class 1259 OID 89044236)
-- Name: atfs_ma_stylecolorattributes_intraday; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorattributes_intraday (
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


ALTER TABLE public.atfs_ma_stylecolorattributes_intraday OWNER TO psql;

--
-- TOC entry 677 (class 1259 OID 81940968)
-- Name: atfs_ma_stylecolorchannelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorchannelattributes (
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
    cc_service_level real DEFAULT 0.8,
    cc_service_level_ecom real DEFAULT 0.95
);


ALTER TABLE public.atfs_ma_stylecolorchannelattributes OWNER TO psql;

--
-- TOC entry 678 (class 1259 OID 81940998)
-- Name: atfs_ma_stylecolorchannelattributes_20251010; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorchannelattributes_20251010 (
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


ALTER TABLE public.atfs_ma_stylecolorchannelattributes_20251010 OWNER TO psql;

--
-- TOC entry 679 (class 1259 OID 81941003)
-- Name: atfs_ma_stylecolorchannelattributes_bk; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorchannelattributes_bk (
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
    ccticketpricechannel_override_txt text
);


ALTER TABLE public.atfs_ma_stylecolorchannelattributes_bk OWNER TO psql;

--
-- TOC entry 680 (class 1259 OID 81941008)
-- Name: atfs_ma_stylecolorfloorsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_stylecolorfloorsetattributes (
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


ALTER TABLE public.atfs_ma_stylecolorfloorsetattributes OWNER TO psql;

--
-- TOC entry 681 (class 1259 OID 81941020)
-- Name: atfs_ma_subclassattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_subclassattributes (
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


ALTER TABLE public.atfs_ma_subclassattributes OWNER TO psql;

--
-- TOC entry 682 (class 1259 OID 81941032)
-- Name: atfs_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_ma_weekattributes (
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


ALTER TABLE public.atfs_ma_weekattributes OWNER TO psql;

--
-- TOC entry 683 (class 1259 OID 81941044)
-- Name: atfs_p_casepack; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_casepack (
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


ALTER TABLE public.atfs_p_casepack OWNER TO psql;

--
-- TOC entry 684 (class 1259 OID 81941056)
-- Name: atfs_p_channeloverride; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_channeloverride (
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


ALTER TABLE public.atfs_p_channeloverride OWNER TO psql;

--
-- TOC entry 685 (class 1259 OID 81941069)
-- Name: atfs_p_dc_adj; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_dc_adj (
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


ALTER TABLE public.atfs_p_dc_adj OWNER TO psql;

--
-- TOC entry 686 (class 1259 OID 81941081)
-- Name: atfs_p_dc_adj_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_dc_adj_size (
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


ALTER TABLE public.atfs_p_dc_adj_size OWNER TO psql;

--
-- TOC entry 687 (class 1259 OID 81941088)
-- Name: atfs_p_dc_adj_size_sup3389; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_dc_adj_size_sup3389 (
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


ALTER TABLE public.atfs_p_dc_adj_size_sup3389 OWNER TO psql;

--
-- TOC entry 688 (class 1259 OID 81941093)
-- Name: atfs_p_itemprice; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_itemprice (
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


ALTER TABLE public.atfs_p_itemprice OWNER TO psql;

--
-- TOC entry 689 (class 1259 OID 81941105)
-- Name: atfs_p_sizemin_by_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_sizemin_by_size (
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


ALTER TABLE public.atfs_p_sizemin_by_size OWNER TO psql;

--
-- TOC entry 690 (class 1259 OID 81941117)
-- Name: atfs_p_strategy_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_strategy_params (
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


ALTER TABLE public.atfs_p_strategy_params OWNER TO psql;

--
-- TOC entry 844 (class 1259 OID 105341142)
-- Name: atfs_p_strategy_params_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_strategy_params_bkp (
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


ALTER TABLE public.atfs_p_strategy_params_bkp OWNER TO psql;

--
-- TOC entry 691 (class 1259 OID 81941136)
-- Name: atfs_p_stylecolor_selling_channel_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_stylecolor_selling_channel_alloc_params (
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


ALTER TABLE public.atfs_p_stylecolor_selling_channel_alloc_params OWNER TO psql;

--
-- TOC entry 692 (class 1259 OID 81941149)
-- Name: atfs_p_stylecolor_store_alloc_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_stylecolor_store_alloc_params (
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


ALTER TABLE public.atfs_p_stylecolor_store_alloc_params OWNER TO psql;

--
-- TOC entry 693 (class 1259 OID 81941162)
-- Name: atfs_p_subclass_channel_floorset_pssr_infomap; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_subclass_channel_floorset_pssr_infomap (
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


ALTER TABLE public.atfs_p_subclass_channel_floorset_pssr_infomap OWNER TO psql;

--
-- TOC entry 694 (class 1259 OID 81941174)
-- Name: atfs_p_target_include_exclude; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_p_target_include_exclude (
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


ALTER TABLE public.atfs_p_target_include_exclude OWNER TO psql;

--
-- TOC entry 695 (class 1259 OID 81941186)
-- Name: atfs_pg_batch_validation; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_pg_batch_validation (
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


ALTER TABLE public.atfs_pg_batch_validation OWNER TO psql;

--
-- TOC entry 696 (class 1259 OID 81941192)
-- Name: atfs_pg_batch_validation_archive; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_pg_batch_validation_archive (
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


ALTER TABLE public.atfs_pg_batch_validation_archive OWNER TO psql;

--
-- TOC entry 697 (class 1259 OID 81941198)
-- Name: atfs_pg_batch_validation_failure; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_pg_batch_validation_failure (
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


ALTER TABLE public.atfs_pg_batch_validation_failure OWNER TO psql;

--
-- TOC entry 698 (class 1259 OID 81941204)
-- Name: atfs_pg_batch_validation_previous; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_pg_batch_validation_previous (
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


ALTER TABLE public.atfs_pg_batch_validation_previous OWNER TO psql;

--
-- TOC entry 699 (class 1259 OID 81941210)
-- Name: atfs_plan_these_cloned_style_stylecolors; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_plan_these_cloned_style_stylecolors (
    style text NOT NULL,
    stylecolor text NOT NULL,
    session_id text NOT NULL,
    updated_by text NOT NULL,
    picked_for_planning integer
);


ALTER TABLE public.atfs_plan_these_cloned_style_stylecolors OWNER TO psql;

--
-- TOC entry 700 (class 1259 OID 81941215)
-- Name: atfs_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_roledimension (
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


ALTER TABLE public.atfs_roledimension OWNER TO psql;

--
-- TOC entry 850 (class 1259 OID 117810782)
-- Name: atfs_rollforward_insert_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_rollforward_insert_a_assortment (
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


ALTER TABLE public.atfs_rollforward_insert_a_assortment OWNER TO psql;

--
-- TOC entry 846 (class 1259 OID 117810569)
-- Name: atfs_rollforward_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_rollforward_items (
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


ALTER TABLE public.atfs_rollforward_items OWNER TO psql;

--
-- TOC entry 849 (class 1259 OID 117810777)
-- Name: atfs_rollforward_max_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_rollforward_max_a_assortment (
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


ALTER TABLE public.atfs_rollforward_max_a_assortment OWNER TO psql;

--
-- TOC entry 848 (class 1259 OID 117810579)
-- Name: atfs_rollforward_missing_floorset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_rollforward_missing_floorset (
    product text,
    location text,
    "time" text
);


ALTER TABLE public.atfs_rollforward_missing_floorset OWNER TO psql;

--
-- TOC entry 847 (class 1259 OID 117810574)
-- Name: atfs_rollforward_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_rollforward_time (
    product text,
    location text,
    indx integer,
    "time" text
);


ALTER TABLE public.atfs_rollforward_time OWNER TO psql;

--
-- TOC entry 701 (class 1259 OID 81941227)
-- Name: atfs_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_servicedefn (
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


ALTER TABLE public.atfs_servicedefn OWNER TO psql;

--
-- TOC entry 702 (class 1259 OID 81941239)
-- Name: atfs_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_serviceparams (
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


ALTER TABLE public.atfs_serviceparams OWNER TO psql;

--
-- TOC entry 703 (class 1259 OID 81941251)
-- Name: atfs_sizemin_cleanup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_sizemin_cleanup (
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


ALTER TABLE public.atfs_sizemin_cleanup OWNER TO psql;

--
-- TOC entry 704 (class 1259 OID 81941256)
-- Name: atfs_sizinglookup; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_sizinglookup (
    sizerange text NOT NULL,
    size text NOT NULL,
    nsp real,
    multiplier real,
    groupsum real,
    strselling_channel text
);


ALTER TABLE public.atfs_sizinglookup OWNER TO psql;

--
-- TOC entry 705 (class 1259 OID 81941261)
-- Name: atfs_specimages; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_specimages (
    product text NOT NULL,
    img text
);


ALTER TABLE public.atfs_specimages OWNER TO psql;

--
-- TOC entry 851 (class 1259 OID 128370742)
-- Name: atfs_specimages_tmp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_specimages_tmp (
    product text,
    img text
);


ALTER TABLE public.atfs_specimages_tmp OWNER TO psql;

--
-- TOC entry 706 (class 1259 OID 81941271)
-- Name: atfs_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.atfs_store_hier_attr AS
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
   FROM (public.atfs_ma_storeattributes a
     LEFT JOIN public.atfs_h_locstd b ON ((a.location = b.id)))
  ORDER BY a.location;


ALTER VIEW public.atfs_store_hier_attr OWNER TO psql;

--
-- TOC entry 707 (class 1259 OID 81941276)
-- Name: atfs_style_clone_stylecolor_size; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_style_clone_stylecolor_size (
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


ALTER TABLE public.atfs_style_clone_stylecolor_size OWNER TO psql;

--
-- TOC entry 708 (class 1259 OID 81941281)
-- Name: atfs_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.atfs_stylecolor_hier_attr AS
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
   FROM public.atfs_ma_stylecolorattributes a,
    public.atfs_h_prodstd b,
    public.atfs_ma_styleattributes c,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS stylecolor_name,
            atfs_d_product.description AS stylecolor_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'stylecolor'::text)) d,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS style_name,
            atfs_d_product.description AS style_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'style'::text)) e,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS subclass_name,
            atfs_d_product.description AS subclass_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'subclass'::text)) g,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS class_name,
            atfs_d_product.description AS class_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'class'::text)) h,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS department_name,
            atfs_d_product.description AS department_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'department'::text)) i,
    ( SELECT atfs_d_product.id,
            atfs_d_product.name AS total_product_name,
            atfs_d_product.description AS total_product_desc
           FROM public.atfs_d_product
          WHERE (atfs_d_product.levelid = 'total_product'::text)) j
  WHERE ((a.product = b.id) AND (b.ancestor0 = c.product) AND (a.product = d.id) AND (b.ancestor0 = e.id) AND (b.ancestor1 = g.id) AND (b.ancestor2 = h.id) AND (b.ancestor3 = i.id) AND (b.ancestor4 = j.id))
  ORDER BY b.id;


ALTER VIEW public.atfs_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 709 (class 1259 OID 81941286)
-- Name: atfs_stylecolor_sizeconcepts; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.atfs_stylecolor_sizeconcepts AS
 SELECT a.product AS stylecolor,
    d.product AS style,
    a.cc_missy_related_stylecolor,
    d.sty_missy_related_style,
    d.sty_size_type,
    b.product AS stylecolorsize
   FROM public.atfs_ma_stylecolorattributes a,
    public.atfs_ma_sizeattributes b,
    public.atfs_h_prodstd c,
    public.atfs_ma_styleattributes d
  WHERE ((a.product = c.id) AND (c.ancestor0 = d.product) AND (a.product = b.parent_id));


ALTER VIEW public.atfs_stylecolor_sizeconcepts OWNER TO psql;

--
-- TOC entry 710 (class 1259 OID 81941291)
-- Name: atfs_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_swatches (
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


ALTER TABLE public.atfs_swatches OWNER TO psql;

--
-- TOC entry 711 (class 1259 OID 81941303)
-- Name: atfs_temp_size_range_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_temp_size_range_mapping (
    prefix text,
    full_size_range text
);


ALTER TABLE public.atfs_temp_size_range_mapping OWNER TO psql;

--
-- TOC entry 712 (class 1259 OID 81941308)
-- Name: atfs_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.atfs_v_memberbasedvalidvalues (
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


ALTER TABLE public.atfs_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 854 (class 1259 OID 128370895)
-- Name: bbr_status_check; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bbr_status_check (
    bbr_stylecolor text,
    bbr_style text,
    validseasons integer
);


ALTER TABLE public.bbr_status_check OWNER TO psql;

--
-- TOC entry 713 (class 1259 OID 81941325)
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
-- TOC entry 714 (class 1259 OID 81941330)
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
-- TOC entry 715 (class 1259 OID 81941335)
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
-- TOC entry 716 (class 1259 OID 81941340)
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
-- TOC entry 717 (class 1259 OID 81941345)
-- Name: bulk_import_run_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bulk_import_run_params (
    run_id integer NOT NULL,
    param text NOT NULL,
    str_value text
);


ALTER TABLE public.bulk_import_run_params OWNER TO psql;

--
-- TOC entry 718 (class 1259 OID 81941350)
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
-- TOC entry 719 (class 1259 OID 81941351)
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
-- TOC entry 720 (class 1259 OID 81941358)
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
-- TOC entry 721 (class 1259 OID 81941365)
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
-- TOC entry 722 (class 1259 OID 81941371)
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
-- TOC entry 723 (class 1259 OID 81941377)
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
-- TOC entry 724 (class 1259 OID 81941384)
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
-- TOC entry 725 (class 1259 OID 81941389)
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
-- TOC entry 726 (class 1259 OID 81941394)
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
-- TOC entry 727 (class 1259 OID 81941399)
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
-- TOC entry 728 (class 1259 OID 81941402)
-- Name: debug_stats_ts; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.debug_stats_ts (
    stat_id text,
    stat text,
    ts timestamp with time zone
);


ALTER TABLE public.debug_stats_ts OWNER TO psql;

--
-- TOC entry 729 (class 1259 OID 81941407)
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
-- TOC entry 730 (class 1259 OID 81941412)
-- Name: default_disc_md; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.default_disc_md (
    class text,
    default_discount numeric(16,4),
    default_md text
);


ALTER TABLE public.default_disc_md OWNER TO psql;

--
-- TOC entry 731 (class 1259 OID 81941417)
-- Name: delete_me_test_corrected_sca_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_corrected_sca_validsizes (
    stylecolor text,
    cc_validsizes_store text[]
);


ALTER TABLE public.delete_me_test_corrected_sca_validsizes OWNER TO psql;

--
-- TOC entry 732 (class 1259 OID 81941422)
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
-- TOC entry 733 (class 1259 OID 81941427)
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
-- TOC entry 734 (class 1259 OID 81941432)
-- Name: delete_me_test_sizeattr; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.delete_me_test_sizeattr (
    stylecolor text,
    stylecolorsize text,
    sizeattribute text
);


ALTER TABLE public.delete_me_test_sizeattr OWNER TO psql;

--
-- TOC entry 735 (class 1259 OID 81941437)
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
-- TOC entry 736 (class 1259 OID 81941442)
-- Name: deleteme_atfs_d_product_20250609; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_d_product_20250609 (
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


ALTER TABLE public.deleteme_atfs_d_product_20250609 OWNER TO psql;

--
-- TOC entry 737 (class 1259 OID 81941447)
-- Name: deleteme_atfs_fix_size_concept_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_fix_size_concept_specstyles (
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


ALTER TABLE public.deleteme_atfs_fix_size_concept_specstyles OWNER TO psql;

--
-- TOC entry 738 (class 1259 OID 81941452)
-- Name: deleteme_atfs_fix_validsizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_fix_validsizes (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    valid_sizes text
);


ALTER TABLE public.deleteme_atfs_fix_validsizes OWNER TO psql;

--
-- TOC entry 739 (class 1259 OID 81941457)
-- Name: deleteme_atfs_fix_validsizes_ecom; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_fix_validsizes_ecom (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    new_cc_validsizes_ecom text
);


ALTER TABLE public.deleteme_atfs_fix_validsizes_ecom OWNER TO psql;

--
-- TOC entry 740 (class 1259 OID 81941462)
-- Name: deleteme_atfs_fix_validsizes_store; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_fix_validsizes_store (
    product text,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    new_cc_validsizes_store text
);


ALTER TABLE public.deleteme_atfs_fix_validsizes_store OWNER TO psql;

--
-- TOC entry 741 (class 1259 OID 81941467)
-- Name: deleteme_atfs_ma_stylecolorattributes_20250502; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_ma_stylecolorattributes_20250502 (
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


ALTER TABLE public.deleteme_atfs_ma_stylecolorattributes_20250502 OWNER TO psql;

--
-- TOC entry 742 (class 1259 OID 81941472)
-- Name: deleteme_atfs_ma_stylecolorattributes_20250601; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_ma_stylecolorattributes_20250601 (
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


ALTER TABLE public.deleteme_atfs_ma_stylecolorattributes_20250601 OWNER TO psql;

--
-- TOC entry 743 (class 1259 OID 81941477)
-- Name: deleteme_atfs_remove_specstyles_from_nonassortment_take2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_atfs_remove_specstyles_from_nonassortment_take2 (
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


ALTER TABLE public.deleteme_atfs_remove_specstyles_from_nonassortment_take2 OWNER TO psql;

--
-- TOC entry 744 (class 1259 OID 81941482)
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
-- TOC entry 745 (class 1259 OID 81941487)
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
-- TOC entry 746 (class 1259 OID 81941492)
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
-- TOC entry 747 (class 1259 OID 81941497)
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
-- TOC entry 748 (class 1259 OID 81941502)
-- Name: deleteme_fix_null_specstyleid; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_fix_null_specstyleid (
    product text,
    name text,
    sty_specstyleid text
);


ALTER TABLE public.deleteme_fix_null_specstyleid OWNER TO psql;

--
-- TOC entry 749 (class 1259 OID 81941507)
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
-- TOC entry 750 (class 1259 OID 81941512)
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
-- TOC entry 751 (class 1259 OID 81941517)
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
-- TOC entry 752 (class 1259 OID 81941522)
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
-- TOC entry 753 (class 1259 OID 81941527)
-- Name: deleteme_missing_floorsetsforpublish; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_missing_floorsetsforpublish (
    product text,
    "time" text
);


ALTER TABLE public.deleteme_missing_floorsetsforpublish OWNER TO psql;

--
-- TOC entry 754 (class 1259 OID 81941532)
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
-- TOC entry 841 (class 1259 OID 105337636)
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
-- TOC entry 840 (class 1259 OID 105337631)
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
-- TOC entry 842 (class 1259 OID 105337641)
-- Name: deleteme_new_size_concepts_in_assortment_step2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_new_size_concepts_in_assortment_step2 (
    product text,
    sty_size_type text,
    new_size_concepts_in_assortment text[]
);


ALTER TABLE public.deleteme_new_size_concepts_in_assortment_step2 OWNER TO psql;

--
-- TOC entry 755 (class 1259 OID 81941552)
-- Name: deleteme_replan_sku_20250715; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_replan_sku_20250715 (
    brand_identifier text,
    sku_id text,
    product text
);


ALTER TABLE public.deleteme_replan_sku_20250715 OWNER TO psql;

--
-- TOC entry 756 (class 1259 OID 81941558)
-- Name: deleteme_sup_3858_fix_bad_sizes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_sup_3858_fix_bad_sizes (
    parent_id text,
    product text,
    sizeattribute text,
    isvalid integer,
    cc_validsizes_store text[],
    cc_validsizes_ecom text[],
    record_state smallint
);


ALTER TABLE public.deleteme_sup_3858_fix_bad_sizes OWNER TO psql;

--
-- TOC entry 757 (class 1259 OID 81941565)
-- Name: deleteme_validsizes_604; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.deleteme_validsizes_604 (
    sty_size_range text,
    validsize text,
    store_ecom text
);


ALTER TABLE public.deleteme_validsizes_604 OWNER TO psql;

--
-- TOC entry 758 (class 1259 OID 81941570)
-- Name: dept_plan_item_conversion; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_item_conversion (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_item_conversion OWNER TO psql;

--
-- TOC entry 759 (class 1259 OID 81941575)
-- Name: dept_plan_items; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items OWNER TO psql;

--
-- TOC entry 760 (class 1259 OID 81941580)
-- Name: dept_plan_items_active; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_active (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_active OWNER TO psql;

--
-- TOC entry 761 (class 1259 OID 81941585)
-- Name: dept_plan_items_daily; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_daily (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_daily OWNER TO psql;

--
-- TOC entry 843 (class 1259 OID 105340985)
-- Name: dept_plan_items_temp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.dept_plan_items_temp (
    product text,
    location text,
    department text
);


ALTER TABLE public.dept_plan_items_temp OWNER TO psql;

--
-- TOC entry 762 (class 1259 OID 81941595)
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
-- TOC entry 763 (class 1259 OID 81941603)
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
-- TOC entry 764 (class 1259 OID 81941610)
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
-- TOC entry 765 (class 1259 OID 81941615)
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
-- TOC entry 766 (class 1259 OID 81941620)
-- Name: floorset_week_mapping; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.floorset_week_mapping (
    product text,
    floorset text,
    ap_start text,
    ap_end text,
    "time" text
);


ALTER TABLE public.floorset_week_mapping OWNER TO psql;

--
-- TOC entry 767 (class 1259 OID 81941625)
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
-- TOC entry 768 (class 1259 OID 81941630)
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
-- TOC entry 769 (class 1259 OID 81941635)
-- Name: missed_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.missed_products (
    product text
);


ALTER TABLE public.missed_products OWNER TO psql;

--
-- TOC entry 833 (class 1259 OID 105337365)
-- Name: modified_atfs_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.modified_atfs_h_timeflrset (
    id text,
    ancestor0 character varying(200),
    ancestor1 text
);


ALTER TABLE public.modified_atfs_h_timeflrset OWNER TO psql;

--
-- TOC entry 770 (class 1259 OID 81941645)
-- Name: perf_assortperiod_week; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.perf_assortperiod_week AS
 SELECT a.product,
    a."time",
    b.id AS week,
    b.indx AS week_indx
   FROM ( SELECT atfs_ma_dptflrsetattributes.product,
            atfs_ma_dptflrsetattributes."time",
            atfs_ma_dptflrsetattributes.ap_start,
            atfs_ma_dptflrsetattributes.ap_end
           FROM public.atfs_ma_dptflrsetattributes) a,
    public.atfs_d_time b
  WHERE ((b.levelid = ('week'::character varying(4))::text) AND (b.id >= a.ap_start) AND (b.id <= a.ap_end));


ALTER VIEW public.perf_assortperiod_week OWNER TO psql;

--
-- TOC entry 771 (class 1259 OID 81941650)
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
-- TOC entry 772 (class 1259 OID 81941655)
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
-- TOC entry 773 (class 1259 OID 81941661)
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
-- TOC entry 774 (class 1259 OID 81941667)
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
-- TOC entry 775 (class 1259 OID 81941676)
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
-- TOC entry 845 (class 1259 OID 105349363)
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
-- TOC entry 776 (class 1259 OID 81941686)
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
-- TOC entry 777 (class 1259 OID 81941690)
-- Name: pricing_table; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.pricing_table (
    t_expression text,
    v_cccurp real
);


ALTER TABLE public.pricing_table OWNER TO psql;

--
-- TOC entry 852 (class 1259 OID 128370750)
-- Name: replannable_products; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.replannable_products (
    member_id text
);


ALTER TABLE public.replannable_products OWNER TO psql;

--
-- TOC entry 823 (class 1259 OID 83580063)
-- Name: s5_analytics_inseason_sls_rnk_transposed; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_analytics_inseason_sls_rnk_transposed (
    stylecolor text,
    act_slsrnk_store real,
    act_slsrnk_ecom real
);


ALTER TABLE public.s5_analytics_inseason_sls_rnk_transposed OWNER TO psql;

--
-- TOC entry 778 (class 1259 OID 81941705)
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
-- TOC entry 779 (class 1259 OID 81941710)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 780 (class 1259 OID 81941715)
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
-- TOC entry 781 (class 1259 OID 81941724)
-- Name: size_ids; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.size_ids (
    size_name text,
    size_id text
);


ALTER TABLE public.size_ids OWNER TO psql;

--
-- TOC entry 782 (class 1259 OID 81941729)
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
-- TOC entry 855 (class 1259 OID 139660427)
-- Name: sync_dataqueue_deletes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_dataqueue_deletes (
    product text,
    "time" text,
    publish_type text
);


ALTER TABLE public.sync_dataqueue_deletes OWNER TO psql;

--
-- TOC entry 783 (class 1259 OID 81941735)
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
-- TOC entry 784 (class 1259 OID 81941742)
-- Name: sync_outbound_delta; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_outbound_delta (
    sync_start timestamp without time zone,
    sync_end timestamp without time zone
);


ALTER TABLE public.sync_outbound_delta OWNER TO psql;

--
-- TOC entry 785 (class 1259 OID 81941745)
-- Name: sync_reset_specstyles; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_reset_specstyles (
    product text
);


ALTER TABLE public.sync_reset_specstyles OWNER TO psql;

--
-- TOC entry 786 (class 1259 OID 81941750)
-- Name: sync_stylecolorchannel; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.sync_stylecolorchannel (
    product text
);


ALTER TABLE public.sync_stylecolorchannel OWNER TO psql;

--
-- TOC entry 787 (class 1259 OID 81941755)
-- Name: temp1_atfs_c_week1; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_atfs_c_week1 (
    week text,
    week_minus_1 text
);


ALTER TABLE public.temp1_atfs_c_week1 OWNER TO psql;

--
-- TOC entry 788 (class 1259 OID 81941760)
-- Name: temp1_atfs_c_week2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_atfs_c_week2 (
    week text,
    week_minus_2 text
);


ALTER TABLE public.temp1_atfs_c_week2 OWNER TO psql;

--
-- TOC entry 789 (class 1259 OID 81941765)
-- Name: temp1_atfs_c_week6; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp1_atfs_c_week6 (
    week text,
    week_minus_6 text
);


ALTER TABLE public.temp1_atfs_c_week6 OWNER TO psql;

--
-- TOC entry 836 (class 1259 OID 105337432)
-- Name: temp_atfs_corpdisc; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_atfs_corpdisc (
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


ALTER TABLE public.temp_atfs_corpdisc OWNER TO psql;

--
-- TOC entry 835 (class 1259 OID 105337423)
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
-- TOC entry 790 (class 1259 OID 81941784)
-- Name: temp_plan_queue; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.temp_plan_queue (
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


ALTER TABLE public.temp_plan_queue OWNER TO psql;

--
-- TOC entry 853 (class 1259 OID 128370882)
-- Name: tmp_atfs_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tmp_atfs_v_memberbasedvalidvalues (
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


ALTER TABLE public.tmp_atfs_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 791 (class 1259 OID 81941794)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 792 (class 1259 OID 81941799)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 793 (class 1259 OID 81941804)
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
-- TOC entry 794 (class 1259 OID 81941812)
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
-- TOC entry 795 (class 1259 OID 81941817)
-- Name: unnested_sca; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.unnested_sca AS
 SELECT atfs_ma_stylecolorchannelattributes.product,
    atfs_ma_stylecolorchannelattributes.ccrangecode,
    unnest(atfs_ma_stylecolorchannelattributes.cc_validsizes_store) AS cc_validsizes_store,
    unnest(atfs_ma_stylecolorchannelattributes.cc_validsizes_ecom) AS cc_validsizes_ecom
   FROM public.atfs_ma_stylecolorchannelattributes;


ALTER VIEW public.unnested_sca OWNER TO psql;

--
-- TOC entry 796 (class 1259 OID 81941821)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 797 (class 1259 OID 81941826)
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
-- TOC entry 798 (class 1259 OID 81941838)
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
-- TOC entry 799 (class 1259 OID 81941846)
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
-- TOC entry 800 (class 1259 OID 81941851)
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
-- TOC entry 801 (class 1259 OID 81941856)
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
-- TOC entry 802 (class 1259 OID 81941861)
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
-- TOC entry 829 (class 1259 OID 89832258)
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
-- TOC entry 828 (class 1259 OID 89832253)
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
-- TOC entry 827 (class 1259 OID 89832248)
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
-- TOC entry 830 (class 1259 OID 89832262)
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
-- TOC entry 803 (class 1259 OID 81941887)
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
-- TOC entry 804 (class 1259 OID 81941893)
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
-- TOC entry 805 (class 1259 OID 81941899)
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
-- TOC entry 806 (class 1259 OID 81941904)
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
-- TOC entry 807 (class 1259 OID 81941909)
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
-- TOC entry 808 (class 1259 OID 81941914)
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
-- TOC entry 821 (class 1259 OID 82394852)
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
-- TOC entry 809 (class 1259 OID 81941919)
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
-- TOC entry 810 (class 1259 OID 81941925)
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
-- TOC entry 822 (class 1259 OID 82394861)
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
-- TOC entry 811 (class 1259 OID 81941930)
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
-- TOC entry 812 (class 1259 OID 81941931)
-- Name: plan_init_status; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE target_setting.plan_init_status OWNER TO psql;

--
-- TOC entry 813 (class 1259 OID 81941934)
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
-- TOC entry 814 (class 1259 OID 81941943)
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
-- TOC entry 831 (class 1259 OID 89832269)
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
-- TOC entry 815 (class 1259 OID 81941955)
-- Name: tyly; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE target_setting.tyly OWNER TO psql;

--
-- TOC entry 816 (class 1259 OID 81941960)
-- Name: tyly_done_prev; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.tyly_done_prev (
    ty text,
    ly text
);


ALTER TABLE target_setting.tyly_done_prev OWNER TO psql;

--
-- TOC entry 817 (class 1259 OID 81941965)
-- Name: user_kv_store; Type: TABLE; Schema: target_setting; Owner: psql
--

CREATE TABLE target_setting.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE target_setting.user_kv_store OWNER TO psql;

--
-- TOC entry 818 (class 1259 OID 81941970)
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
-- TOC entry 6252 (class 2606 OID 82000207)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 6250 (class 2606 OID 82000193)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 6089 (class 2606 OID 81942273)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 6091 (class 2606 OID 81942275)
-- Name: assort_period_from_dpt assort_period_from_dpt_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.assort_period_from_dpt
    ADD CONSTRAINT assort_period_from_dpt_pkey PRIMARY KEY (department, "time");


--
-- TOC entry 6093 (class 2606 OID 81942277)
-- Name: atfs_a_assortment atfs_a_assortment_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_a_assortment
    ADD CONSTRAINT atfs_a_assortment_2_pkey PRIMARY KEY (product, "time", location, plan_type);


--
-- TOC entry 6095 (class 2606 OID 81942279)
-- Name: atfs_an_price_storecount_info atfs_an_price_storecount_info_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_an_price_storecount_info
    ADD CONSTRAINT atfs_an_price_storecount_info_pkey PRIMARY KEY (product, "time", channel, selling_channel);


--
-- TOC entry 6097 (class 2606 OID 81942281)
-- Name: atfs_authorization atfs_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_authorization
    ADD CONSTRAINT atfs_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 6101 (class 2606 OID 81942283)
-- Name: atfs_d_cluster atfs_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_d_cluster
    ADD CONSTRAINT atfs_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 6103 (class 2606 OID 81942285)
-- Name: atfs_d_location atfs_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_d_location
    ADD CONSTRAINT atfs_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 6105 (class 2606 OID 81942287)
-- Name: atfs_d_prodlife atfs_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_d_prodlife
    ADD CONSTRAINT atfs_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 6107 (class 2606 OID 81942289)
-- Name: atfs_d_product atfs_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_d_product
    ADD CONSTRAINT atfs_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 6110 (class 2606 OID 81942300)
-- Name: atfs_d_time atfs_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_d_time
    ADD CONSTRAINT atfs_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 6115 (class 2606 OID 81942302)
-- Name: atfs_h_clusterstd atfs_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_clusterstd
    ADD CONSTRAINT atfs_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 6117 (class 2606 OID 81942304)
-- Name: atfs_h_locdc atfs_h_locdc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_locdc
    ADD CONSTRAINT atfs_h_locdc_pkey PRIMARY KEY (id);


--
-- TOC entry 6119 (class 2606 OID 81942306)
-- Name: atfs_h_locdcstd atfs_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_locdcstd
    ADD CONSTRAINT atfs_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 6121 (class 2606 OID 81942308)
-- Name: atfs_h_locstd atfs_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_locstd
    ADD CONSTRAINT atfs_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 6123 (class 2606 OID 81942310)
-- Name: atfs_h_prodlifestd atfs_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_prodlifestd
    ADD CONSTRAINT atfs_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 6125 (class 2606 OID 81942312)
-- Name: atfs_h_prodstd atfs_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_prodstd
    ADD CONSTRAINT atfs_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 6113 (class 2606 OID 81942320)
-- Name: atfs_h_timeflrset atfs_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_timeflrset
    ADD CONSTRAINT atfs_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 6137 (class 2606 OID 81942322)
-- Name: atfs_h_timestd atfs_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_h_timestd
    ADD CONSTRAINT atfs_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 6099 (class 2606 OID 81942324)
-- Name: atfs_corpdisc atfs_l_corpdisc_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_corpdisc
    ADD CONSTRAINT atfs_l_corpdisc_pkey PRIMARY KEY (department, product, location, "time", prodlife);


--
-- TOC entry 6139 (class 2606 OID 81942326)
-- Name: atfs_l_dclookup atfs_l_dclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_dclookup
    ADD CONSTRAINT atfs_l_dclookup_pkey PRIMARY KEY (channel, dc);


--
-- TOC entry 6142 (class 2606 OID 81942328)
-- Name: atfs_l_priceeventlookup atfs_l_priceeventlookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_priceeventlookup
    ADD CONSTRAINT atfs_l_priceeventlookup_pkey PRIMARY KEY (product, location, ccpriceevent);


--
-- TOC entry 6195 (class 2606 OID 81942330)
-- Name: atfs_sizinglookup atfs_l_sizinglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_sizinglookup
    ADD CONSTRAINT atfs_l_sizinglookup_pkey UNIQUE (sizerange, size, strselling_channel);


--
-- TOC entry 6144 (class 2606 OID 81942332)
-- Name: atfs_l_ssglookup atfs_l_ssglookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_ssglookup
    ADD CONSTRAINT atfs_l_ssglookup_pkey PRIMARY KEY (product, location, ssg_id);


--
-- TOC entry 6146 (class 2606 OID 81942334)
-- Name: atfs_l_storedclookup atfs_l_storedclookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_storedclookup
    ADD CONSTRAINT atfs_l_storedclookup_pkey PRIMARY KEY (store, dc, priority);


--
-- TOC entry 6254 (class 2606 OID 88898443)
-- Name: atfs_l_storelookup_bkup atfs_l_storelookup_bkup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_storelookup_bkup
    ADD CONSTRAINT atfs_l_storelookup_bkup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 6148 (class 2606 OID 81942336)
-- Name: atfs_l_storelookup atfs_l_storelookup_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_storelookup
    ADD CONSTRAINT atfs_l_storelookup_pkey PRIMARY KEY ("time", product, id, value);


--
-- TOC entry 6150 (class 2606 OID 81942344)
-- Name: atfs_ma_dptflrsetattributes atfs_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_dptflrsetattributes
    ADD CONSTRAINT atfs_ma_dptflrsetattributes_pkey PRIMARY KEY (indx);


--
-- TOC entry 6152 (class 2606 OID 81942346)
-- Name: atfs_ma_imgattributes atfs_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_imgattributes
    ADD CONSTRAINT atfs_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6154 (class 2606 OID 81942348)
-- Name: atfs_ma_sizeattributes atfs_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_sizeattributes
    ADD CONSTRAINT atfs_ma_sizeattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6156 (class 2606 OID 81942350)
-- Name: atfs_ma_storeattributes atfs_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_storeattributes
    ADD CONSTRAINT atfs_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 6158 (class 2606 OID 81942352)
-- Name: atfs_ma_styleattributes atfs_ma_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_styleattributes
    ADD CONSTRAINT atfs_ma_styleattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6160 (class 2606 OID 81942360)
-- Name: atfs_ma_stylecolorattributes atfs_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_stylecolorattributes
    ADD CONSTRAINT atfs_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6162 (class 2606 OID 81942362)
-- Name: atfs_ma_stylecolorchannelattributes atfs_ma_stylecolorchannelattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_stylecolorchannelattributes
    ADD CONSTRAINT atfs_ma_stylecolorchannelattributes_2_pkey PRIMARY KEY (product, location);


--
-- TOC entry 6164 (class 2606 OID 81942364)
-- Name: atfs_ma_stylecolorfloorsetattributes atfs_ma_stylecolorfloorsetattributes_2_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_stylecolorfloorsetattributes
    ADD CONSTRAINT atfs_ma_stylecolorfloorsetattributes_2_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 6166 (class 2606 OID 81942367)
-- Name: atfs_ma_subclassattributes atfs_ma_subclassattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_subclassattributes
    ADD CONSTRAINT atfs_ma_subclassattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 6168 (class 2606 OID 81942369)
-- Name: atfs_ma_weekattributes atfs_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_ma_weekattributes
    ADD CONSTRAINT atfs_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 6170 (class 2606 OID 81942371)
-- Name: atfs_p_casepack atfs_p_casepack_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_casepack
    ADD CONSTRAINT atfs_p_casepack_pkey PRIMARY KEY (product, location, "time", case_pack_id);


--
-- TOC entry 6172 (class 2606 OID 81942373)
-- Name: atfs_p_channeloverride atfs_p_channeloverride_pkey1; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_channeloverride
    ADD CONSTRAINT atfs_p_channeloverride_pkey1 PRIMARY KEY (product, location, "time");


--
-- TOC entry 6174 (class 2606 OID 81942375)
-- Name: atfs_p_dc_adj atfs_p_dc_adj_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_dc_adj
    ADD CONSTRAINT atfs_p_dc_adj_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 6176 (class 2606 OID 81942380)
-- Name: atfs_p_dc_adj_size atfs_p_dc_adj_size_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_dc_adj_size
    ADD CONSTRAINT atfs_p_dc_adj_size_pk UNIQUE (product, location, "time");


--
-- TOC entry 6178 (class 2606 OID 81942382)
-- Name: atfs_p_itemprice atfs_p_itemprice_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_itemprice
    ADD CONSTRAINT atfs_p_itemprice_pkey PRIMARY KEY (product, location, "time");


--
-- TOC entry 6180 (class 2606 OID 81942384)
-- Name: atfs_p_sizemin_by_size atfs_p_sizemin_by_size_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_sizemin_by_size
    ADD CONSTRAINT atfs_p_sizemin_by_size_pkey PRIMARY KEY (product);


--
-- TOC entry 6184 (class 2606 OID 81942386)
-- Name: atfs_p_stylecolor_selling_channel_alloc_params atfs_p_stylecolor_selling_channel_alloc_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_stylecolor_selling_channel_alloc_params
    ADD CONSTRAINT atfs_p_stylecolor_selling_channel_alloc_params_pkey PRIMARY KEY (product, location);


--
-- TOC entry 6186 (class 2606 OID 81942388)
-- Name: atfs_p_stylecolor_store_alloc_params atfs_p_stylecolor_store_alloc_params_okey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_stylecolor_store_alloc_params
    ADD CONSTRAINT atfs_p_stylecolor_store_alloc_params_okey PRIMARY KEY (product, location);


--
-- TOC entry 6188 (class 2606 OID 81942390)
-- Name: atfs_p_subclass_channel_floorset_pssr_infomap atfs_p_subclass_channel_floorset_pssr_infomap_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_subclass_channel_floorset_pssr_infomap
    ADD CONSTRAINT atfs_p_subclass_channel_floorset_pssr_infomap_pkey PRIMARY KEY (product, "time", location, pssr_key);


--
-- TOC entry 6190 (class 2606 OID 81942392)
-- Name: atfs_p_target_include_exclude atfs_p_target_include_exclude_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_target_include_exclude
    ADD CONSTRAINT atfs_p_target_include_exclude_pkey PRIMARY KEY (product, "time", ly_lly_key);


--
-- TOC entry 6193 (class 2606 OID 81942394)
-- Name: atfs_roledimension atfs_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_roledimension
    ADD CONSTRAINT atfs_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 6259 (class 2606 OID 105337344)
-- Name: atfs_l_size_range_validsize_defaults atfs_size_range_validsize_defaults_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_l_size_range_validsize_defaults
    ADD CONSTRAINT atfs_size_range_validsize_defaults_pkey PRIMARY KEY (class, size_range);


--
-- TOC entry 6197 (class 2606 OID 81942398)
-- Name: atfs_specimages atfs_specimages_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_specimages
    ADD CONSTRAINT atfs_specimages_pkey PRIMARY KEY (product);


--
-- TOC entry 6200 (class 2606 OID 81942400)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 6202 (class 2606 OID 81942402)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 6204 (class 2606 OID 81942404)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 6206 (class 2606 OID 81942406)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 6211 (class 2606 OID 81942408)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 6213 (class 2606 OID 81942410)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 6215 (class 2606 OID 81942412)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 6217 (class 2606 OID 81942414)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 6182 (class 2606 OID 81942416)
-- Name: atfs_p_strategy_params strategy_params_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.atfs_p_strategy_params
    ADD CONSTRAINT strategy_params_pkey PRIMARY KEY (product, location, floorset_uda);


--
-- TOC entry 6208 (class 2606 OID 81942418)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 6220 (class 2606 OID 81942420)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 6222 (class 2606 OID 81942422)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 6224 (class 2606 OID 81942424)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 6226 (class 2606 OID 81942426)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 6235 (class 2606 OID 81942428)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 6229 (class 2606 OID 81942430)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 6231 (class 2606 OID 81942432)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 6233 (class 2606 OID 81942434)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 6237 (class 2606 OID 81942436)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 6240 (class 2606 OID 81942438)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 6242 (class 2606 OID 81942440)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 6244 (class 2606 OID 81942442)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 6246 (class 2606 OID 81942444)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 6248 (class 2606 OID 81942446)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 6111 (class 1259 OID 81942447)
-- Name: atfs_eohdata_stylecolor_product_channel_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX atfs_eohdata_stylecolor_product_channel_idx ON public.atfs_eohdata_stylecolor USING btree (product, channel);


--
-- TOC entry 6126 (class 1259 OID 81942448)
-- Name: atfs_locstd_ances0_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_locstd_ances0_str_indx ON public.atfs_h_prodstd USING btree (ancestor0);


--
-- TOC entry 6127 (class 1259 OID 81942452)
-- Name: atfs_locstd_ances1_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_locstd_ances1_str_indx ON public.atfs_h_prodstd USING btree (ancestor1);


--
-- TOC entry 6128 (class 1259 OID 81942463)
-- Name: atfs_locstd_ances2_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_locstd_ances2_str_indx ON public.atfs_h_prodstd USING btree (ancestor2);


--
-- TOC entry 6129 (class 1259 OID 81942467)
-- Name: atfs_locstd_ances3_str_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_locstd_ances3_str_indx ON public.atfs_h_prodstd USING btree (ancestor3);


--
-- TOC entry 6191 (class 1259 OID 81942468)
-- Name: atfs_plan_these_cloned_style_stylecolors_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_plan_these_cloned_style_stylecolors_session_id_idx ON public.atfs_plan_these_cloned_style_stylecolors USING btree (session_id);


--
-- TOC entry 6130 (class 1259 OID 81942469)
-- Name: atfs_prodstd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances0_indx ON public.atfs_h_prodstd USING btree (ancestor0);


--
-- TOC entry 6131 (class 1259 OID 81942485)
-- Name: atfs_prodstd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances1_indx ON public.atfs_h_prodstd USING btree (ancestor1);


--
-- TOC entry 6132 (class 1259 OID 81942486)
-- Name: atfs_prodstd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances2_indx ON public.atfs_h_prodstd USING btree (ancestor2);


--
-- TOC entry 6133 (class 1259 OID 81942511)
-- Name: atfs_prodstd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances3_indx ON public.atfs_h_prodstd USING btree (ancestor3);


--
-- TOC entry 6134 (class 1259 OID 81942519)
-- Name: atfs_prodstd_ances4_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances4_indx ON public.atfs_h_prodstd USING btree (ancestor4);


--
-- TOC entry 6135 (class 1259 OID 81942520)
-- Name: atfs_prodstd_ances5_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_prodstd_ances5_indx ON public.atfs_h_prodstd USING btree (ancestor5);


--
-- TOC entry 6108 (class 1259 OID 81942525)
-- Name: atfs_product_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_product_levelid_indx ON public.atfs_d_product USING btree (levelid);


--
-- TOC entry 6198 (class 1259 OID 81942532)
-- Name: atfs_style_clone_stylecolor_size_session_id_idx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX atfs_style_clone_stylecolor_size_session_id_idx ON public.atfs_style_clone_stylecolor_size USING btree (session_id);


--
-- TOC entry 6140 (class 1259 OID 81942533)
-- Name: ldl_lookuptarget; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX ldl_lookuptarget ON public.atfs_l_dependencylookup USING btree (lookup_id, lookup_value, target_id);


--
-- TOC entry 6209 (class 1259 OID 81942534)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 6218 (class 1259 OID 81942535)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 6255 (class 1259 OID 89832276)
-- Name: actuals_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_denorm_target_setting ON target_setting.actuals_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 6256 (class 1259 OID 89832278)
-- Name: actuals_wide_denorm_unique_concurrent; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE UNIQUE INDEX actuals_wide_denorm_unique_concurrent ON target_setting.actuals_wide_denorm USING btree ("time", product, location);


--
-- TOC entry 6227 (class 1259 OID 81942537)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON target_setting.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 6238 (class 1259 OID 81942538)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON target_setting.plan_data_wide USING hash (id);


--
-- TOC entry 6257 (class 1259 OID 89832277)
-- Name: sys_gen_wide_denorm_target_setting; Type: INDEX; Schema: target_setting; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_target_setting ON target_setting.sys_gen_wide_denorm USING btree (time_quarter, product_department, location_channel);


--
-- TOC entry 6301 (class 2620 OID 81942540)
-- Name: atfs_ma_stylecolorchannelattributes ca_1_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER ca_1_trigger_on_update AFTER UPDATE OF dbt_wk, relaunchweek, exitdate ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.store_eligibility_trigger();


--
-- TOC entry 6291 (class 2620 OID 81942541)
-- Name: atfs_ma_stylecolorattributes cc_add_size_concept_to_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_add_size_concept_to_assortment AFTER UPDATE OF cc_size_concepts_in_assortment ON public.atfs_ma_stylecolorattributes FOR EACH ROW WHEN (((cardinality(new.cc_size_concepts_in_assortment) > cardinality(old.cc_size_concepts_in_assortment)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.add_size_concepts_to_assortment();


--
-- TOC entry 6292 (class 2620 OID 81942542)
-- Name: atfs_ma_stylecolorattributes cc_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_copy_master_attributes AFTER UPDATE OF cc_color_name, cc_ppns, cc_novelty_details, cc_print_description, cc_matchbacks, cc_free_one, cc_free_two, cc_free_three, cc_known, cc_collection, cc_preview, cc_marketing_flag, cc_promotion_flag, cc_table, cc_internet_tall_style, cc_price_band, cc_good_better_best, cc_lifecycle, cc_fabric_description, cc_primary_selling, cc_online_exclusive_flag, cc_delivery_month, cc_delivery_name, cc_storeset, cc_season, cc_print_pattern_type ON public.atfs_ma_stylecolorattributes FOR EACH ROW WHEN ((new.cc_missy_related_stylecolor = new.product)) EXECUTE FUNCTION public.cc_copy_master_attributes();


--
-- TOC entry 6293 (class 2620 OID 81942543)
-- Name: atfs_ma_stylecolorattributes cc_remove_size_concept_from_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER cc_remove_size_concept_from_assortment BEFORE UPDATE OF cc_size_concepts_in_assortment ON public.atfs_ma_stylecolorattributes FOR EACH ROW WHEN (((cardinality(new.cc_size_concepts_in_assortment) < cardinality(old.cc_size_concepts_in_assortment)) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.remove_size_concepts_from_assortment();


--
-- TOC entry 6302 (class 2620 OID 81942544)
-- Name: atfs_ma_stylecolorchannelattributes dbt_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER dbt_trigger_on_update AFTER UPDATE OF dbt_wk ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.dbt_wk >= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.dbt_wk < old.plan_current))) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.dbt_after_md_trigger_on_update_validity_check();


--
-- TOC entry 6335 (class 2620 OID 81942545)
-- Name: plan_queue delete_duplicate_invalids_on_plan_queue; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER delete_duplicate_invalids_on_plan_queue AFTER INSERT ON public.plan_queue FOR EACH ROW EXECUTE FUNCTION public.delete_duplicate_invalids();


--
-- TOC entry 6303 (class 2620 OID 81942546)
-- Name: atfs_ma_stylecolorchannelattributes exit_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER exit_trigger_on_update AFTER UPDATE OF exitdate ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (old.exitdate < old.plan_current)))) OR ((new.relaunchweek IS NOT NULL) AND ((new.exitdate <= new.erlstmkdnwk) OR ((old.cloned_at IS NULL) AND (new.exitdate < old.plan_current))) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION public.exit_trigger_on_update_validity_check();


--
-- TOC entry 6304 (class 2620 OID 81942547)
-- Name: atfs_ma_stylecolorchannelattributes md_trigger_on_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER md_trigger_on_update AFTER UPDATE OF erlstmkdnwk ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((((new.relaunchweek IS NULL) AND ((new.erlstmkdnwk <= new.dbt_wk) OR ((old.cloned_at IS NULL) AND (old.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)) OR ((new.relaunchweek IS NOT NULL) AND ((new.erlstmkdnwk <= new.relaunchweek) OR ((old.cloned_at IS NULL) AND (new.erlstmkdnwk < old.plan_current)) OR (new.exitdate <= new.erlstmkdnwk)) AND (pg_trigger_depth() = 0)))) EXECUTE FUNCTION public.md_trigger_on_update_validity_check();


--
-- TOC entry 6334 (class 2620 OID 81942548)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 6336 (class 2620 OID 81942549)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 6337 (class 2620 OID 81942550)
-- Name: plan_queue remove_product_from_queue; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER remove_product_from_queue BEFORE INSERT ON public.plan_queue FOR EACH ROW EXECUTE FUNCTION public.remove_product_from_queue();


--
-- TOC entry 6320 (class 2620 OID 81942551)
-- Name: atfs_p_dc_adj set_dc_adjcost_ecom; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_dc_adjcost_ecom AFTER UPDATE OF dc_adjcost ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_dcadjcost_ecom();


--
-- TOC entry 6332 (class 2620 OID 81942552)
-- Name: atfs_v_memberbasedvalidvalues set_mvv_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_mvv_indx BEFORE INSERT ON public.atfs_v_memberbasedvalidvalues FOR EACH ROW EXECUTE FUNCTION public.trigger_set_indx_valid_values();


--
-- TOC entry 6321 (class 2620 OID 81942553)
-- Name: atfs_p_dc_adj set_pack_ind_flag; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_pack_ind_flag BEFORE INSERT OR UPDATE ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_pack_ind_flag();

ALTER TABLE public.atfs_p_dc_adj DISABLE TRIGGER set_pack_ind_flag;


--
-- TOC entry 6276 (class 2620 OID 81942554)
-- Name: atfs_a_assortment set_timestamp_a_assortment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_a_assortment BEFORE UPDATE ON public.atfs_a_assortment FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6317 (class 2620 OID 81942555)
-- Name: atfs_p_casepack set_timestamp_cp_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish BEFORE UPDATE OF po_status ON public.atfs_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 6318 (class 2620 OID 81942556)
-- Name: atfs_p_casepack set_timestamp_cp_publish_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_cp_publish_ins BEFORE INSERT ON public.atfs_p_casepack FOR EACH ROW EXECUTE FUNCTION public.trigger_set_cp_publish_timestamp();


--
-- TOC entry 6284 (class 2620 OID 81942557)
-- Name: atfs_ma_imgattributes set_timestamp_imgattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_imgattributes BEFORE UPDATE ON public.atfs_ma_imgattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6319 (class 2620 OID 81942558)
-- Name: atfs_p_channeloverride set_timestamp_p_channeloverride; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_channeloverride BEFORE UPDATE ON public.atfs_p_channeloverride FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6322 (class 2620 OID 81942559)
-- Name: atfs_p_dc_adj set_timestamp_p_dc_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj BEFORE UPDATE ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6326 (class 2620 OID 81942560)
-- Name: atfs_p_dc_adj_size set_timestamp_p_dc_adj_size; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_adj_size BEFORE UPDATE ON public.atfs_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6323 (class 2620 OID 81942561)
-- Name: atfs_p_dc_adj set_timestamp_p_dc_publish_adj; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj BEFORE UPDATE OF dc_publish ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 6324 (class 2620 OID 81942562)
-- Name: atfs_p_dc_adj set_timestamp_p_dc_publish_adj_ins; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_p_dc_publish_adj_ins BEFORE INSERT ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.trigger_set_publish_timestamp();


--
-- TOC entry 6285 (class 2620 OID 81942563)
-- Name: atfs_ma_sizeattributes set_timestamp_sizeattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_sizeattr BEFORE UPDATE ON public.atfs_ma_sizeattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6286 (class 2620 OID 81942564)
-- Name: atfs_ma_styleattributes set_timestamp_styleattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleattr BEFORE UPDATE ON public.atfs_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6305 (class 2620 OID 81942565)
-- Name: atfs_ma_stylecolorchannelattributes set_timestamp_styleclrchannel; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_styleclrchannel BEFORE UPDATE ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6294 (class 2620 OID 81942566)
-- Name: atfs_ma_stylecolorattributes set_timestamp_stylecolorattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER set_timestamp_stylecolorattr BEFORE UPDATE ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- TOC entry 6287 (class 2620 OID 81942567)
-- Name: atfs_ma_styleattributes sty_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER sty_copy_master_attributes AFTER UPDATE OF sty_mfp_program_id, sty_pyramid_lens, sty_end_use, sty_silhouette, sty_program_id, sty_shape, sty_length, sty_placement, sty_neckline, sty_sleeve_length, sty_fit, sty_type, sty_hemline_detail, sty_texture, sty_gauge, sty_material, sty_fabric_profile, sty_accessory_measurements, sty_third_party, sty_adhoc, sty_finish, sty_coordination_article, sty_fabric_description_free_text, sty_fabric_description ON public.atfs_ma_styleattributes FOR EACH ROW WHEN (((old.sty_missy_related_style <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.sty_copy_master_attributes();


--
-- TOC entry 6330 (class 2620 OID 81942568)
-- Name: atfs_p_strategy_params trg_p_strategy_params_set_apply_targets; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_p_strategy_params_set_apply_targets BEFORE INSERT OR UPDATE ON public.atfs_p_strategy_params FOR EACH ROW EXECUTE FUNCTION public.trg_set_apply_targets_to_plan();


--
-- TOC entry 6288 (class 2620 OID 81942569)
-- Name: atfs_ma_styleattributes trg_skip_update_styleattributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_skip_update_styleattributes BEFORE UPDATE ON public.atfs_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.skip_update_styleattributes();


--
-- TOC entry 6331 (class 2620 OID 81942570)
-- Name: atfs_p_subclass_channel_floorset_pssr_infomap trg_sync_is_approved; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_sync_is_approved AFTER UPDATE OF is_analytics_approved ON public.atfs_p_subclass_channel_floorset_pssr_infomap FOR EACH ROW EXECUTE FUNCTION public.fn_sync_is_approved();


--
-- TOC entry 6277 (class 2620 OID 81942571)
-- Name: atfs_a_assortment trg_to_update_source_of_ranging_edit; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_to_update_source_of_ranging_edit AFTER UPDATE OF plan_type ON public.atfs_a_assortment FOR EACH ROW WHEN (((new.plan_type = 'ranging'::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.reset_plan_type_to_plan();


--
-- TOC entry 6278 (class 2620 OID 81942572)
-- Name: atfs_a_assortment trg_upd_array_order; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_array_order AFTER UPDATE OF str_grade, str_climate ON public.atfs_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.upd_array_order();


--
-- TOC entry 6279 (class 2620 OID 81942573)
-- Name: atfs_a_assortment trg_upd_assortment_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_assortment_ranging AFTER UPDATE OF str_climate, str_grade, ssg ON public.atfs_a_assortment FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.propagate_assortment_to_floorsets();


--
-- TOC entry 6295 (class 2620 OID 81942574)
-- Name: atfs_ma_stylecolorattributes trg_upd_season; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_season AFTER UPDATE OF cc_storeset ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_season();


--
-- TOC entry 6296 (class 2620 OID 81942575)
-- Name: atfs_ma_stylecolorattributes trg_upd_specstylecolorid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_specstylecolorid AFTER UPDATE OF cc_specstyle_cccolor ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_specstylecolor_id();


--
-- TOC entry 6289 (class 2620 OID 81942576)
-- Name: atfs_ma_styleattributes trg_upd_specstyleid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_specstyleid AFTER UPDATE OF sty_specstyleid ON public.atfs_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_specstyle_id();


--
-- TOC entry 6282 (class 2620 OID 81942577)
-- Name: atfs_h_prodstd trg_upd_subclass; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_subclass AFTER UPDATE OF ancestor0 ON public.atfs_h_prodstd FOR EACH ROW WHEN (((new.ancestor3 IS NOT NULL) AND (new.ancestor4 IS NULL))) EXECUTE FUNCTION public.update_subclass();


--
-- TOC entry 6283 (class 2620 OID 81942578)
-- Name: atfs_h_prodstd trg_upd_subclass_name; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_upd_subclass_name AFTER UPDATE OF ancestor1 ON public.atfs_h_prodstd FOR EACH ROW WHEN (((new.ancestor4 IS NOT NULL) AND (new.ancestor5 IS NULL))) EXECUTE FUNCTION public.update_subclass_name();


--
-- TOC entry 6306 (class 2620 OID 81942579)
-- Name: atfs_ma_stylecolorchannelattributes trg_update_cctktprc_override; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trg_update_cctktprc_override AFTER UPDATE OF ccticketpricechannel_override_txt ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.update_ccticketpricechannel_ovr();


--
-- TOC entry 6307 (class 2620 OID 81942580)
-- Name: atfs_ma_stylecolorchannelattributes trig_cc_channel_copy_master_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_cc_channel_copy_master_attributes AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate, initrcptwk, last_inv_wk, lstfpwk, last_rcpt_wk, act_initrcptwk, act_dbt_wk, plannedselldnwk ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(old.missy_related_stylecolor, ''::text) <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.cc_channel_copy_master_attributes();


--
-- TOC entry 6308 (class 2620 OID 81942581)
-- Name: atfs_ma_stylecolorchannelattributes trig_cc_channel_copy_master_attributes_without_lifecycle; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_cc_channel_copy_master_attributes_without_lifecycle AFTER UPDATE OF ccmdstrategy, cc_ordermultiple, cc_ordermin, cc_discount_pct, cc_discount_pct_ecom, auto_rollforward, ccticketpricechannel, slsrnk_store, slsrnk_ecom, cc_plan_cost ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(old.missy_related_stylecolor, ''::text) <> ''::text) AND (pg_trigger_depth() = 0))) EXECUTE FUNCTION public.cc_channel_copy_master_attributes_without_lifecycle();


--
-- TOC entry 6297 (class 2620 OID 81942582)
-- Name: atfs_ma_stylecolorattributes trig_upd_on_color_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trig_upd_on_color_change AFTER UPDATE OF cc_color_name ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_color_change();


--
-- TOC entry 6333 (class 2620 OID 81942583)
-- Name: cart_params trigger_cartparams_ranging; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_cartparams_ranging AFTER UPDATE OF dbt_wk, exitdate ON public.cart_params FOR EACH ROW EXECUTE FUNCTION public.update_trigger_cartparams_ranging();


--
-- TOC entry 6328 (class 2620 OID 81942584)
-- Name: atfs_p_itemprice trigger_eff_aur; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_eff_aur AFTER INSERT OR UPDATE ON public.atfs_p_itemprice FOR EACH ROW WHEN ((pg_trigger_depth() <= 1)) EXECUTE FUNCTION public.update_eff_aur();


--
-- TOC entry 6309 (class 2620 OID 81942585)
-- Name: atfs_ma_stylecolorchannelattributes trigger_for_time_indx; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx AFTER INSERT OR UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 6310 (class 2620 OID 81942586)
-- Name: atfs_ma_stylecolorchannelattributes trigger_for_time_indx_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_for_time_indx_update AFTER UPDATE OF dbt_wk, relaunchweek, erlstmkdnwk, exitdate ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN (((COALESCE(new.relaunchweek, new.dbt_wk) < new.erlstmkdnwk) AND (new.erlstmkdnwk < new.exitdate) AND ((old.cloned_at IS NOT NULL) OR ((old.dbt_wk > old.plan_current) OR (old.exitdate > old.plan_current))) AND (new.exitdate > new.erlstmkdnwk))) EXECUTE FUNCTION public.update_week_indxes();


--
-- TOC entry 6329 (class 2620 OID 81942587)
-- Name: atfs_p_itemprice trigger_itemprice_fetchdepartment; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_itemprice_fetchdepartment BEFORE INSERT ON public.atfs_p_itemprice FOR EACH ROW EXECUTE FUNCTION public.itemprice_fetchdepartment();


--
-- TOC entry 6311 (class 2620 OID 81942588)
-- Name: atfs_ma_stylecolorchannelattributes trigger_lifecycle_plan_update; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_lifecycle_plan_update AFTER UPDATE OF erlstmkdnwk ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.lifecycle_plan_update();


--
-- TOC entry 6312 (class 2620 OID 81942589)
-- Name: atfs_ma_stylecolorchannelattributes trigger_sizerangecode_isvalid; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_isvalid AFTER UPDATE OF validsizes ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_isvalid();


--
-- TOC entry 6313 (class 2620 OID 81942590)
-- Name: atfs_ma_stylecolorchannelattributes trigger_sizerangecode_validsizes_members; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_sizerangecode_validsizes_members AFTER UPDATE OF ccrangecode ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.sizerangecode_validsizes_members();


--
-- TOC entry 6281 (class 2620 OID 81942591)
-- Name: atfs_d_product trigger_upd_name_description; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_upd_name_description AFTER UPDATE OF name, description ON public.atfs_d_product FOR EACH ROW EXECUTE FUNCTION public.update_name_description();


--
-- TOC entry 6298 (class 2620 OID 81942592)
-- Name: atfs_ma_stylecolorattributes trigger_update_cc_floorset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_cc_floorset AFTER INSERT OR UPDATE OF cc_delivery_name ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_floorset();


--
-- TOC entry 6299 (class 2620 OID 81942593)
-- Name: atfs_ma_stylecolorattributes trigger_update_cc_use_sys_floorset; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_cc_use_sys_floorset BEFORE UPDATE OF cc_floorset ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.update_cc_use_sys_floorset();


--
-- TOC entry 6316 (class 2620 OID 81942594)
-- Name: atfs_ma_stylecolorfloorsetattributes trigger_update_publish_attributes; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER trigger_update_publish_attributes BEFORE UPDATE OF is_attr_published, is_fc_published, is_ir_published ON public.atfs_ma_stylecolorfloorsetattributes FOR EACH ROW EXECUTE FUNCTION public.update_publish_attributes();


--
-- TOC entry 6280 (class 2620 OID 81942595)
-- Name: atfs_a_assortment triggger_insert_scflrsetattr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER triggger_insert_scflrsetattr AFTER INSERT ON public.atfs_a_assortment FOR EACH ROW EXECUTE FUNCTION public.insert_stylecolorfloorsetattributes();


--
-- TOC entry 6290 (class 2620 OID 81942596)
-- Name: atfs_ma_styleattributes update_ccrangecode; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ccrangecode AFTER UPDATE OF sty_size_range ON public.atfs_ma_styleattributes FOR EACH ROW EXECUTE FUNCTION public.update_stylecolorchannelattributes_ccrangecode();


--
-- TOC entry 6327 (class 2620 OID 81942597)
-- Name: atfs_p_dc_adj_size update_ecom_onorder_ovr; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_ecom_onorder_ovr AFTER INSERT OR UPDATE OF dc_finrev_ecom ON public.atfs_p_dc_adj_size FOR EACH ROW EXECUTE FUNCTION public.update_ecom_onorder_ovr();


--
-- TOC entry 6325 (class 2620 OID 81942598)
-- Name: atfs_p_dc_adj update_p_dc_adj_size_publish; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_p_dc_adj_size_publish AFTER UPDATE OF dc_publish ON public.atfs_p_dc_adj FOR EACH ROW EXECUTE FUNCTION public.update_p_dc_adj_size_publish();


--
-- TOC entry 6314 (class 2620 OID 81942599)
-- Name: atfs_ma_stylecolorchannelattributes update_price_band; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_price_band AFTER INSERT OR UPDATE OF ccticketpricechannel, ccticketpricechannel_override ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW EXECUTE FUNCTION public.update_price_bands();


--
-- TOC entry 6315 (class 2620 OID 81942600)
-- Name: atfs_ma_stylecolorchannelattributes update_size_concepts; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER update_size_concepts AFTER UPDATE OF record_state ON public.atfs_ma_stylecolorchannelattributes FOR EACH ROW WHEN ((pg_trigger_depth() = 0)) EXECUTE FUNCTION public.update_cc_size_concept_in_assortment();


--
-- TOC entry 6300 (class 2620 OID 81942601)
-- Name: atfs_ma_stylecolorattributes validate_size_concept_addition; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER validate_size_concept_addition BEFORE UPDATE OF cc_size_concepts_in_assortment ON public.atfs_ma_stylecolorattributes FOR EACH ROW EXECUTE FUNCTION public.validate_size_concept_addition();


--
-- TOC entry 6261 (class 2606 OID 81942602)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 6262 (class 2606 OID 81942607)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 6264 (class 2606 OID 81942612)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 6275 (class 2606 OID 82000208)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.agent_conversations(conversation_id);


--
-- TOC entry 6260 (class 2606 OID 81942617)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES public.allocation_plan_queue(jobid);


--
-- TOC entry 6267 (class 2606 OID 81942622)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 6268 (class 2606 OID 81942627)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 6263 (class 2606 OID 81942632)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 6266 (class 2606 OID 81942637)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 6265 (class 2606 OID 81942642)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.user_metadata(uid);


--
-- TOC entry 6269 (class 2606 OID 81942647)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 6270 (class 2606 OID 81942652)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 6273 (class 2606 OID 81942657)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 6271 (class 2606 OID 81942662)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES target_setting.plans(id) ON DELETE CASCADE;


--
-- TOC entry 6272 (class 2606 OID 81942667)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES target_setting.plans(id);


--
-- TOC entry 6274 (class 2606 OID 81942672)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: target_setting; Owner: psql
--

ALTER TABLE ONLY target_setting.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES target_setting.dimensions(id);


--
-- TOC entry 6495 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:05:56 IST

--
-- PostgreSQL database dump complete
--

\unrestrict YSkr1RtUy66zekoplwj7YeiK8ZIO8m4ZBgKCH7HZUZwHre0w3V9KMNDHDN8gse3

