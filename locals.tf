locals {
    name = "eks-lab"
    domain = "lab.ridwanahmed.com"
    region = "eu-west-2"

    tags = {
        Environment = "sandbox"
        Project = "EKS Project 1"
        Owner = "Ridwan"
    }
}