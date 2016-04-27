resource "aws_route53_zone" "subdomain" {
  name = "${var.environment}.${var.domain}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${var.domain_hosted_zone_id}"
  name = "${var.environment}.${var.domain}"
  type = "NS"
  ttl = "30"
  records = [
    "${aws_route53_zone.subdomain.name_servers.0}",
    "${aws_route53_zone.subdomain.name_servers.1}",
    "${aws_route53_zone.subdomain.name_servers.2}",
    "${aws_route53_zone.subdomain.name_servers.3}"
  ]
}

resource "aws_route53_zone" "private" {
  name = "${var.environment}.${var.domain}"
  vpc_id = "${aws_vpc.main.id}"
}
