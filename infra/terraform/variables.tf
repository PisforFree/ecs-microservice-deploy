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