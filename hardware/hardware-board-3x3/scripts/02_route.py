#!/usr/bin/env python3
"""
02_route.py — auto-route the matrix board.

Routes the four parametric signal families on the matrix board:

  - **LED data chain**: J1's LED_DATA_5V → D1 DIN; then DN DOUT → D(N+1) DIN
    for every consecutive pair of LEDs in raster order. Row-transition links
    use the `/L<n>` nets emitted by `sch/03_leds.py`.

  - **+5V_LED**: J1's +5V_LED pins → row-bulk caps → horizontal trunk through
    each LED row (touches every LED VCC pad + each per-LED cap pin 1).

  - **CA_PWR..CH_PWR**: J1's column-power pins → vertical column rail
    through every Hall sensor VDD pad in that file.

  - **S0..S7**: J1's row-sense pins → horizontal row rail through every
    Hall sensor OUT pad in that rank.

**GND is NOT routed.** The user fills F.Cu and B.Cu zones with GND, which
covers every GND-tied pad without explicit traces.

Idempotent: every track/via this script adds is tagged with a UUID prefix
(`70474e00…`). Re-running the script removes only its own tracks before
laying down fresh ones. Hand-routed traces with other UUIDs are preserved.

PREREQUISITE — openchess-board-3x3.kicad_pcb must already have component
placement done (run `01_chess_grid.py` first).

Run with KiCad CLOSED.
"""
from __future__ import annotations

import sys
import uuid as _uuid
from pathlib import Path

try:
    import pcbnew
except ImportError:
    sys.exit("pcbnew not on path — run inside KiCad's Python console "
             "or with the python that ships with KiCad.")


# ──────────────────────────────────────────────────────────────────────────────
# Configuration — change for the 8×8 by copying this file to that board's
# scripts/ dir and bumping these two numbers.
# ──────────────────────────────────────────────────────────────────────────────
MATRIX_COLS = 3
MATRIX_ROWS = 3
LED_COLS = MATRIX_COLS + 1     # 4
LED_ROWS = MATRIX_ROWS + 1     # 4

# Track widths (override netclass widths)
SIGNAL_WIDTH_MM = 0.25
POWER_WIDTH_MM  = 0.5    # +5V_LED width — matches Paolo's hand-routed top row
DIAG_45_MM      = 0.9    # 45° diagonal length used to "hop" around each LED VCC pad
                         # (gives ~0.9 mm clearance south of LED's DIN/DOUT pads)

# Default vias (general purpose)
VIA_DIAMETER_MM = 0.8
VIA_DRILL_MM    = 0.4

# Column rail (CA..CH_PWR) — matches Paolo's hand-routed /CA_PWR
# (extracted 2026-06-09). B.Cu vertical column ~3.6 mm west of Hall
# column X; F.Cu stub from each Hall VDD pad west to a via on the column.
# J1 connection NOT generated (Paolo wants to hand-route the J1 area).
COL_RAIL_WIDTH_MM        = 0.5
COL_RAIL_VIA_DIAMETER_MM = 0.6
COL_RAIL_VIA_DRILL_MM    = 0.3
COL_RAIL_X_OFFSET_MM     = 3.619   # column_x = Hall_X - this

# LED data chain — matches Paolo's hand-routed D1→D2 (extracted 2026-06-09).
# The chain hops over each pair of LEDs by exiting DOUT SW, running south
# on F.Cu, dropping to B.Cu just west of the next LED to clear the +5V_LED
# trunk, going north on B.Cu, popping back to F.Cu, and entering DIN NW.
LED_DATA_WIDTH_MM        = 0.2
LED_DATA_VIA_DIAMETER_MM = 0.6
LED_DATA_VIA_DRILL_MM    = 0.3
LED_SOUTH_LANE_OFFSET_MM = 3.237   # F.Cu south horizontal: Y_LED + this
LED_SOUTH_BRIDGE_HOP_MM  = 0.5     # 45° hop up before the south via
LED_NORTH_LANE_OFFSET_MM = 3.513   # F.Cu north horizontal: Y_LED - this
LED_BRIDGE_X_OFFSET_MM   = 4.669   # bridge X = next_LED.x - this

