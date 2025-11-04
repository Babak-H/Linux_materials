#!/bin/bash

# function
log() {
    echo 'You called the log function!'
}

# execute the function
log

# another way
function logalt {
    echo 'You called the logalt function!'
}

logalt

logparam() {
    # local means this variable is only accessible from inside the function
    local MESSAGE="${*}"
    echo "${MESSAGE}"
}

logparam 'Hello!'
logparam 'Hello' 'There'

logconditional() {
    local VERBOSE="${1}"
    shift
    local MESSAGE="${*}"
    if [[ "${VERBOSE}" = 'true' ]]
    then 
     echo "${MESSAGE}"
    fi

    # sends a message to the system log (syslog).
    # logger : A command-line tool that writes messages to the system logs (usually /var/log/syslog, /var/log/messages)
    # -t my-script.sh : Sets the tag that will appear in the logs, so you can identify which script/app wrote the message. Here it's my-script.sh
    # "${MESSAGE}" : The actual content/text of the log entry, stored in the shell variable MESSAGE
    logger -t lsuer-demo10.sh "${MESSAGE}"
}

# VERBOSE='true'
logparam 'Hello this is conditional'
# In shell (bash), a readonly variable is a variable that, once set, cannot be changed or unset for the rest of the script/session.
readonly TESTVAR='false'

# After this, any attempt to modify it gives an error:
# bash: VAR: readonly variable

backup_file() {
    local FILE="${1}"

    # make sure the file exists
    if [[ -f "${FILE}" ]]
    then
     local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
     log "backing up ${FILE} to ${BACKUP_FILE}."

     cp -p "${FILE}" "${BACKUP_FILE}"
    else
     echo "File does not exist!" >&2
     # Use return inside a function to indicate its success or failure, It only affects the function itself, not the whole script
     # exit terminates the entire script immediately, regardless of whether you’re in a function or not.
     return 1
    fi
}

backup_file '/etc/passwd'

# make a decision based on exit status of the function
if [[ "${?}" -eq '0' ]]
then
 log 'backup succeeded'
else
 log 'file backup failed'
 exit 1
fi
