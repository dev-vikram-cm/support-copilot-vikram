"""
PySpark equivalent of  etl-trd-batch/vsql/weekly/010_products.sql
(clone: repos/etl-trd-batch, branch etl_assortment_planning)

Vertica DDL/DML script -> immutable DataFrame pipeline. Same outputs, same column
order:
    TRD_REF_PRD_MEMBERMASTER, TRD_REF_S5_CLIENT_ID_MAPPING,
    trd_d_product, trd_h_prodstd,
    trd_ma_styleattributes, trd_ma_stylecolorattributes, trd_ma_sizeattributes,
    TRD_REF_CC_SKU_MAPPING, TRD_REF_CC_STYLE_MAPPING, size_ids

Translation rules applied throughout
------------------------------------
* `DROP TABLE ... ; CREATE TABLE ... AS SELECT`  -> a function returning a DataFrame.
* comma-join + WHERE                            -> explicit inner join.
* `UPDATE t SET c = x FROM s WHERE ...`          -> left join + a new column
                                                   (DataFrames are immutable).
* `SEQUENCE.NEXTVAL` across N ordered INSERTs    -> one global row_number()
                                                   over (level_rank, id).
* `ISUTF8()` / non-ASCII scrub                   -> rlike on the ASCII range.
* `commit;`                                      -> nothing; write-out is the commit.

Run: spark-submit trd_weekly_010_products_spark.py
"""

from pyspark.sql import Column, DataFrame, SparkSession, Window
from pyspark.sql import functions as F

# ---------------------------------------------------------------------------
# I/O seam -- swap for your JDBC / Iceberg / Delta reader+writer
# ---------------------------------------------------------------------------


def read(spark: SparkSession, table: str) -> DataFrame:
    return spark.read.table(table.lower())


def write(df: DataFrame, table: str) -> None:
    df.write.mode("overwrite").saveAsTable(table.lower())


# ---------------------------------------------------------------------------
# shared helpers
# ---------------------------------------------------------------------------

NOW = F.date_trunc("second", F.current_timestamp())

AUDIT = [
    F.lit(1).alias("version_id"),
    NOW.alias("created_at"),
    F.lit("system").alias("created_by"),
    NOW.alias("updated_at"),
    F.lit("system").alias("updated_by"),
    F.lit(0).alias("record_state"),
]

# levelid is lower(product_level) everywhere except 'group' -> 'group_id'  (SQL:166)
LEVELID = (
    F.when(F.lower("product_level") == "group", F.lit("group_id"))
    .otherwise(F.lower("product_level"))
)

# insert order of the 9 level blocks, which is what the sequence encodes (SQL:113-322)
LEVEL_ORDER = [
    "total_brand", "division", "group", "department",
    "class", "subclass", "style", "stylecolor", "stylecolorsize",
]
MAPPED_LEVELS = {"style", "stylecolor", "stylecolorsize"}  # get an s5_id swap

ASCII_ONLY = r"^[\x00-\x7F]*$"


def week_fmt(col: str) -> Column:
    """'2025-W03' style source -> '2025_W03'   (SQL:547-552)"""
    c = F.col(col)
    return F.concat(F.substring(c, 1, 4), F.lit("_W"), F.expr(f"substring({col}, 8)"))


def dec(col: str, alias: str) -> Column:
    return F.col(col).cast("decimal(16,4)").alias(alias)


def nulls(*names: str, typ: str = "string") -> list:
    return [F.lit(None).cast(typ).alias(n) for n in names]


# ---------------------------------------------------------------------------
# 1. inbound scrub + TRD_REF_PRD_MEMBERMASTER                       (SQL:28-40)
# ---------------------------------------------------------------------------


def prd_master_clean(spark: SparkSession) -> DataFrame:
    """sku -> stylecolorsize, then drop member_ids that aren't clean ASCII."""
    return (
        read(spark, "TRD_IN_PRD_MASTER")
        .withColumn(
            "product_level",
            F.when(F.col("product_level") == "sku", F.lit("stylecolorsize"))
            .otherwise(F.col("product_level")),
        )
        .filter(F.col("member_id").rlike(ASCII_ONLY))
    )


def ref_prd_membermaster(master: DataFrame, hier: DataFrame) -> DataFrame:
    """Only members that actually appear in the hierarchy file."""
    return (
        master.join(hier.select("member_id").distinct(), "member_id", "left_semi")
        .select("member_id", "product_level")
        .distinct()
    )


# ---------------------------------------------------------------------------
# 2. TRD_REF_S5_CLIENT_ID_MAPPING                                   (SQL:46-63)
# ---------------------------------------------------------------------------


