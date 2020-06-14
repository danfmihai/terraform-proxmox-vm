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
  
  
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.ssh_host
    }
    
    provisioner "remote-exec" {
    inline = [
      "echo 'VM IS RUNNING'",
      "ip a | grep 192.168.102 | awk '{ print $2 }'",
    ]
  }

}
