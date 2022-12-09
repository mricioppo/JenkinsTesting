output "public_ip" {
    description = "Indirizzo pubblico del database"
    value = try(aws_instance.db.public_ip,"")
}

locals {
  myIp = try(aws_instance.db.public_ip,"")
}