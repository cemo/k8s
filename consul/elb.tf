resource "aws_elb" "consul" {
  name = "consul-${var.environment}"
  internal = true
  subnets = ["${split(",", terraform_remote_state.vpc.output.private_subnet_ids)}"]
  security_groups = ["${aws_security_group.elb_private.id}"]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 8500
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8500/v1/agent/self"
    interval = 30
  }
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  tags {
    Name = "consul-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "elb_private" {
  name_prefix = "consul-elb-${var.environment}"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${terraform_remote_state.vpc.output.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "consul_private" {
  zone_id = "${terraform_remote_state.vpc.output.private_zone_id}"
  name = "consul"
  type = "A"
  alias {
    name = "${aws_elb.consul.dns_name}"
    zone_id = "${aws_elb.consul.zone_id}"
    evaluate_target_health = true
  }
}
