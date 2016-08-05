data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block["${var.environment}"]}"
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
  count = "${var.public_subnet_count}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public-${data.aws_availability_zones.available.names[count.index]}-${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count = "${var.private_subnet_count}"
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index + var.public_subnet_count)}"
  tags {
    Name = "private-${data.aws_availability_zones.available.names[count.index]}-${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  count = "${signum(var.public_subnet_count)}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "k8s-${var.environment}"
  }
}
