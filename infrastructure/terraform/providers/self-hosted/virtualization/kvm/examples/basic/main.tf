module "kvm_infrastructure" {
  source = "../../"

  # KVM Connection
  libvirt_uri = "qemu:///system"

  # Environment
  environment = "production"

  # Storage Configuration
  storage_pools = {
    images  = "/var/lib/libvirt/images"
    volumes = "/var/lib/libvirt/volumes"
  }

  # OS Images
  os_images = {
    debian = "/var/lib/libvirt/images/debian-11-generic-amd64.qcow2"
    ubuntu = "/var/lib/libvirt/images/ubuntu-22.04-server-cloudimg-amd64.img"
    rocky  = "/var/lib/libvirt/images/Rocky-8-GenericCloud.qcow2"
  }

  # Virtual Machines
  virtual_machines = {
    "app-server-1" = {
      os_type      = "ubuntu"
      cpu_cores    = 4
      memory       = 8192
      disk_size    = 100
      role         = "application"
      networks = [
        {
          network_name = "default"
          ip_address  = "192.168.1.101"
          gateway     = "192.168.1.1"
          netmask     = 24
          dns_servers = ["8.8.8.8", "8.8.4.4"]
        }
      ]
      dns_servers = ["8.8.8.8", "8.8.4.4"]
    }

    "db-server-1" = {
      os_type      = "rocky"
      cpu_cores    = 8
      memory       = 16384
      disk_size    = 500
      role         = "database"
      networks = [
        {
          network_name = "default"
          ip_address  = "192.168.1.102"
          gateway     = "192.168.1.1"
          netmask     = 24
          dns_servers = ["8.8.8.8", "8.8.4.4"]
        },
        {
          network_name = "storage"
          ip_address  = "172.16.1.102"
          gateway     = "172.16.1.1"
          netmask     = 24
          dns_servers = ["8.8.8.8", "8.8.4.4"]
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
