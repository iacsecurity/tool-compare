# Test case: Resource (ec2) use default sg (automatically created) in a newly created VPC
# Expected: alert on the use of default sg

provider "aws" {
  region = "eu-west-2"
}

locals {
  test_description = "resource (ec2) use default sg (automatically created) in a newly created VPC"
  test_name        = "Integration test - use case 1"
  cidr_block       = "10.9.0.0/16"
}

resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block

  tags = {
    Name = local.test_name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.cidr_block

  tags = {
    Name = local.test_name
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-07cda0db070313c52"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id

  tags = {
    Name = local.test_name
  }
}