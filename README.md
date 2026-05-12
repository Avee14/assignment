## A testing terraform code to deploy Infra on Azure. Infra including AKS, ACR, Networking, Azure Postgres Flexible Server.
### This was a part of an assignment where It was asked to create Infra and Also host a demo springboot application with Postgres as backend. I have used the modules approach as that makes code cleaner and also re-usable and easy to understand.

Project structure:
```
terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
│
├── providers.tf
│
└── modules/
    │
    ├── aks/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │
    ├── keyvault/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │
    ├── postgres/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │
    ├── acr/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │
    └── network/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
    └── monitoring/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf

```

## Go to the VM where terraform is installed and go into terraform directory

```
$ cd Terraform

# Format Terraform code
terraform fmt

# Validate Terraform configuration
terraform validate

# Initialize Terraform providers and backend
terraform init

# Preview infrastructure changes
terraform plan

# Provision infrastructure
terraform apply

# Destroy infrastructure
terraform destroy

```

## GitOps Deployment

Argo CD is used as the GitOps deployment tool.

Workflow:
1. Kubernetes manifests are stored in Git
2. Argo CD continuously monitors the repository
3. Any manifest changes are automatically synchronized to AKS
4. Drift detection ensures cluster state consistency

## Security Considerations

- Secrets are stored in Azure Key Vault
- AKS uses Managed Identity for secure Key Vault access
- No hardcoded credentials are stored in Git
- Terraform remote state is centrally managed
- Kubernetes secrets are dynamically injected using CSI Driver

## Monitoring & Observability

The solution includes:
- Azure Monitor integration
- Log Analytics Workspace
- Spring Boot Actuator health probes
- Kubernetes liveness and readiness probes

## Architecture Overview

                                      ┌───────────────────────┐
                                      │      GitHub Repo      │
                                      │ Terraform + K8s YAMLs │
                                      └──────────┬────────────┘
                                                 │
                                                 │ GitOps Sync
                                                 ▼
                                      ┌───────────────────────┐
                                      │       Argo CD         │
                                      │   (Running in AKS)    │
                                      └──────────┬────────────┘
                                                 │
                                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Azure Kubernetes Service (AKS)                    │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                    Spring Boot Application Pod                       │  │
│  │                                                                       │  │
│  │  - Liveness & Readiness Probes                                       │  │
│  │  - Resource Limits                                                    │  │
│  │  - Environment Variables from Secrets                                │  │
│  └──────────────────────────────┬────────────────────────────────────────┘  │
│                                 │                                           │
│                                 ▼                                           │
│                 ┌────────────────────────────────┐                          │
│                 │ Secrets Store CSI Driver       │                          │
│                 │ Azure Key Vault Integration    │                          │
│                 └────────────────┬───────────────┘                          │
│                                  │                                          │
└──────────────────────────────────┼──────────────────────────────────────────┘
                                   │
                                   ▼
                    ┌────────────────────────────────┐
                    │       Azure Key Vault          │
                    │                                │
                    │  - DB URL                      │
                    │  - DB Username                 │
                    │  - DB Password                 │
                    └────────────────┬───────────────┘
                                     │
                                     ▼
                    ┌────────────────────────────────┐
                    │ Azure PostgreSQL Flexible DB   │
                    │                                │
                    │  Managed PostgreSQL Backend    │
                    └────────────────────────────────┘


                    ┌────────────────────────────────┐
                    │ Azure Container Registry (ACR) │
                    │                                │
                    │  Spring Boot Docker Images     │
                    └────────────────┬───────────────┘
                                     ▲
                                     │
                           Docker Build & Push
                                     │
                           ┌──────────────────┐
                           │ Developer / VM   │
                           └──────────────────┘


                    ┌────────────────────────────────┐
                    │ Azure Monitor & Log Analytics  │
                    │                                │
                    │  Logs, Metrics & Monitoring    │
                    └────────────────────────────────┘
