# Proxmox Terraform VMs with and without cloud-init

[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.6.0-844FBA?logo=terraform&logoColor=white)](https://www.terraform.io)
[![Proxmox provider bpg/proxmox](https://img.shields.io/badge/provider-bpg%2Fproxmox%20~%3E0.66-orange)](https://registry.terraform.io/providers/bpg/proxmox/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Terraform project to create a Linux VM in Proxmox VE by cloning an existing template, with
custom cloud-init (users, packages, `runcmd`, etc.) defined in `.tftpl` files.

## Prerequisites on Proxmox

1. **VM template**: a VM template (numeric id, e.g. `9000`) with `qemu-guest-agent`
   installed and the cloud-init drive already configured (it's recommended to create it with
   `qm create` + `qm template`, or by cloning a cloud image of your preferred distro).
2. **API Token**: `Datacenter → Permissions → API Tokens`. Create a token for a user
   (e.g. `terraform@pve`) without "Privilege Separation" or with a role that includes at least:
   - `VM.Allocate`, `VM.Clone`, `VM.Config.CDROM`, `VM.Config.CPU`, `VM.Config.Disk`,
     `VM.Config.Memory`, `VM.Config.Network`, `VM.Config.Options`, `VM.PowerMgmt`
   - `Datastore.Audit`, `Datastore.AllocateSpace`, `Datastore.AllocateTemplate` on the
     disk storage and on the storage used for snippets. If the token has
     "Privilege Separation" enabled, these permissions must be assigned to the token
     directly, not only to the user.
3. **Snippets storage** (only if custom cloud-init is enabled, see below): the
   datastore specified in `snippet_datastore_id` (default `local`) must have the
   **Snippets** content type enabled:
   `Datacenter → Storage → <storage> → Edit → Content → Snippets`.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your real values (endpoint, token, node, VM)

terraform init
terraform plan -out plans/test1.tfplan
terraform apply plans/test1.tfplan
```

## Structure

- `versions.tf` / `providers.tf` — `bpg/proxmox` provider and connection configuration.
- `variables.tf` — connection variables and VM variables (name, template,
  resources, network, and cloud-init).
- `cloud-init.tf` — uploads the rendered cloud-init (`templatefile`) of the VM as a snippet.
  Commented out by default (see "VM without cloud-init" below).
- `vm.tf` — clones the template and creates the VM. By default it does not use custom
  cloud-init (the `user_data_file_id` line, line 38, is commented out); to enable it,
  uncomment it.
- `cloud-init/*.tftpl` — available cloud-init templates. `default.yaml.tftpl` is a
  generic cloud-init; `web.yaml.tftpl` is a customization example (installs nginx
  and writes an `index.html`). Add new `.tftpl` files here for new use cases.
- `outputs.tf` — ID and IP (via guest agent) of the created VM.

## Configuring the VM

Fill in the variables in `terraform.tfvars`, specifying at minimum `vm_name` and
`template_vm_id`. Everything else has reasonable defaults (see `variables.tf`).
To use a different cloud-init, point `cloudinit_template` to a new file
in `cloud-init/` and, if that template uses custom variables, pass them in `cloudinit_vars`
(they become available inside the `.tftpl` as the `extra` map, e.g. `extra["site_message"]`
or `lookup(extra, "site_message", "default")`).

### VM without cloud-init

By default (`cloud-init.tf` commented out and `user_data_file_id` commented out in `vm.tf`) the
VM is created without custom cloud-init. The VM still has the
`initialization.ip_config` block, so `ip_config`/`gateway` are still applied via
Proxmox's native cloud-init (IP assignment), but no packages,
users are installed, nor is any `runcmd` executed.

To enable custom cloud-init: uncomment the full `resource` block in
`cloud-init.tf` and the `user_data_file_id` line (line 38) in `vm.tf`.

To deploy multiple VMs, use a separate directory (or workspace/state) per VM,
reusing this same module with a different `terraform.tfvars`.

## Notes

- `ip_config` accepts `"dhcp"` or an IP in CIDR format (e.g. `"192.168.1.101/24"`); if it's
  static, also fill in `gateway`.
- IP outputs depend on `qemu-guest-agent` being installed and running on the VM
  (the included cloud-init templates already install and enable it).
- The `lifecycle.ignore_changes = [clone]` block in `vm.tf` prevents Terraform from
  re-cloning the VM on every apply.
