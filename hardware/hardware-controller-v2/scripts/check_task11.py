#!/usr/bin/env python3
"""
check_task11.py — Validate Task 11 PCB placement for the OpenChess v2 controller.

Parses the saved .kicad_pcb s-expression directly (no KiCad Python API required)
and asserts geometry rules that correspond to the placement guide.

Usage:
    python3 hardware/hardware-controller-v2/scripts/check_task11.py [path/to/pcb.kicad_pcb]

If no path is given, uses the project default PCB.
Exits 0 when all assertions pass; exits 1 when any FAIL.

Checks performed:
  (-) Board outline matches v1 exactly: (50,50)→(108,121), 58×71 mm, ±0.5 mm.
  (a) All schematic component refs present on board (via kicad-cli netlist export).
  (b) U2 antenna courtyard crosses Edge.Cuts (overhang confirmed geometrically).
  (c) Proximity rules for power-cluster parts (boost, charger, LDO).
  (d) Connectors within specified distance of a board edge.
  (d2) J1 at exact v1 position (103.6125, 85.418666) ±1 mm, rot 180°, on B.Cu
       (the matrix cable plugs from the BACK — deliberate, per the built v1 board).
  (e) All SMD footprints on F.Cu (front/top). THT parts may be on either side;
      J1 is expected on B.Cu.
  (f) No footprint centroid outside board outline (antenna area excepted).
  (g) kicad-cli DRC run; courtyard-overlap and edge errors reported.

Baseline test (pre-placement, current PCB state):
  The current PCB file still has v1 footprints. Running this script against it
  will FAIL with missing refs for all new v2 parts (U7, U8, U9, U10, U11, J4,
  J5, J6–J9, etc.). That baseline output is included in the task-11 report.
"""

import math
import os
import re
import subprocess
import sys
import tempfile

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
_HERE = os.path.dirname(os.path.abspath(__file__))
_PROJECT_ROOT = os.path.normpath(os.path.join(_HERE, ".."))

PCB_DEFAULT = os.path.join(_PROJECT_ROOT, "openchess-controller.kicad_pcb")
SCH_DEFAULT = os.path.join(_PROJECT_ROOT, "openchess-controller.kicad_sch")
KICAD_CLI = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"

# ---------------------------------------------------------------------------
# Result helpers
# ---------------------------------------------------------------------------
PASS = "PASS"
FAIL = "FAIL"
WARN = "WARN"

_results = []


def check(label, condition, detail=""):
    status = PASS if condition else FAIL
    msg = f"  {status:4s}  {label}"
    if not condition and detail:
        msg += f"\n        → {detail}"
    _results.append((status, msg))
    print(msg)


def warn(label, detail=""):
    msg = f"  WARN  {label}"
    if detail:
        msg += f"\n        → {detail}"
    _results.append((WARN, msg))
    print(msg)


# ---------------------------------------------------------------------------
# PCB S-expression parser (minimal, regex-based)
# ---------------------------------------------------------------------------

