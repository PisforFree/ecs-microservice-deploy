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
  description = "List of security group IDs to attach to the ALB"
}
