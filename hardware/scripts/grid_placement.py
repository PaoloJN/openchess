#!/usr/bin/env python3
"""
Grid placement for the chessboard PCB.

Places and labels on the front of the board:
  - 64 hall sensors (U3-U66) at chess square centers
  - 81 WS2812B LEDs (D2-D82) at 9x9 grid corners
  - Board outline on Edge.Cuts with margin around the LED grid
  - Optional silkscreen decorations (toggleable below)

Layout orientation (matches standard chess view):
  - A1 (white queenside) = bottom-left
  - H8 (black kingside) = top-right
  - Files A-H run left-to-right
  - Ranks 1-8 run bottom-to-top

IDEMPOTENT: safe to re-run after changing config below. Re-running:
  - Always backs up current PCB first
  - Removes previous items added by this script (tracked via UUID markers)
  - Re-places everything with new config

Reference mapping (from schematic — DO NOT CHANGE):
  U3=A1, U4=A2, ..., U10=A8, U11=B1, ..., U66=H8 (file*8 + rank)
  D2 at top-left corner, raster order, D82 at bottom-right corner
"""

import re
import os
import shutil
import uuid

# ==============================================================================
# GEOMETRY  -  change these to resize the board
# ==============================================================================

BOARD_ORIGIN_X = 50       # mm — top-left of the BOARD outline (not the LED grid)
BOARD_ORIGIN_Y = 50

SQUARE_SIZE    = 32       # mm per chess square (typical: 30-35mm)
BOARD_MARGIN   = 12       # mm extra around the LED grid for the board edge
                          # (LEDs at corners need clearance + room for labels)

# ==============================================================================
# SILKSCREEN DECORATIONS  -  toggle each on/off
# ==============================================================================

DRAW_SQUARE_LABELS    = True   # A1-H8 labels under each hall sensor
DRAW_CHESS_GRID       = True   # 8x8 grid lines showing square boundaries
DRAW_FILE_RANK_LABELS = True   # A-H along bottom, 1-8 along left
DRAW_TITLE_BLOCK      = True   # "Chessboard v2" + name + date in corner
DRAW_CARDINAL_LABELS  = True   # "WHITE" near rank 1, "BLACK" near rank 8
DRAW_MOUNTING_HOLE_MARKERS = True  # circles where M3 screws will go

# ==============================================================================
# STYLE
# ==============================================================================

# Hall sensor chess labels (A1, A2, ...)
LABEL_FONT_SIZE   = 1.5
LABEL_FONT_WIDTH  = 0.25
LABEL_Y_OFFSET    = 5     # mm below sensor

# Title block
TITLE_TEXT        = "Chessboard v2"
TITLE_AUTHOR      = "Paolo Nessim"
TITLE_VERSION     = "Rev 0.1"
TITLE_FONT_SIZE   = 2.0

# File/rank labels (A-H, 1-8)
FILE_LABEL_FONT_SIZE = 2.5
RANK_LABEL_FONT_SIZE = 2.5

# Cardinal direction labels
CARDINAL_FONT_SIZE = 3.0

# Chess grid line thickness
GRID_LINE_WIDTH = 0.15    # mm — thin silkscreen line

# Mounting hole config
MOUNTING_HOLE_INSET = 6   # mm from board corner to hole center
MOUNTING_HOLE_DIAMETER = 3.2  # mm — for M3 screws

# ==============================================================================
# DERIVED VALUES  -  do not edit
# ==============================================================================

# LED grid spans 8 squares (9 corners per side)
LED_GRID_SIZE = 8 * SQUARE_SIZE
BOARD_SIZE = LED_GRID_SIZE + 2 * BOARD_MARGIN

# LED grid starts BOARD_MARGIN inside the board outline
LED_ORIGIN_X = BOARD_ORIGIN_X + BOARD_MARGIN
LED_ORIGIN_Y = BOARD_ORIGIN_Y + BOARD_MARGIN

# Chess board outer bounds
CHESS_X_LEFT   = LED_ORIGIN_X
CHESS_X_RIGHT  = LED_ORIGIN_X + LED_GRID_SIZE
CHESS_Y_TOP    = LED_ORIGIN_Y
CHESS_Y_BOTTOM = LED_ORIGIN_Y + LED_GRID_SIZE

# UUID prefix markers — items with these prefixes are owned by this script
MARKER_OUTLINE       = "10000000"  # board outline
MARKER_LABEL         = "20000000"  # silkscreen text labels (all kinds)
MARKER_GRID          = "30000000"  # silkscreen lines (chess grid)
MARKER_MOUNTING_HOLE = "40000000"  # mounting hole circles

