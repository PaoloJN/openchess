#!/usr/bin/env python3
"""make_jlc_assembly.py — generate JLC BOM + CPL CSVs from KiCad's
exported all-pos.csv.

Why this exists: JLC PCBA wants two specific files:
  • BOM CSV — one row per UNIQUE part (Comment, Designator list, Footprint, JLCPCB Part #)
  • CPL CSV — one row per PLACED part (Designator, Mid X, Mid Y, Layer, Rotation)
KiCad's "Generate Position File" exports an all-pos.csv that has the per-
component data; we just reshape it.

Two adjustments JLC requires that KiCad's export gets wrong:
  1. Y axis is flipped — KiCad uses +Y down; JLC wants the standard
     mathematical +Y up. So the CPL flips Y to positive.
  2. Position values need a `mm` suffix and Top/Bottom is capitalised.

Mechanical-only items (fiducials FID1..FID3, mounting holes H1..H4, the
hand-soldered J1 connector) are excluded — JLC's pick-and-place machine
doesn't place them.
"""
from __future__ import annotations
import csv
import re
import sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
BOARD_DIR = HERE.parent
ALL_POS_CSV = BOARD_DIR / "assembly" / "openchess-board-all-pos.csv"
BOM_OUT = BOARD_DIR / "assembly" / "openchess-board-jlc-bom.csv"
CPL_OUT = BOARD_DIR / "assembly" / "openchess-board-jlc-cpl.csv"

# Part library — (value, footprint-fragment) → (JLC Part #, JLC-friendly
# Comment, JLC-friendly Footprint). Footprint-fragment is a substring of
# the KiCad footprint name that uniquely identifies the package.
PART_LIBRARY = [
    # (value, footprint_contains, jlc_part, comment, jlc_footprint)
    ("47uF",     "C_1206_3216Metric",  "C96123",  "47uF",      "1206"),
    ("100nF",    "C_0805_2012Metric",  "C49678",  "100nF",     "0805"),
    ("WS2812B",  "LED_WS2812B_PLCC4",  "C2761795","WS2812B",   "LED-WS2812B_5050"),
    ("DRV5032FC","SOT-23",             "C527532", "DRV5032FC", "SOT-23"),
]

# Refs to exclude from assembly — mechanical / hand-soldered.
EXCLUDE_REF_RE = re.compile(r"^(FID\d+|H\d+|J\d+)$")


def lookup_part(value: str, footprint: str) -> tuple[str, str, str] | None:
    """Return (jlc_part, comment, jlc_footprint) or None if no match."""
    for val, fp_substr, jlc, comment, jlc_fp in PART_LIBRARY:
        if val == value and fp_substr in footprint:
            return jlc, comment, jlc_fp
    return None


def ref_sort_key(ref: str) -> tuple[str, int]:
    """Sort C10 < C11 < C2 (default string sort) becomes C2 < C10 < C11."""
    m = re.match(r"([A-Za-z]+)(\d+)", ref)
    if m:
        return m.group(1), int(m.group(2))
    return ref, 0


def main() -> int:
    if not ALL_POS_CSV.exists():
        sys.exit(f"ERROR: {ALL_POS_CSV} not found. "
                 f"Export it from KiCad: File → Fabrication Outputs → "
                 f"Component Placement (.pos).")

    rows = list(csv.DictReader(ALL_POS_CSV.open()))
    print(f"Read {len(rows)} placed components from {ALL_POS_CSV.name}")

    # Detect Y axis convention. KiCad's pos export uses +Y down when the
    # drill/place file origin is NOT set (raw absolute coords). When
    # the drill origin IS set (placed at the board's bottom-left
    # corner), KiCad emits standard +Y up coords. JLC wants +Y up — so
    # if Y is already positive we leave it alone; if negative we flip.
    y_needs_flip = any(float(r["PosY"]) < 0 for r in rows)
    print(f"Y convention: {'flip (KiCad +Y down)' if y_needs_flip else 'as-is (drill origin set, +Y up)'}")

    # ── BOM: group by (value, footprint) → list of refs ──────────────
    grouped: dict[tuple[str, str], list[str]] = defaultdict(list)
    skipped: list[str] = []
    unknown: list[str] = []
    cpl_rows: list[dict] = []

    for r in rows:
        ref = r["Ref"]
        if EXCLUDE_REF_RE.match(ref):
            skipped.append(ref)
            continue
        value, footprint = r["Val"], r["Package"]
        part = lookup_part(value, footprint)
        if part is None:
            unknown.append(f"{ref} ({value}, {footprint})")
            continue
        jlc, comment, jlc_fp = part
        grouped[(jlc, comment, jlc_fp)].append(ref)
        # CPL row — Y handled per-convention (see y_needs_flip above)
        y_val = float(r["PosY"])
        if y_needs_flip:
            y_val = -y_val
        cpl_rows.append({
            "Designator": ref,
            "Mid X": f"{float(r['PosX']):.6f}mm",
            "Mid Y": f"{y_val:.6f}mm",
            "Layer": r["Side"].capitalize(),
            "Rotation": str(int(round(float(r["Rot"])))),
        })

    if unknown:
        print(f"WARN: {len(unknown)} components had no part mapping — "
              f"they're missing from PART_LIBRARY:")
        for u in unknown[:10]:
            print(f"  {u}")

    print(f"Skipped {len(skipped)} mechanical refs: "
          f"{', '.join(sorted(set(skipped))[:8])}...")

    # ── Write BOM ─────────────────────────────────────────────────────
    BOM_OUT.parent.mkdir(parents=True, exist_ok=True)
    with BOM_OUT.open("w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["Comment", "Designator", "Footprint", "JLCPCB Part #"])
        for (jlc, comment, jlc_fp), refs in sorted(
            grouped.items(),
            key=lambda kv: ref_sort_key(kv[1][0]),
        ):
            refs_sorted = sorted(refs, key=ref_sort_key)
            w.writerow([comment, ",".join(refs_sorted), jlc_fp, jlc])
    print(f"Wrote {BOM_OUT} — {len(grouped)} lines")

    # ── Write CPL ─────────────────────────────────────────────────────
    cpl_rows.sort(key=lambda r: ref_sort_key(r["Designator"]))
    with CPL_OUT.open("w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["Designator", "Mid X", "Mid Y",
                                          "Layer", "Rotation"])
        w.writeheader()
        for row in cpl_rows:
            w.writerow(row)
    print(f"Wrote {CPL_OUT} — {len(cpl_rows)} placed parts")
    return 0


if __name__ == "__main__":
    sys.exit(main())
