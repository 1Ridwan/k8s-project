module "cert_manager_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws.git?ref=6b2ba41882f042bc9ab7a256989f282a03d66c1d"
  name   = "cert-manager"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = [var.hosted_zone_arn]

}

resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = module.eks.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = module.cert_manager_pod_identity.iam_role_arn
}


module "external_dns_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws.git?ref=6b2ba41882f042bc9ab7a256989f282a03d66c1d"
  name   = "external-dns"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [var.hosted_zone_arn]

}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = module.eks.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = module.external_dns_pod_identity.iam_role_arn
}

# module "argocd_pod_identity" {
#   source = "terraform-aws-modules/eks-pod-identity/aws"

#   name = "argocd"

#   attach_custom_policy    = true
#   source_policy_documents = [file("eks-cluster-policy.json")]
# }

# resource "aws_eks_pod_identity_association" "argocd_repo" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "argocd"
#   service_account = "argocd-repo-server"
#   role_arn        = module.argocd_pod_identity.iam_role_arn
# }

module "amazon_managed_service_prometheus_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws.git?ref=6b2ba41882f042bc9ab7a256989f282a03d66c1d"

  name = "amazon-managed-service-prometheus"

  attach_amazon_managed_service_prometheus_policy  = true
  amazon_managed_service_prometheus_workspace_arns = ["arn:aws:prometheus:*:*:workspace/foo"]

}

resource "aws_eks_pod_identity_association" "prometheus" {
  cluster_name    = module.eks.cluster_name
  namespace       = "prometheus"
  service_account = "prometheus"
  role_arn        = module.amazon_managed_service_prometheus_pod_identity.iam_role_arn
}

