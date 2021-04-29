provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "aws_vpc" "nondefault" {
  cidr_block = "10.1.1.0/24"
  enable_dns_hostnames = true
}

resource "aws_security_group" "nondefault" {
  vpc_id = aws_vpc.nondefault.id

  ingress {
    from_port = 0
    protocol = "TCP"
    to_port = 64000
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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nondefault.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.nondefault.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.nondefault_1.id
}

resource "aws_route_table_association" "rt2" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.nondefault_2.id
}

resource "aws_db_subnet_group" nondefault {
  name = "nondefault"
  subnet_ids = [aws_subnet.nondefault_1.id, aws_subnet.nondefault_2.id]

}

resource "aws_rds_cluster" "test" {
  db_subnet_group_name = aws_db_subnet_group.nondefault.name
  vpc_security_group_ids = [aws_security_group.nondefault.id]
  master_username = "asdfasdf"
  master_password = "asdf1234!!"
}

resource "aws_rds_cluster_instance" "ins1" {
  db_subnet_group_name = aws_db_subnet_group.nondefault.name
  cluster_identifier = aws_rds_cluster.test.id
  instance_class = "db.r4.large"
  engine             = aws_rds_cluster.test.engine
  engine_version     = aws_rds_cluster.test.engine_version
  publicly_accessible = true
}

resource "aws_rds_cluster_instance" "ins2" {
  db_subnet_group_name = aws_db_subnet_group.nondefault.name
  cluster_identifier = aws_rds_cluster.test.id
  instance_class = "db.r4.large"
  engine             = aws_rds_cluster.test.engine
  engine_version     = aws_rds_cluster.test.engine_version
  publicly_accessible = true
}