variable "region" { type = string }
variable "project_prefix" { type = string }
variable "env" { type = string }

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "use_fargate_spot_weight" {
  description = "Set >0 to mix in SPOT. Keep 0 in dev for predictability."
  type        = number
  default     = 0
}
