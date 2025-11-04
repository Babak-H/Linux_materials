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
