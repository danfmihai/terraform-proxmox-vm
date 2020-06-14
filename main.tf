#resource "random_integer" "ip" {
#  min     = 200
#  max     = 245
  #keepers = {
    # Generate a new integer each time we switch to a new vm
  #  ip_vm = "${var.ip_vm}"
  #}
#}

resource "proxmox_vm_qemu" "vm_server" {
  count       = 1
  name        = "vm-${var.img_type}-tf-${count.index +1}"
  target_node = "proxmox"
  clone       = "${var.img_type}-cloudinit-template"
  full_clone = false
  cores = var.cores
  memory  = var.memory
  boot  = "c"

  disk {
    id              = 0
    size            = 20
    type            = "scsi"
    storage         = "pveimages"
    storage_type    = "zfs"
    iothread        = true
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.102.20${count.index + 1}/24,gw=192.168.102.1"
  #nameserver = "192.168.102.1"
  sshkeys = <<EOF
  ${var.ssh_key}
  ${var.ssh_key2}
  EOF
  
 #provisioner "remote-exec" {
 #   inline = [
 #     "sleep 20",
 #     "ip a"
 #   ]
 # }

}
