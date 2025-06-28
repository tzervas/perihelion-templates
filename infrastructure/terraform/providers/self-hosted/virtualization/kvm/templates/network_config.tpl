version: 2
ethernets:
%{ for index, network in networks ~}
  eth${index}:
    addresses:
      - ${network.ip_address}/${network.netmask}
    gateway4: ${network.gateway}
    nameservers:
      addresses: ${jsonencode(network.dns_servers)}
%{ endfor ~}
