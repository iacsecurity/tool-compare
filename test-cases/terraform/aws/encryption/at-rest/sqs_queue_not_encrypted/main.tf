provider "aws" {
  region = "us-east-1"
}

resource "aws_sqs_queue" "cloudrail" {
  name = "sqs_non_encrypted"
}
