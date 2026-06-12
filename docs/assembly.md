# Assembly And Bring-Up Guide

Status: current prototype bring-up plan. Update after the 3x3 validation board
and controller are physically tested.

## Build Order

1. Inspect or re-export the current KiCad fabrication and assembly files for
   the 3x3 validation board and controller.
2. Order the 3x3 validation board and controller together.
3. Source the plug-in modules, panel parts, LiPo, and magnets.
4. Build the panel harness from controller `J3` to the SSD1306 OLED and POWER,
   MODE, SELECT buttons.
5. Bench-test the controller by itself: power rails, ESP32 power, OLED I2C,
   buttons, LED data level shifting, and `VBAT_MON`.
6. Connect and validate the 3x3 matrix: first power, LED chain, one Hall
   sensor, then full matrix scan.
7. If the 3x3/controller validation is clean, order and bring up the full 8x8
   matrix board.
8. Continue firmware and web integration against measured hardware behavior.
9. Design the enclosure around the validated board stack, panel harness,
   battery, USB-C access, and service access.

## Matrix Board Notes

- Current Hall sensors are DRV5032FC SOT-23 parts.
- The 8x8 board is 282 mm by 282 mm; the 3x3 validation board is 132 mm by
  132 mm.
- The full matrix has 81 WS2812B LEDs in a 9x9 corner grid; the 3x3 board has
  16 LEDs around the validation squares.
- Test LED continuity before relying on downstream LEDs.
- Confirm `+5V_LED`, `GND`, `LED_DATA_5V`, `S0..S7`, and `CA_PWR..CH_PWR` at
  the matrix connector before joining boards.

## Controller Board Notes

- The controller board is 58 mm by 71 mm.
- Verify Seeed Lipo Rider Plus 5 V and 3.3 V outputs before connecting the
  matrix.
- Verify row pullups are tied to the 3.3 V rail.
- Verify LED data leaves the controller as `LED_DATA_5V`.
- Verify `VBAT_MON` stays inside the ESP32 ADC range across expected LiPo
  voltages.
- Verify all active 2x13 matrix/controller `J` connectors match the intended
  `PinSocket_2x13` footprint family before ordering.

## Panel Harness Notes

- There is no active panel PCB.
- The OLED and 3 buttons wire to controller `J3`.
- Buttons short their signal net to GND.
- Mark pin 1 on the harness and panel wiring before installing in the
  enclosure.
- Check whether the OLED module already includes I2C pullups.

## Firmware Bring-Up

1. Flash a minimal firmware build.
2. Confirm controller power, OLED, buttons, and battery ADC first.
3. Confirm LED data output with a small WS2812B test.
4. Connect the 3x3 validation matrix.
5. Verify single-sensor Hall behavior, then full scan behavior.
6. Verify web UI connection and board-state protocol.
7. Only then bring up the full 8x8 matrix.
