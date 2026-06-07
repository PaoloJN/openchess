"""
OpenChess controller — PCB component placement script.

Gives you a clean, compact starting layout for the controller board. You
edit the LAYOUT dict at the top, re-run, see the result, repeat.

HOW TO RUN
----------

Option A — inside KiCad (recommended while iterating):

    1. Open hardware/hardware-controller/openchess-controller.kicad_pcb
       in KiCad's PCB Editor.
    2. Tools → Scripting Console (or press the terminal icon).
    3. In the console:
         exec(open('/Users/paolonessim/Projects/openchess/hardware/hardware-controller/scripts/pcb/place_components.py').read())
    4. Components snap to their new positions. Inspect, then File → Save
       if you like it.

Option B — standalone (one-shot):

    cd hardware/hardware-controller
    python3 scripts/pcb/place_components.py
    # the script writes openchess-controller.kicad_pcb in place.

LAYOUT PHILOSOPHY
-----------------

Board is 80 × 95 mm, organized into 4 horizontal zones:

    y = 0  ┌──────────────────────────────────────────┐
           │ MH1                                  MH2 │
    y = 8  ├──────────────────────────────────────────┤
           │ POWER ZONE                               │
           │   M1 (Lipo Rider Plus)  USB-C at left    │
           │   C1 C2 bulk caps · D2 Schottky          │
           │   R14 R15 C12 (battery monitor divider)  │
    y = 40 ├──────────────────────────────────────────┤
           │ CPU ZONE                                 │
           │   U2 (ESP32-DevKitC socket, horizontal)  │
           │   µUSB end at right edge for programming │
    y = 72 ├──────────────────────────────────────────┤
           │ INTERFACE ZONE                           │
           │   U6 (col driver) U3 (level shifter)     │
           │   R1..R8 row pullups · R11               │
           │   R36 R37 button pullups · J3 (JST XH)   │
    y = 87 ├──────────────────────────────────────────┤
           │ MH3                                  MH4 │
    y = 95 └──────────────────────────────────────────┘

    J1 (J_MAIN, 2×13 IDC) lives on the BOTTOM layer, centered under the
    CPU zone, so it mates with J_CTRL on the matrix PCB sitting above.

Each component's (x, y) is its CENTER in mm. Tweak any number, re-run.
Components that aren't in LAYOUT keep their current position.
"""

import os
import sys

try:
    import pcbnew
except ImportError:
    sys.exit("pcbnew module not found — run inside KiCad's Scripting Console "
             "or with the python that ships with KiCad.")


# ============================================================================
# CONFIG
# ============================================================================

# Path to the controller board. Used only in standalone mode (Option B).
# In KiCad console mode the currently open board is used.
HERE = os.path.dirname(os.path.abspath(__file__))
BOARD_PATH = os.path.normpath(os.path.join(HERE, "..", "..", "openchess-controller.kicad_pcb"))

# Board outline (mm). Drawn automatically on Edge.Cuts if DRAW_OUTLINE = True.
# Sized for the ESP32-DevKitC (~54 mm wide when horizontal), M1 (~46×26 mm),
# J_MAIN (~34 mm horizontal) and J_PANEL (~26 mm horizontal).
BOARD_W = 95.0
BOARD_H = 105.0
DRAW_OUTLINE = True

# If True, each (x, y) is interpreted as the desired CENTER of the footprint's
# bounding box. We compensate for the footprint's anchor (usually pin 1) by
# measuring the post-rotation bbox and shifting the anchor so the body center
# lands at the target. Leave True — it's what makes the layout sensible.
CENTER_ON_BBOX = True


# ============================================================================
# LAYOUT
# ============================================================================
#
# Each entry: refdes → { pos: (x_mm, y_mm), rot: deg, side: "top" | "bottom" }
#
# (x, y) is the component CENTER. Origin (0, 0) is top-left of the board.
# rot is degrees CCW. side flips the footprint to the bottom copper layer.

