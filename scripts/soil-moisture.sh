#!/bin/bash

# Define log file
CURR_DATE=$(date +%Y%m%d)
CURR_TIME=$(date +%H%M%S)
LOG_DIR=~/log/download-log/soil-moisture
LOG_FILE=${LOG_DIR}/soil-moisture-${CURR_DATE}-${CURR_TIME}.log

MY_AUTH0_USER="$1"

if [ -z "${MY_AUTH0_USER}" ]; then
    echo "EMAIL is required"
    exit 1
fi

if [ ! -d "${LOG_DIR}" ]; then
    mkdir -p "${LOG_DIR}"
fi

SOIL_MOISTURE_DIR=~/dataset/SOIL_MOISTURE

if [ ! -d "${SOIL_MOISTURE_DIR}" ]; then
    mkdir -p "${SOIL_MOISTURE_DIR}"
fi

# Main script
{
    URL="https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/"
    URL_DIRS=$(curl -S "${URL}" \
        | grep "\[DIR\]" \
        | grep -v "doc" \
        | grep -oP '(?<=href=")[^"]*')


    for URLS in ${URL_DIRS}; do
        GES_URL="${URL}${URLS}"

        GES_PATTERN="FLDAS.*\.nc"

        URL_DIRS=$(curl -s "${GES_URL}" \
            | grep -oP "${GES_PATTERN}" \
            | pup \
            | grep -v "href" \
            | grep -oP "${GES_PATTERN}")
        UNIQUE_URL_DIRS=$(echo "${URL_DIRS}" | sort -u)

        for URLS in ${UNIQUE_URL_DIRS}; do
            echo "Downloading ${GES_URL}${URLS}"
            wget \
                --load-cookies ./.urs_cookies \
                --keep-session-cookies \
                --user="${MY_AUTH0_USER}" \
                --content-disposition --content-disposition –r -c -nH -nd -np -A ".nc4" \
                -P "${SOIL_MOISTURE_DIR}" "${GES_URL}${URLS}"
        done
    done
    # Rename the files with .tmp extension
    find "${SOIL_MOISTURE_DIR}" -type f -name "*.tmp" | while read FILE; do
        NEW_FILE="$FILE"
        while [[ "$NEW_FILE" == *.tmp ]]; do
            NEW_FILE="${NEW_FILE%.tmp}"
        done
        mv "$FILE" "$NEW_FILE"
        echo "Renamed $FILE to $NEW_FILE"
    done

    wait
    echo "All downloads completed."
} > "$LOG_FILE" 2>&1 &

# Print PID of the background process
echo "Background process started with PID $!"
echo "You can monitor the progress with: tail -f $LOG_FILE"

# Start tailing the log file
tail -f "$LOG_FILE"
