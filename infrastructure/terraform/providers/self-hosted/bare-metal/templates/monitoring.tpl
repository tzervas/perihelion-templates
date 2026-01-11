global:
  scrape_interval: ${monitoring_config.prometheus.scrape_interval}
  evaluation_interval: ${monitoring_config.prometheus.scrape_interval}

%{ if monitoring_config.prometheus.enabled ~}
prometheus:
  retention_days: ${monitoring_config.prometheus.retention_days}
  targets:
  %{ for name, server in servers ~}
    - ${server.ip_address}:${monitoring_config.node_exporter.port}
  %{ endfor ~}
%{ endif ~}

%{ if monitoring_config.alertmanager.enabled ~}
alertmanager:
  smtp_host: ${monitoring_config.alertmanager.smtp_host}
  smtp_port: ${monitoring_config.alertmanager.smtp_port}
  recipients:
  %{ for recipient in monitoring_config.alertmanager.alert_recipients ~}
    - ${recipient}
  %{ endfor ~}

  routes:
    - match:
        severity: critical
      receiver: ops-team
      continue: true
    - match:
        severity: warning
      receiver: dev-team
      continue: true

  receivers:
    - name: ops-team
      email_configs:
      %{ for recipient in monitoring_config.alertmanager.alert_recipients ~}
        - to: ${recipient}
          send_resolved: true
      %{ endfor ~}
%{ endif ~}

%{ if monitoring_config.node_exporter.enabled ~}
node_exporter:
  port: ${monitoring_config.node_exporter.port}
  collectors:
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

rules:
  - alert: HostHighCPULoad
    expr: 100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[2m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Host high CPU load (instance {{ $labels.instance }})"
      description: "CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

  - alert: HostOutOfMemory
    expr: node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Host out of memory (instance {{ $labels.instance }})"
      description: "Node memory is filling up (< 10% left)\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

  - alert: HostOutOfDiskSpace
    expr: (node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"} < 10
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Host out of disk space (instance {{ $labels.instance }})"
      description: "Disk is almost full (< 10% left)\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"

  - alert: HostHighLoad
    expr: node_load1 > (count by (instance) (node_cpu_seconds_total{mode="idle"}) * 2)
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "Host high load (instance {{ $labels.instance }})"
      description: "Host load is too high\n  VALUE = {{ $value }}\n  LABELS: {{ $labels }}"
