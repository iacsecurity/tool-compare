provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "cloudrail_1" {
  name = "sns_not_ecnrypted-1"
  tags = {
    Name = "Sns Topic Cloudrail Test",
    Env = "Cloudrail Rules test"
  }
}

resource "aws_sqs_queue" "cloudrail" {
  name = "sqs_non_encrypted"
  tags = {
    Name = "Sqs Cloudrail Test",
    Env = "Cloudrail Rules test"
  }
}
