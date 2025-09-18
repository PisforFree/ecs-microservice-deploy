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
# trigger workflow
# pr-trigger

variable "image_uri" {
  description = "ECR image URI for the ECS task definition"
  type        = string
}
