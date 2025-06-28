all:
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=yes -o UserKnownHostsFile=/etc/ssh/ssh_known_hosts'
    environment: ${environment}

%{ for role in distinct([for name, vm in virtual_machines : vm.role]) ~}
  ${role}:
    hosts:
    %{ for name, vm in virtual_machines ~}
    %{ if vm.role == role ~}
      ${name}:
        ansible_host: ${vm.networks[0].ip_address}
        vm_cpu: ${vm.cpu}
        vm_memory: ${vm.memory}
        vm_disk_size: ${vm.disk_size}
        vm_networks:
        %{ for network in vm.networks ~}
          - name: ${network.name}
            ip: ${network.ip_address}
            netmask: ${network.netmask}
            gateway: ${network.gateway}
        %{ endfor ~}
        dns_servers: ${jsonencode(vm.dns_servers)}
    %{ endif ~}
    %{ endfor ~}
%{ endfor ~}

  vmware_vms:
    children:
    %{ for role in distinct([for name, vm in virtual_machines : vm.role]) ~}
      ${role}:
    %{ endfor ~}
    vars:
      ansible_user: ${ssh_username}
      ansible_become: true
