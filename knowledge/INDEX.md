# Knowledge Index — the map of everything the copilot knows

The agent's routing table. When working a ticket, find the relevant row(s)
by the "Use when" trigger, then read that file. Grep this index first if
unsure where something lives. **Keep this current: every new knowledge
file gets a row here.**

## Process & workflow

| File | Use when |
|---|---|
| `WELCOME.md` (repo root) | The session-start menu — greet + capability options (persona-filtered) + routing into each workflow. Shown on the first turn. |
| `AGENT.md` (repo root) | **First read for any agent** — persona resolution (admin/user) + the loop, grounding rules, classification + confidence rubrics |
| `modes/roles.json` + `modes/{admin,user}.md` | **Persona modes** — admin (owner/architect: proactive, edits the brain, suggests what to build) vs user (ticket-solving guide). Resolved by email; `/mode` switches (admin owner-gated). Distinct from tutor/pair/autopilot |
| `jira-agent-system-prompt.md` (repo root) | Self-contained system prompt for an LLM+API JIRA agent (no shell) — paste into agent config |
| `knowledge/workflow.md` | Always — the 8-stage ticket workflow + JIRA contract + the two gates |
| `knowledge/system-map.md` | Routing a ticket to a layer (ETL/config/frontend/backend/db); repo contracts |
| `knowledge/TEMPLATE.md` | Writing a solution note (retro) |
| `knowledge/PLAN.md` | Big-picture roadmap / status of the whole initiative |
| `knowledge/IDEAS.md` | Enhancement backlog (config-verify harness, pivot-file lineage, …) |

## Domain knowledge — the FUNCTIONAL half (retail meaning)

| File | Use when |
|---|---|
| `knowledge/domain/glossary.md` | Any term/metric (choice count, APS, OTB, flow status, sell-through, TY/LY/LLY…) — business meaning + the **↔ tech** anchor. Grep this to fill the "functional" half of `knowledge_gained` |
| `knowledge/domain/assortment-planning-primer.md` | Need the retail mental model: the 6 products, the L3 process phases, pre/in-season, planning vs forecasting. Place a ticket on the process map |

## Platform knowledge — how the product works

| File | Use when |
|---|---|
| `knowledge/config-layer/PLATFORM-PRIMER.md` | Need the whole-system mental model in one place (portable; also good to hand another agent) |
| `knowledge/config-layer/cheatsheets.md` | Config-layer file-type grammar (confdefn/view/model/pivot/filter/mfp) — debug decision tree, dataIndex namespaces, FreeMarker |
| `knowledge/config-layer/components-reference.md` | Which UI components exist, their 3 contracts, choosing one |
| `knowledge/config-layer/components-catalog.md` | Per-component required/optional props + real examples (all 54) |
| `knowledge/config-layer/how-filters-work.md` | Any filter ticket — the end-to-end filter mechanism + display-alias gap (confirmed in darwin source) |
| `knowledge/config-layer/README.md` | Index to the config-layer training curriculum source |
| `knowledge/backend/darwin-primer.md` | Backend (darwin) questions: pivot execution/ordering, `aggregationSQLs` vs `reverseAggSQLs` (drill-level SQL, root-first vs leaf-first, mutually exclusive), why `bottomLevels` is dead config, filter option assembly, config caching, member resolution, the agents package |
| `knowledge/backend/ann-add-to-assortment.md` | Understanding the ann/KWG `add_to_assortment()` PG procedure — the "materialize a cart into the plan" pipeline: its goal, the A–J chunks, every step's why/output, the forward-feeding chain, where SUP-3879 sat, plus a reusable method for reading big dynamic-SQL procedures |

## Per-customer facts

