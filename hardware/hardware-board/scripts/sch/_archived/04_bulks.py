#!/usr/bin/env python3
"""04_bulks.py — place LED_ROWS row-bulk decoupling caps on +5V_LED.

One 47 µF cap per row of the LED grid (so 4 caps for 3x3, 9 caps for 8x8).
Refs: C1..C{LED_ROWS}. Placed in a horizontal strip below the LED matrix,
each with a +5V_LED label above and a GND power port below.

Owns the PFX_BULK_CAP "bc00" UUID prefix — anything written by this chunk
will be regenerated cleanly on re-runs.

Run with KiCad CLOSED. Writes build/sch/04_bulks.sexp and reassembles
the schematic via 99_assemble.py.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    g, uid, write_chunk, assemble,
    emit_symbol, emit_wire, emit_label,
    PFX_BULK_CAP,
)
from config import (
    CAP_LIB,
    LED_POWER_NET,
    LED_ROWS,
    ROW_BULK_FOOTPRINT,
    ROW_BULK_VALUE,
)
from geometry import row_bulk_position

GND_POWER_LIB = "power:GND"
STUB_LEN_G = 1   # short stub from pin to label/power port


def main() -> int:
    out: list[str] = []

    for i in range(LED_ROWS):
        x, y = row_bulk_position(i)
        ref = f"C{i + 1}"
        sym_u = uid(PFX_BULK_CAP, i + 1)

        # Device:C symbol pin 1 sits at (0, +2.54) [top], pin 2 at (0, -2.54)
        # [bottom] when unrotated. We label pin 1 = +5V_LED (above), pin 2 = GND
        # (below via power port).
        emit_symbol(
            out,
            lib_id=CAP_LIB,
            x=x, y=y, rot=0,
            ref=ref,
            value=ROW_BULK_VALUE,
            footprint=ROW_BULK_FOOTPRINT,
            sym_uuid=sym_u,
            pin_uuids={
                "1": uid(PFX_BULK_CAP, 100 + i * 2 + 0),
                "2": uid(PFX_BULK_CAP, 100 + i * 2 + 1),
            },
            ref_offset=(g(1), -g(1)),
            value_offset=(g(1), g(1)),
        )

        # Pin 1 (top, +2.54 in symbol) → +5V_LED label
        top_pin = (x, y - g(1))
        top_stub = (x, y - g(2))
        emit_wire(out, top_pin[0], top_pin[1], top_stub[0], top_stub[1],
                  uid(PFX_BULK_CAP, 300 + i * 2 + 0))
        emit_label(out, LED_POWER_NET, top_stub[0], top_stub[1], 90,
                   uid(PFX_BULK_CAP, 200 + i * 2 + 0),
                   justify="left bottom")

        # Pin 2 (bottom, -2.54 in symbol) → GND power port
        bot_pin = (x, y + g(1))
        bot_anchor = (x, y + g(2))
        emit_wire(out, bot_pin[0], bot_pin[1], bot_anchor[0], bot_anchor[1],
                  uid(PFX_BULK_CAP, 300 + i * 2 + 1))
        emit_symbol(
            out,
            lib_id=GND_POWER_LIB,
            x=bot_anchor[0], y=bot_anchor[1], rot=0,
            ref=f"#PWR_B{i + 1}",
            value="GND",
            footprint="",
            sym_uuid=uid(PFX_BULK_CAP, 400 + i),
            pin_uuids={"1": uid(PFX_BULK_CAP, 500 + i)},
            ref_offset=(g(-1), -g(1)),
            value_offset=(g(-1), g(1)),
            in_bom=False,
            on_board=False,
            hide_ref=True,
        )

    write_chunk("04_bulks", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
