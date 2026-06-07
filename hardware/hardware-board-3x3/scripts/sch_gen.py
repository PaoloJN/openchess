#!/usr/bin/env python3
"""
sch_gen.py — generate openchess-board.kicad_sch from scratch.

Generates a clean A2 schematic for the OpenChess MATRIX BOARD with:
  • Populated title block
  • Big heading + tagline + separator
  • Labeled boxes around functional groups (hall matrix, LED chain,
    row pull-ups, row bulk caps, J_CTRL connector)
  • All component instances placed at sensible positions inside their boxes:
      - 64× A3144 hall sensors in an 8×8 grid (U1..U64)
      - 81× WS2812B LEDs in a 9×9 grid (D1..D81)
      - 81× 100 nF LED decoupling caps next to each LED (C10..C90)
      - 9× 10 µF row bulk caps (C1..C9)
      - 8× 10 kΩ row pull-ups (R1..R8)
      - 1× WS2812B status LED (BATT_LED1) at the front of the chain
      - 1× 2×13 pin header for inter-board connector (J1 = J_CTRL)
      - PWR_FLAGs on +5V, +3V3, GND, +BAT, BAT_SW
  • Hierarchical labels around the perimeter (one per J_CTRL signal)
  • Short wire stubs + power-rail symbols where the pattern is obvious
    (e.g. each hall's VCC → CA..CH_PWR label, GND → #PWR symbol)

WIRING is the USER'S JOB after this runs — KiCad GUI is the right tool for
the long traces. This script gets you to "all components in the right place
with their pins labeled" so the wiring is just connect-the-dots.

IDEMPOTENT — re-running overwrites the output but preserves the top-level
sheet UUID if the file exists. Backup written before each overwrite.

Run with KiCad CLOSED.
"""
from __future__ import annotations
import shutil
import sys
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
BOARD_DIR = HERE.parent
OUT_PATH = BOARD_DIR / "openchess-board.kicad_sch"

# ────────────────────────────────────────────────────────────────────────────
# Grid system — KiCad uses 100 mil (2.54 mm) for symbol pin alignment.
# Every position that touches a pin, wire, label, or junction must be at an
# integer multiple of G. Decorative items (box outlines, heading text) can be
# off-grid without affecting ERC.
# ────────────────────────────────────────────────────────────────────────────
G = 2.54

def g(n) -> float:
    """Grid units → mm. n=1 returns 2.54 mm."""
    return n * G

# ────────────────────────────────────────────────────────────────────────────
# Page geometry — A2 landscape (594 × 420 mm)
# ────────────────────────────────────────────────────────────────────────────
PAGE_W, PAGE_H = 594.0, 420.0

# Header band (top of page) — decorative, off-grid OK
HEAD_X, HEAD_Y = 30, 22
HEAD_SIZE = 6.0
TAGLINE_Y = 31
TAGLINE_SIZE = 2.0
SEPARATOR_Y = 36
SEPARATOR_X1 = 30
SEPARATOR_X2 = 560

# Working area (decorative)
WORK_TOP    = 45
WORK_BOTTOM = 390
WORK_LEFT   = 25
WORK_RIGHT  = 565

BOX_STROKE      = 0.2
BOX_TITLE_SIZE  = 2.5
BOX_BODY_SIZE   = 1.5
HLABEL_SIZE     = 1.4
WIRE_LABEL_SIZE = 1.27

# ────────────────────────────────────────────────────────────────────────────
# Box layout — decorative rectangles around functional groups
# ────────────────────────────────────────────────────────────────────────────
BOX_HALL_MATRIX = (28, 50, 287, 295)
BOX_LED_CHAIN   = (290, 50, 566, 295)
BOX_PULLUPS     = (28, 305, 110, 385)
BOX_BULK_CAPS   = (115, 305, 285, 385)
BOX_J_CTRL      = (290, 305, 478, 385)
BOX_POWER       = (485, 305, 566, 385)

# ────────────────────────────────────────────────────────────────────────────
# Component grid positions (everything in grid units — multiply by g())
# ────────────────────────────────────────────────────────────────────────────
# Hall matrix: 8 cols × 8 rows. Pin pitch on the A3144 symbol is 1 grid (2.54mm)
# vertically; we space halls 11 grids apart vertically and 12 grids horizontally.
HALL_X_PITCH_G = 12          # 30.48 mm
HALL_Y_PITCH_G = 11          # 27.94 mm
HALL_X_START_G = 24          # 60.96 mm — clear of box edge + room for stub labels
HALL_Y_START_G = 32          # 81.28 mm — clear of box top

# LED grid: 9 cols × 9 rows. Each LED + its cap takes ~5 grids horizontally.
LED_X_PITCH_G = 11           # 27.94 mm
LED_Y_PITCH_G = 10           # 25.40 mm
LED_X_START_G = 120          # 304.8 mm
LED_Y_START_G = 32           # 81.28 mm

# LED cap sits 4 grids right of its LED's origin
LED_CAP_DX_G = 4

