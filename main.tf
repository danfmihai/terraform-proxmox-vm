resource "proxmox_vm_qemu" "test_server" {
  count             = 1
  name              = "vm-test-tf"
  target_node       = "proxmox"
  clone             = "ubuntu-cloudinit-template"

#   os_type           = "cloud-init"
#   cores             = 4
#   sockets           = "1"
#   cpu               = "host"
#   memory            = 1024
#   scsihw            = "virtio-scsi-pci"
#   bootdisk          = "scsi0"

#   disk {
#     id              = 0
#     size            = 20
#     type            = "scsi"
#     storage         = "data2"
#     storage_type    = "lvm"
#     iothread        = true
#   }

#   network {
#     id              = 0
#     model           = "virtio"
#     bridge          = "vmbr0"
#   }

  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0         = "ip=192.168.102.21${count.index + 1}/24,gw=192.168.102.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
