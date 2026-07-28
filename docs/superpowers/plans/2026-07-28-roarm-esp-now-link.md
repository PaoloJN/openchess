# RoArm-M2-S ESP-NOW Link Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** OpenChess ESP32 commands the RoArm-M2-S wirelessly over ESP-NOW, including a DIY hobby-servo gripper, driven from the OpenChess serial console (`arm demo`).

**Architecture:** Three stages: (1) a Mac pyserial console to drive the arm over USB and record poses; (2) rebuild + flash the arm's open-source firmware, first stock, then with one added JSON command `{"T":117,"angle":0..180}` driving a hobby servo on GPIO4; (3) a standalone OpenChess bench build (`bench_roarm`) that broadcasts the arm's fixed ESP-NOW struct with `cmd=1` + JSON payload.

**Tech Stack:** Python 3 + pyserial; Arduino (arduino-cli, esp32 core) for the arm firmware; PlatformIO bench env for OpenChess.

**Spec:** `docs/superpowers/specs/2026-07-28-roarm-esp-now-link-design.md`
**Reference:** `docs/reference/robot-arm/` (JSON commands, ESP-NOW struct, servo IO — all verified against `waveshareteam/roarm_m2`)

## Global Constraints

- Arm serial: **115200 baud, 8N1, newline-terminated JSON** both directions.
- Scripted serial opens must **deassert DTR/RTS** (CP2102 auto-reset circuit).
- ESP-NOW frames carry the **exact struct**: `byte devCode; float base, shoulder, elbow, hand; byte cmd; char message[210];` — field order and types are the wire contract with the arm firmware.
- ESP-NOW `cmd=1` JSON must be **non-blocking commands only** (use `T:1041` for moves, never `T:104`).
- Both radios on **WiFi channel 1** (arm AP default).
- DIY hobby servo: signal → arm board **GPIO4**, GND common. **Never on the ST3215 daisy chain** (~12 V serial bus). Board 5 V only for micro servos (MG90S class or smaller); bigger servo → separate 5–6 V supply, common GND.
- Hardware-in-the-loop project: “tests” are observed hardware behavior at each step; expected outputs are stated per step. Physical steps (wiring, pressing reset) are done by Paolo — pause and ask.
- The two USB ports are `/dev/cu.usbserial-10` and `/dev/cu.usbserial-210`; which is the arm is determined in Task 1 and used consistently after.

---

### Task 1: Mac serial console — talk to the arm over USB

**Files:**
- Create: `scripts/roarm_console.py`
- Create (by the script at runtime): `scripts/roarm_poses.json`

**Interfaces:**
- Produces: `roarm_console.py <port>` REPL; `--scan` mode that identifies which usbserial port is the arm. Saved poses in `scripts/roarm_poses.json` as `{"name": {"x":..,"y":..,"z":..,"t":..}}`.

- [ ] **Step 1: Write the console script**

