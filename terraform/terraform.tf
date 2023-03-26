terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
  backend local {}
  /*cloud {
    organization = "TPrep"

    workspaces {
      name = "DevSecOps"
    }
  }*/
}

provider "aws" {
  region = "us-east-1"
}

locals {
  vpc_id=""
}


data "aws_vpc" "main" {
  id = "${local.vpc_id}"
}


resource "aws_security_group" "sg_devsecops" {
  name        = "sg_DevSecOps"
  description = "DevSecOps Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
			prefix_list_ids  = []
			security_groups = []
			self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]

  egress = [
    {
      description = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]
}

resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDp1RR+EUBr8NABzg0P6kkNUdGelrpqgWtTlrHX+K69trHzWnICgDaSZXpvhFagFCQtatNXeN3NnnZlRi6PD5aUzqZjdtOUHL1EZzOZorHgHKOnxrtqVdmWmzGqJf8GAnUTBulE6n3baP5pHpcTP1c5cG+u3W48j8G1Qqhd7LkLiLcKzekQuNQe8FCE0vW6gdTeSKstM7+0yCI4Z0TjAk0bJghvTdF6lGIadja7V+E3O4+PTspMbESyh2Goj72jODeCRx2ZkO7A3TOLuZMtIbMkBO6ZqL8iBUl05RiE2KFTZG11MB9vPPlGBwW+xACyRLJcL1CcpRlgsUwaK7etyG13BpljosmZpsVWP50LVF1N983R5oEcDrJaVnQCL9Hc+qkPGAtoT00cIdi02NCTSdwCf2DhatwiuZaFvKQYS9Yg5r5gNO0Uzk/tPJsaj/RUv9TJF6+cYglKaBqY4HezFnMhWdedQ4nsUYuj2kyq4knYp1KFvKUbjVYOU4PQ29U/GXU= ansible@node1.rhce.class.com"
}

resource "aws_key_pair" "prod-key" {
  key_name   = "prod-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyU13qpUD8qkd2isjqTaxh9pEKDP6BeAexYneTm4uNTnZn6/blhZt0zBZIyvLT7dR2G0B7clFFJc0rphsnJobquwH3juooMA8lTfgHvUoEiimIaRvXOSK8WbdnRvvyxBMvFSvPyOgeDQjmJMG/TA9wBU/pHCH0zTujCCpS+4wdsCgOv+S7Rx21ld+iaeCthGDUVTWDnCNtkFe3JhGILGafgRZDFmhFwYSXH7EpveVJlpHdUKeZfz6qzNS7pIZvOsvSGi1gNPfBAc8kt71PhAu/aFLkE3pUdVoGJ9MRVwGDHueA0E0X8zeQiFX5vV7YAAQ8T3bWuoytpb6YuS4YpVYWisO59d8W+cwY3ZjR8wWelTw4jNJ8lF7SbWt5jTr6vJ97U4v9+by2OEMo8nQp74cK3QVDBhXsta4m2lZsgR4Y6X6k2rtyqX0+O8B7wPmewlWtmh6ypDMIQqhS4jagk+OeWPI4no8YpBj3yROUCcti2nE41NMaMHOQrJPYobYmRCk= ansible@node1.rhce.class.com"
}

resource "aws_instance" "production" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.prod-key.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_devsecops.id]
  //provisioner local-exec {
  //command = "sudo sed -i '10s/.*/${self.public_ip} production/' /etc/hosts"
  //interpreter = ["/usr/bin/bash","-c"]
  //}
  tags = {
    Name = "Production"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0dfcb1ef8550277af"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins-key.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_devsecops.id]
  //provisioner local-exec {
  //command = "sudo sed -i '9s/.*/${self.public_ip} remote_jenkins/' /etc/hosts"
  //interpreter = ["/usr/bin/bash","-c"]
  //}
  tags = {
    Name = "Jenkins"
  }
}

output "jenkins_public_ip"{
	value = aws_instance.jenkins.public_ip
}
output "prod_public_ip" {
	value = aws_instance.production.public_ip
}
output "prod_private_ip" {
        value = aws_instance.production.private_ip
}
output "jenkins_private_ip"{
        value = aws_instance.jenkins.private_ip
}
