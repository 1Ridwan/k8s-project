locals {
  name   = "eks-lab"
  domain = "ridwanahmed.com"
  region = "eu-west-2"

  cluster_name = "cluster-lab"

  tags = {
    Environment = "dev"
    Project     = "EKS Project 1"
    Owner       = "Ridwan"
  }
}