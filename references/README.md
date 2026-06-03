# References

Read-only clones of upstream projects this build is derived from or compared against. Useful when working offline or for keeping the project self-contained.

**These are gitignored** — each clone has its own upstream remote and tracks its own history. They are not part of `chessboard-v2`'s git history.

## What's here

### `chessboard-v1-omercier/`

Olivier Mercier's original `Chessboard` project — the v1 design that inspired this rebuild. Reed switches + multiplexed LED matrix + separate controller box + touchscreen.

- Upstream: <https://github.com/omercier01/Chessboard>
- Useful for: the proven Lichess client firmware, the CAD reference (`Cad/circuit_ESP32.svg`, `Cad/notes.txt`), and understanding the design tradeoffs we changed in v2.

### `openchess-joojoooo/`

joojoooo's OpenChess — the firmware foundation that `firmware/` will fork from. Modern C++ codebase with persistence, OTA, web UI, full chess engine, Stockfish, ChessConnect.

- Upstream: <https://github.com/joojoooo/OpenChess>
- Useful for: reading current source while planning the 9×9 LED adaptation; cross-referencing pin assignments; checking what's runtime-configurable vs compile-time.

## Re-cloning

If `references/` is missing (fresh checkout) and you want it populated:

```bash
mkdir -p references && cd references
git clone https://github.com/omercier01/Chessboard.git chessboard-v1-omercier
git clone https://github.com/joojoooo/OpenChess.git  openchess-joojoooo
```

## Updating

These are static snapshots. To pull upstream changes:

```bash
cd references/openchess-joojoooo && git pull
cd references/chessboard-v1-omercier && git pull
```
