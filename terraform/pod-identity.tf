module "cert_manager_pod_identity" {
  source                        = "git::https://github.com/terraform-aws-modules/terraform-aws-eks-pod-identity.git?ref=6b2ba41882f042bc9ab7a256989f282a03d66c1d"
  name                          = "cert-manager"
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
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks-pod-identity.git?ref=6b2ba41882f042bc9ab7a256989f282a03d66c1d"
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
