# Private subnets default route to NAT
resource "aws_route" "private_default_to_nat" {
  route_table_id         = "rtb-0cfd187c223fc7632"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "nat-06063c10377fba6a0"
}

# Ensure both private subnets use THIS private RTB
resource "aws_route_table_association" "priv1" {
  subnet_id      = "subnet-06c96b155527807d1"
  route_table_id = "rtb-0cfd187c223fc7632"
}

resource "aws_route_table_association" "priv2" {
  subnet_id      = "subnet-0cb937fb5a2ff2457"
  route_table_id = "rtb-0cfd187c223fc7632"
}