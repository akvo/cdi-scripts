#!/bin/bash

# Define log file
CURR_DATE=$(date +%Y%m%d)
CURR_TIME=$(date +%H%M%S)
LOG_FILE=~/log/download-log/ndvi-${CURR_DATE}-${CURR_TIME}.log

if [ ! -d "~/log/download-log" ]; then
    mkdir -p ~/log/download-log
fi

NDVI_DIR=~/dataset/NDVI

if [ ! -d "${NDVI_DIR}" ]; then
    mkdir -p "${NDVI_DIR}"
fi

# Main script
{
    GES_URL="https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/NDVI/"
    GES_PATTERN=".zip"

    URL_DIRS=$(curl -s "${GES_URL}" \
        | grep "${GES_PATTERN}" \
        | pup \
        | grep -v "href" \
        | grep "${GES_PATTERN}")

    for URLS in ${URL_DIRS}; do
        # Download the file first using wget and store it locally
        echo "Downloading ${GES_URL}${URLS}"
        wget -q -O temp_ndvi.zip "${GES_URL}${URLS}"

        # After download is complete, unzip the file to the target directory
        unzip -d "${NDVI_DIR}" temp_ndvi.zip

        # Remove the temp file after unzipping
        rm temp_ndvi.zip
    done

    wait
    echo "All downloads completed."
} > "$LOG_FILE" 2>&1 &

# Print PID of the background process
echo "Background process started with PID $!"
echo "You can monitor the progress with: tail -f $LOG_FILE"

# Start tailing the log file
tail -f "$LOG_FILE"
