resource "proxmox_vm_qemu" "vm_server" {
  count       = var.count_vm
  desc        = "Terraform VM provision for PORXMOX"
  agent       = 1
  os_type     = "cloud-init"
  name        = "vm-${var.img_type}-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = "${var.img_type}-cloudinit-template"
  full_clone  = false
  cores       = var.cores
  memory      = var.memory
  cpu         = "host"
  boot        = "c"
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"
  
  disk {
    slot         = 0
    size         = "10G"
    type         = "scsi"
    storage      = "nvme"
    # storage_type = "scsi"
    iothread     = 1
  }
  
  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=${var.ip}${count.index + 1}/24,gw=${var.gw}"
  #os_network_config =  <<EOF
  #auto eth0
  #iface eth0 inet dhcp
  #EOF
  sshkeys = <<EOF
  ${var.ssh_key1}
  ${var.ssh_key2}
  EOF

}