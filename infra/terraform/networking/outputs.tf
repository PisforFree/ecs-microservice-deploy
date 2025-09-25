output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
  # alternatively: values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
  # alternatively: values(aws_subnet.private)[*].id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_service_security_group_id" {
  value = aws_security_group.ecs_service.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
