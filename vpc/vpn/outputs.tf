output "dns_name" {
  value = "${aws_route53_record.vpn.fqdn}"
}

output "sg_id" {
  value = "${aws_security_group.vpn.id}"
}
