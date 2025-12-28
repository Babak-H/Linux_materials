#!/bin/bash

# BASH = Born Again SHell

# in a shell script you can write same commands as in the terminal and then execute them all from one file

# how to run a shell script 
# 1- set the script to executable : chmod +x script.sh     
# 2- run the script : ./script.sh

# how to run the script from terminal with arguments
./args.sh one two three four

A=babak
B="Habibnejad"
C=125

echo ${A}
echo ${B}
echo ${C}

declare -i D=123   # d is an integer
declare -r E=1000  # e is an read-only and can not be modified

# prints the machine type (hardware and OS platform) that your Bash shell was compiled for.
echo "${MACHTYPE}"
# shows info about the host
echo "${HOSTNAME}"
# shows current version of bash software
echo "${BASH_VERSION}"
# shows name of the running script
echo "${0}"

# command substitution: save commands inside a variable
I=$(pwd)
echo "${I}"

S=$(ls -l)
echo "${S}"

# get pings from a website
Z=$(ping -c 1 google.com | grep 'bytes from' | cut -d = -f 4)
echo "${Z}"


# [[  ]]  0 => True   1 => False

# both == and = are used for string comparison, and in most cases they behave identically
[[ "cat" == "cat" ]]
  echo ${?}

[[ "cat" = "dog" ]]   # both '=' and '==' work for compring strings
  echo ${?}

[[ 20 -lt 100 ]]   # -lt = less than 
  echo ${?}

[[ 25 -gt 25 ]]  # -gt = greater or equal >=
  echo ${?}

A=""
B="catDog"
# -z STRING   “zero length”      The string is empty ("")
# -n STRING   “non-zero length”  The string is not empty
# && → logical AND, so the whole test is true only if both conditions are true.
[[ -z ${A} && -n ${B} ]]
  echo ${?}


# STDIN  => standard input, a stream of data going inside the program
# STDOUT => standard output, a stream of data going outside the program
# STDERR => standard error, errors in your program

2> /dev/null  # redirecting STDERR to be deleted

ARGV  # is an array of arguments given to the program

echo "${1}" # Echo the first ARGV argument
echo "${2}" # second argument
echo "${@}"
echo "${*}"
echo "the are " ${#} "arguments"

# cat hire_data/* => Reads (concatenates) all files inside the directory hire_data/.  The * expands to all files in that folder
#  grep "${1}" => Pipes (|) the combined output of all those files into grep, grep "${1}" searches for lines that contain the pattern stored in the first positional parameter
# > "${1}".csv => Redirects (>) the output (the matching lines) into a new file named after the search term
cat hire_data/* | grep "${1}" > "${1}".csv


A=3
if [[ $A -gt 4 ]]; then
  echo "${A} is greater than 4"
else
  echo "${A} is smaller than 4"
fi


B="44this is my string!"

# [0-9]+ : is a regular expression and means if there is one or more number inside the string
# =~  means contains

if [[ $B =~ [0-9]+ ]]; then
  echo "There is a number inside the string : ${B}"
else
  echo "there is no number inside the string : ${B}"  
fi

# extract value from ARGV element (reads the keyword 'Accuracy: number' from a text file)
# grep searches for lines containing the word "Accuracy" in the file given by $1 (input argument to the file)
# sed 's/.* //'  => .* = match everything up to the last space in the line, Replace it with nothing → effectively delete everything before the last space, So for each line, it keeps only the last word (after the final space).
# Epoch 2: Accuracy 0.91 =>  0.91
accuracy=$(grep Accuracy $1 | sed 's/.* //')
# check the results
if [[ ${accuracy} -gt 90 ]]; then
  mv $1 good_folder/
fi

# create a variable from first argument given to the script
sfile=${1}
# if the strings 'SRVM_' and 'vpt' exist in the file then...
# we are removing [[ ]] from the if statement since we are directly using the terminal commands here:
if grep -q 'SRVM_' "${sfile}" && grep -q 'vpt' "${sfile}"; then
  mv "${sfile}" approved_logs/
fi


A="Hello"
B="World"

C="${A} ${B}"
echo "${C}"

# length of the string ${#a}
echo ${#A}
echo ${#C}

# the $C variable from its fourth character
D=${C:4}
echo "${D}"

# start at third character and show 4 characters after that
E=${C:3:4}
echo "${E}"

# shows last 4 characters of string (backward)
# The space before -4 is important — it tells Bash to count from the end
F=${C: -4} 
echo "${F}"

FRUIT="cherry banana apple tangerine banana cucumber banana orange"
# this command performs string substitution — it replaces the first occurrence of a word or pattern within a variable.
echo "${FRUIT/banana/mouz}"  # this will change first instnce of banana with mouz in variable fruit

echo "${FRUIT//banana/mouz}"  # change all instances of banana with mouz in variable fruit

echo "${FRUIT/#cherry/CHERRY}"  # only replaces if the searched term is first inisde the variable

echo "${FRUIT/o*/APPLE}"  # all words that start with o

