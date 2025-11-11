#!/bin/bash

# Run this script after terraform resources are provisioned

# Install helm resources
helmfile apply

# Configure ClusterIssuer
kubectl apply -f staging-issuer.yaml
kubectl apply -f prod-issuer.yaml

# Create ArgoCD application
kubectl apply -f argocd-app/application.yaml
