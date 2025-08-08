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

  if ! grep -q "dio:" "$PUBSPEC"; then
    perl -0pi -e 's/dependencies:\n/dependencies:\n  dio: ^5.3.0\n  flutter_bloc: ^8.1.3\n  get_it: ^7.6.0\n  flutter_secure_storage: ^9.0.0\n  go_router: ^12.0.0\n  hive: ^2.2.3\n  hive_flutter: ^1.1.0\n  json_annotation: ^4.8.1\n  speech_to_text: ^6.6.1\n/' "$PUBSPEC"
  elif ! grep -q "speech_to_text:" "$PUBSPEC"; then
    perl -0pi -e 's/dependencies:\n/dependencies:\n  speech_to_text: ^6.6.1\n/' "$PUBSPEC"
  fi
  if ! grep -q "mocktail:" "$PUBSPEC"; then
    perl -0pi -e 's/dev_dependencies:\n/dev_dependencies:\n  build_runner: ^2.4.7\n  json_serializable: ^6.7.1\n  flutter_test:\n    sdk: flutter\n  mocktail: ^1.0.0\n  bloc_test: ^9.1.0\n  mockito: ^5.4.2\n/' "$PUBSPEC"
  elif ! grep -q "bloc_test:" "$PUBSPEC"; then
    perl -0pi -e 's/mocktail: \^1.0.0/mocktail: ^1.0.0\n  bloc_test: ^9.1.0\n  mockito: ^5.4.2/' "$PUBSPEC"
  elif ! grep -q "mockito:" "$PUBSPEC"; then
    perl -0pi -e 's/bloc_test: \^9.1.0/bloc_test: ^9.1.0\n  mockito: ^5.4.2/' "$PUBSPEC"
  fi
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
