resource "aws_route53_record" "vpn" {
  zone_id = "${var.hosted_zone_id}"
  name    = "vpn"
  type    = "A"
  ttl     = "60"
  records = ["${aws_eip.vpn.public_ip}"]
}
