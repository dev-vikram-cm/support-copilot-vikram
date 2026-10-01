# Time & Filters — build plan (grounded in real UI logs)

Goal: give the SQL Composer a Time picker and Filter panel that mirror the S5
product UI, so a composed validation query reproduces the **exact scope** a
screen used. Everything below is derived from 15 customer log captures
(`uploads/*.txt`, ~70 MB), not assumption. Counts in parentheses are occurrences
across those logs.

---

## 1. What the logs actually show

### 1.1 The listData request (what the URL carries)

    listData?aggBy=<grain list>&appName=Assortment&defnId=<pivot|model>
            [&flowStatus=<>][&topMembers=<members>][&nestData=false]

- `aggBy` tokens come in three flavours:
  `level:stylecolor`, `level:department`, `level:class:name`,
  `attribute:class_name:name`, `attribute:subclass_name`, `custom:tgt_time`.
- `topMembers` carries the **selected scope members** — mixed dimensions in one
  comma list, e.g.
  `topMembers=DP-145,FY28_Q4` (department + quarter),
  `topMembers=DP-125,0526_Spr_4_125` (department + **floorset**),
  `topMembers=<uuid>,0526_Spr_4_125` (a stylecolor + floorset).
- `flowStatus` = `` (all, 204×), `0` (10×), also seen as `[0]` / `[]`.

**Key fact: the time *window* is NOT in the URL.** The URL may name a floorset
or quarter member, but the concrete history range is session context (next).

### 1.2 The time window = session/pivot context

Pivot invocations log their bound params, e.g.:

    $department=DP-48, $HistoryStart=2025_W26, $channel=CH-2, $HistoryEnd=2026_W17
    $department=DP-145, $HistoryStart=FY26_W48, $channel=CP-1, $HistoryEnd=FY27_W...
    $total_brand=TB-01, $HistoryStart=2025_W10, $channel=CH-2, $HistoryEnd=...

So the real scope contract is:

| Param | Meaning | Notes |
|---|---|---|
| `$HistoryStart` / `$HistoryEnd` (410 each) | history week window | **start/end week ids**, inclusive range |
| `$department` / `$total_brand` | product scope | **variable name = the level** picked (department, or total_brand=ancestor7) |
| `$channel` | location scope | `CH-2`, `CP-1` — channel members |

### 1.3 Week-id format is tenant-specific

Two coexisting formats in the data (685 distinct week ids):

- Calendar: `2025_W26`, `2026_W17` (customers on `CH-2`)
- Fiscal:  `FY26_W48`, `FY24_W31`, `FY27_W32` (customers on `CP-1`)

Both are fixed-width and lexically chronological, **but the composer must not
assume either** — it reads the actual week ids from `trd_d_time` and treats
`time` as an opaque ordered String (matches the existing CH-dialect note).

### 1.4 Two time hierarchies

- `trd_d_time` (2769×) — dimension, partitioned by `levelid`
  (`week` (37×), `month` (12×), `floorset` (4×), plus quarter/season/year).
- `trd_h_timestd` (126×) — **calendar** closure (week↔month↔quarter↔season↔year),
  `ancestor0..7` shape like `trd_h_prodstd`/`trd_h_locstd`.
- `trd_h_timeflrset` (14×) — **floorset** closure (floorset↔week) — a *separate*
  hierarchy. Floorset tokens look like `0526_Spr_4_125`, `1226_Fal_2_125`
  (`MMYY_Season_seq_dept`).

So resolving a **time selection → set of week ids** has three paths:
1. explicit week range (`HistoryStart..HistoryEnd`) → weeks ordered by `indx`
   in `trd_d_time` between the two, inclusive;
2. floorset(s) → weeks via `trd_h_timeflrset`;
3. quarter / season / month → weeks via `trd_h_timestd` (ancestor mapping).

### 1.5 The filter surface

- **Attribute filters** (via `attribute:*`): `class_name` (30×), `subclass_name`
  (20×), `cc_selected_clusters` (34×), `cc_cluster_group` (34×), `ssg` (5×),
  `img` (4×), `cccolor` (4×), `supp_brand` (2×), `cc_target_cost`,
  `relaunch_cc_cluster_group`. These are the "filters available in the UI".
- **`flowStatus`** (URL 0/1/2) is resolved by the pivot into a **session table**
  `flow_status_P<32-hex>` — i.e. it is a pivot-computed membership set
  (New / Carryover / Sell-down), **not** a plain agg column.
