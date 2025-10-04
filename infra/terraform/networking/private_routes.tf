# Private subnets default route to NAT
resource "aws_route" "private_default_to_nat" {
  route_table_id         = "rtb-0cfd187c223fc7632"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "nat-06063c10377fba6a0"
}
