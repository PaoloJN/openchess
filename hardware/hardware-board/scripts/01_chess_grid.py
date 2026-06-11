#!/usr/bin/env python3
"""
01_chess_grid.py — front-side chess grid for the matrix board.

Places on the F.Cu / F.SilkS layer:
  - 64 A3144 hall sensors U1..U64 at chess square centers
      (A1 bottom-left, H8 top-right; U{1 + file*8 + rank})
  - 81 WS2812B LEDs D1..D81 at the 9x9 grid corners, raster (row-major) order
      (D1 top-left, D9 top-right, D10 row-1 left, ..., D81 bottom-right).
      Physical chain routing on the PCB is up to the routing script — refs
      here just match the schematic numbering.
  - 81 100 nF decoupling caps C10..C90, one per LED, number-matched
      (D1↔C10, D2↔C11, ..., D81↔C90), placed `LED_CAP_OFFSET_MM` to the
      right of their LED.
  - 4 M3 mounting holes H1..H4 at the board corners (real drilled holes —
      the silk circles below are just decorative outlines around them).
  - 3 fiducials FID1..FID3 in an asymmetric triangle for JLC's PnP camera.
  - Board outline rectangle on Edge.Cuts
  - Optional silkscreen decorations (toggleable):
      * A1..H8 square labels under each hall sensor
      * 8x8 chess grid lines
      * File (A-H) labels along the bottom, rank (1-8) labels along the left
      * Title block (project name + author + revision)
      * WHITE / BLACK cardinal labels
      * Mounting hole markers at the four corners

IDEMPOTENT — safe to re-run. Owned items (board outline, silk text, silk lines,
silk circles) are tracked by UUID prefix from lib_layout's marker registry; a
re-run removes the previous ones before laying the new ones down.

PREREQUISITE — openchess-board.kicad_pcb must exist. Generate it via:
  1. Open openchess-board.kicad_pro in KiCad.
  2. Open the PCB editor (Pcbnew). On first open it will be empty.
  3. File -> Update PCB from Schematic (F8). Accept defaults. Save.
  4. Close KiCad.
This script then repositions every U/D footprint to its grid coordinate.

Run with KiCad CLOSED.
"""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import lib_layout as ll  # noqa: E402


# ──────────────────────────────────────────────────────────────────────────────
# Geometry — change these to resize the board
# ──────────────────────────────────────────────────────────────────────────────
SQUARE_SIZE  = 31.75     # mm per chess square — = 1.25 in (10 in ÷ 8).
                         # Matches the actual wood squares on Paolo's
                         # folding board, which has a 10×10 in playing area
                         # = 254 × 254 mm of chess squares.
                         # (Was 32 originally; tried 30 on 2026-06-10 before
                         # Paolo measured the board and confirmed 1.25 in.)
BOARD_MARGIN = 14        # mm from outermost chess square corner to PCB edge.
                         # Trimmed from 18→14 on 2026-06-10 to fit the
                         # folding board's inner-frame cavity. Total board
                         # size now 282×282 mm (8 × 31.75 + 2 × 14).
                         #
                         # IMPORTANT: keep SQUARE_SIZE_MM and BOARD_MARGIN_MM
                         # in scripts/02_route.py in sync with these values.
                         # The routing script has its own copies that need
                         # to match for the row-sense lane geometry to land
                         # correctly between Hall rows.

# Matrix dimensions — 8×8 full board. Locked by scripts/sch/config.py.
MATRIX_COLS = 8
MATRIX_ROWS = 8
LED_COLS = MATRIX_COLS + 1   # 9
LED_ROWS = MATRIX_ROWS + 1   # 9


# ──────────────────────────────────────────────────────────────────────────────
# Silkscreen toggles
# ──────────────────────────────────────────────────────────────────────────────
DRAW_SQUARE_LABELS         = True
DRAW_CHESS_GRID            = True
DRAW_FILE_RANK_LABELS      = True
DRAW_TITLE_BLOCK           = True
DRAW_CARDINAL_LABELS       = True
DRAW_MOUNTING_HOLE_MARKERS = True


# ──────────────────────────────────────────────────────────────────────────────
# Style
# ──────────────────────────────────────────────────────────────────────────────
LABEL_FONT_SIZE      = 1.5
LABEL_FONT_WIDTH     = 0.25
LABEL_Y_OFFSET       = 5      # mm below sensor for the A1..H8 silk label

