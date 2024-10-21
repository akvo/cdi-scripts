#!/usr/bin/bash

GES_URL="$1"
GES_PATTERN="$2"
DOWNLOAD_LIST="./download.log"

curl -s "${GES_URL}" \
	| grep "${GES_PATTERN}" \
	| pup \
	| grep -v "href" \
	| grep "${GES_PATTERN}" \
	| sed "s/\ //g" > ./download.log

echo "FILES TOBE DOWNLOADED: $(wc -l ./download.log)"

# Read the file line by line
while IFS= read -r GES_FILE; do
    echo "Processing line: ${LINE}"
    wget --load-cookies ./.urs_cookies \
			--keep-session-cookies --user="${MY_AUTH0_USER}" \
			--content-disposition --content-disposition –r -c -nH -nd -np -A ".nc4" \
			"${GES_URL}/${GES_FILE}"
done < "${DOWNLOAD_LIST}"

