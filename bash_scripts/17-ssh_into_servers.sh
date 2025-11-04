#!/bin/bash

SERVER_LIST='/babak/servers'
SSH_OPTIONS='-o ConnectTimeout=3 -o StrictHostKeyChecking=no'

# usage function
usage() {
    echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
    echo "Execute COMMAND on all servers." >&2
    echo "  -f  FILE : Use FILE for the list of servers. Default is ${SERVER_LIST}" >&2
    echo "  -n       : Dry run mode. Display the command that would have been executed and exit." >&2
    echo "  -s       : Execute the COMMAND using sudo on the remote server." >&2
    echo "  -v       : Verbose mode. Display the server name before executing COMMAND." >&2
    exit 1
}

# make sure we do not run this script as root user
if [[ "${UID}" -eq 0 ]]; then
    echo 'Do not execute this script as root; use -s option instead.' >&2
    usage
fi

# parse options
while getopts f:nsv OPTION; do
    case ${OPTION} in
        f) SERVER_LIST="${OPTARG}" ;;
        n) DRY_RUN='true' ;;
        s) SUDO='sudo' ;;
        v) VERBOSE='true' ;;
        ?) usage ;;
    esac
done

# remove parsed options
shift "$(( OPTIND - 1 ))"

# check that at least one command is supplied
if [[ "${#}" -lt 1 ]]; then
    usage
fi

COMMAND="${*}"

# make sure SERVER_LIST exists
if [[ ! -e "${SERVER_LIST}" ]]; then
    echo "The file '${SERVER_LIST}' can't be accessed." >&2
    exit 1
fi

EXIT_STATUS=0

# loop through servers
# for SERVER in $(cat "${SERVER_LIST}") can break if server names contain spaces or special chars
while read -r SERVER; do
    [[ -z "${SERVER}" ]] && continue  # skip empty lines

    if [[ "${VERBOSE}" = 'true' ]]; then
        echo "${SERVER}"
    fi

    SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

    if [[ "${DRY_RUN}" = 'true' ]]; then
        echo "DRY RUN: ${SSH_COMMAND}"
    else
        ${SSH_COMMAND}
        SSH_STATUS_EXITED=${?}
        if [[ "${SSH_STATUS_EXITED}" -ne 0 ]]; then
            echo "Execution on ${SERVER} failed." >&2
            EXIT_STATUS="${SSH_STATUS_EXITED}"
        fi
    fi
# we inject the server list here at the end to the 'while read' 
done < "${SERVER_LIST}"

exit "${EXIT_STATUS}"
