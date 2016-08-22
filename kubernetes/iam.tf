resource "aws_iam_instance_profile" "kubernetes" {
  name = "kubernetes.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
  roles = ["${aws_iam_role.kubernetes.name}"]
}

resource "aws_iam_role" "kubernetes" {
    name = "kubernetes.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
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
  name = "kubernetes.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
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
