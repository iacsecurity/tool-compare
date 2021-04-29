locals {
  region = "us-east-1"
  cidr_block = "172.16.0.0/16"
  public_subnet_cidr_block = "172.16.100.0/24"
  public_subnet_2_cidr_block = "172.16.200.0/24"
  quad_zero_cidr_block = "0.0.0.0/0"
}

provider "aws" {
  region = local.region
}

resource "aws_vpc" "main" {
  cidr_block = local.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public-subnet-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidr_block
  availability_zone = "${local.region}-1a"
  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1a-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_2_cidr_block
  availability_zone = "${local.region}-1a"
  tags = {
    Name = "public-subnet-1a-2"
  }
}

resource "aws_route_table_association" "public-subnet-1a-rtb-assoc" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "public-subnet-1a-2-rtb-assoc" {
  subnet_id      = aws_subnet.public-subnet-1a-2.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_network_acl" "allow-public-outbound-nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-1a-2.id]

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = local.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "allow-public-outbound-nacl"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}


resource "aws_security_group" "internet-access-sg" {
  name        = "internet-access-sg"
  description = "Allow all local traffic and interent access"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.quad_zero_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_block]
  }

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

resource "aws_instance" "test-ec2-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1a.id
  vpc_security_group_ids = [aws_security_group.internet-access-sg.id]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [aws_subnet.public-subnet-1a.id]
  security_group_ids = [aws_security_group.internet-access-sg.id]
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint-2" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [aws_subnet.public-subnet-1a-2.id]
  security_group_ids = [aws_security_group.internet-access-sg.id]
}

resource "aws_sqs_queue" "test-queue" {
  name = "test-queue"
}
