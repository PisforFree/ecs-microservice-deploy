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

variable "alb_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the ALB"
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the ALB and TG live"
}

variable "ecr_repo_uri" {
  description = "Base ECR repo URI (no tag/digest). Example: 803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice"
  type        = string
}

variable "image_digest" {
  description = "SHA256 digest for the image to deploy (without the 'sha256:' prefix is invalid; include full sha256:...)."
  type        = string
}

variable "ecr_repo_uri" { type = string }
variable "image_digest" { type = string }
