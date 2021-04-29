provider "aws" {
  region = "us-east-1"
}

resource "aws_ssm_parameter" "test" {
  name  = "test-cloudrail"
  type  = "SecureString"
  value = "s11per.S3cret.Value"
}