```python
#!/usr/bin/env python3
"""RoArm-M2-S serial console. Usage:
  python3 roarm_console.py --scan          # find which port is the arm
  python3 roarm_console.py /dev/cu.usbserial-XX
Shortcuts: home | pos X Y Z [T] | grip N | torque on|off | led N | save NAME | list | raw JSON
Reference: docs/reference/robot-arm/10-json-commands.md
"""
import glob, json, sys, time
from pathlib import Path

import serial  # pip install pyserial

BAUD = 115200
POSES = Path(__file__).parent / "roarm_poses.json"


def open_port(port):
    s = serial.Serial()
    s.port, s.baudrate, s.timeout = port, BAUD, 0.5
    s.dtr = False  # deassert BEFORE open: CP2102 DTR/RTS drive the
    s.rts = False  # ESP32 auto-reset circuit and would reboot the arm
    s.open()
    return s


def send(s, obj_or_str):
    line = obj_or_str if isinstance(obj_or_str, str) else json.dumps(obj_or_str)
    s.write((line + "\n").encode())


def drain(s, dur=0.8):
    out, end = [], time.time() + dur
    while time.time() < end:
        line = s.readline().decode(errors="replace").strip()
        if line:
            out.append(line)
            print(f"  arm> {line}")
    return out


def scan():
    for port in sorted(glob.glob("/dev/cu.usbserial*")):
        try:
            s = open_port(port)
            send(s, {"T": 105})  # feedback request -> {"T":1051,...}
            lines = drain(s, 1.0)
            s.close()
            verdict = "ARM" if any('"T":1051' in l for l in lines) else "not the arm"
            print(f"{port}: {verdict}")
        except (OSError, serial.SerialException) as e:
            print(f"{port}: busy/unreadable ({e})")


def get_pose(s):
    send(s, {"T": 105})
    for line in drain(s, 1.0):
        if '"T":1051' in line:
            fb = json.loads(line)
            return {k: fb[k] for k in ("x", "y", "z", "t") if k in fb}
    return None


def repl(port):
    s = open_port(port)
    poses = json.loads(POSES.read_text()) if POSES.exists() else {}
    print(f"Connected {port} @ {BAUD}. Type 'help'. Ctrl-C to quit.")
    while True:
        try:
            cmd = input("roarm> ").strip()
        except (EOFError, KeyboardInterrupt):
            break
        if not cmd:
            drain(s, 0.3)
            continue
        parts = cmd.split()
        if cmd == "help":
            print(__doc__)
        elif cmd == "home":
            send(s, {"T": 100})
        elif parts[0] == "pos" and len(parts) >= 4:
            x, y, z = (float(v) for v in parts[1:4])
            t = float(parts[4]) if len(parts) > 4 else 3.14
            send(s, {"T": 1041, "x": x, "y": y, "z": z, "t": t})
        elif parts[0] == "grip" and len(parts) == 2:  # DIY servo, needs Task 3
            send(s, {"T": 117, "angle": int(parts[1])})
        elif parts[0] == "torque" and len(parts) == 2:
            send(s, {"T": 210, "cmd": 1 if parts[1] == "on" else 0})
        elif parts[0] == "led" and len(parts) == 2:
            send(s, {"T": 114, "led": int(parts[1])})
        elif parts[0] == "save" and len(parts) == 2:
            pose = get_pose(s)
            if pose:
                poses[parts[1]] = pose
                POSES.write_text(json.dumps(poses, indent=2))
                print(f"saved {parts[1]}: {pose}")
            else:
                print("no T:1051 feedback received")
        elif cmd == "list":
            print(json.dumps(poses, indent=2))
        elif cmd.startswith("{"):
            send(s, cmd)
        else:
            print("unknown; type 'help'")
        drain(s)
    s.close()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--scan":
        scan()
    elif len(sys.argv) > 1:
        repl(sys.argv[1])
    else:
        print(__doc__)
```

- [ ] **Step 2: Install pyserial and scan for the arm**

Run: `python3 -m pip install pyserial && python3 scripts/roarm_console.py --scan`
Expected: one port prints `ARM` (answers `{"T":105}` with a `"T":1051` feedback line), the other prints `not the arm`. Record the ARM port; the other one is the OpenChess DevKitC (needed in Task 4).
If both say "not the arm": check the arm is powered (12 V supply on, not just USB) and retry; the arm's OLED should be lit.

- [ ] **Step 3: First motion over USB (Paolo at the keyboard, arm clear of objects)**

Run: `python3 scripts/roarm_console.py /dev/cu.usbserial-<ARM>`
Then: `led 255` → arm LED lights. `home` → arm moves to init pose. `pos 200 100 150` → arm moves. `pos 235 0 234` → back near home. `led 0`.
Expected: motion follows commands; JSON feedback lines print as `arm> ...`.

- [ ] **Step 4: Save two poses for the later demo**

In the console: move somewhere sensible with `pos`, then `save pick`; move again, `save drop`; `list` shows both. Expected: `scripts/roarm_poses.json` exists with `pick` and `drop`.

- [ ] **Step 5: Commit**

```bash
git add scripts/roarm_console.py scripts/roarm_poses.json
git commit -m "feat(roarm): serial console for RoArm-M2-S with port scan and pose capture"
```

---

### Task 2: Vendor + build + flash STOCK arm firmware (the un-brick safety net)

**Files:**
- Create: `firmware-roarm/roarm_m2/` (vendored clone of `waveshareteam/roarm_m2`, no `.git`)
- Create: `firmware-roarm/README.md` (build/flash commands + why vendored)

**Interfaces:**
- Produces: a proven local build+flash path for the arm firmware. Task 3 edits this vendored copy.

- [ ] **Step 1: Vendor the firmware source**

```bash
git clone --depth 1 https://github.com/waveshareteam/roarm_m2 /tmp/roarm_m2 \
  && rm -rf /tmp/roarm_m2/.git \
  && mkdir -p firmware-roarm && cp -R /tmp/roarm_m2 firmware-roarm/roarm_m2
ls firmware-roarm/roarm_m2
```
Expected: the sketch directory (contains a `.ino` — likely `RoArm-M2_example/RoArm-M2_example.ino`) plus `json_cmd.h` etc. Note the actual sketch path for the next steps.

