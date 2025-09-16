variable "region" {
  type    = string
  default = "us-east-2"
}

variable "project_prefix" {
  type    = string
  default = "micro"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "image_uri" {
  description = "ECR image URI with digest"
  type        = string
}


# noop: trigger plan workflow
