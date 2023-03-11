!/bin/bash

a="hello"
b=" World"
c=$a$b       # add two strings together
echo $c

# length of the string ${#a}
echo ${#a}
echo ${#c}

d=${c:4}    # the $c variable from its fourth character
echo $d

e=${c:3:4}   # start at third character and show 4 characters after that
echo $e

f=${c: -4} # shows last 4 characters of string (backward)
echo $f

fruit="cherry banana apple tangerine banana cucumber banana orange"
echo ${fruit/banana/mouz}  # this will change first instnce of banana with mouz in variable fruit

echo ${fruit//banana/mouz}  # change all instances of banana with mouz in variable fruit

echo ${fruit/#cherry/gilas} # only replaces if the searched term is first inisde the variable

echo ${fruit/o*/sib}   # all words that start with o
