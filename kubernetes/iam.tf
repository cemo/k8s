resource "aws_iam_instance_profile" "kubernetes" {
  name  = "kubernetes.${var.environment}.${var.name}"
  roles = ["${aws_iam_role.kubernetes.name}"]
}

resource "aws_iam_role" "kubernetes" {
  name = "kubernetes.${var.environment}.${var.name}"

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
  name = "kubernetes.${var.environment}.${var.name}"
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
