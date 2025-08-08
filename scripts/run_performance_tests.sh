#!/bin/bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/../flutter_app/mrs_unkwn_app" && pwd)"
cd "$APP_DIR"

mkdir -p build/performance
flutter test integration_test/performance_test.dart --reporter json > build/performance/performance_results.json

echo "Performance tests completed. See build/performance for details."
