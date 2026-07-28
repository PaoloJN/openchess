# Controller v2 (Integrated ESP32 + Battery) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the DevKitC + Lipo Rider Plus daughterboards with a single self-contained controller PCB: soldered ESP32-WROOM-32E, USB-C flashing/charging, power-path charger, always-on 5V boost, split XH panel connectors — per the approved spec `docs/superpowers/specs/2026-07-27-controller-v2-integrated-design.md`.

**Architecture:** New KiCad project `hardware/hardware-controller-v2/` copied from v1 so the proven v1 project stays intact. Proven blocks (74AHCT125, TBD62783A, pullups, J1 pinout) carry over unchanged; DevKitC and Lipo Rider are replaced by on-board reference-design blocks. Schematic work is done by Paolo in the KiCad GUI following exact net-by-net instructions; every task is verified with `kicad-cli` ERC + netlist checks before commit.

**Tech Stack:** KiCad 9 (`/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli`), JLCPCB SMT assembly, PlatformIO (`firmware/`), Espressif DevKitC v4 reference schematic, TI BQ24074 + TPS61022 datasheets.

## Global Constraints

- v1 project `hardware/hardware-controller/` is NEVER modified (boards physically exist). All hardware work happens in `hardware/hardware-controller-v2/`.
- J1 matrix connector: 2x13, `PinSocket_2x13_P2.54mm_Vertical`, pinout **identical to v1** — existing matrix board must plug in unchanged.
- Proven blocks copied unchanged from v1: 74AHCT125 (U3) level shifter + 33Ω series R11, TBD62783A (U6) column driver, row pullups R1–R8 (10k), button pullups R36/R37 (10k), battery divider R14/R15 (220k/100k).
- All ESP32 signals are 3.3V. The 74AHCT125 stays (WS2812B VIH = 0.7×5V = 3.5V > 3.3V).
- New circuit blocks copy published reference designs verbatim (DevKitC v4 schematic; BQ24074 and TPS61022 datasheet typical applications). No invented circuits.
- Prefer JLCPCB **Basic** parts; Extended parts allowed where necessary (each Extended part adds a one-time feed fee).
- Antenna zone of the WROOM module: copper keepout on ALL layers, module antenna overhangs the board edge.
- Git: repo has unrelated dirty files — every commit stages ONLY the files named in its task (`git add <explicit paths>`).
- Commit messages end with: `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`
- `kicad-cli` is not on PATH; use the absolute path or `alias kc=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli`.

## Reference: v2 GPIO Map (used by Tasks 3, 4, 8, 9)

Design rules that produced this map: GPIO1/3 reserved for UART0↔USB-serial (debug + flashing); GPIO0 reserved for BOOT button; strapping pins carry only boot-safe signals (GPIO5/15 may idle HIGH → row sense; GPIO12 must NOT idle high and GPIO2 must not be pulled high externally → column drives, which idle low; GPIO2 keeps BTN_SELECT with internal-only pullup exactly as proven in v1); I2C lands on GPIO21/22, the ESP32 Arduino `Wire` defaults.

| Signal | v1 GPIO | v2 GPIO | WROOM-32E pin | Notes |
|---|---:|---:|---:|---|
| `LED_DATA` | 32 | **32** | 8 (IO32) | unchanged |
| `S0` | 4 | **16** | 27 (IO16) | row sense, ext 10k pullup R1 |
| `S1` | 16 | **17** | 28 (IO17) | R2 |
| `S2` | 17 | **18** | 30 (IO18) | R3 |
| `S3` | 18 | **19** | 31 (IO19) | R4 |
| `S4` | 19 | **23** | 37 (IO23) | R5 |
| `S5` | 21 | **5** | 29 (IO5) | strapping; idles HIGH = boot-safe; R6 |
| `S6` | 22 | **15** | 23 (IO15) | strapping; idles HIGH = boot-safe; R7 |
| `S7` | 23 | **35** | 7 (IO35) | input-only; ext pullup R8 (required — no internal pullup) |
| `COL_DRV_A` | 13 | **13** | 16 (IO13) | unchanged |
| `COL_DRV_B` | 14 | **14** | 13 (IO14) | unchanged |
| `COL_DRV_C` | 27 | **27** | 12 (IO27) | unchanged |
| `COL_DRV_D` | 26 | **26** | 11 (IO26) | unchanged |
| `COL_DRV_E` | 25 | **25** | 10 (IO25) | unchanged |
| `COL_DRV_F` | 33 | **33** | 9 (IO33) | unchanged |
| `COL_DRV_G` | 5 | **4** | 26 (IO4) | off strapping pin |
| `COL_DRV_H` | 15 | **12** | 14 (IO12) | strapping but idles LOW (driver input) = boot-safe |
| `I2C_SDA` | 1 | **21** | 33 (IO21) | Arduino Wire default |
| `I2C_SCL` | 3 | **22** | 36 (IO22) | Arduino Wire default |
| `BTN_SELECT` | 2 | **2** | 24 (IO2) | internal pullup only (NO external pullup — would break USB download mode) |
| `BTN_POWER` | 36 | **36** | 4 (SENSOR_VP) | ext pullup R36 |
| `BTN_MODE` | 39 | **39** | 5 (SENSOR_VN) | ext pullup R37 |
| `VBAT_MON` | 34 | **34** | 6 (IO34) | ADC1_CH6, divider R14/R15 |
| `PANEL_SPARE` | 35 | — | — | retired (GPIO35 now S7) |
| UART0 TX | — | **1** | 35 (TXD0) | to USB-serial RXD |
| UART0 RX | — | **3** | 34 (RXD0) | to USB-serial TXD |
| BOOT | — | **0** | 25 (IO0) | BOOT button + auto-program transistor |
| EN | — | — | 3 (EN) | 10k pullup + 1µF to GND + EN button + auto-program transistor |

