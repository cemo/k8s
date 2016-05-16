resource "aws_autoscaling_group" "consul" {
  name = "consul-${var.environment}"
  min_size = "${var.node_count}"
  max_size = "${var.node_count}"
  desired_capacity = "${var.node_count}"
  wait_for_elb_capacity = true
  health_check_grace_period = 300
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.consul.name}"
  load_balancers = [
    "${aws_elb.consul.name}"
  ]
  vpc_zone_identifier = ["${split(",", terraform_remote_state.vpc.output.private_subnet_ids)}"]
  tag {
    key = "Name"
    value = "consul-${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
