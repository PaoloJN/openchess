# Firmware Foundations Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fork joojoooo's OpenChess firmware, audit its engine/shell boundary, restructure into a clean monorepo, adapt the LED driver for the 9×9-at-corners layout, and ship a working end-to-end loop: Next.js web UI ↔ WebSocket on ESP32 dev board ↔ a single test LED. No real PCB required.

**Architecture:** Monorepo with `firmware/` (PlatformIO/Arduino), `web/` (Next.js static export), `app/` (React Native, scaffolded but not built out in this plan). Pure-WebSocket JSON-RPC protocol shared by web and app. LED driver lifted but its `ledIndexMap` rewritten for 9×9. Other engine pieces (Lichess client, Stockfish, matrix scan, OTA) lifted as-is and verified to still build.

**Tech Stack:** PlatformIO + Arduino-ESP32, ESPAsyncWebServer + AsyncWebSocket, FastLED (already in joojoooo's code), Next.js 14+ with static export, TypeScript, Vitest, Unity (PlatformIO native unit tests).

**Scope of this plan:** Phase A — what's achievable without the real PCB. Phase B (BLE provisioning, mDNS polish, matrix-scan validation on real hardware, React Native app) is scoped separately and will get its own plan when the PCB is fab-ready.

---

## File structure (after this plan executes)

```
openchess/
├── firmware/                     ← was the README placeholder, becomes real
│   ├── platformio.ini            ← lifted from joojoooo, env adjusted
│   ├── partitions.csv            ← lifted from joojoooo
│   ├── src/
│   │   ├── main.cpp              ← lifted, then heavily edited (shell rewrite)
│   │   ├── engine/               ← NEW: kept-as-is pieces from joojoooo
│   │   │   ├── board_driver.h    ← lifted, LED_COUNT/NUM_ROWS/NUM_COLS edited
│   │   │   ├── board_driver.cpp  ← lifted, ledIndexMap rewritten for 9×9
│   │   │   ├── chess_lichess.*   ← lifted as-is
│   │   │   ├── chess_bot.*       ← lifted as-is
│   │   │   ├── move_history.*    ← lifted as-is
│   │   │   └── ota_updater.*     ← lifted as-is
│   │   ├── shell/                ← NEW: replaces joojoooo's web stack
│   │   │   ├── ws_server.h       ← NEW: WebSocket lifecycle
│   │   │   ├── ws_server.cpp     ← NEW
│   │   │   ├── protocol.h        ← NEW: JSON-RPC message types
│   │   │   └── protocol.cpp      ← NEW: parse/serialize
│   │   └── web_bundle/           ← NEW: embedded Next.js static export
│   ├── data/                     ← NEW: SPIFFS/LittleFS content (mirrors web/ build)
│   ├── test/                     ← NEW: native unit tests
│   │   ├── test_led_mapping/
│   │   └── test_protocol/
│   ├── AUDIT.md                  ← NEW: engine/shell classification of joojoooo's code
│   └── README.md                 ← edited
├── web/                          ← NEW: Next.js app
│   ├── package.json
│   ├── next.config.mjs           ← output: 'export'
│   ├── tsconfig.json
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx              ← root page, board visualization placeholder
│   │   └── globals.css
│   ├── lib/
│   │   ├── protocol.ts           ← shared with React Native app later
│   │   └── ws-client.ts          ← WebSocket client
│   └── components/
│       └── BoardView.tsx         ← minimal 8x8 board placeholder
└── app/                          ← stub only this plan; build out in Phase B
    └── README.md                 ← "future React Native app — see plan B"
```

**Why this layout:** engine and shell are physically separated in `firmware/src/`, making the design decision visible in the directory structure. `web/` ships the UI bundle into `firmware/data/` for embedding. The `app/` directory is a placeholder so the monorepo shape is right.

---

## Task 1: Clone joojoooo's firmware and verify it builds

**Files:**
- Modify: `firmware/` (currently has only `CLAUDE.md` and `README.md`)
- Create: `firmware/upstream/` (temporary working area for the clone)

**Context:** We can't lift code we haven't verified compiles in our environment. Doing this in a `upstream/` subfolder keeps the cleanup easy.

- [ ] **Step 1: Clone joojoooo's repo into a working subdirectory**

```bash
cd /Users/paolonessim/Projects/openchess/firmware
git clone https://github.com/joojoooo/OpenChess.git upstream
```

- [ ] **Step 2: Inspect what's there**

```bash
ls -la upstream/
cat upstream/platformio.ini
ls upstream/src/
```

Note the actual file list — the plan assumes the structure described in `firmware/CLAUDE.md`, but reality is the source of truth.

- [ ] **Step 3: Build it in PlatformIO without modifications**

```bash
cd upstream
pio run -e esp32dev
```

Expected: clean build OR a list of dependency / config errors. If errors, capture them — they tell us what we need to fix before lifting.

- [ ] **Step 4: If the build fails, fix the minimum needed to make it compile**

Common likely issues:
- Library version pin drift (FastLED, ArduinoJson, AsyncTCP, ESPAsyncWebServer). Update `lib_deps` to current versions.
- Partition table file missing or path wrong.

Fix iteratively until `pio run` succeeds. Do NOT modify any source code — only `platformio.ini` and possibly `partitions.csv`.

- [ ] **Step 5: Commit the working upstream clone**

```bash
cd /Users/paolonessim/Projects/openchess
git add firmware/upstream
git commit -m "firmware: clone joojoooo upstream into working subdirectory

Verified pio run succeeds. Will audit and lift cleaned pieces in
subsequent tasks; upstream/ is throwaway working space, will be
deleted after Task 4."
```

---

## Task 2: Audit engine vs shell separation

**Files:**
- Create: `firmware/AUDIT.md`

**Context:** The whole "keep engine, rebuild shell" plan rests on the boundary being clean. This task forces us to find out before we commit to the architecture. If the boundary is tangled (engine reaches into the web UI, shell reaches into board state), the architecture needs adjustment.

- [ ] **Step 1: List every `.cpp` and `.h` in `upstream/src/`**

```bash
find upstream/src -name '*.cpp' -o -name '*.h' | sort
```

- [ ] **Step 2: For each file, classify it**

Create `firmware/AUDIT.md` with this structure:

````markdown
# joojoooo Engine/Shell Audit

Generated: <today>
Upstream commit: <git rev-parse HEAD inside upstream/>

## Classification

| File | Class | Notes |
|---|---|---|
| src/board_driver.cpp | ENGINE | LED + matrix scan, lift but rewrite ledIndexMap |
| src/chess_lichess.cpp | ENGINE | Lichess client, lift as-is |
| src/web/index.html | SHELL | Replace with Next.js bundle |
| ... | ... | ... |

## Engine pieces (lift as-is)

[list]

## Engine pieces requiring modification

[list with what changes]

## Shell pieces (delete, replace)

[list]

## Cross-layer concerns

If any engine file `#include`s a shell file, list it here. Each one is a
re-architecture decision — that engine piece needs to be cleaned up before
lifting, or its dependency rewritten.

## Verdict

- [ ] Boundary is clean enough to lift as planned
- [ ] Boundary has fixable entanglements (list them)
- [ ] Boundary is too tangled — plan needs adjustment
````

- [ ] **Step 3: Fill in the audit by reading the files**

Read each `.cpp` and `.h`. For each, look at the `#include`s and the public API. Engine files should only depend on hardware libraries, FreeRTOS, FastLED, ArduinoJson, the Lichess HTTP/SSE client. Shell files include WiFi config, web server, HTML, captive portal logic.

- [ ] **Step 4: Identify cross-layer entanglements explicitly**

For example: does `board_driver.cpp` directly call a function in `web/` to update the UI? If yes, that's a shell dependency leaking into engine. Note it. We'll resolve by introducing an event callback the shell registers with the engine.

- [ ] **Step 5: Commit the audit**

```bash
git add firmware/AUDIT.md
git commit -m "firmware: audit joojoooo engine/shell separation

Result: <one-sentence verdict>. Identified N cross-layer entanglements
to resolve during the lift (see AUDIT.md)."
```

- [ ] **Step 6: STOP and review the verdict**

If verdict is "boundary too tangled," stop and revise the architecture spec before proceeding. The whole plan assumes the boundary is liftable.

---

## Task 3: Set up the firmware project structure

**Files:**
- Create: `firmware/platformio.ini` (adapted from upstream)
- Create: `firmware/src/main.cpp` (stub)
- Create: `firmware/src/engine/.gitkeep`
- Create: `firmware/src/shell/.gitkeep`
- Create: `firmware/test/.gitkeep`
- Create: `firmware/partitions.csv` (from upstream)
- Delete: `firmware/upstream/` (after lift in Task 4)

**Context:** We're committing to the engine/shell split as a directory structure, not just a naming convention. Tools (compilers, future readers) will see it.

- [ ] **Step 1: Create the directory skeleton**

```bash
cd /Users/paolonessim/Projects/openchess/firmware
mkdir -p src/engine src/shell test data
touch src/engine/.gitkeep src/shell/.gitkeep test/.gitkeep data/.gitkeep
```

- [ ] **Step 2: Copy and adapt `platformio.ini` from upstream**

```bash
cp upstream/platformio.ini ./platformio.ini
cp upstream/partitions.csv ./partitions.csv 2>/dev/null || true
```

- [ ] **Step 3: Edit `platformio.ini`** to add a separate native test environment

Read the file first to understand its current shape. Then add (or merge with existing envs):

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
board_build.partitions = partitions.csv
build_flags =
    -DCORE_DEBUG_LEVEL=3
lib_deps =
    fastled/FastLED@^3.6.0
    bblanchon/ArduinoJson@^7.0.0
    ottowinter/ESPAsyncWebServer-esphome@^3.1.0
    h2zero/NimBLE-Arduino@^1.4.1

[env:native]
platform = native
test_framework = unity
build_flags =
    -std=c++17
    -DUNIT_TEST
```

(Version pins are starting points; adjust based on what Task 1 confirmed builds.)

- [ ] **Step 4: Create stub `src/main.cpp`** that compiles but does nothing

```cpp
#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  Serial.println("OpenChess firmware booting");
}

