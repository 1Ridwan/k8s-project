terraform {
  backend "s3" {
    bucket       = "terraform-state-k8s-assignment"
    key          = "terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true #S3 native locking
  }
}