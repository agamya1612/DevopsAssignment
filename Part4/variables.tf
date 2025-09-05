variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster to monitor"
  default     = "webapp-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service to monitor"
  default     = "webapp-service"
}

variable "rds_instance_id" {
  description = "The identifier of the RDS instance to monitor"
  default     = "webapp-postgres"
}

variable "rds_max_connections" {
  description = "Threshold for RDS connections alarm"
  default     = 50
}

variable "log_retention_days" {
  description = "Retention period (in days) for CloudWatch logs"
  default     = 30
}

variable "alert_email" {
  description = "Email to receive CloudWatch alarm notifications"
  default     = "agamyamehrotra.911@gmail.com"
}
