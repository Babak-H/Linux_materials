#!/bin/bash

# usage is just the name of a function. Shell scripts often define a function called usage or help to show how the script should be used. If the user enters invalid options or needs help, 
# the script calls this function.
# this function only gets called if the user provides invalid options or explicitly requests help.
usage() {
    # Usage: ./myscript.sh [-vs] [-l LENGTH]
    # >&2 redirects the output to stderr (standard error) instead of stdout. This is standard practice when printing error/help messages so they don’t get mixed with the normal program output.

    echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
    echo 'Generate a random password.'
    echo '  -l LENGTH Specify the password length.'
    echo '  -s        Append a special character to the password.'
    echo '  -v        increase verbosity.'
    exit 1
}

# set default password length
LENGTH=48

log() {
 local MESSAGE="${*}"
 if [[ "${VERBOSE}" = 'true' ]]
 then
  echo "${MESSAGE}"
 fi
}

# this is how bash scripts can loop through all the positional parameters passed to them.
# getopts => Built-in bash utility for parsing short options like -v, -l 12, -s etc.
# vl:s => The option specification string telling getopts which flags are valid.
# The variable where the currently parsed option letter is stored (e.g. v, l, or s)

# v  -v is a valid flag that does not require an argument.
# l: -l is a valid flag that requires an argument (the : indicates this).
# s  -s is a valid flag that does not require an argument.

# getopts iterates through all options provided on the command line, one at a time. Wrapping it in a while loop allows you to process multiple arguments
while getopts vl:s OPTION
do
 # OPTION is just a variable name that will contain the current option letter being processed.
 case ${OPTION} in
  v) 
   VERBOSE='true'
   log 'Verbose mode on.'
   ;;
  l)
   # It stands for "option argument", and it is automatically filled ONLY when the option requires a value (i.e., in the option string, it has a colon : after it).
   # ./script.sh -l 20
   LENGTH="${OPTARG}"
   ;;
  s)
   USE_SPECIAL_CHARACTER='true'
   ;;
   ?)
    usage
    ;;
 esac
done

echo "Number of args: ${#}"
echo "All args: ${*}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# ${OPTIND} is a special built-in shell variable used together with getopts, OPTIND = "Option Index"
# It stores the index (position) of the next argument to be processed in the $@ list. It starts at 1 by default, Every time getopts successfully parses an option, it increments OPTIND
# After getopts is done, OPTIND tells you where the non-option arguments begin, After processing flags, you often still want to process positional parameters. OPTIND tells you where they start so you can shift them away and get the rest.
echo "OPTIND: ${OPTIND}"

# remove the options processed by getopts from the positional parameters ($1, $2, etc.)
shift "$(( OPTIND - 1 ))"

echo 'After shifting:'
echo "All args: ${*}"
echo "First arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

# if there are any positional parameters left after shifting, show usage and exit
if [[ "${#}" -gt 0 ]]
then
 usage
fi

# ./my-script.sh -v -l 8 -s extra1 extra2

log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
 log 'Adding a special character to the password.'
 SPECIAL_CHARACTER=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
 PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'your password is:'

echo "${PASSWORD}"

exit 0