TITLE_TEXT           = "OpenChess — Matrix Board"
TITLE_AUTHOR         = "Paolo Nessim"
TITLE_VERSION        = "Rev 0.1"
TITLE_FONT_SIZE      = 2.0

FILE_LABEL_FONT_SIZE = 2.5
RANK_LABEL_FONT_SIZE = 2.5
CARDINAL_FONT_SIZE   = 3.0

GRID_LINE_WIDTH      = 0.15
MOUNTING_HOLE_INSET  = 6      # mm from board corner to hole center
MOUNTING_HOLE_DIAMETER = 3.2  # M3

# Per-LED 100 nF decoupling cap offset from its LED center, in mm.
# WS2812B PLCC4 footprint: east pads (DOUT/VSS) east edge at LED.x + 3.2.
# 0805 HandSolder cap rotated 270°: body half-width 0.625 mm, pad
# half-width 0.725 mm. At LED_CAP_OFFSET_MM[0] = 5.5, cap pin 1 west
# edge sits at LED.x + 5.5 − 0.725 ≈ LED.x + 4.78, giving ~1.5 mm
# pad-to-pad clearance to the LED's east pads — closer than the
# earlier 7.5 mm (was ~3.5 mm gap, too roomy per Paolo on 2026-06-11).
LED_CAP_OFFSET_MM = (5.5, 0.0)
LED_CAP_ROTATION  = 270.0  # pin 1 (+5V_LED) on top, pin 2 (GND) on bottom

# Row bulk caps (47 µF, 1206 SMD). One per LED row, placed ABOVE the
# leftmost LED of that row (C1↔D1, C2↔D10, ..., C9↔D73). The cap's
# pin 1 (+5V_LED) shares the same X as the LED's VDD pad and sits
# `ROW_BULK_PIN1_ABOVE_LED_VDD_MM` north of it so the body clears the
# LED footprint entirely.
#
# Rotation 0° = horizontal, pin 1 on the WEST end (was 180° on
# 2026-06-11 morning, which placed the cap WEST of the LED with pads
# overlapping — Paolo wanted the cap stacked above instead).
ROW_BULK_ROTATION = 0.0

# KiCad library offsets used to position the cap relative to the LED.
# Pulled from LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm and
# Capacitor_SMD:C_1206_3216Metric. If you change footprints, update these.
WS2812_VDD_PAD_OFFSET_MM = (-2.45, -1.65)   # pad 1 offset from LED center
C1206_PAD1_OFFSET_MM     = (-1.475, 0.0)    # pad 1 offset from cap center at rot=0°

# Vertical gap (mm) between the cap's pin 1 and the LED's VDD pad. The
# 1206 body half-height is 0.8 mm and the WS2812B body top edge sits
# 2.5 mm north of LED center, so anything ≥ ~3.5 mm keeps the cap body
# entirely clear of the LED footprint. 5 mm gives a comfortable margin.
ROW_BULK_PIN1_ABOVE_LED_VDD_MM = 5.0

# J1 (= J_CTRL) — 2×13 female socket on B.Cu (matrix back face).
# Placed at the center of the bottom edge so the controller PCB mounts
# directly beneath the matrix.
#
# Two transforms applied:
#   1. FLIP — layer = "B.Cu" puts the connector on the back face. KiCad
#      auto-mirrors the footprint horizontally (L↔R) when on B.Cu, so pin 1
#      ends up on the opposite physical side from where 0°/F.Cu would put it.
#   2. ROTATE — the KiCad PinSocket_2x13 footprint has its LONG AXIS along Y
#      at 0° rotation (i.e. "tall and skinny"). For a horizontal placement at
#      the bottom edge, we rotate 90° so the long axis lies along X
#      (~33 mm wide × ~5 mm tall — fits cleanly in the 18 mm bottom margin).
#
# Note (2026-06-09): the paper-fit test on the 3×3 showed that the rows on
# the script-placed J1 are swapped vs the controller's after-flip view. The
# fix is to manually MIRROR J1 in KiCad's PCB editor after this script runs
# (right-click J1 → Mirror → Around X Axis). The script intentionally leaves
# the placement un-mirrored; the manual mirror persists in the .kicad_pcb
# between script runs.
J1_REF                  = "J1"
J1_LAYER                = "B.Cu"   # back face → controller goes underneath
J1_Y_FROM_BOTTOM_EDGE   = 3.5      # mm from board bottom edge to connector center.
                                   # 9 → 5 → 3.5 on 2026-06-11. At 3.5 mm,
                                   # J1 center sits at Y=328.5 (board edge
                                   # Y=332). Body half-height ~2.5 mm → ~1 mm
                                   # body-to-edge clearance (fab-safe). Pads
                                   # land at Y=327.2 / 329.8 → ~2.2 mm pad-
                                   # to-edge. ABOVE J1 there's now ~11 mm of
                                   # routing space up to the bottom LED row
                                   # at Y=316 — enough to fan all 26 pins out
                                   # without crossing the LED grid.
