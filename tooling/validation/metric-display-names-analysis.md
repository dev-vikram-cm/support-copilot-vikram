# Display-name metrics + searchable scope pickers — deep analysis & options

Three asks:
1. **Searchable** scope pickers (product / location / time / …).
2. **Sorted** dropdown values.
3. **Display-name metrics**: show the user the *view* names ("U Sls", "R$ Sales",
   "FGM %") — not raw pivot columns — and compose the query using the **view's
   formula** over the pivot values, with a human alias.

(1) and (2) are small, independent UI wins. (3) is the deep one; most of this
doc is about it, grounded in the `assortmentui` (frontend), `darwin`, and
`trd-configs` code.

---

## 1 & 2 — Searchable + sorted scope pickers (quick wins)

- **Sort**: the member queries already `ORDER BY name`; just make the UI sort
  option text too (locale-aware) so it's stable regardless of DB collation.
- **Search**: each scope is a `<select multiple>`. Add a one-line filter box
  above each that hides non-matching `<option>`s (client-side, case-insensitive
  substring), or switch to a lightweight typeahead. No backend change — the
  members are already loaded. For the big lists (weeks ~965, stylecolor ~5000)
  the filter box is essential; add a small "showing N of M" hint.

Effort: ~half a day, no schema/API changes. Can ship independently of (3).

---

## 3 — Display-name metrics from view files

### 3.1 What a "metric the user sees" actually is

A `*.viewdefn`'s `view[]` is a list of **columns**; each column is the user-facing
metric. Real example (`HistoryRollUp.viewdefn`):

| text (display) | dataIndex | formula | renderer |
|---|---|---|---|
| Count | cccount | `sum(1)` | thousand |
| R$ Sales | net_sls_r | `sum(net_sls_r)` | usMoneyRounded |
| Unit Sales | net_sls_u | `sum(shp_u) - sum(ret_u)` | thousand |
| FGM % | net_sls_margin_pct | `(sum(net_sls_r) - sum(net_sls_c)) / sum(net_sls_r)` | percent |
| Funded APS | funded_aps_u | `(sum(funded_shp_u) - sum(funded_ret_u))/ sum(...)` | twoDecimal |
| Unit EOP | last_value_eoh_u | `sum(last_value_eoh_u)` | thousand |
| Unit Avg EOP WOH | stk_sls_u | `(sum(sum_eoh_u)) / (sum(shp_u) - sum(ret_u))` | oneDecimal |

