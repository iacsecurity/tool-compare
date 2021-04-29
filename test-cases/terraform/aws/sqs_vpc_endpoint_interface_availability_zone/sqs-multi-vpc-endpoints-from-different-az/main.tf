provider "aws" {
  region = "us-east-1"
}

module "public-vpc" {
  source = "../../../../terraform-tests-modules/public-vpc"
  all-subnets-azs = ["a", "b"]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint-1a" {
  vpc_id            = module.public-vpc.vpc-id
  service_name      = "com.amazonaws.${module.public-vpc.vpc-region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [module.public-vpc.subnets-ids[0]]
  security_group_ids = [module.public-vpc.public-internet-sg-id]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint-1b" {
  vpc_id            = module.public-vpc.vpc-id
  service_name      = "com.amazonaws.${module.public-vpc.vpc-region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [module.public-vpc.subnets-ids[1]]
  security_group_ids = [module.public-vpc.public-internet-sg-id]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}