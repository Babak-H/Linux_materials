!/bin/bash

a=()
b=("apple" "cherry" "orange")

echo ${b[1]}

b[5]="kiwi"    # you don't need to populate every element of an array

b+=("mango")  # adds to the end of an array

echo ${b[6]}

echo ${b[@]}    # show all elements of an array

echo ${b[@]: -1}   # shows last element of an array

# array with key-value pairs :
declare -A myArray

myArray[color]=blue
myArray["my office"]="L A"   # if the key or value have space in them you should use ""

echo ${myArray[color]}
echo "the city that I live in is ${myArray["my office"]}"

# this is a  sign to show end of text and will not be shown  when you run the script
cat  << EndOfText     
fdfsdfdsf
dsfsdfsdf
dsfsdfsdf
EndOfText


# the '-' after '<<' removes the tabs from start of lines when showing them on the screen
cat <<- EnditBro     
 	dsfsdfsf
		weruwepruwe
toprtuoieurt
		zxcnv,zmv
EnditBro