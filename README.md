# Terraform Proxmox VM provisioning

[![Terraform Version](https://img.shields.io/badge/Terraform-0.12.26-brightgreen.svg)](https://www.terraform.io/downloads.html) [![Proxmox version](https://img.shields.io/badge/Proxmox-6.2-brightgreen.svg)](https://www.proxmox.com/en/downloads)

The Terraform files will provision a new vm.

# Usage
```
git clone https://github.com/danfmihai/terraform-proxmox-vm.git
cd terraform-proxmox-vm
terraform init
terraform apply --var-file=data.tfvars
```
Following variabiles in data.tfvars file needed:

```
pm_api_url  = "https://proxmox.domain.com:8006/api2/json"
pm_user     = "root@pam"
pm_password = "G>3>2:d%eazk"
ssh_key     = "ssh-rsa ..."
ssh_key2    =  "ssh-rsa ..."
img_type    =   "ubuntu"
cores   = 2
memory = 2048
ip = "192.168.102.20"
gw = "192.168.102.1"
```

The terraform files will provision one or more VMs on a Proxmox node based on a vm template that you previously created.  
To create a template you can use:
[proxmox-create-template repo](https://github.com/danfmihai/proxmox-create-template)  
or you can create one manualy. Please change the necessary variables.

Reference links:  
[Proxmox provider plugin](https://github.com/Telmate/terraform-provider-proxmox)
