resource "null_resource" "terraform-debug" {
  provisioner "local-exec" {
    command = "echo 'fine' > /var/lib/jenkins/workspace/pipe1/ip.txt "

    environment = {

    }
  }
}