#!/usr/bin/env python3
"""07_mech.py — mechanical-only schematic symbols: M3 mounting holes + fiducials.

Why these are in the schematic at all
-------------------------------------
KiCad's BOM, ERC, and Update-PCB-from-Schematic flow only see things that
exist as schematic symbols. A mounting hole or a fiducial is a real PCB
artifact that the fab will drill / expose, so each one needs a symbol on
the schematic side that owns the footprint and the reference designator.
The symbols carry no electrical pins — they're documentation + footprint
anchors.

What this script places
-----------------------
Mechanical artifacts, grouped near the lower-right of the schematic so
they don't clutter the matrix area:

  4 × Mechanical:MountingHole  →  H1..H4  →  MountingHole_3.2mm_M3
      One M3 clearance hole at each board corner. Used to bolt the
      matrix PCB into the wooden folding-board frame; also carries
      the load of the controller PCB that mates J_MAIN/J_CTRL under it.

  3 × Mechanical:Fiducial      →  FID1..FID3  →  Fiducial_1mm_Mask2mm
      Three asymmetric copper dots so JLC's pick-and-place camera can
      pin down the board's exact position + rotation before assembling
      the SMT parts. Asymmetric on purpose: the machine never confuses
      which corner is which. Strictly nice-to-have for our parts list
      (no fine-pitch ICs), but cheap insurance on a 282×282 mm board.

Idempotency
-----------
Owns prefix PFX_TEST_MECH (= "7e57"). On every run, the assembler removes
existing top-level items with that prefix and reinserts the fresh chunk.
Also calls ensure_lib_symbols() so Mechanical:MountingHole and
Mechanical:Fiducial are spliced into (lib_symbols ...) the first time
this script runs.

Schematic position only. The PCB-side positions of the same refs are
controlled by hardware-board/scripts/01_chess_grid.py.

Run with KiCad CLOSED.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    PFX_TEST_MECH,
    assemble,
    ensure_lib_symbols,
    g,
    uid,
    write_chunk,
)
from config import (
    FIDUCIAL_FOOTPRINT,
    FIDUCIAL_LIB,
    MOUNTING_HOLE_FOOTPRINT,
    MOUNTING_HOLE_LIB,
)
from geometry import (
    FIDUCIAL_X_G,
    FIDUCIAL_Y_G,
    MOUNTING_HOLE_X_G,
    MOUNTING_HOLE_Y_G,
)
from parts import place_unpinned_marker


def main() -> int:
    # Make sure the lib_symbols block in the .kicad_sch contains the
    # definitions our instances reference. Idempotent.
    ensure_lib_symbols([MOUNTING_HOLE_LIB, FIDUCIAL_LIB])

    out: list[str] = []
    n = 0

    # ── Mounting holes — H1..H4 ────────────────────────────────────────
    for i, x_g in enumerate(MOUNTING_HOLE_X_G, start=1):
        n += 1
        place_unpinned_marker(
            out,
            lib_id=MOUNTING_HOLE_LIB,
            ref=f"H{i}",
            value="MountingHole",
            footprint=MOUNTING_HOLE_FOOTPRINT,
            x=g(x_g),
            y=g(MOUNTING_HOLE_Y_G),
            uuid_prefix=PFX_TEST_MECH,
            uuid_n=n,
        )

    # ── Fiducials — FID1..FID3 ────────────────────────────────────────
    for i, x_g in enumerate(FIDUCIAL_X_G, start=1):
        n += 1
        place_unpinned_marker(
            out,
            lib_id=FIDUCIAL_LIB,
            ref=f"FID{i}",
            value="Fiducial",
            footprint=FIDUCIAL_FOOTPRINT,
            x=g(x_g),
            y=g(FIDUCIAL_Y_G),
            uuid_prefix=PFX_TEST_MECH,
            uuid_n=n,
        )

    write_chunk("07_mech", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
