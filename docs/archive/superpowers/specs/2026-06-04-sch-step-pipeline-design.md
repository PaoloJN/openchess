---
date: 2026-06-04
status: approved
supersedes: hardware-2.0/hardware-board/scripts/sch_gen.py
---

# Matrix-board schematic generator — step pipeline

## Why

The current monolithic `sch_gen.py` rewrites `openchess-board.kicad_sch`
(2,700 elements, ~300 KB) from scratch in one pass. A bug in any section
corrupts the whole file — there is no per-section trust boundary. "One
bug nukes the whole file" was the pain Paolo called out, and that
diagnosis drives the redesign.

## Architecture

Per-step generators emit s-expression *chunks* to disk. A separate
assembler concatenates them into the final `.kicad_sch`. Each step
script auto-runs the assembler at the end, so the `.kicad_sch` always
reflects "everything generated so far" — open in KiCad to verify
cumulative state before moving on.

```
01_skeleton.py    → build/sch/01_skeleton.sexp    # page, title, lib_symbols, decoration
02_halls.py       → build/sch/02_halls.sexp       # 64 A3144 + label stubs
03_leds.py        → build/sch/03_leds.sexp        # 81 WS2812B + 81 caps
04_pullups.py     → build/sch/04_pullups.sexp     # 8x R1..R8
05_bulks.py       → build/sch/05_bulks.sexp       # 9x C1..C9
06_j_ctrl.py      → build/sch/06_j_ctrl.sexp      # J1 2x13 + 26 labels
07_batt_led.py    → build/sch/07_batt_led.sexp    # BATT_LED1
08_pwrflags.py    → build/sch/08_pwrflags.sexp    # 5x PWR_FLAG
                       │
99_assemble.py  ───────┴──→ openchess-board.kicad_sch
```

**Trust boundary = the chunk file.** A bug in `02_halls.py` overwrites
only `build/sch/02_halls.sexp`. Other chunks on disk stay trusted. You
can `diff` a chunk against its last-known-good copy before assembling.

## File layout

```
hardware-2.0/hardware-board/
├── scripts/
│   ├── sch/                         # NEW
│   │   ├── _lib.py                  # shared: emit_*, uid, grid math,
│   │   │                            #         component positions, constants,
│   │   │                            #         A3144 symbol def, assemble()
│   │   ├── 01_skeleton.py
│   │   ├── 02_halls.py
│   │   ├── 03_leds.py
│   │   ├── 04_pullups.py
│   │   ├── 05_bulks.py
│   │   ├── 06_j_ctrl.py
│   │   ├── 07_batt_led.py
│   │   ├── 08_pwrflags.py
│   │   └── 99_assemble.py
│   ├── pcb/                         # existing PCB scripts
│   └── archived/
│       └── sch_gen_monolithic.py    # was sch_gen.py
├── build/sch/                       # NEW, gitignored
│   ├── 01_skeleton.sexp
│   └── …
└── openchess-board.kicad_sch        # final output (committed)
```

## Chunk format

Each chunk is raw s-expression text representing top-level elements
that live inside a `(kicad_sch …)` wrapper — `(symbol …)`, `(wire …)`,
`(label …)`, `(rectangle …)`, `(text …)`, etc. A chunk does NOT include
the outer wrapper or the `(sheet_instances …)` footer.

Chunk 01 (`01_skeleton.sexp`) carries the header content that must come
first: `(version …)`, `(generator …)`, `(uuid …)`, `(paper "A2")`,
`(title_block …)`, `(lib_symbols …)`. Chunks 02–08 carry symbol
instances, wires, labels, decoration. The assembler wraps everything
in `(kicad_sch … )` and appends `(sheet_instances …)`.

## Idempotency

- Re-running step N overwrites only `build/sch/NN_*.sexp` and re-runs
  the assembler. Other chunks untouched.
- Each step writes `<chunk>.backup_before_<step>` of its own previous
  chunk before overwriting.
- Assembler writes
  `openchess-board.kicad_sch.backup_before_assemble` before overwriting
  the final file.

## UUID scheme

Each step uses a unique 4-hex-char prefix (carrying forward `PFX_HALL`,
`PFX_LED`, `PFX_LED_CAP`, `PFX_BULK_CAP`, `PFX_PULLUP`, `PFX_BATT_LED`,
`PFX_JCTRL`, `PFX_PWRFLAG`, `PFX_DECOR` from the monolithic script).

Chunks reference each other only via *net labels* (`+5V`, `CA_PWR`,
`S0`, etc.) — no UUID coupling across step boundaries. This is already
how the monolithic script works; the pipeline inherits the property.

## Bugs to fix during migration

- **`gen_jctrl` CD/CE swap** — current code has pin 12 = `CD_PWR` and
  pin 24 = `CE_PWR`. `docs/inter-board-connector.md` says pin 12 =
  `CE_PWR` and pin 24 = `CD_PWR`. Fixed in `06_j_ctrl.py`.
- **J1 ref label overlaps box body text** — ref at `y=312.42`, box body
  text at `y=310`. Move J1 ref further. Fixed in `06_j_ctrl.py`.
- Additional bugs surfaced by code review land here as they're found.

## Out of scope

- LED-chain wiring (serpentine D1→…→D81). User does this in KiCad GUI.
- J1 pin fan-out wiring. User does this; labels already sit at each pin.
- Automated ERC. User runs `Tools → ERC` in KiCad GUI.
- Controller board (`hardware-controller/`). Same pattern applied later.

## Verification flow (per step)

1. `python3 scripts/sch/NN_<name>.py`
2. Close KiCad if open
3. Open `openchess-board.kicad_pro`
4. Inspect the section that step adds; check positions, labels, body text
5. If good → run next step
6. If not → edit step script, rerun (only its chunk + assembler regenerate)
