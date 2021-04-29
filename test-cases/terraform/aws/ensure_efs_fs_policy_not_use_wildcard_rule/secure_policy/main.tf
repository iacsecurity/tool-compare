provider "aws" {
  region = "us-east-1"
}

resource "aws_efs_file_system" "secure" {
  creation_token = "efs-secure"

  tags = {
    Name = "Secure"
  }
}

resource "aws_efs_file_system_policy" "secure_policy" {
  file_system_id = aws_efs_file_system.secure.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "ExampleStatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "elasticfilesystem:UpdateFileSystem",
                "elasticfilesystem:DeleteFileSystem",
                "elasticfilesystem:CreateMountTarget"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}