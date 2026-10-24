#!/usr/bin/env python3
"""OpenChess live BLE debug listener.

Connects to the board (OpenChess-XXXX), subscribes to its event characteristic,
and prints the live debug stream (game phase, sensor moves, AI choices, etc.)
plus board->app events. This is the "live debug" window for firmware bring-up.

Run:  ~/.openchess-ble/bin/python firmware/tools/ble_debug.py
Stop:  Ctrl-C
"""
import asyncio
import json
import sys
from bleak import BleakScanner, BleakClient

SVC_UUID = "6f00c0de-b5a3-f393-e0a9-e50e24dcca01"
EVT_UUID = "6f00c0de-b5a3-f393-e0a9-e50e24dcca03"
NAME_PREFIX = "OpenChess"


def ts():
    # monotonic-ish seconds since start, no wall clock needed
    return f"{asyncio.get_event_loop().time():8.2f}"


def on_notify(_handle, data: bytearray):
    txt = data.decode("utf-8", "replace")
    try:
        msg = json.loads(txt)
        t = msg.get("t")
        if t == "dbg":
            print(f"[{ts()}] DBG  {msg.get('m')}")
        elif t == "move":
            print(f"[{ts()}] MOVE {msg.get('square')} {msg.get('kind')}")
        elif t == "status":
            w = msg.get("wifi", {})
            print(f"[{ts()}] STAT batt={msg.get('battery')}% wifi={w.get('ssid') or '--'}")
        elif t == "wifiList":
            print(f"[{ts()}] WIFI {[n['name'] for n in msg.get('networks', [])]}")
        else:
            print(f"[{ts()}] {txt}")
    except json.JSONDecodeError:
        print(f"[{ts()}] RAW  {txt}")


async def main():
    print("Scanning for OpenChess board (up to 20s)...")
    dev = None
    # Match on the service UUID (reliable) OR the name prefix. Names sometimes
    # live only in the scan-response packet and get missed by a name-only filter.
    found = await BleakScanner.discover(timeout=20.0, return_adv=True)
    seen = []
    for d, adv in found.values():
        uuids = [u.lower() for u in (adv.service_uuids or [])]
        nm = d.name or adv.local_name
        seen.append(f"{nm or '?'} [{','.join(uuids) if uuids else 'no-svc'}]")
        if (nm and nm.startswith(NAME_PREFIX)) or SVC_UUID.lower() in uuids:
            dev = d
            break
    if not dev:
        print("Board not found. Is it powered on (menu visible) and not connected to your phone?")
        print("Devices seen:")
        for s in seen:
            print("   ", s)
        return

    print(f"Found {dev.name} ({dev.address}) — connecting...")
    async with BleakClient(dev) as client:
        print("Connected. Subscribing to debug stream. (Ctrl-C to stop)\n")
        await client.start_notify(EVT_UUID, on_notify)
        while client.is_connected:
            await asyncio.sleep(1)
    print("Disconnected.")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        sys.exit(0)