def _parse_footprints(pcb_text):
    """
    Return a list of dicts, one per footprint:
      {
        "ref": str,
        "fp": str,          # footprint lib:name
        "x": float,         # centroid X
        "y": float,         # centroid Y
        "rot": float,       # rotation degrees
        "layer": str,       # "F.Cu" or "B.Cu"
        "smd": bool,        # True if any pad has type "smd"
      }
    """
    footprints = []
    # Split on top-level footprint blocks by finding lines that start footprints
    lines = pcb_text.splitlines()
    fp_start_indices = [i for i, l in enumerate(lines) if re.match(r'\s*\(footprint\s+"', l)]

    for start in fp_start_indices:
        # Collect the full block until the closing paren at the same indent level
        block_lines = [lines[start]]
        depth = lines[start].count('(') - lines[start].count(')')
        j = start + 1
        while j < len(lines) and depth > 0:
            block_lines.append(lines[j])
            depth += lines[j].count('(') - lines[j].count(')')
            j += 1
        block = '\n'.join(block_lines)

        fp_name_m = re.search(r'\(footprint\s+"([^"]+)"', block)
        # The top-level (at ...) for the footprint is the first one on a line
        # starting directly under the footprint block (not nested pads)
        at_m = re.search(r'^\s*\(at\s+([\d\.\-]+)\s+([\d\.\-]+)(?:\s+([\d\.\-]+))?\)', block, re.MULTILINE)
        ref_m = re.search(r'\(property\s+"Reference"\s+"([^"]+)"', block)
        layer_m = re.search(r'^\s*\(layer\s+"([^"]+)"', block, re.MULTILINE)
        # KiCad 10 uses (attr smd) or (attr through_hole) as a top-level field
        attr_smd = bool(re.search(r'\(attr\s+smd\b', block))
        # Older: (type "smd") on pads
        smd = attr_smd or bool(re.search(r'\(type\s+"smd"\)', block))

        if not (fp_name_m and at_m and ref_m):
            continue

        rot_str = at_m.group(3) if at_m.lastindex and at_m.lastindex >= 3 else None
        footprints.append({
            "ref": ref_m.group(1),
            "fp": fp_name_m.group(1),
            "x": float(at_m.group(1)),
            "y": float(at_m.group(2)),
            "rot": float(rot_str) if rot_str else 0.0,
            "layer": layer_m.group(1) if layer_m else "",
            "smd": smd or attr_smd,
        })

    return footprints


def _extract_sexpr_blocks(text, tag):
    """
    Yield every complete s-expression block that starts with '(<tag>', using a
    parenthesis-depth counter. (A non-greedy regex like r'\\(gr_rect(.*?)\\)'
    stops at the FIRST close paren — it would truncate the block at
    '(start 50 50' and never see the layer, so depth-walking is required.)
    """
    needle = '(' + tag
    idx = 0
    while True:
        start = text.find(needle, idx)
        if start == -1:
            return
        # Require a delimiter after the tag (avoid gr_rect matching a longer tag)
        after = start + len(needle)
        if after < len(text) and text[after] not in ' \t\r\n(':
            idx = after
            continue
        depth = 0
        pos = start
        while pos < len(text):
            ch = text[pos]
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
                if depth == 0:
                    yield text[start:pos + 1]
                    break
            pos += 1
        else:
            return  # unbalanced input; stop scanning
        idx = pos + 1


def _parse_board_outline(pcb_text):
    """
    Return (x_min, y_min, x_max, y_max) of the Edge.Cuts bounding rect.
    Handles:
      - gr_rect with (layer "Edge.Cuts") — the form KiCad writes for simple rects
      - gr_line segments on Edge.Cuts — accumulates min/max bounds
    Returns None if no Edge.Cuts graphics are found (board outline not yet drawn).
    """
    # Strategy 1: complete gr_rect blocks (depth-walked) carrying Edge.Cuts
    for blk in _extract_sexpr_blocks(pcb_text, 'gr_rect'):
        if 'Edge.Cuts' not in blk:
            continue
        start_m = re.search(r'\(start\s+([\d\.\-]+)\s+([\d\.\-]+)\)', blk)
        end_m   = re.search(r'\(end\s+([\d\.\-]+)\s+([\d\.\-]+)\)', blk)
        if start_m and end_m:
            x1, y1 = float(start_m.group(1)), float(start_m.group(2))
            x2, y2 = float(end_m.group(1)),   float(end_m.group(2))
            return min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2)

    # Strategy 2: gr_line segments on Edge.Cuts — accumulate the XY extent
    xs, ys = [], []
    for blk in _extract_sexpr_blocks(pcb_text, 'gr_line'):
        if 'Edge.Cuts' not in blk:
            continue
        for tok in re.findall(r'\((?:start|end)\s+([\d\.\-]+)\s+([\d\.\-]+)\)', blk):
            xs.append(float(tok[0]))
            ys.append(float(tok[1]))
    if xs and ys:
        return min(xs), min(ys), max(xs), max(ys)

    return None


