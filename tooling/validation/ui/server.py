#!/usr/bin/env python3
"""
Data Validation Studio — web UI backend.

Same shape as tooling/lineage-viz: FastAPI serving a single-page UI + a small
JSON API. Reads the validation catalog (catalog.db) and the composer to turn a
picked (screen, view, scope) into a CH-correct, consistency-annotated query.

Run locally (needs a real disk for SQLite + the config repo on disk):
  CONFIG_DIR=/path/to/trd-configs \
  CATALOG_DB=/path/to/support-copilot/customers/TRD/lineage/catalog.db \
  uvicorn server:app --port 8770 --reload
(or ./run.sh)
"""
import json, os, sqlite3, subprocess, sys
from pathlib import Path
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

ROOT = Path(__file__).resolve().parent
VALID = ROOT.parent                      # tooling/validation
sys.path.insert(0, str(VALID))
import compose as composer                # compose.compose(url, cfg, which, catalog)
import compare as cmpmod                  # execute + compare vs UI
import route_resolver as rr               # app URL -> screen/model/pivot
import view_metrics as vmet               # viewdefn label metrics -> CH exprs
import config_sync as cfgsync             # repo vs live-QA (OCI overlay) config sources
try:
    import members as members_mod          # live scope/filter members from read-only DB
except Exception:
    members_mod = None

HUB = VALID.parent.parent                # support-copilot
CONFIG_DIR = os.environ.get("CONFIG_DIR", "")
CATALOG_DB = os.environ.get(
    "CATALOG_DB", str(HUB / "customers" / "TRD" / "lineage" / "catalog.db"))
CLIENT = os.environ.get("CLIENT", "TRD")
CH_DSN = os.environ.get("CH_DSN", "")     # read-only ClickHouse DSN (server-side only)

# Config source switching: 'repo' = whatever CONFIG_DIR/CATALOG_DB you launched
# with; an env (e.g. 'qa') = the OCI-overlaid effective dir synced via config_sync.
REPO_CONFIG_DIR, REPO_CATALOG = CONFIG_DIR, CATALOG_DB
ACTIVE = {"source": "repo"}


def _build_catalog(config_dir, catalog_db):
    Path(catalog_db).parent.mkdir(parents=True, exist_ok=True)
    r = subprocess.run([sys.executable, str(VALID / "build_catalog.py"),
                        "--config-dir", str(config_dir), "--db", str(catalog_db)],
                       capture_output=True, text=True)
    return r.returncode == 0, (r.stderr or r.stdout)[-600:]

# product grain levels observed in real requests (aggBy=level:<x>)
GRAINS = ["stylecolor", "style", "class", "subclass", "department"]

app = FastAPI(title="Data Validation Studio")


def db():
    if not Path(CATALOG_DB).exists():
        raise HTTPException(500, f"catalog not found: {CATALOG_DB} — build it with "
                                 f"build_catalog.py on a real disk.")
    con = sqlite3.connect(f"file:{CATALOG_DB}?mode=ro", uri=True)
    con.row_factory = sqlite3.Row
    return con


@app.get("/api/config")
def config():
    return {"client": CLIENT, "config_dir": CONFIG_DIR,
            "catalog": CATALOG_DB, "catalog_present": Path(CATALOG_DB).exists(),
            "config_present": bool(CONFIG_DIR) and Path(CONFIG_DIR).exists(),
            "ch_available": bool(CH_DSN),   # is read-only CH wired? (creds stay server-side)
            "source": ACTIVE["source"],
            "grains": GRAINS}


@app.get("/api/modules")
def modules():
    con = db()
    rows = con.execute("SELECT tab, count(*) n FROM view_index "
                       "WHERE tab IS NOT NULL GROUP BY tab ORDER BY tab").fetchall()
    con.close()
    return [{"module": r["tab"], "views": r["n"]} for r in rows]


@app.get("/api/screens")
def screens(module: str):
    con = db()
    rows = con.execute(
        "SELECT DISTINCT screen FROM view_index WHERE tab=? AND screen IS NOT NULL "
        "ORDER BY screen", (module,)).fetchall()
    con.close()
    return [r["screen"] for r in rows]


