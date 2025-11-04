#!/bin/bash

if [[ "${UID}" -ne 0 ]]
then 
 # this message will be shown on the screen as error (but user can't figure if its stdout or stderr)
 echo "Your user id is not a root user!" 1>&2
 exit 1
fi

if [[ "${#}" -lt 1 ]]
then
 echo "Usage: ${0} USERNAME [COMMENT]..." >&2
 echo "you need to add a USERNAME and a comment to create an account via this script" 1>&2
 exit 1
fi 

USERNAME="${1}"

# shift all variables to the right once
shift
# all variables left become the comment
COMMENT="${*}"

useradd -c "${COMMENT}" -m "${USERNAME}" &> /dev/null

if [[ "${?}" -ne 0 ]]
then
  echo 'The account creation command did not execute successfully.' 1>&2
  exit 1
fi

SPECIAL_CHAR=$(echo '!@#$%&*()_-=+' | fold -w1 | shuf | head -c 1)
PASSWORD=$(date +%s%N${SPECIAL_CHAR} | sha256sum | head -c 48)

echo "${PASSWORD}" | passwd --stdin "${USERNAME}" &> /dev/null

if [[ "${?}" -ne 0 ]]
then
  echo 'The password addition to user command did not execute successfully.' 1>&2
  exit 1
fi

passwd -e "${USERNAME}" &> /dev/null

echo "you username is ${USERNAME}, your password is ${PASSWORD} and the host machine is ${HOSTNAME}"

exit 0
