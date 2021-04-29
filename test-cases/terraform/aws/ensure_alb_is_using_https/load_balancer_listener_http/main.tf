provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.10.0/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]
  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.10.11.0/24"
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]

  tags = {
    Name = "subnet2"
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    gateway_id = aws_internet_gateway.igw1.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "assoc1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "assoc2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_lb_target_group" "test" {
  vpc_id = aws_vpc.vpc1.id
  port = 80
  protocol = "HTTP"
}

resource "aws_lb" "alb_test" {
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  load_balancer_type = "application"
}

resource "aws_lb_listener" "lb_listener_test" {
  load_balancer_arn = aws_lb.alb_test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}


