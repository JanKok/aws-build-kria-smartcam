#!/usr/bin/env bash
# aws-build-kria-smartcam/config.sh — Configuration for the smartcam EC2 build project.
# Source this file at the top of every script in this project.

# Get the paths to 3 important projects:
# AWS_BUILD_CONFIG — this project, which contains config.sh and get-ami-id.sh
export AWS_BUILD_CONFIG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# AWS_BUILD_UTILS — shared utilities for AWS build operations (launch, stop, ssh, etc.)
export AWS_BUILD_UTILS="$(cd "$AWS_BUILD_CONFIG/../aws-build-utils" && pwd)"
# PROJECT - the root of the actual project being built (smartcam in this case)
export PROJECT_NAME="smartcam"
export PROJECT="$(cd "$AWS_BUILD_CONFIG/../$PROJECT_NAME" && pwd)"

export STATE_DIR="$AWS_BUILD_CONFIG/.state"     # per-project EC2 state files (instance-id, instance-ip, volume-id)

source "$AWS_BUILD_UTILS/config.sh"             # pulls in AWS_REGION and SSH_KEY_PATH

export INSTANCE_TYPE="c6i.4xlarge"              # EC2 instance type; many cores for parallel make -j$(nproc)
export INSTANCE_PRICE_PER_HOUR="0.680"          # c6i.4xlarge on-demand price in us-east-1; verify at aws.amazon.com/ec2/pricing
export AMI_ID="ami-028791b62b23efdd9"           # Ubuntu AMI used for the Xilinx build environment
export KEY_PAIR_NAME="aws-build"                # name of the EC2 key pair to use for SSH access
export INSTANCE_NAME="kria-build"               # EC2 Name tag used to identify this project's instance
export ROOT_VOLUME_SIZE=100                     # root EBS volume size in GB; Xilinx toolchain is large
export EBS_SIZE=50                              # extra EBS volume in GB for smartcam source and build artifacts

export REMOTE_USER="ubuntu"                     # login user on the EC2 instance (matches Ubuntu AMI)
export EBS_MOUNT="/data"                        # mount point for the extra EBS volume on EC2
export REMOTE_PROJECT="$EBS_MOUNT/$PROJECT_NAME" # path on EC2 for the entire project (on EBS volume)
export REMOTE_SRC="$REMOTE_PROJECT"             # path on EC2 for source (on EBS volume)
export REMOTE_BIN="$REMOTE_PROJECT/build"       # path on EC2 for the compiled binary (on EBS volume)
export LOCAL_SRC="$PROJECT"                     # smartcam project root (contains CMakeLists.txt etc.)
export LOCAL_BUILD="$PROJECT/build"             # local directory that receives the compiled binary

# For local to remote rsync, don't sync .git and build folders.
export RSYNC_EXTRA_OPTS="--exclude=.git --exclude=build"

export REPO_URL="https://github.com/Xilinx/smartcam.git"  # smartcam source repository
export REPO_BRANCH="xlnx_rel_v2022.1"           # repository branch to build

export DEPLOY_TARGET="192.168.0.42"             # IP address of the Kria device to deploy the binary to

# PAYLOAD_CMD is the command that will be run to perform the build.
export PAYLOAD_CMD="cmake . && make -j\$(nproc)"
