locals {
  name = "${var.project_prefix}-${var.env}"
}

# ---------- Reuse default VPC/Subnets when requested ----------
data "aws_vpc" "default" {
  count   = var.use_default_vpc ? 1 : 0
  default = true
}

# default VPC has one "default subnet" per AZ (public, mapPublicIpOnLaunch = true)
data "aws_subnets" "default_public" {
  count = var.use_default_vpc ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

# ---------- Create-your-own VPC branch (disabled when use_default_vpc = true) ----------
resource "aws_vpc" "this" {
  count                = var.use_default_vpc ? 0 : 1
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${local.name}-vpc"
    Project = var.project_prefix
    Env     = var.env
    Managed = "terraform"
  }
}

# ... (all your existing resources like igw, public/private subnets, route tables,
# NAT, EIP, etc.) should be wrapped with:
#   count = var.use_default_vpc ? 0 : 1
# and any references to the VPC ID should use:
#   var.use_default_vpc ? data.aws_vpc.default[0].id : aws_vpc.this[0].id
#
# Keep those resources as-is, just add the conditional "count" to turn them off
# when using the default VPC.

# ---------- Locals that unify outputs regardless of branch ----------
locals {
  chosen_vpc_id = var.use_default_vpc ? data.aws_vpc.default[0].id : aws_vpc.this[0].id

  # When creating our own VPC, replace these with your module's public subnet IDs.
  # For the default VPC branch, we simply take the default public subnets.
  chosen_public_subnet_ids = var.use_default_vpc ?
    data.aws_subnets.default_public[0].ids :
    flatten([
      # example: aws_subnet.public[*].id
      aws_subnet.public[*].id
    ])

  # If your ECS module expects private subnets but we're using default VPC,
  # just reuse public subnets (we'll set assign_public_ip=true in ECS).
  chosen_private_subnet_ids = var.use_default_vpc ?
    data.aws_subnets.default_public[0].ids :
    flatten([
      # example: aws_subnet.private[*].id
      aws_subnet.private[*].id
    ])
}
