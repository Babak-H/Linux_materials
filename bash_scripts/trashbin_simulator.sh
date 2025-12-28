#!/bin/sh

# Declare and initialize variables for trash directories
TRASH_BASE="$HOME/.local/share/Trash"
TRASH_FILES="$TRASH_BASE/files"
TRASH_INFO="$TRASH_BASE/info"

# Check if the trash directories exist (Trash/files and Trash/info)
if [ ! -d "$TRASH_BASE" ]; then
    mkdir -p "$TRASH_BASE"
fi

if [ ! -d "$TRASH_FILES" ]; then
    mkdir -p "$TRASH_FILES"
fi

if [ ! -d "$TRASH_INFO" ]; then
    mkdir -p  "$TRASH_INFO"
fi

# Check and validate option
RESTORE="false"

while getopts u OPTION
do
    case "$OPTION" in
        u) RESTORE="true" ;;
        *)  echo "Invalid option" >&2
            exit 1 ;;
    esac
done

shift $(( OPTIND - 1  ))

# Check if the filename not provided
if [ '$#' -ne 1 ] ; then
    echo "No Arguments Provided" >&2
    exit 1
fi

RESTORE="false"

# if RESTORE is true => restore a deleted file
# if RESTORE is false (or anything else) => delete the file
if [ "$RESTORE" = "true" ] ; then
    # check if file exists in the trash folder
    if [ -f "$TRASH_FILES/$1" ] ; then
        # check if somehow user restored the file another way and we need to replace it
        original_path=$(grep '^Path=' "${TRASH_INFO}/${1}.trashinfo" | cut -d "=" -f 2)
        if [ -f "$original_path" ] ; then
            echo "File already exists. Do you want to overwrite?" ; read -r userReply
        fi
        # if the answer is Yes (to replace) or original file does NOT exit (no need to rewrite it) then restore the file
        if [ ! -f "$original_path" ] || [ "$(echo $userReply | tr '[:upper:]' '[:lower:]')" = "y" ] ; then
            mv "$TRASH_FILES/$1" "$original_path"
            rm "${TRASH_INFO}/${1}.info"
        else
            exit 0
        fi
    # if the file is not in the trash folder or its address in the meta-trash, then throw an error and exit
    else
        echo "Trash file with filename $1 does not exist!" >&2
        exit 1
    fi
else
    # first take care of all possible errors
    if [ ! -e "$1" ] ; then
        echo "File does not exist!" >&2
        exit 1
    elif [ -d "$1" ] ; then
        echo "mtt: can not remove $1 , its a directory" >&2
        exit 1
    elif [ $1 -ef "$0" ] ; then
        echo "Cannot delete mtt file!" >&2
        exit 1
    else
        absolute_path=$(realpath "$1")
        filename="$(basename "$absolute_path")"
        inode=$(ls -i "$absolute_path" | cut -d " " -f 1)

        # %Y → 4-digit year
        # %m → month
        # %d → day
        # %Z → timezone
        # %T → HH:MM:SS

        echo -e "[Tash Info]\nPath=\"$absolute_path\"\nDeletionDate: $(date +Y%m%d%Z%T)" > "$TRASH_INFO/${filename}_${inode}.trashinfo"
        mv "$absolute_path" "$TRASH_FILES/${filename}_${inode}"
        echo "File moved to the trash successfully!"
    fi
fi

exit 0

# "${filename}_${inode}"  => Bash sees exactly two variables: filename and inode : <filename>_<inode>
# Using {} tells bash exactly where a variable name ends.

# "$filename_$inode" => $filename_ ← it thinks the variable name is filename_
# Unless your variable is literally named filename_ , this will expand to empty or wrong data.

# correct => "${filename}_${inode}"
# wrong => "$filename_text" OR "$var$othervar" OR "$filename_$inode"

