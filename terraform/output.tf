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