- **`prodlife`** (`arr_prodlife`) is a real column with string codes — observed
  `'FP'` (2211×) and `'A'` (196×), used as `AND prodlife IN ('FP')`.

**Correction to the current composer:** `flowStatus`, `prodlife`, and the
`New/Carryover/Sell-down` enum are **three different things**. Today
`compose.py` maps `flowStatus → prodlife = '<fs>'`, which is wrong on two counts
(flowStatus is session-derived, and prodlife codes are `FP`/`A`, not `0/1/2`).

---

## 2. Gap vs the current composer

| Area | Today | Needed |
|---|---|---|
| Time | `WHERE time IN (:HISTORY_WEEKS)` placeholder or a raw week list | accept a **window** (`HistoryStart..HistoryEnd`) or a **floorset/quarter/season**, resolve to concrete weeks via `trd_d_time`/`trd_h_timeflrset`/`trd_h_timestd` |
| Week format | implicitly one format | tenant-agnostic; ids read from DB |
| flowStatus | `prodlife = '<fs>'` (wrong) | separate filter; documented as session-derived (New/Carryover/Sell-down); best-effort or explicit TODO |
| prodlife | not a distinct control | real `prodlife IN (...)` filter with live codes |
| Attribute filters | only department/channel/cluster/grade | add `class`, `subclass`, `cc_cluster_group`, `ssg`, … where they map to agg columns; flag the rest |
| Scope var name | fixed `department` | honor the picked level (`department`/`total_brand`/`class`…) |

---

## 3. Build plan (phased)

### Phase A — Time & filter member providers (`members.py` + `members_queries.json`)
- Add time kinds already stubbed (`week`, `month`, `season`, `floorset`) and
  add `quarter`; list from `trd_d_time` by `levelid` (format auto-detected).
- Add **time expansions**:
  - `week_range(start,end)` → ordered weeks from `trd_d_time` (`ORDER BY indx`)
    between start and end inclusive — format-agnostic.
  - `floorset` → weeks via `trd_h_timeflrset` (confirm ancestor columns first).
  - `quarter|season|month` → weeks via `trd_h_timestd` (confirm level→ancestor).
- Add **attribute-filter providers** for `class`, `subclass`,
  `cc_cluster_group`, `ssg`, etc. (distinct values from the relevant table).
- Add a **prodlife** provider (distinct `arr_prodlife` codes + a label map).

### Phase B — `compose.py` time WHERE
- Accept a `time` selection object: one of `{weeks:[...]}`,
  `{start, end}` (range), `{floorset:[...]}`, `{quarter|season|month:[...]}`.
- Resolve to a concrete `time IN ('…','…')` (via Phase A), else keep the
  `:HISTORY_WEEKS` placeholder with a clear `-- window source` comment.
- Emit a one-line provenance comment (e.g. `-- time: floorset 0526_Spr_4_125 →
  8 weeks 2025_W26..2025_W33`).

### Phase C — `compose.py` filters (split correctly)
- `prodlife IN (...)` — real column, from the prodlife provider.
- `flowStatus` — do **not** fake it as prodlife. Emit either (a) a documented
  `-- flowStatus=<n> is pivot-derived (New/Carryover/Sell-down) via
  flow_status_<PID>; cross-check the pivot's flow criteria` note, or (b) a real
  clause only if we confirm an agg column encodes it.
- Attribute filters → `AND <col> IN (...)` when the attribute maps to an agg
  column; otherwise a `-- TODO attribute '<x>' needs a join` line (never guess).

### Phase D — UI (`ui/static/index.html`)
- **Time picker** with a mode segment: `Weeks range` (start/end selects) ·
  `Floorset` (multiselect) · `Quarter/Season` · `Explicit weeks`. Populate from
  the providers; show the resolved week count.
- **Filters**: attribute multiselects (class, subclass, cluster group, ssg…),
  a `prodlife` select, and a `flowStatus` select that surfaces the "pivot-derived"
  caveat inline.

### Phase E — Verify
- Unit tests for each time-resolution path (range/floorset/quarter) with fixture
  week ids in **both** formats.
- Replay: for a handful of `topMembers`+`HistoryStart/End` combos pulled from
  these logs, compose the query and confirm the emitted `time IN (...)` matches
  the window; where CH is reachable, execute and compare.

---

## 4. Confirmations (from `probe_time_filters.py`, round 1)

CONFIRMED against the read-only account:

