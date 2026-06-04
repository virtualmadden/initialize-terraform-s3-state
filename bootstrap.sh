#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="${SCRIPT_DIR}/infrastructure/terraform"

usage() {
  cat <<EOF
Usage: $(basename "$0") [-y]

Create the Terraform remote state S3 bucket in the current AWS account/credentials.

Configuration (pick one):
  - infrastructure/terraform/terraform.tfvars  (copy from terraform.tfvars.example)
  - STATE_BUCKET_NAME env var (optional: AWS_REGION, default us-west-2)

Options:
  -y   Pass -auto-approve to terraform apply
  -h   Show this help
EOF
}

AUTO_APPROVE=()
while getopts "yh" opt; do
  case "$opt" in
    y) AUTO_APPROVE=(-auto-approve) ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

if ! command -v terraform >/dev/null 2>&1; then
  echo "error: terraform is not installed or not on PATH" >&2
  exit 1
fi

cd "$TF_DIR"

VAR_ARGS=()
if [[ -f terraform.tfvars ]]; then
  :
elif [[ -n "${STATE_BUCKET_NAME:-}" ]]; then
  VAR_ARGS+=(-var="state_bucket_name=${STATE_BUCKET_NAME}")
  if [[ -n "${AWS_REGION:-}" ]]; then
    VAR_ARGS+=(-var="aws_region=${AWS_REGION}")
  fi
else
  echo "error: create terraform.tfvars or set STATE_BUCKET_NAME" >&2
  echo >&2
  usage >&2
  exit 1
fi

terraform init
terraform apply "${AUTO_APPROVE[@]}" "${VAR_ARGS[@]}"

echo
terraform output backend_config
