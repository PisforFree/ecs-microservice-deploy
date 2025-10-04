# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_prefix}-${var.env}-igw"
  }
}

# One NAT Gateway (cost-aware) in first public subnet
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "${var.project_prefix}-${var.env}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = { Name = "${var.project_prefix}-${var.env}-nat" }
}

# Public route table (0.0.0.0/0 -> IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project_prefix}-${var.env}-public-rt" }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

# Private route table (0.0.0.0/0 -> NAT)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project_prefix}-${var.env}-private-rt" }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}

# Ensure existing private RTB points 0.0.0.0/0 to the existing NAT
resource "aws_route" "existing_private_default_to_nat" {
  route_table_id         = var.existing_private_route_table_id # rtb-0cfd187c223fc7632
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.existing_nat_gateway_id # nat-06063c10377fba6a0
}
