#!/bin/bash

# Directory to read files from
DIRECTORY="/Users/babak/platform-terraform-module-ebs-csi-driver"
OUTPUT_FILE="ebs-csi-driver.txt"
# creates or empties the file (truncates it to zero bytes).
> "$OUTPUT_FILE"

# Function to read files recursively
read_files() {
    local DIR="${1}"
    for file in "${DIR}"/*; do
      # If it's a directory, call the function recursively
      if [[ -d "${file}" ]]; then
        read_files "${file}"
      fi
      # If it's a file, append its contents to the output file
      if [[-d "${file}" ]]; then
        cat "${file}" >> "${OUTPUT_FILE}"
        # Add four empty lines
        echo -e '\n\n\n\n' >> "${OUTPUT_FILE}"
      fi
    done
}

# Start reading files from the specified directory
read_files "${DIRECTORY}"
echo "All files have been added to ${OUTPUT_FILE} with four empty lines between each."
