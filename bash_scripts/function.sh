!/bin/bash

function greeting {
	echo "Hi there $1"
	echo "it's a nice $2 ain't it?"
}

# how to call a function (with arguments) :
greeting Bob Day
greeting friend evening


# function that accepts array/list
function numberThings {
	i=1
	for f in $@; do      # $@ means all elements inside the list/array
		echo $i: $f
		((i+=1))
	done
}

numberThings $(ls) # passing command to the function

numberThings apple pineapple applePie 


function upload_to_cloud () {
	for file in output_dir/*results*
	do
		echo "uploading $file to cloud"
	done
}

# call the function
upload_to_cloud


what_day_is_it () {
	current_day = $(date | cut -d " " -f1)
	echo $current_day
}

what_day_is_it


# passing arguments to functions
function return_percentage () {
	# bc command is used for command line calculator. It is similar to basic calculator 
	# by using which we can do basic mathematical calculations.
	percent = $(echo "scale=2; 100 * $1 / $2" | bc)
	return percent
}

# how to run the function with 2 arguments
return_test = $(return_percentage 456 632)
echo "456 out of 632 as a percent is $return_test %"

function get_number_wins () {
	# filter aggregate results by argument
	win_stats=$(cat soccer_scores.csv | cut -d "," -f2 | egrep -v "Winner" | sort | uniq -c | egrep "$1")
}

get_number_wins "Etar" # check the csv file to see if this team is in the winners, and count the wins
echo "The aggregated stats are: $win_stats"  # in bash scripts we dont have local variables, unless specified


function sum_array () {
	# this is a local variable. we can't access it from outside this method directly
	local sum = 0
	# loop through all the given arguments
	for number in "$@"
	do
		sum = $(echo "$sum + $number" | bc)
	done

	echo $sum
}

# Call function with array
test_array=(14 12 23.5 16 19.34)
total=$(sum_array "${test_array[@]}")
echo "total sum is $total"
