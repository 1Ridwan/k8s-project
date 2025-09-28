module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

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

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  tags = local.tags
}





module "cert_manager_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"

  name = "cert-manager"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z0717143R661NCU61KOX"]

  tags = local.tags
}

resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = module.eks.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = module.cert_manager_pod_identity.iam_role_arn
}


resource "kubernetes_namespace_v1" "cert_manager" {
  metadata { name = "cert-manager" }
}

# Install cert-manager (pin a version you approve)
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace_v1.cert_manager.metadata[0].name
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.18.2"
  create_namespace = false

  set = [
    { name = "installCRDs", value = "true" },
    { name = "serviceAccount.name", value = "cert-manager" },
    { name = "serviceAccount.create", value = "true" }
  ]

  depends_on = [aws_eks_pod_identity_association.cert_manager]
}






