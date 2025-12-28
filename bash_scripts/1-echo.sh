#!/bin/bash

# this is a comment

echo 'Hello'

WORD='script'
# returns the content of variable
echo "$WORD"
# returns the word $WORD
echo '$WORD'

echo "This is a shell $WORD"
# another way
echo "This is a shell ${WORD}"

echo "${WORD}ing is fun!"

ENDING='ed'

echo "This is ${WORD}${ENDING}."

ENDING='ing'
echo "This is ${WORD}${ENDING}."

ENDING='s'
echo "You are going to write many ${WORD}${ENDING}"

firstname=David
lastname=Webb
fullname=$firstname" "$lastname