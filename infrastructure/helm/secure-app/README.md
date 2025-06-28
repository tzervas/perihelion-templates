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

## Enhanced Security Features

### Supply Chain Security
- ✅ Container images pinned to SHA256 digests
- ✅ Secure dependency versions (cert-manager ~1.15.3, kube-prometheus-stack ~61.7.2)
- ✅ Service account token automount disabled
- ✅ Security policy annotations and compliance markers

### Pod Security Standards
- ✅ Non-root user execution (uid 1000, gid 3000, fsGroup 2000)
- ✅ Read-only root filesystem with essential volume mounts
- ✅ All capabilities dropped (CAP_ALL)
- ✅ SecComp profile enforcement (RuntimeDefault)
- ✅ No privilege escalation allowed
- ✅ Essential EmptyDir volumes for /tmp, /var/run, /var/cache

### Resource Management
- ✅ ResourceQuota for namespace-level limits
- ✅ LimitRange for default resource constraints
- ✅ Pod Disruption Budget for high availability (minAvailable: 2)
- ✅ Ephemeral storage limits and monitoring
- ✅ NodePort services disabled for security

### Network Security
- ✅ Default deny network policies
- ✅ Explicit DNS and HTTPS egress allowlist
- ✅ Internal namespace communication controls
- ✅ TLS termination and force HTTPS redirects
- ✅ ClusterIP service exposure only

### Access Control
- ✅ RBAC enabled with minimal read-only permissions
- ✅ Service account restrictions and security annotations
- ✅ No cluster-level permissions granted
- ✅ Resource access limited to pods, services, deployments

### Monitoring & Security Alerting
- ✅ Prometheus ServiceMonitor with metric filtering
- ✅ Security-focused PrometheusRules
- ✅ High memory/CPU usage alerts
- ✅ Pod restart monitoring and alerting
- ✅ Security context violation detection
- ✅ Comprehensive liveness/readiness health checks

## Security Best Practices

1. **Container Security**
   - Use minimal base images
   - Keep images updated
   - Scan for vulnerabilities
   - Sign container images
   - Pin to specific digests

2. **Network Security**
   - Enable network policies
   - Use internal services
   - Enable TLS
   - Implement service mesh
   - Default deny egress

3. **Access Control**
   - Use RBAC
   - Minimize permissions
   - Rotate credentials
   - Audit access logs
   - Disable token automount

4. **Runtime Security**
   - Set resource limits
   - Enable security contexts
   - Use read-only filesystems
   - Drop capabilities
   - Monitor security violations

## Example Values

See the [values.yaml](values.yaml) file for the full list of configurable parameters.

## Contributing

1. Follow security best practices
2. Test thoroughly
3. Document changes
4. Update CHANGELOG

## License

MIT Licensed. See [LICENSE](LICENSE) file.
