provider "aws" {
  region = "us-east-1"
}

locals {
  s3_prefix_list_cidr_block = "54.231.0.0/17"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.100.0/24"
  enable_dns_support = true
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.100.128/25"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = local.s3_prefix_list_cidr_block
    gateway_id = aws_vpc_endpoint.s3-vpce-gw.id
  }

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route_table_association" "private-rtb-assoc" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rtb.id
}

resource "aws_vpc_endpoint" "s3-vpce-gw" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "vpce-gw-to-private-rtb-assoc" {
  route_table_id  = aws_route_table.private-rtb.id
  vpc_endpoint_id = aws_vpc_endpoint.s3-vpce-gw.id
}

resource "aws_s3_bucket" "public-bucket" {
  bucket = "public-bucket"
  tags = {
    Name = "public-bucket"
  }

  depends_on = [aws_vpc_endpoint.s3-vpce-gw]
}

resource "aws_s3_bucket_policy" "public-bucket-policy" {
  bucket = aws_s3_bucket.public-bucket.id

  policy = <<POLICY
      {
        "Version": "2012-10-17",
        "Id": "BUCKET_POLICY",
        "Statement": [
          {
            "Sid": "VpceAllow",
            "Effect": "Allow",
            "Principal": { "AWS": "arn:aws:iam::account-id:role/some-role" },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::private-bucket/*",
            "Condition": {
               "StringEquals": {"aws:SourceVpce": "${aws_vpc_endpoint.s3-vpce-gw.id}"}
            }
          }
        ]
      }
    POLICY
}