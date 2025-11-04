#!/bin/bash

echo "Parameter 1: ${1}"
echo "Parameter 2: ${2}"
echo "Parameter 3: ${3}"

while [[ "${#}" -gt 0 ]]
do
    echo "number of parameters: ${#}"
    echo "${1}"
    
    # shift in a shell script discards the first positional parameter ($1) and shifts all the others one place to the left.
    shift
done


# while read => is one of the most common patterns for reading input line-by-line in a shell script.
# read => reads one line from standard input (by default).
# It stores that line into the variable you provided (e.g., VARIABLE).
# If the read is successful, the command returns exit code 0, so while continues to loop.
# Once read reaches end-of-file (EOF) or input fails, it returns a non-zero exit code, and the loop stops.
while read VARIABLE
do
    # use $VARIABLE here
    ...
done

while read VARIABLE
do
    ...
done < file.txt


while read line
do
    echo "You typed: $line"
done


while read line
do
    echo "$line"
done < myfile.txt

# multiple variables
while read first second
do
    echo "first: $first, second: $second"
done < data.txt