-- ENV: QA | DB: lp | dumped: 2026-10-01 15:07 IST | server 14.22 (pg_dump 18.6, plain, schema-only)
--
-- PostgreSQL database dump
--

\restrict TIfrYGgx8UadMT0zyjfuIGVtZdTiIpCegjFqWfht6N3IVTi0fOpWFkTPBXt9rr4

-- Dumped from database version 14.22
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-01 15:07:27 IST

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
-- TOC entry 7 (class 2615 OID 4714380)
-- Name: mfp; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp;


ALTER SCHEMA mfp OWNER TO psql;

--
-- TOC entry 8 (class 2615 OID 4714381)
-- Name: mfp_backup; Type: SCHEMA; Schema: -; Owner: psql
--

CREATE SCHEMA mfp_backup;


ALTER SCHEMA mfp_backup OWNER TO psql;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: oci_superuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO oci_superuser;

--
-- TOC entry 2 (class 3079 OID 4714382)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 918 (class 1247 OID 4714394)
-- Name: approval; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp.approval OWNER TO psql;

--
-- TOC entry 921 (class 1247 OID 4714400)
-- Name: permission; Type: TYPE; Schema: mfp; Owner: psql
--

CREATE TYPE mfp.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp.permission OWNER TO psql;

--
-- TOC entry 924 (class 1247 OID 4714408)
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
-- TOC entry 927 (class 1247 OID 4714424)
-- Name: approval; Type: TYPE; Schema: mfp_backup; Owner: psql
--

CREATE TYPE mfp_backup.approval AS ENUM (
    'op',
    'rp'
);


ALTER TYPE mfp_backup.approval OWNER TO psql;

--
-- TOC entry 930 (class 1247 OID 4714430)
-- Name: permission; Type: TYPE; Schema: mfp_backup; Owner: psql
--

CREATE TYPE mfp_backup.permission AS ENUM (
    'read',
    'plan',
    'admin'
);


ALTER TYPE mfp_backup.permission OWNER TO psql;

--
-- TOC entry 933 (class 1247 OID 4714438)
-- Name: scopetype; Type: TYPE; Schema: mfp_backup; Owner: psql
--

CREATE TYPE mfp_backup.scopetype AS ENUM (
    'actuals',
    'morphed',
    'working',
    'saved',
    'submitted',
    'approved',
    'hidden'
);


ALTER TYPE mfp_backup.scopetype OWNER TO psql;

--
-- TOC entry 936 (class 1247 OID 4714454)
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
-- TOC entry 939 (class 1247 OID 4714466)
-- Name: undo_status; Type: TYPE; Schema: public; Owner: psql
--

CREATE TYPE public.undo_status AS ENUM (
    'invalid',
    'undone'
);


ALTER TYPE public.undo_status OWNER TO psql;

--
-- TOC entry 303 (class 1255 OID 4714471)
-- Name: notify_pivot_execution_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_pivot_execution_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY pivot_execution_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_pivot_execution_change() OWNER TO psql;

--
-- TOC entry 304 (class 1255 OID 4714472)
-- Name: notify_plan_queue_change(); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.notify_plan_queue_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN EXECUTE 'NOTIFY plan_queue_change';
            RETURN NEW; END; $$;


ALTER FUNCTION public.notify_plan_queue_change() OWNER TO psql;

--
-- TOC entry 305 (class 1255 OID 4714473)
-- Name: plan_eligible(text[]); Type: FUNCTION; Schema: public; Owner: psql
--

CREATE FUNCTION public.plan_eligible(products text[]) RETURNS TABLE(product text, location text)
    LANGUAGE plpgsql
    AS $$
        BEGIN
            RETURN QUERY
            SELECT scca.product, scca.location
            FROM lp_ma_stylecolorchannelattributes scca INNER JOIN UNNEST(products) arg
            ON scca.product=arg
            WHERE scca.record_state=0;
        END
        $$;


ALTER FUNCTION public.plan_eligible(products text[]) OWNER TO psql;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 4714474)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL
);


ALTER TABLE mfp.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 213 (class 1259 OID 4714479)
-- Name: actuals_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL,
    bookings_u double precision,
    bookings_r double precision,
    bookings_r_msrp double precision,
    bookings_c double precision
);


ALTER TABLE mfp.actuals_wide OWNER TO psql;

--
-- TOC entry 214 (class 1259 OID 4714484)
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
-- TOC entry 215 (class 1259 OID 4714489)
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
-- TOC entry 272 (class 1259 OID 65047704)
-- Name: location_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.location_denorm AS
 SELECT total_location.id AS total_location,
    channel_group.id AS channel_group,
    channel.id AS channel,
    selling_channel.id AS selling_channel
   FROM (((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'location'::text) AND (dimensions.levelid = 'selling_channel'::text))) selling_channel
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = selling_channel.id) AND (hierarchies.hierarchy = 'locstd'::text))) channel ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = channel.id) AND (hierarchies.hierarchy = 'locstd'::text))) channel_group ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = channel_group.id) AND (hierarchies.hierarchy = 'locstd'::text))) total_location ON (true));


ALTER VIEW mfp.location_denorm OWNER TO psql;

--
-- TOC entry 271 (class 1259 OID 65047699)
-- Name: product_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.product_denorm AS
 SELECT total_products.id AS total_products,
    division.id AS division,
    department.id AS department,
    class.id AS class
   FROM (((( SELECT dimensions.id
           FROM mfp.dimensions
          WHERE ((dimensions.dimension = 'product'::text) AND (dimensions.levelid = 'class'::text))) class
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = class.id) AND (hierarchies.hierarchy = 'prodstd'::text))) department ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = department.id) AND (hierarchies.hierarchy = 'prodstd'::text))) division ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = division.id) AND (hierarchies.hierarchy = 'prodstd'::text))) total_products ON (true));


ALTER VIEW mfp.product_denorm OWNER TO psql;

--
-- TOC entry 270 (class 1259 OID 65047694)
-- Name: time_denorm; Type: VIEW; Schema: mfp; Owner: psql
--

CREATE VIEW mfp.time_denorm AS
 SELECT total_time.id AS total_time,
    year.id AS year,
    season.id AS season,
    quarter.id AS quarter,
    month.id AS month,
    week.id AS week
   FROM (((((( SELECT dimensions.id
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
          WHERE ((hierarchies.id = quarter.id) AND (hierarchies.hierarchy = 'timestd'::text))) season ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = season.id) AND (hierarchies.hierarchy = 'timestd'::text))) year ON (true))
     JOIN LATERAL ( SELECT hierarchies.ancestor AS id
           FROM mfp.hierarchies
          WHERE ((hierarchies.id = year.id) AND (hierarchies.hierarchy = 'timestd'::text))) total_time ON (true));


ALTER VIEW mfp.time_denorm OWNER TO psql;

