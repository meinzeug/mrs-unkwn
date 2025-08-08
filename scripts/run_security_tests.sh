#!/bin/bash
set -e

# Backend security tests and vulnerability scan
(cd backend && npm test)
(cd backend && npm audit || true)

# Flutter security tests
cd flutter_app/mrs_unkwn_app

dart format test/security/security_test.dart >/tmp/format.log && cat /tmp/format.log
flutter analyze || true
flutter test test/security/security_test.dart || true

