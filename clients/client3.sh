#!/bin/bash
echo "8021q" >> /etc/modules

cat > /etc/network/interfaces << EOF
auto eth1.20
iface eth1.20 inet static
  pre-up ip link add name eth1.20 link eth1 type vlan id 20
  up ip link set dev eth1.20 up
  up ip route add 10.10.1.0/24 via 10.10.2.254 dev eth1.20
  address 10.10.2.1
  netmask 255.255.255.0

EOF

ifup eth1.20