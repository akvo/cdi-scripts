#!/bin/bash

LOG_DIR=~/log/download-log

if [ ! -d "${LOG_DIR}" ]; then
    mkdir -p "${LOG_DIR}"
fi

# Define log file
CURR_DATE=$(date +%Y%m%d)
CURR_TIME=$(date +%H%M%S)

CHIRPS_LOG_FILE=${LOG_DIR}/chirps-${CURR_DATE}-${CURR_TIME}.log
SOIL_MOISTURE_LOG_FILE=${LOG_DIR}/soil-moisture-${CURR_DATE}-${CURR_TIME}.log
NDVI_LOG_FILE=${LOG_DIR}/ndvi-${CURR_DATE}-${CURR_TIME}.log
LST_LOG_FILE=${LOG_DIR}/lst-${CURR_DATE}-${CURR_TIME}.log

# Define directories
CHIRPS_DIR=~/dataset/CHIRPS
if [ ! -d "${CHIRPS_DIR}" ]; then
    mkdir -p "${CHIRPS_DIR}"
fi

SOIL_MOISTURE_DIR=~/dataset/SOIL_MOISTURE
if [ ! -d "${SOIL_MOISTURE_DIR}" ]; then
    mkdir -p "${SOIL_MOISTURE_DIR}"
fi

NDVI_DIR=~/dataset/NDVI
if [ ! -d "${NDVI_DIR}" ]; then
    mkdir -p "${NDVI_DIR}"
fi

LST_DIR=~/dataset/LST
if [ ! -d "${LST_DIR}" ]; then
    mkdir -p "${LST_DIR}"
fi

EMAIL="$1"

if [ -z "${EMAIL}" ]; then
    echo "Usage: ./download-all.sh <email>"
    exit 1
fi

# main script
{
    ./login.sh "${EMAIL}"

    ./download.sh "https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_monthly/tifs/" ".tif.gz" "${CHIRPS_LOG_FILE}" "${CHIRPS_DIR}" "${EMAIL}"

    ./download.sh "https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/NDVI/" ".zip" "${NDVI_LOG_FILE}" "${NDVI_DIR}" "${EMAIL}"

    ./download.sh "https://droughtcenter.unl.edu/Outgoing/CDI/data/CDI-Input/LST/" ".zip" "${LST_LOG_FILE}" "${LST_DIR}" "${EMAIL}"

    URL="https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/"
    URL_DIRS=$(curl -S "${URL}" \
        | grep "\[DIR\]" \
        | grep -v "doc" \
        | grep -oP '(?<=href=")[^"]*')


    for URLS in ${URL_DIRS}; do
        GES_URL="${URL}${URLS}"

        GES_PATTERN="FLDAS.*\.nc"
        ./download.sh "${GES_URL}" "${GES_PATTERN}" "${SOIL_MOISTURE_LOG_FILE}" "${SOIL_MOISTURE_DIR}" "${EMAIL}"
    done

    wait
    echo "All downloads completed."
} &

echo "Background process started with PID $!"
