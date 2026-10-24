#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WEB_OUT="$ROOT/web/out"
FW_DATA="$ROOT/firmware/data"

if [ ! -d "$WEB_OUT" ]; then
    echo "web/out/ not found - run 'npm run build' in web/ first"
    exit 1
fi

rm -rf "$FW_DATA"
mkdir -p "$FW_DATA"
cp -R "$WEB_OUT"/. "$FW_DATA"/

echo "Embedded $(find "$FW_DATA" -type f | wc -l | tr -d ' ') files into firmware/data/"
du -sh "$FW_DATA"
