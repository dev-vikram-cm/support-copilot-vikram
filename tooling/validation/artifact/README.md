# SQL Composer — artifact (single-file, deterministic, no LLM)

`sql-composer.html` is a **self-contained** version of the Data Validation
Studio's compose surface: open the file in any browser (no Python, no server, no
clone) and pick screen → view → grain → criteria to get a ClickHouse-correct,
consistency-annotated validation query.

**Why it's hallucination-proof:** the composer logic is ported to JS (a faithful
port of `compose.py` — verified byte-for-byte on HistoryFit: `sum()` additive,
`argMax(m,time)` snapshot/EOH, `argMin(m,time)` first/BOH, the real HAVING
criteria, the consistency banner). The pivot **catalog is baked in** (exported
from `build_catalog.py`). At runtime it's pure code over fixed data — the LLM is
not in the loop, so there's nothing to hallucinate.

## Use
Just open `sql-composer.html` (double-click / drag into a browser). Offline.

## Refresh the baked-in catalog (when configs change)
    python3 build_artifact.py --config-dir /path/to/trd-configs            # Hindsighting slice
    python3 build_artifact.py --config-dir /path/to/trd-configs --module ALL   # everything

This re-exports the catalog and re-embeds it into `sql-composer.html`.

## Scope / limits (by design)
- **Snapshot**, not live — refresh after config changes (command above).
- **Compose only** — no DB execute from the browser (LAN/CORS). Run the composed
  SQL with the Python tool / `ch_validate.py` where there's DB access; that's
  where the execute-&-compare loop lives.
- Higher product grains (class/dept) still need the M_Meta hierarchy join; the
  artifact flags them (stylecolor/style resolve directly).

## Publish as a hosted Claude artifact (optional)
The same HTML can be published as a shareable Claude artifact (its own URL) for
the team — ask the copilot in admin mode to publish it.
