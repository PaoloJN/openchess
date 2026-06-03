#!/usr/bin/env python3
"""
Move support components (ESP32, 74HC595, transistors, resistors, caps,
button, connectors) to the back side of the PCB (B.Cu layer) and arrange
them in a logical layout.

BATT_LED (D1) stays on the front side near an edge so it remains visible.

The chess board's front side stays clean — only hall sensors and 81 LEDs.

After this script runs, open KiCad and verify the back-side layout. You may
want to use KiCad's interactive move tool to fine-tune individual positions.
"""

import re
import os
import shutil

PCB_FILE = "../hardware/openchess.kicad_pcb"
BACKUP_SUFFIX = ".backup_before_back_placement"

# Components to flip to back side, with their target positions on B.Cu
# Positions are inside the 256x256 board (50,50 to 306,306)
# Coordinates are mirrored when viewed from front, so we lay them out
# in their "back view" coordinates here (KiCad handles the mirroring)
BACK_LAYOUT = {
    # ESP32 dev board header: 2x19 pin header, takes ~50mm wide
    "U1":  (130, 280, 0),     # bottom center, dev board header

    # 74HC595 SOIC-16, ~10mm wide
    "U2":  (200, 280, 0),

    # 8 PNP transistors in a row
    "Q1":  (60, 270, 0),
    "Q2":  (70, 270, 0),
    "Q3":  (80, 270, 0),
    "Q4":  (90, 270, 0),
    "Q5":  (100, 270, 0),
    "Q6":  (110, 270, 0),
    "Q7":  (120, 270, 0),
    "Q8":  (130, 270, 0),

    # 8 base resistors below transistors
    "R1":  (60, 275, 0),
    "R2":  (70, 275, 0),
    "R3":  (80, 275, 0),
    "R4":  (90, 275, 0),
    "R5":  (100, 275, 0),
    "R6":  (110, 275, 0),
    "R7":  (120, 275, 0),
    "R8":  (130, 275, 0),

    # 8 sensor pull-up resistors (R9-R16)
    "R9":  (220, 270, 0),
    "R10": (230, 270, 0),
    "R11": (240, 270, 0),
    "R12": (250, 270, 0),
    "R13": (260, 270, 0),
    "R14": (270, 270, 0),
    "R15": (280, 270, 0),
    "R16": (290, 270, 0),

    # Caps near their respective chips
    "C1":  (210, 290, 0),     # WS2812 decoupling
    "C2":  (155, 290, 0),     # ESP32 EN cap

    # Connectors and switch on board edge for accessibility
    "J1":  (60,  300, 0),     # BAT_IN, near edge
    "J2":  (90,  300, 0),     # BOOST_MODULE
    "SW1": (270, 290, 0),     # PWR_SW
}

# Reference designators that stay on front side (don't touch)
# Note: D1 = BATT_LED — we'll leave it on front, repositioned near edge
FRONT_REPOSITION = {
    "BATT_LED": (300, 295, 0),   # Battery indicator near corner
}


def find_footprint_blocks(text):
    """Yield (start, end) tuples for each (footprint ...) block."""
    blocks = []
    i = 0
    while i < len(text):
        idx = text.find('(footprint ', i)
        if idx == -1:
            break
        depth = 1
        j = idx + len('(footprint ')
        in_string = False
        escape = False
        while depth > 0 and j < len(text):
            c = text[j]
            if escape:
                escape = False
            elif c == '\\':
                escape = True
            elif c == '"':
                in_string = not in_string
            elif not in_string:
                if c == '(':
                    depth += 1
                elif c == ')':
                    depth -= 1
            j += 1
        blocks.append((idx, j))
        i = j
    return blocks


def flip_layer(block_text):
    """Swap all 'F.*' layer references to 'B.*' to flip footprint to back side."""
    # F.Cu -> B.Cu, F.Paste -> B.Paste, F.Mask -> B.Mask, F.SilkS -> B.SilkS, F.Fab -> B.Fab
    swaps = [
        ('"F.Cu"', '"B.Cu"'),
        ('"F.Paste"', '"B.Paste"'),
        ('"F.Mask"', '"B.Mask"'),
        ('"F.SilkS"', '"B.SilkS"'),
        ('"F.Fab"', '"B.Fab"'),
        ('"F.CrtYd"', '"B.CrtYd"'),
        ('"F.Adhes"', '"B.Adhes"'),
    ]
    for old, new in swaps:
        block_text = block_text.replace(old, new)
    return block_text


def update_position(block_text, new_x, new_y, new_angle):
    """Replace the FIRST (at X Y [angle]) in the block (footprint position)."""
    at_match = re.search(r'\(at ([\-\d.]+) ([\-\d.]+)(\s+[\-\d.]+)?\)', block_text)
    if not at_match:
        return block_text
    new_at = f"(at {new_x} {new_y} {new_angle})"
    return block_text[:at_match.start()] + new_at + block_text[at_match.end():]


def main():
    pcb_path = os.path.abspath(os.path.join(os.path.dirname(__file__), PCB_FILE))
    shutil.copy(pcb_path, pcb_path + BACKUP_SUFFIX)
    print(f"Backed up to {pcb_path}{BACKUP_SUFFIX}")

    with open(pcb_path) as f:
        text = f.read()

    blocks = find_footprint_blocks(text)
    print(f"Found {len(blocks)} footprint blocks total")

    # Process in reverse to preserve offsets when modifying
    moved_count = 0
    flipped_count = 0

    # Collect changes first
    changes = []   # (start, end, new_block_text, action)
    for start, end in blocks:
        block_text = text[start:end]
        ref_match = re.search(r'\(property "Reference" "([^"]+)"', block_text)
        if not ref_match:
            continue
        ref = ref_match.group(1)

        if ref in BACK_LAYOUT:
            x, y, angle = BACK_LAYOUT[ref]
            new_block = update_position(block_text, x, y, angle)
            new_block = flip_layer(new_block)
            changes.append((start, end, new_block, f"FLIPPED+MOVED {ref} -> ({x}, {y}) on B.Cu"))
        elif ref in FRONT_REPOSITION:
            x, y, angle = FRONT_REPOSITION[ref]
            new_block = update_position(block_text, x, y, angle)
            changes.append((start, end, new_block, f"MOVED {ref} -> ({x}, {y}) on F.Cu (kept on front)"))

    # Apply in reverse
    changes.sort(key=lambda c: c[0], reverse=True)
    for s, e, new_text, msg in changes:
        text = text[:s] + new_text + text[e:]
        print(f"  {msg}")
        if "FLIPPED" in msg:
            flipped_count += 1
        moved_count += 1

    with open(pcb_path, "w") as f:
        f.write(text)

    print()
    print(f"Total: {moved_count} components moved ({flipped_count} flipped to back side)")
    print()
    print("NEXT STEPS:")
    print("  1. Open KiCad PCB editor")
    print("  2. Press B to view back side (or F to flip view)")
    print("  3. Verify components are placed sensibly")
    print("  4. Manually fine-tune any that look wrong (use M key to move)")
    print("  5. Run 03_power_planes.py next")


if __name__ == "__main__":
    main()
