resource "aws_lb" "app" {
  name               = "${var.project}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public : s.id]
}

# Target group for EC2 ASG
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check { path = "/" }
}

# Target group for ECS Fargate (IP mode, port 5000)
resource "aws_lb_target_group" "fargate_tg" {
  name        = "${var.project}-fargate-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Listener rule to forward traffic to ECS TG
resource "aws_lb_listener_rule" "fargate_forward" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

output "fargate_tg_arn" {
  value = aws_lb_target_group.fargate_tg.arn
}

