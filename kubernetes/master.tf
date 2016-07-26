resource "aws_instance" "master" {
  ami = "${var.ami_id}"
  instance_type = "${var.master_instance_type}"
  key_name = "${var.environment}"
  subnet_id = "${element(split(",", terraform_remote_state.vpc.output.private_subnet_ids), 0)}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  user_data = "${template_file.master_cloud_config.rendered}"
  vpc_security_group_ids = [
    "${aws_security_group.kubernetes.id}"
  ]
  tags {
    Name = "kubernetes-master-${var.environment}"
    Environment = "${var.environment}"
  }
  provisioner "file" {
    connection {
      user = "core"
      private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_host = "${terraform_remote_state.vpc.output.bastion_dns_name}"
      timeout = "2m"
    }
    source = "ssl/ca.pem"
    destination = "~/ca.pem"
  }
  provisioner "file" {
    connection {
      user = "core"
      private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_host = "${terraform_remote_state.vpc.output.bastion_dns_name}"
      timeout = "2m"
    }
    source = "ssl/apiserver.pem"
    destination = "~/apiserver.pem"
  }
  provisioner "file" {
    connection {
      user = "core"
      private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_host = "${terraform_remote_state.vpc.output.bastion_dns_name}"
      timeout = "2m"
    }
    source = "ssl/apiserver-key.pem"
    destination = "~/apiserver-key.pem"
  }
  provisioner "remote-exec" {
    connection {
      user = "core"
      private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_private_key = "${file("${var.key_path}/${var.environment}.pem")}"
      bastion_host = "${terraform_remote_state.vpc.output.bastion_dns_name}"
      timeout = "2m"
    }
    inline = [
      "sudo mkdir -p /etc/kubernetes/ssl",
      "sudo mv ~/*.pem /etc/kubernetes/ssl/",
      "sudo chmod 600 /etc/kubernetes/ssl/*-key.pem",
      "sudo chown root:root /etc/kubernetes/ssl/*-key.pem"
    ]
  }
}

resource "template_file" "master_cloud_config" {
  template = "${file("${path.module}/templates/master-cloud-config.yaml")}"
  vars {
    K8S_VERSION = "${var.k8s_version}"
    ETCD_CLUSTER = "${terraform_remote_state.etcd.output.dns_name}"
    POD_NETWORK = "${var.pod_network}"
    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP = "${cidrhost(var.service_ip_range, 10)}"
  }
}
