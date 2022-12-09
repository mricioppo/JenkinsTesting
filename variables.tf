variable "region" {
  default = "eu-west-2"
}

variable "ami_id" {
  type = map

  default = {
    us-east-1    = "ami-0d75aefcfe115e1b1"
    eu-west-2    = "ami-0d75aefcfe115e1b1"
    eu-central-1 = "ami-0d75aefcfe115e1b1"
  }
}

variable "private_key_file" {
  type = string
  description = "SSH private key for accessing the EC2 instance."
}


