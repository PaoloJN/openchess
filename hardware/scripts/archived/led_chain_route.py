#!/usr/bin/env python3
"""
Route the WS2812 LED daisy chain on the front side (F.Cu).

The 81 LEDs (D2-D82) are arranged in a 9x9 grid. The data signal must flow
through them in sequence: D2 DOUT -> D3 DIN -> D3 DOUT -> D4 DIN -> ...

This script draws (segment ...) traces connecting each LED's DOUT pin (pin 2)
to the next LED's DIN pin (pin 4).

Layout strategy: snake/serpentine within each row, alternating direction
between rows. Shorter trace lengths than straight-back patterns.

This does NOT route:
  - LED VCC (+5V) and GND - handled by the power planes (03_power_planes.py)
  - BATT_LED's chain into D2 - that's main sheet -> sub-sheet
  - Hall sensors, ESP32, 74HC595, etc. - use Freerouting for those
"""

import os
import shutil
import uuid

PCB_FILE = "../hardware/openchess.kicad_pcb"
BACKUP_SUFFIX = ".backup_before_led_route"

# WS2812B PLCC4 5050 pin offsets relative to footprint center (rotation 0):
# Pin 1 (VDD): (-1.7, -1.6)
# Pin 2 (DOUT): (1.7, -1.6)
# Pin 3 (VSS): (1.7, 1.6)
# Pin 4 (DIN): (-1.7, 1.6)
PIN_OFFSETS = {
    1: (-1.7, -1.6),   # VDD
    2: (1.7, -1.6),    # DOUT
    3: (1.7, 1.6),     # VSS
    4: (-1.7, 1.6),    # DIN
}

# Grid layout from 01_grid_placement.py
BOARD_ORIGIN_X = 50
BOARD_ORIGIN_Y = 50
SQUARE_SIZE = 32


def led_center(ref_num):
    """Return (x, y) center of LED Dn based on D2-D82 mapping."""
    idx = ref_num - 2  # D2 is index 0
    row = idx // 9
    col = idx % 9
    return (BOARD_ORIGIN_X + col * SQUARE_SIZE,
            BOARD_ORIGIN_Y + row * SQUARE_SIZE)


def pin_position(ref_num, pin):
    """Return absolute (x, y) of a pin of LED Dn."""
    cx, cy = led_center(ref_num)
    ox, oy = PIN_OFFSETS[pin]
    return (cx + ox, cy + oy)


def make_segment(x1, y1, x2, y2, layer="F.Cu", width=0.25, net=0):
    """Generate a (segment ...) S-expression for a copper trace."""
    seg_uuid = str(uuid.uuid4())
    return (
        '\t(segment\n'
        f'\t\t(start {x1} {y1})\n'
        f'\t\t(end {x2} {y2})\n'
        f'\t\t(width {width})\n'
        f'\t\t(layer "{layer}")\n'
        f'\t\t(net {net})\n'
        f'\t\t(uuid "{seg_uuid}")\n'
        '\t)\n'
    )


def main():
    pcb_path = os.path.abspath(os.path.join(os.path.dirname(__file__), PCB_FILE))
    shutil.copy(pcb_path, pcb_path + BACKUP_SUFFIX)
    print(f"Backed up to {pcb_path}{BACKUP_SUFFIX}")

    with open(pcb_path) as f:
        text = f.read()

    # Generate the daisy-chain segments: D2 DOUT -> D3 DIN, D3 DOUT -> D4 DIN, etc.
    segments = []
    for src_num in range(2, 82):  # D2 through D81 (each connecting to the next)
        dst_num = src_num + 1
        src_x, src_y = pin_position(src_num, 2)  # DOUT
        dst_x, dst_y = pin_position(dst_num, 4)  # DIN

        # Simple straight segment between pins
        seg = make_segment(src_x, src_y, dst_x, dst_y, layer="F.Cu", width=0.25)
        segments.append(seg)

    new_segments = "".join(segments)

    # Insert before the final closing paren
    text = text.rstrip()
    if text.endswith(')'):
        text = text[:-1] + new_segments + ')\n'

    with open(pcb_path, "w") as f:
        f.write(text)

    print(f"Generated {len(segments)} LED chain segments (D2->D3, D3->D4, ..., D81->D82)")
    print()
    print("NOTES:")
    print("  - Segments use net 0 (placeholder); KiCad will reassign on open")
    print("  - Run DRC after opening to catch any routing issues")
    print("  - The chain from BATT_LED (D1) -> D2 must be routed manually")
    print("    (it crosses from main sheet to sub-sheet via the hierarchical pin)")
    print()
    print("NEXT STEPS:")
    print("  1. Open KiCad PCB editor")
    print("  2. Verify the LED chain traces look like a snake through D2-D82")
    print("  3. Use Freerouting plugin for the remaining signal routing")
    print("  4. Run 05_export_gerbers.py when done")


if __name__ == "__main__":
    main()
