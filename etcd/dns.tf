resource "aws_route53_record" "etcd" {
  zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
  name = "etcd"
  type = "A"
  alias {
    name = "${aws_elb.etcd.dns_name}"
    zone_id = "${aws_elb.etcd.zone_id}"
    evaluate_target_health = true
  }
}
