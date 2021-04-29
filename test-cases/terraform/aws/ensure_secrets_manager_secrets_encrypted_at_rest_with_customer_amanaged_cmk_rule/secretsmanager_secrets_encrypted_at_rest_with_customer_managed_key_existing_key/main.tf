provider "aws" {
  region = "us-east-1"
}

data "aws_kms_key" "by_alias" {
  key_id = "alias/test-secretsmanager"
}

resource "aws_secretsmanager_secret" "test" {
  name       = "test-cloudrail-3"
  kms_key_id = data.aws_kms_key.by_alias.arn
}