--
-- TOC entry 273 (class 1259 OID 65047709)
-- Name: actuals_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.actuals_wide_denorm AS
 SELECT "time".week AS time_week,
    "time".year AS time_year,
    product.class AS product_class,
    product.department AS product_department,
    product.total_products AS product_total_products,
    location.selling_channel AS location_selling_channel,
    location.total_location AS location_total_location,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.net_sls_u,
    wide.net_sls_r,
    wide.net_sls_c,
    wide.net_sls_r_at_msrp,
    wide.pos_md_r,
    wide.dmd_u,
    wide.dmd_r,
    wide.dmd_r_msrp,
    wide.dmd_c,
    wide.rec_u,
    wide.rec_c,
    wide.rec_r_msrp,
    wide.on_order_u,
    wide.on_order_c,
    wide.on_order_r_msrp,
    wide.net_allocation_u,
    wide.net_allocation_r_msrp,
    wide.net_allocation_c,
    wide.net_whsl_transfer_u,
    wide.net_whsl_transfer_r_msrp,
    wide.net_whsl_transfer_c,
    wide.net_transfer_to_off_price_acct_u,
    wide.net_transfer_to_off_price_acct_r_msrp,
    wide.net_transfer_to_off_price_acct_c,
    wide.net_transfer_to_ecom_sale_u,
    wide.net_transfer_to_ecom_sale_r_msrp,
    wide.net_transfer_to_ecom_sale_c,
    wide.boh_r_msrp,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r_msrp,
    wide.eoh_c,
    wide.avail_to_sell_u,
    wide.avail_to_sell_r_msrp,
    wide.avail_to_sell_c,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r_msrp,
    wide.inv_adjustment_c,
    wide.rgm_r,
    wide.wgm_r,
    wide.net_sls_imu_r,
    wide.bookings_u,
    wide.bookings_r,
    wide.bookings_r_msrp,
    wide.bookings_c
   FROM (((mfp.actuals_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.year
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.total_products
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.selling_channel,
            location_denorm.total_location
           FROM mfp.location_denorm) location ON ((location.selling_channel = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.actuals_wide_denorm OWNER TO psql;

--
-- TOC entry 216 (class 1259 OID 4714516)
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
-- TOC entry 217 (class 1259 OID 4714522)
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
-- TOC entry 269 (class 1259 OID 35795172)
-- Name: dimensions_dup; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.dimensions_dup (
    dimension text,
    id text,
    name text,
    description text,
    levelid text,
    indx integer
);


ALTER TABLE mfp.dimensions_dup OWNER TO psql;

--
-- TOC entry 218 (class 1259 OID 4714528)
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
-- TOC entry 219 (class 1259 OID 4714533)
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
-- TOC entry 220 (class 1259 OID 4714538)
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
-- TOC entry 221 (class 1259 OID 4714544)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL,
    bookings_u double precision,
    bookings_r double precision,
    bookings_r_msrp double precision,
    bookings_c double precision
);


ALTER TABLE mfp.plan_data_wide OWNER TO psql;

--
-- TOC entry 222 (class 1259 OID 4714549)
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
-- TOC entry 223 (class 1259 OID 4714550)
-- Name: plan_init_status; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp.plan_init_status OWNER TO psql;

--
-- TOC entry 224 (class 1259 OID 4714553)
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
-- TOC entry 225 (class 1259 OID 4714562)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    net_sls_u double precision,
    net_sls_r double precision,
    net_sls_c double precision,
    net_sls_r_at_msrp double precision,
    pos_md_r double precision,
    dmd_u double precision,
    dmd_r double precision,
    dmd_r_msrp double precision,
    dmd_c double precision,
    rec_u double precision,
    rec_c double precision,
    rec_r_msrp double precision,
    on_order_u double precision,
    on_order_c double precision,
    on_order_r_msrp double precision,
    net_allocation_u double precision,
    net_allocation_r_msrp double precision,
    net_allocation_c double precision,
    net_whsl_transfer_u double precision,
    net_whsl_transfer_r_msrp double precision,
    net_whsl_transfer_c double precision,
    net_transfer_to_off_price_acct_u double precision,
    net_transfer_to_off_price_acct_r_msrp double precision,
    net_transfer_to_off_price_acct_c double precision,
    net_transfer_to_ecom_sale_u double precision,
    net_transfer_to_ecom_sale_r_msrp double precision,
    net_transfer_to_ecom_sale_c double precision,
    boh_r_msrp double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r_msrp double precision,
    eoh_c double precision,
    avail_to_sell_u double precision,
    avail_to_sell_r_msrp double precision,
    avail_to_sell_c double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r_msrp double precision,
    inv_adjustment_c double precision,
    rgm_r double precision,
    wgm_r double precision,
    net_sls_imu_r double precision,
    bookings_u double precision,
    bookings_r double precision,
    bookings_r_msrp double precision,
    bookings_c double precision
);


ALTER TABLE mfp.sys_gen_wide OWNER TO psql;

--
-- TOC entry 274 (class 1259 OID 65047716)
-- Name: sys_gen_wide_denorm; Type: MATERIALIZED VIEW; Schema: mfp; Owner: psql
--

CREATE MATERIALIZED VIEW mfp.sys_gen_wide_denorm AS
 SELECT wide.sys_version,
    "time".week AS time_week,
    "time".year AS time_year,
    product.class AS product_class,
    product.department AS product_department,
    product.total_products AS product_total_products,
    location.selling_channel AS location_selling_channel,
    location.total_location AS location_total_location,
    wide."time",
    wide.product,
    wide.location,
    wide.storecount,
    wide.net_sls_u,
    wide.net_sls_r,
    wide.net_sls_c,
    wide.net_sls_r_at_msrp,
    wide.pos_md_r,
    wide.dmd_u,
    wide.dmd_r,
    wide.dmd_r_msrp,
    wide.dmd_c,
    wide.rec_u,
    wide.rec_c,
    wide.rec_r_msrp,
    wide.on_order_u,
    wide.on_order_c,
    wide.on_order_r_msrp,
    wide.net_allocation_u,
    wide.net_allocation_r_msrp,
    wide.net_allocation_c,
    wide.net_whsl_transfer_u,
    wide.net_whsl_transfer_r_msrp,
    wide.net_whsl_transfer_c,
    wide.net_transfer_to_off_price_acct_u,
    wide.net_transfer_to_off_price_acct_r_msrp,
    wide.net_transfer_to_off_price_acct_c,
    wide.net_transfer_to_ecom_sale_u,
    wide.net_transfer_to_ecom_sale_r_msrp,
    wide.net_transfer_to_ecom_sale_c,
    wide.boh_r_msrp,
    wide.boh_u,
    wide.boh_c,
    wide.eoh_u,
    wide.eoh_r_msrp,
    wide.eoh_c,
    wide.avail_to_sell_u,
    wide.avail_to_sell_r_msrp,
    wide.avail_to_sell_c,
    wide.inv_adjustment_u,
    wide.inv_adjustment_r_msrp,
    wide.inv_adjustment_c,
    wide.rgm_r,
    wide.wgm_r,
    wide.net_sls_imu_r,
    wide.bookings_u,
    wide.bookings_r,
    wide.bookings_r_msrp,
    wide.bookings_c
   FROM (((mfp.sys_gen_wide wide
     JOIN ( SELECT time_denorm.week,
            time_denorm.year
           FROM mfp.time_denorm) "time" ON (("time".week = wide."time")))
     JOIN ( SELECT product_denorm.class,
            product_denorm.department,
            product_denorm.total_products
           FROM mfp.product_denorm) product ON ((product.class = wide.product)))
     JOIN ( SELECT location_denorm.selling_channel,
            location_denorm.total_location
           FROM mfp.location_denorm) location ON ((location.selling_channel = wide.location)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW mfp.sys_gen_wide_denorm OWNER TO psql;

--
-- TOC entry 226 (class 1259 OID 4714574)
-- Name: tyly; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp.tyly OWNER TO psql;

--
-- TOC entry 227 (class 1259 OID 4714579)
-- Name: user_kv_store; Type: TABLE; Schema: mfp; Owner: psql
--

CREATE TABLE mfp.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp.user_kv_store OWNER TO psql;

--
-- TOC entry 228 (class 1259 OID 4714584)
-- Name: actuals_stage_wide; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.actuals_stage_wide (
    id text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL
);


ALTER TABLE mfp_backup.actuals_stage_wide OWNER TO psql;

--
-- TOC entry 229 (class 1259 OID 4714589)
-- Name: actuals_wide; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.actuals_wide (
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL
);


ALTER TABLE mfp_backup.actuals_wide OWNER TO psql;

--
-- TOC entry 230 (class 1259 OID 4714594)
-- Name: comments; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.comments (
    comment_id uuid NOT NULL,
    author text NOT NULL,
    plan_id integer NOT NULL,
    view_context text NOT NULL,
    view_template_id text NOT NULL,
    content text NOT NULL,
    modified_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_backup.comments OWNER TO psql;

--
-- TOC entry 231 (class 1259 OID 4714600)
-- Name: currency_exchange_rates; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.currency_exchange_rates (
    "time" text NOT NULL,
    location text NOT NULL,
    exchange_ratio double precision NOT NULL,
    currency_id text DEFAULT 'MISSING'::text NOT NULL
);


ALTER TABLE mfp_backup.currency_exchange_rates OWNER TO psql;

--
-- TOC entry 232 (class 1259 OID 4714606)
-- Name: dimensions; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.dimensions (
    dimension text NOT NULL,
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    levelid text NOT NULL,
    indx integer
);


ALTER TABLE mfp_backup.dimensions OWNER TO psql;

--
-- TOC entry 233 (class 1259 OID 4714611)
-- Name: hierarchies; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.hierarchies (
    dimension text NOT NULL,
    hierarchy text NOT NULL,
    id text NOT NULL,
    ancestor text NOT NULL
);


ALTER TABLE mfp_backup.hierarchies OWNER TO psql;

--
-- TOC entry 234 (class 1259 OID 4714616)
-- Name: metadata; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.metadata (
    key text NOT NULL,
    as_int bigint,
    as_string text,
    as_member_id text,
    as_timestamp timestamp with time zone,
    as_member_id_arr text[]
);


ALTER TABLE mfp_backup.metadata OWNER TO psql;

--
-- TOC entry 235 (class 1259 OID 4714621)
-- Name: paired_dimension_links; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.paired_dimension_links (
    source_dimension text NOT NULL,
    target_dimension text NOT NULL,
    source_id text NOT NULL,
    target_id text NOT NULL
);


ALTER TABLE mfp_backup.paired_dimension_links OWNER TO psql;

--
-- TOC entry 236 (class 1259 OID 4714626)
-- Name: plan_audit_log; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.plan_audit_log (
    plan text NOT NULL,
    action text NOT NULL,
    action_by text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE mfp_backup.plan_audit_log OWNER TO psql;

--
-- TOC entry 237 (class 1259 OID 4714632)
-- Name: plan_data_wide; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.plan_data_wide (
    id integer NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision NOT NULL,
    net_sls_u double precision NOT NULL,
    net_sls_r double precision NOT NULL,
    net_sls_c double precision NOT NULL,
    net_sls_r_at_msrp double precision NOT NULL,
    pos_md_r double precision NOT NULL,
    dmd_u double precision NOT NULL,
    dmd_r double precision NOT NULL,
    dmd_r_msrp double precision NOT NULL,
    dmd_c double precision NOT NULL,
    rec_u double precision NOT NULL,
    rec_c double precision NOT NULL,
    rec_r_msrp double precision NOT NULL,
    on_order_u double precision NOT NULL,
    on_order_c double precision NOT NULL,
    on_order_r_msrp double precision NOT NULL,
    net_allocation_u double precision NOT NULL,
    net_allocation_r_msrp double precision NOT NULL,
    net_allocation_c double precision NOT NULL,
    net_whsl_transfer_u double precision NOT NULL,
    net_whsl_transfer_r_msrp double precision NOT NULL,
    net_whsl_transfer_c double precision NOT NULL,
    net_transfer_to_off_price_acct_u double precision NOT NULL,
    net_transfer_to_off_price_acct_r_msrp double precision NOT NULL,
    net_transfer_to_off_price_acct_c double precision NOT NULL,
    net_transfer_to_ecom_sale_u double precision NOT NULL,
    net_transfer_to_ecom_sale_r_msrp double precision NOT NULL,
    net_transfer_to_ecom_sale_c double precision NOT NULL,
    boh_r_msrp double precision NOT NULL,
    boh_u double precision NOT NULL,
    boh_c double precision NOT NULL,
    eoh_u double precision NOT NULL,
    eoh_r_msrp double precision NOT NULL,
    eoh_c double precision NOT NULL,
    avail_to_sell_u double precision NOT NULL,
    avail_to_sell_r_msrp double precision NOT NULL,
    avail_to_sell_c double precision NOT NULL,
    inv_adjustment_u double precision NOT NULL,
    inv_adjustment_r_msrp double precision NOT NULL,
    inv_adjustment_c double precision NOT NULL,
    rgm_r double precision NOT NULL,
    wgm_r double precision NOT NULL,
    net_sls_imu_r double precision NOT NULL
);


ALTER TABLE mfp_backup.plan_data_wide OWNER TO psql;

--
-- TOC entry 238 (class 1259 OID 4714637)
-- Name: plan_id_ticker; Type: SEQUENCE; Schema: mfp_backup; Owner: psql
--

CREATE SEQUENCE mfp_backup.plan_id_ticker
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE mfp_backup.plan_id_ticker OWNER TO psql;

--
-- TOC entry 239 (class 1259 OID 4714638)
-- Name: plan_init_status; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.plan_init_status (
    id integer NOT NULL,
    seeded_at timestamp with time zone,
    balanced_at timestamp with time zone
);


ALTER TABLE mfp_backup.plan_init_status OWNER TO psql;

--
-- TOC entry 240 (class 1259 OID 4714641)
-- Name: plans; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.plans (
    id integer DEFAULT nextval('mfp_backup.plan_id_ticker'::regclass) NOT NULL,
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


ALTER TABLE mfp_backup.plans OWNER TO psql;

--
-- TOC entry 241 (class 1259 OID 4714650)
-- Name: sys_gen_wide; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.sys_gen_wide (
    sys_version text NOT NULL,
    "time" text NOT NULL,
    product text NOT NULL,
    location text NOT NULL,
    storecount double precision,
    net_sls_u double precision,
    net_sls_r double precision,
    net_sls_c double precision,
    net_sls_r_at_msrp double precision,
    pos_md_r double precision,
    dmd_u double precision,
    dmd_r double precision,
    dmd_r_msrp double precision,
    dmd_c double precision,
    rec_u double precision,
    rec_c double precision,
    rec_r_msrp double precision,
    on_order_u double precision,
    on_order_c double precision,
    on_order_r_msrp double precision,
    net_allocation_u double precision,
    net_allocation_r_msrp double precision,
    net_allocation_c double precision,
    net_whsl_transfer_u double precision,
    net_whsl_transfer_r_msrp double precision,
    net_whsl_transfer_c double precision,
    net_transfer_to_off_price_acct_u double precision,
    net_transfer_to_off_price_acct_r_msrp double precision,
    net_transfer_to_off_price_acct_c double precision,
    net_transfer_to_ecom_sale_u double precision,
    net_transfer_to_ecom_sale_r_msrp double precision,
    net_transfer_to_ecom_sale_c double precision,
    boh_r_msrp double precision,
    boh_u double precision,
    boh_c double precision,
    eoh_u double precision,
    eoh_r_msrp double precision,
    eoh_c double precision,
    avail_to_sell_u double precision,
    avail_to_sell_r_msrp double precision,
    avail_to_sell_c double precision,
    inv_adjustment_u double precision,
    inv_adjustment_r_msrp double precision,
    inv_adjustment_c double precision,
    rgm_r double precision,
    wgm_r double precision,
    net_sls_imu_r double precision
);


ALTER TABLE mfp_backup.sys_gen_wide OWNER TO psql;

--
-- TOC entry 242 (class 1259 OID 4714655)
-- Name: tyly; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.tyly (
    ty text NOT NULL,
    ly text NOT NULL
);


ALTER TABLE mfp_backup.tyly OWNER TO psql;

--
-- TOC entry 243 (class 1259 OID 4714660)
-- Name: user_kv_store; Type: TABLE; Schema: mfp_backup; Owner: psql
--

CREATE TABLE mfp_backup.user_kv_store (
    uid text NOT NULL,
    key text NOT NULL,
    value text
);


ALTER TABLE mfp_backup.user_kv_store OWNER TO psql;

--
-- TOC entry 267 (class 1259 OID 35630335)
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
-- TOC entry 268 (class 1259 OID 35630345)
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
-- TOC entry 244 (class 1259 OID 4714665)
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
-- TOC entry 245 (class 1259 OID 4714670)
-- Name: cart_master; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_master (
    jsessionid text
);


ALTER TABLE public.cart_master OWNER TO psql;

--
-- TOC entry 246 (class 1259 OID 4714675)
-- Name: cart_params; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_params (
    jsessionid text
);


ALTER TABLE public.cart_params OWNER TO psql;

--
-- TOC entry 247 (class 1259 OID 4714680)
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
-- TOC entry 248 (class 1259 OID 4714687)
-- Name: cart_ranging; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.cart_ranging (
    jsessionid text
);


ALTER TABLE public.cart_ranging OWNER TO psql;

--
-- TOC entry 249 (class 1259 OID 4714692)
-- Name: current_week; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.current_week (
    current_week character varying(25)
);


ALTER TABLE public.current_week OWNER TO psql;

--
-- TOC entry 250 (class 1259 OID 4714695)
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
-- TOC entry 251 (class 1259 OID 4714700)
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
-- TOC entry 252 (class 1259 OID 4714703)
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
-- TOC entry 253 (class 1259 OID 4714710)
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
-- TOC entry 286 (class 1259 OID 138843613)
-- Name: lp_d_cluster; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_d_cluster (
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


ALTER TABLE public.lp_d_cluster OWNER TO psql;

--
-- TOC entry 281 (class 1259 OID 138843533)
-- Name: lp_d_location; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_d_location (
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


ALTER TABLE public.lp_d_location OWNER TO psql;

--
-- TOC entry 288 (class 1259 OID 138843641)
-- Name: lp_d_prodlife; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_d_prodlife (
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


ALTER TABLE public.lp_d_prodlife OWNER TO psql;

--
-- TOC entry 275 (class 1259 OID 138843441)
-- Name: lp_d_product; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_d_product (
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


ALTER TABLE public.lp_d_product OWNER TO psql;

--
-- TOC entry 284 (class 1259 OID 138843580)
-- Name: lp_d_time; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_d_time (
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


ALTER TABLE public.lp_d_time OWNER TO psql;

--
-- TOC entry 287 (class 1259 OID 138843627)
-- Name: lp_h_clusterstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_h_clusterstd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_h_clusterstd OWNER TO psql;

--
-- TOC entry 282 (class 1259 OID 138843548)
-- Name: lp_h_locstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_h_locstd (
    id text NOT NULL,
    ancestor0 text,
    ancestor1 text,
    ancestor2 text,
    ancestor3 text,
    ancestor4 text,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_h_locstd OWNER TO psql;

--
-- TOC entry 289 (class 1259 OID 138843655)
-- Name: lp_h_prodlifestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_h_prodlifestd (
    id text NOT NULL,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_h_prodlifestd OWNER TO psql;

--
-- TOC entry 276 (class 1259 OID 138843456)
-- Name: lp_h_prodstd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_h_prodstd (
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


ALTER TABLE public.lp_h_prodstd OWNER TO psql;

--
-- TOC entry 285 (class 1259 OID 138843595)
-- Name: lp_h_timestd; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_h_timestd (
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


ALTER TABLE public.lp_h_timestd OWNER TO psql;

--
-- TOC entry 280 (class 1259 OID 138843519)
-- Name: lp_ma_imgattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_ma_imgattributes (
    product text NOT NULL,
    client_id text,
    url text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_ma_imgattributes OWNER TO psql;

--
-- TOC entry 279 (class 1259 OID 138843504)
-- Name: lp_ma_sizeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_ma_sizeattributes (
    product text NOT NULL,
    parent_id text,
    sizeattribute text,
    isvalid integer,
    ccstylecolorsizecreatedate text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_ma_sizeattributes OWNER TO psql;

--
-- TOC entry 283 (class 1259 OID 138843566)
-- Name: lp_ma_storeattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_ma_storeattributes (
    location text NOT NULL,
    strname text,
    str_name_number text,
    str_district text,
    str_region text,
    str_open_status text,
    str_climate text,
    str_hot_temp_cold_seasonal text,
    str_fashion_core text,
    str_mall_type text,
    str_square_footage text,
    str_capacity_grp text,
    str_foh_sq_ft text,
    str_unit_capacity text,
    customer_group_name text,
    customer_group_desc text,
    selling_channel_name text,
    selling_channel_desc text,
    channel_name text,
    channel_desc text,
    channel_group_name text,
    channel_group_desc text,
    total_location_name text,
    total_location_desc text,
    sold_to_account_id text,
    customer_type text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_ma_storeattributes OWNER TO psql;

--
-- TOC entry 277 (class 1259 OID 138843475)
-- Name: lp_ma_styleattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_ma_styleattributes (
    product text NOT NULL,
    sty_style_description text,
    sty_size_range text,
    sty_size_range_name text,
    sty_size_type text,
    sty_patterned_after text,
    sty_is_locked text,
    sty_s5_adopted text,
    sty_num_clones_s5 real,
    sty_num_times_cloned_s5 real,
    ccstylecreatedate timestamp without time zone,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_ma_styleattributes OWNER TO psql;

--
-- TOC entry 278 (class 1259 OID 138843489)
-- Name: lp_ma_stylecolorattributes; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_ma_stylecolorattributes (
    product text NOT NULL,
    client_id text,
    cc_style_desc text,
    cc_color_id text,
    cc_color_desc text,
    cc_color_id_desc text,
    cc_stylecolor_desc text,
    cc_stylecolor_id_desc text,
    cc_print_code text,
    cc_print_name text,
    cc_season text,
    cc_season_code text,
    cc_season_period text,
    cc_year text,
    cc_scp_quarter text,
    cc_season_deliveries text,
    cc_go_live_date text,
    cc_scp_development_type text,
    cc_division text,
    cc_category text,
    cc_sub_category text,
    cc_merch_division text,
    cc_department text,
    cc_class text,
    cc_abs_product_class text,
    cc_style_number text,
    cc_ais_legacy_code text,
    cc_abs_style_number text,
    cc_description text,
    cc_print_pattern_solid_spec text,
    cc_nrf_color_group_family text,
    cc_print_pattern_spec_legacy_code text,
    cc_color_temperature text,
    cc_nrf_shade text,
    cc_shade_description text,
    cc_shade_group_description text,
    cc_surface_color_type text,
    cc_hts_code text,
    cc_production_tax_classification text,
    cc_std_cost real,
    cc_whl_price real,
    cc_retail_price real,
    cc_price_tier text,
    cc_edi_selection text,
    cc_ooe_product_type text,
    cc_coordinate_group text,
    cc_size_range text,
    cc_sizes text,
    cc_sizes_start_end text,
    cc_abs_size_range text,
    cc_production_supplier_id text,
    cc_production_supplier text,
    cc_production_contact text,
    cc_scp_color_category text,
    cc_neck_line text,
    cc_occasion text,
    cc_bra_friendly text,
    cc_dress_length text,
    cc_short_length text,
    cc_skirt_skort_length text,
    cc_swim_type text,
    cc_style_family text,
    cc_bom_main_materials text,
    cc_refinement_short_inseam text,
    cc_refinement_pant_inseam text,
    cc_refinement_jumpsuit_inseam text,
    cc_refinement_romper_inseam text,
    cc_refinement_skirt_skort_inseam text,
    cc_refinement_dress_length text,
    cc_sustainable_material text,
    cc_scp_neon text,
    cc_extra_hem_length text,
    cc_swim_coverage text,
    cc_is_agenda text,
    cc_style_hangtags_ecom text,
    cc_colorway_hangtags_ecom text,
    cc_licensed_product_legacy_code text,
    cc_licensed_product_vendor text,
    cc_licensed_product_type text,
    cc_pillar text,
    cc_resort_occasion text,
    cc_marketing_campaign text,
    cc_the_moment text,
    cc_size_type text,
    cc_ecom_sale_flag_current text,
    cc_actual_initial_receipt_week text,
    ccstylecolorcreatedate text,
    cc_silhouette_bucket text,
    cc_silhouette_category text,
    cc_silo_sub_category text,
    cc_style_type text,
    cc_fit_bucket text,
    cc_dress_fit_bucket text,
    cc_sleeve_type text,
    cc_inseam_length text,
    cc_length_type text,
    cc_material_sub_type text,
    cc_material_sub_class text,
    cc_activity_type text,
    cc_assortment_breakdown text,
    cc_rise text,
    cc_design_detail text,
    cc_surface_add text,
    cc_engineering text,
    cccolor text,
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
    stylecolor_name text,
    style_name text,
    class_name text,
    department_name text,
    division_name text,
    total_products_name text,
    eventdate date DEFAULT CURRENT_DATE,
    version_id bigint DEFAULT 1,
    created_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    created_by text DEFAULT 'system'::text,
    updated_at timestamp without time zone DEFAULT date_trunc('sec'::text, CURRENT_TIMESTAMP),
    updated_by text DEFAULT 'system'::text,
    record_state smallint DEFAULT 0
);


ALTER TABLE public.lp_ma_stylecolorattributes OWNER TO psql;

--
-- TOC entry 290 (class 1259 OID 138843669)
-- Name: lp_serviceparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.lp_serviceparams (
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


ALTER TABLE public.lp_serviceparams OWNER TO psql;

--
-- TOC entry 292 (class 1259 OID 138843688)
-- Name: lp_store_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.lp_store_hier_attr AS
 SELECT s.location,
    s.strname,
    s.str_name_number,
    s.str_district,
    s.str_region,
    s.str_open_status,
    s.str_climate,
    s.str_hot_temp_cold_seasonal,
    s.str_fashion_core,
    s.str_mall_type,
    s.str_square_footage,
    s.str_capacity_grp,
    s.str_foh_sq_ft,
    s.str_unit_capacity,
    s.customer_group_name,
    s.customer_group_desc,
    s.selling_channel_name,
    s.selling_channel_desc,
    s.channel_name,
    s.channel_desc,
    s.channel_group_name,
    s.channel_group_desc,
    s.total_location_name,
    s.total_location_desc,
    s.sold_to_account_id,
    s.customer_type,
    h.id AS store,
    h.ancestor0 AS customer_group,
    h.ancestor1 AS selling_channel,
    h.ancestor2 AS channel,
    h.ancestor3 AS channel_group,
    h.ancestor4 AS total_location,
    s.eventdate,
    s.version_id,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by,
    s.record_state
   FROM (public.lp_ma_storeattributes s
     LEFT JOIN public.lp_h_locstd h ON ((h.id = s.location)));


ALTER VIEW public.lp_store_hier_attr OWNER TO psql;

--
-- TOC entry 291 (class 1259 OID 138843683)
-- Name: lp_stylecolor_hier_attr; Type: VIEW; Schema: public; Owner: psql
--

CREATE VIEW public.lp_stylecolor_hier_attr AS
 SELECT a.product,
    a.client_id,
    a.cc_style_desc,
    a.cc_color_id,
    a.cc_color_desc,
    a.cc_color_id_desc,
    a.cc_stylecolor_desc,
    a.cc_stylecolor_id_desc,
    a.cc_print_code,
    a.cc_print_name,
    a.cc_season,
    a.cc_season_code,
    a.cc_season_period,
    a.cc_year,
    a.cc_scp_quarter,
    a.cc_season_deliveries,
    a.cc_go_live_date,
    a.cc_scp_development_type,
    a.cc_division,
    a.cc_category,
    a.cc_sub_category,
    a.cc_merch_division,
    a.cc_department,
    a.cc_class,
    a.cc_abs_product_class,
    a.cc_style_number,
    a.cc_ais_legacy_code,
    a.cc_abs_style_number,
    a.cc_description,
    a.cc_print_pattern_solid_spec,
    a.cc_nrf_color_group_family,
    a.cc_print_pattern_spec_legacy_code,
    a.cc_color_temperature,
    a.cc_nrf_shade,
    a.cc_shade_description,
    a.cc_shade_group_description,
    a.cc_surface_color_type,
    a.cc_hts_code,
    a.cc_production_tax_classification,
    a.cc_std_cost,
    a.cc_whl_price,
    a.cc_retail_price,
    a.cc_price_tier,
    a.cc_edi_selection,
    a.cc_ooe_product_type,
    a.cc_coordinate_group,
    a.cc_size_range,
    a.cc_sizes,
    a.cc_sizes_start_end,
    a.cc_abs_size_range,
    a.cc_production_supplier_id,
    a.cc_production_supplier,
    a.cc_production_contact,
    a.cc_scp_color_category,
    a.cc_neck_line,
    a.cc_occasion,
    a.cc_bra_friendly,
    a.cc_dress_length,
    a.cc_short_length,
    a.cc_skirt_skort_length,
    a.cc_swim_type,
    a.cc_style_family,
    a.cc_bom_main_materials,
    a.cc_refinement_short_inseam,
    a.cc_refinement_pant_inseam,
    a.cc_refinement_jumpsuit_inseam,
    a.cc_refinement_romper_inseam,
    a.cc_refinement_skirt_skort_inseam,
    a.cc_refinement_dress_length,
    a.cc_sustainable_material,
    a.cc_scp_neon,
    a.cc_extra_hem_length,
    a.cc_swim_coverage,
    a.cc_is_agenda,
    a.cc_style_hangtags_ecom,
    a.cc_colorway_hangtags_ecom,
    a.cc_licensed_product_legacy_code,
    a.cc_licensed_product_vendor,
    a.cc_licensed_product_type,
    a.cc_pillar,
    a.cc_resort_occasion,
    a.cc_marketing_campaign,
    a.cc_the_moment,
    a.cc_size_type,
    a.cc_ecom_sale_flag_current,
    a.cc_actual_initial_receipt_week,
    a.ccstylecolorcreatedate,
    a.cc_silhouette_bucket,
    a.cc_silhouette_category,
    a.cc_silo_sub_category,
    a.cc_style_type,
    a.cc_fit_bucket,
    a.cc_dress_fit_bucket,
    a.cc_sleeve_type,
    a.cc_inseam_length,
    a.cc_length_type,
    a.cc_material_sub_type,
    a.cc_material_sub_class,
    a.cc_activity_type,
    a.cc_assortment_breakdown,
    a.cc_rise,
    a.cc_design_detail,
    a.cc_surface_add,
    a.cc_engineering,
    a.cccolor,
    a.isassortment,
    a.merch_comments,
    a.plan_comments,
    a.allocator_comments,
    a.cc_is_locked,
    a.cc_s5_adopted,
    a.cc_prepublish,
    a.cc_prepublished_at,
    a.cc_floorset,
    a.cc_use_sys_floorset,
    a.cc_num_clones_s5,
    a.cc_num_times_cloned_s5,
    a.stylecolor_name,
    a.style_name,
    a.class_name,
    a.department_name,
    a.division_name,
    a.total_products_name,
    b.sty_style_description,
    b.sty_size_range,
    b.sty_size_range_name,
    b.sty_size_type,
    b.sty_patterned_after,
    b.sty_is_locked,
    b.sty_s5_adopted,
    b.sty_num_clones_s5,
    b.sty_num_times_cloned_s5,
    b.ccstylecreatedate,
    h.ancestor0 AS style,
    h.ancestor1 AS class_lvl,
    h.ancestor2 AS department_lvl,
    h.ancestor3 AS division_lvl,
    h.ancestor4 AS total_products,
    a.eventdate,
    a.version_id,
    a.created_at,
    a.created_by,
    a.updated_at,
    a.updated_by,
    a.record_state
   FROM ((public.lp_ma_stylecolorattributes a
     LEFT JOIN public.lp_h_prodstd h ON ((h.id = a.product)))
     LEFT JOIN public.lp_ma_styleattributes b ON ((b.product = h.ancestor0)));


ALTER VIEW public.lp_stylecolor_hier_attr OWNER TO psql;

--
-- TOC entry 254 (class 1259 OID 4714715)
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
-- TOC entry 255 (class 1259 OID 4714720)
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
-- TOC entry 256 (class 1259 OID 4714726)
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
-- TOC entry 257 (class 1259 OID 4714732)
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
-- TOC entry 258 (class 1259 OID 4714741)
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
-- TOC entry 259 (class 1259 OID 4714745)
-- Name: s5_tunableparams; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.s5_tunableparams (
    paramid text NOT NULL,
    intvalue integer,
    stringvalue text
);


ALTER TABLE public.s5_tunableparams OWNER TO psql;

--
-- TOC entry 260 (class 1259 OID 4714750)
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
-- TOC entry 261 (class 1259 OID 4714759)
-- Name: tyly; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.tyly (
    ty text,
    ly text
);


ALTER TABLE public.tyly OWNER TO psql;

--
-- TOC entry 262 (class 1259 OID 4714764)
-- Name: undo_display; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.undo_display (
    undo_id uuid NOT NULL,
    modification_description text[] NOT NULL
);


ALTER TABLE public.undo_display OWNER TO psql;

--
-- TOC entry 263 (class 1259 OID 4714769)
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
-- TOC entry 264 (class 1259 OID 4714777)
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
-- TOC entry 265 (class 1259 OID 4714782)
-- Name: user_metadata; Type: TABLE; Schema: public; Owner: psql
--

CREATE TABLE public.user_metadata (
    uid text NOT NULL,
    email text,
    name text
);


ALTER TABLE public.user_metadata OWNER TO psql;

--
-- TOC entry 266 (class 1259 OID 4714787)
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
-- TOC entry 4530 (class 2606 OID 4714800)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 4524 (class 2606 OID 4714802)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 4526 (class 2606 OID 4714804)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 4528 (class 2606 OID 4714806)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 4532 (class 2606 OID 4714808)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 4535 (class 2606 OID 4714810)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4537 (class 2606 OID 4714812)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 4539 (class 2606 OID 4714814)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 4541 (class 2606 OID 4714816)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 4543 (class 2606 OID 4714818)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 4546 (class 2606 OID 4714820)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 4548 (class 2606 OID 4714822)
-- Name: dimensions dimension_levelid_indx_unique; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.dimensions
    ADD CONSTRAINT dimension_levelid_indx_unique UNIQUE (dimension, levelid, indx);


--
-- TOC entry 4550 (class 2606 OID 4714824)
-- Name: dimensions dimensions_pk; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.dimensions
    ADD CONSTRAINT dimensions_pk PRIMARY KEY (id);


--
-- TOC entry 4552 (class 2606 OID 4714826)
-- Name: hierarchies hierarchies_unq; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.hierarchies
    ADD CONSTRAINT hierarchies_unq UNIQUE (dimension, hierarchy, id, ancestor);


--
-- TOC entry 4554 (class 2606 OID 4714828)
-- Name: metadata metadata_pk; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.metadata
    ADD CONSTRAINT metadata_pk PRIMARY KEY (key);


--
-- TOC entry 4557 (class 2606 OID 4714830)
-- Name: plan_init_status plan_init_status_pkey; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.plan_init_status
    ADD CONSTRAINT plan_init_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4559 (class 2606 OID 4714832)
-- Name: plans plans_unique; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.plans
    ADD CONSTRAINT plans_unique UNIQUE (name, module, version, owned_by, "time", product, location);


--
-- TOC entry 4561 (class 2606 OID 4714834)
-- Name: plans plans_unique_id; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.plans
    ADD CONSTRAINT plans_unique_id UNIQUE (id);


--
-- TOC entry 4563 (class 2606 OID 4714836)
-- Name: tyly tyly_uniq; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.tyly
    ADD CONSTRAINT tyly_uniq UNIQUE (ty, ly);


--
-- TOC entry 4565 (class 2606 OID 4714838)
-- Name: user_kv_store user_kv_store_pkey; Type: CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.user_kv_store
    ADD CONSTRAINT user_kv_store_pkey PRIMARY KEY (uid, key);


--
-- TOC entry 4593 (class 2606 OID 35630343)
-- Name: allocation_plan_queue allocation_plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue
    ADD CONSTRAINT allocation_plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 4567 (class 2606 OID 4714840)
-- Name: cart_queue cart_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT cart_queue_pkey PRIMARY KEY (cart_id);


--
-- TOC entry 4569 (class 2606 OID 4714842)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 4571 (class 2606 OID 4714844)
-- Name: dev_session dev_session_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT dev_session_pkey PRIMARY KEY (session_id);


--
-- TOC entry 4573 (class 2606 OID 4714846)
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (key);


--
-- TOC entry 4642 (class 2606 OID 138843626)
-- Name: lp_d_cluster lp_d_cluster_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_d_cluster
    ADD CONSTRAINT lp_d_cluster_pkey PRIMARY KEY (id);


--
-- TOC entry 4621 (class 2606 OID 138843546)
-- Name: lp_d_location lp_d_location_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_d_location
    ADD CONSTRAINT lp_d_location_pkey PRIMARY KEY (id);


--
-- TOC entry 4646 (class 2606 OID 138843654)
-- Name: lp_d_prodlife lp_d_prodlife_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_d_prodlife
    ADD CONSTRAINT lp_d_prodlife_pkey PRIMARY KEY (id);


--
-- TOC entry 4601 (class 2606 OID 138843454)
-- Name: lp_d_product lp_d_product_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_d_product
    ADD CONSTRAINT lp_d_product_pkey PRIMARY KEY (id);


--
-- TOC entry 4633 (class 2606 OID 138843593)
-- Name: lp_d_time lp_d_time_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_d_time
    ADD CONSTRAINT lp_d_time_pkey PRIMARY KEY (id);


--
-- TOC entry 4644 (class 2606 OID 138843640)
-- Name: lp_h_clusterstd lp_h_clusterstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_h_clusterstd
    ADD CONSTRAINT lp_h_clusterstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4624 (class 2606 OID 138843560)
-- Name: lp_h_locstd lp_h_locstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_h_locstd
    ADD CONSTRAINT lp_h_locstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4648 (class 2606 OID 138843668)
-- Name: lp_h_prodlifestd lp_h_prodlifestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_h_prodlifestd
    ADD CONSTRAINT lp_h_prodlifestd_pkey PRIMARY KEY (id);


--
-- TOC entry 4604 (class 2606 OID 138843468)
-- Name: lp_h_prodstd lp_h_prodstd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_h_prodstd
    ADD CONSTRAINT lp_h_prodstd_pkey PRIMARY KEY (id);


--
-- TOC entry 4636 (class 2606 OID 138843608)
-- Name: lp_h_timestd lp_h_timestd_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_h_timestd
    ADD CONSTRAINT lp_h_timestd_pkey PRIMARY KEY (id);


--
-- TOC entry 4619 (class 2606 OID 138843532)
-- Name: lp_ma_imgattributes lp_ma_imgattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_ma_imgattributes
    ADD CONSTRAINT lp_ma_imgattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4616 (class 2606 OID 138843517)
-- Name: lp_ma_sizeattributes lp_ma_sizeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_ma_sizeattributes
    ADD CONSTRAINT lp_ma_sizeattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4631 (class 2606 OID 138843579)
-- Name: lp_ma_storeattributes lp_ma_storeattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_ma_storeattributes
    ADD CONSTRAINT lp_ma_storeattributes_pkey PRIMARY KEY (location);


--
-- TOC entry 4612 (class 2606 OID 138843488)
-- Name: lp_ma_styleattributes lp_ma_styleattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_ma_styleattributes
    ADD CONSTRAINT lp_ma_styleattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4614 (class 2606 OID 138843503)
-- Name: lp_ma_stylecolorattributes lp_ma_stylecolorattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_ma_stylecolorattributes
    ADD CONSTRAINT lp_ma_stylecolorattributes_pkey PRIMARY KEY (product);


--
-- TOC entry 4650 (class 2606 OID 138843682)
-- Name: lp_serviceparams lp_serviceparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.lp_serviceparams
    ADD CONSTRAINT lp_serviceparams_pkey PRIMARY KEY (id);


--
-- TOC entry 4578 (class 2606 OID 4714848)
-- Name: pivot_execution pivot_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT pivot_execution_pkey PRIMARY KEY (pivot_session_id);


--
-- TOC entry 4580 (class 2606 OID 4714850)
-- Name: plan_queue plan_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.plan_queue
    ADD CONSTRAINT plan_queue_pkey PRIMARY KEY (jobid);


--
-- TOC entry 4582 (class 2606 OID 4714852)
-- Name: s5_tunableparams s5_tunableparams_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.s5_tunableparams
    ADD CONSTRAINT s5_tunableparams_pkey PRIMARY KEY (paramid);


--
-- TOC entry 4584 (class 2606 OID 4714854)
-- Name: scope scope_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.scope
    ADD CONSTRAINT scope_pkey PRIMARY KEY (id);


--
-- TOC entry 4575 (class 2606 OID 4714856)
-- Name: favorites triplet; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT triplet UNIQUE (user_id, module, favorite_name);


--
-- TOC entry 4587 (class 2606 OID 4714858)
-- Name: undo_log undo_log_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_log
    ADD CONSTRAINT undo_log_pkey PRIMARY KEY (undo_id);


--
-- TOC entry 4589 (class 2606 OID 4714860)
-- Name: user_metadata user_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_metadata
    ADD CONSTRAINT user_metadata_pkey PRIMARY KEY (uid);


--
-- TOC entry 4591 (class 2606 OID 4714862)
-- Name: user_worklist user_worklist_pkey; Type: CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.user_worklist
    ADD CONSTRAINT user_worklist_pkey PRIMARY KEY (user_id, product);


--
-- TOC entry 4594 (class 1259 OID 65047723)
-- Name: actuals_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_bottom_up ON mfp.actuals_wide_denorm USING btree (time_year, product_department, location_total_location);


--
-- TOC entry 4595 (class 1259 OID 65047725)
-- Name: actuals_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_middle_out ON mfp.actuals_wide_denorm USING btree (time_year, product_total_products, location_total_location);


--
-- TOC entry 4596 (class 1259 OID 65047727)
-- Name: actuals_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_denorm_top_down ON mfp.actuals_wide_denorm USING btree (time_year, product_total_products, location_total_location);


--
-- TOC entry 4522 (class 1259 OID 4714866)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 4533 (class 1259 OID 4714878)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp.plan_data_wide USING hash (id);


--
-- TOC entry 4597 (class 1259 OID 65047724)
-- Name: sys_gen_wide_denorm_bottom_up; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_bottom_up ON mfp.sys_gen_wide_denorm USING btree (time_year, product_department, location_total_location);


--
-- TOC entry 4598 (class 1259 OID 65047726)
-- Name: sys_gen_wide_denorm_middle_out; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_middle_out ON mfp.sys_gen_wide_denorm USING btree (time_year, product_total_products, location_total_location);


--
-- TOC entry 4599 (class 1259 OID 65047728)
-- Name: sys_gen_wide_denorm_top_down; Type: INDEX; Schema: mfp; Owner: psql
--

CREATE INDEX sys_gen_wide_denorm_top_down ON mfp.sys_gen_wide_denorm USING btree (time_year, product_total_products, location_total_location);


--
-- TOC entry 4544 (class 1259 OID 4714882)
-- Name: actuals_wide_dimensions_idx; Type: INDEX; Schema: mfp_backup; Owner: psql
--

CREATE INDEX actuals_wide_dimensions_idx ON mfp_backup.actuals_wide USING btree ("time", product, location);


--
-- TOC entry 4555 (class 1259 OID 4714883)
-- Name: plan_data_wide_id_idx; Type: INDEX; Schema: mfp_backup; Owner: psql
--

CREATE INDEX plan_data_wide_id_idx ON mfp_backup.plan_data_wide USING hash (id);


--
-- TOC entry 4622 (class 1259 OID 138843547)
-- Name: lp_location_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_location_levelid_indx ON public.lp_d_location USING btree (levelid);


--
-- TOC entry 4625 (class 1259 OID 138843561)
-- Name: lp_locstd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_locstd_ances0_indx ON public.lp_h_locstd USING btree (ancestor0);


--
-- TOC entry 4626 (class 1259 OID 138843562)
-- Name: lp_locstd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_locstd_ances1_indx ON public.lp_h_locstd USING btree (ancestor1);


--
-- TOC entry 4627 (class 1259 OID 138843563)
-- Name: lp_locstd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_locstd_ances2_indx ON public.lp_h_locstd USING btree (ancestor2);


--
-- TOC entry 4628 (class 1259 OID 138843564)
-- Name: lp_locstd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_locstd_ances3_indx ON public.lp_h_locstd USING btree (ancestor3);


--
-- TOC entry 4629 (class 1259 OID 138843565)
-- Name: lp_locstd_ances4_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_locstd_ances4_indx ON public.lp_h_locstd USING btree (ancestor4);


--
-- TOC entry 4605 (class 1259 OID 138843469)
-- Name: lp_prodstd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances0_indx ON public.lp_h_prodstd USING btree (ancestor0);


--
-- TOC entry 4606 (class 1259 OID 138843470)
-- Name: lp_prodstd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances1_indx ON public.lp_h_prodstd USING btree (ancestor1);


--
-- TOC entry 4607 (class 1259 OID 138843471)
-- Name: lp_prodstd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances2_indx ON public.lp_h_prodstd USING btree (ancestor2);


--
-- TOC entry 4608 (class 1259 OID 138843472)
-- Name: lp_prodstd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances3_indx ON public.lp_h_prodstd USING btree (ancestor3);


--
-- TOC entry 4609 (class 1259 OID 138843473)
-- Name: lp_prodstd_ances4_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances4_indx ON public.lp_h_prodstd USING btree (ancestor4);


--
-- TOC entry 4610 (class 1259 OID 138843474)
-- Name: lp_prodstd_ances5_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_prodstd_ances5_indx ON public.lp_h_prodstd USING btree (ancestor5);


--
-- TOC entry 4602 (class 1259 OID 138843455)
-- Name: lp_product_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_product_levelid_indx ON public.lp_d_product USING btree (levelid);


--
-- TOC entry 4617 (class 1259 OID 138843518)
-- Name: lp_sizeattr_parent_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_sizeattr_parent_indx ON public.lp_ma_sizeattributes USING btree (parent_id);


--
-- TOC entry 4634 (class 1259 OID 138843594)
-- Name: lp_time_levelid_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_time_levelid_indx ON public.lp_d_time USING btree (levelid);


--
-- TOC entry 4637 (class 1259 OID 138843609)
-- Name: lp_timestd_ances0_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_timestd_ances0_indx ON public.lp_h_timestd USING btree (ancestor0);


--
-- TOC entry 4638 (class 1259 OID 138843610)
-- Name: lp_timestd_ances1_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_timestd_ances1_indx ON public.lp_h_timestd USING btree (ancestor1);


--
-- TOC entry 4639 (class 1259 OID 138843611)
-- Name: lp_timestd_ances2_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_timestd_ances2_indx ON public.lp_h_timestd USING btree (ancestor2);


--
-- TOC entry 4640 (class 1259 OID 138843612)
-- Name: lp_timestd_ances3_indx; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX lp_timestd_ances3_indx ON public.lp_h_timestd USING btree (ancestor3);


--
-- TOC entry 4576 (class 1259 OID 4714884)
-- Name: triplet_index; Type: INDEX; Schema: public; Owner: psql
--

CREATE UNIQUE INDEX triplet_index ON public.favorites USING btree (user_id, module, favorite_name);


--
-- TOC entry 4585 (class 1259 OID 4714885)
-- Name: tyly_ty; Type: INDEX; Schema: public; Owner: psql
--

CREATE INDEX tyly_ty ON public.tyly USING btree (ty);


--
-- TOC entry 4672 (class 2620 OID 4714886)
-- Name: pivot_execution on_pivot_execution_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_pivot_execution_change AFTER INSERT OR DELETE OR UPDATE ON public.pivot_execution FOR EACH STATEMENT EXECUTE FUNCTION public.notify_pivot_execution_change();


--
-- TOC entry 4673 (class 2620 OID 4714887)
-- Name: plan_queue on_plan_queue_change; Type: TRIGGER; Schema: public; Owner: psql
--

CREATE TRIGGER on_plan_queue_change AFTER INSERT OR DELETE OR UPDATE ON public.plan_queue FOR EACH STATEMENT EXECUTE FUNCTION public.notify_plan_queue_change();


--
-- TOC entry 4651 (class 2606 OID 4714888)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4652 (class 2606 OID 4714893)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4655 (class 2606 OID 4714898)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4653 (class 2606 OID 4714903)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp.plans(id) ON DELETE CASCADE;


--
-- TOC entry 4654 (class 2606 OID 4714908)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp.plans(id);


--
-- TOC entry 4656 (class 2606 OID 4714913)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp; Owner: psql
--

ALTER TABLE ONLY mfp.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp.dimensions(id);


--
-- TOC entry 4658 (class 2606 OID 4714918)
-- Name: hierarchies hierarchies_ancestor_fk; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.hierarchies
    ADD CONSTRAINT hierarchies_ancestor_fk FOREIGN KEY (ancestor) REFERENCES mfp_backup.dimensions(id);


--
-- TOC entry 4659 (class 2606 OID 4714923)
-- Name: hierarchies hierarchies_id_fk; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.hierarchies
    ADD CONSTRAINT hierarchies_id_fk FOREIGN KEY (id) REFERENCES mfp_backup.dimensions(id);


--
-- TOC entry 4661 (class 2606 OID 4714928)
-- Name: tyly ly_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.tyly
    ADD CONSTRAINT ly_dimension_fkey FOREIGN KEY (ly) REFERENCES mfp_backup.dimensions(id);


--
-- TOC entry 4657 (class 2606 OID 4714933)
-- Name: comments plan_id_fkey; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.comments
    ADD CONSTRAINT plan_id_fkey FOREIGN KEY (plan_id) REFERENCES mfp_backup.plans(id) ON DELETE CASCADE;


--
-- TOC entry 4660 (class 2606 OID 4714938)
-- Name: plan_init_status plan_init_status_id_fkey; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.plan_init_status
    ADD CONSTRAINT plan_init_status_id_fkey FOREIGN KEY (id) REFERENCES mfp_backup.plans(id);


--
-- TOC entry 4662 (class 2606 OID 4714943)
-- Name: tyly ty_dimension_fkey; Type: FK CONSTRAINT; Schema: mfp_backup; Owner: psql
--

ALTER TABLE ONLY mfp_backup.tyly
    ADD CONSTRAINT ty_dimension_fkey FOREIGN KEY (ty) REFERENCES mfp_backup.dimensions(id);


--
-- TOC entry 4663 (class 2606 OID 4714948)
-- Name: cart_master cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_master
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 4664 (class 2606 OID 4714953)
-- Name: cart_params cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_params
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 4666 (class 2606 OID 4714958)
-- Name: cart_ranging cart_queue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_ranging
    ADD CONSTRAINT cart_queue_fkey FOREIGN KEY (jsessionid) REFERENCES public.cart_queue(cart_id);


--
-- TOC entry 4671 (class 2606 OID 35630353)
-- Name: allocation_plan_queue_items fk_allocation_plan_queue_items_allocation_plan_queue; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.allocation_plan_queue_items
    ADD CONSTRAINT fk_allocation_plan_queue_items_allocation_plan_queue FOREIGN KEY (jobid) REFERENCES public.allocation_plan_queue(jobid);


--
-- TOC entry 4669 (class 2606 OID 4714963)
-- Name: undo_display fk_undo_display_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_display
    ADD CONSTRAINT fk_undo_display_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 4670 (class 2606 OID 4714968)
-- Name: undo_modifications fk_undo_modification_id; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.undo_modifications
    ADD CONSTRAINT fk_undo_modification_id FOREIGN KEY (undo_id) REFERENCES public.undo_log(undo_id) ON DELETE CASCADE;


--
-- TOC entry 4665 (class 2606 OID 4714973)
-- Name: cart_queue scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.cart_queue
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 4668 (class 2606 OID 4714978)
-- Name: pivot_execution scope_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.pivot_execution
    ADD CONSTRAINT scope_id_fkey FOREIGN KEY (scope_id) REFERENCES public.scope(id);


--
-- TOC entry 4667 (class 2606 OID 4714983)
-- Name: dev_session target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: psql
--

ALTER TABLE ONLY public.dev_session
    ADD CONSTRAINT target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES public.user_metadata(uid);


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: oci_superuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-10-01 15:08:09 IST

--
-- PostgreSQL database dump complete
--

\unrestrict TIfrYGgx8UadMT0zyjfuIGVtZdTiIpCegjFqWfht6N3IVTi0fOpWFkTPBXt9rr4

