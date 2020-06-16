resource "proxmox_vm_qemu" "vm_server" {
  count       = 1
  name        = "vm-${var.img_type}${count.index + 1}-tf"
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
 
}
  
  resource "null_resource" "script_install" {
    depends_on =[
      proxmox_vm_qemu.vm_server,
    ]
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = "192.168.102.201"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/#ClientAliveInterval\\ 0/ClientAliveInterval\\ 120/g' /etc/ssh/sshd_config",
      "sudo sed -i 's/#ClientAliveCountMax\\ 3/ClientAliveCountMax\\ 720/g' /etc/ssh/sshd_config",
      "sudo systemctl restart sshd", 
    ]
  }

  provisioner "file" {
    source      = "scripts/install.sh"
    destination = "/tmp/install.sh"
  }
  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh",
    ]
  }
}