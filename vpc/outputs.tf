output "region" {
  value = "${var.region}"
}

output "id" {
  value = "${aws_vpc.main.id}"
}

output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "private_subnet_ids" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "private_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "public_zone_id" {
  value = "${aws_route53_zone.public.zone_id}"
}

output "bastion_sg_id" {
  value = "${aws_security_group.bastion.id}"
}

output "bastion_dns_name" {
  value = "${aws_route53_record.bastion.fqdn}"
}

output "kubernetes_cluster" {
  value = "${var.kubernetes_cluster}"
}
