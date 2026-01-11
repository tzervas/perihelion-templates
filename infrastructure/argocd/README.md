# Secure ArgoCD Templates

This directory contains security-focused ArgoCD templates for GitOps deployments.

## Features

1. **Application Security**
   - Secure pod configuration
   - Network policies
   - Resource limits
   - RBAC integration

2. **Project Security**
   - Resource restrictions
   - Source repository whitelisting
   - Destination restrictions
   - Role-based access control

3. **Access Control**
   - Restricted service accounts
   - Minimal RBAC permissions
   - Group-based access
   - Sync windows

4. **Resource Management**
   - Automated sync policies
   - Orphaned resource handling
   - Self-healing
   - Pruning policies

## Templates

### Application Template
- Secure pod and container configuration
- Network policy integration
- Automated sync with safety measures
- Resource management

### Project Template
- Resource whitelisting
- Destination restrictions
- Role-based access
- Sync windows
- Orphaned resource management

### RBAC Template
- Restricted service account
- Minimal role permissions
- Secure role bindings
- Namespace scoping

## Usage

1. **Create a Project**
```bash
kubectl apply -f templates/project.yaml
```

2. **Deploy an Application**
```bash
kubectl apply -f templates/application.yaml
```

3. **Configure RBAC**
```bash
kubectl apply -f templates/rbac.yaml
```

## Security Best Practices

1. **Access Control**
   - Use restricted service accounts
   - Implement minimal RBAC permissions
   - Enable group-based access
   - Configure sync windows

2. **Resource Security**
   - Whitelist allowed resources
   - Restrict destination scopes
   - Enable network policies
   - Configure resource limits

3. **GitOps Security**
   - Use signed commits
   - Implement branch protection
   - Enable automated pruning
   - Configure self-healing

4. **Monitoring**
   - Enable audit logging
   - Monitor sync status
   - Track resource health
   - Alert on failures

## Implementation Notes

1. Customize repository URLs and paths
2. Adjust security context settings
3. Configure appropriate resource limits
4. Update RBAC permissions as needed
5. Set appropriate sync windows

## Contributing

1. Follow security best practices
2. Test thoroughly
3. Document changes
4. Update examples
