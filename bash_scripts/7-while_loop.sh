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


while read -r line
do
    echo "$line"
    sleep 0.5
done < "$1"


i=0
while [ $i -le 5 ]
do
    echo $i
    i=$((i+1))
done


# infinite loop
while true
do
    echo "PIN should contain at least 5 digits."
    echo "Enter PIN:"
    read -r pin
    #  ${#pin}    : holds the number of characters in string variable $pin
    if [ ${#pin} -lt 5 ]
    then
        echo "PIN too short, try again"
    else
        break
    fi
done
echo "PIN accepted"


for i in 1 2 3 4 5
do 
    echo "$i"
done

for ((i=0; i<10; i++))
do
    echo "$i"
done

# for loops can iterate through arguments passed into the script by the use of "$@" internal parameter:
for name in "$@"
do
    echo "Hello, $name!"
done


# for loop can iterate through the standard output of a command string by using command substitution
for file in $(ls)
do
    echo "File found: $file"
done

for user in $(users | tr " " "\n" | cut -c 10- | sort -u)
do
    echo "Users found: $user"
    sleep 0.5
done


for i in 1 2 3 4 5
do
    echo "$i"
    if [ "$i" -eq 3 ]
    then
        break  # completely break out of loop
    fi
    echo "keep looping"
done
echo "outside loop"


for i in 1 2 3 4 5
do
    echo "$i"
    if [ "$i" -eq 3 ]
    then
        continue  3  # exit current iteration and move to next iteration of the loop
    fi
    echo "keep looping"
done
echo "outside loop"

# continue will exit the current iteration of loop / current if statement


lines=("apple" "banana" "cherry")

# This iterates over VALUES
for item in "${lines[@]}"; do
    echo "$item"
done
# Output: apple, banana, cherry

# This iterates over INDICES
for i in "${!lines[@]}"; do
    echo "Index: $i, Value: ${lines[$i]}"
done
# Output:
# Index: 0, Value: apple
# Index: 1, Value: banana
# Index: 2, Value: cherry