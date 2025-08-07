#!/bin/bash
set -e

APP_DIR="flutter_app"
PROJECT_NAME="mrs_unkwn_app"
ORG="com.mrsunkwn"
PLATFORMS="android,ios,web,windows,macos,linux"

# Ensure flutter is installed
command -v flutter >/dev/null 2>&1 || { echo "flutter not installed"; exit 1; }

TARGET_DIR="$APP_DIR/$PROJECT_NAME"

if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$APP_DIR"
  flutter create --org "$ORG" --platforms $PLATFORMS "$TARGET_DIR"
fi

PUBSPEC="$TARGET_DIR/pubspec.yaml"
if [ -f "$PUBSPEC" ]; then
  perl -0pi -e 's/sdk: ">=([0-9]+\.[0-9]+\.[0-9]+)/sdk: ">=3.16.0/' "$PUBSPEC"
fi

MAIN_DART="$TARGET_DIR/lib/main.dart"
if [ -f "$MAIN_DART" ]; then
  cat <<'EOF2' > "$MAIN_DART"
import 'package:flutter/widgets.dart';

void main() {
  runApp(const Placeholder());
}
EOF2
fi

for dir in core features shared platform_channels; do
  mkdir -p "$TARGET_DIR/lib/$dir"
done

echo "Flutter project prepared at $TARGET_DIR"
