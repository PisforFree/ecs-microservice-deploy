resource "aws_subnet" "public" {
  for_each = { for i, cidr in var.public_subnet_cidrs : i => {
    cidr = cidr
    az   = var.azs[i]
  } }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_prefix}-${var.env}-public-${each.value.az}"
    tier    = "public"
    project = var.project_prefix
    env     = var.env
  }
}

resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.private_subnet_cidrs : i => {
    cidr = cidr
    az   = var.azs[i]
  } }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name    = "${var.project_prefix}-${var.env}-private-${each.value.az}"
    tier    = "private"
    project = var.project_prefix
    env     = var.env
  }
}
