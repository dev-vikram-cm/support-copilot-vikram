#!/usr/bin/env python3
"""
Search the knowledge full-text index — ranked, CITED passages.

Returns file › section + a highlighted snippet + a relevance rank, so the agent
finds the right knowledge among many files and can cite it. This is a FIND aid:
the agent still opens and cites the real file; search just points the way.

Usage:
  python3 tooling/knowledge/search.py "count mismatch across screens"
  python3 tooling/knowledge/search.py "flow status" --area lms --k 5
  python3 tooling/knowledge/search.py "trd_p_history_agg" --client TRD
"""
import argparse, json, re, sqlite3, sys
from pathlib import Path

HUB = Path(__file__).resolve().parent.parent.parent
DEFAULT_DB = HUB / "knowledge" / "knowledge_fts.db"


def _fts_query(q: str) -> str:
    """Make a forgiving FTS5 query: OR the terms, quote odd tokens. Falls back to
    a phrase if the raw query errors."""
    terms = re.findall(r"[A-Za-z0-9_]+", q)
    if not terms:
        return '""'
    return " OR ".join(f'"{t}"' for t in terms)


def search(query, k=8, area=None, client=None, db=None):
    dbp = Path(db) if db else DEFAULT_DB
    if not dbp.exists():
        raise FileNotFoundError(f"index not built: {dbp} — run index_build.py")
    con = sqlite3.connect(f"file:{dbp}?mode=ro", uri=True)
    con.row_factory = sqlite3.Row
    where = ["docs MATCH ?"]
    params = [_fts_query(query)]
    if area:
        where.append("area = ?"); params.append(area)
    if client:
        where.append("client = ?"); params.append(client)
    sql = (f"SELECT area, client, path, section, "
           f"snippet(docs, 4, '»', '«', ' … ', 14) AS snip, bm25(docs) AS rank "
           f"FROM docs WHERE {' AND '.join(where)} ORDER BY rank LIMIT ?")
    params.append(k)
    try:
        rows = con.execute(sql, params).fetchall()
    except sqlite3.OperationalError:
        # fallback: exact phrase
        params[0] = '"' + query.replace('"', "") + '"'
        rows = con.execute(sql, params).fetchall()
    con.close()
    return [dict(r) for r in rows]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("query")
    ap.add_argument("--k", type=int, default=8)
    ap.add_argument("--area")
    ap.add_argument("--client")
    ap.add_argument("--db")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    res = search(a.query, a.k, a.area, a.client, a.db)
    if a.json:
        print(json.dumps(res, indent=1)); return
    if not res:
        print("no matches."); return
    for r in res:
        tag = r["area"] + (f"/{r['client']}" if r["client"] else "")
        print(f"[{tag}] {r['path']}"
              + (f"  ›  {r['section']}" if r['section'] else ""))
        print(f"    {r['snip'].strip()}\n")


if __name__ == "__main__":
    main()
