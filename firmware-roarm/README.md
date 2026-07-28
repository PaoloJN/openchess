# firmware-roarm — RoArm-M2-S firmware (vendored)

Vendored copy of https://github.com/waveshareteam/roarm_m2 (HEAD @ 2026-07-28,
`.git`, media, python demos and Windows flash tool removed) so local patches
are version-controlled alongside OpenChess. Not a submodule on purpose.

The arm enumerates as `/dev/cu.usbserial-210` on Paolo's Mac (identify anytime
with `python3 scripts/roarm_console.py --scan` — the OpenChess DevKitC is the
other port).

## Toolchain (verified working 2026-07-28)

- arduino-cli 1.5.1 (Homebrew)
- esp32:esp32 core **3.3.11**
- Libraries: ArduinoJson 7.4.2, SCServo 1.0.2, Adafruit SSD1306 2.5.16,
  Adafruit GFX 1.12.4 (+BusIO 1.17.4)

```bash
arduino-cli core install esp32:esp32 \
  --additional-urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli lib install ArduinoJson SCServo "Adafruit SSD1306" "Adafruit GFX Library"
```

## Build + flash

```bash
cd firmware-roarm/roarm_m2
arduino-cli compile --fqbn esp32:esp32:esp32 RoArm-M2_example
arduino-cli upload  --fqbn esp32:esp32:esp32 -p /dev/cu.usbserial-210 RoArm-M2_example
```

(Free the serial port first — quit any roarm_console session.)

## Local patches vs upstream

1. `esp_now_ctrl.h` — `OnDataSent` signature updated for arduino-esp32 3.3.x
   (IDF 5.5): first callback arg is now `wifi_tx_info_t*`; destination MAC is
   `tx_info->des_addr`. Build-compat only, no behavior change.

Stock re-flash = revert local patches beyond #1 (that one is required to
build on this toolchain) and run the two commands above. Verified: this
rebuild boots and behaves identically to the factory firmware (boot mission,
AP `RoArm-M2`, ESP-NOW follower, JSON serial control).
