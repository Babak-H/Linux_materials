!/bin/bash

# [[  ]]     1 => false   0 => true

[[ "cat" == "cat" ]]
echo $?

[[ "cat" = "dog" ]]     # both '=' and '==' work for compring strings
echo $?

[[ 20 -lt 100 ]]      # -lt = less than 
echo $?

[[ 25 -ge 25 ]]       # -gt = greater or equal >=
echo $?

a=""
b="catDog"

[[ -z $a && -n $b ]]      # -z  => check if the string is null        
                          # -n  => check if string is not null
echo $?