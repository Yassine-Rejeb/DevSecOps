
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
  instance_type = "t2.small"
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