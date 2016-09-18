module "etcd" {
  source         = "../etcd"
  name           = "${var.name}"
  environment    = "${var.environment}"
  region         = "${var.region[var.environment]}"
  vpc_id         = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr_block = "${data.terraform_remote_state.vpc.cidr_block}"
  subnet_ids     = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
  hosted_zone_id = "${data.terraform_remote_state.vpc.private_hosted_zone_id}"

  ssh_security_group_ids = [
    "${data.terraform_remote_state.vpc.vpn_sg_id}",
  ]
}

output "etcd_dns_name" {
  value = "${module.etcd.dns_name}"
}
