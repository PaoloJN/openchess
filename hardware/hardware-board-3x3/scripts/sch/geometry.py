"""Grid-snapped schematic coordinates for the matrix board."""
from __future__ import annotations

from _lib import g
from config import LED_COLS, MATRIX_ROWS

HALL_X_PITCH_G = 12
HALL_Y_PITCH_G = 11
HALL_X_START_G = 24
HALL_Y_START_G = 32

LED_X_PITCH_G = 11
LED_Y_PITCH_G = 10
LED_X_START_G = 123   # shifted +g(3) right to better center the matrix in BOX_LED_MATRIX
LED_Y_START_G = 31    # shifted +g(1) down for vertical balance
LED_CAP_DX_G = 5

ROW_BULK_X_START_G = 50
ROW_BULK_Y_G = 137
ROW_BULK_X_PITCH_G = 7

ENTRY_CAP_X_G = 27
ENTRY_CAP_Y_G = 139

JCTRL_X_G = 149   # 378.46 mm — symbol origin. Body is offset +1.27 mm from
                  # origin, so the body center lands at 379.73 mm, ~0.3 mm
                  # left of the BOX_J_CTRL X midline (380 mm).
JCTRL_Y_G = 139   # 353.06 mm — body center, ~0.6 mm below the box Y midline (352.5).

TESTPOINT_Y_G = 130
TESTPOINT_X_G = (194, 201, 208, 215)

MOUNTING_HOLE_Y_G = 135
MOUNTING_HOLE_X_G = (194.5, 201.5, 208.5, 215.5)

FIDUCIAL_Y_G = 140.5
FIDUCIAL_X_G = (194.5, 201.5, 208.5)   # column-aligned with MH1..MH3


def hall_position(file_idx: int, rank_idx: int) -> tuple[float, float]:
    """World (x, y) for file 0..MATRIX_COLS-1 and rank 0..MATRIX_ROWS-1.

    Rank 0 is chess rank 1, drawn at the bottom of the page.
    """
    return (
        g(HALL_X_START_G + file_idx * HALL_X_PITCH_G),
        g(HALL_Y_START_G + (MATRIX_ROWS - 1 - rank_idx) * HALL_Y_PITCH_G),
    )


def led_position(col: int, row: int) -> tuple[float, float]:
    return (
        g(LED_X_START_G + col * LED_X_PITCH_G),
        g(LED_Y_START_G + row * LED_Y_PITCH_G),
    )


def led_chain_index(col: int, row: int) -> int:
    return row * LED_COLS + col


def led_ref(col: int, row: int) -> str:
    return f"D{led_chain_index(col, row) + 1}"


def led_cap_position(col: int, row: int) -> tuple[float, float]:
    lx, ly = led_position(col, row)
    return lx + g(LED_CAP_DX_G), ly


def led_cap_ref(col: int, row: int) -> str:
    return f"C{led_chain_index(col, row) + 10}"


def row_bulk_position(idx: int) -> tuple[float, float]:
    return g(ROW_BULK_X_START_G + idx * ROW_BULK_X_PITCH_G), g(ROW_BULK_Y_G)


def entry_cap_position() -> tuple[float, float]:
    return g(ENTRY_CAP_X_G), g(ENTRY_CAP_Y_G)


def jctrl_position() -> tuple[float, float]:
    return g(JCTRL_X_G), g(JCTRL_Y_G)
