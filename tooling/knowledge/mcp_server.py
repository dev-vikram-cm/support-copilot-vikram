#!/usr/bin/env python3
"""
Knowledge search MCP server — full-text (FTS5) search over the repo's prose
knowledge, exposed as a tool any MCP client (Claude Code, Cowork, the JIRA
agent) can call. Zero dependencies (stdlib only). Registered via the repo-root
.mcp.json.

  knowledge_search   ranked, CITED passages across knowledge/, customers/, LMS,
                     solution notes, captured facts — with file › section.

A FIND aid, not the source of truth: the agent still opens and cites the real
file. Deterministic and explainable (BM25); rebuild the index with
tooling/knowledge/index_build.py when knowledge changes.

Speaks JSON-RPC over stdio (one message per line).
"""
import json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import search as ks  # noqa: E402


def tool_search(a) -> str:
    q = a.get("query", "").strip()
    if not q:
        return "provide a 'query'."
    try:
        res = ks.search(q, k=int(a.get("k", 8)),
                        area=a.get("area") or None, client=a.get("client") or None)
    except FileNotFoundError as e:
        return f"{e}"
    if not res:
        return "no matches. (try fewer/other terms, or drop area/client filters)"
    out = []
    for r in res:
        tag = r["area"] + (f"/{r['client']}" if r["client"] else "")
        head = f"[{tag}] {r['path']}" + (f"  ›  {r['section']}" if r["section"] else "")
        out.append(head + "\n    " + r["snip"].strip())
    return "\n\n".join(out)


TOOLS = [
    {"name": "knowledge_search",
     "description": "Full-text search the copilot's prose knowledge (platform "
                    "primers, config-layer/backend docs, runbooks, LMS courses, "
                    "solution notes, captured facts, per-customer profiles). "
                    "Returns ranked passages CITED as file › section. Use it to "
                    "find the right knowledge among many files before answering; "
                    "then open and cite the actual file. Optional facets: area "
                    "(lms|domain|solution-note|note|runbook|config-layer|backend|"
                    "customer|…) and client (e.g. TRD).",
     "inputSchema": {"type": "object", "required": ["query"],
                     "properties": {
                         "query": {"type": "string"},
                         "k": {"type": "integer", "description": "max results (default 8)"},
                         "area": {"type": "string"},
                         "client": {"type": "string"}}},
     "fn": tool_search},
]
TOOL_BY_NAME = {t["name"]: t for t in TOOLS}


def handle(msg):
    method = msg.get("method")
    if method == "initialize":
        return {"protocolVersion": msg["params"].get("protocolVersion", "2024-11-05"),
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "knowledge", "version": "1.0.0"}}
    if method == "tools/list":
        return {"tools": [{k: t[k] for k in ("name", "description", "inputSchema")}
                          for t in TOOLS]}
    if method == "tools/call":
        name = msg["params"]["name"]
        args = msg["params"].get("arguments") or {}
        t = TOOL_BY_NAME.get(name)
        if not t:
            raise ValueError(f"unknown tool {name}")
        try:
            return {"content": [{"type": "text", "text": t["fn"](args)}], "isError": False}
        except Exception as e:
            return {"content": [{"type": "text", "text": f"error: {e}"}], "isError": True}
    if method == "ping":
        return {}
    return None


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        if "id" not in msg:
            continue
        try:
            resp = {"jsonrpc": "2.0", "id": msg["id"], "result": handle(msg)}
        except Exception as e:
            resp = {"jsonrpc": "2.0", "id": msg["id"],
                    "error": {"code": -32603, "message": str(e)}}
        sys.stdout.write(json.dumps(resp) + "\n"); sys.stdout.flush()


if __name__ == "__main__":
    main()
