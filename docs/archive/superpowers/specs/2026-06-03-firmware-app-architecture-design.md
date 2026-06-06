# Firmware & App Architecture — Design Spec

**Date:** 2026-06-03
**Status:** Approved design, not yet implemented. Firmware work blocked until PCB is fab-ready.

## Problem

joojoooo's OpenChess firmware works but has two layers that don't fit this project's goals:

1. **Onboarding is unfriendly.** It uses a WiFi captive portal (user switches their phone's WiFi to a "OpenChess-AP" SSID, opens a browser, enters home WiFi creds). Industry-standard ugly.
2. **The UI is a single embedded HTML web app.** Paolo plans to ship both a polished web UI *and* a native mobile app. The existing UI doesn't separate cleanly from the firmware.

The redesign keeps joojoooo's proven core (matrix scan, Lichess client, Stockfish, OTA, move persistence) and rebuilds the WiFi/UI/transport shell.

## Approach: Keep core engine, rebuild shell

| Layer | Decision |
|---|---|
| **Matrix scan** (74HC595 + PNP column drive, hall sensor sense) | Lift from joojoooo. Already matches this PCB exactly. |
| **Lichess client** (`chess_lichess.cpp`) | Lift from joojoooo. Non-trivial protocol work already done. |
| **Stockfish integration** (`chess_bot.cpp`) | Lift from joojoooo. RAM tuning and partition table already validated. |
| **Move history / persistence** | Lift from joojoooo. |
| **OTA update mechanism** | Lift from joojoooo. |
| **LED driver** | Rewrite. joojoooo expects 8×8 LEDs under squares; this PCB has 9×9 at corners (81 total). Rewrite `ledIndexMap` and `setSquareColor`. |
| **WiFi provisioning** | **Replace.** Captive portal → BLE-based provisioning (see below). |
| **Web UI** | **Replace.** Single-file HTML → modern React SPA served from board. |
| **App/board protocol** | **Replace.** New JSON-over-WebSocket protocol shared between web UI and mobile app. |
| **Mobile app** | **New.** React Native + Expo. |

Caveat: how cleanly joojoooo's code separates engine from shell is unknown until reviewed. First implementation step is a code audit to confirm the lift surface.

## Onboarding: BLE provisioning + mDNS

```
1. Plug board in → BLE advertising for 60s (blue LED on board)
2. User opens mobile app → app scans for nearby boards over BLE
3. User taps their board → app pairs via BLE
4. Board scans available WiFi networks, sends list over BLE
5. User picks home WiFi, types password
6. Board joins WiFi, BLE shuts off, LED turns green
7. Mobile app and web UI now talk to board over LAN via mDNS (`openchess.local`) + WebSocket
8. Total time-to-play: ~30s, no menu hunting, no captive portal
```

**Recovery:** hold a button on the board for 5s → BLE provisioning re-opens.

**QR code (optional fallback):** a sticker on the back of the board encodes a pairing URL. Useful for the "I have multiple boards nearby" or marketing/demo scenarios. Not the primary flow.

**Library choice:** NimBLE-Arduino (works in joojoooo's existing PlatformIO/Arduino setup, ~80KB flash overhead). ESP-IDF's `wifi_provisioning` is the alternative but would force a framework switch.

## Steady-state protocol: pure WebSocket

One bidirectional WebSocket carries all application traffic. JSON-RPC-style framing:

```
Requests:  {"type":"...","id":N, ...}
Responses: {"type":"...","id":N, "result":...}
Events:    {"type":"event_name", ...}      // server-pushed, no id
```

Tiny HTTP surface on the board:

```
GET  /              → index.html + JS bundle (web UI)
GET  /static/*      → web UI assets
POST /ota           → firmware upload (multipart; awkward over WS)
WS   /ws            → the actual application API
```

**Why pure WebSocket and not REST + WS:**

- One protocol, two frontends. Web UI and mobile app use identical message types — build the protocol once, both clients consume it.
- Almost every interaction is reactive (moves, board state changes, LED updates). REST is awkward for any of it.
- One connection, one auth flow, one reconnect handler — cleaner firmware.
- Future-compatible with a BLE-bridged fallback (same JSON messages framed over a BLE characteristic).

**Why not MQTT/gRPC/GraphQL:** broker overhead, HTTP/2 weight, complexity for the scale. Not justified.

## Web UI hosting: served from the board

The board hosts `index.html` and the JS bundle. No internet dependency for the UI.

- Pros: offline-capable, single-binary deploy, no hosting cost.
- Cons: UI updates require an OTA firmware push — but OTA-over-WiFi already exists in joojoooo's design and is kept.

**Framework: Next.js with static export** (`output: 'export'`). Used as a static-site generator — produces a directory of `.html` + `.js` + `.css` that gets embedded into firmware (likely via SPIFFS/LittleFS partition). No server-side features (no RSC, no Server Actions, no API routes) since the ESP32 has no Node runtime. Chosen over Vite for the better DX, file-based routing, and shared component patterns with the React Native app.

Alternative considered: host the UI at a static site (e.g. `openchess.app` on Vercel) that connects to the local board's WebSocket. Faster to iterate but adds an external dependency for a product that's mostly local-only. Rejected for v1 — can be added later as a power-user alternative without changing the board protocol.

## Mobile app: React Native + Expo

- Single codebase covers iOS + Android.
- Web UI is React → component logic, protocol clients, and state shapes share between web and mobile.
- BLE support via `react-native-ble-plx`, mature library.
- Expo handles iOS shell concerns: background BLE entitlements, universal links for the optional QR pairing flow.

Alternatives considered: Flutter (great, but forces web UI into a separate stack); native Swift+Kotlin (best UX, 2× the work); PWA (no Web Bluetooth on iOS Safari, kills BLE provisioning). Rejected.

## Trade-offs accepted

- **Native mobile app is required for first-time pairing.** Web Bluetooth doesn't exist on iOS Safari, so the BLE pairing moment has to happen in the app. Mitigation: keep a hidden captive-portal fallback (long button hold) for tinkerers who self-rescue without the app.
- **mDNS isn't 100% reliable on every router.** ~95% of home setups work. Fallback: manual IP entry in app settings, or BLE re-broadcast for re-discovery.
- **BLE provisioning adds firmware complexity** (NimBLE stack, protocol design, pairing UX, error recovery). Real work, justified because the mobile app already exists in scope.

## Implementation order

Build incrementally so a working board exists at every step:

1. **Fork joojoooo's repo into `firmware/`.** Audit the code to confirm engine ↔ shell separation is clean.
2. **Adapt LED driver for 9×9-at-corners layout.** Hardest pure-firmware task. Validates that the engine pieces still work after PCB swap.
3. **Build the WebSocket protocol on the board.** Serve a minimal HTML dev page over HTTP for testing. Manually type the board's IP for now.
4. **Build the React web UI.** Connect to board over the new protocol. Now you have a working board over LAN.
5. **Add mDNS discovery.** Now no IP typing — `openchess.local` works.
6. **Build the React Native app.** Reuses the protocol client from the web UI. Same backend, no special cases.
7. **Add BLE provisioning.** Replaces the "manually configured WiFi" step. Polish, not blocker.
8. **Cut the captive-portal fallback down to a recovery path** (long button hold), not the primary flow.

Each step ships a working board.

## Open sub-decisions for later

- **Auth model.** Is the WebSocket open to anyone on the LAN, or does pairing produce a shared secret that the app/web client presents? Probably the latter (simple bearer token from BLE pairing handshake). Decide when implementing step 3.
- **Multi-client behavior.** Does the board accept multiple simultaneous WebSocket clients (so phone + laptop browser can both watch a game)? Probably yes, broadcast events to all. Decide when implementing step 4.
- **Web UI build pipeline.** Vite + React + TypeScript is the default; the dev-time experience and the embed-into-firmware path need to be confirmed.
- **Versioning.** App ↔ firmware protocol version handshake on connect, so older apps don't break with newer firmware. Decide when implementing step 6.

## Out of scope

- Mechanical (wooden case, piece design)
- Stockfish opening-book / NNUE updates beyond what joojoooo ships
- Cloud relay (board-from-anywhere over internet) — local-only is enough for v1
- Matter / HomeKit certification — overkill for a hobby project
