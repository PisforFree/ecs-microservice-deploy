terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region # us-east-2
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
# Day-5 policy test: no-op change
