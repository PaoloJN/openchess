# OpenChess App — BLE Transport Design Spec

Date: 2026-07-06
Status: Approved, implementation in progress

## Goal

Replace the app's `MockBoard` with a real Bluetooth Low Energy transport that
talks to the OpenChess board firmware end-to-end: scan, connect, live status,
LED control, physical move events, and Wi-Fi provisioning — all over BLE. The
phone <-> board link is BLE; the board uses Wi-Fi only for board -> internet
(Lichess / OTA), provisioned over BLE.

The firmware side is already implemented (`firmware/src/shell/ble_board.*`,
NimBLE). This spec covers the phone side and locks the shared GATT contract.

## GATT contract (source of truth: firmware `ble_board.cpp`)

- Advertised name: `OpenChess-XXXX`, advertises the service UUID. MTU 517.
- Service UUID: `6f00c0de-b5a3-f393-e0a9-e50e24dcca01`
- **CMD** characteristic `6f00c0de-b5a3-f393-e0a9-e50e24dcca02` — WRITE /
  WRITE_NR. App writes UTF-8 JSON commands:
  - `{"t":"setLEDs","cells":[{"file":0-7,"rank":0-7,"r":0-255,"g":..,"b":..}]}`
  - `{"t":"scanWifi"}`
  - `{"t":"provisionWifi","ssid":"..","password":".."}`
- **EVT** characteristic `6f00c0de-b5a3-f393-e0a9-e50e24dcca03` — NOTIFY / READ.
  Board notifies UTF-8 JSON events:
  - `{"t":"status","battery":int,"firmware":str,"wifi":{"ssid":str,"strength":int,"lichessReady":bool}}`
  - `{"t":"move","square":str,"kind":"lift"|"place"}`
  - `{"t":"wifiList","networks":[{"name":str,"lock":bool,"strength":int}]}`

Notes: `status` carries no board name (app takes it from the advertisement) and
no connection field (derived from BLE link state).

## Components

### `src/board/bleCodec.ts` — pure, radio-free

- `encodeSetLEDs(cells): string`, `encodeScanWifi(): string`,
  `encodeProvisionWifi(ssid, password): string`.
- `decodeEvent(json): BoardEvent` — a discriminated union
  (`{kind:'status',...} | {kind:'move',...} | {kind:'wifiList',...} | {kind:'unknown'}`).
- No dependency on ble-plx. Unit-tested.

### `src/board/BleBoard.ts` — `implements BoardTransport`

Wraps `react-native-ble-plx` (`BleManager`, one `Device`). Characteristic
values are base64 (ble-plx convention) — encode/decode UTF-8 at the boundary.

- `scan()`: `startDeviceScan([SVC_UUID], null, cb)` for ~4s, dedupe by id, map to
  `BoardInfo` (id, name, rssi), stop scan, resolve. Requests Android runtime
  permissions first.
- `connect(id)`: connect, `discoverAllServicesAndCharacteristics`,
  `monitorCharacteristic(EVT)` → `decodeEvent` → fan out to status/move
  subscribers; set connection state; on disconnect update state.
- `disconnect()`: cancel connection.
- `setLEDs(cells)`: `writeCharacteristicWithoutResponse(CMD, base64(json))`.
- `scanWifi()`: write `{t:"scanWifi"}`, resolve on next `wifiList` event
  (8s timeout → reject).
- `provisionWifi(ssid,pw)`: write command; resolve on write. New wifi arrives via
  later `status` events.
- Maintains a `BoardStatus` cache; merges each `status` event; `subscribeStatus`
  replays the current cache on subscribe (same shape as MockBoard).

### `src/board/createBoard.ts` — selection

- Returns `BleBoard` when running on a native dev build (not Expo Go) and the
  ble-plx native module is available; otherwise `MockBoard`.
- Detection via `expo-constants` (`executionEnvironment`). A dev override
  (Settings toggle, persisted) can force `mock` or `ble`.
- `BoardProvider` calls `createBoard()` once.

### Screen wiring

- `pair.tsx`: replace hardcoded `connect('4A2F')` with `scan()` → render the
  first discovered board in the existing card → `connect(device.id)` on the
  button. Show a scanning/empty state when nothing is found. All other screens
  already consume `useBoard()` and go live unchanged.

### Native config

- `expo install react-native-ble-plx expo-dev-client`.
- Add the ble-plx Expo config plugin to `app.json` with the iOS
  `NSBluetoothAlwaysUsageDescription` string; Android `BLUETOOTH_SCAN` /
  `BLUETOOTH_CONNECT` permissions. Runtime permission request on Android before
  scanning.

## Testing

- `bleCodec` unit tests (encode strings, decode each event type + malformed).
- `tsc --noEmit` clean; Metro bundle clean; `expo prebuild` config resolves.
- End-to-end (scan/connect/LED/move/provision) requires a **physical** phone
  (iOS Simulator has no BLE) and a **flashed** board — deferred until hardware is
  connected. MockBoard keeps the app fully usable until then.

## Out of scope

Gameplay logic over the live link (real clocks, Lichess/Stockfish move flow),
OTA, BLE bonding/encryption. The transport is the deliverable.

## Deferred: Wi-Fi provisioning (2026-07-06)

Real Wi-Fi provisioning is deferred — it only serves online play (Lichess /
Chess.com) and OTA, none of which exists yet, and the BLE link the app runs on
already works. The `wifi.tsx` screen is now an honest, skippable step (no fake
password field; shows the board's live scan best-effort; "Skip for now" → Home).

Verified on hardware: BLE scan + connect + status work. Two things to fix when
this is picked back up, one on each side:

- **Firmware — chunk `wifiList`.** iOS delivers a BLE notification of at most
  ~(negotiated MTU − 3) bytes, and iOS commonly negotiates ~185 regardless of
  the board's `setMTU(517)`. A multi-network `wifiList` JSON exceeds that, so the
  notification is truncated and the app can't parse it (the app's 8s wait then
  times out and the list stays empty). Fix: send one network per notification
  (e.g. `{"t":"wifiNet","index","count",...}`) or split the JSON into framed
  chunks the app reassembles. Small `status`/`move` messages are unaffected.
- **App — real network select + password entry + `provisionWifi(ssid, pw)`**
  wired to the chunked list, plus a "Set up Wi-Fi" entry point in Settings.
