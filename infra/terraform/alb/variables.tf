variable "region" { type = string }
variable "project_prefix" { type = string }
variable "env" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" { type = string }

# Must match the app/container port your service exposes
variable "app_port" {
  type    = number
  default = 3000
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "deregistration_delay" {
  type    = number
  default = 15
}
