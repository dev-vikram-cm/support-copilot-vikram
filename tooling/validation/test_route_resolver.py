#!/usr/bin/env python3
"""
Tests for route_resolver against the real confdefns. Needs the config repo:
set CONFIG_DIR (defaults to the common local path); SKIPs cleanly if absent so
CI without the config doesn't fail.

Run:  CONFIG_DIR=/path/to/trd-configs python3 test_route_resolver.py
"""
import os, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "db"))
import route_resolver as rr

CONFIG_DIR = os.environ.get("CONFIG_DIR") or "/Users/vigneshn/Desktop/JIRAs/SUP-4153/trd-configs"

CASES = [
    # url, expected tab, expected pivot (or model), expected model
    ("https://qa.torrid.oci.s5stratos.com/#/bottom-up/hindsighting/category-recap/hist-category-recap-worklist/hist-category-summary",
     "hindsighting", "HistoryGrid_Companion", "HistoryGrid_Companion"),
    ("https://qa.torrid.oci.s5stratos.com/#/bottom-up/hindsighting/style-color-review/canvas-view",
     "hindsighting", "HistoryFit", "HistoryFit"),
    ("https://qa.torrid.oci.s5stratos.com/#/bottom-up/hindsighting/history-grid/history-grid",
     "hindsighting", "BU_HistoryGridStyleColor", "HistoryHistoryGridNestedViewGrid"),
]


def main():
    if not Path(CONFIG_DIR, "uidefn", "conf").exists():
        print(f"SKIP — config not found at {CONFIG_DIR} (set CONFIG_DIR).")
        return 0
    fails = []
    # parse-only checks (no config needed) — always run
    p = rr.parse_route("https://h/#/bottom-up/hindsighting/history-grid/history-grid")
    if not (p["perspective"] == "bottom-up" and p["tab"] == "hindsighting" and p["slugs"] == ["history-grid", "history-grid"]):
        fails.append(f"parse_route wrong: {p}")

    for url, tab, pivot, model in CASES:
        r = rr.resolve_url(CONFIG_DIR, url)
        if r["tab"] != tab:
            fails.append(f"{url}\n   tab {r['tab']} != {tab}")
        if r["model"] != model:
            fails.append(f"{url}\n   model {r['model']} != {model}")
        if r["pivot"] != pivot:
            fails.append(f"{url}\n   pivot {r['pivot']} != {pivot}")
        if r["unmatched"]:
            fails.append(f"{url}\n   unexpected unmatched slug: {r['unmatched']}")

    if fails:
        print(f"FAIL ({len(fails)}):")
        for f in fails:
            print("  -", f)
        return 1
    print(f"OK — parse + {len(CASES)} real URLs resolved to the expected model/pivot.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
