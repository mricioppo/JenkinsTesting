resource "null_resource" "terraform-debug" {
  provisioner "local-exec" {
    command = "echo $VARIABLE1 > /var/lib/jenkins/workspace/pipelineDB/debug.txt ; echo $VARIABLE1 > /var/lib/jenkins/workspace/pipelineDB/debug2.txt ; echo ${aws_instance.db.public_ip} > /var/lib/jenkins/workspace/pipelineDB/ip.txt "

    environment = {
        VARIABLE1 = var.private_key_file
    }
  }
}

resource "aws_instance" "db" {
  ami = "${lookup(var.ami_id, var.region)}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.webSG_DB.id}"]
  key_name = "JenkinsKey"
  
  tags = {
    Name = "GecoDBServer"
  }
  
  provisioner "remote-exec" {
    # Leave this here so we know when to start with Ansible local-exec
    inline = [ "echo 'Cool, we are ready for provisioning'"]
  }

  provisioner "file" {
    source      = "creazioneDB.sh"
    destination = "/tmp/creazioneDB.sh"
  }

  provisioner "file" {
    source      = "web/gecodb.sql"
    destination = "/tmp/gecodb.sql"
  }


  provisioner "remote-exec" {
    // inline = [ "chmod +x /tmp/creazioneDB.sh", "/tmp/creazioneDB.sh ${aws_instance.db.public_ip}"]
    inline = ["echo ciao"]
  }
  
  connection {
    user = "ec2-user"
    private_key = "${file("${var.private_key_file}")}"
    host = "${aws_instance.db.public_ip}"
    agent = false
    timeout = "5m"
  }
  
  
  depends_on = [ aws_instance.db ]

}

resource "aws_security_group" "webSG_DB" {
    
    name = "webSG_DB"
    description = "Allow ssh inbound traffic"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80  
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
        from_port   = 8080  
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

}
