output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ALB ARN"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "ALB DNS name"
}

output "listener_arn" {
  value       = aws_lb_listener.http.arn
  description = "HTTP listener ARN"
}

output "tg_arn" {
  value       = aws_lb_target_group.app.arn
  description = "Target group ARN"
}
