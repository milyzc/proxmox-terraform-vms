resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = coalesce(var.node_name, var.proxmox_node)
  vm_id     = var.vm_id
  tags      = var.tags

  agent {
    enabled = true
  }

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "virtio0"
    size         = var.disk_size
  }

  network_device {
    bridge  = var.bridge
    vlan_id = var.vlan_id
  }

  initialization {
    datastore_id      = var.datastore_id
    # user_data_file_id = proxmox_virtual_environment_file.cloud_init[0].id # to configure cloud-init.tf

    ip_config {
      ipv4 {
        address = var.ip_config
        gateway = var.gateway
      }
    }
  }

  lifecycle {
    ignore_changes = [
      clone,
    ]
  }
}
