-- ENV: QA | DB: tb | dumped: 2026-10-01 15:07 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict dzmoR1IaEepAuSOuDU6UHBtNLmygBFYTq4G0ND36PjGcs2neYpTE27PmpDChOm8

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:07:43 IST

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
-- TOC entry 5 (class 2615 OID 47373393)
-- Name: mfp; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp;


ALTER SCHEMA mfp OWNER TO psql;

--
-- TOC entry 7 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 2 (class 3079 OID 4715249)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 981 (class 1247 OID 47373395)
-- Name: approval; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp.approval OWNER TO psql;

--
-- TOC entry 987 (class 1247 OID 47373400)
-- Name: permission; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp.permission OWNER TO psql;

--
-- TOC entry 1254 (class 1247 OID 62715120)
-- Name: agent_sender; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.agent_sender AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE public.agent_sender OWNER TO psql;

--
-- TOC entry 990 (class 1247 OID 47373408)
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
-- TOC entry 993 (class 1247 OID 47373420)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 368 (class 1255 OID 47373425)
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
-- TOC entry 369 (class 1255 OID 47373426)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN EXECUTE 'NOTIFY pivot_execution_change'; RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 370 (class 1255 OID 47373427)
-- Name: notify_plan_queue_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_plan_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY plan_queue_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_plan_queue_change() OWNER TO psql;

--
-- TOC entry 377 (class 1255 OID 47373428)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$ BEGIN RETURN QUERY
            SELECT scca.product, scca.location FROM tb01_ma_stylecolorchannelattributes scca
            INNER JOIN UNNEST(products) arg ON scca.product=arg WHERE scca.record_state=0; END
            $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 47373429)
-- Name: actuals_loaded; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_loaded (
    id integer NOT NULL,
    product character varying(64) NOT NULL,
    location character varying(64) NOT NULL,
    "time" character varying(64) NOT NULL,
    prodlife character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    data bytea
);


ALTER TABLE mfp.actuals_loaded OWNER TO psql;

--
-- TOC entry 212 (class 1259 OID 47373435)
-- Name: actuals_loaded_id_seq; Type: SEQUENCE; Schema: mfp; Owner: psql
--

CREATE SEQUENCE mfp.actuals_loaded_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp.actuals_loaded_id_seq OWNER TO psql;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 212
-- Name: actuals_loaded_id_seq; Type: SEQUENCE OWNED BY; Schema: mfp; Owner: psql
--

ALTER SEQUENCE mfp.actuals_loaded_id_seq OWNED BY mfp.actuals_loaded.id;


--
-- TOC entry 213 (class 1259 OID 47373436)
-- Name: actuals_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide (
    "time" character varying(64) NOT NULL,
    location character varying(64) NOT NULL,
    product character varying(64) NOT NULL,
    prodlife character varying(64) NOT NULL,
    sales_u double precision,
    sales_r double precision,
    sales_c double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    store_count double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    return_u double precision,
    return_r double precision,
    discount_r double precision,
    markdown_r double precision,
    adjustments_u double precision,
    adjustments_r double precision,
    adjustments_c double precision,
    xfer_u_in double precision,
    xfer_c_in double precision,
    xfer_r_in double precision,
    xfer_u_out double precision,
    xfer_c_out double precision,
    xfer_r_out double precision,
    on_order_u double precision,
    on_order_r double precision,
    on_order_c double precision,
    phrec_c double precision DEFAULT 0.0 NOT NULL,
    phrec_u double precision DEFAULT 0.0 NOT NULL,
    phrec_r double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE mfp.actuals_wide OWNER TO psql;

--
-- TOC entry 214 (class 1259 OID 47373442)
-- Name: actuals_wide_2019_stage; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_2019_stage (
    id character varying(128),
    "time" character varying(64),
    location character varying(64),
    product character varying(64),
    prodlife character varying(64),
    sales_u double precision,
    sales_r double precision,
    sales_c double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    shipqty_u double precision,
    shipqty_r double precision,
    shipqty_c double precision,
    slsu_tktp double precision,
    bohu_tktp double precision,
    rec_tktp double precision,
    store_count double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    sales_aut double precision,
    return_u double precision,
    return_r double precision,
    discount_r double precision,
    markdown_r double precision,
    adjustments_u double precision,
    adjustments_r double precision,
    adjustments_c double precision,
    gross_sales_u double precision,
    gross_sales_r double precision,
    xfer_u_in double precision,
    xfer_c_in double precision,
    xfer_r_in double precision,
    sales_auc_override double precision,
    sales_aut_override double precision,
    xfer_u_out double precision,
    xfer_c_out double precision,
    xfer_r_out double precision,
    on_order_u double precision,
    on_order_r double precision,
    on_order_c double precision
);


ALTER TABLE mfp.actuals_wide_2019_stage OWNER TO psql;

--
-- TOC entry 215 (class 1259 OID 47373445)
-- Name: actuals_wide_backup; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_backup (
    id character varying(128),
    "time" character varying(64),
    location character varying(64),
    product character varying(64),
    prodlife character varying(64),
    sales_u double precision,
    sales_r double precision,
    sales_c double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    shipqty_u double precision,
    shipqty_r double precision,
    shipqty_c double precision,
    slsu_tktp double precision,
    bohu_tktp double precision,
    rec_tktp double precision,
    store_count double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    sales_aut double precision,
    return_u double precision,
    return_r double precision,
    discount_r double precision,
    markdown_r double precision,
    adjustments_u double precision,
    adjustments_r double precision,
    adjustments_c double precision,
    gross_sales_u double precision,
    gross_sales_r double precision,
    xfer_u_in double precision,
    xfer_c_in double precision,
    xfer_r_in double precision,
    sales_auc_override double precision,
    sales_aut_override double precision,
    xfer_u_out double precision,
    xfer_c_out double precision,
    xfer_r_out double precision,
    on_order_u double precision,
    on_order_r double precision,
    on_order_c double precision
);


ALTER TABLE mfp.actuals_wide_backup OWNER TO psql;

--
-- TOC entry 216 (class 1259 OID 47373448)
-- Name: actuals_wide_bkp20220501; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_bkp20220501 (
    "time" character varying(64),
    location character varying(64),
    product character varying(64),
    prodlife character varying(64),
    sales_u double precision,
    sales_r double precision,
    sales_c double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    store_count double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    return_u double precision,
    return_r double precision,
    discount_r double precision,
    markdown_r double precision,
    adjustments_u double precision,
    adjustments_r double precision,
    adjustments_c double precision,
    xfer_u_in double precision,
    xfer_c_in double precision,
    xfer_r_in double precision,
    xfer_u_out double precision,
    xfer_c_out double precision,
    xfer_r_out double precision,
    on_order_u double precision,
    on_order_r double precision,
    on_order_c double precision,
    phrec_c double precision,
    phrec_u double precision,
    phrec_r double precision
);


ALTER TABLE mfp.actuals_wide_bkp20220501 OWNER TO psql;

--
-- TOC entry 217 (class 1259 OID 47373451)
-- Name: dimensions; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions (
    dimension character varying(128) NOT NULL,
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128) NOT NULL,
    indx integer
);


ALTER TABLE mfp.dimensions OWNER TO psql;

--
-- TOC entry 218 (class 1259 OID 47373456)
-- Name: hierarchies; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies (
    dimension character varying(128) NOT NULL,
    hierarchy character varying(128) NOT NULL,
    id character varying(64) NOT NULL,
    ancestor character varying(64) NOT NULL
);


ALTER TABLE mfp.hierarchies OWNER TO psql;

--
-- TOC entry 219 (class 1259 OID 47373459)
-- Name: location_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.location_denorm AS
 SELECT locrootlevel.id AS locrootlevel,
    locbrand.id AS locbrand,
    sellingchannel.id AS sellingchannel,
    globalregion.id AS globalregion,
    channel.id AS channel
   FROM ((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE (((dimensions.dimension)::text = 'location'::text) AND ((dimensions.levelid)::text = 'channel'::text))) channel
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (channel.id)::text) AND ((hierarchies.hierarchy)::text = 'locstd'::text))) globalregion ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (globalregion.id)::text) AND ((hierarchies.hierarchy)::text = 'locstd'::text))) sellingchannel ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (sellingchannel.id)::text) AND ((hierarchies.hierarchy)::text = 'locstd'::text))) locbrand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (locbrand.id)::text) AND ((hierarchies.hierarchy)::text = 'locstd'::text))) locrootlevel ON (true));


ALTER VIEW mfp.location_denorm OWNER TO psql;

