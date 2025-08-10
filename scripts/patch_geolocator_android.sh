#!/usr/bin/env bash
set -euo pipefail
PLUGIN_DIR="$(flutter pub cache path geolocator_android 2>/dev/null || true)"
if [[ -z "${PLUGIN_DIR}" ]]; then
  PLUGIN_DIR="$HOME/.pub-cache/hosted/pub.dev/geolocator_android-5.0.2"
fi
TARGET_FILE="$PLUGIN_DIR/lib/src/types/foreground_settings.dart"
if [[ -f "$TARGET_FILE" ]]; then
  sed -i "s/color?.toARGB32()/color?.value/" "$TARGET_FILE"
fi
