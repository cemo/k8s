resource "aws_eip" "vpn" {
  vpc = true
}

resource "aws_eip_association" "vpn" {
  instance_id   = "${aws_instance.vpn.id}"
  allocation_id = "${aws_eip.vpn.id}"
}

resource "aws_instance" "vpn" {
  ami               = "${var.openvpn_ami_id[var.region]}"
  subnet_id         = "${var.subnet_id}"
  instance_type     = "${var.instance_type[var.environment]}"
  key_name          = "${var.key_name[var.environment]}"
  source_dest_check = false
  user_data         = "${data.template_file.vpn.rendered}"

  root_block_device {
    volume_type = "gp2"
  }

  vpc_security_group_ids = [
    "${aws_security_group.vpn.id}",
  ]

  tags {
    Name        = "vpn.${var.environment}.${var.name}"
    Environment = "${var.environment}"
  }
}

data "template_file" "vpn" {
  template = "${file("${path.module}/templates/userdata")}"

  vars {
    public_hostname = "${aws_route53_record.vpn.fqdn}"
    reroute_dns     = "1"
  }
}
