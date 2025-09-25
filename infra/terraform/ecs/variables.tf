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
  type = list(string)
}

variable "ecs_service_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}