J1_ROTATION             = 90.0     # 90° = horizontal (long axis along X);
                                   # try 270° if pin 1 ends up on the wrong end


# ──────────────────────────────────────────────────────────────────────────────
# Mechanical: M3 mounting holes + fiducials
# ──────────────────────────────────────────────────────────────────────────────
# H1..H4 — 3.2 mm M3 clearance holes at the 4 board corners, drilled by the
# fab. The matrix board bolts into the wooden folding-board frame through
# these; they also carry the controller's weight via the J_MAIN/J_CTRL mate.
# Refs come from sch/07_mech.py; placement here matches MOUNTING_HOLE_INSET
# so the silk circles emitted above sit AROUND the actual holes.
MOUNTING_HOLE_REFS = ("H1", "H2", "H3", "H4")   # TL, TR, BL, BR

# FID1..FID3 — JLC PCBA fiducials (1 mm copper pad + 2 mm mask opening).
# Asymmetric triangle so the pick-and-place camera can pin down board
# orientation. FID1/FID2 sit in the top margin (different X offsets from
# the centerline → not mirror-symmetric); FID3 sits in the bottom-right
# margin between J1 (centered) and the BR mounting hole. All three are
# safely outside the LED grid and clear of caps/connectors.
FIDUCIAL_REFS = ("FID1", "FID2", "FID3")
FIDUCIAL_INSET_FROM_EDGE = 6.0     # mm — fiducial center to nearest board edge


# ──────────────────────────────────────────────────────────────────────────────
# Derived geometry — do not edit
# ──────────────────────────────────────────────────────────────────────────────
BOARD_ORIGIN_X, BOARD_ORIGIN_Y = ll.board_origin()    # (50, 50)
LED_GRID_SIZE = MATRIX_COLS * SQUARE_SIZE             # 256
BOARD_SIZE = LED_GRID_SIZE + 2 * BOARD_MARGIN         # 280

LED_ORIGIN_X = BOARD_ORIGIN_X + BOARD_MARGIN          # 62
LED_ORIGIN_Y = BOARD_ORIGIN_Y + BOARD_MARGIN          # 62

CHESS_X_LEFT   = LED_ORIGIN_X
CHESS_X_RIGHT  = LED_ORIGIN_X + LED_GRID_SIZE
CHESS_Y_TOP    = LED_ORIGIN_Y
CHESS_Y_BOTTOM = LED_ORIGIN_Y + LED_GRID_SIZE

BACKUP_SUFFIX = ".backup_before_01_chess_grid"


# ──────────────────────────────────────────────────────────────────────────────
# Position helpers
# ──────────────────────────────────────────────────────────────────────────────
def hall_position(file_idx: int, rank_idx: int) -> tuple[float, float]:
    """(x, y) for a hall sensor. file 0..7 = A..H, rank 0..7 = 1..8.
    Rank 1 sits at the BOTTOM of the PCB (Y is +down)."""
    x = LED_ORIGIN_X + 0.5 * SQUARE_SIZE + file_idx * SQUARE_SIZE
    y = LED_ORIGIN_Y + (MATRIX_ROWS - 0.5) * SQUARE_SIZE - rank_idx * SQUARE_SIZE
    return x, y


def hall_ref(file_idx: int, rank_idx: int) -> str:
    """U1..U64 — must match scripts/sch_gen.py and scripts/sch/02_halls.py."""
    return f"U{1 + file_idx * MATRIX_ROWS + rank_idx}"


