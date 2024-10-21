URL="https://hydro1.gesdisc.eosdis.nasa.gov/data/FLDAS/FLDAS_NOAH01_C_GL_M.001/"
URL_DIRS=$(curl -S "${URL}" \
	| grep "\[DIR\]" \
	| grep -v "doc" \
	| grep -oP '(?<=href=")[^"]*')


for URLS in ${URL_DIRS}; do
    echo "FOLDER: ${URL}${URLS}"
done
