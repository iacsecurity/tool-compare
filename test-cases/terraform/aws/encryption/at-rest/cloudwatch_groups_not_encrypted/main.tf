provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "cloudrail-test" {
  retention_in_days = 1
}
