#!/bin/bash

# Set versions for tools
aws_version="2.2.47"
terraform_version="1.0.2"
ansible_version="latest"
vault_version="1.8.3"

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
