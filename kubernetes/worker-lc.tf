resource "aws_launch_configuration" "worker" {
  name_prefix          = "workers.${var.environment}.${var.name}."
  image_id             = "${lookup(var.coreos_ami_id, var.region[var.environment])}"
  instance_type        = "${var.worker_instance_type[var.environment]}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  key_name             = "${var.key_name[var.environment]}"
  user_data            = "${data.template_file.worker_userdata.rendered}"

  security_groups = [
    "${aws_security_group.worker.id}",
  ]

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "worker_userdata" {
  template = "${file("${path.module}/templates/worker-cloud-config.yaml")}"

  vars {
    K8S_VER                    = "v${var.k8s_version}_coreos.0"
    MASTER_HOST                = "${aws_route53_record.master.fqdn}"
    ETCD_PROXY_INITIAL_CLUSTER = "http://${module.etcd.dns_name}:2380"
    POD_NETWORK                = "${var.pod_network}"
    SERVICE_IP_RANGE           = "${var.service_ip_range}"
    DNS_SERVICE_IP             = "${cidrhost(var.service_ip_range, 10)}"
    CA_KEY                     = "${base64encode(tls_private_key.ca.private_key_pem)}"
    CA_PEM                     = "${base64encode(tls_self_signed_cert.ca.cert_pem)}"
  }
}
