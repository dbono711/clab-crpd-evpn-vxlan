#!/bin/bash
echo "8021q" >> /etc/modules

# Load the 802.1Q module (if not already loaded)
modprobe 8021q

# Create network namespaces
ip netns add BLUE
ip netns add RED

# Configure VLAN sub-interface for BLUE
ip link add name eth1.101 link eth1 type vlan id 101
ip link set dev eth1.101 netns BLUE
ip netns exec BLUE ip link set lo up
ip netns exec BLUE ip link set eth1.101 up
ip netns exec BLUE ip addr add 10.10.1.1/24 dev eth1.101
ip netns exec BLUE ip route add default via 10.10.1.254

# Configure VLAN sub-interface for RED
ip link add name eth1.102 link eth1 type vlan id 102
ip link set dev eth1.102 netns RED
ip netns exec RED ip link set lo up
ip netns exec RED ip link set eth1.102 up
ip netns exec RED ip addr add 10.10.2.1/24 dev eth1.102
ip netns exec RED ip route add default via 10.10.2.254
