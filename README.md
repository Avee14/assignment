## A testing terraform code to deploy Infra on Azure. Infra including AKS, ACR, Networking, Azure Postgres Flexible Server.
### This was a part of an assignment where It was asked to create Infra and Also host a demo springboot application with Postgres as backend. I have used the modules approach as that makes code cleaner and also re-usable and easy to understand.

Project structure:
```
.
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

# To format code if any formatting required(managed by terraform itself)

$ terraform fmt

# To Check syntax correctness and it also Validates variable usage

$ terraform validate 

# Initializes the working directory Downloads provider plugins (Azure, AWS, etc.)

$ terraform init

# Shows execution plan. 

$ terraform plan

# Creates infra

terraform apply 

```

