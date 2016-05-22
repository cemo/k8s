resource "aws_route53_record" "gocd" {
  zone_id = "${terraform_remote_state.vpc.output.public_zone_id}"
  name = "gocd"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.gocd.public_ip}"]
}
