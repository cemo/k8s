module "vpn" {
  source         = "../vpn"
  name           = "${var.name}"
  environment    = "${var.environment}"
  region         = "${var.region[var.environment]}"
  vpc_id         = "${aws_vpc.main.id}"
  subnet_id      = "${aws_subnet.public.0.id}"
  hosted_zone_id = "${aws_route53_zone.public.id}"
}

output "vpn_public_ip" {
  value = "${module.vpn.public_ip}"
}

output "vpn_private_ip" {
  value = "${module.vpn.private_ip}"
}

output "vpn_sg_id" {
  value = "${module.vpn.sg_id}"
}

output "vpn_dns_name" {
  value = "${module.vpn.dns_name}"
}
