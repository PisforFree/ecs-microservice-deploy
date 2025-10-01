locals {
  container_name = "${var.project_prefix}-${var.env}-app"
  app_port       = 80
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_prefix}-${var.env}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  # Pin image immutably by digest (repo@sha256:...)
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${var.ecr_repo_uri}@${var.image_digest}"
      essential = true

      portMappings = [
        {
          containerPort = local.app_port
          hostPort      = local.app_port
          protocol      = "tcp"
        }
      ]

      # CloudWatch Logs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-stream-prefix = "ecs"
        }
      }

      # Simple container health check for Apache baseline
      healthCheck = {
        command     = ["CMD-SHELL", "curl -fsS http://localhost/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }
    }
  ])
}

