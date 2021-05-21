provider "aws" {
  region = "eu-central-1"
}

locals {
  test_description = "Indirect public access to Redshift - a public EC2 can reach a private Redshift cluster"
  test_name        = "Indirect public access to Redshift - use case 1"
}

resource "aws_vpc" "nondefault" {
  cidr_block = "10.1.1.0/24"
}

resource "aws_network_acl" "ec2_nacl" {
  vpc_id = aws_vpc.nondefault.id
  subnet_ids = [aws_subnet.nondefault_1.id]

  egress {
    protocol   = -1
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65000
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65000
  }

  tags = {
    Name = "main"
  }
}

resource "aws_network_acl" "redshift_eni2_nacl" {
  vpc_id = aws_vpc.nondefault.id
  subnet_ids = [aws_subnet.nondefault_2.id]

  egress {
    protocol   = -1
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65000
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65000
  }

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "nondefault_1" {
  vpc_id = aws_vpc.nondefault.id
  cidr_block = "10.1.1.128/25"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "nondefault_2" {
  vpc_id = aws_vpc.nondefault.id
  cidr_block = "10.1.1.0/25"
  availability_zone = "eu-central-1b"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nondefault.id
}

resource aws_route_table "nondefault_1" {
  vpc_id = aws_vpc.nondefault.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "nondefault_1" {
  route_table_id = aws_route_table.nondefault_1.id
  subnet_id = aws_subnet.nondefault_1.id
}

resource "aws_redshift_subnet_group" nondefault {
  name = "nondefault"
  subnet_ids = [aws_subnet.nondefault_1.id, aws_subnet.nondefault_2.id]

}

resource "aws_redshift_cluster" "test" {
  cluster_identifier = "redshift-defaults-only"
  node_type = "dc2.large"
  master_password = "Test1234"
  master_username = "test"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.publicly_accessible_sg.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.nondefault.name
  publicly_accessible = false // Note that while the subnet itself has public access, the redshift is set NOT to have a public IP
}

resource "aws_security_group" "publicly_accessible_sg" {
  vpc_id = aws_vpc.nondefault.id
  ingress {
    from_port = 0
    protocol = "tcp"
    to_port = 65000
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65000
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// This instance is can potentially be used to hop into the DB
resource "aws_instance" "public_ins" {
  ami = "ami-0130bec6e5047f596"
  instance_type = "t3.nano"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.publicly_accessible_sg.id]
  subnet_id = aws_subnet.nondefault_1.id
}