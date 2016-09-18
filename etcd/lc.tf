resource "aws_launch_configuration" "etcd" {
  name_prefix          = "etcd.${var.environment}.${var.name}."
  image_id             = "${lookup(var.coreos_ami_id, var.region)}"
  instance_type        = "${var.instance_type[var.environment]}"
  iam_instance_profile = "${aws_iam_instance_profile.etcd.id}"
  key_name             = "${var.key_name[var.environment]}"
  security_groups      = ["${aws_security_group.etcd.id}"]
  user_data            = "${file("${path.module}/files/cloud-config.yml")}"

  root_block_device {
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
