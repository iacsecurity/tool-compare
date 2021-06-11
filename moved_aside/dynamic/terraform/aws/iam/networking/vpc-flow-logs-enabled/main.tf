provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_permissions_needed" {
  name = "lambda_permissions_needed"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "index.js"
    output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "lambda_in_vpc_without_flow_logs"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs12.x"

  vpc_config {
    subnet_ids = ["subnet-7e8d8433"] # This is one of the default subnets in vpc-4bfa6f36 which is the default VPC of us-east-1
    security_group_ids = ["sg-0b1019d78b92774ab"]
  }
}

