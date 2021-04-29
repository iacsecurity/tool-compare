provider "aws" {
  region = "us-east-1"
}

module "public-vpc" {
  source = "../../../../terraform-tests-modules/public-vpc"
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint" {
  vpc_id            = module.public-vpc.vpc-id
  service_name      = "com.amazonaws.${module.public-vpc.vpc-region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = module.public-vpc.subnets-ids
  security_group_ids = [module.public-vpc.public-internet-sg-id]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}
