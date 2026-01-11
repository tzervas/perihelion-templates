servers:
%{ for name, server in servers ~}
  ${name}:
    ip_address: ${server.ip_address}
    os_type: ${server.os_type}
    role: ${server.role}
    specifications:
      cpu_cores: ${server.specifications.cpu_cores}
      memory_gb: ${server.specifications.memory_gb}
      storage_gb: ${server.specifications.storage_gb}
    network:
      subnet: ${server.network.subnet}
      gateway: ${server.network.gateway}
      dns_servers:
      %{ for dns in server.network.dns_servers ~}
        - ${dns}
      %{ endfor ~}
%{ endfor ~}