# LED chain ROW TRANSITION (/L<n>) — matches Paolo's hand-routed /L4
# (extracted 2026-06-09). The transition drops south from D_n DOUT all
# the way across the board to D_{n+1} DIN on the next row, on F.Cu only,
# running through the "inter-row" gap between LED rows at a lane Y that's
# slightly north of the Hall row center (so the lane clears the Hall pads).
INTER_ROW_LANE_NORTH_OF_HALL_MM = 4.812   # lane Y = Hall_row_Y - this
INTER_ROW_DOUT_DROP_VERTICAL_MM = 6.219   # south vertical from DOUT before SW diagonal
INTER_ROW_DOUT_SW_DIAG_MM       = 3.319   # 45° SW diagonal length from south drop
INTER_ROW_DIN_SW_DIAG_MM        = 4.75    # 45° SW diagonal length down to vertical
INTER_ROW_DIN_FINAL_DIAG_MM     = 0.081   # final tiny 45° into DIN

# Hall row geometry (parametric on SQUARE_SIZE + BOARD_MARGIN). For the
# 3×3 board: square 32 mm, margin 18 mm → first Hall row at Y = 84,
# subsequent rows at +32 mm. KEEP IN SYNC with 01_chess_grid.py constants.
SQUARE_SIZE_MM   = 32
BOARD_MARGIN_MM  = 18
FIRST_HALL_Y_MM  = BOARD_MARGIN_MM + SQUARE_SIZE_MM / 2.0 + 50  # board origin = 50

# Routing layers (per net family)
LAYER_LED_DATA      = "F.Cu"   # short hops between adjacent LEDs
LAYER_5V_TRUNK      = "F.Cu"   # row trunks through LED VCCs
LAYER_COL_PWR       = "F.Cu"   # CA..CH vertical rails
LAYER_ROW_SENSE     = "B.Cu"   # S0..S7 horizontal rails (different layer so
                               # they don't fight column rails at every Hall)

# UUID prefix to mark items as owned by this script (first 8 hex chars).
UUID_PREFIX = "70474e00"       # "rOUTE" + zeros


# ──────────────────────────────────────────────────────────────────────────────
# Path discovery
# ──────────────────────────────────────────────────────────────────────────────
HERE = Path(__file__).resolve().parent
BOARD_PATH = (HERE / ".." / "openchess-board-3x3.kicad_pcb").resolve()


# ──────────────────────────────────────────────────────────────────────────────
# pcbnew helpers
# ──────────────────────────────────────────────────────────────────────────────
F_CU = pcbnew.F_Cu
B_CU = pcbnew.B_Cu


def layer_id(name: str) -> int:
    return F_CU if name == "F.Cu" else B_CU


def mm_to_nm(v: float) -> int:
    return int(round(v * 1_000_000))


def make_owned_uuid() -> "pcbnew.KIID":
    """KIID whose first 8 hex chars are UUID_PREFIX — for idempotent cleanup."""
    suffix = _uuid.uuid4().hex[8:]
    full = UUID_PREFIX + suffix
    formatted = f"{full[:8]}-{full[8:12]}-{full[12:16]}-{full[16:20]}-{full[20:32]}"
    return pcbnew.KIID(formatted)


def uuid_str(item) -> str:
    """Get an item's UUID as a string, handling KiCad 10 API variations."""
    try:
        return item.m_Uuid.AsString()
    except Exception:
        try:
            return str(item.m_Uuid)
        except Exception:
            return ""


def is_owned(item) -> bool:
    return uuid_str(item).lower().replace("-", "").startswith(UUID_PREFIX.lower())


def find_pad(board: "pcbnew.BOARD", ref: str, pad_num) -> "pcbnew.PAD | None":
    pad_num = str(pad_num)
    for fp in board.GetFootprints():
        if fp.GetReference() == ref:
            for pad in fp.Pads():
                if pad.GetNumber() == pad_num:
                    return pad
    return None


def pad_pos(board: "pcbnew.BOARD", ref: str, pad_num) -> "pcbnew.VECTOR2I | None":
    pad = find_pad(board, ref, pad_num)
    return pad.GetPosition() if pad else None


def net_code(board: "pcbnew.BOARD", name: str) -> int | None:
    net = board.FindNet(name)
    if net is None or net.GetNetCode() == 0:
        return None
    return net.GetNetCode()


