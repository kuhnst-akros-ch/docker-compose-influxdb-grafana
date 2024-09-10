#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="
PRECISION="s"

# echo "$SCRIPT_DIR/my_dashboard.json"

# $SCRIPT_DIR/my_dashboard.json

# Import dashboard using InfluxDB API
# curl -X POST http://localhost:8086/api/v2/dashboards \
# curl -X POST "$INFLUX_HOST/api/v2/dashboards?orgID=851b746f2f93a4b5" \
# curl -X POST "$INFLUX_HOST/api/v2/dashboards?org=$ORG&bucket=$BUCKET" \
curl -X POST "$INFLUX_HOST/api/v2/dashboards?orgID=851b746f2f93a4b5" \
  --header "Authorization: Token $TOKEN" \
  -H "Content-Type: application/json" \
  --data-binary "@$SCRIPT_DIR/my_dashboard.json"

