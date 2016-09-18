resource "aws_vpc_endpoint" "s3" {
  vpc_id          = "${aws_vpc.main.id}"
  service_name    = "com.amazonaws.${var.region[var.environment]}.s3"
  route_table_ids = ["${aws_route_table.private.*.id}"]
}
