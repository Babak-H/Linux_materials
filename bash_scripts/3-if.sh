#!/bin/bash

echo "Your UID is ${UID}"

# Only display if the UID does NOT match 1000.
UID_TO_TEST_FOR='1000'

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
  echo "Your UID does not match ${UID_TO_TEST_FOR}."
  exit 1
fi

# Display the username.
USER_NAME=$(id -un)

# Test if the command succeeded.
# ${?} or $? shows the exit status of the latest executed command. 0 => executed correctly  1 => there was some error
if [[ "${?}" -ne 0 ]]
then
  echo 'The id command did not execute successfully.'
  exit 1
fi

echo "Your username is ${USER_NAME}"

# You can use a string test conditional.
USER_NAME_TO_TEST_FOR='vagrant'
# =  same as -eq
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
  echo "Your username matches ${USER_NAME_TO_TEST_FOR}."
fi
# !=  same as -ne
if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
 echo "Your username does not match ${USER_NAME_TO_TEST_FOR}."
 exit 1
fi

exit 0

