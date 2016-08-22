resource "aws_elb" "etcd" {
  name = "etcd-${data.terraform_remote_state.vpc.vpc_name}-${var.environment}"
  internal = true
  subnets = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
  listener {
    lb_port = 22
    lb_protocol = "tcp"
    instance_port = 22
    instance_protocol = "tcp"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 2379
    instance_protocol = "http"
  }
  listener {
    lb_port = 2380
    lb_protocol = "tcp"
    instance_port = 2380
    instance_protocol = "tcp"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 4
    timeout = 3
    target = "HTTP:2379/v2/stats/self"
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
    Name = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "etcd_elb" {
  name_prefix = "etcd-elb.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}."
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${data.terraform_remote_state.vpc.vpn_sg_id}"
    ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "${data.terraform_remote_state.vpc.cidr_block}"
    ]
  }
  ingress {
    from_port = 2380
    to_port = 2380
    protocol = "tcp"
    cidr_blocks = [
      "${data.terraform_remote_state.vpc.cidr_block}"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "etcd-elb.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
    Environment = "${var.environment}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