# Row pull-ups: vertical column at left edge of pull-up box
PULLUP_X_R_G = 18            # 45.72 mm
PULLUP_Y_TOP_G = 127         # 322.58 mm
PULLUP_Y_PITCH_G = 3         # 7.62 mm

# Row bulk caps: horizontal row across the bulk-cap box
BULK_X_START_G = 50          # 127 mm
BULK_Y_G        = 137         # 347.98 mm
BULK_X_PITCH_G  = 7           # 17.78 mm

# J_CTRL connector (2×13). Conn_02x13_Odd_Even has pin 1 at (-2.54, +6*2.54)
# from center (rotation 0). We place center on grid.
JCTRL_X_G = 145              # 368.3 mm
JCTRL_Y_G = 138              # 350.52 mm — centered in connector box

# BATT_LED1
BATT_LED_X_G = 200           # 508 mm — inside power box
BATT_LED_Y_G = 130           # 330.2 mm

# PWR_FLAGs
PWRFLAG_X_G = 213            # 541.02 mm
PWRFLAG_Y_START_G = 132      # 335.28 mm
PWRFLAG_Y_PITCH_G = 3        # 7.62 mm

# ────────────────────────────────────────────────────────────────────────────
# UUID generation — byte-stable across runs
# ────────────────────────────────────────────────────────────────────────────
def uid(prefix: str, n: int) -> str:
    """Generate a deterministic v4-shaped UUID."""
    return f"{prefix}{n:04x}-0000-4000-8000-{n:012x}"


# Per-category UUID prefixes
PFX_DECOR     = "deca"  # boxes, headings, separator
PFX_HALL      = "ba11"  # 64 halls
PFX_LED       = "1ed0"  # 81 LEDs
PFX_LED_CAP   = "1ed5"  # 81 LED decoupling caps
PFX_BULK_CAP  = "bc00"  # 9 row bulk caps
PFX_PULLUP    = "9011"  # 8 row pull-ups
PFX_BATT_LED  = "ba11ed"  # 1 status LED — wait, that's 6 chars
PFX_BATT_LED  = "b4ed"  # 1 status LED
PFX_JCTRL     = "1c70"  # connector + pins
PFX_PWRFLAG   = "f1a6"  # PWR_FLAGs
PFX_HLABEL    = "1ab1"  # hierarchical labels
PFX_LIB       = "11b5"  # lib_symbol UUIDs (rarely used)


# ────────────────────────────────────────────────────────────────────────────
# Number formatters — KiCad style
# ────────────────────────────────────────────────────────────────────────────
def _n_size(x: float) -> str:
    """Font size — KiCad keeps `4.0` for whole numbers."""
    if isinstance(x, int) or x == int(x):
        return f"{x:.1f}"
    s = f"{x:.6f}".rstrip("0")
    return s + "0" if s.endswith(".") else s


def _nc(x: float) -> str:
    """Coordinate — KiCad strips `.0` for whole numbers."""
    if isinstance(x, int) or x == int(x):
        return str(int(x))
    s = f"{x:.6f}".rstrip("0")
    return s.rstrip(".")


# ────────────────────────────────────────────────────────────────────────────
# A3144 custom symbol — embedded so the schematic is self-contained.
# Pin positions match Connector_Generic:Conn_01x03 (pin 1 at (-5.08, 2.54),
# pin 2 at (-5.08, 0), pin 3 at (-5.08, -2.54)) so existing wires/positions
# from the old project would transfer cleanly if anyone wanted to.
# ────────────────────────────────────────────────────────────────────────────
A3144_SYMBOL_DEF = '''\t\t(symbol "openchess:A3144"
\t\t\t(pin_names
\t\t\t\t(offset 0.508)
\t\t\t)
\t\t\t(exclude_from_sim no)
\t\t\t(in_bom yes)
\t\t\t(on_board yes)
\t\t\t(property "Reference" "U"
\t\t\t\t(at 0 5.08 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t)
\t\t\t(property "Value" "A3144"
\t\t\t\t(at 0 -5.08 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t)
\t\t\t(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
\t\t\t\t(at 0 0 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t\t(hide yes)
\t\t\t\t)
\t\t\t)
\t\t\t(property "Datasheet" "https://www.allegromicro.com/-/media/files/datasheets/a3141-2-3-4-datasheet.pdf"
\t\t\t\t(at 0 0 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t\t(hide yes)
\t\t\t\t)
\t\t\t)
\t\t\t(property "Description" "Allegro A3144 Hall-effect switch, open-collector output"
\t\t\t\t(at 0 0 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t\t(hide yes)
\t\t\t\t)
\t\t\t)
\t\t\t(property "ki_keywords" "hall sensor a3144 magnetic switch"
\t\t\t\t(at 0 0 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t\t(hide yes)
\t\t\t\t)
\t\t\t)
\t\t\t(property "ki_fp_filters" "TO?92*"
\t\t\t\t(at 0 0 0)
\t\t\t\t(effects
\t\t\t\t\t(font
\t\t\t\t\t\t(size 1.27 1.27)
\t\t\t\t\t)
\t\t\t\t\t(hide yes)
\t\t\t\t)
\t\t\t)
\t\t\t(symbol "A3144_0_1"
\t\t\t\t(rectangle
\t\t\t\t\t(start -2.54 3.81)
\t\t\t\t\t(end 2.54 -3.81)
\t\t\t\t\t(stroke
\t\t\t\t\t\t(width 0.254)
\t\t\t\t\t\t(type default)
\t\t\t\t\t)
\t\t\t\t\t(fill
\t\t\t\t\t\t(type background)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t\t(text "H"
\t\t\t\t\t(at 0 1.27 0)
\t\t\t\t\t(effects
\t\t\t\t\t\t(font
\t\t\t\t\t\t\t(size 1.778 1.778)
\t\t\t\t\t\t\t(bold yes)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t)
\t\t\t(symbol "A3144_1_1"
\t\t\t\t(pin passive line
\t\t\t\t\t(at -5.08 2.54 0)
\t\t\t\t\t(length 2.54)
\t\t\t\t\t(name "VCC"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t\t(number "1"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t\t(pin passive line
\t\t\t\t\t(at -5.08 0 0)
\t\t\t\t\t(length 2.54)
\t\t\t\t\t(name "GND"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t\t(number "2"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t\t(pin open_collector line
\t\t\t\t\t(at -5.08 -2.54 0)
\t\t\t\t\t(length 2.54)
\t\t\t\t\t(name "OUT"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t\t(number "3"
\t\t\t\t\t\t(effects
\t\t\t\t\t\t\t(font
\t\t\t\t\t\t\t\t(size 1.016 1.016)
\t\t\t\t\t\t\t)
\t\t\t\t\t\t)
\t\t\t\t\t)
\t\t\t\t)
\t\t\t)
\t\t\t(embedded_fonts no)
\t\t)
'''


