module "vpn" {
  source = "vpn"
  on_off = "${var.vpn_on_off}"
  environment = "${var.environment}"
  vpc_id = "${aws_vpc.main.id}"
  public_subnet_ids = ["${aws_subnet.public.*.id}"]
  public_zone_id = "${aws_route53_zone.public.zone_id}"
}
