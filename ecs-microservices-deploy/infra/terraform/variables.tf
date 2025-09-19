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

# ECS identifiers for autoscaling
variable "ecs_cluster_name" {
  description = "Exact ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "Exact ECS service name"
  type        = string
}

# Scaling settings
variable "min_task_count" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "max_task_count" {
  description = "Maximum number of tasks"
  type        = number
  default     = 4
}

variable "cpu_target_percent" {
  description = "Target average CPU utilization for the service"
  type        = number
  default     = 50
}

variable "scale_in_cooldown" {
  description = "Seconds to wait after a scale in activity"
  type        = number
  default     = 120
}

variable "scale_out_cooldown" {
  description = "Seconds to wait after a scale out activity"
  type        = number
  default     = 60
}