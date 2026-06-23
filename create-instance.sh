#!/usr/bin/env bash
# aws-build-kria-smartcam/create-instance.sh — One-time setup: launch a new EC2 instance,
# create and attach an EBS volume, format and mount it, clone the smartcam repository,
# then stop the instance. Run this once before the first build.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$AWS_BUILD_UTILS/args.sh" "$@"

"$AWS_BUILD_UTILS/launch.sh"

INSTANCE_IP=$(cat "$STATE_DIR/instance-ip")

echo "=== Formatting and mounting EBS volume ==="
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no "$REMOTE_USER@$INSTANCE_IP" << ENDSSH
  sudo mkfs.ext4 /dev/nvme1n1
  sudo mkdir -p $EBS_MOUNT
  sudo mount /dev/nvme1n1 $EBS_MOUNT
  sudo chown $REMOTE_USER:$REMOTE_USER $EBS_MOUNT
  echo '/dev/nvme1n1 $EBS_MOUNT ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
ENDSSH

echo "=== Cloning smartcam source ==="
ssh -i "$SSH_KEY_PATH" "$REMOTE_USER@$INSTANCE_IP" \
  "git clone --recursive --branch $REPO_BRANCH $REPO_URL $REMOTE_SRC"

echo "=== Stopping instance after setup ==="
"$AWS_BUILD_UTILS/stop.sh"

echo ""
echo "Instance created. ID saved to $STATE_DIR/instance-id"
echo "Run build.sh to compile the smartcam binary."
