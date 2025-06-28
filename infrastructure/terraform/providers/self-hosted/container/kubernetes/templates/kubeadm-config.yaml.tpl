apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  criSocket: "unix:///var/run/containerd/containerd.sock"
  kubeletExtraArgs:
    cgroup-driver: "systemd"
    container-runtime-endpoint: "unix:///var/run/containerd/containerd.sock"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
clusterName: ${cluster_name}
kubernetesVersion: v${var.kubernetes_version}
controlPlaneEndpoint: "${api_server_endpoint}"
networking:
  podSubnet: "${pod_subnet}"
  serviceSubnet: "${service_subnet}"
  dnsDomain: "${var.cluster_config.cluster_domain}"
apiServer:
  certSANs:
    - "${api_server_endpoint}"
    - "127.0.0.1"
    - "localhost"
  extraArgs:
    audit-log-maxage: "30"
    audit-log-maxbackup: "10"
    audit-log-maxsize: "100"
    audit-log-path: "/var/log/kubernetes/audit.log"
    enable-admission-plugins: "NodeRestriction,PodSecurityPolicy"
    encryption-provider-config: "/etc/kubernetes/encryption-config.yaml"
  extraVolumes:
    - name: audit-log
      hostPath: "/var/log/kubernetes"
      mountPath: "/var/log/kubernetes"
      pathType: DirectoryOrCreate
controllerManager:
  extraArgs:
    bind-address: "0.0.0.0"
    terminated-pod-gc-threshold: "1000"
scheduler:
  extraArgs:
    bind-address: "0.0.0.0"
etcd:
  local:
    dataDir: "/var/lib/etcd"
    extraArgs:
      listen-metrics-urls: "http://0.0.0.0:2381"
certificatesDir: "/etc/kubernetes/pki"
imageRepository: "registry.k8s.io"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/etc/kubernetes/pki/ca.crt"
authorization:
  mode: Webhook
cgroupDriver: "systemd"
clusterDNS:
  - "10.96.0.10"
clusterDomain: "${var.cluster_config.cluster_domain}"
containerRuntimeEndpoint: "unix:///var/run/containerd/containerd.sock"
cpuManagerPolicy: "static"
enforceNodeAllocatable:
  - "pods"
  - "system-reserved"
  - "kube-reserved"
eventRecordQPS: 5
evictionHard:
  memory.available: "100Mi"
  nodefs.available: "10%"
  nodefs.inodesFree: "5%"
featureGates:
  RotateKubeletServerCertificate: true
kubeReserved:
  cpu: "100m"
  memory: "100Mi"
  ephemeral-storage: "1Gi"
systemReserved:
  cpu: "100m"
  memory: "100Mi"
  ephemeral-storage: "1Gi"
protectKernelDefaults: true
readOnlyPort: 0
resolvConf: "/etc/resolv.conf"
rotateCertificates: true
runtimeRequestTimeout: "10m"
serverTLSBootstrap: true
staticPodPath: "/etc/kubernetes/manifests"
streamingConnectionIdleTimeout: "4h"
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
bindAddress: "0.0.0.0"
clientConnection:
  acceptContentTypes: ""
  burst: 10
  contentType: "application/vnd.kubernetes.protobuf"
  kubeconfig: "/var/lib/kube-proxy/kubeconfig.conf"
  qps: 5
clusterCIDR: "${pod_subnet}"
configSyncPeriod: "15m"
conntrack:
  maxPerCore: 32768
  min: 131072
  tcpCloseWaitTimeout: "1h"
  tcpEstablishedTimeout: "24h"
enableProfiling: false
healthzBindAddress: "0.0.0.0:10256"
hostnameOverride: ""
iptables:
  masqueradeAll: false
  masqueradeBit: 14
  minSyncPeriod: "0s"
  syncPeriod: "30s"
ipvs:
  excludeCIDRs: []
  minSyncPeriod: "0s"
  scheduler: ""
  strictARP: false
  syncPeriod: "30s"
  tcpFinTimeout: "0s"
  tcpTimeout: "0s"
  udpTimeout: "0s"
metricsBindAddress: "127.0.0.1:10249"
mode: ""
nodePortAddresses: []
oomScoreAdj: -999
portRange: ""
showHiddenMetricsForVersion: ""
udpIdleTimeout: "250ms"
winkernel:
  enableDSR: false
  networkName: ""
  sourceVip: ""
