#!/usr/bin/env bash
# aws-build-kria-smartcam/build.sh — Full build pipeline: start EC2, sync smartcam source,
# run cmake and make, fetch the compiled binary, stop EC2. Can be run from any directory.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$AWS_PATH/args.sh" "$@"

"$AWS_PATH/start.sh"

INSTANCE_IP=$(cat "$STATE_DIR/instance-ip")

RSYNC_EXTRA_OPTS="--exclude=.git --exclude=build"
"$AWS_PATH/dry-run-check.sh" || exit 0

echo "=== Syncing smartcam source to EC2 ==="
rsync -avz \
  $RSYNC_EXTRA_OPTS \
  -e "ssh -i \"$SSH_KEY_PATH\" -o StrictHostKeyChecking=no" \
  "$LOCAL_SRC/" \
  "$REMOTE_USER@$INSTANCE_IP:$REMOTE_SRC/"

echo "=== Building smartcam on EC2 ==="
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$REMOTE_USER@$INSTANCE_IP" \
  "cd $REMOTE_SRC && $PAYLOAD_CMD"

echo "=== Fetching build artifact ==="
mkdir -p "$LOCAL_BUILD"
rsync -avz \
  -e "ssh -i \"$SSH_KEY_PATH\" -o StrictHostKeyChecking=no" \
  "$REMOTE_USER@$INSTANCE_IP:$REMOTE_SRC/build/smartcam" \
  "$LOCAL_BUILD/"

echo "=== Stopping EC2 instance ==="
"$AWS_PATH/stop.sh"

echo "=== Build complete. Binary is at $LOCAL_BUILD/smartcam ==="
