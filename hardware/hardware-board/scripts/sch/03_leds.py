#!/usr/bin/env python3
"""03_leds.py — place 81 WS2812B LEDs + 81 decoupling caps, wired for power
                and chained via net labels.

Layout
------
LEDs sit at the 9×9 grid CORNERS that bound the 8×8 chess-square matrix.
- Top row is row 0 (smallest world Y); bottom row is row 8.
- Left column is col 0; right column is col 8.

Refs are ROW-MAJOR (reading order, left-to-right then top-to-bottom):

    Row 0 (top):     D1  → D9     (col 0 → col 8)
    Row 1:           D10 → D18    (col 0 → col 8)
    Row 2:           D19 → D27
    …
    Row 8 (bottom): D73 → D81

D1 sits at top-left, D81 at bottom-right.

Decoupling caps (100 nF, 0805) sit just to the right of each LED with
matching index: C10 next to D1, C11 next to D2, …, C90 next to D81.

Auto-wired in this step
-----------------------
**Power** — two short manhattan wires per LED+cap pair:
  - LED VDD (top) → cap pin 1 (top of cap)  ─ right, then down
  - LED VSS (bottom) → cap pin 2 (bottom of cap)  ─ right, then up
Each cap pin is labeled `+5V_LED` / `GND`, so the LED power pins are on
those nets electrically. `+5V_LED` is kept SEPARATE from the controller
`+5V` rail to isolate WS2812 current spikes (60 mA per LED × 81 LEDs =
4.86 A worst-case peak) from clean logic supply.

**Chain** — direct wires within a row, net labels across row breaks:
  - **Within-row** (col 0..7): a horizontal wire from D_n DOUT straight
    through C_n's body to D_{n+1} DIN. Visually crosses the cap, but
    cap pins are at Y=ly±3.81 so there's no electrical contact.
  - **Row transition** (col 8 → col 0 of next row): a net label `L<n+1>`
    on D_n DOUT and the same label on D_{n+1} DIN — KiCad resolves the
    long visual jump by name.
  - **D1 DIN**: `LED_DATA_5V` — the 5 V level-shifted data signal that
    arrives via J_CTRL from the controller PCB.
  - **D81 DOUT**: `LED_DOUT_END` — useful as an end-of-chain test point.

Writes build/sch/03_leds.sexp.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    g, uid, write_chunk, assemble,
    emit_symbol, emit_wire, emit_label,
    pin_world, PIN_COORDS, PFX_LED, PFX_LED_CAP,
)
from config import (
    CAP_FOOTPRINT_0805,
    CAP_LIB,
    GND_NET,
    LED_DATA_NET,
    LED_DECOUP_VALUE,
    LED_DOUT_END_NET,
    LED_POWER_NET,
    LED_COLS,
    LED_ROWS,
    WS2812_FOOTPRINT,
    WS2812_LIB,
    WS2812_VALUE,
)
from geometry import (
    led_cap_position as cap_position,
    led_cap_ref as cap_ref,
    led_chain_index,
    led_position,
    led_ref,
)

# ────────────────────────────────────────────────────────────────────────
# Grid geometry — all values in grid units (G = 2.54 mm).
# Fits inside BOX_LED_CHAIN (290, 50, 566, 295) defined in 01_skeleton.py.
# ────────────────────────────────────────────────────────────────────────
CAP_STUB_LEN_G = 1       # short stub from cap pin to its rail label
GND_POWER_LIB  = "power:GND"


def main() -> int:
    out: list[str] = []
    rail_counter = 0   # cap-pin rail label stubs (existing)
    wire_counter = 0   # LED↔cap power wires       (new)
    chain_counter = 0  # DIN/DOUT chain labels     (new)
    chain_last_idx = LED_ROWS * LED_COLS - 1

    led_pin_vdd  = PIN_COORDS[WS2812_LIB]["1"]   # sym (0, +7.62)  → world (lx, ly-7.62)
    led_pin_dout = PIN_COORDS[WS2812_LIB]["2"]   # sym (+7.62, 0)  → world (lx+7.62, ly)
    led_pin_vss  = PIN_COORDS[WS2812_LIB]["3"]   # sym (0, -7.62)  → world (lx, ly+7.62)
    led_pin_din  = PIN_COORDS[WS2812_LIB]["4"]   # sym (-7.62, 0)  → world (lx-7.62, ly)
    cap_pin1_sym = PIN_COORDS[CAP_LIB]["1"]   # sym (0, +3.81)  → world (cx, cy-3.81) — top
    cap_pin2_sym = PIN_COORDS[CAP_LIB]["2"]   # sym (0, -3.81)  → world (cx, cy+3.81) — bottom
    stub_dy = g(CAP_STUB_LEN_G)

    for row in range(LED_ROWS):
        for col in range(LED_COLS):
            chain_idx = led_chain_index(col, row)
            n = chain_idx + 1                        # 1..81 — used for both LED and cap UUIDs

            lx, ly = led_position(col, row)
            cx, cy = cap_position(col, row)

            # ── LED ───────────────────────────────────────────────────
            emit_symbol(
                out,
                lib_id=WS2812_LIB,
                x=lx, y=ly, rot=0,
                ref=led_ref(col, row),
                value=WS2812_VALUE,
                footprint=WS2812_FOOTPRINT,
                sym_uuid=uid(PFX_LED, n),
                pin_uuids={
                    "1": uid(PFX_LED, 2000 + n * 4 + 0),
                    "2": uid(PFX_LED, 2000 + n * 4 + 1),
                    "3": uid(PFX_LED, 2000 + n * 4 + 2),
                    "4": uid(PFX_LED, 2000 + n * 4 + 3),
                },
                ref_offset=(0, -g(4)),                 # above VDD pin
                value_offset=(0, g(4)),                # below VSS pin
            )

            # ── Cap ───────────────────────────────────────────────────
            emit_symbol(
                out,
                lib_id=CAP_LIB,
                x=cx, y=cy, rot=0,
                ref=cap_ref(col, row),
                value=LED_DECOUP_VALUE,
                footprint=CAP_FOOTPRINT_0805,
                sym_uuid=uid(PFX_LED_CAP, n),
                pin_uuids={
                    "1": uid(PFX_LED_CAP, 3000 + n * 2 + 0),
                    "2": uid(PFX_LED_CAP, 3000 + n * 2 + 1),
                },
                ref_offset=(g(1), -g(1)),              # upper-right of cap body
                value_offset=(g(1), g(1)),             # lower-right of cap body
            )

            # ── Cap pin rail labels: +5V_LED on pin 1 (top), GND on pin 2 (bottom) ──
            p1x, p1y = pin_world(cx, cy, *cap_pin1_sym, 0)   # (cx, cy - 3.81)
            p2x, p2y = pin_world(cx, cy, *cap_pin2_sym, 0)   # (cx, cy + 3.81)

            rail_counter += 1
            emit_wire(out, p1x, p1y, p1x, p1y - stub_dy,
                      uid(PFX_LED_CAP, 5000 + rail_counter))
            rail_counter += 1
            emit_label(out, LED_POWER_NET, p1x, p1y - stub_dy, 90,
                       uid(PFX_LED_CAP, 5000 + rail_counter),
                       justify="left bottom")

            # GND on cap pin 2 — use a power:GND symbol rotated 180° so the
            # triangle extends DOWN, away from the cap body. The symbol's
            # pin sits exactly on cap pin 2 — no stub wire needed.
            emit_symbol(
                out,
                lib_id=GND_POWER_LIB,
                x=p2x, y=p2y, rot=180,
                ref=f"#PWR_L{n}",
                value="GND",
                footprint="",
                sym_uuid=uid(PFX_LED_CAP, 7000 + n),
                pin_uuids={"1": uid(PFX_LED_CAP, 7200 + n)},
                ref_offset=(g(1), g(1)),
                value_offset=(g(1), -g(1)),
                in_bom=False,
                on_board=False,
            )

            # ── Power wires: LED VDD → cap pin 1, LED VSS → cap pin 2 ──
            # 2-segment manhattan, routed clear of LED and cap bodies.
            vdd_x, vdd_y = pin_world(lx, ly, *led_pin_vdd, 0)   # (lx, ly - 7.62)
            vss_x, vss_y = pin_world(lx, ly, *led_pin_vss, 0)   # (lx, ly + 7.62)

            # VDD: horizontal at vdd_y from LED pin to cap_x, then vertical down to cap pin 1.
            wire_counter += 1
            emit_wire(out, vdd_x, vdd_y, cx, vdd_y,
                      uid(PFX_LED, 6000 + wire_counter))
            wire_counter += 1
            emit_wire(out, cx, vdd_y, p1x, p1y,
                      uid(PFX_LED, 6000 + wire_counter))

            # VSS: horizontal at vss_y, then vertical up to cap pin 2.
            wire_counter += 1
            emit_wire(out, vss_x, vss_y, cx, vss_y,
                      uid(PFX_LED, 6000 + wire_counter))
            wire_counter += 1
            emit_wire(out, cx, vss_y, p2x, p2y,
                      uid(PFX_LED, 6000 + wire_counter))

            # ── Chain: wires within rows, labels across row breaks ────
            din_x, din_y   = pin_world(lx, ly, *led_pin_din,  0)   # (lx - 7.62, ly)
            dout_x, dout_y = pin_world(lx, ly, *led_pin_dout, 0)   # (lx + 7.62, ly)

            # DIN side:
            #   D1 (chain_idx 0)      → LED_DATA_5V label (from J_CTRL)
            #   col 0, chain_idx > 0  → L<chain_idx> label (row transition in)
            #   col 1..8              → nothing (wire from previous LED in same row)
            if chain_idx == 0:
                chain_counter += 1
                emit_label(out, LED_DATA_NET,
                           din_x, din_y, 180,
                           uid(PFX_LED, 7000 + chain_counter),
                           justify="right bottom")
            elif col == 0:
                chain_counter += 1
                emit_label(out, f"L{chain_idx}",
                           din_x, din_y, 180,
                           uid(PFX_LED, 7000 + chain_counter),
                           justify="right bottom")

            # DOUT side:
            #   D81 (chain_last)              → LED_DOUT_END label
            #   col LED_COLS-1, not D81       → L<chain_idx + 1> label (row transition out)
            #   col 0..LED_COLS-2 (within row) → wire to next LED's DIN
            if chain_idx == chain_last_idx:
                chain_counter += 1
                emit_label(out, LED_DOUT_END_NET,
                           dout_x, dout_y, 0,
                           uid(PFX_LED, 7000 + chain_counter),
                           justify="left bottom")
            elif col == LED_COLS - 1:
                chain_counter += 1
                emit_label(out, f"L{chain_idx + 1}",
                           dout_x, dout_y, 0,
                           uid(PFX_LED, 7000 + chain_counter),
                           justify="left bottom")
            else:
                # Within-row chain wire — goes from this DOUT horizontally
                # through C_n's body to the next LED's DIN. Cap pins are at
                # Y=ly±3.81 so the wire (at Y=ly) doesn't electrically connect
                # to the cap.
                next_lx, next_ly = led_position(col + 1, row)
                next_din_x, next_din_y = pin_world(next_lx, next_ly, *led_pin_din, 0)
                chain_counter += 1
                emit_wire(out, dout_x, dout_y, next_din_x, next_din_y,
                          uid(PFX_LED, 7000 + chain_counter))

    write_chunk("03_leds", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
