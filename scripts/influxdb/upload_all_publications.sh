#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# clean up: delete all xml containing error
grep -Flr --include='*.xml' 'ch.admin.seco.eshab.application.publication.exception.PublicationNotFoundException' "$SCRIPT_DIR"/../current_portal/publications" \
  | xargs rm -f

find "$SCRIPT_DIR"/../current_portal/publications" -name '*.xml' -size 0 | xargs rm -f

for file in "$SCRIPT_DIR"/../current_portal/publications/*.xml; do
  printf "Uploading $file\n"
  "$SCRIPT_DIR/upload_publication.sh" "$file"
done