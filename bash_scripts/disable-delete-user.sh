#!/bin/bash

if [[ "${UID}" -ne 0 ]]
then
 echo 'Please run with sudo or as root user.' >&2
 exit 1
fi

usage() {
    echo "Usage: ${0} [-dra] USER [USER]..." >&2
    echo 'disable a local user account.' >&2
    echo '  -d  deletes the account instead of disabling it.' >&2
    echo '  -r  removes the home directory associated with the account.' >&2
    echo '  -a  creates an archive of the home directory associated with the account.' >&2
    exit 1
}

REMOVE_HOME='-r'

ARCHIVE_HOME='false'
DELETE_ACCOUNT='false'

ARCHIVE='/archive'
if [[ ! -d "${ARCHIVE}" ]]
then
 mkdir -p "${ARCHIVE}"
fi

if [[ "${?}" -ne 0 ]]
then
 echo "could not create the directory ${ARCHIVE}." >&2
 exit 1
fi


while getopts dra OPTION
do
 case ${OPTION} in
  d) DELETE_ACCOUNT='true' ;;
  r) REMOVE_HOME='-r' ;;
  a) ARCHIVE_HOME='true' ;;
  ?) usage ;;
 esac
done

shift "$(( OPTIND -1 ))"

if [[ "${#}" -lt 1 ]]
then
 usage
fi

for USERNAME in "${@}"
do
    # we have to check if the user exists, because in the next if statement below, if user does`t exist, the -lt 1000 check would return an error.
    if ! id "${USERNAME}" &>/dev/null
    then
     echo "the account ${USERNAME} does not exist." >&2
     exit 1
    fi

    if [[ $(id -u "${USERNAME}") -lt 1000 ]]
    then
        echo "Refusing to disable system account: ${USERNAME} with UID $(id -u "${USERNAME}")." >&2
        exit 1
    fi

    if [[ "${ARCHIVE_HOME}" = 'true' ]]
    then
     HOME_DIR="/home/${USERNAME}"
     ARCHIVE_PATH="${ARCHIVE}/${USERNAME}.tar.gz"
     if [[ -d "${HOME_DIR}" ]]
     then
      tar -czf "${ARCHIVE_PATH}" "${HOME_DIR}" &>/dev/null

      if [[ "${?}" -ne 0 ]]
      then
       echo "could not create  ${ARCHIVE_PATH}." >&2
       exit 1
      fi

     fi
    fi

    if [[ "${DELETE_ACCOUNT}" = 'true' ]]
    then
     userdel ${REMOVE_HOME} "${USERNAME}" &>/dev/null
    else
     chage -E 0 "${USERNAME}"
    fi

    if [[ "${?}" -ne 0 ]]
    then
     echo "there was some issue while disabling/deleting the account ${USERNAME}." >&2
     exit 1
    fi

    echo "the user account ${USERNAME} was disabled/deleted successfully."
done

exit 0