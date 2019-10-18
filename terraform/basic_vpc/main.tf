#
# main.tf
#   - Available AZs
#   - Provider
#   - VPC
#   - Subnets
#

# Find all the AWS AZs currently available
data "aws_availability_zones" "available" {}

# Setup AWS provider
provider "aws" {
  region = "${var.aws_region}"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "basic_vpc-${terraform.workspace}"
  }
}

# Create internet gateway for main VPC
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "basic_vpc-${terraform.workspace}"
  }
}

# Create route table for main VPC
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "basic_vpc-${terraform.workspace}"
  }
}

# Create a default route for main internet gateway
resource "aws_route" "default" {
  route_table_id         = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

# create 2 public subnets for main VPC
resource "aws_subnet" "main" {
  count             = "${length(data.aws_availability_zones.names)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${lookup(var.subnet_pub, count.index)}"
  vpc_id            = "${aws_vpc.main.id}"

  tags = {
    Name = "basic_vpc-${terraform.workspace}-subnet${count.index}-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Associate subnets to route table
resource "aws_route_table_association" "main" {
  count          = "${length(data.aws_availability_zones.names)}"
  subnet_id      = "${aws_subnet.main.*.id[count.index]}"
  route_table_id = "${aws_route_table.main.id}"
}
