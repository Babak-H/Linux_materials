#!bin/bash

set -e

if [ $# -ne 1 ] ; then
    echo "usage: $0 needs one variable as address of the file"
    exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
    echo "Error: file does not exist"
    exit 1
fi

if [[ "$file" != *.txt ]]; then
    echo "Error: file must be a .txt file"
    exit 1
fi

temp_file=$(mktemp)

mapfile -t lines < "$file"

special_indices=()

# ${!lines[@]} is a bash array expansion that returns the indices (keys) of the array lines, rather than its values
for i in "${!lines[@]}"; do
    if [[ "${lines[$i]}" == *"***"* ]]; then
        special_indices+=("$i")
    fi
done

is_near_special() {
    local idx=$1

    for s in "${special_indices[@]}"; do
        if [[ $((s-1)) -eq idx || $((s+1)) -eq idx ]]; then
            return 0
        fi
    done

    return 1
}

cleaned=()

for i in "${!lines[@]}"; do
  line="${lines[$i]}"

  if [[ -z "${line// /}" ]]; then
    # Keep only if next to "***"
    if is_near_special "$i"; then
      cleaned+=("")
    fi
  else
    cleaned+=("$line")
  fi
done

# Wrap lines at 200 characters without breaking words
for line in "${cleaned[@]}"; do
    if [[ -z "${line// /}" ]]; then
        echo "" >> "$temp_file"
    else
        echo "$line" | fold -s -w 200 >> "$temp_file"
    fi
done

mv "$temp_file" "$file"

echo "filed was processed!"