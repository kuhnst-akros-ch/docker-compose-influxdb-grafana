#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="

ORG_ID="$($SCRIPT_DIR/get-orgID.sh)"

# echo "org id=$ORG_ID'"

# Import dashboard using InfluxDB API
# use sed to replace the orgId on the fly and pass result to curl
sed 's#"orgID": ""#"orgID": "'"$ORG_ID"'"#' "$SCRIPT_DIR/my_dashboard.json" | \
curl --request POST "$INFLUX_HOST/api/v2/dashboards?orgID=$ORGID" \
  --header "Authorization: Token $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary @-
