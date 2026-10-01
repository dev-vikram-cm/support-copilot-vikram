#!/usr/bin/env python3
"""
Config source manager for the Validation Studio.

Lets the tool compose against EITHER the git repo (base branch) OR the LIVE
env config (base overlaid with the env's OCI bucket, honoring `.delete`
tombstones) — per knowledge/runbooks/fetch-live-config.md and
customers/<client>/config_sources.json.

Layout (created under customers/<client>/config/):
    repo/                 git clone of the base branch (allocation-configs)
    overlay/<env>/        raw `oci os object sync` output (…/<prefix>/…)
    effective/<env>/      repo + overlay applied + tombstones removed  ← composed against
    <env>.status.json     {last_synced, fingerprint, counts}

Shell-outs (run on a host with the CLIs + creds — your Mac, not the sandbox):
    git clone/fetch/checkout       (base branch)
    oci os object sync -bn <bucket> --prefix <prefix> --dest-dir <overlay> --region <r>

The pure-Python `build_effective` (base+overlay+.delete) needs no network and
is unit-tested.

CLI:
    python3 config_sync.py --client TRD --status
    python3 config_sync.py --client TRD --sync-env qa            # git + oci + effective
    python3 config_sync.py --client TRD --sync-env qa --print-cmds   # show, don't run
    python3 config_sync.py --client TRD --dir repo|qa           # print the effective dir
"""
import argparse, hashlib, json, os, shutil, subprocess, sys, time
from pathlib import Path

HUB = Path(__file__).resolve().parent.parent.parent          # support-copilot


def load_sources(client):
    f = HUB / "customers" / client / "config_sources.json"
    if not f.exists():
        raise RuntimeError(f"no config_sources.json for {client} ({f})")
    return json.loads(f.read_text())


def _root(client, cfg):
    return HUB / "customers" / client / cfg.get("root", "config")


def paths(client, env=None):
    cfg = load_sources(client)
    root = _root(client, cfg)
    p = {"root": root,
         "repo": root / cfg["config_repo"]["local"]}
    if env:
        p["overlay"] = root / "overlay" / env
        p["effective"] = root / "effective" / env
        p["status"] = root / f"{env}.status.json"
    return p, cfg


def effective_dir(client, source):
    """source = 'repo' or an env name (e.g. 'qa'). Returns the config dir to
    compose against, or None if it hasn't been synced/cloned yet."""
    p, cfg = paths(client, None if source == "repo" else source)
    d = p["repo"] if source == "repo" else (_root(client, cfg) / "effective" / source)
    return d if d.exists() else None


# ---- commands (returned as lists so we can print or run) --------------------
def repo_cmds(client):
    p, cfg = paths(client)
    r = cfg["config_repo"]
    repo, branch, local = r["repo"], r["branch"], p["repo"]
    if (local / ".git").exists():
        return [["git", "-C", str(local), "fetch", "--depth", "1", "origin", branch],
                ["git", "-C", str(local), "checkout", branch],
                ["git", "-C", str(local), "reset", "--hard", f"origin/{branch}"]]
    return [["git", "clone", "--depth", "1", "-b", branch, repo, str(local)]]


def overlay_cmd(client, env):
    p, cfg = paths(client, env)
    e = cfg["envs"].get(env)
    if not e:
        raise RuntimeError(f"no env '{env}' in config_sources for {client}")
    p["overlay"].mkdir(parents=True, exist_ok=True)
    return ["oci", "os", "object", "sync", "-bn", e["bucket"],
            "--prefix", e["prefix"], "--dest-dir", str(p["overlay"]),
            "--region", e["region"]]


def _run(cmd):
    r = subprocess.run(cmd, capture_output=True, text=True)
    return {"cmd": " ".join(cmd), "rc": r.returncode,
            "out": r.stdout[-2000:], "err": r.stderr[-2000:]}


# ---- pure-python overlay build (unit-tested) --------------------------------
def _copy_tree(src, dst):
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)


