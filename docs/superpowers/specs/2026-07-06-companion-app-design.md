# OpenChess Companion App — Design Spec

Date: 2026-07-06
Status: Approved, implementation in progress

## Goal

A React Native (Expo) companion app for the OpenChess physical board. First
build is a fully navigable prototype of all 10 designed screens, running against
a **mock board** so it works with no hardware. Real transports (BLE + Wi-Fi) are
implemented later behind a stable interface — a separate agent owns firmware.

Design source: Claude Design project `4c187927-45f5-4e26-b4a2-a22a8ec18751`,
file `OpenChess App.dc.html` (10 iOS screens).

## Transport model (from the design)

Two transports, two jobs:

- **Phone ↔ Board: Bluetooth (BLE).** The app's live link — discovery/pairing
  (screen 01), board status, LED control, and reading physical moves. Works
  locally, no internet.
- **Board ↔ Internet: Wi-Fi.** The app provisions the board onto Wi-Fi
  (screen 02); the *board* then reaches Lichess and pulls firmware. Stockfish is
  the on-board offline opponent.

The board is the brain; the phone is a smart remote/display. (The old
`web/` LAN-WebSocket approach was deleted and is not used.)

For this build, **no real transport is implemented** — a `MockBoard` stands in.

## Architecture — three layers

### 1. Design system — `src/theme/`, `src/ui/`

Tokens from the design:

- Colors: bg `#EDEAE3`, panel `#F3F1EC`, card `#FFFFFF`, ink `#22201C`,
  text `#23211D`, muted `#6B6862` / `#8A857B` / `#9A9488`, green `#3F8F63`,
  green-bright `#5EC489`, green-tint `#E9F1EC`, red `#C4553D`, red-tint
  `#FBEDE9`, board-light `#F7F4ED`-ish / board-dark warm brown.
- Fonts: `Hanken Grotesk` (UI, weights 400–800), `IBM Plex Mono` (labels,
  codes, clocks).
- Radii: 10–24px; soft shadows; uppercase mono section labels with letter
  spacing.

Reusable primitives:

- `Screen` — safe-area padded page with the panel background.
- `Button` — primary (green, shadowed), secondary (ghost/text), destructive.
- `Card` — white rounded panel with subtle border/shadow; `DarkCard` variant
  (`#22201C`) for the connected-status and game-over screens.
- `SectionLabel` — mono uppercase label.
- `BoardGrid` — 8×8 grid rendering piece glyphs, with overlays for selection
  ring, LED dot (green glow), and error square (red pulse). Configurable so it
  serves Live, Setup, and Analysis screens.
- `StatusCard`, `Toggle`, `Segmented`, `Slider`, `ListRow`, `Pill`.

### 2. Board transport — `src/board/`

```ts
type LedCell = { file: number; rank: number; r: number; g: number; b: number };
type BoardMove = { from: string; to: string; kind: "lift" | "place" };
type BoardStatus = {
  connection: "disconnected" | "pairing" | "connected";
  battery: number;         // 0..100
  wifi?: { ssid: string; strength: 0 | 1 | 2 | 3; lichessReady: boolean };
  firmware?: string;
  name?: string;           // e.g. "OpenChess-4A2F"
};
type BoardInfo = { id: string; name: string; rssi: number };

interface BoardTransport {
  scan(): Promise<BoardInfo[]>;
  connect(id: string): Promise<void>;
  disconnect(): Promise<void>;
  provisionWifi(ssid: string, password: string): Promise<void>;
  setLEDs(cells: LedCell[]): void;
  getStatus(): BoardStatus;
  subscribeStatus(cb: (s: BoardStatus) => void): () => void;
  subscribeMove(cb: (m: BoardMove) => void): () => void;
}
```

- `MockBoard implements BoardTransport` — fakes discovery (`OpenChess-4A2F`),
  battery/Wi-Fi status, echoes `setLEDs`, and can emit simulated moves so the
  Live/Setup screens feel alive.
- `BoardProvider` (React context) owns the active transport and exposes it plus
  reactive status via a hook `useBoard()`.
- Real `BleBoard` / `WifiBoard` implement the same interface later — no UI
  changes. This interface is the contract the firmware agent should target.

### 3. Chess logic — `chess.js`

Used in-app for move validation, legal-move generation (→ which squares the
LEDs light as hints), FEN parsing/rendering, SAN move lists, and driving the
mock opponent. Once hardware exists, the physical board remains source of truth;
the app reconciles against it.

## Screens (expo-router, in `app/app/`)

Onboarding stack: `welcome` → `pair` → `wifi`.
App: `home`, `new-game`, `setup-board`, `live-game`, `game-over`, `analysis`,
`settings`.

Each mirrors the corresponding design screen 00–09. Navigation follows the
design flow (Home → New game → Set up board → Live game → Game over →
Analysis).

## Build order

1. Foundation (solo): scaffold Expo app, theme tokens, fonts, UI primitives,
   `BoardTransport` + `MockBoard` + `BoardProvider`, chess.js wiring, router
   shell.
2. Screens (parallel subagents): each screen built against the foundation from
   its design section.
3. Integration pass: wire navigation, run the app, fix visual/flow issues.

## Out of scope (stubbed)

Real BLE/Wi-Fi, Lichess OAuth, on-device Stockfish, EAS builds/deploys,
persistence beyond in-memory mock state.
