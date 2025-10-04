# infra/terraform/logs.tf  (new file at the same level as your other resources)
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_prefix}-${var.env}" # -> /ecs/micro-dev
  retention_in_days = 14
  tags = {
    Project = var.project_prefix
    Env     = var.env
  }
}
