#!/usr/bin/env python3
"""03_row_pullups.py — 10k pullups for Hall row-sense nets S0..S7."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import write_chunk, assemble, PFX_PULLUP
from config import LOGIC_NET, ROW_SENSE_NETS
from geometry import pullup_position
from parts import place_row_pullup


def main() -> int:
    out: list[str] = []
    for idx, net in enumerate(ROW_SENSE_NETS):
        x, y = pullup_position(idx)
        place_row_pullup(
            out,
            ref=f"R{idx + 1}",
            sense_net=net,
            logic_net=LOGIC_NET,
            x=x,
            y=y,
            uuid_prefix=PFX_PULLUP,
            idx=idx + 1,
        )
    write_chunk("03_row_pullups", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
