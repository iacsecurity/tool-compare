provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "group-1" {
  name = "group-1"
  path = "/"
}

resource "aws_iam_group_policy" "allow-policy" {
  name = "allow-policy"
  group = aws_iam_group.group-1.name

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "iam:Create*"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:iam::111111111111:group/${aws_iam_group.group-1.name}"
      }
    ]
  }
  EOF

  depends_on = [aws_iam_group.group-1]
}
