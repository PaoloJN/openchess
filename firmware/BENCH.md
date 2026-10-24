# Bench Bring-Up — Tomorrow's Plan

Three self-contained tests. Flash one at a time. **Go in order** — each builds
confidence before the next. Do NOT skip the power-rail check.

## 0. Safety gate (multimeter, before inserting the ESP32)
- USB-C into M1 (Lipo Rider). Measure:
  - **5V rail ≈ 5V**, **3.3V rail ≈ 3.3V**
  - **5V ↔ GND is NOT a short** (not ~0 Ω)
- Clean → insert ESP32 and continue. Short/wrong → stop, debug the bridge.

## 1. Sign of life (no peripherals)
```
pio run -e esp32dev            # (or just flash test/bench/bench_signs_of_life.ino)
```
Open serial @115200 → should print `OpenChess controller — ALIVE`.
Jumper GPIO36/39/2 → GND to see inputs flip 1→0.

## 2. LEDs  →  `bench_led`
```
pio run -e bench_led -t upload
```
- A white pixel walks D1→D81 (a break = "stops at LED N"), then all R/G/B dim.
- **Connect:** controller → matrix via J1. Power on.
- ✅ Pass: pixel travels the whole chain, all three colors fill fully.

## 3. Sensors  →  `bench_sensor`   ⭐ the important one
```
pio run -e bench_sensor -t upload
```
- Serial prints a live 8×8 board. Wave a magnet over a square → `[#]`.
- ✅ Pass: the right square lights up, neighbors stay `.` (no ghosting).
- Tune `SETTLE_MS` (start 55ms) and magnet strength/gap here.

## 4. Web dashboard  →  `bench_web`   (LEDs + sensors in one UI)
```
pio run -e bench_web -t upload
```
- ESP32 makes WiFi hotspot **`OpenChess-Bench`** / pass **`chess1234`**.
- Join it, open **http://192.168.4.1** on your phone.
- Live 8×8 grid (green = magnet) + buttons: LEDs off / dim white / walk / pick color.

## Auto-sleep — verify on hardware
Main firmware now deep-sleeps after inactivity: **10 min** idle / **30 min**
mid-game (buttons, piece changes, or a connected phone reset the timer;
mid-game sleep abandons the game). To bench-test without waiting, shrink
`SLEEP_IDLE_MS` / `SLEEP_GAME_MS` at the top of `src/main.cpp` to ~30 s and
check: it ripples off + OLED blanks, OK wakes it, and touching a piece or
button actually postpones the sleep.

## Notes / gotchas
- **OLED is on GPIO1/3 (UART0).** Keep it DISCONNECTED while flashing, and you
  can't use serial debug with it plugged in. (Bench tests above don't use it.)
- **LED brightness is capped low on purpose** — 81 white LEDs ≈ 4.9A but the
  supply is 2.4A. Don't crank it.
- **Arduino IDE alt:** the `test/bench/*.ino` mirror these; set board =
  "ESP32 Dev Module", install Adafruit NeoPixel if not using PlatformIO.
