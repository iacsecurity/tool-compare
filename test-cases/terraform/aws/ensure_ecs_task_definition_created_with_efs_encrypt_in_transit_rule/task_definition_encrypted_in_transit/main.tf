provider "aws" {
  region = "us-east-1"
}

resource "aws_efs_file_system" "test" {
  creation_token = "cloudrail-test"
}

resource "aws_ecs_task_definition" "service" {
  family                = "cloudrail-test-encryption"
  container_definitions = <<DEFINITION
[
    {
        "name": "first",
        "image": "service-first",
        "cpu": 10,
        "memory": 512,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    },
    {
        "name": "second",
        "image": "service-second",
        "cpu": 10,
        "memory": 256,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 443,
                "hostPort": 443
            }
        ]
    }
]
  DEFINITION
  volume {
    name = "service-storage"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.test.id
      root_directory     = "/opt/data"
      transit_encryption = "ENABLED"
    }
  }
}
