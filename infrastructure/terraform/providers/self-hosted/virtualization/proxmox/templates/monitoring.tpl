%{ if monitoring_config.prometheus.enabled ~}
prometheus:
  scrape_interval: ${monitoring_config.prometheus.scrape_interval}
  retention_days: ${monitoring_config.prometheus.retention_days}

  scrape_configs:
    - job_name: 'node_exporter'
      static_configs:
        - targets:
          %{ for name, vm in virtual_machines ~}
            - "${vm.name}:${monitoring_config.node_exporter.port}"
          %{ endfor ~}
      relabel_configs:
        - source_labels: [__address__]
          target_label: instance
          regex: '([^:]+):.+'
          replacement: '$1'

  alerting_rules:
    groups:
      - name: node_alerts
        rules:
          - alert: HighCPUUsage
            expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High CPU usage on {{ $labels.instance }}"
              description: "CPU usage is above 80% for more than 5 minutes"

          - alert: HighMemoryUsage
            expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High memory usage on {{ $labels.instance }}"
              description: "Memory usage is above 85% for more than 5 minutes"

          - alert: HighDiskUsage
            expr: 100 - ((node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"}) > 85
            for: 5m
            labels:
              severity: warning
            annotations:
              summary: "High disk usage on {{ $labels.instance }}"
              description: "Disk usage is above 85% for more than 5 minutes"

          - alert: InstanceDown
            expr: up == 0
            for: 5m
            labels:
              severity: critical
            annotations:
              summary: "Instance {{ $labels.instance }} is down"
              description: "Instance has been down for more than 5 minutes"
%{ endif ~}

%{ if monitoring_config.alertmanager.enabled ~}
alertmanager:
  smtp_smarthost: "${monitoring_config.alertmanager.smtp_host}:${monitoring_config.alertmanager.smtp_port}"
  smtp_from: "alertmanager@example.com"
  smtp_require_tls: true

  route:
    group_by: ['alertname', 'severity']
    group_wait: 30s
    group_interval: 5m
    repeat_interval: 4h
    receiver: 'team-email'

  receivers:
    - name: 'team-email'
      email_configs:
      %{ for recipient in monitoring_config.alertmanager.alert_recipients ~}
        - to: ${recipient}
          send_resolved: true
      %{ endfor ~}

  inhibit_rules:
    - source_match:
        severity: 'critical'
      target_match:
        severity: 'warning'
      equal: ['instance']
%{ endif ~}

%{ if monitoring_config.node_exporter.enabled ~}
node_exporter:
  port: ${monitoring_config.node_exporter.port}
  collectors_enabled:
    - cpu
    - diskstats
    - filesystem
    - loadavg
    - meminfo
    - netdev
    - netstat
    - stat
    - time
    - vmstat
    - systemd
%{ endif ~}
