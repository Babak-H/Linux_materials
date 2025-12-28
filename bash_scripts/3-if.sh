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


# exit status of a command can be used by an if statement
# exit 0   executes
# exit 1,2,..  doesnt execute
# if command
# then
#   execute this code
# fi

if rm "${1}" 2> /dev/null
then
  echo "File deleted"
else
  echo "file not deleted"
fi


if who | grep -q babak.habibnejad
then
  echo "Babak has logged in"
else
  echo "babak has not logged in yet"
fi


# [ -e filename ]    exists
# [ -d filename ]    is a directory
# [ -f filename ]    is a regular file
# [ -h filename ]    is a symbolic link
# [ -r filename ]    exists and is readable

# if statement with file
if [ -e "$1" ]
then
  echo "file exists"
else
  echo "file does not exist" >&2
  exit 1


if [ "$1" = "$2 " ]
then
  echo "both arguments are equal"
else
  echo "Arguments are different"
fi

# [ $1 = $2 ]    equality
# [ $1 != $2 ]   not equal
# [ -z $string ] is empty
# [ -n $string ]   length of $string is non-zero (has content)


# = is equality operator for strings
# -eq is equality operator for strings

# numeric tests
# [ $n1 -eq $n2 ]   equal
# [ $n1 -ne $n2 ]   not equal
# [ $n1 -lt $n2 ]   less than
# [ $n1 -le $n2 ]   less or equal
# [ $n1 -gt $n2 ]   greater than
# [ $n1 -ge $n2 ]   greater or equal


if [ "$#" -eq 0 ] ; then
  echo "no argument has been passed to script"
elif [ "$#" -eq 1 ] ; then
  echo "one argument has been passed"
else
  echo "more than one argument has been passed"
fi

# boolean / conditional operators

# ! test             negete (opposite)
# test1 || test2     OR
# test1 && test2     AND
# test1 -o test2     OR
# test1 -a test2     AND

if [ "$#" -eq 0 ] ; then
  echo "no argument"
elif [ "$#" -eq 2 ] || [ "$#" -eq 4 ] || [ "$#" -eq 6 ] ; then
  echo "even arguments"
else
  echo "odd arguments"
fi

# if statement with wildcards and regular expressions
if [[ $1 = *at ]]
then
  echo "argument ends with 'at'"
fi

if [[ $1 =~ [0-9] ]] ; then
  echo "argument has a digit"
fi

if echo "$1" | grep -q '[0-9]' ; then
  echo "argument has a digit'
fi