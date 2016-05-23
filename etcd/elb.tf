resource "aws_elb" "etcd" {
  internal = true
  subnets = ["${split(",", terraform_remote_state.vpc.output.private_subnet_ids)}"]
  instances = ["${aws_instance.etcd.*.id}"]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 2379
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 4
    timeout = 3
    target = "HTTP:2379/health"
    interval = 30
  }
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  security_groups = [
    "${aws_security_group.etcd_elb.id}"
  ]
  tags {
    Name = "etcd-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "etcd_elb" {
  name_prefix = "etcd-elb-${var.environment}-"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "${terraform_remote_state.vpc.output.cidr_block}"
    ]
  }
  tags {
    Name = "etcd-elb-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "etcd_elb_egress" {
  type = "egress"
  from_port = 2379
  to_port = 2379
  protocol = "tcp"
  security_group_id = "${aws_security_group.etcd_elb.id}"
  source_security_group_id = "${aws_security_group.etcd_instance.id}"
}
