provider "aws" {
  region = "us-east-1"
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier  = "my-docdb-cluster"
  engine              = "docdb"
  master_username     = "foo"
  master_password     = "mustbeeightchars"
  skip_final_snapshot = true
}