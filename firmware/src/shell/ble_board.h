#ifndef BLE_BOARD_H
#define BLE_BOARD_H

// BLE transport for the phone <-> board link. Implements the contract in the
// companion app's app/src/board/types.ts (BoardTransport) as JSON messages over
// two GATT characteristics:
//   CMD (app -> board, write):   setLEDs, scanWifi, provisionWifi
//   EVT (board -> app, notify):  status, move (lift/place), wifiList
// Replaces the old WiFi WebSocket path. WiFi still exists on the board, but only
// for board -> internet (Lichess / OTA), provisioned over BLE.
#include <Arduino.h>
#include <functional>
#include <vector>

struct LedCellMsg { int file; int rank; int r; int g; int b; };   // mirrors app LedCell
struct WifiNet   { String name; bool lock; int strength; };       // mirrors app WifiNetwork

class BleBoard {
 public:
  void begin(const String& name);
  bool connected() const;

  // board -> app (notify)
  void pushStatus(int battery, const String& firmware, const String& wifiSsid, int wifiStrength, bool lichessReady);
  void pushMove(const String& square, const char* kind);   // kind = "lift" | "place"
  void pushWifiList(const std::vector<WifiNet>& nets);
  void pushDebug(const String& line);                       // live debug log line

  // app -> board (set by main.cpp)
  std::function<void(const std::vector<LedCellMsg>&)> onSetLEDs;
  std::function<void()>                               onScanWifi;
  std::function<void(const String&, const String&)>  onProvisionWifi;

  // called by the BLE write callback (internal)
  void handleCommand(const String& json);

 private:
  void notify(const String& json);
};

extern BleBoard bleBoard;   // singleton the GATT callbacks dispatch to

#endif // BLE_BOARD_H
