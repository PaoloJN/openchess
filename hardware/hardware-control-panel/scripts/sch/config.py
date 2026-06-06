"""Control-panel schematic configuration.

This is the side-mounted physical controls board. It should stay simple:
status LEDs, pushbuttons, and one cable connector back to the controller.
"""
from __future__ import annotations

GND_NET = "GND"
LOGIC_NET = "+3V3"

LED_NETS = ("LED_PWR_N", "LED_CONN_N", "LED_BATT_N")
LED_LABELS = ("PWR", "CONN", "BATT")
LED_SERIES_VALUE = "1k"
LED_RESISTOR_FOOTPRINT = "Resistor_SMD:R_0805_2012Metric"
LED_FOOTPRINT = "LED_SMD:LED_0805_2012Metric"

BUTTON_NETS = ("BTN_POWER", "BTN_MODE", "BTN_RESET")
BUTTON_LABELS = ("POWER", "MODE", "RESET")
BUTTON_FOOTPRINT = "Button_Switch_SMD:SW_SPST_TL3342"

PANEL_CONN_LIB = "Connector_Generic:Conn_01x10"
PANEL_CONN_REF = "J1"
PANEL_CONN_VALUE = "J_PANEL_1x10"
PANEL_CONN_FOOTPRINT = "Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical"

# Controller side should mirror this as its user/control-panel connector.
PANEL_PIN_NETS: dict[int, str] = {
    1: LOGIC_NET,
    2: GND_NET,
    3: LED_NETS[0],
    4: LED_NETS[1],
    5: LED_NETS[2],
    6: BUTTON_NETS[0],
    7: BUTTON_NETS[1],
    8: BUTTON_NETS[2],
    9: "PANEL_SPARE",
    10: GND_NET,
}

R_LIB = "Device:R"
LED_LIB = "Device:LED"
SW_LIB = "Switch:SW_Push"
TESTPOINT_LIB = "Connector:TestPoint"
TESTPOINT_FOOTPRINT = "TestPoint:TestPoint_Pad_D1.5mm"
TESTPOINT_NETS = (LOGIC_NET, GND_NET, *LED_NETS, *BUTTON_NETS, "PANEL_SPARE")

MOUNTING_HOLE_LIB = "Mechanical:MountingHole"
MOUNTING_HOLE_FOOTPRINT = "MountingHole:MountingHole_3.2mm_M3"
FIDUCIAL_LIB = "Mechanical:Fiducial"
FIDUCIAL_FOOTPRINT = "Fiducial:Fiducial_1mm_Mask2mm"
PWR_FLAG_LIB = "power:PWR_FLAG"
