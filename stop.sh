#!/usr/bin/env bash
# aws-build-kria-smartcam/stop.sh — Stop the smartcam project's EC2 instance manually.
# Use this if the instance was left running after a failed or interrupted build.
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
"$AWS_BUILD_UTILS/stop.sh"
