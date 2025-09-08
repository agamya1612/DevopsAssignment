variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "webapp"
}

variable "env" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy ECS service"
  type        = string
  default     = "ap-south-1"
}

variable "subnets" {
  type        = list(string)
  description = "Private subnets for ECS tasks"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for ECS tasks"
}

# DB details to store in Secrets Manager
variable "db_host" {
  description = "Database host endpoint"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# App container settings
variable "container_port" {
  description = "App container port"
  type        = number
  default     = 5000
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}