def ref_s5_client_id_mapping(
    master: DataFrame, hier: DataFrame, existing: DataFrame
) -> DataFrame:
    from_inbound = (
        master.join(hier.select("member_id").distinct(), "member_id", "left_semi")
        .select(
            F.coalesce("s5_id", "member_id").alias("s5_id"),
            F.col("member_id").alias("client_erp_id"),
            F.col("product_level").alias("levelid"),
        )
        .distinct()
    )
    # carry forward ids already live in trd_d_product but absent from this feed
    from_existing = (
        existing.join(from_inbound.select("s5_id"), existing.id == F.col("s5_id"), "left_anti")
        .select(
            F.col("id").alias("s5_id"),
            F.coalesce("client_id", "id").alias("client_erp_id"),
            F.col("levelid"),
        )
        .distinct()
    )
    return from_inbound.unionByName(from_existing)


# ---------------------------------------------------------------------------
# 3. trd_d_product                                                 (SQL:69-324)
# ---------------------------------------------------------------------------


def d_product(master: DataFrame, memmaster: DataFrame, idmap: DataFrame) -> DataFrame:
    """
    ProductRoot (indx 0) + one block per level, indx from a single sequence that
    keeps counting across the blocks -> global row_number over (level_rank, id).

    NOTE (SQL:268-271, 292-295, 317-320): the join to IDMAP is on client_erp_id
    only -- no `AND IDMAP.levelid = A.PRODUCT_LEVEL`. A member_id reused across
    two levels fans this out. Faithful here; flag it before you rely on it.
    """
    rows = master.join(
        memmaster, ["member_id", "product_level"], "inner"
    ).filter(F.col("product_level").isin(LEVEL_ORDER))

    mapped = (
        rows.filter(F.col("product_level").isin(list(MAPPED_LEVELS)))
        .join(idmap, rows.member_id == idmap.client_erp_id, "inner")
        .select(rows["*"], idmap.s5_id)
    )
    unmapped = rows.filter(~F.col("product_level").isin(list(MAPPED_LEVELS))).withColumn(
        "s5_id", F.lit(None).cast("string")
    )

    level_rank = F.create_map(
        *[x for i, lvl in enumerate(LEVEL_ORDER) for x in (F.lit(lvl), F.lit(i))]
    )[F.col("product_level")]

    body = (
        mapped.unionByName(unmapped)
        .select(
            F.coalesce("s5_id", "member_id").alias("id"),
            F.col("member_id").alias("client_id"),
            F.col("member_name").alias("name"),
            F.col("member_desc").alias("description"),
            LEVELID.alias("levelid"),
            level_rank.alias("_rank"),
        )
        .withColumn(
            "indx",
            F.row_number().over(Window.orderBy("_rank", "id")),  # the NEXTVAL
        )
        .drop("_rank")
    )

    root = body.sparkSession.range(1).select(
        *[F.lit("ProductRoot").alias(c) for c in ("id", "client_id", "name", "description")],
        F.lit("prodrootlevel").alias("levelid"),
        F.lit(0).alias("indx"),
    )

    return (
        root.unionByName(body)
        .select("id", "client_id", "name", "description", "levelid", "indx",
                F.current_date().alias("eventdate"), *AUDIT)
    )


# ---------------------------------------------------------------------------
# 4. trd_h_prodstd                                                (SQL:330-434)
# ---------------------------------------------------------------------------

ANCESTORS = [f"ancestor{i}" for i in range(8)]


