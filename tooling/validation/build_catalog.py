#!/usr/bin/env python3
"""
Build the validation CATALOG — the shared fact store that lets the composer,
the consistency checker, and the UI scale to many modules/pivots without
reparsing. Deterministic: walk config ONCE, write structured facts to SQLite.
No RAG, no vectors — exact-key lookups on structured data.

Tables:
  pivots(pivot, base, grain, metrics, flow, hist, flow_noop, hist_noop, path)
  view_index(tab, screen, model, view, pivot, base)   -- (screen,view) -> pivot
  consistency(pivot, base, verdict, hist, flow, majority_hist, n_siblings)
  base_summary(base, n_pivots, n_variants, inconsistent, majority_hist, majority_flow)

Usage:
  python3 build_catalog.py --config-dir <trd-configs> [--db <path.db>]
  python3 build_catalog.py --config-dir <cfg> --stats     # print, don't write
Rebuild incrementally in future by diffing changed files; for now it's a fast
full rebuild (regex over text).
"""
import argparse, json, sqlite3, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import pivot_contract, criteria_consistency as cc


# ---------- extract pivots ----------
def scan_pivots(cfg):
    out = {}
    for f in sorted((cfg / "pivot").glob("*.pivotdefn")):
        c = pivot_contract.extract(f)
        out[c["pivot"]] = c
    return out


# ---------- walk confdefn: (tab, screen, model, view[]) ----------
def scan_screens(cfg):
    rows = []
    conf = cfg / "uidefn" / "conf" / "AssortmentUiConf.confdefn"
    if not conf.exists():
        return rows
    d = json.loads(conf.read_text())
    for tab in d.get("tabs", []):
        tab_id = tab.get("id")
        def walk(o, screen_ctx):
            if isinstance(o, dict):
                sid = o.get("id", screen_ctx)
                if "defns" in o and isinstance(o["defns"], dict):
                    dn = o["defns"]
                    model = dn.get("model")
                    for v in (dn.get("view") or []):
                        rows.append({"tab": tab_id, "screen": o.get("id", screen_ctx),
                                     "model": model, "view": v})
                for v in o.values():
                    walk(v, sid)
            elif isinstance(o, list):
                for v in o:
                    walk(v, screen_ctx)
        walk(tab, tab_id)
    return rows


# ---------- model -> pivot ----------
def model_pivot(cfg, model):
    if not model:
        return None
    m = cfg / "uidefn" / "model" / f"{model}.modeldefn"
    if m.exists():
        try:
            return json.loads(m.read_text()).get("pivotDefn")
        except Exception:
            return None
    return None


# ---------- consistency from contracts ----------
def build_consistency(pivots):
    rows = [{"pivot": p["pivot"], "base": p.get("runtime_table"),
             "flow": cc.norm(p.get("flow_criteria")), "hist": cc.norm(p.get("hist_criteria")),
             "flow_noop": cc.is_noop(p.get("flow_criteria")),
             "hist_noop": cc.is_noop(p.get("hist_criteria"))} for p in pivots.values()]
    rep = cc.analyze(rows)
    verdict = {}          # pivot -> (base, verdict, hist, flow, majority_hist, n_siblings)
    base_summary = {}
    for g in rep["groups"]:
        base = g["base"]; maj = g["majority"]
        base_summary[base] = {"n_pivots": g["n_pivots"], "n_variants": g["n_variants"],
                              "inconsistent": int(g["n_variants"] > 1),
                              "majority_hist": maj["hist"], "majority_flow": maj["flow"]}
        for pv in maj["pivots"]:
            verdict[pv] = (base, "majority", maj["hist"], maj["flow"],
                           maj["hist"], len(maj["pivots"]))
        for o in g["outliers"]:
            for pv in o["pivots"]:
                verdict[pv] = (base, "outlier", o["hist"], o["flow"],
                               maj["hist"], len(maj["pivots"]))
    noop_pivots = {n["pivot"] for n in rep["noops"]}
    for pv in noop_pivots:                       # noop overrides verdict label
        r = pivots[pv]
        base = r.get("runtime_table")
        prev = verdict.get(pv)
        verdict[pv] = (base, "noop",
                       cc.norm(r.get("hist_criteria")), cc.norm(r.get("flow_criteria")),
                       prev[4] if prev else None, prev[5] if prev else 0)
    return verdict, base_summary, rep


