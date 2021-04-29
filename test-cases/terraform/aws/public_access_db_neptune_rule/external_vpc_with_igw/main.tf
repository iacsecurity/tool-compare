provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "external" {
  cidr_block = "10.1.1.0/24"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "external-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.external.id
}

resource "aws_security_group" "free" {
  vpc_id = aws_vpc.external.id

  ingress {
    from_port = 0
    protocol = "TCP"
    to_port = 64000
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.external.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.free_1.id
}

resource "aws_route_table_association" "rt2" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.free_2.id
}

resource "aws_subnet" "free_1" {
  vpc_id = aws_vpc.external.id
  cidr_block = "10.1.1.128/25"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "free_2" {
  vpc_id = aws_vpc.external.id
  cidr_block = "10.1.1.0/25"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" free {
  name = "free"
  subnet_ids = [
    aws_subnet.free_1.id,
    aws_subnet.free_2.id]
}

resource "aws_neptune_cluster" "encrypted_neptune_cluster" {
  cluster_identifier  = "cloudrail-test-encrypted"
  engine              = "neptune"
  skip_final_snapshot = true
  apply_immediately   = true
  storage_encrypted   = true
  neptune_subnet_group_name = aws_db_subnet_group.free.name
  vpc_security_group_ids = [aws_security_group.free.id]
}

resource "aws_neptune_cluster_instance" "neptune_instance" {
  count              = 2
  cluster_identifier = aws_neptune_cluster.encrypted_neptune_cluster.cluster_identifier
  engine             = "neptune"
  instance_class     = "db.r4.large"
  apply_immediately  = true
  publicly_accessible = true
}