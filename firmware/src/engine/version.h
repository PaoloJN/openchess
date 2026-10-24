#ifndef VERSION_H
#define VERSION_H

// Local builds use the default version below.
// The GitHub Actions workflow replaces this with the actual tag version.
#define FIRMWARE_VERSION "dev"
#define DEV_BUILD

// GitHub repository for OTA update checks
#define OTA_GITHUB_API_URL "https://api.github.com/repos/joojoooo/OpenChess/releases/latest"

#endif // VERSION_H
