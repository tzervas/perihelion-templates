# Secure Application Helm Chart

This Helm chart implements a security-first approach to deploying applications in Kubernetes.

## Features

1. **Security Context**
   - Non-root user execution
   - Read-only root filesystem
   - Dropped capabilities
   - Resource limits

2. **Network Security**
   - Network policies
   - Internal-only services
   - TLS configuration
   - Service mesh ready

3. **Access Control**
   - RBAC integration
   - Service account management
   - Least privilege principles
   - Resource restrictions

4. **Monitoring**
   - Prometheus integration
   - Service monitoring
   - Health checks
   - Resource tracking

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- cert-manager (optional)
- Prometheus Operator (optional)

## Installation

```bash
helm install my-app secure-app \
  --set global.security.networkPolicies.enabled=true \
  --set certManager.enabled=true
```

## Configuration

### Global Security Settings

```yaml
global:
  security:
    podSecurityContext:
      runAsNonRoot: true
      runAsUser: 1000
    containerSecurityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
```

### Network Policies

```yaml
global:
  security:
    networkPolicies:
      enabled: true
      ingressRules:
        - from:
            - podSelector:
                matchLabels:
                  app: frontend
```

### RBAC Configuration

```yaml
rbac:
  enabled: true
  rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list"]
```

### TLS/Certificate Management

```yaml
certManager:
  enabled: true
  certificate:
    enabled: true
    dnsNames:
      - secure-app.example.com
```

### Monitoring

```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 30s
```

## Security Best Practices

1. **Container Security**
   - Use minimal base images
   - Keep images updated
   - Scan for vulnerabilities
   - Sign container images

2. **Network Security**
   - Enable network policies
   - Use internal services
   - Enable TLS
   - Implement service mesh

3. **Access Control**
   - Use RBAC
   - Minimize permissions
   - Rotate credentials
   - Audit access logs

4. **Runtime Security**
   - Set resource limits
   - Enable security contexts
   - Use read-only filesystems
   - Drop capabilities

## Example Values

See the [values.yaml](values.yaml) file for the full list of configurable parameters.

## Contributing

1. Follow security best practices
2. Test thoroughly
3. Document changes
4. Update CHANGELOG

## License

MIT Licensed. See [LICENSE](LICENSE) file.
