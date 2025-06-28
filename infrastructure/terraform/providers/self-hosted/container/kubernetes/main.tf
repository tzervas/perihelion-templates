# Self-hosted Kubernetes Cluster Provider

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
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# Local variables
locals {
  common_tags = merge(
    var.tags,
    {
      Environment     = var.environment
      ManagedBy      = "terraform"
      InfrastructureType = "kubernetes"
    }
  )

  # Distribution-specific configurations
  os_configs = {
    debian = {
      ssh_user = "debian"
      package_manager = "apt"
      container_runtime = "containerd"
    }
    ubuntu = {
      ssh_user = "ubuntu"
      package_manager = "apt"
      container_runtime = "containerd"
    }
    rhel = {
      ssh_user = "ec2-user"
      package_manager = "dnf"
      container_runtime = "containerd"
    }
    rocky = {
      ssh_user = "rocky"
      package_manager = "dnf"
      container_runtime = "containerd"
    }
  }
}

# Generate cluster CA certificate
resource "tls_private_key" "cluster_ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "cluster_ca" {
  private_key_pem = tls_private_key.cluster_ca.private_key_pem

  subject {
    common_name  = "kubernetes"
    organization = var.cluster_config.organization
  }

  validity_period_hours = 8760  # 1 year

  is_ca_certificate = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

# Generate kubeadm join token
resource "random_string" "kubeadm_token_first" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "kubeadm_token_second" {
  length  = 16
  special = false
  upper   = false
}

# Generate encryption key for etcd
resource "random_string" "etcd_encryption_key" {
  length  = 32
  special = false
}

# Cluster configuration files
resource "local_file" "cluster_config" {
  content = templatefile("${path.module}/templates/cluster-config.yaml.tpl", {
    cluster_name    = var.cluster_config.name
    pod_subnet      = var.cluster_config.pod_subnet
    service_subnet  = var.cluster_config.service_subnet
    cluster_domain  = var.cluster_config.cluster_domain
    api_server_endpoint = var.cluster_config.api_server_endpoint
    ca_cert_hash    = sha256(tls_self_signed_cert.cluster_ca.cert_pem)
    encryption_key  = base64encode(random_string.etcd_encryption_key.result)
  })
  filename = "${path.module}/output/cluster-config.yaml"
}

resource "local_file" "kubeadm_config" {
  content = templatefile("${path.module}/templates/kubeadm-config.yaml.tpl", {
    cluster_name    = var.cluster_config.name
    pod_subnet      = var.cluster_config.pod_subnet
    service_subnet  = var.cluster_config.service_subnet
    api_server_endpoint = var.cluster_config.api_server_endpoint
    etcd_endpoints  = var.cluster_config.etcd_endpoints
    ca_cert         = base64encode(tls_self_signed_cert.cluster_ca.cert_pem)
    ca_key          = base64encode(tls_private_key.cluster_ca.private_key_pem)
  })
  filename = "${path.module}/output/kubeadm-config.yaml"
}

