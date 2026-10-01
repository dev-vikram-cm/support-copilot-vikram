#!/usr/bin/env python3
"""
Repo freshness check — is THIS support-copilot checkout up to date with the team
(git origin)? Run it before starting a ticket so you pick up the latest skills,
tooling, knowledge and fixes instead of debugging on a stale copy.

Deterministic, read-only by default: it `git fetch`es and compares your local
branch to its upstream (behind / ahead / dirty). It does NOT pull unless you
pass --pull (and it refuses to pull over uncommitted changes).

Usage:
  python3 tooling/triage/repo_sync_check.py            # check + suggest
  python3 tooling/triage/repo_sync_check.py --no-fetch  # skip network, compare cached
  python3 tooling/triage/repo_sync_check.py --pull      # fast-forward sync (opt-in)
  python3 tooling/triage/repo_sync_check.py --json

Exit code: 0 = up to date & clean; 1 = behind or dirty (suggestion printed);
2 = not a git checkout / can't determine.
"""
import argparse, json, subprocess, sys
from pathlib import Path

HUB = Path(__file__).resolve().parent.parent.parent     # support-copilot root


def git(*args, check=False):
    r = subprocess.run(["git", "-C", str(HUB), *args],
                       capture_output=True, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(r.stderr.strip() or f"git {' '.join(args)} failed")
    return r.returncode, r.stdout.strip(), r.stderr.strip()


def check(do_fetch=True):
    out = {"repo": str(HUB), "is_git": False, "branch": None, "upstream": None,
           "behind": 0, "ahead": 0, "dirty_files": 0, "fetched": False,
           "status": "unknown", "changed_areas": [], "note": None}
    rc, _, _ = git("rev-parse", "--is-inside-work-tree")
    if rc != 0:
        out["note"] = "not a git checkout — can't check freshness (clone from origin to enable)"
        return out, 2
    out["is_git"] = True
    out["branch"] = git("rev-parse", "--abbrev-ref", "HEAD")[1] or "(detached)"
    rc, up, _ = git("rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}")
    if rc != 0 or not up:
        out["note"] = (f"branch '{out['branch']}' has no upstream — set one with "
                       f"`git branch --set-upstream-to=origin/{out['branch']}`")
        out["dirty_files"] = len([l for l in git('status', '--porcelain')[1].splitlines() if l.strip()])
        out["status"] = "no-upstream"
        return out, 1
    out["upstream"] = up
    if do_fetch:
        frc = git("fetch", "--quiet", out["upstream"].split("/")[0])[0]
        out["fetched"] = (frc == 0)
        if frc != 0:
            out["note"] = "git fetch failed (offline / no access?) — comparing cached refs"
    out["behind"] = int(git("rev-list", "--count", f"HEAD..{up}")[1] or 0)
    out["ahead"] = int(git("rev-list", "--count", f"{up}..HEAD")[1] or 0)
    out["dirty_files"] = len([l for l in git("status", "--porcelain")[1].splitlines() if l.strip()])
    if out["behind"]:
        # top-level areas that changed upstream (skills/tooling/knowledge/…)
        stat = git("diff", "--name-only", f"HEAD..{up}")[1].splitlines()
        areas = sorted({(p.split("/")[0] if "/" in p else p) for p in stat if p.strip()})
        out["changed_areas"] = areas[:12]
    out["status"] = ("behind" if out["behind"] else
                     "dirty" if out["dirty_files"] else
                     "ahead" if out["ahead"] else "up-to-date")
    return out, (1 if (out["behind"] or out["dirty_files"]) else 0)


def render(o):
    b = o["branch"]
    if not o["is_git"]:
        return f"• support-copilot: {o['note']}"
    if o["status"] == "no-upstream":
        return f"• support-copilot [{b}]: {o['note']}"
    L = []
    if o["behind"]:
        L.append(f"⚠ support-copilot is {o['behind']} commit(s) BEHIND {o['upstream']} "
                 f"— sync before starting this ticket:")
        L.append(f"    git -C \"{o['repo']}\" pull --rebase")
        if o["changed_areas"]:
            L.append(f"    (updates in: {', '.join(o['changed_areas'])})")
    if o["dirty_files"]:
        L.append(f"⚠ {o['dirty_files']} uncommitted local change(s) — commit or stash "
                 f"before pulling.")
    if o["ahead"]:
        L.append(f"ℹ {o['ahead']} local commit(s) not pushed to {o['upstream']}.")
    if not L:
        L.append(f"✓ support-copilot [{b}] is up to date with {o['upstream']}.")
    if o.get("note"):
        L.append(f"  ({o['note']})")
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-fetch", action="store_true", help="skip git fetch (use cached refs)")
    ap.add_argument("--pull", action="store_true", help="fast-forward sync if behind & clean")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    o, code = check(do_fetch=not a.no_fetch)
    if a.json:
        print(json.dumps(o, indent=1)); sys.exit(code)
    print(render(o))
    if a.pull and o.get("behind") and not o.get("dirty_files"):
        print("→ pulling…")
        rc, so, se = git("pull", "--rebase")
        print(so or se)
        sys.exit(0 if rc == 0 else 1)
    elif a.pull and o.get("dirty_files"):
        print("→ not pulling: commit/stash your changes first.")
    sys.exit(code)


if __name__ == "__main__":
    main()