void loop() {
  delay(1000);
}
```

- [ ] **Step 5: Verify the empty project builds**

```bash
pio run -e esp32dev
```

Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add firmware/platformio.ini firmware/partitions.csv firmware/src firmware/test firmware/data
git commit -m "firmware: scaffold engine/shell project structure

Empty PlatformIO project that builds cleanly. Next task lifts the
classified-as-ENGINE files from upstream/ into src/engine/."
```

---

## Task 4: Lift engine files from upstream

**Files:**
- Copy from `firmware/upstream/src/` to `firmware/src/engine/`:
  - All files classified ENGINE in `AUDIT.md`
- Delete: `firmware/upstream/`

**Context:** This is the "actually take the code" step. We do NOT modify any engine code yet — we lift, verify it builds in the new location, then commit. LED-driver rewrite is Task 5.

- [ ] **Step 1: Copy each ENGINE file**

For each file classified ENGINE in `AUDIT.md`:

```bash
cp upstream/src/<path>/<file> firmware/src/engine/<file>
```

If files reference each other with relative includes (`#include "../foo.h"`), keep the paths working by adjusting `#include` lines to match the new flat `src/engine/` layout.

- [ ] **Step 2: Update `main.cpp`** to include and call into the engine just enough to verify it links

This depends on what the engine API looks like — typically something like:

