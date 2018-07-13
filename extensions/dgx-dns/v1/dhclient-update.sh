#!/bin/bash

#
# for hybrid dns replace reddog.microsoft.com with the real domain name
#
# note:
#   this script will supports ubuntu. as is it will not work on rhel/centos

set -e

DOMAINNAME=$1

echo $(date) " - Starting Script"

if ! grep -Fq "${DOMAINNAME}" /etc/dhcp/dhclient.conf
then
    echo $(date) " - Adding domain to dhclient.conf"

    echo "supersede domain-name \"${DOMAINNAME}\";" >> /etc/dhcp/dhclient.conf
    echo "prepend domain-search \"${DOMAINNAME}\";" >> /etc/dhcp/dhclient.conf
fi

# service networking restart
echo $(date) " - Restarting network"
sudo ifdown eth0 && sudo ifup eth0