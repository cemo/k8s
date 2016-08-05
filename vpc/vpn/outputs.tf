output "dns_name" {
  value = "${aws_route53_record.vpn.fqdn}"
}

output "private_ip" {
  value = "${aws_instance.vpn.private_ip}"
}

output "public_ip" {
  value = "${aws_eip.vpn.public_ip}"
}

output "sg_id" {
  value = "${aws_security_group.vpn.id}"
}
