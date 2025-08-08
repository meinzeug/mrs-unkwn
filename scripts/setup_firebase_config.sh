#!/bin/bash
set -e

APP_DIR="flutter_app/mrs_unkwn_app"
ANDROID_CONFIG="$APP_DIR/android/app/google-services.json"
IOS_CONFIG="$APP_DIR/ios/Runner/GoogleService-Info.plist"

if [ -z "$FIREBASE_ANDROID_CONFIG" ] || [ -z "$FIREBASE_IOS_CONFIG" ]; then
  echo "Set FIREBASE_ANDROID_CONFIG and FIREBASE_IOS_CONFIG environment variables with base64 encoded configs"
  exit 1
fi

mkdir -p "$(dirname "$ANDROID_CONFIG")" "$(dirname "$IOS_CONFIG")"
echo "$FIREBASE_ANDROID_CONFIG" | base64 -d > "$ANDROID_CONFIG"
echo "$FIREBASE_IOS_CONFIG" | base64 -d > "$IOS_CONFIG"
echo "Firebase configuration files generated."
