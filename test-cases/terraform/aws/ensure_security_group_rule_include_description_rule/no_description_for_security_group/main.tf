provider "aws" {
  region = "us-east-1"
}

locals {
  cidr_block       = "10.0.0.0/24"
}


resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block

}

resource "aws_security_group" "default" {
  name        = "examplerulename"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "This is an inbound rule for something...."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    description = "this is an egress rule for something else...."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example_rule_with_descriptions"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.cidr_block

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

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids  = [aws_security_group.default.id]

}
