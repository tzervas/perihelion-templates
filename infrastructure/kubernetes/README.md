# Secure Kubernetes Templates

This directory contains security-focused Kubernetes manifests and configurations.

## Directory Structure

```
kubernetes/
├── base/                    # Base configurations
│   ├── network-policies/    # Network isolation policies
│   ├── security/           # Security policies and configurations
│   ├── rbac/              # Role-based access control
│   ├── workloads/         # Secure workload templates
│   └── networking/        # Service and ingress configurations
└── overlays/              # Environment-specific configurations
    ├── development/
    ├── staging/
    └── production/
```

## Security Features

1. **Pod Security**
   - Non-root user execution
   - Read-only root filesystem
   - Resource limits and requests
   - Security context configuration
   - Seccomp and AppArmor profiles

2. **Network Security**
   - Default deny policies
   - Explicit ingress/egress rules
   - Service mesh integration readiness
   - Internal-only service exposure

3. **Access Control**
   - Least privilege RBAC roles
   - Service account restrictions
   - Token automounting disabled
   - Resource access limitations

4. **Container Security**
   - Dropped capabilities
   - No privilege escalation
   - Resource quotas
   - Liveness and readiness probes

## Usage

### Network Policies

Apply default deny policies:
```bash
kubectl apply -f base/network-policies/default-deny.yaml
```

### Pod Security

Deploy a secure pod:
```bash
kubectl apply -f base/workloads/secure-pod.yaml
```

### RBAC

Apply restricted roles:
```bash
kubectl apply -f base/rbac/restricted-role.yaml
```

## Security Best Practices

1. **Container Images**
   - Use minimal base images
   - Regular security updates
   - Image scanning
   - Signed images

2. **Runtime Security**
   - No privileged containers
   - Resource limitations
   - Read-only filesystems
   - Non-root execution

3. **Network Security**
   - Default deny policies
   - Explicit allow rules
   - Internal service exposure
   - TLS everywhere

4. **Access Control**
   - Minimal RBAC permissions
   - Service account controls
   - API server authentication
   - Audit logging

5. **Monitoring**
   - Security event logging
   - Resource monitoring
   - Network flow logging
   - Compliance checking

## Implementation Notes

1. All templates follow security best practices
2. Default configurations are secure by default
3. Resources are isolated by default
4. Network access is denied by default
5. Least privilege principle is enforced