# ────────────────────────────────────────────────────────────────────────────
# Header / decoration emitters (same patterns as sch_render_subsheets.py)
# ────────────────────────────────────────────────────────────────────────────
class Out:
    """Line-based output builder."""
    def __init__(self) -> None:
        self.lines: list[str] = []

    def a(self, s: str = "") -> None:
        self.lines.append(s)

    def render(self) -> str:
        return "\n".join(self.lines) + "\n"


def emit_rectangle(o: Out, x1, y1, x2, y2, u, stroke=BOX_STROKE):
    o.a("\t(rectangle")
    o.a(f"\t\t(start {_nc(x1)} {_nc(y1)}) (end {_nc(x2)} {_nc(y2)})")
    o.a(f"\t\t(stroke (width {_nc(stroke)}) (type default))")
    o.a("\t\t(fill (type none))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_text(o: Out, s, x, y, size, justify, u, bold=False, italic=False):
    font = f"(font (size {_n_size(size)} {_n_size(size)})"
    if bold:
        font += " (bold yes)"
    if italic:
        font += " (italic yes)"
    font += ")"
    o.a(f'\t(text "{s}"')
    o.a("\t\t(exclude_from_sim no)")
    o.a(f"\t\t(at {_nc(x)} {_nc(y)} 0)")
    o.a(f"\t\t(effects {font} (justify {justify}))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_polyline(o: Out, x1, y1, x2, y2, u, stroke=0.2):
    o.a("\t(polyline")
    o.a(f"\t\t(pts (xy {_nc(x1)} {_nc(y1)}) (xy {_nc(x2)} {_nc(y2)}))")
    o.a(f"\t\t(stroke (width {_nc(stroke)}) (type default))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_hlabel(o: Out, label, x, y, angle, shape, justify, u, size=HLABEL_SIZE):
    o.a(f'\t(hierarchical_label "{label}"')
    o.a(f"\t\t(shape {shape})")
    o.a(f"\t\t(at {_nc(x)} {_nc(y)} {angle})")
    o.a(f"\t\t(effects (font (size {_n_size(size)} {_n_size(size)})) (justify {justify}))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_label(o: Out, label, x, y, angle, u, size=WIRE_LABEL_SIZE,
               justify="left bottom"):
    o.a(f'\t(label "{label}"')
    o.a(f"\t\t(at {_nc(x)} {_nc(y)} {angle})")
    o.a(f"\t\t(effects (font (size {_n_size(size)} {_n_size(size)})) (justify {justify}))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_wire(o: Out, x1, y1, x2, y2, u):
    o.a("\t(wire")
    o.a(f"\t\t(pts (xy {_nc(x1)} {_nc(y1)}) (xy {_nc(x2)} {_nc(y2)}))")
    o.a("\t\t(stroke (width 0) (type default))")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


def emit_junction(o: Out, x, y, u, diameter=0):
    o.a("\t(junction")
    o.a(f"\t\t(at {_nc(x)} {_nc(y)})")
    o.a(f"\t\t(diameter {_nc(diameter)})")
    o.a("\t\t(color 0 0 0 0)")
    o.a(f'\t\t(uuid "{u}")')
    o.a("\t)")


# ────────────────────────────────────────────────────────────────────────────
# Component instance emitter
# ────────────────────────────────────────────────────────────────────────────
def emit_symbol(
    o: Out,
    lib_id: str,
    x: float, y: float, rot: float,
    ref: str, value: str, footprint: str,
    sym_uuid: str,
    pin_uuids: dict[str, str],
    properties: dict[str, str] | None = None,
    ref_offset: tuple[float, float] = (2.54, -2.54),
    value_offset: tuple[float, float] = (2.54, 2.54),
):
    """Emit a top-level (symbol ...) component instance."""
    properties = properties or {}
    o.a("\t(symbol")
    o.a(f'\t\t(lib_id "{lib_id}")')
    o.a(f"\t\t(at {_nc(x)} {_nc(y)} {_nc(rot)})")
    o.a("\t\t(unit 1)")
    o.a("\t\t(exclude_from_sim no)")
    o.a("\t\t(in_bom yes)")
    o.a("\t\t(on_board yes)")
    o.a("\t\t(dnp no)")
    o.a(f'\t\t(uuid "{sym_uuid}")')
    o.a(f'\t\t(property "Reference" "{ref}"')
    o.a(f"\t\t\t(at {_nc(x + ref_offset[0])} {_nc(y + ref_offset[1])} 0)")
    o.a("\t\t\t(effects")
    o.a("\t\t\t\t(font")
    o.a("\t\t\t\t\t(size 1.27 1.27)")
    o.a("\t\t\t\t)")
    o.a("\t\t\t\t(justify left)")
    o.a("\t\t\t)")
    o.a("\t\t)")
    o.a(f'\t\t(property "Value" "{value}"')
    o.a(f"\t\t\t(at {_nc(x + value_offset[0])} {_nc(y + value_offset[1])} 0)")
    o.a("\t\t\t(effects")
    o.a("\t\t\t\t(font")
    o.a("\t\t\t\t\t(size 1.27 1.27)")
    o.a("\t\t\t\t)")
    o.a("\t\t\t\t(justify left)")
    o.a("\t\t\t)")
    o.a("\t\t)")
    o.a(f'\t\t(property "Footprint" "{footprint}"')
    o.a(f"\t\t\t(at {_nc(x)} {_nc(y)} 0)")
    o.a("\t\t\t(effects")
    o.a("\t\t\t\t(font (size 1.27 1.27))")
    o.a("\t\t\t\t(hide yes)")
    o.a("\t\t\t)")
    o.a("\t\t)")
    for k, v in properties.items():
        o.a(f'\t\t(property "{k}" "{v}"')
        o.a(f"\t\t\t(at {_nc(x)} {_nc(y)} 0)")
        o.a("\t\t\t(effects (font (size 1.27 1.27)) (hide yes))")
        o.a("\t\t)")
    for pin_num, pin_uuid in pin_uuids.items():
        o.a(f'\t\t(pin "{pin_num}"')
        o.a(f'\t\t\t(uuid "{pin_uuid}")')
        o.a("\t\t)")
    o.a("\t\t(instances")
    o.a('\t\t\t(project "openchess-board"')
    o.a(f'\t\t\t\t(path "/" (reference "{ref}") (unit 1))')
    o.a("\t\t\t)")
    o.a("\t\t)")
    o.a("\t)")


# ────────────────────────────────────────────────────────────────────────────
# Hall sensor layout (8×8 grid) — all positions in grid units, converted to mm
# ────────────────────────────────────────────────────────────────────────────
def hall_position(file_idx: int, rank_idx: int) -> tuple[float, float]:
    """(x, y) in mm for hall at file 0..7 (A..H) and rank 0..7 (1..8).
    Rank 1 (closest to white) is at the BOTTOM, rank 8 at the top —
    same convention as PCB layout per CLAUDE.md."""
    return (g(HALL_X_START_G + file_idx * HALL_X_PITCH_G),
            g(HALL_Y_START_G + (7 - rank_idx) * HALL_Y_PITCH_G))


def hall_ref(file_idx: int, rank_idx: int) -> str:
    """U-ref using firmware-friendly numbering: U(1 + file*8 + rank).
    File 0 (A), rank 0 (1) → U1; file 7 (H), rank 7 (8) → U64."""
    return f"U{1 + file_idx * 8 + rank_idx}"


def col_pwr_net(file_idx: int) -> str:
    return f"C{chr(ord('A') + file_idx)}_PWR"


def row_sense_net(rank_idx: int) -> str:
    return f"S{rank_idx}"


# ────────────────────────────────────────────────────────────────────────────
# LED chain layout (9×9 grid, serpentine)
# ────────────────────────────────────────────────────────────────────────────
def led_position(col: int, row: int) -> tuple[float, float]:
    """LED at grid corner (col 0..8, row 0..8; row 0 at TOP, row 8 at bottom)."""
    return (g(LED_X_START_G + col * LED_X_PITCH_G),
            g(LED_Y_START_G + row * LED_Y_PITCH_G))


def led_ref(col: int, row: int) -> str:
    """D1..D81 in serpentine order: D1 = top-left, then right across row 0,
    then down to row 1 (right-to-left), etc."""
    if row % 2 == 0:
        idx = row * 9 + col
    else:
        idx = row * 9 + (8 - col)
    return f"D{idx + 1}"


def led_cap_position(col: int, row: int) -> tuple[float, float]:
    """100 nF decoupling cap sits to the right of each LED, grid-aligned."""
    lx, ly = led_position(col, row)
    return lx + g(LED_CAP_DX_G), ly


def led_cap_ref(col: int, row: int) -> str:
    """C10..C90 — one per LED, matching the LED's chain index."""
    if row % 2 == 0:
        idx = row * 9 + col
    else:
        idx = row * 9 + (8 - col)
    return f"C{idx + 10}"


# ────────────────────────────────────────────────────────────────────────────
# Component placement — produces a list of emit_symbol args
# ────────────────────────────────────────────────────────────────────────────
def gen_halls(o: Out, counter: list[int]) -> None:
    """Place 64 A3144 hall sensors in 8×8 grid + label their VCC/GND/OUT pins.
    All wire stubs and labels are placed at grid-aligned positions."""
    STUB_LEN_G = 2   # 5.08 mm stub from each pin to its net label
    for file_idx in range(8):
        for rank_idx in range(8):
            x, y = hall_position(file_idx, rank_idx)
            ref = hall_ref(file_idx, rank_idx)
            n = file_idx * 8 + rank_idx + 1
            sym_u = uid(PFX_HALL, n)
            emit_symbol(
                o,
                lib_id="openchess:A3144",
                x=x, y=y, rot=0,
                ref=ref, value="A3144",
                footprint="Package_TO_SOT_THT:TO-92_Inline",
                sym_uuid=sym_u,
                pin_uuids={
                    "1": uid(PFX_HALL, 1000 + n * 3 + 0),
                    "2": uid(PFX_HALL, 1000 + n * 3 + 1),
                    "3": uid(PFX_HALL, 1000 + n * 3 + 2),
                },
                ref_offset=(g(1), g(-1)),
                value_offset=(g(1), g(2)),
            )
            # A3144 (per the symbol def) has pins at:
            #   Pin 1 (VCC, top):    (-2*G, +1*G) relative to origin
            #   Pin 2 (GND, middle): (-2*G,  0  )
            #   Pin 3 (OUT, bottom): (-2*G, -1*G)
            pin1 = (x - g(2), y + g(1))
            pin2 = (x - g(2), y)
            pin3 = (x - g(2), y - g(1))
            stub_dx = g(STUB_LEN_G)
            # Pin 1 → CA_PWR..CH_PWR
            counter[0] += 1
            emit_wire(o, pin1[0], pin1[1], pin1[0] - stub_dx, pin1[1],
                      uid(PFX_HALL, 5000 + counter[0]))
            counter[0] += 1
            emit_label(o, col_pwr_net(file_idx),
                       pin1[0] - stub_dx, pin1[1], 180,
                       uid(PFX_HALL, 5000 + counter[0]),
                       justify="left bottom")
            # Pin 2 → GND
            counter[0] += 1
            emit_wire(o, pin2[0], pin2[1], pin2[0] - stub_dx, pin2[1],
                      uid(PFX_HALL, 5000 + counter[0]))
            counter[0] += 1
            emit_label(o, "GND", pin2[0] - stub_dx, pin2[1], 180,
                       uid(PFX_HALL, 5000 + counter[0]),
                       justify="left bottom")
            # Pin 3 → S0..S7
            counter[0] += 1
            emit_wire(o, pin3[0], pin3[1], pin3[0] - stub_dx, pin3[1],
                      uid(PFX_HALL, 5000 + counter[0]))
            counter[0] += 1
            emit_label(o, row_sense_net(rank_idx),
                       pin3[0] - stub_dx, pin3[1], 180,
                       uid(PFX_HALL, 5000 + counter[0]),
                       justify="left bottom")


def gen_leds(o: Out) -> None:
    """Place 81 WS2812B LEDs in 9×9 grid."""
    for row in range(9):
        for col in range(9):
            x, y = led_position(col, row)
            ref = led_ref(col, row)
            n = row * 9 + col + 1
            sym_u = uid(PFX_LED, n)
            emit_symbol(
                o,
                lib_id="LED:WS2812B",
                x=x, y=y, rot=0,
                ref=ref, value="WS2812B",
                footprint="LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm",
                sym_uuid=sym_u,
                pin_uuids={
                    "1": uid(PFX_LED, 2000 + n * 4 + 0),
                    "2": uid(PFX_LED, 2000 + n * 4 + 1),
                    "3": uid(PFX_LED, 2000 + n * 4 + 2),
                    "4": uid(PFX_LED, 2000 + n * 4 + 3),
                },
                ref_offset=(0, -8.0),
                value_offset=(0, 6.5),
            )


def gen_led_caps(o: Out) -> None:
    """Place 81 100 nF decoupling caps next to each LED."""
    for row in range(9):
        for col in range(9):
            x, y = led_cap_position(col, row)
            ref = led_cap_ref(col, row)
            n = row * 9 + col + 1
            sym_u = uid(PFX_LED_CAP, n)
            emit_symbol(
                o,
                lib_id="Device:C",
                x=x, y=y, rot=0,
                ref=ref, value="100nF",
                footprint="Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder",
                sym_uuid=sym_u,
                pin_uuids={
                    "1": uid(PFX_LED_CAP, 3000 + n * 2 + 0),
                    "2": uid(PFX_LED_CAP, 3000 + n * 2 + 1),
                },
                ref_offset=(2, -2),
                value_offset=(2, 2),
            )


def gen_bulk_caps(o: Out) -> None:
    """Place 9 row-bulk 10 µF caps in a horizontal row."""
    for i in range(9):
        x = g(BULK_X_START_G + i * BULK_X_PITCH_G)
        y = g(BULK_Y_G)
        ref = f"C{i + 1}"
        sym_u = uid(PFX_BULK_CAP, i + 1)
        emit_symbol(
            o,
            lib_id="Device:C",
            x=x, y=y, rot=0,
            ref=ref, value="10uF",
            footprint="Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder",
            sym_uuid=sym_u,
            pin_uuids={
                "1": uid(PFX_BULK_CAP, 100 + i * 2 + 0),
                "2": uid(PFX_BULK_CAP, 100 + i * 2 + 1),
            },
            ref_offset=(g(1), g(-1)),
            value_offset=(g(1), g(1)),
        )
        # Device:C pin 1 at (0, +2.54) [top], pin 2 at (0, -2.54) [bottom]
        # in unrotated form. Stubs + net labels above/below.
        emit_wire(o, x, y - g(1), x, y - g(2), uid(PFX_BULK_CAP, 300 + i * 2))
        emit_label(o, "+5V", x, y - g(2), 90,
                   uid(PFX_BULK_CAP, 200 + i * 2), justify="left bottom")
        emit_wire(o, x, y + g(1), x, y + g(2), uid(PFX_BULK_CAP, 300 + i * 2 + 1))
        emit_label(o, "GND", x, y + g(2), 270,
                   uid(PFX_BULK_CAP, 200 + i * 2 + 1), justify="left bottom")


def gen_pullups(o: Out) -> None:
    """Place 8 row pull-up 10 kΩ resistors vertically."""
    for i in range(8):
        x = g(PULLUP_X_R_G)
        y = g(PULLUP_Y_TOP_G + i * PULLUP_Y_PITCH_G)
        ref = f"R{i + 1}"
        sym_u = uid(PFX_PULLUP, i + 1)
        # Resistor rotated 90° — pin 1 at (-2.54, 0), pin 2 at (+2.54, 0)
        emit_symbol(
            o,
            lib_id="Device:R",
            x=x, y=y, rot=90,
            ref=ref, value="10k",
            footprint="Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder",
            sym_uuid=sym_u,
            pin_uuids={
                "1": uid(PFX_PULLUP, 100 + i * 2 + 0),
                "2": uid(PFX_PULLUP, 100 + i * 2 + 1),
            },
            ref_offset=(g(-2), g(-1)),
            value_offset=(g(-2), g(1)),
        )
        emit_wire(o, x - g(1), y, x - g(2), y, uid(PFX_PULLUP, 300 + i * 2))
        emit_label(o, f"S{i}", x - g(2), y, 180,
                   uid(PFX_PULLUP, 200 + i * 2), justify="right bottom")
        emit_wire(o, x + g(1), y, x + g(2), y, uid(PFX_PULLUP, 300 + i * 2 + 1))
        emit_label(o, "+3V3", x + g(2), y, 0,
                   uid(PFX_PULLUP, 200 + i * 2 + 1), justify="left bottom")


def gen_jctrl(o: Out) -> None:
    """Place J1 = J_CTRL 2×13 pin header with a hierarchical label per pin."""
    sym_u = uid(PFX_JCTRL, 1)
    pin_uuids = {str(p): uid(PFX_JCTRL, 100 + p) for p in range(1, 27)}
    jx = g(JCTRL_X_G)
    jy = g(JCTRL_Y_G)
    emit_symbol(
        o,
        lib_id="Connector_Generic:Conn_02x13_Odd_Even",
        x=jx, y=jy, rot=0,
        ref="J1", value="J_CTRL_2x13",
        footprint="Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical",
        sym_uuid=sym_u,
        pin_uuids=pin_uuids,
        ref_offset=(g(-1), g(-15)),
        value_offset=(g(-1), g(15)),
    )
    JCTRL_PINS = {
        1:  "+BAT",         2:  "GND",
        3:  "BAT_SW",       4:  "GND",
        5:  "+5V",          6:  "+5V",
        7:  "+3V3",         8:  "GND",
        9:  "LED_DATA_5V", 10:  "GND",
        11: "CC_PWR",      12: "CD_PWR",
        13: "CG_PWR",      14: "S0",
        15: "S1",          16: "S2",
        17: "S3",          18: "S4",
        19: "S5",          20: "S6",
        21: "S7",          22: "CA_PWR",
        23: "CB_PWR",      24: "CE_PWR",
        25: "CF_PWR",      26: "CH_PWR",
    }
    # Conn_02x13_Odd_Even actual pin coords (verified from KiCad lib file):
    #   odd  pin k (left col):  (-5.08, +15.24 - row*2.54)  → x offset = -2 grids
    #   even pin k (right col): (+7.62, +15.24 - row*2.54)  → x offset = +3 grids
    # where row = (k-1)//2.  Pin 1 (odd) and pin 2 (even) share top row.
    for pin, label in JCTRL_PINS.items():
        is_odd = pin % 2 == 1
        row = (pin - 1) // 2
        px = jx + (-g(2) if is_odd else g(3))
        py = jy + g(6) - g(row)
        stub_x = px + (-g(2) if is_odd else g(2))
        emit_wire(o, px, py, stub_x, py, uid(PFX_JCTRL, 200 + pin))
        # Regular labels (not hierarchical) — this is a flat single-sheet
        # schematic; the J_CTRL connector is the external interface, no
        # sub-sheets above. Hierarchical labels would dangle.
        emit_label(
            o, label, stub_x, py,
            angle=180 if is_odd else 0,
            u=uid(PFX_HLABEL, pin),
            justify="right" if is_odd else "left",
        )


def gen_batt_led(o: Out) -> None:
    """BATT_LED1 — the status LED at the front of the chain."""
    sym_u = uid(PFX_BATT_LED, 1)
    emit_symbol(
        o,
        lib_id="LED:WS2812B",
        x=g(BATT_LED_X_G), y=g(BATT_LED_Y_G), rot=0,
        ref="BATT_LED1", value="WS2812B",
        footprint="LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm",
        sym_uuid=sym_u,
        pin_uuids={str(p): uid(PFX_BATT_LED, 100 + p) for p in range(1, 5)},
        ref_offset=(0, g(-3)),
        value_offset=(0, g(3)),
    )


def gen_pwrflags(o: Out) -> None:
    """PWR_FLAGs on +5V, +3V3, +BAT, BAT_SW, GND.
    PWR_FLAG's pin 1 sits at (0, 0) (symbol origin). A short wire stub
    connects the pin to a net label placed 2 grids away."""
    flags = ["+5V", "+3V3", "+BAT", "BAT_SW", "GND"]
    for i, net in enumerate(flags):
        x = g(PWRFLAG_X_G)
        y = g(PWRFLAG_Y_START_G + i * PWRFLAG_Y_PITCH_G)
        sym_u = uid(PFX_PWRFLAG, i + 1)
        emit_symbol(
            o,
            lib_id="power:PWR_FLAG",
            x=x, y=y, rot=0,
            ref=f"#FLG0{i + 1}",
            value="PWR_FLAG",
            footprint="",
            sym_uuid=sym_u,
            pin_uuids={"1": uid(PFX_PWRFLAG, 100 + i)},
        )
        # Wire from pin (at symbol origin) to label position
        emit_wire(o, x, y, x + g(2), y, uid(PFX_PWRFLAG, 300 + i))
        emit_label(o, net, x + g(2), y, 0, uid(PFX_PWRFLAG, 200 + i),
                   justify="left bottom")


# ────────────────────────────────────────────────────────────────────────────
# Box decoration (per sch_render_subsheets pattern)
# ────────────────────────────────────────────────────────────────────────────
BOXES = [
    (BOX_HALL_MATRIX, "HALL MATRIX (8 × 8)",
     "64× A3144 hall-effect sensors\n"
     "Files A..H left→right, ranks 1..8 bottom→top\n"
     "Columns share VCC = CA..CH_PWR\nRows share OC sense = S0..S7"),
    (BOX_LED_CHAIN, "LED CHAIN (9 × 9)",
     "81× WS2812B with per-LED 100 nF decoupling\n"
     "Serpentine: D1 (top-left) → D9 → D10 ... → D81\n"
     "Powered from +5V, driven by LED_DATA_5V"),
    (BOX_PULLUPS, "ROW PULL-UPS",
     "R1..R8 — 10 kΩ\nS0..S7 → +3V3"),
    (BOX_BULK_CAPS, "ROW BULK CAPS",
     "C1..C9 — 10 µF\nOne per LED row\n+5V to GND"),
    (BOX_J_CTRL, "J_CTRL — INTER-BOARD CONNECTOR",
     "2×13 pin header (26 pins)\n"
     "Power, sense, drive, LED data to controller PCB\n"
     "See docs/inter-board-connector.md"),
    (BOX_POWER, "STATUS + PWR FLAGS",
     "BATT_LED1 — WS2812B status LED\n"
     "PWR_FLAGs on +5V, +3V3, +BAT, BAT_SW"),
]


def gen_decoration(o: Out) -> None:
    # Heading
    emit_text(o, "OpenChess — Matrix Board", HEAD_X, HEAD_Y, HEAD_SIZE,
              "left bottom", uid(PFX_DECOR, 1), bold=True)
    emit_text(o, "8×8 hall sensor matrix + 9×9 WS2812 LED chain  ·  rev 0.1",
              HEAD_X, TAGLINE_Y, TAGLINE_SIZE, "left bottom",
              uid(PFX_DECOR, 2), italic=True)
    emit_polyline(o, SEPARATOR_X1, SEPARATOR_Y, SEPARATOR_X2, SEPARATOR_Y,
                  uid(PFX_DECOR, 3))

    # Boxes
    for i, ((x1, y1, x2, y2), title, body) in enumerate(BOXES):
        o.a("")
        emit_rectangle(o, x1, y1, x2, y2, uid(PFX_DECOR, 10 + i * 3))
        emit_text(o, title, x1 + 3, y1 - 2, BOX_TITLE_SIZE, "left bottom",
                  uid(PFX_DECOR, 11 + i * 3), bold=True)
        body_esc = body.replace("\n", "\\n")
        emit_text(o, body_esc, x1 + 4, y1 + 5, BOX_BODY_SIZE, "left top",
                  uid(PFX_DECOR, 12 + i * 3))


# ────────────────────────────────────────────────────────────────────────────
# Schematic header + footer + lib_symbols section
# ────────────────────────────────────────────────────────────────────────────
def emit_header(o: Out, sheet_uuid: str) -> None:
    o.a("(kicad_sch")
    o.a("\t(version 20260306)")
    o.a('\t(generator "eeschema")')
    o.a('\t(generator_version "10.0")')
    o.a(f'\t(uuid "{sheet_uuid}")')
    o.a('\t(paper "A2")')
    o.a("\t(title_block")
    o.a('\t\t(title "OpenChess — Matrix Board")')
    o.a('\t\t(date "2026-06-04")')
    o.a('\t\t(rev "0.1")')
    o.a('\t\t(company "Paolo Nessim")')
    o.a('\t\t(comment 1 "8×8 hall matrix + 9×9 LED chain")')
    o.a('\t\t(comment 2 "Inter-board connector J_CTRL → controller PCB")')
    o.a("\t)")
    # lib_symbols — embed A3144 + minimal stubs. KiCad will auto-resolve
    # the others (Device:R, Device:C, LED:WS2812B, etc.) from the project's
    # symbol library table at open time. For full self-containment those
    # could be pre-embedded too — left as future polish.
    o.a("\t(lib_symbols")
    o.a(A3144_SYMBOL_DEF.rstrip())
    o.a("\t)")
    o.a("")


def emit_footer(o: Out) -> None:
    o.a("\t(sheet_instances")
    o.a('\t\t(path "/"')
    o.a('\t\t\t(page "1")')
    o.a("\t\t)")
    o.a("\t)")
    o.a(")")


# ────────────────────────────────────────────────────────────────────────────
# Main
# ────────────────────────────────────────────────────────────────────────────
def read_sheet_uuid(path: Path) -> str | None:
    if not path.exists():
        return None
    txt = path.read_text()
    for line in txt.splitlines():
        s = line.strip()
        if s.startswith("(uuid "):
            return s.split('"')[1]
    return None


def main() -> int:
    sheet_uuid = read_sheet_uuid(OUT_PATH) or (
        "ab0a4d00-0000-4000-8000-000000000001"
    )

    o = Out()
    emit_header(o, sheet_uuid)

    # ---- decoration (boxes, heading, separator) ----
    gen_decoration(o)

    # ---- component placements ----
    o.a("")
    counter = [0]  # shared incrementing UUID counter for hall stubs
    gen_halls(o, counter)
    o.a("")
    gen_leds(o)
    o.a("")
    gen_led_caps(o)
    o.a("")
    gen_bulk_caps(o)
    o.a("")
    gen_pullups(o)
    o.a("")
    gen_jctrl(o)
    o.a("")
    gen_batt_led(o)
    o.a("")
    gen_pwrflags(o)

    emit_footer(o)

    out_text = o.render()

    if OUT_PATH.exists():
        backup = OUT_PATH.with_suffix(OUT_PATH.suffix + ".backup_before_gen")
        shutil.copy2(OUT_PATH, backup)
        print(f"  backup → {backup.name}")

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(out_text)
    print(f"OK {OUT_PATH.relative_to(BOARD_DIR.parent)}")
    print(f"   {len(out_text):,} chars / {len(out_text.encode()):,} bytes")
    print(f"   sheet_uuid = {sheet_uuid[:8]}…")
    print()
    print("NEXT:")
    print("  1. Open openchess-board.kicad_sch in KiCad")
    print("  2. Verify component placement (all 64 halls + 81 LEDs + 81 caps")
    print("     + 9 bulks + 8 pull-ups + J1 + BATT_LED1 + PWR_FLAGs)")
    print("  3. Wire up the LED chain (D1 → D2 → ... → D81 serpentine)")
    print("  4. Wire J1 pins to their nets (labels already placed at each pin)")
    print("  5. Tools → Annotate Schematic (verify refs are clean)")
    print("  6. ERC")
    return 0


if __name__ == "__main__":
    sys.exit(main())