def add_track(
    board: "pcbnew.BOARD",
    start,
    end,
    net_code_val: int,
    layer_name: str = "F.Cu",
    width_mm: float = SIGNAL_WIDTH_MM,
) -> None:
    """Drop a track segment between two positions on the given layer."""
    if start is None or end is None or net_code_val is None:
        return
    if start.x == end.x and start.y == end.y:
        return
    track = pcbnew.PCB_TRACK(board)
    track.SetStart(start)
    track.SetEnd(end)
    track.SetLayer(layer_id(layer_name))
    track.SetWidth(mm_to_nm(width_mm))
    track.SetNetCode(net_code_val)
    try:
        track.m_Uuid = make_owned_uuid()
    except Exception:
        pass
    board.Add(track)


def add_via(
    board: "pcbnew.BOARD",
    pos,
    net_code_val: int,
    diameter_mm: float = VIA_DIAMETER_MM,
    drill_mm: float = VIA_DRILL_MM,
) -> None:
    via = pcbnew.PCB_VIA(board)
    via.SetPosition(pos)
    via.SetWidth(mm_to_nm(diameter_mm))
    via.SetDrill(mm_to_nm(drill_mm))
    via.SetNetCode(net_code_val)
    via.SetLayerPair(F_CU, B_CU)
    via.SetViaType(pcbnew.VIATYPE_THROUGH)
    try:
        via.m_Uuid = make_owned_uuid()
    except Exception:
        pass
    board.Add(via)


def clear_owned(board: "pcbnew.BOARD") -> int:
    """Remove all tracks/vias whose UUID starts with UUID_PREFIX."""
    removed = 0
    for track in list(board.GetTracks()):
        if is_owned(track):
            board.Remove(track)
            removed += 1
    return removed


# ──────────────────────────────────────────────────────────────────────────────
# Component lookup helpers (parametric on matrix size)
# ──────────────────────────────────────────────────────────────────────────────
def hall_ref(col: int, row: int) -> str:
    """U1..U{N²} in file-major order: U1=A1, U_{col*N+row+1}."""
    return f"U{col * MATRIX_ROWS + row + 1}"


def led_ref(col: int, row: int) -> str:
    """D1..D{(N+1)²} raster (row-major): D1=top-left."""
    return f"D{row * LED_COLS + col + 1}"


def led_cap_ref(col: int, row: int) -> str:
    """C10..C{10+(N+1)²-1} — one per LED, number-matched."""
    return f"C{10 + row * LED_COLS + col}"


def row_bulk_ref(row: int) -> str:
    """C1..C{N+1} — one per LED row."""
    return f"C{row + 1}"


# WS2812B PLCC4 footprint pin numbering (KiCad standard):
WS2812_VDD  = "1"
WS2812_DOUT = "2"
WS2812_VSS  = "3"
WS2812_DIN  = "4"

# DRV5032FC SOT-23 pin numbering:
DRV5032_VDD = "1"
DRV5032_GND = "2"
DRV5032_OUT = "3"

# J1 (J_CTRL) pin map — matches docs/inter-board-connector.md.
# NOTE: J1 on this board was manually mirrored in KiCad (Mirror Around X
# Axis) so the odd-even pin numbers swap relative to the contract here.
# The routing script uses the CONTRACT pin numbers; KiCad's net router
# follows the schematic-defined net assignments regardless of which
# physical pad number ended up where.
J1_PIN_5V       = ("1", "3", "5", "25")                    # +5V_LED entry pads
J1_PIN_LED_DATA = "7"                                       # LED_DATA_5V → D1 DIN
J1_PIN_S        = {i: str(9 + i) for i in range(8)}         # S0..S7 → J1 9..16
J1_PIN_COL      = {i: str(17 + i) for i in range(8)}        # CA..CH → J1 17..24

COL_LETTERS = ["A", "B", "C", "D", "E", "F", "G", "H"]


# ──────────────────────────────────────────────────────────────────────────────
# Routing functions
# ──────────────────────────────────────────────────────────────────────────────
def fp_pos(board: "pcbnew.BOARD", ref: str) -> "pcbnew.VECTOR2I | None":
    for fp in board.GetFootprints():
        if fp.GetReference() == ref:
            return fp.GetPosition()
    return None


