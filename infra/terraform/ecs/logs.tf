resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project_prefix}-${var.env}-app"
  retention_in_days = 7
  tags              = { project = var.project_prefix, env = var.env }
}