```cpp
#include <Arduino.h>
#include "engine/board_driver.h"

void setup() {
  Serial.begin(115200);
  Serial.println("OpenChess firmware booting");
  board_driver_init();  // or whatever the real entry point is
}

void loop() {
  // intentionally idle; full loop wired up in Task 7
  delay(1000);
}
```

- [ ] **Step 3: Build**

```bash
pio run -e esp32dev
```

Expected: PASS. If it fails, the engine has shell dependencies that the audit missed — go back, update `AUDIT.md`, and either lift the missing dep or stub it.

- [ ] **Step 4: Delete `upstream/`**

```bash
rm -rf upstream/
```

The lifted code now lives in `src/engine/`. The original is still in git history via the Task 1 commit if we ever need to consult it; we also have the `references/openchess-joojoooo/` clean reference per project CLAUDE.md.

- [ ] **Step 5: Commit**

```bash
git add firmware/src/engine firmware/src/main.cpp
git rm -r firmware/upstream
git commit -m "firmware: lift engine files from joojoooo upstream

Files lifted: <list from AUDIT.md>. Built clean on esp32dev. Engine
sources unchanged from upstream except for #include path adjustments;
LED driver and other modifications happen in subsequent tasks."
```

---

## Task 5: Rewrite the LED index map for the 9×9-at-corners layout

**Files:**
- Modify: `firmware/src/engine/board_driver.h` — change `LED_COUNT`, `NUM_LED_ROWS`, `NUM_LED_COLS`
- Modify: `firmware/src/engine/board_driver.cpp` — rewrite `ledIndexMap` / `setSquareColor` / any chain-iteration
- Create: `firmware/test/test_led_mapping/test_main.cpp` — Unity unit tests

**Context:** joojoooo's firmware assumes 64 LEDs sitting under chess squares. This PCB has 81 LEDs at the **corners** of a 9×9 grid (D2 top-left, D82 bottom-right per project CLAUDE.md). Each chess square is bordered by 4 corner LEDs; lighting a square means lighting up to 4 LEDs.

This task is testable with pure logic (no hardware): given a board state, the mapping function returns the correct LED indices. Perfect for Unity native tests.

- [ ] **Step 1: Read `firmware/src/engine/board_driver.h` and `.cpp`**

Understand the existing API: what's the function that joojoooo's code calls to light up a square? It's probably `setSquareColor(file, rank, CRGB color)` or similar.

- [ ] **Step 2: Write the failing test for the LED index function**

Create `firmware/test/test_led_mapping/test_main.cpp`:

```cpp
#include <unity.h>
#include "engine/board_driver.h"

// File 0 = A, rank 0 = 1. Square A1 (bottom-left).
// In the 9x9 corner LED grid with D2 top-left, D82 bottom-right,
// rows go top-to-bottom (row 0 = rank 8 boundary, row 8 = rank 0 boundary),
// cols go left-to-right (col 0 = file A boundary, col 8 = file H boundary).
//
// Square at (file, rank) is bordered by corners at:
//   top-left:     (col=file,   row=8-rank-1)  = (file, 8-rank-1)
//   top-right:    (col=file+1, row=8-rank-1)
//   bottom-left:  (col=file,   row=8-rank)
//   bottom-right: (col=file+1, row=8-rank)
//
// LED index for a corner = row * 9 + col, then add 1 to skip D1 (BATT_LED)
// to get the actual D-reference number — BUT in the LED chain the index
// is 0-based starting at the first WS2812 in the chain.
//
// Per project CLAUDE.md: D1 is BATT_LED (separate). D2..D82 = chain index 0..80.
// So corner (row, col) → chain_index = row * 9 + col + 1 (the +1 is BATT_LED)
// — confirm this against board_driver.h's existing chain offset.

void test_a1_corners(void) {
    // A1 = file 0, rank 0.
    // Corners: (col=0, row=7) TL, (col=1, row=7) TR, (col=0, row=8) BL, (col=1, row=8) BR.
    // chain_index = row*9 + col + 1:
    //   TL = 7*9+0+1 = 64
    //   TR = 7*9+1+1 = 65
    //   BL = 8*9+0+1 = 73
    //   BR = 8*9+1+1 = 74
    uint8_t corners[4];
    int n = squareCornerLEDs(/*file=*/0, /*rank=*/0, corners);
    TEST_ASSERT_EQUAL(4, n);
    TEST_ASSERT_EQUAL(64, corners[0]); // TL
    TEST_ASSERT_EQUAL(65, corners[1]); // TR
    TEST_ASSERT_EQUAL(73, corners[2]); // BL
    TEST_ASSERT_EQUAL(74, corners[3]); // BR
}

void test_h8_corners(void) {
    // H8 = file 7, rank 7.
    // Corners: (col=7, row=0) TL, (col=8, row=0) TR, (col=7, row=1) BL, (col=8, row=1) BR.
    //   TL = 0*9+7+1 = 8
    //   TR = 0*9+8+1 = 9
    //   BL = 1*9+7+1 = 17
    //   BR = 1*9+8+1 = 18
    uint8_t corners[4];
    int n = squareCornerLEDs(/*file=*/7, /*rank=*/7, corners);
    TEST_ASSERT_EQUAL(4, n);
    TEST_ASSERT_EQUAL(8, corners[0]);
    TEST_ASSERT_EQUAL(9, corners[1]);
    TEST_ASSERT_EQUAL(17, corners[2]);
    TEST_ASSERT_EQUAL(18, corners[3]);
}

void test_center_square_d4_corners(void) {
    // D4 = file 3, rank 3.
    // Corners: (col=3, row=4), (col=4, row=4), (col=3, row=5), (col=4, row=5).
    //   TL = 4*9+3+1 = 40
    //   TR = 4*9+4+1 = 41
    //   BL = 5*9+3+1 = 49
    //   BR = 5*9+4+1 = 50
    uint8_t corners[4];
    int n = squareCornerLEDs(/*file=*/3, /*rank=*/3, corners);
    TEST_ASSERT_EQUAL(4, n);
    TEST_ASSERT_EQUAL(40, corners[0]);
    TEST_ASSERT_EQUAL(41, corners[1]);
    TEST_ASSERT_EQUAL(49, corners[2]);
    TEST_ASSERT_EQUAL(50, corners[3]);
}

void setUp(void) {}
void tearDown(void) {}

int main(int argc, char **argv) {
    UNITY_BEGIN();
    RUN_TEST(test_a1_corners);
    RUN_TEST(test_h8_corners);
    RUN_TEST(test_center_square_d4_corners);
    return UNITY_END();
}
```

