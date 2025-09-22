@'
variable "region"         { type = string  default = "us-east-2" }
variable "project_prefix" { type = string  default = "micro" }
variable "env"            { type = string  default = "dev" }
'@ | Out-File -FilePath infra/terraform/variables.tf -Encoding UTF8
