#ifndef OTA_UPDATER_H
#define OTA_UPDATER_H

#include <Arduino.h>

// Forward declarations
class BoardDriver;
class HTTPClient;

// OTA update check result
struct OtaUpdateInfo {
  bool available;
  String version;
  String firmwareUrl;
  String webAssetsUrl;
};

class OtaUpdater {
 public:
  OtaUpdater(BoardDriver* boardDriver);

  OtaUpdateInfo checkForUpdate();

  bool applyFirmwareFromUrl(const String& url);

  bool applyWebAssetsFromUrl(const String& url);

  bool applyWebAssetsFromStream(Stream& stream, size_t contentLength);

  static const char* getCurrentVersion();

  // Apply web assets + firmware from an OtaUpdateInfo (used by autoUpdate and web UI apply).
  // Applies web assets first, then firmware. Firmware triggers reboot on success.
  void applyUpdate(const OtaUpdateInfo& info);

 private:
  BoardDriver* boardDriver;

  // Compare semantic versions. Returns true if remote is newer than current.
  static bool isNewerVersion(const String& current, const String& remote);

  // Configure an HTTPClient and perform a GET request. Returns true on HTTP 200.
  // On success, caller must call http.end(). On failure, http.end() is called internally.
  static bool beginHttpGet(HTTPClient& http, const String& url, int timeoutMs = 10000);

  // Read exactly 'length' bytes from a stream with timeout. Returns actual bytes read.
  static size_t readStreamBytes(Stream& stream, uint8_t* buffer, size_t length, unsigned long timeoutMs = 10000);

  // Skip the TAR data blocks for an entry of the given file size. Updates bytesProcessed.
  static bool skipTarBlocks(Stream& stream, size_t fileSize, size_t& bytesProcessed);

  // Recursively remove all LittleFS files except those under /games/
  static void removeWebAssets(const String& dirPath = "/");
};

#endif // OTA_UPDATER_H
