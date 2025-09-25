output "ecs_cluster_name" { value = aws_ecs_cluster.this.name }
output "ecs_cluster_arn" { value = aws_ecs_cluster.this.arn }

output "task_execution_role_arn" { value = aws_iam_role.task_execution_role.arn }
output "task_role_arn" { value = aws_iam_role.task_role.arn }

output "service_name" { value = aws_ecs_service.app.name }
output "task_definition_family" { value = aws_ecs_task_definition.app.family }
