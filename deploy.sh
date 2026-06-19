#!/usr/bin/env bash
# aws-build-kria-smartcam/deploy.sh — Deploy the compiled smartcam binary to the Kria device
# and run a quick sanity test. The Kria device must be reachable at $DEPLOY_TARGET.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

BINARY="$LOCAL_BUILD/smartcam"
if [ ! -f "$BINARY" ]; then
  echo "Error: binary not found at $BINARY — run build.sh first." >&2
  exit 1
fi

echo "=== Deploying smartcam to Kria at $DEPLOY_TARGET ==="
rsync -avz -e "ssh -i \"$SSH_KEY_PATH\"" \
  "$BINARY" \
  "$REMOTE_USER@$DEPLOY_TARGET:/tmp/smartcam"
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$DEPLOY_TARGET" "/tmp/smartcam --help"
