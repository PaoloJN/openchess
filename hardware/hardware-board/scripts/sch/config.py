"""Project-level schematic configuration for OpenChess board generators.

This module is intentionally small and boring: controller-board and side-UI
generators should copy this pattern, then change only their local nets,
footprints, and connector maps.
"""
from __future__ import annotations

FILES = tuple("ABCDEFGH")
MATRIX_COLS = 8
MATRIX_ROWS = 8
LED_COLS = MATRIX_COLS + 1
LED_ROWS = MATRIX_ROWS + 1

GND_NET = "GND"
LED_POWER_NET = "+5V_LED"
LED_DATA_NET = "LED_DATA_5V"
LED_DOUT_END_NET = "LED_DOUT_END"

COL_PWR_NETS = tuple(f"C{file}_PWR" for file in FILES)
ROW_SENSE_NETS = tuple(f"S{i}" for i in range(MATRIX_ROWS))

A3144_LIB = "openchess:A3144"
A3144_VALUE = "A3144"
A3144_FOOTPRINT = "Package_TO_SOT_THT:TO-92_Inline"

WS2812_LIB = "LED:WS2812B"
WS2812_VALUE = "WS2812B"
WS2812_FOOTPRINT = "LED_SMD:LED_WS2812B_PLCC4_5.0x5.0mm_P3.2mm"

CAP_LIB = "Device:C"
CAP_FOOTPRINT_0805 = "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder"
LED_DECOUP_VALUE = "100nF"

ROW_BULK_VALUE = "47uF"
ROW_BULK_FOOTPRINT = "Capacitor_SMD:C_1206_3216Metric"

ENTRY_CAP_LIB = "Device:C_Polarized"
ENTRY_CAP_REF = "C91"
ENTRY_CAP_VALUE = "470uF"
ENTRY_CAP_FOOTPRINT = "Capacitor_THT:CP_Radial_D10.0mm_P5.00mm"

PWR_FLAG_LIB = "power:PWR_FLAG"

JCTRL_LIB = "Connector_Generic:Conn_02x13_Odd_Even"
JCTRL_REF = "J1"
JCTRL_VALUE = "Conn_02x13"
JCTRL_FOOTPRINT = "Connector_PinHeader_2.54mm:PinHeader_2x13_P2.54mm_Vertical"

# Matrix-side connector contract. Keep this in sync with the controller
# schematic when you script that board.
JCTRL_PIN_NETS: dict[int, str] = {
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

TESTPOINT_LIB = "Connector:TestPoint"
TESTPOINT_FOOTPRINT = "TestPoint:TestPoint_Pad_D1.5mm"
TESTPOINT_NETS = (LED_POWER_NET, GND_NET, LED_DATA_NET, LED_DOUT_END_NET)

MOUNTING_HOLE_LIB = "Mechanical:MountingHole"
MOUNTING_HOLE_FOOTPRINT = "MountingHole:MountingHole_3.2mm_M3"

FIDUCIAL_LIB = "Mechanical:Fiducial"
FIDUCIAL_FOOTPRINT = "Fiducial:Fiducial_1mm_Mask2mm"
