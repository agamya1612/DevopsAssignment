output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecs_app.name
}

output "codedeploy_deployment_group_name" {
  value = aws_codedeploy_deployment_group.ecs_blue_green.deployment_group_name
}

output "rds_instance_endpoint" {
  value = aws_db_instance.webapp_db.endpoint
}
