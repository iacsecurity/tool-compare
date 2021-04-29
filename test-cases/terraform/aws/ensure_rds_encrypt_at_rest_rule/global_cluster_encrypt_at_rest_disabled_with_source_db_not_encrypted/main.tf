provider "aws" {
  region = "us-east-1"
}

resource "aws_rds_cluster" "rds-cluster-test" {
  skip_final_snapshot = true
  master_username = "asdfasdf"
  master_password = "asdf1234!!"
}

resource "aws_rds_global_cluster" "global" {
  global_cluster_identifier = "cloudrail-global-rds-cluster-test"
  force_destroy             = true
  source_db_cluster_identifier = aws_rds_cluster.rds-cluster-test.arn
}