WROOM-32E pins not listed: 1/15/38 GND + thermal pad 39 GND, 2 = 3V3, 17–22 (SD2/SD3/CMD/CLK/SD0/SD1 — internal flash, leave unconnected), 32 (NC).

## Reference: v2 power chain (used by Tasks 2, 7, 11, 12)

```
USB-C VBUS ──► BQ24074 IN          BQ24074 BAT ◄──► JST-PH ── 1S protected LiPo
              BQ24074 OUT (SYS) ──► TPS61022 boost ──► +5V_LED rail
                                         │                ├─► J1 (matrix LEDs)
              slide switch ──► boost EN  │                ├─► 74AHCT125 VCC
                                         │                └─► AMS1117-3.3 ──► +3.3V rail
```

Power switch drives the boost **EN pin** (signal-level, no load current through the switch). Switch OFF = 5V and 3.3V rails dead = board off, while the charger still charges the battery — phone-like charge-while-off. Battery standby drain is the BQ24074's µA-level quiescent only.

---

### Task 1: Scaffold the v2 KiCad project

**Files:**
- Create: `hardware/hardware-controller-v2/` (copied from `hardware/hardware-controller/`)
- Create: `hardware/hardware-controller-v2/README.md`

**Interfaces:**
- Produces: a v2 project that opens in KiCad, passes baseline ERC at v1 parity, named `openchess-controller-v2`. All later tasks edit only this directory.

- [ ] **Step 1: Adopt Paolo's copy, drop v1-only build artifacts**

Paolo already created `hardware/hardware-controller-v2/` as a copy of v1 and
has it open in KiCad (lock files present). Do NOT rename the KiCad files —
the directory name distinguishes v2; renaming under an open session breaks
it. Just remove stale v1 artifacts:

```bash
cd /Users/paolonessim/Projects/openchess/hardware/hardware-controller-v2
rm -f openchess-board-3x3.step openchess-controller.step .DS_Store
```

Leave `.history/` and `~*.lck` files on disk but do not commit them.

- [ ] **Step 2: Confirm the project loads standalone**

Paolo confirms in his open KiCad session: schematic and PCB both open, and
Tools → Update PCB from Schematic reports no missing-file errors.

- [ ] **Step 3: Baseline ERC — record v1 parity**

```bash
kc=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
$kc sch erc openchess-controller.kicad_sch --output /tmp/erc-baseline.rpt --exit-code-violations; echo "exit=$?"
cat /tmp/erc-baseline.rpt
```

Expected: same violation count as v1 (run the same command against `../hardware-controller/openchess-controller.kicad_sch` to compare). This is the baseline; Task 9 requires zero.

- [ ] **Step 4: Write `README.md`**

```markdown
# hardware-controller-v2

Integrated controller: soldered ESP32-WROOM-32E + USB-C (CH340C) + BQ24074
power-path charger + TPS61022 5V boost + AMS1117-3.3. Replaces the v1
DevKitC + Lipo Rider Plus daughterboards.

- Spec: `docs/superpowers/specs/2026-07-27-controller-v2-integrated-design.md`
- Plan: `docs/superpowers/plans/2026-07-27-controller-v2-integrated.md`
- GPIO map: `docs/gpio-map.md` (v2 table)
- Part sourcing + design values: `SOURCING.md`

v1 (`../hardware-controller/`) is frozen — boards exist physically.
```

- [ ] **Step 5: Commit**

```bash
cd /Users/paolonessim/Projects/openchess
git add hardware/hardware-controller-v2
git commit -m "feat(hw): scaffold controller v2 KiCad project from v1"
```

---

### Task 2: Part sourcing and power design values → SOURCING.md

**Files:**
- Create: `hardware/hardware-controller-v2/SOURCING.md`

**Interfaces:**
- Produces: confirmed LCSC part numbers, Basic/Extended status, stock, and computed resistor/capacitor values for every new component. Tasks 5–8 and 10 read exact values from this file and must not re-derive them.

- [ ] **Step 1: Verify candidate parts on jlcpcb.com/parts (web search each MPN)**

For each row: confirm the LCSC number, Basic vs Extended, in-stock quantity, and unit price. Candidates (MPN is the search key; LCSC numbers below must be re-verified, not trusted):