- [ ] **Step 3: Run tests, expect FAIL (function not defined)**

```bash
cd firmware
pio test -e native
```

Expected: compilation failure — `squareCornerLEDs` not defined.

- [ ] **Step 4: Define `squareCornerLEDs` in `board_driver.h`**

```cpp
#ifndef BOARD_DRIVER_H
#define BOARD_DRIVER_H

#include <stdint.h>

#define LED_COUNT 81
#define NUM_LED_ROWS 9
#define NUM_LED_COLS 9

// Fills `out` with the 1-4 chain indices of the corner LEDs that border
// the chess square at (file, rank). file: 0=A..7=H, rank: 0=rank1..7=rank8.
// Returns the count written. Chain index 0 is D2 (first WS2812 after BATT_LED).
int squareCornerLEDs(uint8_t file, uint8_t rank, uint8_t* out);

// ... keep / port the rest of joojoooo's API surface here ...

#endif
```

- [ ] **Step 5: Implement `squareCornerLEDs` in `board_driver.cpp`**

```cpp
#include "board_driver.h"

int squareCornerLEDs(uint8_t file, uint8_t rank, uint8_t* out) {
    if (file > 7 || rank > 7) return 0;
    uint8_t row_top = 8 - rank - 1;
    uint8_t row_bot = 8 - rank;
    uint8_t col_l = file;
    uint8_t col_r = file + 1;
    out[0] = (uint8_t)(row_top * 9 + col_l + 1); // TL
    out[1] = (uint8_t)(row_top * 9 + col_r + 1); // TR
    out[2] = (uint8_t)(row_bot * 9 + col_l + 1); // BL
    out[3] = (uint8_t)(row_bot * 9 + col_r + 1); // BR
    return 4;
}
```

Note the `+ 1` accounts for D1 (BATT_LED) being chain index 0 — confirm against the schematic & the existing chain init code. If BATT_LED is NOT in the same chain (separate data line), drop the `+ 1`.

- [ ] **Step 6: Run tests, expect PASS**

```bash
pio test -e native
```

Expected: all 3 tests pass.

- [ ] **Step 7: Rewrite `setSquareColor` (or equivalent) to use `squareCornerLEDs`**

Replace whatever joojoooo's `setSquareColor` did with the corner-LED equivalent. Since each square now has up to 4 LEDs and adjacent squares share corner LEDs, decide on a blending rule (last-write-wins is simplest; weighted average is prettier). For v1, last-write-wins.

```cpp
void setSquareColor(uint8_t file, uint8_t rank, CRGB color) {
    uint8_t corners[4];
    int n = squareCornerLEDs(file, rank, corners);
    for (int i = 0; i < n; i++) {
        leds[corners[i]] = color;
    }
}
```

- [ ] **Step 8: Build the firmware (esp32dev env) to ensure the rewrite still links**

```bash
pio run -e esp32dev
```

Expected: PASS.

- [ ] **Step 9: Commit**

```bash
git add firmware/src/engine/board_driver.* firmware/test/test_led_mapping
git commit -m "firmware: rewrite LED index map for 9x9-at-corners layout

- LED_COUNT 64 -> 81, grid 8x8 -> 9x9
- squareCornerLEDs() maps (file, rank) -> up to 4 chain indices
- setSquareColor uses last-write-wins blending for shared corners
- Unity tests cover A1, H8, D4 corner mappings (run with pio test -e native)"
```

---

## Task 6: Define the WebSocket JSON-RPC protocol (shared types)

**Files:**
- Create: `firmware/src/shell/protocol.h`
- Create: `firmware/src/shell/protocol.cpp`
- Create: `firmware/test/test_protocol/test_main.cpp`
- Create: `web/lib/protocol.ts` (mirror — these MUST stay in sync)

**Context:** This is the contract between board and clients. Defining it explicitly (and testing the parse/serialize) prevents weeks of "why doesn't the UI update?" debugging. We define both ends now so changes happen in lockstep.

For the v1 protocol, three message types are enough:

| Type | Direction | Purpose |
|---|---|---|
| `ping` / `pong` | both | health check, latency |
| `set_led` | client → board | testing primitive: light one square |
| `board_state` | board → client | server-pushed: 64 squares' occupancy |

More message types will be added later (game.start, move, lichess.connect, etc.). This task ships the protocol *framework*, not the full surface.

- [ ] **Step 1: Write failing tests for protocol parsing**

Create `firmware/test/test_protocol/test_main.cpp`:

