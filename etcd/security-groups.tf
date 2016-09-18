resource "aws_security_group" "etcd" {
  name_prefix = "etcd.${var.environment}.${var.name}."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${var.ssh_security_group_ids}",
      "${aws_security_group.etcd_elb.id}",
    ]
  }

  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "etcd.${var.environment}.${var.name}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "etcd_elb" {
  name_prefix = "elb.etcd.${var.environment}.${var.name}."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${var.ssh_security_group_ids}",
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  ingress {
    from_port = 2380
    to_port   = 2380
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "elb.etcd.${var.environment}.${var.name}"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
