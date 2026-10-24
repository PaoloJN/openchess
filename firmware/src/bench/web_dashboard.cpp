// web_dashboard.cpp — BENCH TEST 3: live web UI for LEDs + sensors
// Build:  pio run -e bench_web -t upload
//
// The ESP32 makes its OWN WiFi hotspot (no router needed):
//     SSID:  OpenChess-Bench      PASS:  chess1234
// Join it from your phone/laptop, open  http://192.168.4.1
//
// You get:
//   - a live 8x8 grid: a square turns GREEN the instant a magnet is over it
//   - LED controls: all off / all dim-white / walk one pixel / pick a color
//
// This is the one-stop bring-up tool: see every sensor + drive every LED
// from your phone. Sensors scan in the background; the page polls them.
//
// SAFETY: LED brightness capped low (81 white LEDs would pull ~4.9A; supply
// is 2.4A). "All white" here uses a dim value.
#include <Arduino.h>
#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <NeoPixelBus.h>
#include "pins.h"

static const char* AP_SSID = "OpenChess-Bench";
static const char* AP_PASS = "chess1234";
static const int   SETTLE_MS = 55;
static const uint8_t DIM = 40;

static NeoPixelBus<NeoGrbFeature, NeoEsp32Rmt0Ws2812xMethod> strip(LED_COUNT, PIN_LED_DATA);
static AsyncWebServer server(80);

static volatile bool present[MATRIX_COLS][MATRIX_ROWS];

// ── background sensor scan ────────────────────────────────────────────
static void scanTask(void*) {
  for (;;) {
    for (int c = 0; c < MATRIX_COLS; c++) {
      digitalWrite(PIN_COL_DRV[c], HIGH);
      vTaskDelay(pdMS_TO_TICKS(SETTLE_MS));
      for (int r = 0; r < MATRIX_ROWS; r++)
        present[c][r] = (digitalRead(PIN_ROW_SENSE[r]) == LOW);
      digitalWrite(PIN_COL_DRV[c], LOW);
    }
  }
}

// ── LED helpers ───────────────────────────────────────────────────────
static void fill(RgbColor c) {
  for (int i = 0; i < LED_COUNT; i++) strip.SetPixelColor(i, c);
  strip.Show();
}

// ── inline web page ───────────────────────────────────────────────────
static const char PAGE[] PROGMEM = R"HTML(
<!doctype html><html><head><meta name=viewport content="width=device-width,initial-scale=1">
<title>OpenChess Bench</title><style>
body{font-family:system-ui;background:#111;color:#eee;text-align:center;margin:0;padding:16px}
h2{margin:8px}
#grid{display:inline-grid;grid-template-columns:repeat(8,40px);gap:3px;margin:12px}
.sq{width:40px;height:40px;border-radius:6px;background:#333;transition:background .1s}
.sq.on{background:#2ecc40;box-shadow:0 0 10px #2ecc40}
.row{margin:10px}
button,input{font-size:16px;padding:8px 12px;margin:3px;border-radius:6px;border:0}
button{background:#0074d9;color:#fff}
.lbl{color:#888;font-size:13px}
</style></head><body>
<h2>OpenChess — Bench Dashboard</h2>
<div class=lbl>Squares turn green when a magnet is over them</div>
<div id=grid></div>
<div class=row>
  <button onclick="led('off')">LEDs Off</button>
  <button onclick="led('white')">All Dim White</button>
  <button onclick="led('walk')">Walk Pixel</button>
</div>
<div class=row>
  <input type=color id=col value="#ff0000">
  <button onclick="led('color&v='+document.getElementById('col').value.substring(1))">Set Color</button>
</div>
<div class=lbl id=stat>connecting...</div>
<script>
const g=document.getElementById('grid');
// build 8x8, rank 8 at top, files A-H
let cells=[];
for(let r=7;r>=0;r--)for(let c=0;c<8;c++){let d=document.createElement('div');d.className='sq';g.appendChild(d);cells.push({c,r,el:d});}
async function poll(){
  try{
    let s=await(await fetch('/api/sensors')).json();
    cells.forEach(x=>x.el.classList.toggle('on', s[x.c*8+x.r]==1));
    document.getElementById('stat').textContent='live • '+s.filter(v=>v).length+' sensors active';
  }catch(e){document.getElementById('stat').textContent='disconnected';}
}
function led(cmd){fetch('/api/led?cmd='+cmd);}
setInterval(poll,200);poll();
</script></body></html>
)HTML";

void setup() {
  Serial.begin(115200);
  delay(300);
  Serial.println("\n=== BENCH 3: web dashboard ===");

  for (int c = 0; c < MATRIX_COLS; c++) { pinMode(PIN_COL_DRV[c], OUTPUT); digitalWrite(PIN_COL_DRV[c], LOW); }
  for (int r = 0; r < MATRIX_ROWS; r++)   pinMode(PIN_ROW_SENSE[r], INPUT);

  strip.Begin();
  fill(RgbColor(0, 0, 0));

  WiFi.mode(WIFI_AP);
  WiFi.softAP(AP_SSID, AP_PASS);
  Serial.printf("WiFi AP '%s' (pass '%s')  ->  http://%s\n",
                AP_SSID, AP_PASS, WiFi.softAPIP().toString().c_str());

  server.on("/", HTTP_GET, [](AsyncWebServerRequest* req) {
    req->send_P(200, "text/html", PAGE);
  });

  server.on("/api/sensors", HTTP_GET, [](AsyncWebServerRequest* req) {
    String s = "[";
    for (int c = 0; c < MATRIX_COLS; c++)
      for (int r = 0; r < MATRIX_ROWS; r++)
        s += (present[c][r] ? "1" : "0") + String((c == 7 && r == 7) ? "" : ",");
    s += "]";
    req->send(200, "application/json", s);
  });

  server.on("/api/led", HTTP_GET, [](AsyncWebServerRequest* req) {
    String cmd = req->hasParam("cmd") ? req->getParam("cmd")->value() : "";
    if (cmd == "off")        fill(RgbColor(0, 0, 0));
    else if (cmd == "white") fill(RgbColor(DIM, DIM, DIM));
    else if (cmd == "walk") {
      for (int i = 0; i < LED_COUNT; i++) {
        fill(RgbColor(0, 0, 0));
        strip.SetPixelColor(i, RgbColor(DIM, DIM, DIM));
        strip.Show();
        delay(30);
      }
    } else if (cmd == "color" && req->hasParam("v")) {
      long h = strtol(req->getParam("v")->value().c_str(), nullptr, 16);
      uint8_t r = (h >> 16) & 0xFF, g = (h >> 8) & 0xFF, b = h & 0xFF;
      // scale to safe brightness
      fill(RgbColor(r * DIM / 255, g * DIM / 255, b * DIM / 255));
    }
    req->send(200, "text/plain", "ok");
  });

  server.begin();
  xTaskCreatePinnedToCore(scanTask, "scan", 4096, nullptr, 1, nullptr, 1);
  Serial.println("Ready. Join the WiFi and open http://192.168.4.1");
}

void loop() { delay(1000); }