LAYOUT = {
    # ----------------- MOUNTING (corners, M3) ----------------------------
    "MH1": {"pos": (5,         5),         "rot": 0,   "side": "top"},
    "MH2": {"pos": (BOARD_W-5, 5),         "rot": 0,   "side": "top"},
    "MH3": {"pos": (5,         BOARD_H-5), "rot": 0,   "side": "top"},
    "MH4": {"pos": (BOARD_W-5, BOARD_H-5), "rot": 0,   "side": "top"},

    # ----------------- POWER ZONE (y = 12 .. 42) -------------------------
    # M1 Lipo Rider Plus (~46 × 26 mm). Long axis horizontal. USB-C on
    # the left short edge → faces the LEFT side of the board so the
    # panel-mount extension cable can reach the enclosure wall.
    "M1":  {"pos": (28, 28),  "rot": 0,   "side": "top"},

    # Bulk caps on +5V_LED, just to the right of M1's 5 V output.
    "C1":  {"pos": (58, 18),  "rot": 0,   "side": "top"},
    "C2":  {"pos": (63, 18),  "rot": 0,   "side": "top"},

    # D2 SS14 Schottky: anode on +5V_LED, cathode to DevKit pin 19.
    "D2":  {"pos": (70, 22),  "rot": 0,   "side": "top"},

    # Battery monitor divider on M1 pin 6 (BAT) → VBAT_MON → GPIO34.
    "R14": {"pos": (58, 33),  "rot": 0,   "side": "top"},
    "R15": {"pos": (63, 33),  "rot": 0,   "side": "top"},
    "C12": {"pos": (70, 33),  "rot": 0,   "side": "top"},

    # ----------------- CPU ZONE (y = 48 .. 76) ---------------------------
    # ESP32-DevKitC v4 in a 2 × 19 socket pair. The footprint is naturally
    # tall (28.5 × 54 mm), so we rotate 90° → 54 × 28.5 mm horizontal.
    # µUSB end is at one of the short edges; tweak rot (90 vs 270) if it
    # comes out facing the wrong way.
    "U2":  {"pos": (45, 62),  "rot": 90,  "side": "top"},

    # ----------------- INTERFACE ZONE (y = 80 .. 100) --------------------
    # J1 (J_MAIN, 2 × 13 keyed IDC) on the BOTTOM layer, rotated horizontal
    # so its 34 mm long axis lies along X. Mates with J_CTRL on the matrix
    # PCB sitting above (board-to-board stack).
    "J1":  {"pos": (45, 81),  "rot": 90,  "side": "bottom"},

    # U6 TBD62783A column driver — DIP-18, naturally ~23 mm tall. Rotate
    # 90° so it lies horizontal. Outputs drop straight down into J1 below.
    "U6":  {"pos": (16, 90),  "rot": 90,  "side": "top"},
    "C11": {"pos": (16, 99),  "rot": 0,   "side": "top"},

    # U3 74AHCT125 level shifter — small enough to leave at rot 0.
    "U3":  {"pos": (33, 89),  "rot": 0,   "side": "top"},
    "C5":  {"pos": (33, 96),  "rot": 0,   "side": "top"},
    "R11": {"pos": (39, 89),  "rot": 0,   "side": "top"},

    # R1..R8 row pullups — tight 2 × 4 grid, between U3 and J_PANEL pullups.
    "R1":  {"pos": (44, 86),  "rot": 0,   "side": "top"},
    "R2":  {"pos": (44, 89),  "rot": 0,   "side": "top"},
    "R3":  {"pos": (44, 92),  "rot": 0,   "side": "top"},
    "R4":  {"pos": (44, 95),  "rot": 0,   "side": "top"},
    "R5":  {"pos": (47, 86),  "rot": 0,   "side": "top"},
    "R6":  {"pos": (47, 89),  "rot": 0,   "side": "top"},
    "R7":  {"pos": (47, 92),  "rot": 0,   "side": "top"},
    "R8":  {"pos": (47, 95),  "rot": 0,   "side": "top"},

    # Button pullups close to J_PANEL.
    "R36": {"pos": (51, 87),  "rot": 0,   "side": "top"},
    "R37": {"pos": (51, 93),  "rot": 0,   "side": "top"},

    # J3 (J_PANEL, JST XH 10) — horizontal (rot 90 because this footprint's
    # natural orientation is vertical). Centered so it clears MH4 in x.
    # Harness exits toward the enclosure side wall.
    "J3":  {"pos": (68, 90),  "rot": 90,  "side": "top"},
}


# ============================================================================
# IMPLEMENTATION
# ============================================================================

def mm(x, y):
    """Convert (x_mm, y_mm) → KiCad internal VECTOR2I."""
    return pcbnew.VECTOR2I(pcbnew.FromMM(float(x)), pcbnew.FromMM(float(y)))


