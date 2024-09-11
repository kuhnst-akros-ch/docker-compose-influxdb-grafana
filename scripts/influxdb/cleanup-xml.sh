#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo 'clean up: delete all xml containing error'
grep -Flr --include='*.xml' 'ch.admin.seco.eshab.application.publication.exception.PublicationNotFoundException' "$SCRIPT_DIR"/../current_portal/publications \
  | xargs rm -f

echo 'clean up: delete empty xml files'
find "$SCRIPT_DIR"/../current_portal/publications -type f -name '*.xml' -size 0 | xargs rm -f

echo 'clean up: delete xml files not starting with "<?xml"'
find "$SCRIPT_DIR"/../current_portal/publications -type f -name "*.xml" -exec grep -L "^<?xml" {} + | xargs rm -f

echo 'clean up: delete large (>30 KB) xml files'
find "$SCRIPT_DIR"/../current_portal/publications -type f -name "*.xml" -size +30k | xargs rm -f