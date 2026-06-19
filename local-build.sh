#!/usr/bin/env bash
# aws-build-kria-smartcam/local-build.sh — Build smartcam on this machine using cmake/make.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

echo "=== Building smartcam locally ==="
cd "$LOCAL_SRC"
mkdir -p "$LOCAL_BUILD"
eval "$PAYLOAD_CMD"
echo "=== Build complete. Binary is at $LOCAL_BUILD/smartcam ==="
