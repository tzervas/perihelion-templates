module "vmware_infrastructure" {
  source = "../../"

  # VMware Connection
  vsphere_server        = "vcenter.example.com"
  vsphere_user         = "administrator@vsphere.local"
  vsphere_password     = "REDACTED"
  allow_unverified_ssl = false

  # Infrastructure
  datacenter = "DC1"
  cluster    = "Cluster1"
  datastore  = "DatastoreA"
  networks   = ["VM Network", "DMZ Network"]
  environment = "production"
  domain     = "example.com"

  # VM Templates
  vm_templates = {
    ubuntu = "ubuntu-20.04-template"
    rocky  = "rocky-8-template"
  }

  # Resource Pool
  resource_pool_config = {
    cpu_share_level    = "normal"
    memory_share_level = "normal"
    cpu_reservation    = 0
    memory_reservation = 0
    cpu_limit         = -1
    memory_limit      = -1
  }

  # Virtual Machines
  virtual_machines = {
    "app-server-1" = {
      cpu            = 4
      memory         = 8192
      disk_size      = 100
      guest_id       = "ubuntu64Guest"
      template       = "ubuntu"
      thin_provision = true
      role           = "application"
      networks = [
        {
          name        = "VM Network"
          ip_address  = "192.168.1.10"
          netmask     = 24
          gateway     = "192.168.1.1"
        }
      ]
      dns_servers = ["8.8.8.8", "8.8.4.4"]
    }
    "db-server-1" = {
      cpu            = 8
      memory         = 16384
      disk_size      = 500
      guest_id       = "rocky64Guest"
      template       = "rocky"
      thin_provision = true
      role           = "database"
      networks = [
        {
          name        = "VM Network"
          ip_address  = "192.168.1.11"
          netmask     = 24
          gateway     = "192.168.1.1"
        },
        {
          name        = "DMZ Network"
          ip_address  = "172.16.1.11"
          netmask     = 24
          gateway     = "172.16.1.1"
        }
      ]
      dns_servers = ["8.8.8.8", "8.8.4.4"]
    }
  }

  # SSH Configuration
  ssh_username         = "admin"
  ssh_private_key_path = "/path/to/ssh/key"
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
