resource "aws_launch_configuration" "consul" {
  name_prefix = "consul-${var.environment}"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "consul-${var.environment}"
  iam_instance_profile = "${aws_iam_instance_profile.consul.name}"
  user_data = "${template_file.userdata.rendered}"
  security_groups = [
    "${aws_security_group.consul.id}",
    "${terraform_remote_state.bastion.output.security_group_id}"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "consul" {
  name_prefix = "consul-${var.environment}"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  ingress {
    self = true
    from_port = 8300
    to_port = 8300
    protocol = "tcp"
  }
  ingress {
    self = true
    from_port = 8301
    to_port = 8302
    protocol = "tcp"
  }
  ingress {
    self = true
    from_port = 8301
    to_port = 8302
    protocol = "udp"
  }
  ingress {
    self = true
    from_port = 8400
    to_port = 8400
    protocol = "tcp"
  }
  ingress {
    self = true
    from_port = 8500
    to_port = 8500
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.elb_private.id}"
    ]
  }
  ingress {
    self = true
    from_port = 8600
    to_port = 8600
    protocol = "tcp"
  }
  ingress {
    self = true
    from_port = 8600
    to_port = 8600
    protocol = "udp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "userdata" {
  template = "${file("userdata.sh")}"
  vars {
    region = "${var.region}"
    datacenter = "devscape-${var.environment}"
    node_count = "${var.node_count}"
    elb_name = "${aws_elb.consul.name}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "consul" {
  name = "consul-${var.environment}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:DescribeLoadBalancers"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "consul" {
  name = "consul-${var.environment}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "consul" {
  name = "consul-${var.environment}"
  roles = ["${aws_iam_role.consul.name}"]
  policy_arn = "${aws_iam_policy.consul.arn}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "consul" {
  name = "consul-${var.environment}"
  roles = ["${aws_iam_role.consul.name}"]
  lifecycle {
    create_before_destroy = true
  }
}
