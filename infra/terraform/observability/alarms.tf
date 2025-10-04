#############################################
# observability/alarms.tf  (multi-line syntax)
#############################################

# --- Inputs (declared here so you don't need a separate variables.tf) ---

variable "project_prefix" {
  description = "Project short name, used for alarm names/tags"
  type        = string
}

variable "env" {
  description = "Environment (dev/stage/prod)"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB arn_suffix like app/micro-dev-alb/xxxxxxxx"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target Group arn_suffix like targetgroup/micro-dev-tg-80/yyyyyyyy"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name for ECS service alarms"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service name for ECS service alarms"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN to notify on alarm"
  type        = string
}


# --- Thresholds (override in tfvars if desired) ---

variable "alb_5xx_threshold" {
  description = "ALB 5xx count per period to alarm"
  type        = number
  default     = 5
}

variable "alb_unhealthy_threshold" {
  description = "Number of unhealthy targets to alarm"
  type        = number
  default     = 1
}

variable "cpu_high_threshold" {
  description = "ECS service CPU percent to alarm"
  type        = number
  default     = 80
}

variable "mem_high_threshold" {
  description = "ECS service Memory percent to alarm"
  type        = number
  default     = 80
}

variable "running_tasks_min" {
  description = "Minimum running tasks; alarm if below"
  type        = number
  default     = 1
}

# --- Common tags ---

locals {
  alarm_tags = {
    project = var.project_prefix
    env     = var.env
    owner   = "devops"
  }
}

# -------------------------------
# ALB: 5xx errors (Load Balancer)
# -------------------------------
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_prefix}-${var.env}-alb-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]


  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = local.alarm_tags
}

# -------------------------------------------
# Target Group: UnHealthyHostCount (requires
# BOTH TargetGroup and LoadBalancer dims)
# -------------------------------------------
resource "aws_cloudwatch_metric_alarm" "tg_unhealthy" {
  alarm_name          = "${var.project_prefix}-${var.env}-tg-unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = var.alb_unhealthy_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]


  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  tags = local.alarm_tags
}

# -------------------------------
# ECS Service: High CPU
# -------------------------------
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.project_prefix}-${var.env}-ecs-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_high_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]


  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = local.alarm_tags
}

# -------------------------------
# ECS Service: High Memory
# -------------------------------
resource "aws_cloudwatch_metric_alarm" "ecs_mem_high" {
  alarm_name          = "${var.project_prefix}-${var.env}-ecs-mem-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = var.mem_high_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]


  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = local.alarm_tags
}

# --------------------------------------------
# ECS Service: Running tasks dropped (minimum)
# --------------------------------------------
resource "aws_cloudwatch_metric_alarm" "ecs_running_low" {
  alarm_name          = "${var.project_prefix}-${var.env}-ecs-running-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  metric_name         = "RunningTaskCount"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Minimum"
  threshold           = var.running_tasks_min
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_topic_arn]


  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = local.alarm_tags
}

