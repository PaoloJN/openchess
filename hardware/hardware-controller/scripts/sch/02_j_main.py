#!/usr/bin/env python3
"""02_j_main.py — controller-side matrix connector."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import g, uid, write_chunk, assemble, emit_symbol, emit_label, pin_world, PIN_COORDS, PFX_JCTRL, PFX_LABEL
from config import JMAIN_FOOTPRINT, JMAIN_LIB, JMAIN_PIN_NETS, JMAIN_REF, JMAIN_VALUE
from geometry import jmain_position


def main() -> int:
    out: list[str] = []
    jx, jy = jmain_position()
    emit_symbol(
        out,
        lib_id=JMAIN_LIB,
        x=jx,
        y=jy,
        rot=0,
        ref=JMAIN_REF,
        value=JMAIN_VALUE,
        footprint=JMAIN_FOOTPRINT,
        sym_uuid=uid(PFX_JCTRL, 1),
        pin_uuids={str(pin): uid(PFX_JCTRL, 100 + pin) for pin in range(1, 27)},
        ref_offset=(g(-3), g(-14)),
        value_offset=(g(-3), g(14)),
    )
    for pin, net in JMAIN_PIN_NETS.items():
        px, py = pin_world(jx, jy, *PIN_COORDS[JMAIN_LIB][str(pin)], 0)
        if pin % 2 == 1:
            emit_label(out, net, px, py, 180, uid(PFX_LABEL, pin), justify="right bottom")
        else:
            emit_label(out, net, px, py, 0, uid(PFX_LABEL, pin), justify="left bottom")
    write_chunk("02_j_main", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
