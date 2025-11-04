#!/bin/bash

LIMIT='10'
LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
 echo "can't find the ${LOG_FILE} file" >&2
 exit 1
fi

# display CSV Header
echo 'Count,IP,Location'
# 6749 182.100.67.59
# 3379 183.3.202.111
grep Failed /tmp/syslog-sample | awk -F 'from ' '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr | while read COUNT IP
do
 if [[ "${COUNT}" -gt "${LIMIT}" ]]
 then
  LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}' )
  echo "${COUNT},${IP},${LOCATION}"
 fi
done

exit 0
