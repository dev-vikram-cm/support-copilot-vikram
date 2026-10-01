#!/usr/bin/env python3
"""
View-label metrics — compose the query using the user-facing metric NAMES and
FORMULAS from the viewdefn (e.g. "R$ Sales", "U Sls", "FGM %", "Unit EOP") so
the DB output lines up 1:1 with the S5 screen, instead of raw pivot columns.

A viewdefn column = { text (label), dataIndex, formula (mathjs), renderer }.
The app evaluates `formula` client-side over the pivot rows with mathjs
(sum/mean/count/first/last). We translate that formula to ClickHouse:

  - each aggregate keeps its meaning: sum→sum, mean→avg, size/count→count,
    first→argMin(x,time), last→argMax(x,time); `sum(1)` → count(DISTINCT product).
  - formula base columns that are pivot-DERIVED (not on the agg view) are
    substituted with their agg-column derivation (DERIVATIONS below):
        net_sls_r = shp_r - ret_r,  net_sls_c = shp_c - ret_c,  net_sls_u = shp_u - ret_u
        sum_eoh_u  → eoh_u           (kept under the outer sum: sum(eoh_u))
        last_value_eoh_u → argMax(eoh_u, time)   (point-in-time; subsumes the outer sum)
  - columns we cannot ground from the agg (funded_*) mark the metric as a TODO
    rather than emitting a missing column.

Output alias is the view `text`, so a DB row reads like the screen.
"""
import json, re
from pathlib import Path

# pivot-derived base column -> how to compute it from AGG columns.
#   ("inline", expr)  : substitute the token; the view's own aggregate stays
#                       (e.g. sum(net_sls_r) -> sum(shp_r - ret_r))
#   ("agg", expr)     : expr is already an aggregate and SUBSUMES the view's
#                       outer aggregate (e.g. sum(last_value_eoh_u) -> argMax(eoh_u,time))
DERIVATIONS = {
    "net_sls_r": ("inline", "shp_r - ret_r"),
    "net_sls_u": ("inline", "shp_u - ret_u"),
    "net_sls_c": ("inline", "shp_c - ret_c"),
    "sum_eoh_u": ("inline", "eoh_u"),
    "last_value_eoh_u": ("agg", "argMax(eoh_u, time)"),
    "last_value_eoh_intransit_u": ("agg", "argMax(eop_intransit_u, time)"),
}
# base columns not present on the agg view → metric can't be grounded here
UNGROUNDABLE = {"funded_shp_u", "funded_ret_u", "funded_aps_u",
                "funded_net_sls_u", "strcntwk_funded"}

_AGG_MAP = {"sum": "sum", "mean": "avg", "avg": "avg", "count": "count",
            "size": "count", "min": "min", "max": "max",
            "first": "argMin", "last": "argMax"}
_CALL = re.compile(r"\b(sum|mean|avg|count|size|min|max|first|last)\s*\(\s*([^()]*?)\s*\)", re.I)
_IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


def translate_formula(formula, order_key="time", count_expr="count(DISTINCT product)"):
    """mathjs formula -> (ch_expr, ok, missing[]). ok=False when a base column
    can't be grounded from the agg (missing lists them)."""
    missing = set()

    def repl(m):
        fn, arg = m.group(1).lower(), m.group(2).strip()
        if fn == "sum" and arg == "1":
            return count_expr
        if arg in DERIVATIONS and DERIVATIONS[arg][0] == "agg":
            return DERIVATIONS[arg][1]           # subsumes the outer aggregate
        for ident in _IDENT.findall(arg):
            if ident in UNGROUNDABLE:
                missing.add(ident)

        def sub(mm):
            w = mm.group(0)
            if w in DERIVATIONS and DERIVATIONS[w][0] == "inline":
                return "(" + DERIVATIONS[w][1] + ")"
            return w
        arg2 = _IDENT.sub(sub, arg)
        chfn = _AGG_MAP.get(fn, fn)
        if chfn in ("argMin", "argMax"):
            return f"{chfn}({arg2}, {order_key})"
        return f"{chfn}({arg2})"

    expr = _CALL.sub(repl, formula)
    return expr, (len(missing) == 0), sorted(missing)


def load_view_columns(config_dir, view_name):
    f = Path(config_dir) / "uidefn" / "view" / f"{view_name}.viewdefn"
    if not f.exists():
        return []
    d = json.loads(f.read_text())
    cols = d.get("view") or d.get("columns") or []
    return [c for c in cols if isinstance(c, dict) and c.get("formula")]


def build_view_metrics(config_dir, view_name, order_key="time"):
    """→ [{label, dataIndex, formula, renderer, expr, ok, missing}] for a view."""
    out = []
    for c in load_view_columns(config_dir, view_name):
        expr, ok, missing = translate_formula(c["formula"], order_key)
        out.append({"label": c.get("text") or c.get("dataIndex"),
                    "dataIndex": c.get("dataIndex"), "formula": c["formula"],
                    "renderer": c.get("renderer"), "expr": expr,
                    "ok": ok, "missing": missing})
    return out


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--config-dir", required=True)
    ap.add_argument("--view", required=True)
    a = ap.parse_args()
    for m in build_view_metrics(a.config_dir, a.view):
        flag = "" if m["ok"] else f"   -- TODO ungroundable: {m['missing']}"
        print(f"{m['label']:22} {m['expr']}{flag}")
        print(f"{'':22}   (formula: {m['formula']})")
