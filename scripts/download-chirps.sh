#!/bin/bash

# Define log file
CURR_DATE=$(date +%Y%m%d)
CURR_TIME=$(date +%H%M%S)
LOG_DIR=~/log/download-log/chirps
LOG_FILE=${LOG_DIR}/chirps-${CURR_DATE}-${CURR_TIME}.log

if [ ! -d "${LOG_DIR}" ]; then
    mkdir -p "${LOG_DIR}"
fi

CHIRPS_DIR=~/dataset/CHIRPS

if [ ! -d "${CHIRPS_DIR}" ]; then
    mkdir -p "${CHIRPS_DIR}"
fi

# Main script
{
    GES_URL="https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_monthly/tifs/"
    GES_PATTERN=".tif.gz"

    URL_DIRS=$(curl -s "${GES_URL}" \
        | grep "${GES_PATTERN}" \
        | pup \
        | grep -v "href" \
        | grep "${GES_PATTERN}")

    for URLS in ${URL_DIRS}; do
        wget -P "${CHIRPS_DIR}" "${GES_URL}${URLS}"
    done

    wait
    echo "All downloads completed."
} > "$LOG_FILE" 2>&1 &

# Print PID of the background process
echo "Background process started with PID $!"
echo "You can monitor the progress with: tail -f $LOG_FILE"

# Start tailing the log file
tail -f "$LOG_FILE"