def h_prodstd(hier: DataFrame, memmaster: DataFrame, idmap: DataFrame) -> DataFrame:
    """
    Same ancestor columns for every level; only the id and the ancestor slots that
    hold a mapped level get the s5_id swap:
        style           -> id
        stylecolor      -> id, ancestor0(style)
        stylecolorsize  -> id, ancestor0(stylecolor), ancestor1(style)
    """
    def m(level: str):
        return idmap.filter(F.col("levelid") == level).select(
            F.col("client_erp_id").alias(f"{level}_erp"), F.col("s5_id").alias(f"{level}_s5")
        )

    sty, styclr, size = m("style"), m("stylecolor"), m("stylecolorsize")
    base = hier.join(memmaster, "member_id", "inner")

    def shape(df, id_col, a0=None, a1=None):
        return df.select(
            id_col.alias("id"),
            (a0 if a0 is not None else F.col("ancestor0")).alias("ancestor0"),
            (a1 if a1 is not None else F.col("ancestor1")).alias("ancestor1"),
            *[F.col(a) for a in ANCESTORS[2:]],
            *AUDIT,
        )

    upper = shape(
        base.filter(~F.col("product_level").isin(list(MAPPED_LEVELS))), F.col("member_id")
    )

    style = shape(
        base.filter(F.col("product_level") == "style")
            .join(sty, F.col("member_id") == F.col("style_erp"), "inner"),
        F.coalesce("style_s5", "member_id"),
    )

    stylecolor = shape(
        base.filter(F.col("product_level") == "stylecolor")
            .join(styclr, F.col("member_id") == F.col("stylecolor_erp"), "inner")
            .join(sty, F.col("ancestor0") == F.col("style_erp"), "inner"),
        F.coalesce("stylecolor_s5", "member_id"),
        a0=F.coalesce("style_s5", "ancestor0"),
    )

    scs = shape(
        base.filter(F.col("product_level") == "stylecolorsize")
            .join(size, F.col("member_id") == F.col("stylecolorsize_erp"), "inner")
            .join(styclr, F.col("ancestor0") == F.col("stylecolor_erp"), "inner")
            .join(sty, F.col("ancestor1") == F.col("style_erp"), "inner"),
        F.coalesce("stylecolorsize_s5", "member_id"),
        a0=F.coalesce("stylecolor_s5", "ancestor0"),
        a1=F.coalesce("style_s5", "ancestor1"),
    )

    return upper.unionByName(style).unionByName(stylecolor).unionByName(scs)


# ---------------------------------------------------------------------------
# 5. trd_ma_styleattributes                                       (SQL:441-492)
# ---------------------------------------------------------------------------

STYLE_ATTRS = [
    "knit_or_woven", "fabrication", "sleeve_length", "leg_opening", "brand",
    "body_style_silhouette", "occasion_usage", "detail", "finish_style",
    "private_label", "license", "license_vs_non_licensed", "hazmat_code",
    "prop_65_warning", "material_content", "item_type", "dwrise", "length",
    "neckline", "toeshape", "heel_height", "bottom_length", "v_360_smoothing",
    "franchise", "key_item", "single_vs_multi_pack", "ticket_type", "vpn",
    "size_range",
]


def ma_styleattributes(attr: DataFrame, memmaster: DataFrame, idmap: DataFrame) -> DataFrame:
    sty = idmap.filter(F.col("levelid") == "style")
    return (
        attr.join(
            memmaster.filter(F.col("product_level") == "style"), "member_id", "inner"
        )
        .join(sty, attr.member_id == sty.client_erp_id, "inner")
        .select(
            F.coalesce(sty.s5_id, attr.member_id).alias("product"),
            *[F.col(c).alias(f"sty_{c}") for c in STYLE_ATTRS],
            F.col("rms_stylecolor_create_date").alias("ccstylecreatedate"),
            *nulls("sty_is_locked", "sty_s5_adopted"),
            F.current_date().alias("eventdate"),
            *AUDIT,
            F.col("knit_fit").alias("sty_knit_fit"),
        )
    )


# ---------------------------------------------------------------------------
# 6. trd_ma_stylecolorattributes                                  (SQL:499-695)
# ---------------------------------------------------------------------------

# plain passthroughs, source col -> cc_<source col>
CC_ATTRS = [
    "item_diff_1", "pattern", "graphic", "fashion_basic", "holiday", "property_type",
    "internet_exclusive", "web_color_discription", "export_hts",
    "commercial_invoice_description", "season_code", "dtr", "dw_color_family",
    "channel_reorder", "ticket_season_code", "sub_programs", "music_genre",
    "clearance_str_product", "po_supplier", "origin_country_id", "country_of_sourcing",
    "country_of_manufacturing", "freight", "royalty", "duty", "ship_method",
    "lading_port", "hts", "primary_supplier", "sub_brand", "pattern_type",
    "pop_print_neutral", "debut_season_code", "matchback", "primary_collection",
    "secondary_collection", "vpn_color", "store_price_status", "ifc_price_status",
    "omni_price_type", "price_band", "good_better_best", "supp_cost", "finish",
    "license", "channel_availability", "extended_size", "op_markdown_week", "motif",
    "rp_revised_markdown_week", "parent_season_code", "art_code", "material_content",
    "fabrication",
]

WEEK_COLS = {
    "first_rec_week": "cc_first_rec_week",
    "first_inv_week": "cc_first_inv_week",
    "first_sale_week": "cc_first_sale_week",
    "first_md_week": "cc_first_md_week",
    "last_md_week": "cc_last_md_week",
    "last_rec_week": "cc_last_rec_week",
}

