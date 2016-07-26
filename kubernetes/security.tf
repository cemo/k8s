resource "aws_security_group" "kubernetes" {
  name = "kubernetes-${var.environment}"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${terraform_remote_state.vpc.output.bastion_sg_id}"
    ]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [
      "${terraform_remote_state.vpc.output.bastion_sg_id}"
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
