resource "aws_launch_configuration" "etcd" {
  name_prefix = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}."
  image_id = "${var.ami_id[data.terraform_remote_state.vpc.region]}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.etcd.id}"
  key_name = "${data.terraform_remote_state.vpc.vpc_name}-${var.environment}"
  security_groups = ["${aws_security_group.etcd.id}"]
  user_data = "${file("${path.module}/files/cloud-config.yml")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "etcd" {
  name_prefix = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}."
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${data.terraform_remote_state.vpc.vpn_sg_id}",
      "${aws_security_group.etcd_elb.id}"
    ]
  }
  ingress {
    from_port = 2379
    to_port = 2380
    protocol = "tcp"
    self = true
    cidr_blocks = ["${data.terraform_remote_state.vpc.cidr_block}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "etcd.${data.terraform_remote_state.vpc.vpc_name}.${var.environment}"
    Environment = "${var.environment}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
