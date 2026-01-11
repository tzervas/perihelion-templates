# KVM Connection Variables
variable "libvirt_uri" {
  description = "libvirt connection URI (e.g., qemu:///system)"
  type        = string
}

# Environment Variables
variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

# Storage Configuration
variable "storage_pools" {
  description = "Storage pool paths"
  type = object({
    images  = string
    volumes = string
  })
}

# OS Images
variable "os_images" {
  description = "Map of OS image paths"
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
    os_type      = string
    cpu_cores    = number
    memory       = number
    disk_size    = number  # Size in GB
    role         = string
    networks = list(object({
      network_name = string
      ip_address  = string
      gateway     = string
      netmask     = number
      dns_servers = list(string)
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
