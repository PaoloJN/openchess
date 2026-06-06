# DO NOT USE THIS DIRECTORY

These scripts are **archived and dangerous**. They use `99_assemble.py`
which **OVERWRITES** the hand-drawn `openchess-controller.kicad_sch`
file. Running any chunk script in here destroys your KiCad work.

The actual scripts are now under `../sch.DO_NOT_RUN.archived/` —
kept for reference but should never be executed.

For test-point/mounting-hole generation, use the **snippet generator**
under `../snippets/gen_test_mech.py` instead. That one generates a
separate `.kicad_sch` file you copy-paste from — it does NOT touch
the main controller schematic.

If you ever accidentally run an old chunk script:
1. The schematic is overwritten with just the chunk content
2. A backup is automatically saved to
   `openchess-controller.kicad_sch.backup_before_assemble`
3. Recover by:
   ```bash
   cp openchess-controller.kicad_sch.backup_before_assemble \
      openchess-controller.kicad_sch
   ```
