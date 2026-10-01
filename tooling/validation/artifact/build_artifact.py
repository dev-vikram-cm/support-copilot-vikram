#!/usr/bin/env python3
"""
Refresh the SQL Composer artifact — re-embed a fresh catalog into the
self-contained HTML. The artifact composes queries in-browser (deterministic,
no LLM); this just keeps its baked-in catalog current when configs change.

Usage:
  # 1) export a catalog (all or a module slice), 2) inject it into the html
  python3 build_artifact.py --config-dir /path/to/trd-configs [--module Hindsighting]

Produces/updates: sql-composer.html (catalog embedded in <script id="catalog">).
"""
import argparse, json, re, subprocess, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
VALID = HERE.parent
HTML = HERE / "sql-composer.html"


def slice_module(cat, module):
    hv = [v for v in cat["view_index"] if v["tab"] == module and v.get("pivot")]
    pivs = sorted({v["pivot"] for v in hv})
    return {"generated": cat["generated"], "client": cat["client"], "module": module,
            "pivots": {p: cat["pivots"][p] for p in pivs if p in cat["pivots"]},
            "view_index": hv,
            "consistency": {p: cat["consistency"][p] for p in pivs if p in cat["consistency"]}}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config-dir", required=True)
    ap.add_argument("--module", default="Hindsighting",
                    help="module slice to embed (default Hindsighting; 'ALL' for everything)")
    a = ap.parse_args()
    tmp = "/tmp/_catalog_full.json"
    subprocess.run([sys.executable, str(VALID / "build_catalog.py"),
                    "--config-dir", a.config_dir, "--stats", "--export", tmp], check=True)
    cat = json.loads(Path(tmp).read_text())
    if a.module and a.module.upper() != "ALL":
        cat = slice_module(cat, a.module)
    payload = json.dumps(cat)
    assert "</script" not in payload, "catalog would break the <script> tag"
    html = HTML.read_text()
    new = re.sub(r'(<script id="catalog" type="application/json">).*?(</script>)',
                 lambda m: m.group(1) + payload + m.group(2), html, flags=re.S)
    HTML.write_text(new)
    print(f"embedded {len(cat['pivots'])} pivots / {len(cat['view_index'])} views "
          f"({a.module}) -> {HTML.name}  ({round(len(new)/1024)} KB)")


if __name__ == "__main__":
    main()