--
-- TOC entry 220 (class 1259 OID 47373464)
-- Name: prodlife_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.prodlife_denorm AS
 SELECT prodliferootlevel.id AS prodliferootlevel
   FROM ( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE (((dimensions.dimension)::text = 'prodlife'::text) AND ((dimensions.levelid)::text = 'prodliferootlevel'::text))) prodliferootlevel;


ALTER VIEW mfp.prodlife_denorm OWNER TO psql;

--
-- TOC entry 221 (class 1259 OID 47373468)
-- Name: product_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.product_denorm AS
 SELECT prodrootlevel.id AS prodrootlevel,
    brand.id AS brand,
    division.id AS division,
    department.id AS department,
    class.id AS class
   FROM ((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE (((dimensions.dimension)::text = 'product'::text) AND ((dimensions.levelid)::text = 'class'::text))) class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (class.id)::text) AND ((hierarchies.hierarchy)::text = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (department.id)::text) AND ((hierarchies.hierarchy)::text = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (division.id)::text) AND ((hierarchies.hierarchy)::text = 'prodstd'::text))) brand ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (brand.id)::text) AND ((hierarchies.hierarchy)::text = 'prodstd'::text))) prodrootlevel ON (true));


ALTER VIEW mfp.product_denorm OWNER TO psql;

--
-- TOC entry 222 (class 1259 OID 47373473)
-- Name: time_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.time_denorm AS
 SELECT timerootlevel.id AS timerootlevel,
    fiscalyear.id AS fiscalyear,
    season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE (((dimensions.dimension)::text = 'time'::text) AND ((dimensions.levelid)::text = 'week'::text))) week
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (week.id)::text) AND ((hierarchies.hierarchy)::text = 'timestd'::text))) month ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (month.id)::text) AND ((hierarchies.hierarchy)::text = 'timestd'::text))) quarter ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (quarter.id)::text) AND ((hierarchies.hierarchy)::text = 'timestd'::text))) season ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (season.id)::text) AND ((hierarchies.hierarchy)::text = 'timestd'::text))) fiscalyear ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE (((hierarchies.id)::text = (fiscalyear.id)::text) AND ((hierarchies.hierarchy)::text = 'timestd'::text))) timerootlevel ON (true));


ALTER VIEW mfp.time_denorm OWNER TO psql;

