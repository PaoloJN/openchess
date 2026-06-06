#!/usr/bin/env python3
"""03_controls.py — status LEDs and pushbuttons."""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import write_chunk, assemble, PFX_LED
from config import BUTTON_LABELS, BUTTON_NETS, LED_LABELS, LED_NETS
from geometry import button_position, led_position
from parts import place_button, place_status_led

PFX_BUTTON = "b007"


def main() -> int:
    out: list[str] = []
    for idx, (label, net) in enumerate(zip(LED_LABELS, LED_NETS)):
        x, y = led_position(idx)
        place_status_led(out, idx=idx, label=label, sink_net=net, x=x, y=y, uuid_prefix=PFX_LED)
    for idx, (label, net) in enumerate(zip(BUTTON_LABELS, BUTTON_NETS)):
        x, y = button_position(idx)
        place_button(out, idx=idx, label=label, net=net, x=x, y=y, uuid_prefix=PFX_BUTTON)
    write_chunk("03_controls", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