| File | Use when |
|---|---|
| `customers/<CLIENT>/profile.md` | Start of any ticket — that client's repos, envs, quirks |
| `customers/<CLIENT>/repos.json` | **Per-client** repos only (ETL + config) + branch |
| `knowledge/platform-repos.json` | **Shared** repos (frontend `assortmentui`, backend `darwin`) — one instance for ALL clients |
| `customers/<CLIENT>/db/README.md` | DB questions — PG trigger/function map (hidden business logic) |
| `customers/<CLIENT>/db/postgres_schema.sql` | Exact PG DDL/triggers/functions/views (grep it) |
| `customers/<CLIENT>/db/connections.json` | (gitignored) live read-only DB access config for the db MCP |
| `customers/TRD/weekly-product-master-lineage.md` | TRD product-master pipeline (worked example of ETL lineage) |
| `customers/BOD/db/bd_ma_stylecolorchannelattributes.sql` | Boden lifecycle triggers + functions (QA = Bonus/Staging, 2026-09-29) — the only copy of this DDL anywhere; diff other envs against it. Any "MD/Exit/Debut week reverts / won't save" ticket |
| `customers/LP/hindsighting-build-log.md` | **Why each step** of the LP Hindsighting ETL+config build — learning-oriented, cross-client grounded, grows per session. Read when working any LP AP/hindsighting step or learning the inbound→landing→staging→model→PG/CH pipeline generally |
| `customers/<CLIENT>/captured-knowledge.md` | Facts users dropped during tickets (newest first, provenance-stamped by `learn.py`) — check before asking; promote durable ones into profile.md |
| `knowledge/captured-knowledge.md` | Same, but platform-wide (not client-specific) |

Known customers: TRD (deepest), EE (Evereve — note: JIRA tag `EE`, but
repos/app/table-prefix use `eve`/`evereve`, see customers/EE/profile.md
naming note), BELK, AEO, BOD (Boden — JIRA tag `[BD]`, table prefix `bd`;
Staging = Upgrade = "Bonus"; profile + db/README from SUP-3857, no full
schema dump yet), KW, TB, EXP, LP (Lilly Pulitzer — MFP in
prod, Hindsighting/AP build in progress; repos.json + build log so far, no
profile.md/db/ yet). Adding one = a new `customers/<CLIENT>/` folder
(profile + repos.json, optionally db/) — **check both the JIRA tag and any
app-level short name before creating a new folder**, they can differ (EE).

## Tools (run in Claude Code / Cowork with the hub folder)

