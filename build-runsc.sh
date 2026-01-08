#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "building patched runsc for linux amd64"
echo "working directory: $SCRIPT_DIR"

echo "starting docker container..."
docker run --rm -it \
  --platform linux/amd64 \
  -v "$(pwd):/src" \
  -w /src \
  golang:1.22-bookworm \
  /src/build-inside-container.sh

echo "build complete"
echo "binary: $SCRIPT_DIR/runsc-patched"
file "$SCRIPT_DIR/runsc-patched"
