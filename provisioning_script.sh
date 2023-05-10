#! /usr/bin/bash

YELLOW='\e[33m'
GREEN='\033[0;32m'
NC='\033[0m'
RED='\e[31m' 
echo -e "${YELLOW}******************************************************************************************************************************************************${NC}"
echo -e "${YELLOW}******************************************************************************************************************************************************${NC}"

echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Installing Required Tools-//------------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
read -p "To proceed, we need to install the required tools. Would you like to proceed? (y/n): " confirm

if [ "$confirm" = "y" ]; then
	./setup.sh
else
	echo -e "${RED}Skipping..."
fi

echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Configuring AWS Credentials-//----------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
./awscreds.sh
echo ""
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Configuring SSH Keys-//-----------------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
rm -rf ~/.ssh/known_hosts
./sshkeys.sh
echo ""
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Running Terraform-//--------------------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
terraform -chdir=terraform init
terraform -chdir=terraform apply -auto-approve
echo ""
echo -e "${GREEN}Instances Created Successfully.${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Configuring /etc/hosts-//---------------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
sudo sed -i '/prod/d; /remote_jenkins/d' /etc/hosts
sudo sed -i -e '$a\'"$(terraform -chdir=./terraform output -raw jenkins_public_ip)	remote_jenkins" /etc/hosts
sudo sed -i -e '$a\'"$(terraform -chdir=./terraform output -raw prod_public_ip)	production_server" /etc/hosts
echo ""
echo -e "${GREEN}/etc/hosts File Successfully Configured.${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}-----------------------------------------------------------------//-Running Ansible Playbooks-//------------------------------------------------------${NC}"
echo -e "${YELLOW}------------------------------------------------------------------------------------------------------------------------------------------------------${NC}"
echo ""
cd ansible
ansible-playbook --private-key ~/.ssh/jenkins jenkins.yml -vvv
ansible-playbook --private-key ~/.ssh/prod jenkins2.yml 
echo ""
echo -e "${YELLOW}******************************************************************************************************************************************************${NC}"
echo -e "${YELLOW}******************************************************************************************************************************************************${NC}"
