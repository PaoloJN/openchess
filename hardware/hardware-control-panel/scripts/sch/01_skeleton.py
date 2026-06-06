#!/usr/bin/env python3
"""01_skeleton.py — page setup, embedded symbols, and functional boxes."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import emit_polyline, emit_rectangle, emit_text, assemble, uid, write_chunk, load_symbol_def, PFX_DECOR

EMBEDDED_STOCK_SYMBOLS = [
    "Device:R",
    "Device:LED",
    "Switch:SW_Push",
    "Connector_Generic:Conn_01x10",
    "Connector:TestPoint",
    "Mechanical:MountingHole",
    "Mechanical:Fiducial",
    "power:PWR_FLAG",
]

TB_TITLE = "OpenChess — Control Panel"
TB_DATE = "2026-06-05"
TB_REV = "0.1"
TB_COMPANY = "Paolo Nessim"
TB_C1 = "Side-mounted buttons + status LEDs"
TB_C2 = "Cable connector to controller board"

BOXES = [
    (28, 50, 145, 150, "J_PANEL — CABLE CONNECTOR", "1x10 cable header to controller\n+3V3, GND, LED sinks, buttons, spare GPIO"),
    (155, 50, 355, 150, "STATUS LEDS", "D1..D3 normal LEDs\nR1..R3 current-limit resistors\nController sinks LED_*_N nets"),
    (365, 50, 566, 150, "BUTTONS", "SW1..SW3 momentary buttons\nButtons short BTN_* nets to GND\nPullups live on controller"),
    (28, 180, 566, 285, "TEST + MECHANICAL", "Testpoints on cable nets\n4x M3 mounting holes\n3x fiducials for assembly"),
]


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
    for lib_id in EMBEDDED_STOCK_SYMBOLS:
        out.append(load_symbol_def(lib_id))
    out.append('\t)')

    emit_text(out, TB_TITLE, 30, 28, 6.0, "left bottom", uid(PFX_DECOR, 1), bold=True)
    emit_text(out, "Physical side panel: status LEDs + simple button inputs", 30, 37, 2.0, "left bottom", uid(PFX_DECOR, 2), italic=True)
    emit_polyline(out, 30, 42, 560, 42, uid(PFX_DECOR, 3))

    for i, (x1, y1, x2, y2, title, body) in enumerate(BOXES):
        emit_rectangle(out, x1, y1, x2, y2, uid(PFX_DECOR, 10 + i * 3))
        emit_text(out, title, x1 + 3, y1 - 2, 2.5, "left bottom", uid(PFX_DECOR, 11 + i * 3), bold=True)
        emit_text(out, body.replace("\n", "\\n"), x1 + 4, y1 + 5, 1.5, "left top", uid(PFX_DECOR, 12 + i * 3))

    write_chunk("01_skeleton", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
