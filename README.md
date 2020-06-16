# Terraform Proxmox VM provisioning and Jenkins install

[![Terraform Version](https://img.shields.io/badge/Terraform-0.12.26-brightgreen.svg)](https://www.terraform.io/downloads.html) [![Proxmox version](https://img.shields.io/badge/Proxmox-6.2-brightgreen.svg)](https://www.proxmox.com/en/downloads)

The Terraform files will provision a new vm and use the script to install Jenkins.

# Usage
```
git clone https://github.com/danfmihai/terraform-proxmox-vm.git
cd terraform-proxmox-vm
terraform init
terraform apply --var-file=data.tfvars
```
Create a file called 'data.tfvars' and add the following variabiles:

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
# Jenkins script
```
#!bin/bash

#set -x

ip=$(ip a | grep 192 | awk '{ print $2}' | cut -c -15)

# installing Jenkins Ubuntu/Debian
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update
sudo apt-get install -y openjdk-8-jdk 
sudo apt install -y jenkins
sudo apt autoremove -y
#sudo systemctl status jenkins --no-pager | grep Active
sudo usermod -G ubuntu jenkins
echo
echo "Jenkins will run on port 8080 usually."
echo "Access Jenkins at http://${ip}:8080"
echo "***********************************"
echo "Username is admin and password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "***********************************"

# set +x

```


The terraform files will provision one or more VMs (change 'count' variable) on a Proxmox node based on a vm template that you previously created.  
To create a template you can use:
[proxmox-create-template repo](https://github.com/danfmihai/proxmox-create-template)  
or you can create one manualy. Please change the necessary variables.

Reference links:  
[Proxmox provider plugin](https://github.com/Telmate/terraform-provider-proxmox)
