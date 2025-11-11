terraform {
  required_version = "~> 1.12.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 6.15.0, < 7.0" # my eks terraform module requires 6.15.0
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}


