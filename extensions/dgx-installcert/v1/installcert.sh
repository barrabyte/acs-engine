#!/bin/bash

#
# download and install a cert
#
# note:
#   this script will supports ubuntu. as is it will not work on rhel/centos

set -e

certName
certUri=$1

echo $(date) " - Starting Script"

echo $(date) " - Done"