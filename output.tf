output "vm_id" {
  value       = proxmox_vm_qemu.vm_server.*.id
  description = "The id of the vm."
}

output "vm_ip" {
    value = "${var.ip}${var.count_vm}" 
}
