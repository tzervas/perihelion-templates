module "bare_metal_infrastructure" {
  source = "../../"

  environment = "production"
  ssh_private_key_path = "/path/to/ssh/key"
  timezone = "UTC"

  servers = {
    "app-server-1" = {
      ip_address = "192.168.1.10"
      os_type    = "ubuntu"
      role       = "application"
      specifications = {
        cpu_cores  = 4
        memory_gb  = 16
        storage_gb = 100
      }
      network = {
        subnet      = "192.168.1.0/24"
        gateway     = "192.168.1.1"
        dns_servers = ["8.8.8.8", "8.8.4.4"]
      }
    }
    "db-server-1" = {
      ip_address = "192.168.1.11"
      os_type    = "rocky"
      role       = "database"
      specifications = {
        cpu_cores  = 8
        memory_gb  = 32
        storage_gb = 500
      }
      network = {
        subnet      = "192.168.1.0/24"
        gateway     = "192.168.1.1"
        dns_servers = ["8.8.8.8", "8.8.4.4"]
      }
    }
  }

  monitoring_config = {
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
    node_exporter = {
      enabled = true
      port = 9100
    }
  }

  backup_config = {
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
