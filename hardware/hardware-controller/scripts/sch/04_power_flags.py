#!/usr/bin/env python3
"""04_power_flags.py — schematic-only ERC flags for controller-sourced rails."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import write_chunk, assemble
from config import GND_NET, LED_POWER_NET, LOGIC_NET
from geometry import pwr_flag_position
from parts import place_power_flag

PFX_PWR = "cafe"


def main() -> int:
    out: list[str] = []
    for idx, net in enumerate((LOGIC_NET, LED_POWER_NET, GND_NET)):
        x, y = pwr_flag_position(idx)
        place_power_flag(out, ref=f"#FLG{idx + 1}", net=net, x=x, y=y, uuid_prefix=PFX_PWR, idx=idx + 1)
    write_chunk("04_power_flags", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
