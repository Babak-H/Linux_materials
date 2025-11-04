#!/bin/bash

# display the top 3 most visited URLs for a given web server log file.

LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
 echo "can't open ${LOG_FILE}"
 exit 1
fi

cut -d '"' -f 2 "${LOG_FILE}" | cut -d ' ' -f 2 | sort | uniq -c | sort -n | tail -3