resource "aws_elb" "etcd" {
  name     = "etcd-${var.name}-${var.environment}"
  internal = true
  subnets  = ["${var.subnet_ids}"]

  listener {
    lb_port           = 22
    lb_protocol       = "tcp"
    instance_port     = 22
    instance_protocol = "tcp"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 2379
    instance_protocol = "http"
  }

  listener {
    lb_port           = 2380
    lb_protocol       = "tcp"
    instance_port     = 2380
    instance_protocol = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 3
    target              = "HTTP:2379/v2/stats/self"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = [
    "${aws_security_group.etcd_elb.id}",
  ]

  tags {
    Name        = "etcd.${var.environment}.${var.name}"
    Environment = "${var.environment}"
  }
}
