# 2048 on AWS EKS

## Overview

This project deploys the open-source [2048](https://github.com/gabrielecirulli/2048) game on **Amazon EKS**, using a **highly available, production-grade architecture** spanning three availability zones.  
It demonstrates end-to-end DevOps practices — **Infrastructure as Code (IaC)**, **containerisation**, **CI/CD automation**, and **GitOps deployment** with **ArgoCD**.

2048 is a web-based number puzzle where you combine tiles to reach the number 2048.  
This deployment turns it into a real-world cloud-native workload to showcase **scalable Kubernetes deployment** on AWS.

---

## Key Features
- Highly available **EKS cluster** distributed across multiple AZs.  
- **Terraform**-managed VPC, networking, and EKS resources.  
- **ArgoCD GitOps pipeline** for automated deployment.  
- **Helmfile** to manage and install Helm charts consistently.  
- Full **CI/CD automation** from code commit → container build → cluster deployment.  
- Integrated **monitoring (Prometheus, Grafana)** and **security hardening (WAFv2, IAM least privilege)**.

---

## Architecture Diagram
![Architecture Diagram](./images/architecture-diagram.png)

### Architecture Description
> - **Amazon EKS**: Managed Kubernetes control plane and worker nodes.  
> - **Public subnets**: Host ingress and network load balancer.  
> - **Private subnets**: Run application workloads and cluster services securely.  
> - **NAT Gateway**: Provides outbound internet for worker nodes to pull container images.  
> - **Nginx Ingress Controller**: Routes traffic to services through Ingress resources.  
> - **External DNS**: Dynamically updates Route53 records for subdomain `lab.ridwanahmed.com`.  
> - **Cert-Manager**: Issues and renews TLS certificates automatically via Let’s Encrypt.  
> - **Prometheus & Grafana**: Provide observability and cluster health visualisation.  

---

## Architecture Components

| AWS Resource / Tool                  | Purpose                                                                 |
|--------------------------------------|-------------------------------------------------------------------------|
| **Amazon EKS**                       | Runs Kubernetes workloads across multiple AZs                           |
| **Amazon ECR**                       | Stores Docker images built by the CI/CD pipeline               |
| **NGINX Ingress Controller**         | Manages inbound HTTP/HTTPS traffic                                      |
| **External DNS**                     | Automates DNS record creation for ingress endpoints                     |
| **Cert-Manager & Let’s Encrypt**     | Issues SSL/TLS certificates automatically                               |
| **AWS Certificate Manager (ACM)**    | Manages additional certificates for load balancers                      |
| **Prometheus**                       | Collects metrics for monitoring cluster performance                     |
| **Grafana**                          | Visualizes metrics and logs for operational insights                    |
| **EKS Pod Identity**                 | Provides fine-grained AWS permissions to pods securely                  |
| **AWS S3 (Terraform Backend)**       | Stores Terraform state with remote locking                              |

---

## CI/CD and GitOps Workflow

This project integrates **GitHub Actions**, **Helmfile**, and **ArgoCD** into a fully automated GitOps pipeline.

### 🔧 1. CI: Build and Push Stage
- **GitHub Actions** triggers on every push or pull request to the `main` branch.  
- The workflow:
  1. Runs **Checkov** to scan Terraform and Kubernetes manifests for security issues.  
  2. Builds the **Docker image** of the 2048 app.  
  3. Pushes the image to **Amazon ECR**.  
  4. Updates the image tag inside Kubernetes manifest or Helm values files using the SHA of the build workflow for clear visibility of which workflow created the image.

### 🚀 2. CD: Automated Deployment with ArgoCD + Helmfile
- **Helmfile** declaratively manages all Helm charts for cluster add-ons (e.g., Nginx Ingress Controller, Cert-Manager, Prometheus, Grafana).  
- **ArgoCD** monitors the Git repository for changes to any manifest file.  
- When a commit is detected:
  1. ArgoCD automatically **synchronises** the desired state with the live cluster.  
  2. New application pods are deployed using rolling updates (old pods remain active until the new ones are healthy).  

This enables **zero-downtime deployments**, **version-controlled infrastructure**, and **rapid feature rollout** by simply committing code changes.

---

## Security

- **Security Groups** enforce least privilege:
  - ALB allows only HTTP/HTTPS ingress from the public internet.
  - EKS worker nodes accept traffic only from trusted sources.
- **IAM Roles** follow the principle of least privilege:
  - Worker node role allows pulling from ECR.
- **Checkov** scans all Terraform and manifest code for security misconfigurations.

## Security

- **EKS Pod Identity (Replacing IRSA):**
  - This project uses **EKS Pod Identity** instead of the traditional IAM Roles for Service Accounts (IRSA).
  - Pod Identity provides a more secure and simplified approach to granting AWS permissions directly to pods without requiring OIDC providers or service account annotations.
  - Each pod that needs access to AWS services (e.g., S3, Route53) is assigned a dedicated **Pod Identity association** linked to an IAM role.
  - This ensures tighter permission boundaries, automatic credential rotation, and easier debugging compared to IRSA.
  - It also eliminates the need for managing IAM OIDC providers, reducing operational complexity and improving cluster security posture.
- **IAM Roles** follow the principle of least privilege:
  - Worker node role allows pulling from ECR and writing logs to CloudWatch.
- **Checkov** scans all Terraform and manifest code for security misconfigurations.

---
## Deployment Tools

| Tool                   | Purpose                                                                 |
|-------------------------|-------------------------------------------------------------------------|
| **Terraform**           | Provisions VPC, subnets, IAM, Pod Identity, and EKS resources.          |
| **Docker**              | Builds and packages the 2048 container image.                           |
| **GitHub Actions**      | Runs CI pipeline for build, test, and security scanning.                |
| **Helmfile**            | Declaratively installs and manages Helm charts for Kubernetes add-ons.  |
| **ArgoCD**              | Implements GitOps and automatically deploys manifest changes.           |

---

## Screenshots
![VPC Resources](./images/1.png)
![ALB Resource Map](./images/2.png)
![EKS Cluster](./images/3.png)
![ACM Certificate](./images/4.png)
![Website 1](./images/5.png)
![Website 2](./images/6.png)
![Deploy to EKS](./images/7.png)
![Terraform Plan](./images/8.png)
![Terraform Apply](./images/9.png)
![Terraform Destroy](./images/10.png)

---

## Local Development

```bash
# Clone the repository
git clone https://github.com/1Ridwan/ECS.git
cd app

# Build and run locally
docker build -t 2048-app:local .
docker run -d --rm --name 2048-app -p 8080:8080 2048-app:local

Then open:
http://localhost:8080

```

## Why This Project?

This project validates my ability to design, deploy, and automate production-grade cloud-native systems using AWS and Kubernetes.

It demonstrates practical expertise in:
- Containerisation and image optimisation
- Infrastructure provisioning with Terraform
- CI/CD automation and GitOps workflows
- Kubernetes operations with ArgoCD and Helmfile
- Observability and cloud security best practices