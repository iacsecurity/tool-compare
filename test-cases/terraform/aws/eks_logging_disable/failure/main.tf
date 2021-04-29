
provider "aws" {
  region = "us-east-2"
  version = "3.1"
}

resource "aws_iam_role" "eksrole" {
  assume_role_policy = ""
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eks_cluster" "test" {
  name = "test"
  role_arn = aws_iam_role.eksrole.arn
  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id]
  }
}