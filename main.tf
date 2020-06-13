resource "proxmox_vm_qemu" "test_server" {
  #count       = 1
  name        = "vm-test-tf"
  target_node = "proxmox"
  clone       = "ubuntu-cloudinit-template"
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
  ipconfig0 = "ip=192.168.102.217/24,gw=192.168.102.1"

  sshkeys = <<EOF
  ${var.ssh_key}
  ${var.ssh_key2}
  EOF
}
