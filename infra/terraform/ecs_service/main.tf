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
# Task Definition (Fargate)
# ----------------------------
data "aws_region" "current" {}

# Build container definitions JSON
locals {
  container_def = {
    name      = var.container_name
    image     = var.image_uri
    essential = true
    portMappings = [
      {
        containerPort = var.app_port
        hostPort      = var.app_port
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.log_group_name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = var.log_stream_prefix
      }
    }
    environment = [
      for k, v in var.env_vars : {
        name  = k
        value = v
      }
    ]
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${local.name}-taskdef"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = jsonencode([local.container_def])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(local.tags, { Name = "${local.name}-taskdef" })
}

# ----------------------------
# ECS Service
# ----------------------------
resource "aws_ecs_service" "this" {
  name                 = "${local.name}-service"
  cluster              = var.ecs_cluster_name
  task_definition      = aws_ecs_task_definition.this.arn
  desired_count        = var.desired_count
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_sg_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.app_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  propagate_tags = "SERVICE"

  lifecycle {
    ignore_changes = [
      task_definition # allow rolling updates by replacing taskdef outside of drift concerns
    ]
  }

  tags = merge(local.tags, { Name = "${local.name}-service" })
}
