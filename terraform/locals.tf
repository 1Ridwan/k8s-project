locals {
  name   = "eks-lab"
  domain = "ridwanahmed.com"
  region = "eu-west-2"

  cluster_name = "cluster-lab"

  tags = {
    Environment = "showcase1"
    Project     = "EKS Project showcase"
    Owner       = "Ridwan"
  }
}