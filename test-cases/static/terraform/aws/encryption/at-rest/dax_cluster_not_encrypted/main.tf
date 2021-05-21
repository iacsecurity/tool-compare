provider "aws" {
  region = "us-east-1"
}

# No policy attached to this role because it is for testing purposes
resource "aws_iam_role" "dax" {
  name = "dynamodb-dax-cloudrail-test"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "dax.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_dax_cluster" "cloudrail-test" {
  cluster_name       = "non-encrypt"
  iam_role_arn       = aws_iam_role.dax.arn
  node_type          = "dax.r4.large"
  replication_factor = 1
}
