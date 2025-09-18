// variables.tf — clean version (no conflict markers)

variable "region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_prefix" {
  description = "Short prefix used for naming resources (e.g., 'micro')"
  type        = string
}

variable "env" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

variable "image_uri" {
  description = "Full ECR image URI (prefer a pinned digest, e.g., 803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice@sha256:...)"
  type        = string
}
