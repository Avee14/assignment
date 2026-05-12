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
Azure Monitor – Centralized monitoring for AKS and infrastructure
Log Analytics Workspace – Aggregates logs from AKS and workloads
Azure Application Insights – Application-level telemetry and tracing
Spring Boot Actuator – Exposes health and metrics endpoints
Kubernetes Probes – Liveness and readiness checks for containers
Azure Key Vault + CSI Driver – Secure injection of telemetry configuration

```
Spring Boot Application
        │
        │ (Actuator endpoints: /health, /metrics)
        ▼
Kubernetes Probes (Liveness & Readiness)
        │
        ▼
Azure Monitor (AKS Insights)
        │
        ├── Logs → Log Analytics Workspace
        │
        └── Metrics → Cluster & Node monitoring

Application Telemetry
        │
        ▼
Azure Application Insights
        │
        ├── Request tracking
        ├── Exception tracking
        └── Performance metrics

```

Alerts & Notifications (Planned Enhancement)

Azure Monitor alerts can be configured to enable proactive monitoring of the application and infrastructure. As a future enhancement, alerting can be added for the following scenarios:

Pod restarts or crash loops exceeding threshold
Liveness or readiness probe failures
High CPU or memory usage on AKS nodes
HTTP 5xx error spikes or increased latency
Error patterns or exceptions detected in application logs via Log Analytics
Database connectivity or authentication failures

These alerts can be implemented using Azure Monitor Metric Alerts and Log-based Alerts, and integrated with Action Groups for notifications via email, webhook, or external tools.

## Architecture Overview