- [ ] **Step 2: Install arduino-cli + esp32 core + libraries**

```bash
brew install arduino-cli
arduino-cli core update-index --additional-urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
arduino-cli core install esp32:esp32 --additional-urls https://espressif.github.io/arduino-esp32/package_esp32_index.json
```
Then check the sketch's `#include`s and the repo README for required libraries and any pinned esp32-core version; install each with `arduino-cli lib install "<name>"`. Typical set for this firmware: ArduinoJson, ESP32Servo (Task 3), an ST-servo/SCServo library (often bundled in the sketch folder — bundled needs no install), Adafruit SSD1306 + GFX.
Expected: all installs succeed. If the wiki/README pins an older esp32 core (e.g. 2.0.x) install that exact version: `arduino-cli core install esp32:esp32@<version> --additional-urls ...`.

- [ ] **Step 3: Compile stock**

```bash
cd firmware-roarm/roarm_m2
arduino-cli compile --fqbn esp32:esp32:esp32 <sketch-dir-from-step-1>
```
Expected: `Sketch uses ... bytes` success line. Fix missing-library errors by installing the named library, nothing else. If it needs a bigger partition scheme (app too large), add `--board-options PartitionScheme=huge_app`.

- [ ] **Step 4: Flash stock and verify the arm is unchanged (Paolo present)**

```bash
arduino-cli upload --fqbn esp32:esp32:esp32 -p /dev/cu.usbserial-<ARM> <sketch-dir>
```
(Quit the roarm console first — the port must be free.)
Expected: upload completes; arm reboots, OLED shows its boot info. Re-run Task 1 Step 3 checks (`led 255`, `home`, `pos`) — identical behavior to before. **This step is the guarantee: we can always return the arm to stock.**

- [ ] **Step 5: Write firmware-roarm/README.md and commit**

