#!/usr/bin/env python3
"""01_skeleton.py — page setup, title block, embedded symbols, and boxes."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import emit_polyline, emit_rectangle, emit_text, assemble, uid, write_chunk, load_symbol_def, PFX_DECOR

EMBEDDED_STOCK_SYMBOLS = [
    "Device:R",
    "Device:C",
    "Connector_Generic:Conn_02x13_Odd_Even",
    "Connector:TestPoint",
    "Connector:USB_C_Receptacle_USB2.0_16P",
    "Regulator_Linear:AP2204K-1.5",   # base symbol — pins live here
    "Regulator_Linear:AP2112K-3.3",   # extends AP2204K-1.5
    "Mechanical:MountingHole",
    "Mechanical:Fiducial",
    "power:PWR_FLAG",
]

TB_TITLE = "OpenChess — Controller Board"
TB_DATE = "2026-06-04"
TB_REV = "0.1"
TB_COMPANY = "Paolo Nessim"
TB_C1 = "ESP32 controller + power + matrix scan drivers"
TB_C2 = "J_MAIN mates to matrix-board J_CTRL"

HEAD_X, HEAD_Y = 30, 28
TAGLINE_TEXT = "Controller PCB: power, ESP32, row pullups, column drivers, LED data, user UI"
BOX_TITLE_SIZE = 2.5
BOX_BODY_SIZE = 1.5

BOXES = [
    (28, 50, 135, 150, "J_MAIN — MATRIX CONNECTOR",
     "2x13 connector matching matrix J_CTRL\n+5V_LED, GND, S0..S7, CA..CH_PWR, LED_DATA_5V"),
    (145, 50, 285, 150, "ROW PULLUPS",
     "R1..R8 — 10k\nS0..S7 pulled to +3V3 on controller\nHall outputs are open-collector"),
    (295, 50, 430, 150, "ESP32 / LOGIC",
     "ESP32 module/devkit placeholder\nGPIO assignment to be locked before placement\n+3V3 logic rail"),
    (440, 50, 566, 150, "POWER",
     "USB-C 5V → +5V_LED rail\n+3V3 LDO (AP2112K-3.3, 600 mA)\nNo battery on prototype #1"),
    (28, 170, 210, 285, "COLUMN DRIVERS",
     "CA_PWR..CH_PWR switched 5V column rails\nImplementation pending: direct GPIO vs 74HC595 + transistors"),
    (220, 170, 370, 285, "LED DATA LEVEL SHIFT",
     "ESP32 data -> 5V WS2812 data\nTarget net: LED_DATA_5V\nPart choice pending"),
    (380, 170, 566, 285, "USER UI CONNECTOR",
     "Cable-mounted side controls\nStatus LEDs and buttons live off-board\nPinout pending"),
    (28, 305, 566, 400, "TEST + MECHANICAL",
     "Testpoints for rails, matrix connector nets, drivers\n4x M3 mounting holes\n3x fiducials for assembly"),
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

    emit_text(out, TB_TITLE, HEAD_X, HEAD_Y, 6.0, "left bottom", uid(PFX_DECOR, 1), bold=True)
    emit_text(out, TAGLINE_TEXT, HEAD_X, 37, 2.0, "left bottom", uid(PFX_DECOR, 2), italic=True)
    emit_polyline(out, 30, 42, 560, 42, uid(PFX_DECOR, 3))

    for i, (x1, y1, x2, y2, title, body) in enumerate(BOXES):
        emit_rectangle(out, x1, y1, x2, y2, uid(PFX_DECOR, 10 + i * 3))
        emit_text(out, title, x1 + 3, y1 - 2, BOX_TITLE_SIZE, "left bottom", uid(PFX_DECOR, 11 + i * 3), bold=True)
        emit_text(out, body.replace("\n", "\\n"), x1 + 4, y1 + 5, BOX_BODY_SIZE, "left top", uid(PFX_DECOR, 12 + i * 3))

    write_chunk("01_skeleton", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
