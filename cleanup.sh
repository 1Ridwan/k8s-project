#!bin/bash

# Delete helm releases
helm uninstall argocd --namespace argocd
helm uninstall cert-manager --namespace cert-manager
helm uninstall external-dns --namespace external-dns
helm uninstall ingress-nginx --namespace ingress-nginx
helm uninstall prometheus --namespace default
helm uninstall grafana --namespace default

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
