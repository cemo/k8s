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
}

resource "template_file" "master_cloud_config" {
  template = "${file("${path.module}/templates/master-cloud-config.yaml")}"
  vars {
    K8S_VERSION = "${var.k8s_version}"
    ETCD_CLUSTER = "http://${terraform_remote_state.etcd.output.dns_name}:2380"
    POD_NETWORK = "${var.pod_network}"
    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP = "${cidrhost(var.service_ip_range, 10)}"
  }
}

resource "aws_route53_record" "master" {
  zone_id = "${terraform_remote_state.vpc.output.private_zone_id}"
  name = "kubernetes-master"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.master.private_ip}"]
}
