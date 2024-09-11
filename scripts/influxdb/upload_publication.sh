#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FILE="$1"

JSON="$(python $SCRIPT_DIR/xml2json.py "$FILE")"
JSON="$(printf "$JSON" | python $SCRIPT_DIR/clean-json.py)"
PUBLICATION_DATE="$(printf "$JSON" | python $SCRIPT_DIR/get-field-from-json.py "publicationDate")"
PUBLICATION_DATE="$(date -d "$PUBLICATION_DATE" +%s)"
LINE="$(printf "$JSON" | python $SCRIPT_DIR/json2line.py)"
LINE="$LINE $PUBLICATION_DATE"

printf "$LINE" | $SCRIPT_DIR/upload_publication.sh