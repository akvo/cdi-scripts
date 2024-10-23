#!/bin/bash

# Directory where .gz files are located (default is current directory)
DIR="../source/input_data/CHIRPS"

# Loop through all .gz files in the directory
for gz_file in "$DIR"/*.gz; do
  # Check if there are any .gz files
  if [[ ! -e "$gz_file" ]]; then
    echo "No .gz files found."
    exit 1
  fi

  # Extract the file (removing .gz extension)
  gunzip -k "$gz_file"  # Use -k to keep the .gz file intact
  # Remove the .gz file
  # rm "$gz_file"

  # Get the extracted file name (removes the .gz part)
  extracted_file="${gz_file%.gz}"

  # Extract the date parts from the file name
  # File format: chirps-v2.0.YYYY.MM.tif
  # Extract the year and month from the filename
  year=$(echo "$extracted_file" | grep -oP '\d{4}')  # Extract the 4-digit year
  month=$(echo "$extracted_file" | grep -oP '\.\d{2}\.' | tr -d '.')  # Extract the month, removing dots

  # Create the new filename: cYYYYMM.tif
  new_file_name="${DIR}/c${year}${month}.tif"

  # Rename the extracted file
  mv "$extracted_file" "$new_file_name"

  # Log the renaming action
  echo "changed from '$extracted_file' to '$new_file_name'"
done
