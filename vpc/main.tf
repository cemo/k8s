resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block[var.environment]}"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags {
    Name = "${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.availability_zones[var.region])}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${element(var.availability_zones[var.region], count.index)}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public-${var.region}${element(var.availability_zones[var.region], count.index)}-${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.availability_zones[var.region])}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${var.region}${element(var.availability_zones[var.region], count.index)}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + length(aws_subnet.public.*.id))}"
  tags {
    Name = "private-${var.region}${element(var.availability_zones[var.region], count.index)}-${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}
