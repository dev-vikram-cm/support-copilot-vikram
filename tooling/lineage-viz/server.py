#!/usr/bin/env python3
"""
ETL Lineage Visualization Tool — FastAPI backend (localhost).

    pip install fastapi uvicorn
    python3 server.py            # -> http://127.0.0.1:8000

Serves the single-page UI (static/index.html) and a small JSON API backed by the
per-customer lineage.db. Read-only; regeneration is a separate step
(load_sqlite.py + classify_loadmode.py).
"""
from __future__ import annotations

import json
from pathlib import Path
from typing import Optional

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

import graph_service as gs
import unified_service as us

ROOT = Path(__file__).parent
REGISTRY = ROOT / "registry" / "customers.json"


def unified_db_for(c: dict) -> str:
    """Path to the customer's unified (ETL+config+pivot) DB. Falls back to a
    convention next to the ETL graph_db."""
    p = c.get("unified_db") or str(Path(c["graph_db"]).with_name("unified_" + c["id"].lower() + ".db"))
    full = (ROOT / p).resolve()
    if not full.exists():
        raise HTTPException(503, f"unified DB missing for {c['id']} — "
                                 f"run unified_load.py (see Pivot proposal §7b)")
    return str(full)

app = FastAPI(title="ETL Lineage Tool")


def load_registry() -> dict:
    return json.loads(REGISTRY.read_text())


def customer(cid: str) -> dict:
    for c in load_registry()["customers"]:
        if c["id"] == cid:
            return c
    raise HTTPException(404, f"unknown customer {cid}")


def db_for(c: dict) -> str:
    p = (ROOT / c["graph_db"]).resolve()
    if not p.exists():
        raise HTTPException(503, f"lineage.db missing for {c['id']} — build it first")
    return str(p)


def graph_db_or_none(c: dict):
    """ETL view DB, or None if not built yet — lets ETL-scope endpoints degrade
    gracefully (empty) instead of 503, so Pivot/End-to-End still work."""
    p = (ROOT / c["graph_db"]).resolve()
    return str(p) if p.exists() else None


@app.get("/api/customers")
def customers():
    return [{"id": c["id"], "name": c["name"], "engines": c.get("engines", []),
             "batches": list(c.get("batches", {}).keys())}
            for c in load_registry()["customers"]]


@app.get("/api/customers/{cid}/batches")
def batches(cid: str):
    db = graph_db_or_none(customer(cid))
    if not db:                      # ETL view DB not built — degrade to empty
        return []
    with gs.connect_ro(db) as con:
        return gs.list_batches(con)


@app.get("/api/customers/{cid}/tables")
def tables(cid: str, batch: Optional[str] = None):
    db = graph_db_or_none(customer(cid))
    if not db:                      # ETL view DB not built — degrade to empty
        return []
    with gs.connect_ro(db) as con:
        return gs.list_tables(con, batch)


@app.get("/api/customers/{cid}/lineage")
def lineage(cid: str, table: str, direction: str = "upstream",
            depth: str = "1", batch: Optional[str] = None):
    d = "full" if depth == "full" else int(depth)
    with gs.connect_ro(db_for(customer(cid))) as con:
        out = gs.subgraph(con, table, direction, d, batch)
    if "error" in out:
        raise HTTPException(404, out["error"])
    return out


@app.get("/api/customers/{cid}/unified/search")
def unified_search(cid: str, q: str, scope: str = "e2e"):
    with us.connect_ro(unified_db_for(customer(cid))) as con:
        return us.search(con, q, scope)


@app.get("/api/customers/{cid}/unified/nodes")
def unified_nodes(cid: str, kind: str):
    """Default dropdown list per scope: pivot scope -> kind=pivot;
    e2e -> kind=screen."""
    with us.connect_ro(unified_db_for(customer(cid))) as con:
        return us.list_nodes(con, kind)


@app.get("/api/customers/{cid}/unified/lineage")
def unified_lineage(cid: str, node: str, direction: str = "upstream",
                    depth: str = "1", scope: str = "e2e", expand: str = ""):
    """Scope-aware lineage: scope ∈ {etl,pivot,e2e}. In e2e, `expand` is a
    comma-separated list of pivot ids to reveal their internal temp DAGs."""
    d = "full" if depth == "full" else int(depth)
    exp = {e for e in expand.split(",") if e}
    with us.connect_ro(unified_db_for(customer(cid))) as con:
        out = us.subgraph(con, node, direction, d, scope=scope, expand=exp)
    if "error" in out:
        raise HTTPException(404, out["error"])
    return out


@app.get("/api/customers/{cid}/batch-scripts")
def batch_scripts(cid: str, batch: str):
    with gs.connect_ro(db_for(customer(cid))) as con:
        out = gs.batch_scripts(con, batch)
    if "error" in out:
        raise HTTPException(404, out["error"])
    return out


@app.get("/api/customers/{cid}/staleness")
def stale(cid: str):
    c = customer(cid)
    repo = (ROOT / c["clone_path"]).resolve()
    with gs.connect_ro(db_for(c)) as con:
        return gs.staleness(con, repo)


@app.get("/")
def index():
    return FileResponse(ROOT / "static" / "index.html")


app.mount("/static", StaticFiles(directory=ROOT / "static"), name="static")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
