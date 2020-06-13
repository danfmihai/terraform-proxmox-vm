resource "proxmox_vm_qemu" "test_server" {
  count       = 1
  name        = "vm-test-tf"
  target_node = "proxmox"
  clone       = "ubuntu-cloudinit-template"

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # Cloud Init Settings
  ipconfig0 = "ip=192.168.102.219/24,gw=192.168.102.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
