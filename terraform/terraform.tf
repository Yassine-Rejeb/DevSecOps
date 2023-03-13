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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDgynvEl4SvPq0VhGGzyh/VVCeLXvVbHM6hC9zadbGUjLtJF5sienw3veajlwLVkprMjrTtWI5y0EtZ0hcZe8+q3Oiz++zr5e9YjkZc25m6N/swXNWioGRQzxTHYEM+//eJWOSBkVuugegRPIyTOBBEY8ucKPLevtjGMQ91Yhk9Y0lWBPMn+E13+gh+RvcgKjjIyFCPo8lQWET4KoHnwZMfpKrl36J6W3jOG2y8o7+XJWWOv0sz7BquBietdznkrWyQc3C2kw7MMVUw16hkpTxHOb7bPbTBrt2WhcIDc1cAt54oFDe5GOnoNcgSWZS5fF+3sS6/pfmyhSTx/Pnh7fPTV8LFCnNmYEV7m9bI+/RnchSheK2yJCiijzpuBeRTQ5tsfhIyVgdFbT0OQ2nJeWwxSXq6mwCmuKQZk1/BN2JyqcEJnXyvz5/NTghPsifJtP8I6ZS3NN7wt0lOaHmN4QzVtdpAeVvKuDESupllj7hiPB39AEdR0n3vytkvJbCLig8= terraform@node1.rhce.class.com"
}

resource "aws_key_pair" "prod-key" {
  key_name   = "prod-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC99XW/z9RB/BLOHtED1h21YnnKPKVXZiQTTV1JlRqmBnyV7Kr+aYNHlEORaz2vDkVxS6pdfBdZKzN8rVthtBK5WE81ZCBQ6Jbn+nzg1wrw587sd+4Bi5MCAY8R3vvjMHwrFF1PeE6NBtsNn3ZuCPvwdWNcScrwHUehBNaEpjvsfsavN9jWOnCVTaZgHr81EPbgz/VwYHk0B1UM/gcSEmty71yC9e1ipK+jKti7n9cB4meOc7Rw96cGAYJay6WCjE834tf+V9cpbGcwYj2QHOW+4s0K9Pw+DS99kDbGuE1qi362kL5EXXLFWqW/ugTjYZuVCR3UEbst056AaRZxLc8Mf+AKPQmlY3sGGeKL3QeckYmQu3Ki5lQjtgl4CpTBkPSdBso7AHmyRSEKjRewr/79vRTLlvA0nsiQTFmiZxrTM/2p8+ZUgYjIo2gAcak/kL1FyIPxlh4rDhq+KHCgcv7BYYZeK109Kcrg/Pv3HcpfL7Inyc1cz2XVtgQ0YmSN8R0= terraform@node1.rhce.class.com"
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
