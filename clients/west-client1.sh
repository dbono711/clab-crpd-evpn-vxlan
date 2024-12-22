#!/bin/bash
echo "8021q" >> /etc/modules

cat > /etc/network/interfaces << EOF
auto eth1.101
iface eth1.101 inet static
  pre-up ip link add name eth1.101 link eth1 type vlan id 101
  up ip link set dev eth1.101 up
  address 10.10.1.1
  netmask 255.255.255.0

EOF

ifup eth1.101
