#!/bin/sh

usage() {
        printf "===================\nSIMPLE CALCULATOR\n===================\na - Add two numbers\ns - Subtract two numbers\nm - Multiply two numbers\nd - Divide two numbers\n5 – Raise a number to a power\n\n"
}

usage

add() {
        RES=$(( $1 + $2 ))
        echo "$1 + $2 = $RES"
}

sub() {
        RES=$(( $1 - $2 ))
        echo "$1 - $2 = $RES"
}

mult() {
        RES=$(( $1 * $2 ))
        echo "$1 * $2 = $RES"
}

div() {
        if [[ $2 -eq 0 ]]; then
                echo "can not perform division by Zero" >&2
                return 1
        fi
        RES=$(echo "scale=2; $1 / $2" | bc -l)
        echo "$1 / $2 = $RES"
}

twoargs() {
        if [ "$#" -ne 2 ] || [ -z "$1" ] || [ -z "$2" ]; then
                echo "this script needs to arguments" >&2
                exit 1
        fi
}

isint() {
        if [[ "$1" =~ ^[0-9]+$ && "$2" =~ ^[0-9]+$ ]]; then
                return 0
        else
                echo "needs both arguments to be integers" >&2
                exit 1
        fi
}

raise() {
        twoargs "$1" "$2"
        isint "$1" "$2"
        RES=$(echo "$1 ^ $2" | bc)
        echo "$RES"
}

CALCS=()

while getopts asmd OPTION
do
        case $OPTION in
        a) CALCS+=("add") ;;
        s) CALCS+=("sub") ;;
        m) CALCS+=("mult") ;;
        d) CALCS+=("div") ;;
        *)
        echo "provide correct options" >&2
        exit 1
        ;;
        esac
done

shift $(( OPTIND - 1 ))

twoargs $1 $2
isint $1 $2

for CALC in ${CALCS[@]}; do
        $CALC $1 $2
done

raise "$1" "$2"