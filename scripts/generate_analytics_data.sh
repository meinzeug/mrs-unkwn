#!/bin/bash
# Generates demo analytics data for the Flutter app.
set -e

OUTPUT="flutter_app/mrs_unkwn_app/assets/analytics/demo_data.json"
mkdir -p "$(dirname "$OUTPUT")"
cat > "$OUTPUT" <<'JSON'
{
  "sessions": [
    {"id": "s1", "subject": "math", "minutes": 30, "questions": 15},
    {"id": "s2", "subject": "english", "minutes": 20, "questions": 10}
  ]
}
JSON

echo "Demo analytics data written to $OUTPUT"
