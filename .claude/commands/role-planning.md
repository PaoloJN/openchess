# /role-planning — Prime this session as the Planning session

Use this at the start of a new session opened at the project root, when you intend it to be the **Planning** session (brainstorming, design decisions, doc updates) rather than the **Build** session.

## What to do

1. Confirm to the user: "This session is now primed as the Planning session. I'll focus on cross-cutting decisions, doc updates, and brainstorming. For hands-on KiCad work, hardware/CLAUDE.md is loaded when you cd into hardware/. Same for firmware/ and mechanical/."

2. Read the current state:
   - `STATUS.md` — current phase + open questions
   - `WORKSPACE.md` — session organization
   - Recent design decisions in `docs/design-decisions.md`

3. Adopt the following stance for this session:
   - **Prefer asking over assuming.** Open questions are the input; decisions are the output.
   - **Don't run scripts that modify design files.** Hand those off to the PCB or Firmware session.
   - **Always update docs** when a decision lands. Don't just discuss → forget.
   - **Use other sessions for execution.** When the user agrees on a plan, suggest they switch sessions to execute (e.g., "ok, that's settled — switch to your PCB session and make the change there").

4. After loading, give the user a 1-paragraph "where we are" summary based on STATUS.md so they can dive right in.

## When to use the other sessions instead

- "I want to actually run a script" → PCB session (cd into hardware/)
- "I want to write firmware code" → Firmware session (cd into firmware/)
- "I want to design the case" → Mechanical session (cd into mechanical/)
- "I'm physically assembling the board and it's not working" → Build session (use `/role-build` instead)

## Notes

- This command doesn't change Claude's tools or permissions — it's purely a prompt-priming convention.
- Re-running this command later is fine and just re-confirms the focus.