PCB_FILE = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "..", "hardware", "openchess.kicad_pcb"))
BACKUP_SUFFIX = ".backup_before_grid_placement"


# ==============================================================================
# COORDINATE HELPERS
# ==============================================================================

def hall_sensor_position(file_idx, rank_idx):
    """(x, y) for sensor at file (0=A) and rank (0=rank1, bottom)."""
    x = LED_ORIGIN_X + 0.5 * SQUARE_SIZE + file_idx * SQUARE_SIZE
    y = LED_ORIGIN_Y + 7.5 * SQUARE_SIZE - rank_idx * SQUARE_SIZE
    return (x, y)


def led_position(col, row):
    """LED at grid corner (col 0-8, row 0-8 with row 0 at top)."""
    x = LED_ORIGIN_X + col * SQUARE_SIZE
    y = LED_ORIGIN_Y + row * SQUARE_SIZE
    return (x, y)


def chess_square_name(file_idx, rank_idx):
    return chr(ord('A') + file_idx) + str(rank_idx + 1)


def compute_positions():
    positions = {}
    for ref_num in range(3, 67):
        idx = ref_num - 3
        file_idx = idx // 8
        rank_idx = idx % 8
        x, y = hall_sensor_position(file_idx, rank_idx)
        positions[f"U{ref_num}"] = (x, y, chess_square_name(file_idx, rank_idx))
    for ref_num in range(2, 83):
        idx = ref_num - 2
        row = idx // 9
        col = idx % 9
        x, y = led_position(col, row)
        positions[f"D{ref_num}"] = (x, y, None)
    return positions


# ==============================================================================
# PCB FILE HELPERS
# ==============================================================================

def find_footprint_blocks(text):
    blocks = []
    i = 0
    while i < len(text):
        idx = text.find('(footprint ', i)
        if idx == -1: break
        depth = 1
        j = idx + len('(footprint ')
        in_string = False
        escape = False
        while depth > 0 and j < len(text):
            c = text[j]
            if escape: escape = False
            elif c == '\\': escape = True
            elif c == '"': in_string = not in_string
            elif not in_string:
                if c == '(': depth += 1
                elif c == ')': depth -= 1
            j += 1
        blocks.append((idx, j))
        i = j
    return blocks


def find_blocks_with_marker(text, block_keyword, marker_prefix):
    blocks = []
    i = 0
    needle = f'({block_keyword} '
    while i < len(text):
        idx = text.find(needle, i)
        if idx == -1: break
        depth = 1
        j = idx + len(needle)
        in_string = False
        escape = False
        while depth > 0 and j < len(text):
            c = text[j]
            if escape: escape = False
            elif c == '\\': escape = True
            elif c == '"': in_string = not in_string
            elif not in_string:
                if c == '(': depth += 1
                elif c == ')': depth -= 1
            j += 1
        block_text = text[idx:j]
        if f'(uuid "{marker_prefix}-' in block_text:
            blocks.append((idx, j))
        i = j
    return blocks


def make_uuid(prefix):
    rest = str(uuid.uuid4()).split('-', 1)[1]
    return f"{prefix}-{rest}"


# ==============================================================================
# S-EXPRESSION BUILDERS
# ==============================================================================

def make_board_outline(x, y, w, h):
    return (
        '\t(gr_rect\n'
        f'\t\t(start {x} {y})\n'
        f'\t\t(end {x + w} {y + h})\n'
        '\t\t(stroke (width 0.15) (type solid))\n'
        '\t\t(fill no)\n'
        '\t\t(layer "Edge.Cuts")\n'
        f'\t\t(uuid "{make_uuid(MARKER_OUTLINE)}")\n'
        '\t)\n'
    )


def make_silk_text(text, x, y, font_size=1.5, font_width=0.25, angle=0, justify=None):
    justify_str = f'\n\t\t\t(justify {justify})' if justify else ''
    return (
        f'\t(gr_text "{text}"\n'
        f'\t\t(at {x} {y} {angle})\n'
        f'\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{make_uuid(MARKER_LABEL)}")\n'
        '\t\t(effects\n'
        f'\t\t\t(font (size {font_size} {font_size}) (thickness {font_width})){justify_str}\n'
        '\t\t)\n'
        '\t)\n'
    )


def make_silk_line(x1, y1, x2, y2, width=GRID_LINE_WIDTH):
    return (
        '\t(gr_line\n'
        f'\t\t(start {x1} {y1})\n'
        f'\t\t(end {x2} {y2})\n'
        f'\t\t(stroke (width {width}) (type solid))\n'
        '\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{make_uuid(MARKER_GRID)}")\n'
        '\t)\n'
    )


