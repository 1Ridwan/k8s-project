locals {
  name            = "eks-lab"
  domain          = "lab.ridwanahmed.com"
  region          = "eu-west-2"
  hosted_zone_arn = "arn:aws:route53:::hostedzone/Z0717143R661NCU61KOX"

  cluster_name = "cluster-lab"

  tags = {
    Environment = "sandbox"
    Project     = "EKS Project 1"
    Owner       = "Ridwan"
  }
}