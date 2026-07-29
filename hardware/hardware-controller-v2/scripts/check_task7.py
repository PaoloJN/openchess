#!/usr/bin/env python3
"""
check_task7.py — Verify Task 7 power chain contract in the v2 schematic netlist.

Usage:
    python3 hardware/hardware-controller-v2/scripts/check_task7.py [path/to/netlist.net]

If no path is given, exports the netlist fresh from the schematic using kicad-cli, then
checks it. Exits 0 if all checks pass; exits 1 if any FAIL.

Pin numbers referenced in assertions come from the installed KiCad 10 library files
(grepped verbatim — not from memory):

  Battery_Management:BQ24074RGT  (Battery_Management.kicad_sym line 6820)
    pin 1  = TS       (thermistor sense)
    pin 2  = BAT      (battery positive, power out)
    pin 3  = BAT      (battery positive, duplicate)
    pin 4  = ~{CE}    (charge enable, active-low)
    pin 5  = EN2      (input-limit mode select bit 2)
    pin 6  = EN1      (input-limit mode select bit 1)
    pin 7  = ~{PGOOD} (power-good open-collector)
    pin 8  = VSS      (ground)
    pin 9  = ~{CHG}   (charge status open-drain)
    pin 10 = OUT      (system output, power path)
    pin 11 = OUT      (system output, duplicate)
    pin 12 = ILIM     (input current limit set)
    pin 13 = IN       (input from USB)
    pin 14 = TMR      (safety timer)
    pin 15 = ITERM    (termination current)
    pin 16 = ISET     (charge current set)
    pin 17 = VSS      (ground, duplicate / exposed pad)

  Converter_DCDC:TPS61022  (Converter_DCDC.kicad_sym line 108329)
    pin 1 = GND   (ground)
    pin 2 = SW    (switch node → inductor)
    pin 3 = VOUT  (output)
    pin 4 = FB    (feedback)
    pin 5 = EN    (enable)
    pin 6 = MODE  (PWM/PFM select)
    pin 7 = VIN   (input)

  Regulator_Linear:AMS1117-3.3  (extends AP1117-15, Regulator_Linear.kicad_sym line 2602)
    pin 1 = GND  (ground / adjust)
    pin 2 = VO   (output)
    pin 3 = VI   (input)

  Switch:SW_SPDT  (Switch.kicad_sym line 23618)
    pin 1 = A  (ON contact)
    pin 2 = B  (common / wiper)
    pin 3 = C  (OFF contact)

  Device:L  (Device.kicad_sym line 52588)
    pin 1 = 1  (one end)
    pin 2 = 2  (other end)

  Device:LED  (Device.kicad_sym line 52766)
    pin 1 = K  (cathode)
    pin 2 = A  (anode)

  Connector_Generic:Conn_01x02  (Connector_Generic.kicad_sym line 134)
    pin 1 = Pin_1  (battery positive)
    pin 2 = Pin_2  (battery negative)

  Device:R  (generic 2-pin)
    pin 1 = ~  (one end)
    pin 2 = ~  (other end)

Deletion assertions:
  BT1 (Device:Battery_Cell) must NOT appear in the netlist.
  D3  (any ref "D3") must NOT appear in the netlist.
  R14 must be on net VBAT (not the old "BAT" label).
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
NETLIST_TMP = "/tmp/v2_check_task7.net"


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
# Parse nets and components
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
    """
    nets_match = re.search(r'\(nets\b(.*)', netlist_text, re.DOTALL)
    if not nets_match:
        return {}
    nets_section = nets_match.group(1)

    result = {}
    full_blocks = re.findall(
        r'\(net\s.*?\(code\s+"[^"]*"\s*\)\s*\(name\s+"([^"]*)"(.*?)(?=\(net\s|\Z)',
        nets_section,
        re.DOTALL,
    )
    for name, body in full_blocks:
        nodes = re.findall(r'\(node\s.*?\(ref\s+"([^"]+)"\s*\)\s*\(pin\s+"([^"]+)"', body)
        result[name] = set(nodes)
    return result


