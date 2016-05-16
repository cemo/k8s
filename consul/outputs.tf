output "dns_name" {
  value = "${aws_route53_record.consul_private.fqdn}"
}

output "security_group_id" {
  value = "${aws_security_group.consul.id}"
}
