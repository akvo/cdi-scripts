#!/usr/bin/bash

GES_URL="$1"
GES_PATTERN="$2"
DOWNLOAD_LIST="$3"
TARGET_DIR="$4"
MY_AUTH0_USER="$5"

curl -s "${GES_URL}" \
	| grep "${GES_PATTERN}" \
	| pup \
	| grep -v "href" \
	| grep "${GES_PATTERN}" \
	| sed "s/\ //g" > "${DOWNLOAD_LIST}"

echo "FILES TOBE DOWNLOADED: $(wc -l "${DOWNLOAD_LIST}")"

# Read the file line by line
while IFS= read -r GES_FILE; do
    echo "Processing line: ${LINE}"
    wget --load-cookies ./.urs_cookies \
			--keep-session-cookies --user="${MY_AUTH0_USER}" \
			--content-disposition --content-disposition –r -c -nH -nd -np -A ".nc4" \
			-P "${TARGET_DIR}" "${GES_URL}/${GES_FILE}"
done < "${DOWNLOAD_LIST}"

