# SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "my-app-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# ECS Log Group
resource "aws_cloudwatch_log_group" "ecs_app_logs" {
  name              = "/ecs/${var.ecs_service_name}"
  retention_in_days = var.log_retention_days
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "my-app-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type       = "metric",
        x          = 0
        y          = 0
        width      = 12
        height     = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "ECS CPU & Memory"
        }
      },
      {
        type       = "metric",
        x          = 0
        y          = 7
        width      = 12
        height     = 6
        properties = {
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Connections"
        }
      }
    ]
  })
}
