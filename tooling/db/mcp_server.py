#!/usr/bin/env python3
"""
Read-only database MCP server — queries Postgres / ClickHouse / Vertica
on remote VMs over SSH. Zero dependencies (stdlib only).

Security model:
  - Uses YOUR existing ssh keys/config (no credentials stored here).
  - Only statements starting with SELECT / WITH / SHOW / EXPLAIN /
    DESCRIBE / DESC are executed. Everything else is refused.
  - Row cap enforced (default 200) and ssh-level timeout (default 60s).
  - Every query is visible in the Claude conversation log.

Connections are defined per customer in
  customers/<CLIENT>/db/connections.json:

{
  "qa": {
    "postgres":   { "ssh": "opc@qa-app-vm",  "cmd": "psql -d torrid -X -A -F'\t'  -c {SQL}" },
    "clickhouse": { "ssh": "opc@qa-ch-vm",   "cmd": "clickhouse-client --format TabSeparatedWithNames --query {SQL}" },
    "vertica":    { "ssh": "opc@qa-vert-vm", "cmd": "vsql -A -F'\t' -c {SQL}" }
  },
  "staging": { ... }
}

`{SQL}` is replaced with the (shell-quoted) statement. `ssh` may be any
alias from your ~/.ssh/config (ProxyJump/bastion supported for free).

Tools exposed:
  db_targets()                          list configured client/env/engine
  db_query(client, env, engine, sql, max_rows=200)
"""
import json
import re
import shlex
import subprocess
import sys
from pathlib import Path

HUB = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(Path(__file__).resolve().parent))
from readonly_guard import check_sql, SqlNotAllowed  # single source of truth
SSH_TIMEOUT = 60


def connections():
    out = {}
    for f in HUB.glob("customers/*/db/connections.json"):
        client = f.parent.parent.name
        try:
            out[client] = json.loads(f.read_text())
        except Exception as e:
            out[client] = {"_error": str(e)}
    return out


def tool_targets(_args):
    lines = []
    for client, envs in connections().items():
        for env, engines in envs.items():
            if env.startswith("_"):
                continue
            for eng in engines:
                lines.append(f"{client} / {env} / {eng}")
    return "\n".join(lines) or ("no connections configured — create "
                                "customers/<CLIENT>/db/connections.json")


def tool_query(args):
    client, env, engine = args["client"], args["env"], args["engine"]
    max_rows = min(int(args.get("max_rows", 200)), 2000)
    conf = connections().get(client, {}).get(env, {}).get(engine)
    if not conf:
        return f"no connection for {client}/{env}/{engine} — call db_targets"
    sql = check_sql(args["sql"])
    # crude but effective row cap for bare SELECTs without LIMIT
    if re.match(r"^\s*select\b", sql, re.I) and not re.search(r"\blimit\s+\d+", sql, re.I):
        sql = f"{sql} LIMIT {max_rows}"
    remote_cmd = conf["cmd"].replace("{SQL}", shlex.quote(sql))
    cmd = ["ssh", "-o", "BatchMode=yes", "-o", "ConnectTimeout=10",
           # hosts with a RemoteCommand in ssh_config refuse CLI commands
           # ("Cannot execute command-line and remote command.") — override:
           "-o", "RemoteCommand=none", "-T",
           conf["ssh"], remote_cmd]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True,
                           timeout=SSH_TIMEOUT)
    except subprocess.TimeoutExpired:
        return f"error: query timed out after {SSH_TIMEOUT}s"
    if r.returncode != 0:
        return (f"error (exit {r.returncode}):\n"
                f"stderr: {r.stderr[-1500:]!r}\nstdout: {r.stdout[-1500:]!r}")
    out = r.stdout
    lines = out.splitlines()
    if len(lines) > max_rows + 5:
        out = "\n".join(lines[:max_rows + 5]) + f"\n... truncated at {max_rows} rows"
    return out or "(no rows)"


# --- read-only identity probe -------------------------------------------------
# Confirms WHICH account actually runs our queries and that it cannot write, so
# the composer/Studio can display and verify it is on the read-only account
# (s5_copilot_ro) rather than an admin proxy. Engine-appropriate, read-only SQL.
_IDENTITY_SQL = {
    "postgres":   "SELECT current_user AS db_user, "
                  "current_setting('is_superuser') AS is_superuser",
    "vertica":    "SELECT current_user AS db_user",
    "clickhouse": "SELECT currentUser() AS db_user",
}


