#!/bin/bash
set -e
PROJECT_DIR="flutter_app/mrs_unkwn_app"
cd "$PROJECT_DIR"
mkdir -p test/goldens
flutter test --update-goldens test/widget/*_golden_test.dart
