---
client: BOD
name: Boden
status: active
---

# BOD (Boden): customer profile

**Naming note:** the JIRA summary tag is **`[BD]`**, the hub folder is
`BOD`, and the tenant/table prefix is **`bd`** (`bd_ma_stylecolorchannelattributes`,
`bd_serviceparams`, `bd_PlanMeta`). Some tickets are split out of joint
**Boden/KWG** tickets.

## Repos (see repos.json for exact branches)

| Layer | Repo | Branch | Note |
|---|---|---|---|
| ETL | `s5-stratos/etl-bod-batch` | `etl-prod-2025` | main prod branch (confirmed 2026-08-07) |
| Config | `s5-stratos/boden-configs` | `main` | local `../boden-configs`. Env sync branches exist (`boden_upgrade`, `autosync/s5-qa`, `11.13.2025_fromQA`/`_fromUpg`). CI files there are stale leftovers that reference `tb-configs-v2` |
| Frontend | `s5-stratos/assortmentui` | (shared) | not cloned locally: `git clone --depth 1 git@github.com:s5-stratos/assortmentui.git` |
| Backend | `s5-stratos/darwin` | (shared, `dev`) | same: shallow clone over SSH |
| Postgres triggers/functions | **none, not in git** | n/a | snapshot: `db/bd_ma_stylecolorchannelattributes.sql`. `boden-configs/schema/citus_schema.sql` is a stale 2018 TB template; ignore it |

## Environments

| Env | App URL | Config source | Postgres |
|---|---|---|---|
| **QA** | https://asst.qa.bd.s5stratos.com/ (also https://qa.boden.oci.s5stratos.com/) | OCI bucket `internal-qa-config`, prefix `bd/` | QA `bd` |
| **Staging / Upgrade = "Bonus"** | https://upgrade.boden.s5stratos.com/ | OCI staging bucket not yet identified | the **Bonus** server, which is the app's live DB |
| **Prod** | (not recorded) | (not recorded) | (not recorded) |

"Staging", "Upgrade" and "Bonus" (Boden Bonus) are **the same environment**.

**⚠ Stale-server trap (SUP-3857):** `172.16.80.198:5432 / db bd` looks like
Boden Staging but is an old copy that the app doesn't use. Its
`bd_serviceparams` has plan_current 2025-W20 and plan_end 2026-W32, and the
attribute table's last write was 2025-06-19. Before trusting any "Staging"
dump, check `bd_serviceparams.plan_current` against the week shown in the
UI, and check that `max(updated_at)` on `bd_ma_stylecolorchannelattributes`
is recent (queries: `tickets/SUP-3857/diagnostic-queries.sql` §1).

**Comparison point:** tickets often say "see **Express Staging** for expected
behaviour", so `../express-configs` is the usual diff target.

## Where things live (confirmed in darwin/config during SUP-3857)

- **Lifecycle weeks** (Debut `dbt_wk`, Relaunch `relaunchweek`, MD
  `erlstmkdnwk`, Exit `exitdate`) are read from **Postgres**
  `bd_ma_stylecolorchannelattributes`, with one row per (product, location).
  - Style Edit uses `/api/assortment/style/lifecycleParams` →
    `AttributeOperation.getAttributesByOwner`.
  - Grid `attribute:` columns use `AttributePostProcessor` (pgDataSource).
- **UI current week and range** come from Postgres `bd_serviceparams`
  (`plan_current`, `plan_end`), via `AssortmentHelper.getRange` and
  `ScopeDataController.getDateContext`. The plan engine reads it through
  ClickHouse `bd_PlanMeta`.
- **Row-level `plan_current`** is stamped on each attribute row. The
  lifecycle triggers compare against it.
- **ClickHouse `bd_ma_stylecolorchannelattributes`** is **append-only history**.
  It gets backend sync inserts (`SyncTableOperation`) and replan write-back
  (`FlowSheetPlanPivot.pivotdefn:11705`). Readers take the latest version with
  `order by updated_at desc limit 1 by product, location`.
- **Item lists come from ClickHouse pivots.** Style Edit's list is built from
  `bd_temp_flow_status_prep` (via `AssortmentFitStyleZeros`), which the replan
  writes, so it shows styles only after they've been replanned.
- **Hierarchy:** in `bd_h_prodstd`, `ancestor0` = style and `ancestor3` =
  department. Names are in `bd_d_product`.
- **Lifecycle edits on published items** queue outbound interface **15.5**
  (`sync_outbound_dataqueue`, from `update_week_indxes()`).
- **Multi-currency ticket prices:** GBP1, GBP2, USD, EUR1, EUR2, AUD
  (`ccticketpricechannel_base_*` / `_override_*`). There is a ticket-price
  lock (`ticketprice_locked`) in QA and Bonus.

## Known quirks

- **Lifecycle business rules are Postgres triggers**, and they drift between
  environments. See `db/README.md`.
- **"In MD"** means `erlstmkdnwk < plan_current AND exitdate >= plan_current`,
  using the row's own `plan_current`. The week picker disables passed weeks,
  so on an in-MD item only Exit is editable in the Debut/MD/Exit row. Use the
  Relaunch row to move MD.
- **Wks at FP / Initial Intake Wk** are counted from Debut, not Relaunch
  (`AssortmentLinePlanLifecycleTab.viewdefn:43,:70`). Express behaves the
  same way.
- **No Boden DB access in the hub's db MCP yet.** Queries are run by hand
  and pasted in.

## Tickets

- SUP-3857: relaunch MD Wk reverts. Cause: a Postgres trigger lock. Done
  2026-09-29. See `knowledge/notes/SUP-3857.md`.

## Jira

Project SUP; summary tag `[BD]`. Reporters and approvers seen so far:
Olga Gervits, Jatin Rana. QA tester: Suhel Rehman.
