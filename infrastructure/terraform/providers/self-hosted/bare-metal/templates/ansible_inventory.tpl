all:
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=yes -o UserKnownHostsFile=/etc/ssh/ssh_known_hosts'
    ansible_port: ${ssh_port}

%{ for role in distinct([for server in servers : server.role]) ~}
  ${role}:
    hosts:
    %{ for name, server in servers ~}
    %{ if server.role == role ~}
      ${name}:
        ansible_host: ${server.ip_address}
        ansible_user: ${os_configs[server.os_type].ssh_user}
        os_type: ${server.os_type}
        ansible_become: true
    %{ endif ~}
    %{ endfor ~}
%{ endfor ~}

  children:
    debian_servers:
      hosts:
      %{ for name, server in servers ~}
      %{ if server.os_type == "debian" ~}
        ${name}:
      %{ endif ~}
      %{ endfor ~}

    ubuntu_servers:
      hosts:
      %{ for name, server in servers ~}
      %{ if server.os_type == "ubuntu" ~}
        ${name}:
      %{ endif ~}
      %{ endfor ~}

    rhel_servers:
      hosts:
      %{ for name, server in servers ~}
      %{ if server.os_type == "rhel" ~}
        ${name}:
      %{ endif ~}
      %{ endfor ~}

    rocky_servers:
      hosts:
      %{ for name, server in servers ~}
      %{ if server.os_type == "rocky" ~}
        ${name}:
      %{ endif ~}
      %{ endfor ~}
