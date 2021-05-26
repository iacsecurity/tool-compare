provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user-1" {
  name = "user-1"
}

resource "aws_iam_policy" "managed-policy" {
  name        = "managed-policy"
  description = "A test policy"
  policy      = <<EOF
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

resource "aws_iam_user_policy_attachment" "managed-policy-attach" {
  user       = aws_iam_user.user-1.name
  policy_arn = aws_iam_policy.managed-policy.arn
}