def make_silk_circle(cx, cy, radius, width=0.15):
    return (
        '\t(gr_circle\n'
        f'\t\t(center {cx} {cy})\n'
        f'\t\t(end {cx + radius} {cy})\n'
        f'\t\t(stroke (width {width}) (type solid))\n'
        '\t\t(fill no)\n'
        '\t\t(layer "F.SilkS")\n'
        f'\t\t(uuid "{make_uuid(MARKER_MOUNTING_HOLE)}")\n'
        '\t)\n'
    )


# ==============================================================================
# DECORATION GENERATORS (each returns list of S-expr strings)
# ==============================================================================

def gen_square_labels():
    """A1-H8 labels under each hall sensor."""
    out = []
    for file_idx in range(8):
        for rank_idx in range(8):
            sx, sy = hall_sensor_position(file_idx, rank_idx)
            label = chess_square_name(file_idx, rank_idx)
            out.append(make_silk_text(label, sx, sy + LABEL_Y_OFFSET,
                                       font_size=LABEL_FONT_SIZE, font_width=LABEL_FONT_WIDTH))
    return out


def gen_chess_grid():
    """8x8 grid of lines defining the chess squares."""
    out = []
    # Horizontal lines (9 of them, one per rank boundary)
    for i in range(9):
        y = CHESS_Y_TOP + i * SQUARE_SIZE
        out.append(make_silk_line(CHESS_X_LEFT, y, CHESS_X_RIGHT, y))
    # Vertical lines (9 of them, one per file boundary)
    for i in range(9):
        x = CHESS_X_LEFT + i * SQUARE_SIZE
        out.append(make_silk_line(x, CHESS_Y_TOP, x, CHESS_Y_BOTTOM))
    return out


def gen_file_rank_labels():
    """File labels A-H along bottom, rank labels 1-8 along left."""
    out = []
    # Files A-H below the grid (centered under each square)
    label_y = CHESS_Y_BOTTOM + BOARD_MARGIN * 0.5
    for file_idx in range(8):
        sx, _ = hall_sensor_position(file_idx, 0)
        out.append(make_silk_text(chr(ord('A') + file_idx), sx, label_y,
                                   font_size=FILE_LABEL_FONT_SIZE, font_width=0.3))
    # Ranks 1-8 to the left of the grid (centered beside each square)
    label_x = CHESS_X_LEFT - BOARD_MARGIN * 0.5
    for rank_idx in range(8):
        _, sy = hall_sensor_position(0, rank_idx)
        out.append(make_silk_text(str(rank_idx + 1), label_x, sy,
                                   font_size=RANK_LABEL_FONT_SIZE, font_width=0.3))
    return out


def gen_title_block():
    """Title text in top-right corner of board (outside grid, inside outline)."""
    # Place in margin area at top
    out = []
    cx = BOARD_ORIGIN_X + BOARD_SIZE / 2
    cy = BOARD_ORIGIN_Y + BOARD_MARGIN * 0.4
    out.append(make_silk_text(TITLE_TEXT, cx, cy,
                               font_size=TITLE_FONT_SIZE, font_width=0.35))
    out.append(make_silk_text(f"{TITLE_AUTHOR}  {TITLE_VERSION}", cx, cy + TITLE_FONT_SIZE + 1,
                               font_size=1.0, font_width=0.15))
    return out


def gen_cardinal_labels():
    """WHITE near rank 1 (bottom), BLACK near rank 8 (top)."""
    out = []
    cx = BOARD_ORIGIN_X + BOARD_SIZE / 2
    # BLACK at top
    out.append(make_silk_text("BLACK",
                               CHESS_X_RIGHT + BOARD_MARGIN * 0.4, CHESS_Y_TOP + SQUARE_SIZE * 0.5,
                               font_size=CARDINAL_FONT_SIZE, font_width=0.4, angle=90))
    # WHITE at bottom
    out.append(make_silk_text("WHITE",
                               CHESS_X_LEFT - BOARD_MARGIN * 0.4, CHESS_Y_BOTTOM - SQUARE_SIZE * 0.5,
                               font_size=CARDINAL_FONT_SIZE, font_width=0.4, angle=90))
    return out


