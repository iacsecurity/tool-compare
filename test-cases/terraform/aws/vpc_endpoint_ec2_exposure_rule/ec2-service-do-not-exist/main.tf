locals {
  region = "us-east-1"
  cidr_block = "172.16.0.0/16"
  public_subnet_cidr_block = "172.16.100.0/24"
  quad_zero_cidr_block = "0.0.0.0/0"
}

provider "aws" {
  region = local.region
}

resource "aws_vpc" "main" {
  cidr_block = local.cidr_block
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidr_block
  availability_zone = "${local.region}-1a"
  tags = {
    Name = "public-subnet-1a"
  }
}

resource "aws_route_table_association" "public-subnet-rtb-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
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
  subnet_ids = [aws_subnet.public-subnet.id]

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
    cidr_block = local.quad_zero_cidr_block
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

resource "aws_vpc_endpoint" "ec2-vpc-endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.ec2"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [aws_subnet.public-subnet.id]
  security_group_ids = [aws_security_group.internet-access-sg.id]
}
