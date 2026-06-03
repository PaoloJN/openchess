# Workspace Guide

How to work on this project efficiently: which Claude Code sessions to keep open, what external tools, and the KiCad shortcuts you'll use most.

## Recommended sessions

Open one terminal per session, name the tab so you don't mix them up.

| Session | cwd | Purpose | When to open |
|---|---|---|---|
| **PCB** | `~/Projects/openchess/` | KiCad work — schematic, PCB layout, scripts | Always (active) |
| **Planning** | `~/Projects/openchess/` | Brainstorming, doc updates, "should I X or Y" | Always (chatty) |
| **Firmware** | `~/Projects/openchess/firmware/` | Adapting joojoooo's code, PlatformIO builds, ESP32 flashing | After PCB is ordered |
| **Mechanical** | `~/Projects/openchess/mechanical/` | Wooden case + 3D-printed pieces | After PCB arrives |
| **Build** | `~/Projects/openchess/` | Physical assembly debugging | When soldering the fabbed board |

**Rule:** end of each session, briefly update `STATUS.md` so the others (and your future self) know what happened.

## External tools to keep open

| Tool | What for | When |
|---|---|---|
| **KiCad PCB Editor** | Layout, routing, DRC | Active during PCB phase |
| **KiCad Schematic Editor** | Schematic edits | Same |
| **Freerouting** (KiCad plugin) | Autorouting most signals | When ready to route |
| **PlatformIO** (CLI or VS Code) | Firmware builds + ESP32 flash | Firmware phase |
| **A web browser** | Lichess API docs, joojoooo's docs site, JLCPCB upload | As needed |
| **kicad-cli** (CLI) | Gerber export, headless ops | Used by `scripts/export_gerbers.py` |

## Project-specific slash commands

These are defined in `.claude/commands/` and only work in sessions opened from this project directory.

| Command | Does |
|---|---|
| `/backup` | Creates timestamped master backup of all design files in `.backups/master/` |
| `/restore [timestamp]` | Restores design files from a master backup (lists available if no arg) |
| `/run-script <name>` | Safely runs a script from `hardware/scripts/` (checks KiCad closed, creates backup, validates output) |
| `/sync-gpio` | Verifies ESP32 pin assignments match across CLAUDE.md, gpio-map.md, schematic, and firmware |
| `/status` | Shows current STATUS.md + recently-modified files + available backups |

## Project-specific agents

Defined in `.claude/agents/`.

| Agent | Use when |
|---|---|
| `pcb-reviewer` | After a PCB script run or significant manual layout. Catches file syntax issues, missing footprints, position sanity, GPIO drift. **Read-only**, doesn't modify anything. Use with the `Agent` tool. |

## Useful global skills (already installed)

Available in any session, not project-specific:

| Skill | When |
|---|---|
| `simplify` | Review changed code for quality issues |
| `superpowers:systematic-debugging` | When the board (or firmware) doesn't behave as expected |
| `superpowers:writing-plans` | Before starting a multi-step task |
| `superpowers:verification-before-completion` | Before claiming any phase done |
| `obsidian-markdown` | If you take design notes in Obsidian |
| `Plan` (agent) | Designing implementation plans for complex changes |
| `Explore` (agent) | Finding things across the codebase |

## KiCad keyboard shortcuts (most-used)

### Schematic editor
| Key | Action |
|---|---|
| `A` | Add symbol |
| `P` | Add power port (+5V, +3V3, GND) |
| `L` | Add label (local net name) |
| `H` | Add hierarchical label (for sub-sheets) |
| `W` | Draw wire |
| `R` | Rotate selected |
| `Y` / `X` | Mirror vertical / horizontal |
| `M` | Move (preserves connections) |
| `G` | Drag (moves + keeps wires connected) |
| `E` | Edit properties |
| `Q` | Add no-connect flag |
| `I` | Repeat last item (auto-increments labels like CA → CB) |
| `Cmd+F` | Find component by reference |
| `Esc` | Cancel current action |

### PCB editor
| Key | Action |
|---|---|
| `M` | Move (without re-routing) |
| `G` | Drag (with re-routing) |
| `R` | Rotate |
| `F` | Flip to other side |
| `B` | Fill all zones (refresh copper pours) |
| `X` | Start routing trace |
| `D` | Drag track |
| `Y` | Rectangle draw (on current layer) |
| `Home` | Zoom to fit board |
| `Cmd+F` | Find component |

### Cross-editor
| Key | Action |
|---|---|
| `Cmd+S` | Save |
| `Cmd+Z` | Undo |
| `Cmd+C` / `Cmd+V` | Copy / paste |
| `+` / `-` | Zoom in / out |
| `Esc` | Cancel current action |

## Common workflows

### Re-run grid placement after changing board size
1. Edit `hardware/scripts/grid_placement.py` — change `SQUARE_SIZE` or `BOARD_MARGIN`
2. **Close KiCad** (otherwise the script will be overwritten on save)
3. From the PCB session: `/run-script grid_placement`
4. Open KiCad, verify

### Make a master backup before something risky
1. `/backup` — creates `.backups/master/*.<timestamp>` files
2. Note the timestamp in your head (or `/status` to see it later)
3. If things go wrong: `/restore <timestamp>`

### Update GPIO pin assignment
1. Edit `docs/gpio-map.md` (source of truth)
2. Edit the schematic to match (relabel ESP32 pins in KiCad)
3. Once firmware exists, edit `firmware/src/board_driver.h` to match
4. `/sync-gpio` to verify all three agree

### Get the PCB ready for fab
1. Manual layout + Freerouting + manual cleanup
2. Run KiCad's DRC (Tools → Run DRC)
3. Use `pcb-reviewer` agent for second-pair-of-eyes review
4. `/run-script export_gerbers`
5. Upload zip from `hardware/fab/` to JLCPCB

## Don't do these

- Don't run two scripts that modify the PCB file concurrently (race condition on the file)
- Don't open KiCad and run a script at the same time (lock conflict)
- Don't edit the `references/` clones — they're upstream code we just read from
- Don't put one-off thoughts in `CLAUDE.md` — it's for durable context. Use `STATUS.md` or chat for transient stuff.

## Reference projects (read-only clones in `references/`)

- **`references/chessboard-v1-omercier/`** — Olivier Mercier's original v1 design with reed switches and the LED matrix. Useful for: SVG schematic, CAD files, the proven Lichess client code. Has its own `CLAUDE.md` if you want to spin up a session focused on it.
- **`references/openchess-joojoooo/`** — joojoooo's firmware foundation. The basis for our `firmware/` once we fork it. Look at `src/board_driver.h` for the hardware abstraction we'll adapt.
