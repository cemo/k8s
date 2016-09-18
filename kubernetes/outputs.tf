output "master_dns_name" {
  value = "${aws_route53_record.master.fqdn}"
}
