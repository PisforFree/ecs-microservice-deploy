output "vpc_id" {
  value = local.chosen_vpc_id
}

output "public_subnet_ids" {
  value = local.chosen_public_subnet_ids
}

output "private_subnet_ids" {
  value = local.chosen_private_subnet_ids
}
