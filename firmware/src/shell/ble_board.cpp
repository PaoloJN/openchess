#include "ble_board.h"
#include <NimBLEDevice.h>
#include <ArduinoJson.h>

// Custom 128-bit UUIDs for the OpenChess service + its two characteristics.
#define SVC_UUID "6f00c0de-b5a3-f393-e0a9-e50e24dcca01"
#define CMD_UUID "6f00c0de-b5a3-f393-e0a9-e50e24dcca02"   // app writes commands
#define EVT_UUID "6f00c0de-b5a3-f393-e0a9-e50e24dcca03"   // board notifies events

BleBoard bleBoard;

static NimBLECharacteristic* evtChar = nullptr;
static bool clientConnected = false;

class ServerCB : public NimBLEServerCallbacks {
  void onConnect(NimBLEServer*, NimBLEConnInfo&) override { clientConnected = true; }
  void onDisconnect(NimBLEServer*, NimBLEConnInfo&, int) override {
    clientConnected = false;
    NimBLEDevice::startAdvertising();   // let the phone reconnect
  }
};

class CmdCB : public NimBLECharacteristicCallbacks {
  void onWrite(NimBLECharacteristic* c, NimBLEConnInfo&) override {
    bleBoard.handleCommand(String(c->getValue().c_str()));
  }
};

void BleBoard::begin(const String& name) {
  NimBLEDevice::init(name.c_str());
  NimBLEDevice::setMTU(517);            // allow larger LED/wifi payloads
  NimBLEServer* server = NimBLEDevice::createServer();
  server->setCallbacks(new ServerCB());

  NimBLEService* svc = server->createService(SVC_UUID);
  NimBLECharacteristic* cmd =
      svc->createCharacteristic(CMD_UUID, NIMBLE_PROPERTY::WRITE | NIMBLE_PROPERTY::WRITE_NR);
  cmd->setCallbacks(new CmdCB());
  evtChar = svc->createCharacteristic(EVT_UUID, NIMBLE_PROPERTY::NOTIFY | NIMBLE_PROPERTY::READ);
  svc->start();

  NimBLEAdvertising* adv = NimBLEDevice::getAdvertising();
  adv->addServiceUUID(SVC_UUID);
  adv->setName(name.c_str());
  adv->enableScanResponse(true);
  NimBLEDevice::startAdvertising();
}

bool BleBoard::connected() const { return clientConnected; }

void BleBoard::notify(const String& json) {
  if (!evtChar || !clientConnected) return;
  evtChar->setValue((uint8_t*)json.c_str(), json.length());
  evtChar->notify();
}

void BleBoard::pushStatus(int battery, const String& firmware, const String& wifiSsid,
                          int wifiStrength, bool lichessReady) {
  JsonDocument doc;
  doc["t"] = "status";
  doc["battery"] = battery;
  doc["firmware"] = firmware;
  JsonObject w = doc["wifi"].to<JsonObject>();
  w["ssid"] = wifiSsid;
  w["strength"] = wifiStrength;
  w["lichessReady"] = lichessReady;
  String out;
  serializeJson(doc, out);
  notify(out);
}

void BleBoard::pushMove(const String& square, const char* kind) {
  JsonDocument doc;
  doc["t"] = "move";
  doc["square"] = square;
  doc["kind"] = kind;
  String out;
  serializeJson(doc, out);
  notify(out);
}

void BleBoard::pushWifiList(const std::vector<WifiNet>& nets) {
  JsonDocument doc;
  doc["t"] = "wifiList";
  JsonArray arr = doc["networks"].to<JsonArray>();
  for (const auto& n : nets) {
    JsonObject o = arr.add<JsonObject>();
    o["name"] = n.name;
    o["lock"] = n.lock;
    o["strength"] = n.strength;
  }
  String out;
  serializeJson(doc, out);
  notify(out);
}

void BleBoard::pushDebug(const String& line) {
  JsonDocument doc;
  doc["t"] = "dbg";
  doc["m"] = line;
  String out;
  serializeJson(doc, out);
  notify(out);
}

void BleBoard::handleCommand(const String& json) {
  JsonDocument doc;
  if (deserializeJson(doc, json)) return;
  const char* t = doc["t"] | "";

  if (!strcmp(t, "setLEDs")) {
    std::vector<LedCellMsg> cells;
    for (JsonObject c : doc["cells"].as<JsonArray>())
      cells.push_back({c["file"] | 0, c["rank"] | 0, c["r"] | 0, c["g"] | 0, c["b"] | 0});
    if (onSetLEDs) onSetLEDs(cells);
  } else if (!strcmp(t, "scanWifi")) {
    if (onScanWifi) onScanWifi();
  } else if (!strcmp(t, "provisionWifi")) {
    if (onProvisionWifi) onProvisionWifi(String((const char*)(doc["ssid"] | "")),
                                         String((const char*)(doc["password"] | "")));
  }
}
