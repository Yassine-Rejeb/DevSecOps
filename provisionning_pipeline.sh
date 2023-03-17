#! /usr/bin/bash

rm -rf ~/.ssh/known_hosts
terraform -chdir=terraform apply -auto-approve
sudo sed -i "3s/.*/$(terraform -chdir=./terraform output -raw jenkins_public_ip)	remote_jenkins/" /etc/hosts
sudo sed -i "4s/.*/$(terraform -chdir=./terraform output -raw prod_public_ip)	production_server/" /etc/hosts
ansible-playbook --private-key /home/ansible/.ssh/jenkins jenkins.yml -i inventory
