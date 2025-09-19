output "ecs_cluster_name" { value = aws_ecs_cluster.this.name }
output "task_execution_role_arn" { value = aws_iam_role.task_execution_role.arn }
output "task_role_arn" { value = aws_iam_role.task_role.arn }
output "app_log_group_name" { value = aws_cloudwatch_log_group.app.name }
