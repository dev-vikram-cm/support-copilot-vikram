# Data Validation Studio (UI)

A single-page web tool — same design language as the ETL Lineage Explorer
(`tooling/lineage-viz`) — that turns a picked **screen → view → scope** into a
**ClickHouse-correct, consistency-annotated validation query** you can run and
cross-check against the S5 app UI.

## What it does

- **Paste app URL** (header): paste an S5 screen URL (the `#/…` route) and it
  auto-selects module → screen → view by walking the confdefn `pathSlot`s
  (`route_resolver.py`), then composes the query for that screen.
- **module → screen → view** pickers, plus grain (`aggBy`) and criteria
  (HIST/FLOW).
- **Time** picker with modes: **Range** (from/to week, resolved via `indx`),
  **Floorset** (+ sales/receipt/life window), **Quarter**, **Season**, **Weeks**.
  Resolves live to the concrete week set and shows `→ N weeks`.
- **Scope & filters**: Department (product scope), Channel (location scope),
  Cluster/grade, Product-lifecycle (`prodlife` FP/MD/OOL), Flow status
  (documented as pivot-derived).
- **Metrics**: checkboxes (all on by default, all/none) — compose only the
  metrics you want; grain + choice count always kept.
- **Center**: the composed SQL with a verdict bar (✓ consistent / ⚠ outlier /
  ⚠ no-op), a `🔒 read-only account` badge, and **Copy SQL**.
- **Side panel — pivot contract**: base view, grain, per-metric aggregation
  family (additive `sum` / snapshot `argMax` / first `argMin`), the FLOW/HIST
  criteria, and sibling pivots to reconcile against.
- **Execute & compare** (needs a read-only ClickHouse DSN — deferred): runs the
  query and diffs against expected UI numbers.

Compose, pickers, URL-resolution and the SQL all work **without ClickHouse** —
only Execute & compare needs `CH_DSN`.

## Host it locally (one command)

Prereqs: Python 3.8+, on the VPN (so the live pickers can reach the read-only
DB). The catalog is built automatically on first run.

    cd tooling/validation/ui
    CONFIG_DIR=/path/to/trd-configs ./serve_local.sh
    # → http://localhost:8770

`serve_local.sh` creates a venv, installs FastAPI/uvicorn, builds `catalog.db`
from the config if missing (no DB needed for that step), and serves.

Options:

    PORT=9000        CONFIG_DIR=… ./serve_local.sh          # different port
    CH_DSN=http://ro:pass@ch-host:8123 CONFIG_DIR=… ./serve_local.sh   # enable Execute & compare
    CATALOG_DB=/custom/catalog.db      CONFIG_DIR=… ./serve_local.sh   # custom catalog path

### Manual (equivalent) steps

    python3 -m venv .venv && source .venv/bin/activate
    pip install -r requirements.txt
    python3 ../build_catalog.py --config-dir /path/to/trd-configs   # once, and after config changes
    CONFIG_DIR=/path/to/trd-configs ./run.sh                        # → http://localhost:8770

## Notes

- Needs a real filesystem (SQLite + the config repo) — run on your machine.
- **Live pickers + URL resolution need the VPN**; module/screen/view lists come
  from the locally-built catalog and work offline.
- Every query the tool sends is gated by the read-only guard
  (`tooling/db/readonly_guard.py`) and runs as the read-only DB account.
- Higher product grains (class/department) still emit a hierarchy-join TODO
  until the M_Meta join lands; stylecolor/style resolve directly.
