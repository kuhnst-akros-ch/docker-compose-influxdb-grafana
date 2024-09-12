#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for file in "$SCRIPT_DIR"/ids/*.xml; do
  echo "parsing file '$file'"
  python "$SCRIPT_DIR/split_ids_xml.py" "$file" "$SCRIPT_DIR/split-ids"
done