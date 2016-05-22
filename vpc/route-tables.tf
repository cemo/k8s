resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags {
    Name = "public-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(split(",", var.availability_zones))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count = "${length(split(",", var.availability_zones))}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "private-${var.environment}-${var.region}${element(split(",", var.availability_zones), count.index)}"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${length(split(",", var.availability_zones))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
