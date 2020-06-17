resource "proxmox_vm_qemu" "vm_server" {
  count       = var.count_vm
  desc  = "Provision VM and install Jenkins"
  name        = "vm-${var.img_type}${count.index + 1}-jenkins"
  target_node = "proxmox"
  clone       = "${var.img_type}-cloudinit-template"
  full_clone  = false
  cores       = var.cores
  memory      = var.memory
  boot        = "c"
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"
  disk {
    id           = 0
    size         = 10
    type         = "scsi"
    storage      = "pveimages"
    storage_type = "zfs"
    iothread     = true
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

  provisioner "file" {
    source      = "scripts/install-nc.sh"
    destination = "/tmp/install-nc.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.ssh_host
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      "ls -l /tmp/install-nc
      .sh",
      "sudo sed -i 's/#ClientAliveInterval\\ 0/ClientAliveInterval\\ 120/g' /etc/ssh/sshd_config",
      "sudo sed -i 's/#ClientAliveCountMax\\ 3/ClientAliveCountMax\\ 720/g' /etc/ssh/sshd_config",
      "chmod +x /tmp/install-nc.sh",
      "sudo systemctl restart sshd",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      "sudo sh /tmp/install-nc.sh"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = "${var.ip}${var.count_vm}"
    }
  }

}