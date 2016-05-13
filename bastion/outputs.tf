output "bastion_security_group_id" {
  value = "${aws_security_group.bastion_private.id}"
}

output "bastion_dns_name" {
  value = "${aws_route53_record.bastion.fqdn}"
}