# how many times each unique word is being repeated in the text file
cat animals.txt | cut -d " " -f 2 | sort | uniq -c

car soccer_scores.txt | cut -d "," -f 2 | tail -n 2 | uniq -c

# Create a pipe using sed twice to change the team Cherno to Cherno City first, and then Arda to Arda United
cat soccer_scores.txt | sed 's/Cherno/Cherno City/g' | sed 's/Arda/Arda United/g' > soccer_score_edited.csv


A="cat"

case ${A} in
  cat) echo "its cat" ;;
  dog|puppy) "it's dog" ;;
  *) echo "no match" ;;
esac

# create a case statement matching first ARGV element
case ${1} in
  Monday|Tuesday|Wedensday|Friday)
   echo "its weekday" ;;
  Saturday|Sunday)
   echo "its weekend" ;;
  *) echo "not a week day";;
esac

for file in model_out/*
do
  case $(cat "${file}") in 
    RandomForest|GBM|XGBoost|KNN) rm "${file}" ;;
    *) echo "unknown model in ${file}" ;;
  esac
done


A=$(( 12+14 ))
echo ${A}

echo $(( 3+2*5))  # 13

x=$(( (3+2)*5))
echo $x  # 25

D=2
E=$(( D+2 ))
echo ${E}

(( E++ ))
echo "$E"

(( E-- ))
echo "$E"

(( E += 3 ))
echo "$E"

(( E -= 6 ))
echo "$E"

(( E *= 4 ))
echo "$E"

(( E /= 2 ))
echo "$E"

# bash only works with integers, return 0
F=$(( 1/3 ))
echo "$F"

F=$(echo "1/3" | bc -l)
echo "$F"  # Output: 0.3333333333333333

echo $(( 8/3 )) # 2
x=$(echo "scale=3; 8/3" | bc -l)
echo "$x"  # 2.666



# while loop works when the expression is true
I=0
while [[ $I -lt 10 ]]; do
  echo "I: ${I}"
  (( I++ ))
done

# another way to do same:
for (( I=0; I<10; I++ )); do
  echo "I: ${I}"
done

J=0
until [[ ${J} -gt 10 ]]; do
  echo ${J}
  (( J++ ))
done

EMP_NUM=1
while [[ $EMP_NUM -lt 1000 ]]; do
  cat "${EMP_NUM}-dailysales.txt" | grep -E 'Sales_total' | sed 's/.* ://' > "${EMP_NUM}-agg.txt"
  (( EMP_NUM++ ))
done

# sed 's/.* ://'
# .* → match any characters (as many as possible)
# : → then match a space followed by a colon (" :")
# // → replace everything matched by that pattern with nothing (i.e., delete it)
# it removes everything up to and including the first " :" in each line.
# Name : John  =>  John

for i in 1 2 3 4 5
do 
  echo "$i"
done

# 1 3 5 7 9
for j in {1..10..2}
do
  echo "$j"
done

for (( z=0; z<=10; z++))
do 
  echo "$z"
done

arr=("apple" "banana" "cherry")
for x in "${arr[@]}"
do
  echo "$x"
done

declare -A arr
arr["name"]="Alex Jones"
arr["id"]="1031B"

# ! in ${!arr[@]} means that $v is the key and not the value
# we put array element inside "" since there may be space in the string
# ${!arr[@]} => Expands to all the indexes (for normal arrays) or keys (for associative arrays) in arr
for v in "${!arr[@]}"
do
  echo "${v}: ${arr[$v]}"
done

# for loop for all files in a directory
for file in inheritedfolder/*.py
do 
  echo "${file}"
done


for file in executive_files/*.py
do
  if grep -q 'RandomForestClassifer' "${file}"; then
    mv "${file}" to_keep/
  fi
done


A=()
B=("Apple" "Cherry" "Orange")

echo "${B[1]}"

# you don't need to populate every element of an array
B[5]="kiwi"  

# adds to the end of an array, sixth element
B+=("Mango")

echo "${B[6]}"
# show all elements of an array
echo "${B[@]}"

# ${B[@]} → expands to all elements of array B
# The : -1 syntax means slice starting from index -1 (i.e., the last element), The space before -1 is required — without it, Bash would think :@ means something else
echo "${B[@]: -1}"

show fourth value in the names array
echo "${names[3]}"

# array with key-value pairs :
declare -A myArray

myArray[color]=blue
# if the key or value have space in them you should use ""
myArray["my office"]="L A"  

echo "${myArray[color]}"
echo "the city that I live in is ${myArray['my office']}"

# Create a normal array with the declare method
declare -a capital_cities
# Add (append) the elements
capital_cities+=("Sydney")
capital_cities+=("New York")
capital_cities+=("Paris")

# print the entire array
echo "${capital_cities[@]}"
# print length of the array
echo ${#capital_cities[@]}

# Declare associative array with key-value pairs in one line
declare -A model_metrics=([model_accuracy]=98 [model_name]='knn' [model_f1]=82)
# Print out the entire array
echo "${model_metrics[@]}"
# print out just the keys of array
echo "${!model_metrics[@]}"

# POSIX shell doesnt't accept arrays, but we can define them this way there
set - "Alice" "Bob" "Mary Jane" "Ted"

echo "$1" # Alice
echo "$4" # Ted
echo "$@" # all values

# this is a sign to show end of text and will not be shown  when you run the script
cat << EndOfText
fdfsdfdsf
dsfsdfsdf
dsfsdfsdf
EndOfText

# the '-' after '<<' removes the tabs from start of lines when showing them on the screen
cat <<- EnditHere
 	dsfsdfsf
		weruwepruwe
toprtuoieurt
		zxcnv,zmv
EnditHere


greeting() {
  echo "Hi there ${1}"
  echo "its a nice ${2} day"
}

# how to call a function (with arguments) :
greeting Babak Sunny
greeting friend lovely

numberThings() {
  i=1
  for f in "${@}"
  do
    echo "${i}: ${f}"
    (( i++ ))
  done
}

# passing command to the function
numberThings "$(ls)"

numberThings apple pineApple applePie

upload_to_cloud() {
    for file in output_dir/*results*; do
      echo "uploading ${file} to cloud"
    done
}

upload_to_cloud

what_day_is_it() {
    current_day=$(date | cut -d " " -f 1)
    echo "${current_day}"
}

what_day_is_it

return_percentage() {
    # scale=2 sets the decimal precision to 2 digits after the decimal point
    # The output of echo ... is piped (|) into bc, which performs the arithmetic.
    # $( ... ) captures (command substitution) the result of bc and stores it in the variable percent
    percent=$(echo "scale=2; 100*${1}/${2}" | bc)
    return "${percent}"
}

return_test=$(return_percentage 456 632)
echo "456 out of 632 as a percent is ${return_test}"

get_number_wins() {
    # filter aggregate results by argument
    win_stats=$(cat soccer_scores.csv | cut -d "," -f 2 | grep -v "Winner" | sort | uniq -c | grep -e "${1}" )
    echo "${win_stats}"
}

get_number_wins "Etar"  # check the csv file to see if this team is in the winners, and count the wins

sum_array() {
    # this is a local variable. we can't access it from outside this method directly
    local sum=0
    for num in "${@}"
    do
      # for integers only => ((sum += num))
      sum=$(echo "${sum}+${num}" | bc)
    done

    echo "${sum}"
}

# Call function with array
test_array=(14 12 23.5 16 19 19.34)
total_value=$(sum_array "${test_array[@]}")
echo "total sum is ${total_value}"

# when you want to send a list/array of argument to the script:
for i in "${@}"
do
	echo "${i}"
done

echo "number of arguments: ${#}"  #  $# shows number of entered arguments


# $OPTARG is the data that you enter
while getopts u:p: OPTION
do
  case $OPTION in
    u) USER=$OPTRG ;;
    p) PASS=$OPTARG ;;
    *) exit 1
  esac
done

echo "${USER}, ${PASS}"

echo "what is your name?"
# read command waits for user's input
read name
# read -s : it will not show what user has typed
read -s pass

# using read without echo command with 'read -p' , it will do everything in one line
read -p "what is your favorite animal? " ANIMAL
echo "name: ${name}, passwd: ${pass}, fav animal: ${ANIMAL}"

# this is a select menu and user enters the number of their selected item :
select favAnimal in "cat" "dog" "bird" "fish"
do 
  echo "you selected ${favAnimal}"
  break
done


read -p "favorite animal? " A
# this will repeat the question untill user actually types something
while [[ -z $A ]]; do
    read -p "favorite animal? " A
done

echo "${A} was selected"


read -p "what is your birth year [YYYY] ? " Y

# here we check if user wrote a 4-digit number with regular expressions:
while [[ ! ${Y} =~ [0-9]{4} ]]
do
  read -p "enter a valid year [YYYY] ? " Y
done

echo "you selected the year: ${Y}"

# turn Fahrenheit to celsius
temp_f=${1}
temp_f2=$(echo "scale=2; ${temp_f}-32" | bc)  # Subtract 32
temp_c=$(echo "scale=2; ${temp_f2}*5/9" | bc)  # Multiply by 5/9
echo "${temp_c}"


for i in 1 2 3 4 5
do
  if [[ $i == $j ]]; then
    found=true
    break
  fi
done 

# same thing as as
for i in 1 2 3 4 5
do
  [[ $i == $j ]] && found=true && break
done 
