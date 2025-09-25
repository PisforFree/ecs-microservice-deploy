output "env" {
  value = var.env
}

# ALB module outputs
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "tg_arn" { value = module.alb.tg_arn }
output "listener_arn" { value = module.alb.listener_arn }

# (optional but handy)
output "ecs_cluster_name" { value = module.ecs.ecs_cluster_name }
output "task_execution_role_arn" { value = module.ecs.task_execution_role_arn }
output "task_role_arn" { value = module.ecs.task_role_arn }

