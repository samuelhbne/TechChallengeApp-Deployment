resource "aws_rds_cluster" "pgcluster1" {
  cluster_identifier        = "${var.ENV}-aurora-cluster-pg"
  engine                    = "aurora-postgresql"
  engine_version            = "10.7"
  availability_zones        = var.availability_zones
  database_name             = var.DBNAME
  master_username           = var.PGUSER
  master_password           = var.PGPASS
  backup_retention_period   = 5
  apply_immediately         = true
  preferred_backup_window   = "07:00-09:00"
  final_snapshot_identifier = "${var.ENV}-aurora-cluster-pg-backup-${formatdate("YYYYMMDD-hhmmss-ZZZ", timestamp())}"
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.rds_sg1.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                     = 2
  identifier                = "${var.ENV}-aurora-cluster-pg-instance-${count.index}"
  engine                    = "aurora-postgresql"
  cluster_identifier        = aws_rds_cluster.pgcluster1.id
  instance_class            = var.instance_type_db
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]

  tags = {
    Name = "Database subnet group"
  }
}


output "db_reader_endpoint" {
  description               = "Database endpoint"
  value                     = aws_rds_cluster.pgcluster1.reader_endpoint
}

output "db_endpoint" {
  description               = "Database endpoint"
  value                     = aws_rds_cluster.pgcluster1.endpoint
}
