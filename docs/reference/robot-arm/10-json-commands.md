# RoArm-M2-S JSON Command Reference

Sources (fetched 2026-07-28):
- https://www.waveshare.com/wiki/RoArm-M2-S_JSON_Command_Meaning
- https://www.waveshare.com/wiki/RoArm-M2-S_Robotic_Arm_Control
- https://www.waveshare.com/wiki/RoArm-M2-S_EoAT_Setting
- https://github.com/waveshareteam/roarm_m2/blob/main/RoArm-M2_example/json_cmd.h
  (authoritative firmware command list; examples below match it)

Every command is a single-line JSON object sent over USB serial, UART RX/TX,
HTTP (`http://<ip>/js?json=<urlencoded>`), or wrapped in ESP-NOW. `"T"` is the
command type. Commands marked **blocking** stall the command loop until the
move finishes.

## Emergency

| Cmd | Name | Example |
|-----|------|---------|
| 0 | CMD_EMERGENCY_STOP | `{"T":0}` |
| 999 | CMD_RESET_EMERGENCY | `{"T":999}` |

## EoAT (end effector) type / geometry

| Cmd | Name | Example | Notes |
|-----|------|---------|-------|
| 1 | CMD_EOAT_TYPE | `{"T":1,"mode":0}` | mode 0 = gripper (default), 1 = wrist. Persist across boots by appending to the `boot` mission: `{"T":222,"name":"boot","step":"{\"T\":1,\"mode\":1}"}` |
| 2 | CMD_CONFIG_EOAT | `{"T":2,"pos":3,"ea":0,"eb":20}` | wrist mode only. pos = mounting hole (0 edge, 1 Ø3.2, 2 Ø4.2, 3 Ø10.2 mm); ea/eb = horizontal/vertical offset (mm) of the new tool tip. IK endpoint then tracks the tool tip. |

## Movement control (MOVING CTRL)

| Cmd | Name | Example | Notes |
|-----|------|---------|-------|
| 100 | CMD_MOVE_INIT | `{"T":100}` | all joints to init position. **Blocking.** |
| 101 | CMD_SINGLE_JOINT_CTRL | `{"T":101,"joint":1,"rad":0,"spd":0,"acc":10}` | radians. joint: 1 BASE, 2 SHOULDER, 3 ELBOW, 4 EOAT. spd in steps/s (4096 steps/rev, 0 = max), acc 0–254 in 100 steps/s² (0 = max). |
| 102 | CMD_JOINTS_RAD_CTRL | `{"T":102,"base":0,"shoulder":0,"elbow":1.57,"hand":3.14,"spd":0,"acc":10}` | all joints, radians. |
| 103 | CMD_SINGLE_AXIS_CTRL | `{"T":103,"axis":2,"pos":0,"spd":0.25}` | IK, one axis. axis: 1 X, 2 Y, 3 Z (mm), 4 T (rad). **Blocking**, curved speed profile. |
| 104 | CMD_XYZT_GOAL_CTRL | `{"T":104,"x":235,"y":0,"z":234,"t":3.14,"spd":0.25}` | IK move with interpolation. **Blocking.** |
| 1041 | CMD_XYZT_DIRECT_CTRL | `{"T":1041,"x":235,"y":0,"z":234,"t":3.14}` | IK, no interpolation, non-blocking, moves at max speed — meant for continuous streaming of nearby waypoints. |
| 105 | CMD_SERVO_RAD_FEEDBACK | `{"T":105}` | returns `{"T":1051,"x":...,"y":...,"z":...,"b":...,"s":...,"e":...,"t":...,"torB":...,"torS":...,"torE":...,"torH":...,"torswitchB":1,...,"v":1211}` — position (mm), joint angles (rad), joint loads, torque-lock states, supply voltage (0.01 V units). |
| 106 | CMD_EOAT_HAND_CTRL | `{"T":106,"cmd":3.14,"spd":0,"acc":0}` | gripper/wrist joint only, radians. Gripper range 1.08 (open) – 3.14 (closed); wrist range 1.08–5.20. |
| 121 | CMD_SINGLE_JOINT_ANGLE | `{"T":121,"joint":1,"angle":0,"spd":10,"acc":10}` | degrees. BASE ±180°, SHOULDER ±90°, ELBOW 0–180° (init 90°), EOAT 45–180° gripper / 45–315° wrist (init 180°). spd °/s, acc °/s² (max 22.5). |
| 122 | CMD_JOINTS_ANGLE_CTRL | `{"T":122,"b":0,"s":0,"e":90,"h":180,"spd":10,"acc":10}` | all joints, degrees. |
| 123 | CMD_CONSTANT_CTRL | `{"T":123,"m":0,"axis":0,"cmd":0,"spd":3}` | continuous jog. m: 0 angle mode / 1 xyzt mode. axis: joint or axis number. cmd: 0 stop, 1 increase, 2 decrease. spd 0–20. |

