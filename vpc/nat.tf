resource "aws_eip" "nat" {
  count = "${var.private_subnet_count}"
  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = "${var.private_subnet_count}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
}

resource "aws_route" "nat" {
  count = "${var.private_subnet_count}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.main.*.id[count.index]}"
}
