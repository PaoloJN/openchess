#!/usr/bin/env python3
"""01_skeleton.py — page setup + title block + lib_symbols + decoration boxes.

Writes build/sch/01_skeleton.sexp:
  - (paper "A2")
  - (title_block ...)
  - (lib_symbols ...)  — embeds every symbol used by generated chunks.
  - Heading text + tagline + separator line
  - Six labeled decoration boxes (one per functional group)

Run with KiCad CLOSED. After this step `openchess-board.kicad_sch` is a
valid (but empty-of-components) schematic — open in KiCad to verify the
page setup + decoration look right before running step 02.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    emit_polyline, emit_rectangle, emit_text,
    assemble, uid, write_chunk, load_symbol_def,
    PFX_DECOR,
)

# ────────────────────────────────────────────────────────────────────────
# Stock KiCad symbols we embed alongside A3144 so the schematic is
# self-contained — it resolves to its own (lib_symbols ...) block and
# does not depend on the host project's sym-lib-table.
# ────────────────────────────────────────────────────────────────────────
EMBEDDED_STOCK_SYMBOLS = [
    "Device:C",
    "Device:C_Polarized",
    "LED:WS2812B",
    "Connector_Generic:Conn_02x13_Odd_Even",
    "power:PWR_FLAG",
    "power:GND",
    "Connector:TestPoint",
    "Mechanical:MountingHole",
    "Mechanical:Fiducial",
]

# ────────────────────────────────────────────────────────────────────────
# Title block
# ────────────────────────────────────────────────────────────────────────
TB_TITLE   = "OpenChess — Matrix Board"
TB_DATE    = "2026-06-04"
TB_REV     = "0.1"
TB_COMPANY = "Paolo Nessim"
TB_C1      = "8×8 hall matrix + 9×9 LED chain"
TB_C2      = "Inter-board connector J_CTRL → controller PCB"

# ────────────────────────────────────────────────────────────────────────
# Heading (top of page, decorative — off-grid OK).
# Pulled down 6 mm from the original so the title clears the A2 page
# top border in KiCad's worksheet template.
# ────────────────────────────────────────────────────────────────────────
HEAD_X, HEAD_Y = 30, 28
HEAD_SIZE = 6.0
TAGLINE_TEXT = "8×8 hall sensor matrix + 9×9 WS2812 LED chain  ·  rev 0.1"
TAGLINE_Y = 37
TAGLINE_SIZE = 2.0
SEPARATOR_Y = 42
SEPARATOR_X1 = 30
SEPARATOR_X2 = 560

BOX_TITLE_SIZE = 2.5
BOX_BODY_SIZE  = 1.5

# ────────────────────────────────────────────────────────────────────────
# Decoration boxes — (x1, y1, x2, y2, title, body)
# Wrap the layout around the A2 title block. Title block top-left corner
# observed at ~(474, 376) — so:
#   • PULL-UPS / BULKS / J_CTRL sit at x < 474, can drop their bottom
#     edges down to y=400 (10 mm from frame bottom).
#   • POWER (x=485..566) sits entirely over the title block's X range,
#     so stops at y=370 to leave a 6 mm margin above the title block.
# ────────────────────────────────────────────────────────────────────────
BOXES = [
    (28, 50, 287, 295, "HALL MATRIX (8 × 8)",
     "64× A3144 hall-effect sensors\n"
     "Files A..H left→right, ranks 1..8 bottom→top\n"
     "Columns share VCC = CA..CH_PWR\n"
     "Rows share open-collector OUT = S0..S7 (pulled up on controller)"),
    (290, 50, 566, 295, "LED MATRIX (9 × 9)",
     "81× WS2812B with per-LED 100 nF decoupling\n"
     "Row-major: D1 top-left → D81 bottom-right\n"
     "Powered from +5V_LED, driven by LED_DATA_5V"),
    (28, 305, 110, 400, "LED DECOUPLING",
     "C91 — 470 µF / 10 V\n"
     "+5V_LED entry bulk cap near J_CTRL\n"
     "ERC flags for external +5V_LED/GND"),
    (115, 305, 285, 400, "ROW BULK CAPS",
     "C1..C9 — 47 µF\nOne per LED row\n+5V_LED to GND"),
    (290, 305, 470, 400, "J_CTRL — INTER-BOARD CONNECTOR",
     "2×13 pin header (26 pins)\n"
     "+5V_LED, GND, sense, column power, LED data\n"
     "See docs/inter-board-connector.md"),
    (485, 305, 566, 370, "TEST + MECHANICAL",
     "Test points on +5V_LED, GND, LED_DATA_5V, LED_DOUT_END\n"
     "4× M3 mounting holes\nFiducials for assembly"),
]

# ────────────────────────────────────────────────────────────────────────
# A3144 custom symbol definition — embedded in lib_symbols block.
# Pin types: VCC and GND are `passive` (NOT power_in) — the A3144 isn't
# a power consumer in the KiCad sense and `power_in` triggers ERC errors
# when fed by an open net like CA_PWR. OUT is `open_collector`.
# Coordinates MUST match _lib.PIN_COORDS["openchess:A3144"].
# ────────────────────────────────────────────────────────────────────────
A3144_SYMBOL_DEF = '''		(symbol "openchess:A3144"
			(pin_names
				(offset 0.508)
			)
			(exclude_from_sim no)
			(in_bom yes)
			(on_board yes)
			(property "Reference" "U"
				(at 0 5.08 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Value" "A3144"
				(at 0 -5.08 0)
				(effects
					(font
						(size 1.27 1.27)
					)
				)
			)
			(property "Footprint" "Package_TO_SOT_THT:TO-92_Inline"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Datasheet" "https://www.allegromicro.com/-/media/files/datasheets/a3141-2-3-4-datasheet.pdf"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "Description" "Allegro A3144 Hall-effect switch, open-collector output"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_keywords" "hall sensor a3144 magnetic switch"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(property "ki_fp_filters" "TO?92*"
				(at 0 0 0)
				(effects
					(font
						(size 1.27 1.27)
					)
					(hide yes)
				)
			)
			(symbol "A3144_0_1"
				(rectangle
					(start -2.54 3.81)
					(end 2.54 -3.81)
					(stroke
						(width 0.254)
						(type default)
					)
					(fill
						(type background)
					)
				)
				(text "H"
					(at 0 1.27 0)
					(effects
						(font
							(size 1.778 1.778)
							(bold yes)
						)
					)
				)
			)
			(symbol "A3144_1_1"
				(pin passive line
					(at -5.08 2.54 0)
					(length 2.54)
					(name "VCC"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
					(number "1"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
				)
				(pin passive line
					(at -5.08 0 0)
					(length 2.54)
					(name "GND"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
					(number "2"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
				)
				(pin open_collector line
					(at -5.08 -2.54 0)
					(length 2.54)
					(name "OUT"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
					(number "3"
						(effects
							(font
								(size 1.016 1.016)
							)
						)
					)
				)
			)
			(embedded_fonts no)
		)'''


def main() -> int:
    out: list[str] = []

    out.append('\t(paper "A2")')
    out.append('\t(title_block')
    out.append(f'\t\t(title "{TB_TITLE}")')
    out.append(f'\t\t(date "{TB_DATE}")')
    out.append(f'\t\t(rev "{TB_REV}")')
    out.append(f'\t\t(company "{TB_COMPANY}")')
    out.append(f'\t\t(comment 1 "{TB_C1}")')
    out.append(f'\t\t(comment 2 "{TB_C2}")')
    out.append('\t)')

    out.append('\t(lib_symbols')
    out.append(A3144_SYMBOL_DEF)
    for lib_id in EMBEDDED_STOCK_SYMBOLS:
        out.append(load_symbol_def(lib_id))
    out.append('\t)')

    emit_text(out, TB_TITLE, HEAD_X, HEAD_Y, HEAD_SIZE,
              "left bottom", uid(PFX_DECOR, 1), bold=True)
    emit_text(out, TAGLINE_TEXT, HEAD_X, TAGLINE_Y, TAGLINE_SIZE,
              "left bottom", uid(PFX_DECOR, 2), italic=True)
    emit_polyline(out, SEPARATOR_X1, SEPARATOR_Y, SEPARATOR_X2, SEPARATOR_Y,
                  uid(PFX_DECOR, 3))

    for i, (x1, y1, x2, y2, title, body) in enumerate(BOXES):
        emit_rectangle(out, x1, y1, x2, y2, uid(PFX_DECOR, 10 + i * 3))
        emit_text(out, title, x1 + 3, y1 - 2, BOX_TITLE_SIZE,
                  "left bottom", uid(PFX_DECOR, 11 + i * 3), bold=True)
        body_esc = body.replace("\n", "\\n")
        emit_text(out, body_esc, x1 + 4, y1 + 5, BOX_BODY_SIZE,
                  "left top", uid(PFX_DECOR, 12 + i * 3))

    write_chunk("01_skeleton", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
