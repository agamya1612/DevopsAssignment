########################################
# ECR Repository
########################################
resource "aws_ecr_repository" "app" {
  name = "${var.project}-repo-${var.env}"
}

########################################
# CloudWatch Log Group (for ECS logs)
########################################
resource "aws_cloudwatch_log_group" "ecs_app_logs" {
  name              = "/ecs/${var.project}-service-${var.env}"
  retention_in_days = 7
}

########################################
# Secrets Manager (4 separate secrets)
########################################
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "aws_secretsmanager_secret" "db_host" {
  name        = "${var.project}-db-host-${var.env}-${random_string.suffix.result}"
  description = "Database host for ${var.project} in ${var.env}"
}
resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = var.db_host
}

resource "aws_secretsmanager_secret" "db_name" {
  name        = "${var.project}-db-name-${var.env}-${random_string.suffix.result}"
  description = "Database name for ${var.project} in ${var.env}"
}
resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = var.db_name
}

resource "aws_secretsmanager_secret" "db_user" {
  name        = "${var.project}-db-user-${var.env}-${random_string.suffix.result}"
  description = "Database username for ${var.project} in ${var.env}"
}
resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = var.db_user
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.project}-db-pass-${var.env}-${random_string.suffix.result}"
  description = "Database password for ${var.project} in ${var.env}"
}
resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

########################################
# ECS Cluster
########################################
resource "aws_ecs_cluster" "app" {
  name = "${var.project}-cluster-${var.env}"
}

########################################
# IAM Roles
########################################
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project}-ecs-execution-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
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
# ECS Task Definition
########################################
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-task-${var.env}"
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
        { name = "DB_HOST", valueFrom = aws_secretsmanager_secret.db_host.arn },
        { name = "DB_NAME", valueFrom = aws_secretsmanager_secret.db_name.arn },
        { name = "DB_USER", valueFrom = aws_secretsmanager_secret.db_user.arn },
        { name = "DB_PASS", valueFrom = aws_secretsmanager_secret.db_password.arn }
      ]

      # 👇 CloudWatch Logs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_app_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

########################################
# ECS Service
########################################
variable "target_group_arn" {
  description = "ARN of the Target Group (must be type=ip)"
  type        = string
}

resource "aws_ecs_service" "app" {
  name            = "${var.project}-service-${var.env}"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_ecs_task_definition.app]
}
