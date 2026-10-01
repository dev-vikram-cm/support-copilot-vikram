# SUP-4628 — Assortment view rollout checklist

Metrics for THIS ticket: **FP ST%** (all 10 groups), **FP WOH + WOH** (groups 1-5 only;
6-10 are "ST metrics only"). Plus: update existing **ST%** so its inventory denominator
is price-status agnostic.

Confirmed formula set (from SUP-4378, Nicole-approved 2026-09-01), mapped to Belk
Assortment field names (no `tot_` prefix here — the bare fields ARE the totals; FP is
the `fp_`-prefixed parallel family):

```
avail_inv_u  = last_value_eoh_u + last_value_eoh_intransit_u + (shp_u - ret_u)   -- already exists in most pivots
sell_thru_pct = (shp_u - ret_u) / avail_inv_u          -- FIX: today's denom omits intransit
fp_st_pct     = fp_net_sls_u    / avail_inv_u          -- FIX/ADD: today fp uses fp_last_value_eoh_u (FP-only) — the SUP-4378 bug
woh           = avail_inv_u / ((shp_u - ret_u) / weekcount)
fp_woh        = avail_inv_u / (fp_net_sls_u      / weekcount)
weekcount     = max( count(distinct time) )            -- Assortment weekcount is PLAIN (no strcntwk>0, no prodlife) — simpler than Hindsighting; rollup already max()
```

Divide-by-zero: wrap in `CASE WHEN <denom> > 0 THEN round(...,4) ELSE 0 END` (matches
every sibling metric).

Wrench order (this ticket — NOT the SUP-4378 consecutive block):
- **FP ST%** immediately after **ST%**
- **FP WOH** immediately before **BOH U**
- **WOH** immediately after **FP WOH**

Paths relative to `belk-configs/`. Edit clone: `/Users/vigneshn/Desktop/JIRAs/SUP-4628/belk-configs/` (branch `SUP-4628`).

## Per-pivot audit (verified 2026-09-02 against belk-configs@assortment-planning / SUP-4628 branch)

| # | View group | Pivot | `avail_inv_u` present | current `sell_thru_pct` | FP raw family | `fp_sell_thru_pct` | woh/fp_woh | rollup wk | Effort | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| 1,2,3 | Summary / Grid / Flow Type (StyleColor) | `AssortmentFit` | ✅ `:2616` | OLD, no intransit `:2623` | ✅ full `BASE_SUM_FP_SALES/INV_METRICS` param family | **BUG** `:2658` (`fp_last_value_eoh_u` denom) | ❌ add both | `max` ✅ | **LOW** | **PIVOT DONE — committed 613d2c6, pushed to origin/SUP-4628.** Wrench DONE (not committed) — see below. |
| 4 | Top TY vs LY (StyleColor) | `AssortmentFitTYLY` | ✅ `:1380` (now `ttl_eoh_u`-derived) | OLD `:1387` | ❌ none pre-existing | ❌ none pre-existing | ❌ | `max` ✅ | **HIGH** — build FP family | **PIVOT DONE — same in-place design as AssortmentFit, extended to build the FP family from scratch (this pivot had none) since 3 CREATE TABLEs (TY/LY/LLY) all reuse `params.BASE_SUM_SALES_METRICS`, inlined the sumIf list into all 3 + deleted the dead param; `COMPUTED_METRICS`/`key`-tag mechanism (`'TY'`/`'LY'`/`'LLY'`) is shared, so one edit covers all 3 years. File uses CRLF line endings — preserved.** Wrench DONE (not committed) — see below.
| 5 | TY/LY Grid View Tabs | `AssortmentFitTYLYTranspose` | ✅ `ty_`/`ly_` `:1763/:1970` | ✅ already agnostic `:1772` (but duplicate alias — see note) | ❌ none pre-existing | ❌ none pre-existing | ❌ | `max(weekcount_x)`; `sum(avail_inv_u)` at transpose | **HIGH** — FP family + ty/ly transpose dup | **PIVOT DONE — heaviest pivot yet.** Two-year mechanic (`ty_`/`ly_`-prefixed columns in ONE row, not row-tagged): edited 2 SALES `CREATE TABLE`s (TY+LY, both reuse one param), 6 zero-fill blocks, **3** union blocks (`_TY`/`_LY`/`_TYLY` — `_TY` real+`_LY` zero, `_LY` zero+real, `_TYLY` re-sums both), **and** a 4th layer unique to this pivot — `params.COLUMNS_FINAL`, a full re-aggregation read from `BASE_ATTR_AGG_FINAL` that mirrors every `COMPUTED_METRICS` column via `sum()`; anything added to `COMPUTED_METRICS` and left out of `COLUMNS_FINAL` is silently dropped before reaching the frontend. Caught mid-edit: a duplicate `ty_sell_thru_pct`/`ly_sell_thru_pct` alias (forgot to delete the OLD formula before adding the new one, unlike the first two pivots) — fixed before validating. Also caught after review: 3 union blocks (`_TY`/`_LY`/`_TYLY`) initially had new columns lumped together instead of split into their own ty_/ly_ sections (file convention), and `woh`/`fp_woh` (here + the other two pivots) were missing a `weekcount > 0` guard — both fixed. Wrench DONE (not committed) — see below.

