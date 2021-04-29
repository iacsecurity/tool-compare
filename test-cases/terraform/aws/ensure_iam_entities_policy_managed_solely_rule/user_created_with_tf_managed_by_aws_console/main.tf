provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user-2" {
  name = "user-2"
}

resource "aws_iam_user_policy" "policy" {
  name = "inline-policy"
  user = aws_iam_user.user-2.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}