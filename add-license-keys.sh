#!/bin/bash
SWITCHES=("spine01" "spine02" "leaf01" "leaf02" "leaf03")

for switch in ${SWITCHES[@]}; do
  echo -n "Checking for installed cRPD license on $switch..."
  license=$(docker exec -it clab-crpd-evpn-vxlan-$switch cli show system license | grep SKU | xargs)
  if [ -z "$license" ]; then
    if [ ! -e junos.lic ]; then
      echo "please download your free eval license key from https://www.juniper.net/us/en/dm/crpd-free-trial.html"
      echo "(login required) and rename it to 'junos.lic' add place it in the root of this repository"
    fi
    echo -n "[FAILED] >>> Adding license key 'junos.lic' to clab-crpd-evpn-vxlan-$switch..."
    docker cp junos.lic clab-crpd-evpn-vxlan-$switch:/config/license/safenet/junos.lic >/dev/null 2>&1
    docker exec -it clab-crpd-evpn-vxlan-$switch cli request system license add /config/license/safenet/junos.lic >/dev/null 2>&1
    echo "[OK]"
  else
    echo "[OK]"
  fi
done
