#!/usr/bin/env bash

set -e

# Check if the TOKEN parameter is provided
if [ -z "$1" ]; then
    echo "Error: TOKEN is required. Get it from the browser header (X-Auth-Token)."
    echo "Usage: $0 <TOKEN>"
    exit 1
fi

# Assign the passed TOKEN to a variable
TOKEN=$1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p "$SCRIPT_DIR/publications"

# Start date is today
START_DATE=$(date +%Y-%m-%d)
MAX_DOWNLOAD=10000

# Function to make the curl request
fetch_data() {
    local id=$1
	# https://shab.ch/api/v1/publications/e8a8489c-65d7-455b-b75b-c5387b7374b6/xml
	local url="https://shab.ch/api/v1/publications/$id/xml"
	printf "url is $url \n\n" 1>&2
	curl \
		--silent \
		--header "X-Auth-Token: $TOKEN" \
		\ # -o "$SCRIPT_DIR/publications/$id.xml" \
		-X GET \
		"$url" \
	> "$SCRIPT_DIR/publications/$id.xml"
}

dos2unix $SCRIPT_DIR/ids/*.ids

counter=0
for file in $SCRIPT_DIR/ids/*.ids; do
	printf "file is $file \n"
	while IFS= read -r id; do
		if [ ! -f "$SCRIPT_DIR/publications/$id.xml" ]; then
			echo "File not present: $SCRIPT_DIR/publications/$id.xml"
		else
			echo "File already present: $SCRIPT_DIR/publications/$id.xml"
		fi
		
		if [ ! -f "$SCRIPT_DIR/publications/$id.xml" ]; then
			printf "$file: Processing id: $id \n\n"
			fetch_data $id

			counter=$((counter + 1))
			if [ "$counter" -ge "$MAX_DOWNLOAD" ]; then
				echo "Reached $MAX_DOWNLOAD iterations, exiting..."
				exit
			fi
		else
			echo "File already present: $SCRIPT_DIR/publications/$id.xml"
		fi
	done < $file
done
