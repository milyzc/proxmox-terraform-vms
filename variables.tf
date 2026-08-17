variable "proxmox_endpoint" {
  description = "URL de la API de Proxmox VE, ej. https://proxmox.local:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token de Proxmox en formato user@realm!tokenid=secret"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Si es true, no valida el certificado TLS del endpoint de Proxmox"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Nodo Proxmox por defecto donde se crea la VM (se puede overridear con node_name)"
  type        = string
}

variable "snippet_datastore_id" {
  description = "Datastore de Proxmox con content type 'Snippets' habilitado, usado para subir el archivo de cloud-init"
  type        = string
  default     = "local"
}

variable "vm_name" {
  description = "Nombre lógico/hostname de la VM"
  type        = string
}

variable "template_vm_id" {
  description = "ID de la VM template a clonar"
  type        = number
}

variable "node_name" {
  description = "Nodo Proxmox donde se crea la VM (si no se especifica, usa proxmox_node)"
  type        = string
  default     = null
}

variable "vm_id" {
  description = "ID numérico de la VM en Proxmox (si no se especifica, Proxmox asigna uno automáticamente)"
  type        = number
  default     = null
}

variable "cores" {
  description = "Cantidad de cores de CPU"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memoria RAM en MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Tamaño del disco en GB. Si se deja en null (default), se usa el tamaño del disco tal cual viene del template (no se intenta resize)."
  type        = number
  default     = null
}

variable "datastore_id" {
  description = "Datastore de Proxmox donde se crea el disco de la VM"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Bridge de red al que se conecta la VM"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN tag de la interfaz de red (opcional)"
  type        = number
  default     = null
}

variable "ip_config" {
  description = "Configuración de IP de la VM: \"dhcp\" o una IP en formato CIDR (ej. \"192.168.1.101/24\")"
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "Gateway de red, requerido si ip_config es una IP estática"
  type        = string
  default     = null
}

variable "cloudinit_template" {
  description = "Nombre del archivo .tftpl en cloud-init/ usado para renderizar el user-data de la VM"
  type        = string
  default     = "default.yaml.tftpl"
}

variable "cloudinit_vars" {
  description = "Variables extra pasadas al template de cloud-init (disponibles como el mapa 'extra')"
  type        = map(string)
  default     = {}
}

variable "ssh_public_keys" {
  description = "Claves públicas SSH a inyectar en la VM vía cloud-init"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags de Proxmox asignados a la VM"
  type        = list(string)
  default     = []
}