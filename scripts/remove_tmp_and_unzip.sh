#!/bin/bash

# Check if a dataset directory is passed as an argument
if [ -z "$1" ]; then
    echo "Please provide a dataset directory as an argument."
    exit 1
fi

# Define the dataset directory
DATASET_DIR=~/dataset/$1

# Check if the directory exists
if [ ! -d "$DATASET_DIR" ]; then
    echo "Directory $DATASET_DIR does not exist."
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
        unzip -o "$NEW_FILE" -d "$DATASET_DIR"
    fi
done

echo "Process complete."
