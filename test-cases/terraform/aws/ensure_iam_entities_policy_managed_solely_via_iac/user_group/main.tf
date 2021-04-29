provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user1" {
  name = "user-1"
}

resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"
}

resource "aws_iam_user_group_membership" "user-dev" {
  user = aws_iam_user.user1.name

  groups = [
    aws_iam_group.developers.name
  ]
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy-5923"
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

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.policy.arn
}
