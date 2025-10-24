resource "helm_release" "ingress_nginx" {
  name             = "nginx-ingress"
  namespace        = "ingress-nginx"
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"

  version = "4.11.3"

  values = [file("helm-values/nginx.yaml")]

  atomic          = true
  cleanup_on_fail = true
  timeout         = 900
}



# load balancer controller

resource "helm_release" "aws_lbc" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.9.1"

  values = [yamlencode({
    clusterName = module.eks.cluster_name
    region      = "eu-west-2"
    vpcId       = module.vpc.vpc_id
    serviceAccount = {
      create = true
      name   = "aws-load-balancer-controller"
    }
  })]

  depends_on = [aws_eks_pod_identity_association.alb]
  wait       = true
  timeout    = 900
  atomic     = false # so Helm won’t uninstall it if readiness takes a while

}

# IAM role with the official LBC policy, via the pod-identity module

module "alb_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.9" # or newer

  name = "aws-load-balancer-controller"

  attach_aws_lb_controller_policy = true
}

resource "aws_eks_pod_identity_association" "alb" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = module.alb_controller_pod_identity.iam_role_arn
}

## cert manager ##

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.2"

  create_namespace = true
  namespace        = "cert-manager"

  values = [
    "${file("helm-values/cert-manager.yaml")}",
  ]

  depends_on = [aws_eks_pod_identity_association.cert_manager]

}

module "cert_manager_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
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

## external dns ##


resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  values = [
    "${file("helm-values/external-dns.yaml")}",
  ]

  depends_on = [aws_eks_pod_identity_association.external_dns]
}


module "external_dns_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
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
