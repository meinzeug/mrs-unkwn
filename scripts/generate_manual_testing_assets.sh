#!/bin/bash
set -e
OUTPUT_DIR="codex/tests/manual/generated"
mkdir -p "$OUTPUT_DIR"

cat > "$OUTPUT_DIR/manual_test_checklist.csv" <<'EOC'
Test Area,Test,Status,Notes
Login,Login with valid credentials,,
Registration,Register a new user,,
Tutoring,Start a tutoring session and receive AI response,,
Analytics,View learning progress page,,
EOC

cat > "$OUTPUT_DIR/bug_report_template.csv" <<'EOC'
Field,Description
Summary,Short description
Steps to Reproduce,"Step1; Step2; Step3"
Expected Result,What should happen
Actual Result,What happened
Environment,"App version / Device / OS"
Additional Info,Optional
EOC

echo "Templates generated in $OUTPUT_DIR"
