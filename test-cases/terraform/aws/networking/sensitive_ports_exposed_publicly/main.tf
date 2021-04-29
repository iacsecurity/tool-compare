provider "aws" {
  region = "us-east-1"
}

locals {
  test_description = "spin up a bastion host using a module"
  test_name        = "PublicAccessSecurityGroupsPort test - use case 9"
  cidr_block       = "10.10.0.0/16"
}

module "vpc_example_complete-vpc" {
  source  = "terraform-aws-modules/vpc/aws//examples/complete-vpc"
}

module "ec2-bastion-server" {
  source  = "cloudposse/ec2-bastion-server/aws"

  name = "bastion"
  namespace = "test"
  ssh_user = "ec2user"
  stage = "dev"
  subnets = module.vpc_example_complete-vpc.public_subnets
  vpc_id = module.vpc_example_complete-vpc.vpc_id
}