#!/bin/bash

LOG_DIR=~/log/

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

function download_ges_files() {
    URL=$1
    GES_PATTERN=$2
    NAME=$3

    URL_DIRS=$(curl -S "${URL}" \
        | grep "\[DIR\]" \
        | grep -v "doc" \
        | grep -oP '(?<=href=")[^"]*')

    index=1  # Initialize the index
    count=0  # Initialize the count
    for URLS in ${URL_DIRS}; do
        GES_URL="${URL}${URLS}"
        echo "Downloading... ${GES_URL}"
        download_file "${GES_URL}" "${GES_PATTERN}" "${NAME}_${index}"

        index=$((index + 1))  # Increment the index
        count=$((count + 1))  # Increment the count

        if [ $count -eq 10 ]; then
            echo "Waiting for 5 minutes before starting the next batch..."
            sleep 300  # Delay for 5 minutes
            count=0  # Reset the count
        fi
    done
}

# main script
CHIRPS_URL="https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_monthly/tifs/"
LST_URL="https://e4ftl01.cr.usgs.gov/MOLT/MOD21C3.061/"
NDVI_URL="https://e4ftl01.cr.usgs.gov/MOLT/MOD13C2.061/"
SM_URL="https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/"

download_file "${CHIRPS_URL}" ".tif.gz" "CHIRPS" &
download_ges_files "${LST_URL}" ".hdf" "LST" &
download_ges_files "${NDVI_URL}" ".hdf" "NDVI" &
download_ges_files "${SM_URL}" "FLDAS.*\.nc" "SOIL_MOISTURE" &
