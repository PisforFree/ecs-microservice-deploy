variable "region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_prefix" {
  description = "Resource name prefix (e.g., micro)"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}

variable "image_uri" {
  description = "ECR image URI (prefer a pinned digest)"
  type        = string
}