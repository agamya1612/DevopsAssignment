# -----------------------------
# ECS Blue-Green Deployment (CodeDeploy)
# -----------------------------
provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = { Service = "codedeploy.amazonaws.com" }
        Effect    = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codedeploy_ecs_policy_custom" {
  name = "codedeploy-ecs-access"
  role = aws_iam_role.codedeploy_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:RegisterTaskDefinition",
          "ecs:ListClusters",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeListeners"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codedeploy_ecs_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_codedeploy_app" "ecs_app" {
  name             = "${var.ecs_service_name}-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs_blue_green" {
  app_name              = aws_codedeploy_app.ecs_app.name
  deployment_group_name = "${var.ecs_service_name}-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "DISCOVER_EXISTING"
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.alb_target_group_blue
      }
      target_group {
        name = var.alb_target_group_green
      }
      prod_traffic_route {
        listener_arns = ["arn:aws:elasticloadbalancing:ap-south-1:116555270265:loadbalancer/app/webapp-alb/f8db1225c65f181c"]
      }
    }
  }
}

# -----------------------------
# RDS Automated Backups
# -----------------------------

resource "aws_db_instance" "webapp_db" {
  identifier            = var.rds_instance_id
  engine                = "postgres"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = "webapp-rds-subnets" 
  vpc_security_group_ids = ["sg-041b42b862fd3bc4a"]

  backup_retention_period = var.db_backup_retention_days
  backup_window           = "03:00-04:00"
  multi_az                = true
  skip_final_snapshot =  false
}

