provider "aws" {
  region = "us-east-1"
}

data "aws_kms_key" "by_alias" {
  key_id = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "test" {
  name   = "test-cloudrail"
  type   = "SecureString"
  value  = "s11per.S3cret.Value"
  key_id = data.aws_kms_key.by_alias.arn
}
