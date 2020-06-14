resource "random_integer" "ip" {
  min     = 200
  max     = 245
  keepers = {
    # Generate a new integer each time we switch to a new vm 
    ip_vm = "${var.ip_vm}"
  }
}

resource "proxmox_vm_qemu" "test_server" {
  #count       = 1
  name        = "vm-${var.img_type}-tf"
  target_node = "proxmox"
  clone       = "${var.img_type}-cloudinit-template"
  full_clone = false
  cores = 2
  memory  = 2048
  boot  = "c"
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.102.${random_integer.ip.result}/24,gw=192.168.102.1"
  nameserver = "192.168.102.1"
  sshkeys = <<EOF
  ${var.ssh_key}
  ${var.ssh_key2}
  EOF
}