| Block | Candidate MPN | Package | Fallback if unavailable |
|---|---|---|---|
| MCU module | ESP32-WROOM-32E-N4 | SMD module | ESP32-WROOM-32E-N8 |
| USB-serial | CH340C | SOP-16 | CP2102N-A01-GQFN28 |
| USB-C receptacle | TYPE-C-31-M-12 (16-pin, USB2.0) | SMD+TH | any 16-pin USB-C with CC1/CC2 |
| USB ESD | USBLC6-2SC6 | SOT-23-6 | omit (optional) |
| Charger | BQ24074RGTR | VQFN-16 | MCP73871-2CCI/ML |
| Boost 5V ≥3A | TPS61022RWUR | VQFN-7 | FP6277XR-G1, or SY7208 class |
| LDO 3.3V ≥800mA | AMS1117-3.3 | SOT-223 | fed from 5V rail, dropout OK |
| Auto-program transistors | S8050 (J3Y) ×2 | SOT-23 | SS8050, MMBT2222 |
| Boost inductor | per TPS61022 datasheet (≈1µH, Isat > 6A) | — | pick from JLC Basic inductors |
| Buttons EN/BOOT | TS-1187A or similar SMD tactile ×2 | SMD | any Basic 2-pin/4-pin tactile |
| Charge LED + R | 0603 LED + 1k | 0603 | any Basic |
| Slide switch | MSK-12C02 | SMD/TH | hand-solder acceptable |
| PWR LED + R | 0603 LED + 1k | 0603 | any Basic |
| Battery conn | B2B-XH-A (JST XH 2-pin) | TH | right-angle S2B-XH-A |
| Panel conns | B4B-XH-A + B5B-XH-A (JST XH) | TH | hand-solder acceptable |
| Column driver (SMD upgrade) | TBD62783AFG,EL (SOP-18) | SOP-18 | keep v1 DIP-18 TBD62783APG hand-soldered |

- [ ] **Step 2: Extract design values from the BQ24074 datasheet (TI, current revision)**