def square_name(file_idx: int, rank_idx: int) -> str:
    return f"{chr(ord('A') + file_idx)}{rank_idx + 1}"


def led_position(col: int, row: int) -> tuple[float, float]:
    """LED at the (col, row) grid corner. col 0..8 left→right, row 0..8 top→bottom."""
    return (LED_ORIGIN_X + col * SQUARE_SIZE,
            LED_ORIGIN_Y + row * SQUARE_SIZE)


def _led_chain_idx(col: int, row: int) -> int:
    """0..80, raster order. MUST match scripts/sch/geometry.py:led_chain_index."""
    return row * LED_COLS + col


def led_ref(col: int, row: int) -> str:
    """D1..D81 — raster (row-major) order, D1=top-left, D81=bottom-right.
    MUST match scripts/sch/geometry.py:led_ref."""
    return f"D{_led_chain_idx(col, row) + 1}"


def led_cap_ref(col: int, row: int) -> str:
    """C10..C90 — one per LED, number-matched (D1↔C10, ..., D81↔C90).
    MUST match scripts/sch/geometry.py:led_cap_ref."""
    return f"C{_led_chain_idx(col, row) + 10}"


def led_cap_position(col: int, row: int) -> tuple[float, float]:
    lx, ly = led_position(col, row)
    return lx + LED_CAP_OFFSET_MM[0], ly + LED_CAP_OFFSET_MM[1]


def row_bulk_ref(row_idx: int) -> str:
    """C1..C{LED_ROWS} — one 47 µF bulk cap per LED row."""
    return f"C{row_idx + 1}"


def row_bulk_position(row_idx: int) -> tuple[float, float]:
    """Place each row bulk ABOVE its leftmost LED.

    Pin 1 lines up in X with the LED's VDD pad and sits
    ROW_BULK_PIN1_ABOVE_LED_VDD_MM mm above (smaller Y = north).
    The cap body extends west of pin 1 (rot=0°), entirely north of the
    LED footprint.
    """
    led_x, led_y = led_position(0, row_idx)
    pin1_x = led_x + WS2812_VDD_PAD_OFFSET_MM[0]
    pin1_y = led_y + WS2812_VDD_PAD_OFFSET_MM[1] - ROW_BULK_PIN1_ABOVE_LED_VDD_MM
    cap_x = pin1_x - C1206_PAD1_OFFSET_MM[0]
    cap_y = pin1_y - C1206_PAD1_OFFSET_MM[1]
    return cap_x, cap_y


def mounting_hole_positions() -> list[tuple[str, float, float]]:
    """(ref, x, y) for the 4 corner M3 holes. Inset MOUNTING_HOLE_INSET
    from each board corner. Order: TL, TR, BL, BR (matches MOUNTING_HOLE_REFS)."""
    inset = MOUNTING_HOLE_INSET
    return [
        (MOUNTING_HOLE_REFS[0], BOARD_ORIGIN_X + inset,              BOARD_ORIGIN_Y + inset),
        (MOUNTING_HOLE_REFS[1], BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + inset),
        (MOUNTING_HOLE_REFS[2], BOARD_ORIGIN_X + inset,              BOARD_ORIGIN_Y + BOARD_SIZE - inset),
        (MOUNTING_HOLE_REFS[3], BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + BOARD_SIZE - inset),
    ]


def fiducial_positions() -> list[tuple[str, float, float]]:
    """(ref, x, y) for the 3 fiducials. Asymmetric triangle:
      FID1 in the TOP margin, left of center.
      FID2 in the TOP margin, right of center, with a different X offset
           from the centerline than FID1 so the pair isn't mirror-symmetric.
      FID3 in the BOTTOM-RIGHT margin, between J1 and the BR mounting hole.
    """
    fy_top    = BOARD_ORIGIN_Y + FIDUCIAL_INSET_FROM_EDGE
    fy_bottom = BOARD_ORIGIN_Y + BOARD_SIZE - FIDUCIAL_INSET_FROM_EDGE
    return [
        (FIDUCIAL_REFS[0], BOARD_ORIGIN_X + 50.0,               fy_top),
        (FIDUCIAL_REFS[1], BOARD_ORIGIN_X + BOARD_SIZE - 70.0,  fy_top),
        (FIDUCIAL_REFS[2], BOARD_ORIGIN_X + BOARD_SIZE - 50.0,  fy_bottom),
    ]