@app.get("/api/views")
def views(module: str, screen: str):
    con = db()
    rows = con.execute(
        "SELECT vi.view, vi.model, vi.pivot, vi.base, co.verdict "
        "FROM view_index vi LEFT JOIN consistency co ON co.pivot=vi.pivot "
        "WHERE vi.tab=? AND vi.screen=? ORDER BY vi.view", (module, screen)).fetchall()
    con.close()
    return [dict(r) for r in rows]


@app.get("/api/pivot")
def pivot(pivot: str):
    con = db()
    p = con.execute("SELECT * FROM pivots WHERE pivot=?", (pivot,)).fetchone()
    c = con.execute("SELECT * FROM consistency WHERE pivot=?", (pivot,)).fetchone()
    sib = []
    if c and c["base"]:
        sib = [r["pivot"] for r in con.execute(
            "SELECT pivot FROM consistency WHERE base=? AND verdict='majority' "
            "AND pivot!=? LIMIT 8", (c["base"], pivot)).fetchall()]
    con.close()
    if not p:
        raise HTTPException(404, f"pivot not in catalog: {pivot}")
    out = dict(p)
    for k in ("grain", "metrics", "metric_aggs"):
        try: out[k] = json.loads(out[k]) if out[k] else None
        except Exception: pass
    out["consistency"] = dict(c) if c else None
    out["siblings"] = sib
    return out


def _csv(s):
    return [x.strip() for x in (s or "").split(",") if x.strip()]


def _ch_scope_subquery(scope_kind, members):
    """Build a compact CH hierarchy subquery for a scope selection, e.g.
    'SELECT stylecolor FROM trd_stylecolor_hier_attr WHERE department IN (...)'.
    Driven by members_queries.json → ch_hierarchy. Returns None if unconfigured."""
    if members_mod is None or not members:
        return None
    hq = (members_mod.QUERIES.get(CLIENT, {}) or {}).get("ch_hierarchy") or {}
    for dim, cfg in hq.items():
        if not isinstance(cfg, dict):
            continue                       # skip _readme etc.
        col = (cfg.get("scopes") or {}).get(scope_kind)
        if col:
            leaf, table = cfg["leaf"], cfg["table"]
            vcol = cfg.get("version_col")
            inlist = ", ".join("'" + str(m).replace("'", "''") + "'" for m in members)
            if vcol:
                # latest version per leaf, then filter scope on that current row
                # (mirrors the pivots: (product, updated_at) IN (…max…))
                return (f"SELECT {leaf} FROM {table} "
                        f"WHERE ({leaf}, {vcol}) IN (SELECT {leaf}, max({vcol}) FROM {table} GROUP BY {leaf}) "
                        f"AND {col} IN ({inlist})")
            return f"SELECT {leaf} FROM {table} WHERE {col} IN ({inlist})"
    return None


