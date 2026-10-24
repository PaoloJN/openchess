#include "protocol.h"
#include <ArduinoJson.h>
#include <string.h>

bool parseMessage(const char* json, ProtocolMessage& out) {
    JsonDocument doc;
    DeserializationError err = deserializeJson(doc, json);
    if (err) return false;

    const char* type = doc["type"];
    if (!type) return false;
    out.id = doc["id"] | 0;

    if (strcmp(type, "ping") == 0) {
        out.type = MsgType::Ping;
        return true;
    }
    if (strcmp(type, "set_led") == 0) {
        out.type = MsgType::SetLed;
        out.setLed.file = doc["file"] | 0;
        out.setLed.rank = doc["rank"] | 0;
        out.setLed.r = doc["r"] | 0;
        out.setLed.g = doc["g"] | 0;
        out.setLed.b = doc["b"] | 0;
        return true;
    }
    return false;
}

size_t serializePongResponse(uint32_t id, char* buf, size_t buf_size) {
    JsonDocument doc;
    doc["type"] = "pong";
    doc["id"] = id;
    return serializeJson(doc, buf, buf_size);
}

size_t serializeBoardStateEvent(const bool occupancy[64], char* buf, size_t buf_size) {
    JsonDocument doc;
    doc["type"] = "board_state";
    JsonArray arr = doc["squares"].to<JsonArray>();
    for (int i = 0; i < 64; i++) arr.add(occupancy[i]);
    return serializeJson(doc, buf, buf_size);
}