def gen_mounting_hole_markers():
    """4 circles at corners marking where M3 mounting holes will go.

    NOTE: these are silkscreen markers only — actual drill holes need to be added
    via KiCad's GUI (Place > Mounting Hole) or via the netlist later.
    """
    out = []
    r = MOUNTING_HOLE_DIAMETER / 2
    inset = MOUNTING_HOLE_INSET
    for cx, cy in [
        (BOARD_ORIGIN_X + inset, BOARD_ORIGIN_Y + inset),                          # top-left
        (BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + inset),             # top-right
        (BOARD_ORIGIN_X + inset, BOARD_ORIGIN_Y + BOARD_SIZE - inset),             # bot-left
        (BOARD_ORIGIN_X + BOARD_SIZE - inset, BOARD_ORIGIN_Y + BOARD_SIZE - inset),# bot-right
    ]:
        out.append(make_silk_circle(cx, cy, r))
    return out


# ==============================================================================
# MAIN
# ==============================================================================

def main():
    if not os.path.exists(PCB_FILE):
        print(f"ERROR: PCB file not found at {PCB_FILE}")
        return
    shutil.copy(PCB_FILE, PCB_FILE + BACKUP_SUFFIX)
    print(f"Backed up: {os.path.basename(PCB_FILE)}{BACKUP_SUFFIX}")

    with open(PCB_FILE) as f:
        text = f.read()

    # Remove previously added items (idempotent)
    removals = []
    for keyword, marker in [
        ("gr_rect", MARKER_OUTLINE),
        ("gr_text", MARKER_LABEL),
        ("gr_line", MARKER_GRID),
        ("gr_circle", MARKER_MOUNTING_HOLE),
    ]:
        found = find_blocks_with_marker(text, keyword, marker)
        removals.extend(found)
    removals.sort(key=lambda b: b[0], reverse=True)
    for start, end in removals:
        if end < len(text) and text[end] == '\n':
            end += 1
        text = text[:start] + text[end:]
    print(f"Removed {len(removals)} item(s) from previous runs")

    # Update component positions
    positions = compute_positions()
    blocks = find_footprint_blocks(text)
    updates = []
    for start, end in blocks:
        block_text = text[start:end]
        ref_match = re.search(r'\(property "Reference" "([^"]+)"', block_text)
        if not ref_match: continue
        ref = ref_match.group(1)
        if ref not in positions: continue
        x, y, _ = positions[ref]
        at_match = re.search(r'\(at ([\-\d.]+) ([\-\d.]+)(\s+[\-\d.]+)?\)', block_text)
        if not at_match: continue
        angle = at_match.group(3) or ''
        new_at = f"(at {x} {y}{angle})"
        updates.append((start + at_match.start(), start + at_match.end(), new_at))
    updates.sort(key=lambda u: u[0], reverse=True)
    for s, e, new_at in updates:
        text = text[:s] + new_at + text[e:]
    print(f"Updated {len(updates)} component positions")

    # Build all additions
    additions = []
    additions.append(make_board_outline(BOARD_ORIGIN_X, BOARD_ORIGIN_Y, BOARD_SIZE, BOARD_SIZE))

    decoration_log = []
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
        decoration_log.append(f"  {len(items)} mounting hole markers")

    # Insert before final closing paren
    text = text.rstrip()
    if text.endswith(')'):
        text = text[:-1] + ''.join(additions) + ')\n'

    with open(PCB_FILE, "w") as f:
        f.write(text)

    # Validate
    depth = 0; in_string = False; escape = False
    for c in text:
        if escape: escape = False; continue
        if c == '\\': escape = True; continue
        if c == '"': in_string = not in_string; continue
        if in_string: continue
        if c == '(': depth += 1
        elif c == ')': depth -= 1
    if depth != 0:
        print(f"ERROR: PCB file unbalanced (depth={depth}). Restoring backup!")
        shutil.copy(PCB_FILE + BACKUP_SUFFIX, PCB_FILE)
        return

    # Report
    print()
    print("=== Layout summary ===")
    print(f"Board:        ({BOARD_ORIGIN_X}, {BOARD_ORIGIN_Y}) - "
          f"({BOARD_ORIGIN_X + BOARD_SIZE}, {BOARD_ORIGIN_Y + BOARD_SIZE}) "
          f"= {BOARD_SIZE} x {BOARD_SIZE} mm")
    print(f"Square size:  {SQUARE_SIZE} mm")
    print(f"Board margin: {BOARD_MARGIN} mm")
    print()
    print("Silkscreen decorations:")
    for line in decoration_log:
        print(line)
    print()
    print("Corner verification (should be standard chess board orientation):")
    for fname, rname, ref_idx in [("A", "1", 3), ("A", "8", 10), ("H", "1", 59), ("H", "8", 66)]:
        ref = f"U{ref_idx}"
        x, y, label = positions[ref]
        print(f"  {ref} ({label}) at ({x}, {y})")
    print()
    print("Open KiCad PCB editor and press Home to zoom-to-fit.")


if __name__ == "__main__":
    main()
