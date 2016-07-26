resource "aws_autoscaling_group" "workers" {
  name = "kubernetes-workers-${var.environment}"
  vpc_zone_identifier = ["${split(",", terraform_remote_state.vpc.output.private_subnet_ids)}"]
  desired_capacity = "${var.desired_workers}"
  min_size = "${var.min_workers}"
  max_size = "${var.max_workers}"
  launch_configuration = "${aws_launch_configuration.worker.name}"
  health_check_grace_period = 300
  health_check_type = "EC2"
  tag {
    key = "Name"
    value = "kubernetes-worker-${var.environment}"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "worker" {
  name_prefix = "kubernetes-worker-${var.environment}-"
  image_id = "${var.ami_id}"
  instance_type = "${var.worker_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  key_name = "${var.environment}"
  security_groups = ["${aws_security_group.kubernetes.id}"]
  user_data = "${template_file.worker_cloud_config.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "worker_cloud_config" {
  template = "${file("${path.module}/templates/worker-cloud-config.yaml")}"
  vars {
    K8S_VERSION = "${var.k8s_version}"
    ETCD_CLUSTER = "http://${terraform_remote_state.etcd.output.dns_name}:2380"
    POD_NETWORK = "${var.pod_network}"
    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP = "${cidrhost(var.service_ip_range, 10)}"
    MASTER_API_SERVER = "http://${aws_route53_record.master.fqdn}:8080"
  }
  lifecycle {
    create_before_destroy = true
  }
}
