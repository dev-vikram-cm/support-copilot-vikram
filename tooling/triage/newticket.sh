#!/usr/bin/env bash
# Set up a per-ticket workspace: folder, cloned repos on a ticket branch,
# optional OCI live-config, and an initialized state.json. Deterministic —
# reads customers/<CID>/repos.json for the exact repo+branch.
#
# Usage:
#   tooling/triage/newticket.sh <SUP-ID> <CID> <component> [env]
#     component: etl | config | frontend | backend | hybrid | all
#     env:       qa | staging | prod   (default: qa; drives branch + OCI)
#   e.g. tooling/triage/newticket.sh SUP-4321 TRD config qa
set -euo pipefail

TID="${1:?usage: newticket.sh <SUP-ID> <CID> <component> [env]}"
CID="${2:?customer id, e.g. TRD}"
COMP="${3:?component: etl|config|frontend|backend|hybrid|all}"
ENV="${4:-qa}"

HERE="$(cd "$(dirname "$0")" && pwd)"
HUB="$(cd "$HERE/../.." && pwd)"
WS="$HUB/tickets/$TID"
REPOS_JSON="$HUB/customers/$CID/repos.json"
PLATFORM_JSON="$HUB/knowledge/platform-repos.json"
mkdir -p "$WS/repos" "$WS/logs" "$WS/live-config"

# --- freshness: is this support-copilot checkout current with the team? -----
# Non-fatal — just surfaces a sync suggestion so you don't start on a stale copy.
echo "== support-copilot freshness =="
python3 "$HERE/repo_sync_check.py" || true
echo

echo "== workspace: tickets/$TID (client $CID, component $COMP, env $ENV) =="

# --- resolve which repos this component needs -------------------------------
layers=()
case "$COMP" in
  all|hybrid) layers=(etl config frontend backend) ;;
  *) IFS='+' read -ra layers <<< "$COMP" ;;   # allow "etl+config"
esac

jqget() { python3 -c "import json,sys;d=json.load(open(sys.argv[1]));print(d.get(sys.argv[2],{}).get(sys.argv[3],''))" "$1" "$2" "$3" 2>/dev/null; }

branch_for_env() {  # layer env -> branch key
  local layer="$1" env="$2" f="$3"
  local b
  b="$(jqget "$f" "$layer" "branch_${env}")"                 # per-env (etl/config)
  [ -z "$b" ] && b="$(jqget "$f" "$layer" default_branch)"   # per-client default
  [ -z "$b" ] && b="$(jqget "$f" "$layer" branch)"           # shared platform (frontend/backend)
  echo "$b"
}

clone_layer() {
  local layer="$1" f="$2"
  local repo; repo="$(jqget "$f" "$layer" repo)"
  [ -z "$repo" ] && { echo "  ($layer: no repo in $(basename "$f") — skip)"; return; }
  local branch; branch="$(branch_for_env "$layer" "$ENV" "$f")"
  local name; name="$(basename "$repo" .git)"
  local dest="$WS/repos/$name"
  if [ -d "$dest/.git" ]; then
    echo "  $layer: $name already cloned"
  else
    echo "  $layer: clone $name @ $branch"
    git clone --depth 1 -b "$branch" "$repo" "$dest" 2>&1 | tail -1 || \
      echo "    (clone failed — check access/branch $branch)"
  fi
  # per-ticket fix branch
  ( cd "$dest" && git checkout -b "$TID" 2>/dev/null || git checkout "$TID" 2>/dev/null || true )
}

for layer in "${layers[@]}"; do
  case "$layer" in
    frontend|backend) clone_layer "$layer" "$PLATFORM_JSON" ;;
    etl|config)       clone_layer "$layer" "$REPOS_JSON" ;;
  esac
done

# --- config layer: overlay OCI live config for the env ----------------------
if printf '%s\n' "${layers[@]}" | grep -qx config; then
  echo "== OCI live config for $ENV (config = base branch + OCI overlay) =="
  echo "   see knowledge/runbooks/fetch-live-config.md — run then diff vs the cloned config repo:"
  case "$ENV" in
    qa)      echo "   oci os object sync -bn internal-qa-config      --prefix trd/asst/ --dest-dir $WS/live-config/qa/" ;;
    staging) echo "   oci os object sync -bn trd-trd-1-staging-config --prefix trd/asst/ --dest-dir $WS/live-config/staging/" ;;
    prod)    echo "   oci os object sync -bn trd-trd-1-prod-config    --prefix trd/asst/ --dest-dir $WS/live-config/prod/" ;;
  esac
fi

# --- initialize state.json --------------------------------------------------
STATE="$WS/state.json"
if [ ! -f "$STATE" ]; then
  cat > "$STATE" <<JSON
{
  "ticket": "$TID",
  "client": "$CID",
  "owner": "$(git config user.email 2>/dev/null || echo "${USER:-unknown}")",
  "stage": "intake",
  "classification": {"type": null, "type_source": null,
    "component": ["${layers[0]}"], "component_source": "newticket-arg",
    "environment": "$ENV"},
  "requirement": {"statement": "", "confirmed": false},
  "prior_art": [], "evidence": [], "requested_evidence": [],
  "hypotheses": [], "root_cause": {}, "fix": {"branch": "$TID"},
  "validation": {}, "knowledge_gained": {}, "confidence": {}
}
JSON
  echo "== initialized $STATE =="
fi

echo "== done. Next: fill state.json, confirm the requirement, run"
echo "   python3 tooling/triage/confidence.py tickets/$TID/state.json =="
