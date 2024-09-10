#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="

ORGID="$($SCRIPT_DIR/get-orgID.sh)"

# echo "org id=$ORGID'"
# echo "$SCRIPT_DIR/my_dashboard.json"

# $SCRIPT_DIR/my_dashboard.json

# Import dashboard using InfluxDB API
# curl -X POST http://localhost:8086/api/v2/dashboards \
# curl -X POST "$INFLUX_HOST/api/v2/dashboards?orgID=851b746f2f93a4b5" \
# curl -X POST "$INFLUX_HOST/api/v2/dashboards?org=$ORG&bucket=$BUCKET" \
# curl -X POST "$INFLUX_HOST/api/v2/dashboards?orgID=851b746f2f93a4b5" \
# curl --request PATCH "$INFLUX_HOST/api/v2/dashboards/0da331a041699000" \
# curl --request POST "$INFLUX_HOST/api/v2/dashboards" \
#   --header "Authorization: Token $TOKEN" \
#   -H "Content-Type: application/json" \
#   --data-binary "@$SCRIPT_DIR/my_dashboard.json"

curl --request POST "$INFLUX_HOST/api/v2/dashboards?orgID=$ORGID" \
  --header "Authorization: Token $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary "@$SCRIPT_DIR/my_dashboard.json"
