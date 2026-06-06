#!/usr/bin/env python3
"""04_power_flags.py — schematic-only ERC flags for externally supplied rails."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import g, write_chunk, assemble
from config import GND_NET, LOGIC_NET
from geometry import PWR_FLAG_X_G, PWR_FLAG_Y_G
from parts import place_power_flag

PFX_PWR = "f00d"


def main() -> int:
    out: list[str] = []
    for idx, net in enumerate((LOGIC_NET, GND_NET)):
        place_power_flag(out, ref=f"#FLG{idx + 1}", net=net, x=g(PWR_FLAG_X_G), y=g(PWR_FLAG_Y_G + idx * 5), uuid_prefix=PFX_PWR, idx=idx + 1)
    write_chunk("04_power_flags", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