### Wrench (viewdefn) edits — items 1,2,3,4,5 — done 2026-09-14

Confdefn-verified file mapping (both perspectives share the same view list in every case — only `showPopover`/`fabType` differ, so one file covers bottom-up + top-down):

| Item | Viewdefn edited | Type | Edit |
|---|---|---|---|
| 1 | `AssortmentBuildStyleColorSummaryDetails.viewdefn` | flat card | added `fp_sell_thru_pct` after `sell_thru_pct`; added `fp_woh`/`woh` before `ttl_boh_u` |
| 2 | `AssortmentBuildStyleColorGridViewGrid.viewdefn` | formula grid | fixed stale client-side `sell_thru_pct` formula (`sum(shp_u-ret_u)/sum(last_value_eoh_u+...)` → `sum(tot_net_sls_u)/sum(tot_avail_inv_u)`); added `fp_sell_thru_pct` formula after it; added `fp_woh`/`woh` formulas (`sum(tot_avail_inv_u)/(sum(fp_net_sls_u or tot_net_sls_u)/max(tot_weekcount))`) before `ttl_boh_u` |
| 3 | `AssortmentBuildStyleColorFlowTypeDetails.viewdefn` | flat card | same as item 1 |
| 4 | `AssortmentBuildStyleColorTopTYLYDetails.viewdefn` | flat card | same as item 1 (this pivot row-tags TY/LY via a `key` column, unprefixed dataIndex — same as Hindsighting's TYLY, not ty_/ly_ prefixed) |
| 5 | `AssortmentBuildStyleColorTYLYGrid.viewdefn` | formula grid, ty_/ly_ pair | fixed stale `ty_sell_thru_pct`/`ly_sell_thru_pct` formulas to the agnostic `ty_tot_net_sls_u`/`ty_tot_avail_inv_u` (and ly_) base; added `ty_fp_sell_thru_pct`/`ly_fp_sell_thru_pct` after their ST% column; added `ty_fp_woh`/`ty_woh`/`ly_fp_woh`/`ly_woh` — this file has **no "BOH U" column at all**, so placed right after `Avail Inv C` (the closest analogous inventory-metric position) instead of the ticket's literal "before BOH U" anchor |

All 5 files validated `json.load`-clean, zero duplicate `dataIndex`, correct column counts. Renderers/format matched to the shipped SUP-4378 History wrench template (`percentOneDecimal` for the two %, `oneDecimal` for WOH/FP WOH), with `fp_sell_thru_pct` as the dataIndex (not History's `fp_st_pct` — matches this pivot family's own pre-existing naming). Rollup viewdefns (`AssortmentBuildStyleColorReviewRollUp.viewdefn`, `AssortmentBuildStyleColorTYLYGridRollup.viewdefn`) and the `*GridViewList`/`*TYLYGridList` companion views checked — confirmed no ST%/WOH fields exist there to touch (rollups stay lean at 6 metrics, matching SUP-4378 precedent; list views are trivial id/name pickers). Not committed.

**ORDER CHANGE 2026-09-14 (user updated JIRA requirement):** wrench order for this ticket is now the SUP-4378-style **consecutive block** — `ST % → FP ST % → FP WOH → WOH` immediately together, right after ST%, *not* split with FP WOH/WOH placed before BOH U as the ticket originally specified (that original instruction explicitly said NOT to reuse the Hindsighting consecutive-block pattern — the user has since revised the JIRA description to require it after all). Re-ordered all 5 files accordingly:
- 3 flat-card views (Summary/FlowType/TopTYLY): `sell_thru_pct → fp_sell_thru_pct → fp_woh → woh → avail_inv_c → ...`
- `AssortmentBuildStyleColorGridViewGrid.viewdefn`: `sell_thru_pct → fp_sell_thru_pct → fp_woh → woh → stk_sls_u → ...`
- `AssortmentBuildStyleColorTYLYGrid.viewdefn`: same block for both the `ty_` and `ly_` column families independently.
Re-validated after reordering: JSON-clean, zero duplicate `dataIndex` on all 5.
| 6 | Cat Summary Tabs — ST only | `AssortmentAggregateViewsNestedAttribute_for_CatRecap` | ✅ TY only originally; now real for **all 3 years** — see note | OLD `:1198` (fixed) | ✅ added via Approach A | ✅ added, real TY/LY/LLY | n/a | `sum(weekcount)` `:728` — pre-existing, irrelevant to ST-only | **HIGH — reclassified from MED, ended up the largest edit in the ticket** | **PIVOT DONE.** `id="mother_of_All_Pivots"` — the exact bespoke family SUP-4378 broke on with in-place `sumIf`. Used **Approach A** (separate unfiltered table) per user's explicit call, after user caught that `TY/LY/LLY_BASE_LAST_INV_METRICS` *also* filters `prodlife` here (unlike `AssortmentFit`, where inventory was already agnostic) — so both sales AND inventory needed the agnostic treatment. 8-layer edit: (1) new scope-var-free `params.BASE_SUM_SALES_METRICS_AGNOSTIC` (8 cols: `tot_`/`fp_` sales); (2) 3 new `CREATE TABLE ..._AGNOSTIC` (TY/LY/LLY), each adding 2 more cols inline (`tot_last_value_eoh_u`/`_intransit_u`, scope-var-dependent so kept out of the param) — **per the user's direction, built real (not zero-filled) agnostic inventory for LY/LLY too**, resolving what was flagged as a known limitation; (3) zero-filled the 10 new cols in the 6 pre-existing base tables; (4) added the 3 new tables as a 7th `UNION ALL` branch in `TY/LY/LLY_ALL_BASE`; (5) threaded the 10 cols through `PRE_BASE_METRICS_UNION`/`BASE_METRICS_UNION`/`BASE_METRICS_UNION_ZERO`/`BASE_METRICS_UNION_INSTK_COUNT`; (6) `COMPUTED_METRICS` — fixed `sell_thru_pct`, added `fp_sell_thru_pct`; (7) `TY_COMBO_ALL`/`LY_COMBO_ALL`/`LLY_COMBO_ALL` — each casts its own year's `fp_sell_thru_pct` real, zero-fills the other two (mirrors the pre-existing `sell_thru_pct` pattern exactly); (8) `FINAL_ALL_WITHOUT_VAR` — `SUM(...)` re-aggregation exposing `fp_sell_thru_pct`/`ly_fp_sell_thru_pct`/`lly_fp_sell_thru_pct`. **Caught and fixed mid-edit:** first draft of the new AGNOSTIC table only carried 10 columns vs the other 6 base tables' 97 — would have silently corrupted the positional `UNION ALL` for every existing metric in this pivot; rebuilt with the full 87-zero-fill + 10-real shape and verified column-order match. Not committed.

**Item 6 wrench — done 2026-09-14.** `AssortmentAnalysisCatRecapCatSummaryGrid.viewdefn` (Detail, 3-year ACT/LY/LLY column groups) and `AssortmentAnalysisCatRecapCatSummaryGrid_quick.viewdefn` (Quick, 2-year ACT/LY only — no LLY group in Quick, matches this file's own existing convention). Both use a **grouped-header format**: a "ST %" parent column with ACT/LY/LLY (or ACT/LY) sub-columns bound to `sell_thru_pct`/`ly_sell_thru_pct`/`lly_sell_thru_pct` — added a parallel "FP ST %" group, same sub-column shape, bound to `fp_sell_thru_pct`/`ly_fp_sell_thru_pct`/`lly_fp_sell_thru_pct`, inserted right after the "ST %" group (before "Stk Sls U") per the consecutive-block order. No WOH/FP WOH here — item 6 is ST-only. Both files JSON-valid, `dataIndex` uniqueness confirmed. Not committed.
| 7 | Nested Attr Tabs — ST only | `AssortmentAggregateViewsNestedAttribute` | same as 6 | OLD `:1198` | ❌ none | ❌ none | n/a | `sum` | **MED** | not started |
| 8 | Nested View Tabs — ST only + FP ST% Rating | `AssortmentAnalysisGrid` | ✅ `:1182` | OLD `:1189` | ❌ none | ❌ none | n/a | `max` ✅ | **HIGH** — FP family + parallel `fp_sell_thru_pct_band` composite block (`:1614` weights 0.5/0.3/0.2, `:1734` band→color) + "FP ST% Rating" column + re-point existing ST% rating | not started |
| 9 | Nested Over Time — ST only (FP ST% col already present) | `NestedOverTime` | ❌ uses `eoh_u + net_sls_u` | n/a — only `avail_sell_thru_pct` `:32` | ❌ none | **broken**: `AssortmentBuildNestedOvertime.viewdefn:39-40` "FP ST %" → `dataIndex sell_thru_pct` (no such field) | n/a | n/a | **MED** — add `fp_avail_sell_thru_pct` mirroring existing shape; re-point the broken column | not started — **H4 decision needed** |
| 10 | Style Color over Time — ST only | `NestedStyleOverTime` | ❌ uses `eoh_u` | OLD `:507` + `:549` (2 layers) | ❌ none | ❌ none | n/a | n/a | **MED** — lighter pivot, 2 layers | not started |
| — | Style Pane (not a named item — H5) | `StyleChannelReview` | ✅ `:2975` | — | has fp (per SUP-4378) | **BUG** `~:2985` (FP-only denom) | n/a | `max` ✅ | **LOW** — 1 formula fix | not started — **H5 user OK needed** |

Dead / out of scope (confirmed):
- `AssortmentFitStyle.pivotdefn`, `AssortmentFitStyleTYLY.pivotdefn`, all plain-Style viewdefns — `StyleReview` section `hidden:true` + `inPerspectives:[]` at confdefn `:773` and `:4206`.
- Top-Down for items 5 & 10 — no TD view id in confdefn (`TopTYLYGridView :4127`, `NestedStyleOvertime :7204` both `bottom-up` only). Out of scope per ticket wording ("where view exists in Top Down").

## Cost summary

- **LOW** (formula fix + add woh/fp_woh + wrench): AssortmentFit (items 1-3), StyleChannelReview.
- **MED** (FP ST% plumb, no WOH): items 6, 7, 9, 10.
- **HIGH** (build full parallel FP sales family following AssortmentFit's `BASE_SUM_FP_SALES_METRICS` pattern — filtered base table + union/agg threading): items 4, 5, 8. Item 8 also needs the composite-band clone.

## Open decisions (ask Nicole / user before FIX)

1. **Item 9 approach** — re-point "FP ST %" to a new `fp_avail_sell_thru_pct = fp_net_sls_u/(eoh_u+net_sls_u)` matching the view's existing lighter shape (recommended), or rebuild NestedOverTime onto the full agnostic `avail_inv_u` base?
2. **StyleChannelReview fp bug (H5)** — fix in this ticket or split to its own?
3. **Items 5 & 10 Top-Down** — confirm no new TD wiring expected.
4. **Items 6/7 LY & LLY FP ST%** — `ly_avail_inv_u` / `lly_avail_inv_u` are zero-filled in these pivots today, so LY/LLY FP ST% would render 0 unless real inventory is plumbed for those years. JIRA says "same logic for LY as TY... if not possible, discuss." → discuss.
