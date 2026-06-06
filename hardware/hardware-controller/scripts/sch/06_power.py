#!/usr/bin/env python3
"""06_power.py — USB-C 5V input + +3V3 LDO.

Architecture
------------
USB-C VBUS ────────────────► +5V_LED rail
   │                              │
   │                              ├─► C1, C2 (10uF bulk)
   │                              │
   │                              ├─► C3 (1uF) ─► U1 VIN ─► VOUT ─► +3V3
   │                              │                                  │
   │                              │                                  └─► C4 (1uF) ─► GND
   │                              │
   CC1 ── R9 5.1k ── GND         (U1 EN tied to VIN — always on)
   CC2 ── R10 5.1k ── GND
   D+, D-, SBU1, SBU2 ────────── no_connect (power-only USB, no PD)
   SHIELD ─────────────────────── GND

Net labels emitted by this chunk: +5V_LED, GND, +3V3.
Connectivity to the rest of the schematic is by label name.

Run with KiCad CLOSED. Writes build/sch/06_power.sexp and reassembles.
"""
from __future__ import annotations
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import (
    g, uid, write_chunk, assemble,
    emit_symbol, emit_wire, emit_label, emit_no_connect,
    pin_world, PIN_COORDS,
    PFX_USB, PFX_PWR_RAIL, PFX_LDO, PFX_PWR_LABEL,
)
from config import (
    BULK_CAP_5V_COUNT, BULK_CAP_5V_FOOTPRINT, BULK_CAP_5V_VALUE,
    C_LIB,
    GND_NET, LED_POWER_NET, LOGIC_NET,
    LDO_CAP_FOOTPRINT, LDO_CAP_VALUE,
    LDO_FOOTPRINT, LDO_LIB, LDO_REF, LDO_VALUE,
    R_LIB,
    USB_C_FOOTPRINT, USB_C_LIB, USB_C_NC_PINS, USB_C_REF, USB_C_VALUE,
    USB_CC_PULLDOWN_FOOTPRINT, USB_CC_PULLDOWN_VALUE,
)
from geometry import (
    bulk_cap_position, cc_pulldown_position,
    ldo_in_cap_position, ldo_out_cap_position, ldo_position,
    usb_c_position,
)


# ────────────────────────────────────────────────────────────────────────
# Local helpers — kept here because this is the only chunk that uses
# them. If a second chunk needs decoupling caps, refactor into parts.py.
# ────────────────────────────────────────────────────────────────────────
def _place_vertical_cap(
    out: list[str], *,
    ref: str, value: str, footprint: str,
    x: float, y: float,
    top_net: str, bottom_net: str,
    uuid_prefix: str, idx: int,
) -> None:
    """Place a vertical Device:C with pin 1 (top) on top_net and pin 2
    (bottom) on bottom_net. Stub + label on each pin."""
    emit_symbol(
        out,
        lib_id=C_LIB,
        x=x, y=y, rot=0,
        ref=ref, value=value, footprint=footprint,
        sym_uuid=uid(uuid_prefix, idx),
        pin_uuids={
            "1": uid(uuid_prefix, 100 + idx * 2),
            "2": uid(uuid_prefix, 101 + idx * 2),
        },
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
    )
    p1x, p1y = pin_world(x, y, *PIN_COORDS[C_LIB]["1"], 0)  # top
    p2x, p2y = pin_world(x, y, *PIN_COORDS[C_LIB]["2"], 0)  # bottom

    # Stub up from pin 1, down from pin 2, then label.
    emit_wire(out, p1x, p1y, p1x, p1y - g(1), uid(uuid_prefix, 300 + idx * 4))
    emit_label(out, top_net, p1x, p1y - g(1), 90,
               uid(uuid_prefix, 301 + idx * 4), justify="left bottom")
    emit_wire(out, p2x, p2y, p2x, p2y + g(1), uid(uuid_prefix, 302 + idx * 4))
    emit_label(out, bottom_net, p2x, p2y + g(1), 270,
               uid(uuid_prefix, 303 + idx * 4), justify="left bottom")


