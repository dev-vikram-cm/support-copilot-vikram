#!/usr/bin/env python3
"""
Read-only SQL guard — the SINGLE source of truth that decides whether a
statement may run. FAIL-CLOSED: anything that is not unambiguously ONE
read-only statement is refused.

Every execution path in the tool routes through `check_sql()`:
  - Postgres / Vertica over SSH  -> mcp_server.tool_query
  - ClickHouse over HTTP         -> validation/compare.run + ch_validate

so the tool can NEVER execute anything but a single SELECT-family statement,
on ANY engine, no matter how the SQL was produced.

This is defense-in-depth ON TOP of a real read-only DB account
(`s5_copilot_ro`, superuser off, no INSERT/UPDATE grants). Even if a caller is
buggy or hostile, nothing here lets a write / DDL / DCL / transaction / session
/ admin statement through. Do NOT loosen it to allow writes.

Design:
  1. Strip comments and string/quoted-identifier literals first, so keyword and
     statement-separator checks cannot be fooled by data or by comment
     smuggling (`SELECT 1 /* ; DROP ... */`). An unterminated quote/comment —
     a classic bypass trick — is itself a rejection.
  2. The remaining "code" must START with an allowed read verb (allowlist).
  3. It must contain no statement separator `;` (multiple statements) beyond a
     single optional trailing one.
  4. It must contain no forbidden verb as a whole word.
  5. The ORIGINAL text (comments + string data intact) is what executes — only
     the analysis runs on the stripped form, which is sound because comments
     and string literals are inert to the database.
"""
import re


class SqlNotAllowed(ValueError):
    """Raised when a statement is not a permitted read-only query."""


# A read-only statement MUST begin with one of these (after comment stripping).
_ALLOWED_START = re.compile(r"^(select|with|show|explain|describe|desc)\b", re.I)

# Whole-word verbs that must NEVER appear in a read-only statement. Covers
# Postgres + ClickHouse + Vertica write / DDL / DCL / transaction / session /
# admin surface.
#
# Deliberately EXCLUDED to avoid false positives on legitimate read queries or
# real schema identifiers:
#   - `cluster`  : a real dimension column (WHERE cluster IN (...)).
#   - `end`      : CASE ... END.
#   - `analyze`  : EXPLAIN ANALYZE <select> is read-only; a bare ANALYSE/ANALYZE
#                  statement is blocked by the leading-verb allowlist anyway.
#   - `settings` : ClickHouse `SELECT ... SETTINGS x=1` (note: bare `set` IS
#                  forbidden; `\bset\b` does not match "settings"/"offset"/etc).
_FORBIDDEN = re.compile(
    r"""\b(
        insert|update|delete|merge|upsert|replace|
        truncate|drop|alter|create|rename|
        grant|revoke|
        copy|load|unload|export|import|outfile|infile|
        attach|detach|optimize|move|exchange|freeze|unfreeze|mutate|
        system|kill|shutdown|
        call|do|perform|
        prepare|deallocate|declare|cursor|
        begin|commit|rollback|savepoint|
        lock|unlock|
        vacuum|reindex|refresh|checkpoint|discard|reset|
        listen|notify|
        into|set|use
    )\b""",
    re.I | re.X,
)

MAX_LEN = 200_000


def _strip_comments_and_literals(sql: str) -> str:
    """Return `sql` with comments and string/quoted-identifier literals removed
    (replaced by a single space). Raises SqlNotAllowed on an unterminated
    comment or string literal."""
    out = []
    i, n = 0, len(sql)
    while i < n:
        two = sql[i:i + 2]
        if two == "--":                       # line comment -> end of line
            j = sql.find("\n", i)
            i = n if j < 0 else j
            continue
        if two == "/*":                       # block comment
            j = sql.find("*/", i + 2)
            if j < 0:
                raise SqlNotAllowed("unterminated block comment")
            i = j + 2
            continue
        c = sql[i]
        if c in "'\"`":                        # string or quoted identifier
            q = c
            j = i + 1
            while j < n:
                cj = sql[j]
                if cj == q:
                    if j + 1 < n and sql[j + 1] == q:   # doubled escape '' "" ``
                        j += 2
                        continue
                    break
                if cj == "\\" and q == "'":            # backslash escape (CH/MySQL strings)
                    j += 2
                    continue
                j += 1
            if j >= n:
                raise SqlNotAllowed("unterminated string literal")
            out.append(" ")
            i = j + 1
            continue
        out.append(c)
        i += 1
    return "".join(out)


def check_sql(sql: str) -> str:
    """Validate `sql` as a single read-only statement. Return the cleaned
    statement (trailing ';' and surrounding whitespace removed) ready to run.
    Raise SqlNotAllowed otherwise."""
    if not isinstance(sql, str) or not sql.strip():
        raise SqlNotAllowed("empty query")
    if "\x00" in sql:
        raise SqlNotAllowed("null byte in query")
    if len(sql) > MAX_LEN:
        raise SqlNotAllowed(f"query exceeds {MAX_LEN} chars")

    code = _strip_comments_and_literals(sql).strip()
    if not code:
        raise SqlNotAllowed("query has no executable statement (comments only)")

    # allow exactly one optional trailing ';'
    core = code[:-1].rstrip() if code.endswith(";") else code
    if ";" in core:
        raise SqlNotAllowed("multiple statements are not allowed")

    if not _ALLOWED_START.match(core):
        raise SqlNotAllowed("only SELECT / WITH / SHOW / EXPLAIN / DESCRIBE are allowed")

    m = _FORBIDDEN.search(core)
    if m:
        raise SqlNotAllowed(f"forbidden keyword: {m.group(1).lower()}")

    return sql.strip().rstrip(";").strip()


def is_readonly(sql: str) -> bool:
    """Non-raising convenience wrapper."""
    try:
        check_sql(sql)
        return True
    except SqlNotAllowed:
        return False


if __name__ == "__main__":  # tiny CLI: exit 0 if read-only, 1 if not
    import sys
    q = sys.stdin.read() if len(sys.argv) < 2 else sys.argv[1]
    try:
        check_sql(q)
        print("OK: read-only")
    except SqlNotAllowed as e:
        print(f"BLOCKED: {e}")
        sys.exit(1)
