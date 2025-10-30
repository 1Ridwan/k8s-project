#!bin/bash

# Delete helm releases
helm uninstall argocd --namespace argocd
helm uninstall cert-manager --namespace cert-manager
helm uninstall external-dns --namespace external-dns
helm uninstall nginx-ingress --namespace ingress-nginx
helm uninstall prometheus --namespace prometheus
helm uninstall grafana --namespace monitoring

# Delete ArgoCD related CRDs
kubectl delete crd applications.argoproj.io \
                   applicationsets.argoproj.io \
                   appprojects.argoproj.io
                
# Delete Cert-Manager related CRDs
kubectl delete crd certificaterequests.cert-manager.io \
                   certificates.cert-manager.io \
                   challenges.acme.cert-manager.io \
                   clusterissuers.cert-manager.io \
                   issuers.cert-manager.io \
                   orders.acme.cert-manager.io