def route_led_chain(board: "pcbnew.BOARD") -> int:
    """LED data chain — only within-row hops for now (D_n DOUT → D_{n+1} DIN
    where both LEDs share a row). Row transitions (/L<n>) and J1 entry
    (/LED_DATA_5V → D1) are left unrouted until Paolo hand-routes examples.

    Pattern per hop (extracted from D1→D2 on 2026-06-09):
        D_n DOUT (SW pad)
          ╲ 45° SE diagonal to south lane
          ─── F.Cu horizontal east at Y_LED + 3.237
          ╱ 0.5 mm 45° hop up to south bridge Y
        VIA (0.6 mm)
          │ B.Cu vertical north
        VIA (0.6 mm)
          ─── F.Cu horizontal east at Y_LED - 3.513
          ╲ 45° SE diagonal to next D's DIN (NE pad)
    Bridge X is placed at next_LED.x - 4.669 (just west of next LED).
    """
    count = 0
    total = LED_ROWS * LED_COLS

    south_offset = mm_to_nm(LED_SOUTH_LANE_OFFSET_MM)
    south_bridge_hop = mm_to_nm(LED_SOUTH_BRIDGE_HOP_MM)
    north_offset = mm_to_nm(LED_NORTH_LANE_OFFSET_MM)
    bridge_x_offset = mm_to_nm(LED_BRIDGE_X_OFFSET_MM)

    for n in range(1, total):
        # Skip row transitions (handled by route_led_chain_row_transitions)
        if n % LED_COLS == 0:
            continue

        dout = pad_pos(board, f"D{n}", WS2812_DOUT)
        din  = pad_pos(board, f"D{n+1}", WS2812_DIN)
        next_led_fp = fp_pos(board, f"D{n+1}")
        if not (dout and din and next_led_fp):
            continue

        nc = net_code(board, f"Net-(D{n}-DOUT)")
        if nc is None:
            continue

        # Use Dn's Y as Y_LED (both LEDs same row, same Y)
        y_led = dout.y - mm_to_nm(1.65)  # DOUT pad is at Y_LED + 1.65, so Y_LED = DOUT.y - 1.65
        y_south_lane   = y_led + south_offset
        y_south_bridge = y_south_lane - south_bridge_hop
        y_north_lane   = y_led - north_offset
        bridge_x = next_led_fp.x - bridge_x_offset

        # === South side ===
        # 1. DOUT → south lane (45° SE diagonal of length sqrt(2)*1.587 mm)
        d_se = y_south_lane - dout.y  # vertical drop = 1.587 mm
        p_after_dout = _v(dout.x + d_se, y_south_lane)
        add_track(board, dout, p_after_dout, nc, "F.Cu", LED_DATA_WIDTH_MM)

        # 2. Horizontal east on south lane to start of pre-bridge 0.5 mm hop
        p_before_hop = _v(bridge_x - south_bridge_hop, y_south_lane)
        add_track(board, p_after_dout, p_before_hop, nc, "F.Cu", LED_DATA_WIDTH_MM)

        # 3. 0.5 mm 45° hop up to south bridge Y
        p_south_via = _v(bridge_x, y_south_bridge)
        add_track(board, p_before_hop, p_south_via, nc, "F.Cu", LED_DATA_WIDTH_MM)

        # 4. Via south (F.Cu → B.Cu)
        add_via(board, p_south_via, nc, LED_DATA_VIA_DIAMETER_MM, LED_DATA_VIA_DRILL_MM)

        # === B.Cu bridge ===
        # 5. Vertical north on B.Cu
        p_north_via = _v(bridge_x, y_north_lane)
        add_track(board, p_south_via, p_north_via, nc, "B.Cu", LED_DATA_WIDTH_MM)

        # 6. Via north (B.Cu → F.Cu)
        add_via(board, p_north_via, nc, LED_DATA_VIA_DIAMETER_MM, LED_DATA_VIA_DRILL_MM)

        # === North side ===
        # 7. Horizontal east on north lane to start of DIN diagonal
        d_din = din.y - y_north_lane  # vertical rise toward DIN (positive)
        p_before_din = _v(din.x - d_din, y_north_lane)
        add_track(board, p_north_via, p_before_din, nc, "F.Cu", LED_DATA_WIDTH_MM)

        # 8. 45° SE diagonal into DIN (NW pad of next LED)
        add_track(board, p_before_din, din, nc, "F.Cu", LED_DATA_WIDTH_MM)

        count += 8  # 6 tracks + 2 vias counted as segments-ish

    return count


def _v(x_nm: int, y_nm: int) -> "pcbnew.VECTOR2I":
    return pcbnew.VECTOR2I(int(x_nm), int(y_nm))


