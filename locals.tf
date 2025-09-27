locals {
    name = "eks-lab"
    domain = "lab.ridwanahmed.com"
    region = "eu-west-2"

    cluster_name = "cluster-lab"

    tags = {
        Environment = "sandbox"
        Project = "EKS Project 1"
        Owner = "Ridwan"
    }
}