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
        proxmox_node: ${vm.target_node}
        proxmox_vmid: ${vm.vmid}
        vm_specs:
          cpu_cores: ${vm.cpu_cores}
          cpu_sockets: ${vm.cpu_sockets}
          memory: ${vm.memory}
          disk_size: ${vm.disk_size}
          disk_type: ${vm.disk_type}
          storage_pool: ${vm.storage_pool}
        networks:
        %{ for network in vm.networks ~}
          - bridge: ${network.bridge}
            ip: ${network.ip_address}
            netmask: ${network.netmask}
            gateway: ${network.gateway}
            vlan_id: ${network.vlan_id}
        %{ endfor ~}
        dns_servers: ${jsonencode(vm.dns_servers)}
    %{ endif ~}
    %{ endfor ~}
%{ endfor ~}

  proxmox_vms:
    children:
    %{ for role in distinct([for name, vm in virtual_machines : vm.role]) ~}
      ${role}:
    %{ endfor ~}
