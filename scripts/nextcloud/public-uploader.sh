#!/bin/bash

URL="${1}"
FOLDER="${2}"
FILE="${3}"
WEBDAV='public.php/webdav/'
REMOTE="$(/usr/bin/basename "${4:-${FILE}}")"

if [ "${FOLDER}" = '' ]; then
  echo 'Please use arguments: <url> <folder> <file> [remote]'
  exit 255
fi

if [ "${URL}" = '' ]; then
  echo 'Please use arguments: <url> <folder> <file> [remote]'
  exit 255
fi

if [ "${FILE}" = '' ]; then
  echo 'Please use arguments: <url> <folder> <file> [remote]'
  exit 255
fi

echo "Uploading ${FILE}..."
curl -T "${FILE}" -u "${FOLDER}":'' -H 'X-Requested-With: XMLHttpRequest' -H 'X-Method-Override: REPLACE' "${URL}${WEBDAV}${REMOTE}" || exit 255
exit 0
