#!/bin/bash
set -e

PROJECT_DIR="flutter_app/mrs_unkwn_app"
cd "$PROJECT_DIR"

flutter test --coverage

if command -v lcov >/dev/null 2>&1; then
  lcov --summary coverage/lcov.info
fi