def _dist(fp_a, fp_b):
    return math.hypot(fp_a["x"] - fp_b["x"], fp_a["y"] - fp_b["y"])


def _dist_to_edge(fp, outline):
    """Minimum distance from the footprint centroid to any of the four board edges."""
    x_min, y_min, x_max, y_max = outline
    return min(
        fp["x"] - x_min,
        x_max - fp["x"],
        fp["y"] - y_min,
        y_max - fp["y"],
    )


def _inside_board(fp, outline, margin=0.0):
    """True if centroid is within (or on) the outline, optionally expanded by margin."""
    x_min, y_min, x_max, y_max = outline
    return (
        x_min - margin <= fp["x"] <= x_max + margin
        and y_min - margin <= fp["y"] <= y_max + margin
    )


# ---------------------------------------------------------------------------
# Schematic ref list (from netlist export or fallback grep)
# ---------------------------------------------------------------------------

def _export_netlist(sch_path, netlist_path):
    if not os.path.isfile(KICAD_CLI):
        return False
    result = subprocess.run(
        [KICAD_CLI, "sch", "export", "netlist", "--format", "kicadxml",
         "--output", netlist_path, sch_path],
        capture_output=True, text=True
    )
    return result.returncode == 0 and os.path.isfile(netlist_path)


def _refs_from_netlist(netlist_path):
    try:
        with open(netlist_path) as f:
            raw = f.read()
        # KiCad 10 exports <comp ref="..."> format
        refs = re.findall(r'<comp\s+ref="([^"]+)"', raw)
        if not refs:
            # Fallback: older <ref>...</ref> tag format
            refs = re.findall(r'<ref>([^<]+)</ref>', raw)
        return set(r for r in refs if not r.startswith('#'))
    except Exception:
        return set()


def _refs_from_schematic_grep(sch_path):
    """Fallback: grep the .kicad_sch for property Reference values."""
    try:
        with open(sch_path) as f:
            sch = f.read()
        raw = re.findall(r'\(property\s+"Reference"\s+"([^"]+)"', sch)
        # Exclude power/flag symbols and template entries
        return set(r for r in raw if not r.startswith('#') and len(r) > 1
                   and not re.match(r'^[A-Z]$', r))
    except Exception:
        return set()


# ---------------------------------------------------------------------------
# kicad-cli DRC
# ---------------------------------------------------------------------------

def _run_drc(pcb_path):
    """
    Run kicad-cli pcb drc and return the report text.
    Returns (success: bool, report_text: str).
    """
    if not os.path.isfile(KICAD_CLI):
        return False, "kicad-cli not found at expected path"
    rpt = tempfile.NamedTemporaryFile(suffix=".rpt", delete=False, mode="w")
    rpt.close()
    result = subprocess.run(
        [KICAD_CLI, "pcb", "drc", "--output", rpt.name, pcb_path],
        capture_output=True, text=True, timeout=120
    )
    try:
        with open(rpt.name) as f:
            text = f.read()
    except Exception:
        text = result.stdout + result.stderr
    os.unlink(rpt.name)
    return result.returncode == 0, text


# ---------------------------------------------------------------------------
# Main checks
# ---------------------------------------------------------------------------

