# Terraform Proxmox VM provisioning

[![Terraform Version](https://img.shields.io/badge/Terraform-0.12.26-brightgreen.svg)](https://www.terraform.io/downloads.html) [![Proxmox version](https://img.shields.io/badge/Proxmox-6.2-brightgreen.svg)](https://www.proxmox.com/en/downloads)

The terraform files will provision one or more VMs on a Proxmox node based on a vm template that you previously created.  
To create a template you can use:
[proxmox-create-template repo](https://github.com/danfmihai/proxmox-create-template)  
or you can create one manualy. Please change the necessary variables.

Reference links:  
[Proxmox provider plugin](https://github.com/Telmate/terraform-provider-proxmox)
