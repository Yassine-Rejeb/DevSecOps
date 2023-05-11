#!/bin/bash

# Set versions for tools
aws_version="2.9.23"
terraform_version="1.4.5"
ansible_version="latest"
vault_version="1.13.1"

if command -v docker-compose &>/dev/null; then
  echo "docker-compose is already installed"
else
  sudo yum update
  sudo yum install docker -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo docker run hello-world
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version
  sudo systemctl start docker.service
fi

# Check if AWS CLI is already installed
if command -v aws &>/dev/null; then
  echo "AWS CLI is already installed"
else
  # Download AWS CLI
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${aws_version}.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

# Check if Terraform is already installed
if command -v terraform &>/dev/null; then
  echo "Terraform is already installed"
else
  # Download Terraform
  curl "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" -o "terraform.zip"
  unzip terraform.zip
  sudo mv terraform /usr/local/bin/
fi

# Check if Ansible is already installed
if command -v ansible &>/dev/null; then
  echo "Ansible is already installed"
else
  # Download Ansible
  sudo apt update
  sudo apt install -y ansible="${ansible_version}"
fi

# Check if Vault is already installed
if command -v vault &>/dev/null; then
  echo "Vault is already installed"
else
  # Download Vault
  curl "https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip" -o "vault.zip"
  unzip vault.zip
  sudo mv vault /usr/local/bin/
fi

# Verify installation
aws --version
terraform --version
ansible --version
vault --version
docker-compose --version
