#!/bin/bash
# Generates placeholder badge icons using ImageMagick.
set -e

# Ensure ImageMagick's convert is available
if ! command -v convert >/dev/null 2>&1; then
  echo "Error: ImageMagick 'convert' command not found. Please install ImageMagick." >&2
  exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
OUTPUT_DIR="$SCRIPT_DIR/../flutter_app/mrs_unkwn_app/assets/badges"
mkdir -p "$OUTPUT_DIR"

BADGES=("novice" "intermediate" "expert")

for badge in "${BADGES[@]}"; do
  convert -size 200x200 canvas:transparent \
    -fill "#FFD700" -stroke black -strokewidth 2 \
    -draw "circle 100,100 100,10" \
    -gravity center -pointsize 24 -fill black \
    -annotate 0 "$badge" "$OUTPUT_DIR/${badge}.png"
  echo "Created $OUTPUT_DIR/${badge}.png"
done

echo "Badge icons generated in $OUTPUT_DIR"
