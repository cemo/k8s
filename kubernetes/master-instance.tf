resource "aws_instance" "master" {
  ami                  = "${lookup(var.coreos_ami_id, var.region[var.environment])}"
  instance_type        = "${var.master_instance_type[var.environment]}"
  key_name             = "${var.key_name[var.environment]}"
  subnet_id            = "${data.terraform_remote_state.vpc.private_subnet_ids[0]}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  user_data            = "${data.template_file.master_userdata.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.master.id}",
  ]

  root_block_device {
    volume_type = "gp2"
  }

  tags {
    Name              = "master.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${data.terraform_remote_state.vpc.kubernetes_cluster}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "master_userdata" {
  template = "${file("${path.module}/templates/master-cloud-config.yaml")}"

  vars {
    K8S_VER                    = "v${var.k8s_version}_coreos.0"
    ETCD_PROXY_INITIAL_CLUSTER = "http://${module.etcd.dns_name}:2380"
    POD_NETWORK                = "${var.pod_network}"
    SERVICE_IP_RANGE           = "${var.service_ip_range}"
    DNS_SERVICE_IP             = "${cidrhost(var.service_ip_range, 10)}"
    CA_PEM                     = "${base64encode(tls_self_signed_cert.ca.cert_pem)}"
    APISERVER_KEY              = "${base64encode(tls_private_key.apiserver.private_key_pem)}"
    APISERVER_PEM              = "${base64encode(tls_locally_signed_cert.apiserver.cert_pem)}"
  }
}
