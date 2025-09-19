terraform {
  backend "s3" {
    bucket         = "tfstate-brant-202509151432"
    region         = "us-east-2"
    dynamodb_table = "tf-locks"
    encrypt        = true

    # IMPORTANT: let workspaces choose the folder
    workspace_key_prefix = "envs"
    key                  = "terraform.tfstate"
  }
}

