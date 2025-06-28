module "proxmox_infrastructure" {
  source = "../../"

  # Proxmox Connection
  proxmox_api_url         = "https://proxmox.example.com:8006/api2/json"
  proxmox_api_token_id    = "terraform@pve!terraform-token"
  proxmox_api_token_secret = "REDACTED"
  allow_insecure_ssl      = false

  # Environment
  environment = "production"
  domain      = "example.com"

  # Templates
  templates = {
    debian = "debian-11-template"
    ubuntu = "ubuntu-22.04-template"
    rocky  = "rocky-8-template"
  }

  # Virtual Machines
  virtual_machines = {
    "app-server-1" = {
      target_node  = "pve1"
      vmid         = 101
      os_type      = "ubuntu"
      cpu_cores    = 4
      cpu_sockets  = 1
      memory       = 8192
      disk_size    = 100
      disk_type    = "ssd"
      storage_pool = "local-lvm"
      role         = "application"
      networks = [
        {
          bridge     = "vmbr0"
          ip_address = "192.168.1.101"
          netmask    = 24
          gateway    = "192.168.1.1"
          vlan_id    = 0
        }
      ]
      dns_servers = ["8.8.8.8", "8.8.4.4"]
    }

    "db-server-1" = {
      target_node  = "pve1"
      vmid         = 102
      os_type      = "rocky"
      cpu_cores    = 8
      cpu_sockets  = 1
      memory       = 16384
      disk_size    = 500
      disk_type    = "ssd"
      storage_pool = "local-lvm"
      role         = "database"
      networks = [
        {
          bridge     = "vmbr0"
          ip_address = "192.168.1.102"
          netmask    = 24
          gateway    = "192.168.1.1"
          vlan_id    = 0
        },
        {
          bridge     = "vmbr1"
          ip_address = "172.16.1.102"
          netmask    = 24
          gateway    = "172.16.1.1"
          vlan_id    = 100
        }
      ]
      dns_servers = ["8.8.8.8", "8.8.4.4"]
    }
  }

  # SSH Configuration
  ssh_username         = "admin"
  ssh_private_key_path = "/path/to/private/key"
  ssh_public_key_path  = "/path/to/public/key"
  timezone             = "UTC"

  # Monitoring Configuration
  monitoring_config = {
    node_exporter = {
      enabled = true
      download_url = "https://example.com/node_exporter_install.sh"
      port = 9100
    }
    prometheus = {
      enabled = true
      retention_days = 30
      scrape_interval = "15s"
    }
    alertmanager = {
      enabled = true
      smtp_host = "smtp.company.com"
      smtp_port = 587
      alert_recipients = ["ops@company.com"]
    }
  }

  # Backup Configuration
  backup_config = {
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
      type = "s3"
      path = "company-backups"
      credentials = {
        aws_access_key = "REDACTED"
        aws_secret_key = "REDACTED"
        aws_bucket = "company-backups"
        aws_region = "us-west-2"
      }
    }
  }

  tags = {
    Environment = "production"
    Project     = "company-app"
    ManagedBy   = "terraform"
  }
}