```cpp
#include <unity.h>
#include "shell/protocol.h"

void test_parse_ping(void) {
    const char* json = "{\"type\":\"ping\",\"id\":42}";
    ProtocolMessage msg;
    bool ok = parseMessage(json, msg);
    TEST_ASSERT_TRUE(ok);
    TEST_ASSERT_EQUAL(MsgType::Ping, msg.type);
    TEST_ASSERT_EQUAL(42, msg.id);
}

void test_parse_set_led(void) {
    const char* json = "{\"type\":\"set_led\",\"id\":7,\"file\":3,\"rank\":4,\"r\":255,\"g\":0,\"b\":128}";
    ProtocolMessage msg;
    bool ok = parseMessage(json, msg);
    TEST_ASSERT_TRUE(ok);
    TEST_ASSERT_EQUAL(MsgType::SetLed, msg.type);
    TEST_ASSERT_EQUAL(7, msg.id);
    TEST_ASSERT_EQUAL(3, msg.setLed.file);
    TEST_ASSERT_EQUAL(4, msg.setLed.rank);
    TEST_ASSERT_EQUAL(255, msg.setLed.r);
    TEST_ASSERT_EQUAL(0, msg.setLed.g);
    TEST_ASSERT_EQUAL(128, msg.setLed.b);
}

void test_parse_invalid_json(void) {
    const char* json = "not json";
    ProtocolMessage msg;
    bool ok = parseMessage(json, msg);
    TEST_ASSERT_FALSE(ok);
}

void test_parse_unknown_type(void) {
    const char* json = "{\"type\":\"bogus\",\"id\":1}";
    ProtocolMessage msg;
    bool ok = parseMessage(json, msg);
    TEST_ASSERT_FALSE(ok);
}

void test_serialize_pong_response(void) {
    char buf[128];
    serializePongResponse(42, buf, sizeof(buf));
    // Should produce {"type":"pong","id":42}
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"type\":\"pong\""));
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"id\":42"));
}

void test_serialize_board_state_event(void) {
    bool occupancy[64];
    for (int i = 0; i < 64; i++) occupancy[i] = (i < 32);
    char buf[512];
    serializeBoardStateEvent(occupancy, buf, sizeof(buf));
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"type\":\"board_state\""));
    // event has no id field
    TEST_ASSERT_NULL(strstr(buf, "\"id\""));
}

void setUp(void) {}
void tearDown(void) {}

int main(int argc, char **argv) {
    UNITY_BEGIN();
    RUN_TEST(test_parse_ping);
    RUN_TEST(test_parse_set_led);
    RUN_TEST(test_parse_invalid_json);
    RUN_TEST(test_parse_unknown_type);
    RUN_TEST(test_serialize_pong_response);
    RUN_TEST(test_serialize_board_state_event);
    return UNITY_END();
}
```

