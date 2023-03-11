!/bin/bash

echo $1
echo $2

# when you want to send a list/array of argument to the script:
for i in $@
do
	echo $i
done

echo "number of arguments: $#"  #  $# shows number of entered arguments


# flags
# u: and p: means you write -u/-p and some data after them.
# in the case if you entered -u before data it will asign it to username and if it was -p it will be password
# $OPTARG is the data that you enter

while getopts u:p: option; do
	case $option in
		u) user=$OPTARG;;
		p) pass=$OPTARG;;
	esac
done

echo " $user  /  $pass "


echo "what is your name?"

# read command waits for user's input
read name

echo "what is your password?"

# read -s : it will not show what user has typed
read -s pass

# using read without echo command with 'read -p' , it will do everything in one line
read -p "what is your favorite animal?  " animal

echo "name : $name, pass : $pass, animal: $animal"


#this is a select menu and user enters the number of their selected item :
select favAnimal in "cat" "dog" "bird" "fish" "reptile"
do
	echo "you selected $favAnimal"
	break
done


read -p "favorite animal? " a

# this will repeat the question untill user actually types something
while [[ -z $a ]]; do
	read -p "favorite animal? " a
done
echo "$a was selected"


read -p "what year [nnnn] ? " b

# here we check if user wrote a 4-digit number with regular expressions:
while [[ ! $b =~ [0-9]{4} ]]; do
	read -p "enter a valid year [nnnn] ? " b
done
echo "you selected year $b"