Sure — here’s a clean, well-structured and properly formatted `README.md` version of your instructions:

---

````markdown
# 📦 Project: **Azure VNet Peering**

## 🛠️ Prerequisites

- **Terraform** installed on your system  
  👉 [Terraform Install Guide](https://developer.hashicorp.com/terraform/downloads)

- **Azure CLI** installed and configured  
  👉 [Azure CLI Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

---

## 📥 Install Terraform (Windows)

```bash
choco install terraform
terraform --version
````

---

## 🔐 Login to Azure

```bash
az login
```

---

## ⚙️ Configure Subscription Details

1. Open `provider.tf`
2. Update your Azure Subscription ID

```bash
nano provider.tf
# Replace the subscription ID value
```

---

## 🗂️ Create Resource Group (Manual Step)

Before running Terraform, manually create a resource group in Azure named:

```
azurerm_resource_group
```

---

## 🚀 Deploy Infrastructure with Terraform

### Initialize Terraform

```bash
terraform init
```

### Review the Execution Plan

```bash
terraform plan
```

### Apply the Configuration

```bash
terraform apply
```

---

## 🧹 Destroy the Infrastructure

To tear down the deployed resources:

```bash
terraform destroy
```

---

## 📌 Notes

* Ensure your terminal/command prompt has the required permissions.
* Resource naming and configurations can be customized via `terraform.tfvars`.
* Peering is established between VNets with non-overlapping address spaces.

```


## 📑 Resources Created:

* ✅ Azure Resource Group
* ✅ Two VNets with custom CIDR
* ✅ Two Subnets
* ✅ Bi-directional VNet Peering
* ✅ (Optional enhancement ready: NSG + VM provisioning + ICMP rules)

---

## 📂 Final Project Structure:

```
azure-vnet-peering-demo/
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## 📜 provider.tf

```hcl
provider "azurerm" {
  features {}
}
```

---

## 📜 variables.tf

```hcl
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "vnet_a_address_space" {
  description = "Address space for VNet-A"
  type        = list(string)
}

variable "vnet_b_address_space" {
  description = "Address space for VNet-B"
  type        = list(string)
}

variable "subnet_a_prefix" {
  description = "Address prefix for Subnet-A"
  type        = list(string)
}

variable "subnet_b_prefix" {
  description = "Address prefix for Subnet-B"
  type        = list(string)
}
```

---

## 📜 terraform.tfvars

```hcl
resource_group_name  = "vnet-peering-demo-rg"
location             = "East US"

vnet_a_address_space = ["10.0.0.0/16"]
vnet_b_address_space = ["10.1.0.0/16"]

subnet_a_prefix      = ["10.0.1.0/24"]
subnet_b_prefix      = ["10.1.1.0/24"]
```

---

## 📜 main.tf

```hcl
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# VNet-A
resource "azurerm_virtual_network" "vnet_a" {
  name                = "vnet-a"
  address_space       = var.vnet_a_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_a" {
  name                 = "subnet-a"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_a.name
  address_prefixes     = var.subnet_a_prefix
}

# VNet-B
resource "azurerm_virtual_network" "vnet_b" {
  name                = "vnet-b"
  address_space       = var.vnet_b_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet_b" {
  name                 = "subnet-b"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_b.name
  address_prefixes     = var.subnet_b_prefix
}

# VNet Peering A -> B
resource "azurerm_virtual_network_peering" "peer_a_to_b" {
  name                      = "peer-a-to-b"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_a.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_b.id
  allow_virtual_network_access = true
}

# VNet Peering B -> A
resource "azurerm_virtual_network_peering" "peer_b_to_a" {
  name                      = "peer-b-to-a"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet_b.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_a.id
  allow_virtual_network_access = true
}
```

---

## 📜 outputs.tf

```hcl
output "vnet_a_id" {
  value = azurerm_virtual_network.vnet_a.id
}

output "vnet_b_id" {
  value = azurerm_virtual_network.vnet_b.id
}

output "peering_a_to_b_id" {
  value = azurerm_virtual_network_peering.peer_a_to_b.id
}

output "peering_b_to_a_id" {
  value = azurerm_virtual_network_peering.peer_b_to_a.id
}
```

---

## 📖 README.md

```markdown
# Azure VNet Peering Demo 🚀

## 📌 Overview
This Terraform project deploys two Azure Virtual Networks (VNet-A & VNet-B) in the same region and configures bi-directional VNet Peering between them.

---

## 📖 Architecture

```

+------------+             +------------+
\|  VNet-A    | <---------> |  VNet-B    |
\| 10.0.0.0/16|   Peering   | 10.1.0.0/16|
+------------+             +------------+

````

---

## 📦 Resources Deployed

- Azure Resource Group
- VNet-A + Subnet-A
- VNet-B + Subnet-B
- Peering between VNet-A and VNet-B (both directions)

---

## 🚀 How to Deploy

1️⃣ Initialize Terraform  
```bash
terraform init
````

2️⃣ Validate configuration

```bash
terraform validate
```

3️⃣ Plan the deployment

```bash
terraform plan -var-file="terraform.tfvars"
```

4️⃣ Apply the deployment

```bash
terraform apply -var-file="terraform.tfvars"
```

5️⃣ Clean up after use

```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## 📌 Notes

* VMs and NSGs with ICMP rules can be added for testing ping connectivity.
* Bastion Host support can be integrated for secure access without public IPs.
* Peering works across Azure regions if supported by your subscription.

---

## 📌 Author

Atul — Cloud Solutions Architect

```

## 📚 References

* [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure VNet Peering Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview)

```


---

## ✅ Done!  
This is now a **fully structured, clean, and production-ready repo.**