def j1_position() -> tuple[float, float]:
    """J1 (J_CTRL) at the center of the bottom edge of the matrix board.

    KiCad's PinSocket_2x13_P2.54mm_Vertical footprint anchor sits AT pin 1
    (not at the body center). At rotation=90°, pin 1 lands at the anchor X
    and the rest of the 30.48 mm body extends in +X. So if we placed the
    anchor at the true board center, the BODY would end up offset to the
    right by half its length. Compensate by shifting the anchor LEFT by
    half the body length so the geometric center of the body lands at the
    board's X center.
    """
    board_center_x = BOARD_ORIGIN_X + BOARD_SIZE / 2.0
    # 2×13 body length = 12 pitches × 2.54 mm = 30.48 mm; half = 15.24 mm
    body_half_length = 12 * 2.54 / 2.0
    x = board_center_x - body_half_length
    y = BOARD_ORIGIN_Y + BOARD_SIZE - J1_Y_FROM_BOTTOM_EDGE
    return x, y


# ──────────────────────────────────────────────────────────────────────────────
# S-expression builders for owned silkscreen / outline items
# ──────────────────────────────────────────────────────────────────────────────
def make_board_outline(x: float, y: float, w: float, h: float) -> str:
    return (
        "\t(gr_rect\n"
        f"\t\t(start {x} {y})\n"
        f"\t\t(end {x + w} {y + h})\n"
        "\t\t(stroke (width 0.15) (type solid))\n"
        "\t\t(fill no)\n"
        '\t\t(layer "Edge.Cuts")\n'
        f'\t\t(uuid "{ll.make_uuid(ll.MARKER_OUTLINE)}")\n'
        "\t)\n"
    )


def make_silk_text(
    text: str, x: float, y: float,
    font_size: float = LABEL_FONT_SIZE,
    font_width: float = LABEL_FONT_WIDTH,
    angle: float = 0,
    justify: str | None = None,
) -> str:
    justify_str = f"\n\t\t\t(justify {justify})" if justify else ""
    return (
        f'\t(gr_text "{text}"\n'
        f"\t\t(at {x} {y} {angle})\n"
        '\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{ll.make_uuid(ll.MARKER_LABEL)}")\n'
        "\t\t(effects\n"
        f"\t\t\t(font (size {font_size} {font_size}) (thickness {font_width})){justify_str}\n"
        "\t\t)\n"
        "\t)\n"
    )


def make_silk_line(x1: float, y1: float, x2: float, y2: float,
                   width: float = GRID_LINE_WIDTH) -> str:
    return (
        "\t(gr_line\n"
        f"\t\t(start {x1} {y1})\n"
        f"\t\t(end {x2} {y2})\n"
        f"\t\t(stroke (width {width}) (type solid))\n"
        '\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{ll.make_uuid(ll.MARKER_GRID)}")\n'
        "\t)\n"
    )


def make_silk_circle(cx: float, cy: float, radius: float, width: float = 0.15) -> str:
    return (
        "\t(gr_circle\n"
        f"\t\t(center {cx} {cy})\n"
        f"\t\t(end {cx + radius} {cy})\n"
        f"\t\t(stroke (width {width}) (type solid))\n"
        "\t\t(fill no)\n"
        '\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{ll.make_uuid(ll.MARKER_MOUNTING_HOLE)}")\n'
        "\t)\n"
    )


# ──────────────────────────────────────────────────────────────────────────────
# Decoration generators
# ──────────────────────────────────────────────────────────────────────────────
def gen_square_labels() -> list[str]:
    out = []
    for f in range(MATRIX_COLS):
        for r in range(MATRIX_ROWS):
            sx, sy = hall_position(f, r)
            out.append(make_silk_text(square_name(f, r), sx, sy + LABEL_Y_OFFSET))
    return out


def gen_chess_grid() -> list[str]:
    out = []
    for i in range(LED_ROWS):
        y = CHESS_Y_TOP + i * SQUARE_SIZE
        out.append(make_silk_line(CHESS_X_LEFT, y, CHESS_X_RIGHT, y))
    for i in range(LED_COLS):
        x = CHESS_X_LEFT + i * SQUARE_SIZE
        out.append(make_silk_line(x, CHESS_Y_TOP, x, CHESS_Y_BOTTOM))
    return out