- **Week range via `indx`.** `trd_d_time` weeks are contiguously ordered by
  `indx` (`2015_W27`=2, `W28`=3, …; week indx 2–966). A `HistoryStart..
  HistoryEnd` window is therefore `WHERE levelid='week' AND indx BETWEEN
  (start.indx) AND (end.indx) ORDER BY indx` — **format-agnostic** (calendar and
  fiscal tenants both). This is the primary Time resolver.
- **`trd_d_time` levels + indx bands:** floorset (4516, 10001–14516),
  superset (1508, 100001–101508), week (965, 2–966), month (222, 967–1188),
  quarter (74, 1189–1262), season (37, 1263–1299), year (19, 1300–1318),
  timerootlevel (1).
- **`trd_h_timestd` (calendar closure), month row:**
  `id | ancestor0=quarter | ancestor1=season | ancestor2=year`. So
  quarter/season/month → weeks is an ancestor match (week-row layout confirmed
  in round 2 below).
- **`prodlife` is its own PG dimension** — `trd_d_prodlife` (+ `trd_h_prodlifestd`)
  exist, so the prodlife filter is populated from **Postgres**, no ClickHouse
  needed. (The `FP`/`A` codes seen in the CH agg are these ids.)
- **`trd_h_timeflrset` does NOT contain weeks** — it maps floorset →
  season/year (`0119_Resort_121 | 19_Resort | SS_121 | 2019`). Floorset→week
  resolution lives elsewhere (round 2).
- Real tables (ignore `_bk*/_bkp*/_new*/_delete_me` copies): `trd_d_time`,
  `trd_h_timestd`, `trd_h_timeflrset`, `trd_d_prodlife`, `trd_h_prodlifestd`,
  and floorset-attribute candidates `trd_ma_dptflrsetattributes`,
  `trd_for_tgt_flrset_hier`.

CONFIRMED (round 2):
1. **`trd_d_prodlife`** members: `FP`, `MD`, `OOL` (+ `ProdLifeRoot` = root, exclude).
   name==id. Filter = `prodlife IN ('FP','MD','OOL')` on the agg's `prodlife` col.
2. **Week-row ancestors** in `trd_h_timestd`: `ancestor0=month, ancestor1=quarter,
   ancestor2=season, ancestor3=year`. So weeks-in-member is a uniform match:
   `WHERE '<member>' IN (ancestor0..3)` joined to week-level ids.
3. **Floorset → weeks = `trd_ma_dptflrsetattributes`**, keyed by `time`=floorset
   id (`0119_Resort_48`) and `product`=dept (`DP-48`). Selling window is
   `slsstart`..`slsend` (also `rcptstart/end`, `exit_week`, `markdown_week`,
   `ap_start/end`). Default floorset→weeks = **sales window (slsstart..slsend)**,
   expanded to weeks via `indx`; the window kind is configurable.
   (`trd_for_tgt_flrset_hier` is only floorset→superset/fiscal_year — not weeks.)

### Confirmed resolution SQL (all read-only, PG)

    -- week range (HistoryStart..HistoryEnd)
    SELECT id FROM trd_d_time WHERE levelid='week'
      AND indx BETWEEN (SELECT indx FROM trd_d_time WHERE id=:start AND levelid='week')
                   AND (SELECT indx FROM trd_d_time WHERE id=:end   AND levelid='week')
    ORDER BY indx;

    -- month | quarter | season | year -> weeks (uniform ancestor match)
    SELECT t.id FROM trd_h_timestd h JOIN trd_d_time t ON t.id=h.id
    WHERE t.levelid='week' AND :member IN (h.ancestor0,h.ancestor1,h.ancestor2,h.ancestor3)
    ORDER BY t.indx;

    -- floorset -> weeks (sales window), then expand via the week-range query above
    SELECT slsstart, slsend FROM trd_ma_dptflrsetattributes WHERE time=:floorset;

DESIGN DECISION (confirmed with user): `flowStatus` (New/Carryover/Sell-down) is
pivot-derived into `flow_status_<PID>`; the composer emits a documented caveat
pointing at the pivot's flow criteria rather than fabricating a column filter.

---

## 5. Why this stays deterministic

Every value in a composed `WHERE` comes from: the listData URL (scope members),
the session context (`HistoryStart/End`, `department`, `channel`), or a
read-only lookup against `trd_d_time` / the hierarchy closures. Nothing is
inferred by the model — unresolved pieces are emitted as explicit
`-- TODO/CONFIRM` lines, exactly like the rest of the composer.
