#! /usr/bin/bash

rm -rf /home/terraform/.ssh/known_hosts
terraform -chdir=terraform apply -auto-approve
sudo sed -i "9s/.*/$(terraform -chdir=./terraform output -raw jenkins_public_ip)	remote_jenkins/" /etc/hosts
sudo sed -i "10s/.*/$(terraform -chdir=./terraform output -raw prod_public_ip)	production_server/" /etc/hosts
ansible-playbook --private-key /home/terraform/.ssh/terraform jenkins.yml -i inventory