- [ ] **Step 2: Run tests, expect FAIL (header doesn't exist)**

```bash
pio test -e native -f test_protocol
```

- [ ] **Step 3: Define `protocol.h`**

```cpp
#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdint.h>
#include <stddef.h>

enum class MsgType {
    Unknown,
    Ping,
    SetLed,
};

struct SetLedPayload {
    uint8_t file;
    uint8_t rank;
    uint8_t r;
    uint8_t g;
    uint8_t b;
};

struct ProtocolMessage {
    MsgType type = MsgType::Unknown;
    uint32_t id = 0;
    union {
        SetLedPayload setLed;
    };
};

bool parseMessage(const char* json, ProtocolMessage& out);
size_t serializePongResponse(uint32_t id, char* buf, size_t buf_size);
size_t serializeBoardStateEvent(const bool occupancy[64], char* buf, size_t buf_size);

#endif
```

- [ ] **Step 4: Implement `protocol.cpp` using ArduinoJson**

```cpp
#include "protocol.h"
#include <ArduinoJson.h>
#include <string.h>

bool parseMessage(const char* json, ProtocolMessage& out) {
    JsonDocument doc;
    DeserializationError err = deserializeJson(doc, json);
    if (err) return false;

    const char* type = doc["type"];
    if (!type) return false;
    out.id = doc["id"] | 0;

    if (strcmp(type, "ping") == 0) {
        out.type = MsgType::Ping;
        return true;
    }
    if (strcmp(type, "set_led") == 0) {
        out.type = MsgType::SetLed;
        out.setLed.file = doc["file"] | 0;
        out.setLed.rank = doc["rank"] | 0;
        out.setLed.r = doc["r"] | 0;
        out.setLed.g = doc["g"] | 0;
        out.setLed.b = doc["b"] | 0;
        return true;
    }
    return false;
}

size_t serializePongResponse(uint32_t id, char* buf, size_t buf_size) {
    JsonDocument doc;
    doc["type"] = "pong";
    doc["id"] = id;
    return serializeJson(doc, buf, buf_size);
}

size_t serializeBoardStateEvent(const bool occupancy[64], char* buf, size_t buf_size) {
    JsonDocument doc;
    doc["type"] = "board_state";
    JsonArray arr = doc["squares"].to<JsonArray>();
    for (int i = 0; i < 64; i++) arr.add(occupancy[i]);
    return serializeJson(doc, buf, buf_size);
}
```

- [ ] **Step 5: Run tests, expect PASS**

```bash
pio test -e native -f test_protocol
```

- [ ] **Step 6: Mirror types in `web/lib/protocol.ts`** (file created in Task 8; reference forward — we write it in this task to enforce the contract)

Defer this step's code to Task 8 where `web/` exists. Note in `protocol.cpp` header comment: *"types mirrored in web/lib/protocol.ts; keep in sync."*

- [ ] **Step 7: Commit**

```bash
git add firmware/src/shell/protocol.* firmware/test/test_protocol
git commit -m "firmware: define v1 WebSocket JSON-RPC protocol

Three messages: ping/pong (health), set_led (client->board test),
board_state (board->client event). Parse/serialize covered by Unity
tests on native env. Types will be mirrored in web/lib/protocol.ts
when the web app is scaffolded (Task 8)."
```

---

## Task 7: Wire up the WebSocket server on the board

**Files:**
- Create: `firmware/src/shell/ws_server.h`
- Create: `firmware/src/shell/ws_server.cpp`
- Modify: `firmware/src/main.cpp`

**Context:** Pulls together protocol + engine + WiFi. The server accepts WS connections, parses messages, routes `set_led` into the engine's `setSquareColor`. Hardcoded WiFi creds for now — BLE provisioning comes in Phase B.

- [ ] **Step 1: Define `ws_server.h`**

```cpp
#ifndef WS_SERVER_H
#define WS_SERVER_H

void wsServerBegin(const char* ssid, const char* password);
void wsServerLoop();

#endif
```

- [ ] **Step 2: Implement `ws_server.cpp`**

```cpp
#include "ws_server.h"
#include "protocol.h"
#include "../engine/board_driver.h"
#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <FastLED.h>

static AsyncWebServer server(80);
static AsyncWebSocket ws("/ws");

extern CRGB leds[];  // defined in board_driver.cpp

static void onMessage(AsyncWebSocketClient* client, const char* data) {
    ProtocolMessage msg;
    if (!parseMessage(data, msg)) return;

    switch (msg.type) {
        case MsgType::Ping: {
            char buf[64];
            serializePongResponse(msg.id, buf, sizeof(buf));
            client->text(buf);
            break;
        }
        case MsgType::SetLed: {
            CRGB color(msg.setLed.r, msg.setLed.g, msg.setLed.b);
            setSquareColor(msg.setLed.file, msg.setLed.rank, color);
            FastLED.show();
            break;
        }
        default: break;
    }
}

static void onEvent(AsyncWebSocket* server, AsyncWebSocketClient* client,
                    AwsEventType type, void* arg, uint8_t* data, size_t len) {
    if (type == WS_EVT_DATA) {
        AwsFrameInfo* info = (AwsFrameInfo*)arg;
        if (info->opcode == WS_TEXT && info->final && info->index == 0 && info->len == len) {
            char buf[1024];
            size_t n = (len < sizeof(buf) - 1) ? len : sizeof(buf) - 1;
            memcpy(buf, data, n);
            buf[n] = 0;
            onMessage(client, buf);
        }
    }
}

void wsServerBegin(const char* ssid, const char* password) {
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi");
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println();
    Serial.print("Board IP: ");
    Serial.println(WiFi.localIP());

    ws.onEvent(onEvent);
    server.addHandler(&ws);
    server.begin();
}

void wsServerLoop() {
    ws.cleanupClients();
}
```

- [ ] **Step 3: Wire it into `main.cpp`**

```cpp
#include <Arduino.h>
#include "engine/board_driver.h"
#include "shell/ws_server.h"

// TEMP: hardcoded WiFi for development. Replace with BLE provisioning in Phase B.
const char* WIFI_SSID = "REPLACE_ME";
const char* WIFI_PASS = "REPLACE_ME";

void setup() {
    Serial.begin(115200);
    board_driver_init();
    wsServerBegin(WIFI_SSID, WIFI_PASS);
}

void loop() {
    wsServerLoop();
    delay(10);
}
```

- [ ] **Step 4: Build**

```bash
pio run -e esp32dev
```

Expected: PASS.

- [ ] **Step 5: Flash to a dev board** (any ESP32 dev kit is fine — no chess hardware needed)

```bash
pio run -e esp32dev -t upload
pio device monitor --baud 115200
```

Expected: serial shows "Connecting to WiFi" → "Board IP: x.x.x.x".

- [ ] **Step 6: Smoke-test with a CLI WebSocket client**

```bash
brew install websocat 2>/dev/null || true
websocat ws://<board-ip>/ws
> {"type":"ping","id":1}
< {"type":"pong","id":1}
```

Expected: pong reply. If you have an LED on the dev board (almost all do), try `{"type":"set_led","id":2,"file":0,"rank":0,"r":255,"g":0,"b":0}` — the corner LEDs of A1 should light up. (May not be visible if no WS2812 wired to the dev board; verify by `FastLED.show()` not crashing and serial output.)

- [ ] **Step 7: Commit**

```bash
git add firmware/src/shell/ws_server.* firmware/src/main.cpp
git commit -m "firmware: wire up WebSocket server with protocol + engine

- WS endpoint at /ws, handles ping and set_led messages
- WiFi creds hardcoded (TEMP, replaced by BLE provisioning in Phase B)
- Smoke-tested over websocat against a dev board"
```

---

## Task 8: Scaffold the Next.js web UI

**Files:**
- Create: `web/package.json` (via `create-next-app`)
- Create: `web/next.config.mjs`
- Create: `web/app/page.tsx`
- Create: `web/lib/protocol.ts`
- Create: `web/lib/ws-client.ts`
- Create: `web/components/BoardView.tsx`

**Context:** Static-export Next.js. The dev server runs locally and connects to the dev-board's WebSocket. The production build (`next build && next export`) produces a static bundle that will be embedded into firmware in Task 9.

- [ ] **Step 1: Scaffold a Next.js app**

```bash
cd /Users/paolonessim/Projects/openchess
npx create-next-app@latest web --typescript --tailwind --app --src-dir=false --import-alias='@/*' --eslint --no-turbopack
```

Decline any optional prompts. Accept defaults otherwise.

- [ ] **Step 2: Configure static export**

Edit `web/next.config.mjs`:

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: { unoptimized: true },
  trailingSlash: true,
};

export default nextConfig;
```

- [ ] **Step 3: Mirror the protocol types from firmware**

Create `web/lib/protocol.ts`:

```typescript
// Types mirrored from firmware/src/shell/protocol.h — keep in sync.

export type PingMessage = { type: 'ping'; id: number };
export type PongMessage = { type: 'pong'; id: number };
export type SetLedMessage = {
  type: 'set_led';
  id: number;
  file: number;  // 0-7 (A-H)
  rank: number;  // 0-7 (1-8)
  r: number;     // 0-255
  g: number;
  b: number;
};
export type BoardStateEvent = {
  type: 'board_state';
  squares: boolean[];  // length 64, true = occupied
};

export type ClientMessage = PingMessage | SetLedMessage;
export type ServerMessage = PongMessage | BoardStateEvent;
```

- [ ] **Step 4: Build a thin WebSocket client wrapper**

Create `web/lib/ws-client.ts`:

```typescript
import type { ClientMessage, ServerMessage } from './protocol';

