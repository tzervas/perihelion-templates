# Environment Variables
variable "environment" {
  description = "Environment name (e.g., production, staging, development)"
  type        = string
}

# Cluster Configuration
variable "cluster_config" {
  description = "Kubernetes cluster configuration"
  type = object({
    name                = string
    organization        = string
    pod_subnet          = string
    service_subnet      = string
    cluster_domain      = string
    api_server_endpoint = string
    etcd_endpoints      = list(string)
  })
}

variable "kubernetes_version" {
  description = "Kubernetes version to install"
  type        = string
  default     = "1.28.0"
}

# Container Runtime Configuration
variable "container_runtime" {
  description = "Container runtime configuration"
  type = object({
    type    = string
    version = string
  })
  default = {
    type    = "containerd"
    version = "1.7.0"
  }
}

# CNI Plugin Configuration
variable "cni_plugin" {
  description = "CNI plugin configuration"
  type = object({
    type    = string
    version = string
  })
  default = {
    type    = "calico"
    version = "3.26.0"
  }
}

# Control Plane Nodes
variable "control_plane_nodes" {
  description = "Map of control plane node configurations"
  type = map(object({
    ip_address = string
    os_type    = string
    role       = string
    specifications = object({
      cpu_cores  = number
      memory_gb  = number
      storage_gb = number
    })
  }))
}

# Worker Nodes
variable "worker_nodes" {
  description = "Map of worker node configurations"
  type = map(object({
    ip_address = string
    os_type    = string
    role       = string
    specifications = object({
      cpu_cores  = number
      memory_gb  = number
      storage_gb = number
    })
  }))
}

# SSH Configuration
variable "ssh_private_key_path" {
  description = "Path to SSH private key for node access"
  type        = string
}

variable "timezone" {
  description = "Timezone for cluster nodes"
  type        = string
  default     = "UTC"
}

# Monitoring Configuration
variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
    prometheus = object({
      enabled = bool
      retention_days = number
      scrape_interval = string
      storage_class = string
      storage_size = string
    })
    grafana = object({
      enabled = bool
      admin_password = string
      storage_class = string
      storage_size = string
    })
    alertmanager = object({
      enabled = bool
      smtp_host = string
      smtp_port = number
      alert_recipients = list(string)
      storage_class = string
      storage_size = string
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
      storage_class = "default"
      storage_size = "50Gi"
    }
    grafana = {
      enabled = true
      admin_password = "changeme"
      storage_class = "default"
      storage_size = "10Gi"
    }
    alertmanager = {
      enabled = true
      smtp_host = "smtp.example.com"
      smtp_port = 587
      alert_recipients = ["alerts@example.com"]
      storage_class = "default"
      storage_size = "10Gi"
    }
    node_exporter = {
      enabled = true
      port = 9100
    }
  }
}

# Backup Configuration
variable "backup_config" {
  description = "Backup configuration"
  type = object({
    enabled = bool
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
    etcd_backup = object({
      enabled = bool
      schedule = string
      retention_days = number
    })
  })
  default = {
    enabled = true
    type = "velero"
    schedule = "0 2 * * *"
    retention = {
      daily = 7
      weekly = 4
      monthly = 6
      yearly = 2
    }
    storage = {
      type = "s3"
      path = "kubernetes-backups"
      credentials = {}
    }
    etcd_backup = {
      enabled = true
      schedule = "0 1 * * *"
      retention_days = 30
    }
  }
}

# Security Configuration
variable "security_config" {
  description = "Security configuration"
  type = object({
    pod_security_standards = object({
      enabled = bool
      enforce = string
      audit = string
      warn = string
    })
    network_policies = object({
      enabled = bool
      default_deny = bool
    })
    rbac = object({
      enabled = bool
      create_default_roles = bool
    })
    admission_controllers = list(string)
  })
  default = {
    pod_security_standards = {
      enabled = true
      enforce = "restricted"
      audit = "restricted"
      warn = "restricted"
    }
    network_policies = {
      enabled = true
      default_deny = true
    }
    rbac = {
      enabled = true
      create_default_roles = true
    }
    admission_controllers = [
      "NodeRestriction",
      "PodSecurityPolicy",
      "ResourceQuota"
    ]
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