def route_5v_trunks(board: "pcbnew.BOARD") -> int:
    """+5V_LED: per-row zigzag trunk matching Paolo's hand-routed top row.

    Topology per row (left → right):
        bulk pin 1
          ─── horizontal east at Y_bulk
          ╱  45° up to D_0 VCC (NW corner of LED)
        D_0 VCC
          ╲  45° down to junction Y (= Y_VCC + DIAG_45_MM)
          ─── horizontal east
          ╱  45° up to C_0 pin 1
        C_0 pin 1
          ─── horizontal east at Y_cap
          ╱  45° up to D_1 VCC
        D_1 VCC
          (repeat ↓→↗→ → for each LED/cap pair across the row)

    Trace width: POWER_WIDTH_MM (0.5 mm). Layer: F.Cu.

    The 45° diagonals south of each LED VCC give the row trunk room to
    hop over the LED's east-side pads (DIN/GND) without overlapping them.
    """
    nc = net_code(board, "+5V_LED")
    if nc is None:
        return 0
    count = 0
    diag = mm_to_nm(DIAG_45_MM)

    for row in range(LED_ROWS):
        bulk = pad_pos(board, row_bulk_ref(row), "1")
        if not bulk:
            continue

        # Gather (LED_VCC, cap_pin1) for each col, in left-to-right order
        leds_caps = []
        for col in range(LED_COLS):
            led_vcc = pad_pos(board, led_ref(col, row), WS2812_VDD)
            cap_p1  = pad_pos(board, led_cap_ref(col, row), "1")
            if led_vcc and cap_p1:
                leds_caps.append((led_vcc, cap_p1))
        if not leds_caps:
            continue

        # === Entry: bulk pin → first LED VCC ===
        first_vcc = leds_caps[0][0]
        # 45° entry: from horizontal at Y_bulk, rise to LED_VCC.
        # dy = Y_bulk - Y_VCC; for 45°, dx == dy.
        dy = bulk.y - first_vcc.y
        x_entry = first_vcc.x - dy
        entry_h_end = _v(x_entry, bulk.y)
        add_track(board, bulk, entry_h_end, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
        add_track(board, entry_h_end, first_vcc, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
        count += 2

        # === For each (LED, cap) pair: dip south, run east, up to cap, east to next LED, up ===
        for i, (led_vcc, cap_pin) in enumerate(leds_caps):
            # 1. From LED VCC: 45° down-right to junction
            junction = _v(led_vcc.x + diag, led_vcc.y + diag)
            add_track(board, led_vcc, junction, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
            count += 1

            # 2. Horizontal east from junction to point just before cap diagonal
            dy_cap = junction.y - cap_pin.y
            before_cap = _v(cap_pin.x - dy_cap, junction.y)
            add_track(board, junction, before_cap, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
            count += 1

            # 3. 45° up to cap pin
            add_track(board, before_cap, cap_pin, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
            count += 1

            # 4. If there's a next LED, run east at Y_cap then 45° up to its VCC
            if i < len(leds_caps) - 1:
                next_vcc = leds_caps[i + 1][0]
                dy_next = cap_pin.y - next_vcc.y
                before_next = _v(next_vcc.x - dy_next, cap_pin.y)
                add_track(board, cap_pin, before_next, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
                add_track(board, before_next, next_vcc, nc, LAYER_5V_TRUNK, POWER_WIDTH_MM)
                count += 2

    # J1 entry (J1's +5V_LED pads → bottom-row bulk) is INTENTIONALLY not
    # routed here — Paolo wants to hand-route the J1 area, so the script
    # leaves J1's pads untouched on every net family.

    return count


def route_led_chain_row_transitions(board: "pcbnew.BOARD") -> int:
    """LED chain row transitions /L4, /L8, /L12, … for the 3×3 (LED_COLS=4)
    or the equivalent for any matrix size.

    Pattern per transition (extracted from /L4 hand-route on 2026-06-09):
        D_n DOUT (SW pad, end of row k)
          │ F.Cu vertical south {DOUT_DROP_VERTICAL_MM}
          ╲ 45° SW diagonal {DOUT_SW_DIAG_MM}
          ─── F.Cu horizontal west on inter-row lane Y
              (lane Y = Hall_row_k_Y - INTER_ROW_LANE_NORTH_OF_HALL_MM)
          ╲ 45° SW diagonal {DIN_SW_DIAG_MM} down
          │ F.Cu vertical south to {DIN_FINAL_DIAG_MM} above DIN
          ╲ tiny 45° SW into DIN
        D_{n+1} DIN (NE pad, start of row k+1)

    All on F.Cu, no vias — the lane Y sits clear of Hall pads.
    """
    count = 0
    total = LED_ROWS * LED_COLS

    drop_vertical = mm_to_nm(INTER_ROW_DOUT_DROP_VERTICAL_MM)
    drop_sw_diag  = mm_to_nm(INTER_ROW_DOUT_SW_DIAG_MM)
    rise_sw_diag  = mm_to_nm(INTER_ROW_DIN_SW_DIAG_MM)
    final_diag    = mm_to_nm(INTER_ROW_DIN_FINAL_DIAG_MM)
    lane_offset   = mm_to_nm(INTER_ROW_LANE_NORTH_OF_HALL_MM)

    for n in range(LED_COLS, total, LED_COLS):
        # n is the last LED of row k; n+1 is first of row k+1
        dout = pad_pos(board, f"D{n}", WS2812_DOUT)
        din  = pad_pos(board, f"D{n+1}", WS2812_DIN)
        if not (dout and din):
            continue
        nc = net_code(board, f"/L{n}")
        if nc is None:
            continue

        # Hall row that lies BETWEEN row k and row k+1 (i.e. Hall row k)
        # Hall row k Y = FIRST_HALL_Y_MM + k * SQUARE_SIZE_MM
        # For /L_n with n = LED_COLS * (k+1), the row k of Halls is between
        # LED row k (n // LED_COLS - 1) and LED row k+1 (n // LED_COLS).
        led_row_k = (n // LED_COLS) - 1
        hall_row_y_nm = mm_to_nm(FIRST_HALL_Y_MM + led_row_k * SQUARE_SIZE_MM)
        lane_y = hall_row_y_nm - lane_offset

        # === Source side (east): drop from DOUT south, then SW diag to lane ===
        p2 = _v(dout.x, dout.y + drop_vertical)               # W2: vertical south
        p3 = _v(dout.x - drop_sw_diag, lane_y)                # W3: 45° SW to lane
        add_track(board, dout, p2, nc, "F.Cu", LED_DATA_WIDTH_MM)
        add_track(board, p2, p3, nc, "F.Cu", LED_DATA_WIDTH_MM)

        # === Destination side (west): SW diag down, then vertical south to DIN ===
        p5 = _v(din.x + final_diag, lane_y + rise_sw_diag)    # W5: end of SW diag
        p4 = _v(p5.x + rise_sw_diag, lane_y)                  # W4: start of SW diag (west end of lane)
        p6 = _v(din.x + final_diag, din.y - final_diag)       # W6: vertical south end

        # === Horizontal west across the board on the lane ===
        add_track(board, p3, p4, nc, "F.Cu", LED_DATA_WIDTH_MM)
        # === Destination side ===
        add_track(board, p4, p5, nc, "F.Cu", LED_DATA_WIDTH_MM)
        add_track(board, p5, p6, nc, "F.Cu", LED_DATA_WIDTH_MM)
        add_track(board, p6, din, nc, "F.Cu", LED_DATA_WIDTH_MM)

        count += 6  # 6 segments per transition

    return count


def route_column_rails(board: "pcbnew.BOARD") -> int:
    """CA..CH_PWR: B.Cu vertical column per file, with F.Cu stub from each
    Hall's VDD pad west to a via on the column.

    Matches Paolo's hand-routed /CA_PWR (extracted 2026-06-09). Pattern:
        column_x = Hall_X - 3.619 mm
        for each Hall VDD pad in the file:
            F.Cu trace from VDD west to (column_x, Y_VDD)
            VIA (0.6 mm) at (column_x, Y_VDD)
        B.Cu vertical segments connecting consecutive vias

    J1 connection (J1's CA_PWR pad → column) is intentionally NOT generated —
    Paolo hand-routes the J1 area.
    """
    count = 0
    col_offset = mm_to_nm(COL_RAIL_X_OFFSET_MM)

    for col in range(MATRIX_COLS):
        letter = COL_LETTERS[col]
        nc = net_code(board, f"/C{letter}_PWR")
        if nc is None:
            continue

        # Gather Hall VDD pads in this file, sorted by Y (south → north)
        hall_pads = []
        for row in range(MATRIX_ROWS):
            p = pad_pos(board, hall_ref(col, row), DRV5032_VDD)
            if p: hall_pads.append(p)
        if not hall_pads:
            continue
        hall_pads.sort(key=lambda p: -p.y)  # south first (largest Y first)

        column_x = hall_pads[0].x - col_offset

        # F.Cu stub + via at each Hall
        for pad in hall_pads:
            via_point = _v(column_x, pad.y)
            add_track(board, pad, via_point, nc, "F.Cu", COL_RAIL_WIDTH_MM)
            add_via(board, via_point, nc, COL_RAIL_VIA_DIAMETER_MM, COL_RAIL_VIA_DRILL_MM)
            count += 2  # 1 track + 1 via

        # B.Cu vertical segments connecting consecutive Hall vias
        for i in range(len(hall_pads) - 1):
            p1 = _v(column_x, hall_pads[i].y)
            p2 = _v(column_x, hall_pads[i + 1].y)
            add_track(board, p1, p2, nc, "B.Cu", COL_RAIL_WIDTH_MM)
            count += 1

    return count


def route_row_sense(board: "pcbnew.BOARD") -> int:
    """S0..S{N-1}: one straight F.Cu horizontal trace per rank, from the
    leftmost Hall's OUT pad to the rightmost.

    Matches Paolo's hand-routed /S2 (extracted 2026-06-09):
        F.Cu, 0.2 mm width, no vias. The track passes through each
        intermediate Hall's OUT pad center — KiCad's connectivity engine
        treats those as legitimate connection points so we only need one
        segment per net regardless of how many Halls share the rank.
    """
    count = 0
    for row in range(MATRIX_ROWS):
        nc = net_code(board, f"/S{row}")
        if nc is None:
            continue
        # Gather Hall OUT pads in this rank (every column)
        pads = []
        for col in range(MATRIX_COLS):
            p = pad_pos(board, hall_ref(col, row), DRV5032_OUT)
            if p: pads.append(p)
        if len(pads) < 2:
            continue
        pads.sort(key=lambda p: p.x)
        # One segment from leftmost OUT pad to rightmost
        add_track(board, pads[0], pads[-1], nc, "F.Cu", LED_DATA_WIDTH_MM)
        count += 1
    return count


# ──────────────────────────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────────────────────────
def main() -> int:
    if not BOARD_PATH.exists():
        print(f"ERROR: PCB not found at {BOARD_PATH}", file=sys.stderr)
        return 1

    print(f"Loading: {BOARD_PATH}")
    board = pcbnew.LoadBoard(str(BOARD_PATH))

    # Backup
    backup = BOARD_PATH.with_suffix(".kicad_pcb.backup_before_02_route")
    backup.write_bytes(BOARD_PATH.read_bytes())
    print(f"Backup: {backup.name}")

    # Clear previous owned items
    removed = clear_owned(board)
    print(f"Cleared {removed} previously-owned tracks/vias.")

    # Route each net family — toggle these as patterns get hand-routed
    # and extracted into the script. Disabled = "we don't have a confirmed
    # pattern yet, leave the net for Paolo to hand-route or for a later
    # iteration of this script."
    n_5v       = route_5v_trunks(board)
    n_chain    = route_led_chain(board)
    n_chain_rt = route_led_chain_row_transitions(board)
    n_col      = route_column_rails(board)
    n_sense    = route_row_sense(board)

    print(f"\nRouted:")
    print(f"  +5V_LED trunks             : {n_5v:>4} segments")
    print(f"  LED data (within-row)      : {n_chain:>4} segments")
    print(f"  LED data (row transitions) : {n_chain_rt:>4} segments")
    print(f"  CA..C{COL_LETTERS[MATRIX_COLS-1]}_PWR rails           : {n_col:>4} segments")
    print(f"  S0..S{MATRIX_ROWS-1} row sense              : {n_sense:>4} segments")
    print(f"  TOTAL                      : {n_chain + n_chain_rt + n_5v + n_col + n_sense:>4} new tracks/vias")
    print()
    print(f"  Skipped: J1 LED_DATA_5V → D1 entry — leave for hand routing")

    board.Save(str(BOARD_PATH))
    print(f"\nSaved: {BOARD_PATH.name}")
    print("Open in KiCad, run DRC, expect crossings/clearance violations on F.Cu.")
    print("Iterate by hand or tell the script what to change.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
