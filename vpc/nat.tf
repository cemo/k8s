resource "aws_eip" "nat" {
  count = "${length(split(",", var.availability_zones))}"
  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = "${length(split(",", var.availability_zones))}"
  depends_on = ["aws_internet_gateway.main"]
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route" "nat" {
  count = "${length(split(",", var.availability_zones))}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.main.*.id, count.index)}"
}
