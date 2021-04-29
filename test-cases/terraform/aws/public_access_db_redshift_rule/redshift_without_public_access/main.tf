provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "aws_vpc" "nondefault" {
  cidr_block = "10.1.1.0/24"
}

resource "aws_security_group" "nondefault" {
  vpc_id = aws_vpc.nondefault.id

  ingress {
    from_port = 5439
    protocol = "TCP"
    to_port = 5439
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_redshift_subnet_group" "nondefault" {
  name = "nondefault"
  subnet_ids = [aws_subnet.nondefault_1.id, aws_subnet.nondefault_2.id]
}

resource "aws_route_table" "nondefault" {
  vpc_id = aws_vpc.nondefault.id
}

resource "aws_route_table_association" "nondefault1" {
  route_table_id = aws_route_table.nondefault.id
  subnet_id = aws_subnet.nondefault_1.id
}

resource "aws_route_table_association" "nondefault2" {
  route_table_id = aws_route_table.nondefault.id
  subnet_id = aws_subnet.nondefault_2.id
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.nondefault.id
  subnet_ids = [aws_subnet.nondefault_1.id]
}

resource "aws_network_acl_rule" "public_allow_ingress_5439_test" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 5439
  to_port        = 5439
  icmp_type      = -1
  icmp_code      = -1
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.nondefault.id
  subnet_ids = [aws_subnet.nondefault_2.id]
}

resource "aws_network_acl_rule" "private_allow_ingress_5439_test" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65536
  icmp_type      = -1
  icmp_code      = -1
}

resource "aws_redshift_cluster" "test" {
  cluster_identifier = "redshift-defaults-only"
  node_type = "dc2.large"
  master_password = "Test1234"
  master_username = "test"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.nondefault.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.nondefault.name
  publicly_accessible = true
}
