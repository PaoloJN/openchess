#!/usr/bin/env python3
"""02_connector.py — J_PANEL cable connector to controller board."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import g, uid, write_chunk, assemble, emit_symbol, emit_label, pin_world, PIN_COORDS, PFX_JCTRL, PFX_LABEL
from config import PANEL_CONN_FOOTPRINT, PANEL_CONN_LIB, PANEL_CONN_REF, PANEL_CONN_VALUE, PANEL_PIN_NETS
from geometry import connector_position


def main() -> int:
    out: list[str] = []
    x, y = connector_position()
    emit_symbol(
        out,
        lib_id=PANEL_CONN_LIB,
        x=x,
        y=y,
        rot=0,
        ref=PANEL_CONN_REF,
        value=PANEL_CONN_VALUE,
        footprint=PANEL_CONN_FOOTPRINT,
        sym_uuid=uid(PFX_JCTRL, 1),
        pin_uuids={str(pin): uid(PFX_JCTRL, 100 + pin) for pin in range(1, 11)},
        ref_offset=(g(2), -g(7)),
        value_offset=(g(2), g(7)),
    )
    for pin, net in PANEL_PIN_NETS.items():
        px, py = pin_world(x, y, *PIN_COORDS[PANEL_CONN_LIB][str(pin)], 0)
        emit_label(out, net, px, py, 180, uid(PFX_LABEL, pin), justify="right bottom")
    write_chunk("02_connector", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
