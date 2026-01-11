#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.local
manage_etc_hosts: true

users:
  - name: ${ssh_user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_key}

timezone: ${timezone}

package_update: true
package_upgrade: true

packages:
  - qemu-guest-agent
  - net-tools
  - curl
  - wget
  - vim
  - htop
  - tmux

write_files:
  - path: /etc/systemd/timesyncd.conf
    content: |
      [Time]
      NTP=ntp.ubuntu.com
      FallbackNTP=0.pool.ntp.org 1.pool.ntp.org

runcmd:
  - systemctl enable --now qemu-guest-agent
  - systemctl enable --now systemd-timesyncd
  - systemctl restart systemd-timesyncd

ssh_pwauth: false
disable_root: true

bootcmd:
  - ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

final_message: "Cloud-init has finished system configuration after $UPTIME seconds"
