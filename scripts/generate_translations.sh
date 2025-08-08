#!/bin/bash
set -e
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_DIR="$SCRIPT_DIR/../flutter_app/mrs_unkwn_app"
cd "$APP_DIR"
flutter gen-l10n --arb-dir=lib/l10n --template-arb-file=app_en.arb --output-localization-file=app_localizations.dart

