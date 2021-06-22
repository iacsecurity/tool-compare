# Here we have a security group that is not used by any other resource

resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  vpc_id = aws_vpc.example.id
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