Axes (right-hand rule): X forward, Y left, Z up. Init pose is roughly
x=235, y=0, z=234, t=3.14.

## Torque / dynamics / PID

| Cmd | Name | Example | Notes |
|-----|------|---------|-------|
| 210 | CMD_TORQUE_CTRL | `{"T":210,"cmd":0}` | 0 = torque lock off (arm can be moved by hand), 1 = on. Any motion command re-enables torque. |
| 112 | CMD_DYNAMIC_ADAPTATION | `{"T":112,"mode":1,"b":60,"s":110,"e":50,"h":50}` | DEFA: per-joint max torque limits; arm springs back when external force exceeds limit. `{"T":112,"mode":0,"b":1000,...}` = off (limits reset to 1000). |
| 107 | CMD_EOAT_GRAB_TORQUE | `{"T":107,"tor":200}` | gripper clamp max torque, 0–1000 (200 = 20 % of servo max). |
| 108 | CMD_SET_JOINT_PID | `{"T":108,"joint":3,"p":16,"i":0}` | default p=16, i=0 (i in multiples of 8). Too high ⇒ oscillation. |
| 109 | CMD_RESET_PID | `{"T":109}` | |
| 110 | CMD_SET_NEW_X | `{"T":110,"xAxisAngle":0}` | redefine the X-axis heading. |
| 111 | CMD_DELAY_MILLIS | `{"T":111,"cmd":3000}` | delay (used inside missions). |

## Switch / LED outputs (the only "extra output" commands in this firmware)

| Cmd | Name | Example | Notes |
|-----|------|---------|-------|
| 113 | CMD_SWITCH_CTRL | `{"T":113,"pwm_a":-255,"pwm_b":-255}` | PWM −255…0(off)…+255 on the two switched-12 V PH2.0 2P ports (TB6612 H-bridge channels A/B, ~100 kHz PWM). |
| 114 | CMD_LIGHT_CTRL | `{"T":114,"led":255}` | LED brightness 0–255 on port A (the "LED lamp interface"). Internally the same TB6612 channel A. |
| 115 | CMD_SWITCH_OFF | `{"T":115}` | both switch ports off. |

Note: these are switched **12 V power outputs**, not hobby-servo PWM signals.
There is **no JSON command for a standard PWM servo** in the RoArm-M2-S
firmware (the `{"T":132,"IO4":...,"IO5":...}` PWM command belongs to the
WAVE ROVER / UGV firmware for the same board). See `40-custom-servo-io.md`.

## File system (ESP32 flash)

| Cmd | Name | Example |
|-----|------|---------|
| 200 | CMD_SCAN_FILES | `{"T":200}` |
| 201 | CMD_CREATE_FILE | `{"T":201,"name":"file.txt","content":"..."}` |
| 202 | CMD_READ_FILE | `{"T":202,"name":"file.txt"}` |
| 203 | CMD_DELETE_FILE | `{"T":203,"name":"file.txt"}` |
| 204 | CMD_APPEND_LINE | `{"T":204,"name":"file.txt","content":"..."}` |
| 205 | CMD_INSERT_LINE | `{"T":205,"name":"file.txt","lineNum":3,"content":"..."}` |
| 206 | CMD_REPLACE_LINE | `{"T":206,"name":"file.txt","lineNum":3,"content":"..."}` |
| 207 | CMD_READ_LINE | `{"T":207,"name":"file.txt","lineNum":3}` |
| 208 | CMD_DELETE_LINE | `{"T":208,"name":"file.txt","lineNum":3}` |

