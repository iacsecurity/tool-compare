provider "aws" {
  region = "us-east-1"
}

module "private-vpc" {
  source = "../../../../terraform-tests-modules/private-vpc"
  all-subnets-azs = ["a"]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint" {
  vpc_id            = module.private-vpc.vpc-id
  service_name      = "com.amazonaws.${module.private-vpc.vpc-region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = module.private-vpc.subnets-ids
  security_group_ids = [module.private-vpc.local-network-sg-id]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}