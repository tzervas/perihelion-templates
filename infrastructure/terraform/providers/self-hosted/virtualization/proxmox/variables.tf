# Proxmox Connection Variables
variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g., https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "allow_insecure_ssl" {
  description = "Allow insecure SSL certificates"
  type        = bool
  default     = false
}

# Environment Variables
variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

variable "domain" {
  description = "DNS domain for VMs"
  type        = string
}

# Template Configuration
variable "templates" {
  description = "Map of OS templates"
  type = object({
    debian = string
    ubuntu = string
    rocky  = string
  })
}

# Virtual Machine Configuration
variable "virtual_machines" {
  description = "Map of virtual machine configurations"
  type = map(object({
    target_node  = string
    vmid         = number
    os_type      = string
    cpu_cores    = number
    cpu_sockets  = number
    memory       = number
    disk_size    = number
    disk_type    = string
    storage_pool = string
    role         = string
    networks = list(object({
      bridge     = string
      ip_address = string
      netmask    = number
      gateway    = string
      vlan_id    = number
    }))
    dns_servers = list(string)
  }))
}

# SSH Configuration
variable "ssh_username" {
  description = "SSH username for post-provision configuration"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "timezone" {
  description = "Timezone for VMs"
  type        = string
  default     = "UTC"
}

# Monitoring Configuration
variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
    node_exporter = object({
      enabled = bool
      download_url = string
      port = number
    })
    prometheus = object({
      enabled = bool
      retention_days = number
      scrape_interval = string
    })
    alertmanager = object({
      enabled = bool
      smtp_host = string
      smtp_port = number
      alert_recipients = list(string)
    })
  })
  default = {
    node_exporter = {
      enabled = true
      download_url = "https://example.com/node_exporter_install.sh"
      port = 9100
    }
    prometheus = {
      enabled = true
      retention_days = 15
      scrape_interval = "15s"
    }
    alertmanager = {
      enabled = true
      smtp_host = "smtp.example.com"
      smtp_port = 587
      alert_recipients = ["alerts@example.com"]
    }
  }
}

# Backup Configuration
variable "backup_config" {
  description = "Backup configuration"
  type = object({
    enabled = bool
    agent_url = string
    type = string
    schedule = string
    retention = object({
      daily = number
      weekly = number
      monthly = number
      yearly = number
    })
    storage = object({
      type = string
      path = string
      credentials = map(string)
    })
  })
  default = {
    enabled = true
    agent_url = "https://example.com/backup_agent_install.sh"
    type = "restic"
    schedule = "0 2 * * *"
    retention = {
      daily = 7
      weekly = 4
      monthly = 6
      yearly = 2
    }
    storage = {
      type = "local"
      path = "/var/backups"
      credentials = {}
    }
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