export class BoardClient {
  private ws: WebSocket | null = null;
  private nextId = 1;
  private pending = new Map<number, (msg: ServerMessage) => void>();
  private listeners = new Set<(msg: ServerMessage) => void>();

  connect(url: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.ws = new WebSocket(url);
      this.ws.onopen = () => resolve();
      this.ws.onerror = (e) => reject(e);
      this.ws.onmessage = (e) => {
        const msg = JSON.parse(e.data) as ServerMessage;
        if ('id' in msg && this.pending.has(msg.id)) {
          this.pending.get(msg.id)!(msg);
          this.pending.delete(msg.id);
        }
        this.listeners.forEach((l) => l(msg));
      };
    });
  }

  send(msg: Omit<ClientMessage, 'id'>): Promise<ServerMessage> {
    if (!this.ws) throw new Error('not connected');
    const id = this.nextId++;
    return new Promise((resolve) => {
      this.pending.set(id, resolve);
      this.ws!.send(JSON.stringify({ ...msg, id }));
    });
  }

  on(listener: (msg: ServerMessage) => void): () => void {
    this.listeners.add(listener);
    return () => this.listeners.delete(listener);
  }
}
```

- [ ] **Step 5: Build a minimal board page**

Replace `web/app/page.tsx`:

```typescript
'use client';

import { useEffect, useState } from 'react';
import { BoardClient } from '@/lib/ws-client';
import BoardView from '@/components/BoardView';

export default function Home() {
  const [client, setClient] = useState<BoardClient | null>(null);
  const [boardIp, setBoardIp] = useState('192.168.1.100');
  const [connected, setConnected] = useState(false);

  async function connect() {
    const c = new BoardClient();
    await c.connect(`ws://${boardIp}/ws`);
    setClient(c);
    setConnected(true);
  }

  return (
    <main className="p-8">
      <h1 className="text-2xl font-bold">OpenChess</h1>
      {!connected ? (
        <div className="mt-4">
          <input
            className="border p-2"
            value={boardIp}
            onChange={(e) => setBoardIp(e.target.value)}
          />
          <button className="ml-2 p-2 bg-black text-white" onClick={connect}>
            Connect
          </button>
        </div>
      ) : (
        <BoardView client={client!} />
      )}
    </main>
  );
}
```

- [ ] **Step 6: Build the board view**

Create `web/components/BoardView.tsx`:

```typescript
'use client';

import { BoardClient } from '@/lib/ws-client';

export default function BoardView({ client }: { client: BoardClient }) {
  const files = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  const ranks = [8, 7, 6, 5, 4, 3, 2, 1];

  function clickSquare(file: number, rank: number) {
    client.send({
      type: 'set_led',
      file,
      rank,
      r: 255,
      g: 0,
      b: 0,
    });
  }

  return (
    <div className="mt-8 grid grid-cols-8 w-[400px] h-[400px]">
      {ranks.map((rank, ri) =>
        files.map((file, fi) => {
          const dark = (ri + fi) % 2 === 1;
          return (
            <button
              key={`${file}${rank}`}
              className={dark ? 'bg-gray-700' : 'bg-gray-200'}
              onClick={() => clickSquare(fi, rank - 1)}
            >
              {file}{rank}
            </button>
          );
        }),
      )}
    </div>
  );
}
```

- [ ] **Step 7: Run the dev server**

```bash
cd web
npm run dev
```

Open `http://localhost:3000`, enter the board IP, click a square. Expect a red light to flash on the corresponding LED on the dev board (if a WS2812 strip is connected) and at minimum the websocat-equivalent message to be sent.

- [ ] **Step 8: Verify static export works**

```bash
npm run build
ls out/
```

Expected: a static export in `web/out/` containing `index.html` + assets. This is what gets embedded into firmware in Task 9.

- [ ] **Step 9: Commit**

```bash
cd /Users/paolonessim/Projects/openchess
git add web
git commit -m "web: scaffold Next.js UI with WebSocket client

- Static export (output: 'export') configured for embedding in firmware
- Protocol types mirrored from firmware/src/shell/protocol.h
- Minimal 8x8 board page; clicking a square sends set_led to the board
- Dev server connects to a manually-entered board IP for now"
```

---

## Task 9: Embed the web bundle into firmware

**Files:**
- Modify: `firmware/platformio.ini` — add LittleFS partition + data upload config
- Modify: `firmware/partitions.csv` — reserve SPIFFS/LittleFS region
- Modify: `firmware/src/shell/ws_server.cpp` — serve static files from LittleFS
- Create: `firmware/scripts/embed_web.sh` — copies `web/out/` → `firmware/data/`

**Context:** The web UI lives on the board so it works offline. ESP32 stores it in LittleFS (a flash filesystem). PlatformIO ships tooling for this.

- [ ] **Step 1: Update `partitions.csv`** to reserve a LittleFS region (~1.5 MB)

Inspect the current `partitions.csv` first (`cat firmware/partitions.csv`). Adjust to include something like:

```
# Name,   Type, SubType, Offset,  Size,    Flags
nvs,      data, nvs,     0x9000,  0x5000,
otadata,  data, ota,     0xe000,  0x2000,
app0,     app,  ota_0,   0x10000, 0x1E0000,
app1,     app,  ota_1,   0x1F0000,0x1E0000,
spiffs,   data, spiffs,  0x3D0000,0x30000,
```

Adjust sizes based on the current Next.js bundle size (`du -sh web/out`). Goal: enough headroom for the bundle + future growth.

- [ ] **Step 2: Add LittleFS to `platformio.ini`**

```ini
[env:esp32dev]
...
board_build.filesystem = littlefs
```

- [ ] **Step 3: Write the embed script**

