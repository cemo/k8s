resource "aws_eip" "nat" {
  count = "${length(split(",", lookup(var.availability_zones, var.environment)))}"
  vpc = true
}

resource "aws_nat_gateway" "main" {
  depends_on = ["aws_internet_gateway.main"]
  count = "${length(split(",", lookup(var.availability_zones, var.environment)))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route" "nat" {
  count = "${length(split(",", lookup(var.availability_zones, var.environment)))}"
  route_table_id = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.main.*.id, count.index)}"
}
