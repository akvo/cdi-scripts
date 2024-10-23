#!/bin/bash

# Define log file
LOG_FILE="/tmp/download-lst.log"

# Main script
{
    GES_URL="https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/LST/"
    GES_PATTERN=".zip"

    URL_DIRS=$(curl -s "${GES_URL}" \
        | grep "${GES_PATTERN}" \
        | pup \
        | grep -v "href" \
        | grep "${GES_PATTERN}")

    for URLS in ${URL_DIRS}; do
        echo "Downloading ${GES_URL}${URLS}"
        wget -q -O temp_lst.zip "${GES_URL}${URLS}"
        unzip -d "../source/input_data/MOD21C3_LST" temp_lst.zip
        rm temp_lst.zip
    done

    wait
    echo "All downloads completed."
} > "$LOG_FILE" 2>&1 &

# Print PID of the background process
echo "Background process started with PID $!"
echo "You can monitor the progress with: tail -f $LOG_FILE"

# Start tailing the log file
tail -f "$LOG_FILE"
