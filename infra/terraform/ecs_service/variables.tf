variable "region" { type = string }
variable "project_prefix" { type = string }
variable "env" { type = string }

# Networking & security (from modules you created)
variable "private_subnet_ids" { type = list(string) }
variable "ecs_tasks_sg_id" { type = string }

# ALB Target Group to register tasks to
variable "target_group_arn" { type = string }

# ECS cluster & IAM roles from ECS module
variable "ecs_cluster_name" { type = string }
variable "task_execution_role_arn" { type = string }
variable "task_role_arn" { type = string }

# Image pinned by digest
variable "image_uri" {
  description = "Full ECR image URI with digest, e.g. 123456789012.dkr.ecr.us-east-2.amazonaws.com/microservice@sha256:..."
  type        = string
}

# Container settings
variable "container_name" {
  type    = string
  default = "app"
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "cpu" {
  type    = number
  default = 256 # 0.25 vCPU
}

variable "memory" {
  type    = number
  default = 512 # 0.5 GB
}

# Logs
variable "log_group_name" { type = string }

variable "log_stream_prefix" {
  type    = string
  default = "ecs"
}

# Service scaling
variable "desired_count" {
  type    = number
  default = 1
}

# Optional env vars for the container (simple map)
variable "env_vars" {
  type    = map(string)
  default = {}
}