## Missions (recorded step sequences, stored in flash)

| Cmd | Name | Example |
|-----|------|---------|
| 220 | CMD_CREATE_MISSION | `{"T":220,"name":"mission_a","intro":"test"}` |
| 221 | CMD_MISSION_CONTENT | `{"T":221,"name":"mission_a"}` |
| 222 | CMD_APPEND_STEP_JSON | `{"T":222,"name":"mission_a","step":"{\"T\":104,\"x\":235,\"y\":0,\"z\":234,\"t\":3.14,\"spd\":0.25}"}` |
| 223 | CMD_APPEND_STEP_FB | `{"T":223,"name":"mission_a","spd":0.25}` (records current pose) |
| 224 | CMD_APPEND_DELAY | `{"T":224,"name":"mission_a","delay":3000}` |
| 225–227 | INSERT step/fb/delay at stepNum | `{"T":225,"name":"mission_a","stepNum":3,"step":"..."}` |
| 228–230 | REPLACE step/fb/delay at stepNum | `{"T":228,"name":"mission_a","stepNum":3,"step":"..."}` |
| 231 | CMD_DELETE_STEP | `{"T":231,"name":"mission_a","stepNum":3}` |
| 241 | CMD_MOVE_TO_STEP | `{"T":241,"name":"mission_a","stepNum":3}` |
| 242 | CMD_MISSION_PLAY | `{"T":242,"name":"mission_a","times":3}` (times = −1 loops forever) |

A mission named `boot` runs automatically at power-up (useful for persistent
settings). Details: https://www.waveshare.com/wiki/RoArm-M2-S_Step_Recording_and_Reproduction
and https://www.waveshare.com/wiki/RoArm-M2-S_FLASH_File_System_Operation

## ESP-NOW (300–306)

See `20-esp-now.md`.

## WiFi settings

| Cmd | Name | Example |
|-----|------|---------|
| 401 | CMD_WIFI_ON_BOOT | `{"T":401,"cmd":3}` (0 off, 1 AP, 2 STA, 3 AP+STA) |
| 402 | CMD_SET_AP | `{"T":402,"ssid":"RoArm-M2","password":"12345678"}` |
| 403 | CMD_SET_STA | `{"T":403,"ssid":"yourSSID","password":"yourPass"}` |
| 404 | CMD_WIFI_APSTA | `{"T":404,"ap_ssid":"...","ap_password":"...","sta_ssid":"...","sta_password":"..."}` |
| 405 | CMD_WIFI_INFO | `{"T":405}` |
| 406 | CMD_WIFI_CONFIG_CREATE_BY_STATUS | `{"T":406}` |
| 407 | CMD_WIFI_CONFIG_CREATE_BY_INPUT | `{"T":407,"mode":3,"ap_ssid":"...",...}` |
| 408 | CMD_WIFI_STOP | `{"T":408}` |

## Bus servo settings (use with care)

| Cmd | Name | Example | Notes |
|-----|------|---------|-------|
| 501 | CMD_SET_SERVO_ID | `{"T":501,"raw":1,"new":11}` | change a bus servo's ID. Arm IDs: 11 base, 12/13 shoulder pair, 14 elbow, 15 gripper. |
| 502 | CMD_SET_MIDDLE | `{"T":502,"id":11}` | set current position as middle. |
| 503 | CMD_SET_SERVO_PID | `{"T":503,"id":14,"p":16}` | |

## ESP32 system

| Cmd | Name | Example |
|-----|------|---------|
| 600 | CMD_REBOOT | `{"T":600}` |
| 601 | CMD_FREE_FLASH_SPACE | `{"T":601}` |
| 602 | CMD_BOOT_MISSION_INFO | `{"T":602}` |
| 603 | CMD_RESET_BOOT_MISSION | `{"T":603}` |
| 604 | CMD_NVS_CLEAR | `{"T":604}` (fixes WiFi issues after reflash) |
| 605 | CMD_INFO_PRINT | `{"T":605,"cmd":1}` (0 quiet, 1 debug prints [default], 2 flow feedback) |
