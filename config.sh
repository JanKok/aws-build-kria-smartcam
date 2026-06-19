#!/usr/bin/env bash
# aws-build-kria-smartcam/config.sh — Configuration for the smartcam EC2 build project.
# Source this file at the top of every script in this project.

# Locate aws-build-utils one level up from this file: aws-build-kria-smartcam/ → parent dir
AWS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../aws-build-utils" && pwd)"
source "$AWS_PATH/config.sh"           # pulls in AWS_REGION and SSH_KEY_PATH

INSTANCE_TYPE="c6i.4xlarge"           # EC2 instance type; many cores for parallel make -j$(nproc)
INSTANCE_PRICE_PER_HOUR="0.680"      # c6i.4xlarge on-demand price in us-east-1; verify at aws.amazon.com/ec2/pricing
AMI_ID="ami-028791b62b23efdd9"        # Ubuntu AMI used for the Xilinx build environment
KEY_PAIR_NAME="aws-build"              # name of the EC2 key pair to use for SSH access
INSTANCE_NAME="kria-build"            # EC2 Name tag used to identify this project's instance
ROOT_VOLUME_SIZE=100                  # root EBS volume size in GB; Xilinx toolchain is large
EBS_SIZE=50                           # extra EBS volume in GB for smartcam source and build artifacts

REMOTE_USER="ubuntu"                  # login user on the EC2 instance (matches Ubuntu AMI)
REMOTE_SRC="/data/smartcam"          # path on EC2 for source and build output (on EBS volume)
PAYLOAD_CMD="cmake . && make -j\$(nproc)"
EBS_MOUNT="/data"                     # mount point for the extra EBS volume on EC2

REPO_URL="https://github.com/Xilinx/smartcam.git"  # smartcam source repository
REPO_BRANCH="xlnx_rel_v2022.1"       # repository branch to build

DEPLOY_TARGET="192.168.0.42"         # IP address of the Kria device to deploy the binary to

# Paths relative to this config file so the project can live anywhere on disk
_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SRC="$_CONFIG_DIR/../smartcam"          # smartcam project root (contains CMakeLists.txt etc.)
LOCAL_BUILD="$_CONFIG_DIR/../smartcam/build"  # local directory that receives the compiled binary
STATE_DIR="$_CONFIG_DIR/.state"      # per-project EC2 state files (instance-id, instance-ip, volume-id)