README content: what this directory is (vendored `waveshareteam/roarm_m2` @ today's HEAD, no submodule so it can carry local patches), the exact compile/upload commands from steps 3–4 with the real sketch path and core/library versions used, and “stock re-flash = run these two commands on the unmodified source”.

```bash
git add firmware-roarm
git commit -m "feat(roarm): vendor stock roarm_m2 firmware + reproducible build/flash path"
```

---

### Task 3: DIY gripper — wire servo to GPIO4, add `{"T":117,"angle":N}`

**Files:**
- Modify: `firmware-roarm/roarm_m2/.../json_cmd.h` (add `#define CMD_PWM_SERVO 117`)
- Modify: the sketch file that dispatches JSON commands (find it: `grep -rn "113\|CMD_SWITCH_CTRL" firmware-roarm/roarm_m2 --include=*.h --include=*.ino`) — add the T:117 case next to the T:113/114 handling
- Modify: `firmware-roarm/README.md` (document the patch)

**Interfaces:**
- Consumes: build/flash path from Task 2.
- Produces: `{"T":117,"angle":<0..180>}` moves the DIY gripper servo, over every transport (serial now, ESP-NOW in Task 4).

- [ ] **Step 1: Physical wiring (Paolo, arm powered OFF)**

Locate the IO4 breakout on the driver board (silkscreen “IO4”; schematic: https://files.waveshare.com/wiki/RoArm-M2-S/General_Driver_for_Robots.pdf). Connect: servo signal → IO4, servo GND → board GND. Servo power: board 5 V pin if the servo is MG90S-class or smaller; otherwise separate 5–6 V supply with GND tied to board GND. **Confirm which servo model the gripper uses before choosing.** Do NOT connect anything to the servo daisy-chain.

- [ ] **Step 2: Add the firmware patch**

In `json_cmd.h`, next to the other CMD defines:
```c
#define CMD_PWM_SERVO 117  // DIY gripper: {"T":117,"angle":0..180} on GPIO4
```
In the sketch (top, with other includes/globals):
```c
#include <ESP32Servo.h>
Servo pwmGripper;
#define PWM_GRIPPER_PIN 4
```
In `setup()` (after existing init):
```c
pwmGripper.setPeriodHertz(50);
pwmGripper.attach(PWM_GRIPPER_PIN, 500, 2500);
```
In the JSON dispatch switch, next to `case CMD_SWITCH_CTRL` (113):
```c
case CMD_PWM_SERVO: {
  int angle = jsonCmdReceive["angle"];
  if (angle < 0) angle = 0;
  if (angle > 180) angle = 180;
  pwmGripper.write(angle);
  break;
}
```
(Match the local naming: if the parsed JSON doc is called something other than `jsonCmdReceive` in that switch, use that name.)

- [ ] **Step 3: Compile + flash**

```bash
arduino-cli lib install "ESP32Servo"
arduino-cli compile --fqbn esp32:esp32:esp32 <sketch-dir> && \
arduino-cli upload --fqbn esp32:esp32:esp32 -p /dev/cu.usbserial-<ARM> <sketch-dir>
```
Expected: clean build, arm reboots normally (OLED up, `home` still works — regression check).

- [ ] **Step 4: Verify the gripper over USB**

In the console: `grip 0` → servo to one end; `grip 180` → other end; `grip 90` → middle. Expected: smooth motion, no jitter, board doesn’t brown-out (if the arm resets when the servo moves, the servo is too big for board 5 V → external supply per Step 1).
Note the real open/closed angles for your gripper mechanism (e.g. open=40, closed=120) — Task 4 uses them.

- [ ] **Step 5: Commit**

```bash
git add firmware-roarm
git commit -m "feat(roarm): T:117 PWM gripper command on GPIO4 (DIY servo)"
```

---

### Task 4: `bench_roarm` — OpenChess ESP32 commands the arm over ESP-NOW

**Files:**
- Create: `firmware/src/bench/bench_roarm.cpp`
- Modify: `firmware/platformio.ini` (append env)

**Interfaces:**
- Consumes: arm in factory follower mode (obeys broadcast, no arm config needed); `T:117` from Task 3; open/closed gripper angles from Task 3 Step 4; optionally poses from `scripts/roarm_poses.json` (hardcode them into the demo array).

- [ ] **Step 1: Add the platformio env**

Append to `firmware/platformio.ini`:
```ini
; Side quest — RoArm-M2-S ESP-NOW leader. Console: arm home | grip N | json {...} | demo
;   pio run -e bench_roarm -t upload --upload-port /dev/cu.usbserial-<OPENCHESS>
[env:bench_roarm]
extends = env:esp32dev
build_src_filter = -<*> +<bench/bench_roarm.cpp>
```

- [ ] **Step 2: Write the bench**

`firmware/src/bench/bench_roarm.cpp`:
```cpp
// bench_roarm — ESP-NOW leader for the Waveshare RoArm-M2-S.
// The arm ships as a broadcast follower: no pairing, no config needed.
// Wire contract (docs/reference/robot-arm/20-esp-now.md): fixed struct,
// cmd=1 => execute the JSON in `message` (non-blocking commands only).
#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>
#include <esp_wifi.h>

struct struct_message {           // MUST match roarm_m2 esp_now_ctrl.h
  uint8_t devCode;
  float base, shoulder, elbow, hand;
  uint8_t cmd;
  char message[210];
};

static const uint8_t BROADCAST[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
static const uint8_t CHANNEL = 1;  // arm AP default

// Gripper angles measured in Task 3 Step 4 — adjust to the real mechanism:
static const int GRIP_OPEN = 40, GRIP_CLOSED = 120;

static void onSend(const uint8_t*, esp_now_send_status_t st) {
  Serial.println(st == ESP_NOW_SEND_SUCCESS ? "[espnow] delivered"
                                            : "[espnow] SEND FAILED");
}

static void sendJson(const String& json) {
  struct_message f = {};
  f.cmd = 1;
  json.toCharArray(f.message, sizeof(f.message));
  esp_err_t e = esp_now_send(BROADCAST, (uint8_t*)&f, sizeof(f));
  Serial.printf("-> %s (%s)\n", f.message, e == ESP_OK ? "queued" : "err");
}

static void grip(int angle) {
  sendJson(String("{\"T\":117,\"angle\":") + angle + "}");
}

static void moveTo(float x, float y, float z, float t = 3.14f) {
  char buf[120];
  snprintf(buf, sizeof(buf),
           "{\"T\":1041,\"x\":%.1f,\"y\":%.1f,\"z\":%.1f,\"t\":%.2f}", x, y, z, t);
  sendJson(buf);
}

static void demo() {
  Serial.println("demo: LED, wave, grip cycle");
  sendJson("{\"T\":114,\"led\":255}");   delay(800);
  moveTo(235, 0, 234);                     delay(1500);  // near init pose
  moveTo(200, 100, 180);                   delay(1500);
  moveTo(200, -100, 180);                  delay(1500);
  moveTo(235, 0, 234);                     delay(1500);
  grip(GRIP_OPEN);                         delay(1000);
  grip(GRIP_CLOSED);                       delay(1000);
  grip(GRIP_OPEN);                         delay(1000);
  sendJson("{\"T\":114,\"led\":0}");
  Serial.println("demo done");
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  esp_wifi_set_channel(CHANNEL, WIFI_SECOND_CHAN_NONE);
  if (esp_now_init() != ESP_OK) { Serial.println("esp_now_init FAILED"); return; }
  esp_now_register_send_cb(onSend);
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, BROADCAST, 6);
  peer.channel = CHANNEL;
  if (esp_now_add_peer(&peer) != ESP_OK) { Serial.println("add_peer FAILED"); return; }
  Serial.println("bench_roarm ready. Commands: home | grip <0-180> | open | close"
                 " | pos <x> <y> <z> | led <0-255> | json <raw> | demo");
}

void loop() {
  static String line;
  while (Serial.available()) {
    char c = Serial.read();
    if (c == '\n' || c == '\r') {
      line.trim();
      if (line == "home") sendJson("{\"T\":100}");
      else if (line == "demo") demo();
      else if (line == "open") grip(GRIP_OPEN);
      else if (line == "close") grip(GRIP_CLOSED);
      else if (line.startsWith("grip ")) grip(line.substring(5).toInt());
      else if (line.startsWith("led "))
        sendJson(String("{\"T\":114,\"led\":") + line.substring(4).toInt() + "}");
      else if (line.startsWith("pos ")) {
        float x, y, z;
        if (sscanf(line.c_str() + 4, "%f %f %f", &x, &y, &z) == 3) moveTo(x, y, z);
        else Serial.println("usage: pos <x> <y> <z>");
      }
      else if (line.startsWith("json ")) sendJson(line.substring(5));
      else if (line.length()) Serial.println("unknown command");
      line = "";
    } else line += c;
  }
}
```
Before building, confirm the struct against the vendored source: `grep -n -A9 "struct_message" firmware-roarm/roarm_m2 -r` — field order/types must match exactly.

- [ ] **Step 3: Build + flash the OpenChess DevKitC**

```bash
cd firmware && pio run -e bench_roarm -t upload --upload-port /dev/cu.usbserial-<OPENCHESS>
```
(`<OPENCHESS>` = the port that was NOT the arm in Task 1 Step 2. Never upload this to the arm's port.)
Expected: build + upload succeed.

- [ ] **Step 4: End-to-end — the two ESP32s talk**

Run: `pio device monitor -p /dev/cu.usbserial-<OPENCHESS> -b 115200`
Type: `led 255` → expect `[espnow] delivered` on the monitor AND the arm's LED lights with no cable between the boards. Then `home`, `pos 200 100 180`, `open`, `close`.
If `SEND FAILED` / no reaction: check the arm is on (follower mode is factory default); confirm channel — if the arm's AP was reconfigured, find its channel and set `CHANNEL` accordingly; re-check the struct grep from Step 2.

- [ ] **Step 5: The milestone — `arm demo` with no USB in the link**

Type `demo` in the monitor. Expected: LED on → arm waves through 4 poses → DIY gripper opens/closes twice → LED off. The USB cables are only power/console; the command path is radio.
Optionally update `GRIP_OPEN`/`GRIP_CLOSED` and the demo poses (use `pick`/`drop` from `scripts/roarm_poses.json`), re-flash, re-run.

- [ ] **Step 6: Commit**

```bash
git add firmware/src/bench/bench_roarm.cpp firmware/platformio.ini
git commit -m "feat(roarm): bench_roarm ESP-NOW leader — OpenChess ESP32 drives the arm + DIY gripper"
```

---

## Self-review notes

- Spec coverage: console (Task 1), stock rebuild guarantee (Task 2), T:117 gripper (Task 3), bench + ESP-NOW + success criteria (Task 4). Error handling = send-callback printing (Task 4 Step 2). Out-of-scope items untouched.
- Known unknowns handled in-plan: exact sketch dir name (discovered Task 2 Step 1), esp32 core/library versions (Task 2 Step 2), JSON dispatch variable name (Task 3 Step 2), gripper servo size → power source (Task 3 Step 1), gripper angles (Task 3 Step 4 → Task 4 constants).
