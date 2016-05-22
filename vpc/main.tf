resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags {
    Name = "${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(split(",", var.availability_zones))}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${element(split(",", var.availability_zones), count.index)}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)}"
  tags {
    Name = "private-${var.environment}-${var.region}${element(split(",", var.availability_zones), count.index)}"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(split(",", var.availability_zones))}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${element(split(",", var.availability_zones), count.index)}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + 3)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public-${var.environment}-${var.region}${element(split(",", var.availability_zones), count.index)}"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.environment}"
    Environment = "${var.environment}"
  }
}
