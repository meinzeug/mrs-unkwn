#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SDK_DIR="$ROOT_DIR/backend/sdk"
DIST_DIR="$SDK_DIR/dist"

mkdir -p "$DIST_DIR"

cd "$ROOT_DIR/backend"
npx tsc "$SDK_DIR/index.ts" --module commonjs --target ES2020 --lib ES2020 --moduleResolution node --types node --outDir "$DIST_DIR"
echo "SDK built at $DIST_DIR"
