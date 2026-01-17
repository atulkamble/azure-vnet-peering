```


VNETS - SAME REGION - SAME ACCOUNT
VNETS - DIFFERENT REGION - SAME ACCOUNT
VNETS - DIFFERENT 





https://chocolatey.org/install
https://learn.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
https://developer.hashicorp.com/terraform/install

choco install terraform

az --version
az login 
git --version
terraform --version

git clone https://github.com/atulkamble/azure-vnet-peering.git
cd azure-vnet-peering

// update subscription id in provider.tf | search in azure portal 

terraform init -upgrade
terraform plan 
terraform apply -auto-approve

1. Launch VMA with public ip in VNetA (with password | VnetA | PublicIP)
2. Launch VMB with private ip in VNetB (with password | VnetB | PrivateIP)
3. Login to AzureVMA (atul@20.83.169.79)
4. from VMA connect to VMB (ssh atul@10.1.1.4)

delete VMs

terraform destroy 



```
