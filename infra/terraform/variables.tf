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
variable "alb_name" {
  type        = string
  description = "Pre-existing ALB name"
}

variable "tg_name" {
  type        = string
  description = "Pre-existing Target Group name"
}

variable "listener_port" {
  type        = number
  description = "Listener port to read (typically 80)"
  default     = 80
}

variable "create_network_primitives" {
  description = "Create IGW/NAT/RTs in this module (false when reusing existing VPC networking)"
  type        = bool
  default     = false
}

variable "existing_private_route_table_id" {
  description = "Existing private RTB to add 0.0.0.0/0 NAT route to"
  type        = string
}

variable "existing_nat_gateway_id" {
  description = "Existing NAT Gateway ID used for private egress"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Override ECS cluster name if it doesn't follow the default pattern"
  type        = string
  default     = null
}

variable "ecs_service_name" {
  description = "Override ECS service name if it doesn't follow the default pattern"
  type        = string
  default     = null
}

variable "alb_arn_suffix" {
  description = "ALB arn_suffix like app/micro-dev-alb/xxxxxxxx"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target Group arn_suffix like targetgroup/micro-dev-tg-80/yyyyyyyy"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to notify from CloudWatch alarms"
  type        = string
}

