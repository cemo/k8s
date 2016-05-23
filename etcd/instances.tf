resource "aws_instance" "etcd" {
  count = "${var.node_count}"
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(split(",", terraform_remote_state.vpc.output.private_subnet_ids), count.index)}"
  key_name = "${var.environment}"
  security_groups = [
    "${aws_security_group.etcd_instance.id}"
  ]
  user_data = "${template_file.cloud_config.rendered}"
  tags {
    Name = "etcd-${var.environment}"
    Environment = "${var.environment}"
  }
}

resource "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.tpl")}"
  vars {
    discovery_url = "${var.discovery_url}"
  }
}

resource "aws_security_group" "etcd_instance" {
  name_prefix = "etcd-instance-${var.environment}-"
  vpc_id = "${terraform_remote_state.vpc.output.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${terraform_remote_state.vpc.output.bastion_sg_id}"
    ]
  }
  ingress {
    from_port = 2379
    to_port = 2379
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.etcd_elb.id}"
    ]
  }
  ingress {
    from_port = 2380
    to_port = 2380
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 4001
    to_port = 4001
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 7001
    to_port = 7001
    protocol = "tcp"
    self = true
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "etcd-instance-${var.environment}"
    Environment = "${var.environment}"
  }
}
