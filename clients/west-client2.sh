#!/bin/bash
echo "8021q" >> /etc/modules

# Load the 802.1Q module (if not already loaded)
modprobe 8021q

# Create network namespaces
ip netns add GREEN1
ip netns add GREEN2

# Configure VLAN sub-interface for GREEN1
ip link add name eth1.103 link eth1 type vlan id 103
ip link set dev eth1.103 netns GREEN1
ip netns exec GREEN1 ip link set lo up
ip netns exec GREEN1 ip link set eth1.103 up
ip netns exec GREEN1 ip addr add 10.10.3.1/24 dev eth1.103
ip netns exec GREEN1 ip route add default via 10.10.3.254

# Configure VLAN sub-interface for GREEN2
ip link add name eth1.104 link eth1 type vlan id 104
ip link set dev eth1.104 netns GREEN2
ip netns exec GREEN2 ip link set lo up
ip netns exec GREEN2 ip link set eth1.104 up
ip netns exec GREEN2 ip addr add 10.10.4.1/24 dev eth1.104
ip netns exec GREEN2 ip route add default via 10.10.4.254
