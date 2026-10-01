# TRD — DB connections & read-only posture

`connections.json` (gitignored) holds the per-env commands the DB layer
(`tooling/db/mcp_server.py` → `tool_query`) runs over SSH to reach the client's
databases. This note records **which account actually runs our queries** and why
the Postgres command is wired the way it is — it was not obvious, and getting it
wrong silently ran everything as an admin account.

## TL;DR

- Postgres reads run **directly against the PG server (`172.16.231.92:5432`) as
  `s5_copilot_ro`** — a genuine, DB-enforced read-only role.
- Do **not** point Postgres at `127.0.0.1` on `qa-processor`. That is an admin
  proxy: it collapses every connection to the superuser-ish app account `psql`
  regardless of the `-U` you pass. (`current_user` came back `psql`, not the
  read-only role, through that path.)
- Vertica still connects as `s5_copilot_ro` via the `vsql` wrapper.
- The app-level `check_sql()` guard (SELECT/WITH/SHOW/EXPLAIN/DESCRIBE only) is
  now **defense-in-depth on top of real DB permissions**, not the only thing
  preventing a write.

## The security finding (why the direct path matters)

`qa-processor` has a `psql` **wrapper** on `PATH` that:
1. requires `CLIENT` to be set (`export CLIENT=trd`), and
2. appends its own connection string —
   `host=172.16.231.92 dbname=trd user=psql password=<admin pw>` — to the
   command line.

Connecting via the local proxy (`-h 127.0.0.1`) authenticated upstream as the
admin `psql` account **even when we asked for `-U s5_copilot_ro`**. So the
"read-only" connection was read-only in name only; the sole real protection was
the application's `check_sql()`.

Connecting **directly** to `172.16.231.92` with the real `/usr/bin/psql` and
explicit `-h/-U/-d` options makes the wrapper's injected conninfo land in an
extra positional slot that psql **ignores** (`psql: warning: extra command-line
argument "…" ignored`), so our `-U s5_copilot_ro` wins and we authenticate as the
read-only role for real.

Verified on the direct path:

    current_user   = s5_copilot_ro     (session_user too — proxy bypassed)
    is_superuser   = off
    can SELECT     = yes  (349 table grants; all dimension/hierarchy tables)
    can INSERT     = no
    can UPDATE     = no

## Grants that make `s5_copilot_ro` usable (run once, as table owner / admin)

The role existed but had **no** table grants, so a direct connection could
authenticate yet read nothing. Applied on `trd`:

```sql
GRANT USAGE ON SCHEMA public TO s5_copilot_ro;                 -- (USAGE on public is default; may warn, harmless)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO s5_copilot_ro;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO s5_copilot_ro;  -- future tables
```

If new schemas/tables appear and reads start failing with permission errors,
re-run the `GRANT SELECT ON ALL TABLES` (and add the schema to
`ALTER DEFAULT PRIVILEGES`).

## The Postgres command (current)

```
CLIENT=trd PGPASSWORD='<s5_copilot_ro pw>' /usr/bin/psql \
  -h 172.16.231.92 -p 5432 -U s5_copilot_ro -d trd -X -A -F'\t' -c {SQL}
```

- `CLIENT=trd` — required by the wrapper's env check even though `/usr/bin/psql`
  itself doesn't need it; harmless to keep and keeps behaviour identical if the
  bare `psql` is ever used.
- `/usr/bin/psql` — the real binary, **not** the wrapper, so no conninfo is
  injected.
- `-h 172.16.231.92` — direct to the PG server, bypassing the `127.0.0.1` proxy.
- `-X -A -F'\t'` — no psqlrc, unaligned, tab-separated (parsed by
  `members.py::_parse_tsv`, which always drops the first line as the header).

## Verify after any change

```bash
# raw (what connections.json runs), from a host on the VPN:
ssh -o RemoteCommand=none -T qa-processor \
  "CLIENT=trd PGPASSWORD='<pw>' /usr/bin/psql -h 172.16.231.92 -p 5432 -U s5_copilot_ro -d trd -X -A -F$'\t' \
   -c \"SELECT current_user, current_setting('is_superuser')\""
# expect: s5_copilot_ro | off

# end-to-end through the tool:
cd tooling/validation && python3 members.py --client TRD --kind department --refresh
```

## Read-only enforcement in code (defense-in-depth)

DB permissions are now the primary guarantee (see above), but the tool also
refuses to *send* anything but a single read-only statement, on **every**
engine. One guard is the single source of truth:

- `tooling/db/readonly_guard.py :: check_sql()` — **fail-closed**. It strips
  comments and string literals first (so a keyword or `;` hidden in a comment or
  string can't fool it, and an unterminated quote/comment is itself a
  rejection), then requires the statement to **start** with
  `SELECT/WITH/SHOW/EXPLAIN/DESCRIBE`, allows no second statement, and rejects
  any write/DDL/DCL/transaction/session/admin verb
  (`insert update delete merge drop alter create grant revoke copy into set use
  system kill attach optimize …`). It deliberately does *not* trip on the real
  `cluster` column, `CASE … END`, `OFFSET`, or `SETTINGS`.

Every execution path routes through it:

| Path | Engine | Enforced at |
|---|---|---|
| `mcp_server.tool_query` | Postgres / Vertica (SSH) | `check_sql()` before the SSH call |
| `ch_validate.ch_post`   | ClickHouse (HTTP)        | `check_sql()` on **every** POST (probes, EXPLAIN, runs) |
| `compare.run`           | ClickHouse               | `check_sql()` on the composed body before LIMIT/FORMAT |

Tests: `python3 tooling/db/test_readonly_guard.py` (33 blocked / 20 allowed).
**Never loosen `check_sql()` to permit writes** — it is the second layer under
the read-only account, not a substitute for it.

## Verifying which account the composer uses

The Studio shows a 🔒 badge of the live DB account and its read-only status
(`/api/whoami` → `members.whoami()` → `mcp_server.probe_identity()`), so it is
explicit that details, scope expansion, and execution all run via
`s5_copilot_ro`. From the CLI:

```bash
cd tooling/validation && python3 members.py --client TRD --whoami
# -> {"accounts": {"postgres": {"user": "s5_copilot_ro", "is_superuser": false,
#                               "read_only": true}, ...}}
```

A `read_only: false` (writable) account turns the badge red — treat that as a
misconfiguration to fix before trusting the tool.

## Open follow-ups

- **Rotate the admin `psql` password.** It is printed in cleartext in the
  wrapper's `extra command-line argument … ignored` warning (and thus in shell
  history / logs) on every invocation.
- Keep `check_sql()` strict — it is now a second layer, not the only one. Never
  loosen it to allow writes.
