# RoArm-M2-S ESP-NOW Control

Source: https://www.waveshare.com/wiki/RoArm-M2-S_ESP-NOW_Control (fetched 2026-07-28)
Firmware reference: `esp_now_ctrl.h` / `json_cmd.h` in
https://github.com/waveshareteam/roarm_m2

ESP-NOW is Espressif's connectionless WiFi-layer protocol: low latency (no
TCP/IP stack), broadcast/multicast/unicast, low power. The arm ships in
**Follower mode with broadcast control enabled** — out of the box it will obey
ESP-NOW frames sent to the broadcast MAC `FF:FF:FF:FF:FF:FF`.

The arm's MAC address is shown on its OLED at boot, or query with `{"T":302}`.

## Communication data structure (important for a DIY ESP32 leader)

ESP-NOW peers exchange this fixed C struct, NOT raw JSON strings:

```c
typedef struct struct_message {
  byte devCode;      // device code, unused by stock demo (set 0)
  float base;        // BASE joint angle (rad)
  float shoulder;    // SHOULDER joint angle (rad)
  float elbow;       // ELBOW joint angle (rad)
  float hand;        // GRIPPER/WRIST joint angle (rad)
  byte cmd;          // 0 = move joints to b/s/e/h; 1 = execute JSON in message
  char message[210]; // JSON command string when cmd==1 (non-blocking cmds only)
} struct_message;
```

So a second ESP32 controlling the arm directly via ESP-NOW must
`esp_now_send()` this struct to the arm's MAC (or broadcast). Two usage
patterns:

- `cmd = 0`: the four floats are joint targets in radians — direct pose
  streaming (this is how leader-follower mimicry works).
- `cmd = 1`: floats ignored; `message` carries any **non-blocking** JSON
  command (e.g. `{"T":1041,...}`, `{"T":114,"led":255}`, `{"T":106,...}`).

## JSON commands for ESP-NOW configuration (sent over serial/HTTP)

### T:300 — CMD_BROADCAST_FOLLOWER (broadcast permission)

```json
{"T":300,"mode":1}
{"T":300,"mode":0,"mac":"00:00:00:00:00:00"}
```

- mode 1 (factory default): device obeys broadcast frames from anyone.
- mode 0: ignore broadcasts; only obey the Leader MAC given in `mac`
  (use `00:00:00:00:00:00` if none).

### T:301 — CMD_ESP_NOW_CONFIG (operation mode)

```json
{"T":301,"mode":3}
```

- 0 — ESP-NOW off.
- 1 — **Stream multicast Leader**: continuously sends its own joint positions
  to every MAC in its peerList.
- 2 — **Stream unicast/broadcast Leader**: continuously streams joint
  positions to one MAC (or to all, if that MAC is `FF:FF:FF:FF:FF:FF`).
- 3 — **Follower** (factory default): receives ESP-NOW commands; can still
  send one-shot commands to others as a leader.

In modes 1/2 the leader arm streams its servo feedback positions, so
followers mirror it in real time when you move the leader by hand
(turn the leader's torque off first: `{"T":210,"cmd":0}`).
Note: WiFi must be in STA or AP+STA mode for ESP-NOW.

### T:302 — CMD_GET_MAC_ADDRESS

```json
{"T":302}
```
Returns e.g. `44:17:93:EE:FD:70`.

### T:303 / T:304 — add/remove peerList entry

```json
{"T":303,"mac":"44:17:93:EE:FD:70"}
{"T":304,"mac":"44:17:93:EE:FD:70"}
```

- Dozens of MACs can be added (multicast group).
- For broadcast control add `FF:FF:FF:FF:FF:FF` as a peer — but do not mix
  the broadcast MAC into a multicast peerList.

### T:305 — CMD_ESP_NOW_GROUP_CTRL (multicast to whole peerList)

```json
{"T":305,"dev":0,"b":0,"s":0,"e":1.57,"h":1.57,"cmd":0,"megs":"hello!"}
{"T":305,"dev":0,"b":0,"s":0,"e":0,"h":0,"cmd":1,"megs":"{\"T\":114,\"led\":255}"}
```

- Keys map onto the struct: dev→devCode, b/s/e/h→joint floats, cmd→cmd,
  megs→message.
- cmd 0: followers move joints to b/s/e/h (radians).
- cmd 1: followers execute the JSON inside `megs` (non-blocking commands).

### T:306 — CMD_ESP_NOW_SINGLE (unicast, or broadcast via FF:...:FF)

```json
{"T":306,"mac":"44:17:93:EE:FD:70","dev":0,"b":0,"s":0,"e":1.57,"h":1.57,"cmd":0,"megs":"hello!"}
{"T":306,"mac":"FF:FF:FF:FF:FF:FF","dev":0,"b":0,"s":0,"e":0,"h":0,"cmd":1,"megs":"{\"T\":114,\"led\":255}"}
```

Same fields as T:305 plus target `mac`. The target MAC must already be in the
peerList (add with T:303 first, including the broadcast MAC).

## Typical setups

**Arm-to-arm broadcast (leader arm on USB serial):**
1. On leader: `{"T":303,"mac":"FF:FF:FF:FF:FF:FF"}`
2. One-shot to all followers:
   `{"T":306,"mac":"FF:FF:FF:FF:FF:FF","dev":0,"b":0,"s":0,"e":0,"h":0,"cmd":1,"megs":"{\"T\":114,\"led\":255}"}`
3. Real-time mimic: `{"T":210,"cmd":0}` (torque off), `{"T":301,"mode":2}`
   (stream-broadcast leader), then move the leader by hand.

**DIY ESP32 leader (no arm on the sending side):**
- Program your own ESP32 with esp_now, register the arm's MAC (or broadcast
  MAC) as a peer, and send the `struct_message` above. Use `cmd=1` +
  JSON-in-`message` for full command access, or `cmd=0` for raw pose control.
- The arm needs no configuration if it is still in factory defaults
  (Follower + broadcast allowed). For robustness against neighbors, set
  `{"T":300,"mode":0,"mac":"<your ESP32 MAC>"}` on the arm.
- Both ends must be on the same WiFi channel (defaults work if the arm stays
  in AP mode on channel 1 and the sender uses channel 1).
