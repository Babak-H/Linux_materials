!/usr/bash

# BASH = Born Again SHell

# in a shell script you can write same commands as in the terminal and then execute them all from one file

# how to create a shell script 
# 1- open a new document file in any text editor
# 2- !/bin/sh  => this should be the first line a shell script, it shows the linux it is shell file
# 3- # => any thing after this is a comment and will be ignored

# how to run a shell script 
# bash nameOfScript : bash Bobcript => this will run the script (if it has excute permission)
# 1- set the script to executable : chmod +x script.sh     
# 2- run the script : ./script.sh

echo -n "Hello"; 
echo " World"           # -n wil make sure we don't go to the next line
echo "$x is my thing "  # apple is my thing    
echo '$x is my thing'   # $x is my thing


# how many times each unique word is being repeated in the text file
cat animals.txt | cut -d " " -f 2 | sort | uniq -c  

cat server_log_with_todays.txt

cat soccer_scores.txt | cut -d "," -f 2 | tail -n +2 | uniq -c

# Create a pipe using sed twice to change the team Cherno to Cherno City first, and then Arda to Arda United
cat soccer_score.txt | sed 's.Cherno/Cherno City/g' | sed 's/Arda/Arda United/g' > soccer_score_edited.csv


'''
STDIN  => standard input, a stream of data going inside the program
STDOUT => standard output, a stream of data going outside the program
STDERR => standard error, errors in your program

2> /dev/null  => redirecting STDERR to be deleted


ARGV  => is an array of arguments given to the program
'''

echo $1 # Echo the first ARGV argument
echo $2
echo $@
echo "the are " $# "arguments"

echo $1
# Cat all the files
# read all the text into the variable $1
# Then write out to a named csv using the first ARGV argument
cat hire_data/* | grep "$1" > "$1".csv

# how to run the script from terminal with arguments
bash args.sh one two three four