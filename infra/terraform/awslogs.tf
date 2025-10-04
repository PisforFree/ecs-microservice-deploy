
# ECS task/app log groups

resource "aws_cloudwatch_log_group" "ecs_service" {
  name              = "/ecs/micro-dev"
  retention_in_days = 14

  tags = {
    project = var.project_prefix
    env     = var.env
    scope   = "ecs-service"
  }
}

# Optional: keep only if your task uses a second group
resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/micro-dev-app"
  retention_in_days = 14

  tags = {
    project = var.project_prefix
    env     = var.env
    scope   = "ecs-app"

# CloudWatch log groups needed by the ECS task definition
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/micro-dev"
  retention_in_days = 14
  tags = {
    Env     = "dev"
    Project = "micro"
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/micro-dev-app"
  retention_in_days = 14
  tags = {
    Env     = "dev"
    Project = "micro"
  }
}
