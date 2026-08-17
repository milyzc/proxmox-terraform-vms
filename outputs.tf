output "vm_id" {
  description = "ID de la VM creada"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_ipv4_addresses" {
  description = "Direcciones IPv4 reportadas por qemu-guest-agent (requiere agent instalado y corriendo en el template)"
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}