def _place_cc_pulldown(
    out: list[str], *,
    ref: str, x: float, y: float, idx: int,
) -> None:
    """Place a horizontal (rot 90) 5.1k from a CC pin to GND.

    Pin 1 of the resistor lands exactly on the USB-C CC pin endpoint
    one grid to the left; pin 2 gets a GND label one grid to the right.
    Implicit pin-to-pin connection at pin 1 (no junction needed).
    """
    emit_symbol(
        out,
        lib_id=R_LIB,
        x=x, y=y, rot=90,
        ref=ref, value=USB_CC_PULLDOWN_VALUE,
        footprint=USB_CC_PULLDOWN_FOOTPRINT,
        sym_uuid=uid(PFX_USB, 400 + idx),
        pin_uuids={
            "1": uid(PFX_USB, 500 + idx * 2),
            "2": uid(PFX_USB, 501 + idx * 2),
        },
        ref_offset=(-g(1), -g(1)),
        value_offset=(-g(1), g(1)),
    )
    p2x, p2y = pin_world(x, y, *PIN_COORDS[R_LIB]["2"], 90)
    emit_label(out, GND_NET, p2x, p2y, 0,
               uid(PFX_USB, 600 + idx), justify="left bottom")


def main() -> int:
    out: list[str] = []

    # ── USB-C receptacle ───────────────────────────────────────────────
    ux, uy = usb_c_position()
    emit_symbol(
        out,
        lib_id=USB_C_LIB,
        x=ux, y=uy, rot=0,
        ref=USB_C_REF, value=USB_C_VALUE, footprint=USB_C_FOOTPRINT,
        sym_uuid=uid(PFX_USB, 1),
        # All 17 pins — even hidden duplicates need UUIDs in the instance.
        pin_uuids={k: uid(PFX_USB, 10 + i)
                   for i, k in enumerate(PIN_COORDS[USB_C_LIB].keys())},
        ref_offset=(g(-4), g(-10)),
        value_offset=(g(-4), g(-9)),
    )

    # VBUS pin (A4 is visible, A9/B4/B9 are stacked at the same point —
    # labeling once covers all four).
    vbus_xy = pin_world(ux, uy, *PIN_COORDS[USB_C_LIB]["A4"], 0)
    emit_wire(out, *vbus_xy, vbus_xy[0] + g(1), vbus_xy[1],
              uid(PFX_USB, 100))
    emit_label(out, LED_POWER_NET, vbus_xy[0] + g(1), vbus_xy[1], 0,
               uid(PFX_PWR_LABEL, 1), justify="left bottom")

    # GND pin (A1 visible, A12/B1/B12 stacked).
    gnd_xy = pin_world(ux, uy, *PIN_COORDS[USB_C_LIB]["A1"], 0)
    emit_wire(out, *gnd_xy, gnd_xy[0], gnd_xy[1] + g(1),
              uid(PFX_USB, 101))
    emit_label(out, GND_NET, gnd_xy[0], gnd_xy[1] + g(1), 270,
               uid(PFX_PWR_LABEL, 2), justify="left bottom")

    # SHIELD → GND.
    sh_xy = pin_world(ux, uy, *PIN_COORDS[USB_C_LIB]["SH"], 0)
    emit_wire(out, *sh_xy, sh_xy[0], sh_xy[1] + g(1),
              uid(PFX_USB, 102))
    emit_label(out, GND_NET, sh_xy[0], sh_xy[1] + g(1), 270,
               uid(PFX_PWR_LABEL, 3), justify="left bottom")

    # Data + sideband pins → no_connect at the pin endpoint.
    for i, pin in enumerate(USB_C_NC_PINS):
        nc_xy = pin_world(ux, uy, *PIN_COORDS[USB_C_LIB][pin], 0)
        emit_no_connect(out, *nc_xy, uid(PFX_USB, 200 + i))

    # ── CC1, CC2 pulldowns (5.1k → GND) ────────────────────────────────
    cc1_x, cc1_y = cc_pulldown_position(0)
    _place_cc_pulldown(out, ref="R9", x=cc1_x, y=cc1_y, idx=0)
    cc2_x, cc2_y = cc_pulldown_position(1)
    _place_cc_pulldown(out, ref="R10", x=cc2_x, y=cc2_y, idx=1)

    # ── Bulk caps on +5V_LED ──────────────────────────────────────────
    for i in range(BULK_CAP_5V_COUNT):
        bx, by = bulk_cap_position(i)
        _place_vertical_cap(
            out,
            ref=f"C{i + 1}",
            value=BULK_CAP_5V_VALUE,
            footprint=BULK_CAP_5V_FOOTPRINT,
            x=bx, y=by,
            top_net=LED_POWER_NET, bottom_net=GND_NET,
            uuid_prefix=PFX_PWR_RAIL, idx=i,
        )

    # ── LDO input cap C3 ───────────────────────────────────────────────
    cinx, ciny = ldo_in_cap_position()
    _place_vertical_cap(
        out,
        ref="C3", value=LDO_CAP_VALUE, footprint=LDO_CAP_FOOTPRINT,
        x=cinx, y=ciny,
        top_net=LED_POWER_NET, bottom_net=GND_NET,
        uuid_prefix=PFX_PWR_RAIL, idx=10,
    )

    # ── +3V3 LDO U1 ────────────────────────────────────────────────────
    lx, ly = ldo_position()
    emit_symbol(
        out,
        lib_id=LDO_LIB,
        x=lx, y=ly, rot=0,
        ref=LDO_REF, value=LDO_VALUE, footprint=LDO_FOOTPRINT,
        sym_uuid=uid(PFX_LDO, 1),
        pin_uuids={str(p): uid(PFX_LDO, 10 + p) for p in range(1, 6)},
        ref_offset=(g(2), -g(3)),
        value_offset=(g(2), -g(2)),
    )
    vin_xy  = pin_world(lx, ly, *PIN_COORDS[LDO_LIB]["1"], 0)  # VIN
    gnd2_xy = pin_world(lx, ly, *PIN_COORDS[LDO_LIB]["2"], 0)  # GND
    en_xy   = pin_world(lx, ly, *PIN_COORDS[LDO_LIB]["3"], 0)  # EN
    vout_xy = pin_world(lx, ly, *PIN_COORDS[LDO_LIB]["5"], 0)  # VOUT
    # Pin 4 (NC) is declared no_connect in the library — no explicit marker needed.

    # VIN ← +5V_LED (label extending left).
    emit_wire(out, *vin_xy, vin_xy[0] - g(1), vin_xy[1],
              uid(PFX_LDO, 100))
    emit_label(out, LED_POWER_NET, vin_xy[0] - g(1), vin_xy[1], 180,
               uid(PFX_PWR_LABEL, 10), justify="right bottom")

    # EN ← +5V_LED (always on).
    emit_wire(out, *en_xy, en_xy[0] - g(1), en_xy[1],
              uid(PFX_LDO, 101))
    emit_label(out, LED_POWER_NET, en_xy[0] - g(1), en_xy[1], 180,
               uid(PFX_PWR_LABEL, 11), justify="right bottom")

    # GND ↓.
    emit_wire(out, *gnd2_xy, gnd2_xy[0], gnd2_xy[1] + g(1),
              uid(PFX_LDO, 102))
    emit_label(out, GND_NET, gnd2_xy[0], gnd2_xy[1] + g(1), 270,
               uid(PFX_PWR_LABEL, 12), justify="left bottom")

    # VOUT → +3V3 (label extending right).
    emit_wire(out, *vout_xy, vout_xy[0] + g(1), vout_xy[1],
              uid(PFX_LDO, 103))
    emit_label(out, LOGIC_NET, vout_xy[0] + g(1), vout_xy[1], 0,
               uid(PFX_PWR_LABEL, 13), justify="left bottom")

    # ── LDO output cap C4 ──────────────────────────────────────────────
    coutx, couty = ldo_out_cap_position()
    _place_vertical_cap(
        out,
        ref="C4", value=LDO_CAP_VALUE, footprint=LDO_CAP_FOOTPRINT,
        x=coutx, y=couty,
        top_net=LOGIC_NET, bottom_net=GND_NET,
        uuid_prefix=PFX_PWR_RAIL, idx=11,
    )

    write_chunk("06_power", out)
    assemble()
    return 0


if __name__ == "__main__":
    sys.exit(main())
