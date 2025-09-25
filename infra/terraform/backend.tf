terraform {
  backend "s3" {
    bucket               = "tfstate-brant-202509221842"
    key                  = "terraform.tfstate" # state file name only
    workspace_key_prefix = "envs"              # workspace folder prefix
    region               = "us-east-2"
    dynamodb_table       = "tf-locks"
    encrypt              = true
  }
}
