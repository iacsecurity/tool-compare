provider "aws" {
  region = "us-east-1"
}

module "public-vpc" {
  source = "../../../../terraform-tests-modules/public-vpc"
  all-subnets-azs = ["a"]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}
