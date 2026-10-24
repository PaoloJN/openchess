#ifndef OPENCHESS_SHELL_PROTOCOL_H
#define OPENCHESS_SHELL_PROTOCOL_H

#include <stdint.h>
#include <stddef.h>

// Types mirrored from web/lib/protocol.ts - keep in sync.

enum class MsgType {
    Unknown,
    Ping,
    SetLed,
};

struct SetLedPayload {
    uint8_t file;  // 0-7 (A-H)
    uint8_t rank;  // 0-7 (1-8)
    uint8_t r;     // 0-255
    uint8_t g;
    uint8_t b;
};

struct ProtocolMessage {
    MsgType type = MsgType::Unknown;
    uint32_t id = 0;
    SetLedPayload setLed{};  // valid only when type == MsgType::SetLed
};

bool parseMessage(const char* json, ProtocolMessage& out);
size_t serializePongResponse(uint32_t id, char* buf, size_t buf_size);
size_t serializeBoardStateEvent(const bool occupancy[64], char* buf, size_t buf_size);

#endif
