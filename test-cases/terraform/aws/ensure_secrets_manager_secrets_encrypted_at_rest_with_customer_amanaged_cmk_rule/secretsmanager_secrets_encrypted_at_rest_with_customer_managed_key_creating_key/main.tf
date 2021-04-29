provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "test" {
  description             = "KMS key for Secrets Manager"
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret" "test" {
  name       = "test-cloudrail-2"
  kms_key_id = aws_kms_key.test.arn
}
