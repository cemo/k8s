resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name              = "public.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${var.max_az_count}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name              = "${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