def gen_file_rank_labels() -> list[str]:
    out = []
    label_y = CHESS_Y_BOTTOM + BOARD_MARGIN * 0.5
    for f in range(MATRIX_COLS):
        sx, _ = hall_position(f, 0)
        out.append(make_silk_text(
            chr(ord("A") + f), sx, label_y,
            font_size=FILE_LABEL_FONT_SIZE, font_width=0.3))
    label_x = CHESS_X_LEFT - BOARD_MARGIN * 0.5
    for r in range(MATRIX_ROWS):
        _, sy = hall_position(0, r)
        out.append(make_silk_text(
            str(r + 1), label_x, sy,
            font_size=RANK_LABEL_FONT_SIZE, font_width=0.3))
    return out


def gen_title_block() -> list[str]:
    cx = BOARD_ORIGIN_X + BOARD_SIZE / 2
    cy = BOARD_ORIGIN_Y + BOARD_MARGIN * 0.4
    return [
        make_silk_text(TITLE_TEXT, cx, cy,
                       font_size=TITLE_FONT_SIZE, font_width=0.35),
        make_silk_text(f"{TITLE_AUTHOR}  {TITLE_VERSION}",
                       cx, cy + TITLE_FONT_SIZE + 1,
                       font_size=1.0, font_width=0.15),
    ]


def gen_cardinal_labels() -> list[str]:
    return [
        make_silk_text(
            "BLACK",
            CHESS_X_RIGHT + BOARD_MARGIN * 0.4, CHESS_Y_TOP + SQUARE_SIZE * 0.5,
            font_size=CARDINAL_FONT_SIZE, font_width=0.4, angle=90),
        make_silk_text(
            "WHITE",
            CHESS_X_LEFT - BOARD_MARGIN * 0.4, CHESS_Y_BOTTOM - SQUARE_SIZE * 0.5,
            font_size=CARDINAL_FONT_SIZE, font_width=0.4, angle=90),
    ]


def gen_mounting_hole_markers() -> list[str]:
    r = MOUNTING_HOLE_DIAMETER / 2
    inset = MOUNTING_HOLE_INSET
    corners = [
        (BOARD_ORIGIN_X + inset,              BOARD_ORIGIN_Y + inset),
        (BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + inset),
        (BOARD_ORIGIN_X + inset,              BOARD_ORIGIN_Y + BOARD_SIZE - inset),
        (BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + BOARD_SIZE - inset),
    ]
    return [make_silk_circle(cx, cy, r) for cx, cy in corners]


# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────
def main() -> int:
    if not ll.PCB_PATH.exists():
        print(f"ERROR: {ll.PCB_PATH} does not exist.")
        print()
        print("Create the PCB scaffold first:")
        print("  1. Open openchess-board.kicad_pro in KiCad")
        print("  2. Open the PCB editor (Pcbnew)")
        print("  3. File → Update PCB from Schematic (F8) — accept defaults, save")
        print("  4. Close KiCad")
        print("  5. Re-run this script")
        return 1

    text = ll.read_pcb()

    # 1. Remove items owned by this script (idempotent re-run).
    text, n_removed = ll.remove_owned_items(
        text,
        keywords=["gr_rect", "gr_text", "gr_line", "gr_circle"],
        marker_prefix=ll.MARKER_OUTLINE,
    )
    for prefix in (ll.MARKER_LABEL, ll.MARKER_GRID, ll.MARKER_MOUNTING_HOLE):
        text, n = ll.remove_owned_items(
            text,
            keywords=["gr_rect", "gr_text", "gr_line", "gr_circle"],
            marker_prefix=prefix,
        )
        n_removed += n
    print(f"Removed {n_removed} owned item(s) from previous run(s)")

    # 2. Place 64 hall sensors.
    placed_halls = 0
    missing_halls: list[str] = []
    for f in range(MATRIX_COLS):
        for r in range(MATRIX_ROWS):
            ref = hall_ref(f, r)
            x, y = hall_position(f, r)
            text, ok = ll.place_footprint(text, ref, x, y, rot=0.0, layer="F.Cu")
            if ok:
                placed_halls += 1
            else:
                missing_halls.append(ref)
    total_halls = MATRIX_COLS * MATRIX_ROWS
    print(f"Placed {placed_halls}/{total_halls} hall sensors"
          + (f"  (missing: {', '.join(missing_halls)})" if missing_halls else ""))

    # 3. Place 81 WS2812B LEDs.
    placed_leds = 0
    missing_leds: list[str] = []
    for row in range(LED_ROWS):
        for col in range(LED_COLS):
            ref = led_ref(col, row)
            x, y = led_position(col, row)
            text, ok = ll.place_footprint(text, ref, x, y, rot=0.0, layer="F.Cu")
            if ok:
                placed_leds += 1
            else:
                missing_leds.append(ref)
    total_leds = LED_COLS * LED_ROWS
    print(f"Placed {placed_leds}/{total_leds} LEDs"
          + (f"  (missing: {', '.join(missing_leds)})" if missing_leds else ""))

    # 3b. Place per-LED 100 nF decoupling caps next to their LEDs.
    placed_caps = 0
    missing_caps: list[str] = []
    for row in range(LED_ROWS):
        for col in range(LED_COLS):
            ref = led_cap_ref(col, row)
            x, y = led_cap_position(col, row)
            text, ok = ll.place_footprint(text, ref, x, y, rot=LED_CAP_ROTATION, layer="F.Cu")
            if ok:
                placed_caps += 1
            else:
                missing_caps.append(ref)
    total_led_caps = LED_COLS * LED_ROWS
    print(f"Placed {placed_caps}/{total_led_caps} LED decoupling caps"
          + (f"  (missing: {', '.join(missing_caps)})" if missing_caps else ""))

    # 3c. Place 47 µF row bulk caps (C1..C{LED_ROWS}) — one per LED row,
    # in a vertical strip just right of the chess grid.
    placed_bulks = 0
    missing_bulks: list[str] = []
    for row_idx in range(LED_ROWS):
        ref = row_bulk_ref(row_idx)
        x, y = row_bulk_position(row_idx)
        text, ok = ll.place_footprint(text, ref, x, y, rot=ROW_BULK_ROTATION, layer="F.Cu")
        if ok:
            placed_bulks += 1
        else:
            missing_bulks.append(ref)
    print(f"Placed {placed_bulks}/{LED_ROWS} row bulk caps (47 µF)"
          + (f"  (missing: {', '.join(missing_bulks)})" if missing_bulks else ""))

    # 3d. Place J1 (J_CTRL matrix connector) at the center of the bottom edge,
    # on B.Cu so the controller PCB can mount underneath.
    j1_x, j1_y = j1_position()
    text, j1_ok = ll.place_footprint(text, J1_REF, j1_x, j1_y,
                                     rot=J1_ROTATION, layer=J1_LAYER)
    if j1_ok:
        print(f"Placed J1 at ({j1_x}, {j1_y}) on {J1_LAYER} "
              f"(rotation {J1_ROTATION}°, center of bottom edge)")
    else:
        print(f"WARNING: J1 not found in PCB — add it in KiCad first")

    # 3e. Place 4 M3 mounting holes (H1..H4) at the board corners.
    placed_mh = 0
    missing_mh: list[str] = []
    for ref, x, y in mounting_hole_positions():
        text, ok = ll.place_footprint(text, ref, x, y, rot=0.0, layer="F.Cu")
        if ok:
            placed_mh += 1
        else:
            missing_mh.append(ref)
    print(f"Placed {placed_mh}/{len(MOUNTING_HOLE_REFS)} M3 mounting holes"
          + (f"  (missing: {', '.join(missing_mh)} — run sch/07_mech.py first)"
             if missing_mh else ""))

    # 3f. Place 3 fiducials (FID1..FID3) for JLC's pick-and-place camera.
    placed_fid = 0
    missing_fid: list[str] = []
    for ref, x, y in fiducial_positions():
        text, ok = ll.place_footprint(text, ref, x, y, rot=0.0, layer="F.Cu")
        if ok:
            placed_fid += 1
        else:
            missing_fid.append(ref)
    print(f"Placed {placed_fid}/{len(FIDUCIAL_REFS)} fiducials"
          + (f"  (missing: {', '.join(missing_fid)} — run sch/07_mech.py first)"
             if missing_fid else ""))

    # 4. Build all additions (outline + silkscreen).
    additions: list[str] = [
        make_board_outline(BOARD_ORIGIN_X, BOARD_ORIGIN_Y, BOARD_SIZE, BOARD_SIZE)
    ]
    decoration_log: list[str] = []
    if DRAW_SQUARE_LABELS:
        items = gen_square_labels()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} chess square labels (A1-H8)")
    if DRAW_CHESS_GRID:
        items = gen_chess_grid()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} chess grid lines")
    if DRAW_FILE_RANK_LABELS:
        items = gen_file_rank_labels()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} file/rank labels (A-H + 1-8)")
    if DRAW_TITLE_BLOCK:
        items = gen_title_block()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} title block lines")
    if DRAW_CARDINAL_LABELS:
        items = gen_cardinal_labels()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} cardinal labels (WHITE/BLACK)")
    if DRAW_MOUNTING_HOLE_MARKERS:
        items = gen_mounting_hole_markers()
        additions.extend(items)
        decoration_log.append(f"  {len(items)} mounting-hole markers")

    # 5. Splice additions in just before the final top-level closing paren.
    text = text.rstrip()
    if not text.endswith(")"):
        print("ERROR: PCB file does not end with ')'. Aborting.")
        return 1
    text = text[:-1] + "".join(additions) + ")\n"

    # 6. Write with paren-balance check + auto-restore on failure.
    ll.write_pcb(ll.PCB_PATH, text, backup_suffix=BACKUP_SUFFIX)

    # 7. Report.
    print()
    print("=== Layout summary ===")
    print(f"Board:        ({BOARD_ORIGIN_X}, {BOARD_ORIGIN_Y}) → "
          f"({BOARD_ORIGIN_X + BOARD_SIZE}, {BOARD_ORIGIN_Y + BOARD_SIZE}) "
          f"= {BOARD_SIZE} × {BOARD_SIZE} mm")
    print(f"Square size:  {SQUARE_SIZE} mm")
    print(f"Board margin: {BOARD_MARGIN} mm")
    print()
    print("Silkscreen decorations:")
    for line in decoration_log:
        print(line)
    print()
    print("Hall sensor corners (chess orientation, A1 bottom-left):")
    for f, r in [(0, 0), (0, MATRIX_ROWS - 1),
                 (MATRIX_COLS - 1, 0), (MATRIX_COLS - 1, MATRIX_ROWS - 1)]:
        ref = hall_ref(f, r)
        name = square_name(f, r)
        x, y = hall_position(f, r)
        print(f"  {ref} ({name}) at ({x}, {y})")
    print()
    print("LED grid corners (raster):")
    for col, row, tag in [(0, 0, "top-left"),
                          (LED_COLS - 1, 0, "top-right"),
                          (0, LED_ROWS - 1, "bottom-left"),
                          (LED_COLS - 1, LED_ROWS - 1, "bottom-right")]:
        x, y = led_position(col, row)
        cx, cy = led_cap_position(col, row)
        print(f"  {tag:14s} {led_ref(col, row):>4s} at ({x}, {y});  "
              f"cap {led_cap_ref(col, row):>4s} at ({cx}, {cy})")
    print()
    print(f"Row bulks (47 µF, pin 1 sits {ROW_BULK_PIN1_ABOVE_LED_VDD_MM} mm above its row's first LED VDD pad):")
    for row_idx in range(LED_ROWS):
        ref = row_bulk_ref(row_idx)
        x, y = row_bulk_position(row_idx)
        print(f"  {ref} at ({x}, {y})")
    print()
    j1_x, j1_y = j1_position()
    print(f"J1 (matrix connector to controller, B.Cu): ({j1_x}, {j1_y})")
    print(f"  → controller mounts beneath, centered on this connector position")
    print()
    print("M3 mounting holes (board corners):")
    for ref, x, y in mounting_hole_positions():
        print(f"  {ref} at ({x}, {y})")
    print()
    print("Fiducials (asymmetric triangle for JLC PnP camera):")
    for ref, x, y in fiducial_positions():
        print(f"  {ref} at ({x}, {y})")
    print()
    print(f"Backup: openchess-board.kicad_pcb{BACKUP_SUFFIX}")
    print("Open KiCad PCB editor and press Home to zoom-to-fit.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
