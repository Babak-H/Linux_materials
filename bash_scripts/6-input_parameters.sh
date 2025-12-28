#!/bin/bash

# $0 => positional parameter, first parameter which contains the name of this script itself
# $1 => first argument passed to the script
# $2 => second argument passed to the script
# $# => the number of arguments passed to the script
# $? => return code of previously run command (0=success)
# $$ => process id for the shell/script
# $! => process id of the most recent executed background command
echo "You executed this command: ${0}"

# more detailed
echo "you used $(dirname ${0}) as the path to $(basename ${0}) script"

# how many arguments the user has passed to the script
NUM_OF_PARAMS=$#
echo "you supplied ${NUM_OF_PARAMS} argument(s) on the command line."

# make sure at least one argument is supplied
if [[ "${NUM_OF_PARAMS}" -lt 1 ]]
then
 echo "Usage: ${0} USERNAME [USERNAME]...[USERNAME]..."
 exit 1
fi 

# display all given arguments via for loop
# $@ is a special parameter that represents all the positional parameters passed to the script or function, as separate quoted strings
# $* => contains all arguments, but all in One parameters
for USERNAME in "${@}"
do
 PASSWORD=$(date +%s%N | sha256sum | head -c 32)
 echo "${USERNAME}: ${PASSWORD}"
done

exit 0
 