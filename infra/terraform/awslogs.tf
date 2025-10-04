# ECS task/app log groups

# Main ECS service log group
resource "aws_cloudwatch_log_group" "ecs_service" {
  name              = "/ecs/micro-dev"
  retention_in_days = 14

  tags = {
    project = var.project_prefix
    env     = var.env
    scope   = "ecs-service"
  }
}

# Optional: App container log group (only if you have multiple containers)
resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/micro-dev-app"
  retention_in_days = 14

  tags = {
    project = var.project_prefix
    env     = var.env
    scope   = "ecs-app"
  }
}