So a metric = **`text`** (label) + **`formula`** (how it's computed) +
**`renderer`** (format) + `dataIndex` (its output key) + `xtype`.

### 3.2 How the app evaluates `formula` (from assortmentui)

`utils/Pivot/RollUp.ts` → `evaluateFormula()` in `utils/LibraryUtils/MathUtils.tsx`:

- The formula is a **mathjs** expression. Each identifier (`shp_u`, `net_sls_r`)
  resolves to an **array of one value per pivot leaf row**; aggregate functions
  reduce the array: `sum`, `mean`(=`avg`), `size`(=`count`), `first`, `last`,
  `min`, `max`, plus `default(v, d)` for invalid numbers and date helpers
  (`s5week`, `weeks`, `days`).
- `sum(1)` is compat-rewritten to `sum(size(__DATA))` → **row count**.
- If `xtype === "unique"`, the rows are `uniqBy(id)`-deduped **before** the
  rollup — this is the fix for the `sum(1)`-counts-rows bug (**SUP-4202**).
- A per-column `fallbackKey` (= the column's `dataIndex`) is used when an
  identifier isn't numeric on a row.

Implication: to reproduce a displayed number we must apply the **same formula**
over the **same base columns**, at the **same grain** — not our own guessed
aggregation. The formula is the source of truth.

### 3.3 The catch: TWO derivation layers

The formula's base columns are **not all physical**. Checking
`customers/TRD/db/clickhouse_schema.sql` for the agg table `trd_p_history_agg`:

- **Physical agg columns**: `shp_u`, `ret_u`, `eoh_u`, `boh_u`, `dmd_u`, …
- **NOT on the agg** (pivot-derived): `net_sls_r`, `net_sls_u`, `net_sls_c`,
  `last_value_eoh_u`, `sum_eoh_u`, `funded_shp_u/ret_u/aps_u`, `cccount`,
  `net_sls_margin_pct`, `stk_sls_u`, …

Those derived columns are produced **inside the pivot SQL** (FreeMarker
templated), e.g. from `trd-configs/pivot/…`:

    (shp_r - ret_r)                as net_sls_r
    (count(distinct stylecolor) as Float32) as cccount
    …windowed argMax expression…   as last_value_eoh_u
    0                              as net_sls_u      -- (branch when disabled)

So the real chain is **three levels**:

    raw agg cols ──(pivot SQL derivations)──▶ derived cols ──(view formula rollup)──▶ displayed number

Our composer targets the agg view and **bypasses the pivot temp-tables by
design** — which is correct for an independent oracle, but it means for a
derived-column metric we must **re-derive** the pivot column ourselves (from raw
agg cols) before the view formula can roll it up. Two of these are easy
(`net_sls_r = shp_r - ret_r`), some are point-in-time (`last_value_eoh_u =
argMax(eoh_u, time)`), `cccount = count(distinct stylecolor)`, and several are
**branch-dependent** (a FreeMarker `<#if>` emits `0 as net_sls_u` in some
configs) — so the derivation is per-pivot, not global.

### 3.4 The formula → ClickHouse translation

mathjs → CH is mostly 1:1 because both wrap columns in aggregates and the
arithmetic syntax is identical:

| formula | ClickHouse | notes |
|---|---|---|
| `sum(x)` | `sum(x)` | |
| `mean(x)` / `avg(x)` | `avg(x)` | |
| `count(x)` / `size(x)` | `count()` | rows; `count(DISTINCT id)` if `xtype=unique` |
| `sum(1)` | `count()` (or `count(DISTINCT id)`) | SUP-4202 |
| `first(x)` | `argMin(x, time)` | needs an order key (time) |
| `last(x)` | `argMax(x, time)` | " |
| `min(x)`/`max(x)` | `min(x)`/`max(x)` | |
| `default(v, d)` | `ifNull(nullIf(v,'nan'), d)` / `if(isFinite(v),v,d)` | |
| `a / b`, `a - b`, `(…)` | identical | ratios: guard `/0` → CH returns nan/inf; render as the app does |

The alias is the column `text` (quoted): `… AS "FGM %"`. The `renderer`
(percent / usMoneyRounded / thousand / twoDecimal) tells the **compare
tolerance / formatting**, not the SQL.

### 3.5 Where the metric list comes from (per screen)

The resolved screen (route_resolver / confdefn `defns`) names a **model**, and
the model's `defns.view[]` names the viewdefns. The **rollUp/summary** view
(`type: "rollUp"`, e.g. `HistoryRollUp`) holds the aggregate metrics the user
reads as totals; the **grid** view holds per-row columns. So the metric picker
should list the **rollUp view's** columns for total-validation (and optionally
the grid columns for per-row).

---

## Options

### Option A — Direct view-formula (physical columns only)
Translate the view formula → CH, but only for metrics whose base columns are
**physical** on the agg (`shp_u`, `ret_u`, `eoh_u`, `boh_u`, `dmd_u` → so "Unit
Sales", raw EOH/BOH work). Derived-column metrics (net_sls_*, funded_*, WOH,
FGM%) emit a `-- needs pivot derivation` TODO.
- **Fidelity**: exact for direct metrics; honest TODO for the rest.
- **Effort**: low (formula translator + view parse). No pivot-derivation work.
- **Use**: ships display names + correct composition for the simple ~1/3 of
  metrics immediately.

### Option B — Two-layer (pivot derivations + view formula) — full fidelity
Also extract each pivot's **column derivations** (raw → derived) from the pivot
SQL/FTL and inline them, so the query is self-contained on the agg table and
reproduces *any* metric.
- **Fidelity**: highest — matches the screen for derived metrics too.
- **Effort**: high. The FTL is templated + branchy + has point-in-time
  windowing; extraction must resolve the config branch actually used and the
  ordering key. Some derivations won't statically resolve → still TODO.
- **Risk**: silently wrong if we pick the wrong FTL branch — must validate by
  executing vs the UI (needs the read-only CH we deferred).

### Option C — Catalog-driven, phased hybrid (recommended)
Extend `build_catalog.py` to store, per (view, column): `text, dataIndex,
formula, renderer, xtype`, and per (pivot, derived-col): the derivation
expression it can extract (marking the rest `unresolved`). Then:
- **Phase 1** (UX + easy fidelity): metric picker lists **view `text`**; compose
  translates the formula for metrics whose bases are physical or have a
  statically-extracted derivation; everything else shows the name with a
  `-- derivation not resolved (see pivot)` note. Ship 1 & 2 (search/sort) here.
- **Phase 2** (fidelity): grow the pivot-derivation extractor (net_* deltas,
  cccount, funded_*), add first/last ordering + XTYPE_UNIQUE → `count(DISTINCT)`.
- **Phase 3** (trust): once read-only CH lands, auto-execute the composed metric
  and diff vs a captured UI value per (pivot, metric) — turning "resolved" into
  "verified", and flagging any derivation that doesn't reconcile.
- **Fidelity**: grows monotonically; never fabricates — unresolved = labeled.
- **Effort**: incremental; fits the existing catalog/compose architecture.

### Recommendation
**Option C.** It delivers the display-name UX and the searchable/sorted pickers
immediately (Phase 1), composes the true formula wherever we can ground it, and
is explicit about what it can't yet derive — consistent with the composer's
"unknown stays a TODO, never guessed" principle. Phase 3 closes the loop once
the read-only ClickHouse account exists.

---

## Catalog additions (Option C)

    view_metrics(view, text, data_index, formula, renderer, xtype, view_type)
    pivot_derivations(pivot, derived_col, expr, resolved BOOL, note)

Compose then: pick metric by `text` → view formula → substitute any derived-col
with its `pivot_derivations.expr` (or emit TODO) → translate mathjs→CH → alias
as `text`. `renderer` drives compare tolerance.

## Correctness caveats to keep visible
- **Branch-dependent derivations**: the FTL `<#if>` config flags change a
  column's SQL; the catalog must record which branch (per pivot) or mark
  unresolved.
- **Point-in-time**: `first/last`/`last_value_*`/`sum_eoh_*` depend on the row
  order key (`time`) and the pivot grain (`bottomLevels`). Wrong grain → wrong
  stock number (SUP-4202 class).
- **Ratios**: division-by-zero renders as the app's renderer would (nan/inf) —
  compare must treat those like the UI, not as a mismatch.
- **XTYPE_UNIQUE**: `count`/`sum(1)` must become `count(DISTINCT id)` when the
  column is unique-typed, else counts inflate.

## Test strategy
- Formula translator unit tests (mathjs subset → CH) incl. `sum(1)`, ratios,
  first/last, default.
- Golden tests: for a few (view, column) pairs, assert the composed SQL matches
  a hand-verified expected string (using the real viewdefns).
- Phase 3: execute-and-compare against captured UI numbers per metric.
