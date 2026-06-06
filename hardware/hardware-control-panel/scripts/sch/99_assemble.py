#!/usr/bin/env python3
"""99_assemble.py — concatenate build/sch/*.sexp chunks into openchess-control-panel.kicad_sch.

Reads chunks matching NN_*.sexp (NN = two digits) in alphabetical order,
wraps them in (kicad_sch ...) with version / generator / uuid header
and (sheet_instances ...) footer, writes the assembled schematic.

Preserves the sheet UUID across runs by reading the existing file.
Backs up the previous .kicad_sch to *.backup_before_assemble.

Run with KiCad CLOSED — KiCad locks the file while open and a
concurrent write here will corrupt it.
"""
from __future__ import annotations
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lib import BUILD_DIR, OUT_PATH, REPO_ROOT

VERSION = "20260306"
GENERATOR = "eeschema"
GENERATOR_VERSION = "10.0"
DEFAULT_SHEET_UUID = "ab0a4d00-0000-4000-8000-000000000001"


def read_existing_uuid(path: Path) -> str | None:
    """Pull the first top-level (uuid "...") from an existing .kicad_sch."""
    if not path.exists():
        return None
    for line in path.read_text().splitlines():
        s = line.strip()
        if s.startswith("(uuid "):
            return s.split('"')[1]
    return None


def main() -> int:
    chunks = sorted(BUILD_DIR.glob("[0-9][0-9]_*.sexp"))
    if not chunks:
        sys.exit(f"no chunks found in {BUILD_DIR.relative_to(REPO_ROOT)}")

    sheet_uuid = read_existing_uuid(OUT_PATH) or DEFAULT_SHEET_UUID

    out: list[str] = [
        "(kicad_sch",
        f"\t(version {VERSION})",
        f'\t(generator "{GENERATOR}")',
        f'\t(generator_version "{GENERATOR_VERSION}")',
        f'\t(uuid "{sheet_uuid}")',
    ]

    for chunk_path in chunks:
        out.append("")
        out.append(chunk_path.read_text().rstrip())

    out.extend([
        "",
        "\t(sheet_instances",
        '\t\t(path "/"',
        '\t\t\t(page "1")',
        "\t\t)",
        "\t)",
        ")",
    ])

    text = "\n".join(out) + "\n"

    if OUT_PATH.exists():
        backup = OUT_PATH.with_suffix(OUT_PATH.suffix + ".backup_before_assemble")
        shutil.copy2(OUT_PATH, backup)

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(text)

    print(f"OK  assembled {len(chunks)} chunks → {OUT_PATH.relative_to(REPO_ROOT)}")
    print(f"    {len(text):,} chars / {len(text.encode()):,} bytes")
    print(f"    sheet uuid = {sheet_uuid[:8]}…")
    print(f"    chunks: {', '.join(c.stem for c in chunks)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
