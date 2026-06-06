"""Grid-snapped schematic coordinates for the controller board."""
from __future__ import annotations

from _lib import g

JMAIN_X_G = 32
JMAIN_Y_G = 50

PULLUP_X_START_G = 74
PULLUP_Y_G = 34
PULLUP_X_PITCH_G = 6

TESTPOINT_X_START_G = 28
TESTPOINT_Y_G = 96
TESTPOINT_X_PITCH_G = 7

MOUNTING_HOLE_X_G = (140, 147, 154, 161)
MOUNTING_HOLE_Y_G = 96

FIDUCIAL_X_G = (140, 150, 160)
FIDUCIAL_Y_G = 106

PWR_FLAG_X_G = 74
PWR_FLAG_Y_START_G = 50
PWR_FLAG_Y_PITCH_G = 5

# ── chunk 06: power section, inside POWER box (440..566, 50..150) ───────
# All grid units. Multiply by g() at use-site.
USB_X_G = 180          # USB-C symbol center x  → world 457.2 mm
USB_Y_G = 30           # USB-C symbol center y  → world  76.2 mm

# CC1/CC2 pulldown resistors — horizontal (rot 90), each centered between
# the USB-C CC pin endpoint (sym x=+15.24 → world x=USB_X+6g) and a GND
# label one grid further right. Resistor center x sits at USB_X + 7.5g so
# pin 1 lands exactly on the CC pin endpoint at USB_X + 6g.
CC_PULLDOWN_CENTER_DX_G = 7.5    # offset from USB_X_G
CC1_Y_G = USB_Y_G - 4            # CC1 sym y = +10.16 = +4g  → world above
CC2_Y_G = USB_Y_G - 3            # CC2 sym y = +7.62  = +3g

# Bulk caps on +5V_LED, vertical, just right of USB-C.
BULK_CAP_X_START_G = USB_X_G + 12   # world ~487 mm
BULK_CAP_X_PITCH_G = 4
BULK_CAP_Y_G = 27                    # center y → pin1 at world g(25.5), pin2 at g(28.5)

# +3V3 LDO and its decoupling caps further right.
LDO_X_G = USB_X_G + 25             # world ~520 mm
LDO_Y_G = 30
LDO_IN_CAP_X_G = LDO_X_G - 4
LDO_OUT_CAP_X_G = LDO_X_G + 5
LDO_CAP_Y_G = 27


def jmain_position() -> tuple[float, float]:
    return g(JMAIN_X_G), g(JMAIN_Y_G)


def pullup_position(idx: int) -> tuple[float, float]:
    return g(PULLUP_X_START_G + idx * PULLUP_X_PITCH_G), g(PULLUP_Y_G)


def testpoint_position(idx: int) -> tuple[float, float]:
    return g(TESTPOINT_X_START_G + idx * TESTPOINT_X_PITCH_G), g(TESTPOINT_Y_G)


def pwr_flag_position(idx: int) -> tuple[float, float]:
    return g(PWR_FLAG_X_G), g(PWR_FLAG_Y_START_G + idx * PWR_FLAG_Y_PITCH_G)


def usb_c_position() -> tuple[float, float]:
    return g(USB_X_G), g(USB_Y_G)


def cc_pulldown_position(idx: int) -> tuple[float, float]:
    """idx 0 → CC1 pulldown, idx 1 → CC2 pulldown."""
    y_g = CC1_Y_G if idx == 0 else CC2_Y_G
    return g(USB_X_G + CC_PULLDOWN_CENTER_DX_G), g(y_g)


def bulk_cap_position(idx: int) -> tuple[float, float]:
    return g(BULK_CAP_X_START_G + idx * BULK_CAP_X_PITCH_G), g(BULK_CAP_Y_G)


def ldo_position() -> tuple[float, float]:
    return g(LDO_X_G), g(LDO_Y_G)


def ldo_in_cap_position() -> tuple[float, float]:
    return g(LDO_IN_CAP_X_G), g(LDO_CAP_Y_G)


def ldo_out_cap_position() -> tuple[float, float]:
    return g(LDO_OUT_CAP_X_G), g(LDO_CAP_Y_G)