def place(board, ref, x, y, rot_deg, side):
    fp = board.FindFootprintByReference(ref)
    if fp is None:
        print(f"  WARN: {ref:5s} not found in board — skipped")
        return False

    # 1. flip to the target side first (so bbox reflects final geometry)
    on_back = fp.GetLayer() == pcbnew.B_Cu
    want_back = (side == "bottom")
    if on_back != want_back:
        fp.Flip(fp.GetPosition(), False)  # mirror around Y axis (X flip)

    # 2. rotate
    fp.SetOrientationDegrees(float(rot_deg))

    # 3. move anchor to the requested target, then adjust so the BODY CENTER
    #    (not the pin-1 anchor) lands at the target. Use the footprint's
    #    bounding box for "body center".
    target = mm(x, y)
    fp.SetPosition(target)

    if CENTER_ON_BBOX:
        bbox = fp.GetBoundingBox(False, False)  # exclude text
        bbox_center = bbox.GetCenter()
        anchor = fp.GetPosition()
        # Body is currently centered at bbox_center, anchor is at `target`.
        # Shift anchor by (target - bbox_center) so body center reaches target.
        dx = target.x - bbox_center.x
        dy = target.y - bbox_center.y
        fp.SetPosition(pcbnew.VECTOR2I(anchor.x + dx, anchor.y + dy))

    # actual final body-center, for the log line
    final_bbox = fp.GetBoundingBox(False, False)
    fc = final_bbox.GetCenter()
    fcx_mm = pcbnew.ToMM(fc.x)
    fcy_mm = pcbnew.ToMM(fc.y)
    w_mm = pcbnew.ToMM(final_bbox.GetWidth())
    h_mm = pcbnew.ToMM(final_bbox.GetHeight())

    print(f"  OK   {ref:5s}  body center ({fcx_mm:5.1f}, {fcy_mm:5.1f})  "
          f"size {w_mm:4.1f}×{h_mm:4.1f}  rot {rot_deg:>3}°  {side}")
    return True


def draw_outline(board, w, h):
    """Replace any existing Edge.Cuts segments with a clean W×H rectangle."""
    edge_layer = pcbnew.Edge_Cuts
    to_remove = []
    for drawing in board.GetDrawings():
        if drawing.GetLayer() == edge_layer:
            to_remove.append(drawing)
    for d in to_remove:
        board.Remove(d)

    corners = [(0, 0), (w, 0), (w, h), (0, h), (0, 0)]
    for (x1, y1), (x2, y2) in zip(corners, corners[1:]):
        seg = pcbnew.PCB_SHAPE(board)
        seg.SetShape(pcbnew.SHAPE_T_SEGMENT)
        seg.SetStart(mm(x1, y1))
        seg.SetEnd(mm(x2, y2))
        seg.SetLayer(edge_layer)
        seg.SetWidth(pcbnew.FromMM(0.15))
        board.Add(seg)
    print(f"  Edge.Cuts rectangle drawn: {w} × {h} mm")


def main():
    running_in_kicad = (pcbnew.GetBoard() is not None
                        and pcbnew.GetBoard().GetFileName() != "")

    if running_in_kicad:
        board = pcbnew.GetBoard()
        print(f"Using open board: {board.GetFileName()}")
    else:
        print(f"Loading board from disk: {BOARD_PATH}")
        if not os.path.isfile(BOARD_PATH):
            sys.exit(f"  board file not found: {BOARD_PATH}")
        board = pcbnew.LoadBoard(BOARD_PATH)

    print()
    if DRAW_OUTLINE:
        print("Drawing board outline:")
        draw_outline(board, BOARD_W, BOARD_H)
        print()

    print("Placing components:")
    placed = 0
    for ref, conf in LAYOUT.items():
        x, y = conf["pos"]
        if place(board, ref, x, y, conf["rot"], conf["side"]):
            placed += 1
    print(f"\n{placed}/{len(LAYOUT)} components placed.")

    if running_in_kicad:
        pcbnew.Refresh()
        print("\nDone. Review in KiCad and File → Save when happy.")
    else:
        pcbnew.SaveBoard(BOARD_PATH, board)
        print(f"\nBoard saved: {BOARD_PATH}")


if __name__ == "__main__" or True:
    main()
