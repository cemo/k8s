resource "aws_route53_zone" "private" {
  name = "${var.environment}.${var.private_domain}"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route53_zone" "public" {
  name = "${var.environment}.${var.public_domain}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${var.domain_hosted_zone_id}"
  name = "${var.environment}.${var.public_domain}"
  type = "NS"
  ttl = "30"
  records = [
    "${aws_route53_zone.public.name_servers.0}",
    "${aws_route53_zone.public.name_servers.1}",
    "${aws_route53_zone.public.name_servers.2}",
    "${aws_route53_zone.public.name_servers.3}"
  ]
}
