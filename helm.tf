resource "helm_release" "nginx" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

  create_namespace = true
  namespace = "nginx-ingress"
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = kubernetes_namespace_v1.cert_manager.metadata[0].name
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.18.2"

  create_namespace = true
  namespace = "cert-manager"

    values = [
    file("${path.module}/values/cert-manager.yaml")
  ]

  depends_on = [aws_eks_pod_identity_association.cert_manager]
}