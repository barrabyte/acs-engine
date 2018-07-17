#!/bin/bash

# ACS-Engine DGX Pre Provision Script
#
# Note:
#   This script us desginged for Ubuntu. It may not work on other flavours, notably Redhat/CentOS
#
# HYBRID DNS
# For hybrid DNS envrinments replace reddog.microsoft.com with the real domain name
#
# MEDPLUS Artifactory
# If containers will be sourced from the Medplus Artifactory Repo, the Medplus
# CA (Certificate of Authority) needs to be installed
#

set -e

domainName=$1

caSourceUri=$2
caTargetPath=$3

echo $(date -Iseconds) " Starting dgxPreProvision"

  #
  # HYBRID DNS
  #
  echo $(date -Iseconds) " ..Starting Hybrid DNS"
  if ! grep -Fq "${domainName}" /etc/dhcp/dhclient.conf
  then
    echo $(date -Iseconds) " ....Adding domain to dhclient.conf"
    echo "supersede domain-name \"${domainName}\";" >> /etc/dhcp/dhclient.conf
    echo "prepend domain-search \"${domainName}\";" >> /etc/dhcp/dhclient.conf
  fi

  echo $(date -Iseconds) " ....Restarting network"
  sudo ifdown eth0 && sudo ifup eth0

  echo $(date -Iseconds) " ..Done Hybrid DNS"

  #
  # MEDPLUS CA CERTS
  #
  echo $(date -Iseconds) " ..Starting MedPlus CA Install"
    echo $(date -Iseconds) " ....Download CA"
    curl -k $caCourceUri -o $caTargetPath
    echo $(date -Iseconds) " ....Update CA Certificates"
    update-ca-certificates
  echo $(date -Iseconds) " ..Done MedPlus CA Install"

echo $(date -Iseconds) " Done dgxPreProvision"

