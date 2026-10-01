#!/usr/bin/env python3
"""
Resolve an S5 app URL (the hash route shown in the browser) to the screen it
represents, and from there to the model/pivot the composer validates.

Deterministic: the route segments are matched against `pathSlot` /
`defaultPathSlot` fields in the confdefn tree (tabs → leftNavSections → views…),
filtered by `inPerspectives`. The leaf node's `componentProps.defns.model`
(with `view[]`) is the binding; model → pivotDefn reuses the composer's own
resolver. If a catalog.db is supplied, the (module, screen, view) rows that use
that model/pivot are returned so the UI can auto-select.

    https://host/#/bottom-up/hindsighting/category-recap/hist-category-recap-worklist/hist-category-summary
      perspective ─┘        tab ┘         section ┘        node ┘                     leaf(defaultPathSlot)

Usage:
    python3 route_resolver.py --config-dir /path/trd-configs \
        --url "https://qa…/#/bottom-up/hindsighting/history-grid/history-grid"
"""
import argparse, json, sqlite3, sys
from pathlib import Path
from urllib.parse import unquote

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import compose as composer                    # resolve_pivot(model_or_pivot, cfg)


def parse_route(url):
    """→ {perspective, tab, slugs:[…]} from the hash route (rest after '#')."""
    frag = url.split("#", 1)[1] if "#" in url else url
    segs = [unquote(s) for s in frag.split("/") if s.strip()]
    if not segs:
        return {"perspective": None, "tab": None, "slugs": []}
    perspective = segs[0]
    tab = segs[1] if len(segs) > 1 else None
    return {"perspective": perspective, "tab": tab, "slugs": segs[2:]}


def _child_dicts(node):
    """All dict items in any list-valued field (leftNavSections, views, …)."""
    out = []
    for v in node.values() if isinstance(node, dict) else []:
        if isinstance(v, list):
            out += [x for x in v if isinstance(x, dict)]
    return out


def _in_perspective(node, perspective):
    ip = node.get("inPerspectives")
    return (not ip) or (not perspective) or (perspective in ip)


def _slots(node):
    """All route-slot ids a node answers to (top-level and componentProps-level
    pathSlot / defaultPathSlot)."""
    cp = node.get("componentProps") or {}
    return {node.get("pathSlot"), node.get("defaultPathSlot"),
            cp.get("pathSlot"), cp.get("defaultPathSlot")} - {None}


def _find_confdefn(config_dir, tab_slug, perspective):
    """Pick the confdefn that owns this tab. Prefer the base app config
    (shortest filename) over layout variants (_LG/_LG2/MO/TD…)."""
    cands = []
    for f in sorted(Path(config_dir, "uidefn", "conf").glob("*.confdefn")):
        try:
            doc = json.loads(f.read_text())
        except Exception:
            continue
        for t in doc.get("tabs", []):
            if tab_slug and (t.get("pathSlot") == tab_slug
                             or (t.get("id", "").lower() == tab_slug.lower())):
                if _in_perspective(t, perspective):
                    cands.append((len(f.name), f.name, doc, t))
    cands.sort()
    return (cands[0][2], cands[0][3], cands[0][1]) if cands else (None, None, None)


def _walk(tab_node, slugs, perspective):
    """Walk pathSlot/defaultPathSlot from the tab node. Returns
    (leaf_node, matched_slugs, unmatched_slug|None)."""
    node = tab_node
    matched = []
    for slug in slugs:
        hit = None
        for c in _child_dicts(node):
            if slug in _slots(c) and _in_perspective(c, perspective):
                hit = c
                break
        if hit is not None:
            node = hit
            matched.append(slug)
        elif slug in _slots(node):
            matched.append(slug)                # leaf sub-view tab on the same node
        else:
            return node, matched, slug           # unmatched → best-effort at current node
    return node, matched, None


def _leaf_binding(node):
    """Find (model, views[]) for a node: its own defns, else defaultView, else
    the first descendant carrying a defns.model."""
    def defns_of(n):
        d = (n.get("componentProps") or {}).get("defns") or n.get("defns")
        return d if isinstance(d, dict) else None
    d = defns_of(node)
    if d and d.get("model"):
        v = d.get("view")
        return d["model"], (v if isinstance(v, list) else [v] if v else [])
    if node.get("defaultView"):
        return node["defaultView"], []           # a defn id; resolve_pivot handles it
    for c in _child_dicts(node):
        m, v = _leaf_binding(c)
        if m:
            return m, v
    return None, []


def _catalog_rows(catalog, model, pivot):
    if not catalog or not Path(catalog).exists():
        return []
    try:
        con = sqlite3.connect(f"file:{catalog}?mode=ro", uri=True)
        con.row_factory = sqlite3.Row
        rows = con.execute(
            "SELECT tab AS module, screen, view, pivot, model FROM view_index "
            "WHERE model=? OR pivot=? ORDER BY tab, screen, view",
            (model or "", pivot or "")).fetchall()
        con.close()
        return [dict(r) for r in rows]
    except Exception:
        return []


def resolve_url(config_dir, url, catalog=None):
    r = parse_route(url)
    out = {"url": url, "perspective": r["perspective"], "tab": r["tab"],
           "slugs": r["slugs"], "matched": [], "unmatched": None,
           "model": None, "views": [], "pivot": None, "pivot_note": None,
           "catalog_match": None, "candidates": [], "confdefn": None, "warnings": []}
    if not r["tab"]:
        out["warnings"].append("no tab segment in URL"); return out
    doc, tab_node, fname = _find_confdefn(config_dir, r["tab"], r["perspective"])
    out["confdefn"] = fname
    if not tab_node:
        out["warnings"].append(f"tab '{r['tab']}' not found in any confdefn"); return out
    leaf, matched, unmatched = _walk(tab_node, r["slugs"], r["perspective"])
    out["matched"] = matched
    out["unmatched"] = unmatched
    if unmatched:
        out["warnings"].append(f"slug '{unmatched}' not matched — resolved to nearest node")
    model, views = _leaf_binding(leaf)
    out["model"], out["views"] = model, views
    if not model:
        out["warnings"].append("no model binding on the resolved node (presentation-only?)")
        return out
    cpath, note = composer.resolve_pivot(model, config_dir)
    if cpath:
        out["pivot"] = cpath.stem
        out["pivot_note"] = note
    else:
        out["warnings"].append(note or f"could not resolve model '{model}' to a pivot")
    rows = _catalog_rows(catalog, model, out["pivot"])
    out["candidates"] = rows
    out["catalog_match"] = rows[0] if rows else None
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config-dir", required=True)
    ap.add_argument("--url", required=True)
    ap.add_argument("--catalog", default=None, help="catalog.db → also map to module/screen/view")
    a = ap.parse_args()
    cat = a.catalog or (Path(a.config_dir) / "lineage" / "catalog.db")
    r = resolve_url(a.config_dir, a.url, str(cat) if Path(cat).exists() else None)
    print(json.dumps(r, indent=2))


if __name__ == "__main__":
    main()
