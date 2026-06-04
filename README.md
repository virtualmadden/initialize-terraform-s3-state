# initialize-terraform-s3-state

One-time Terraform bootstrap to create an S3 bucket for remote state in an AWS account. This root uses **local state** so it can run before the remote backend exists.

## Usage

```bash
cp infrastructure/terraform/terraform.tfvars.example infrastructure/terraform/terraform.tfvars
# edit state_bucket_name in terraform.tfvars
./bootstrap.sh
```

Or pass the bucket name via environment (no tfvars file):

```bash
STATE_BUCKET_NAME=your-globally-unique-bucket-name ./bootstrap.sh
```

Skip the apply confirmation prompt:

```bash
./bootstrap.sh -y
```

After apply, the script prints a sample `backend "s3"` block for your other stacks (`terraform output backend_config`).

### Partial apply / bucket already exists

If apply fails with S3 `OperationAborted`, ensure no other apply is running, wait a few minutes, then either import an existing bucket or target the bucket resource first:

```bash
cd infrastructure/terraform
aws s3api head-bucket --bucket YOUR_BUCKET --region us-west-2
terraform import aws_s3_bucket.terraform_state YOUR_BUCKET
terraform apply
```
