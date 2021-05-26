provider "aws" {
  region = "us-east-1"
}

resource "aws_secretsmanager_secret" "test" {
  name = "test-cloudrail"
}
