%{ if backup_config.enabled ~}
backup:
  type: ${backup_config.type}
  schedule: ${backup_config.schedule}
  retention:
    keep-daily: ${backup_config.retention.daily}
    keep-weekly: ${backup_config.retention.weekly}
    keep-monthly: ${backup_config.retention.monthly}
    keep-yearly: ${backup_config.retention.yearly}

  storage:
    type: ${backup_config.storage.type}
    path: ${backup_config.storage.path}
    %{ if backup_config.storage.type != "local" ~}
    credentials:
      %{ for key, value in backup_config.storage.credentials ~}
      ${key}: ${value}
      %{ endfor ~}
    %{ endif ~}

  servers:
  %{ for name, server in servers ~}
    ${name}:
      paths:
        - /etc
        - /var/log
        - /home
        - /root
      exclude:
        - "*.tmp"
        - "*.temp"
        - "*.log"
        - "/var/log/journal"
        - "/var/cache"
        - "/var/tmp"
      pre_backup_script: |
        #!/bin/bash
        # Add any pre-backup tasks here
        set -e
        # Example: MySQL dump
        if command -v mysqldump &> /dev/null; then
          mysqldump --all-databases > /var/backups/mysql_dump.sql
        fi

      post_backup_script: |
        #!/bin/bash
        # Add any post-backup tasks here
        set -e
        # Example: Clean up temporary files
        find /var/backups -name "*.tmp" -type f -mtime +7 -delete

  notifications:
    on_success:
      - type: email
        recipients: ${jsonencode(monitoring_config.alertmanager.alert_recipients)}
    on_failure:
      - type: email
        recipients: ${jsonencode(monitoring_config.alertmanager.alert_recipients)}

  healthcheck:
    enabled: true
    interval: "1h"
    timeout: "10m"
    unhealthy_threshold: 3
    alerts:
      - type: email
        recipients: ${jsonencode(monitoring_config.alertmanager.alert_recipients)}
%{ endif ~}
