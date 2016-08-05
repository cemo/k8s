resource "aws_autoscaling_group" "workers" {
  name = "kubernetes-workers-${var.environment}"
  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]
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
    propagate_at_launch = true
  }
  tag {
    key = "KubernetesCluster"
    value = "${data.terraform_remote_state.vpc.kubernetes_cluster}"
    propagate_at_launch = true
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
  user_data = "${data.template_file.worker_cloud_config.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "worker_cloud_config" {
  template = "${file("${path.module}/templates/worker-cloud-config.yaml")}"
  vars {
    K8S_VER = "v${var.k8s_version}_coreos.0"
    MASTER_HOST = "${aws_route53_record.master.fqdn}"
    ETCD_PROXY_INITIAL_CLUSTER = "http://${data.terraform_remote_state.etcd.dns_name}:2380"
    ETCD_ENDPOINTS = "http://0.0.0.0:2379"
    POD_NETWORK = "${var.pod_network}"
    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP = "${cidrhost(var.service_ip_range, 10)}"
    CA_PEM = "${base64encode(file("${path.module}/ssl/ca.pem"))}"
    CA_KEY_PEM = "${base64encode(file("${path.module}/ssl/ca-key.pem"))}"
  }
}
