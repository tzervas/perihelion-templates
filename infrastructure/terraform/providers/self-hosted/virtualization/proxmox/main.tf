# Proxmox Infrastructure Provider

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Proxmox Connection
provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure    = var.allow_insecure_ssl
}

# Local variables
locals {
  common_tags = merge(
    var.tags,
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      InfrastructureType = "proxmox"
    }
  )

  # Distribution-specific configurations
  os_configs = {
    debian = {
      template = var.templates.debian
      type     = "cloud-init"
    }
    ubuntu = {
      template = var.templates.ubuntu
      type     = "cloud-init"
    }
    rocky = {
      template = var.templates.rocky
      type     = "cloud-init"
    }
  }
}

# VM Creation
resource "proxmox_vm_qemu" "vm" {
  for_each = var.virtual_machines

  name        = each.key
  target_node = each.value.target_node
  vmid        = each.value.vmid
  clone       = local.os_configs[each.value.os_type].template

  # VM Resources
  cores    = each.value.cpu_cores
  sockets  = each.value.cpu_sockets
  memory   = each.value.memory
  onboot   = true
  oncreate = true

  # Cloud-init configuration
  os_type      = "cloud-init"
  ipconfig0    = "ip=${each.value.networks[0].ip_address}/${each.value.networks[0].netmask},gw=${each.value.networks[0].gateway}"
  nameserver   = join(" ", each.value.dns_servers)
  searchdomain = var.domain

  # Network interfaces
  network {
    model  = "virtio"
    bridge = each.value.networks[0].bridge
    tag    = each.value.networks[0].vlan_id
  }

  dynamic "network" {
    for_each = slice(each.value.networks, 1, length(each.value.networks))
    content {
      model  = "virtio"
      bridge = network.value.bridge
      tag    = network.value.vlan_id
    }
  }

  # Storage configuration
  disk {
    type    = "scsi"
    storage = each.value.storage_pool
    size    = "${each.value.disk_size}G"
    ssd     = each.value.disk_type == "ssd"
    backup  = var.backup_config.enabled
  }

  # SSH key
  sshkeys = file(var.ssh_public_key_path)

  # Tags
  tags = join(";", concat(
    ["env=${var.environment}", "role=${each.value.role}"],
    [for key, value in local.common_tags : "${key}=${value}"]
  ))

  # Lifecycle
  lifecycle {
    ignore_changes = [
      network,
      disk
    ]
  }
}

# Post-provisioning configuration
resource "null_resource" "post_provision" {
  for_each = var.virtual_machines

  triggers = {
    vm_id = proxmox_vm_qemu.vm[each.key].id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ssh_username
      private_key = file(var.ssh_private_key_path)
      host        = each.value.networks[0].ip_address
    }

    inline = [
      # Base configuration
      "hostnamectl set-hostname ${each.key}",
      "timedatectl set-timezone ${var.timezone}",
      
      # Security hardening
      "sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config",
      "systemctl restart sshd",
      
      # System updates
      each.value.os_type == "debian" || each.value.os_type == "ubuntu" ? 
        "apt-get update && apt-get upgrade -y" : 
        "dnf update -y",
      
      # Monitoring setup
      var.monitoring_config.node_exporter.enabled ?
        "curl -sSL ${var.monitoring_config.node_exporter.download_url} | sh" :
        "echo 'Monitoring disabled'",
      
      # Backup agent setup
      var.backup_config.enabled ?
        "curl -sSL ${var.backup_config.agent_url} | sh" :
        "echo 'Backup disabled'"
    ]
  }
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    virtual_machines = var.virtual_machines
    environment     = var.environment
    ssh_username    = var.ssh_username
  })
  filename = "${path.module}/ansible/inventory.yml"
}

# Generate monitoring configuration
resource "local_file" "monitoring_config" {
  content = templatefile("${path.module}/templates/monitoring.tpl", {
    virtual_machines = proxmox_vm_qemu.vm
    monitoring_config = var.monitoring_config
  })
  filename = "${path.module}/monitoring/config.yml"
}

# Generate backup configuration
resource "local_file" "backup_config" {
  content = templatefile("${path.module}/templates/backup.tpl", {
    virtual_machines = proxmox_vm_qemu.vm
    backup_config = var.backup_config
  })
  filename = "${path.module}/backup/config.yml"
}