@app.get("/api/compose")
def compose(pivot: str, grain: str = "stylecolor", criteria: str = "hist",
            flowStatus: str = "", topMembers: str = "",
            weeks: str = "", location: str = "", cluster: str = "", department: str = "",
            channel: str = "", prodlife: str = "", metrics: str = "",
            items: str = "", itemCol: str = "product", view: str = "", labels: str = "raw",
            timeKind: str = "", timeValues: str = "", timeWindow: str = "", timeDept: str = ""):
    if not CONFIG_DIR or not Path(CONFIG_DIR).exists():
        raise HTTPException(500, "CONFIG_DIR (trd-configs) not set/found — needed to read the pivotdefn.")
    from urllib.parse import quote
    url = (f"api/pivot3/listData?aggBy=level:{quote(grain)}&appName=Assortment"
           f"&defnId={quote(pivot)}&flowStatus={quote(flowStatus)}")
    if topMembers:
        url += f"&topMembers={quote(topMembers)}"
    filters = {"weeks": _csv(weeks), "location": _csv(location), "cluster": _csv(cluster),
               "department": _csv(department), "channel": _csv(channel), "flowStatus": flowStatus,
               "prodlife": _csv(prodlife), "metrics": _csv(metrics),
               "items": _csv(items), "item_col": itemCol or "product"}
    # Time picker: resolve a selection (range/floorset/quarter/season/…) to a
    # concrete week set live via the read-only DB; falls back to explicit weeks.
    if timeKind and members_mod:
        try:
            r = members_mod.resolve_time(CLIENT, timeKind, _csv(timeValues),
                                         window=(timeWindow or None), dept=(timeDept or None))
            if r["weeks"]:
                filters["weeks"] = r["weeks"]
                filters["time_note"] = r["note"]
        except Exception as e:
            filters["time_note"] = f"time resolve failed: {e}"
    # Scope → a compact ClickHouse hierarchy SUBQUERY (department→stylecolors via
    # trd_stylecolor_hier_attr, channel→stores via trd_store_hier_attr). No giant
    # inlined IN lists, no cross-DB round-trip — all in CH alongside the agg.
    if filters["department"]:
        sq = _ch_scope_subquery("department", filters["department"])
        if sq:
            filters["product_subquery"] = sq
    if filters["channel"]:
        sq = _ch_scope_subquery("channel", filters["channel"])
        if sq:
            filters["location_subquery"] = sq
    # view-label metrics: compose the screen's named metrics (formulas → CH) so
    # the DB output matches the UI 1:1. Falls back to raw columns if the view has
    # no formula columns (e.g. a grid view) or none are groundable.
    if labels == "view" and view:
        try:
            vms = vmet.build_view_metrics(CONFIG_DIR, view)
            if vms:
                filters["view_metrics"] = vms
        except Exception:
            pass
    sql = composer.compose(url, CONFIG_DIR, criteria,
                           CATALOG_DB if Path(CATALOG_DB).exists() else None,
                           filters=filters)
    return {"pivot": pivot, "grain": grain, "criteria": criteria, "sql": sql,
            "weeks": filters.get("weeks") or [], "time_note": filters.get("time_note", "")}


@app.get("/api/execute")
def execute(pivot: str, grain: str = "stylecolor", criteria: str = "hist",
            weeks: str = "", expected: str = "{}",
            flowStatus: str = "", topMembers: str = "",
            location: str = "", cluster: str = "", department: str = "", channel: str = "",
            prodlife: str = "", metrics: str = "", items: str = "", itemCol: str = "product"):
    """Compose → run on ClickHouse → summarize → compare to UI values.
    CH_DSN lives server-side only (never sent to the browser). `weeks` is the
    already-resolved week set (the Time picker resolves range/floorset/quarter →
    weeks at compose time and passes them here)."""
    if not CH_DSN:
        raise HTTPException(400, "CH_DSN not set — a read-only ClickHouse DSN is required to execute.")
    wlist = [w.strip() for w in weeks.split(",") if w.strip()]
    if not wlist:
        raise HTTPException(400, "provide 'weeks' (comma list of week ids), or pick a Time range/floorset.")
    # compose WITHOUT inlining weeks (keep :HISTORY_WEEKS for the runner to substitute),
    # but WITH the scope filters so the executed query matches the composed one.
    sql = compose(pivot, grain, criteria, flowStatus, topMembers,
                  weeks="", location=location, cluster=cluster, department=department,
                  channel=channel, prodlife=prodlife, metrics=metrics,
                  items=items, itemCol=itemCol)["sql"]
    info = cmpmod.chv.probe_version(CH_DSN)
    if not info.get("version"):
        raise HTTPException(502, f"ClickHouse unreachable: {info.get('version_error')}")
    try:
        header, rows = cmpmod.run(sql, CH_DSN, wlist, 200000)
    except Exception as e:
        raise HTTPException(502, f"query failed on CH: {e}")
    summary = cmpmod.summarize(header, rows)
    exp = json.loads(expected or "{}")
    match, details = None, []
    if exp:
        ok, det = cmpmod.compare(summary, exp)
        match = ok
        details = [{"metric": d[0], "ui": d[1], "db": d[2], "verdict": d[3]} for d in det]
    return {"version": info["version"], "weeks": len(wlist),
            "summary": summary, "match": match, "details": details}


