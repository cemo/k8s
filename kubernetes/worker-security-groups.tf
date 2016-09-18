resource "aws_security_group" "worker" {
  name_prefix = "worker.${var.environment}.${var.name}."
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name              = "worker.${var.environment}.${var.name}"
    Environment       = "${var.environment}"
    KubernetesCluster = "${data.terraform_remote_state.vpc.kubernetes_cluster}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "worker_ssh" {
  security_group_id        = "${aws_security_group.worker.id}"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${data.terraform_remote_state.vpc.vpn_sg_id}"
}

resource "aws_security_group_rule" "worker_master_comms" {
  security_group_id        = "${aws_security_group.worker.id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "worker_worker_comms" {
  security_group_id = "${aws_security_group.worker.id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "worker_outbound" {
  security_group_id = "${aws_security_group.worker.id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
