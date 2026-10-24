// Minimal Arduino stub for native unit tests of engine code.
// Only what src/engine sources actually touch: ctype, stdint, String, millis.
#pragma once
#include <stdint.h>
#include <ctype.h>
#include <stdlib.h>
#include <string>
#include <chrono>
typedef std::string String;
#define PROGMEM
inline uint32_t millis() {
  using namespace std::chrono;
  static auto t0 = steady_clock::now();
  return (uint32_t)duration_cast<milliseconds>(steady_clock::now() - t0).count();
}
