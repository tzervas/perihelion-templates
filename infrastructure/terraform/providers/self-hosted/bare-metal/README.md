# Bare Metal Infrastructure Provider

This provider template manages bare metal infrastructure deployments across various Linux distributions.

## Features

1. **Multi-Distribution Support**
   - Debian-based (Debian, Ubuntu)
   - RHEL-based (RHEL, Rocky Linux)
   - SUSE-based (SLES, OpenSUSE)

2. **Server Management**
   - Basic system configuration
   - Package management
   - Security hardening
   - Network configuration

3. **Monitoring Integration**
   - Prometheus
   - Node Exporter
   - AlertManager
   - Custom alert rules

4. **Backup Management**
   - Multiple backup solutions (restic, borgbackup)
   - Flexible retention policies
   - Various storage backends
   - Automated scheduling

## Prerequisites

- SSH access to target servers
- Sudo/root access for initial setup
- Network connectivity between servers
- DNS resolution configured

## Usage

1. **Basic Configuration**

```hcl
module "bare_metal" {
  source = "path/to/bare-metal"

  environment = "production"
  ssh_private_key_path = "/path/to/key"

  servers = {
    "app-1" = {
      ip_address = "192.168.1.10"
      os_type    = "ubuntu"
      role       = "application"
      # ... other config
    }
  }
}
```

2. **With Monitoring**

```hcl
module "bare_metal" {
  # ... basic config ...

  monitoring_config = {
    prometheus = {
      enabled = true
      retention_days = 30
      scrape_interval = "15s"
    }
    # ... other monitoring config
  }
}
```

3. **With Backups**

```hcl
module "bare_metal" {
  # ... basic config ...

  backup_config = {
    enabled = true
    type = "restic"
    schedule = "0 2 * * *"
    # ... other backup config
  }
}
```

## Server Configuration

### Supported OS Types
- `debian`: Debian Linux
- `ubuntu`: Ubuntu Linux
- `rhel`: Red Hat Enterprise Linux
- `rocky`: Rocky Linux

### Role Types
- `application`: Application servers
- `database`: Database servers
- `storage`: Storage servers
- `monitoring`: Monitoring servers

## Security Features

1. **System Hardening**
   - Automatic updates
   - Firewall configuration
   - SSH hardening
   - Service hardening

2. **Network Security**
   - Firewall rules
   - Network isolation
   - Service exposure control
   - Traffic monitoring

3. **Access Control**
   - SSH key management
   - Sudo configuration
   - Service accounts
   - Permission management

4. **Monitoring & Auditing**
   - System logging
   - Audit logging
   - Performance monitoring
   - Security monitoring

## Monitoring Configuration

### Prometheus
- Metrics collection
- Data retention
- Alert configuration
- PromQL rules

### AlertManager
- Email notifications
- Alert routing
- Alert grouping
- Silence management

### Node Exporter
- System metrics
- Custom collectors
- Performance data
- Resource utilization

## Backup Configuration

### Supported Backends
- Local storage
- S3-compatible
- SFTP
- NFS

### Retention Policies
- Daily backups
- Weekly backups
- Monthly backups
- Yearly backups

### Features
- Encryption
- Deduplication
- Compression
- Verification

## Implementation Notes

1. **Initial Setup**
   - Ensure SSH access
   - Configure sudo access
   - Update system packages
   - Install prerequisites

2. **Network Setup**
   - Configure static IPs
   - Set up DNS resolution
   - Configure firewall rules
   - Test connectivity

3. **Monitoring Setup**
   - Deploy Prometheus
   - Configure exporters
   - Set up alerting
   - Verify metrics

4. **Backup Setup**
   - Install backup software
   - Configure storage
   - Set up schedules
   - Test restores

## Contributing

1. Follow security best practices
2. Test on all supported distributions
3. Document changes thoroughly
4. Update examples
5. Verify monitoring integration
