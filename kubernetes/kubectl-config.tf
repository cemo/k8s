data "template_file" "kubectl_config" {
  template = "${file("${path.module}/templates/kubectl-config.yaml")}"

  vars {
    MASTER_HOST = "${aws_route53_record.master.fqdn}"
  }
}

resource "null_resource" "kubectl_config" {
  count = "${var.kubectl_config}"

  triggers {
    ca_key        = "${tls_private_key.ca.private_key_pem}"
    ca_pem        = "${tls_self_signed_cert.ca.cert_pem}"
    apiserver_key = "${tls_private_key.apiserver.private_key_pem}"
    apiserver_pem = "${tls_locally_signed_cert.apiserver.cert_pem}"
  }

  provisioner "local-exec" {
    command = "mkdir -p \"$HOME/.kube/ssl\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.ca.private_key_pem}\" > \"$HOME/.kube/ssl/ca-key.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_self_signed_cert.ca.cert_pem}\" > \"$HOME/.kube/ssl/ca.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.apiserver.private_key_pem}\" > \"$HOME/.kube/ssl/apiserver-key.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_locally_signed_cert.apiserver.cert_pem}\" > \"$HOME/.kube/ssl/apiserver.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_private_key.admin.private_key_pem}\" > \"$HOME/.kube/ssl/admin-key.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${tls_locally_signed_cert.admin.cert_pem}\" > \"$HOME/.kube/ssl/admin.pem\""
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.kubectl_config.rendered}\" > \"$HOME/.kube/config\""
  }
}
