provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "not_secure_policy" {
  description             = "KMS key + not_secure_policy"
  deletion_window_in_days = 7

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Not Secure Policy",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "*",
            "Action": [
            "kms:*"
            ]
        }
    ]
}
EOF
}