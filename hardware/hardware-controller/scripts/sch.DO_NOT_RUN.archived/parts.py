"""Reusable schematic placement helpers for the controller board."""
from __future__ import annotations

from _lib import PIN_COORDS, emit_label, emit_symbol, emit_wire, g, pin_world, uid
from config import (
    MOUNTING_HOLE_FOOTPRINT,
    MOUNTING_HOLE_LIB,
    PWR_FLAG_LIB,
    R_LIB,
    ROW_PULLUP_FOOTPRINT,
    ROW_PULLUP_VALUE,
    TESTPOINT_FOOTPRINT,
    TESTPOINT_LIB,
)


def place_row_pullup(
    out: list[str],
    *,
    ref: str,
    sense_net: str,
    logic_net: str,
    x: float,
    y: float,
    uuid_prefix: str,
    idx: int,
) -> None:
    emit_symbol(
        out,
        lib_id=R_LIB,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value=ROW_PULLUP_VALUE,
        footprint=ROW_PULLUP_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, idx),
        pin_uuids={"1": uid(uuid_prefix, 100 + idx * 2), "2": uid(uuid_prefix, 101 + idx * 2)},
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
    )
    p1x, p1y = pin_world(x, y, *PIN_COORDS[R_LIB]["1"], 0)
    p2x, p2y = pin_world(x, y, *PIN_COORDS[R_LIB]["2"], 0)
    emit_wire(out, p1x, p1y, p1x, p1y - g(1), uid(uuid_prefix, 300 + idx * 4))
    emit_label(out, logic_net, p1x, p1y - g(1), 90, uid(uuid_prefix, 301 + idx * 4), justify="left bottom")
    emit_wire(out, p2x, p2y, p2x, p2y + g(1), uid(uuid_prefix, 302 + idx * 4))
    emit_label(out, sense_net, p2x, p2y + g(1), 270, uid(uuid_prefix, 303 + idx * 4), justify="left bottom")


def place_testpoint(out: list[str], *, ref: str, net: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(
        out,
        lib_id=TESTPOINT_LIB,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value="TestPoint",
        footprint=TESTPOINT_FOOTPRINT,
        sym_uuid=uid(uuid_prefix, 100 + idx),
        pin_uuids={"1": uid(uuid_prefix, 200 + idx)},
        ref_offset=(g(1), -g(2)),
        value_offset=(g(1), -g(1)),
    )
    px, py = pin_world(x, y, *PIN_COORDS[TESTPOINT_LIB]["1"], 0)
    emit_wire(out, px, py, px + g(1), py, uid(uuid_prefix, 300 + idx))
    emit_label(out, net, px + g(1), py, 0, uid(uuid_prefix, 400 + idx), justify="left bottom")


def place_unpinned_marker(out: list[str], *, lib_id: str, ref: str, value: str, footprint: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(
        out,
        lib_id=lib_id,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value=value,
        footprint=footprint,
        sym_uuid=uid(uuid_prefix, idx),
        pin_uuids={},
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
    )


def place_mounting_hole(out: list[str], *, ref: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    place_unpinned_marker(
        out,
        lib_id=MOUNTING_HOLE_LIB,
        ref=ref,
        value="M3",
        footprint=MOUNTING_HOLE_FOOTPRINT,
        x=x,
        y=y,
        uuid_prefix=uuid_prefix,
        idx=idx,
    )


def place_power_flag(out: list[str], *, ref: str, net: str, x: float, y: float, uuid_prefix: str, idx: int) -> None:
    emit_symbol(
        out,
        lib_id=PWR_FLAG_LIB,
        x=x,
        y=y,
        rot=0,
        ref=ref,
        value="PWR_FLAG",
        footprint="",
        sym_uuid=uid(uuid_prefix, 700 + idx),
        pin_uuids={"1": uid(uuid_prefix, 800 + idx)},
        ref_offset=(g(1), -g(1)),
        value_offset=(g(1), g(1)),
        in_bom=False,
        on_board=False,
    )
    px, py = pin_world(x, y, *PIN_COORDS[PWR_FLAG_LIB]["1"], 0)
    emit_label(out, net, px, py, 0, uid(uuid_prefix, 900 + idx), justify="left bottom")