# Control plane initialization
resource "null_resource" "control_plane_init" {
  for_each = var.control_plane_nodes

  triggers = {
    node_ip = each.value.ip_address
    config_hash = md5(local_file.kubeadm_config.content)
  }

  connection {
    type        = "ssh"
    user        = local.os_configs[each.value.os_type].ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = each.value.ip_address
  }

  # Upload configuration files
  provisioner "file" {
    content     = local_file.kubeadm_config.content
    destination = "/tmp/kubeadm-config.yaml"
  }

  provisioner "file" {
    content     = tls_self_signed_cert.cluster_ca.cert_pem
    destination = "/tmp/ca.crt"
  }

  provisioner "file" {
    content     = tls_private_key.cluster_ca.private_key_pem
    destination = "/tmp/ca.key"
  }

  provisioner "remote-exec" {
    inline = [
      # System preparation
      "sudo hostnamectl set-hostname ${each.key}",
      "sudo timedatectl set-timezone ${var.timezone}",

      # Install container runtime
      var.container_runtime.type == "containerd" ? 
        templatefile("${path.module}/scripts/install-containerd.sh", {
          os_type = each.value.os_type
          version = var.container_runtime.version
        }) : "",

      # Install Kubernetes components
      templatefile("${path.module}/scripts/install-kubernetes.sh", {
        os_type = each.value.os_type
        version = var.kubernetes_version
      }),

      # Configure networking
      "sudo sysctl -w net.bridge.bridge-nf-call-iptables=1",
      "sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1",
      "sudo sysctl -w net.ipv4.ip_forward=1",

      # Initialize cluster (only on first control plane node)
      length(var.control_plane_nodes) == 1 || each.key == keys(var.control_plane_nodes)[0] ?
        "sudo kubeadm init --config=/tmp/kubeadm-config.yaml --upload-certs" :
        "echo 'Secondary control plane node'",

      # Setup kubectl for user
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",

      # Install CNI (only on first node)
      length(var.control_plane_nodes) == 1 || each.key == keys(var.control_plane_nodes)[0] ?
        var.cni_plugin.type == "calico" ?
          "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v${var.cni_plugin.version}/manifests/calico.yaml" :
          var.cni_plugin.type == "flannel" ?
            "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml" :
            "echo 'Unsupported CNI plugin'" :
        "echo 'CNI already installed'",

      # Security hardening
      templatefile("${path.module}/scripts/harden-node.sh", {
        node_type = "control-plane"
      })
    ]
  }
}

# Worker node setup
resource "null_resource" "worker_nodes" {
  for_each = var.worker_nodes

  depends_on = [null_resource.control_plane_init]

  triggers = {
    node_ip = each.value.ip_address
    token = "${random_string.kubeadm_token_first.result}.${random_string.kubeadm_token_second.result}"
  }

  connection {
    type        = "ssh"
    user        = local.os_configs[each.value.os_type].ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = each.value.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      # System preparation
      "sudo hostnamectl set-hostname ${each.key}",
      "sudo timedatectl set-timezone ${var.timezone}",

      # Install container runtime
      var.container_runtime.type == "containerd" ? 
        templatefile("${path.module}/scripts/install-containerd.sh", {
          os_type = each.value.os_type
          version = var.container_runtime.version
        }) : "",

      # Install Kubernetes components
      templatefile("${path.module}/scripts/install-kubernetes.sh", {
        os_type = each.value.os_type
        version = var.kubernetes_version
      }),

      # Configure networking
      "sudo sysctl -w net.bridge.bridge-nf-call-iptables=1",
      "sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1",
      "sudo sysctl -w net.ipv4.ip_forward=1",

      # Join cluster
      "sudo kubeadm join ${var.cluster_config.api_server_endpoint} --token ${random_string.kubeadm_token_first.result}.${random_string.kubeadm_token_second.result} --discovery-token-ca-cert-hash sha256:${sha256(tls_self_signed_cert.cluster_ca.cert_pem)}",

      # Security hardening
      templatefile("${path.module}/scripts/harden-node.sh", {
        node_type = "worker"
      })
    ]
  }
}

# Generate cluster access configurations
resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/templates/kubeconfig.yaml.tpl", {
    cluster_name = var.cluster_config.name
    api_server_endpoint = var.cluster_config.api_server_endpoint
    ca_cert = base64encode(tls_self_signed_cert.cluster_ca.cert_pem)
  })
  filename = "${path.module}/output/kubeconfig.yaml"
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    control_plane_nodes = var.control_plane_nodes
    worker_nodes       = var.worker_nodes
    environment        = var.environment
  })
  filename = "${path.module}/ansible/inventory.yml"
}

# Generate monitoring configuration
resource "local_file" "monitoring_config" {
  content = templatefile("${path.module}/templates/monitoring.tpl", {
    cluster_config = var.cluster_config
    monitoring_config = var.monitoring_config
    all_nodes = merge(var.control_plane_nodes, var.worker_nodes)
  })
  filename = "${path.module}/monitoring/config.yml"
}

# Generate backup configuration
resource "local_file" "backup_config" {
  content = templatefile("${path.module}/templates/backup.tpl", {
    cluster_config = var.cluster_config
    backup_config = var.backup_config
    all_nodes = merge(var.control_plane_nodes, var.worker_nodes)
  })
  filename = "${path.module}/backup/config.yml"
}
