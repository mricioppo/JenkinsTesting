resource "null_resource" "terraform-debug" {
  provisioner "local-exec" {
    command = "echo 'INDIRIZZO IP FITTIZIO' > /var/lib/jenkins/workspace/pipelineJenkins1/ip.txt "

    environment = {

    }
  }
}