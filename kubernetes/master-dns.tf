resource "aws_route53_record" "master" {
  zone_id = "${data.terraform_remote_state.vpc.private_hosted_zone_id}"
  name    = "master"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.master.private_ip}"]
}
