#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FILE="$1"

JSON="$(python $SCRIPT_DIR/xml2json.py "$FILE")"
JSON="$(printf "$JSON" | python $SCRIPT_DIR/clean-json.py)"

PUBLICATION_DATE="$(printf "$JSON" | python $SCRIPT_DIR/get-field-from-json.py "publicationDate")"

LINE="$(printf "$JSON" | python $SCRIPT_DIR/json2line.py)"
LINE="publication,$LINE value=\"$PUBLICATION_DATE\" $(date -d "$PUBLICATION_DATE" +%s)"

printf "$LINE" | $SCRIPT_DIR/insert-line.sh

# printf "Data from $FILE uploaded as:\n$LINE\n"

# echo "$LINE" > $SCRIPT_DIR/line.out