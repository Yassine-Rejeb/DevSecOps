resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins-key"
  public_key = file("${pathexpand("~/.ssh/jenkins.pub")}")
}

resource "aws_key_pair" "prod-key" {
  key_name   = "prod-key"
  public_key = file("${pathexpand("~/.ssh/prod.pub")}")
}

