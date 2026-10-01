# Knowledge search (FTS5) — reliable recall across the prose knowledge

As the knowledge base grows (LMS courses, solution notes, captured facts,
runbooks, per-customer profiles), a hand-curated `INDEX.md` + grep stops
covering the long tail. This adds **full-text search** so the copilot reliably
finds the right passage among many files — and cites it.

**Why FTS5, not a vector DB (yet):** deterministic, explainable (BM25 — you can
see *why* it matched), zero infra (built into Python's `sqlite3`), offline,
rebuilds in seconds, and best-in-class for the exact tokens that dominate our
corpus (table/pivot/config names, ticket ids). Add embeddings later *only if*
the retrieval eval set shows FTS is missing semantic queries — then go hybrid.

## Pieces

| File | Role |
|---|---|
| `index_build.py` | Chunk every knowledge `.md` by section → SQLite FTS5 index (`knowledge/knowledge_fts.db`), with `area` + `client` facets. |
| `search.py` | Ranked BM25 search → cited passages (`area/client · file › section` + snippet). CLI + importable `search()`. |
| `mcp_server.py` | Exposes `knowledge_search` as an MCP tool (registered in `.mcp.json`) so the agent, Cowork, and the JIRA agent all get it. |

## Use

    # build/refresh the index (real disk; rebuild after knowledge changes)
    python3 tooling/knowledge/index_build.py            # -> knowledge/knowledge_fts.db

    # search (CLI)
    python3 tooling/knowledge/search.py "counts don't match between screens"
    python3 tooling/knowledge/search.py "flow status" --area lms --k 5
    python3 tooling/knowledge/search.py "trd_p_history_agg" --client TRD

The agent calls `knowledge_search(query, k, area?, client?)` via MCP. It's a
**find aid**: results point to the file › section; the agent still opens and
cites the real file. The index is gitignored (regenerable) — each clone builds
it locally, and it covers new solution notes / captured facts the moment they're
committed and re-indexed.

## Facets (`area`)

`lms` · `domain` · `solution-note` · `note` · `runbook` · `config-layer` ·
`backend` · `playbook` · `customer` · `knowledge` · `root`. Plus `client`
(e.g. `TRD`) for per-customer files.

## Roadmap (climb only as evals justify)

1. Retrieval **eval set** (question → expected source) + coverage lint —
   measures whether FTS+INDEX actually misses anything.
2. If it does: bolt on a local embedding store for **hybrid** (BM25 + vectors)
   — same `knowledge_search` interface, structured knowledge stays exact-key.
