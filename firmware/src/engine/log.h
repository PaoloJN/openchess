#ifndef OPENCHESS_ENGINE_LOG_H
#define OPENCHESS_ENGINE_LOG_H

#include <Print.h>

// Engine code logs through this reference. Default impl writes to Serial.
// The shell may rebind it (e.g., to a WebSocket sink) by reassigning.
extern Print& engineLog;

#endif
