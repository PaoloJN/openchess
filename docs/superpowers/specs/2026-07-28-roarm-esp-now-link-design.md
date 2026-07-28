# RoArm-M2-S ESP-NOW Link — Design

Date: 2026-07-28
Status: Approved by Paolo (side quest, experimental)

## Goal

Make the OpenChess ESP32 command the Waveshare RoArm-M2-S robot arm wirelessly,
including a DIY hobby-servo gripper the arm doesn't stock. First milestone is
"the boards talk and the arm moves" — not chess integration.

**Success criteria:** with both boards powered and no USB involved in the link,
typing `arm demo` on the OpenChess serial console makes the arm run a canned
move sequence and open/close the DIY gripper.

## Context and constraints

- Arm: Waveshare RoArm-M2-S. Five ST3215 serial-bus servos, ESP32 driver
  board, open-source Arduino firmware (`waveshareteam/roarm_m2`). Ships as an
  ESP-NOW *follower*: it obeys broadcast frames out of the box.
  Full reference: `docs/reference/robot-arm/` (fetched 2026-07-28).
- OpenChess side: ESP32-DevKitC seated on the v1 controller PCB, no matrix
  attached. Nearly all GPIOs are claimed by the PCB, so a wired UART link is
  impractical — ESP-NOW needs zero pins.
- DIY gripper: hobby PWM servo (exact model TBD at implementation). It must
  NOT join the arm's servo daisy-chain — that bus carries ~12 V plus the
  ST3215 serial protocol and would destroy a hobby servo.
- Paolo's ask: keep the OpenChess-side code separate test code, not woven into
  the main firmware. The existing `firmware/src/bench/` one-file-per-build
  pattern (`build_src_filter`) is exactly that.

## Decision

ESP-NOW broadcast link (option A), staged. The arm's stock follower mode
executes any non-blocking JSON carried in the ESP-NOW frame, so the OpenChess
side only needs a sender. The only arm-side change is a small firmware
addition for the gripper servo. Rejected alternatives: UART wire (no free
pins, conflicts with USB debug on both ends), Mac-in-the-middle relay (boards
never actually talk to each other).

## Components (build order)

### 1. Mac test console — `scripts/roarm_console.py`

Small Python (pyserial) REPL against the arm's USB port (115200 8N1,
newline-terminated JSON both ways). Purpose: learn the command set, find the
arm's reachable workspace, and record good poses before any ESP32 code exists.

- Raw mode: type a JSON object, see the arm's JSON feedback.
- Shortcuts: `home`, `pos <x> <y> <z>`, `torque on|off`, `grip <angle>`
  (grip works only after component 2).
- `save <name>` / `list`: append current pose (from `{"T":105}` feedback) to
  `scripts/roarm_poses.json` for later use in the bench demo sequence.
- Must deassert DTR/RTS on open (CP2102 would otherwise reset the arm ESP32).

### 2. Arm firmware — stock rebuild + gripper command

Two flashes, deliberately separated:

1. **Stock first.** Clone `waveshareteam/roarm_m2`, build unmodified, flash
   over USB, verify the arm behaves identically (web UI, JSON over serial,
   ESP-NOW follower). This proves the rebuild/reflash path before any edit —
   and is the permanent "back to stock" escape hatch. ESP32s cannot be
   bricked by an app flash; the ROM bootloader always allows reflashing.
2. **Gripper addition (~20 lines).** Hobby servo signal on the driver board's
   spare GPIO4 (broken out on the board; Waveshare's own PWM-servo demo for
   this board uses it). New JSON command `{"T":117,"angle":<0..180>}` using
   the ESP32Servo library. No other behavior changes.

Wiring: servo signal → GPIO4, servo GND → board GND. Servo power: board 5 V
pin only if it's a micro servo (MG90S class); anything larger gets its own
5–6 V supply with common ground. Confirm the GPIO4 breakout location against
the board silkscreen/schematic before soldering (flagged in
`docs/reference/robot-arm/40-custom-servo-io.md`).

The modified firmware lives in this repo under `firmware-roarm/` (vendored
clone + patch), so the customization is reproducible.

### 3. OpenChess bench — `firmware/src/bench/bench_roarm.cpp`

New PlatformIO env `bench_roarm` following the existing bench pattern
(`build_src_filter = -<*> +<bench/bench_roarm.cpp>`). Standalone build; main
firmware untouched.

- Joins ESP-NOW (broadcast peer, arm's WiFi channel), no WiFi network needed.
- Sends the arm's fixed ESP-NOW frame struct — `devCode`, four joint floats,
  `cmd` byte, `char message[210]` — with `cmd=1` and the JSON command in
  `message`. Struct layout per `docs/reference/robot-arm/20-esp-now.md`;
  verify against the vendored firmware source at implementation time.
- Serial console commands: `arm json <raw>`, `arm home`, `arm grip <angle>`,
  `arm demo` (canned sequence of poses from calibration + gripper open/close,
  with delays — ESP-NOW frames must carry non-blocking JSON only).

## Error handling

ESP-NOW broadcast is fire-and-forget: no delivery guarantee, no feedback
channel in this milestone. Acceptable for a demo; the bench prints the ESP-NOW
send-callback status (delivered/failed at the radio level) so silent failure
is at least visible. The demo sequence uses fixed delays between commands
rather than completion feedback. Two-way feedback is future work.

## Testing

All validation is on real hardware, in build order: console proves the JSON
command set and records poses; stock reflash proves the firmware path;
`{"T":117}` proves the gripper over USB serial; the bench proves ESP-NOW
end-to-end. Each stage has a working fallback (USB serial) for debugging.

## Out of scope (deliberate)

- Chess-square → arm-coordinate mapping, and playing real games.
- Feedback from the arm back to OpenChess (poses, completion, errors).
- Any change to the main OpenChess firmware, matrix, OLED, or engine code.
- Leader-mode ESP-NOW config commands (T:300–306) — broadcast-follower
  default is enough for this milestone.
