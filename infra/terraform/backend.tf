@'
terraform {
  backend "s3" {
    bucket         = "<REPLACE_WITH_TFSTATE_BUCKET>"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
'@ | Out-File -FilePath infra/terraform/backend.tf -Encoding UTF8
