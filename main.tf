resource "proxmox_vm_qemu" "vm_server" {
  count       = 1
  name        = "vm-${var.img_type}${count.index +1}-tf"
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
  ipconfig0 = "ip=${var.ip}${count.index + 1}/24,gw=${var.gw}"
  #nameserver = "192.168.102.1"
  sshkeys = <<EOF
  ${var.ssh_key1}
  ${var.ssh_key2}
  EOF
  
  
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.ssh_host
    }
    
    provisioner "file" {
    source      = "scripts/sshd_config"
    destination = "/tmp/sshd_config"
  }

   provisioner "remote-exec" {
        inline = [
            "sudo cp -r /tmp/sshd_config /etc/ssh/",
            "systemctl restart sshd", # This works Centos. If you use another OS, you must change this line.
        ]
    }
    
    provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }
  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh",
    ]
  }

}
