# OpenChess Companion App

Expo SDK 57 + expo-router + TypeScript. The phone is a remote for the board:
pair over BLE, see the board mirrored live, start games, control LEDs, review
results. The board stays the brain.

## Run

```bash
npm install
npx expo start              # Expo Go or web: mock board, no Bluetooth
npx expo run:ios            # native dev build: real BLE to the board
```

BLE does not work in Expo Go or the iOS Simulator. Use a physical phone and a
flashed board. After the first native build, `npx expo start --dev-client` is
enough unless native code changed.

## Layout

```text
src/app/        screens (welcome, pair, wifi, home, new game, live game,
                setup board, game over, analysis, settings)
src/board/      BoardTransport interface, BleBoard, MockBoard, bleCodec,
                types.ts (the contract shared with firmware/src/shell/)
src/chess/      chess.js rendering helpers
src/ui/         Screen, Text, Button, Card, BoardGrid, icons
src/theme/      design tokens
```

## BLE Contract

Service `6f00c0de-b5a3-f393-e0a9-e50e24dcca01`. The app writes JSON to the
CMD characteristic (`...ca02`), the board notifies JSON on EVT (`...ca03`).
Source of truth is `firmware/src/shell/ble_board.cpp`; the codec here must
match it.

## Checks

```bash
npx tsc --noEmit
npm test
```
