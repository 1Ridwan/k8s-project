terraform {
  backend "s3" {
    bucket       = "terraform-state-k8s-assignment"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true #S3 native locking
  }
}

import {
  to = aws_ecr_repository.main
  identity = {
    name = "k8s-ecr"
  }
}

resource "aws_ecr_repository" "main" {
  name = "k8s-ecr"
  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  image_tag_mutability = "IMMUTABLE"
  force_delete         = false
}