def parse_all_refs(netlist_text):
    """
    Returns a set of all component reference designators present in the netlist.
    Looks in the (components ...) section.
    """
    comps_match = re.search(r'\(components\b(.*?)(?=\(nets\b)', netlist_text, re.DOTALL)
    if not comps_match:
        return set()
    comps_section = comps_match.group(1)
    refs = re.findall(r'\(ref\s+"([^"]+)"', comps_section)
    return set(refs)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def find_net(nets, *candidate_names):
    """
    Return (resolved_name, node_set) for the first matching candidate.
    Net names in KiCad netlists appear as "/NETNAME" for global signals, or
    plain "NETNAME" for power nets.  Try both forms.
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


def find_net_for_pin(nets, ref, pin):
    """Return the net name (or None) that contains (ref, pin)."""
    for nm, nodes_set in nets.items():
        if (ref, pin) in nodes_set:
            return nm
    return None


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------
PASS = "OK"
FAIL = "FAIL"


def run_checks(nets, all_refs):
    results = []

    def check(label, condition, detail=""):
        status = PASS if condition else FAIL
        msg = f"  {status}  {label}"
        if detail:
            msg += f"  ({detail})"
        results.append((status, msg))

    # =========================================================================
    # DELETION ASSERTIONS — v1 leftovers must be gone
    # =========================================================================

    check("BT1 (v1 battery cell) absent from netlist",
          "BT1" not in all_refs,
          "BT1 must be deleted — v2 uses J5 JST connector instead of a bare cell symbol")

    check("D3 absent from netlist",
          "D3" not in all_refs,
          "D3 (v1 Schottky) must be deleted from the schematic")

    # =========================================================================
    # VBAT net — R14 must be on VBAT (not old 'BAT' label)
    # =========================================================================

    vbat_name, vbat = find_net(nets, "VBAT", "/VBAT")
    check("VBAT net exists",
          vbat_name is not None,
          "Net VBAT must exist (rename old 'BAT' label on R14 top)")

    check("R14 pin 1 on VBAT",
          pin_in(vbat, "R14", "1"),
          "R14 pin 1 (divider top) must be on VBAT — re-label 'BAT' → 'VBAT'")

    # Make sure BAT is truly gone (should not be a net name)
    old_bat_name, old_bat = find_net(nets, "BAT", "/BAT")
    check("Old 'BAT' label net is gone (renamed to VBAT)",
          old_bat_name is None,
          "Net 'BAT' still exists — rename the local label on R14 top from BAT to VBAT")

    # =========================================================================
    # VSYS net
    # =========================================================================

    vsys_name, vsys = find_net(nets, "VSYS", "/VSYS")
    check("VSYS net exists",
          vsys_name is not None,
          "Net VSYS must exist — wire U9 OUT pins to it")

    check("U9 pin 10 (OUT) on VSYS",
          pin_in(vsys, "U9", "10"),
          "U9 pin 10 (OUT) must be on VSYS")

    check("U9 pin 11 (OUT dup) on VSYS",
          pin_in(vsys, "U9", "11"),
          "U9 pin 11 (OUT dup) must also be on VSYS")

    check("U10 pin 7 (VIN) on VSYS",
          pin_in(vsys, "U10", "7"),
          "U10 pin 7 (VIN) must be on VSYS — boost input from charger output")

    check("SW1 pin 2 (B, common) on VSYS",
          pin_in(vsys, "SW1", "2"),
          "SW1 pin 2 (common/wiper) must be on VSYS")

    # R25 CHG LED pull-up is from VSYS
    check("R25 (CHG LED pull-up) on VSYS",
          pin_in(vsys, "R25", "1") or pin_in(vsys, "R25", "2"),
          "R25 (CHG LED 1kΩ series) must have one pin on VSYS (pull-up rail from OUT)")

    # =========================================================================
    # VBAT net (continued)
    # =========================================================================

    check("U9 pin 2 (BAT) on VBAT",
          pin_in(vbat, "U9", "2"),
          "U9 pin 2 (BAT) must be on VBAT")

    check("U9 pin 3 (BAT dup) on VBAT",
          pin_in(vbat, "U9", "3"),
          "U9 pin 3 (BAT dup) must also be on VBAT")

    check("J5 pin 1 (battery +) on VBAT",
          pin_in(vbat, "J5", "1"),
          "J5 pin 1 must be on VBAT — battery positive terminal")

    # =========================================================================
    # VBUS net — U9 IN
    # =========================================================================

    vbus_name, vbus = find_net(nets, "VBUS", "/VBUS")
    check("VBUS net exists",
          vbus_name is not None,
          "VBUS net must exist (from Task 6)")

    check("U9 pin 13 (IN) on VBUS",
          pin_in(vbus, "U9", "13"),
          "U9 pin 13 (IN) must be on VBUS — charger input from USB")

    # =========================================================================
    # GND net — all ground connections
    # =========================================================================

    gnd_name, gnd = find_net(nets, "GND", "/GND")
    check("GND net exists",
          gnd_name is not None,
          "GND net must exist")

    check("U9 pin 8 (VSS) on GND",
          pin_in(gnd, "U9", "8"),
          "U9 pin 8 (VSS) must be on GND")

    check("U9 pin 17 (VSS dup) on GND",
          pin_in(gnd, "U9", "17"),
          "U9 pin 17 (VSS dup / exposed pad) must be on GND")

    check("U9 pin 4 (~{CE}) on GND (always-enable)",
          pin_in(gnd, "U9", "4"),
          "U9 pin 4 (~{CE}) must be tied to GND to keep charger always-enabled")

    check("U9 pin 6 (EN1) on GND",
          pin_in(gnd, "U9", "6"),
          "U9 pin 6 (EN1) must be on GND for external ILIM mode")

    check("U9 pin 14 (TMR) on GND (timer disabled)",
          pin_in(gnd, "U9", "14"),
          "U9 pin 14 (TMR) must be on GND to disable safety timer")

    check("J5 pin 2 (battery −) on GND",
          pin_in(gnd, "J5", "2"),
          "J5 pin 2 must be on GND — battery negative terminal")

    check("U10 pin 1 (GND) on GND",
          pin_in(gnd, "U10", "1"),
          "U10 pin 1 (GND) must be on GND")

    check("U10 pin 6 (MODE) on GND (force PWM)",
          pin_in(gnd, "U10", "6"),
          "U10 pin 6 (MODE) must be on GND to force PWM mode")

    check("U11 pin 1 (GND) on GND",
          pin_in(gnd, "U11", "1"),
          "U11 pin 1 (GND) must be on GND")

    check("D5 pin 1 (K cathode) on GND",
          pin_in(gnd, "D5", "1"),
          "D5 pin 1 (K, cathode of PWR LED) must be on GND")

    # =========================================================================
    # +3.3V net — EN2 and LDO output
    # =========================================================================

    v33_name, v33 = find_net(nets, "+3.3V", "/+3.3V")
    check("+3.3V net exists",
          v33_name is not None,
          "+3.3V net must exist (from prior tasks)")

    check("U9 pin 5 (EN2) on +3.3V",
          pin_in(v33, "U9", "5"),
          "U9 pin 5 (EN2) must be on +3.3V — selects external ILIM mode")

    check("U11 pin 2 (VO) on +3.3V",
          pin_in(v33, "U11", "2"),
          "U11 pin 2 (VO) must be on +3.3V — LDO output")

    check("R27 (PWR LED series R) on +3.3V",
          pin_in(v33, "R27", "1") or pin_in(v33, "R27", "2"),
          "R27 pin 1 must be on +3.3V — PWR LED pull-up rail")

    # =========================================================================
    # +5V_LED net — boost output → LDO input
    # =========================================================================

    v5_name, v5 = find_net(nets, "+5V_LED", "/+5V_LED")
    check("+5V_LED net exists",
          v5_name is not None,
          "+5V_LED net must exist (pre-existing net from prior tasks)")

    check("U10 pin 3 (VOUT) on +5V_LED",
          pin_in(v5, "U10", "3"),
          "U10 pin 3 (VOUT) must be on +5V_LED — boost output")

    check("U11 pin 3 (VI) on +5V_LED",
          pin_in(v5, "U11", "3"),
          "U11 pin 3 (VI) must be on +5V_LED — LDO input from boost")

    # FB divider R31 top pin on +5V_LED
    check("R31 (FB R1, 750kΩ) on +5V_LED",
          pin_in(v5, "R31", "1") or pin_in(v5, "R31", "2"),
          "R31 (FB divider top, 750kΩ) must have one pin on +5V_LED")

    # =========================================================================
    # Inductor L1 — boost topology: VSYS (input) through L1 to SW node.
    # CORRECTED 2026-07-29: the original contract wired L1 to +5V_LED (output),
    # which is wrong for a boost converter and would make the 5V rail dead.
    # Per TPS61022 datasheet typical application: L1 = VSYS <-> SW.
    # =========================================================================

    # L1 pin 1 must be on same net as U10 pin 2 (SW)
    sw_net_name = find_net_for_pin(nets, "U10", "2")
    check("U10 pin 2 (SW) is wired",
          sw_net_name is not None,
          "U10 pin 2 (SW) must be on some net (SW node to inductor L1)")

    if sw_net_name:
        sw_net = nets[sw_net_name]
        check("L1 pin 1 on same net as U10 SW (pin 2)",
              ref_in(sw_net, "L1"),
              f"L1 must share a net with U10 pin 2 (net: {sw_net_name!r}) — SW node to inductor")

    # L1 pin 2 must be on VSYS (boost input side, per datasheet)
    check("L1 pin 2 on VSYS (boost input — NOT +5V_LED)",
          pin_in(nets.get("VSYS", {}), "L1", "2") if isinstance(nets.get("VSYS"), dict) else ref_in(nets.get("VSYS", []), "L1"),
          "L1 pin 2 must be on VSYS — inductor goes between the input supply and SW "
          "(TPS61022 datasheet). If it reads +5V_LED the schematic still has the old bug.")
    check("L1 NOT on +5V_LED (old bug check)",
          not pin_in(v5, "L1", "1") and not pin_in(v5, "L1", "2"),
          "L1 must not touch +5V_LED at all — that was the incorrect original wiring.")

    # =========================================================================
    # FB divider — R31 and R32 share the FB node (U10 pin 4)
    # =========================================================================

    fb_net_name = find_net_for_pin(nets, "U10", "4")
    check("U10 pin 4 (FB) is wired",
          fb_net_name is not None,
          "U10 pin 4 (FB) must be on some net (feedback divider tap)")

    if fb_net_name:
        fb_net = nets[fb_net_name]
        check("R31 (FB R1, 750kΩ) on FB node",
              ref_in(fb_net, "R31"),
              f"R31 must share the FB net with U10 pin 4 (net: {fb_net_name!r})")
        check("R32 (FB R2, 100kΩ) on FB node",
              ref_in(fb_net, "R32"),
              f"R32 must share the FB net with U10 pin 4 (net: {fb_net_name!r})")

    # R32 other end must be on GND
    check("R32 (FB R2) other end on GND",
          pin_in(gnd, "R32", "1") or pin_in(gnd, "R32", "2"),
          "R32 pin not on FB must be on GND")

    # =========================================================================
    # EN pin — SW1 → U10 EN, with R26 pulldown
    # =========================================================================

    en_sw_net_name = find_net_for_pin(nets, "SW1", "1")  # SW1 pin A (ON contact)
    check("SW1 pin 1 (A, ON contact) is wired",
          en_sw_net_name is not None,
          "SW1 pin 1 (A) must be wired to U10 EN (and R26 pulldown)")

    if en_sw_net_name:
        en_sw_net = nets[en_sw_net_name]
        check("U10 pin 5 (EN) on same net as SW1 pin 1 (A)",
              pin_in(en_sw_net, "U10", "5"),
              f"U10 pin 5 (EN) must share net with SW1 pin 1 (net: {en_sw_net_name!r})")
        check("R26 (EN pulldown 100kΩ) on EN net",
              ref_in(en_sw_net, "R26"),
              f"R26 must share the EN net with SW1 pin 1 and U10 pin 5 (net: {en_sw_net_name!r})")

    check("R26 other end on GND (pulldown)",
          pin_in(gnd, "R26", "1") or pin_in(gnd, "R26", "2"),
          "R26 other pin must be on GND — this is the pulldown that holds EN low when switch is OFF")

    # =========================================================================
    # ISET — R29 (910Ω)
    # =========================================================================

    iset_net_name = find_net_for_pin(nets, "U9", "16")
    check("U9 pin 16 (ISET) is wired",
          iset_net_name is not None,
          "U9 pin 16 (ISET) must be wired (R29 910Ω to GND)")

    if iset_net_name:
        iset_net = nets[iset_net_name]
        check("R29 (ISET 910Ω) on same net as U9 pin 16",
              ref_in(iset_net, "R29"),
              f"R29 must share ISET net with U9 pin 16 (net: {iset_net_name!r})")

    check("R29 other end on GND",
          pin_in(gnd, "R29", "1") or pin_in(gnd, "R29", "2"),
          "R29 other pin must be on GND — sets charge current ~0.978A")

    # =========================================================================
    # ILIM — R28 (1.1kΩ)
    # =========================================================================

    ilim_net_name = find_net_for_pin(nets, "U9", "12")
    check("U9 pin 12 (ILIM) is wired",
          ilim_net_name is not None,
          "U9 pin 12 (ILIM) must be wired (R28 1.1kΩ to GND)")

    if ilim_net_name:
        ilim_net = nets[ilim_net_name]
        check("R28 (ILIM 1.1kΩ) on same net as U9 pin 12",
              ref_in(ilim_net, "R28"),
              f"R28 must share ILIM net with U9 pin 12 (net: {ilim_net_name!r})")

    check("R28 other end on GND",
          pin_in(gnd, "R28", "1") or pin_in(gnd, "R28", "2"),
          "R28 other pin must be on GND — sets input current limit 1.46A")

    # =========================================================================
    # TS — R30 (10kΩ)
    # =========================================================================

    ts_net_name = find_net_for_pin(nets, "U9", "1")
    check("U9 pin 1 (TS) is wired",
          ts_net_name is not None,
          "U9 pin 1 (TS) must be wired (R30 10kΩ to GND to disable temp fault)")

    if ts_net_name:
        ts_net = nets[ts_net_name]
        check("R30 (TS 10kΩ) on same net as U9 pin 1",
              ref_in(ts_net, "R30"),
              f"R30 must share TS net with U9 pin 1 (net: {ts_net_name!r})")

    check("R30 other end on GND",
          pin_in(gnd, "R30", "1") or pin_in(gnd, "R30", "2"),
          "R30 other pin must be on GND — biases TS to normal-temperature window")

    # =========================================================================
    # CHG LED circuit: VSYS → R25 → D4 anode → D4 cathode → U9 pin 9 (~{CHG})
    # =========================================================================

    # D4 cathode (pin 1) must be on same net as U9 pin 9 (~{CHG})
    chg_net_name = find_net_for_pin(nets, "U9", "9")
    check("U9 pin 9 (~{CHG}) is wired",
          chg_net_name is not None,
          "U9 pin 9 (~{CHG}) must be wired — open-drain CHG status to LED cathode")

    if chg_net_name:
        chg_net = nets[chg_net_name]
        check("D4 cathode (pin 1) on CHG net (U9 pin 9)",
              pin_in(chg_net, "D4", "1"),
              f"D4 pin 1 (K cathode) must be on same net as U9 pin 9 (net: {chg_net_name!r})")

    # D4 anode (pin 2) must share a net with R25
    d4_anode_net_name = find_net_for_pin(nets, "D4", "2")
    check("D4 anode (pin 2) is wired",
          d4_anode_net_name is not None,
          "D4 pin 2 (A anode) must be wired to R25")

    if d4_anode_net_name:
        d4_anode_net = nets[d4_anode_net_name]
        check("R25 (CHG LED 1kΩ) on D4 anode net",
              ref_in(d4_anode_net, "R25"),
              f"R25 must share net with D4 pin 2 (net: {d4_anode_net_name!r})")

    # R25 must also touch VSYS (the pull-up rail)
    check("R25 on VSYS (CHG LED pull-up from OUT rail)",
          pin_in(vsys, "R25", "1") or pin_in(vsys, "R25", "2"),
          "R25 must connect to VSYS (the BQ24074 OUT rail) as pull-up for CHG open-drain")

    # =========================================================================
    # PWR LED circuit: +3.3V → R27 → D5 anode → D5 cathode → GND
    # =========================================================================

    # D5 anode (pin 2) must share a net with R27
    d5_anode_net_name = find_net_for_pin(nets, "D5", "2")
    check("D5 anode (pin 2) is wired",
          d5_anode_net_name is not None,
          "D5 pin 2 (A anode) must be wired to R27")

    if d5_anode_net_name:
        d5_anode_net = nets[d5_anode_net_name]
        check("R27 (PWR LED 1kΩ) on D5 anode net",
              ref_in(d5_anode_net, "R27"),
              f"R27 must share net with D5 pin 2 (net: {d5_anode_net_name!r})")

    # R27 must touch +3.3V
    check("R27 on +3.3V (PWR LED anode-side supply)",
          pin_in(v33, "R27", "1") or pin_in(v33, "R27", "2"),
          "R27 must connect to +3.3V — PWR LED pull-up rail")

    # D5 cathode on GND
    check("D5 cathode (pin 1) on GND",
          pin_in(gnd, "D5", "1"),
          "D5 pin 1 (K cathode) must be on GND")

    # =========================================================================
    # U11 input decoupling — C18 on +5V_LED and GND
    # =========================================================================

    check("C18 on +5V_LED (LDO input bypass)",
          pin_in(v5, "C18", "1") or pin_in(v5, "C18", "2"),
          "C18 must be on +5V_LED — input bypass cap for AMS1117")

    check("C18 on GND",
          pin_in(gnd, "C18", "1") or pin_in(gnd, "C18", "2"),
          "C18 other pin must be on GND")

    # =========================================================================
    # U11 output decoupling — C17 on +3.3V and GND
    # =========================================================================

    check("C17 on +3.3V (LDO output bypass)",
          pin_in(v33, "C17", "1") or pin_in(v33, "C17", "2"),
          "C17 must be on +3.3V — output bypass cap for AMS1117")

    check("C17 on GND",
          pin_in(gnd, "C17", "1") or pin_in(gnd, "C17", "2"),
          "C17 other pin must be on GND")

    # =========================================================================
    # U9 IN decoupling — C20 on VBUS and GND
    # =========================================================================

    check("C20 on VBUS (U9 IN decoupling)",
          pin_in(vbus, "C20", "1") or pin_in(vbus, "C20", "2"),
          "C20 must be on VBUS — input decoupling for BQ24074 IN pin")

    check("C20 on GND",
          pin_in(gnd, "C20", "1") or pin_in(gnd, "C20", "2"),
          "C20 other pin must be on GND")

    # =========================================================================
    # U9 OUT decoupling — C21 on VSYS and GND
    # =========================================================================

    check("C21 on VSYS (U9 OUT decoupling)",
          pin_in(vsys, "C21", "1") or pin_in(vsys, "C21", "2"),
          "C21 must be on VSYS — output decoupling for BQ24074 OUT pins")

    check("C21 on GND",
          pin_in(gnd, "C21", "1") or pin_in(gnd, "C21", "2"),
          "C21 other pin must be on GND")

    # =========================================================================
    # U10 VIN decoupling — C22 on VSYS and GND
    # =========================================================================

    check("C22 on VSYS (U10 VIN decoupling)",
          pin_in(vsys, "C22", "1") or pin_in(vsys, "C22", "2"),
          "C22 must be on VSYS — input decoupling for TPS61022 VIN pin")

    check("C22 on GND",
          pin_in(gnd, "C22", "1") or pin_in(gnd, "C22", "2"),
          "C22 other pin must be on GND")

    # =========================================================================
    # U10 VOUT decoupling — C23, C24, C25 on +5V_LED and GND
    # =========================================================================

    check("C23 on +5V_LED (U10 VOUT bulk cap)",
          pin_in(v5, "C23", "1") or pin_in(v5, "C23", "2"),
          "C23 (100µF bulk) must be on +5V_LED — boost output bulk cap")

    check("C23 on GND",
          pin_in(gnd, "C23", "1") or pin_in(gnd, "C23", "2"),
          "C23 other pin must be on GND")

    check("C24 on +5V_LED (U10 VOUT ceramic)",
          pin_in(v5, "C24", "1") or pin_in(v5, "C24", "2"),
          "C24 (22µF ceramic) must be on +5V_LED")

    check("C24 on GND",
          pin_in(gnd, "C24", "1") or pin_in(gnd, "C24", "2"),
          "C24 other pin must be on GND")

    check("C25 on +5V_LED (U10 VOUT ceramic)",
          pin_in(v5, "C25", "1") or pin_in(v5, "C25", "2"),
          "C25 (22µF ceramic) must be on +5V_LED")

    check("C25 on GND",
          pin_in(gnd, "C25", "1") or pin_in(gnd, "C25", "2"),
          "C25 other pin must be on GND")

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
    all_refs = parse_all_refs(raw)

    if not nets:
        print("ERROR: Could not parse any nets from netlist. Check the file.")
        sys.exit(1)

    print(f"\nParsed {len(nets)} nets, {len(all_refs)} component refs.")
    print("Running Task 7 contract checks...\n")

    results = run_checks(nets, all_refs)

    any_fail = False
    for status, msg in results:
        print(msg)
        if status == FAIL:
            any_fail = True

    total = len(results)
    passed = sum(1 for s, _ in results if s == PASS)
    failed = total - passed

    # Component VALUE assertions (added after R31/R32 10k escape)
    _schtxt = open(SCH).read()
    def _val(ref):
        import re as _r
        m = _r.search(r'\(property\s+"Reference"\s+"' + ref + r'"[\s\S]{0,300}?\(property\s+"Value"\s+"([^"]+)"', _schtxt)
        return (m.group(1) if m else "").lower().replace("\u03a9", "").replace("\u03c9", "").replace("uf", "\u00b5f").replace("uh", "\u00b5h")
    for _ref, _want, _why in [("R31", "750k", "FB top - sets 5V out"), ("R32", "100k", "FB bottom"),
            ("R29", "910", "ISET ~1A charge"), ("R28", "1.1k", "ILIM 1.46A"), ("R26", "100k", "boost EN pulldown"),
            ("L1", "1\u00b5h", "boost inductor"), ("C23", "100\u00b5f", "VOUT bulk"), ("C24", "22\u00b5f", "VOUT ceramic"), ("C25", "22\u00b5f", "VOUT ceramic")]:
        ok = _val(_ref) == _want.lower()
        total += 1
        if ok:
            passed += 1
            print(f"  OK  VALUE {_ref} == {_want}")
        else:
            failed += 1
            any_fail = True
            print(f"  FAIL  VALUE {_ref} == {_want}  ({_ref} must be {_want} ({_why}), found: {_val(_ref) or 'missing'})")

    print(f"\n{'='*60}")
    print(f"RESULT: {passed}/{total} checks passed, {failed} failed")

    if any_fail:
        print("OVERALL: FAIL — wire the missing connections in KiCad and re-run.")
        sys.exit(1)
    else:
        print("OVERALL: PASS — Task 7 power chain contract satisfied.")
        sys.exit(0)


if __name__ == "__main__":
    main()
