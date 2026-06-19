#!/usr/bin/env bash
# aws-build-kria-smartcam/start.sh — Start the smartcam project's EC2 instance manually.
# Useful for SSH debugging sessions outside of the normal build pipeline.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
"$AWS_PATH/start.sh"
