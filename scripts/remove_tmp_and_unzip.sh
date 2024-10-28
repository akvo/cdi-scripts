#!/bin/bash

# Define the dataset directory
DATASET_DIR=~/dataset/$1
TARGET_DIR="${2/#\~/$HOME}"

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dataset_name> <target_name>"
    echo "Both <dataset_name> and <target_name> are required arguments."
    exit 1
fi

# Check if the dataset directory exists
if [ ! -d "$DATASET_DIR" ]; then
    echo "Directory $DATASET_DIR does not exist."
    exit 1
fi
# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    exit 1
fi

# Remove all .tmp extensions and unzip files
find "${DATASET_DIR}" -type f -name "*.tmp" | while read FILE; do
    NEW_FILE="$FILE"
    while [[ "$NEW_FILE" == *.tmp ]]; do
        NEW_FILE="${NEW_FILE%.tmp}"
    done

    mv "$FILE" "$NEW_FILE"
    echo "Renamed $FILE to $NEW_FILE"

    if [[ $NEW_FILE == *.gz ]]; then
        gunzip -k "$NEW_FILE"
    fi
    if [[ $NEW_FILE == *.zip ]]; then
        unzip -o "$NEW_FILE" -d "$TARGET_DIR"
    fi
done

echo "Process complete."
