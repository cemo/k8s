resource "aws_iam_instance_profile" "etcd" {
  name = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
  roles = ["${aws_iam_role.etcd.name}"]
}

resource "aws_iam_role" "etcd" {
  name = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
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

resource "aws_iam_role_policy" "etcd" {
  name = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
  role = "${aws_iam_role.etcd.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "autoscaling:Describe*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
