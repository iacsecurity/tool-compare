provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "test" {
  description             = "KMS key for SSM Parameter Store"
  deletion_window_in_days = 7
}

resource "aws_ssm_parameter" "test" {
  name   = "test-cloudrail"
  type   = "SecureString"
  value  = "s11per.S3cret.Value"
  key_id = aws_kms_key.test.arn
}