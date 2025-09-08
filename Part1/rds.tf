resource "aws_db_subnet_group" "rds" {
  name       = "${var.project}-rds-subnets"
  subnet_ids = [for s in aws_subnet.private : s.id]
}

resource "aws_db_instance" "postgres" {
  identifier              = "${var.project}-postgres"
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  final_snapshot_identifier = null
}
