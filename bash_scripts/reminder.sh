#!/bin/sh

HOUR=$(date +"%I" | sed 's/^0//')
ZONE=$(date +"%p")
GREETING=""

if [[ $HOUR -lt 12 && $ZONE = "am" ]]; then
        GREETING='Good morning'
elif [[ $HOUR -lt 5 && $ZONE = "pm" ]]; then
        GREETING='Good afternoon'
elif [[ $HOUR -gt 5 && $ZONE = "pm" ]]; then
        GREETING='Good evening'
fi

# grep -o '[^:]*$'   => it will go the the last : and take whatever comes after it until the end
echo "$GREETING $(echo $USER), don't forget to save your scripts in $(pwd) and create hardlinks to them in your $(echo $PATH | grep -o '[^:]*$' ) directory!"
if [[ $# -ne 2 ]]
then
        echo "No argument supplied"
        exit 1
fi

if [[ "$1" = 'thanks' || "$1" = 'Thank you' ]]
then
        echo "You're welcome!"
fi

if [[ "$2" = 'Sandip' ]]; then
        if [ -f 'Sandip' ]; then
                read -p "the file already exists, do you want to delete it?  " DEL
                if [[ $DEL = 'yes' || $DEL = 'Yes' || $DEL = 'YES' ]]; then
                        rm './Sandip'
                        if [[ $? -ne 0 ]]; then
                                exit 2
                        fi
                elif [[ $DEL = 'no' || $DEL = 'No' || $DEL = 'NO' ]]; then
                        exit 0
                else
                        echo "Invalid response" >&2
                        exit 2
                fi
        fi
        touch "$2"
        echo "$(ls -li | grep $2 | tr -s ' ' | cut -d ' ' -f1,10)" 2> /dev/null
fi

LC=0
while IFS= read -r LINE; do
        ((LC++))
        CC=$(echo $LINE | tr -s ' ' | wc -c)
        echo "History line $LC contains $CC characters."
done < "history"

echo $(date +"%H:%M")

exit 0