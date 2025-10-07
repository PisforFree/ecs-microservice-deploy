locals {
  cluster_name = "${var.project_prefix}-${var.env}-ecs"
}

resource "aws_ecs_cluster" "this" {
  name = "micro-dev-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name    = local.cluster_name
    project = var.project_prefix
    env     = var.env
  }
}

