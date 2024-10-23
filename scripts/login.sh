#!/usr/bin/bash

EMAIL="$1"

if [ -z "${EMAIL}" ]; then
    echo "EMAIL is required"
    exit 1
fi

wget --load-cookies ./.urs_cookies \
    --save-cookies ./.urs_cookies \
    --keep-session-cookies \
    --user="${EMAIL}" \
    --ask-password \
    --content-disposition \
    https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2_MONTHLY/M2TMNXSLV.5.12.4/1981/MERRA2_100.tavgM_2d_slv_Nx.198101.nc4
