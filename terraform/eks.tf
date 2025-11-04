module "eks" {
  # source  = "terraform-aws-modules/eks/aws"
  # version = "~> 21.0"
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=32599e5dfc369596dfdb28cea120d469c92145c1"  # commit hash of version 21.8.0 on 27th Oct

  name               = local.cluster_name
  kubernetes_version = "1.33"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    worker1 = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      # use spot instances
      # use t3.large

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }

  tags = local.tags
}


