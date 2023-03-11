!/bin/bash

if
a=3
if [ $a -gt 4 ]; then
	echo "$a is greater than 4"
else
	echo "$a is not greater than 4"
fi


b="44this is my string!"
# [0-9]+ : is a regular expression and means if there is one or more number inside the string
# =~  means contains
if [[ $b =~ [0-9]+ ]]; then   
	echo "There is a number inside the string : $b"
else
	echo "there is no number inside the string : $b"
fi



# extract value from ARGV element (reads the keyword 'Accuracy: number' from a text file)
acuuracy=$(grep Accuracy $1 | sed 's/.* //')
# use conditional
if [$accuracy -ge 90]; then
	mv $1 good_folder/
fi

if [$accuracy -lt 90]; then
	mv $1 bad_folder/
fi


# create a variable from the first given argument
sfile=$1
# if the strings 'SRVM_' and 'vpt' exist in the file then...
if grep -q 'SRVM_' $sfile && grep -q 'vpt' $sfile then
	mv $sfile good_logs/
fi