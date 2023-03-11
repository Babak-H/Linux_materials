!/bin/bash

$((a+b))   # typical form of a mathematical operation in bash

d=2
e=$((d+2))
echo $e

((e++))
echo $e

((e--))
echo $e

((e+=3))
echo $e

((e-=6))
echo $e

((e*=4))
echo $e

((e/=2))
echo $e

f=$((1/3))
echo $f    # bash only works with integers, return 0
