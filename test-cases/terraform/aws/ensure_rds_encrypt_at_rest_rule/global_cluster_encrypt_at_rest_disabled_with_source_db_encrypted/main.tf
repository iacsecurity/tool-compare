provider "aws" {
  region = "us-east-1"
}

resource "aws_rds_cluster" "test" {
  cluster_identifier  = "cloudrail-test-encrypted"
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name       = "cloudrail"
  master_username     = "administrator"
  master_password     = "cloudrail-TEST-password"
  skip_final_snapshot = true
  storage_encrypted   = true
}

resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "cloudrail-test-non-encrypted"
  force_destroy             = true
  source_db_cluster_identifier = aws_rds_cluster.test.arn
}
