"""Reusable schematic placement helpers for the control panel."""
from __future__ import annotations

from _lib import PIN_COORDS, emit_label, emit_symbol, emit_wire, g, pin_world, uid
from config import (
    BUTTON_FOOTPRINT,
    GND_NET,
    LED_FOOTPRINT,
    LED_RESISTOR_FOOTPRINT,
    LED_SERIES_VALUE,
    LOGIC_NET,
    MOUNTING_HOLE_FOOTPRINT,
    MOUNTING_HOLE_LIB,
    PWR_FLAG_LIB,
    R_LIB,
    SW_LIB,
    LED_LIB,
    TESTPOINT_FOOTPRINT,
    TESTPOINT_LIB,
)


def place_status_led(out: list[str], *, idx: int, label: str, sink_net: str, x: float, y: float, uuid_prefix: str) -> None:
    r_ref = f"R{idx + 1}"
    d_ref = f"D{idx + 1}"
    mid_net = f"LED_{label}_A"
    rx = x - g(5)
    dx = x + g(5)

    emit_symbol(
        out,
        lib_id=R_LIB,
        x=rx,
        y=y,
        rot=90,
        ref=r_ref,
        value=LED_SERIES_VALUE,
        footprint=LED_RESISTOR_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, 100 + idx),
        pin_uuids={"1": uid(uuid_prefix, 200 + idx * 2), "2": uid(uuid_prefix, 201 + idx * 2)},
        ref_offset=(g(-1), -g(3)),
        value_offset=(g(-1), g(3)),
    )
    r1 = pin_world(rx, y, *PIN_COORDS[R_LIB]["1"], 90)
    r2 = pin_world(rx, y, *PIN_COORDS[R_LIB]["2"], 90)
    emit_label(out, LOGIC_NET, *r1, 180, uid(uuid_prefix, 300 + idx * 4), justify="right bottom")
    emit_label(out, mid_net, *r2, 0, uid(uuid_prefix, 301 + idx * 4), justify="left bottom")

    emit_symbol(
        out,
        lib_id=LED_LIB,
        x=dx,
        y=y,
        rot=0,
        ref=d_ref,
        value=label,
        footprint=LED_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, 400 + idx),
        pin_uuids={"1": uid(uuid_prefix, 500 + idx * 2), "2": uid(uuid_prefix, 501 + idx * 2)},
        ref_offset=(g(-1), -g(3)),
        value_offset=(g(-1), g(3)),
    )
    k = pin_world(dx, y, *PIN_COORDS[LED_LIB]["1"], 0)
    a = pin_world(dx, y, *PIN_COORDS[LED_LIB]["2"], 0)
    emit_label(out, sink_net, *k, 180, uid(uuid_prefix, 302 + idx * 4), justify="right bottom")
    emit_label(out, mid_net, *a, 0, uid(uuid_prefix, 303 + idx * 4), justify="left bottom")


def place_button(out: list[str], *, idx: int, label: str, net: str, x: float, y: float, uuid_prefix: str) -> None:
    emit_symbol(
        out,
        lib_id=SW_LIB,
        x=x,
        y=y,
        rot=0,
        ref=f"SW{idx + 1}",
        value=label,
        footprint=BUTTON_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, 700 + idx),
        pin_uuids={"1": uid(uuid_prefix, 800 + idx * 2), "2": uid(uuid_prefix, 801 + idx * 2)},
        ref_offset=(g(-1), -g(3)),
        value_offset=(g(-1), g(3)),
    )
    p1 = pin_world(x, y, *PIN_COORDS[SW_LIB]["1"], 0)
    p2 = pin_world(x, y, *PIN_COORDS[SW_LIB]["2"], 0)
    emit_label(out, net, *p1, 180, uid(uuid_prefix, 900 + idx * 2), justify="right bottom")
    emit_label(out, GND_NET, *p2, 0, uid(uuid_prefix, 901 + idx * 2), justify="left bottom")


def place_testpoint(out: list[str], *, ref: str, net: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(out, lib_id=TESTPOINT_LIB, x=x, y=y, rot=0, ref=ref, value="TestPoint", footprint=TESTPOINT_FOOTPRINT, sym_uuid=uid(uuid_prefix, 100 + idx), pin_uuids={"1": uid(uuid_prefix, 200 + idx)}, ref_offset=(g(1), -g(2)), value_offset=(g(1), -g(1)))
    px, py = pin_world(x, y, *PIN_COORDS[TESTPOINT_LIB]["1"], 0)
    emit_wire(out, px, py, px + g(1), py, uid(uuid_prefix, 300 + idx))
    emit_label(out, net, px + g(1), py, 0, uid(uuid_prefix, 400 + idx), justify="left bottom")


def place_unpinned_marker(out: list[str], *, lib_id: str, ref: str, value: str, footprint: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(out, lib_id=lib_id, x=x, y=y, rot=0, ref=ref, value=value, footprint=footprint, sym_uuid=uid(uuid_prefix, idx), pin_uuids={}, ref_offset=(g(1), -g(1)), value_offset=(g(1), g(1)))


def place_mounting_hole(out: list[str], *, ref: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    place_unpinned_marker(out, lib_id=MOUNTING_HOLE_LIB, ref=ref, value="M3", footprint=MOUNTING_HOLE_FOOTPRINT, x=x, y=y, uuid_prefix=uuid_prefix, idx=idx)


def place_power_flag(out: list[str], *, ref: str, net: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(out, lib_id=PWR_FLAG_LIB, x=x, y=y, rot=0, ref=ref, value="PWR_FLAG", footprint="", sym_uuid=uid(uuid_prefix, 700 + idx), pin_uuids={"1": uid(uuid_prefix, 800 + idx)}, ref_offset=(g(1), -g(1)), value_offset=(g(1), g(1)), in_bom=False, on_board=False)
    px, py = pin_world(x, y, *PIN_COORDS[PWR_FLAG_LIB]["1"], 0)
    emit_label(out, net, px, py, 0, uid(uuid_prefix, 900 + idx), justify="left bottom")
