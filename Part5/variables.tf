variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

variable "ecs_cluster_name" {
  description = "Name of ECS cluster"
}

variable "ecs_service_name" {
  description = "Name of ECS service"
}

variable "alb_target_group_blue" {
  description = "Target group ARN for blue environment"
}

variable "alb_target_group_green" {
  description = "Target group ARN for green environment"
}

variable "rds_instance_id" {
  description = "RDS instance identifier"
}

variable "db_username" {
  description = "RDS master username"
}

variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}

variable "db_backup_retention_days" {
  description = "Automated backup retention period for RDS"
  default     = 7
}
