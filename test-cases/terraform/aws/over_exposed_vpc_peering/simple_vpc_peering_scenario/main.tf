provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "this"
}

provider "aws" {
  region = "us-east-1"
  alias = "peer"
}

locals {
  test_description = "simple VPC peering setup"
  test_name        = "NoVpcPeeringAllowedRuleTest test - use case 1"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.5.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1_1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.5.10.0/24"
}

resource "aws_subnet" "subnet1_2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.5.11.0/24"
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.7.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet2_1" {
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.7.10.0/24"
}

resource "aws_subnet" "subnet2_2" {
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.7.11.0/24"
}

/**
The code below this comment is a copying of the code for grem11n/vpc-peering/aws module,
and changing it NOT to require existing VPCs in order to run a plan.
*/
# Local Values required for inter-region peering workaround
# See https://github.com/terraform-providers/terraform-provider-aws/issues/6730
locals {
  this_vpc_id = aws_vpc.vpc1.id
  peer_vpc_id = aws_vpc.vpc2.id
}
data "aws_caller_identity" "this" {
  provider = aws.this
}
data "aws_region" "this" {
  provider = aws.this
}

data "aws_caller_identity" "peer" {
  provider = aws.peer
}
data "aws_region" "peer" {
  provider = aws.peer
}

data "aws_vpc" "this_vpc" {
  provider = aws.this
  id       = local.this_vpc_id
}

data "aws_vpc" "peer_vpc" {
  provider = aws.peer
  id       = local.peer_vpc_id
}

locals {
  this_region = data.aws_region.this.name
  peer_region = data.aws_region.peer.name
}

##########################
# VPC peering connection #
##########################
resource "aws_vpc_peering_connection" "this" {
  provider      = aws.this
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_vpc_id   = local.peer_vpc_id
  vpc_id        = local.this_vpc_id
  peer_region   = data.aws_region.peer.name
}

######################################
# VPC peering accepter configuration #
######################################
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = "true"
}

#######################
# VPC peering options #
#######################
resource "aws_vpc_peering_connection_options" "this" {
  provider                  = aws.this
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  # See https://github.com/terraform-providers/terraform-provider-aws/issues/6730
  # Until this is fixed, we must not try and set any options for cross-region peering.
  count = 1

  requester {
    allow_remote_vpc_dns_resolution  = "true"
    allow_classic_link_to_remote_vpc = "false"
    allow_vpc_to_remote_classic_link = "false"
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  # See https://github.com/terraform-providers/terraform-provider-aws/issues/6730
  # Until this is fixed, we must not try and set any options for cross-region peering.
  count = 1

  accepter {
    allow_remote_vpc_dns_resolution  = "true"
    allow_classic_link_to_remote_vpc = "false"
    allow_vpc_to_remote_classic_link = "false"
  }
}

###################
# This VPC Routes #
###################
resource "aws_route" "this_routes_region" {
  provider                  = aws.this
  route_table_id            = aws_vpc.vpc1.default_route_table_id
  destination_cidr_block    = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

###################
# Peer VPC Routes #
###################
resource "aws_route" "peer_routes_region" {
  provider                  = aws.peer
  route_table_id            = aws_vpc.vpc2.default_route_table_id
  destination_cidr_block    = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route_table" "subnet2_1" {
  vpc_id = aws_vpc.vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  }
}

resource "aws_route_table_association" "subnet2_1" {
  subnet_id = aws_subnet.subnet2_1.id
  route_table_id = aws_route_table.subnet2_1.id
}