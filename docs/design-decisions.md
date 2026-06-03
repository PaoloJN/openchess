# Design Decisions

Why this project looks the way it does. Written for future Claude sessions (and future Paolo) to understand the *why* behind the current design — so we don't relitigate the same decisions every session.

## Why we're redesigning v1

Paolo built the original [Olivier Mercier chessboard](https://www.oliviermercier.com/res/projects/chessboard/) firmware-first. Reed switches in an 8×8 matrix with 2N3906 transistors per cell were brutal to wire by hand (200+ joints), and the LED matrix (4× 74LS138 + 3× 74LS00 + 81 LEDs in a multiplexed grid) was hard to hand-solder and required hand-stripping enamel off pre-wired LED wires. Result: many hours debugging a flaky physical build.

This v2 keeps the **idea** (touch-free chess board that plays Lichess) but trades the painful parts for proven alternatives.

## Decisions

### Hall sensors instead of reed switches
- Reed switches have a narrow magnet-axis window — wrong orientation = no detect. Painful to debug and unreliable in use.
- A3144 hall effect sensors: insensitive to magnet orientation, much smaller package (TO-92), cheaper at scale.
- One-for-one drop-in: same 8×8 matrix scan, same firmware interface.

### WS2812B addressable LEDs instead of LED matrix
- 81 LEDs on a multiplexed 9×9 matrix needs: 2× 74LS138 (column + row select), 3× 74LS00 (NAND gating), 9 current-limit resistors, 81 individual LEDs hand-wired.
- WS2812B: 81 chained on **one data wire**. No multiplexer chips, no NAND gates, no current resistors. Per-LED RGB, brightness controllable in software.
- BOM goes from ~8 ICs to 1 (74HC595 for sensor scan only).

### Keep the corner LED layout (9×9 = 81 LEDs)
- joojoooo's default design puts 64 LEDs *under* each square (8×8).
- Paolo specifically liked the original's distinctive corner-LED aesthetic — light frames the square instead of illuminating it directly. Looks more "physical" and lets adjacent moves form a connected highlight.
- Cost: ~15 hours of firmware adaptation to remap joojoooo's `BoardDriver` 8×8 layout to 9×9 corners. Decided this is worth it.

### Drop the touchscreen + separate controller box
- Original had an ILI9341 240×320 touchscreen + dedicated XPT2046 + custom enclosure + HDMI cable. Adds ~$40, ~50 hours of firmware work to port menu UI into joojoooo, and a second PCB.
- joojoooo's design uses the 81 WS2812 LEDs themselves to encode game state (red = capture, blue = bot thinking, cyan = piece origin, etc.) plus a phone web UI served from the ESP32 over WiFi.
- Phone UI is strictly bigger and more flexible than a 240×320 touchscreen. No physical controller box needed.
- **Single PCB.** Just the wooden chess board with electronics hidden underneath. Cleaner aesthetic.

### Use joojoooo's firmware, not the original's
- Original firmware: hand-rolled Arduino `.ino` files, ~13 files, hand-rolled `volatile` flag mutexes, no game state persistence, no OTA, no web UI.
- joojoooo's: proper C++ classes across 25+ files, FreeRTOS primitives, full chess engine, Stockfish bot, ChessConnect, game-state persistence to flash, OTA updates, web UI for config, ~8000 lines of mature code.
- Adapting joojoooo to our specific hardware (9×9 corner LEDs) = 1-2 weekends. Building original up to joojoooo's feature level = months.

### Add a battery + USB-C charging
- Modern smart chess boards (Chessnut, DGT Centaur) are portable. The original wasn't.
- Adds: Li-Po cell (4000mAh), TP4056 charging IC (off-the-shelf module), MT3608 boost converter (off-the-shelf module), USB-C connector, power switch, battery LED indicator.
- Why off-the-shelf modules instead of designing the charging circuit on-PCB: simplifies layout, reduces fab errors, $2 per module is cheaper than the parts on-board.

### Why HDMI as the board-to-board connector got dropped
- Original used HDMI as a generic 19-pin board-to-board cable between controller and chessboard.
- v2 has no separate controller, so no cable needed. Everything on one PCB.

### Phone web UI instead of native app
- joojoooo serves a full HTML/JS app from the ESP32. Phone connects to the board's WiFi, opens the URL, gets full control.
- Pros: no app install, works on any device with WiFi, easy to iterate (just rebuild the ESP32 webroot)
- Cons: requires WiFi connection; no native OS integration (push notifications, haptics)
- For a phase 2, could wrap into a Progressive Web App (PWA) and "install to home screen" for app-like UX.

### KiCad over Eagle / EasyEDA / Fusion 360
- KiCad: free, open-source, no usage limits, professional output, runs offline.
- Eagle: discontinued (folded into Fusion 360, paid).
- EasyEDA: tied to JLCPCB's ecosystem, less flexible.
- KiCad has the steepest learning curve but the best long-term ROI for hobbyist hardware.

### Scripted PCB layout vs manual GUI
- Manual placement of 145+ components on a precise grid (64 sensors + 81 LEDs at exact mm positions) is hours of clicking.
- Python scripts editing `.kicad_pcb` directly (S-expression format) place them in seconds.
- Scripts work for **mechanical/repetitive** tasks. They DO NOT work for layout/routing decisions that need aesthetic judgment (which is why the routing scripts were rolled back — see `scripts/README.md`).
- Routing uses **Freerouting** plugin for autorouted parts + manual cleanup.

### Pre-made charging/boost modules vs designing them on-PCB
- TP4056 + DW01A + MT3608 modules: ~$2 each, breadboard-ready.
- Designing equivalent on the main PCB: more components on the BOM, USB-C connector layout (which is finicky), risk of fab errors on the charging circuit (which involves Li-Po safety — getting it wrong is a fire risk).
- Off-the-shelf modules add maybe 2cm² total volume inside the enclosure but eliminate ~10 components from our BOM and remove the highest-risk part of the design.

### Per-LED 100nF decoupling on WS2812 chain
- Best practice is 1 cap per LED. We have 81 LEDs. That's 81 caps.
- Compromise: 1 cap every ~8-16 LEDs (so ~6-10 total) is "good enough" per WS2812 community wisdom. Saves BOM cost.
- Decided to add only 1 per chip group when finalizing the back-side layout.
