#!/bin/bash

set -eu

command -v git node curl 2>/dev/null

if [ $? -ne 0 ]; then 
echo "programes are not installed, please install git"
exit 1
else echo "programes is installed"
fi 







