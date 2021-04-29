
provider "aws" {
  region = "eu-west-2"
}

variable "source_cidr" {
  type = string
  default = "10.0.0.0/8"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.16.0.0/16" 

}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.16.0.0/16"

}

resource "aws_network_acl" "nondefault" {
  subnet_ids = [aws_subnet.subnet.id]
  vpc_id = aws_vpc.vpc.id
  ingress {
    action = "allow"
    from_port = 22
    protocol = "tcp"
    rule_no = 100
    to_port = 22
    cidr_block = var.source_cidr
  }
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.source_cidr]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "toinet" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "toinet" {
  subnet_id = aws_subnet.subnet.id
  route_table_id = aws_route_table.toinet.id
}

resource "aws_instance" "test" {
  ami           = "ami-09b89ad3c5769cca2"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
}
