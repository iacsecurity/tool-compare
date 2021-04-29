locals {
  region  = "us-east-1"
  mysql_port = 3306
  web_server_port = 80
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_vpc" "main-vpc" {
  cidr_block           = "192.168.10.0/24"
}

resource "aws_subnet" "main-public-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.10.0/24"
  availability_zone = local.region
}

resource "aws_network_acl" "public-subnet-nacl" {
  vpc_id     = aws_vpc.main-vpc.id
  subnet_ids = [aws_subnet.main-public-subnet.id]
}

resource "aws_network_acl_rule" "inbound-rule" {
  network_acl_id = aws_network_acl.public-subnet-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = local.web_server_port
  to_port        = local.mysql_port
}

resource "aws_network_acl_rule" "outbound-rule" {
  network_acl_id = aws_network_acl.public-subnet-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "public-subnet-rt" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route" "igw-route" {
  route_table_id         = aws_route_table.public-subnet-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-subnet-rt-assoc" {
  subnet_id      = aws_subnet.main-public-subnet.id
  route_table_id = aws_route_table.public-subnet-rt.id
}


resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.main-vpc.id

  ingress {
    description = "mysql"
    from_port   = local.web_server_port
    to_port     = local.mysql_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "web-server-task-definition" {
  family                = "web-server-task"
  container_definitions = <<DEFINITION
  [
    {
      "name": "apache-web-server",
      "image": "167389268608.dkr.ecr.us-east-1.amazonaws.com/apache-web-server:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION
  execution_role_arn = "arn:aws:iam::167389268608:role/ecsExecRole"
  network_mode = "awsvpc"
  memory = "512"
  cpu = "256"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_cloudwatch_event_target" "web-server-et" {
  target_id = "web-server-schedule-rule-target-id"
  rule      = aws_cloudwatch_event_rule.web-server-schedule-every-1d-rule.name
  arn       = aws_ecs_cluster.ecs-cluster.arn

  ecs_target {
    task_count = 1
    task_definition_arn = "arn:aws:ecs:us-east-1:167389268608:task-definition/apache-web-server-task:1"
    launch_type = "FARGATE"
    network_configuration {
      subnets = [aws_subnet.main-public-subnet.id]
      security_groups = [aws_security_group.sg.id]
      assign_public_ip = true
    }
  }

  role_arn = "arn:aws:iam::167389268608:role/ecsEventsRole"
}

resource "aws_cloudwatch_event_rule" "web-server-schedule-every-1d-rule" {
  name        = "web-server-schedule-every-1d-rule"
  schedule_expression = "rate(24 hours)"
}


