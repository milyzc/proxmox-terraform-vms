# resource "proxmox_virtual_environment_file" "cloud_init" {
#   content_type = "snippets"
#   datastore_id = var.snippet_datastore_id
#   node_name    = coalesce(var.node_name, var.proxmox_node)

#   source_raw {
#     data = templatefile("${path.module}/cloud-init/${var.cloudinit_template}", {
#       hostname        = var.vm_name
#       ssh_public_keys = var.ssh_public_keys
#       extra           = var.cloudinit_vars
#     })
#     file_name = "${var.vm_name}-user-data.yaml"
#   }
# }
