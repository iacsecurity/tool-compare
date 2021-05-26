provider "aws" {
  region = "us-east-1"
}

locals {
  test_description = "spin up EC2 in default VPC"
  test_name        = "TestDisallowDefaultVpcRule test - use case 1"
  cidr_block       = "10.10.0.0/16"
  region  = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "default-subnet" {
  vpc_id     = aws_default_vpc.default.id
  cidr_block = "192.168.10.0/24"
  availability_zone = local.region
}

resource "aws_route_table" "default-route-table" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_route_table_association" "default-route-table-assoc" {
  subnet_id      = aws_subnet.default-subnet.id
  route_table_id = aws_route_table.default-route-table.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "t2-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.default-subnet.id
}
