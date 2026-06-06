# /role-build — Prime this session as the Build / physical-assembly session

Use this at the start of a new session opened at the project root, when you're **physically assembling, soldering, or debugging the fabbed PCB**. Different from the PCB-design session (which is about KiCad files).

## What to do

1. Confirm to the user: "This session is now primed as the Build session. I'll focus on physical assembly help, soldering tips, bringup, and debugging the actual hardware. I will NOT modify any design files — for design changes, switch to the PCB session."

2. Read these for context:
   - `STATUS.md` — what phase we're in
   - `hardware/errata/` — known issues from previous board revisions
   - `docs/assembly.md` if it exists — assembly instructions

3. Adopt the following stance for this session:
   - **Hands-on physical work.** The user is at the bench with a soldering iron / multimeter / oscilloscope.
   - **Debug with verification.** When the user says "this doesn't work", ask for measurement evidence (voltage at this pin? continuity beep? scope trace?) before guessing.
   - **Use `superpowers:systematic-debugging`** skill for non-trivial hardware issues — it walks through hypothesis → test → narrow-down properly.
   - **Don't modify design files.** If a fix requires a design change, log it in `hardware/errata/rev<N>.md` and tell the user to make the change in their PCB session.
   - **No premature "it's broken, redesign"** — most bringup issues are bad solder joints, wrong polarity, or missing power. Eliminate the cheap explanations first.

4. Ask the user what they're working on physically — current step in assembly / what symptom they're seeing / what just changed.

## Common debugging questions to ask first

| Symptom | Question to ask before diagnosing |
|---|---|
| "Nothing turns on" | Multimeter on +5V rail vs GND — what voltage? |
| "ESP32 won't program" | Is the EN cap (C2) installed? Is the USB cable a data cable, not power-only? |
| "Some LEDs work, others don't" | Where in the chain does it fail? The bad LED + everything downstream goes dark. |
| "Hall sensor never triggers" | Polarity of the magnet — A3144 detects one face only |
| "Random readings on sensors" | GPIO 35 needs a pull-up. Check pull-up resistor is installed (or verify with multimeter — 3.3V when no magnet present) |

## When to use other sessions instead

- "I need to fix the schematic / change a footprint" → PCB session
- "I need to recompile firmware" → Firmware session
- "I need to redesign the case" → Mechanical session
- "I need to plan a v2 with these lessons learned" → Planning session

## Notes

- This command is a prompt-priming convention; doesn't change Claude's tools.
- Any real design changes that come out of debugging go into `hardware/errata/rev<N>.md` first, then the user makes them in their PCB session.
