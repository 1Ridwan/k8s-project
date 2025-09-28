resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

  create_namespace = true
  namespace        = "nginx-ingress"
}

## cert manager ##

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.2"

  create_namespace = true
  namespace        = "cert-manager"

  value = [
    "${file("helm-values/cert-manager.yaml")}",
  ]

  depends_on = [aws_eks_pod_identity_association.cert_manager]
}

module "cert_manager_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  name   = "cert-manager"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = [local.hosted_zone_arn]

}

resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = module.eks.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = module.cert_manager_pod_identity.iam_role_arn
}





## external dns ##


resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  value = [
    "${file("helm-values/external-dns.yaml")}",
  ]

  depends_on = [aws_eks_pod_identity_association.cert_manager]
}


module "external_dns_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  name   = "external-dns"

  # This module can attach a least-priv Route53 policy for ExternalDNS
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [local.hosted_zone_arn]

}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = module.eks.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = module.external_dns_pod_identity.iam_role_arn
}
