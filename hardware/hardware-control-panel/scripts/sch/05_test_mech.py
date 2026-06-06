#!/usr/bin/env python3
"""05_test_mech.py — testpoints, mounting holes, and fiducials."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import g, write_chunk, assemble, PFX_TEST_MECH
from config import FIDUCIAL_FOOTPRINT, FIDUCIAL_LIB, TESTPOINT_NETS
from geometry import FIDUCIAL_X_G, FIDUCIAL_Y_G, MOUNTING_HOLE_X_G, MOUNTING_HOLE_Y_G, testpoint_position
from parts import place_mounting_hole, place_testpoint, place_unpinned_marker


def main() -> int:
    out: list[str] = []
    for idx, net in enumerate(TESTPOINT_NETS):
        x, y = testpoint_position(idx)
        place_testpoint(out, ref=f"TP{idx + 1}", net=net, x=x, y=y, uuid_prefix=PFX_TEST_MECH, idx=idx + 1)
    for idx, xg in enumerate(MOUNTING_HOLE_X_G):
        place_mounting_hole(out, ref=f"MH{idx + 1}", x=g(xg), y=g(MOUNTING_HOLE_Y_G), uuid_prefix=PFX_TEST_MECH, idx=300 + idx)
    for idx, xg in enumerate(FIDUCIAL_X_G):
        place_unpinned_marker(out, lib_id=FIDUCIAL_LIB, ref=f"FID{idx + 1}", value="Fiducial", footprint=FIDUCIAL_FOOTPRINT, x=g(xg), y=g(FIDUCIAL_Y_G), uuid_prefix=PFX_TEST_MECH, idx=400 + idx)
    write_chunk("05_test_mech", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
