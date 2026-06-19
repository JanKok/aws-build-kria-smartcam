#!/usr/bin/env bash
# aws-build-kria-smartcam/resize-instance.sh — Change the kria-build EC2 instance type.
# Usage: resize-instance.sh <instance-type>  (e.g. c6i.8xlarge)
set -e

source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
"$AWS_PATH/resize-instance.sh" "$@"
