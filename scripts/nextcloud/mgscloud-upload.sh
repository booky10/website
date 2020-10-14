#!/bin/bash

FOLDER="${1}"

if [ "${FOLDER}" = '' ]; then
  echo 'Please use arguments: <folder> [file]'
  exit
fi

URL='https://mgscloud.net/'
WEBDAV='public.php/webdav/'

REMOTE=$(/usr/bin/basename panel.tar.gz)
FILE="${2:-panel.tar.gz}"


echo "Uploading ${FILE}... (Folder: ${FOLDER})"
curl -T "${FILE}" -u "${FOLDER}":'' -H 'X-Requested-With: XMLHttpRequest' -H 'X-Method-Override: REPLACE' "${URL}${WEBDAV}${REMOTE}"
