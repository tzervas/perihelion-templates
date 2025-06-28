# Ansible Security Hardening Templates

This directory contains comprehensive Ansible playbooks and roles for security hardening of Linux systems with a security-first approach.

## Features

### 🔒 Base Security Hardening
- **System Hardening**: Enhanced sysctl settings, kernel parameters, and security controls
- **SSH Hardening**: Secure SSH configuration with modern ciphers and strict settings
- **Firewall Configuration**: UFW with default deny and explicit allow rules
- **Password Policies**: Strong password requirements and PAM configuration
- **System Limits**: Resource limits and security boundaries

### 🛡️ Security Tools & Monitoring
- **AIDE**: File integrity monitoring with daily checks
- **ClamAV**: Antivirus scanning with automated updates
- **RKHunter**: Rootkit detection and system verification
- **Fail2ban**: Intrusion prevention with SSH and web protection
- **Auditd**: Comprehensive system auditing and logging

### 📊 Logging & Compliance
- **Enhanced Logging**: Centralized security logging with rsyslog
- **Log Rotation**: Secure log management and retention policies
- **Audit Rules**: Comprehensive audit trail for security events
- **Compliance**: CIS benchmark compatible configurations

### ⚡ Automated Security
- **Auto Updates**: Automated security patch management
- **Time Synchronization**: Secure NTP configuration with chrony
- **AppArmor**: Mandatory access control enforcement
- **Automated Scans**: Daily security scans and integrity checks

## Directory Structure

```
ansible/
├── ansible.cfg              # Secure Ansible configuration
├── site.yml                 # Main site playbook
├── inventory/
│   └── sample-inventory.yml # Sample inventory with security settings
└── roles/
    └── base_security/       # Base security hardening role
        ├── defaults/
        │   └── main.yml     # Security configuration variables
        ├── tasks/
        │   └── main.yml     # Security hardening tasks
        ├── templates/       # Security configuration templates
        │   ├── sshd_config.j2
        │   ├── audit.rules.j2
        │   ├── jail.local.j2
        │   ├── limits.conf.j2
        │   ├── 20auto-upgrades.j2
        │   ├── rsyslog.conf.j2
        │   └── logrotate.conf.j2
        └── handlers/
            └── main.yml     # Service restart handlers
```

## Quick Start

### Prerequisites

```bash
# Install Ansible with security collections
pip install ansible
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
```

### Basic Usage

1. **Configure Inventory**:
   ```bash
   cp inventory/sample-inventory.yml inventory/production.yml
   # Edit inventory/production.yml with your hosts
   ```

2. **Run Security Hardening**:
   ```bash
   ansible-playbook -i inventory/production.yml site.yml
   ```

3. **Run Specific Security Tasks**:
   ```bash
   # SSH hardening only
   ansible-playbook -i inventory/production.yml site.yml --tags ssh
   
   # Firewall configuration only
   ansible-playbook -i inventory/production.yml site.yml --tags firewall
   
   # Install security tools only
   ansible-playbook -i inventory/production.yml site.yml --tags tools
   ```

## Security Configuration

### Enhanced Security Features

#### 🔐 SSH Security
- **Protocol 2 only** with secure ciphers and MACs
- **Root login disabled** with key-based authentication
- **Connection limits** and timeout settings
- **Verbose logging** for security monitoring

#### 🌐 Network Security
- **Default deny** firewall policy with explicit allows
- **Essential services**: DNS (53), HTTP/HTTPS (80/443), NTP (123)
- **SSH protection** with fail2ban integration
- **Network hardening** with sysctl settings

#### 📈 System Monitoring
- **File integrity**: AIDE database with daily checks
- **Antivirus**: ClamAV with automated scanning
- **Rootkit detection**: RKHunter daily verification
- **Audit logging**: Comprehensive system audit trail

#### 🛡️ Access Control
- **PAM configuration**: Strong password policies
- **System limits**: Resource constraints and security boundaries
- **AppArmor enforcement**: Mandatory access controls
- **Sudo hardening**: Secure privilege escalation

