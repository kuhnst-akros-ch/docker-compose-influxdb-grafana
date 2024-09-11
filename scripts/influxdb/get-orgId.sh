#!/usr/bin/env bash

set -e

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="

curl -s --request GET "$INFLUX_HOST/api/v2/orgs" \
  --header "Authorization: Token $TOKEN" \
  | grep '"id":' | sed -E 's#^.*"id": "(.*)".*$#\1#' | tr -d '\n'
