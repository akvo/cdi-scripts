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

# main script
download_file "https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_monthly/tifs/" ".tif.gz" "CHIRPS" &
download_file "https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/NDVI/" ".zip" "NDVI" &
download_file "https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/LST/" ".zip" "LST" &

{
    URL="https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/"
    URL_DIRS=$(curl -S "${URL}" \
        | grep "\[DIR\]" \
        | grep -v "doc" \
        | grep -oP '(?<=href=")[^"]*')

    for URLS in ${URL_DIRS}; do
        GES_URL="${URL}${URLS}"
        GES_PATTERN="FLDAS.*\.nc"
        download_file "${GES_URL}" "${GES_PATTERN}" "SOIL_MOISTURE"
    done
} &
