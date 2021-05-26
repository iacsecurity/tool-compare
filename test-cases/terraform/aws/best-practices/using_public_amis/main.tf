provider "aws" {
  region = "us-east-1"
}

locals {
  description = "3 ways to create AMI's with instances"
}

data "aws_availability_zones" "available" {
  state = "available"
}

/*** Simple AMI creation ****/

resource "aws_ebs_volume" "example" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "HelloWorld_snap"
  }
}

resource "aws_ami" "example" {
  name                = "terraform-example"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ena_support = true

  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = aws_ebs_snapshot.example_snapshot.id
    volume_size = 40
  }
}

resource "aws_instance" "example_with_new_ami" {
  ami = aws_ami.example.id
  instance_type = "t3.nano"
}

/** Copying an existing AMI, making the new one private **/

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


resource "aws_ami_copy" "example" {
  name              = "terraform-example2"
  description       = "A copy of ubuntu ami"
  source_ami_id     = data.aws_ami.ubuntu.id
  source_ami_region = data.aws_availability_zones.available.id

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "example_with_copied_ami" {
  ami = aws_ami_copy.example.id
  instance_type = "t3.nano"
  
}

/** Create a private AMI from an EC2 instance **/

resource "aws_ami_from_instance" "example" {
  name               = "terraform-example3"
  source_instance_id = aws_instance.example_with_copied_ami.id
}

resource "aws_instance" "example_with_ami_from_instance" {
  ami = aws_ami_from_instance.example.id
  instance_type = "t3.nano"
}

resource "aws_instance" "public-ubuntu-from-data" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  tags = {
    Name = "public-ubuntu-from-data"
  }
}
