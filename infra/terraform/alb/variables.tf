variable "project_prefix" {
  type        = string
  description = "Project prefix (e.g., micro)"
}

variable "env" {
  type        = string
  description = "Environment (e.g., dev)"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID where the ALB and TG live"
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "Existing public subnet IDs for the ALB"
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the ALB"
}

variable "app_port" {
  type        = number
  description = "Application port (must match ECS service containerPort)"
}

variable "health_check_path" {
  type        = string
  description = "Health check path for the target group"
  default     = "/"
}

