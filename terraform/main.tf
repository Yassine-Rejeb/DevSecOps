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