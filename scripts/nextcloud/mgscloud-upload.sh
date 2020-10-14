#!/bin/bash

FOLDER="${1}"
FILE="${2:-panel.tar.gz}"
REMOTE="$(/usr/bin/basename ${3:-panel.tar.gz})"

URL='https://mgscloud.net/'
WEBDAV='public.php/webdav/'

if [ "${FOLDER}" = '' ]; then
  echo 'Please use arguments: <folder> [file]'
  exit
fi


echo "Uploading ${FILE}... (Folder: ${FOLDER})"
curl -T "${FILE}" -u "${FOLDER}":'' -H 'X-Requested-With: XMLHttpRequest' -H 'X-Method-Override: REPLEASE' "${URL}${WEBDAV}${REMOTE}"