def probe_identity(client, env, engine):
    """Return {engine, user, is_superuser, read_only, raw} for the account that
    actually authenticates on client/env/engine. Never raises — reports."""
    q = _IDENTITY_SQL.get(engine)
    if not q:
        return {"engine": engine, "error": f"no identity probe for engine '{engine}'"}
    out = tool_query({"client": client, "env": env, "engine": engine,
                      "sql": q, "max_rows": 5})
    lines = [l for l in out.splitlines()
             if l.strip() and not re.match(r"^\(\d+ rows?\)$", l.strip())]
    if not lines or out.lower().startswith(("error", "no connection")) or "denied" in out.lower():
        return {"engine": engine, "error": out.strip().splitlines()[0] if out.strip() else "no output",
                "raw": out}
    vals = (lines[1] if len(lines) > 1 else lines[0]).split("\t")
    user = vals[0].strip() if vals else None
    is_super = None
    if len(vals) > 1:
        is_super = vals[1].strip().lower() in ("on", "t", "true", "1", "yes")
    return {"engine": engine, "user": user, "is_superuser": is_super,
            # read-only is asserted only when we can prove superuser is OFF;
            # unknown (other engines) stays None -> the UI shows "unverified".
            "read_only": (is_super is False) if is_super is not None else None,
            "raw": out.strip()}


def tool_whoami(args):
    client, env = args["client"], args["env"]
    engs = list((connections().get(client, {}).get(env, {}) or {}).keys())
    if args.get("engine"):
        engs = [args["engine"]]
    return json.dumps([probe_identity(client, env, e) for e in engs], indent=1)


TOOLS = [
    {"name": "db_targets",
     "description": "List configured database connections (client/env/engine).",
     "inputSchema": {"type": "object", "properties": {}},
     "fn": tool_targets},
    {"name": "db_query",
     "description": "Run a READ-ONLY query (SELECT/SHOW/EXPLAIN/DESCRIBE) "
                    "against a customer database over SSH. Lower envs only "
                    "unless the user explicitly approves prod.",
     "inputSchema": {"type": "object",
                     "required": ["client", "env", "engine", "sql"],
                     "properties": {
                         "client": {"type": "string", "description": "e.g. TRD"},
                         "env": {"type": "string", "description": "e.g. qa"},
                         "engine": {"type": "string",
                                    "enum": ["postgres", "clickhouse", "vertica"]},
                         "sql": {"type": "string"},
                         "max_rows": {"type": "integer", "default": 200}}},
     "fn": tool_query},
    {"name": "db_whoami",
     "description": "Report which DB account actually runs our queries and "
                    "whether it is read-only (superuser off). Verifies the "
                    "read-only account is in effect, not an admin proxy.",
     "inputSchema": {"type": "object",
                     "required": ["client", "env"],
                     "properties": {
                         "client": {"type": "string"},
                         "env": {"type": "string"},
                         "engine": {"type": "string",
                                    "enum": ["postgres", "clickhouse", "vertica"]}}},
     "fn": tool_whoami},
]
TOOL_BY_NAME = {t["name"]: t for t in TOOLS}


def handle(msg):
    m = msg.get("method")
    if m == "initialize":
        return {"protocolVersion": msg["params"].get("protocolVersion",
                                                     "2024-11-05"),
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "db-readonly", "version": "1.0.0"}}
    if m == "tools/list":
        return {"tools": [{k: t[k] for k in ("name", "description",
                                             "inputSchema")} for t in TOOLS]}
    if m == "tools/call":
        t = TOOL_BY_NAME.get(msg["params"]["name"])
        if not t:
            raise ValueError(f"unknown tool {msg['params']['name']}")
        try:
            text = t["fn"](msg["params"].get("arguments") or {})
            return {"content": [{"type": "text", "text": text}],
                    "isError": False}
        except Exception as e:
            return {"content": [{"type": "text", "text": f"error: {e}"}],
                    "isError": True}
    if m == "ping":
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
        sys.stdout.write(json.dumps(resp) + "\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