| Tool | Use when |
|---|---|
| lineage MCP (`.mcp.json` → `tooling/lineage/mcp_server.py`) | "what breaks if I change X", upstream/downstream, blast radius. **Reads the UNIFIED graph** (file→ETL→pivot temp→pivot→model→screen) for `LINEAGE_CLIENT` (default TRD) |
| `tooling/lineage/query.py` | Same, as CLI: `find/upstream/downstream/impact/path/stats`. Also reaches pivot temps + screens now |
| `tooling/lineage/regen.sh <CID> <etl> <config>` | Rebuild ALL graphs for a customer end-to-end (extract→merge→pivot→unified→sqlite) |
| `tooling/lineage-viz/` (web tool) | Human visual explorer — 3 scopes (ETL / Pivot / End-to-End), expand-pivot. `cd tooling/lineage-viz && python3 server.py`. NOT how the agent uses lineage (that's the MCP) |
| db read-only MCP (`.mcp.json` → `tooling/db/mcp_server.py`) | Run SELECT/SHOW against a customer's QA Vertica/PG/CH over SSH. PG via that endpoint is admin-proxied — prefer Vertica; CH pending infra |
| clickhouse-docs MCP (`.mcp.json` → `https://clickhouse.com/docs/mcp`) | Look up ClickHouse SQL/functions/engines/settings from official docs when composing or debugging CH queries. Docs-only (no DB). **Caveat:** docs reflect current CH; for 21.4-specific truth, confirm with `tooling/validation/ch_validate.py` version+capability probe |
| `tooling/lineage/diff.py` | PR data-impact report (edge diff between two graphs) |
| `tooling/metrics/rollup.py` + `server.py` | **ADMIN** — copilot utilization/quality/knowledge dashboard from `state.json` + notes + learning logs. `./run.sh` → :8771 |
| `tooling/triage/` | **Deterministic triage engine** — the backbone that shrinks the LLM's trust surface. See `tooling/triage/README.md`. |
| `tooling/triage/route.py` | Classify a ticket from text → type/component/env (each with a source). Seeds `state.json`. |
| `tooling/triage/newticket.sh` | Spin up `tickets/<ID>/`: clone right repo+branch, OCI sync, ticket branch, seed state.json |
| `tooling/triage/confidence.py` | Deterministic 0-100 confidence + band from a ticket state; the band gates behavior |
| `tooling/triage/evidence-matrix.md` | `(type × component) → required evidence + exact commands` lookup |
| `tooling/triage/trace.py` | State → reasoning/debug trace, or `--note` → solution-note draft |
| `tooling/triage/learn.py` | Persist a user-given fact with provenance (`captured-knowledge.md`) |
| `tooling/triage/MODES.md` | **Assistance modes** (tutor/pair/autopilot) — solve the ticket AND keep the human sharp; what changes per stage |
| `tooling/triage/confidence.py --predict` | Calibration: predict the score before revealing; logs your delta over time |
| `tooling/learning/flashcards.py` | Spaced-repetition recall built from every ticket's `knowledge_gained` (build/due/show/grade) |
| `tooling/learning/skill_ledger.py` | Track authored-vs-accepted per skill; flags erosion (`log`, `report`, `streak`) |

Lineage graphs live under `customers/<CID>/lineage/` (single source; see
`tooling/lineage/README.md`). Generated JSON/DB are gitignored — rebuild
with `regen.sh`.

## Runbooks — how to get evidence / do a task

| File | Use when |
|---|---|
| `knowledge/runbooks/fetch-live-config.md` | Lower-env config issue — sync OCI live config + diff vs git (drift) |
| `knowledge/runbooks/db-schema-snapshot.md` | Refresh PG/CH/Vertica schema dumps (also DB drift detection) |
| `knowledge/runbooks/create-readonly-accounts.md` | Stand up read-only DB users for a new env (incl. CH 21.4 gotchas) |
| `knowledge/runbooks/local-ui-setup.md` | Reproduce a frontend bug locally (Vite proxy to a client env) |
| `knowledge/runbooks/ui-repro.md` | Reproduce/verify a UI issue (Chrome interactive + Playwright regression) |
| `knowledge/runbooks/capture-prompt.md` | Capture knowledge from another Claude chat into a solution note |
| `knowledge/runbooks/exp-sftp-cyclic-recovery.md` | EXP cyclic `@here failed cyclic` — partner SFTP delivery failure (reset/timeout to sftp.inside-express.com) — hold cron, notify partner, re-push queued files |
| `knowledge/runbooks/claude-project-setup.md` | Set up the copilot as a claude.ai Project (away-from-repo use) |

## Memory — past solutions

| File | Use when |
|---|---|
| `knowledge/notes/SUP-*.md` | ALWAYS search first (grep symptom/component/table words). Lead with prior art |
| `knowledge/notes/PROD-<CLIENT>-<YYYYMMDD>-*.md` | Same — prod batch/data incidents worked without a filed JIRA ticket (common: caught via log/monitoring before a ticket exists). If a ticket gets filed later, rename to `SUP-####.md` and update this row |

Notable notes: SUP-3857 (BOD relaunch MD Wk reverts — Postgres
`md_trigger_on_update` WHEN lock `old.erlstmkdnwk < old.plan_current` undoes
the edit at save; QA hand-fixed, triggers not in git → env drift; stale
"Staging" server trap; Done, Prod trigger check open), SUP-4210 (viewdefn `_r`/`_u` formula typo + AEO subsidiary
replication), SUP-4230 (Belk on-order id-mapping dedup), SUP-4254
(carriage-return in upload → split export → products vanish), SUP-4311
(text-column enhancement, ordinal-load gotcha), SUP-4378 (Belk ST%/FP
ST%/WOH/FP WOH — confirmed formula set, agnostic `tot_avail_inv_u`,
weekcount `countIf(...strcntwk>0)` + grouped-rollup `max` not `sum`,
Life-To-Date style pane architecture, pivotdefn filename-vs-`id=` routing),
bd mfpapsync lock-race, SUP-4738 (TB `V_MemberBasedValidValues` converted to
a real constant table — `mappings/*.csv` + `vertica/0N_load_*.sql` pattern;
follow-through on SUP-3061; open casing/CH-scope questions noted),
PROD-EE-20260809 (EE/Evereve new-store onboarding missing backtest backfill
→ non-nullable NULL insert in `600_18_AllocAdjEve.sql`), PROD-TRD-20260813
(Torrid duplicate MERGE key — new stylecolor sent without S5_ID, backfilled
next day, raw-code identity collides with real UUID identity).

## Skills (`.claude/skills/`)

| Skill | Covers |
|---|---|
| `triage-ticket` | Workflow stages 1–5 (intake dialogue → root-cause gate) |
| `validate-fix` | Stages 6–7 (validation plan + gate) |
| `ticket-retro` | Stage 8 (solution note → memory) |
| `impact-analysis` | Lineage-backed blast-radius answers |

---
*Reflex: on any ticket, (1) profile → (2) search notes → (3) route via
system-map → (4) pull the layer's platform doc above → (5) tools for
evidence. Add a row here whenever you create a knowledge file.*
