# infra/terraform/ecs/autoscaling.tf

# Use your existing naming convention.
# If your real names are different, edit the two locals below to match exactly.
locals {
  # Must match what AWS shows right now
  ecs_cluster_name = "micro-dev-ecs"
  ecs_service_name = "micro-dev-service"
}

resource "aws_appautoscaling_target" "ecs_service" {
  service_namespace = "ecs"
  # Must be "service/<cluster-name>/<service-name>"
  resource_id        = "service/${local.ecs_cluster_name}/${local.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

resource "aws_appautoscaling_policy" "cpu_target" {
  name               = "${var.project_prefix}-${var.env}-cpu-tt"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 50
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "mem_target" {
  name               = "${var.project_prefix}-${var.env}-mem-tt"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 70
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
