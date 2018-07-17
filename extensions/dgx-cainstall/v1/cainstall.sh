#!/bin/bash

#
#
# Download and install a Certificate of Authority
#
# Note:
#   This script will supports ubuntu. It has not been tested on other flavours
#   of linux
#

set -e

sourceUri=$1
targetPath=$2

echo $(date) " - Starting Script"

 curl -k $sourceUri -o $targetPath
 update-ca-certificates

echo $(date) " - Done"
