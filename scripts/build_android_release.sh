#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_DIR="$SCRIPT_DIR/../flutter_app/mrs_unkwn_app"
cd "$APP_DIR"
flutter clean
flutter pub get
flutter gen-l10n
"$SCRIPT_DIR"/patch_geolocator_android.sh
dart run tool/fix_android_namespaces.dart
flutter build apk --release
