#!/usr/bin/env bash

set -e
#
# Check if the TOKEN parameter is provided
if [ -z "$1" ]; then
	echo "Error: TOKEN is required. Get it from the browser header (X-Auth-Token)."
  echo "Usage: $0 <TOKEN>"
  exit 1
fi

# Assign the passed TOKEN to a variable
TOKEN=$1

curl --silent \
	--header "X-Auth-Token: $TOKEN" \
	-X GET \
	'https://shab.ch/api/v1/publications/csv?includeContent=true&includePDF=false&pageRequest.page=0&pageRequest.size=3000&publicationDate.end=2024-09-10&publicationDate.start=2024-09-10&publicationStates=PUBLISHED&publicationStates=CANCELLED' \
	tail -n +2 | \
	sed -E 's#^"([^"]+)".*#\1#'
