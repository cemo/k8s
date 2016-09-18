data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block[var.environment]}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags {
    Name              = "${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}

resource "aws_subnet" "private" {
  count             = "${var.max_az_count}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)}"

  tags {
    Name              = "private.${data.aws_availability_zones.available.names[count.index]}.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}

resource "aws_subnet" "public" {
  count                   = "${var.max_az_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + length(aws_subnet.private.*.id))}"
  map_public_ip_on_launch = true

  tags {
    Name              = "public.${data.aws_availability_zones.available.names[count.index]}.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}
