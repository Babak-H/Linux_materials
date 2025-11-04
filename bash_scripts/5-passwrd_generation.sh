#!/bin/bash

# generate a list of random passwords
echo "${RANDOM}"

# a random number as password
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# three random numbers together
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# use current date/time as basis for password generation
# +%s  => time based on seconds
PASSWORD=$(date +%s)   
echo "${PASSWORD}"
# +%s%N => time based on nano-seconds
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"

# encrypted password, 32 character password
PASSWORD=$(date +%s%N | sha256sum | head -c 32)
echo "${PASSWORD}"

# even stronger
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c 48)

# create a special character randomly
# fold -w1 => Takes the input string and splits it so that each line contains exactly 1 character. Basically it turns the string into one-character-per-line.
# shuf => Randomly shuffles those single-character lines — i.e. it randomizes the order.
# head -c 1 => just takes the first character from the now-shuffled list, effectively selecting one random character
SPECIAL_CHAR=$(echo '!@#$%&*()_-=+' | fold -w1 | shuf | head -c 1)

echo "${PASSWORD}${SPECIAL_CHAR}"

