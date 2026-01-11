# Self-hosted bare metal infrastructure provider

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Local variables for server configuration
locals {
  common_tags = merge(
    var.tags,
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      InfrastructureType = "bare-metal"
    }
  )

  # Distribution-specific configurations
  os_configs = {
    debian = {
      ssh_user = "debian"
      packages = ["apt-transport-https", "ca-certificates", "curl", "software-properties-common"]
      update_cmd = "apt-get update && apt-get upgrade -y"
    }
    ubuntu = {
      ssh_user = "ubuntu"
      packages = ["apt-transport-https", "ca-certificates", "curl", "software-properties-common"]
      update_cmd = "apt-get update && apt-get upgrade -y"
    }
    rhel = {
      ssh_user = "ec2-user"
      packages = ["yum-utils", "device-mapper-persistent-data", "lvm2"]
      update_cmd = "yum update -y"
    }
    rocky = {
      ssh_user = "rocky"
      packages = ["yum-utils", "device-mapper-persistent-data", "lvm2"]
      update_cmd = "dnf update -y"
    }
  }
}

# Server inventory management
resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    servers = var.servers
    os_configs = local.os_configs
  })
  filename = "${path.module}/inventory.yml"
}

# Server provisioning configuration
resource "null_resource" "server_provision" {
  for_each = var.servers

  triggers = {
    server_ip = each.value.ip_address
    os_type   = each.value.os_type
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = local.os_configs[each.value.os_type].ssh_user
      private_key = file(var.ssh_private_key_path)
      host        = each.value.ip_address
    }

    inline = [
      # Update system
      local.os_configs[each.value.os_type].update_cmd,
      
      # Install base packages
      "for pkg in ${join(" ", local.os_configs[each.value.os_type].packages)}; do ${each.value.os_type == "debian" || each.value.os_type == "ubuntu" ? "apt-get install -y" : "yum install -y"} $pkg; done",
      
      # Configure firewall
      each.value.os_type == "debian" || each.value.os_type == "ubuntu" ? "ufw allow ${var.ssh_port}/tcp" : "firewall-cmd --permanent --add-port=${var.ssh_port}/tcp",
      each.value.os_type == "debian" || each.value.os_type == "ubuntu" ? "ufw enable" : "firewall-cmd --reload",
      
      # Set hostname
      "hostnamectl set-hostname ${each.key}",
      
      # Configure timezone
      "timedatectl set-timezone ${var.timezone}",
      
      # Enable and start chronyd/ntp
      each.value.os_type == "debian" || each.value.os_type == "ubuntu" ? "systemctl enable ntp && systemctl start ntp" : "systemctl enable chronyd && systemctl start chronyd"
    ]
  }
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    servers = var.servers
    os_configs = local.os_configs
  })
  filename = "${path.module}/ansible/inventory.yml"
}

# Generate monitoring configuration
resource "local_file" "monitoring_config" {
  content = templatefile("${path.module}/templates/monitoring.tpl", {
    servers = var.servers
    monitoring_config = var.monitoring_config
  })
  filename = "${path.module}/monitoring/config.yml"
}

# Generate backup configuration
resource "local_file" "backup_config" {
  content = templatefile("${path.module}/templates/backup.tpl", {
    servers = var.servers
    backup_config = var.backup_config
  })
  filename = "${path.module}/backup/config.yml"
}
