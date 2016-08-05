resource "aws_security_group" "kubernetes" {
  name = "kubernetes-${var.environment}"
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
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [
      "${data.terraform_remote_state.vpc.vpn_sg_id}"
    ]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [
      "${data.terraform_remote_state.vpc.vpn_sg_id}"
    ]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "kubernetes-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "aws_iam_instance_profile" "kubernetes" {
  name = "kubernetes-${var.environment}"
  roles = ["${aws_iam_role.kubernetes.name}"]
}

resource "aws_iam_role" "kubernetes" {
    name = "kubernetes-${var.environment}"
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
}

resource "aws_iam_role_policy" "kubernetes" {
  name = "kubernetes-${var.environment}"
  role = "${aws_iam_role.kubernetes.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "route53:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
