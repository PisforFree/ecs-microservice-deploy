resource "aws_ecs_service" "app" {
  name             = "${var.project_prefix}-${var.env}-service" # e.g., micro-dev-service
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  # Safer rollouts with automatic rollback on failed deploys
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Trigger a new deployment when the task definition changes (handy during troubleshooting)
  force_new_deployment = true

  # ALB target group mapping — must match container name/port from taskdef
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.project_prefix}-${var.env}-app" # must equal taskdef container name
    container_port   = 80
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_service_security_group_id]
    assign_public_ip = false
  }

  # Conservative rollout while we stabilize
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  depends_on = [
    aws_ecs_cluster.this
  ]
}
