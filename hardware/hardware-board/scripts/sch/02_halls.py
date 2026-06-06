#!/usr/bin/env python3
"""02_halls.py — place 64 A3144 hall sensors in an 8×8 grid with pin label stubs.

Layout
------
8 files (A..H, x increases L→R) × 8 ranks (1..8, increases bottom→top
on the page in chess convention). The U-ref formula is:

    U(1 + file_idx*8 + rank_idx)        # file 0..7, rank 0..7

so U1 = A1 (bottom-left, white queenside) and U64 = H8 (top-right,
black kingside).

Each hall gets three short wire stubs leftward off its pins, terminated
by regular wire labels that name the net:

    Pin 1 VCC   → CA_PWR..CH_PWR    (file-determined column rail)
    Pin 2 GND   → GND
    Pin 3 OUT   → S0..S7            (rank-determined open-collector sense)

Pin coordinates come from `_lib.PIN_COORDS["openchess:A3144"]` and are
mapped to world coordinates via `pin_world()` — so the Y-axis inversion
that bit the monolithic generator is handled in exactly one place.

Run with KiCad CLOSED. Writes build/sch/02_halls.sexp and reassembles
the schematic.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    g, uid, write_chunk, assemble,
    emit_symbol, emit_wire, emit_label,
    pin_world, PIN_COORDS, PFX_HALL,
)
from config import (
    A3144_FOOTPRINT,
    A3144_LIB,
    A3144_VALUE,
    COL_PWR_NETS,
    ROW_SENSE_NETS,
)
from geometry import hall_position

GND_POWER_LIB = "power:GND"

STUB_LEN_G     = 2    # wire stub length from pin endpoint to label anchor


def hall_ref(file_idx: int, rank_idx: int) -> str:
    return f"U{1 + file_idx * 8 + rank_idx}"


def col_pwr_net(file_idx: int) -> str:
    return COL_PWR_NETS[file_idx]


def row_sense_net(rank_idx: int) -> str:
    return ROW_SENSE_NETS[rank_idx]


def main() -> int:
    out: list[str] = []
    stub_counter = 0   # local — scoped to PFX_HALL "5xxx" range below

    pin_vcc = PIN_COORDS[A3144_LIB]["1"]   # sym (-5.08, +2.54)
    pin_gnd = PIN_COORDS[A3144_LIB]["2"]   # sym (-5.08,  0)
    pin_out = PIN_COORDS[A3144_LIB]["3"]   # sym (-5.08, -2.54)

    for file_idx in range(8):
        for rank_idx in range(8):
            wx, wy = hall_position(file_idx, rank_idx)
            ref = hall_ref(file_idx, rank_idx)
            n = file_idx * 8 + rank_idx + 1   # 1..64

            emit_symbol(
                out,
                lib_id=A3144_LIB,
                x=wx, y=wy, rot=0,
                ref=ref,
                value=A3144_VALUE,
                footprint=A3144_FOOTPRINT,
                sym_uuid=uid(PFX_HALL, n),
                pin_uuids={
                    "1": uid(PFX_HALL, 1000 + n * 3 + 0),
                    "2": uid(PFX_HALL, 1000 + n * 3 + 1),
                    "3": uid(PFX_HALL, 1000 + n * 3 + 2),
                },
                ref_offset=(g(1), -g(1)),       # upper-right of body
                value_offset=(g(1), g(2)),      # lower-right of body
            )

            # Pin endpoints in world coords, with Y-inversion handled in pin_world.
            vcc = pin_world(wx, wy, *pin_vcc, 0)   # (wx-5.08, wy-2.54) — top pin
            gnd = pin_world(wx, wy, *pin_gnd, 0)   # (wx-5.08, wy)      — middle pin
            outp = pin_world(wx, wy, *pin_out, 0)  # (wx-5.08, wy+2.54) — bottom pin

            stub_dx = g(STUB_LEN_G)

            # VCC and OUT — keep the existing stub+label pattern.
            for pin_world_pos, net_name in (
                (vcc,  col_pwr_net(file_idx)),
                (outp, row_sense_net(rank_idx)),
            ):
                px, py = pin_world_pos
                lx = px - stub_dx
                stub_counter += 1
                emit_wire(out, px, py, lx, py,
                          uid(PFX_HALL, 5000 + stub_counter))
                stub_counter += 1
                emit_label(out, net_name, lx, py, 180,
                           uid(PFX_HALL, 5000 + stub_counter),
                           justify="right bottom")

            # GND — drop a power:GND symbol AT the pin endpoint, rotated 270°
            # so the triangle extends in the user's preferred direction. The
            # symbol's pin coincides with the hall's GND pin — no stub needed.
            # ref (#PWR_Hn) is hidden; the triangle body itself reads as GND.
            emit_symbol(
                out,
                lib_id=GND_POWER_LIB,
                x=gnd[0], y=gnd[1], rot=270,
                ref=f"#PWR_H{n}",
                value="GND",
                footprint="",
                sym_uuid=uid(PFX_HALL, 7000 + n),
                pin_uuids={"1": uid(PFX_HALL, 7200 + n)},
                ref_offset=(g(-1), -g(1)),
                value_offset=(g(-1), g(1)),
                in_bom=False,
                on_board=False,
                hide_ref=True,    # hide the #PWR_Hn reference
                # value "GND" stays visible as a small label next to the triangle
            )

    write_chunk("02_halls", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
