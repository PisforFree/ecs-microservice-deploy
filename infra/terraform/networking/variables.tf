variable "project_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.32.0/20", "10.0.48.0/20"]
}

variable "app_port" {
  type    = number
  default = 3000
}

# When reusing existing networking
variable "existing_private_route_table_id" {
  description = "Existing private RTB ID to add default NAT route to (e.g., rtb-0cfd187c223fc7632)"
  type        = string
  default     = ""
}

variable "existing_nat_gateway_id" {
  description = "Existing NAT GW ID to route 0.0.0.0/0 to (e.g., nat-06063c10377fba6a0)"
  type        = string
  default     = ""
}
