"""Reusable schematic placement helpers.

The helpers do not hide the electrical design; they just package repeated
KiCad S-expression mechanics so each board script reads like a BOM/netlist.
"""
from __future__ import annotations

from _lib import (
    PIN_COORDS,
    emit_label,
    emit_symbol,
    emit_wire,
    g,
    pin_world,
    uid,
)
from config import (
    CAP_FOOTPRINT_0805,
    CAP_LIB,
    ENTRY_CAP_FOOTPRINT,
    ENTRY_CAP_LIB,
    ENTRY_CAP_VALUE,
    GND_NET,
    LED_POWER_NET,
    PWR_FLAG_LIB,
    TESTPOINT_FOOTPRINT,
    TESTPOINT_LIB,
)


def place_labeled_cap(
    out: list[str],
    *,
    lib_id: str,
    ref: str,
    value: str,
    footprint: str,
    x: float,
    y: float,
    uuid_prefix: str,
    symbol_n: int,
    pin1_net: str = LED_POWER_NET,
    pin2_net: str = GND_NET,
    pin1_angle: int = 90,
    pin2_angle: int = 270,
    stub_base: int = 200,
    stub_len_g: float = 1,
) -> None:
    emit_symbol(
        out,
        lib_id=lib_id,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value=value,
        footprint=footprint,
        sym_uuid=uid(uuid_prefix, symbol_n),
        pin_uuids={
            "1": uid(uuid_prefix, 100 + symbol_n * 2),
            "2": uid(uuid_prefix, 101 + symbol_n * 2),
        },
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
    )

    stub_dy = g(stub_len_g)
    p1x, p1y = pin_world(x, y, *PIN_COORDS[lib_id]["1"], 0)
    p2x, p2y = pin_world(x, y, *PIN_COORDS[lib_id]["2"], 0)

    emit_wire(out, p1x, p1y, p1x, p1y - stub_dy, uid(uuid_prefix, stub_base))
    emit_label(
        out,
        pin1_net,
        p1x,
        p1y - stub_dy,
        pin1_angle,
        uid(uuid_prefix, stub_base + 1),
        justify="left bottom",
    )
    emit_wire(out, p2x, p2y, p2x, p2y + stub_dy, uid(uuid_prefix, stub_base + 2))
    emit_label(
        out,
        pin2_net,
        p2x,
        p2y + stub_dy,
        pin2_angle,
        uid(uuid_prefix, stub_base + 3),
        justify="left bottom",
    )


def place_entry_cap(out: list[str], *, ref: str, x: float, y: float, uuid_prefix: str) -> None:
    place_labeled_cap(
        out,
        lib_id=ENTRY_CAP_LIB,
        ref=ref,
        value=ENTRY_CAP_VALUE,
        footprint=ENTRY_CAP_FOOTPRINT,
        x=x,
        y=y,
        uuid_prefix=uuid_prefix,
        symbol_n=1,
        stub_base=200,
        pin2_angle=90,         # GND reads bottom-to-top, matching +5V_LED
        stub_len_g=2,          # 5.08 mm stub — gives the label breathing room
    )


def place_testpoint(
    out: list[str],
    *,
    ref: str,
    net: str,
    x: float,
    y: float,
    uuid_prefix: str,
    symbol_n: int,
) -> None:
    emit_symbol(
        out,
        lib_id=TESTPOINT_LIB,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value="TestPoint",
        footprint=TESTPOINT_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, 100 + symbol_n),
        pin_uuids={"1": uid(uuid_prefix, 110 + symbol_n)},
        ref_offset=(g(1), -g(2)),
        value_offset=(g(1), -g(1)),
    )
    px, py = pin_world(x, y, *PIN_COORDS[TESTPOINT_LIB]["1"], 0)
    lx = px + g(1)
    emit_wire(out, px, py, lx, py, uid(uuid_prefix, 130 + symbol_n))
    emit_label(out, net, lx, py, 0, uid(uuid_prefix, 140 + symbol_n), justify="left bottom")


def place_power_flag(
    out: list[str],
    *,
    ref: str,
    net: str,
    x: float,
    y: float,
    uuid_prefix: str,
    symbol_n: int,
) -> None:
    emit_symbol(
        out,
        lib_id=PWR_FLAG_LIB,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value="PWR_FLAG",
        footprint="",
        sym_uuid=uid(uuid_prefix, 400 + symbol_n),
        pin_uuids={"1": uid(uuid_prefix, 410 + symbol_n)},
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
        in_bom=False,
        on_board=False,
    )
    px, py = pin_world(x, y, *PIN_COORDS[PWR_FLAG_LIB]["1"], 0)
    emit_label(out, net, px, py, 0, uid(uuid_prefix, 420 + symbol_n), justify="left bottom")


def place_unpinned_marker(
    out: list[str],
    *,
    lib_id: str,
    ref: str,
    value: str,
    footprint: str,
    x: float,
    y: float,
    uuid_prefix: str,
    uuid_n: int,
) -> None:
    emit_symbol(
        out,
        lib_id=lib_id,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value=value,
        footprint=footprint,
        sym_uuid=uid(uuid_prefix, uuid_n),
        pin_uuids={},
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
    )


def cap_symbol_defaults() -> tuple[str, str]:
    return CAP_LIB, CAP_FOOTPRINT_0805
