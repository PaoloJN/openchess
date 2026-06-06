"""Grid-snapped schematic coordinates for the control-panel board."""
from __future__ import annotations
from _lib import g

CONN_X_G = 28
CONN_Y_G = 42

LED_X_START_G = 72
LED_Y_G = 30
LED_X_PITCH_G = 18

BUTTON_X_START_G = 72
BUTTON_Y_G = 54
BUTTON_X_PITCH_G = 18

TESTPOINT_X_START_G = 26
TESTPOINT_Y_G = 88
TESTPOINT_X_PITCH_G = 8

MOUNTING_HOLE_X_G = (130, 138, 146, 154)
MOUNTING_HOLE_Y_G = 88
FIDUCIAL_X_G = (132, 142, 152)
FIDUCIAL_Y_G = 98
PWR_FLAG_X_G = 28
PWR_FLAG_Y_G = 70


def connector_position() -> tuple[float, float]:
    return g(CONN_X_G), g(CONN_Y_G)


def led_position(idx: int) -> tuple[float, float]:
    return g(LED_X_START_G + idx * LED_X_PITCH_G), g(LED_Y_G)


def button_position(idx: int) -> tuple[float, float]:
    return g(BUTTON_X_START_G + idx * BUTTON_X_PITCH_G), g(BUTTON_Y_G)


def testpoint_position(idx: int) -> tuple[float, float]:
    return g(TESTPOINT_X_START_G + idx * TESTPOINT_X_PITCH_G), g(TESTPOINT_Y_G)
