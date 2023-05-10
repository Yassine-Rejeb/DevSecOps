#!/bin/bash

RED='\e[31m' 
GREEN='\033[0;32m'

read -p "Do you want to save your AWS credentials? (y/n) " confirm

if [ "$confirm" = "y" ]; then

  read -p "Enter your AWS Access Key ID: " aws_access_key_id
  read -p "Enter your AWS Secret Access Key: " aws_secret_access_key
  read -p "Enter your AWS Session Token: " aws_session_token

  mkdir -p ~/.aws
  cat > ~/.aws/credentials <<EOL
[default]
aws_access_key_id = $aws_access_key_id
aws_secret_access_key = $aws_secret_access_key
aws_session_token = $aws_session_token
EOL

  chmod 600 ~/.aws/credentials
  echo " "
  echo " "
  echo -e "${GREEN}Credentials succesfully saved to ~/.aws/credentials"
else
  echo -e "${RED}skipped..."
  echo " "
  exit 0
fi
