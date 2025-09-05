output "ecs_cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "secrets_manager_arn" {
  value = aws_secretsmanager_secret.db.arn
}
