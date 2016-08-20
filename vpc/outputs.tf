output "region" {
  value = "${var.region}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "availability_zones" {
  value = ["${var.availability_zones[var.region]}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "nat_gateway_ips" {
  value = ["${aws_nat_gateway.main.*.public_ip}"]
}

output "public_zone_id" {
  value = "${aws_route53_zone.public.zone_id}"
}

output "private_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "kubernetes_cluster" {
  value = "${var.name}.${var.environment}"
}

output "vpn_public_ip" {
  value = "${aws_eip.vpn.public_ip}"
}

output "vpn_private_ip" {
  value = "${aws_instance.vpn.private_ip}"
}

output "vpn_sg_id" {
  value = "${aws_security_group.vpn.id}"
}

output "vpn_dns_name" {
  value = "${aws_route53_record.vpn.fqdn}"
}
