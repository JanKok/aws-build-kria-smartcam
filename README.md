# aws-build-kria-smartcam

EC2 build pipeline for the [Xilinx smartcam](../smartcam) application targeting the Kria KV260 board. Syncs the smartcam source to a c6i.4xlarge EC2 instance, builds with `cmake`/`make`, fetches the binary to `smartcam/build/`, and can deploy it to the Kria device over SSH.

## Prerequisites

- `aws-build-kria-smartcam`, `smartcam`, and `aws-build-utils` must all be checked out as siblings in the same parent directory.
- AWS CLI, SSH key pair, and other one-time setup steps are described in [aws-build-utils/SETUP-README.md](../aws-build-utils/SETUP-README.md).
- EC2 key pair named `aws-build` with the private key at the path configured in `aws-build-utils/config.sh`.
- Kria KV260 board reachable at `192.168.0.42` (for deployment).

## First-time setup

```bash
./create-instance.sh
```

Launches the EC2 instance, creates and mounts a 50 GB EBS volume at `/data`, clones the smartcam repository onto it, then stops the instance. Only needed once.

## Scripts

| Script | What it does |
|---|---|
| `build.sh` | Start EC2, sync source, cmake + make, fetch binary, stop EC2 |
| `local-build.sh` | Build smartcam locally with cmake/make |
| `deploy.sh` | Copy the binary to the Kria device and run a sanity check |
| `start.sh` | Start the EC2 instance |
| `stop.sh` | Stop the EC2 instance |
| `resize-instance.sh` | Change the EC2 instance type (instance must be stopped) |
| `create-instance.sh` | One-time setup: launch EC2, set up EBS, clone repo |

All scripts accept `--dry-run` to print what they would do without making changes.

## VS Code tasks

Open `aws-build.code-workspace` in VS Code. `Ctrl+Shift+B` runs **Build on EC2**. Other tasks are available via **Terminal → Run Task**.

## Configuration

Edit `config.sh` to change instance type, key pair, EBS size, deploy target, or local paths. `PAYLOAD_CMD` defines the build command run on EC2 and locally.
