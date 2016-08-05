output "aws_account_id" {
  value = "${var.aws_account_id}"
}

output "region" {
  value = "${var.region}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "private_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "public_zone_id" {
  value = "${aws_route53_zone.public.zone_id}"
}

output "kubernetes_cluster" {
  value = "k8s-${var.environment}"
}

output "vpn_private_ip" {
  value = "${module.vpn.private_ip}"
}

output "vpn_public_ip" {
  value = "${module.vpn.public_ip}"
}

output "vpn_sg_id" {
  value = "${module.vpn.sg_id}"
}

output "vpn_dns_name" {
  value = "${module.vpn.dns_name}"
}

output "nat_gateway_ips" {
  value = ["${aws_nat_gateway.main.*.public_ip}"]
}
