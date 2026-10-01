#!/usr/bin/env bash
# One-command local launch of the Data Validation Studio.
#
#   CONFIG_DIR=/path/to/trd-configs ./serve_local.sh
#   CONFIG_DIR=/path/to/trd-configs CH_DSN=http://ro:pass@ch-host:8123 ./serve_local.sh
#
# Does everything idempotently: creates a venv, installs deps, builds the
# catalog if it's missing (scans config only — no DB/VPN needed), then serves.
# Be on the VPN so the Time/Filter pickers fill from the read-only DB.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"           # tooling/validation/ui
VALID="$(cd "$HERE/.." && pwd)"                 # tooling/validation

: "${CONFIG_DIR:?set CONFIG_DIR to your trd-configs path, e.g. CONFIG_DIR=/Users/you/.../trd-configs ./serve_local.sh}"
export CONFIG_DIR
export CATALOG_DB="${CATALOG_DB:-$CONFIG_DIR/lineage/catalog.db}"
export CLIENT="${CLIENT:-TRD}"

# 1) venv + deps (idempotent; avoids the 'externally-managed-environment' pip error)
VENV="$HERE/.venv"
[ -d "$VENV" ] || python3 -m venv "$VENV"
# shellcheck disable=SC1091
source "$VENV/bin/activate"
pip install -q --upgrade pip >/dev/null 2>&1 || true
pip install -q -r "$HERE/requirements.txt"

# 2) build the catalog if missing/empty (populates module/screen/view lists)
if [ ! -s "$CATALOG_DB" ]; then
  echo "· catalog missing — building from config (no DB needed): $CATALOG_DB"
  mkdir -p "$(dirname "$CATALOG_DB")"
  python3 "$VALID/build_catalog.py" --config-dir "$CONFIG_DIR" --db "$CATALOG_DB"
else
  echo "· catalog: $CATALOG_DB"
fi

# 3) launch
echo "· config : $CONFIG_DIR"
echo "· execute: ${CH_DSN:+enabled}${CH_DSN:-disabled  (set CH_DSN to a read-only ClickHouse DSN to enable Run & compare)}"
echo "· open   : http://localhost:${PORT:-8770}"
echo "  (Time/Filter pickers need the VPN; compose works offline from the catalog.)"
cd "$HERE"
exec python3 -m uvicorn server:app --port "${PORT:-8770}" --reload
