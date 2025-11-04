#!/bin/bash

# this script shows the open network ports on a system
# NF is a built-in awk variable that means “Number of Fields” in the current line.
# $NF means “the last field” — regardless of how many fields there are
netstat -nutl "${1}" | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'

