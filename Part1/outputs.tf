output "alb_dns_name"   { value = aws_lb.app.dns_name }
output "rds_endpoint"   { value = aws_db_instance.postgres.address }