--
-- TOC entry 223 (class 1259 OID 47373478)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.actuals_wide_denorm AS
 SELECT "time".week AS time_week,
    "time".fiscalyear AS time_fiscalyear,
    product.class AS product_class,
    product.department AS product_department,
    product.brand AS product_brand,
    location.channel AS location_channel,
    location.locbrand AS location_locbrand,
    prodlife.prodliferootlevel AS prodlife_prodliferootlevel,
    wide."time",
    wide.product,
    wide.location,
    wide.prodlife,
    wide.sales_r,
    wide.sales_u,
    wide.sales_c,
    wide.rec_r,
    wide.rec_u,
    wide.rec_c,
    wide.xfer_r_in,
    wide.xfer_u_in,
    wide.xfer_c_in,
    wide.xfer_r_out,
    wide.xfer_u_out,
    wide.xfer_c_out,
    wide.adjustments_r,
    wide.adjustments_u,
    wide.adjustments_c,
    wide.boh_u,
    wide.boh_r,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.on_order_r,
    wide.on_order_u,
    wide.on_order_c,
    wide.store_count,
    wide.discount_r,
    wide.markdown_r,
    wide.return_r,
    wide.return_u,
    wide.phrec_r,
    wide.phrec_u,
    wide.phrec_c
   FROM ((((mfp.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.fiscalyear
           FROM mfp.time_denorm) "time" ON ((("time".week)::text = (wide."time")::text)))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.brand
           FROM mfp.product_denorm) product ON (((product.class)::text = (wide.product)::text)))
     JOIN ( SELECT location_denorm.channel,
            location_denorm.locbrand
           FROM mfp.location_denorm) location ON (((location.channel)::text = (wide.location)::text)))
     JOIN ( SELECT prodlife_denorm.prodliferootlevel
           FROM mfp.prodlife_denorm) prodlife ON (((prodlife.prodliferootlevel)::text = (wide.prodlife)::text)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 224 (class 1259 OID 47373485)
-- Name: actuals_wide_old; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide_old (
    id character varying(128),
    "time" character varying(64),
    location character varying(64),
    product character varying(64),
    prodlife character varying(64),
    sales_u double precision,
    sales_r double precision,
    sales_c double precision,
    boh_r double precision,
    boh_u double precision,
    boh_c double precision,
    rec_u double precision,
    rec_r double precision,
    rec_c double precision,
    shipqty_u double precision,
    shipqty_r double precision,
    shipqty_c double precision,
    slsu_tktp double precision,
    bohu_tktp double precision,
    rec_tktp double precision,
    store_count double precision,
    eoh_u double precision,
    eoh_r double precision,
    eoh_c double precision,
    sales_aut double precision,
    return_u double precision,
    return_r double precision,
    discount_r double precision,
    markdown_r double precision,
    adjustments_u double precision,
    adjustments_r double precision,
    adjustments_c double precision,
    gross_sales_u double precision,
    gross_sales_r double precision,
    xfer_u_in double precision,
    xfer_c_in double precision,
    xfer_r_in double precision,
    sales_auc_override double precision,
    sales_aut_override double precision,
    xfer_u_out double precision,
    xfer_c_out double precision,
    xfer_r_out double precision,
    on_order_u double precision,
    on_order_r double precision,
    on_order_c double precision
);


ALTER TABLE mfp.actuals_wide_old OWNER TO psql;

--
-- TOC entry 225 (class 1259 OID 47373488)
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
-- TOC entry 226 (class 1259 OID 47373494)
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
-- TOC entry 227 (class 1259 OID 47373500)
-- Name: d_location; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.d_location (
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.d_location OWNER TO psql;

--
-- TOC entry 228 (class 1259 OID 47373505)
-- Name: d_prodlife; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.d_prodlife (
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.d_prodlife OWNER TO psql;

--
-- TOC entry 229 (class 1259 OID 47373510)
-- Name: d_product; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.d_product (
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.d_product OWNER TO psql;

--
-- TOC entry 230 (class 1259 OID 47373515)
-- Name: d_product_bkp; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.d_product_bkp (
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.d_product_bkp OWNER TO psql;

--
-- TOC entry 231 (class 1259 OID 47373520)
-- Name: d_time; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.d_time (
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128),
    indx integer,
    next character varying(128),
    prev character varying(128)
);


ALTER TABLE mfp.d_time OWNER TO psql;

--
-- TOC entry 232 (class 1259 OID 47373525)
-- Name: dimensions_backup_2025_09_12; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_backup_2025_09_12 (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_backup_2025_09_12 OWNER TO psql;

--
-- TOC entry 233 (class 1259 OID 47373530)
-- Name: dimensions_backup_2025_09_16; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_backup_2025_09_16 (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_backup_2025_09_16 OWNER TO psql;

--
-- TOC entry 234 (class 1259 OID 47373535)
-- Name: dimensions_bkp; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_bkp (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_bkp OWNER TO psql;

--
-- TOC entry 235 (class 1259 OID 47373540)
-- Name: dimensions_bkp_20250323; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_bkp_20250323 (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_bkp_20250323 OWNER TO psql;

--
-- TOC entry 236 (class 1259 OID 47373545)
-- Name: dimensions_load_2025_09_12; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_load_2025_09_12 (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_load_2025_09_12 OWNER TO psql;

--
-- TOC entry 237 (class 1259 OID 47373550)
-- Name: dimensions_staging; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_staging (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.dimensions_staging OWNER TO psql;

--
-- TOC entry 238 (class 1259 OID 47373555)
-- Name: dimensions_staging_042023; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_staging_042023 (
    dimension character varying(128) NOT NULL,
    id character varying(128) NOT NULL,
    name text,
    description text,
    levelid character varying(128) NOT NULL,
    indx integer
);


ALTER TABLE mfp.dimensions_staging_042023 OWNER TO psql;

--
-- TOC entry 239 (class 1259 OID 47373560)
-- Name: eb_authgrants_copy_063019; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.eb_authgrants_copy_063019 (
    uid text,
    dimension character varying(128),
    member character varying(128),
    permission mfp.permission
);


ALTER TABLE mfp.eb_authgrants_copy_063019 OWNER TO psql;

--
-- TOC entry 240 (class 1259 OID 47373565)
-- Name: h_locstd; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.h_locstd (
    id character varying(64),
    ancestor character varying(64),
    distance smallint
);


ALTER TABLE mfp.h_locstd OWNER TO psql;

--
-- TOC entry 241 (class 1259 OID 47373568)
-- Name: h_prodlifestd; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.h_prodlifestd (
    id character varying(128) NOT NULL,
    ancestor character varying(128) NOT NULL,
    distance smallint
);


ALTER TABLE mfp.h_prodlifestd OWNER TO psql;

--
-- TOC entry 242 (class 1259 OID 47373571)
-- Name: h_prodstd; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.h_prodstd (
    id character varying(128),
    ancestor character varying(128),
    distance smallint
);


ALTER TABLE mfp.h_prodstd OWNER TO psql;

--
-- TOC entry 243 (class 1259 OID 47373574)
-- Name: h_timestd; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.h_timestd (
    id character varying(128),
    ancestor character varying(128),
    distance smallint
);


ALTER TABLE mfp.h_timestd OWNER TO psql;

--
-- TOC entry 244 (class 1259 OID 47373577)
-- Name: hierarchies_backup_2025_09_12; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_backup_2025_09_12 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_backup_2025_09_12 OWNER TO psql;

--
-- TOC entry 245 (class 1259 OID 47373580)
-- Name: hierarchies_backup_2025_09_16; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_backup_2025_09_16 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_backup_2025_09_16 OWNER TO psql;

--
-- TOC entry 246 (class 1259 OID 47373583)
-- Name: hierarchies_bkp; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_bkp (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_bkp OWNER TO psql;

--
-- TOC entry 247 (class 1259 OID 47373586)
-- Name: hierarchies_bkp_080123; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_bkp_080123 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_bkp_080123 OWNER TO psql;

--
-- TOC entry 248 (class 1259 OID 47373589)
-- Name: hierarchies_bkp_20250323; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_bkp_20250323 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_bkp_20250323 OWNER TO psql;

--
-- TOC entry 249 (class 1259 OID 47373592)
-- Name: hierarchies_load_2025_09_12; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_load_2025_09_12 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchies_load_2025_09_12 OWNER TO psql;

--
-- TOC entry 250 (class 1259 OID 47373595)
-- Name: hierarchies_staging; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchies_staging (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64),
    distance smallint
);


ALTER TABLE mfp.hierarchies_staging OWNER TO psql;

--
-- TOC entry 251 (class 1259 OID 47373598)
-- Name: hierarchy_backup_2025_11_04; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.hierarchy_backup_2025_11_04 (
    dimension character varying(128),
    hierarchy character varying(128),
    id character varying(64),
    ancestor character varying(64)
);


ALTER TABLE mfp.hierarchy_backup_2025_11_04 OWNER TO psql;

--
-- TOC entry 252 (class 1259 OID 47373601)
-- Name: metadata; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.metadata (
    key character varying(128) NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id character varying(128),
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp.metadata OWNER TO psql;

--
-- TOC entry 253 (class 1259 OID 47373606)
-- Name: orderings_staging; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.orderings_staging (
    dimension character varying(128),
    source character varying(128),
    target character varying(128)
);


ALTER TABLE mfp.orderings_staging OWNER TO psql;

--
-- TOC entry 254 (class 1259 OID 47373609)
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
-- TOC entry 255 (class 1259 OID 47373614)
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
-- TOC entry 256 (class 1259 OID 47373620)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide (
    id integer NOT NULL,
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adjustments_c double precision NOT NULL,
    adjustments_r double precision NOT NULL,
    adjustments_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    boh_r double precision NOT NULL,
    boh_u double precision NOT NULL,
    discount_r double precision NOT NULL,
    eoh_c double precision NOT NULL,
    eoh_r double precision NOT NULL,
    eoh_u double precision NOT NULL,
    markdown_r double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r double precision NOT NULL,
    on_order_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r double precision NOT NULL,
    rec_u double precision NOT NULL,
    return_r double precision NOT NULL,
    return_u double precision NOT NULL,
    sales_c double precision NOT NULL,
    sales_r double precision NOT NULL,
    sales_u double precision NOT NULL,
    store_count double precision NOT NULL,
    xfer_c_in double precision NOT NULL,
    xfer_c_out double precision NOT NULL,
    xfer_r_in double precision NOT NULL,
    xfer_r_out double precision NOT NULL,
    xfer_u_in double precision NOT NULL,
    xfer_u_out double precision NOT NULL,
    phrec_c double precision DEFAULT 0.0 NOT NULL,
    phrec_u double precision DEFAULT 0.0 NOT NULL,
    phrec_r double precision DEFAULT 0.0 NOT NULL
);


ALTER TABLE mfp.plan_data_wide OWNER TO psql;

--
-- TOC entry 257 (class 1259 OID 47373628)
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
-- TOC entry 258 (class 1259 OID 47373629)
-- Name: plan_init_status; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp.plan_init_status OWNER TO psql;

--
-- TOC entry 259 (class 1259 OID 47373632)
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
-- TOC entry 260 (class 1259 OID 47373641)
-- Name: product_staging; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.product_staging (
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.product_staging OWNER TO psql;

--
-- TOC entry 261 (class 1259 OID 47373646)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.sys_gen_wide (
    sys_version text NOT NULL,
    prodlife text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    adjustments_c double precision,
    adjustments_r double precision,
    adjustments_u double precision,
    boh_c double precision,
    boh_r double precision,
    boh_u double precision,
    discount_r double precision,
    eoh_c double precision,
    eoh_r double precision,
    eoh_u double precision,
    markdown_r double precision,
    on_order_c double precision,
    on_order_r double precision,
    on_order_u double precision,
    phrec_c double precision,
    phrec_r double precision,
    phrec_u double precision,
    rec_c double precision,
    rec_r double precision,
    rec_u double precision,
    return_r double precision,
    return_u double precision,
    sales_c double precision,
    sales_r double precision,
    sales_u double precision,
    store_count double precision,
    xfer_c_in double precision,
    xfer_c_out double precision,
    xfer_r_in double precision,
    xfer_r_out double precision,
    xfer_u_in double precision,
    xfer_u_out double precision
);


ALTER TABLE mfp.sys_gen_wide OWNER TO psql;

--
-- TOC entry 262 (class 1259 OID 47373651)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".fiscalyear AS time_fiscalyear,
    product.class AS product_class,
    product.department AS product_department,
    product.brand AS product_brand,
    location.channel AS location_channel,
    location.locbrand AS location_locbrand,
    prodlife.prodliferootlevel AS prodlife_prodliferootlevel,
    wide."time",
    wide.product,
    wide.location,
    wide.prodlife,
    wide.sales_r,
    wide.sales_u,
    wide.sales_c,
    wide.rec_r,
    wide.rec_u,
    wide.rec_c,
    wide.xfer_r_in,
    wide.xfer_u_in,
    wide.xfer_c_in,
    wide.xfer_r_out,
    wide.xfer_u_out,
    wide.xfer_c_out,
    wide.adjustments_r,
    wide.adjustments_u,
    wide.adjustments_c,
    wide.boh_u,
    wide.boh_r,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r,
    wide.eoh_c,
    wide.on_order_r,
    wide.on_order_u,
    wide.on_order_c,
    wide.store_count,
    wide.discount_r,
    wide.markdown_r,
    wide.return_r,
    wide.return_u,
    wide.phrec_r,
    wide.phrec_u,
    wide.phrec_c
   FROM ((((mfp.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.fiscalyear
           FROM mfp.time_denorm) "time" ON ((("time".week)::text = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.brand
           FROM mfp.product_denorm) product ON (((product.class)::text = wide.product)))
     JOIN ( SELECT location_denorm.channel,
            location_denorm.locbrand
           FROM mfp.location_denorm) location ON (((location.channel)::text = wide.location)))
     JOIN ( SELECT prodlife_denorm.prodliferootlevel
           FROM mfp.prodlife_denorm) prodlife ON (((prodlife.prodliferootlevel)::text = wide.prodlife)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 263 (class 1259 OID 47373658)
-- Name: time_load; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.time_load (
    dimension character varying(128),
    id character varying(128),
    name text,
    description text,
    levelid character varying(128),
    indx integer
);


ALTER TABLE mfp.time_load OWNER TO psql;

--
-- TOC entry 264 (class 1259 OID 47373663)
-- Name: tyly; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp.tyly OWNER TO psql;

--
-- TOC entry 265 (class 1259 OID 47373668)
-- Name: tyly_backup_2025_09_12; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly_backup_2025_09_12 (
    ty text,
    ly text
);


ALTER TABLE mfp.tyly_backup_2025_09_12 OWNER TO psql;

--
-- TOC entry 266 (class 1259 OID 47373673)
-- Name: user_kv_store; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp.user_kv_store OWNER TO psql;

--
-- TOC entry 353 (class 1259 OID 62715109)
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
-- TOC entry 354 (class 1259 OID 62715125)
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
-- TOC entry 267 (class 1259 OID 47373678)
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
-- TOC entry 268 (class 1259 OID 47373685)
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
-- TOC entry 269 (class 1259 OID 47373693)
-- Name: bd_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorattributes (
    product text NOT NULL,
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
    cc_animal text,
    cc_applied_detail text,
    cc_colour_group text,
    cc_novelty text,
    cc_pattern text,
    cc_print_name text,
    cc_print_type text,
    cc_fabric_yarn_type text,
    cc_supplier text,
    cc_price_banding_latest text,
    cc_end_use_latest text,
    cc_continuity_packages_latest text,
    cc_classification_latest text,
    cc_theme_latest text,
    cc_newness_latest text,
    cc_season_latest text,
    sty_fit_style text,
    sty_gender text,
    sty_heel_height text,
    sty_heel_shape text,
    sty_hem_shape text,
    sty_length text,
    sty_neck_detail text,
    sty_neck_shape text,
    sty_skirt_shape text,
    sty_sleeve_length text,
    sty_sleeve_shape text,
    sty_texture text,
    sty_sub_range text,
    sty_building_blocks text,
    sty_shopzilla_rating text,
    sty_shopzilla_rating_count text,
    sty_age_group text,
    sty_classification_latest text,
    cccolor text,
    cccolorfamily text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.bd_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 270 (class 1259 OID 47373705)
-- Name: bd_ma_stylecolorweekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.bd_ma_stylecolorweekattributes (
    product text NOT NULL,
    style text,
    phase_id text,
    t_cc_price_banding text,
    t_cc_phase_story text,
    t_cc_end_use text,
    t_cc_continuity_packages text,
    t_cc_classification text,
    t_cc_theme text,
    t_cc_newness text,
    t_cc_exposure text,
    t_cc_cts text,
    t_cc_season text,
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
-- TOC entry 271 (class 1259 OID 47373717)
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
-- TOC entry 272 (class 1259 OID 47373722)
-- Name: cart_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master (
    jsessionid text
);


ALTER TABLE public.cart_master OWNER TO psql;

--
-- TOC entry 273 (class 1259 OID 47373727)
-- Name: cart_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params (
    jsessionid text
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 274 (class 1259 OID 47373732)
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
-- TOC entry 275 (class 1259 OID 47373739)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 276 (class 1259 OID 47373744)
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
-- TOC entry 277 (class 1259 OID 47373749)
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
-- TOC entry 278 (class 1259 OID 47373752)
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
-- TOC entry 279 (class 1259 OID 47373759)
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
-- TOC entry 280 (class 1259 OID 47373764)
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
-- TOC entry 281 (class 1259 OID 47373769)
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
-- TOC entry 282 (class 1259 OID 47373775)
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
-- TOC entry 283 (class 1259 OID 47373781)
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
-- TOC entry 284 (class 1259 OID 47373790)
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
-- TOC entry 285 (class 1259 OID 47373794)
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
-- TOC entry 286 (class 1259 OID 47373802)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 287 (class 1259 OID 47373807)
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
-- TOC entry 288 (class 1259 OID 47373816)
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
-- TOC entry 289 (class 1259 OID 47373821)
-- Name: tb01_a_assortment; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_a_assortment (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    style text,
    initrcptwk text,
    dbtwk text,
    erlstmkdnwk text,
    exitdate text,
    validsizes text[],
    grade text[],
    strclimate text[],
    strfohtier text[],
    slsr real,
    slsu real,
    slsc real,
    fpmargin real,
    fpmarginpct real,
    fpaur real,
    fpdiscountpct real,
    rctu real,
    rctr real,
    rctc real,
    eohu real,
    bohu real,
    ttlslsu real,
    ttlslsr real,
    ttlslsc real,
    ttlmargin real,
    ttlmarginpct real,
    ttlaur real,
    ttldiscountpct real,
    fpaps real,
    ttlaps real,
    fpsellthru real,
    ttlsellthru real,
    storecount real,
    weeksonsale real,
    tktp real,
    lndcst real,
    imupct real,
    slsauc real,
    ttlslsauc real,
    eventdate date,
    plan_type text
);


ALTER TABLE public.tb01_a_assortment OWNER TO psql;

--
-- TOC entry 290 (class 1259 OID 47373826)
-- Name: tb01_a_assortment_old; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_a_assortment_old (
    product text NOT NULL,
    location text NOT NULL,
    "time" text NOT NULL,
    style text,
    initrcptwk text,
    dbtwk text,
    erlstmkdnwk text,
    exitdate text,
    validsizes text[],
    grade text[],
    strclimate text[],
    strfohtier text[],
    slsr real,
    slsu real,
    slsc real,
    fpmargin real,
    fpmarginpct real,
    fpaur real,
    fpdiscountpct real,
    rctu real,
    rctr real,
    rctc real,
    eohu real,
    bohu real,
    ttlslsu real,
    ttlslsr real,
    ttlslsc real,
    ttlmargin real,
    ttlmarginpct real,
    ttlaur real,
    ttldiscountpct real,
    fpaps real,
    ttlaps real,
    fpsellthru real,
    ttlsellthru real,
    storecount real,
    weeksonsale real,
    tktp real,
    lndcst real,
    imupct real,
    slsauc real,
    ttlslsauc real,
    eventdate date DEFAULT CURRENT_DATE,
    plan_type text DEFAULT 'plan'::text NOT NULL
);


ALTER TABLE public.tb01_a_assortment_old OWNER TO psql;

--
-- TOC entry 291 (class 1259 OID 47373833)
-- Name: tb01_authorization; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_authorization (
    tenantid text DEFAULT 'TB01'::text,
    roleid text NOT NULL,
    authid text NOT NULL,
    access text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_authorization OWNER TO psql;

--
-- TOC entry 292 (class 1259 OID 47373840)
-- Name: tb01_authorization_backup_20200713; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_authorization_backup_20200713 (
    tenantid text,
    roleid text,
    authid text,
    access text,
    eventdate date
);


ALTER TABLE public.tb01_authorization_backup_20200713 OWNER TO psql;

--
-- TOC entry 293 (class 1259 OID 47373845)
-- Name: tb01_authorization_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_authorization_bkp (
    tenantid text,
    roleid text,
    authid text,
    access text,
    eventdate date
);


ALTER TABLE public.tb01_authorization_bkp OWNER TO psql;

--
-- TOC entry 294 (class 1259 OID 47373850)
-- Name: tb01_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_cluster (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_d_cluster OWNER TO psql;

--
-- TOC entry 295 (class 1259 OID 47373856)
-- Name: tb01_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_location (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_d_location OWNER TO psql;

--
-- TOC entry 296 (class 1259 OID 47373862)
-- Name: tb01_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_prodlife (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_d_prodlife OWNER TO psql;

--
-- TOC entry 297 (class 1259 OID 47373868)
-- Name: tb01_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_product (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_d_product OWNER TO psql;

--
-- TOC entry 298 (class 1259 OID 47373874)
-- Name: tb01_d_product_jul30; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_product_jul30 (
    id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_d_product_jul30 OWNER TO psql;

--
-- TOC entry 299 (class 1259 OID 47373879)
-- Name: tb01_d_product_shadow; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_product_shadow (
    id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_d_product_shadow OWNER TO psql;

--
-- TOC entry 300 (class 1259 OID 47373884)
-- Name: tb01_d_product_shadow2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_product_shadow2 (
    id text,
    name text,
    description text,
    levelid text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_d_product_shadow2 OWNER TO psql;

--
-- TOC entry 301 (class 1259 OID 47373889)
-- Name: tb01_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_time (
    id text NOT NULL,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_d_time OWNER TO psql;

--
-- TOC entry 302 (class 1259 OID 47373895)
-- Name: tb01_d_time_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_time_bkp (
    id text,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_d_time_bkp OWNER TO psql;

--
-- TOC entry 303 (class 1259 OID 47373900)
-- Name: tb01_d_time_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_d_time_test (
    id text,
    name text,
    description text,
    levelid text,
    prev text,
    next text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_d_time_test OWNER TO psql;

--
-- TOC entry 304 (class 1259 OID 47373905)
-- Name: tb01_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_clusterstd OWNER TO psql;

--
-- TOC entry 305 (class 1259 OID 47373911)
-- Name: tb01_h_locdcstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_locdcstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_locdcstd OWNER TO psql;

--
-- TOC entry 306 (class 1259 OID 47373917)
-- Name: tb01_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_locstd OWNER TO psql;

--
-- TOC entry 307 (class 1259 OID 47373923)
-- Name: tb01_h_locstd_bkp_20250512; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_locstd_bkp_20250512 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    eventdate date
);


ALTER TABLE public.tb01_h_locstd_bkp_20250512 OWNER TO psql;

--
-- TOC entry 308 (class 1259 OID 47373928)
-- Name: tb01_h_locstd_bkp_20250518; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_locstd_bkp_20250518 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    eventdate date
);


ALTER TABLE public.tb01_h_locstd_bkp_20250518 OWNER TO psql;

--
-- TOC entry 309 (class 1259 OID 47373933)
-- Name: tb01_h_locstd_bkp_20250525; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_locstd_bkp_20250525 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    eventdate date
);


ALTER TABLE public.tb01_h_locstd_bkp_20250525 OWNER TO psql;

--
-- TOC entry 310 (class 1259 OID 47373938)
-- Name: tb01_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_prodlifestd OWNER TO psql;

--
-- TOC entry 311 (class 1259 OID 47373944)
-- Name: tb01_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_prodstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_prodstd OWNER TO psql;

--
-- TOC entry 312 (class 1259 OID 47373950)
-- Name: tb01_h_prodstd_jul30; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_prodstd_jul30 (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    ancestor5 text,
    ancestor6 text,
    eventdate date
);


ALTER TABLE public.tb01_h_prodstd_jul30 OWNER TO psql;

--
-- TOC entry 313 (class 1259 OID 47373955)
-- Name: tb01_h_timeflrset; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_timeflrset (
    id text NOT NULL,
    ancestor0 text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_timeflrset OWNER TO psql;

--
-- TOC entry 314 (class 1259 OID 47373961)
-- Name: tb01_h_timeflrset_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_timeflrset_bkp (
    id text,
    ancestor0 text,
    eventdate date
);


ALTER TABLE public.tb01_h_timeflrset_bkp OWNER TO psql;

--
-- TOC entry 315 (class 1259 OID 47373966)
-- Name: tb01_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_timestd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_h_timestd OWNER TO psql;

--
-- TOC entry 316 (class 1259 OID 47373972)
-- Name: tb01_h_timestd_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_timestd_bkp (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    eventdate date
);


ALTER TABLE public.tb01_h_timestd_bkp OWNER TO psql;

--
-- TOC entry 317 (class 1259 OID 47373977)
-- Name: tb01_h_timestd_test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_h_timestd_test (
    id text,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    eventdate date
);


ALTER TABLE public.tb01_h_timestd_test OWNER TO psql;

--
-- TOC entry 318 (class 1259 OID 47373982)
-- Name: tb01_ma_channelattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_channelattributes (
    indx integer,
    location text,
    chnllatitude text,
    chnllongitude text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_channelattributes OWNER TO psql;

--
-- TOC entry 319 (class 1259 OID 47373988)
-- Name: tb01_ma_classchnlattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_classchnlattributes (
    indx integer,
    product text,
    location text,
    promoelas real,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_classchnlattributes OWNER TO psql;

--
-- TOC entry 320 (class 1259 OID 47373994)
-- Name: tb01_ma_dptflrsetattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_dptflrsetattributes (
    indx integer,
    product text NOT NULL,
    "time" text NOT NULL,
    initialrcptwk text,
    rcptend text,
    rcptstart text,
    slsend text,
    slsstart text,
    lyslsend text,
    lyslsstart text,
    too integer,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_dptflrsetattributes OWNER TO psql;

--
-- TOC entry 321 (class 1259 OID 47374000)
-- Name: tb01_ma_dptflrsetattributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_dptflrsetattributes_bkp (
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
    eventdate date
);


ALTER TABLE public.tb01_ma_dptflrsetattributes_bkp OWNER TO psql;

--
-- TOC entry 322 (class 1259 OID 47374005)
-- Name: tb01_ma_globalregionattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_globalregionattributes (
    indx integer,
    location text,
    globalregionlatitude text,
    globalregionlongitude text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_globalregionattributes OWNER TO psql;

--
-- TOC entry 323 (class 1259 OID 47374011)
-- Name: tb01_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_imgattributes (
    indx integer,
    product text NOT NULL,
    img text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_imgattributes OWNER TO psql;

--
-- TOC entry 324 (class 1259 OID 47374017)
-- Name: tb01_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_storeattributes (
    indx integer,
    location text,
    strbrand text,
    strbusinessunit text,
    strclimate text,
    strglobalregion text,
    strlocationdesc text,
    strlocationfohtier text,
    strlocationtype text,
    strsalesmarket text,
    strsalesregion text,
    strlongitude text,
    strlatitude text,
    strsellingchannel text,
    strcustomerarea text,
    strcustomergroup text,
    strchainname text,
    eventdate date DEFAULT CURRENT_DATE,
    strpricechannel text,
    strplant text
);


ALTER TABLE public.tb01_ma_storeattributes OWNER TO psql;

--
-- TOC entry 325 (class 1259 OID 47374026)
-- Name: tb01_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_stylecolorattributes (
    indx integer,
    product text,
    ccbrandcode text,
    ccbranddesc text,
    ccline text,
    cclaunchyear text,
    cclaunchmonth text,
    ccproductareacode text,
    ccproductareadesc text,
    ccproductcategorycode text,
    ccproductcategorydesc text,
    ccclasscode text,
    ccclassdesc text,
    ccsubclasscode text,
    ccsubclassdesc text,
    stylecolorname text,
    stylename text,
    styledescription text,
    stylecolordescription text,
    cccolorcode text,
    cccolorfamily text,
    cctypology text,
    cctypologydesc text,
    ccstylefamily text,
    ccstylegroup text,
    cccolor text,
    ccmaterialstatus text,
    ccpdmadoptedflag text,
    ccfabrictype text,
    ccexclusive text,
    ccreplenishmentflag text,
    ccdiscontinuemonth text,
    ccdiscontinueyear text,
    ccheeltype text,
    ccshape text,
    cctoetype text,
    ccpricerange text,
    cclogo text,
    ccpattern text,
    ccmerchseasoncode text,
    ccmerchseasondesc text,
    ccpurchasingseasoncode text,
    ccpurchasingseason text,
    ccpurchasingyear text,
    ccpurchasingdeliverycode text,
    ccpurchasingdeliveryname text,
    ccbrand text,
    cclaunchmonthyear text,
    ccproductarea text,
    ccproductcategory text,
    ccclass text,
    ccsubclass text,
    ccdiscontinuemonthyear text,
    ccpurchasingseasonyear text,
    ccdeliverynameyear text,
    cccarryoverflag text,
    ccstylefohtier text,
    ccsilhouette text,
    ccsolidprintnovelty text,
    cctktprc text,
    cclndcst text,
    ccextcost text,
    eventdate date DEFAULT CURRENT_DATE,
    ccdiscontinuestrategy text,
    ccproductsegmentation text,
    ccmerchandisingmaterialtype text,
    cccolorsubcategory text,
    ccassortmentflag text,
    ccwindowlook text,
    ccmarketingflag text,
    ccrunwayflag text,
    ccgcis_northamerica text,
    ccgcis_international text,
    ccflag365 text,
    ccfloorsetdate text
);


ALTER TABLE public.tb01_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 326 (class 1259 OID 47374032)
-- Name: tb01_ma_stylecolorattributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_stylecolorattributes_bkp (
    indx integer,
    product text,
    ccbrandcode text,
    ccbranddesc text,
    ccline text,
    cclaunchyear text,
    cclaunchmonth text,
    ccproductareacode text,
    ccproductareadesc text,
    ccproductcategorycode text,
    ccproductcategorydesc text,
    ccclasscode text,
    ccclassdesc text,
    ccsubclasscode text,
    ccsubclassdesc text,
    stylecolorname text,
    stylename text,
    styledescription text,
    stylecolordescription text,
    cccolorcode text,
    cccolorfamily text,
    cctypology text,
    cctypologydesc text,
    ccstylefamily text,
    ccstylegroup text,
    cccolor text,
    ccmaterialstatus text,
    ccpdmadoptedflag text,
    ccfabrictype text,
    ccexclusive text,
    ccreplenishmentflag text,
    ccdiscontinuemonth text,
    ccdiscontinueyear text,
    ccheeltype text,
    ccshape text,
    cctoetype text,
    ccpricerange text,
    cclogo text,
    ccpattern text,
    ccmerchseasoncode text,
    ccmerchseasondesc text,
    ccpurchasingseasoncode text,
    ccpurchasingseason text,
    ccpurchasingyear text,
    ccpurchasingdeliverycode text,
    ccpurchasingdeliveryname text,
    ccbrand text,
    cclaunchmonthyear text,
    ccproductarea text,
    ccproductcategory text,
    ccclass text,
    ccsubclass text,
    ccdiscontinuemonthyear text,
    ccpurchasingseasonyear text,
    ccdeliverynameyear text,
    cccarryoverflag text,
    ccstylefohtier text,
    ccsilhouette text,
    ccsolidprintnovelty text,
    cctktprc text,
    cclndcst text,
    ccextcost text,
    eventdate date
);


ALTER TABLE public.tb01_ma_stylecolorattributes_bkp OWNER TO psql;

--
-- TOC entry 327 (class 1259 OID 47374037)
-- Name: tb01_ma_stylecolorattributes_jul30; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_stylecolorattributes_jul30 (
    indx integer,
    product text,
    ccbrandcode text,
    ccbranddesc text,
    ccline text,
    cclaunchyear text,
    cclaunchmonth text,
    ccproductareacode text,
    ccproductareadesc text,
    ccproductcategorycode text,
    ccproductcategorydesc text,
    ccclasscode text,
    ccclassdesc text,
    ccsubclasscode text,
    ccsubclassdesc text,
    stylecolorname text,
    stylename text,
    styledescription text,
    stylecolordescription text,
    cccolorcode text,
    cccolorfamily text,
    cctypology text,
    cctypologydesc text,
    ccstylefamily text,
    ccstylegroup text,
    cccolor text,
    ccmaterialstatus text,
    ccpdmadoptedflag text,
    ccfabrictype text,
    ccexclusive text,
    ccreplenishmentflag text,
    ccdiscontinuemonth text,
    ccdiscontinueyear text,
    ccheeltype text,
    ccshape text,
    cctoetype text,
    ccpricerange text,
    cclogo text,
    ccpattern text,
    ccmerchseasoncode text,
    ccmerchseasondesc text,
    ccpurchasingseasoncode text,
    ccpurchasingseason text,
    ccpurchasingyear text,
    ccpurchasingdeliverycode text,
    ccpurchasingdeliveryname text,
    ccbrand text,
    cclaunchmonthyear text,
    ccproductarea text,
    ccproductcategory text,
    ccclass text,
    ccsubclass text,
    ccdiscontinuemonthyear text,
    ccpurchasingseasonyear text,
    ccdeliverynameyear text,
    cccarryoverflag text,
    ccstylefohtier text,
    ccsilhouette text,
    ccsolidprintnovelty text,
    cctktprc text,
    cclndcst text,
    ccextcost text,
    eventdate date
);


ALTER TABLE public.tb01_ma_stylecolorattributes_jul30 OWNER TO psql;

--
-- TOC entry 328 (class 1259 OID 47374042)
-- Name: tb01_ma_stylecolorattributes_shadow; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_stylecolorattributes_shadow (
    indx integer,
    product text,
    ccbrandcode text,
    ccbranddesc text,
    ccline text,
    cclaunchyear text,
    cclaunchmonth text,
    ccproductareacode text,
    ccproductareadesc text,
    ccproductcategorycode text,
    ccproductcategorydesc text,
    ccclasscode text,
    ccclassdesc text,
    ccsubclasscode text,
    ccsubclassdesc text,
    stylecolorname text,
    stylename text,
    styledescription text,
    stylecolordescription text,
    cccolorcode text,
    cccolorfamily text,
    cctypology text,
    cctypologydesc text,
    ccstylefamily text,
    ccstylegroup text,
    cccolor text,
    ccmaterialstatus text,
    ccpdmadoptedflag text,
    ccfabrictype text,
    ccexclusive text,
    ccreplenishmentflag text,
    ccdiscontinuemonth text,
    ccdiscontinueyear text,
    ccheeltype text,
    ccshape text,
    cctoetype text,
    ccpricerange text,
    cclogo text,
    ccpattern text,
    ccmerchseasoncode text,
    ccmerchseasondesc text,
    ccpurchasingseasoncode text,
    ccpurchasingseason text,
    ccpurchasingyear text,
    ccpurchasingdeliverycode text,
    ccpurchasingdeliveryname text,
    ccbrand text,
    cclaunchmonthyear text,
    ccproductarea text,
    ccproductcategory text,
    ccclass text,
    ccsubclass text,
    ccdiscontinuemonthyear text,
    ccpurchasingseasonyear text,
    ccdeliverynameyear text,
    cccarryoverflag text,
    ccstylefohtier text,
    ccsilhouette text,
    ccsolidprintnovelty text,
    cctktprc text,
    cclndcst text,
    ccextcost text,
    eventdate date
);


ALTER TABLE public.tb01_ma_stylecolorattributes_shadow OWNER TO psql;

--
-- TOC entry 329 (class 1259 OID 47374047)
-- Name: tb01_ma_stylecolorattributes_shadow2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_stylecolorattributes_shadow2 (
    indx integer,
    product text,
    ccbrandcode text,
    ccbranddesc text,
    ccline text,
    cclaunchyear text,
    cclaunchmonth text,
    ccproductareacode text,
    ccproductareadesc text,
    ccproductcategorycode text,
    ccproductcategorydesc text,
    ccclasscode text,
    ccclassdesc text,
    ccsubclasscode text,
    ccsubclassdesc text,
    stylecolorname text,
    stylename text,
    styledescription text,
    stylecolordescription text,
    cccolorcode text,
    cccolorfamily text,
    cctypology text,
    cctypologydesc text,
    ccstylefamily text,
    ccstylegroup text,
    cccolor text,
    ccmaterialstatus text,
    ccpdmadoptedflag text,
    ccfabrictype text,
    ccexclusive text,
    ccreplenishmentflag text,
    ccdiscontinuemonth text,
    ccdiscontinueyear text,
    ccheeltype text,
    ccshape text,
    cctoetype text,
    ccpricerange text,
    cclogo text,
    ccpattern text,
    ccmerchseasoncode text,
    ccmerchseasondesc text,
    ccpurchasingseasoncode text,
    ccpurchasingseason text,
    ccpurchasingyear text,
    ccpurchasingdeliverycode text,
    ccpurchasingdeliveryname text,
    ccbrand text,
    cclaunchmonthyear text,
    ccproductarea text,
    ccproductcategory text,
    ccclass text,
    ccsubclass text,
    ccdiscontinuemonthyear text,
    ccpurchasingseasonyear text,
    ccdeliverynameyear text,
    cccarryoverflag text,
    ccstylefohtier text,
    ccsilhouette text,
    ccsolidprintnovelty text,
    cctktprc text,
    cclndcst text,
    ccextcost text,
    eventdate date
);


ALTER TABLE public.tb01_ma_stylecolorattributes_shadow2 OWNER TO psql;

--
-- TOC entry 330 (class 1259 OID 47374052)
-- Name: tb01_ma_weekattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_weekattributes (
    "time" text NOT NULL,
    start_date text DEFAULT ''::text,
    end_date text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_ma_weekattributes OWNER TO psql;

--
-- TOC entry 331 (class 1259 OID 47374059)
-- Name: tb01_ma_weekattributes_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_ma_weekattributes_bkp (
    "time" text,
    start_date text,
    end_date text,
    eventdate date
);


ALTER TABLE public.tb01_ma_weekattributes_bkp OWNER TO psql;

--
-- TOC entry 332 (class 1259 OID 47374064)
-- Name: tb01_roledimension; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_roledimension (
    tenantid text DEFAULT 'TB01'::text NOT NULL,
    roleid text NOT NULL,
    dimensionid text NOT NULL,
    levelids text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_roledimension OWNER TO psql;

--
-- TOC entry 333 (class 1259 OID 47374071)
-- Name: tb01_roledimension_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_roledimension_bkp (
    tenantid text,
    roleid text,
    dimensionid text,
    levelids text,
    eventdate date
);


ALTER TABLE public.tb01_roledimension_bkp OWNER TO psql;

--
-- TOC entry 334 (class 1259 OID 47374076)
-- Name: tb01_servicedefn; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_servicedefn (
    service text NOT NULL,
    authlevels text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_servicedefn OWNER TO psql;

--
-- TOC entry 335 (class 1259 OID 47374082)
-- Name: tb01_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_serviceparams (
    id text NOT NULL,
    type text,
    value text,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_serviceparams OWNER TO psql;

--
-- TOC entry 336 (class 1259 OID 47374088)
-- Name: tb01_swatches; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_swatches (
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


ALTER TABLE public.tb01_swatches OWNER TO psql;

--
-- TOC entry 337 (class 1259 OID 47374100)
-- Name: tb01_v_memberbasedvalidvalues; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_v_memberbasedvalidvalues (
    attributeid text,
    membertie text DEFAULT ''::text,
    attributekey text,
    attributevalue text,
    indx integer NOT NULL,
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.tb01_v_memberbasedvalidvalues OWNER TO psql;

--
-- TOC entry 338 (class 1259 OID 47374107)
-- Name: tb01_v_memberbasedvalidvalues_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_v_memberbasedvalidvalues_bkp (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_v_memberbasedvalidvalues_bkp OWNER TO psql;

--
-- TOC entry 339 (class 1259 OID 47374112)
-- Name: tb01_v_memberbasedvalidvalues_indx_seq; Type: SEQUENCE; Schema: public; Owner: psql
--

CREATE SEQUENCE public.tb01_v_memberbasedvalidvalues_indx_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tb01_v_memberbasedvalidvalues_indx_seq OWNER TO psql;

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 339
-- Name: tb01_v_memberbasedvalidvalues_indx_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: psql
--

ALTER SEQUENCE public.tb01_v_memberbasedvalidvalues_indx_seq OWNED BY public.tb01_v_memberbasedvalidvalues.indx;


--
-- TOC entry 340 (class 1259 OID 47374113)
-- Name: tb01_v_memberbasedvalidvalues_shadow; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_v_memberbasedvalidvalues_shadow (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_v_memberbasedvalidvalues_shadow OWNER TO psql;

--
-- TOC entry 341 (class 1259 OID 47374118)
-- Name: tb01_v_memberbasedvalidvalues_shadow2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tb01_v_memberbasedvalidvalues_shadow2 (
    attributeid text,
    membertie text,
    attributekey text,
    attributevalue text,
    indx integer,
    eventdate date
);


ALTER TABLE public.tb01_v_memberbasedvalidvalues_shadow2 OWNER TO psql;

--
-- TOC entry 342 (class 1259 OID 47374123)
-- Name: test; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.test (
    roleid text,
    authid text
);


ALTER TABLE public.test OWNER TO psql;

--
-- TOC entry 343 (class 1259 OID 47374128)
-- Name: test2; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.test2 (
    roleid text,
    authid text
);


ALTER TABLE public.test2 OWNER TO psql;

--
-- TOC entry 344 (class 1259 OID 47374133)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 345 (class 1259 OID 47374138)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 346 (class 1259 OID 47374143)
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
-- TOC entry 347 (class 1259 OID 47374151)
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
-- TOC entry 348 (class 1259 OID 47374156)
-- Name: user_bkp; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_bkp (
    tenantid text,
    id text,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date
);


ALTER TABLE public.user_bkp OWNER TO psql;

--
-- TOC entry 349 (class 1259 OID 47374161)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 350 (class 1259 OID 47374166)
-- Name: user_tbl; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl (
    tenantid text NOT NULL,
    id text NOT NULL,
    description text DEFAULT 'User'::text,
    name text DEFAULT 'User'::text,
    password text DEFAULT 'blah'::text,
    roles text[],
    eventdate date DEFAULT CURRENT_DATE
);


ALTER TABLE public.user_tbl OWNER TO psql;

--
-- TOC entry 351 (class 1259 OID 47374175)
-- Name: user_tbl_bkup_061219; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_tbl_bkup_061219 (
    tenantid text,
    id text,
    description text,
    name text,
    password text,
    roles text[],
    eventdate date
);


ALTER TABLE public.user_tbl_bkup_061219 OWNER TO psql;

--
-- TOC entry 352 (class 1259 OID 47374180)
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
-- TOC entry 4612 (class 2604 OID 47374188)
-- Name: actuals_loaded id; Type: DEFAULT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.actuals_loaded ALTER COLUMN id SET DEFAULT nextval('mfp.actuals_loaded_id_seq'::regclass);


--
-- TOC entry 4700 (class 2604 OID 47374189)
-- Name: tb01_v_memberbasedvalidvalues indx; Type: DEFAULT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_v_memberbasedvalidvalues ALTER COLUMN indx SET DEFAULT nextval('tb01_v_memberbasedvalidvalues_indx_seq'::regclass);


--
-- TOC entry 4719 (class 2606 OID 47374612)
-- Name: actuals_loaded actuals_loaded_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.actuals_loaded
    ADD CONSTRAINT actuals_loaded_pkey PRIMARY KEY (id);


--
-- TOC entry 4733 (class 2606 OID 47374614)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 4722 (class 2606 OID 47374616)
-- Name: dimensions dimension_levelid_indx_uniqe; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimension_levelid_indx_uniqe UNIQUE (dimension, levelid, indx);


--
-- TOC entry 4743 (class 2606 OID 47374618)
-- Name: dimensions_staging_042023 dimension_staging_levelid_indx_uniqe; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions_staging_042023
    ADD CONSTRAINT dimension_staging_levelid_indx_uniqe UNIQUE (dimension, levelid, indx);


--
-- TOC entry 4726 (class 2606 OID 47374620)
-- Name: dimensions dimensions_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimensions_pkey PRIMARY KEY (id);


--
-- TOC entry 4745 (class 2606 OID 47374622)
-- Name: dimensions_staging_042023 dimensions_staging_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions_staging_042023
    ADD CONSTRAINT dimensions_staging_pkey PRIMARY KEY (id);


--
-- TOC entry 4749 (class 2606 OID 47374624)
-- Name: metadata metadata_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (key);


--
-- TOC entry 4752 (class 2606 OID 47374626)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4754 (class 2606 OID 47374628)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location, prodlife);


--
-- TOC entry 4756 (class 2606 OID 47374630)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 4735 (class 2606 OID 47374632)
-- Name: d_location tb01_d_location_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.d_location
    ADD CONSTRAINT tb01_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 4737 (class 2606 OID 47374634)
-- Name: d_prodlife tb01_d_prodlife_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.d_prodlife
    ADD CONSTRAINT tb01_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 4739 (class 2606 OID 47374636)
-- Name: d_product tb01_d_product_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.d_product
    ADD CONSTRAINT tb01_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 4741 (class 2606 OID 47374638)
-- Name: d_time tb01_d_time_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.d_time
    ADD CONSTRAINT tb01_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 4747 (class 2606 OID 47374640)
-- Name: h_prodlifestd tb01_h_prodlifestd_new_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.h_prodlifestd
    ADD CONSTRAINT tb01_h_prodlifestd_new_pkey PRIMARY KEY (id, ancestor);


--
-- TOC entry 4761 (class 2606 OID 47374642)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 4763 (class 2606 OID 47374644)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 4851 (class 2606 OID 62715133)
-- Name: agent_conversations_log agent_conversations_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT agent_conversations_log_pkey PRIMARY KEY (message_id);


--
-- TOC entry 4849 (class 2606 OID 62715118)
-- Name: agent_conversations agent_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations
    ADD CONSTRAINT agent_conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4765 (class 2606 OID 47374646)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 4794 (class 2606 OID 47374648)
-- Name: tb01_a_assortment assort_perf_pk; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_a_assortment
    ADD CONSTRAINT assort_perf_pk PRIMARY KEY (product, "time", location);


--
-- TOC entry 4767 (class 2606 OID 47374653)
-- Name: bd_ma_stylecolorattributes bd_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorattributes
    ADD CONSTRAINT bd_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4769 (class 2606 OID 47374655)
-- Name: bd_ma_stylecolorweekattributes bd_ma_stylecolorweekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.bd_ma_stylecolorweekattributes
    ADD CONSTRAINT bd_ma_stylecolorweekattributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 4771 (class 2606 OID 47374657)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 4773 (class 2606 OID 47374659)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 4775 (class 2606 OID 47374661)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 4777 (class 2606 OID 47374663)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 4782 (class 2606 OID 47374665)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 4784 (class 2606 OID 47374667)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 4786 (class 2606 OID 47374669)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 4788 (class 2606 OID 47374671)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 4790 (class 2606 OID 47374673)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 4792 (class 2606 OID 47374675)
-- Name: targetsetting targetsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.targetsetting
    ADD CONSTRAINT targetsetting_pkey PRIMARY KEY (id, version, type, scope_hash);


--
-- TOC entry 4796 (class 2606 OID 47374677)
-- Name: tb01_a_assortment_old tb01_a_assortment_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_a_assortment_old
    ADD CONSTRAINT tb01_a_assortment_pkey PRIMARY KEY (product, location, "time", plan_type);


--
-- TOC entry 4798 (class 2606 OID 47374731)
-- Name: tb01_authorization tb01_authorization_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_authorization
    ADD CONSTRAINT tb01_authorization_pkey PRIMARY KEY (roleid, authid);


--
-- TOC entry 4800 (class 2606 OID 47374733)
-- Name: tb01_d_cluster tb01_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_d_cluster
    ADD CONSTRAINT tb01_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 47374735)
-- Name: tb01_d_location tb01_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_d_location
    ADD CONSTRAINT tb01_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 47374737)
-- Name: tb01_d_prodlife tb01_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_d_prodlife
    ADD CONSTRAINT tb01_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 4806 (class 2606 OID 47374739)
-- Name: tb01_d_product tb01_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_d_product
    ADD CONSTRAINT tb01_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 2606 OID 47374741)
-- Name: tb01_d_time tb01_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_d_time
    ADD CONSTRAINT tb01_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 4810 (class 2606 OID 47374743)
-- Name: tb01_h_clusterstd tb01_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_clusterstd
    ADD CONSTRAINT tb01_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 47374745)
-- Name: tb01_h_locdcstd tb01_h_locdcstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_locdcstd
    ADD CONSTRAINT tb01_h_locdcstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4814 (class 2606 OID 47374747)
-- Name: tb01_h_locstd tb01_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_locstd
    ADD CONSTRAINT tb01_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 47374749)
-- Name: tb01_h_prodlifestd tb01_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_prodlifestd
    ADD CONSTRAINT tb01_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2606 OID 47374751)
-- Name: tb01_h_prodstd tb01_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_prodstd
    ADD CONSTRAINT tb01_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 47374753)
-- Name: tb01_h_timeflrset tb01_h_timeflrset_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_timeflrset
    ADD CONSTRAINT tb01_h_timeflrset_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 47374755)
-- Name: tb01_h_timestd tb01_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_h_timestd
    ADD CONSTRAINT tb01_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 47374757)
-- Name: tb01_ma_dptflrsetattributes tb01_ma_dptflrsetattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_ma_dptflrsetattributes
    ADD CONSTRAINT tb01_ma_dptflrsetattributes_pkey PRIMARY KEY (product, "time");


--
-- TOC entry 4826 (class 2606 OID 47374759)
-- Name: tb01_ma_imgattributes tb01_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_ma_imgattributes
    ADD CONSTRAINT tb01_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4828 (class 2606 OID 47374764)
-- Name: tb01_ma_weekattributes tb01_ma_weekattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_ma_weekattributes
    ADD CONSTRAINT tb01_ma_weekattributes_pkey PRIMARY KEY ("time");


--
-- TOC entry 4830 (class 2606 OID 47374766)
-- Name: tb01_roledimension tb01_roledimension_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_roledimension
    ADD CONSTRAINT tb01_roledimension_pkey PRIMARY KEY (tenantid, roleid, dimensionid);


--
-- TOC entry 4832 (class 2606 OID 47374768)
-- Name: tb01_servicedefn tb01_servicedefn_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_servicedefn
    ADD CONSTRAINT tb01_servicedefn_pkey PRIMARY KEY (service);


--
-- TOC entry 4834 (class 2606 OID 47374770)
-- Name: tb01_serviceparams tb01_serviceparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_serviceparams
    ADD CONSTRAINT tb01_serviceparams_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 47374772)
-- Name: tb01_swatches tb01_swatches_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_swatches
    ADD CONSTRAINT tb01_swatches_pkey PRIMARY KEY (validvalue);


--
-- TOC entry 4838 (class 2606 OID 47374774)
-- Name: tb01_v_memberbasedvalidvalues tb01_v_memberbasedvalidvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.tb01_v_memberbasedvalidvalues
    ADD CONSTRAINT tb01_v_memberbasedvalidvalues_pkey PRIMARY KEY (indx);


--
-- TOC entry 4779 (class 2606 OID 47374776)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 4841 (class 2606 OID 47374778)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 4843 (class 2606 OID 47374780)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 4845 (class 2606 OID 47374782)
-- Name: user_tbl user_tbl_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_tbl
    ADD CONSTRAINT user_tbl_pkey PRIMARY KEY (tenantid, id);


--
-- TOC entry 4847 (class 2606 OID 47374784)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 4717 (class 1259 OID 47374785)
-- Name: actuals_loaded_by_dimensions; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_loaded_by_dimensions ON mfp.actuals_loaded USING btree ("time", location, product, prodlife);


--
-- TOC entry 4729 (class 1259 OID 47374786)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp.actuals_wide_denorm USING btree (time_fiscalyear, product_department, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 4730 (class 1259 OID 47374787)
-- Name: actuals_wide_denorm_global_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_global_down ON mfp.actuals_wide_denorm USING btree (time_fiscalyear, product_brand, location_locbrand, prodlife_prodliferootlevel);


--
-- TOC entry 4731 (class 1259 OID 47374788)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp.actuals_wide_denorm USING btree (time_fiscalyear, product_brand, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 4720 (class 1259 OID 47374789)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp.actuals_wide USING btree ("time", product, location, prodlife);


--
-- TOC entry 4723 (class 1259 OID 47374799)
-- Name: dimensions_by_dimension; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX dimensions_by_dimension ON mfp.dimensions USING btree (dimension);


--
-- TOC entry 4724 (class 1259 OID 47374800)
-- Name: dimensions_id_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX dimensions_id_idx ON mfp.dimensions USING btree (id);

ALTER TABLE mfp.dimensions CLUSTER ON dimensions_id_idx;


--
-- TOC entry 4727 (class 1259 OID 47374801)
-- Name: hierarchies_by_dimension_hierarchy; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX hierarchies_by_dimension_hierarchy ON mfp.hierarchies USING btree (dimension, hierarchy);


--
-- TOC entry 4728 (class 1259 OID 47374802)
-- Name: hierarchies_by_dimension_hierarchy_ancestor; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX hierarchies_by_dimension_hierarchy_ancestor ON mfp.hierarchies USING btree (dimension, hierarchy, ancestor);


--
-- TOC entry 4750 (class 1259 OID 47374803)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp.plan_data_wide USING hash (id);


--
-- TOC entry 4757 (class 1259 OID 47374985)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp.sys_gen_wide_denorm USING btree (time_fiscalyear, product_department, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 4758 (class 1259 OID 47374986)
-- Name: sys_gen_wide_denorm_global_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_global_down ON mfp.sys_gen_wide_denorm USING btree (time_fiscalyear, product_brand, location_locbrand, prodlife_prodliferootlevel);


--
-- TOC entry 4759 (class 1259 OID 47374987)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp.sys_gen_wide_denorm USING btree (time_fiscalyear, product_brand, location_channel, prodlife_prodliferootlevel);


--
-- TOC entry 4780 (class 1259 OID 47374988)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 4839 (class 1259 OID 47374989)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 4867 (class 2620 OID 47374990)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION notify_pivot_execution_change();


--
-- TOC entry 4868 (class 2620 OID 47374991)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION notify_plan_queue_change();


--
-- TOC entry 4852 (class 2606 OID 47374992)
-- Name: hierarchies hierarchies_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_dimension_fkey FOREIGN KEY (id) REFERENCES mfp.dimensions(id) ON UPDATE CASCADE;


--
-- TOC entry 4855 (class 2606 OID 47374997)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4853 (class 2606 OID 47375002)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp.plans(id) ON DELETE CASCADE;


--
-- TOC entry 4854 (class 2606 OID 47375007)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp.plans(id);


--
-- TOC entry 4856 (class 2606 OID 47375012)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4858 (class 2606 OID 47375017)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 4859 (class 2606 OID 47375022)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 4861 (class 2606 OID 47375027)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES cart_queue(cart_id);


--
-- TOC entry 4866 (class 2606 OID 62715134)
-- Name: agent_conversations_log fk_agent_conversations_log_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.agent_conversations_log
    ADD CONSTRAINT fk_agent_conversations_log_conversation_id FOREIGN KEY (conversation_id) REFERENCES agent_conversations(conversation_id);


--
-- TOC entry 4857 (class 2606 OID 47375032)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES allocation_plan_queue(jobid);


--
-- TOC entry 4864 (class 2606 OID 47375037)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 47375042)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 4860 (class 2606 OID 47375047)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 4863 (class 2606 OID 47375052)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES scope(id);


--
-- TOC entry 4862 (class 2606 OID 47375057)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES user_metadata(uid);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:08:23 IST

--
-- PostgreSQL database dump complete
--

\unrestrict dzmoR1IaEepAuSOuDU6UHBtNLmygBFYTq4G0ND36PjGcs2neYpTE27PmpDChOm8

