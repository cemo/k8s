resource "null_resource" "ssl" {
  provisioner "local-exec" {
    command = "cd ${path.module}/ssl && /bin/bash generate.sh"
  }
}
