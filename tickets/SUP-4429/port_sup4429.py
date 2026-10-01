#!/usr/bin/env python3
"""SUP-4429: port ANN's QA metric blocks (5 cols) into each brand's config repo clone."""
import json, re, sys
from pathlib import Path

QA = Path(__file__).parent / "live-config/qa/ann/override_configuration"
JIRAS = Path("/Users/vigneshn/Desktop/JIRAs/SUP-4429")
BRANDS = ["ann", "atfs", "loft", "los"]
PIVOTS = ["LinePlanFloorsetAll", "LinePlanFloorsetMaster", "LinePlanFloorsetSizeConcept",
          "LinePlanFloorsetDesignSeasonAll", "LinePlanFloorsetDesignSeason_MasterStyle",
          "LinePlanFloorsetDesignSeason_SizeConcept"]
VIEWS = ["AssortmentLinePlanByFloorsetAll", "AssortmentLinePlanByFloorsetMaster",
         "AssortmentLinePlanByFloorsetSize", "AssortmentByDesignSeasonGrid_AllStyles",
         "AssortmentByDesignSeasonGrid_MasterStyle", "AssortmentByDesignSeasonGrid_SizeConcept"]
ST = ["final_st_pct", "store_final_st_pct", "ecom_final_st_pct"]
EOP = ["store_ttl_eohu", "ecom_ttl_eohu"]
ST_ANCHOR, EOP_ANCHOR = "ecom_ttl_stk_sls_u", "attribute:plan_comments:id"


def read(p):
    b = p.read_bytes().decode("utf-8")
    return b.replace("\r\n", "\n"), "\r\n" in b


def write(p, text, crlf):
    p.write_bytes((text.replace("\n", "\r\n") if crlf else text).encode("utf-8"))


def obj_span(t, key):
    """(start,end) of the {...} object whose dataIndex is `key` (string-aware brace match)."""
    m = list(re.finditer(r'"dataIndex"\s*:\s*"%s"' % re.escape(key), t))
    assert len(m) == 1, f"{key}: {len(m)} matches"
    pos, depth, i = m[0].start(), 0, m[0].start()
    while True:  # walk back to enclosing {
        i -= 1
        if t[i] == "}": depth += 1
        elif t[i] == "{":
            if depth == 0: break
            depth -= 1
    start, depth, instr, j = i, 0, False, i
    while True:
        c = t[j]
        if instr:
            if c == "\\": j += 1
            elif c == '"': instr = False
        elif c == '"': instr = True
        elif c == "{": depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0: return start, j + 1
        j += 1


def port_view(name, brand):
    src, _ = read(QA / f"uidefn/view/{name}.viewdefn")
    p = JIRAS / f"{brand}-configs/uidefn/view/{name}.viewdefn"
    t, crlf = read(p)
    if "final_st_pct" in t:
        return "skip (already has)"
    def objs(keys):
        return ",\n    ".join(src[slice(*obj_span(src, k))].strip() for k in keys)
    # indentation of the anchor object's line
    for keys, anchor in ((EOP, EOP_ANCHOR), (ST, ST_ANCHOR)):  # EOP first so earlier offsets stay valid
        s, e = obj_span(t, anchor)
        ind = re.search(r"[ \t]*$", t[:s]).group(0)
        block = ",\n".join(ind + src[slice(*obj_span(src, k))].strip() for k in keys)
        t = t[:e] + ",\n" + block + t[e:]
    json.loads(t)  # must stay valid JSON
    write(p, t, crlf)
    return "ok"


def port_pivot(name, brand):
    src, _ = read(QA / f"pivot/{name}.pivotdefn")
    lines = src.split("\n")
    i = next(k for k, l in enumerate(lines) if "SUP-4429" in l)
    blk = lines[i:i + 6]
    assert "ecom_final_st_pct" in blk[-1], blk
    anchor = lines[i - 1]
    p = JIRAS / f"{brand}-configs/pivot/{name}.pivotdefn"
    t, crlf = read(p)
    if "final_st_pct" in t:
        return "skip (already has)"
    tl = t.split("\n")
    hits = [k for k, l in enumerate(tl) if l.strip() == anchor.strip()]
    assert len(hits) == 1, f"anchor hits={len(hits)}: {anchor.strip()[:80]}"
    ind = re.match(r"\s*", tl[hits[0]]).group(0)
    tl[hits[0] + 1:hits[0] + 1] = [ind + b.strip() for b in blk]
    write(p, "\n".join(tl), crlf)
    return "ok"


if __name__ == "__main__":
    for b in BRANDS:
        for n in PIVOTS: print(b, "pivot", n, port_pivot(n, b))
        for n in VIEWS: print(b, "view ", n, port_view(n, b))
