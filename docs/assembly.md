# Assembly And Bring-Up Guide

Status: the v0.1 boards went through this sequence in June 2026 and passed.
Kept as the checklist for assembling a spare matrix or controller.

## Build Order

1. Export fabrication and assembly files with the KiCad Fabrication Toolkit
   plugin. It includes the drill file and applies the JLC rotations, which the
   first manual export missed.
2. Order the matrix and controller together. SMD parts assembled by JLC,
   modules and connectors hand-soldered.
3. Hand-solder on the controller: ESP32 module or DevKitC headers, the
   TBD62783A column driver (solder it directly, loose socket pins failed),
   `J1`, the panel connectors, and the charger/boost module.
4. Hand-solder the matrix `J1` female socket.
5. Wire the panel: 0.91" SSD1306 OLED plus UP, DOWN, OK buttons on flying
   leads.
6. Bench-test the controller alone, then connect the matrix.
7. Print the corner test piece, then the case.

## Controller Checks Before Inserting The ESP32

- USB-C in. Measure the 5 V rail and the 3.3 V rail.
- Confirm 5 V to GND is not a short.
- Row pullups tied to 3.3 V.
- LED data leaves the controller as `LED_DATA_5V`.
- `VBAT_MON` stays inside the ADC range across LiPo voltages.

## Matrix Checks

- DRV5032FC orientation (JLC set them to 180 degrees, matching the design).
- Confirm `+5V_LED`, `GND`, `LED_DATA_5V`, `S0..S7`, and `CA_PWR..CH_PWR` at
  `J1` before joining boards.
- LED walk test from D1 to D81. A break shows as "stops at LED N".

## Firmware Bring-Up

Follow `../firmware/BENCH.md` in order:

1. `bench_alive`: serial sign of life, button inputs.
2. `bench_led`: white pixel walks the chain, then R/G/B fills.
3. `bench_sensor`: live 8x8 board on serial, wave a magnet.
4. `bench_highlight`: a magnet lights its square's four corners.
5. `bench_oled` and `bench_buttons`: panel.
6. `esp32dev`: the product build. Pair from the app.

## Battery

The v0.1 Lipo Rider Plus module would not start the board on battery. Its
IP5306 shuts the boost down under light load. The replacement is an Adafruit
bq25185 charger plus boost on the same jumper points: battery to the JST, 5 V
pad to `+5V_LED`, GND to GND, BAT pad to `VBAT_MON`. Keep LED brightness
moderate and ramp at boot; the module dislikes big load steps.

A 1S LiPo only, 3.0 to 4.2 V. Anything higher destroys the charger.
