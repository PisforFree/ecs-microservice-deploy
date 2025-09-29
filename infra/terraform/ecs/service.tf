resource "aws_ecs_service" "app" {
  name             = "${var.project_prefix}-${var.env}-svc"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.app.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  deployment_circuit_breaker {
    enable   = true   # turn on circuit breaker
    rollback = true   # auto-rollback to last RUNNING task set if deployment fails
  }

  # (Optional) tweak rollout speed; not required for circuit breaker
  # deployment_minimum_healthy_percent = 100
  # deployment_maximum_percent         = 200

  # (FYI) deployment_controller defaults to "ECS" (rolling update), which supports circuit breaker:
  # deployment_controller {
  #   type = "ECS"
  # }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_service_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  depends_on = [aws_ecs_cluster.this]
}
