terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  name = "${var.project_prefix}-${var.env}"
  tags = {
    Project = var.project_prefix
    Env     = var.env
    Managed = "terraform"
  }
}

# ----------------------------
# CloudWatch Logs for the app
# ----------------------------
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.name}/app"
  retention_in_days = var.log_retention_days
  tags              = merge(local.tags, { Name = "${local.name}-app-logs" })
}

# ----------------------------
# IAM: Task Execution Role
# ----------------------------
data "aws_iam_policy_document" "task_exec_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.name}-task-exec-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
  tags               = merge(local.tags, { Name = "${local.name}-task-exec-role" })
}

# AWS-managed policy grants ECR pull + logs. (Do not duplicate perms yourself.)
resource "aws_iam_role_policy_attachment" "task_exec_managed" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ----------------------------
# IAM: Task Role (app's own permissions)
# Keep least privilege. Add policies later if your app needs AWS APIs.
# ----------------------------
resource "aws_iam_role" "task_role" {
  name               = "${local.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json
  tags               = merge(local.tags, { Name = "${local.name}-task-role" })
}

# ----------------------------
# ECS Cluster + Capacity Providers
# ----------------------------
resource "aws_ecs_cluster" "this" {
  name = "${local.name}-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(local.tags, { Name = "${local.name}-cluster" })
}

# Register Fargate & Fargate Spot
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }

  # Optionally add SPOT weight for cost tests (kept 0 by default to avoid surprise preemption in dev)
  dynamic "default_capacity_provider_strategy" {
    for_each = var.use_fargate_spot_weight > 0 ? [1] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = var.use_fargate_spot_weight
    }
  }
}

# NOTE: ECS creates/uses a service-linked role 'AWSServiceRoleForECS' automatically.
# Your deploy role needs iam:CreateServiceLinkedRole the first time if it doesn't exist.
