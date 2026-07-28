// bench_roarm — ESP-NOW leader for the Waveshare RoArm-M2-S side quest.
// The arm ships as a broadcast follower: no pairing, no arm config needed.
// Wire contract (docs/reference/robot-arm/20-esp-now.md, verified against
// firmware-roarm/roarm_m2/RoArm-M2_example/esp_now_ctrl.h): fixed struct,
// cmd=1 => arm executes the JSON in `message` (non-blocking commands only,
// so moves use T:1041, never T:104).
// {"T":117,"angle":0..180} is the DIY gripper servo (local arm patch).
#include <Arduino.h>
#include <WiFi.h>
#include <esp_now.h>
#include <esp_wifi.h>

struct struct_message {  // MUST match roarm_m2 esp_now_ctrl.h field-for-field
  uint8_t devCode;
  float base, shoulder, elbow, hand;
  uint8_t cmd;
  char message[210];
};

static const uint8_t BROADCAST[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
static const uint8_t CHANNEL = 1;  // arm AP default channel

// MS18 DIY gripper travel (500-2500us band in the arm firmware):
static const int GRIP_OPEN = 0, GRIP_CLOSED = 180;

// (core 2.x signature — PlatformIO's espressif32 platform; the arm side
// builds on core 3.3.x where the first arg is wifi_tx_info_t* instead)
static void onSend(const uint8_t*, esp_now_send_status_t st) {
  Serial.println(st == ESP_NOW_SEND_SUCCESS ? "[espnow] delivered"
                                            : "[espnow] SEND FAILED");
}

static void sendJson(const String& json) {
  struct_message f = {};
  f.cmd = 1;
  json.toCharArray(f.message, sizeof(f.message));
  esp_err_t e = esp_now_send(BROADCAST, (uint8_t*)&f, sizeof(f));
  Serial.printf("-> %s (%s)\n", f.message, e == ESP_OK ? "queued" : "err");
}

static void grip(int angle) {
  sendJson(String("{\"T\":117,\"angle\":") + angle + "}");
}

static void moveTo(float x, float y, float z, float t = 3.14f) {
  char buf[120];
  snprintf(buf, sizeof(buf),
           "{\"T\":1041,\"x\":%.1f,\"y\":%.1f,\"z\":%.1f,\"t\":%.2f}", x, y, z, t);
  sendJson(buf);
}

static void demo() {
  Serial.println("demo: LED, wave, grip cycle");
  sendJson("{\"T\":114,\"led\":255}");   delay(800);
  moveTo(235, 0, 234);                   delay(1500);  // near init pose
  moveTo(200, 100, 180);                 delay(1500);
  moveTo(200, -100, 180);                delay(1500);
  moveTo(235, 0, 234);                   delay(1500);
  grip(GRIP_OPEN);                       delay(1200);
  grip(GRIP_CLOSED);                     delay(1200);
  grip(GRIP_OPEN);                       delay(1200);
  sendJson("{\"T\":114,\"led\":0}");
  Serial.println("demo done");
}

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  esp_wifi_set_channel(CHANNEL, WIFI_SECOND_CHAN_NONE);
  if (esp_now_init() != ESP_OK) { Serial.println("esp_now_init FAILED"); return; }
  esp_now_register_send_cb(onSend);
  esp_now_peer_info_t peer = {};
  memcpy(peer.peer_addr, BROADCAST, 6);
  peer.channel = CHANNEL;
  if (esp_now_add_peer(&peer) != ESP_OK) { Serial.println("add_peer FAILED"); return; }
  Serial.println("bench_roarm ready. Commands: home | grip <0-180> | open | close"
                 " | pos <x> <y> <z> | led <0-255> | json <raw> | demo");
}

void loop() {
  static String line;
  while (Serial.available()) {
    char c = Serial.read();
    if (c == '\n' || c == '\r') {
      line.trim();
      if (line == "home") sendJson("{\"T\":100}");
      else if (line == "demo") demo();
      else if (line == "open") grip(GRIP_OPEN);
      else if (line == "close") grip(GRIP_CLOSED);
      else if (line.startsWith("grip ")) grip(line.substring(5).toInt());
      else if (line.startsWith("led "))
        sendJson(String("{\"T\":114,\"led\":") + line.substring(4).toInt() + "}");
      else if (line.startsWith("pos ")) {
        float x, y, z;
        if (sscanf(line.c_str() + 4, "%f %f %f", &x, &y, &z) == 3) moveTo(x, y, z);
        else Serial.println("usage: pos <x> <y> <z>");
      }
      else if (line.startsWith("json ")) sendJson(line.substring(5));
      else if (line.length()) Serial.println("unknown command");
      line = "";
    } else line += c;
  }
}
