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

variable "vpc_id" {
  description = "Existing VPC ID used by ALB and ECS"
  type        = string
}

variable "alb_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group IDs attached to the ALB"
  type        = list(string)
}

variable "ecs_private_subnet_ids" {
  description = "Private subnet IDs where ECS tasks run"
  type        = list(string)
}

variable "ecs_service_security_group_id" {
  description = "Security group ID for the ECS service/tasks"
  type        = string
}

variable "ecr_repo_uri" {
  description = "ECR repository URI, e.g. 8037....dkr.ecr.us-east-2.amazonaws.com/microservice"
  type        = string
}

variable "image_digest" {
  description = "Immutable image digest, e.g. sha256:abcd..."
  type        = string
}

# variables.tf
variable "alb_name"       { type = string }
variable "tg_name"        { type = string }
variable "listener_port"  { type = number  default = 80 }
