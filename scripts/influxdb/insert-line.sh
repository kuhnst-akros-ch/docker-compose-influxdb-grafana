#!/usr/bin/env bash

set -e

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="
PRECISION="s"

# Function to upload data to InfluxDB
upload_to_influx() {
  local data=$1
  curl -i -XPOST "$INFLUX_HOST/api/v2/write?org=$ORG&bucket=$BUCKET&precision=$PRECISION" \
    --header "Authorization: Token $TOKEN" \
    --data-raw "$data"
}

# Check if input is provided via file or pipe
if [ $# -gt 0 ]; then
  # Input from file
  if [ -f "$1" ]; then
    data=$(cat "$1")  # Read the entire file content
  else
    echo "File not found: $1"
    exit 1
  fi
elif [ ! -t 0 ]; then
  # Input from pipe
  data=$(cat)  # Read the entire pipe content
else
  # No input provided
  echo "No input file or pipe provided."
  exit 1
fi

echo "Uploading data..."
upload_to_influx "$data"