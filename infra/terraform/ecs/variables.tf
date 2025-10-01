variable "project_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_service_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecr_repo_uri" {
  description = "Base ECR repo URI (no tag/digest). Example: 803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice"
  type        = string
}

variable "image_digest" {
  description = "Full SHA256 digest string (include sha256: prefix)."
  type        = string
}

