variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

variable "servers" {
  description = "Map of server configurations"
  type = map(object({
    ip_address    = string
    os_type       = string
    role          = string
    specifications = object({
      cpu_cores   = number
      memory_gb   = number
      storage_gb  = number
    })
    network = object({
      subnet      = string
      gateway     = string
      dns_servers = list(string)
    })
  }))
}

variable "ssh_port" {
  description = "SSH port for server access"
  type        = number
  default     = 22
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for server access"
  type        = string
}

variable "timezone" {
  description = "Server timezone"
  type        = string
  default     = "UTC"
}

variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
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
    node_exporter = object({
      enabled = bool
      port = number
    })
  })
  default = {
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
    node_exporter = {
      enabled = true
      port = 9100
    }
  }
}

variable "backup_config" {
  description = "Backup configuration"
  type = object({
    enabled = bool
    type = string  # e.g., "restic", "borgbackup"
    schedule = string
    retention = object({
      daily = number
      weekly = number
      monthly = number
      yearly = number
    })
    storage = object({
      type = string  # e.g., "local", "s3", "sftp"
      path = string
      credentials = map(string)
    })
  })
  default = {
    enabled = true
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
}
