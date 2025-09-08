output "dashboard_name" {
  value = aws_cloudwatch_dashboard.app_dashboard.dashboard_name
}

output "ecs_log_group" {
  value = aws_cloudwatch_log_group.ecs_app_logs.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.alerts.name
}
