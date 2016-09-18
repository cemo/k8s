resource "aws_route_table" "private" {
  count  = "${var.max_az_count}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name              = "private.${aws_subnet.private.*.availability_zone[count.index]}.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${var.environment}.${var.name}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${var.max_az_count}"
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}

resource "aws_eip" "nat" {
  count = "${var.max_az_count}"
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = "${var.max_az_count}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
}

resource "aws_route" "nat" {
  count                  = "${var.max_az_count}"
  route_table_id         = "${aws_route_table.private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.main.*.id[count.index]}"
}
