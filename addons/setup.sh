#!/bin/bash

[ -z "${gateway}" ] && exit 0

cat <<-EOF > /etc/systemd/network/default.network
[Match]
Name=$(ip a | grep $(hostname -I | awk '{print $1}') | awk '{print $NF}')

[Network]
DHCP=ipv4

[DHCP]
UseDNS=false
UseRoutes=false

[Route]
Destination=0.0.0.0/0
Gateway=${gateway}
EOF

sed -i 's/#DNS=/DNS=185.12.64.2 185.12.64.1/g' /etc/systemd/resolved.conf

systemctl disable systemd-networkd-wait-online.service
service systemd-networkd restart
service systemd-resolved restart
