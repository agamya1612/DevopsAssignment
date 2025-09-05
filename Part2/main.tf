variable "target_group_arn" {
  description = "ARN of the target group for the ECS service"
  type        = string
}

########################################
# ECR Repository
########################################
resource "aws_ecr_repository" "app" {
  name = "${var.project}-repo"
}

########################################
# Secrets Manager
########################################
resource "aws_secretsmanager_secret" "db" {
  name = "${var.project}-db-creds"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    host     = var.db_host
    name     = var.db_name
    user     = var.db_user
    password = var.db_password
  })
}

########################################
# ECS Cluster
########################################
resource "aws_ecs_cluster" "app" {
  name = "${var.project}-cluster"
}

########################################
# IAM Roles
########################################
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

########################################
# Task Definition
########################################
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      secrets = [
        { name = "DB_HOST", valueFrom = "${aws_secretsmanager_secret.db.arn}:host::" },
        { name = "DB_NAME", valueFrom = "${aws_secretsmanager_secret.db.arn}:name::" },
        { name = "DB_USER", valueFrom = "${aws_secretsmanager_secret.db.arn}:user::" },
        { name = "DB_PASS", valueFrom = "${aws_secretsmanager_secret.db.arn}:password::" }
      ]
    }
  ])
}

########################################
# ECS Service
########################################
resource "aws_ecs_service" "app" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }
}
