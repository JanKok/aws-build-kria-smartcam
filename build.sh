#!/usr/bin/env bash
# aws-build-kria-smartcam/build.sh — Full build pipeline: start EC2, sync smartcam source,
# run cmake and make, fetch the compiled binary, stop EC2. Can be run from any directory.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$AWS_BUILD_UTILS/args.sh" "$@"

"$AWS_BUILD_UTILS/start.sh"

INSTANCE_IP=$(cat "$STATE_DIR/instance-ip")

"$AWS_BUILD_UTILS/dry-run-check.sh" || exit 0

echo "=== Syncing smartcam source to EC2 ==="
if [ -n "$MKDIR_REMOTE_DIRS" ]; then
  ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$REMOTE_USER@$INSTANCE_IP" \
    "mkdir -p $MKDIR_REMOTE_DIRS"
fi
rsync -avz \
  $RSYNC_EXTRA_OPTS \
  -e "ssh -i \"$SSH_KEY_PATH\" -o StrictHostKeyChecking=no" \
  "$LOCAL_SRC/" \
  "$REMOTE_USER@$INSTANCE_IP:$REMOTE_SRC/"

echo "=== Building smartcam on EC2 ==="
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$REMOTE_USER@$INSTANCE_IP" \
  "cd $REMOTE_SRC && $PAYLOAD_CMD"

echo "=== Fetching build artifact ==="
if [ -n "$MKDIR_LOCAL_DIRS" ]; then
  mkdir -p "$MKDIR_LOCAL_DIRS"
fi
rsync -avz \
  -e "ssh -i \"$SSH_KEY_PATH\" -o StrictHostKeyChecking=no" \
  "$REMOTE_USER@$INSTANCE_IP:$REMOTE_SRC/build/smartcam" \
  "$LOCAL_BUILD/"

echo "=== Stopping EC2 instance ==="
"$AWS_BUILD_UTILS/stop.sh"

echo "=== Build complete. Binary is at $LOCAL_BUILD/smartcam ==="
