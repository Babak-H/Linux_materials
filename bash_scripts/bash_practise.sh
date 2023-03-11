!/bin/bash

# Create the required variable
yourname="Sam"

echo "Hi there $yourname, welcome to the website!"

# shel within a shell
echo "Right now it is `date`"


# turn Fahrenheit to celsius
temp_f=$1   # Get first ARGV into variable
temp_f2=$(echo "scale=2; $temp_f - 32" | bc)   # Subtract 32
temp_c=$(echo "scale=2; $temp_f2 * 5 / 9" | bc)   # Multiply by 5/9
echo $temp_c   # Print the celsius temp


# Create three variables from the temp data files contents
temp_a=$(cat temps/region_A)
temp_b=$(cat temps/region_B)
temp_c=$(cat temps/region_C)
# Print out the three variables
echo "The three temperatures were $temp_a, $temp_b, and $temp_c"


# Create a normal array 
capital_cities=("Sydney" "New York" "Paris")


# Create a normal array with the declare method
declare -a capital_cities
# Add (append) the elements
capital_cities+=("Sydney")
capital_cities+=("New York")
capital_cities+=("Paris")

# print the entire array
echo ${capital_cities[@]}
# print length of the array
echo ${#capital_cities[@]}


# associative array (similar to python dictionary)
declare -A model_metrics
model_metrics[model_accuracy]=98
model_metrics[model_name]="knn"
model_metrics[model_f1]=0.82


# Declare associative array with key-value pairs in one line
declare -A model_metrics=([model_accuracy]=98 [model_name]="knn" [model_f1]=0.82)
# Print out the entire array
echo ${model_metrics[@]}
# print out just the keys of array
echo ${!model_metrics[@]}


# Create variables from the temperature data files
temp_b="$(cat temps/region_B)"
temp_c="$(cat temps/region_C)"
# Create an array with these variables as elements
region_temps=($temp_b $temp_c)
# Call an external program to get average temperature
average_temp=$(echo "scale=2; (${region_temps[0]} + ${region_temps[1]}) / 2" | bc)
# Append to array
region_temps+=($average_temp)
# Print out the whole array
echo ${region_temps[@]}