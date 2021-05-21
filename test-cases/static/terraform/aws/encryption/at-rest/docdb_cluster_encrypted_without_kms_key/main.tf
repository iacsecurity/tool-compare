provider "aws" {
  region = "us-east-1"
}

resource "aws_docdb_cluster" "test1" {
  cluster_identifier  = "my-docdb-cluster-test1"
  engine              = "docdb"
  master_username     = "foo"
  master_password     = "mustbeeightchars"
  skip_final_snapshot = true
  storage_encrypted   = true
}
