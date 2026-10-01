#!/usr/bin/env python3
"""
Compose an INDEPENDENT validation query from (listData request) + (pivot
contract). It does NOT execute — it prints SQL for you to run and compare to
the UI. Copy the INPUTS (grain/filters from the request); compute the OUTPUT
(metric logic) independently from the contract — so agreement is a real test,
not a replay of the pivot's temp-table flow.

Targets the agg VIEW the pivot actually reads (e.g. trd_p_history_agg), so the
temp tables (trd_<Pivot>_PRODUCT_<session>) are bypassed by design.

Anything not fully grounded is emitted as an explicit  -- TODO/CONFIRM  line
rather than guessed (unknown stays unknown).

Usage:
  python3 compose.py --url "<listData URL>" --config-dir <trd-configs>
  python3 compose.py --url "<URL>" --config-dir <cfg> --criteria hist|flow
"""
import argparse, re, sqlite3, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import listdata_parse, pivot_contract


def consistency_banner(pivot, db_path):
    """Look up this pivot's verdict in the catalog and return SQL-comment lines
    that link the consistency finding straight onto the composed query."""
    try:
        con = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
        row = con.execute("SELECT verdict, base, hist, majority_hist, n_siblings "
                          "FROM consistency WHERE pivot=?", (pivot,)).fetchone()
        con.close()
    except Exception as e:
        return [f"-- (consistency: catalog unavailable: {e})"]
    if not row:
        return ["-- consistency: no verdict for this pivot (not in catalog)."]
    verdict, base, hist, maj_hist, nsib = row
    if verdict == "noop":
        out = ["-- ⚠ CONSISTENCY: this pivot's criteria is a NO-OP → rows are UNFILTERED.",
               f"--   criteria as written: {hist or '(see HAVING above)'}"]
        if base and maj_hist:
            out.append(f"--   {nsib} sibling pivots on {base} filter at: {maj_hist}")
        else:
            out.append("--   this pivot reads a DERIVED source (a nested pivot's output), not a")
            out.append("--   base history table directly — cross-check against the module's primary")
            out.append("--   filtered view (e.g. HistoryFit) to see if this view over-counts.")
        return out
    if verdict == "outlier":
        return ["-- ⚠ CONSISTENCY: this pivot's criteria DIFFERS from its base-mates.",
                f"--   this pivot: {hist}",
                f"--   majority ({nsib} pivots) on {base}: {maj_hist}",
                "--   counts on this view may not reconcile with sibling views (SUP-4486 class)."]
    return [f"-- ✓ CONSISTENCY: criteria matches the majority ({nsib} pivots) on {base}."]

# grounded from trd_p_history_agg column list (clickhouse_schema.sql)
# product LEVEL token -> agg column that represents that grain
PROD_LEVEL_COL = {
    "stylecolor": "product",     # 'product' IS the stylecolor id in this view
    "style": "x_style",
}
# Pivot-DERIVED metrics that are NOT physical columns on the agg view — they are
# counts the pivot computes. Compose them as the correct count expression instead
# of referencing a non-existent column (was causing UNKNOWN_IDENTIFIER on the agg).
DERIVED_METRICS = {
    "cccount":    "count(DISTINCT product)",    # choice / style-color count
    "storecount": "count(DISTINCT location)",   # store count
}
# fixed lower-grain dimensions available directly on the agg view
FIXED_DIMS = {"location", "time", "merchcat", "grade", "prodlife", "cluster"}
DEFAULT_METRICS = ["dmd_u", "shp_u", "eoh_u", "dmd_r", "shp_r"]


def resolve_pivot(defn_id, config_dir):
    """defnId in the request may be a PIVOT id or a MODEL id. Try pivot first;
    else read the model's pivotDefn. Returns (pivotdefn_path, note)."""
    cfg = Path(config_dir)
    p = cfg / "pivot" / f"{defn_id}.pivotdefn"
    if p.exists():
        return p, None
    m = cfg / "uidefn" / "model" / f"{defn_id}.modeldefn"
    if m.exists():
        import json
        pv = json.loads(m.read_text()).get("pivotDefn")
        if pv:
            pp = cfg / "pivot" / f"{pv}.pivotdefn"
            if pp.exists():
                return pp, f"defnId '{defn_id}' is a model -> pivotDefn '{pv}'"
    return None, f"could not resolve defnId '{defn_id}' to a pivotdefn"


