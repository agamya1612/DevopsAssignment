variable "project" {
  default = "webapp"
}

variable "region" {
  description = "AWS region to deploy ECS service"
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
variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {
  sensitive = true
}

# App container settings
variable "container_port" {
  default = 5000
}

variable "desired_count" {
  default = 2
}
