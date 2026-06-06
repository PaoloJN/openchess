"""Controller-board schematic configuration.

Keep this file as the controller-side electrical contract. The matrix board's
`hardware-board/scripts/sch/config.py` owns the other side of J_MAIN/J_CTRL.
"""
from __future__ import annotations

GND_NET = "GND"
LOGIC_NET = "+3V3"
LED_POWER_NET = "+5V_LED"
LED_DATA_NET = "LED_DATA_5V"
LED_DOUT_END_NET = "LED_DOUT_END"

ROW_SENSE_NETS = tuple(f"S{i}" for i in range(8))
COL_PWR_NETS = tuple(f"C{file}_PWR" for file in "ABCDEFGH")

JMAIN_LIB = "Connector_Generic:Conn_02x13_Odd_Even"
JMAIN_REF = "J1"
JMAIN_VALUE = "J_MAIN_2x13"
JMAIN_FOOTPRINT = "Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical"

# Must match hardware-board/scripts/sch/config.py:JCTRL_PIN_NETS.
JMAIN_PIN_NETS: dict[int, str] = {
    1: LED_POWER_NET,  2: GND_NET,
    3: LED_POWER_NET,  4: GND_NET,
    5: LED_POWER_NET,  6: GND_NET,
    7: LED_DATA_NET,   8: GND_NET,
    9: "S0",          10: "S1",
    11: "S2",         12: "S3",
    13: "S4",         14: "S5",
    15: "S6",         16: "S7",
    17: "CA_PWR",     18: "CB_PWR",
    19: "CC_PWR",     20: "CD_PWR",
    21: "CE_PWR",     22: "CF_PWR",
    23: "CG_PWR",     24: "CH_PWR",
    25: LED_POWER_NET, 26: GND_NET,
}

R_LIB = "Device:R"
C_LIB = "Device:C"
ROW_PULLUP_VALUE = "10k"
ROW_PULLUP_FOOTPRINT = "Resistor_SMD:R_0805_2012Metric"

# ── USB-C 5V input ──────────────────────────────────────────────────────
USB_C_LIB = "Connector:USB_C_Receptacle_USB2.0_16P"
USB_C_REF = "J2"
USB_C_VALUE = "USB-C 5V"
USB_C_FOOTPRINT = "Connector_USB:USB_C_Receptacle_GCT_USB4085"

# CC1/CC2 pulldowns (5.1k → GND) make us a USB-C SINK device.
USB_CC_PULLDOWN_VALUE = "5.1k"
USB_CC_PULLDOWN_FOOTPRINT = "Resistor_SMD:R_0603_1608Metric"

# Pin numbers that should be tagged no_connect (data + sideband).
USB_C_NC_PINS = ("A6", "A7", "A8", "B6", "B7", "B8")

# ── Bulk caps on +5V_LED at the USB entry ──────────────────────────────
BULK_CAP_5V_VALUE = "10uF"
BULK_CAP_5V_FOOTPRINT = "Capacitor_SMD:C_0805_2012Metric"
BULK_CAP_5V_COUNT = 2  # C1, C2

# ── +3V3 LDO (AP2112K-3.3 — SOT-23-5, 600 mA, active-high EN) ───────────
LDO_LIB = "Regulator_Linear:AP2112K-3.3"
LDO_REF = "U1"
LDO_VALUE = "AP2112K-3.3"
LDO_FOOTPRINT = "Package_TO_SOT_SMD:SOT-23-5"

# Decoupling around the LDO: 1uF at VIN, 1uF at VOUT (datasheet recommendation).
LDO_CAP_VALUE = "1uF"
LDO_CAP_FOOTPRINT = "Capacitor_SMD:C_0603_1608Metric"

TESTPOINT_LIB = "Connector:TestPoint"
TESTPOINT_FOOTPRINT = "TestPoint:TestPoint_Pad_D1.5mm"
TESTPOINT_NETS = (
    LED_POWER_NET,
    LOGIC_NET,
    GND_NET,
    LED_DATA_NET,
    *ROW_SENSE_NETS,
    *COL_PWR_NETS,
)

MOUNTING_HOLE_LIB = "Mechanical:MountingHole"
MOUNTING_HOLE_FOOTPRINT = "MountingHole:MountingHole_3.2mm_M3"

FIDUCIAL_LIB = "Mechanical:Fiducial"
FIDUCIAL_FOOTPRINT = "Fiducial:Fiducial_1mm_Mask2mm"

PWR_FLAG_LIB = "power:PWR_FLAG"
