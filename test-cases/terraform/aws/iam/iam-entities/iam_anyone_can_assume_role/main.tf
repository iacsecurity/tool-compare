resource "aws_iam_role" "over-privilege-role" {
  name = "over-privilege-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": "*",
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}

