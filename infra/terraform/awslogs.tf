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
