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

  # Use custom Apache image pinned by digest (immutable)
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "803767876973.dkr.ecr.us-east-2.amazonaws.com/microservice@sha256:7b6b61c2064daeb6c3327ad5b6715be02f4948ad9483748a4509589c3d1cf62f"
      essential = true
      portMappings = [
        {
          containerPort = local.app_port
          hostPort      = local.app_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.region
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-stream-prefix = "ecs"
        }
      }

      # 🔴 TEMPORARY failing health check to trigger ECS rollback
      healthCheck = {
        command     = ["CMD-SHELL", "exit 1"]
        interval    = 5
        timeout     = 2
        retries     = 2
        startPeriod = 0
      }
    }
  ]) 
}
