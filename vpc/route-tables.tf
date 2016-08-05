resource "aws_route_table" "public" {
  count = "${signum(var.public_subnet_count)}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "public-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${var.public_subnet_count}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "igw" {
  count = "${signum(var.public_subnet_count)}"
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
  depends_on = ["aws_route_table.public"]
}

resource "aws_route_table" "private" {
  count = "${var.private_subnet_count}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "private-${aws_subnet.private.*.availability_zone[count.index]}-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${var.private_subnet_count}"
  subnet_id = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}
