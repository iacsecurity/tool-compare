provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "test" {
  description             = "customer-managed CMK for SNS test"
  deletion_window_in_days = 7
}

resource "aws_sns_topic" "test" {
  name              = "sns_ecnrypted"
  kms_master_key_id = aws_kms_key.test.arn
}