def build_effective(client, env):
    """effective = copy of repo, with the env overlay applied on top and any
    paths listed in `.delete` markers removed. Returns {files, deleted, fingerprint}."""
    p, cfg = paths(client, env)
    repo, overlay, eff = p["repo"], p["overlay"], p["effective"]
    prefix = cfg["envs"][env]["prefix"].strip("/")
    if not repo.exists():
        raise RuntimeError(f"base repo not cloned yet: {repo}")
    _copy_tree(repo, eff)                                   # start from base
    deleted = 0
    overlay_root = overlay / prefix if (overlay / prefix).exists() else overlay
    applied = 0
    if overlay_root.exists():
        for f in overlay_root.rglob("*"):
            rel = f.relative_to(overlay_root)
            if f.is_dir():
                continue
            if f.name == ".delete":                          # tombstones
                for line in f.read_text().splitlines():
                    line = line.strip()
                    if not line:
                        continue
                    victim = eff / line
                    if victim.exists():
                        victim.unlink(); deleted += 1
                continue
            target = eff / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(f, target); applied += 1
    fp = _fingerprint(eff)
    total = sum(1 for _ in eff.rglob("*") if _.is_file())
    (p["status"]).write_text(json.dumps(
        {"env": env, "last_synced": int(time.time()),
         "fingerprint": fp, "files": total, "overlay_applied": applied,
         "tombstoned": deleted}, indent=1))
    return {"files": total, "overlay_applied": applied, "deleted": deleted, "fingerprint": fp}


def _fingerprint(root):
    h = hashlib.sha256()
    for f in sorted(root.rglob("*")):
        if f.is_file() and ".git" not in f.parts:
            st = f.stat()
            h.update(str(f.relative_to(root)).encode())
            h.update(str(int(st.st_mtime)).encode())
            h.update(str(st.st_size).encode())
    return h.hexdigest()[:16]


def _build_catalog(config_dir, db):
    """Best-effort: (re)build the validation catalog for this effective dir so
    URL→screen resolution + dropdowns work on this source. Shells out to
    build_catalog.py (sibling)."""
    bc = HUB / "tooling" / "validation" / "build_catalog.py"
    if not bc.exists():
        return False
    Path(db).parent.mkdir(parents=True, exist_ok=True)
    r = subprocess.run([sys.executable, str(bc), "--config-dir", str(config_dir), "--db", str(db)],
                       capture_output=True, text=True)
    return r.returncode == 0


def sync_env(client, env, print_cmds=False):
    steps = repo_cmds(client) + [overlay_cmd(client, env)]
    if print_cmds:
        return {"commands": [" ".join(c) for c in steps]}
    results = [_run(c) for c in steps]
    failed = [r for r in results if r["rc"] != 0]
    if failed:
        return {"ok": False, "results": results,
                "hint": "needs git creds + OCI CLI (oci setup config) with bucket access; run on your Mac + VPN"}
    built = build_effective(client, env)
    p, _ = paths(client, env)
    catalog_built = _build_catalog(p["effective"], p["effective"] / "lineage" / "catalog.db")
    return {"ok": True, "results": results, "effective": built, "catalog_built": catalog_built}


def status(client):
    p, cfg = paths(client)
    out = {"client": client, "sources": []}
    repo = p["repo"]
    out["sources"].append({"source": "repo", "kind": "git",
                           "branch": cfg["config_repo"]["branch"],
                           "present": repo.exists(),
                           "dir": str(repo) if repo.exists() else None})
    for env in cfg["envs"]:
        pe, _ = paths(client, env)
        st = json.loads(pe["status"].read_text()) if pe["status"].exists() else {}
        eff = pe["effective"]
        age = int(time.time()) - st["last_synced"] if st.get("last_synced") else None
        out["sources"].append({
            "source": env, "kind": "oci-overlay",
            "bucket": cfg["envs"][env]["bucket"], "prefix": cfg["envs"][env]["prefix"],
            "present": eff.exists(),
            "dir": str(eff) if eff.exists() else None,
            "last_synced": st.get("last_synced"), "age_seconds": age,
            "fingerprint": st.get("fingerprint"), "files": st.get("files")})
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--client", default="TRD")
    ap.add_argument("--status", action="store_true")
    ap.add_argument("--sync-env")
    ap.add_argument("--print-cmds", action="store_true")
    ap.add_argument("--dir", help="print the config dir for a source (repo|<env>)")
    a = ap.parse_args()
    if a.dir:
        d = effective_dir(a.client, a.dir)
        print(d or f"(not synced: {a.dir})")
    elif a.sync_env:
        print(json.dumps(sync_env(a.client, a.sync_env, a.print_cmds), indent=1))
    else:
        print(json.dumps(status(a.client), indent=1))


if __name__ == "__main__":
    main()
