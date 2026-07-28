#!/usr/bin/env python3
"""RoArm-M2-S serial console. Usage:
  python3 roarm_console.py --scan          # find which port is the arm
  python3 roarm_console.py /dev/cu.usbserial-XX
Shortcuts: home | pos X Y Z [T] | grip N | torque on|off | led N | save NAME | list | raw JSON
Reference: docs/reference/robot-arm/10-json-commands.md
"""
import glob, json, sys, time
from pathlib import Path

import serial  # pip install pyserial

BAUD = 115200
POSES = Path(__file__).parent / "roarm_poses.json"


def open_port(port):
    s = serial.Serial()
    s.port, s.baudrate, s.timeout = port, BAUD, 0.5
    s.dtr = False  # deassert BEFORE open: CP2102 DTR/RTS drive the
    s.rts = False  # ESP32 auto-reset circuit and would reboot the arm
    s.open()
    return s


def send(s, obj_or_str):
    line = obj_or_str if isinstance(obj_or_str, str) else json.dumps(obj_or_str)
    s.write((line + "\n").encode())


def drain(s, dur=0.8):
    out, end = [], time.time() + dur
    while time.time() < end:
        line = s.readline().decode(errors="replace").strip()
        if line:
            out.append(line)
            print(f"  arm> {line}")
    return out


def scan():
    for port in sorted(glob.glob("/dev/cu.usbserial*")):
        try:
            s = open_port(port)
            # Opening the port may auto-reset the ESP32 (DTR); let it boot.
            print(f"{port}: waiting out boot...")
            drain(s, 6.0)
            send(s, {"T": 105})  # feedback request -> {"T":1051,...}
            lines = drain(s, 2.0)
            s.close()
            verdict = "ARM" if any('"T":1051' in l for l in lines) else "not the arm"
            print(f"{port}: {verdict}")
        except (OSError, serial.SerialException) as e:
            print(f"{port}: busy/unreadable ({e})")


def get_pose(s):
    send(s, {"T": 105})
    for line in drain(s, 1.0):
        if '"T":1051' in line:
            fb = json.loads(line)
            return {k: fb[k] for k in ("x", "y", "z", "t") if k in fb}
    return None


def repl(port):
    s = open_port(port)
    poses = json.loads(POSES.read_text()) if POSES.exists() else {}
    print(f"Connected {port} @ {BAUD}. Type 'help'. Ctrl-C to quit.")
    while True:
        try:
            cmd = input("roarm> ").strip()
        except (EOFError, KeyboardInterrupt):
            break
        if not cmd:
            drain(s, 0.3)
            continue
        parts = cmd.split()
        if cmd == "help":
            print(__doc__)
        elif cmd == "home":
            send(s, {"T": 100})
        elif parts[0] == "pos" and len(parts) >= 4:
            x, y, z = (float(v) for v in parts[1:4])
            t = float(parts[4]) if len(parts) > 4 else 3.14
            send(s, {"T": 1041, "x": x, "y": y, "z": z, "t": t})
        elif parts[0] == "grip" and len(parts) == 2:  # DIY servo, needs T:117 firmware
            send(s, {"T": 117, "angle": int(parts[1])})
        elif parts[0] == "torque" and len(parts) == 2:
            send(s, {"T": 210, "cmd": 1 if parts[1] == "on" else 0})
        elif parts[0] == "led" and len(parts) == 2:
            send(s, {"T": 114, "led": int(parts[1])})
        elif parts[0] == "save" and len(parts) == 2:
            pose = get_pose(s)
            if pose:
                poses[parts[1]] = pose
                POSES.write_text(json.dumps(poses, indent=2))
                print(f"saved {parts[1]}: {pose}")
            else:
                print("no T:1051 feedback received")
        elif cmd == "list":
            print(json.dumps(poses, indent=2))
        elif cmd.startswith("{"):
            send(s, cmd)
        else:
            print("unknown; type 'help'")
        drain(s)
    s.close()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--scan":
        scan()
    elif len(sys.argv) > 1:
        repl(sys.argv[1])
    else:
        print(__doc__)
