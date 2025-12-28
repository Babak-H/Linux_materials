#!/bin/sh

# *** Advanced Logging ***

# e: Exit immediately when a non-zero exit status is encountered
# u: Undefined variables throws an error and exits the script
# x: Print every evaluation.
# o pipefail: Here we make sure that any error in a pipe of commands will fail the entire pipe instead just carrying on to the next command in the pipe.
set -euxo pipefail

function log::info() {
    # This calls another function named log::_write_log
    # "INFO" is passed as the first argument, indicating that this is an informational log message
    # "$@" represents all arguments passed to log::info and forwards them to log::_write_log
    log::_write_log "INFO" "${@}"
}

function log::level_is_active() {
    # Declares two local variables (check_level and current_level) that are used only within this function.
    local check_level current_level
    # Assigns the first argument passed to the function to the check_level variable.
    check_level=$1
    # Declares an associative array (log_levels), mapping log levels to numeric values.
    declare -A log_levels=(
        [DEBUG]=1
        [INFO]=2
        [WARN]=3
        [ERROR]=4        
    )
    # turns the input $check_level to numerical based on the defined array
    check_level="${log_levels["${check_level}"]}"
    current_level="${log_levels["${LOG_LEVEL}"]}"
    # arithmetic comparison in Bash
    # It checks if the requested check_level is greater than or equal to current_level
    # If true, it means the requested log level is active, and the function returns success (0 in Bash),If false, it returns failure (1 in Bash) 
    (( check_level >= current_level ))
}

function log::_write_log() {
    local timestamp file function_name log_level
    log_level=$1
    # The shift command removes the first argument ($1) from the list of arguments, After this, $2 becomes $1, $3 becomes $2, and so on
    shift
    # here using a function inside an if statement
    if log::level_is_active "${log_level}"; then
        timestamp=$(date +'%y.%m.%d %H:%M:%S')  # 24.03.05 12:30:15
        # BASH_SOURCE is an array that stores the script file paths in the call stack
        # BASH_SOURCE[2] refers to the script two levels up in the call stack, ##*/ extracts only the file name (removing the full path)
        # # If BASH_SOURCE[2] is /home/user/script.sh, then file="script.sh"
        file="${BASH_SOURCE[2]##*/}"
        # If FUNCNAME[2] is my_function, then function_name="my_function"
        function_name="${FUNCNAME[2]}"
        # redirect the print-format output to standard error
        >&2 printf '&s [%s] [%s - %s]: %s\n' \
        # $* returns the logging text since we removed first variable via shift
            "${log_level}" "${timestamp}" "${file}" "${function_name}" "${*}"
    fi
}

# test
function my_func() {
    log::_write_log "INFO" "Something happened"
}

my_func  # INFO [24.03.05 12:30:15] [script.sh - my_function]: Something happened