# hierarchy-name backfills:  target col -> (ancestor slot, trd_d_product levelid)
NAME_BACKFILL = {
    "stylecolor_name": ("ancestor0", "stylecolor"),   # see CAVEAT below
    "style_name":      ("ancestor1", "style"),        # see CAVEAT below
    "total_brand_name": ("ancestor6", "total_brand"),
    "division_name":   ("ancestor5", "division"),
    "group_name":      ("ancestor4", "group_id"),
    "department_name": ("ancestor3", "department"),
    "class_name":      ("ancestor2", "class"),
    "subclass_name":   ("ancestor1", "subclass"),
}
# CAVEAT (SQL:617-633 vs 662-687): trd_ma_stylecolorattributes.product is a
# STYLECOLOR, and a stylecolor row in trd_h_prodstd has ancestor0 = style,
# ancestor1 = subclass. So `stylecolor_name` joins ancestor0 against levelid
# 'stylecolor', and `style_name` joins ancestor1 against levelid 'style' -- both
# one slot off from the other six, which line up. Expect both to land NULL.
# Replicated as-is; confirm against QA data before changing anything.


def ma_stylecolorattributes(
    attr: DataFrame, memmaster: DataFrame, idmap: DataFrame,
    hier: DataFrame, product: DataFrame, colormap: DataFrame,
) -> DataFrame:
    styclr = idmap.filter(F.col("levelid") == "stylecolor")

    df = (
        attr.join(
            memmaster.filter(F.col("product_level") == "stylecolor"), "member_id", "inner"
        )
        .join(styclr, attr.member_id == styclr.client_erp_id, "inner")
        .select(
            F.coalesce(styclr.s5_id, attr.member_id).alias("product"),
            *[F.col(c).alias(f"cc_{c}") for c in CC_ATTRS],
            dec("unit_retail", "cc_unit_retail"),
            dec("unit_retail_cad", "cc_unit_retail_cad"),
            dec("unit_cost", "cc_unit_cost"),
            dec("orig_unit_retail", "cc_orig_unit_retail"),
            dec("orig_unit_retail_cad", "cc_orig_unit_retail_cad"),
            dec("web_current_retail", "cc_web_current_retail"),
            *[week_fmt(src).alias(tgt) for src, tgt in WEEK_COLS.items()],
            F.col("stylecolor_create_date").alias("ccstylecolorcreatedate"),
            F.col("item_diff_1").alias("cccolor"),
            F.col("dw_color_family").alias("cccolorfamily"),
            # TO_CHAR(x,'FM999999990.00') -- no thousands separator, so format_string
            # not format_number.  (half-up vs Spark's half-even on the cent: watch it)
            F.format_string("$%.2f", F.col("orig_unit_retail").cast("decimal(16,4)"))
             .alias("cc_orig_unit_retail_char"),
            F.current_date().alias("eventdate"),
            *AUDIT,
            *nulls("isassortment", "merch_comments", "plan_comments", "cc_is_locked",
                   "cc_s5_adopted", "allocator_comments", "cccolorid",
                   "cc_specstylecolor_status", "cc_spec_division", "cc_spec_group",
                   "cc_development_season", "cc_delivery_season", "cc_po_due_date",
                   "cc_pd_ndc_week", "cc_additional_tariff", "cc_design_notes",
                   "cc_pd_notes", "cc_compliance_notes"),
            *nulls("cc_prepublish", typ="boolean"),
            *nulls("cc_prepublished_at", typ="timestamp"),
        )
    )

    # the eight UPDATE ... FROM name backfills -> left joins
    for target, (slot, levelid) in NAME_BACKFILL.items():
        names = (
            hier.alias("h")
            .join(
                product.filter(F.col("levelid") == levelid).alias("p"),
                F.col(f"h.{slot}") == F.col("p.id"),
                "inner",
            )
            .select(F.col("h.id").alias("_prod"), F.col("p.name").alias(f"_{target}"))
            .distinct()
        )
        df = (
            df.join(names, df.product == names._prod, "left")
            .withColumn(target, F.col(f"_{target}"))
            .drop("_prod", f"_{target}")
        )

    # cccolorid from the colour-code cross-reference                     (SQL:689-692)
    cm = colormap.select(
        F.col("color_id").alias("_cid"), F.col("color_code").alias("_ccode")
    ).distinct()
    df = (
        df.join(cm, df.cc_item_diff_1 == cm._cid, "left")
        .withColumn("cccolorid", F.col("_ccode"))
        .drop("_cid", "_ccode")
    )
    return df