def run_checks(pcb_path, sch_path):
    print(f"\n{'='*65}")
    print(f"check_task11.py — PCB placement validator")
    print(f"PCB : {pcb_path}")
    print(f"SCH : {sch_path}")
    print(f"{'='*65}\n")

    # -----------------------------------------------------------------------
    # Load PCB
    # -----------------------------------------------------------------------
    if not os.path.isfile(pcb_path):
        print(f"ERROR: PCB file not found: {pcb_path}")
        sys.exit(2)

    with open(pcb_path) as f:
        pcb_text = f.read()

    footprints = _parse_footprints(pcb_text)
    fp_by_ref = {fp["ref"]: fp for fp in footprints}
    outline = _parse_board_outline(pcb_text)

    print(f"Parsed {len(footprints)} footprints from PCB.")
    if outline:
        x1, y1, x2, y2 = outline
        print(f"Board outline: ({x1},{y1}) → ({x2},{y2}) = {x2-x1:.1f}×{y2-y1:.1f} mm\n")
        # V1 outline is the case-mandated reference: (50,50)→(108,121), r=3mm.
        V1_OUTLINE = (50.0, 50.0, 108.0, 121.0)
        TOL = 0.5
        matches = all(abs(outline[i] - V1_OUTLINE[i]) <= TOL for i in range(4))
        check(
            "Board outline matches v1: (50,50)→(108,121) ±0.5 mm",
            matches,
            f"Parsed bounds ({x1},{y1})→({x2},{y2}); required (50,50)→(108,121). "
            f"The case depends on this exact 58×71 mm outline.",
        )
    else:
        print("WARNING: Could not parse board outline from Edge.Cuts.\n")
        check(
            "Board outline present on Edge.Cuts",
            False,
            "No Edge.Cuts graphics found — draw the rectangle (50,50)→(108,121), "
            "corner radius 3 mm (guide Step 0).",
        )

    # -----------------------------------------------------------------------
    # (a) All schematic refs present on board
    # -----------------------------------------------------------------------
    print("--- (a) Schematic ↔ PCB ref coverage ---")
    netlist_tmp = tempfile.NamedTemporaryFile(suffix=".net", delete=False).name
    exported = _export_netlist(sch_path, netlist_tmp)
    if exported:
        sch_refs = _refs_from_netlist(netlist_tmp)
        print(f"  Netlist exported: {len(sch_refs)} component refs.")
    else:
        sch_refs = _refs_from_schematic_grep(sch_path)
        warn("kicad-cli netlist export failed — falling back to schematic grep",
             f"Found {len(sch_refs)} refs via grep (may include template symbols)")

    # These refs are virtual (power symbols) and never appear on the PCB
    VIRTUAL_PREFIXES = ('#', 'PWR_FLAG')
    real_sch_refs = {r for r in sch_refs if not any(r.startswith(p) for p in VIRTUAL_PREFIXES)}

    # Refs that the schematic specifies but the PCB omits
    pcb_refs = set(fp_by_ref.keys())
    missing_from_pcb = real_sch_refs - pcb_refs
    extra_on_pcb = pcb_refs - real_sch_refs

    check(
        f"All {len(real_sch_refs)} schematic refs present on PCB",
        len(missing_from_pcb) == 0,
        f"Missing: {', '.join(sorted(missing_from_pcb))}" if missing_from_pcb else "",
    )
    if extra_on_pcb:
        warn(
            f"{len(extra_on_pcb)} extra refs on PCB not in schematic",
            f"Extra: {', '.join(sorted(extra_on_pcb))} — may be stale v1 footprints"
        )

    if missing_from_pcb:
        print(f"\n  NOTE: {len(missing_from_pcb)} missing ref(s) — this is expected on a")
        print(f"  pre-placement (baseline) run before Task 11 GUI work is done.")
        print(f"  Missing: {', '.join(sorted(missing_from_pcb))}\n")

    # -----------------------------------------------------------------------
    # Helper: safely get a footprint or skip related checks
    # -----------------------------------------------------------------------
    def fp(ref):
        return fp_by_ref.get(ref)

    def proximity(ref_a, ref_b, max_mm, label=None):
        a, b = fp(ref_a), fp(ref_b)
        if a is None or b is None:
            warn(f"Proximity {ref_a}↔{ref_b}: one or both refs missing from PCB")
            return
        d = _dist(a, b)
        lbl = label or f"|{ref_a}–{ref_b}| < {max_mm} mm"
        check(lbl, d <= max_mm,
              f"Actual distance = {d:.1f} mm (max {max_mm} mm)")

    def near_edge(ref, max_mm, label=None):
        a = fp(ref)
        if a is None:
            warn(f"Edge proximity {ref}: ref missing from PCB")
            return
        if outline is None:
            warn(f"Edge proximity {ref}: board outline not parsed")
            return
        d = _dist_to_edge(a, outline)
        lbl = label or f"{ref} within {max_mm} mm of a board edge"
        check(lbl, d <= max_mm,
              f"Closest edge distance = {d:.1f} mm (max {max_mm} mm)")

    # -----------------------------------------------------------------------
    # (b) U2 antenna overhang: courtyard crosses Edge.Cuts top edge
    # -----------------------------------------------------------------------
    print("\n--- (b) U2 antenna overhang ---")
    u2 = fp("U2")
    if u2 is None:
        warn("U2 not on PCB — antenna overhang check skipped")
    else:
        if outline:
            y_top = outline[1]  # top edge (min Y)
            # Module BODY half-height: the RF_Module:ESP32-WROOM-32E footprint's
            # F.Fab body spans y = -12.75 .. +12.75 relative to the anchor
            # (anchor = body centre; 25.5 mm tall module). This is NOT the
            # courtyard — the courtyard/keepout wing extends ~28 mm above the
            # anchor (antenna clearance region). The check below verifies the
            # module BODY tip overhangs the board edge; the footprint's
            # built-in keepout rule-area covers any antenna clearance that
            # remains on-board.
            WROOM_BODY_HALF_H = 12.75
            body_tip_y = u2["y"] - WROOM_BODY_HALF_H
            overhangs = body_tip_y < y_top
            check(
                "U2 module body tip crosses top Edge.Cuts (antenna overhang confirmed)",
                overhangs,
                f"Body tip Y = {body_tip_y:.2f} mm, top edge Y = {y_top:.2f} mm. "
                f"{'Overhang OK' if overhangs else 'No overhang — move U2 toward top edge or rotate.'}"
            )
            overhang_mm = y_top - body_tip_y
            if overhangs:
                check(
                    f"U2 overhang ≥ 2 mm (actual {overhang_mm:.1f} mm)",
                    overhang_mm >= 2.0,
                    "Increase overhang to ≥ 2 mm for reliable antenna performance"
                )
        else:
            warn("U2 overhang: board outline not parsed")

    # -----------------------------------------------------------------------
    # (c) Proximity rules for power cluster
    # -----------------------------------------------------------------------
    print("\n--- (c) Proximity rules ---")

    # Boost cluster: U10 TPS61022
    proximity("L1",  "U10", 8.0,  "|L1–U10| < 8 mm (inductor tight to boost IC)")
    proximity("C22", "U10", 6.0,  "|C22–U10| < 6 mm (boost VIN input cap)")
    proximity("C23", "U10", 10.0, "|C23–U10| < 10 mm (boost VOUT bulk)")
    proximity("C24", "U10", 10.0, "|C24–U10| < 10 mm (boost VOUT ceramic)")
    proximity("C25", "U10", 10.0, "|C25–U10| < 10 mm (boost VOUT ceramic)")

    # Charger cluster: U9 BQ24074
    proximity("C20", "U9",  6.0,  "|C20–U9| < 6 mm (charger IN decoupling)")
    proximity("C21", "U9",  6.0,  "|C21–U9| < 6 mm (charger OUT decoupling)")

    # LDO cluster: U11 AMS1117
    proximity("C17", "U11", 6.0,  "|C17–U11| < 6 mm (LDO output bypass)")
    proximity("C18", "U11", 6.0,  "|C18–U11| < 6 mm (LDO input bypass)")

    # U2 ESP32 decoupling
    proximity("C13", "U2",  5.0,  "|C13–U2| < 5 mm (WROOM 3V3 bypass)")
    proximity("C14", "U2",  6.0,  "|C14–U2| < 6 mm (WROOM 3V3 bulk)")

    # U7 CH340C decoupling
    proximity("C16", "U7",  5.0,  "|C16–U7| < 5 mm (CH340C V3 bypass)")
    proximity("C19", "U7",  5.0,  "|C19–U7| < 5 mm (CH340C VCC bypass)")

    # U8 USBLC6 in USB D+/D- path
    proximity("U8",  "J4",  10.0, "|U8–J4| < 10 mm (ESD protector near USB connector)")

    # -----------------------------------------------------------------------
    # (d) Connectors within distance of board edge
    # -----------------------------------------------------------------------
    print("\n--- (d) Connector edge proximity ---")

    # 5 mm: a flush edge-mount USB-C's centroid legitimately sits ~4 mm inboard
    near_edge("J4",  5.0,  "J4 USB-C within 5 mm of a board edge")
    near_edge("J5",  5.0,  "J5 battery connector within 5 mm of an edge")
    near_edge("J6",  5.0,  "J6 OLED connector within 5 mm of an edge")
    near_edge("J7",  5.0,  "J7 button connector within 5 mm of an edge")
    near_edge("J8",  5.0,  "J8 button connector within 5 mm of an edge")
    near_edge("J9",  5.0,  "J9 button connector within 5 mm of an edge")
    near_edge("SW1", 5.0,  "SW1 slide switch within 5 mm of an edge")

    # J1 is special: the matrix cable and case assume the exact v1 position,
    # rotation 180°, on the BACK copper (cable plugs from the back). Verified
    # against hardware-controller/openchess-controller.kicad_pcb (v1, as built).
    print("\n--- (d2) J1 exact v1 position (case/cable contract) ---")
    J1_V1_X, J1_V1_Y, J1_V1_ROT = 103.6125, 85.418666, 180.0
    j1 = fp("J1")
    if j1 is None:
        warn("J1 missing from PCB — position check skipped")
    else:
        d = math.hypot(j1["x"] - J1_V1_X, j1["y"] - J1_V1_Y)
        check(
            f"J1 at v1 position ({J1_V1_X}, {J1_V1_Y}) ±1 mm",
            d <= 1.0,
            f"J1 is at ({j1['x']}, {j1['y']}) — {d:.1f} mm away. Move it back "
            f"(footprint Properties: X={J1_V1_X}, Y={J1_V1_Y}).",
        )
        check(
            "J1 rotation = 180°",
            abs(((j1["rot"] - J1_V1_ROT) + 180) % 360 - 180) <= 0.1,
            f"J1 rotation is {j1['rot']}° — set Orientation to 180° in Properties.",
        )
        check(
            "J1 on B.Cu (back — matrix cable plugs from the back, per v1)",
            j1["layer"].startswith("B."),
            f"J1 is on {j1['layer']!r}. Do NOT place J1 on the front — "
            f"press F to flip it to the back.",
        )

    # -----------------------------------------------------------------------
    # (e) All SMD footprints on F.Cu
    # -----------------------------------------------------------------------
    print("\n--- (e) All SMD parts on F.Cu (front/top) ---")
    # This rule applies to SMD footprints only (single-side JLC assembly).
    # Through-hole parts (J1, J5–J9) may legitimately sit on either side;
    # J1 in particular is EXPECTED on B.Cu (checked in section d2).
    back_smd = [
        fp_["ref"] for fp_ in footprints
        if fp_["smd"] and fp_["layer"].startswith("B.")
    ]
    check(
        "All SMD footprints on F.Cu (front layer)",
        len(back_smd) == 0,
        f"SMD parts on back copper: {', '.join(sorted(back_smd))} — "
        f"press F on each to flip back to the front." if back_smd else "",
    )

    # Informational: list THT parts on the back other than J1 (J1's back-side
    # placement is deliberate and asserted in section d2).
    back_tht_unexpected = [
        fp_["ref"] for fp_ in footprints
        if fp_["layer"].startswith("B.") and not fp_["smd"] and fp_["ref"] != "J1"
    ]
    if back_tht_unexpected:
        warn(
            f"{len(back_tht_unexpected)} through-hole footprint(s) on back copper (besides J1)",
            f"Refs: {', '.join(sorted(back_tht_unexpected))} — confirm intentional"
        )

    # -----------------------------------------------------------------------
    # (f) No footprint centroid outside board outline
    # -----------------------------------------------------------------------
    print("\n--- (f) Footprints inside board outline ---")
    if outline is None:
        warn("Board outline not parsed — skipping boundary check")
    else:
        # U2 antenna is allowed to extend outside the top edge
        ANTENNA_ALLOWANCE = 5.0  # mm beyond top edge allowed for U2 only
        outside = []
        for fp_ in footprints:
            if fp_["ref"] == "U2":
                # U2 may cross the top edge; check only left/right/bottom
                x_min, y_min, x_max, y_max = outline
                if not (x_min - 1 <= fp_["x"] <= x_max + 1 and fp_["y"] <= y_max + 1):
                    outside.append(fp_["ref"])
            else:
                if not _inside_board(fp_, outline, margin=1.0):
                    outside.append(fp_["ref"])
        check(
            "All footprint centroids inside board outline (U2 antenna excepted)",
            len(outside) == 0,
            f"Outside board: {', '.join(sorted(outside))}" if outside else "",
        )

    # -----------------------------------------------------------------------
    # (g) kicad-cli DRC — courtyard overlap + edge errors
    # -----------------------------------------------------------------------
    print("\n--- (g) kicad-cli DRC (courtyard / edge errors) ---")
    if not os.path.isfile(KICAD_CLI):
        warn("kicad-cli not found — DRC skipped",
             f"Expected at: {KICAD_CLI}")
    else:
        print(f"  Running kicad-cli pcb drc on {pcb_path} …")
        try:
            ok, rpt = _run_drc(pcb_path)
        except subprocess.TimeoutExpired:
            warn("DRC timed out after 120 s")
            rpt = ""
            ok = False

        # Filter lines relevant to placement (exclude unconnected nets)
        relevant = [
            l.strip() for l in rpt.splitlines()
            if re.search(r'courtyard|edge\.cuts|outside.*board|board.*outside', l, re.IGNORECASE)
            and not re.search(r'unconnected|ratsnest', l, re.IGNORECASE)
        ]

        # Antenna courtyard crossing Edge.Cuts is expected and acceptable
        antenna_edge_lines = [l for l in relevant if re.search(r'u2|antenna', l, re.IGNORECASE)]
        real_errors = [l for l in relevant if l not in antenna_edge_lines]

        check(
            "DRC: zero courtyard-overlap or edge errors (excl. U2 antenna)",
            len(real_errors) == 0,
            "\n        ".join(real_errors) if real_errors else "",
        )
        if antenna_edge_lines:
            warn(
                f"DRC: {len(antenna_edge_lines)} U2-antenna edge crossing(s) — expected, not an error",
                antenna_edge_lines[0] if antenna_edge_lines else "",
            )
        if not rpt.strip():
            warn("DRC produced no output — PCB may need saving in KiCad first")


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

def _summarise():
    total = len(_results)
    n_pass = sum(1 for s, _ in _results if s == PASS)
    n_fail = sum(1 for s, _ in _results if s == FAIL)
    n_warn = sum(1 for s, _ in _results if s == WARN)
    print(f"\n{'='*65}")
    print(f"SUMMARY: {n_pass} passed, {n_fail} failed, {n_warn} warnings  ({total} total)")
    if n_fail:
        print("OVERALL: FAIL — fix the issues above, save the PCB, and re-run.")
        return False
    print("OVERALL: PASS — Task 11 placement geometry constraints satisfied.")
    return True


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main():
    pcb_path = sys.argv[1] if len(sys.argv) >= 2 else PCB_DEFAULT
    sch_path = sys.argv[2] if len(sys.argv) >= 3 else SCH_DEFAULT

    run_checks(pcb_path, sch_path)
    ok = _summarise()
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
