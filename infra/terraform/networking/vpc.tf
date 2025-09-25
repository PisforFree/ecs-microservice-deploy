resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project_prefix}-${var.env}-vpc"
    project = var.project_prefix
    env     = var.env
  }
}
