# Two roles, both are bad and should be caught. The test will be considered "passed" only if the tool
# catches both roles.

resource "aws_iam_role" "over-privilege-role1" {
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

resource "aws_iam_role" "over-privilege-role2" {
  name = "over-privilege-role"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        },
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "AWS": "*"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}
