#include <unity.h>
#include <string.h>
#include "shell/protocol.h"

void test_parse_ping(void) {
    const char* json = "{\"type\":\"ping\",\"id\":42}";
    ProtocolMessage msg;
    TEST_ASSERT_TRUE(parseMessage(json, msg));
    TEST_ASSERT_EQUAL(static_cast<int>(MsgType::Ping), static_cast<int>(msg.type));
    TEST_ASSERT_EQUAL_UINT32(42, msg.id);
}

void test_parse_set_led(void) {
    const char* json = "{\"type\":\"set_led\",\"id\":7,\"file\":3,\"rank\":4,\"r\":255,\"g\":0,\"b\":128}";
    ProtocolMessage msg;
    TEST_ASSERT_TRUE(parseMessage(json, msg));
    TEST_ASSERT_EQUAL(static_cast<int>(MsgType::SetLed), static_cast<int>(msg.type));
    TEST_ASSERT_EQUAL_UINT32(7, msg.id);
    TEST_ASSERT_EQUAL_UINT8(3, msg.setLed.file);
    TEST_ASSERT_EQUAL_UINT8(4, msg.setLed.rank);
    TEST_ASSERT_EQUAL_UINT8(255, msg.setLed.r);
    TEST_ASSERT_EQUAL_UINT8(0, msg.setLed.g);
    TEST_ASSERT_EQUAL_UINT8(128, msg.setLed.b);
}

void test_parse_invalid_json(void) {
    const char* json = "not json";
    ProtocolMessage msg;
    TEST_ASSERT_FALSE(parseMessage(json, msg));
}

void test_parse_unknown_type(void) {
    const char* json = "{\"type\":\"bogus\",\"id\":1}";
    ProtocolMessage msg;
    TEST_ASSERT_FALSE(parseMessage(json, msg));
}

void test_parse_missing_type(void) {
    const char* json = "{\"id\":1}";
    ProtocolMessage msg;
    TEST_ASSERT_FALSE(parseMessage(json, msg));
}

void test_serialize_pong_response(void) {
    char buf[128];
    size_t n = serializePongResponse(42, buf, sizeof(buf));
    TEST_ASSERT_TRUE(n > 0);
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"type\":\"pong\""));
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"id\":42"));
}

void test_serialize_board_state_event(void) {
    bool occupancy[64];
    for (int i = 0; i < 64; i++) occupancy[i] = (i < 32);
    char buf[512];
    size_t n = serializeBoardStateEvent(occupancy, buf, sizeof(buf));
    TEST_ASSERT_TRUE(n > 0);
    TEST_ASSERT_NOT_NULL(strstr(buf, "\"type\":\"board_state\""));
    // event has no id field
    TEST_ASSERT_NULL(strstr(buf, "\"id\""));
}

void setUp(void) {}
void tearDown(void) {}

int main(int argc, char **argv) {
    UNITY_BEGIN();
    RUN_TEST(test_parse_ping);
    RUN_TEST(test_parse_set_led);
    RUN_TEST(test_parse_invalid_json);
    RUN_TEST(test_parse_unknown_type);
    RUN_TEST(test_parse_missing_type);
    RUN_TEST(test_serialize_pong_response);
    RUN_TEST(test_serialize_board_state_event);
    return UNITY_END();
}
