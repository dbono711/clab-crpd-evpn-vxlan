#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess


def ping(ip_address: str, container) -> str:
    """
    Pings an ip address in a container.

    Args:
        ip_address (str): Target ip address

    Returns:
        str: Status.
    """
    print(f"Pinging ({ip_address}) from client1...", end="")
    reply = subprocess.run(
        [
            "docker",
            "exec",
            "-it",
            f"{container}",
            "bash",
            "-c",
            f"ping -c 1 -n {ip_address}",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf-8",
    )

    if reply.returncode == 0:
        print("SUCCESS")
    else:
        print("FAILURE...Initiating network validation")


if __name__ == "__main__":
    print("Testing intra-VNI connectivity")
    ping("10.10.1.2", "clab-crpd-evpn-vxlan-client1")
    print("Testing inter-VNI connectivity")
    ping("10.10.2.1", "clab-crpd-evpn-vxlan-client1")
