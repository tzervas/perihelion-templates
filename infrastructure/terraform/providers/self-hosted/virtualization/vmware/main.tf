# VMware Infrastructure Provider

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
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

# vSphere Connection
provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                = var.vsphere_user
  password            = var.vsphere_password
  allow_unverified_ssl = var.allow_unverified_ssl
}

# Data Sources
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each      = toset(var.networks)
  name          = each.value
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  for_each      = var.vm_templates
  name          = each.value
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Local variables
locals {
  vm_networks = {
    for vm_name, vm in var.virtual_machines : vm_name => [
      for network in vm.networks : {
        name = network.name
        id   = data.vsphere_network.network[network.name].id
      }
    ]
  }

  common_tags = merge(
    var.tags,
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      InfrastructureType = "vmware"
    }
  )
}

# Resource Pool
resource "vsphere_resource_pool" "pool" {
  name                    = "${var.environment}-pool"
  parent_resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  cpu_share_level    = var.resource_pool_config.cpu_share_level
  memory_share_level = var.resource_pool_config.memory_share_level

  cpu_reservation    = var.resource_pool_config.cpu_reservation
  memory_reservation = var.resource_pool_config.memory_reservation

  cpu_limit         = var.resource_pool_config.cpu_limit
  memory_limit      = var.resource_pool_config.memory_limit

  tags = local.common_tags
}

# Folder
resource "vsphere_folder" "folder" {
  path          = "${var.environment}-vms"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags          = local.common_tags
}

# Virtual Machines
resource "vsphere_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name             = each.key
  resource_pool_id = vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = vsphere_folder.folder.path

  num_cpus = each.value.cpu
  memory   = each.value.memory
  guest_id = each.value.guest_id

  network_interface {
    network_id = data.vsphere_network.network[each.value.networks[0].name].id
  }

  dynamic "network_interface" {
    for_each = slice(each.value.networks, 1, length(each.value.networks))
    content {
      network_id = data.vsphere_network.network[network_interface.value.name].id
    }
  }

  disk {
    label            = "disk0"
    size             = each.value.disk_size
    thin_provisioned = each.value.thin_provision
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.value.template].id

    customize {
      linux_options {
        host_name = each.key
        domain    = var.domain
      }

      dynamic "network_interface" {
        for_each = each.value.networks
        content {
          ipv4_address = network_interface.value.ip_address
          ipv4_netmask = network_interface.value.netmask
        }
      }

      ipv4_gateway = each.value.networks[0].gateway
      dns_server_list = each.value.dns_servers
    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name = each.key
      Role = each.value.role
    }
  )
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    virtual_machines = var.virtual_machines
    environment     = var.environment
  })
  filename = "${path.module}/ansible/inventory.yml"
}

# Post-provisioning configuration
resource "null_resource" "post_provision" {
  for_each = var.virtual_machines

  triggers = {
    vm_id = vsphere_virtual_machine.vm[each.key].id
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
      
      # Install monitoring agent
      var.monitoring_config.node_exporter.enabled ? "curl -sSL ${var.monitoring_config.node_exporter.download_url} | sh" : "echo 'Monitoring disabled'",
      
      # Configure backup agent
      var.backup_config.enabled ? "curl -sSL ${var.backup_config.agent_url} | sh" : "echo 'Backup disabled'"
    ]
  }
}
