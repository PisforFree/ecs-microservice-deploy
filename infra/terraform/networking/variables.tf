variable "region" { type = string }
variable "project_prefix" { type = string }
variable "env" { type = string }

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

# Two AZs for dev: us-east-2b, us-east-2c
variable "azs" {
  type    = list(string)
  default = ["us-east-2b", "us-east-2c"]
}

# Small /24s for simplicity & cost
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}
