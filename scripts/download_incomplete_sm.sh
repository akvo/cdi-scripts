#!/bin/bash

LOG_DIR=~/log

mkdir -p "${LOG_DIR}"

# Define log file
CURR_DATE=$(date +%Y%m%d)
CURR_TIME=$(date +%H%M%S)

EMAIL="$1"

if [ -z "${EMAIL}" ]; then
    echo "Usage: ./download-all.sh <email>"
    exit 1
fi

function download_file()
{
    URL=$1
    PATTERN=$2
    NAME=$3

    mkdir -p ~/dataset/"${NAME}"

    ./download.sh "${URL}" "${PATTERN}" "${LOG_DIR}/${NAME}-${CURR_DATE}-${CURR_TIME}.log" ~/dataset/"${NAME}" "${EMAIL}" > /dev/null 2>&1
}

# Directory to search
directory=~/cdi-scripts/source/input_data/soil_moisture

# Initialize an associative array for storing counts by year
declare -A year_counts

# Loop through each file in the specified directory
for file in "$directory"/FLDAS_NOAH01_C_GL_M.A*.nc; do
  # Extract the year from the filename using pattern matching
  if [[ "$file" =~ FLDAS_NOAH01_C_GL_M\.A([0-9]{4})[0-9]{2}\.001\.nc ]]; then
    year="${BASH_REMATCH[1]}"
    # Increment the count for the extracted year
    ((year_counts["$year"]++))
  fi
done

# Print the results in the specified range (1982 to 2024)
for year in $(seq 1982 2024); do
  if [[ -n "${year_counts[$year]}" ]]; then
    count=${year_counts[$year]}
    if (( count < 12 )); then
      echo "$year = incomplete"
      download_file "https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/${year}/" ".nc" "SOIL_MOISTURE_${year}" &
      disown  # Disown the process so it won't terminate when the terminal closes
    else
      echo "$year = $count"
    fi
  else
    echo "$year = incomplete"
    download_file "https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/${year}/" ".nc" "SOIL_MOISTURE_${year}" &
    disown  # Disown the process so it won't terminate when the terminal closes
  fi
done
