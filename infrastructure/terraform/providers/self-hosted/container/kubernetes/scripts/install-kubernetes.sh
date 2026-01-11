#!/bin/bash
set -e

OS_TYPE="${os_type}"
K8S_VERSION="${version}"

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install Kubernetes components based on OS type
if [[ "$OS_TYPE" == "debian" || "$OS_TYPE" == "ubuntu" ]]; then
    # Update package index
    sudo apt-get update
    
    # Install required packages
    sudo apt-get install -y apt-transport-https ca-certificates curl
    
    # Add Kubernetes GPG key
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
    
    # Add Kubernetes repository
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    # Update package index
    sudo apt-get update
    
    # Install Kubernetes components
    sudo apt-get install -y kubelet=${K8S_VERSION}-00 kubeadm=${K8S_VERSION}-00 kubectl=${K8S_VERSION}-00
    
    # Hold packages at current version
    sudo apt-mark hold kubelet kubeadm kubectl
    
elif [[ "$OS_TYPE" == "rhel" || "$OS_TYPE" == "rocky" ]]; then
    # Add Kubernetes repository
    cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
    
    # Set SELinux to permissive mode
    sudo setenforce 0
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
    
    # Install Kubernetes components
    sudo dnf install -y kubelet-${K8S_VERSION} kubeadm-${K8S_VERSION} kubectl-${K8S_VERSION} --disableexcludes=kubernetes
fi

# Enable kubelet
sudo systemctl enable --now kubelet

# Configure crictl
sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
sudo crictl config image-endpoint unix:///var/run/containerd/containerd.sock

# Create kubelet configuration directory
sudo mkdir -p /var/lib/kubelet

# Configure kubelet
cat <<EOF | sudo tee /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
authorization:
  mode: Webhook
cgroupDriver: systemd
clusterDNS:
  - "10.96.0.10"
clusterDomain: "cluster.local"
containerRuntimeEndpoint: "unix:///var/run/containerd/containerd.sock"
protectKernelDefaults: true
readOnlyPort: 0
rotateCertificates: true
serverTLSBootstrap: true
staticPodPath: "/etc/kubernetes/manifests"
streamingConnectionIdleTimeout: "4h"
EOF

# Create kubelet systemd drop-in
sudo mkdir -p /etc/systemd/system/kubelet.service.d
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
Environment="KUBELET_KUBEADM_ARGS=--container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9"
Environment="KUBELET_EXTRA_ARGS="
ExecStart=
ExecStart=/usr/bin/kubelet \$KUBELET_KUBECONFIG_ARGS \$KUBELET_CONFIG_ARGS \$KUBELET_KUBEADM_ARGS \$KUBELET_EXTRA_ARGS
EOF

# Reload systemd and restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo "Kubernetes installation completed successfully"
