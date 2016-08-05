resource "aws_instance" "master" {
  depends_on = ["aws_iam_instance_profile.kubernetes", "aws_iam_role.kubernetes"]
  ami = "${var.ami_id}"
  instance_type = "${var.master_instance_type}"
  key_name = "${var.environment}"
  subnet_id = "${data.terraform_remote_state.vpc.private_subnet_ids[0]}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.id}"
  user_data = "${data.template_file.master_cloud_config.rendered}"
  vpc_security_group_ids = [
    "${aws_security_group.kubernetes.id}"
  ]
  tags {
    Name = "kubernetes-master-${var.environment}"
    Environment = "${var.environment}"
    KubernetesCluster = "${data.terraform_remote_state.vpc.kubernetes_cluster}"
  }
}

data "template_file" "master_cloud_config" {
  template = "${file("${path.module}/templates/master-cloud-config.yaml")}"
  vars {
    K8S_VER = "v${var.k8s_version}_coreos.0"
    ETCD_PROXY_INITIAL_CLUSTER = "http://${data.terraform_remote_state.etcd.dns_name}:2380"
    ETCD_ENDPOINTS = "http://0.0.0.0:2379"
    POD_NETWORK = "${var.pod_network}"
    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP = "${cidrhost(var.service_ip_range, 10)}"
    CA_PEM = "${base64encode(file("${path.module}/ssl/ca.pem"))}"
    APISERVER_PEM = "${base64encode(file("${path.module}/ssl/apiserver.pem"))}"
    APISERVER_KEY_PEM = "${base64encode(file("${path.module}/ssl/apiserver-key.pem"))}"
  }
}

resource "aws_route53_record" "master" {
  zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
  name = "kubernetes-master"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.master.private_ip}"]
}
