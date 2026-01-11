# KVM Infrastructure Provider

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
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

# Libvirt Connection
provider "libvirt" {
  uri = var.libvirt_uri
}

# Local variables
locals {
  common_tags = merge(
    var.tags,
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      InfrastructureType = "kvm"
    }
  )

  # Distribution-specific configurations
  os_configs = {
    debian = {
      image = var.os_images.debian
      pool  = var.storage_pools.images
    }
    ubuntu = {
      image = var.os_images.ubuntu
      pool  = var.storage_pools.images
    }
    rocky = {
      image = var.os_images.rocky
      pool  = var.storage_pools.images
    }
  }
}

# Storage Pools
resource "libvirt_pool" "images" {
  name = "${var.environment}-images"
  type = "dir"
  path = var.storage_pools.images
}

resource "libvirt_pool" "volumes" {
  name = "${var.environment}-volumes"
  type = "dir"
  path = var.storage_pools.volumes
}

# Cloud Init Image
resource "libvirt_cloudinit_disk" "commoninit" {
  for_each = var.virtual_machines
  name      = "${each.key}-commoninit.iso"
  pool      = libvirt_pool.images.name
  user_data = templatefile("${path.module}/templates/cloud_init.tpl", {
    hostname   = each.key
    ssh_user   = var.ssh_username
    ssh_key    = file(var.ssh_public_key_path)
    timezone   = var.timezone
    dns_servers = each.value.dns_servers
  })
  network_config = templatefile("${path.module}/templates/network_config.tpl", {
    networks = each.value.networks
  })
}

# Base Volume
resource "libvirt_volume" "base" {
  for_each = var.virtual_machines
  name   = "${each.key}-base"
  pool   = libvirt_pool.images.name
  source = local.os_configs[each.value.os_type].image
  format = "qcow2"
}

# VM Volumes
resource "libvirt_volume" "vm_volume" {
  for_each = var.virtual_machines
  name           = "${each.key}-volume"
  base_volume_id = libvirt_volume.base[each.key].id
  pool           = libvirt_pool.volumes.name
  size           = each.value.disk_size * 1024 * 1024 * 1024  # Convert GB to bytes
}

# Virtual Machines
resource "libvirt_domain" "vm" {
  for_each = var.virtual_machines
  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.cpu_cores

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.vm_volume[each.key].id
  }

  # Primary network interface
  network_interface {
    network_name = each.value.networks[0].network_name
    wait_for_lease = true
  }

  # Additional network interfaces
  dynamic "network_interface" {
    for_each = slice(each.value.networks, 1, length(each.value.networks))
    content {
      network_name = network_interface.value.network_name
      wait_for_lease = true
    }
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  xml {
    xslt = file("${path.module}/templates/domain.xsl")
  }
}

# Post-provisioning configuration
resource "null_resource" "post_provision" {
  for_each = var.virtual_machines

  triggers = {
    vm_id = libvirt_domain.vm[each.key].id
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
      
      # QEMU guest agent
      each.value.os_type == "debian" || each.value.os_type == "ubuntu" ?
        "apt-get install -y qemu-guest-agent" :
        "dnf install -y qemu-guest-agent",
      "systemctl enable --now qemu-guest-agent",
      
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
    virtual_machines = libvirt_domain.vm
    monitoring_config = var.monitoring_config
  })
  filename = "${path.module}/monitoring/config.yml"
}

# Generate backup configuration
resource "local_file" "backup_config" {
  content = templatefile("${path.module}/templates/backup.tpl", {
    virtual_machines = libvirt_domain.vm
    backup_config = var.backup_config
  })
  filename = "${path.module}/backup/config.yml"
}