Create `firmware/scripts/embed_web.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WEB_OUT="$ROOT/web/out"
FW_DATA="$ROOT/firmware/data"

if [ ! -d "$WEB_OUT" ]; then
    echo "web/out/ not found — run 'npm run build' in web/ first"
    exit 1
fi

rm -rf "$FW_DATA"
mkdir -p "$FW_DATA"
cp -r "$WEB_OUT"/* "$FW_DATA"/

echo "Copied $(find "$FW_DATA" -type f | wc -l) files to firmware/data/"
du -sh "$FW_DATA"
```

```bash
chmod +x firmware/scripts/embed_web.sh
```

- [ ] **Step 4: Add static-file serving to the firmware**

Extend `wsServerBegin` in `ws_server.cpp`:

```cpp
#include <LittleFS.h>

void wsServerBegin(const char* ssid, const char* password) {
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) { delay(500); }
    Serial.print("Board IP: "); Serial.println(WiFi.localIP());

    if (!LittleFS.begin()) {
        Serial.println("LittleFS mount failed");
        return;
    }
    server.serveStatic("/", LittleFS, "/").setDefaultFile("index.html");

    ws.onEvent(onEvent);
    server.addHandler(&ws);
    server.begin();
}
```

- [ ] **Step 5: Build the web bundle, embed, flash**

```bash
cd web && npm run build && cd ..
./firmware/scripts/embed_web.sh
cd firmware
pio run -e esp32dev -t buildfs
pio run -e esp32dev -t uploadfs
pio run -e esp32dev -t upload
```

- [ ] **Step 6: Open the board's IP in a browser**

`http://<board-ip>/` should show the Next.js UI. Click a square. Expect the LED to light (or at least the WebSocket message to go through).

- [ ] **Step 7: Commit**

```bash
git add firmware/platformio.ini firmware/partitions.csv firmware/scripts firmware/src/shell/ws_server.cpp
git add -f firmware/data/.gitkeep
echo "firmware/data/*" > firmware/.gitignore
echo "!firmware/data/.gitkeep" >> firmware/.gitignore
git add firmware/.gitignore
git commit -m "firmware: embed Next.js static bundle via LittleFS

- partitions.csv reserves SPIFFS region for web bundle
- scripts/embed_web.sh copies web/out/ -> firmware/data/
- WS server serves / from LittleFS, /ws for the WebSocket API
- firmware/data/ is gitignored (build artifact)"
```

---

## Task 10: End-to-end smoke test + update STATUS

**Files:**
- Modify: `STATUS.md` (at repo root)

**Context:** This is the "are we done with Phase A?" gate. The user (on a phone or laptop browser) opens the board's IP, clicks a square, an LED lights up. Plus an honest write-up of what's done and what's deferred to Phase B.

- [ ] **Step 1: Run through the full flow manually**

1. Power on dev board (which has the firmware + LittleFS bundle from Task 9).
2. From a phone on the same WiFi, open `http://<board-ip>/` in Safari/Chrome.
3. Click squares on the 8×8 board view.
4. Observe LED activity (visible only if a WS2812 strip is wired up — otherwise verify via serial monitor that `set_led` messages arrive).

- [ ] **Step 2: Update STATUS.md** at repo root with what landed and what's next

Read it first to understand the format, then append a Phase A section. Be honest about what's not done:
- BLE provisioning: not started, Phase B
- mDNS: not started, manual IP entry for now
- React Native app: scaffolded only
- Real hardware (matrix scan, full 81 LEDs): cannot verify until PCB exists

- [ ] **Step 3: Commit**

```bash
git add STATUS.md
git commit -m "status: Phase A firmware complete

End-to-end working: phone -> Next.js UI on board (LittleFS) -> WS API
-> engine -> LED on dev board. Phase B (BLE provisioning, mDNS, RN app,
real-PCB validation) blocked on hardware fab."
```

---

## What's deliberately NOT in this plan

These are real work, but scoping them out keeps Phase A shippable:

- **BLE provisioning** — requires NimBLE-Arduino, custom GATT services, pairing UX, error recovery. Whole separate plan.
- **mDNS discovery** — small task, but only valuable once the app exists. Add in Phase B.
- **React Native app** — scaffolded only. Build out once the board protocol is proven and stable.
- **Full Lichess + Stockfish integration** — the engine files are lifted, but wiring them into the protocol (game.start, move, etc.) is its own task series after the foundation is solid.
- **Real PCB validation** — matrix scan, 81-LED chain, hall sensor debounce all require the real hardware. Cannot test on a dev board.
- **OTA via the new API** — joojoooo's OTA module is lifted, but exposing it through the WebSocket protocol (or a dedicated `/ota` POST) is a separate task.
- **Auth / pairing tokens on the WebSocket** — currently anyone on the LAN can connect. Acceptable for v1 + home WiFi; address in Phase B alongside BLE pairing (which produces the natural token).

---

## Self-review check

**Spec coverage:** 
- ✅ Keep core engine, rebuild shell → Tasks 1-4 (audit, lift, structure)
- ✅ LED driver rewrite for 9×9 → Task 5
- ✅ Pure WebSocket protocol → Tasks 6-7
- ✅ Next.js web UI served from board → Tasks 8-9
- ⏸ BLE provisioning → explicitly deferred to Phase B (documented)
- ⏸ mDNS → explicitly deferred
- ⏸ React Native app → explicitly deferred (stub directory in Task 3)

**Placeholder scan:** no TBDs. Each step has concrete code or an exact command. The "if upstream build fails" branch in Task 1 is appropriately conditional rather than vague.

**Type consistency:** `squareCornerLEDs`, `setSquareColor`, `parseMessage`, `serializePongResponse`, `serializeBoardStateEvent`, `wsServerBegin`, `wsServerLoop`, `BoardClient` — all consistent across the tasks where they appear.

One known-uncertain spot: the `+ 1` offset in `squareCornerLEDs` for BATT_LED's chain position depends on whether BATT_LED is on the same WS2812 chain or separate. Task 5 step 5 flags this explicitly so the implementer verifies against the schematic.