def _inlist(vals):
    return ", ".join("'" + str(v).replace("'", "''") + "'" for v in vals if str(v).strip())


def _alias(label):
    """Quote an output alias when it isn't a plain identifier (view labels like
    'R$ Sales', 'FGM %' need backticks in ClickHouse)."""
    return str(label) if re.match(r"^[A-Za-z_][A-Za-z0-9_]*$", str(label)) \
        else "`" + str(label).replace("`", "``") + "`"


def _scope_clause(col, ids, subquery, note):
    """Scope predicate for a grain column. Prefer a compact ClickHouse subquery
    against the hierarchy (readable, no thousands of inlined ids); otherwise fall
    back to an inline IN list (annotated with its size)."""
    if subquery:
        return f"  AND {col} IN (\n      {subquery}\n  )   -- {note} (hierarchy subquery)"
    n = len([i for i in ids if str(i).strip()])
    return f"  AND {col} IN ({_inlist(ids)})   -- {note} ({n} ids)"


def compose(url, config_dir, which="hist", catalog=None, filters=None):
    filters = filters or {}          # {weeks:[], time_note, location:[], cluster:[],
                                     #  prodlife:[], flowStatus, department:[], channel:[], product:[],
                                     #  metrics:[]  (subset of the pivot's metrics; default all)}
    scope = listdata_parse.parse(url)
    pivot = scope["defnId"]
    if not pivot:
        return "-- ERROR: no defnId in the request; cannot pick a pivot."
    cpath, resolve_note = resolve_pivot(pivot, config_dir)
    if not cpath:
        return f"-- ERROR: {resolve_note}"
    c = pivot_contract.extract(cpath)

    table = c["runtime_table"] or "trd_p_history_agg"
    maggs = c.get("metric_aggs", {})
    # metrics, ordered core-first then the rest — the full set the pivot exposes.
    CORE = ["dmd_u", "shp_u", "ret_u", "dmd_r", "shp_r", "eoh_u", "boh_u"]
    ordered = [m for m in CORE if m in maggs] + [m for m in sorted(maggs) if m not in CORE]
    if not ordered:
        ordered = list(maggs)[:8]
    # metric picker: if the caller chose a subset, emit ONLY those (+ grain +
    # choice count); each metric's ch_expr already pulls its own related columns
    # (e.g. argMax(eoh_u, time)). Default = all of the pivot's metrics.
    want = filters.get("metrics") or []
    missing = [m for m in want if m not in maggs]
    show = [m for m in ordered if m in set(want)] if want else ordered
    crit = c["hist_criteria"] if which == "hist" else c["flow_criteria"]
    crit_kind = "HIST (sum-based)" if which == "hist" else "FLOW (avg-based)"

    # resolve the requested product grain
    prod_levels = [g for g in scope["grain"] if g["kind"] == "level"
                   and g["name"] not in FIXED_DIMS]
    warnings, group_cols, select_dims = [], [], []
    for g in prod_levels:
        col = PROD_LEVEL_COL.get(g["name"])
        if col:
            group_cols.append(col); select_dims.append(f"{col} AS {g['name']}")
        else:
            warnings.append(f"grain level '{g['name']}' is not a direct column on "
                            f"{table} — needs a product-hierarchy join (M_Meta). "
                            f"Query below groups at stylecolor; roll up in the tool.")
    if not group_cols:                       # default to stylecolor
        group_cols = ["product"]; select_dims = ["product AS stylecolor"]

    L = []
    L.append(f"-- ============================================================")
    L.append(f"-- VALIDATION QUERY (independent oracle) — compose.py")
    L.append(f"-- pivot/defnId : {pivot}" + (f"   ({resolve_note})" if resolve_note else ""))
    L.append(f"-- grain (aggBy): {scope['grain_raw'] or '(none)'}")
    L.append(f"-- source view  : {table}   (temp tables bypassed by design)")
    if c.get("runtime_note"):
        L.append(f"-- table map    : {c['runtime_note']}")
    L.append(f"-- criteria     : {crit_kind}: {crit}")
    if scope["flowStatus"] not in (None, ""):
        L.append(f"-- flowStatus   : {scope['flowStatus']}  (filter — confirm column below)")
    if scope["topMembers"]:
        L.append(f"-- topMembers   : {scope['topMembers']}  (scope — needs hierarchy join)")
    for w in warnings:
        L.append(f"-- TODO/CONFIRM : {w}")
    L.append(f"-- BEFORE RUN    : set the history time window to match the UI "
             f"(HistoryStart..HistoryEnd / HISTORY_WEEKS).")
    L.append(f"-- CH DIALECT    : `time` is a String week id → filter with IN (not a date BETWEEN).")
    L.append(f"--   additive metrics use sum(); POINT-IN-TIME stock metrics use "
             f"argMax(m, time) (EOH=last) / argMin(m, time) (BOH=first) — NOT sum.")
    # metric selection provenance
    if filters.get("view_metrics"):
        vv = filters["view_metrics"]
        okn = sum(1 for v in vv if v.get("ok", True))
        L.append(f"-- metrics     : {okn}/{len(vv)} VIEW-label metrics from the viewdefn "
                 f"(output columns match the screen; formulas grounded to agg columns)")
    elif want:
        L.append(f"-- metrics     : subset ({len(show)}/{len(maggs)}): {', '.join(show) or '(none matched)'}")
        if missing:
            L.append(f"-- TODO/CONFIRM : requested metric(s) not on this pivot: {', '.join(missing)}")
    else:
        L.append(f"-- metrics     : all {len(show)} on this pivot: {', '.join(show)}")
    L.append("")

    # --- inner aggregate SELECT --------------------------------------------
    # Inner aggregate aliases are PREFIXED (m_/c_) so an alias can never equal a
    # base column that another aggregate references — that is the ClickHouse
    # ILLEGAL_AGGREGATION trap (e.g. `argMax(eoh_u,time) AS eoh_u` next to
    # `sum(eoh_u)` makes eoh_u resolve to the alias). The outer query renames
    # m_<metric> back to the clean display name.
    dim_aliases = [d.split(" AS ")[-1].strip() for d in select_dims]
    inner = list(select_dims)
    disp = []                             # (label, inner_alias) for outer rename
    expr2alias = {}                       # ch_expr (spaces stripped) -> inner alias
    todo_notes = []
    vms = filters.get("view_metrics")     # [{label, expr, ok, missing, formula}]
    if vms:
        # compose the user-facing VIEW metrics (labels + formulas) so the DB
        # output matches the screen; ungroundable ones become explicit TODOs.
        for i, vm in enumerate(vms):
            if not vm.get("ok", True):
                todo_notes.append(f"-- TODO metric '{vm['label']}': not groundable on {table} "
                                  f"({', '.join(vm.get('missing', []))}); UI formula: {vm.get('formula','')}")
                continue
            ia = f"m_{i}"
            inner.append(f"{vm['expr']} AS {ia}")
            disp.append((vm["label"], ia))
            expr2alias[vm["expr"].replace(' ', '')] = ia
    else:
        for m in show:
            if m in DERIVED_METRICS:
                expr = DERIVED_METRICS[m]         # a count, not an agg column
            else:
                info = maggs.get(m)
                expr = info["ch_expr"] if info else f"sum({m})"
            ia = f"m_{m}"
            inner.append(f"{expr} AS {ia}")
            disp.append((m, ia))
            expr2alias[expr.replace(' ', '')] = ia
    inner.append("count(DISTINCT product) AS stylecolor_count")

    # --- WHERE lines (scope/filters) — built once, used by flat or wrapped ---
    wl = []
    weeks = filters.get("weeks") or []
    if weeks:
        if filters.get("time_note"):
            wl.append(f"-- time window: {filters['time_note']}")
        wl.append(f"WHERE time IN ({_inlist(weeks)})")
    else:
        wl.append("WHERE time IN (:HISTORY_WEEKS)               -- REQUIRED: string week ids (Time picker: range/floorset/quarter → weeks)")
    # specific item override — validate ONE (or a few) grain ids directly, no
    # whole-scope expansion. item_col must be a real agg column (product=stylecolor,
    # location=store, cluster, prodlife, time).
    if filters.get("items"):
        icol = filters.get("item_col") or "product"
        wl.append(f"  AND {icol} IN ({_inlist(filters['items'])})   -- specific item(s) [{icol}]")
    if filters.get("cluster"):
        wl.append(f"  AND cluster IN ({_inlist(filters['cluster'])})   -- Cluster/Grade (direct: agg.cluster)")
    if filters.get("prodlife"):
        wl.append(f"  AND prodlife IN ({_inlist(filters['prodlife'])})   -- Product lifecycle (trd_d_prodlife: FP/MD/OOL)")
    fs = filters.get("flowStatus", scope.get("flowStatus"))
    if fs not in (None, ""):
        wl.append(f"--  flowStatus={fs}: pivot-derived (New/Carryover/Sell-down) via flow_status_<PID> — reconcile vs this pivot's FLOW criteria")
    # Product scope (Department → stylecolors) and Location scope (Channel → stores)
    if filters.get("product_subquery") or filters.get("product"):
        wl.append(_scope_clause("product", filters.get("product") or [], filters.get("product_subquery"),
                                "Department scope → stylecolors (trd_stylecolor_hier_attr)"))
    elif filters.get("department") or scope.get("topMembers"):
        d = filters.get("department") or scope.get("topMembers")
        wl.append(f"--  AND product IN (SELECT stylecolor FROM trd_stylecolor_hier_attr WHERE department IN ('{d}'))   -- (scope not resolved)")
    if filters.get("location_subquery") or filters.get("location"):
        wl.append(_scope_clause("location", filters.get("location") or [], filters.get("location_subquery"),
                                "Location scope → stores (trd_store_hier_attr)"))
    elif filters.get("channel"):
        wl.append(f"--  AND location IN (SELECT store FROM trd_store_hier_attr WHERE channel IN ('{filters['channel']}'))   -- (scope not resolved)")

    # --- criteria: move to an OUTER WHERE over a subquery, remapping each
    # aggregate to an inner alias. This avoids the ClickHouse nested-aggregate
    # error (an alias like `dmd_u` shadowing the column inside HAVING sum(dmd_u))
    # AND reads far cleaner. ------------------------------------------------
    outer_where = None
    if crit:
        agg_re = re.compile(r"(?:sum|avg|count|min|max|any|uniq|uniqExact|argMax|argMin)\s*\([^()]*\)", re.I)
        cm = crit.strip()
        seen = {}
        for e in agg_re.findall(cm):
            key = e.replace(' ', '')
            if key in expr2alias:
                alias = expr2alias[key]
            elif key in seen:
                alias = seen[key]
            else:
                alias = f"c_{len(seen)}"
                seen[key] = alias
                inner.append(f"{e} AS {alias}")
            cm = cm.replace(e, alias)
        outer_where = cm

    # Always wrap: aggregate (with safe prefixed aliases) in the subquery, then
    # rename to clean display names and apply the criteria outside — no alias can
    # shadow a column inside an aggregate anywhere.
    for n in todo_notes:
        L.append(n)
    outer_cols = list(dim_aliases) + [f"{ia} AS {_alias(label)}" for (label, ia) in disp] + ["stylecolor_count"]
    L.append("SELECT " + ", ".join(outer_cols))
    L.append("FROM (")
    L.append("  SELECT")
    for i, it in enumerate(inner):
        L.append(f"    {it}{',' if i < len(inner) - 1 else ''}")
    L.append(f"  FROM {table}")
    for w in wl:
        L.append("  " + w)
    L.append(f"  GROUP BY {', '.join(group_cols)}")
    L.append(") AS agg")
    if catalog:
        L += consistency_banner(cpath.stem, catalog)
    if outer_where:
        L.append(f"WHERE {outer_where}          -- pivot selection criteria (references the aggregates by alias)")
    L.append(f"ORDER BY {', '.join(dim_aliases)}")
    L.append(";")
    L.append("")
    L.append("-- Compare to the UI for the SAME scope:")
    L.append("--   * stylecolor_count       == the count/# products shown")
    L.append("--   * each metric (per its aggregation) == the rolled-up value on screen")
    L.append("--   * a row present here but missing on the UI (or vice-versa) => a criteria/filter bug (SUP-4486 class)")
    L.append("--   NOTE: if a stock metric (eoh/boh) mismatches, check the point-in-time ordering key (time).")
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--url", required=True, help="the pivot3 listData URL (or a log line with it)")
    ap.add_argument("--config-dir", required=True, help="path to trd-configs")
    ap.add_argument("--criteria", choices=["hist", "flow"], default="hist")
    ap.add_argument("--catalog", default=None, help="path to catalog.db → annotate with consistency verdict")
    a = ap.parse_args()
    print(compose(a.url, a.config_dir, a.criteria, a.catalog))


if __name__ == "__main__":
    main()