# ---------- write sqlite ----------
def write_db(db_path, pivots, screens, verdict, base_summary, cfg):
    db_path.parent.mkdir(parents=True, exist_ok=True)
    if db_path.exists():
        db_path.unlink()
    con = sqlite3.connect(db_path); cur = con.cursor()
    cur.executescript("""
      CREATE TABLE pivots(pivot TEXT PRIMARY KEY, base TEXT, grain TEXT, metrics TEXT,
        metric_aggs TEXT, flow TEXT, hist TEXT, flow_noop INT, hist_noop INT,
        uses_agg_products INT, path TEXT);
      CREATE TABLE view_index(tab TEXT, screen TEXT, model TEXT, view TEXT, pivot TEXT, base TEXT);
      CREATE TABLE consistency(pivot TEXT PRIMARY KEY, base TEXT, verdict TEXT, hist TEXT,
        flow TEXT, majority_hist TEXT, n_siblings INT);
      CREATE TABLE base_summary(base TEXT PRIMARY KEY, n_pivots INT, n_variants INT,
        inconsistent INT, majority_hist TEXT, majority_flow TEXT);
      CREATE INDEX ix_view_pivot ON view_index(pivot);
      CREATE INDEX ix_view_screenview ON view_index(screen, view);
      CREATE INDEX ix_pivots_base ON pivots(base);
    """)
    for c in pivots.values():
        cur.execute("INSERT INTO pivots VALUES (?,?,?,?,?,?,?,?,?,?,?)",
            (c["pivot"], c.get("runtime_table"), json.dumps(c.get("bottom_levels")),
             json.dumps(c.get("metrics")), json.dumps(c.get("metric_aggs")),
             cc.norm(c.get("flow_criteria")),
             cc.norm(c.get("hist_criteria")), int(cc.is_noop(c.get("flow_criteria"))),
             int(cc.is_noop(c.get("hist_criteria"))), int(c.get("uses_aggregation_products", False)),
             c.get("path")))
    mp_cache = {}
    for r in screens:
        model = r["model"]
        if model not in mp_cache:
            mp_cache[model] = model_pivot(cfg, model)
        pv = mp_cache[model]
        base = pivots.get(pv, {}).get("runtime_table") if pv else None
        cur.execute("INSERT INTO view_index VALUES (?,?,?,?,?,?)",
                    (r["tab"], r["screen"], model, r["view"], pv, base))
    for pv, (base, v, hist, flow, maj_hist, nsib) in verdict.items():
        cur.execute("INSERT OR REPLACE INTO consistency VALUES (?,?,?,?,?,?,?)",
                    (pv, base, v, hist, flow, maj_hist, nsib))
    for base, s in base_summary.items():
        cur.execute("INSERT INTO base_summary VALUES (?,?,?,?,?,?)",
                    (base, s["n_pivots"], s["n_variants"], s["inconsistent"],
                     s["majority_hist"], s["majority_flow"]))
    con.commit(); con.close()


def export_json(out_path, pivots, screens, verdict, base_summary, cfg):
    """Dump the catalog as portable JSON — the data a browser artifact needs to
    compose queries client-side (no Python/DB at runtime, fully deterministic)."""
    import datetime
    piv = {}
    for c in pivots.values():
        piv[c["pivot"]] = {
            "base": c.get("runtime_table"),
            "grain": c.get("bottom_levels"),
            "metrics": c.get("metrics"),
            "metric_aggs": c.get("metric_aggs"),
            "flow": cc.norm(c.get("flow_criteria")),
            "hist": cc.norm(c.get("hist_criteria")),
            "uses_aggregation_products": c.get("uses_aggregation_products", False),
        }
    vidx = []
    mp_cache = {}
    for r in screens:
        model = r["model"]
        if model not in mp_cache:
            mp_cache[model] = model_pivot(cfg, model)
        pv = mp_cache[model]
        vidx.append({"tab": r["tab"], "screen": r["screen"], "model": model,
                     "view": r["view"], "pivot": pv,
                     "base": piv.get(pv, {}).get("base") if pv else None})
    cons = {pv: {"base": b, "verdict": v, "hist": hist, "flow": flow,
                 "majority_hist": mh, "n_siblings": ns}
            for pv, (b, v, hist, flow, mh, ns) in verdict.items()}
    doc = {"generated": datetime.datetime.now().isoformat(timespec="seconds"),
           "client": cfg.name, "pivots": piv, "view_index": vidx,
           "consistency": cons, "base_summary": base_summary}
    Path(out_path).write_text(json.dumps(doc, indent=1))
    print(f"exported {len(piv)} pivots + {len(vidx)} views -> {out_path}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config-dir", required=True)
    ap.add_argument("--db", default=None, help="output SQLite (default: <cfg>/lineage/catalog.db)")
    ap.add_argument("--export", default=None, help="also write catalog JSON (for the browser artifact)")
    ap.add_argument("--stats", action="store_true", help="print summary, don't write")
    a = ap.parse_args()
    cfg = Path(a.config_dir)
    pivots = scan_pivots(cfg)
    screens = scan_screens(cfg)
    verdict, base_summary, rep = build_consistency(pivots)

    linked = sum(1 for r in screens if r["model"])
    print(f"catalog build: {len(pivots)} pivots | {len(screens)} (screen,view) rows "
          f"({linked} with a model) | {len(base_summary)} base tables | "
          f"{rep['inconsistent_bases']} inconsistent, {len(rep['noops'])} no-op")
    if a.export:
        export_json(a.export, pivots, screens, verdict, base_summary, cfg)
    if a.stats:
        return
    db = Path(a.db) if a.db else (cfg / "lineage" / "catalog.db")
    write_db(db, pivots, screens, verdict, base_summary, cfg)
    print(f"wrote {db}")


if __name__ == "__main__":
    main()
