provider "aws" {
  region = "eu-west-1"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier  = "cloudrail-test-encrypted"
  engine              = "aurora-mysql"
  engine_version      = "5.7.mysql_aurora.2.03.2"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name       = "cloudrail"
  master_username     = "administrator"
  master_password     = "cloudrail-TEST-password"
  skip_final_snapshot = true
  storage_encrypted   = true
}