## Advanced Configuration

### Security Variables

Key security settings in `roles/base_security/defaults/main.yml`:

```yaml
# SSH Security
ssh_port: 22
ssh_permit_root_login: "no"
ssh_password_authentication: "no"
ssh_max_auth_tries: 3

# Password Policy
password_min_length: 14
password_min_digit: 1
password_min_uppercase: 1
password_min_lowercase: 1

# Firewall Rules
ufw_default_incoming_policy: "deny"
ufw_default_outgoing_policy: "deny"

# Security Tools
audit_enabled: true
fail2ban_enabled: true
apparmor_enabled: true
auto_updates_enabled: true
```

### Custom Security Rules

Add custom firewall rules:

```yaml
ufw_allowed_incoming_ports:
  - { port: "443", proto: "tcp", comment: "HTTPS web traffic" }
  - { port: "80", proto: "tcp", comment: "HTTP web traffic" }

ufw_allowed_outgoing_ports:
  - { port: "25", proto: "tcp", comment: "SMTP mail" }
  - { port: "993", proto: "tcp", comment: "IMAPS" }
```

### Compliance Frameworks

Configure for specific compliance requirements:

```yaml
# Set in inventory
security_compliance_mode: "cis"        # CIS Benchmarks
security_enhanced_logging: true        # Enhanced audit logging
security_monitoring_enabled: true      # Security monitoring tools
```

## Security Best Practices

### 1. Pre-Deployment Security
- **Key Management**: Use secure SSH key pairs
- **Inventory Security**: Encrypt sensitive inventory data
- **Access Control**: Implement proper user management
- **Network Isolation**: Use secure network segments

### 2. Deployment Security
- **Dry Run**: Always test with `--check` first
- **Incremental**: Deploy security changes incrementally
- **Monitoring**: Monitor systems during deployment
- **Backup**: Ensure proper backup before changes

### 3. Post-Deployment Security
- **Verification**: Verify security configurations
- **Monitoring**: Set up ongoing security monitoring
- **Updates**: Regular security updates and patches
- **Auditing**: Regular security audits and assessments

### 4. Maintenance Security
- **Log Reviews**: Regular log analysis
- **Vulnerability Scans**: Regular security scanning
- **Compliance Checks**: Ongoing compliance verification
- **Incident Response**: Security incident procedures

## Monitoring and Alerting

### Security Logs
- **Authentication**: `/var/log/auth.log`
- **Sudo Usage**: `/var/log/sudo.log`
- **Audit Trail**: `/var/log/audit/audit.log`
- **Fail2ban**: `/var/log/fail2ban.log`

### Daily Security Tasks
- **02:00**: AIDE integrity check
- **03:00**: ClamAV antivirus scan
- **04:00**: RKHunter rootkit scan
- **Daily**: Security updates (if enabled)

### Security Alerts
Monitor for:
- Failed login attempts
- Privilege escalation events
- File integrity violations
- Unusual network activity
- System configuration changes

## Troubleshooting

### Common Issues

1. **SSH Access Lost**:
   ```bash
   # Always test SSH config before applying
   ansible-playbook site.yml --check --diff
   ```

2. **Firewall Blocks Traffic**:
   ```bash
   # Check UFW status
   ansible all -m shell -a "ufw status verbose"
   ```

3. **Service Failures**:
   ```bash
   # Check service status
   ansible all -m service -a "name=fail2ban state=started"
   ```

### Recovery Procedures

1. **Emergency Access**: Ensure console access to systems
2. **Firewall Reset**: Know how to reset firewall rules
3. **Service Recovery**: Document service restart procedures
4. **Configuration Backup**: Maintain configuration backups

## Contributing

1. **Security Testing**: Test all security configurations
2. **Documentation**: Update documentation for changes
3. **Compliance**: Ensure compliance with security standards
4. **Code Review**: Security-focused code reviews

## License

MIT Licensed. See [LICENSE](../LICENSE) file.

## Security Contact

For security issues, please contact: security@example.com
