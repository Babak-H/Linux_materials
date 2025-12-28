#!/bin/sh

while true
do
        echo "                 Menu"
        echo "1 - Display the Current Date and Time"
        echo "2 - Display the Current Working Directory"
        echo "3 - Display the User's Currently Running Processes"
        echo "4 - Quit"

        read -p "select any of the options 1-4 from the Menu:  " VAR
        echo -e "\n"
        case "$VAR" in
                1) echo $(date) ;;
                2) echo $(pwd) ;;
                3) echo $(ps -u $USER) ;;
                4) exit 0 ;;
                *)
                    echo 'supply a valid option' >&2
                    exit 1
                    ;;
        esac

        echo -e "\n\n"
done