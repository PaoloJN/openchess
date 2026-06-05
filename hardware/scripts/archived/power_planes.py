#!/usr/bin/env python3
"""
Add copper pour zones for power distribution:
  - +5V plane on F.Cu (front side)
  - GND plane on B.Cu (back side)

Why split it: keeps the chess board's front side mostly clean except for the
+5V pour around the sensor matrix. The GND pour fills the back side under
the support components for noise immunity.

Zones automatically connect to pads on the matching net (thermal relief by
default) and clear around other nets.
"""

import os
import shutil
import uuid

PCB_FILE = "../hardware/openchess.kicad_pcb"
BACKUP_SUFFIX = ".backup_before_power_planes"

# Board outline (matches 01_grid_placement.py)
BOARD_X = 50
BOARD_Y = 50
BOARD_W = 256
BOARD_H = 256

# Zone clearance + thermal relief defaults
CLEARANCE = 0.25     # mm distance to other nets
MIN_THICKNESS = 0.25 # mm minimum copper width
THERMAL_GAP = 0.5
THERMAL_BRIDGE = 0.5


def make_zone(net_name, layer, board_x, board_y, board_w, board_h):
    """Generate a (zone ...) S-expression for a filled copper pour."""
    zone_uuid = str(uuid.uuid4())
    return (
        '\t(zone\n'
        f'\t\t(net 0)\n'                                # placeholder net number, KiCad reassigns
        f'\t\t(net_name "{net_name}")\n'
        f'\t\t(layer "{layer}")\n'
        f'\t\t(uuid "{zone_uuid}")\n'
        '\t\t(hatch edge 0.5)\n'
        '\t\t(connect_pads\n'
        '\t\t\t(clearance 0.5)\n'
        '\t\t)\n'
        f'\t\t(min_thickness {MIN_THICKNESS})\n'
        '\t\t(filled_areas_thickness no)\n'
        '\t\t(fill\n'
        '\t\t\t(thermal_gap 0.5)\n'
        '\t\t\t(thermal_bridge_width 0.5)\n'
        '\t\t)\n'
        '\t\t(polygon\n'
        '\t\t\t(pts\n'
        f'\t\t\t\t(xy {board_x} {board_y})\n'
        f'\t\t\t\t(xy {board_x + board_w} {board_y})\n'
        f'\t\t\t\t(xy {board_x + board_w} {board_y + board_h})\n'
        f'\t\t\t\t(xy {board_x} {board_y + board_h})\n'
        '\t\t\t)\n'
        '\t\t)\n'
        '\t)\n'
    )


def main():
    pcb_path = os.path.abspath(os.path.join(os.path.dirname(__file__), PCB_FILE))
    shutil.copy(pcb_path, pcb_path + BACKUP_SUFFIX)
    print(f"Backed up to {pcb_path}{BACKUP_SUFFIX}")

    with open(pcb_path) as f:
        text = f.read()

    # Check if zones already exist (idempotent)
    if 'net_name "+5V"' in text and '(zone' in text:
        print("WARNING: PCB already has zones. Skipping to avoid duplicates.")
        print("Delete existing zones in KiCad if you want to regenerate.")
        return

    # Build the two zones
    plus_5v_zone = make_zone("+5V", "F.Cu", BOARD_X, BOARD_Y, BOARD_W, BOARD_H)
    gnd_zone = make_zone("GND", "B.Cu", BOARD_X, BOARD_Y, BOARD_W, BOARD_H)

    new_zones = plus_5v_zone + gnd_zone

    # Insert before the final closing paren of the kicad_pcb file
    text = text.rstrip()
    if text.endswith(')'):
        text = text[:-1] + new_zones + ')\n'

    with open(pcb_path, "w") as f:
        f.write(text)

    print(f"Added 2 copper pour zones:")
    print(f"  +5V on F.Cu  ({BOARD_W}x{BOARD_H}mm)")
    print(f"  GND on B.Cu  ({BOARD_W}x{BOARD_H}mm)")
    print()
    print("NEXT STEPS:")
    print("  1. Open KiCad PCB editor")
    print("  2. Press B to fill all zones (or Edit -> Fill All Zones)")
    print("  3. You should see solid copper pours appear")
    print("  4. Run 04_led_chain_route.py next")


if __name__ == "__main__":
    main()
