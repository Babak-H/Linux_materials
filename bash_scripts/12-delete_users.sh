#!/bin/bash

# this script deletes users

# run it as root user
if [[ "${UID}" -ne 0 ]]
then
 echo 'Please run with sudo or as root user.' >&2
 exit 1
fi

# assume that the first parameter is the username
USERNAME="${1}"

userdel -r "${USERNAME}"

if [[ "${?}" -ne 0 ]]
then
 echo "the account ${USERNAME} could not be deleted." >&2
 exit 1
fi

echo "the account ${USERNAME} has been deleted."
exit 0


# chmod 755 luser-demo12.sh
# sudo ./luser-demo12.sh baduser