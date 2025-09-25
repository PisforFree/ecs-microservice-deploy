terraform {
  backend "s3" {
    bucket         = "tfstate-brant-202509221842"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-locks"
    encrypt        = true
  }
}
