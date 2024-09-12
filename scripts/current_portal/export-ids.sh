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
mkdir -p "$SCRIPT_DIR/ids"

# Start date is today
# START_DATE=$(date +%Y-%m-%d)
START_DATE='2024-09-01'

# Function to extract ids
extract_ids_from_xml() {
    local date=$1
	# Read input from stdin
    local xml_input=$(cat)
	# Extract the <total> value from the piped input
    total=$(echo "$xml_input" | xmllint --xpath 'string(//total)' -)

	# Check if <total> is 0
    if [ "$total" -ne "0" ]; then
        # Extract the <id> values only if <total> is greater than 0
        echo "$xml_input" | xmllint --xpath '//id/text()' - > "$SCRIPT_DIR/ids/$date.ids"
    fi
}

# Function to make the curl request
fetch_data() {
    local date=$1
	local url="https://shab.ch/api/v1/publications/xml?includeContent=false&includePDF=false&pageRequest.page=0&pageRequest.size=3000&publicationDate.end=$date&publicationDate.start=$date&publicationStates=PUBLISHED&publicationStates=CANCELLED"
	# echo "url=$url"
	curl \
		--silent \
		\ #--header "X-Auth-Token: $TOKEN" \
		\ #-o ids/$date.csv \
		-X GET \
		"$url" \
	| tee "$SCRIPT_DIR/ids/$date.xml" \
	| extract_ids_from_xml $date -
}

# Loop to decrement the date until no data is found
for ((i=0; i<100; i++)); do
    fetch_data "$(date -I -d "$START_DATE - $i day")"
done
