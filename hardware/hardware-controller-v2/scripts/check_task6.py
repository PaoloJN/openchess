#!/usr/bin/env python3
"""
check_task6.py — Verify Task 6 USB/CH340C/auto-program contract in the v2 schematic netlist.

Usage:
    python3 hardware/hardware-controller-v2/scripts/check_task6.py [path/to/netlist.net]

If no path is given, exports the netlist fresh from the schematic using kicad-cli, then
checks it. Exits 0 if all checks pass; exits 1 if any FAIL.

Pin numbers referenced in assertions come from the installed KiCad 9/10 library files
(grepped verbatim — not from memory):

  Interface_USB:CH340C
    pin 1 = GND, pin 2 = TXD, pin 3 = RXD, pin 4 = V3, pin 5 = UD+, pin 6 = UD-
    pin 13 = ~{DTR}, pin 14 = ~{RTS}, pin 16 = VCC

  Connector:USB_C_Receptacle_USB2.0_16P
    pin A1 = GND, pin A4 = VBUS, pin A5 = CC1, pin A6 = D+, pin A7 = D-
    pin B5 = CC2, pin B6 = D+, pin B7 = D-, pin SH = SHIELD

  Transistor_BJT:SS8050  (extends Q_NPN_BEC)
    pin 1 = B (Base), pin 2 = E (Emitter), pin 3 = C (Collector)

  Power_Protection:USBLC6-2SC6  (extends USBLC6-2P6)
    pin 1 = I/O1, pin 2 = GND, pin 3 = I/O2, pin 4 = I/O2, pin 5 = VBUS, pin 6 = I/O1
"""

import re
import subprocess
import sys
import os

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
SCH = os.path.join(
    os.path.dirname(__file__),
    "..",
    "openchess-controller.kicad_sch",
)
SCH = os.path.normpath(SCH)

KICAD_CLI = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli"
NETLIST_TMP = "/tmp/v2_check_task6.net"

# ---------------------------------------------------------------------------
# Export or load netlist
# ---------------------------------------------------------------------------
def export_netlist(sch, output):
    print(f"Exporting netlist from: {sch}")
    result = subprocess.run(
        [KICAD_CLI, "sch", "export", "netlist", sch, "--output", output],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"ERROR: kicad-cli exited {result.returncode}")
        print(result.stderr)
        sys.exit(1)
    print(f"Netlist written to: {output}")


def load_netlist(path):
    with open(path) as f:
        return f.read()


# ---------------------------------------------------------------------------
# Parse nets
# ---------------------------------------------------------------------------
def parse_nets(netlist_text):
    """
    Returns a dict:  net_name -> set of (ref, pin) tuples.

    The KiCad netlist (version E) has this structure in the (nets ...) section:
        (net
            (code "N")
            (name "NETNAME")
            (class "Default")
            (node (ref "X") (pin "P") ...)
            ...
        )

    We use a whitespace-tolerant regex that handles any indentation.
    """
    # Extract the (nets ...) section first to avoid matching comp sections
    nets_match = re.search(r'\(nets\b(.*)', netlist_text, re.DOTALL)
    if not nets_match:
        return {}
    nets_section = nets_match.group(1)

    # Split into individual net blocks
    net_blocks = re.findall(
        r'\(net\s.*?\(code\s+"[^"]+"\s*\)\s*\(name\s+"([^"]+)".*?(?=\(net\s|\Z)',
        nets_section,
        re.DOTALL,
    )

    # Parse each block for (node (ref ...) (pin ...))
    result = {}
    # Re-extract full blocks with content
    full_blocks = re.findall(
        r'\(net\s.*?\(code\s+"[^"]*"\s*\)\s*\(name\s+"([^"]*)"(.*?)(?=\(net\s|\Z)',
        nets_section,
        re.DOTALL,
    )
    for name, body in full_blocks:
        nodes = re.findall(r'\(node\s.*?\(ref\s+"([^"]+)"\s*\)\s*\(pin\s+"([^"]+)"', body)
        result[name] = set(nodes)
    return result


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------
def find_net(nets, *candidate_names):
    """
    Given several candidate net names (with/without leading /), return the
    first one found. Returns (resolved_name, node_set) or (None, set()).
    Net names in KiCad netlists appear as "/NETNAME" for global signals, or
    plain "NETNAME" for power nets like "+3.3V" or "GND".
    """
    for name in candidate_names:
        if name in nets:
            return name, nets[name]
    return None, set()


