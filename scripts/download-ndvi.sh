#!/bin/bash

# Define log file
LOG_FILE="/tmp/download-ndvi.log"

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
        unzip -d "../source/input_data/MOD13C2_NDVI" temp_ndvi.zip

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