# ---------------------------------------------------------------------------
# 7. trd_ma_sizeattributes + the two ref maps + size_ids           (SQL:702-787)
# ---------------------------------------------------------------------------


def ma_sizeattributes(attr: DataFrame, memmaster: DataFrame, idmap: DataFrame) -> DataFrame:
    size = idmap.filter(F.col("levelid") == "stylecolorsize")
    return (
        attr.join(
            memmaster.filter(F.col("product_level") == "stylecolorsize"),
            attr.item == memmaster.member_id, "inner",
        )
        .join(size, attr.item == size.client_erp_id, "inner")
        .select(
            F.coalesce(size.s5_id, attr.item).alias("product"),
            *nulls("parent_id"),
            F.col("item_diff_2"), F.col("item_diff_3"),
            F.col("size_attr_id").alias("sizeattribute"),
            F.lit(1).alias("isvalid"),
            F.current_date().alias("eventdate"),
            *AUDIT,
            F.col("stylecolorsize_create_date").alias("ccctylecolorsizecreatedate"),
        )
    )


def ref_cc_sku_mapping(hier: DataFrame, product: DataFrame) -> DataFrame:
    scs = product.filter(F.col("levelid") == "stylecolorsize").select("id")
    cols = ["stylecolor", "style", "subclass", "class", "department",
            "group", "division", "total_brand"]
    return hier.join(scs, "id", "left_semi").select(
        F.col("id").alias("stylecolorsize"),
        *[F.col(f"ancestor{i}").alias(c) for i, c in enumerate(cols)],
    )


def ref_cc_style_mapping(hier: DataFrame, product: DataFrame) -> DataFrame:
    sc = product.filter(F.col("levelid") == "stylecolor").select("id")
    return (
        hier.join(sc, "id", "left_semi")
        .select(F.col("id").alias("stylecolor"), F.col("ancestor0").alias("style"))
        .distinct()
    )


def size_ids(sizerange: DataFrame) -> DataFrame:
    return sizerange.select(
        F.col("size_desc").alias("size_name"), F.col("size_id")
    ).distinct()


def attach_parent_id(sizeattrs: DataFrame, sku_map: DataFrame) -> DataFrame:
    """UPDATE trd_ma_sizeattributes SET parent_id = stylecolor     (SQL:752-755)"""
    m = sku_map.select(
        F.col("stylecolorsize").alias("_scs"), F.col("stylecolor").alias("_parent")
    )
    return (
        sizeattrs.join(m, sizeattrs.product == m._scs, "left")
        .withColumn("parent_id", F.col("_parent"))
        .drop("_scs", "_parent")
    )


# ---------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------


def main() -> None:
    spark = SparkSession.builder.appName("trd_weekly_010_products").getOrCreate()

    master = prd_master_clean(spark).cache()
    hier_in = read(spark, "TRD_IN_PRD_HIER")

    memmaster = ref_prd_membermaster(master, hier_in).cache()
    idmap = ref_s5_client_id_mapping(
        master, hier_in, read(spark, "trd_d_product_existing")
    ).cache()

    product = d_product(master, memmaster, idmap).cache()
    hier = h_prodstd(hier_in, memmaster, idmap).cache()

    style_attrs = ma_styleattributes(
        read(spark, "TRD_IN_PRD_ATTRSTYLE"), memmaster, idmap
    )
    sc_attrs = ma_stylecolorattributes(
        read(spark, "TRD_IN_PRD_ATTRSTYLECLR"), memmaster, idmap, hier, product,
        read(spark, "TRD_IN_VV_COLORMAPPING"),
    )

    sku_map = ref_cc_sku_mapping(hier, product)
    size_attrs = attach_parent_id(
        ma_sizeattributes(read(spark, "TRD_IN_PRD_ATTRSKU"), memmaster, idmap), sku_map
    )

    for df, table in [
        (memmaster, "TRD_REF_PRD_MEMBERMASTER"),
        (idmap, "TRD_REF_S5_CLIENT_ID_MAPPING"),
        (product, "trd_d_product"),
        (hier, "trd_h_prodstd"),
        (style_attrs, "trd_ma_styleattributes"),
        (sc_attrs, "trd_ma_stylecolorattributes"),
        (size_attrs, "trd_ma_sizeattributes"),
        (sku_map, "TRD_REF_CC_SKU_MAPPING"),
        (ref_cc_style_mapping(hier, product), "TRD_REF_CC_STYLE_MAPPING"),
        (size_ids(read(spark, "TRD_IN_BUS_SIZERANGE_MAPPING")), "size_ids"),
    ]:
        write(df, table)

    spark.stop()


if __name__ == "__main__":
    main()