def ref_in(nodes, ref):
    """True if any node has the given ref."""
    return any(r == ref for r, _ in nodes)


def pin_in(nodes, ref, pin):
    """True if (ref, pin) is in the node set."""
    return (ref, pin) in nodes


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------
PASS = "OK"
FAIL = "FAIL"


def run_checks(nets):
    results = []

    def check(label, condition, detail=""):
        status = PASS if condition else FAIL
        msg = f"  {status}  {label}"
        if detail:
            msg += f"  ({detail})"
        results.append((status, msg))

    # -- VBUS net --
    vbus_name, vbus = find_net(nets, "VBUS", "/VBUS")
    check("VBUS net exists", vbus_name is not None,
          f"looked for VBUS or /VBUS; found {vbus_name!r}")
    check("J4 in VBUS (pin A4)", pin_in(vbus, "J4", "A4"),
          "J4 pin A4 must be on VBUS")
    check("U7 in VBUS (pin 16 VCC)", pin_in(vbus, "U7", "16"),
          "U7 pin 16 (VCC) must be on VBUS")

    # -- USB_DP net --
    dp_name, dp = find_net(nets, "USB_DP", "/USB_DP")
    check("USB_DP net exists", dp_name is not None)
    check("J4 in USB_DP (pin A6)", pin_in(dp, "J4", "A6"),
          "J4 pin A6 (D+ side A) must be on USB_DP")
    check("J4 in USB_DP (pin B6)", pin_in(dp, "J4", "B6"),
          "J4 pin B6 (D+ side B) must be on USB_DP")
    check("U7 in USB_DP (pin 5 UD+)", pin_in(dp, "U7", "5"),
          "U7 pin 5 (UD+) must be on USB_DP")

    # -- USB_DM net --
    dm_name, dm = find_net(nets, "USB_DM", "/USB_DM")
    check("USB_DM net exists", dm_name is not None)
    check("J4 in USB_DM (pin A7)", pin_in(dm, "J4", "A7"),
          "J4 pin A7 (D- side A) must be on USB_DM")
    check("J4 in USB_DM (pin B7)", pin_in(dm, "J4", "B7"),
          "J4 pin B7 (D- side B) must be on USB_DM")
    check("U7 in USB_DM (pin 6 UD-)", pin_in(dm, "U7", "6"),
          "U7 pin 6 (UD-) must be on USB_DM")

    # -- GND: J4 pins A1 and SH --
    gnd_name, gnd = find_net(nets, "GND", "/GND")
    check("GND net exists", gnd_name is not None)
    check("J4 in GND (pin A1)", pin_in(gnd, "J4", "A1"),
          "J4 pin A1 (GND) must be on GND")
    check("J4 in GND (pin SH SHIELD)", pin_in(gnd, "J4", "SH"),
          "J4 pin SH (SHIELD) must be on GND")
    check("U7 in GND (pin 1)", pin_in(gnd, "U7", "1"),
          "U7 pin 1 (GND) must be on GND")

    # -- CC pulldowns: R21 and R22 --
    # R21 connects CC1 (J4 pin A5) to GND
    cc1_name, cc1 = find_net(nets, "USB_CC1", "/USB_CC1")
    # If no named net, the wire from A5 might be an anonymous net numbered
    # as /Net-(...) — just check that R21 exists in any net that J4/A5 is also in.
    r21_gnd = pin_in(gnd, "R21", "2") or pin_in(gnd, "R21", "1")
    # Find whichever net contains J4 A5
    j4_a5_net = None
    for nm, nodes_set in nets.items():
        if ("J4", "A5") in nodes_set:
            j4_a5_net = nm
            break
    r21_on_cc1 = False
    if j4_a5_net:
        r21_on_cc1 = ref_in(nets[j4_a5_net], "R21")
    check("R21 connects J4 pin A5 (CC1)", r21_on_cc1,
          f"R21 must be in same net as J4 A5 (net: {j4_a5_net!r})")
    check("R21 connects to GND", r21_gnd,
          "R21 pin 1 or 2 must be on GND")

    j4_b5_net = None
    for nm, nodes_set in nets.items():
        if ("J4", "B5") in nodes_set:
            j4_b5_net = nm
            break
    r22_on_cc2 = False
    if j4_b5_net:
        r22_on_cc2 = ref_in(nets[j4_b5_net], "R22")
    r22_gnd = pin_in(gnd, "R22", "2") or pin_in(gnd, "R22", "1")
    check("R22 connects J4 pin B5 (CC2)", r22_on_cc2,
          f"R22 must be in same net as J4 B5 (net: {j4_b5_net!r})")
    check("R22 connects to GND", r22_gnd,
          "R22 pin 1 or 2 must be on GND")

    # -- CH340C V3 bypass cap C19 --
    v3_net = None
    for nm, nodes_set in nets.items():
        if ("U7", "4") in nodes_set:
            v3_net = nm
            break
    c19_on_v3 = False
    if v3_net:
        c19_on_v3 = ref_in(nets[v3_net], "C19")
    check("C19 connects to U7 pin 4 (V3)", c19_on_v3,
          f"C19 must share net with U7 pin 4 (net: {v3_net!r})")
    c19_gnd = pin_in(gnd, "C19", "1") or pin_in(gnd, "C19", "2")
    check("C19 connects to GND", c19_gnd,
          "C19 other pin must be on GND")

    # -- C16 VCC decoupling --
    # C16 should be on VBUS and GND
    check("C16 in VBUS", pin_in(vbus, "C16", "1") or pin_in(vbus, "C16", "2"),
          "C16 (VCC decoupling) must be on VBUS net")
    check("C16 in GND", pin_in(gnd, "C16", "1") or pin_in(gnd, "C16", "2"),
          "C16 other pin must be on GND")

    # -- Serial crossover: U7 TXD (pin2) -> U0RXD, U7 RXD (pin3) -> U0TXD --
    u0rxd_name, u0rxd = find_net(nets, "/U0RXD", "U0RXD")
    check("U0RXD net exists", u0rxd_name is not None)
    check("U7 TXD (pin 2) on U0RXD", pin_in(u0rxd, "U7", "2"),
          "U7 pin 2 (TXD) must drive the U0RXD net (ESP32 RX)")
    check("U2 on U0RXD (pin 34)", pin_in(u0rxd, "U2", "34"),
          "U2 pin 34 (RXD0/GPIO3) must be on U0RXD")

    u0txd_name, u0txd = find_net(nets, "/U0TXD", "U0TXD")
    check("U0TXD net exists", u0txd_name is not None)
    check("U7 RXD (pin 3) on U0TXD", pin_in(u0txd, "U7", "3"),
          "U7 pin 3 (RXD) must receive from U0TXD net (ESP32 TX)")
    check("U2 on U0TXD (pin 35)", pin_in(u0txd, "U2", "35"),
          "U2 pin 35 (TXD0/GPIO1) must be on U0TXD")

    # Guard against crossover swap: TXD must NOT be on U0TXD, RXD must NOT be on U0RXD
    check("TXD/RXD not swapped (U7 pin2 NOT on U0TXD)",
          not pin_in(u0txd, "U7", "2"),
          "BUG: U7 TXD (pin2) is on U0TXD — crossover is wrong!")
    check("TXD/RXD not swapped (U7 pin3 NOT on U0RXD)",
          not pin_in(u0rxd, "U7", "3"),
          "BUG: U7 RXD (pin3) is on U0RXD — crossover is wrong!")

    # -- EN net: Q1 collector --
    en_name, en = find_net(nets, "/EN", "EN")
    check("EN net exists", en_name is not None)
    check("Q1 Collector (pin 3) on EN", pin_in(en, "Q1", "3"),
          "Q1 pin 3 (Collector) must be on EN net")
    check("U2 on EN (pin 3)", pin_in(en, "U2", "3"),
          "U2 pin 3 (EN) must be on EN net")

    # -- IO0 net: Q2 collector --
    io0_name, io0 = find_net(nets, "/IO0", "IO0")
    check("IO0 net exists", io0_name is not None)
    check("Q2 Collector (pin 3) on IO0", pin_in(io0, "Q2", "3"),
          "Q2 pin 3 (Collector) must be on IO0 net")
    check("U2 on IO0 (pin 25)", pin_in(io0, "U2", "25"),
          "U2 pin 25 (IO0) must be on IO0 net")

    # -- DTR net: Q1 emitter + Q2 emitter + U7 pin 13 --
    # Find the net containing U7 pin 13 (~{DTR})
    dtr_net_name = None
    for nm, nodes_set in nets.items():
        if ("U7", "13") in nodes_set:
            dtr_net_name = nm
            break
    dtr_nodes = nets.get(dtr_net_name, set()) if dtr_net_name else set()
    check("U7 pin 13 (~DTR) is wired", dtr_net_name is not None,
          "U7 pin 13 must be on some net (auto-program DTR side)")
    check("Q1 Base (pin 1) on DTR net via R23",
          ref_in(dtr_nodes, "R23"),
          f"R23 must be in DTR net (net: {dtr_net_name!r}) — R23 connects DTR to Q1 base")
    check("Q2 Emitter (pin 2) on DTR net",
          pin_in(dtr_nodes, "Q2", "2"),
          "Q2 pin 2 (Emitter) must be on DTR net")

    # -- RTS net: Q2 base via R24 + Q1 emitter + U7 pin 14 --
    rts_net_name = None
    for nm, nodes_set in nets.items():
        if ("U7", "14") in nodes_set:
            rts_net_name = nm
            break
    rts_nodes = nets.get(rts_net_name, set()) if rts_net_name else set()
    check("U7 pin 14 (~RTS) is wired", rts_net_name is not None,
          "U7 pin 14 must be on some net (auto-program RTS side)")
    check("Q2 Base (pin 1) on RTS net via R24",
          ref_in(rts_nodes, "R24"),
          f"R24 must be in RTS net (net: {rts_net_name!r}) — R24 connects RTS to Q2 base")
    check("Q1 Emitter (pin 2) on RTS net",
          pin_in(rts_nodes, "Q1", "2"),
          "Q1 pin 2 (Emitter) must be on RTS net")

    # -- R23 base connection: should reach Q1 base (pin 1) --
    # R23 has two pins; one is on DTR net, the other should be on a net with Q1 pin 1
    q1_base_net = None
    for nm, nodes_set in nets.items():
        if ("Q1", "1") in nodes_set:
            q1_base_net = nm
            break
    check("R23 connects to Q1 Base (pin 1)",
          q1_base_net is not None and ref_in(nets.get(q1_base_net, set()), "R23"),
          f"R23 must share a net with Q1 pin 1 (net: {q1_base_net!r})")

    # -- R24 base connection: should reach Q2 base (pin 1) --
    q2_base_net = None
    for nm, nodes_set in nets.items():
        if ("Q2", "1") in nodes_set:
            q2_base_net = nm
            break
    check("R24 connects to Q2 Base (pin 1)",
          q2_base_net is not None and ref_in(nets.get(q2_base_net, set()), "R24"),
          f"R24 must share a net with Q2 pin 1 (net: {q2_base_net!r})")

    return results


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    if len(sys.argv) >= 2:
        netlist_path = sys.argv[1]
        print(f"Using provided netlist: {netlist_path}")
    else:
        export_netlist(SCH, NETLIST_TMP)
        netlist_path = NETLIST_TMP

    raw = load_netlist(netlist_path)
    nets = parse_nets(raw)

    if not nets:
        print("ERROR: Could not parse any nets from netlist. Check the file.")
        sys.exit(1)

    print(f"\nParsed {len(nets)} nets. Running Task 6 contract checks...\n")

    results = run_checks(nets)

    any_fail = False
    for status, msg in results:
        print(msg)
        if status == FAIL:
            any_fail = True

    total = len(results)
    passed = sum(1 for s, _ in results if s == PASS)
    failed = total - passed

    print(f"\n{'='*60}")
    print(f"RESULT: {passed}/{total} checks passed, {failed} failed")

    if any_fail:
        print("OVERALL: FAIL — wire the missing connections in KiCad and re-run.")
        sys.exit(1)
    else:
        print("OVERALL: PASS — Task 6 contract satisfied.")
        sys.exit(0)


if __name__ == "__main__":
    main()
