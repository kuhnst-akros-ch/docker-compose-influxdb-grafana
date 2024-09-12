#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for file in "$SCRIPT_DIR"/../current_portal/publications/ZH/*.xml; do
  echo "Uploading $file"
  "$SCRIPT_DIR/upload_publication.sh" "$file"
done