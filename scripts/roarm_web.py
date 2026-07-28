#!/usr/bin/env python3
"""Tiny web UI for the RoArm-M2-S via the OpenChess ESP-NOW bench.

  ~/.platformio/penv/bin/python scripts/roarm_web.py [serial-port]

Serves http://localhost:8787 (and on the LAN, so a phone works too).
Every button sends a bench_roarm console line (home/open/close/grip/pos/
led/json/demo) over USB to the OpenChess DevKitC, which broadcasts it to
the arm over ESP-NOW. The arm itself stays unplugged from the computer.
"""
import json, sys, threading, time
from collections import deque
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import serial

PORT = 8787
SERIAL_PORT = sys.argv[1] if len(sys.argv) > 1 else "/dev/cu.usbserial-10"
BAUD = 115200

log = deque(maxlen=200)
ser_lock = threading.Lock()

s = serial.Serial()
s.port, s.baudrate, s.timeout = SERIAL_PORT, BAUD, 0.3
s.dtr = False
s.rts = False
s.open()


def reader():
    while True:
        try:
            line = s.readline().decode(errors="replace").strip()
            if line:
                log.append(line)
        except (OSError, serial.SerialException):
            log.append("!! serial read error — is the board unplugged?")
            time.sleep(2)


threading.Thread(target=reader, daemon=True).start()

PAGE = """<!doctype html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>RoArm control</title>
<style>
  body{background:#14161a;color:#e8e8e8;font-family:-apple-system,sans-serif;
       max-width:480px;margin:0 auto;padding:16px}
  h1{font-size:1.2rem;margin:.2rem 0 1rem}
  .row{display:flex;gap:8px;margin-bottom:10px}
  button{flex:1;padding:14px 8px;font-size:1rem;border:0;border-radius:10px;
         background:#2a2f3a;color:#e8e8e8;cursor:pointer}
  button:active{background:#3d4656}
  .go{background:#1f6f43}.stop{background:#8a2f2f}
  input[type=range]{width:100%}
  input[type=text]{width:100%;padding:10px;border-radius:8px;border:0;
         background:#22262e;color:#e8e8e8;box-sizing:border-box}
  #log{background:#0d0f12;border-radius:8px;padding:8px;height:150px;
       overflow-y:auto;font:0.72rem/1.35 monospace;white-space:pre-wrap}
  label{font-size:.85rem;color:#9aa3b2}
</style>
<h1>🦾 RoArm control</h1>
<div class="row"><button class="go" onclick="cmd('home')">Home</button>
<button onclick="cmd('demo')">Demo</button>
<button class="stop" onclick="cmd('json {&quot;T&quot;:0}')">STOP</button></div>
<div class="row"><button onclick="cmd('open')">Open grip</button>
<button onclick="cmd('close')">Close grip</button></div>
<label>Grip angle: <span id="ga">90</span>°</label>
<input type="range" min="0" max="180" value="90" id="grip"
 oninput="document.getElementById('ga').textContent=this.value"
 onchange="cmd('grip '+this.value)">
<div class="row"><button onclick="cmd('pos 235 0 234')">Init pose</button>
<button onclick="cmd('pos 200 100 180')">Left</button>
<button onclick="cmd('pos 200 -100 180')">Right</button></div>
<div class="row"><button onclick="cmd('led 255')">LED on</button>
<button onclick="cmd('led 0')">LED off</button></div>
<label>Raw command (bench line or json {...})</label>
<div class="row"><input type="text" id="raw" placeholder="pos 180 50 120">
<button style="flex:0 0 70px" onclick="cmd(document.getElementById('raw').value)">Send</button></div>
<div id="log"></div>
<script>
async function cmd(line){ if(!line) return;
  await fetch('/cmd',{method:'POST',body:JSON.stringify({line})}); }
async function poll(){
  const r = await fetch('/log'); const t = await r.json();
  const el = document.getElementById('log');
  el.textContent = t.lines.join('\\n'); el.scrollTop = el.scrollHeight; }
setInterval(poll, 800); poll();
</script>
"""


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):  # keep the terminal quiet
        pass

    def _send(self, code, body, ctype="text/html; charset=utf-8"):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.end_headers()
        self.wfile.write(body.encode() if isinstance(body, str) else body)

    def do_GET(self):
        if self.path == "/":
            self._send(200, PAGE)
        elif self.path == "/log":
            self._send(200, json.dumps({"lines": list(log)}), "application/json")
        else:
            self._send(404, "nope")

    def do_POST(self):
        if self.path != "/cmd":
            return self._send(404, "nope")
        n = int(self.headers.get("Content-Length", 0))
        line = json.loads(self.rfile.read(n))["line"].strip()
        log.append(f"you> {line}")
        with ser_lock:
            s.write((line + "\n").encode())
        self._send(200, json.dumps({"ok": True}), "application/json")


if __name__ == "__main__":
    print(f"Serial: {SERIAL_PORT} @ {BAUD}")
    print(f"Open http://localhost:{PORT}  (works from a phone on your LAN too)")
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
