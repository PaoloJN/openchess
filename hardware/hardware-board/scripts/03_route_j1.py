#!/usr/bin/env python3
"""
03_route_j1.py — wire J1 (J_CTRL) up to the rest of the matrix board.

`02_route.py` intentionally leaves the J1 area unrouted (its docstring
even calls this out). This script fills that gap with a deterministic,
lane-based plan that's easy to read, easy to undo, and easy to tweak.

What it lays down
-----------------
1. **+5V_LED zone on B.Cu** — one big polygon covering the bottom margin
   (where J1's +5V_LED pins are) PLUS the left margin (where C1..C9 row
   bulks live). Set to priority 1 so the user's later GND zone (priority
   0, the KiCad default) carves around it cleanly. J1's +5V_LED pins
   connect directly because the through-hole pads sit inside the zone.

2. **Stitching vias for row bulks** — C1..C9 pin 1 are SMT pads on F.Cu,
   so they need a via to reach the B.Cu zone. One small via drop per
   bulk, placed right next to the pin 1 pad. Without these, the bulks
   are stranded.

3. **LED_DATA_5V trace** — J1 pin 7 to D1 DIN. Manhattan path that exits
   J1 north on B.Cu, runs through the left-margin lane between the row
   bulks and the LED grid, vias to F.Cu near D1, and lands on its DIN
   pad.

4. **CA_PWR..CH_PWR fanouts** — eight B.Cu traces, each connecting a J1
   pad to the southern end of the column rail laid down by 02_route.py.
   CA..CD fan WEST, CE..CH fan EAST, each on its own horizontal Y lane
   between J1 and the matrix.

5. **S0..S7 fanouts** — eight traces, each from a J1 pad to the leftmost
   Hall OUT pad in its rank. B.Cu vertical lanes in the empty strip
   between the row bulks and the LED grid (X≈60..67), then a via to
   F.Cu, then a short F.Cu stub east to the Hall OUT pad. F.Cu was
   chosen for the final stub to match 02_route.py's row-sense rail.

Routing topology — the why
--------------------------
The bottom margin is genuinely tight (14 mm tall, holding J1 + 16 fanout
traces + a power zone + ground). The lane assignment uses three rules:

  • Each horizontal "fanout lane" gets a unique Y, so no two parallel
    traces ever sit at the same Y on the same layer.
  • S traces and CA..CH traces share the bottom-margin B.Cu corridor but
    don't conflict — CA..CH terminate at column rail Xs (76.25..298.5)
    while S verticals climb at X=60..67, which is WEST of the leftmost
    column rail (X=76.25). No crossings.
  • The 4 west-going CA..CD lanes use the southern Y values; the 4
    east-going CE..CH use the same band but on the east side of J1.

GND zone is NOT touched. The user fills GND zones on both layers in
KiCad (per the 02_route.py contract). The +5V_LED zone's priority
ensures it survives the GND fill.

Pathfinding libraries — why none
--------------------------------
For a fanout of 17 traces from a known connector to known endpoints with
no significant obstacles, deterministic Manhattan routing with explicit
lane assignment is cleaner than algorithmic pathfinding (Lee/A*) and
more reproducible than running freerouting. Freerouting (Java, DSN/SES
roundtrip) is the escape hatch if this script's output doesn't look
right after a tweak round.

Idempotent: every track/via/zone this script adds is tagged with a UUID
prefix (`70474e01…`). Re-running removes only its own items; hand-routed
traces with other UUIDs are preserved.

PREREQUISITE — 01_chess_grid.py must have placed J1 and the matrix; ideally
02_route.py has already laid the column rails + row sense traces so the
endpoints exist. (Either order is OK; this script doesn't depend on
their tracks, only on the placed footprints.)

Run with KiCad CLOSED.
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

try:
    import pcbnew
except ImportError:
    # System python3 doesn't ship pcbnew. Re-exec with the python that
    # ships with KiCad so plain `python3 03_route_j1.py` Just Works.
    _KICAD_PYTHONS = [
        # macOS — bundled KiCad app
        "/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3",
        # Linux (Debian/Ubuntu packaging usually patches the system python)
        "/usr/bin/python3",
        # Windows
        r"C:\Program Files\KiCad\10.0\bin\python.exe",
        r"C:\Program Files\KiCad\9.0\bin\python.exe",
    ]
    for _py in _KICAD_PYTHONS:
        if os.path.exists(_py) and _py != sys.executable:
            os.execv(_py, [_py, *sys.argv])
    sys.exit("pcbnew not on path — install KiCad or run with its Python.")


# ──────────────────────────────────────────────────────────────────────────────
# Paths + identity
# ──────────────────────────────────────────────────────────────────────────────
HERE = Path(__file__).resolve().parent
BOARD_PATH = (HERE / ".." / "openchess-board.kicad_pcb").resolve()


# ──────────────────────────────────────────────────────────────────────────────
# Configuration — change me to tune the routing
# ──────────────────────────────────────────────────────────────────────────────

# Matrix dimensions (must match 01_chess_grid.py / 02_route.py)
MATRIX_COLS = 8
MATRIX_ROWS = 8
SQUARE_SIZE_MM   = 31.75
BOARD_MARGIN_MM  = 14
FIRST_HALL_Y_MM  = BOARD_MARGIN_MM + SQUARE_SIZE_MM / 2.0 + 50    # 79.875 mm
COL_RAIL_X_OFFSET_MM = 3.619   # column rail X = leftmost-Hall.x - offset (from 02_route.py)

# Track widths
SIGNAL_WIDTH_MM   = 0.2         # S0..S7 + LED_DATA — matches 02_route.py
COL_RAIL_WIDTH_MM = 0.5         # CA..CH — matches 02_route.py column rail
POWER_STUB_WIDTH_MM = 0.5       # row-bulk stitching stub

# Via dimensions
VIA_DIAMETER_MM = 0.6
VIA_DRILL_MM    = 0.3

# Bulk-cap stitching via — sits next to each row bulk pin 1 SMT pad to
# tie F.Cu pin 1 to the B.Cu +5V_LED zone.
STITCH_VIA_DIAMETER_MM = 0.5
STITCH_VIA_DRILL_MM    = 0.25
STITCH_VIA_OFFSET_MM   = 1.2

# +5V_LED zone outline (B.Cu, L-shape covering J1 area + row-bulk column).
# Bottom strip starts at Y=315 (just south of the bottom LED row at
# Y=318.5 — gives 3.5 mm clearance) so it doesn't carve around the
# F.Cu lane band at Y=319..325. North of the strip, B.Cu lanes Y=305..313
# stay outside the zone (no swiss-cheese around each lane).
ZONE_BOTTOM_STRIP = [   # (x, y) corners, clockwise
    (51.0,  315.0),
    (331.0, 315.0),
    (331.0, 331.0),
    (51.0,  331.0),
]
# Left margin — covers C1..C9 row bulk pin 1 + their stitching vias.
ZONE_LEFT_STRIP = [
    (51.0,  51.0),
    (61.0,  51.0),
    (61.0,  315.0),
    (51.0,  315.0),
]

# Per-family toggles. The full J1 fanout was getting too dense to auto-
# route cleanly, so all the full-route families are off — Paolo is
# hand-routing J1. The script just plants "starter" routes for S0 and
# S7 (a short F.Cu jog + via + long B.Cu south drop + via) so the user
# has anchor points to extend from.
ROUTE_5V_ZONE    = False
ROUTE_5V_STITCH  = False
ROUTE_LED_DATA   = False
ROUTE_S_NETS     = False
ROUTE_C_NETS     = False
ROUTE_S_STARTERS = True
ROUTE_C_STARTERS = True   # Hall-to-J1 column-power starters (B..H)

# Which S indices to route in the full-fanout pass (unused while
# ROUTE_S_NETS is False — kept for when it's re-enabled).
ROUTE_S_INDICES = (1, 2, 3, 4, 5, 6, 7)

# Starter routes — one per S_n. Each starts at the leftmost (file 0)
# Hall in rank n, planting a 2-via "drop" with a long B.Cu vertical so
# Paolo can hand-route the last leg into the right J1 pad.
#
# All 8 starters land at the SAME end Y, side by side, each in its own
# vertical lane: lane X = hall_x + STARTER_VIA1_E_OFFSET_MM + i *
# STARTER_LANE_PITCH_MM, where i is the rank index. The result is 8
# parallel B.Cu drops in a tidy bundle east of the Hall column.
S_STARTERS = [
    # (net_label, hall_ref) — Ux for rank x at file 0 is U{x+1}.
    ("S0", "U1"),
    ("S1", "U2"),
    ("S2", "U3"),
    ("S3", "U4"),
    ("S4", "U5"),
    ("S5", "U6"),
    ("S6", "U7"),
    ("S7", "U8"),
]
# SOT-23 pad 3 (OUT) sits 0.9375 mm EAST of footprint center. Via 1
# offsets are measured from Hall footprint center.
SOT23_OUT_PAD_X_OFFSET_MM = 0.9375
STARTER_VIA1_E_OFFSET_MM  = 2.5    # via 1 X offset east of Hall 0 center
STARTER_VIA1_S_OFFSET_MM  = 3.0    # via 1 Y offset south of Hall center
STARTER_LANE_PITCH_MM     = 1.2    # X delta between consecutive S lanes
                                   # 1.2 mm → 0.6 mm via-to-via clearance
                                   # (0.6 mm via diameter)
STARTER_END_Y_MM          = 322.0  # via 2 Y — just south of LED row 8 (Y=318.5)
                                   # leaves a clear 6.5 mm corridor down to J1 (Y≈328.5)

# C starters — one B.Cu trace per column B..H, picking up at the
# column rail's south end (where 02_route.py terminates) and dropping
# down to the matching J1 column-power pad. CA is intentionally
# skipped — Paolo hand-routed it.
C_STARTER_COLS = (1, 2, 3, 4, 5, 6, 7)   # 0=A is hand-routed; route 1=B..7=H
# Unique horizontal Y per column so the 7 B.Cu lanes don't collide
# in the bottom margin (Y range 303..312, 1.5 mm pitch).
C_STARTER_LANE_Y_MM = {
    1: 303.0,    # CB
    2: 304.5,    # CC
    3: 306.0,    # CD
    4: 307.5,    # CE
    5: 309.0,    # CF
    6: 310.5,    # CG
    7: 312.0,    # CH
}

# Layer assignment — each J1 pin's signal goes on a specific layer so
# that no two traces in the same pin pair share a layer AND an X.
#
# 2026-06-11 update: layer split is now TOP-ROW=B.Cu, BOTTOM-ROW=F.Cu
# (was the opposite). Rationale: top-row pins sit closer to the matrix
# and on B.Cu they meet the column rails (which are also B.Cu) without
# extra vias. Bottom-row pins on F.Cu have a wide-open F.Cu corridor
# south of the LED row.
LAYER_BY_NET = {
    "LED_DATA_5V": "F.Cu",   # pin  7 — bottom row
    "S0": "F.Cu", "S1": "B.Cu",  # pin  9 (bot), 10 (top)
    "S2": "F.Cu", "S3": "B.Cu",  # pin 11, 12
    "S4": "F.Cu", "S5": "B.Cu",  # pin 13, 14
    "S6": "F.Cu", "S7": "B.Cu",  # pin 15, 16
    "CA": "F.Cu", "CB": "B.Cu",  # pin 17 (bot), 18 (top)
    "CC": "F.Cu", "CD": "B.Cu",  # pin 19, 20
    "CE": "F.Cu", "CF": "B.Cu",  # pin 21, 22
    "CG": "F.Cu", "CH": "B.Cu",  # pin 23, 24
}

# Which J1 pads are on the BOTTOM (south) row — these need an east jog
# before climbing north so the trace doesn't pass through the top pad
# above (same X, different net = short). Top-row pad traces don't need
# a jog because climbing north (smaller Y) takes them AWAY from the
# bottom pad.
BOTTOM_ROW_NETS = {
    "LED_DATA_5V", "S0", "S2", "S4", "S6",
    "CA", "CC", "CE", "CG",
}

# Horizontal lane Y per net. Each lane has a unique Y on its own layer
# so no two parallel traces share a Y at the same layer.
#
# B.Cu lanes sit in the corridor between the bottom Hall row (Y=302.125)
# and the LED row (Y=313.5..318.5 body) — F.Cu has LEDs there, but B.Cu
# is clear. F.Cu lanes sit BELOW the LED row, between the LED bottom
# edge (Y=318.5) and J1 (Y≈327).
LANE_Y = {
    # B.Cu — top-row J1 pins (S1, S3, S5, S7, CB, CD, CF, CH).
    # Y=305..313 (1 mm pitch, 8 lanes). All south of Y=305 so
    # clear_owned's boundary check cleanly distinguishes our routes
    # from 02_route.py's matrix-area routes (which end at Y=302.125).
    "CB": 305.0,
    "CD": 306.0,
    "CF": 307.0,
    "CH": 308.0,
    "S1": 309.0,
    "S3": 310.0,
    "S5": 311.0,
    "S7": 312.0,
    # F.Cu — bottom-row J1 pins (S0, S2, S4, S6, CA, CC, CE, CG +
    # LED_DATA). Y=319.5..325.6 (0.7 mm pitch, 9 lanes). North edge
    # clear of per-LED cap bodies for LED row 8 (Y=317..319).
    "CA":           319.5,
    "CC":           320.2,
    "CE":           320.9,
    "CG":           321.6,
    "LED_DATA_5V": 322.3,
    "S0":           323.0,
    "S2":           323.7,
    "S4":           324.4,
    "S6":           325.1,
}

# South-row J1 traces (B.Cu) must NOT pass through the north pad sitting
# directly north of them at the same X — that pad is on a different net
# and would short. So south traces exit east by this much before going
# vertical, putting the climb clear of the north pad's annular ring.
SOUTH_PIN_JOG_E_MM = 1.5   # > pad radius (~0.8 mm) + clearance margin

# Left-margin vertical climb lanes for S traces (the segment that runs
# north up the left margin to reach each rank Y).
#   • Top-row S (S1/S3/S5/S7, B.Cu): lanes EAST of the +5V_LED zone
#     and WEST of column rail A (X=76.25).
#   • Bottom-row S (S0/S2/S4/S6, F.Cu): lanes in the left-margin gap
#     between row bulks (X=54 body) and LED column 0 (X=64 body).
LANE_X_S_BCU = {1: 62.0, 3: 63.0, 5: 64.0, 7: 65.0}
LANE_X_S_FCU = {0: 58.0, 2: 59.0, 4: 60.0, 6: 61.0}

# Y at which the B.Cu S verticals via to F.Cu — just south of the rank Y
# so the short F.Cu stub east clears the Hall body.
S_VIA_Y_OFFSET_FROM_RANK = -1.5

# LED_DATA_5V routing — B.Cu lane to a via in the left margin, then
# F.Cu vertical climb up to D1 DIN.
LED_DATA_LANE_X = 66.5            # vertical climb X for the F.Cu portion


# ──────────────────────────────────────────────────────────────────────────────
# pcbnew helpers (parallel to 02_route.py — duplicated to keep scripts
# independent; if they diverge, we'd refactor into a shared lib.)
# ──────────────────────────────────────────────────────────────────────────────
F_CU = pcbnew.F_Cu
B_CU = pcbnew.B_Cu


def layer_id(name: str) -> int:
    return F_CU if name == "F.Cu" else B_CU


def mm_to_nm(v: float) -> int:
    return int(round(v * 1_000_000))


def _v(x_nm, y_nm) -> "pcbnew.VECTOR2I":
    return pcbnew.VECTOR2I(int(x_nm), int(y_nm))


def _vmm(x_mm: float, y_mm: float) -> "pcbnew.VECTOR2I":
    return _v(mm_to_nm(x_mm), mm_to_nm(y_mm))


def find_pad(board, ref: str, pad_num):
    pad_num = str(pad_num)
    for fp in board.GetFootprints():
        if fp.GetReference() == ref:
            for pad in fp.Pads():
                if pad.GetNumber() == pad_num:
                    return pad
    return None


def pad_pos(board, ref: str, pad_num):
    pad = find_pad(board, ref, pad_num)
    return pad.GetPosition() if pad else None


def net_code(board, name: str):
    net = board.FindNet(name)
    if net is None or net.GetNetCode() == 0:
        return None
    return net.GetNetCode()


def jog_start(j1_pad, net_label: str) -> "pcbnew.VECTOR2I":
    """For BOTTOM-row pads (regardless of routing layer), return the
    point 1.5 mm EAST of the pad — that's where the vertical climb
    starts so it doesn't pass through the TOP-row pad sitting north of
    this one at the same X (the top pad is a different net = short).

    TOP-row pads don't need a jog: climbing north takes them AWAY from
    the bottom pad."""
    if net_label in BOTTOM_ROW_NETS:
        return _v(j1_pad.x + mm_to_nm(SOUTH_PIN_JOG_E_MM), j1_pad.y)
    return _v(j1_pad.x, j1_pad.y)


def add_track(board, start, end, net_code_val, layer_name="F.Cu",
              width_mm=SIGNAL_WIDTH_MM):
    if start is None or end is None or net_code_val is None:
        return
    if start.x == end.x and start.y == end.y:
        return
    track = pcbnew.PCB_TRACK(board)
    track.SetStart(start)
    track.SetEnd(end)
    track.SetLayer(layer_id(layer_name))
    track.SetWidth(mm_to_nm(width_mm))
    track.SetNetCode(net_code_val)
    board.Add(track)


def add_via(board, pos, net_code_val,
            diameter_mm=VIA_DIAMETER_MM, drill_mm=VIA_DRILL_MM):
    if pos is None or net_code_val is None:
        return
    via = pcbnew.PCB_VIA(board)
    via.SetPosition(pos)
    via.SetWidth(mm_to_nm(diameter_mm))
    via.SetDrill(mm_to_nm(drill_mm))
    via.SetNetCode(net_code_val)
    via.SetLayerPair(F_CU, B_CU)
    via.SetViaType(pcbnew.VIATYPE_THROUGH)
    board.Add(via)


def add_zone(board, outline_mm: list[tuple[float, float]],
             net_code_val: int, layer_name: str,
             priority: int = 1,
             min_thickness_mm: float = 0.25):
    """Drop a polygon zone on the given layer for the given net.
    `outline_mm` is a list of (x_mm, y_mm) corners (clockwise).

    The zone is NOT filled here — KiCad fills on save / on Edit→Fill All
    Zones. The polygon outline plus net + layer is enough metadata.
    """
    zone = pcbnew.ZONE(board)
    zone.SetLayer(layer_id(layer_name))
    zone.SetNetCode(net_code_val)
    zone.SetAssignedPriority(priority)
    zone.SetMinThickness(mm_to_nm(min_thickness_mm))
    # Use a clean polygon outline. NewOutline starts a fresh contour;
    # subsequent Append calls add corners.
    outline = zone.Outline()
    outline.NewOutline()
    for x_mm, y_mm in outline_mm:
        outline.Append(mm_to_nm(x_mm), mm_to_nm(y_mm))
    board.Add(zone)
    return zone


def _collect_codes(board, names) -> set:
    out = set()
    for name in names:
        for n in (name, "/" + name):
            nc = net_code(board, n)
            if nc is not None:
                out.add(nc)
    return out


def clear_owned(board) -> int:
    """Remove the script's previous routing without touching 02_route.py's
    matrix-area work.

    Why this is by-geometry instead of by-UUID: KiCad 10 exposes
    `m_Uuid` as read-only, so the prefix-marker trick from older
    KiCads (and from 02_route.py) silently fails. Items would accumulate
    across re-runs. So we identify "our" items by NET + LOCATION instead:

      LED_DATA_5V — entirely ours (02_route.py explicitly skips it).
                    Wipe every track/via on this net.

      +5V_LED      — shared with 02_route.py's row trunks (matrix area).
                    Clear:
                      • all +5V_LED zones (only this script makes any),
                      • tracks/vias in the bottom margin (Y ≥ 314), and
                      • tracks/vias in the left margin (X ≤ 60).
                    02's row trunks at LED Y values (64..316) stay.

      S0..S7, CA..CH — shared with 02_route.py's row sense + column
                    rails. Clear tracks/vias where ANY endpoint is south
                    of the matrix (Y ≥ 304). 02's rails terminate at
                    Y=302.125 so they stay.
    """
    led_data_codes = _collect_codes(board, ["LED_DATA_5V"])
    pwr_codes      = _collect_codes(board, ["+5V_LED"])
    # Only clear C nets the script actually re-lays — leaves hand-
    # routed nets (like Paolo's CA_PWR) intact across re-runs.
    routed_c_letters = [COL_LETTERS[c] for c in C_STARTER_COLS]
    signal_codes   = _collect_codes(
        board,
        [f"S{i}" for i in range(MATRIX_ROWS)]
        + [f"C{c}_PWR" for c in routed_c_letters],
    )

    south_pwr_nm   = mm_to_nm(314.0)   # north edge of bottom +5V zone
    left_pwr_nm    = mm_to_nm(60.0)    # east edge of left +5V zone
    south_sig_nm   = mm_to_nm(304.0)   # south of matrix Hall rank 0

    def pt_in_pwr(pt):
        return pt.y >= south_pwr_nm or pt.x <= left_pwr_nm

    def pt_in_sig(pt):
        return pt.y >= south_sig_nm

    # Collect first, then remove — SWIG's pcbnew bindings lose object
    # types if iteration and Remove() interleave on related lists.
    tracks_to_remove = []
    for track in list(board.GetTracks()):
        nc = track.GetNetCode()
        if isinstance(track, pcbnew.PCB_VIA):
            pos = track.GetPosition()
            owned = (
                nc in led_data_codes
                or (nc in pwr_codes and pt_in_pwr(pos))
                or (nc in signal_codes and pt_in_sig(pos))
            )
        else:
            s, e = track.GetStart(), track.GetEnd()
            owned = (
                nc in led_data_codes
                or (nc in pwr_codes    and (pt_in_pwr(s) or pt_in_pwr(e)))
                or (nc in signal_codes and (pt_in_sig(s) or pt_in_sig(e)))
            )
        if owned:
            tracks_to_remove.append(track)

    # Every +5V_LED zone is ours — 02_route.py doesn't make zones.
    zones_to_remove = [z for z in board.Zones() if z.GetNetCode() in pwr_codes]

    for t in tracks_to_remove:
        board.Remove(t)
    for z in zones_to_remove:
        board.Remove(z)

    return len(tracks_to_remove) + len(zones_to_remove)


# ──────────────────────────────────────────────────────────────────────────────
# Component lookup
# ──────────────────────────────────────────────────────────────────────────────
def hall_ref(col: int, row: int) -> str:
    return f"U{col * MATRIX_ROWS + row + 1}"


DRV5032_OUT = "3"
WS2812_DIN  = "4"

J1_PIN_5V       = ("1", "3", "5", "25")
J1_PIN_LED_DATA = "7"
J1_PIN_S        = {i: str(9 + i)  for i in range(MATRIX_ROWS)}
J1_PIN_COL      = {i: str(17 + i) for i in range(MATRIX_COLS)}
COL_LETTERS     = ["A", "B", "C", "D", "E", "F", "G", "H"]


# ──────────────────────────────────────────────────────────────────────────────
# Route — +5V_LED zone + row-bulk stitching vias
# ──────────────────────────────────────────────────────────────────────────────
def route_5v_zone(board) -> int:
    """Add a B.Cu zone on +5V_LED covering the bottom strip and left margin.
    The single L-shape connects J1's +5V pads (THT, on both layers) and
    every row bulk pin 1 (via the stitching vias added separately)."""
    nc = net_code(board, "/+5V_LED")
    if nc is None:
        nc = net_code(board, "+5V_LED")
    if nc is None:
        print("  WARN: net +5V_LED not found — skipping zone")
        return 0

    add_zone(board, ZONE_BOTTOM_STRIP, nc, "B.Cu", priority=1)
    add_zone(board, ZONE_LEFT_STRIP,   nc, "B.Cu", priority=1)
    return 2


def route_5v_stitching_vias(board) -> int:
    """One small via per row bulk pin 1 — connects F.Cu SMT pad to the
    B.Cu +5V_LED zone. Without these, the row bulks are stranded."""
    nc = net_code(board, "/+5V_LED")
    if nc is None:
        nc = net_code(board, "+5V_LED")
    if nc is None:
        return 0

    n = 0
    for row in range(MATRIX_ROWS + 1):   # C1..C9 — 9 row bulks
        ref = f"C{row + 1}"
        pad = pad_pos(board, ref, "1")
        if pad is None:
            continue
        # Drop the stitching via just inside the bulk's pin 1, offset toward
        # the (open) east side so it's clear of the cap body.
        via_pos = _v(pad.x + mm_to_nm(STITCH_VIA_OFFSET_MM), pad.y)
        add_via(board, via_pos, nc, STITCH_VIA_DIAMETER_MM, STITCH_VIA_DRILL_MM)
        # Plus a tiny F.Cu stub from the pad to the via so KiCad's ratsnest
        # is unambiguous and the via reliably picks up the F.Cu pad too.
        add_track(board, pad, via_pos, nc, "F.Cu", POWER_STUB_WIDTH_MM)
        n += 2
    return n


# ──────────────────────────────────────────────────────────────────────────────
# Route — LED_DATA_5V (J1 pin 7 → D1 DIN)
# ──────────────────────────────────────────────────────────────────────────────
def route_led_data(board) -> int:
    """Single trace. South-row pin → B.Cu jog east → B.Cu lane west to the
    left-margin gap → via to F.Cu → F.Cu climb up the left margin → D1
    DIN. Uses one via."""
    nc = net_code(board, "/LED_DATA_5V") or net_code(board, "LED_DATA_5V")
    if nc is None:
        print("  WARN: net LED_DATA_5V not found — skipping")
        return 0

    j1_pad = pad_pos(board, "J1", J1_PIN_LED_DATA)
    d1_din = pad_pos(board, "D1", WS2812_DIN)
    if j1_pad is None or d1_din is None:
        print("  WARN: J1 pin 7 or D1 DIN missing")
        return 0

    layer  = LAYER_BY_NET["LED_DATA_5V"]
    lane_y = mm_to_nm(LANE_Y["LED_DATA_5V"])
    lane_x = mm_to_nm(LED_DATA_LANE_X)
    jog    = jog_start(j1_pad, "LED_DATA_5V")

    p_lane_in  = _v(jog.x,  lane_y)                 # vertical lands on lane
    p_lane_end = _v(lane_x, lane_y)                 # lane horizontal endpoint

    add_track(board, j1_pad, jog,        nc, layer, SIGNAL_WIDTH_MM)
    add_track(board, jog,    p_lane_in,  nc, layer, SIGNAL_WIDTH_MM)
    add_track(board, p_lane_in, p_lane_end, nc, layer, SIGNAL_WIDTH_MM)
    add_via(board, p_lane_end, nc)

    # F.Cu climb up the left-margin gap (between row bulks at X=54 and
    # LED column 0 at X=64) to D1's DIN.
    p_top = _v(lane_x, d1_din.y)
    add_track(board, p_lane_end, p_top,  nc, "F.Cu", SIGNAL_WIDTH_MM)
    add_track(board, p_top,      d1_din, nc, "F.Cu", SIGNAL_WIDTH_MM)
    return 5


# ──────────────────────────────────────────────────────────────────────────────
# Route — S0..S7 (J1 pins 9..16 → leftmost Hall OUT pad per rank)
# ──────────────────────────────────────────────────────────────────────────────
def route_row_sense(board) -> int:
    """Eight traces.

    Odd S (S0/S2/S4/S6 — south-row J1 pins) on B.Cu:
        J1 pad → 1.5 mm east jog → up to B.Cu lane Y → west to lane X →
        up to via_Y → via to F.Cu → east into leftmost Hall OUT pad.

    Even S (S1/S3/S5/S7 — north-row J1 pins) on F.Cu:
        J1 pad → up to F.Cu lane Y → west to lane X → up to rank Y →
        east into leftmost Hall OUT pad (no via, OUT pad is F.Cu).
    """
    count = 0
    for i in ROUTE_S_INDICES:
        nc = net_code(board, f"/S{i}") or net_code(board, f"S{i}")
        if nc is None:
            continue

        j1_pad  = pad_pos(board, "J1", J1_PIN_S[i])
        out_pad = pad_pos(board, hall_ref(0, i), DRV5032_OUT)
        if j1_pad is None or out_pad is None:
            print(f"  WARN: S{i} endpoints missing")
            continue

        net_label = f"S{i}"
        layer  = LAYER_BY_NET[net_label]
        lane_y = mm_to_nm(LANE_Y[net_label])
        lane_x = mm_to_nm(LANE_X_S_BCU[i] if layer == "B.Cu" else LANE_X_S_FCU[i])
        jog    = jog_start(j1_pad, net_label)

        # Lane segment is on `layer`, regardless of S parity.
        p_lane_in  = _v(jog.x,  lane_y)
        p_lane_end = _v(lane_x, lane_y)

        add_track(board, j1_pad, jog,        nc, layer, SIGNAL_WIDTH_MM)
        add_track(board, jog,    p_lane_in,  nc, layer, SIGNAL_WIDTH_MM)
        add_track(board, p_lane_in, p_lane_end, nc, layer, SIGNAL_WIDTH_MM)

        if layer == "B.Cu":
            # Climb on B.Cu up to via_y, drop to F.Cu, then east on F.Cu
            # to the OUT pad. Vertical at LANE_X_S_BCU (62..65) — east
            # of the +5V_LED zone, west of column A rail (X=76.25).
            via_y = out_pad.y + mm_to_nm(S_VIA_Y_OFFSET_FROM_RANK)
            p_climb_top = _v(lane_x, via_y)
            p_east      = _v(out_pad.x, via_y)
            add_track(board, p_lane_end, p_climb_top, nc, "B.Cu", SIGNAL_WIDTH_MM)
            add_via(board, p_climb_top, nc)
            add_track(board, p_climb_top, p_east,  nc, "F.Cu", SIGNAL_WIDTH_MM)
            add_track(board, p_east,      out_pad, nc, "F.Cu", SIGNAL_WIDTH_MM)
            count += 7
        else:
            # F.Cu all the way — climb the left margin (X=58..61) up to
            # rank Y, then east into OUT pad. No via.
            p_climb_top = _v(lane_x, out_pad.y)
            add_track(board, p_lane_end, p_climb_top, nc, "F.Cu", SIGNAL_WIDTH_MM)
            add_track(board, p_climb_top, out_pad,    nc, "F.Cu", SIGNAL_WIDTH_MM)
            count += 5
    return count


# ──────────────────────────────────────────────────────────────────────────────
# Route — CA..CH (J1 pins 17..24 → southern end of each column rail)
# ──────────────────────────────────────────────────────────────────────────────
def route_col_pwr(board) -> int:
    """Eight traces.

    Odd C (CA/CC/CE/CG — south-row J1 pins) on B.Cu:
        J1 pad → 1.5 mm east jog → up to B.Cu lane Y → east/west to
        rail X → up to (rail_x, rank_0_Y). No via — meets the column
        rail head-on on the same layer.

    Even C (CB/CD/CF/CH — north-row J1 pins) on F.Cu:
        J1 pad → up to F.Cu lane Y → east/west to rail X → up to
        (rail_x, rank_0_Y) → via to B.Cu so it meets the column rail.
    """
    rank0_y_mm = FIRST_HALL_Y_MM + (MATRIX_ROWS - 1) * SQUARE_SIZE_MM   # 302.125
    rank0_y = mm_to_nm(rank0_y_mm)
    count = 0
    for col in range(MATRIX_COLS):
        letter = COL_LETTERS[col]
        nc = net_code(board, f"/C{letter}_PWR") or net_code(board, f"C{letter}_PWR")
        if nc is None:
            continue

        j1_pad = pad_pos(board, "J1", J1_PIN_COL[col])
        leftmost_hall_vdd = pad_pos(board, hall_ref(col, 0), "1")
        if j1_pad is None or leftmost_hall_vdd is None:
            print(f"  WARN: C{letter}_PWR endpoints missing")
            continue
        rail_x = leftmost_hall_vdd.x - mm_to_nm(COL_RAIL_X_OFFSET_MM)

        net_label = f"C{letter}"
        layer  = LAYER_BY_NET[net_label]
        lane_y = mm_to_nm(LANE_Y[net_label])
        jog    = jog_start(j1_pad, net_label)

        p_lane_in  = _v(jog.x,  lane_y)
        p_lane_end = _v(rail_x, lane_y)
        p_rail     = _v(rail_x, rank0_y)

        add_track(board, j1_pad, jog,        nc, layer, COL_RAIL_WIDTH_MM)
        add_track(board, jog,    p_lane_in,  nc, layer, COL_RAIL_WIDTH_MM)
        add_track(board, p_lane_in, p_lane_end, nc, layer, COL_RAIL_WIDTH_MM)
        add_track(board, p_lane_end, p_rail,    nc, layer, COL_RAIL_WIDTH_MM)
        segs = 4
        if layer == "F.Cu":
            # Via at the rail's south endpoint so we land on the
            # B.Cu column rail laid down by 02_route.py.
            add_via(board, p_rail, nc)
            segs += 1
        count += segs
    return count


# ──────────────────────────────────────────────────────────────────────────────
# Route — S "starter" partial traces (S0, S7)
# ──────────────────────────────────────────────────────────────────────────────
def route_s_starters(board) -> int:
    """For each entry in S_STARTERS, plant the pattern from the screenshot:

        Hall OUT pad  ──── F.Cu east ─┐
                                       │ F.Cu south
                                       VIA 1 (F.Cu → B.Cu)
                                       │
                                       │ B.Cu south (long drop)
                                       │
                                       VIA 2 (B.Cu → F.Cu) ← ends here

    Paolo finishes from VIA 2 to the J1 pad by hand.

    Idempotency note: clear_owned() catches segments and vias whose
    endpoints are south of Y=304 — that covers everything except the
    tiny F.Cu jog right at the Hall (Y < 304 for S0 and S7 alike).
    If you re-run this script, delete the duplicate stubs by hand in
    KiCad before re-running.
    """
    count = 0
    for i, (net_label, h_ref) in enumerate(S_STARTERS):
        nc = net_code(board, f"/{net_label}") or net_code(board, net_label)
        if nc is None:
            print(f"  WARN: net {net_label} not found — skipping starter")
            continue
        out_pad = pad_pos(board, h_ref, "3")    # DRV5032FC OUT
        if out_pad is None:
            print(f"  WARN: {h_ref} OUT pad missing — skipping starter")
            continue

        # Hall footprint center X (OUT pad sits +0.9375 mm east of it).
        # Each rank gets its own east-offset so the 8 B.Cu drops sit
        # in 8 parallel lanes instead of all stacking at the same X.
        hall_x = out_pad.x - mm_to_nm(SOT23_OUT_PAD_X_OFFSET_MM)
        lane_e_mm = STARTER_VIA1_E_OFFSET_MM + i * STARTER_LANE_PITCH_MM
        via1_x = hall_x + mm_to_nm(lane_e_mm)
        via1_y = out_pad.y + mm_to_nm(STARTER_VIA1_S_OFFSET_MM)
        end_y  = mm_to_nm(STARTER_END_Y_MM)

        # F.Cu jog: east from OUT pad, then south to via 1
        p_east = _v(via1_x, out_pad.y)
        p_via1 = _v(via1_x, via1_y)
        add_track(board, out_pad, p_east, nc, "F.Cu", SIGNAL_WIDTH_MM)
        add_track(board, p_east, p_via1, nc, "F.Cu", SIGNAL_WIDTH_MM)
        # Via 1: F.Cu → B.Cu
        add_via(board, p_via1, nc)
        # Long B.Cu vertical south
        p_via2 = _v(via1_x, end_y)
        add_track(board, p_via1, p_via2, nc, "B.Cu", SIGNAL_WIDTH_MM)
        # Via 2: B.Cu → F.Cu — Paolo extends from here
        add_via(board, p_via2, nc)
        count += 5
    return count


# ──────────────────────────────────────────────────────────────────────────────
# Route — C "starter" partial traces (B..H column power → J1)
# ──────────────────────────────────────────────────────────────────────────────
def route_c_starters(board) -> int:
    """One B.Cu trace per column in C_STARTER_COLS. Each:

        (col_rail_x, rank_0_Y)  ── B.Cu south ─┐
                                                │
                                                ├──── B.Cu east/west ────┐
                                                                          │
                                                                          ├── B.Cu south
                                                                          │
                                                                       J1 pad

    The starting point is the south end of 02_route.py's column rail
    (which lives at `leftmost_hall.x - COL_RAIL_X_OFFSET_MM`). Each
    column gets a unique horizontal lane Y so the 7 traces don't
    overlap in the bottom margin.

    Lands directly on the J1 pad. CA is skipped — Paolo hand-routed it.
    """
    rank0_y_mm = FIRST_HALL_Y_MM + (MATRIX_ROWS - 1) * SQUARE_SIZE_MM   # 302.125
    rank0_y    = mm_to_nm(rank0_y_mm)
    count = 0
    for col in C_STARTER_COLS:
        letter = COL_LETTERS[col]
        nc = net_code(board, f"/C{letter}_PWR") or net_code(board, f"C{letter}_PWR")
        if nc is None:
            print(f"  WARN: net C{letter}_PWR not found — skipping starter")
            continue

        leftmost_hall_vdd = pad_pos(board, hall_ref(col, 0), "1")
        j1_pad            = pad_pos(board, "J1", J1_PIN_COL[col])
        if leftmost_hall_vdd is None or j1_pad is None:
            print(f"  WARN: C{letter}_PWR endpoints missing")
            continue

        rail_x = leftmost_hall_vdd.x - mm_to_nm(COL_RAIL_X_OFFSET_MM)
        lane_y = mm_to_nm(C_STARTER_LANE_Y_MM[col])

        # B.Cu south from column rail's south end to the lane Y
        p_rail_end  = _v(rail_x, rank0_y)
        p_lane_pre  = _v(rail_x, lane_y)
        # B.Cu east/west to J1 pad X, then south into the pad
        p_lane_post = _v(j1_pad.x, lane_y)

        add_track(board, p_rail_end,  p_lane_pre,  nc, "B.Cu", COL_RAIL_WIDTH_MM)
        add_track(board, p_lane_pre,  p_lane_post, nc, "B.Cu", COL_RAIL_WIDTH_MM)
        add_track(board, p_lane_post, j1_pad,      nc, "B.Cu", COL_RAIL_WIDTH_MM)
        count += 3
    return count


# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────
def clear_only() -> int:
    """Sub-mode for clearing only — invoked via subprocess so the parent
    process gets a clean BOARD on its next LoadBoard."""
    b = pcbnew.LoadBoard(str(BOARD_PATH))
    n = clear_owned(b)
    b.Save(str(BOARD_PATH))
    print(f"Cleared {n} previously-owned tracks/vias/zones.")
    return 0


def main() -> int:
    if "--clear-only" in sys.argv:
        return clear_only()

    if not BOARD_PATH.exists():
        print(f"ERROR: PCB not found at {BOARD_PATH}", file=sys.stderr)
        return 1

    backup = BOARD_PATH.with_suffix(".kicad_pcb.backup_before_03_route_j1")
    backup.write_bytes(BOARD_PATH.read_bytes())
    print(f"Backup: {backup.name}")

    # Clear in a subprocess to dodge a SWIG binding bug: after we Remove
    # items in this process and save/reload, pcbnew returns untyped
    # SwigPyObjects from FindNet/Zones — only a fresh Python process
    # gets a clean BOARD back. Cost is one fork + reload (~1 s on the
    # M-series Mac).
    import subprocess
    r = subprocess.run(
        [sys.executable, str(HERE / "03_route_j1.py"), "--clear-only"],
        capture_output=True, text=True,
    )
    print(r.stdout.strip())
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        return r.returncode
    # Re-load post-clear in this process; this load is clean.
    board = pcbnew.LoadBoard(str(BOARD_PATH))
    print()

    n_zone       = route_5v_zone(board)           if ROUTE_5V_ZONE    else 0
    n_stitch     = route_5v_stitching_vias(board) if ROUTE_5V_STITCH  else 0
    n_data       = route_led_data(board)          if ROUTE_LED_DATA   else 0
    n_sense      = route_row_sense(board)         if ROUTE_S_NETS     else 0
    n_col        = route_col_pwr(board)           if ROUTE_C_NETS     else 0
    n_s_start    = route_s_starters(board)        if ROUTE_S_STARTERS else 0
    n_c_start    = route_c_starters(board)        if ROUTE_C_STARTERS else 0

    def status(enabled): return "" if enabled else "  (disabled)"
    print(f"\nRouted:")
    print(f"  +5V_LED B.Cu zones         : {n_zone:>4}{status(ROUTE_5V_ZONE)}")
    print(f"  +5V_LED stitching vias     : {n_stitch:>4}{status(ROUTE_5V_STITCH)}")
    print(f"  LED_DATA_5V (J1 → D1)      : {n_data:>4}{status(ROUTE_LED_DATA)}")
    print(f"  S0..S7 row sense fanouts   : {n_sense:>4}{status(ROUTE_S_NETS)}")
    print(f"  CA..CH column power fanouts: {n_col:>4}{status(ROUTE_C_NETS)}")
    print(f"  S starters (8 lanes)       : {n_s_start:>4}{status(ROUTE_S_STARTERS)}")
    print(f"  C starters (B..H → J1)     : {n_c_start:>4}{status(ROUTE_C_STARTERS)}")
    print(f"  TOTAL                      : {n_zone+n_stitch+n_data+n_sense+n_col+n_s_start+n_c_start:>4}")
    print()
    print("In KiCad: open the board, run Edit → Fill All Zones (B), then run DRC.")
    print("Expect clearance warnings if the user-added GND zone hasn't been placed yet.")

    board.Save(str(BOARD_PATH))
    print(f"\nSaved: {BOARD_PATH.name}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
