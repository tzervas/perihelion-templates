all:
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=yes -o UserKnownHostsFile=/etc/ssh/ssh_known_hosts'
    environment: ${environment}
    ansible_user: ${ssh_username}
    ansible_become: true

%{ for role in distinct([for name, vm in virtual_machines : vm.role]) ~}
  ${role}:
    hosts:
    %{ for name, vm in virtual_machines ~}
    %{ if vm.role == role ~}
      ${name}:
        ansible_host: ${vm.networks[0].ip_address}
        vm_specs:
          cpu_cores: ${vm.cpu_cores}
          memory: ${vm.memory}
          disk_size: ${vm.disk_size}
        networks:
        %{ for network in vm.networks ~}
          - network_name: ${network.network_name}
            ip: ${network.ip_address}
            netmask: ${network.netmask}
            gateway: ${network.gateway}
            dns_servers: ${jsonencode(network.dns_servers)}
        %{ endfor ~}
    %{ endif ~}
    %{ endfor ~}
%{ endfor ~}

  kvm_vms:
    children:
    %{ for role in distinct([for name, vm in virtual_machines : vm.role]) ~}
      ${role}:
    %{ endfor ~}