@app.get("/api/members/{kind}")
def members(kind: str, refresh: bool = False):
    """Live scope/filter members (department, class, location, cluster, week,
    floorset, flow_status) from the read-only DB, for the picker dropdowns."""
    if members_mod is None:
        raise HTTPException(500, "members provider unavailable")
    try:
        return members_mod.get_members(CLIENT, kind, refresh=refresh)
    except Exception as e:
        raise HTTPException(502, f"{e}")


@app.get("/api/config-sources")
def config_sources():
    """List the config sources (repo + synced envs) with freshness, and which
    one is active."""
    try:
        st = cfgsync.status(CLIENT)
    except Exception as e:
        raise HTTPException(500, f"{e}")
    st["active"] = ACTIVE["source"]
    return st


@app.post("/api/config-source")
def set_config_source(source: str):
    """Switch the active config source. 'repo' restores the launch config;
    an env (e.g. 'qa') points at its OCI-overlaid effective dir (must be synced
    first). Rebuilds that source's catalog if missing."""
    global CONFIG_DIR, CATALOG_DB
    if source == "repo":
        CONFIG_DIR, CATALOG_DB = REPO_CONFIG_DIR, REPO_CATALOG
    else:
        d = cfgsync.effective_dir(CLIENT, source)
        if not d:
            raise HTTPException(400, f"source '{source}' not synced yet — click Sync first")
        cat = str(Path(d) / "lineage" / "catalog.db")
        if not Path(cat).exists():
            ok, msg = _build_catalog(str(d), cat)
            if not ok:
                raise HTTPException(500, f"catalog build failed for {source}: {msg}")
        CONFIG_DIR, CATALOG_DB = str(d), cat
    ACTIVE["source"] = source
    return {"active": source, "config_dir": CONFIG_DIR,
            "catalog_present": Path(CATALOG_DB).exists(),
            "config_present": bool(CONFIG_DIR) and Path(CONFIG_DIR).exists()}


@app.post("/api/sync-config")
def sync_config(env: str = "qa", print_cmds: bool = False):
    """Sync a live env: git base + `oci os object sync` overlay + build effective
    (+ its catalog). Runs git/oci on the host — needs creds + VPN (your Mac)."""
    try:
        res = cfgsync.sync_env(CLIENT, env, print_cmds=print_cmds)
    except Exception as e:
        raise HTTPException(500, f"{e}")
    if res.get("ok") and not res.get("catalog_built"):
        # sync_env already builds the catalog; only build here if it didn't
        d = cfgsync.effective_dir(CLIENT, env)
        if d:
            ok, msg = _build_catalog(str(d), str(Path(d) / "lineage" / "catalog.db"))
            res["catalog_built"] = ok
            if not ok:
                res["catalog_error"] = msg
    return res


@app.get("/api/resolve-url")
def resolve_url(url: str):
    """Resolve a pasted S5 app URL to {tab(module), screen, view, pivot, model}
    by walking the confdefn pathSlots — so the UI can auto-select the screen."""
    if not CONFIG_DIR or not Path(CONFIG_DIR).exists():
        raise HTTPException(500, "CONFIG_DIR (trd-configs) not set/found.")
    cat = CATALOG_DB if Path(CATALOG_DB).exists() else None
    return rr.resolve_url(CONFIG_DIR, url, cat)


@app.get("/api/whoami")
def whoami():
    """Which DB account actually runs the composer's detail/scope + execution
    queries, and whether it is read-only. Powers the Studio's read-only badge so
    it is explicit the tool queries via s5_copilot_ro, not an admin proxy."""
    if members_mod is None:
        raise HTTPException(500, "db layer unavailable")
    try:
        return members_mod.whoami(CLIENT)
    except Exception as e:
        raise HTTPException(502, f"{e}")


@app.get("/")
def index():
    return FileResponse(ROOT / "static" / "index.html")


app.mount("/static", StaticFiles(directory=ROOT / "static"), name="static")
