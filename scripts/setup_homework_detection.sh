#!/bin/bash
set -e

MODEL_DIR="$(dirname "$0")/../backend/data"
MODEL_FILE="$MODEL_DIR/homework_model.bin"

mkdir -p "$MODEL_DIR"

if [ ! -f "$MODEL_FILE" ]; then
  echo "Downloading homework detection model..."
  curl -L -o "$MODEL_FILE" "https://example.com/models/homework_model.bin"
  echo "Model downloaded to $MODEL_FILE"
else
  echo "Model already exists at $MODEL_FILE"
fi
