# VMware Connection Variables
variable "vsphere_server" {
  description = "vSphere server address"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "allow_unverified_ssl" {
  description = "Allow unverified SSL certificates"
  type        = bool
  default     = false
}

# Infrastructure Variables
variable "datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "cluster" {
  description = "vSphere cluster name"
  type        = string
}

variable "datastore" {
  description = "vSphere datastore name"
  type        = string
}

variable "networks" {
  description = "List of network names"
  type        = list(string)
}

variable "vm_templates" {
  description = "Map of VM template names"
  type        = map(string)
}

variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

variable "domain" {
  description = "DNS domain for VMs"
  type        = string
}

# Resource Pool Configuration
variable "resource_pool_config" {
  description = "Resource pool configuration"
  type = object({
    cpu_share_level    = string
    memory_share_level = string
    cpu_reservation    = number
    memory_reservation = number
    cpu_limit         = number
    memory_limit      = number
  })
  default = {
    cpu_share_level    = "normal"
    memory_share_level = "normal"
    cpu_reservation    = 0
    memory_reservation = 0
    cpu_limit         = -1
    memory_limit      = -1
  }
}

# Virtual Machine Configuration
variable "virtual_machines" {
  description = "Map of virtual machine configurations"
  type = map(object({
    cpu            = number
    memory         = number
    disk_size      = number
    guest_id       = string
    template       = string
    thin_provision = bool
    role           = string
    networks = list(object({
      name        = string
      ip_address  = string
      netmask     = number
      gateway     = string
    }))
    dns_servers   = list(string)
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
