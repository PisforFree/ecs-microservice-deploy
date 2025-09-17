output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "region" {
  value = data.aws_region.current.name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

# (Optional) other handy pass-throughs
output "tg_arn" { value = module.alb.tg_arn }
output "cluster_name" { value = module.ecs.ecs_cluster_name }
