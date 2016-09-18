output "account_id" {
  value = "${var.account_id[var.environment]}"
}

output "region" {
  value = "${var.region[var.environment]}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "availability_zones" {
  value = ["${aws_subnet.private.*.availability_zone}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.private.*.id}"]
}

output "nat_gateway_ips" {
  value = ["${aws_nat_gateway.main.*.public_ip}"]
}

output "private_hosted_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "private_domain_name" {
  value = "${var.environment}.${var.name}.internal.${var.domain}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "public_hosted_zone_id" {
  value = "${aws_route53_zone.public.zone_id}"
}

output "public_domain_name" {
  value = "${var.environment}.${var.name}.${var.domain}"
}

output "kubernetes_cluster" {
  value = "${var.environment}.${var.name}"
}

output "s3_endpoint_id" {
  value = "${aws_vpc_endpoint.s3.id}"
}