Record in SOURCING.md with the datasheet formula shown:
- R_ISET for charge current ≈ 1.0A (0.5C for a 2000mAh cell)
- R_ILIM for input current limit ≈ 1.5A
- TS pin network (10k NTC in the pack, or the datasheet's fixed-resistor disable network if the pack has no thermistor — record which)
- TMR pin treatment, EN1/EN2 strapping for the chosen input-limit mode
- CHG̅ open-drain wiring to the charge LED (LED + 1k from 5V… note: from IN/SYS, per datasheet)

- [ ] **Step 3: Extract design values from the TPS61022 datasheet**

Record: FB divider for 5.0V out, inductor value and required saturation current, input/output capacitor values (bulk + ceramic), EN pin logic threshold (confirm a 3.3–4.2V battery-level signal through the slide switch from SYS is valid high).

- [ ] **Step 4: Write SOURCING.md**

One table per block: chosen part, LCSC #, Basic/Extended, price, stock on the check date, plus a "Design values" section with every computed R/C/L value and the formula used. Mark any part that had to fall back, and any that must be hand-soldered.

- [ ] **Step 5: Commit**

```bash
git add hardware/hardware-controller-v2/SOURCING.md
git commit -m "docs(hw): controller v2 part sourcing and power design values"
```

---

### Task 3: Update GPIO map and connector docs (the wiring contract)

**Files:**
- Modify: `docs/gpio-map.md`
- Modify: `docs/inter-board-connector.md`

**Interfaces:**
- Produces: the authoritative v2 net⇄pin contract. Schematic Tasks 5–9 wire exactly what these docs say; firmware Task 4 encodes the same table.

- [ ] **Step 1: Rewrite `docs/gpio-map.md`**

Keep the v1 table under a clearly-labeled "v1 (DevKitC, frozen)" heading. Add a "v2 (hardware-controller-v2, current)" section containing the full v2 GPIO table from this plan's "Reference: v2 GPIO Map", the design rules paragraph above it, and the WROOM-32E physical pin column. Update the "Gotchas" section: GPIO1/3 now UART0 (serial debug works with OLED attached); strapping-pin analysis per the reference table; GPIO34–39 input-only note stays.

- [ ] **Step 2: Update `docs/inter-board-connector.md`**

J1/matrix section: unchanged (state explicitly "identical v1 ⇄ v2"). Replace the J3 XH-10 panel section with:

```markdown
## J_OLED — JST-XH 4-pin (controller ⇄ panel OLED)

| Pin | Net | Matches SSD1306 module order |
|---|---|---|
| 1 | GND | GND |
| 2 | +3.3V | VCC |
| 3 | I2C_SCL | SCL |
| 4 | I2C_SDA | SDA |

Straight-through cable; I2C pullups live on the OLED module (as in v1 — the
controller adds none).

## J_BTN — JST-XH 5-pin (controller ⇄ panel buttons)

| Pin | Net | Note |
|---|---|---|
| 1 | GND | common for all buttons |
| 2 | BTN_POWER | GPIO36, ext pullup R36 |
| 3 | BTN_MODE | GPIO39, ext pullup R37 |
| 4 | BTN_SELECT | GPIO2, internal pullup only |
| 5 | (spare) | not connected, reserved |

Buttons short their signal to GND. The v1 J3 XH-10 harness is retired;
re-crimp the panel harness into these two cables.
```

- [ ] **Step 3: Verify consistency**

Cross-check every GPIO number in both docs against the plan's reference table (there must be no pin that appears with two different assignments in the v2 sections).

- [ ] **Step 4: Commit**

```bash
git add docs/gpio-map.md docs/inter-board-connector.md
git commit -m "docs: v2 GPIO map and split panel connectors (J_OLED/J_BTN)"
```

---

### Task 4: Firmware v2 pin map behind a build flag

**Files:**
- Modify: `firmware/src/pins.h`
- Modify: `firmware/platformio.ini`

**Interfaces:**
- Consumes: v2 GPIO table (Task 3 / plan reference).
- Produces: `OPENCHESS_HW_V2` build flag selecting the v2 map; env `esp32dev_v2` (and `bench_*` still target v1 by default). All existing pin-constant names (`PIN_LED_DATA`, `PIN_COL_DRV[8]`, `PIN_ROW_SENSE[8]`, `PIN_I2C_SDA/SCL`, `PIN_BTN_*`, `PIN_VBAT_MON`) keep their names and types.

- [ ] **Step 1: Restructure `pins.h`** — wrap the existing v1 constants in `#ifndef OPENCHESS_HW_V2 … #else … #endif` and add the v2 block:

```c
#else  // ── v2 hardware (hardware-controller-v2, integrated WROOM-32E) ──

#define PIN_LED_DATA       32

static const int PIN_COL_DRV[8] = {
    13, 14, 27, 26, 25, 33,  // A..F unchanged
     4,  // G  GPIO4  (was 5)
    12,  // H  GPIO12 (was 15; idles low via driver input = boot-safe)
};

static const int PIN_ROW_SENSE[8] = {
    16, 17, 18, 19, 23,      // S0..S4
     5,  // S5 (strapping, idles high = boot-safe)
    15,  // S6 (strapping, idles high = boot-safe)
    35,  // S7 (input-only, ext pullup R8)
};

// I2C on Arduino Wire defaults — serial debug now coexists with the OLED.
#define PIN_I2C_SDA        21
#define PIN_I2C_SCL        22

#define PIN_BTN_POWER      36
#define PIN_BTN_MODE       39
#define PIN_BTN_SELECT      2
#define PIN_VBAT_MON       34

#endif
```

(Drop `PIN_PANEL_SPARE` from the v2 block only; v1 block keeps it.)

- [ ] **Step 2: Add the v2 env to `platformio.ini`** (after `[env:esp32dev]`):

```ini
[env:esp32dev_v2]
extends = env:esp32dev
build_flags =
    -DCORE_DEBUG_LEVEL=3
    -DOPENCHESS_HW_V2
```

- [ ] **Step 3: Build both envs — both must compile**

```bash
cd /Users/paolonessim/Projects/openchess/firmware
pio run -e esp32dev && pio run -e esp32dev_v2
```

Expected: SUCCESS twice. (Grep first that no source file hardcodes GPIO 1/3/5/15 outside `pins.h`: `grep -rn "GPIO_NUM_\|Wire.begin(" src/ | grep -v pins.h` — any hit that bypasses `pins.h` must be switched to the `PIN_*` constant as part of this task.)

- [ ] **Step 4: Commit**

```bash
git add firmware/src/pins.h firmware/platformio.ini
git commit -m "feat(fw): v2 pin map behind OPENCHESS_HW_V2 build flag"
```

---

### Task 5: Schematic — remove daughterboards, place the WROOM-32E core

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (KiCad GUI)

**Interfaces:**
- Consumes: v2 GPIO reference table.
- Produces: `U2` = ESP32-WROOM-32E with EN circuit and buttons; nets `+3.3V`, `EN`, `IO0`; old `U2` (DevKitC), `M1` (Lipo Rider), `D2` (SS14) gone.

- [ ] **Step 1 (GUI): Delete v1 daughterboard symbols** — delete `U2` (ESP32-DevKitC), `M1` (Lipo Rider Plus pin socket), `D2` (SS14). Leave dangling labels in place for now (Task 9 rewires; ERC is allowed to be dirty until then).

- [ ] **Step 2 (GUI): Place the module core** — add symbol `RF_Module:ESP32-WROOM-32E` as new `U2`. Wire:
  - Pin 2 (3V3) → `+3.3V`; pins 1, 15, 38 + pad 39 → `GND`
  - 100nF + 10µF from 3V3 to GND adjacent to the module (new C13, C14)
  - Pin 3 (EN): 10k pullup to `+3.3V` (new R20), 1µF to GND (new C15), tactile button `SW_EN` to GND
  - Pin 25 (IO0): tactile button `SW_BOOT` to GND, net label `IO0`
  - Pins 17–22 (SD0–SD3/CMD/CLK): leave unconnected, add no-connect flags; pin 32 NC flag

- [ ] **Step 3: Verify by netlist**

```bash
kc=/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli
cd /Users/paolonessim/Projects/openchess/hardware/hardware-controller-v2
$kc sch export netlist openchess-controller.kicad_sch --output /tmp/v2.net
grep -c "ESP32-WROOM-32E" /tmp/v2.net      # expected: >= 1
grep -c "DevKitC\|Lipo Rider" /tmp/v2.net  # expected: 0
python3 - <<'EOF'
import re
net = open('/tmp/v2.net').read()
for want_net, want_node in [("+3.3V", '(ref "U2")'), ("GND", '(ref "U2")')]:
    blocks = re.findall(r'\(net \(code "\d+"\) \(name "([^"]+)"\)(.*?)(?=\(net |\Z)', net, re.S)
    ok = any(n == want_net and want_node in body for n, body in blocks)
    print(want_net, "OK" if ok else "MISSING")
EOF
```

Expected: both `OK`.

- [ ] **Step 4: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch
git commit -m "feat(hw): v2 sch — WROOM-32E core replaces DevKitC/Lipo Rider"
```

---

### Task 6: Schematic — USB-C + CH340C + auto-program

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (KiCad GUI)

**Interfaces:**
- Consumes: nets `EN`, `IO0`, `GND`, `+3.3V` (Task 5); part values from `SOURCING.md`.
- Produces: nets `VBUS` (5V from USB), `USB_DP`, `USB_DM`; flashing circuit identical in behavior to DevKitC v4.

- [ ] **Step 1 (GUI): USB-C receptacle `J4`** (16-pin USB2 type): both VBUS pins → net `VBUS`; both CC pins → one 5.1k each to GND (R21, R22); D+/D− pairs (each signal appears on two pins — tie the A/B pairs together) → `USB_DP`/`USB_DM`; shield + GND pins → `GND`. Optional per SOURCING.md: USBLC6-2SC6 across `USB_DP`/`USB_DM`/`VBUS`.

- [ ] **Step 2 (GUI): CH340C `U7`** (no crystal needed): VCC → `VBUS` with 100nF (C16); V3 pin → 100nF to GND (CH340C at 5V supply: V3 gets only the capacitor); UD+ → `USB_DP`, UD− → `USB_DM`; TXD → net `U0RXD` → U2 pin 34 (RXD0/GPIO3); RXD → net `U0TXD` → U2 pin 35 (TXD0/GPIO1).

- [ ] **Step 3 (GUI): Auto-program (copy DevKitC v4 exactly)** — two S8050 NPN (Q1, Q2), two 10k (R23, R24):
  - Q1: base ← 10k ← CH340C DTR̅; collector → `EN`; emitter → CH340C RTS̅
  - Q2: base ← 10k ← CH340C RTS̅; collector → `IO0`; emitter → CH340C DTR̅

- [ ] **Step 4: Verify by netlist**

```bash
$kc sch export netlist openchess-controller.kicad_sch --output /tmp/v2.net
python3 - <<'EOF'
import re
net = open('/tmp/v2.net').read()
blocks = dict(re.findall(r'\(net \(code "\d+"\) \(name "([^"]+)"\)(.*?)(?=\(net |\Z)', net, re.S))
checks = {
  "VBUS":  ['(ref "J4")', '(ref "U7")'],
  "/USB_DP": ['(ref "J4")', '(ref "U7")'],
  "/USB_DM": ['(ref "J4")', '(ref "U7")'],
  "/U0TXD": ['(ref "U2")', '(ref "U7")'],
  "/U0RXD": ['(ref "U2")', '(ref "U7")'],
  "/EN":   ['(ref "Q1")'],
  "/IO0":  ['(ref "Q2")'],
}
for name, wants in checks.items():
    body = next((b for n,b in blocks.items() if n.lstrip('/')==name.lstrip('/')), "")
    print(name, all(w in body for w in wants) and "OK" or "FAIL")
EOF
```

Expected: all `OK` (net-name prefixes may differ by sheet — adjust the lstrip match, not the expectation).

- [ ] **Step 5: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch
git commit -m "feat(hw): v2 sch — USB-C, CH340C, DevKitC-style auto-program"
```

---

### Task 7: Schematic — charger, boost, LDO, switch, battery

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (KiCad GUI)

**Interfaces:**
- Consumes: `VBUS` (Task 6), design values from `SOURCING.md` §Design values.
- Produces: nets `VSYS`, `+5V_LED`, `+3.3V`, `VBAT`; charge LED; power switch on boost EN.

- [ ] **Step 1 (GUI): BQ24074 `U8`** per its datasheet typical application, using the exact R values recorded in SOURCING.md: IN ← `VBUS` (+ input cap); OUT → `VSYS` (+ output cap); BAT ↔ `VBAT` ↔ JST-XH 2-pin `J5` pin 1 (pin 2 → GND); ISET/ILIM/TS/TMR/EN1/EN2 per SOURCING.md; CHG̅ → charge LED `D3` + 1k `R25` from `VBUS`.

- [ ] **Step 2 (GUI): Battery divider stays** — confirm R14 (220k) from `VBAT` to `VBAT_MON` node, R15 (100k) to GND (carried over from v1; only the source net name may need updating to `VBAT`).

- [ ] **Step 3 (GUI): TPS61022 boost `U9`** per datasheet typical application with SOURCING.md values: VIN ← `VSYS`; SW ↔ inductor `L1`; VOUT → `+5V_LED`; FB divider per SOURCING.md; input/output caps per SOURCING.md; EN ← slide switch `SW1`: switch common → `VSYS`, switch ON position → U9 EN (+ 100k pulldown R26 from EN to GND so OFF = defined low).

- [ ] **Step 4 (GUI): LDO `U10` AMS1117-3.3**: IN ← `+5V_LED` (+ 10µF C17), OUT → `+3.3V` (+ 10µF C18), GND → GND. Add PWR LED `D4` + 1k `R27` from `+3.3V` to GND (lit = board on). Confirm the v1 rail consumers (74AHCT125 VCC is `+5V_LED`; row pullups and button pullups on `+3.3V`) still reference the same net names.

- [ ] **Step 5: Verify by netlist** — same pattern as Task 6:

Checks: `VBUS`→{U8}, `VSYS`→{U8, U9, SW1}, `VBAT`→{U8, J5, R14}, `+5V_LED`→{U9, U10, U3}, `+3.3V`→{U10, U2}. All `OK` expected.

- [ ] **Step 6: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch
git commit -m "feat(hw): v2 sch — BQ24074 power path, TPS61022 boost, LDO, switch"
```

---

### Task 8: Schematic — split panel connectors J_OLED / J_BTN

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (KiCad GUI)

**Interfaces:**
- Consumes: connector contract from `docs/inter-board-connector.md` (Task 3).
- Produces: `J6` (J_OLED, XH-4) and `J7` (J_BTN, XH-5); old `J3` gone.

- [ ] **Step 1 (GUI):** Delete `J3` (XH-10). Place `Connector_Generic:Conn_01x04` as `J6` "J_OLED": 1→`GND`, 2→`+3.3V`, 3→`I2C_SCL`, 4→`I2C_SDA`. Place `Conn_01x05` as `J7` "J_BTN": 1→`GND`, 2→`BTN_POWER`, 3→`BTN_MODE`, 4→`BTN_SELECT`, 5→no-connect flag.

- [ ] **Step 2: Verify by netlist** — `J3` absent; `I2C_SDA`/`I2C_SCL` each contain J6 and U2; `BTN_*` contain J7; `BTN_POWER`/`BTN_MODE` also contain R36/R37; `BTN_SELECT` contains **no** resistor.

- [ ] **Step 3: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch
git commit -m "feat(hw): v2 sch — split panel into J_OLED (XH-4) and J_BTN (XH-5)"
```

---

### Task 9: Schematic — GPIO rewire to the v2 map + ERC to zero

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (KiCad GUI)
- Create: `hardware/hardware-controller-v2/scripts/check_v2_nets.py`

**Interfaces:**
- Consumes: every net created in Tasks 5–8; v2 GPIO reference table.
- Produces: fully wired schematic, **zero ERC violations**, and a rerunnable contract checker used again after any later schematic edit.

- [ ] **Step 1 (GUI): Attach every signal net to its v2 WROOM pin** per the reference table: `LED_DATA`→IO32, `S0..S7`→{IO16,IO17,IO18,IO19,IO23,IO5,IO15,IO35}, `COL_DRV_A..H`→{IO13,IO14,IO27,IO26,IO25,IO33,IO4,IO12}, `I2C_SDA`→IO21, `I2C_SCL`→IO22, `BTN_SELECT`→IO2, `BTN_POWER`→SENSOR_VP, `BTN_MODE`→SENSOR_VN, `VBAT_MON`→IO34. Resolve every dangling label left from Task 5.

- [ ] **Step 2: Write `scripts/check_v2_nets.py`** — the full contract in code:

```python
#!/usr/bin/env python3
"""Verify openchess-controller-v2 netlist against the v2 GPIO/connector contract."""
import re, subprocess, sys, pathlib
KC = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"
SCH = pathlib.Path(__file__).resolve().parents[1] / "openchess-controller.kicad_sch"
NET = "/tmp/v2-contract.net"
subprocess.run([KC, "sch", "export", "netlist", str(SCH), "--output", NET], check=True)
net = open(NET).read()
blocks = {n.lstrip('/'): b for n, b in
          re.findall(r'\(net \(code "\d+"\) \(name "([^"]+)"\)(.*?)(?=\(net |\Z)', net, re.S)}
# WROOM-32E physical pin per signal (U2), plus required companions on the net.
CONTRACT = {
    "LED_DATA":  [('U2', '8')],
    "S0": [('U2','27'),('R1',None)], "S1": [('U2','28'),('R2',None)],
    "S2": [('U2','30'),('R3',None)], "S3": [('U2','31'),('R4',None)],
    "S4": [('U2','37'),('R5',None)], "S5": [('U2','29'),('R6',None)],
    "S6": [('U2','23'),('R7',None)], "S7": [('U2','7'),('R8',None)],
    "COL_DRV_A": [('U2','16')], "COL_DRV_B": [('U2','13')],
    "COL_DRV_C": [('U2','12')], "COL_DRV_D": [('U2','11')],
    "COL_DRV_E": [('U2','10')], "COL_DRV_F": [('U2','9')],
    "COL_DRV_G": [('U2','26')], "COL_DRV_H": [('U2','14')],
    "I2C_SDA": [('U2','33'),('J6',None)], "I2C_SCL": [('U2','36'),('J6',None)],
    "BTN_SELECT": [('U2','24'),('J7',None)],
    "BTN_POWER": [('U2','4'),('J7',None),('R36',None)],
    "BTN_MODE":  [('U2','5'),('J7',None),('R37',None)],
    "VBAT_MON":  [('U2','6'),('R14',None),('R15',None)],
}
fail = 0
for name, nodes in CONTRACT.items():
    body = blocks.get(name, "")
    for ref, pin in nodes:
        pat = f'(ref "{ref}")' if pin is None else f'(ref "{ref}")\n\t\t\t\t(pin "{pin}")'
        flat = body.replace('\n', '').replace('\t', '')
        pat_flat = pat.replace('\n', '').replace('\t', '')
        if pat_flat not in flat:
            print(f"FAIL {name}: missing {ref}" + (f" pin {pin}" if pin else "")); fail += 1
print("ALL OK" if not fail else f"{fail} failures"); sys.exit(1 if fail else 0)
```

(If the netlist s-expression formatting differs, fix the script's pattern matching — not the contract table.)

- [ ] **Step 3: Run the contract check**

```bash
python3 hardware/hardware-controller-v2/scripts/check_v2_nets.py
```

Expected: `ALL OK`.

- [ ] **Step 4: ERC to zero**

```bash
$kc sch erc openchess-controller.kicad_sch --output /tmp/erc-v2.rpt --exit-code-violations; echo "exit=$?"
```

Expected: `exit=0`. Fix every violation in the GUI (typical: missing PWR_FLAG on `VBUS`/`VBAT`, unconnected NC pins needing flags), rerun until clean, and rerun Step 3 after any fix.

- [ ] **Step 5: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch \
        hardware/hardware-controller-v2/scripts/check_v2_nets.py
git commit -m "feat(hw): v2 sch — full GPIO rewire, net contract checker, ERC clean"
```

---

### Task 10: Footprints and JLC fields

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_sch` (GUI: symbol fields)

**Interfaces:**
- Consumes: `SOURCING.md` (Task 2).
- Produces: every symbol has a footprint and an `LCSC` field; BOM export is machine-usable by the fabrication toolkit (same field convention as v1 — check one carried-over v1 symbol, e.g. U3, and match it).

- [ ] **Step 1 (GUI):** Assign footprints for all new symbols (module, CH340C SOP-16, USB-C, VQFN parts, SOT-223, SOT-23, inductor, connectors: J6 `JST_XH_B4B-XH-A`, J7 `JST_XH_B5B-XH-A`, J5 `JST_XH_B2B-XH-A`). If SOURCING.md selected the SOP-18 TBD62783AFG, change U6's footprint to SOIC/SOP-18 and add its LCSC field; otherwise leave DIP-18.

- [ ] **Step 2 (GUI):** Fill `LCSC` field on every assembled part from SOURCING.md. Hand-solder parts (switch, XH/PH connectors if through-hole, J1) get no LCSC field but keep footprints.

- [ ] **Step 3: Verify** — export BOM and check no assembled part is missing an LCSC number:

```bash
$kc sch export bom openchess-controller.kicad_sch --output /tmp/v2-bom.csv \
  --fields "Reference,Value,Footprint,LCSC"
grep -v "LCSC" /tmp/v2-bom.csv | head -30   # eyeball: only hand-solder refs may have empty last column
```

- [ ] **Step 4: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_sch
git commit -m "feat(hw): v2 footprints and LCSC assembly fields"
```

---

### Task 11: PCB — outline, placement, keepouts

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_pcb` (KiCad GUI)

**Interfaces:**
- Consumes: complete schematic (Task 9), footprints (Task 10).
- Produces: placed board with locked placement rules; passes DRC courtyard/edge checks (routing not yet done).

- [ ] **Step 1 (GUI): Update PCB from schematic**, delete stale v1 footprints the update flags as removed (DevKitC pin headers, Lipo Rider socket, J3, SS14).

- [ ] **Step 2 (GUI): Board outline** — start from v1's 58×71mm; grow only if placement demands. Keep M3 mounting holes and fiducials.

- [ ] **Step 3 (GUI): Placement, in this priority order** (each rule is a hard constraint):
  1. `U2` WROOM: antenna end overhangs a board edge; rule-area keepout (all copper layers) under the antenna zone per the module datasheet drawing.
  2. `J4` USB-C on a board edge reachable in the case; `U7` CH340C adjacent, D+/D− run short.
  3. Boost `U9` + `L1` + input/output caps: tight cluster, caps immediately at the IC pins, copying the TPS61022 datasheet layout example. Same for `U8` charger caps.
  4. `J5` battery + `SW1` switch near the board edge for case access; `D3` charge LED visible.
  5. `J1` stays where the case/matrix cable expects it (compare v1 position); `U3`/`U6` near `J1`.
  6. `J6`/`J7` grouped on the panel-harness edge.

- [ ] **Step 4: DRC (pre-routing sanity)**

```bash
$kc pcb drc openchess-controller.kicad_pcb --output /tmp/drc-place.rpt
grep -i "courtyard\|edge" /tmp/drc-place.rpt
```

Expected: no courtyard overlaps, no edge-clearance violations (unrouted-net errors are expected and fine at this stage).

- [ ] **Step 5: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_pcb
git commit -m "feat(hw): v2 pcb — outline, placement, antenna keepout"
```

---

### Task 12: PCB — routing + DRC to zero

**Files:**
- Modify: `hardware/hardware-controller-v2/openchess-controller.kicad_pcb` (KiCad GUI)

**Interfaces:**
- Consumes: placed board (Task 11).
- Produces: fully routed board, zero DRC violations, GND pour both sides.

- [ ] **Step 1 (GUI): Route in this order:**
  1. Boost power loop (VSYS → L1 → SW → VOUT caps → GND back): shortest, widest (≥1.5mm), top layer only, no vias in the hot loop.
  2. Charger: VBUS → U8 → VSYS and U8 → J5 battery: ≥1mm width.
  3. `+5V_LED` to J1 and U3, `+3.3V` distribution: ≥0.8mm.
  4. USB D+/D− as a coupled pair, short, no layer change if possible.
  5. All signals (matrix, I2C, buttons, UART): 0.25mm default.
  6. GND pour top+bottom, via-stitch around the boost and under the module (NOT in the antenna keepout).

- [ ] **Step 2: DRC to zero**

```bash
$kc pcb drc openchess-controller.kicad_pcb --output /tmp/drc-final.rpt --exit-code-violations; echo "exit=$?"
```

Expected: `exit=0`. Fix and rerun until clean.

- [ ] **Step 3: Re-run the net contract** (schematic unchanged, but confirms no accidental sch edits during layout):

```bash
python3 hardware/hardware-controller-v2/scripts/check_v2_nets.py
```

Expected: `ALL OK`.

- [ ] **Step 4: Commit**

```bash
git add hardware/hardware-controller-v2/openchess-controller.kicad_pcb
git commit -m "feat(hw): v2 pcb — routed, DRC clean"
```

---

### Task 13: Fabrication outputs + JLC DFM check

**Files:**
- Create: `hardware/hardware-controller-v2/production/` (gerbers, BOM, CPL)

**Interfaces:**
- Consumes: routed board (Task 12), LCSC fields (Task 10).
- Produces: upload-ready JLC order package.

- [ ] **Step 1: Generate outputs with the Fabrication Toolkit** (same plugin/config as v1 — `fabrication-toolkit-options.json` was copied in Task 1) from the KiCad PCB editor, or fall back to `kicad-cli pcb export gerbers` + `kicad-cli pcb export drill` + the Task 10 BOM export.

- [ ] **Step 2: Cross-check the BOM** — every LCSC number in the generated BOM appears in `SOURCING.md` with matching MPN; component count matches the schematic reference count (compare against `grep -c` on the netlist refs).

- [ ] **Step 3 (Paolo, browser): JLC DFM** — upload gerbers to jlcpcb.com, run the DFM analysis, walk the assembly preview: rotations of U2/U7/U8/U9 correct, polarity of D3 and diodes correct. Record any DFM warnings; fix in KiCad and regenerate if any are errors.

- [ ] **Step 4: Commit**

```bash
git add hardware/hardware-controller-v2/production
git commit -m "feat(hw): v2 fabrication outputs (gerbers, BOM, CPL)"
```

---

### Task 14: Docs wrap-up

**Files:**
- Modify: `STATUS.md`
- Modify: `CLAUDE.md` (Current Hardware Sources + Current Hardware Facts)
- Modify: `hardware/hardware-controller-v2/README.md` (only if facts drifted during implementation)

**Interfaces:**
- Consumes: as-built state of everything above.
- Produces: repo docs that match reality.

- [ ] **Step 1:** `STATUS.md` — add controller v2 phase: designed, order-ready/ordered; next action = bring-up per spec verification plan (power rails → USB flash → panel → matrix).

- [ ] **Step 2:** `CLAUDE.md` — add `hardware-controller-v2` KiCad files to Current Hardware Sources; update Current Hardware Facts (WROOM-32E + CH340C + BQ24074 + TPS61022 + AMS1117; J_OLED XH-4 + J_BTN XH-5 replace J3 on v2; v1 controller frozen). Update the UART0 gotcha: fixed on v2 (I2C on 21/22).

- [ ] **Step 3:** Verify no doc still claims v2 uses GPIO1/3 for I2C: `grep -rn "GPIO1\|GPIO 1" docs/ CLAUDE.md STATUS.md | grep -i i2c` — any hit must be inside a clearly-v1-labeled section.

- [ ] **Step 4: Commit**

```bash
git add STATUS.md CLAUDE.md hardware/hardware-controller-v2/README.md
git commit -m "docs: controller v2 status and hardware facts"
```
