resource "aws_route53_zone" "private" {
  name   = "${var.domain_env_prefix[var.environment]}${var.name}.internal.${var.domain}"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route53_zone" "public" {
  name = "${var.domain_env_prefix[var.environment]}${var.name}.${var.domain}"
}

resource "aws_route53_record" "ns" {
  zone_id = "${var.domain_hosted_zone_id[var.environment]}"
  name    = "${var.domain_env_prefix[var.environment]}${var.name}.${var.domain}"
  type    = "NS"
  ttl     = "60"
  records = ["${aws_route53_zone.public.name_servers}"]
}
