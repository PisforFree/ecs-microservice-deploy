###############################################################################
# ECS Service Auto Scaling (Task count) - Target Tracking on CPU
###############################################################################

# Target: the ECS service desiredCount
resource "aws_appautoscaling_target" "ecs_service" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  min_capacity = var.min_task_count
  max_capacity = var.max_task_count
}

# Policy: keep average CPU around target_value
resource "aws_appautoscaling_policy" "cpu_target" {
  name               = "${var.project_prefix}-${var.env}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.ecs_service.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_service.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_percent
    scale_in_cooldown  = var.scale_in_cooldown  # seconds
    scale_out_cooldown = var.scale_out_cooldown # seconds
  }
}
