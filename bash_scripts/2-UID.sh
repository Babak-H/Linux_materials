#!/bin/bash

# chmod 755 this_file.sh

# UID
echo "Your UID is ${UID}"

# username
USER_NAME=$(id -un)
echo "username is ${USER_NAME}"

# is user root or not
if [[ "${UID}" -eq  0 ]]
then 
    echo 'You are root'
else
    echo 'You are not root'
fi
