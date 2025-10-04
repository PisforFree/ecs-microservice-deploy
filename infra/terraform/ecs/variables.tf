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
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_service_security_group_id" {
  description = "Security Group ID for the ECS service/tasks (allows inbound from ALB SG on 80)"
  type        = string
}

variable "target_group_arn" {
  description = "ALB Target Group ARN for the service"
  type        = string
}

variable "ecr_repo_uri" {
  description = "Base ECR repo URI (no tag/digest). Example: 803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice"
  type        = string
}

variable "image_digest" {
  description = "Full SHA256 digest string (include sha256: prefix)."
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Logs group name for the app container"
  type        = string
}

variable "log_stream_prefix" {
  description = "CloudWatch Logs stream prefix"
  type        = string
  default     = "micro-dev-app"
}
