#!/bin/bash

SERVER_FILE="servers.txt"

if [[ ! -e "${SERVER_FILE}" ]]
then
 echo "Server file ${SERVER_FILE} does not exist. Exiting." >&2
 exit 1
 fi

for SERVER in $(cat "${SERVER_FILE}")
do 
 ping -c 1 "${SERVER}" &> /dev/null
 if [[ "${?}" -ne 0 ]]
 then
  echo "can't access ${SERVER}" >&2
  exit 1
 fi

 ssh "${SERVER}" hostname
 ssh "${SERVER}" uptime
 ssh "${SERVER}" ps -ef | head -5
done