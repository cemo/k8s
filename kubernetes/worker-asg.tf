resource "aws_autoscaling_group" "workers" {
  name                      = "workers.${var.environment}.${var.name}"
  force_delete              = true
  vpc_zone_identifier       = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
  desired_capacity          = "${var.desired_workers[var.environment]}"
  min_size                  = "${var.min_workers[var.environment]}"
  max_size                  = "${var.max_workers[var.environment]}"
  launch_configuration      = "${aws_launch_configuration.worker.name}"
  health_check_grace_period = 300
  health_check_type         = "EC2"

  tag {
    key                 = "Name"
    value               = "worker.${var.environment}.${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "KubernetesCluster"
    value               = "${data.terraform_remote_state.vpc.kubernetes_cluster}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
