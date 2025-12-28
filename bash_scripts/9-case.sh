#!/bin/bash

if [[ "${1}" = 'start' ]]
then 
 echo "Starting"
elif [[ "${1}" = 'stop' ]]
then
  echo "Stopping"
elif [[ "${1}" = 'status' ]]
then
 echo 'Status'
else
 echo 'supply a valid option.' >&2
 exit 1
fi


# same via case statement
case "${1}" in
 start) echo 'Starting' ;;
 stop) echo 'Stopping' ;;
 status|state|--status|--state) echo 'Status' ;;
 *)
 echo 'supply a valid option' >&2
  ;;
esac


cat<<eof

        ATM
    ---------------
    1. Deposit
    2. Withdraw
    ---------------
eof

echo "Enter an option:"
read -r optvar
case $optvar in
  1) echo "Deposit is selected." ;;
  2) echo "Withdeaw is selected." ;;
  *) echo "Invalid option." 
     exit 1 
     ;;
esac