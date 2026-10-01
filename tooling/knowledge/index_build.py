#!/usr/bin/env python3
"""
Build the knowledge full-text index (SQLite FTS5).

Why FTS5 (not vectors, yet): deterministic, explainable, zero infra (built into
Python's sqlite3), offline, rebuilds in seconds, and best-in-class for the exact
tokens that dominate our corpus (table/pivot/config names, ticket ids). It gives
the agent reliable recall across all the .md knowledge — including the growing
solution notes, captured facts, LMS courses, and customer profiles — so nothing
is lost just because it's spread across many files.

Chunks each .md by section (heading breadcrumb) so results cite file › section.
Facets: `area` (which part of the brain) and `client` (from customers/<CID>/).

Usage:
  python3 tooling/knowledge/index_build.py                 # -> knowledge/knowledge_fts.db
  python3 tooling/knowledge/index_build.py --db /tmp/k.db  # custom path (real disk needed)
"""
import argparse, re, sqlite3, sys
from pathlib import Path

HUB = Path(__file__).resolve().parent.parent.parent

# what to index: prose knowledge + per-customer facts (NOT the structured graph/catalog)
INCLUDE_GLOBS = [
    "knowledge/**/*.md",
    "customers/*/*.md",
    "customers/*/**/*.md",
    "WELCOME.md", "AGENT.md",
]
EXCLUDE_PARTS = {"node_modules", "__pycache__", ".git"}


def area_of(rel: str) -> str:
    p = rel.replace("\\", "/")
    if p.startswith("knowledge/domain/lms"): return "lms"
    if p.startswith("knowledge/domain"): return "domain"
    if p.startswith("knowledge/solutions"): return "solution-note"
    if p.startswith("knowledge/notes"): return "note"
    if p.startswith("knowledge/runbooks"): return "runbook"
    if p.startswith("knowledge/config-layer"): return "config-layer"
    if p.startswith("knowledge/backend"): return "backend"
    if p.startswith("knowledge/playbooks"): return "playbook"
    if p.startswith("customers/"): return "customer"
    if p.startswith("knowledge/"): return "knowledge"
    return "root"


def client_of(rel: str) -> str:
    m = re.match(r"customers/([^/]+)/", rel.replace("\\", "/"))
    return m.group(1) if m else ""


def chunk_md(text: str):
    """Yield (section_breadcrumb, body) per heading section. Splits big sections."""
    stack = {1: "", 2: "", 3: ""}
    cur_lines, cur_crumb = [], ""
    def crumb():
        return " › ".join(x for x in (stack[1], stack[2], stack[3]) if x)
    def flush(out):
        body = "\n".join(cur_lines).strip()
        if body:
            out.append((cur_crumb or crumb(), body))
    out = []
    for line in text.splitlines():
        m = re.match(r"^(#{1,3})\s+(.*)", line)
        if m:
            flush(out)
            cur_lines = []
            lvl = len(m.group(1)); title = m.group(2).strip()
            stack[lvl] = title
            for deeper in range(lvl + 1, 4):
                stack[deeper] = ""
            cur_crumb = crumb()
        else:
            cur_lines.append(line)
    flush(out)
    # split any oversized section (~2k chars) into windows so results stay snippet-able
    final = []
    for crumb_, body in out:
        if len(body) <= 2400:
            final.append((crumb_, body))
        else:
            for i in range(0, len(body), 2000):
                final.append((crumb_, body[i:i + 2000]))
    return final


def collect_files():
    seen = set()
    for g in INCLUDE_GLOBS:
        for p in HUB.glob(g):
            if not p.is_file():
                continue
            if any(part in EXCLUDE_PARTS for part in p.parts):
                continue
            if p not in seen:
                seen.add(p)
    return sorted(seen)


def build(db_path: Path):
    if db_path.exists():
        db_path.unlink()
    con = sqlite3.connect(db_path)
    con.execute("CREATE VIRTUAL TABLE docs USING fts5("
                "area UNINDEXED, client UNINDEXED, path UNINDEXED, section, body, "
                "tokenize='porter unicode61');")
    n_files = n_chunks = 0
    for f in collect_files():
        rel = str(f.relative_to(HUB))
        try:
            text = f.read_text(errors="replace")
        except Exception:
            continue
        n_files += 1
        for section, body in chunk_md(text):
            con.execute("INSERT INTO docs(area,client,path,section,body) VALUES (?,?,?,?,?)",
                        (area_of(rel), client_of(rel), rel, section, body))
            n_chunks += 1
    con.commit()
    con.execute("INSERT INTO docs(docs) VALUES('optimize')")
    con.commit()
    con.close()
    print(f"indexed {n_files} files -> {n_chunks} chunks -> {db_path}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=str(HUB / "knowledge" / "knowledge_fts.db"))
    a = ap.parse_args()
    build(Path(a.db))


if __name__ == "__main__":
    main()
